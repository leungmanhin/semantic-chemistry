; ===========================================================================
; MULTIWORKER TEST — multiple context-chamber workers in ISOLATED spaces, a step budget,
; dispatch, and a reducer merging their summaries (MSC §6.4 P4 orchestration).
; ---------------------------------------------------------------------------
; Two context-chamber workers over CH_expt1, same snapshot: W_full runs UNBOUNDED (3
; firings, 2 answers); W_lean has worker-budget-steps 2, so it halts after R_so + R_result
; (no R_trans -> 1 answer). Each runs in its own space (isolation — one worker's fuel spend
; never touches the other's). The reducer W_red merges the per-worker firings across par-
; group PG_qa into (reduced total-firings PG_qa 5), re-run-safe. `dispatch` routes each
; worker to its kind's body.
;
; Run:  sh ../PeTTa/run.sh tests/multiworker_test.metta < /dev/null 2>&1 | grep should  # nine ✅
; ===========================================================================
!(import! &self "petta/util.metta")
!(import! &self "petta/fuel.metta")
!(import! &self "petta/compiler.metta")
!(import! &self "petta/gate.metta")
!(import! &self "petta/reaction.metta")
!(import! &self "petta/grounder.metta")
!(import! &self "petta/worker.metta")
!(import! &self "petta/chamber.metta")
!(import! &self "petta/reducer.metta")
!(import! &self "petta/dispatch.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")

; --- the multi-worker scenario (test-local): 2 context-chamber workers + a reducer over
; their par-group. W_lean carries a deterministic step budget. ---
!(add-atom &self (worker W_full))
!(add-atom &self (worker-kind W_full context-chamber))
!(add-atom &self (worker-chamber W_full CH_expt1))
!(add-atom &self (worker-snapshot W_full SNAP_qa))
!(add-atom &self (worker W_lean))
!(add-atom &self (worker-kind W_lean context-chamber))
!(add-atom &self (worker-chamber W_lean CH_expt1))
!(add-atom &self (worker-snapshot W_lean SNAP_qa))
!(add-atom &self (worker-budget-steps W_lean 2))       ; halt after 2 firings (no R_trans)
!(add-atom &self (worker W_red))
!(add-atom &self (worker-kind W_red reducer))
!(add-atom &self (worker-group W_red PG_qa))
!(add-atom &self (par-member PG_qa W_full))
!(add-atom &self (par-member PG_qa W_lean))

; the runner binds each worker's isolated space + registers the handle
!(bind! &ws_full (new-space))
!(add-atom &self (worker-space W_full &ws_full))
!(bind! &ws_lean (new-space))
!(add-atom &self (worker-space W_lean &ws_lean))

; dispatch each worker (2 isolated context-chamber runs), then the reducer
!(dispatch W_full)
!(dispatch W_lean)
!(dispatch W_red)

; --- W_full ran UNBOUNDED: 3 firings, 2 answers ---
!(test (foldall + (match &ws_full (event $c $s $r $k) 1) 0) 3)
!(test (len (collapse (ground-skeleton &ws_full V3_q1_as1))) 2)

; --- W_lean HALTED at the step budget: 2 firings (R_so + R_result, no R_trans), 1 answer ---
!(test (foldall + (match &ws_lean (event $c $s $r $k) 1) 0) 2)
!(test (foldall + (match &ws_lean (sem-edge V3g (trans $a $b) ReasonFor $x $y) 1) 0) 0)  ; no chain edge
!(test (len (collapse (ground-skeleton &ws_lean V3_q1_as1))) 1)

; --- ISOLATION: the two workers did not interfere ---
!(test (fuel-of &ws_full O_chain tr) 0)   ; W_full fired R_trans -> tr spent
!(test (fuel-of &ws_lean O_chain tr) 1)   ; W_lean never reached R_trans -> tr untouched

; --- the REDUCER merged the summaries: total firings = 3 + 2 = 5 ---
!(test (match &self (reduced total-firings PG_qa $n) $n) 5)

; --- RE-RUN-SAFE: dispatch the reducer again -> still 5, not stacked ---
!(dispatch W_red)
!(test (match &self (reduced total-firings PG_qa $n) $n) 5)
