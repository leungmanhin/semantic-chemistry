; ===========================================================================
; COLLECT-THEN-FIRE TEST — TECAN Alg 5.1's execution model, and the retiming it causes.
; ---------------------------------------------------------------------------
; The engine is chosen by `(execution-model M)` in &self. Undeclared means `cascade`, the
; within-cycle priority walk, so nothing else in the suite moves. Declaring
; `collect-then-fire` assembles the whole candidate queue against the EPOCH-START state
; before anything fires (Alg 5.1 lines 3-10 complete before line 16), so a rule enabled only
; by this cycle's products is not in the queue and A CHAIN ADVANCES ONE HOP PER CYCLE.
; On V3 that splits one cascade cycle into two: R_so + R_result derive the base ReasonFor
; edges, and only the NEXT cycle can chain them, so the answer count goes 1 -> 2 where the
; cascade reached 2 at once. Nothing else changes — the TASK absorbs the retiming, because a
; task runs until the chamber settles rather than for a fixed number of cycles. Same answers,
; same purses, one more cycle; and the ACS detector, which counts per task, returns every
; verdict unchanged, down to the leave-one-out do-influence numbers.
; Fire order here is `rule-priority`, a PLACEHOLDER: Alg 5.1 pops best-first keyed by
; TECANScore, which is unbuilt, and priority is a topological sort rather than a value
; judgement. It is deterministic, and immaterial while fuel covers every candidate.
;
; Run:  sh ../PeTTa/run.sh tests/collect_fire_test.metta < /dev/null 2>&1 | grep should
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
!(import! &self "petta/acs.metta")
!(import! &self "petta/ctrl_scaffold.metta")
!(import! &self "petta/dispatch.metta")

; --- THE CASCADE, for contrast: one cycle runs the whole chain, because each firing's
; products are visible to the rules walked after it ------------------------------------
!(test (exec-model) cascade)                       ; undeclared = the current engine
!(bind! &wc (new-space))
!(set-task &wc V3)
!(copy-molecules &wc)
!(restore-snapshot &wc SNAP_qa)
!(set-cycle &wc 1)
!(run-chamber &wc CH_expt1)
!(test (collapse (match &wc (event 1 $s $r $k) $r)) (R_so R_result R_trans))
!(test (total-answers &wc) 2)                      ; both answers, in cycle 1

; --- SWITCH to Alg 5.1 ------------------------------------------------------------------
!(add-atom &self (execution-model collect-then-fire))
!(test (exec-model) collect-then-fire)

; --- the QUEUE is assembled against the state as it stands, so R_trans — which has no
; ReasonFor edge to chain yet — is not in it. One cycle later it is the only entry. ------
!(bind! &wq (new-space))
!(set-task &wq V3)
!(copy-molecules &wq)
!(restore-snapshot &wq SNAP_qa)
!(set-cycle &wq 1)
!(express &wq)
!(test (len (collect-rules &wq (chamber-rules CH_expt1))) 2)     ; R_so + R_result only
!(run-chamber &wq CH_expt1)
!(set-cycle &wq 2)
!(test (len (collect-rules &wq (chamber-rules CH_expt1))) 1)     ; now R_trans, and only it

; --- ONE HOP PER CYCLE: the chain that ran in a single cascade cycle now takes two, and the
; answer count climbs 1 -> 2 as it goes -------------------------------------------------
!(bind! &wf (new-space))
!(set-task &wf V3)
!(copy-molecules &wf)
!(restore-snapshot &wf SNAP_qa)
!(set-cycle &wf 1)
!(run-chamber &wf CH_expt1)
!(test (collapse (match &wf (event 1 $s $r $k) $r)) (R_so R_result))   ; the chainer is absent
!(test (total-answers &wf) 1)                                          ; the one-hop answer
!(set-cycle &wf 2)
!(run-chamber &wf CH_expt1)
!(test (collapse (match &wf (event 2 $s $r $k) $r)) (R_trans))         ; now it can chain
!(test (total-answers &wf) 2)
!(set-cycle &wf 3)
!(run-chamber &wf CH_expt1)
!(test (cycle-firings &wf 3) 0)                                        ; settled

; --- THE TASK ABSORBS THE RETIMING. A task runs until its chamber settles, so it simply
; takes one more cycle; the answers and the purses are the cascade's exactly. ------------
!(bind! &wt (new-space))
!(add-atom &wt (fuel O_base sm 6))
!(add-atom &wt (fuel O_base dq 1))
!(add-atom &wt (fuel O_chain sm 4))
!(add-atom &wt (fuel O_chain dq 1))
!(add-atom &wt (fuel O_chain tr 1))
!(test (run-tasks &wt CH_expt1 CL_deep (V3 V4 V5) 1 9) (2 2 2))
!(test (cycles-of-task &wt V3) (1 2 3))            ; three cycles where the cascade took two
!(test (cycles-of-task &wt V4) (4 5 6))            ; and the next task starts after them
!(test (cycles-of-task &wt V5) (7 8 9))
!(test (fuel-of &wt O_base sm) 6)                  ; breaks even on each arrival, as before
!(test (fuel-of &wt O_chain tr) 4)                 ; and tr still grows +1 per arrival

