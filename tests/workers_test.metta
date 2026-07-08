; ===========================================================================
; WORKER ECOLOGY: separate-space-per-worker isolation + a reducer (TECAN T5).
; ---------------------------------------------------------------------------
; Uses the §6.4 worker contract + dispatcher from petta/workers.metta. Each context-
; chamber worker gets its OWN mutable space (`(worker-space W &ws)`); the read-only IR
; stays SHARED in &self; the engine (reaction.metta) is $ws-parameterized, so a worker
; reads IR from &self and reads/writes its fuel/products/events in its own space — no
; leakage, no per-worker IR copy. A `reducer` merges the per-worker summaries.
;
; TWO context-chamber workers over the same shared IR, different fuel snapshots ->
; different mortal trajectories, fully isolated:
;   W_full (gm 28) -> the full run: 28 firings, all 6 answers
;   W_lean (gm  8) -> starves early: 8 firings, 0 answers (dies before projecting)
; then W_reduce sums firings/answers across both.
;
; Run:  sh ../PeTTa/run.sh tests/workers_test.metta < /dev/null \
;          2>&1 | grep should     # ten ✅
; ===========================================================================
!(import! &self "petta/util.metta")
!(import! &self "petta/fuel.metta")
!(import! &self "petta/compiler.metta")
!(import! &self "petta/gate.metta")
!(import! &self "petta/reaction.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")
!(import! &self "petta/persist.metta")
!(import! &self "petta/chamber.metta")
!(import! &self "petta/reducer.metta")
!(import! &self "petta/workers.metta")

; --- worker W_full: its own mutable space + a generous fuel snapshot ---------
!(bind! &ws_full (new-space))
!(add-atom &self (worker W_full))
!(add-atom &self (worker-kind W_full context-chamber))
!(add-atom &self (worker-chamber W_full CH_expt1))
!(add-atom &self (worker-backend W_full petta))
!(add-atom &self (worker-space W_full &ws_full))
!(add-atom &self (worker-snapshot W_full SNAP_full))
!(add-atom &self (snapshot-fuel SNAP_full O_qa gm 28))
!(add-atom &self (snapshot-fuel SNAP_full O_qa ci 7))

; --- worker W_lean: its own space + a lean fuel snapshot (starves early) -----
!(bind! &ws_lean (new-space))
!(add-atom &self (worker W_lean))
!(add-atom &self (worker-kind W_lean context-chamber))
!(add-atom &self (worker-chamber W_lean CH_expt1))
!(add-atom &self (worker-backend W_lean petta))
!(add-atom &self (worker-space W_lean &ws_lean))
!(add-atom &self (worker-snapshot W_lean SNAP_lean))
!(add-atom &self (snapshot-fuel SNAP_lean O_qa gm 8))
!(add-atom &self (snapshot-fuel SNAP_lean O_qa ci 6))

; --- worker W_reduce: a reducer (merges the per-worker summaries) -------------
!(add-atom &self (worker W_reduce))
!(add-atom &self (worker-kind W_reduce reducer))

!(dispatch W_full)
!(dispatch W_lean)
!(dispatch W_reduce)

; --- verify: two ISOLATED mortal trajectories + a correct reduced merge -------
!(test (match &self (worker-summary W_full firings $f) $f) 28)     ; full run = 28 firings
!(test (match &self (worker-summary W_full answers $a) $a) 6)      ; 6 answers
!(test (match &self (worker-summary W_lean firings $f) $f) 8)      ; lean starves at 8 firings
!(test (match &self (worker-summary W_lean answers $a) $a) 0)      ; ...before projecting any answer
!(test (foldall + (match &ws_full (event $s $r $k) 1) 0) 28)       ; W_full's log lives in its OWN space
!(test (foldall + (match &ws_lean (event $s $r $k) 1) 0) 8)        ; W_lean's log lives in ITS own space
!(test (foldall + (match &ws_lean (candidate-answer $q $a) 1) 0) 0) ; no leak: W_full's 6 answers not in W_lean
!(test (foldall + (match &ws_full (candidate-answer $q $a) 1) 0) 6) ; W_full's answers isolated in W_full
!(test (match &self (reduced total-firings $n) $n) 36)             ; reducer merged: 28 + 8
!(test (match &self (reduced total-answers $n) $n) 6)              ; merged answers: 6 + 0

; --- re-dispatching the reducer REPLACES the reduced facts (re-run-safe, no stacking) --
!(dispatch W_reduce)
!(test (foldall + (match &self (reduced total-firings $n) 1) 0) 1) ; still exactly ONE fact per key
!(test (match &self (reduced total-firings $n) $n) 36)             ; same merged value
