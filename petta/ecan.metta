; ===========================================================================
; ECAN — the ECAN-EPOCH worker body (worker-kind `ecan-epoch`): the MINTING worker kind
; (vs context-chamber's deriving-only). `run-ee` works ONE arriving task (TECAN Alg 5.1) in the
; worker's ISOLATED space: restore snapshot fuel -> pose its task into a fresh hot pool -> run
; cycles until the chamber settles or its `worker-cycles` allowance runs out -> mint + credit
; under its `worker-clamp`. The purse persists in the space; the single event log accumulates
; cycle-tagged, in place. Emits the answer trajectory + total firings + final purse. A worker is
; handed one task — a stream of them is the harness's business. Dispatched by dispatch.metta.
; Assumes util + fuel + reaction + grounder + evaluator + epoch + worker.
; ===========================================================================

; the ecan-epoch worker body: own space -> hot pool -> restore fuel -> run the epoch loop
; for worker-cycles cycles under worker-clamp -> emit trajectory + firings + final purse
(= (run-ee $w)
   (let* (($ws (match &self (worker-space $w $sp) $sp))
          ($ch (match &self (worker-chamber $w $c) $c))
          ($cl (match &self (worker-clamp $w $c2) $c2))
          ($snap (match &self (worker-snapshot $w $s) $s))
          ($n (worker-cycles-of $w))
          ($z1 (restore-snapshot $ws $snap))
          ($traj (cons-atom (run-task $ws $ch $cl (worker-task-of $w) 1 $n) ()))
          ($firings (foldall + (match $ws (event $k $s2 $r $key) 1) 0))
          ($z2 (add-atom &self (worker-trajectory $w $traj)))
          ($z3 (add-atom &self (worker-firings $w $firings))))
     (add-all &self (collapse (match $ws (fuel $O $t $n2) (worker-purse $w $O $t $n2))))))