; --- THE EPOCH BUDGET B (Alg 5.1 line 12, b < B): the queue stops being popped at the
; step bound, so only the first entry fires -----------------------------------------------
!(bind! &wb (new-space))
!(set-task &wb V3)
!(copy-molecules &wb)
!(restore-snapshot &wb SNAP_qa)
!(set-cycle &wb 1)
!(test (run-chamber-b &wb CH_expt1 1) 1)
!(test (collapse (match &wb (event 1 $s $r $k) $r)) (R_so))

; --- AN ENTRY WHOSE RE-CHECK FAILS IS DROPPED, NOT HALTED ON (Alg 5.1 line 14). The queue
; is mixed-rule and mixed-organism, so a later entry may be independent of what the earlier
; one exhausted: here the first entry spends O_chain's last tr, the second needs tr and falls
; away, and O_base's affordable work still fires behind it. The cascade, walking one rule at
; a time, halts that rule instead. ------------------------------------------------------
!(bind! &wd (new-space))
!(add-atom &wd (fuel O_chain tr 1))
!(add-atom &wd (fuel O_chain sm 2))
!(add-atom &wd (fuel O_base sm 2))
!(set-cycle &wd 1)
!(test (fire-queue &wd ((qcand R_trans O_chain k1 ((tr 1) (sm 1)) ((sem-edge G x1 ReasonFor a c)))
                        (qcand R_trans O_chain k2 ((tr 1) (sm 1)) ((sem-edge G x2 ReasonFor a d)))
                        (qcand R_so O_base k3 ((sm 1)) ((sem-edge G x3 ReasonFor a e))))
                       0 none)
       2)                                                    ; two of the three fired
!(test (collapse (match &wd (event 1 $s $r $k) ($s $r $k))) ((0 R_trans k1) (1 R_so k3)))
!(test (present? &wd (sem-edge G x2 ReasonFor a d)) False)    ; the dropped entry left nothing
!(test (fuel-of &wd O_chain tr) 0)
!(test (fuel-of &wd O_base sm) 1)                            ; and was not billed for it

; --- the SETTLE GUARD holds at fire time too: two producers of the same product can both be
; collected, and the second finds it present and pays nothing ---------------------------
!(bind! &wdup (new-space))
!(add-atom &wdup (fuel O_base sm 4))
!(set-cycle &wdup 1)
!(test (fire-queue &wdup ((qcand R_so O_base kA ((sm 1)) ((sem-edge G y1 ReasonFor a b)))
                          (qcand R_result O_base kB ((sm 1)) ((sem-edge G y1 ReasonFor a b))))
                         0 none)
       1)
!(test (fuel-of &wdup O_base sm) 3)                          ; charged once, not twice

; --- THE DETECTOR IS UNCHANGED. Everything it reads is scoped to the TASK, which is what
; makes the retiming invisible to it: the turn now spans three cycles instead of two, and
; `spend-cycles` / `loop-in-task?` union over all of them either way. -------------------
!(bind! &ws (new-space))
!(add-atom &ws (fuel O_base sm 10))
!(add-atom &ws (fuel O_base dq 1))
!(add-atom &ws (fuel O_chain sm 10))
!(add-atom &ws (fuel O_chain dq 1))
!(add-atom &ws (fuel O_chain tr 1))
!(test (run-task &ws CH_expt1 CL_deep V3 1 9) 2)
!(bind! &g (new-space))
!(bind! &abl (new-space))
!(build-graph &g (fired-rules &ws))
!(test (msort (acs-members &g (fired-rules &ws))) (R_result R_so R_trans))
!(test (structurally-closed? (acs-members &g (fired-rules &ws))) False)   ; still food-fed
!(test (rule-firings &ws R_so) 1)                                        ; spend counted per task
!(test (rule-firings &ws R_trans) 1)                                     ; ...including cycle 2
!(test (token-surplus &ws (acs-members &g (fired-rules &ws)) CL_deep sm) 1)
!(test (token-surplus &ws (acs-members &g (fired-rules &ws)) CL_deep tr) 1)
!(test (ablated-answers &abl CH_expt1 SNAP_qa V3 (acs-members &g (fired-rules &ws))) 0)
!(test (causal-influence? &ws &abl CH_expt1 SNAP_qa (acs-members &g (fired-rules &ws))) True)

