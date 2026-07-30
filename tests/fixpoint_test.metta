; ===========================================================================
; FIXPOINT TEST — the execution-model prototype: is iterating the rule pass to a fixpoint
; result-neutral, and does it remove the dependence on `rule-priority`?
; ---------------------------------------------------------------------------
; A single pass fires rules in priority order and adds each product immediately, so a rule walked
; BEFORE its premises exist sees nothing and is never revisited. That is the only reason the
; genome's priorities have to encode a topological order of its own dependencies — a hand-assigned
; ordering standing in for a scoring function we have not built.
;
; Iterating the pass to a fixpoint removes the dependence. This file pins both halves of the claim:
;   1. result-neutral   — same answers, same firings, same purses as the cascade;
;   2. order-independent — reversing the walk order breaks the CASCADE (the chained answer is lost)
;                          and leaves the FIXPOINT unchanged.
; The second is the payoff: it is what makes `rule-priority` unnecessary rather than load-bearing.
;
; Run:  sh ../PeTTa/run.sh tests/fixpoint_test.metta < /dev/null 2>&1 | grep should
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

; the distinct rules that fired, read locally (`fired-rules` itself lives in the ACS layer,
; which this engine-level test has no reason to pull in)
(= (fired $ws) (msort (dedup (collapse (match $ws (event $c $s $r $k) $r)))))

; V3's genome, by priority: the cue-normalizers before the chainer that eats their products
!(test (chamber-rules CH_expt1) (R_so R_result R_trans))

; --- 1. the CASCADE (one pass, priority order) — the baseline -------------------------
!(bind! &wa (new-space))
!(set-task &wa V3)
!(copy-molecules &wa)
!(restore-snapshot &wa SNAP_qa)
!(run-chamber &wa CH_expt1)
!(test (total-answers &wa) 2)
!(test (fired &wa) (R_result R_so R_trans))

; --- 2. the FIXPOINT, same order — RESULT-NEUTRAL --------------------------------------
!(bind! &wb (new-space))
!(set-task &wb V3)
!(copy-molecules &wb)
!(restore-snapshot &wb SNAP_qa)
!(run-chamber-fix &wb CH_expt1)
!(test (total-answers &wb) 2)                                  ; same answers
!(test (fired &wb) (R_result R_so R_trans))      ; same firings
!(test (fuel-of &wb O_base sm) (fuel-of &wa O_base sm))        ; same purses
!(test (fuel-of &wb O_chain sm) (fuel-of &wa O_chain sm))
!(test (fuel-of &wb O_chain tr) (fuel-of &wa O_chain tr))
!(test (foldall + (match &wb (event $c $s $r $k) 1) 0) 3)      ; same number of firings logged

; --- 3. REVERSED order, one pass — the cascade is ORDER-DEPENDENT ----------------------
; R_trans is walked first, when no ReasonFor edge exists yet: it matches nothing, is never
; revisited, and the chained (root-cause) answer is simply lost.
!(test (rev-list (chamber-rules CH_expt1)) (R_trans R_result R_so))
!(bind! &wc (new-space))
!(set-task &wc V3)
!(copy-molecules &wc)
!(restore-snapshot &wc SNAP_qa)
!(run-once-order &wc (rev-list (chamber-rules CH_expt1)))
!(test (fired &wc) (R_result R_so))              ; R_trans never fired
!(test (total-answers &wc) 1)                                  ; only the proximate answer

; --- 4. REVERSED order, to fixpoint — order stops mattering ---------------------------
; The second pass revisits R_trans once its premises exist, so the closure is reached anyway.
!(bind! &wd (new-space))
!(set-task &wd V3)
!(copy-molecules &wd)
!(restore-snapshot &wd SNAP_qa)
!(run-fix-order &wd (rev-list (chamber-rules CH_expt1)))
!(test (fired &wd) (R_result R_so R_trans))
!(test (total-answers &wd) 2)                                  ; the chained answer is back
!(test (fuel-of &wd O_chain tr) (fuel-of &wa O_chain tr))      ; and it cost the same

; --- 5. the fixpoint terminates: a second run in the same cycle adds nothing -----------
; `fired?` blocks re-firing a (rule,key) within a cycle, so the closure is stable.
!(run-chamber-fix &wd CH_expt1)
!(test (foldall + (match &wd (event $c $s $r $k) 1) 0) 3)      ; still 3 firings, no runaway
!(test (total-answers &wd) 2)
