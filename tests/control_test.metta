; ===========================================================================
; CONTROL-CLOSURE TEST — a causal-QA strategy that sustains its own activation, and the first
; loop here to satisfy every §4.5 condition we detect (TECAN T3 / Alg 5.5 step 2 / MSC eq 18-19).
; ---------------------------------------------------------------------------
; The substrate rules are gated on an internal `Primed` state, and three control rules feed a
; successful derivation back into it: ReasonFor -> Worked -> Habit -> Primed. Two rules sit
; OUTSIDE that ring — R_detect turns an arriving why-question into an attempt, R_explore spends
; the one-off `ex` exploration endowment to prime the strategy cold.
;
; Cycle 1 is the COLD START: no habit exists, so R_prime cannot fire and R_explore ignites the
; strategy, spending the whole ex endowment. Decay then forgets the derived layer but KEEPS the
; habit (the one persistent relation). From cycle 2 on, ex is gone and R_explore is silent, so
; `Primed` can only come from R_prime — the loop is the strategy's sole life support, and it
; keeps answering all three questions while earning more than it burns.
;
; Certification: the endo-component is exactly the 6-rule ring (the two food-intake rules peel
; out); it regenerates control motifs (Primed/Worked/Habit) AND a semantic one (ReasonFor), so
; closure is HYBRID; surplus is positive componentwise; ablating it drops the answers to 0; and
; it recurs across cycles 2 and 3. Finally the DEFERRED DEATH: ablate the single closing edge
; R_prime and cycle 1 still answers (ex ignites it) while cycle 2 collapses to 0.
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
!(import! &self "experiments/expt1-causal-qa/control-load.metta")
!(import! &self "petta/epoch.metta")
!(import! &self "petta/acs.metta")

; the chamber admits the control genome only, walked in priming-first order
!(test (chamber-rules CH_ctrl) (R_prime R_detect R_explore R_so_rf R_result_rf R_trans_rf R_worked R_learn))

; --- CYCLE 1, cold start: R_explore ignites the strategy out of the ex endowment ---------
!(bind! &wc (new-space))
!(copy-molecules &wc)
!(restore-snapshot &wc SNAP_ctrl)
!(set-cycle &wc 1)
!(run-chamber &wc CH_ctrl)
!(test (foldall + (match &wc (event 1 $s R_explore $k) 1) 0) 1)   ; the cold spin-up fires
!(test (foldall + (match &wc (event 1 $s R_prime $k) 1) 0) 0)     ; ...R_prime cannot: no habit yet
!(test (total-answers &wc) 3)                                     ; both questions answered
!(test (fuel-of &wc O_ctrl ex) 0)                                 ; the whole endowment is spent
!(test (foldall + (match &wc (sem-edge ctrlg (hb cause-strat) Habit $s) 1) 0) 1)   ; the habit consolidated
!(credit-all-questions &wc CL_ctrl)

; --- DECAY: the habit persists, the rest of the derived layer is forgotten ---------------
!(decay &wc)
!(test (foldall + (match &wc (sem-edge ctrlg (hb cause-strat) Habit $s) 1) 0) 1)   ; KEPT (persistent)
!(test (foldall + (match &wc (sem-edge ctrlg $i Primed $s) 1) 0) 0)                ; forgotten
!(test (foldall + (match &wc (sem-edge ctrlg $i Worked $s) 1) 0) 0)                ; forgotten
!(test (foldall + (match &wc (sem-edge V3g $i ReasonFor $x $y) 1) 0) 0)            ; forgotten
!(test (foldall + (match &wc (sem-edge ctrlg wq_v3q1 WhyQuestion $q) 1) 0) 1)      ; food is re-supplied

; --- CYCLE 2: ex is gone, so the habit is the only source of Primed --------------------
!(set-cycle &wc 2)
!(run-chamber &wc CH_ctrl)
!(test (foldall + (match &wc (event 2 $s R_explore $k) 1) 0) 0)   ; starved of ex — silent
!(test (foldall + (match &wc (event 2 $s R_prime $k) 1) 0) 1)     ; the habit re-primes instead
!(test (total-answers &wc) 3)                                     ; and the strategy still answers
!(credit-all-questions &wc CL_ctrl)

