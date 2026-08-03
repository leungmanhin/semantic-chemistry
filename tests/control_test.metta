; ===========================================================================
; CONTROL-CLOSURE TEST — a causal-QA strategy whose success re-activates it, closing a ring
; WITHIN one task (TECAN T3 / Alg 5.5 step 2 / MSC eq 18-19).
; ---------------------------------------------------------------------------
; The substrate rules are gated on an internal `Primed` state, and three control rules feed a
; successful derivation back into it: ReasonFor -> Worked -> Habit -> Primed. Two rules sit
; OUTSIDE that ring — R_detect turns the arriving why-question into an attempt, R_explore spends
; the one-off `ex` exploration endowment to prime the strategy cold.
;
; Because a task runs cycles until the chamber settles, the ring closes inside a single task —
; and because each epoch collects its candidates against the state as it stood when the epoch
; began, it turns ONE HOP PER CYCLE, so the log spells the strategy out in order: the question
; type is noticed, the ex endowment ignites the strategy, the gated cue-normalizers fire, the
; chainer answers and the success trace is laid down, the habit is consolidated, and only then
; does that habit re-prime the strategy — the closing edge, paid for by the loop's own product.
; The seventh cycle finds every product already present and fires nothing, which ends the task.
;
; ⚠️ WHAT THIS GENOME NO LONGER DOES is carry across arrivals. A task's working material retires
; with the task, so the habit goes with it, and `ex` is spent — the second arrival cannot be
; primed at all and goes unanswered. That is not a bug in the run loop; it is the hand-written
; control genome reaching its limit. Re-activating a strategy on a LATER task needs the memory to
; live somewhere that outlives the task's pool — the event log is the natural home, since it
; already rides with the soma — and that is the emergent-control rework, not this test.
;
; Run:  sh ../PeTTa/run.sh tests/control_test.metta < /dev/null 2>&1 | grep should
; ===========================================================================
!(import! &self "petta/util.metta")
!(import! &self "petta/fuel.metta")
!(import! &self "petta/compiler.metta")
!(import! &self "petta/gate.metta")
!(import! &self "petta/reaction.metta")
!(import! &self "petta/grounder.metta")
!(import! &self "petta/evaluator.metta")
!(import! &self "petta/worker.metta")
!(import! &self "petta/epoch.metta")
!(import! &self "petta/acs.metta")
!(import! &self "experiments/expt1-causal-qa/control-load.metta")

; the chamber admits the control genome only, walked in priming-first order
!(test (chamber-rules CH_ctrl) (R_prime R_detect R_explore R_so_rf R_result_rf R_trans_rf R_worked R_learn))

; --- ONE TASK, worked until the chamber settles ----------------------------------------
!(bind! &wc (new-space))
!(restore-snapshot &wc SNAP_ctrl)
!(test (run-task &wc CH_ctrl CL_ctrl V3 1 9) 2)          ; the arriving question is answered

; the ring turns ONE HOP PER CYCLE, because each epoch's candidates are collected against the
; state as it stood when the epoch began — so the log spells the strategy out in order
!(test (collapse (match &wc (event 1 $s $r $k) $r)) (R_detect))            ; the question type is noticed
!(test (collapse (match &wc (event 2 $s $r $k) $r)) (R_explore))           ; the ex endowment ignites it
!(test (collapse (match &wc (event 3 $s $r $k) $r)) (R_so_rf R_result_rf)) ; the gated cue-normalizers
!(test (collapse (match &wc (event 4 $s $r $k) $r)) (R_trans_rf R_worked)) ; chained, and it worked
!(test (collapse (match &wc (event 5 $s $r $k) $r)) (R_learn))             ; the habit is consolidated
!(test (foldall + (match &wc (event 1 $s R_prime $k) 1) 0) 0)              ; no habit to prime from yet

; cycle 6 — THE CLOSING EDGE: the habit the loop's own success laid down re-primes the strategy
!(test (collapse (match &wc (event 6 $s $r $k) $r)) (R_prime))

; cycle 7 — settled: every product present, nothing fires, the task ends
!(test (cycle-firings &wc 7) 0)
!(test (cycles-of-task &wc V3) (1 2 3 4 5 6 7))

