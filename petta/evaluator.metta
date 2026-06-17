; ===========================================================================
; P1 EVALUATOR ported to PeTTa (TECAN T2) — eq-17 scoring + clamp-gated minting.
; ---------------------------------------------------------------------------
; The layer src/evaluator.py runs OUTSIDE the firing loop: score each candidate-
; answer against its gold skeleton by a faithful subset of MSC eq 17 (Match here;
; Unsupportedness/Redundancy are 0 on this corpus), then MINT typed fuel by the
; active clamp's class. This file runs the rule productions to fixpoint (ample),
; then scores + mints — verified == the Python evaluator.
;
; Numerics: PeTTa's `/` is FLOAT and `round` is absent, but `floor-math` matches
; Python's mint rounding for every value here (floor(6*0.5)=3, floor(6*0.75)=4 =
; Python round(4.5)). Match = covered^2/(skel*ans); mint = floor(SCALE*Match).
;
; VERIFIED vs src/evaluator.py (CL_antecedent, SCALE=6, CI_REWARD=2):
;   income == 25 tau_graph_match + 8 tau_causal; Q3a mint 3 (Match 0.5); Q20
;   abstain mint 4. CLAMP-SWITCH: gm-income flips 25 (physical) <-> 16 (intentional).
;
; Minting adds answer-reward facts under the active clamp CL_antecedent; the
; pure gm-income function shows the clamp-switch. REMAINING for full P1: credit
; the minted fuel back + the epoch loop (metabolic closure) + per-class SURPLUS
; (income - spend) — those integrate with petta/kernel.metta's fuel ledger.
;
; Run:  sh ../PeTTa/run.sh petta/evaluator.metta < /dev/null \
;          2>&1 | grep should     # six ✅
; ===========================================================================
!(import! &self "experiments/expt1-causal-qa/load.metta")
!(collapse (match &self (qa-question $t $q) (match &self (q-word $q $w) (match &self (intent-map $w $i) (add-atom &self (q-intent $q $i))))))
!(collapse (match &self (q-intent $q $i) (match &self (question-source $q $g) (match &self (question-focus $q $foc) (match &self (sem-edge $g $e $rel $src $foc) (match &self (edge-cluster $rel $cls) (match &self (intent-allows $i $cls) ((add-atom &self (alignment-cites (al $q $cls) $g $e)) (add-atom &self (alignment-prov (al $q $cls) $g $src))))))))))
!(collapse (match &self (q-intent $q $i) (match &self (question-source $q $g) (match &self (question-focus $q $foc) (match &self (intent-allows $i $cls) (case (collapse (match &self (sem-edge $g $e $rel $src $foc) (match &self (edge-cluster $rel $cls) yes))) ((() ()) ($any (add-atom &self (alignment (al $q $cls) $q $cls))))))))))
!(collapse (match &self (q-intent $q $i) (match &self (question-source $q $g) (match &self (question-focus $q $foc) (case (collapse (match &self (sem-edge $g $e $rel $src $foc) (match &self (edge-cluster $rel $ec) (match &self (explanatory $ec) yes)))) ((() (add-atom &self (alignment (al $q abstain) $q abstain))) ($any ())))))))
!(collapse (match &self (alignment (al $q $cls) $q $cls) ((add-atom &self (candidate-answer $q (a $q $cls))) (if (== $cls abstain) (add-atom &self (answer-abstain (a $q $cls))) (add-atom &self (answer-class (a $q $cls) $cls))))))
!(collapse (match &self (alignment-cites (al $q $cls) $g $e) (add-atom &self (answer-cites (a $q $cls) $g $e))))
; --- EVALUATOR: eq-17 match + clamp-gated mint (CL_antecedent: physical-cause) ---
(= (covered $q $cls) (foldall + (match &self (answer-cites (a $q $cls) $g $e) (match &self (answer-skeleton $q $sk) (match &self (skeleton-class $sk $cls) (match &self (skeleton-cites $sk $g $e) 1)))) 0))
(= (skelsize $q $cls) (foldall + (match &self (answer-skeleton $q $sk) (match &self (skeleton-class $sk $cls) (match &self (skeleton-cites $sk $g $e) 1))) 0))
(= (anssize $q $cls) (foldall + (match &self (answer-cites (a $q $cls) $g $e) 1) 0))
(= (mint-answer $q $cls) (if (== $cls physical-cause) (let $m (floor-math (* 6 (/ (* (covered $q $cls) (covered $q $cls)) (* (skelsize $q $cls) (anssize $q $cls))))) ((add-atom &self (answer-reward (a $q $cls) tau_graph_match $m)) (add-atom &self (answer-reward (a $q $cls) tau_causal 2)))) (if (== $cls abstain) (let $m2 (floor-math (* 6 0.75)) (add-atom &self (answer-reward (a $q abstain) tau_graph_match $m2))) ())))
!(collapse (match &self (candidate-answer $q (a $q $cls)) (mint-answer $q $cls)))
!(test (foldall + (match &self (answer-reward $a tau_graph_match $n) $n) 0) 25)
!(test (foldall + (match &self (answer-reward $a tau_causal $n) $n) 0) 8)
!(test (foldall + (match &self (answer-reward (a Q3a physical-cause) tau_graph_match $n) $n) 0) 3)
!(test (foldall + (match &self (answer-reward (a Q20 abstain) tau_graph_match $n) $n) 0) 4)
; --- clamp-switch (pure): income an answer would earn under a given clamp class ---
(= (would-mint $q $cls $cc) (if (== $cls $cc) (floor-math (* 6 (/ (* (covered $q $cls) (covered $q $cls)) (* (skelsize $q $cls) (anssize $q $cls))))) (if (== $cls abstain) (floor-math (* 6 0.75)) 0)))
(= (gm-income $cc) (foldall + (match &self (candidate-answer $q (a $q $cls)) (would-mint $q $cls $cc)) 0))
!(test (gm-income physical-cause) 25)
!(test (gm-income intentional) 16)
