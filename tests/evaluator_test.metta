; ===========================================================================
; EVALUATOR TEST — achievement-typed minting on the solve pipeline (V3).
; ---------------------------------------------------------------------------
; Match is BINARY per grounding — every solution mints (per-solution piece-rate).
; A grounding's achievements (skeleton-match always; transitive-explanation when the
; cited derivation is a chain, depth >= 2 read structurally off the provenance ids)
; are converted to typed fuel by the clamp's (clamp-mint CL achievement tok n) facts,
; credited to the organism whose rule derived the cited edge (producer looked up in
; the event log). The clamp-switch is TYPED: sm income is EQUAL under both clamps;
; tr income is 0 (CL_shallow) vs 2 (CL_deep) — R_trans costs tr, so only CL_deep
; makes the chaining strategy metabolically self-sustaining.
;
; Run:  sh ../PeTTa/run.sh tests/evaluator_test.metta < /dev/null 2>&1 | grep should  # twenty-five ✅
; ===========================================================================
!(import! &self "petta/util.metta")
!(import! &self "petta/fuel.metta")
!(import! &self "petta/compiler.metta")
!(import! &self "petta/gate.metta")
!(import! &self "petta/reaction.metta")
!(import! &self "petta/grounder.metta")
!(import! &self "petta/evaluator.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")

; --- the reaction: seed each organism's purse, run the genome (all firings fuel-gated).
; O_base owns R_so/R_result (cost sm); O_chain owns R_trans (costs sm + tr).
!(add-atom &self (fuel O_base sm 10))
!(add-atom &self (fuel O_chain sm 10))
!(add-atom &self (fuel O_chain tr 5))
!(run-rules &self)

; all three corpus texts are loaded into &self, so each rule fires once per text
!(test (foldall + (match &self (event $c $s $r $k) 1) 0) 9)              ; (R_so + R_result + R_trans) x 3
!(test (fuel-of &self O_base sm) 4)                                   ; O_base: R_so + R_result @ sm 1, x3
!(test (fuel-of &self O_chain sm) 7)                                  ; O_chain: R_trans @ sm 1, x3
!(test (fuel-of &self O_chain tr) 2)                                  ; only R_trans costs tr
!(test (foldall + (match &self (sem-edge V3g $e ReasonFor $x $y) 1) 0) 3)  ; 2 normalized + 1 chained

; --- depth is read structurally off the provenance ids ---------------------------
!(test (id-depth (norm v3_conn2)) 1)
!(test (id-depth (trans (norm v3_conn1) (norm v3_conn2))) 2)
!(test (msort (depths-of (collapse (ground-skeleton &self V3_q1_as1)))) (1 2))

; --- achievements -> typed income under each clamp --------------------------------
!(test (question-income &self V3_q1 CL_shallow sm) 4)   ; 2 groundings x skeleton-match @ sm 2
!(test (question-income &self V3_q1 CL_shallow tr) 0)   ; the chain earns NOTHING extra
!(test (question-income &self V3_q1 CL_deep tr) 2)      ; the chain grounding = transitive-explanation @ tr 2

; chamber income is what the POSED task's questions mint — pose V3 and it is V3's alone;
; sm is EQUAL under both clamps, so the clamp-switch is purely the TOKEN TYPE
!(add-atom &self (task-now V3))
!(test (chamber-income &self CL_shallow sm) 4)
!(test (chamber-income &self CL_deep sm) 4)
!(test (chamber-income &self CL_shallow tr) 0)
!(test (chamber-income &self CL_deep tr) 2)

; retire it and nothing is posed, so every task's questions count — the whole corpus's income
!(remove-atom &self (task-now V3))
!(test (chamber-income &self CL_deep sm) 12)
!(test (chamber-income &self CL_deep tr) 6)
!(add-atom &self (task-now V3))

; --- provenance-based crediting: each grounding credits the organism whose rule DERIVED
; its cited answer edge — the proximate answer -> R_result -> O_base, the root -> R_trans -> O_chain
!(test (producer-of &self (sem-edge V3g (trans (norm v3_conn1) (norm v3_conn2)) ReasonFor sk_go_out_1 sk_spoil_1)) R_trans)
!(test (rule-organism R_result) O_base)
!(test (rule-organism R_trans) O_chain)
; the two groundings credit the two organisms respectively
!(test (msort (dedup (collapse (let $s (superpose (collapse (ground-skeleton &self V3_q1_as1))) (solution-earner &self $s))))) (O_base O_chain))

; credit the why-question under the deep clamp: proximate sm 2 -> O_base; root sm 2 + tr 2
; -> O_chain; 6 tokens minted in total
!(test (credit-question &self V3_q1 CL_deep) 6)
!(test (fuel-of &self O_base sm) 6)               ; 10 seeded - 6 spent + 2 minted (proximate)
!(test (fuel-of &self O_chain sm) 9)              ; 10 seeded - 3 spent + 2 minted (root)
!(test (fuel-of &self O_chain tr) 4)              ;  5 seeded - 3 spent + 2 minted (root)
