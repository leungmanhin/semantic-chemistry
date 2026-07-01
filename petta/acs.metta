; ===========================================================================
; ACS — reusable P2 ACS logic: ablation, graph reachability, surplus, and the
; log-miner (derive the reaction graph from the event log + rule IR, then discover the
; ACS = the rules on a metabolic cycle). Facts-free; assumes the engine (kernel.metta)
; and evaluator (evaluator.metta) are loaded by the consumer. Exercised by
; tests/acs_scan_test.metta (certify a hand-given candidate) and
; tests/acs_mine_test.metta (discover it from the log).
; ===========================================================================

; --- ablation: run the genome on $ws skipping one rule; count answers (generous fuel,
;     so the effect is STRUCTURAL not starvation). `none` skips nothing (baseline). ---
(= (ablate-answers $skip $sp) (let $z1 (add-atom $sp (fuel gm 30)) (let $z2 (add-atom $sp (fuel ci 30)) (let $z3 (run-ablate $sp (cons-atom $skip ())) (count-answers $sp)))))

; --- generic list / graph utils ---
(= (member-of $x $l) (case $l ((() False) ($ne (if (== (car-atom $l) $x) True (member-of $x (cdr-atom $l)))))))
(= (app $a $b) (case $a ((() $b) ($ne (cons-atom (car-atom $a) (app (cdr-atom $a) $b))))))
(= (len $l) (if (== $l ()) 0 (+ 1 (len (cdr-atom $l)))))
(= (add-edges $g $es) (case $es ((() done) ($ne (let $h (car-atom $es) (let $z (add-atom $g $h) (add-edges $g (cdr-atom $es))))))))

; --- reachability on a graph of (medge Src Dst) facts (visited set; terminates on cycles) ---
(= (succs $g $node) (collapse (match $g (medge $node $t) $t)))
(= (any-reaches $g $frontier $goal $seen) (case $frontier ((() False) ($ne (let $h (car-atom $frontier) (if (== $h $goal) True (if (member-of $h $seen) (any-reaches $g (cdr-atom $frontier) $goal $seen) (any-reaches $g (app (succs $g $h) (cdr-atom $frontier)) $goal (cons-atom $h $seen)))))))))
(= (reaches? $g $from $to) (any-reaches $g (succs $g $from) $to ()))
(= (cycle-through $g $node) (any-reaches $g (succs $g $node) $node ()))

; --- surplus = evaluator income - firing spend, on a run space; and a 3-way AND ---
(= (gm-surplus $ws $cc) (- (gm-income $ws $cc) (gm-spend $ws)))
(= (all3 $a $b $c) (if $a (if $b (if $c True False) False) False))

; ===========================================================================
; LOG-MINING: derive the reaction graph from the event log + the fired rules' canonical
; IR, then discover the ACS = the fired rules that reach fuel (gm). Generic over any
; genome; variable-head edge clauses are skipped (`varhead`) — they consume food.
; ===========================================================================
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
; the ACS = fired rules on a metabolic cycle (reach gm); its spend + surplus from the log
(= (acs-members $g $rs) (case $rs ((() ()) ($ne (let $r (car-atom $rs) (if (reaches? $g $r gm) (cons-atom $r (acs-members $g (cdr-atom $rs))) (acs-members $g (cdr-atom $rs))))))))
(= (rule-firings $r) (foldall + (match &self (event $s $r $k) 1) 0))
(= (sum-firings $rs) (case $rs ((() 0) ($ne (+ (rule-firings (car-atom $rs)) (sum-firings (cdr-atom $rs)))))))
(= (acs-spend $g) (sum-firings (acs-members $g (fired-rules))))
(= (acs-surplus $g $cc) (- (gm-income &self $cc) (acs-spend $g)))
