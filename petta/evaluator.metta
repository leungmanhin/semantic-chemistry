; ===========================================================================
; EVALUATOR — intrinsic, GRAPH-DERIVED eq-17 scoring ($ws-parameterized).
; ---------------------------------------------------------------------------
; The eq-17 minting score (MSC §4.4), fully data-parameterized: the evaluator carries
; NO domain symbols — every domain semantic reads from facts:
;   question-focus (the asked-about node) · intent-allows (classes an intent admits) ·
;   edge-cluster (relation -> answer-class) · chain-relation (the links mechanism
;   chains are made of) · intent-scope (chain-scoped intents; default = direct) ·
;   clamp-class / clamp-coeff / clamp-mint-scale / clamp-abstain-reward (the clamp).
; Scoring runs under an EXPLICIT clamp $cl (threaded, so the same products can be
; evaluated under different clamps — the clamp-switch). The minting score:
;   Match = covered / idealsize   (recall vs the graph-derived ideal)
;   M     = a * Match             (a = clamp-coeff match)
;   mint  = floor(mint-scale * M) when M>0 and the answer-class is the clamp's rewarded class.
; Only Match is scored for now. eq-17's other terms need machinery the toy lacks: its
; (Y,L) terms — Unsupportedness / Redundancy / CausalClarity / Compression — are
; provenance-aware (they inspect the derivation log L), awaiting a real proof store; each
; is reintroduced per-factor once its doc-faithful meaning is settled.
; Abstain is graph-derived: a typed, unanswered question whose ideal is EMPTY (no
; groundable explanatory edge into the focus over the allowed classes) earns the clamp's
; abstain reward. IR + domain mappings read from &self; the answer products
; (q-intent / cites / candidate-answer / event) from the worker $ws.
; ===========================================================================

; --- clamp accessors (all clamp semantics are facts, keyed by the threaded $cl) ---

; the eq-17 coefficient for $term under clamp $cl
(= (coeff $cl $term)
   (match &self (clamp-coeff $cl $term $w) $w))

; the answer-class clamp $cl rewards
(= (clamp-class-of $cl)
   (match &self (clamp-class $cl $c) $c))

; the clamp's mint scale (tokens per unit of M)
(= (mint-scale-of $cl)
   (match &self (clamp-mint-scale $cl $s) $s))

; the clamp's flat reward for a correct abstention
(= (abstain-reward-of $cl)
   (match &self (clamp-abstain-reward $cl $r) $r))

; the token the clamp's eq-17 (skeleton-match) mint is denominated in
(= (mint-token-of $cl)
   (match &self (clamp-token $cl skeleton-match $tok) $tok))

; --- accessors (focus from IR; intent from the q-intent product in $ws) ---

; the event node a question asks about
(= (focus-of $q)
   (match &self (question-focus $q $f) $f))

; the question's derived intent (the q-intent product the soma wrote)
(= (intent-of $ws $q)
   (match $ws (q-intent $q $i) $i))

; --- graph predicates (IR in &self) ---

; is edge ($rel $src $dst) present in the molecule graph?
(= (edge-present? $rel $src $dst)
   (case (collapse (match &self ($rel $src $dst) yes)) ((() False) ($x True))))

; is relation $rel in answer-class $cls?
(= (rel-cls? $rel $cls)
   (case (collapse (match &self (edge-cluster $rel $cls) yes)) ((() False) ($x True))))

; ideal-direct: # edges of class $cls directly into the focus
(= (ideal-direct $q $cls)
   (let $foc (focus-of $q) (foldall + (match &self ($rel $src $foc) (if (rel-cls? $rel $cls) 1 0)) 0)))

; --- the chain ideal (chain-scoped intents): the backward closure over the declared chain-relation links into the focus ---

; is relation $rel a declared chain link?
(= (chain-rel? $rel)
   (case (collapse (match &self (chain-relation $rel) yes)) ((() False) ($x True))))

; the chain predecessors of node $n (sources of chain-relation edges into $n)
(= (preds-chain $n)
   (collapse (match &self (chain-relation $rel) (match &self ($rel $s $n) $s))))

; the backward chain closure: every node that chains into the frontier
(= (bwd-reach $frontier $seen)
   (case $frontier
         ((() $seen)
          ($ne (let* (($h (car-atom $frontier))
                      ($rest (cdr-atom $frontier)))
                 (if (in-list? $h $seen)
                     (bwd-reach $rest $seen)
                     (bwd-reach (concat-lists (preds-chain $h) $rest) (cons-atom $h $seen))))))))

