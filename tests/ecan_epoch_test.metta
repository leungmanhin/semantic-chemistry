; ===========================================================================
; ecan-epoch: the P1 metabolic-closure loop (TECAN T2 loop).
; ---------------------------------------------------------------------------
; Uses the epoch loop in petta/ecan.metta: run the chamber to quiescence, score the NEW
; answers (eq-17), mint typed fuel by the active clamp, credit it back, re-run while there
; is progress + fuel. This turns the P0 feed-forward chain into a self-sustaining mortal
; ACS — the fuel an answer mints funds the next question (metabolic closure, §4.5 cond 1).
; Relies on the re-run-safe engine (fire-once walk + run-from). Clamp = CL_antecedent.
;
; Demonstration (constrained CLOSURE seed gm=23): feedback OFF (one pass, no mint) starves;
; feedback ON (the epoch loop) earns fuel by answering and reaches more. ON > OFF ==
; "minting funds further computation".
;
; Run:  sh ../PeTTa/run.sh tests/ecan_epoch_test.metta < /dev/null \
;          2>&1 | grep should   # nine ✅ (OFF: 1 answer, starved gm=0 | ON: 6 answers, surplus gm=16)
; ===========================================================================
!(import! &self "petta/util.metta")
!(import! &self "petta/fuel.metta")
!(import! &self "petta/compiler.metta")
!(import! &self "petta/gate.metta")
!(import! &self "petta/reaction.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")
!(import! &self "petta/evaluator.metta")
!(import! &self "petta/ecan.metta")   ; epoch · credit-all · unscored · count-events

; --- feedback OFF: one chamber pass, no minting (the baseline at the constrained seed) ---
!(bind! &ws_off (new-space))
!(add-atom &ws_off (fuel O_qa gm 23))
!(add-atom &ws_off (fuel O_qa ci 20))
!(run-chamber &ws_off CH_expt1)
!(test (count-answers &ws_off) 1)     ; OFF: starves at the constrained seed -> 1 answer only
!(test (count-events &ws_off) 23)     ; spent all 23 gm
!(test (fuel-of &ws_off O_qa gm) 0)    ; ...and died (no minting to replenish)

; --- feedback ON: the epoch loop credits minted fuel back (metabolic closure) ---
!(bind! &ws_on (new-space))
!(add-atom &ws_on (fuel O_qa gm 23))
!(add-atom &ws_on (fuel O_qa ci 20))
!(epoch &ws_on CH_expt1 CL_antecedent)
!(test (count-answers &ws_on) 6)      ; ON: the epoch loop reaches all 6 answers (incl. Q7b, which the seed starved)
!(test (count-events &ws_on) 28)      ; +5 firings the seed alone could not afford
!(test (fuel-of &ws_on O_qa gm) 16)    ; ...ending in metabolic SURPLUS (21 minted, 28 spent, seed 23) = self-sustaining

; --- the credit path is token-generic: the clamp declares its mint token, and crediting
;     a token the organism never held CREATES the purse ---
!(test (mint-token-of CL_antecedent) gm)  ; the clamp's skeleton-match mint is gm-denominated
!(bind! &ws_credit (new-space))
!(credit &ws_credit O_qa xp 5)
!(test (fuel-of &ws_credit O_qa xp) 5)    ; no (fuel O_qa xp _) existed -> purse created
!(credit &ws_credit O_qa xp 3)
!(test (fuel-of &ws_credit O_qa xp) 8)    ; an existing purse accumulates
