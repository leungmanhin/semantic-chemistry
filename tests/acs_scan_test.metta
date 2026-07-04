; ===========================================================================
; acs-scan + replay: the P2 ACS certification (TECAN T3).
; ---------------------------------------------------------------------------
; Certify a HAND-GIVEN candidate (the whole genome) via the reusable ACS logic in
; petta/acs.metta. Three findings, 16 tests (canonical per-match form):
;  * REPLAY/ABLATION (cond 4): suppress one rule in its own space, generous fuel;
;    R_qtype/R_align/R_project are load-bearing (answers collapse), R_complete is
;    INERT (6->6, 0 reward impact) — the same dead-weight rule P3 prunes.
;  * CLOSURE (cond 1+2): reachability on the (hand-drawn) rule-motif graph — a closed
;    metabolic cycle exists with the evaluator's E->fuel edge (True), NOT among the soma
;    rules alone (False) => closure is METABOLIC, not structural. (The MINER derives this
;    graph from the log instead — tests/acs_mine_test.metta.)
;  * SURPLUS (cond 3) + PROMOTION: the FULL genome runs a DEFICIT (income 25 < spend 28);
;    the autocatalytic CORE (R_complete pruned) spends only 19, so income - spend = +6 under
;    CL_antecedent vs -3 under CL_goal; the SAME core is PROMOTED under one clamp, REJECTED
;    under the other (clamp-switch).
;
; Run:  sh ../PeTTa/run.sh tests/acs_scan_test.metta < /dev/null \
;          2>&1 | grep should   # sixteen ✅
; ===========================================================================
!(import! &self "petta/util.metta")
!(import! &self "petta/fuel.metta")
!(import! &self "petta/compiler.metta")
!(import! &self "petta/gate.metta")
!(import! &self "petta/reaction.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")
!(import! &self "petta/evaluator.metta")
!(import! &self "petta/acs.metta")   ; ablate-answers · reachability · gm-surplus · all3

; --- REPLAY/ABLATION (cond 4): base 6 answers; R_complete INERT (0 loss) = prune candidate
!(bind! &ab_base (new-space))
!(bind! &ab_qt (new-space))
!(bind! &ab_al (new-space))
!(bind! &ab_cp (new-space))
!(bind! &ab_pj (new-space))
!(test (ablate-answers none &ab_base) 6)        ; baseline: all answers
!(test (ablate-answers R_qtype &ab_qt) 0)       ; load-bearing (no typing -> nothing)
!(test (ablate-answers R_align &ab_al) 0)       ; load-bearing (no alignment -> no answers)
!(test (ablate-answers R_complete &ab_cp) 6)    ; INERT: costs fuel, 0 reward impact
!(test (ablate-answers R_project &ab_pj) 0)     ; load-bearing (no projection -> no answers)

; --- CLOSURE (cond 1+2): the hand-drawn rule-motif graph; E-edges only in &acs_full
(= (soma-edges) ((medge gm R_qtype) (medge gm R_align) (medge gm R_complete) (medge gm R_project) (medge R_qtype q-intent) (medge q-intent R_align) (medge R_align alignment) (medge alignment R_project) (medge alignment R_complete) (medge R_complete role-fill) (medge R_project candidate-answer)))
!(bind! &acs_full (new-space))
!(bind! &acs_soma (new-space))
!(add-edges &acs_full (soma-edges))
!(add-edges &acs_soma (soma-edges))
!(add-atom &acs_full (medge candidate-answer E))
!(add-atom &acs_full (medge E gm))
!(test (cycle-through &acs_full gm) True)        ; rules + evaluator: a closed metabolic cycle EXISTS
!(test (cycle-through &acs_soma gm) False)       ; soma rules ALONE: feed-forward DAG (no cycle)

; --- SURPLUS (cond 3): full genome DEFICIT vs certified CORE surplus (sign flips with clamp)
!(test (gm-income &ab_base physical-cause) 25)   ; CL_antecedent mints on physical-cause + abstain
!(test (gm-income &ab_base intentional) 16)      ; CL_goal mints on intentional + abstain
!(test (gm-spend &ab_base) 28)                   ; FULL genome firings
!(test (gm-surplus &ab_base physical-cause) -3)  ; FULL genome: DEFICIT (inert R_complete's dead weight)
!(test (gm-spend &ab_cp) 19)                     ; CORE firings (R_complete pruned, certified inert above)
!(test (gm-surplus &ab_cp physical-cause) 6)     ; CORE under CL_antecedent: +6 SURPLUS
!(test (gm-surplus &ab_cp intentional) -3)       ; CORE under CL_goal: -3 DEFICIT (clamp-switch)

; --- PROMOTION: closure AND core-surplus>0 AND ablation-impact>0 (impact = base - ablate R_qtype)
(= (impact) (- (count-answers &ab_base) (count-answers &ab_qt)))
(= (promoted? $cc) (all3 (cycle-through &acs_full gm) (> (gm-surplus &ab_cp $cc) 0) (> (impact) 0)))
!(test (promoted? physical-cause) True)          ; closure + core-surplus>0 + impact>0 -> PROMOTED
!(test (promoted? intentional) False)            ; same core, negative surplus -> REJECTED (clamp-switch)
