; ===========================================================================
; COLLECT-FIRE CONTROL TEST — the control ring under TECAN Alg 5.1's execution model.
; ---------------------------------------------------------------------------
; The deepest chain we run, and the one the retiming shows on most clearly. Under the
; cascade the whole ring turns inside three cycles, because each firing's products are
; visible to the rules walked after it. Under collect-then-fire the queue is assembled
; against the epoch-start state, so the ring unfolds ONE HOP PER CYCLE and its shape becomes
; visible in the log: the arriving question is detected, exploration primes the strategy, the
; gated cue-normalizers fire, the chainer answers and the success trace is laid down, the
; habit is learned, and only then does the habit re-prime the strategy and close the loop.
; Seven cycles instead of three — and nothing else moves. The purses land on the same
; figures, and every §4.5 verdict the detector emits is the cascade's, because the detector
; counts per TASK and the task simply runs until its chamber settles.
;
; Run:  sh ../PeTTa/run.sh tests/collect_fire_ctrl_test.metta < /dev/null 2>&1 | grep should
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

!(add-atom &self (execution-model collect-then-fire))
!(test (exec-model) collect-then-fire)

; --- ONE ARRIVAL: the ring turns, a hop at a time ---------------------------------------
!(bind! &wc (new-space))
!(restore-snapshot &wc SNAP_ctrl)
!(test (run-task &wc CH_ctrl CL_ctrl V3 1 9) 2)          ; the arriving question is answered
!(test (cycles-of-task &wc V3) (1 2 3 4 5 6 7))          ; seven cycles where the cascade took three
!(test (collapse (match &wc (event 1 $s $r $k) $r)) (R_detect))       ; the question type is noticed
!(test (collapse (match &wc (event 2 $s $r $k) $r)) (R_explore))      ; the subsidy primes the strategy
!(test (collapse (match &wc (event 3 $s $r $k) $r)) (R_so_rf R_result_rf))  ; the gated cue-normalizers
!(test (collapse (match &wc (event 4 $s $r $k) $r)) (R_trans_rf R_worked))  ; chained, and it worked
!(test (collapse (match &wc (event 5 $s $r $k) $r)) (R_learn))        ; the habit is consolidated
!(test (collapse (match &wc (event 6 $s $r $k) $r)) (R_prime))        ; ...and re-primes the strategy
!(test (cycle-firings &wc 7) 0)                                       ; settled

; the purses land exactly where the cascade leaves them — the same work, spread out
!(test (fuel-of &wc O_ctrl ex) 0)                        ; the whole endowment is spent
!(test (fuel-of &wc O_ctrl sm) 11)                       ; 12 − 7 fired + 6 minted
!(test (fuel-of &wc O_ctrl tr) 2)                        ; 1 − 1 + 2

; --- EVERY §4.5 VERDICT IS UNCHANGED ----------------------------------------------------
!(bind! &gc (new-space))
!(build-graph &gc (fired-rules &wc))
!(bind! &ablc (new-space))
!(test (msort (acs-member-set &gc (fired-rules &wc))) (R_learn R_prime R_result_rf R_so_rf R_trans_rf R_worked))
!(test (in-list? R_detect (acs-member-set &gc (fired-rules &wc))) False)   ; consumes food only
!(test (msort (closure-rels (acs-member-set &gc (fired-rules &wc)))) (Habit Primed ReasonFor Worked))
!(test (structurally-closed? (acs-member-set &gc (fired-rules &wc))) True)
!(test (closure-kind (acs-member-set &gc (fired-rules &wc))) hybrid)
!(test (autocatalytic? &gc (acs-member-set &gc (fired-rules &wc))) True)
!(test (ablated-answers &ablc CH_ctrl SNAP_ctrl V3 (acs-member-set &gc (fired-rules &wc))) 0)
!(test (causal-influence? &wc &ablc CH_ctrl SNAP_ctrl (acs-member-set &gc (fired-rules &wc))) True)
!(test (loop-in-task? &wc (acs-member-set &gc (fired-rules &wc)) V3) True)  ; the turn spans six cycles
!(test (recurrence-count &wc (acs-member-set &gc (fired-rules &wc))) 1)     ; ...and counts as one
!(test (recurrent? &wc (acs-member-set &gc (fired-rules &wc)) 2) False)     ; one arrival is no record

; --- THE SECOND ARRIVAL still cannot be reached: the endowment funded exactly one ignition,
; and the habit retired with the first task's pool ---------------------------------------
!(test (run-task &wc CH_ctrl CL_ctrl V4 8 9) 0)
!(test (foldall + (match &wc (event 8 $s R_detect $k) 1) 0) 1)    ; only the food intake fires
!(test (foldall + (match &wc (event 8 $s R_explore $k) 1) 0) 0)   ; no endowment left
!(test (foldall + (match &wc (event 8 $s R_prime $k) 1) 0) 0)     ; nothing to prime from
!(test (> (fuel-of &wc O_ctrl sm) 0) True)                        ; not dead — just unreachable
!(test (log-tasks &wc) (V3 V4))
