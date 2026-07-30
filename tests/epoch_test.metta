; ===========================================================================
; EPOCH TEST — working a task, and the typed-starvation death across a stream of them.
; ---------------------------------------------------------------------------
; A task arrives, its text lands in a FRESH hot pool, and the chamber runs cycles until it
; SETTLES (a whole cycle fires nothing more). Products persist across the cycles of one task —
; a chain needs its intermediates alive when the cycle that consumes them runs — and a rule
; whose products are already present does not re-fire, so a settled task stops spending.
; What crosses a task boundary is what MSC eq 8 puts in the organism: the purse F and the log L
; ride with the soma; the hot pool X turns over.
; Two mortal organisms: O_base {R_so,R_result} (cost sm), O_chain {R_trans} (cost sm + tr).
; Under CL_shallow O_chain earns no tr, so by the time the second task arrives it can no longer
; chain and the ROOT answer is gone (2 -> 1) — death by starvation of one token type, now shown
; on genuinely new work rather than on the same question re-asked. Under CL_deep the chain pays
; for itself and every arrival gets both answers.
;
; Run:  sh ../PeTTa/run.sh tests/epoch_test.metta < /dev/null 2>&1 | grep should
; ===========================================================================
!(import! &self "petta/util.metta")
!(import! &self "petta/fuel.metta")
!(import! &self "petta/compiler.metta")
!(import! &self "petta/gate.metta")
!(import! &self "petta/reaction.metta")
!(import! &self "petta/grounder.metta")
!(import! &self "petta/evaluator.metta")
!(import! &self "petta/worker.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")
!(import! &self "petta/epoch.metta")

; --- REFRESH-POOL clears the working material and nothing else -------------------------
!(bind! &wr (new-space))
!(set-task &wr V3)
!(copy-molecules &wr)
!(add-atom &wr (fuel O_base sm 6))
!(set-cycle &wr 1)
!(run-chamber &wr CH_expt1)
!(test (foldall + (match &wr (sem-edge V3g $e ReasonFor $x $y) 1) 0) 2)   ; derived layer present
!(refresh-pool &wr)
!(test (foldall + (match &wr (sem-edge V3g $e ReasonFor $x $y) 1) 0) 0)   ; derived: gone
!(test (foldall + (match &wr (sem-edge V3g v3_conn1 So $x $y) 1) 0) 0)    ; the task's TEXT: gone too
!(test (foldall + (match &wr (event $c $s $r $k) 1) 0) 2)                 ; the log RIDES with the soma
!(test (fuel-of &wr O_base sm) 4)                                        ; ...and so does the purse

; --- WORKING one task: cycles run until the chamber settles ----------------------------
; Products persist across the cycles of the task, and a rule whose products are already present
; does not re-fire — so cycle 2 costs nothing and the task is done.
!(bind! &wk (new-space))
!(set-task &wk V3)
!(copy-molecules &wk)
!(add-atom &wk (fuel O_base sm 6))
!(add-atom &wk (fuel O_chain sm 4))
!(add-atom &wk (fuel O_chain tr 1))
!(test (work-task &wk CH_expt1 CL_deep 1 9) 2)     ; settles with both answers
!(test (log-cycles &wk) (1))                       ; only cycle 1 logged a firing...
!(test (cycles-of-task &wk V3) (1 2))              ; ...though cycle 2 ran and found nothing to do
!(test (fuel-of &wk O_base sm) 4)                  ; spent once, not once per cycle
!(test (fuel-of &wk O_chain tr) 0)

; --- THE TASK STREAM: each arrival brings its own text into a fresh pool ----------------
; CL_shallow: O_chain earns no tr, so the second arrival cannot be chained (2 -> 1).
!(bind! &wst (new-space))
!(add-atom &wst (fuel O_base sm 6))
!(add-atom &wst (fuel O_chain sm 4))
!(add-atom &wst (fuel O_chain tr 1))
!(test (run-tasks &wst CH_expt1 CL_shallow (V3 V4) 1 9) (2 1))
!(test (fuel-of &wst O_chain tr) 0)           ; never replenished under the shallow clamp
!(test (fuel-of &wst O_base sm) 6)            ; O_base breaks even on EACH arrival — spend is
                                              ; per task now, not per text ever seen
!(test (current-task &wst) V4)                ; the last arrival is still posed
!(test (log-tasks &wst) (V3 V4))              ; the log is dated by task, not just by cycle
!(test (cycles-of-task &wst V3) (1 2))
!(test (cycles-of-task &wst V4) (3 4))
; the retired task's text is gone from the pool, but its firings stay in the log
!(test (foldall + (match &wst (sem-edge V3g v3_conn1 So $x $y) 1) 0) 0)
!(test (foldall + (match &wst (event 1 $s R_so $k) 1) 0) 1)

; CL_deep: the chain funds itself, so every arrival gets both answers.
!(bind! &wdt (new-space))
!(add-atom &wdt (fuel O_base sm 6))
!(add-atom &wdt (fuel O_chain sm 4))
!(add-atom &wdt (fuel O_chain tr 1))
!(test (run-tasks &wdt CH_expt1 CL_deep (V3 V4 V5) 1 9) (2 2 2))
!(test (fuel-of &wdt O_chain tr) 4)           ; tr grows: +1 per arrival (income 2 − draw 1)
!(test (fuel-of &wdt O_base sm) 6)            ; and O_base holds steady across all three

; retiring the stream leaves nothing posed, so the scoping falls back to the whole corpus
!(retire-task &wdt)
!(test (current-task &wdt) all)
!(test (msort (posed-questions &wdt)) (V3_q1 V4_q1 V5_q1))
