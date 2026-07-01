; ===========================================================================
; P1 EVALUATOR in PeTTa — eq-17 scoring + clamp-switch (intrinsic, graph-derived).
; ---------------------------------------------------------------------------
; The evaluator layer runs OUTSIDE the firing loop (MSC §4.4): score each candidate-
; answer against a target derived from the GRAPH (no gold answer content), then mint
; typed fuel by the active clamp's class. This standalone demo runs the canonical genome
; to fixpoint (ample fuel), then scores via the shared evaluator_defs.
;
; eq-17: Match = covered/idealsize (recall vs the intent-aware graph ideal) - Unsupportedness
; - Redundancy; mint = floor(6*M). Q3a Match 0.5 -> 3 (the transitive CauseOf closure is the
; ideal); Q23 exact (2/2) -> 6. CLAMP-SWITCH: gm-income flips 25 (physical) <-> 16 (intentional).
; ABSTAIN is the EVALUATOR's job: Q20 produces no answer and its graph-ideal is empty, so
; abstain-income mints 4.
;
; Run:  sh ../PeTTa/run.sh tests/evaluator.metta < /dev/null 2>&1 | grep should   # six ✅
; ===========================================================================
!(import! &self "petta/kernel_defs.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")
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
