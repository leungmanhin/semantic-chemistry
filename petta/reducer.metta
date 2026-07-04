; ===========================================================================
; REDUCER — the reducer worker body (worker-kind `reducer`): a deterministic merge
; of the per-worker summaries across all workers into `(reduced …)` facts in &self.
; Only builtins. Dispatched by workers.metta. Facts-free.
; ===========================================================================

; reducer: deterministic merge of the per-worker summaries across all workers
(= (run-reduce $w)
   (let* (($tf (foldall + (match &self (worker-summary $cw firings $n) $n) 0))
          ($z1 (add-atom &self (reduced total-firings $tf)))
          ($ta (foldall + (match &self (worker-summary $cw2 answers $m) $m) 0)))
     (add-atom &self (reduced total-answers $ta))))
