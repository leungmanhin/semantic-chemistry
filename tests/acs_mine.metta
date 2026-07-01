; ===========================================================================
; ACS LOG-MINING — identify + confirm the mortal-ACS by analyzing the event log.
; ---------------------------------------------------------------------------
; Where acs_scan.metta CONFIRMS a hand-given candidate against a HAND-DRAWN reaction
; graph, this module DERIVES the graph generically and DISCOVERS the ACS:
;   1. run the chamber to fixpoint -> the event log (which rules fired);
;   2. build the reaction graph FROM the fired rules' canonical IR — (medge species R)
;      for each concrete rule-lhs head R consumes, (medge R species) for each rule-rhs
;      head it produces, (medge gm R) for its gm cost — plus the evaluator's closing
;      edge (candidate-answer -> E -> gm);
;   3. IDENTIFY the ACS = the fired rules on a metabolic cycle (that reach gm);
;   4. CONFIRM: the cycle exists ONLY with the evaluator edge (metabolic closure), and
;      the discovered ACS runs a surplus.
; No hand-drawn graph and no ablation: R_complete falls out as dead-weight STRUCTURALLY
; — its product (role-fill) is consumed by nothing, so it never reaches fuel. Generic:
; the derivation reads any genome's rule-lhs/rule-rhs; variable-head edge clauses are
; skipped as `varhead` (they consume food, not produced species).
;
; Run:  sh ../PeTTa/run.sh tests/acs_mine.metta < /dev/null 2>&1 | grep should  # twelve ✅
; ===========================================================================
!(import! &self "petta/kernel_defs.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")
!(import! &self "petta/evaluator_defs.metta")

!(add-atom &self (fuel gm 100))
!(add-atom &self (fuel ci 100))
!(run-rules &self)

; === derive the reaction graph from the log (fired rules) + their canonical IR ===
(= (fired-rules) (dedup (collapse (match &self (event $s $r $k) $r))))
(= (pat-head $pat) (let $h (car-atom $pat) (case $h (((var $n) varhead) ($s $s)))))
(= (clause-head $c) (case $c (((at $sp $pat) (pat-head $pat)) ($bare (pat-head $bare)))))
(= (map-clause-head $l) (if (== $l ()) () (cons-atom (clause-head (car-atom $l)) (map-clause-head (cdr-atom $l)))))
(= (map-pat-head $l) (if (== $l ()) () (cons-atom (pat-head (car-atom $l)) (map-pat-head (cdr-atom $l)))))
(= (lhs-heads $R) (map-clause-head (match &self (rule-lhs $R $cs) $cs)))
(= (rhs-heads $R) (map-pat-head (match &self (rule-rhs $R $ps) $ps)))
(= (gm-cost? $R) (case (collapse (match &self (rule-token-cost $R gm $n) yes)) ((() False) ($x True))))
(= (add-in-edges $g $R $hs) (if (== $hs ()) done (let $h (car-atom $hs) (let $z (if (== $h varhead) done (add-atom $g (medge $h $R))) (add-in-edges $g $R (cdr-atom $hs))))))
(= (add-out-edges $g $R $ps) (if (== $ps ()) done (let $p (car-atom $ps) (let $z (add-atom $g (medge $R $p)) (add-out-edges $g $R (cdr-atom $ps))))))
(= (add-rule-edges $g $R) (let $z0 (if (gm-cost? $R) (add-atom $g (medge gm $R)) done) (let $z1 (add-in-edges $g $R (lhs-heads $R)) (add-out-edges $g $R (rhs-heads $R)))))
(= (build-graph $g $rs) (if (== $rs ()) done (let $z (add-rule-edges $g (car-atom $rs)) (build-graph $g (cdr-atom $rs)))))

; === reachability on the derived graph (visited-set, terminates on cycles) ===
(= (succs $g $node) (collapse (match $g (medge $node $t) $t)))
(= (member-of $x $l) (case $l ((() False) ($ne (if (== (car-atom $l) $x) True (member-of $x (cdr-atom $l)))))))
(= (app $a $b) (case $a ((() $b) ($ne (cons-atom (car-atom $a) (app (cdr-atom $a) $b))))))
(= (any-reaches $g $frontier $goal $seen) (case $frontier ((() False) ($ne (let $h (car-atom $frontier) (if (== $h $goal) True (if (member-of $h $seen) (any-reaches $g (cdr-atom $frontier) $goal $seen) (any-reaches $g (app (succs $g $h) (cdr-atom $frontier)) $goal (cons-atom $h $seen)))))))))
(= (reaches? $g $from $to) (any-reaches $g (succs $g $from) $to ()))
(= (cycle-through $g $node) (any-reaches $g (succs $g $node) $node ()))

; === IDENTIFY the ACS = fired rules on a metabolic cycle (that reach gm) ===
(= (acs-members $g $rs) (case $rs ((() ()) ($ne (let $r (car-atom $rs) (if (reaches? $g $r gm) (cons-atom $r (acs-members $g (cdr-atom $rs))) (acs-members $g (cdr-atom $rs))))))))
(= (len $l) (if (== $l ()) 0 (+ 1 (len (cdr-atom $l)))))
; === CONFIRM: the discovered members' spend (firings from the log) and surplus ===
(= (rule-firings $r) (foldall + (match &self (event $s $r $k) 1) 0))
(= (sum-firings $rs) (case $rs ((() 0) ($ne (+ (rule-firings (car-atom $rs)) (sum-firings (cdr-atom $rs)))))))
(= (acs-spend $g) (sum-firings (acs-members $g (fired-rules))))
(= (acs-surplus $g $cc) (- (gm-income &self $cc) (acs-spend $g)))

; --- build the graph: &g_full has the evaluator's closing edge; &g_soma does not ---
!(bind! &g_full (new-space))
!(build-graph &g_full (fired-rules))
!(add-atom &g_full (medge candidate-answer E))
!(add-atom &g_full (medge E gm))
!(bind! &g_soma (new-space))
!(build-graph &g_soma (fired-rules))

; --- IDENTIFICATION: R_complete falls out (its product reaches no fuel) ---
!(test (len (fired-rules)) 4)                              ; all four rules fired
!(test (reaches? &g_full R_project gm) True)              ; product -> candidate-answer -> E -> gm
!(test (reaches? &g_full R_complete gm) False)            ; role-fill consumed by nothing -> dead-weight
!(test (member-of R_qtype (acs-members &g_full (fired-rules))) True)
!(test (member-of R_align (acs-members &g_full (fired-rules))) True)
!(test (member-of R_project (acs-members &g_full (fired-rules))) True)
!(test (member-of R_complete (acs-members &g_full (fired-rules))) False)
!(test (len (acs-members &g_full (fired-rules))) 3)       ; the ACS = {qtype, align, project}
; --- CLOSURE: metabolic, not structural (cycle only with the evaluator edge) ---
!(test (cycle-through &g_full gm) True)                   ; rules + evaluator: closed cycle
!(test (cycle-through &g_soma gm) False)                  ; soma alone: feed-forward DAG
; --- CONFIRMATION: the discovered ACS runs a surplus ---
!(test (acs-spend &g_full) 19)                            ; member firings (6 qtype + 7 align + 6 project)
!(test (acs-surplus &g_full physical-cause) 6)            ; income 25 - spend 19 = +6 (self-sustaining)
