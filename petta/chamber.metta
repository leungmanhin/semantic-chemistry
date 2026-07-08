; ===========================================================================
; CHAMBER — the context-chamber worker body (worker-kind `context-chamber`): own
; space, fuel restored from its snapshot into each organism's purse, run its chamber's
; admitted rules on that space, persist its output log, summarise to &self. Assumes fuel
; + reaction + persist are loaded. Dispatched by workers.metta.
; ===========================================================================

; context-chamber worker: own space, restore the snapshot's per-organism purses, run the
; worker's chamber (only its context-admitted rules) on $ws, persist its output log (if
; declared), summarise to &self
(= (run-cc $w)
   (let* (($ws (match &self (worker-space $w $sp) $sp))
          ($ch (match &self (worker-chamber $w $c) $c))
          ($snap (match &self (worker-snapshot $w $s) $s))
          ($z1 (add-all $ws (collapse (match &self (snapshot-fuel $snap $O $t $n) (fuel $O $t $n)))))
          ($z2 (run-chamber $ws $ch))
          ($z3 (persist-log $w $ws)))
     (emit-summary $w $ws)))
