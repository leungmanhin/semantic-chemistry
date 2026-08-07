; ===========================================================================
; Per-organism fuel ledger + the MORTAL GATE (MSC eq 24 / eq 13 / eq 25).
; ---------------------------------------------------------------------------
; Exercised on SYNTHETIC organisms/rules (declared here, not in experiments/) so both
; branches are covered — including the reject branches single-organism, single-chamber
; Exp-1 data does not reach. Checks:
;  (1) rule-organism — a rule resolves to its organism via ruleset membership
;      (ruleset-member RS R · quoted-ruleset GNM RS · genome-of O GNM); two organisms,
;      each quoting a one-rule ruleset, resolve distinctly.
;  (2) per-organism purse — afford?/debit read/write the FIRING organism's own
;      `(fuel O tok n)`; two organisms in the SAME space have ISOLATED ledgers.
;  (3) the gate SCORE Gate_C(R,O,X) — sigma(0)=0.5 with no coefficients; the d-term
;      reads the scan's rule-do-influence (widest window; unmeasured = 0); the j-term
;      reads the five-condition CERTIFICATE (established ACS boosts, uncertified /
;      unmeasured-surplus / negative-surplus do not); eq 25 FuelMargin = min purse/cost
;      (no cost vector = 0); flat-cost = the token sum.
;  (4) admission + ranking — eq 13's U < Gate_C against (gate-threshold u): undeclared =
;      no bar, declared refuses sub-threshold candidates STRICTLY, and admissible? kills
;      at the gate what affordability alone would pass; rank-queue pops best-first and
;      keeps collection order on ties.
;
; Run:  sh ../PeTTa/run.sh tests/tecan_shell_test.metta < /dev/null 2>&1 | grep should  # 31 ✅
; ===========================================================================
!(import! &self "petta/util.metta")
!(import! &self "petta/fuel.metta")
!(import! &self "petta/compiler.metta")
!(import! &self "petta/gate.metta")
!(import! &self "petta/reaction.metta")

; --- two synthetic organisms, each a genome quoting a one-rule ruleset -----------
!(add-atom &self (organism O_a))
!(add-atom &self (genome-of O_a GNM_a))
!(add-atom &self (genome-token-cost GNM_a dq 1))
!(add-atom &self (quoted-ruleset GNM_a RS_a))
!(add-atom &self (ruleset-member RS_a R_a))
!(add-atom &self (organism O_b))
!(add-atom &self (genome-of O_b GNM_b))
!(add-atom &self (genome-token-cost GNM_b dq 1))
!(add-atom &self (quoted-ruleset GNM_b RS_b))
!(add-atom &self (ruleset-member RS_b R_b))

; (1) rule-organism resolves each rule to its OWN organism (the multi-organism seam) --
!(test (rule-organism R_a) O_a)
!(test (rule-organism R_b) O_b)

; --- a shared worker space with a SEPARATE typed purse per organism --------------
!(bind! &ws (new-space))
!(add-atom &ws (fuel O_a sm 3))
!(add-atom &ws (fuel O_b sm 1))

