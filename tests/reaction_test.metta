; ===========================================================================
; REACTION TEST — the firing engine: TECAN Alg 5.1 collect-then-fire.
; ---------------------------------------------------------------------------
; The candidate queue is assembled in FULL against the epoch-start state before anything
; fires (Alg 5.1 lines 3-10 complete before line 16), so nothing in a queue was enabled by
; anything else in it and A CHAIN ADVANCES ONE HOP PER CYCLE. That makes one chamber run one
; EPOCH rather than a finished derivation: on V3, R_so and R_result normalize the cues, and
; only the next epoch can chain them. A caller that wants the whole derivation runs epochs
; until one fires nothing — `work-task` with the metabolic bookkeeping, `settle-from` as the
; bare assay — which is why the retiming costs a cycle and changes nothing else.
; Fire order is `rule-priority`, a PLACEHOLDER: Alg 5.1 pops best-first keyed by TECANScore,
; which is unbuilt, and priority is a topological sort rather than a value judgement. It is
; deterministic, and immaterial while fuel covers every candidate.
;
; Run:  sh ../PeTTa/run.sh tests/reaction_test.metta < /dev/null 2>&1 | grep should
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

; --- the QUEUE is assembled against the state as it stands, so R_trans — which has no
; ReasonFor edge to chain yet — is not in it. One epoch later it is the only entry. ------
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

; --- ONE HOP PER CYCLE: the answer count climbs as the chain advances ------------------
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

; --- RUNNING TO SETTLE is the same thing without the cycle bookkeeping: the bare assay for
; a genome run with no task posed, every firing landing in the default cycle ------------
!(bind! &wsl (new-space))
!(set-task &wsl V3)
!(copy-molecules &wsl)
!(restore-snapshot &wsl SNAP_qa)
!(test (run-chamber-settle &wsl CH_expt1 none) 3)                      ; three firings, one pass
!(test (total-answers &wsl) 2)
!(test (log-cycles &wsl) (1))                                          ; no cycle structure here

; --- THE TASK ABSORBS THE RETIMING. A task runs until its chamber settles, so it simply takes
; one more cycle; the answers and the purses are what the whole derivation always cost. ---
!(bind! &wt (new-space))
!(add-atom &wt (fuel O_base sm 6))
!(add-atom &wt (fuel O_base dq 1))
!(add-atom &wt (fuel O_chain sm 4))
!(add-atom &wt (fuel O_chain dq 1))
!(add-atom &wt (fuel O_chain tr 1))
!(test (run-tasks &wt CH_expt1 CL_deep (V3 V4 V5) 1 9) (2 2 2))
!(test (cycles-of-task &wt V3) (1 2 3))            ; two working cycles, then the settle
!(test (cycles-of-task &wt V4) (4 5 6))            ; and the next task starts after them
!(test (cycles-of-task &wt V5) (7 8 9))
!(test (fuel-of &wt O_base sm) 12)                 ; earns 4 and spends 2 on each arrival
!(test (fuel-of &wt O_chain tr) 4)                 ; and tr grows +1 per arrival

; --- ORDER-INDEPENDENCE, a property of the engine rather than of the rule order. Each epoch
; collects its candidates against the state as it stood when the epoch began, so nothing in a
; queue was enabled by anything else in it and enumeration order cannot decide what fires. Run
; the genome in REVERSE priority order and it derives exactly the same thing. Under a cascade
; this fails: the chainer walked first would see no ReasonFor edge and never be revisited, which
; is the only reason `rule-priority` ever had to encode the genome's dependency order. ------
!(bind! &wo (new-space))
!(set-task &wo V3)
!(copy-molecules &wo)
!(restore-snapshot &wo SNAP_qa)
!(set-cycle &wo 1)
!(test (rev-list (chamber-rules CH_expt1)) (R_trans R_result R_so))
!(express &wo)
!(settle-from &wo (rev-list (chamber-rules CH_expt1)) 0 none)
!(test (msort (dedup (collapse (match &wo (event $c $s $r $k) $r)))) (R_result R_so R_trans))
!(test (total-answers &wo) 2)                      ; the chained answer survives the reversal

; --- THE EPOCH BUDGET B (Alg 5.1 line 12, b < B): the queue stops being popped at the
; step bound, so only the first entry fires -----------------------------------------------
!(bind! &wb (new-space))
!(set-task &wb V3)
!(copy-molecules &wb)
!(restore-snapshot &wb SNAP_qa)
!(set-cycle &wb 1)
!(test (run-chamber-b &wb CH_expt1 1) 1)
!(test (collapse (match &wb (event 1 $s $r $k) $r)) (R_so))

; --- AN ENTRY WHOSE RE-CHECK FAILS IS DROPPED, NOT HALTED ON (Alg 5.1 line 14). The queue is
; mixed-rule and mixed-organism, so a later entry may be independent of what the earlier one
; exhausted: here the first entry spends O_chain's last tr, the second needs tr and falls away,
; and O_base's affordable work still fires behind it. ----------------------------------
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