; the leave-one-out numbers are the sharpest check, because the replay has to be given the
; same number of cycles as the run it is paired against: a replay cut off after one cycle
; never reaches the chain, and every member's contribution collapses towards zero
!(test (member-do-influences &ws &abl CH_expt1 SNAP_qa CL_deep (R_so R_result R_trans))
       ((R_so 4) (R_result 6) (R_trans 4)))
!(test (minimal-acs &ws &abl CH_expt1 SNAP_qa CL_deep (R_so R_result R_trans)) (R_so R_result R_trans))
!(test (replay-cycles) 20)                          ; the replay's runaway guard, not a dial

; recurrence still counts TASKS, so a three-arrival stream is a three-turn track record
!(bind! &wr (new-space))
!(add-atom &wr (fuel O_base sm 20))
!(add-atom &wr (fuel O_base dq 1))
!(add-atom &wr (fuel O_chain sm 20))
!(add-atom &wr (fuel O_chain dq 1))
!(add-atom &wr (fuel O_chain tr 1))
!(test (run-tasks &wr CH_expt1 CL_deep (V3 V4 V5) 1 9) (2 2 2))
!(bind! &gr (new-space))
!(build-graph &gr (fired-rules &wr))
!(test (recurrence-count &wr (acs-members &gr (fired-rules &wr))) 3)
!(test (recurrent? &wr (acs-members &gr (fired-rules &wr)) (recurrence-min)) True)

; --- AND SO IS THE SCAFFOLD ARC: the same open-but-recurring chain is detected, wrapped at
; the parents' expense, and the offspring's generated ring certifies exactly as before ---
!(bind! &gd (new-space))
!(bind! &ad (new-space))
!(build-graph &gd (fired-rules &wr))
!(add-all &self (acs-verdicts A_qa &gd &wr &ad CH_expt1 SNAP_qa CL_deep))
!(test (scaffoldable? A_qa) True)
!(bind! &wrich (new-space))
!(add-atom &wrich (fuel O_base sm 30))
!(add-atom &wrich (fuel O_base tr 5))
!(add-atom &wrich (fuel O_base dq 5))
!(add-atom &wrich (fuel O_chain sm 30))
!(add-atom &wrich (fuel O_chain tr 5))
!(add-atom &wrich (fuel O_chain dq 5))
!(add-atom &self (worker W_cs))
!(add-atom &self (worker-kind W_cs ctrl-scaffold))
!(add-atom &self (worker-space W_cs &wrich))
!(add-atom &self (worker-acs W_cs A_qa))
!(add-atom &self (worker-chamber W_cs CH_scaffold))
!(test (dispatch W_cs) scaffolded)
!(test (fuel-of &wrich O_base sm) 20)                        ; the 2:1 split is unchanged
!(test (fuel-of &wrich O_chain sm) 25)

; the generated ring turns once per arrival, one hop at a time
!(test (run-tasks &wrich CH_scaffold CL_deep (V3 V4) 1 9) (2 2))
!(test (foldall + (match &wrich (event 1 $s (recall (strat A_qa)) $k) 1) 0) 1)
!(test (len (dedup (collapse (match &wrich (event $c $s (prime (strat A_qa)) $k) $c)))) 2)
!(bind! &gw (new-space))
!(bind! &aw (new-space))
!(build-graph &gw (fired-rules &wrich))
!(test (msort (acs-member-set &gw (fired-rules &wrich)))
       ((gated R_result (strat A_qa)) (gated R_so (strat A_qa)) (gated R_trans (strat A_qa))
        (learn (strat A_qa)) (prime (strat A_qa)) (worked R_trans (strat A_qa))))
!(test (structurally-closed? (acs-member-set &gw (fired-rules &wrich))) True)
!(test (closure-kind (acs-member-set &gw (fired-rules &wrich))) hybrid)
!(test (autocatalytic? &gw (acs-member-set &gw (fired-rules &wrich))) True)
!(test (recurrence-count &wrich (acs-member-set &gw (fired-rules &wrich))) 2)
!(add-atom &self (snapshot-fuel SNAP_wrap (org (strat A_qa)) sm 12))
!(add-atom &self (snapshot-fuel SNAP_wrap (org (strat A_qa)) tr 3))
!(add-atom &self (snapshot-fuel SNAP_wrap (org (strat A_qa)) dq 3))
!(test (ablated-answers &aw CH_scaffold SNAP_wrap V4 (acs-member-set &gw (fired-rules &wrich))) 0)
!(test (causal-influence? &wrich &aw CH_scaffold SNAP_wrap (acs-member-set &gw (fired-rules &wrich))) True)
