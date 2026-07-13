; ===========================================================================
; EPOCH TEST — the metabolic-closure loop (TECAN Alg 5.1 / MSC §4.5 cond 1) on V3:
; the LITERAL typed-starvation, 1-vs-2-answer death.
; ---------------------------------------------------------------------------
; Each epoch re-performs the task (fuel-gated re-derivation), grounds the skeleton, mints
; + credits typed fuel under the clamp, then DECAYS the derived layer (the purse persists,
; the derivation does not — so the organism must keep earning to keep answering). Two
; mortal organisms: O_base {R_so,R_result} (cost sm), O_chain {R_trans} (cost sm + tr).
; Under CL_shallow O_chain earns no tr -> per-cycle tr surplus < 0 -> it starves and by
; epoch 2 R_trans can fire nothing (death), so the ROOT answer disappears (2 -> 1). Under
; CL_deep its tr surplus is +1 -> it self-sustains (2 every cycle). O_base lives on sm
; either way. `epochs-traced` returns (answers  tr-surplus) per cycle: the surplus (rate)
; predicts and the answer count (state) confirms.
;
; Run:  sh ../PeTTa/run.sh tests/epoch_test.metta < /dev/null 2>&1 | grep should  # ten ✅
; ===========================================================================
!(import! &self "petta/util.metta")
!(import! &self "petta/fuel.metta")
!(import! &self "petta/compiler.metta")
!(import! &self "petta/gate.metta")
!(import! &self "petta/reaction.metta")
!(import! &self "petta/grounder.metta")
!(import! &self "petta/evaluator.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")
!(import! &self "petta/epoch.metta")

; --- DECAY forgets the derived layer, keeps the molecules + the event log -----
!(add-atom &self (fuel O_base sm 6))
!(add-atom &self (fuel O_chain sm 4))
!(add-atom &self (fuel O_chain tr 1))
!(run-chamber &self CH_expt1)
!(test (foldall + (match &self (sem-edge V3g $e ReasonFor $x $y) 1) 0) 3)   ; derived layer present
!(decay &self)
!(test (foldall + (match &self (sem-edge V3g $e ReasonFor $x $y) 1) 0) 0)   ; ...forgotten
!(test (foldall + (match &self (sem-edge V3g v3_conn1 So $x $y) 1) 0) 1)    ; molecule cue KEPT
!(test (foldall + (match &self (event $c $s $r $k) 1) 0) 3)                     ; event log KEPT
!(reset-run &self)

; --- CL_shallow: O_chain starves — the root answer dies at epoch 2 ----------------------
; (answers  tr-surplus) per cycle: 2 answers then 1; tr-surplus −1 (spends its seed) then 0
; (the Definition-1 flatline — R_trans can fire nothing).
!(add-atom &self (fuel O_base sm 6))
!(add-atom &self (fuel O_chain sm 4))
!(add-atom &self (fuel O_chain tr 1))
!(test (epochs-traced &self CH_expt1 CL_shallow 3 O_chain tr) ((2 -1) (1 0) (1 0)))
!(test (fuel-of &self O_chain tr) 0)          ; dead: tr starved to 0, never replenished
!(test (fuel-of &self O_base sm) 6)           ; O_base lives (sm break-even)
!(reset-run &self)

; --- CL_deep: O_chain self-sustains — both answers every cycle --------------------------
; tr-surplus +1 each cycle (income 2 − draw 1); tr grows 1 -> 2 -> 3 -> 4.
!(add-atom &self (fuel O_base sm 6))
!(add-atom &self (fuel O_chain sm 4))
!(add-atom &self (fuel O_chain tr 1))
!(test (epochs-traced &self CH_expt1 CL_deep 3 O_chain tr) ((2 1) (2 1) (2 1)))
!(test (fuel-of &self O_chain tr) 4)          ; alive: tr income sustains the chain
!(test (fuel-of &self O_base sm) 6)           ; O_base lives (sm break-even)
