; ===========================================================================
; ECAN — the P1 metabolic-closure epoch loop: run the chamber to quiescence, score the
; NEW answers (eq-17 Match), mint typed fuel by the active clamp, credit it back to the
; fuel ledger, and re-run while there is progress + fuel. This turns the P0 feed-forward
; chain into a self-sustaining mortal ACS (the fuel an answer mints funds the next).
; Relies on the re-run-safe kernel (fire-once walk + run-from). Facts-free; assumes the
; engine (kernel.metta) + evaluator (evaluator.metta) are loaded by the consumer.
; Exercised by tests/ecan_epoch_test.metta.
; ===========================================================================
; the eq-17 mint under the CL_antecedent clamp = would-mint at physical-cause
(= (gm-mint $ws $q $cls) (would-mint $ws $q $cls physical-cause))
; credit minted gm back to the fuel ledger (evaluator-side, NOT a soma firing) — into the
; earning organism's purse (single-organism Exp-1: the-organism = O_qa)
(= (credit-gm $ws $m) (let $O (the-organism) (let $n (fuelof $ws $O gm) (let $z (remove-atom $ws (fuel $O gm $n)) (let $tot (+ $n $m) (add-atom $ws (fuel $O gm $tot)))))))
; the unscored candidate-answers (as (ans Q CLS)); score-credit-mark each once
(= (unscored $ws) (filter-out skip (collapse (match $ws (candidate-answer $q (a $q $cls)) (case (collapse (match $ws (scored (a $q $cls)) yes)) ((() (ans $q $cls)) ($any skip)))))))
(= (credit-one $ws $q $cls) (let $m (gm-mint $ws $q $cls) (let $z1 (add-atom $ws (scored (a $q $cls))) (let $z2 (credit-gm $ws $m) $m))))
(= (credit-all $ws $as) (case $as ((() 0) ($ne (let (ans $q $cls) (car-atom $as) (let $m (credit-one $ws $q $cls) (+ $m (credit-all $ws (cdr-atom $as)))))))))
(= (count-events $ws) (foldall + (match $ws (event $s $r $k) 1) 0))
; THE EPOCH LOOP: run -> score+mint+credit new -> re-run while progress + fuel
(= (epoch $ws) (let $seq0 (count-events $ws) (let $z (run-rules-from $ws $seq0) (let $new (unscored $ws) (let $cr (credit-all $ws $new) (if (== $new ()) done (if (> $cr 0) (epoch $ws) done)))))))
