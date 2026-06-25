; ===========================================================================
; P1 EVALUATOR in PeTTa — eq-17 scoring + clamp-switch (CANONICAL per-match form, D9).
; ---------------------------------------------------------------------------
; The evaluator layer runs OUTSIDE the firing loop (MSC §4.4): score each candidate-
; answer against its gold skeleton by a faithful subset of eq-17 (Match here), and mint
; typed fuel by the active clamp's class. This standalone demo runs the canonical genome
; to fixpoint (ample fuel), then scores via the shared evaluator_defs.
;
; Numerics unchanged from the old aggregating form: the cites SET is identical (per-match
; just fires them separately), so covered/anssize and thus the mints are the same — Match =
; covered^2/(skel*ans), mint = floor(6*Match). Q3a Match 0.5 -> 3; Q23 exact (2/2) -> 6.
; CLAMP-SWITCH: gm-income flips 25 (physical) <-> 16 (intentional). ABSTAIN is now the
; EVALUATOR's job (D9): Q20 produces no answer, so abstain-income mints 4 for the gold-abstain
; question the soma left unanswered (was the old abstain candidate-answer's would-mint=4).
;
; Run:  sh ../PeTTa/run.sh petta/evaluator.metta < /dev/null 2>&1 | grep should   # six ✅
; ===========================================================================
!(import! &self "petta/kernel_defs.metta")
!(import! &self "experiments/expt1-causal-qa/molecules.metta")
!(import! &self "experiments/expt1-causal-qa/tasks.metta")
!(import! &self "experiments/expt1-causal-qa/configs.metta")
!(import! &self "experiments/expt1-causal-qa/rules.metta")
!(import! &self "petta/evaluator_defs.metta")

; run the canonical genome to fixpoint (ample fuel -> all answers produced)
!(add-atom &self (fuel gm 100))
!(add-atom &self (fuel ci 100))
!(run-rules &self)

; --- clamp-switch: the income an answer set earns under each clamp class ---------
!(test (gm-income &self physical-cause) 25)   ; physical strategy surplus
!(test (gm-income &self intentional) 16)      ; swap the clamp -> the intentional strategy is rewarded
; --- eq-17 Match per answer (mint = floor(6*Match)) ----------------------------
!(test (would-mint &self Q7a physical-cause physical-cause) 6)   ; exact cite match -> 6
!(test (would-mint &self Q3a physical-cause physical-cause) 3)   ; multi-cite skeleton, 1 covered -> Match 0.5 -> 3
!(test (would-mint &self Q23 physical-cause physical-cause) 6)   ; both cites covered (2/2)
; --- abstain handled by the EVALUATOR (Q20 gold-abstain, soma produced no answer) ---
!(test (abstain-income &self) 4)
