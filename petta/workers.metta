; ===========================================================================
; P4.2 — WORKER ECOLOGY: separate-space-per-worker isolation + a reducer
;        (TECAN T5). Uses the §6.4 worker contract + dispatcher.
; ---------------------------------------------------------------------------
; Isolation approach (chosen on the spaces_behavior.metta battle-test): each
; context-chamber worker gets its OWN mutable space (`(new-space)`, registered
; as `(worker-space W &ws)`); the read-only IR stays SHARED in &self. The kernel
; body (kernel_defs.metta) is parameterized by $ws, so a worker reads IR from
; &self and reads/writes its fuel/products/events in its own space — no leakage,
; no per-worker IR copy (cross-space join). A `reducer` worker then
; merges the per-worker summaries (§6.2 reducer layer; §6.4 deterministic merge).
;
; Demonstrated with TWO context-chamber workers over the same shared IR but
; different fuel snapshots -> different mortal trajectories, fully isolated:
;   W_full (gm 20) -> the full P0 run: 20 firings, 6 answers, Q7b starves
;   W_lean (gm  8) -> starves early: 8 firings, 0 answers (dies before projecting)
; then W_reduce sums firings/answers across both. Each worker's event log lives
; only in its own space; neither sees the other's products.
;
; Run:  sh ../PeTTa/run.sh petta/workers.metta < /dev/null \
;          2>&1 | grep should     # ten ✅
; ===========================================================================
!(import! &self "petta/kernel_defs.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")

; --- worker W_full: its own mutable space + a generous fuel snapshot ---------
!(bind! &ws_full (new-space))
!(add-atom &self (worker W_full))
!(add-atom &self (worker-kind W_full context-chamber))
!(add-atom &self (worker-backend W_full petta))
!(add-atom &self (worker-space W_full &ws_full))
!(add-atom &self (worker-snapshot W_full SNAP_full))
!(add-atom &self (snapshot-fuel SNAP_full gm 20))
!(add-atom &self (snapshot-fuel SNAP_full ci 7))

; --- worker W_lean: its own space + a lean fuel snapshot (starves early) -----
!(bind! &ws_lean (new-space))
!(add-atom &self (worker W_lean))
!(add-atom &self (worker-kind W_lean context-chamber))
!(add-atom &self (worker-backend W_lean petta))
!(add-atom &self (worker-space W_lean &ws_lean))
!(add-atom &self (worker-snapshot W_lean SNAP_lean))
!(add-atom &self (snapshot-fuel SNAP_lean gm 8))
!(add-atom &self (snapshot-fuel SNAP_lean ci 6))

; --- worker W_reduce: a reducer (merges the per-worker summaries) -------------
!(add-atom &self (worker W_reduce))
!(add-atom &self (worker-kind W_reduce reducer))

; --- the dispatcher: route a worker to its kind's body (§6.4) ----------------
(= (dispatch $w) (let $k (match &self (worker-kind $w $kind) $kind) (if (== $k context-chamber) (run-cc $w) (if (== $k reducer) (run-reduce $w) unknown-kind))))

; context-chamber worker: own space, fuel from snapshot, run kernel on $ws, summarise to &self
(= (run-cc $w) (let $ws (match &self (worker-space $w $sp) $sp) (let $snap (match &self (worker-snapshot $w $s) $s) (let $z1 (add-all $ws (collapse (match &self (snapshot-fuel $snap $t $n) (fuel $t $n)))) (let $z2 (run-rules $ws) (emit-summary $w $ws))))))

; summary facts (the §6.4 worker output) go to &self, keyed by worker; the LOG stays in $ws
(= (emit-summary $w $ws) (let $f (foldall + (match $ws (event $s $r $k) 1) 0) (let $z1 (add-atom &self (worker-summary $w firings $f)) (let $a (foldall + (match $ws (candidate-answer $q $an) 1) 0) (let $z2 (add-atom &self (worker-summary $w answers $a)) (let $g (fuelof $ws gm) (add-atom &self (worker-summary $w fuel-gm $g))))))))

; reducer: deterministic merge of the per-worker summaries across all workers
(= (run-reduce $w) (let $tf (foldall + (match &self (worker-summary $cw firings $n) $n) 0) (let $z1 (add-atom &self (reduced total-firings $tf)) (let $ta (foldall + (match &self (worker-summary $cw2 answers $m) $m) 0) (add-atom &self (reduced total-answers $ta))))))

!(dispatch W_full)
!(dispatch W_lean)
!(dispatch W_reduce)

; --- verify: two ISOLATED mortal trajectories + a correct reduced merge -------
!(test (match &self (worker-summary W_full firings $f) $f) 20)     ; full run = 20 firings
!(test (match &self (worker-summary W_full answers $a) $a) 6)      ; 6 answers
!(test (match &self (worker-summary W_lean firings $f) $f) 8)      ; lean starves at 8 firings
!(test (match &self (worker-summary W_lean answers $a) $a) 0)      ; ...before projecting any answer
!(test (foldall + (match &ws_full (event $s $r $k) 1) 0) 20)       ; W_full's log lives in its OWN space
!(test (foldall + (match &ws_lean (event $s $r $k) 1) 0) 8)        ; W_lean's log lives in ITS own space
!(test (foldall + (match &ws_lean (candidate-answer $q $a) 1) 0) 0) ; no leak: W_full's 6 answers not in W_lean
!(test (foldall + (match &ws_full (candidate-answer $q $a) 1) 0) 6) ; W_full's answers isolated in W_full
!(test (match &self (reduced total-firings $n) $n) 28)             ; reducer merged: 20 + 8
!(test (match &self (reduced total-answers $n) $n) 6)              ; merged answers: 6 + 0
