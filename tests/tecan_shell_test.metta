; ===========================================================================
; Per-organism fuel ledger + attention state + the computed gate.
; ---------------------------------------------------------------------------
; Exercised on SYNTHETIC organisms/rules (declared here, not in experiments/) so both
; branches are covered — including the reject branches single-organism, single-chamber
; Exp-1 data does not reach. Checks:
;  (1) rule-organism — a rule resolves to its organism via ruleset membership
;      (ruleset-member RS R · quoted-ruleset GNM RS · genome-of O GNM); two organisms,
;      each quoting a one-rule ruleset, resolve distinctly.
;  (2) per-organism purse — afford/debit read/write the FIRING organism's own
;      `(fuel O tok n)`; two organisms in the SAME space have ISOLATED ledgers.
;  (3) computed gate Gate(R,O,X) = rule-eligible? ∧ afford ∧ attn-ok? — the single
;      fire-decision, hitting all three factors incl. the afford-fail and the
;      attention-below-threshold (cold rule) reject branches.
;
; Run:  sh ../PeTTa/run.sh tests/tecan_shell_test.metta < /dev/null 2>&1 | grep should  # 14 ✅
; ===========================================================================
!(import! &self "petta/kernel.metta")

; --- two synthetic organisms, each a genome quoting a one-rule ruleset -----------
!(add-atom &self (organism O_a))
!(add-atom &self (genome-of O_a GNM_a))
!(add-atom &self (quoted-ruleset GNM_a RS_a))
!(add-atom &self (ruleset-member RS_a R_a))
!(add-atom &self (organism O_b))
!(add-atom &self (genome-of O_b GNM_b))
!(add-atom &self (quoted-ruleset GNM_b RS_b))
!(add-atom &self (ruleset-member RS_b R_b))

; (1) rule-organism resolves each rule to its OWN organism (the multi-organism seam) --
!(test (rule-organism R_a) O_a)
!(test (rule-organism R_b) O_b)

; --- a shared worker space with a SEPARATE typed purse per organism --------------
!(bind! &ws (new-space))
!(add-atom &ws (fuel O_a gm 3))
!(add-atom &ws (fuel O_b gm 1))

; (2) afford reads the FIRING organism's own purse -------------------------------
!(test (afford &ws O_a ((gm 2))) True)    ; O_a holds 3 >= 2
!(test (afford &ws O_a ((gm 5))) False)   ; O_a holds 3 <  5
!(test (afford &ws O_b ((gm 2))) False)   ; O_b holds 1 <  2 (its OWN purse, not O_a's)

; (2) debit hits ONLY the firing organism's purse — ISOLATION ---------------------
!(debit &ws O_a gm 2)
!(test (fuelof &ws O_a gm) 1)             ; O_a: 3 - 2 = 1
!(test (fuelof &ws O_b gm) 1)             ; O_b: UNTOUCHED (isolated ledger)

; --- attention state: hand-set typed levels; shell threshold = 1 -----------------
!(add-atom &self (attention R_hot gm 5))
!(add-atom &self (attention R_cold gm 0))
; (3) attn-ok?: >= threshold passes; below fails; ABSENT is vacuously True (shell) --
!(test (attn-ok? R_hot) True)             ; 5 >= 1
!(test (attn-ok? R_cold) False)           ; 0 <  1  -> cold, gated off
!(test (attn-ok? R_a) True)               ; no attention fact -> attention not modelled -> pass

; (3) the computed gate folds all three factors (O_a now holds 1) -----------------
!(test (gate? &ws O_a R_a ((gm 1))) True)     ; eligible + afford (1>=1) + attn vacuous -> OPEN
!(test (gate? &ws O_a R_a ((gm 2))) False)    ; afford FAILS (O_a holds 1) -> gate SHUT
!(test (gate? &ws O_a R_hot ((gm 1))) True)   ; hot rule, afforded -> OPEN
!(test (gate? &ws O_a R_cold ((gm 1))) False) ; COLD rule (attn 0<1) -> SHUT despite afford
