; ===========================================================================
; CHAMBER — the CONTEXT-CHAMBER worker body.
; `run-cc` runs a bounded, isolated unit of chamber DERIVATION: own hot-pool space ->
; materialize the molecules (the shared envelope in `worker.metta`) -> restore snapshot
; fuel -> run the chamber's admitted rules on it, bounded by the worker's step budget ->
; emit the summary. Deriving only; minting (the ecan-epoch kind) is a separate body.
; Dispatched by `dispatch.metta`. Assumes util + fuel + reaction + worker (the envelope)
; are loaded.
; ===========================================================================

; the context-chamber worker body: own space -> hot pool -> restore fuel -> run-chamber-b
; (bounded by worker-budget-steps) -> emit-summary
(= (run-cc $w)
   (let* (($ws (match &self (worker-space $w $sp) $sp))
          ($ch (match &self (worker-chamber $w $c) $c))
          ($snap (match &self (worker-snapshot $w $s) $s))
          ($z0 (copy-molecules $ws))
          ($z1 (restore-snapshot $ws $snap))
          ($z2 (run-chamber-b $ws $ch (worker-budget $w))))
     (emit-summary $w $ws)))
