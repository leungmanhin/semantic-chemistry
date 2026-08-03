; ===========================================================================
; CHAMBER — the CONTEXT-CHAMBER worker body.
; `run-cc` runs a bounded, isolated unit of chamber DERIVATION: own hot-pool space -> pose the
; worker's task and materialize that task's text (the shared envelope in `worker.metta`) ->
; restore snapshot fuel -> WORK THE TASK (`epoch.metta`'s `work-task`: cycles until the chamber
; settles, within the worker's cycle allowance and step budget) -> emit the summary. The worker
; is the doc's §6.4 unit of chamber computation; working a task is the loop underneath it, and
; there is only one such loop — the detector's paired counterfactual runs its twin. Running to
; settle rather than for one epoch is what makes the worker a unit of useful WORK: one epoch
; advances a chain a single hop, so a one-epoch worker would hand the next stage a half-derived
; pool. Deriving only; minting (the ecan-epoch kind) is a separate body.
; Dispatched by `dispatch.metta`. Assumes util + fuel + reaction + worker (the envelope)
; are loaded.
; ===========================================================================

; the context-chamber worker body: own space -> hot pool -> restore fuel -> work the task to
; settle (bounded by worker-cycles + worker-budget-steps) -> emit-summary
(= (run-cc $w)
   (let* (($ws (match &self (worker-space $w $sp) $sp))
          ($ch (match &self (worker-chamber $w $c) $c))
          ($snap (match &self (worker-snapshot $w $s) $s))
          ($z0 (open-hot-pool $ws $w))
          ($z1 (restore-snapshot $ws $snap))
          ($z2 (work-task $ws $ch (next-cycle $ws) (worker-cycles-of $w) (worker-budget $w))))
     (emit-summary $w $ws)))