; --- CYCLE 3: the self-sustaining regime, earning more than it burns -------------------
!(decay &wc)
!(set-cycle &wc 3)
!(run-chamber &wc CH_ctrl)
!(test (total-answers &wc) 3)
!(credit-all-questions &wc CL_ctrl)
!(test (fuel-of &wc O_ctrl sm) 14)      ; sm grows (+1/cycle in the closed regime)
!(test (fuel-of &wc O_ctrl tr) 4)       ; tr grows (+1/cycle)

; --- §4.5 CERTIFICATION over the accumulated log ---------------------------------------
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

; condition 3 — metabolic surplus, positive componentwise (eq 19)
!(test (token-surplus &wc (acs-member-set &gc (fired-rules &wc)) CL_ctrl sm) 3)
!(test (token-surplus &wc (acs-member-set &gc (fired-rules &wc)) CL_ctrl tr) 1)

; condition 4 — causal influence: suppress the ring and the answers vanish
!(test (ablated-answers &ablc CH_ctrl SNAP_ctrl (acs-member-set &gc (fired-rules &wc))) 0)
!(test (causal-influence? &wc &ablc CH_ctrl SNAP_ctrl (acs-member-set &gc (fired-rules &wc))) True)

; recurrence — the whole ring closes in cycles 2 and 3 (cycle 1 lacks R_prime, the cold start)
!(test (recurrence-count &wc (acs-member-set &gc (fired-rules &wc))) 2)
!(test (recurrent? &wc (acs-member-set &gc (fired-rules &wc)) 2) True)

; --- DEFERRED DEATH: ablate the closing edge R_prime and the loop outlives its endowment by
; exactly one cycle — cycle 1 still answers (ex ignites it), cycle 2 has no source of Primed. ---
!(bind! &wk (new-space))
!(copy-molecules &wk)
!(restore-snapshot &wk SNAP_ctrl)
!(set-cycle &wk 1)
!(run-chamber-ablate &wk CH_ctrl (R_prime))
!(test (total-answers &wk) 3)          ; cycle 1 unaffected: the endowment still primes it
!(decay &wk)
!(set-cycle &wk 2)
!(run-chamber-ablate &wk CH_ctrl (R_prime))
!(test (total-answers &wk) 0)          ; cycle 2: nothing re-primes the strategy — it dies

; --- per-rule causal coding (SC §3) on this loop, measured over the OBSERVED WINDOW. Every
; member is measured the same way — suppress it, replay a run of the same length, diff the
; cumulative minted reward — so what distinguishes a control rule is not the code but the window:
; its product acts on the cycle AFTER the one that derives it. Over this log's three cycles all
; six members are load-bearing; the substrate members score 3x their per-cycle value (the loop
; keeps paying), and the three control members score 22 because suppressing any of them makes the
; loop flatline after the cold start (11 earned, then nothing). ---
!(test (window-of &wc) 3)                                                    ; the replay is as long as the run it certifies
!(test (member-do-influences &wc &ablc CH_ctrl SNAP_ctrl CL_ctrl (R_so_rf R_result_rf R_trans_rf)) ((R_so_rf 24) (R_result_rf 24) (R_trans_rf 15)))
!(test (member-do-influences &wc &ablc CH_ctrl SNAP_ctrl CL_ctrl (R_prime R_worked R_learn)) ((R_prime 22) (R_worked 22) (R_learn 22)))

; the WINDOW is doing the work, not a rule-kind check: the very same measurement over ONE cycle
; still reads 0 for R_prime, and turns nonzero as soon as it spans the decay boundary.
!(test (windowed-reward &ablc CH_ctrl SNAP_ctrl CL_ctrl 1 ()) 11)           ; 1-cycle baseline
!(test (windowed-reward &ablc CH_ctrl SNAP_ctrl CL_ctrl 1 (R_prime)) 11)    ; ...unchanged ⇒ delta 0
!(test (windowed-reward &ablc CH_ctrl SNAP_ctrl CL_ctrl 2 ()) 22)           ; 2-cycle baseline
!(test (windowed-reward &ablc CH_ctrl SNAP_ctrl CL_ctrl 2 (R_prime)) 11)    ; the loop flatlines ⇒ delta 11

; and the minimal ACS is now the WHOLE ring: over a one-cycle window the greedy pass would drop
; every control member and return a set that no longer closes.
!(test (msort (minimal-acs &wc &ablc CH_ctrl SNAP_ctrl CL_ctrl (acs-member-set &gc (fired-rules &wc))))
       (R_learn R_prime R_result_rf R_so_rf R_trans_rf R_worked))
