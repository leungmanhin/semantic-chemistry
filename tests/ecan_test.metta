; ===========================================================================
; ECAN TEST — the ecan-epoch worker (MSC §6.4 / §4.5 cond 1): the metabolic-closure epoch
; loop re-hosted on a worker, in an ISOLATED space, with a cycle-tagged event log.
; ---------------------------------------------------------------------------
; run-ee runs the epoch loop in the worker's own space (not &self): each cycle tags the cycle,
; re-derives, mints, then decays only the derived layer (the purse persists in-place; the
; single event log accumulates cycle-tagged, never cleared). Under CL_shallow O_chain starves
; -> the death trajectory [2,1,1]. The event log accumulates across all cycles (3+2+2 = 7
; firings, one cycle tag each). `dispatch` routes ecan-epoch -> run-ee.
;
; Run:  sh ../PeTTa/run.sh tests/ecan_test.metta < /dev/null 2>&1 | grep should  # eight ✅
; ===========================================================================
!(import! &self "petta/util.metta")
!(import! &self "petta/fuel.metta")
!(import! &self "petta/compiler.metta")
!(import! &self "petta/gate.metta")
!(import! &self "petta/reaction.metta")
!(import! &self "petta/grounder.metta")
!(import! &self "petta/evaluator.metta")
!(import! &self "petta/epoch.metta")
!(import! &self "petta/worker.metta")
!(import! &self "petta/ecan.metta")
!(import! &self "petta/dispatch.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")

; --- an ecan-epoch worker: 3 cycles under CL_shallow, fuel from SNAP_qa (test-local) ---
!(add-atom &self (worker W_ep))
!(add-atom &self (worker-kind W_ep ecan-epoch))
!(add-atom &self (worker-chamber W_ep CH_expt1))
!(add-atom &self (worker-clamp W_ep CL_shallow))
!(add-atom &self (worker-snapshot W_ep SNAP_qa))
!(add-atom &self (worker-cycles W_ep 3))
!(bind! &ws_ep (new-space))
!(add-atom &self (worker-space W_ep &ws_ep))
!(dispatch W_ep)

; --- the death trajectory under CL_shallow: 2 then 1 (O_chain starves on tr) ---
!(test (match &self (worker-trajectory W_ep $t) $t) (2 1 1))
!(test (fuel-of &ws_ep O_chain tr) 0)                              ; O_chain dead (tr starved)

; --- the cycle-tagged event log accumulated across ALL cycles (3 + 2 + 2 firings), in the
; worker's own space, never cleared ---
!(test (foldall + (match &ws_ep (event $c $s $r $key) 1) 0) 7)
!(test (match &self (worker-firings W_ep $n) $n) 7)
!(test (foldall + (match &ws_ep (event 1 $s $r $key) 1) 0) 3)   ; cycle 1 fired R_trans
!(test (foldall + (match &ws_ep (event 2 $s $r $key) 1) 0) 2)   ; cycle 2 starved (no R_trans)
!(test (foldall + (match &ws_ep (event 3 $s $r $key) 1) 0) 2)   ; cycle 3 also starved
; --- ISOLATION: the derivation happened in the worker's space, not &self ---
!(test (foldall + (match &self (sem-edge V3g $e ReasonFor $x $y) 1) 0) 0)
