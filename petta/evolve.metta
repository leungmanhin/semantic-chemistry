; ===========================================================================
; P3 EVOLVE ported to PeTTa (TECAN T6) — genome mutation + fitness (surplus).
; ---------------------------------------------------------------------------
; The genome is DATA (a list of member rule names). MUTATION operators — prune /
; recombine / member-of — are list transforms. FITNESS = metabolic surplus =
; income (evaluator mints) − spend (rule firings × cost), counted from the
; expressed facts. Demonstrates the P3 headline: pruning the INERT R_complete
; (which P2 found earns 0 reward) RAISES surplus +4 → +5 — selection-by-surplus
; rediscovers + prunes the dead-weight rule. recombine() of two complementary
; defective genomes yields the union (rescue), per src/evolve.py.
;
; VERIFIED vs src/evolve.py: founder surplus +4 (income 25 − spend 21);
; prune-R_complete +5; prune/recombine/member-of operators.
;
; SCOPE: the full selection LOOP (express EVERY mutant, reject load-bearing
; prunes that starve, recombination-rescues-VIABILITY, converge) needs per-
; genome re-runs — the multi-genome orchestration shared with P2 (acs_detect),
; deferred. prune-R_complete's surplus is analytic here (R_complete is an inert
; leaf — pruning removes only its role-fill firing, no downstream/income change);
; general mutant expression is that deferred re-run harness.
;
; Run:  sh ../PeTTa/run.sh petta/evolve.metta < /dev/null \
;          2>&1 | grep should     # eight ✅
; ===========================================================================
!(import! &self "experiments/expt1-causal-qa/load.metta")
; rules to fixpoint (founder = all rules)
!(collapse (match &self (qa-question $t $q) (match &self (q-word $q $w) (match &self (intent-map $w $i) (add-atom &self (q-intent $q $i))))))
!(collapse (match &self (q-intent $q $i) (match &self (question-source $q $g) (match &self (question-focus $q $foc) (match &self (sem-edge $g $e $rel $src $foc) (match &self (edge-cluster $rel $cls) (match &self (intent-allows $i $cls) ((add-atom &self (alignment-cites (al $q $cls) $g $e)) (add-atom &self (alignment-prov (al $q $cls) $g $src))))))))))
!(collapse (match &self (q-intent $q $i) (match &self (question-source $q $g) (match &self (question-focus $q $foc) (match &self (intent-allows $i $cls) (case (collapse (match &self (sem-edge $g $e $rel $src $foc) (match &self (edge-cluster $rel $cls) yes))) ((() ()) ($any (add-atom &self (alignment (al $q $cls) $q $cls))))))))))
!(collapse (match &self (q-intent $q $i) (match &self (question-source $q $g) (match &self (question-focus $q $foc) (case (collapse (match &self (sem-edge $g $e $rel $src $foc) (match &self (edge-cluster $rel $ec) (match &self (explanatory $ec) yes)))) ((() (add-atom &self (alignment (al $q abstain) $q abstain))) ($any ())))))))
!(collapse (match &self (alignment-cites (al $q $cls) $g $e) (match &self (sem-edge $g $e $rel $cause $foc) (match &self (sem-edge $g $e2 $rel2 $cause $d) (case (collapse (match &self (edge-cluster $rel2 $x) yes)) ((() (add-atom &self (role-fill (al $q $cls) $rel2 $d))) ($any ())))))))
!(collapse (match &self (alignment (al $q $cls) $q $cls) ((add-atom &self (candidate-answer $q (a $q $cls))) (if (== $cls abstain) (add-atom &self (answer-abstain (a $q $cls))) (add-atom &self (answer-class (a $q $cls) $cls))))))
!(collapse (match &self (alignment-cites (al $q $cls) $g $e) (add-atom &self (answer-cites (a $q $cls) $g $e))))
; --- income (from evaluator) + spend (count firings) -> surplus ---
(= (covered $q $cls) (foldall + (match &self (answer-cites (a $q $cls) $g $e) (match &self (answer-skeleton $q $sk) (match &self (skeleton-class $sk $cls) (match &self (skeleton-cites $sk $g $e) 1)))) 0))
(= (skelsize $q $cls) (foldall + (match &self (answer-skeleton $q $sk) (match &self (skeleton-class $sk $cls) (match &self (skeleton-cites $sk $g $e) 1))) 0))
(= (anssize $q $cls) (foldall + (match &self (answer-cites (a $q $cls) $g $e) 1) 0))
(= (would-mint $q $cls $cc) (if (== $cls $cc) (floor-math (* 6 (/ (* (covered $q $cls) (covered $q $cls)) (* (skelsize $q $cls) (anssize $q $cls))))) (if (== $cls abstain) (floor-math (* 6 0.75)) 0)))
(= (gm-income $cc) (foldall + (match &self (candidate-answer $q (a $q $cls)) (would-mint $q $cls $cc)) 0))
(= (cnt $pat) (foldall + (match &self $pat 1) 0))
(= (spend-gm) (+ (cnt (q-intent $a $b)) (+ (cnt (alignment $x $y $z)) (+ (cnt (role-fill $p $r $s)) (cnt (candidate-answer $m $n))))))
(= (surplus-gm $cc) (- (gm-income $cc) (spend-gm)))
!(test (gm-income physical-cause) 25)
!(test (spend-gm) 21)
!(test (surplus-gm physical-cause) 4)
; prune R_complete (inert leaf): same income, spend loses its role-fill firing -> +5
(= (surplus-prune-rcomplete $cc) (- (gm-income $cc) (- (spend-gm) (cnt (role-fill $p $r $s)))))
!(test (surplus-prune-rcomplete physical-cause) 5)

; --- MUTATION operators (genome = list of member rule names) ----------------
(= (member-of $x $l) (case $l ((() False) ($ne (if (== (car-atom $l) $x) True (member-of $x (cdr-atom $l)))))))
(= (prune $r $l) (case $l ((() ()) ($ne (let $h (car-atom $l) (if (== $h $r) (prune $r (cdr-atom $l)) (cons-atom $h (prune $r (cdr-atom $l)))))))))
(= (add-missing $a $b) (case $b ((() $a) ($ne (let $h (car-atom $b) (if (member-of $h $a) (add-missing $a (cdr-atom $b)) (add-missing (cons-atom $h $a) (cdr-atom $b))))))))
(= (recombine $a $b) (add-missing $a $b))
!(test (prune R_complete (R_qtype R_align R_abstain R_complete R_project)) (R_qtype R_align R_abstain R_project))
!(test (member-of R_complete (R_qtype R_align R_abstain R_project)) False)
!(test (member-of R_align (R_qtype R_align R_abstain R_project)) True)
!(test (msort (recombine (R_qtype R_align R_complete) (R_align R_complete R_project))) (R_align R_complete R_project R_qtype))
