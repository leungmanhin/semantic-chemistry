; ===========================================================================
; ECAN TEST — the ecan-epoch worker (MSC §6.4; TECAN Alg 5.1): working one arriving task on a
; worker, in an ISOLATED space, with a cycle-tagged event log.
; ---------------------------------------------------------------------------
; run-ee works the worker's task in the worker's own space (not &self): pose it, open a fresh
; hot pool with that task's text, run cycles until the chamber settles or `worker-cycles` runs
; out, then mint under `worker-clamp`. It is the MINTING worker kind, as against context-chamber
; which only derives. A worker is handed ONE task; a stream of them is the harness's business,
; not the worker's. `dispatch` routes ecan-epoch -> run-ee.
;
; Run:  sh ../PeTTa/run.sh tests/ecan_test.metta < /dev/null 2>&1 | grep should
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
!(import! &self "petta/ecan.metta")
!(import! &self "petta/dispatch.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")

; --- an ecan-epoch worker: task V3, at most 3 cycles, under CL_shallow, fuel from SNAP_qa ---
!(add-atom &self (worker W_ep))
!(add-atom &self (worker-kind W_ep ecan-epoch))
!(add-atom &self (worker-chamber W_ep CH_expt1))
!(add-atom &self (worker-task W_ep V3))
!(add-atom &self (worker-clamp W_ep CL_shallow))
!(add-atom &self (worker-snapshot W_ep SNAP_qa))
!(add-atom &self (worker-cycles W_ep 3))
!(bind! &ws_ep (new-space))
!(add-atom &self (worker-space W_ep &ws_ep))
!(dispatch W_ep)

; --- the task is answered both ways; the seeded tr covers its one chaining ---
!(test (match &self (worker-trajectory W_ep $t) $t) (2))
!(test (fuel-of &ws_ep O_chain tr) 0)                           ; the seed is spent, and CL_shallow
                                                                ; mints none back — the next arrival
                                                                ; would go unchained
; --- the chamber SETTLES: cycle 1 does the work, cycle 2 finds every product already present
; and fires nothing, which is what ends the task ---
!(test (foldall + (match &ws_ep (event $c $s $r $key) 1) 0) 3)
!(test (match &self (worker-firings W_ep $n) $n) 3)
!(test (foldall + (match &ws_ep (event 1 $s $r $key) 1) 0) 3)   ; R_so + R_result + R_trans
!(test (foldall + (match &ws_ep (event 2 $s $r $key) 1) 0) 0)   ; settled
!(test (cycles-of-task &ws_ep V3) (1 2))                        ; both cycles are dated to the task
!(test (log-tasks &ws_ep) (V3))

; --- ISOLATION: the derivation happened in the worker's space, not &self ---
!(test (foldall + (match &self (sem-edge V3g $e ReasonFor $x $y) 1) 0) 0)