!(test (fuel-of &wc O_ctrl ex) 0)                        ; the whole endowment is spent
!(test (fuel-of &wc O_ctrl sm) 11)                       ; 12 − 7 fired + 6 minted
!(test (fuel-of &wc O_ctrl tr) 2)                        ; 1 − 1 + 2

; --- §4.5 CERTIFICATION over the task's log --------------------------------------------
!(bind! &gc (new-space))
!(build-graph &gc (fired-rules &wc))
!(bind! &ablc (new-space))

; membership = the closed ring; the two food-intake rules are outside it
!(test (msort (acs-member-set &gc (fired-rules &wc))) (R_learn R_prime R_result_rf R_so_rf R_trans_rf R_worked))
!(test (in-list? R_detect (acs-member-set &gc (fired-rules &wc))) False)    ; consumes food only
!(test (in-list? R_explore (acs-member-set &gc (fired-rules &wc))) False)   ; fed by R_detect, outside

; condition 1 — structural closure, at the HYBRID level: the ring regenerates control motifs
; (Primed/Worked/Habit) and a semantic one (ReasonFor)
!(test (msort (closure-rels (acs-member-set &gc (fired-rules &wc)))) (Habit Primed ReasonFor Worked))
!(test (structurally-closed? (acs-member-set &gc (fired-rules &wc))) True)
!(test (closure-kind (acs-member-set &gc (fired-rules &wc))) hybrid)
!(test (closure-facts A_ctrl (acs-member-set &gc (fired-rules &wc))) ((acs-closure A_ctrl hybrid)))

; condition 2 — autocatalysis
!(test (autocatalytic? &gc (acs-member-set &gc (fired-rules &wc))) True)

; condition 4 — causal influence: suppress the ring and the task goes unanswered
!(test (ablated-answers &ablc CH_ctrl SNAP_ctrl V3 (acs-member-set &gc (fired-rules &wc))) 0)
!(test (causal-influence? &wc &ablc CH_ctrl SNAP_ctrl (acs-member-set &gc (fired-rules &wc))) True)

; RECURRENCE — counted across TASKS. The ring turns for this one, which is a structural
; CANDIDATE; a second turn needs a second arrival the strategy can still act on.
!(test (loop-in-task? &wc (acs-member-set &gc (fired-rules &wc)) V3) True)
!(test (recurrence-count &wc (acs-member-set &gc (fired-rules &wc))) 1)
!(test (recurrent? &wc (acs-member-set &gc (fired-rules &wc)) 2) False)

; --- THE LIMIT: a second arrival cannot be primed --------------------------------------
; The habit retired with task 1's pool and `ex` is spent, so R_explore is silent, R_prime has
; nothing to read, and the gated substrate rules never fire. The strategy is solvent — it simply
; has no way to reach itself across the boundary.
!(test (run-task &wc CH_ctrl CL_ctrl V4 8 9) 0)
!(test (foldall + (match &wc (event 8 $s R_explore $k) 1) 0) 0)   ; no endowment left
!(test (foldall + (match &wc (event 8 $s R_prime $k) 1) 0) 0)     ; nothing to prime from
!(test (foldall + (match &wc (event 8 $s R_so_rf $k) 1) 0) 0)     ; so the gated rules stay shut
!(test (foldall + (match &wc (event 8 $s R_detect $k) 1) 0) 1)    ; only the food intake fires
!(test (> (fuel-of &wc O_ctrl sm) 0) True)                        ; not dead — just unreachable
!(test (log-tasks &wc) (V3 V4))

; --- ORDER-INDEPENDENCE, now a property of the engine rather than of the rule order. Each
; epoch collects its candidates against the state as it stood when the epoch began, so nothing in
; a queue was enabled by anything else in it and enumeration order cannot decide what fires. Run
; in REVERSE priority order the ring closes exactly as before. ---
!(bind! &wo (new-space))
!(set-task &wo V3)
!(set-cycle &wo 1)
!(copy-molecules &wo)
!(restore-snapshot &wo SNAP_ctrl)
!(test (rev-list (chamber-rules CH_ctrl)) (R_learn R_worked R_trans_rf R_result_rf R_so_rf R_explore R_detect R_prime))
!(express &wo)
!(settle-from &wo (rev-list (chamber-rules CH_ctrl)) 0 none)
!(test (total-answers &wo) 2)
!(test (foldall + (match &wo (event 1 $s R_prime $k) 1) 0) 1)     ; fires though enumerated LAST
