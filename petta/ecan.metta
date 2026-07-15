; ===========================================================================
; ECAN — the ECAN-EPOCH worker body (worker-kind `ecan-epoch`): the MINTING worker kind
; (vs context-chamber's deriving-only). `run-ee` runs the metabolic-closure epoch loop
; (TECAN Alg 5.1) in the worker's ISOLATED space: own hot pool -> restore
; snapshot fuel -> loop the cycle (tag the cycle -> re-derive -> mint+credit -> decay the
; derived layer) for the worker's `worker-cycles` cycles under its `worker-clamp`. The purse
; persists in the space across cycles; the single event log accumulates cycle-tagged, in
; place. Emits the answer trajectory + total firings + final purse. Dispatched
; by dispatch.metta. Assumes util + fuel + reaction + grounder + evaluator + epoch + worker.
; ===========================================================================

; the ecan-epoch worker body: own space -> hot pool -> restore fuel -> run the epoch loop
; for worker-cycles cycles under worker-clamp -> emit trajectory + firings + final purse
(= (run-ee $w)
   (let* (($ws (match &self (worker-space $w $sp) $sp))
          ($ch (match &self (worker-chamber $w $c) $c))
          ($cl (match &self (worker-clamp $w $c2) $c2))
          ($snap (match &self (worker-snapshot $w $s) $s))
          ($n (match &self (worker-cycles $w $cyc) $cyc))
          ($z0 (copy-molecules $ws))
          ($z1 (restore-snapshot $ws $snap))
          ($traj (epochs $ws $ch $cl $n))
          ($firings (foldall + (match $ws (event $k $s2 $r $key) 1) 0))
          ($z2 (add-atom &self (worker-trajectory $w $traj)))
          ($z3 (add-atom &self (worker-firings $w $firings))))
     (add-all &self (collapse (match $ws (fuel $O $t $n2) (worker-purse $w $O $t $n2))))))
