; ===========================================================================
; EVALUATOR — intrinsic, GRAPH-DERIVED eq-17 scoring ($ws-parameterized).
; ---------------------------------------------------------------------------
; The eq-17 minting score (MSC §4.4) computed WITHOUT gold answer content: the target
; Y*_q is derived from the molecule graph — the explanatory edges of the allowed class
; on causal paths into the question-focus (direct edges into the focus for why/why-not/
; what-for; the transitive CauseOf closure for how). The terms:
;   Match       = covered / idealsize     (recall vs the graph-derived ideal)
;   Unsupported = (cites whose edge is absent from the graph) / anssize   (fabrication)
;   Redundant   = (grounded but off-ideal cites) / anssize                (superfluous)
;   M = a*Match - l*Unsupported - n*Redundant   (a/l/n = clamp-coeff match/unsupportedness/redundancy)
;   mint = floor(6*M) when M>0, else 0.
; Abstain is graph-derived: a typed, unanswered question whose ideal is EMPTY (no
; groundable explanatory edge into the focus over the allowed classes) earns the reward.
; IR (graph edges / edge-cluster / question-focus / intent-allows / clamp-coeff) reads from
; &self; the answer products (q-intent / cites / candidate-answer / event) from the worker $ws.
; ===========================================================================

; --- clamp coefficients (active clamp CL_antecedent) ---
; the eq-17 coefficient for $term under the active clamp
(= (cc $term) (match &self (clamp-coeff CL_antecedent $term $w) $w))

; --- accessors (focus from IR; intent from the q-intent product in $ws) ---
; the event node a question asks about
(= (focus-of $q) (match &self (question-focus $q $f) $f))
; the question's derived intent (the q-intent product the soma wrote)
(= (intent-of $ws $q) (match $ws (q-intent $q $i) $i))

; --- graph predicates (IR in &self) ---
; is edge ($rel $src $dst) present in the molecule graph?
(= (edge-present? $rel $src $dst) (case (collapse (match &self ($rel $src $dst) yes)) ((() False) ($x True))))
; is relation $rel in answer-class $cls?
(= (rel-cls? $rel $cls) (case (collapse (match &self (edge-cluster $rel $cls) yes)) ((() False) ($x True))))

; ideal-direct: # edges of class $cls directly into the focus
(= (ideal-direct $q $cls) (let $foc (focus-of $q) (foldall + (match &self ($rel $src $foc) (if (rel-cls? $rel $cls) 1 0)) 0)))

; --- ideal-trans (mechanism): # CauseOf edges on the backward causal closure into the focus ---
; the direct CauseOf predecessors of node $n
(= (preds-causal $n) (collapse (match &self (CauseOf $s $n) $s)))

; the backward CauseOf closure: every node that causally reaches the frontier
(= (bwd-reach $frontier $seen)
   (case $frontier
         ((() $seen)
          ($ne (let* (($h (car-atom $frontier))
                      ($rest (cdr-atom $frontier)))
                 (if (in-list? $h $seen)
                     (bwd-reach $rest $seen)
                     (bwd-reach (concat-lists (preds-causal $h) $rest) (cons-atom $h $seen))))))))

; the causal ancestors of a question's focus
(= (reach-of $q) (bwd-reach (cons-atom (focus-of $q) ()) ()))
; # CauseOf edges landing inside that closure (the mechanism-chain ideal size)
(= (ideal-trans $q) (let $r (reach-of $q) (foldall + (match &self (CauseOf $s $d) (if (in-list? $d $r) 1 0)) 0)))

; idealsize: intent-aware (how -> transitive closure; else direct edges into the focus)
(= (idealsize $ws $q $cls) (if (== (intent-of $ws $q) explain-mechanism) (ideal-trans $q) (ideal-direct $q $cls)))

