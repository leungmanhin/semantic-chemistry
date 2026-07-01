; ===========================================================================
; ECAN — the P1 metabolic-closure epoch loop: run the chamber to quiescence, score the
; NEW answers (eq-17 Match), mint typed fuel by the active clamp, credit it back to the
; fuel ledger, and re-run while there is progress + fuel. This turns the P0 feed-forward
; chain into a self-sustaining mortal ACS (the fuel an answer mints funds the next).
; Relies on the re-run-safe kernel (fire-once walk + run-from). Facts-free; assumes the
; engine (kernel.metta) + evaluator (evaluator.metta) are loaded by the consumer.
; Exercised by tests/ecan_epoch_test.metta.
; ===========================================================================

; the eq-17 mint for answer ($q,$cls) under the active clamp (CL_antecedent = physical-cause)
(= (gm-mint $ws $q $cls) (would-mint $ws $q $cls physical-cause))

; credit $m minted gm back to the earning organism's purse (evaluator-side, NOT a soma
; firing; single-organism Exp-1: the-organism = O_qa)
(= (credit-gm $ws $m)
   (let* (($O (the-organism))
          ($n (fuelof $ws $O gm))
          ($z (remove-atom $ws (fuel $O gm $n)))
          ($tot (+ $n $m)))
     (add-atom $ws (fuel $O gm $tot))))

; the not-yet-scored candidate answers, as (ans Q CLS) (already-scored ones drop out as skip)
(= (unscored $ws)
   (filter-out skip
               (collapse (match $ws (candidate-answer $q (ans $q $cls))
                                (case (collapse (match $ws (scored (ans $q $cls)) yes))
                                      ((() (ans $q $cls))
                                       ($any skip)))))))

; score one answer: mint its gm, mark it scored, credit the fuel; return the minted amount
(= (credit-one $ws $q $cls)
   (let* (($m (gm-mint $ws $q $cls))
          ($z1 (add-atom $ws (scored (ans $q $cls))))
          ($z2 (credit-gm $ws $m)))
     $m))

; score every answer in $as, returning the total minted
(= (credit-all $ws $as)
   (case $as
         ((() 0)
          ($ne (let* (((ans $q $cls) (car-atom $as))
                      ($m (credit-one $ws $q $cls)))
                 (+ $m (credit-all $ws (cdr-atom $as))))))))

; how many firings the run has logged so far
(= (count-events $ws) (foldall + (match $ws (event $s $r $k) 1) 0))

; THE EPOCH LOOP: run -> score+mint+credit the new answers -> re-run while there is
; progress (new answers) and the minting paid off (credited > 0)
(= (epoch $ws)
   (let* (($seq0 (count-events $ws))
          ($z (run-rules-from $ws $seq0))
          ($new (unscored $ws))
          ($cr (credit-all $ws $new)))
     (if (== $new ())
         done
         (if (> $cr 0)
             (epoch $ws)
             done))))