; the chain ancestors of a question's focus
(= (reach-of $q)
   (bwd-reach (cons-atom (focus-of $q) ()) ()))

; # chain edges landing inside that closure (the mechanism-chain ideal size)
(= (ideal-chain $q)
   (let $r (reach-of $q)
        (foldall + (match &self (chain-relation $rel)
                          (foldall + (match &self ($rel $s $d) (if (in-list? $d $r) 1 0)) 0))
                 0)))

; is intent $i chain-scoped? (declared via an (intent-scope I chain) fact; default direct)
(= (chain-scoped? $i)
   (case (collapse (match &self (intent-scope $i chain) yes)) ((() False) ($x True))))

; idealsize: intent-aware (chain-scoped -> the chain closure; else direct edges into the focus)
(= (idealsize $ws $q $cls)
   (if (chain-scoped? (intent-of $ws $q))
       (ideal-chain $q)
       (ideal-direct $q $cls)))

; --- per-cite classification (cites in $ws; graph checks in &self) ---

; is a cite on-ideal? (chain-scoped: a chain edge reaching the closure; else a class edge
; into the focus)
(= (cite-ideal? $ws $q $cls $rel $src $foc)
   (if (chain-scoped? (intent-of $ws $q))
       (if (chain-rel? $rel)
           (in-list? $foc (reach-of $q))
           False)
       (if (rel-cls? $rel $cls)
           (== $foc (focus-of $q))
           False)))

; # cites that are grounded AND on-ideal (the recall numerator)
(= (covered $ws $q $cls)
   (foldall + (match $ws (cites $q $cls $rel $src $foc) (if (edge-present? $rel $src $foc) (if (cite-ideal? $ws $q $cls $rel $src $foc) 1 0) 0)) 0))

; --- the minting score ---

; Match = covered / idealsize (0 when the ideal is empty)
(= (match-score $ws $q $cls)
   (let $is (idealsize $ws $q $cls) (if (== $is 0) 0 (/ (covered $ws $q $cls) $is))))

; the minting score M = a * Match under clamp $cl (a = the clamp's match coefficient)
(= (m-score $ws $q $cls $cl)
   (* (coeff $cl match) (match-score $ws $q $cls)))

; the mint for a cited answer under clamp $cl: floor(mint-scale*M) when the answer-class
; is the clamp's rewarded class and M>0; an abstain answer earns the clamp's abstain reward
(= (would-mint $ws $q $cls $cl)
   (if (== $cls (clamp-class-of $cl))
       (let $m (m-score $ws $q $cls $cl)
            (if (> $m 0) (floor-math (* (mint-scale-of $cl) $m)) 0))
       (if (== $cls abstain) (abstain-reward-of $cl) 0)))

; --- abstain (graph-derived): typed + unanswered + EMPTY ideal over the allowed classes ---

; did the soma produce any answer for $q? / did it type $q (write a q-intent)?
(= (answered? $ws $q)
   (case (collapse (match $ws (candidate-answer $q $a) yes)) ((() False) ($x True))))

(= (typed? $ws $q)
   (case (collapse (match $ws (q-intent $q $i) yes)) ((() False) ($x True))))

; the total ideal size across every class the intent allows (0 => nothing to answer => abstain)
(= (total-ideal $ws $q)
   (let $i (intent-of $ws $q) (foldall + (match &self (intent-allows $i $cls) (idealsize $ws $q $cls)) 0)))

; abstain income: the clamp's reward for each typed, unanswered question whose ideal is empty
(= (abstain-income $ws $cl)
   (foldall + (match &self (qa-question $t $q) (if (typed? $ws $q) (if (answered? $ws $q) 0 (if (== (total-ideal $ws $q) 0) (abstain-reward-of $cl) 0)) 0)) 0))

; total gm minted over the answer set under clamp $cl, plus abstain income
(= (gm-income $ws $cl)
   (+ (foldall + (match $ws (candidate-answer $q (ans $q $cls)) (would-mint $ws $q $cls $cl)) 0)
      (abstain-income $ws $cl)))

; gm spent = one per firing / # candidate answers produced
(= (gm-spend $ws)
   (foldall + (match $ws (event $s $r $k) 1) 0))

(= (count-answers $ws)
   (foldall + (match $ws (candidate-answer $q $a) 1) 0))
