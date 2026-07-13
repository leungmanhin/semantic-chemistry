; ===========================================================================
; WORKER TEST — the context-chamber worker (MSC §6.4) runs the V3 pipeline in an
; ISOLATED hot-pool space, not &self.
; ---------------------------------------------------------------------------
; The runner binds the worker's space + registers the handle; run-cc materializes the
; molecules into that space, restores fuel from the snapshot, runs the chamber's admitted
; rules there, and summarizes. The derivation + the APPEND-ONLY event log live in the
; worker's space; &self keeps only the original molecules (proving isolation). Grounding
; against the worker's space answers the question (2 ways) — the space-parameterized
; pipeline running off &self. (This is the append-only log that retires the epoch's
; decay-clears-the-log shortcut: the log is never cleared, it just lives in $ws.)
; Then an EVALUATOR worker (run-eval) mints on that same derived space — the minting stage
; the context-chamber worker omits — earning O_chain back the tr it spent to zero (CL_deep).
;
; Run:  sh ../PeTTa/run.sh tests/worker_test.metta < /dev/null 2>&1 | grep should  # sixteen ✅
; ===========================================================================
!(import! &self "petta/util.metta")
!(import! &self "petta/fuel.metta")
!(import! &self "petta/compiler.metta")
!(import! &self "petta/gate.metta")
!(import! &self "petta/reaction.metta")
!(import! &self "petta/grounder.metta")
!(import! &self "petta/evaluator.metta")
!(import! &self "petta/worker.metta")
!(import! &self "petta/chamber.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")

; declare the context-chamber worker instance here (this test is its only runner); then bind
; its hot-pool space + register the handle and run it (the shared SNAP_qa endowment is in configs)
!(add-atom &self (worker W_qa))
!(add-atom &self (worker-kind W_qa context-chamber))
!(add-atom &self (worker-chamber W_qa CH_expt1))
!(add-atom &self (worker-snapshot W_qa SNAP_qa))
!(bind! &ws_qa (new-space))
!(add-atom &self (worker-space W_qa &ws_qa))
!(run-cc W_qa)

; --- ISOLATION: the run happened in the worker's space, NOT &self ---
!(test (foldall + (match &self (sem-edge V3g $e ReasonFor $x $y) 1) 0) 0)   ; &self: NO derived edges
!(test (foldall + (match &self (event $c $s $r $k) 1) 0) 0)                     ; &self: NO event log
!(test (foldall + (match &self (sem-edge V3g v3_conn1 So $x $y) 1) 0) 1)    ; &self: molecule cue UNTOUCHED

; --- the worker's space holds the derivation + the append-only event log + spent fuel ---
!(test (foldall + (match &ws_qa (sem-edge V3g $e ReasonFor $x $y) 1) 0) 3)  ; 2 normalized + 1 chained
!(test (foldall + (match &ws_qa (event $c $s $r $k) 1) 0) 3)                    ; append-only log: 3 firings
!(test (foldall + (match &ws_qa (sem-edge V3g v3_conn1 So $x $y) 1) 0) 1)   ; molecules materialized into $ws
!(test (fuel-of &ws_qa O_base sm) 8)                                         ; O_base: R_so + R_result @ sm 1
!(test (fuel-of &ws_qa O_chain sm) 9)                                        ; O_chain: R_trans @ sm 1
!(test (fuel-of &ws_qa O_chain tr) 0)                                        ; O_chain: R_trans @ tr 1 (seed 1)

; --- grounding against the worker's space answers the question (2 ways) ---
!(test (len (collapse (ground-skeleton &ws_qa V3_q1_as1))) 2)

; --- the §6.4 output envelope: summary emitted to &self ---
!(test (foldall + (match &self (worker-firings W_qa $n) $n) 0) 3)
!(test (foldall + (match &self (worker-purse W_qa O_chain tr $n) 1) 0) 1)    ; one purse fact per surviving purse

; === the EVALUATOR worker (worker-kind `evaluator`, run-eval) — the MINTING stage, run on
; the SAME space the chamber derived into (a sequential pipeline handoff; the concurrency
; rule only forbids CONCURRENT hot-pool mutation). It never derives — it reads the derived
; graph and mints typed fuel under its clamp, earning O_chain the tr the chamber spent to 0. ===
!(add-atom &self (worker W_eval))
!(add-atom &self (worker-kind W_eval evaluator))
!(add-atom &self (worker-clamp W_eval CL_deep))
!(add-atom &self (worker-space W_eval &ws_qa))          ; share the chamber's derived space
!(run-eval W_eval)

; the evaluator minted for both groundings: the chain answer earns O_chain tr + sm, the
; direct answer earns O_base sm (each grounding credited to the organism that derived it)
!(test (fuel-of &ws_qa O_chain tr) 2)     ; chamber left tr 0; the evaluator minted it (transitive-explanation)
!(test (fuel-of &ws_qa O_chain sm) 11)    ; 9 + skeleton-match sm 2 (chain grounding)
!(test (fuel-of &ws_qa O_base sm) 10)     ; 8 + skeleton-match sm 2 (direct grounding)
; the token delta emitted to &self (the evaluator's §6.4 output envelope)
!(test (match &self (worker-purse W_eval O_chain tr $n) $n) 2)
