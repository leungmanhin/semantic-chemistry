; ===========================================================================
; REDUCER — the reducer worker body (worker-kind `reducer`): a deterministic merge
; of the per-worker summaries across all workers into `(reduced …)` facts in &self.
; Re-run-safe: each key's fact is REPLACED, not stacked, so (reduced …) always
; reflects the current summary set. Only builtins. Dispatched by workers.metta.
; ===========================================================================

; drop every (reduced $k …) fact for key $k
(= (clear-reduced $k)
   (case (collapse (match &self (reduced $k $x) $x))
         ((() done)
          ($vs (let* (($h (car-atom $vs))
                      ($z (remove-atom &self (reduced $k $h))))
                     (clear-reduced $k))))))

; set (reduced $k $v), replacing any previous value for $k
(= (set-reduced $k $v)
   (let $z (clear-reduced $k)
        (add-atom &self (reduced $k $v))))

; reducer: deterministic merge of the per-worker summaries across all workers
(= (run-reduce $w)
   (let* (($tf (foldall + (match &self (worker-summary $cw firings $n) $n) 0))
          ($z1 (set-reduced total-firings $tf))
          ($ta (foldall + (match &self (worker-summary $cw2 answers $m) $m) 0)))
     (set-reduced total-answers $ta)))
