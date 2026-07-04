; ===========================================================================
; CHAMBER — the context-chamber worker body (worker-kind `context-chamber`): own
; space, fuel seeded from its snapshot into the worker organism's purse, run the
; reaction on that space, persist its output log, summarise to &self. Assumes fuel
; + reaction + persist are loaded. Dispatched by workers.metta. Facts-free.
; ===========================================================================

; context-chamber worker: own space, snapshot fuel into the organism's purse, run
; the engine on $ws, persist its output log (if declared), summarise to &self
; (single-organism Exp-1: the-organism = O_qa)
(= (run-cc $w)
   (let* (($ws (match &self (worker-space $w $sp) $sp))
          ($snap (match &self (worker-snapshot $w $s) $s))
          ($O (the-organism))
          ($z1 (add-all $ws (collapse (match &self (snapshot-fuel $snap $t $n) (fuel $O $t $n)))))
          ($z2 (run-rules $ws))
          ($z3 (persist-log $w $ws)))
     (emit-summary $w $ws)))