; (2) afford? reads the FIRING organism's own purse ------------------------------
!(test (afford? &ws O_a ((sm 2))) True)    ; O_a holds 3 >= 2
!(test (afford? &ws O_a ((sm 5))) False)   ; O_a holds 3 <  5
!(test (afford? &ws O_b ((sm 2))) False)   ; O_b holds 1 <  2 (its OWN purse, not O_a's)

; (2) debit hits ONLY the firing organism's purse — ISOLATION ---------------------
!(debit &ws O_a sm 2)
!(test (fuel-of &ws O_a sm) 1)             ; O_a: 3 - 2 = 1
!(test (fuel-of &ws O_b sm) 1)             ; O_b: UNTOUCHED (isolated ledger)

; (3) the SCORE with no coefficients is the constant sigma(0) ---------------------
!(test (gate-coeffs-declared?) False)
!(test (gate-score &ws O_a R_a) 0.5)

; (3) d-term: the widest-window measurement wins; unmeasured reads 0 --------------
!(add-atom &self (rule-do-influence R_a target answer-reward 2 3))
!(add-atom &self (rule-do-influence R_a target answer-reward 1 5))
!(test (rule-doinf R_a) 3)                 ; window 2 beats window 1, despite the larger delta
!(test (rule-doinf R_b) 0)                 ; never measured -> contributes nothing
!(add-atom &self (gate-coeff d 1))
!(test (gate-coeffs-declared?) True)
!(test (> (gate-score &ws O_a R_a) 0.5) True)   ; sigma(1*3) — measured influence raises propensity

; (3) j-term: the five-condition CERTIFICATE decides the boost --------------------
; A_t certifies on all five -> its member R_b is boosted
!(add-atom &self (acs-member A_t R_b))
!(add-atom &self (acs-closure A_t hybrid))
!(add-atom &self (acs-autocatalytic A_t True))
!(add-atom &self (acs-surplus A_t CL_t sm 2))
!(add-atom &self (acs-surplus A_t CL_t tr 1))
!(add-atom &self (acs-causal-influence A_t True))
!(add-atom &self (acs-recurrent A_t True))
!(test (established-acs? A_t) True)
!(test (acs-boost R_b) 1)
!(test (acs-boost R_a) 0)                  ; member of nothing
; A_u fails ONE condition (not recurrent) -> its member is NOT boosted
!(add-atom &self (acs-member A_u R_c))
!(add-atom &self (acs-closure A_u substrate))
!(add-atom &self (acs-autocatalytic A_u True))
!(add-atom &self (acs-surplus A_u CL_t sm 2))
!(add-atom &self (acs-causal-influence A_u True))
!(add-atom &self (acs-recurrent A_u False))
!(test (acs-boost R_c) 0)
; A_v carries every boolean verdict but NO surplus fact -> unmeasured viability is REFUSED
!(add-atom &self (acs-member A_v R_d))
!(add-atom &self (acs-closure A_v substrate))
!(add-atom &self (acs-autocatalytic A_v True))
!(add-atom &self (acs-causal-influence A_v True))
!(add-atom &self (acs-recurrent A_v True))
!(test (established-acs? A_v) False)
; A_w runs a NEGATIVE surplus -> not viable, not established
!(add-atom &self (acs-member A_w R_e))
!(add-atom &self (acs-closure A_w substrate))
!(add-atom &self (acs-autocatalytic A_w True))
!(add-atom &self (acs-surplus A_w CL_t sm -1))
!(add-atom &self (acs-causal-influence A_w True))
!(add-atom &self (acs-recurrent A_w True))
!(test (established-acs? A_w) False)

; (3) eq 25 FuelMargin: min purse/cost over the costed tokens ---------------------
!(add-atom &self (rule-token-cost R_b sm 2))
!(test (fuel-margin &ws O_b R_b) 0.5)      ; O_b holds 1, needs 2 -> 1/2
!(add-atom &self (rule-token-cost R_m sm 2))
!(add-atom &self (rule-token-cost R_m tr 4))
!(add-atom &ws (fuel O_m sm 6))
!(add-atom &ws (fuel O_m tr 4))
!(test (fuel-margin &ws O_m R_m) 1)        ; min(6/2, 4/4) — starved of tr
!(test (fuel-margin &ws O_a R_nocost) 0)   ; no cost vector -> no starvation axis
!(test (flat-cost R_m) 6)                  ; 2 + 4, every token weighing 1

; (4) eq 13's third conjunct: U < Gate_C against the declared threshold -----------
!(add-atom &self (gate-coeff j 2))         ; R_b now scores sigma(2) ≈ 0.88; R_c sigma(0) = 0.5
!(test (gate-open? &ws O_b R_b) True)      ; no threshold declared -> no admission bar
!(add-atom &self (gate-threshold 0.7))
!(test (gate-open? &ws O_b R_b) True)      ; 0.88 > 0.7 — the certificate carries it through
!(test (gate-open? &ws O_a R_c) False)     ; 0.5 < 0.7 — refused at the gate
!(remove-atom &self (gate-threshold 0.7))
!(add-atom &self (gate-threshold 0.5))
!(test (gate-open? &ws O_a R_c) False)     ; 0.5 > 0.5 fails — eq 13 is STRICT

; (4) admissible? kills at the GATE what affordability alone would pass -----------
!(test (admissible? &ws O_b R_b k9 ((sm 1)) ((p9))) True)    ; affords AND clears the gate
!(test (admissible? &ws O_a R_c k8 ((sm 1)) ((p8))) False)   ; affords (1 >= 1), dies at the gate

; (4) rank-queue pops BEST first; ties keep collection order ----------------------
!(test (car-atom (rank-queue &ws ((qcand R_c O_a kc () ()) (qcand R_b O_b kb () ()))))
       (qcand R_b O_b kb () ()))           ; the boosted rule jumps the queue
!(test (car-atom (rank-queue &ws ((qcand R_c O_a k1 () ()) (qcand R_c O_a k2 () ()))))
       (qcand R_c O_a k1 () ()))           ; equal scores -> collection order stands
