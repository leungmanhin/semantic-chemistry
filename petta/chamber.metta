; ===========================================================================
; CHAMBER — the CONTEXT-CHAMBER worker body.
; `run-cc` runs a bounded, isolated unit of chamber DERIVATION: own hot-pool space -> pose the
; worker's task and materialize that task's text (the shared envelope in `worker.metta`) ->
; restore snapshot fuel -> run the chamber's admitted rules on it TO SETTLE, bounded by the
; worker's step budget -> emit the summary. Running to settle rather than for one epoch is what
; makes the worker a unit of useful WORK: one epoch advances a chain a single hop, so a bounded
; one-epoch worker would hand the next stage a half-derived pool. The budget still bounds it, now
; over the whole run. Deriving only; minting (the ecan-epoch kind) is a separate body.
; Dispatched by `dispatch.metta`. Assumes util + fuel + reaction + worker (the envelope)
; are loaded.
; ===========================================================================

; the context-chamber worker body: own space -> hot pool -> restore fuel -> run the chamber to
; settle (bounded by worker-budget-steps) -> emit-summary
(= (run-cc $w)
   (let* (($ws (match &self (worker-space $w $sp) $sp))
          ($ch (match &self (worker-chamber $w $c) $c))
          ($snap (match &self (worker-snapshot $w $s) $s))
          ($z0 (open-hot-pool $ws $w))
          ($z1 (restore-snapshot $ws $snap))
          ($z2 (run-chamber-settle $ws $ch (worker-budget $w))))
     (emit-summary $w $ws)))
