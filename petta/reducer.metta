; ===========================================================================
; REDUCER — the reducer worker body (worker-kind `reducer`): a deterministic merge of the
; per-worker summaries across a par-group into `(reduced …)` facts in &self. A
; synchronization boundary (MSC §6.4) — the fan-in over independent, isolated worker runs.
; Re-run-safe: the reduced fact is REPLACED, not stacked, so it always reflects the current
; summaries. Assumes util loaded; the worker summaries are already in &self (emit-summary).
; ===========================================================================

; the firings worker $w reported (0 if it emitted none)
(= (worker-firings-of $w)
   (case (collapse (match &self (worker-firings $w $n) $n)) ((() 0) ($ns (car-atom $ns)))))

; the total firings across par-group $pg's member workers
(= (group-firings $pg)
   (foldall + (match &self (par-member $pg $w) (worker-firings-of $w)) 0))

; drop the current (reduced total-firings $pg …) fact (re-run-safety). The value is let*-
; bound before remove-atom, which takes its atom UNEVALUATED (a bare (car-atom …) there
; would never match, looping forever).
(= (clear-reduced $pg)
   (case (collapse (match &self (reduced total-firings $pg $x) $x))
         ((() done)
          ($vs (let* (($h (car-atom $vs))
                      ($z (remove-atom &self (reduced total-firings $pg $h))))
                 (clear-reduced $pg))))))

; reducer worker body: merge par-group PG's per-worker firings into (reduced total-firings
; PG N), replacing any prior value
(= (run-reduce $w)
   (let* (($pg (match &self (worker-group $w $g) $g))
          ($z0 (clear-reduced $pg))
          ($tf (group-firings $pg)))
     (add-atom &self (reduced total-firings $pg $tf))))
