; ===========================================================================
; ECAN — the P1 metabolic-closure epoch loop: run the chamber to quiescence, score the
; NEW answers (eq-17 Match), mint typed fuel by the active clamp, credit it back to the
; fuel ledger, and re-run while there is progress + fuel. This turns the P0 feed-forward
; chain into a self-sustaining mortal ACS (the fuel an answer mints funds the next).
; Relies on the re-run-safe engine (fire-once walk + run-from). Assumes the
; engine (reaction) + evaluator (evaluator.metta) are loaded by the consumer.
; ===========================================================================

; the organism that produced answer (ans Q CLS) — it earns the mint (answer-by product)
(= (answerer $ws $q $cls)
   (match $ws (answer-by (ans $q $cls) $O) $O))

; the not-yet-scored candidate answers, as (ans Q CLS) (already-scored ones drop out as skip)
(= (unscored $ws)
   (filter-out skip
               (collapse (match $ws (candidate-answer $q (ans $q $cls))
                                (case (collapse (match $ws (scored (ans $q $cls)) yes))
                                      ((() (ans $q $cls))
                                       ($any skip)))))))

; score one answer under clamp $cl: mint, mark it scored, credit the clamp's mint token
; to the earning organism (evaluator-side, NOT a soma firing); return the minted amount
(= (credit-one $ws $q $cls $cl)
   (let* (($m (would-mint $ws $q $cls $cl))
          ($z1 (add-atom $ws (scored (ans $q $cls))))
          ($O (answerer $ws $q $cls))
          ($tok (mint-token-of $cl))
          ($z2 (credit $ws $O $tok $m)))
     $m))

; score every answer in $as under clamp $cl, returning the total minted
(= (credit-all $ws $as $cl)
   (case $as
         ((() 0)
          ($ne (let* (((ans $q $cls) (car-atom $as))
                      ($m (credit-one $ws $q $cls $cl)))
                 (+ $m (credit-all $ws (cdr-atom $as) $cl)))))))

; how many firings the run has logged so far
(= (count-events $ws)
   (foldall + (match $ws (event $s $r $k) 1) 0))

; THE EPOCH LOOP: run chamber $ch's admitted rules -> score+mint+credit the new answers
; under clamp $cl -> re-run while there is progress (new answers) and the minting paid
; off (credited > 0). `epoch` expresses the genome once (idempotent), then loops.
(= (epoch $ws $ch $cl)
   (let $z (express) (epoch-loop $ws $ch $cl)))

(= (epoch-loop $ws $ch $cl)
   (let* (($seq0 (count-events $ws))
          ($z (run-chamber-from $ws $ch $seq0))
          ($new (unscored $ws))
          ($cr (credit-all $ws $new $cl)))
     (if (== $new ())
         done
         (if (> $cr 0)
             (epoch-loop $ws $ch $cl)
             done))))

; ===========================================================================
; ECAN-EPOCH WORKER (worker-kind ecan-epoch): a chamber run with metabolic feedback.
; Assumes persist is loaded (persist-log / emit-summary).
; ===========================================================================

; ecan-epoch worker body: own space, restore the snapshot's per-organism purses, run the
; epoch loop (mint feeds back) on the worker's chamber under the worker's clamp, persist
; its output log (if declared), summarise to &self
(= (run-epoch $w)
   (let* (($ws (match &self (worker-space $w $sp) $sp))
          ($snap (match &self (worker-snapshot $w $s) $s))
          ($ch (match &self (worker-chamber $w $chm) $chm))
          ($cl (match &self (worker-clamp $w $c) $c))
          ($z1 (add-all $ws (collapse (match &self (snapshot-fuel $snap $O $t $n) (fuel $O $t $n)))))
          ($z2 (epoch $ws $ch $cl))
          ($z3 (persist-log $w $ws)))
     (emit-summary $w $ws)))