; --- per-cite classification (cites in $ws; graph checks in &self) ---
; is a cite on-ideal? (a mechanism CauseOf reaching the closure, else a class edge into the focus)
(= (cite-ideal? $ws $q $cls $rel $src $foc)
   (if (== (intent-of $ws $q) explain-mechanism)
       (if (== $rel CauseOf) (in-list? $foc (reach-of $q)) False)
       (if (rel-cls? $rel $cls) (== $foc (focus-of $q)) False)))

; # cites the answer carries
(= (anssize $ws $q $cls) (foldall + (match $ws (cites $q $cls $rel $src $foc) 1) 0))
; # cites whose edge is absent from the graph (fabricated)
(= (unsupported $ws $q $cls) (foldall + (match $ws (cites $q $cls $rel $src $foc) (if (edge-present? $rel $src $foc) 0 1)) 0))
; # cites that are grounded AND on-ideal (the recall numerator)
(= (covered $ws $q $cls) (foldall + (match $ws (cites $q $cls $rel $src $foc) (if (edge-present? $rel $src $foc) (if (cite-ideal? $ws $q $cls $rel $src $foc) 1 0) 0)) 0))
; # cites that are grounded but off-ideal (superfluous)
(= (redundant $ws $q $cls) (- (- (anssize $ws $q $cls) (covered $ws $q $cls)) (unsupported $ws $q $cls)))

; --- eq-17 terms + minting score ---
; Match = covered / idealsize (0 when the ideal is empty)
(= (match-score $ws $q $cls) (let $is (idealsize $ws $q $cls) (if (== $is 0) 0 (/ (covered $ws $q $cls) $is))))
; Unsupported / Redundant, each normalised by answer size
(= (unsup-score $ws $q $cls) (let $a (anssize $ws $q $cls) (if (== $a 0) 0 (/ (unsupported $ws $q $cls) $a))))
(= (redund-score $ws $q $cls) (let $a (anssize $ws $q $cls) (if (== $a 0) 0 (/ (redundant $ws $q $cls) $a))))
; the weighted eq-17 score M = a*Match - l*Unsupported - n*Redundant
(= (m-score $ws $q $cls) (- (- (* (cc match) (match-score $ws $q $cls)) (* (cc unsupportedness) (unsup-score $ws $q $cls))) (* (cc redundancy) (redund-score $ws $q $cls))))

; the mint for a cited answer under clamp $cc: floor(6*M) when the class matches and M>0;
; an abstain answer mints a flat 4; otherwise 0
(= (would-mint $ws $q $cls $cc)
   (if (== $cls $cc)
       (let $m (m-score $ws $q $cls) (if (> $m 0) (floor-math (* 6 $m)) 0))
       (if (== $cls abstain) 4 0)))

; --- abstain (graph-derived): typed + unanswered + EMPTY ideal over the allowed classes ---
; did the soma produce any answer for $q? / did it type $q (write a q-intent)?
(= (answered? $ws $q) (case (collapse (match $ws (candidate-answer $q $a) yes)) ((() False) ($x True))))
(= (typed? $ws $q) (case (collapse (match $ws (q-intent $q $i) yes)) ((() False) ($x True))))
; the total ideal size across every class the intent allows (0 => nothing to answer => abstain)
(= (total-ideal $ws $q) (let $i (intent-of $ws $q) (foldall + (match &self (intent-allows $i $cls) (idealsize $ws $q $cls)) 0)))
; abstain income: 4 for each typed, unanswered question whose ideal is empty
(= (abstain-income $ws) (foldall + (match &self (qa-question $t $q) (if (typed? $ws $q) (if (answered? $ws $q) 0 (if (== (total-ideal $ws $q) 0) 4 0)) 0)) 0))

; total gm minted over the answer set under clamp $cc, plus abstain income
(= (gm-income $ws $cc) (+ (foldall + (match $ws (candidate-answer $q (ans $q $cls)) (would-mint $ws $q $cls $cc)) 0) (abstain-income $ws)))
; gm spent = one per firing / # candidate answers produced
(= (gm-spend $ws) (foldall + (match $ws (event $s $r $k) 1) 0))
(= (count-answers $ws) (foldall + (match $ws (candidate-answer $q $a) 1) 0))
