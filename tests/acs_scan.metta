; ===========================================================================
; P4.3 (ii) — acs-scan + replay WORKERS: the P2 ACS-detection (TECAN T3).
; ---------------------------------------------------------------------------
; The P2 mortal-ACS certification (= TECAN T3) as worker kinds over the
; separate-space machinery. Three findings, all 16 tests (canonical per-match form):
;  * REPLAY/ABLATION (cond 4): suppress one rule in its own space, generous fuel;
;    R_qtype/R_align/R_project are load-bearing (answers collapse), R_complete is
;    INERT (6->6, 0 reward impact) — the same dead-weight rule P3 prunes.
;  * CLOSURE (cond 1+2): reachability on the rule-motif graph — a closed metabolic
;    cycle exists with the evaluator's E->fuel edge (cycle-through gm = True) but
;    NOT among the soma rules alone (False) => closure is METABOLIC, not structural.
;  * SURPLUS (cond 3) + PROMOTION: the FULL genome runs a DEFICIT (income 25 < spend 28,
;    the inert R_complete's 9 firings are dead weight). The autocatalytic CORE (R_complete
;    pruned) spends only 19, so income - spend = +6 under CL_antecedent vs -3 under CL_goal;
;    the SAME core is PROMOTED under one clamp and REJECTED under the other (clamp-switch).
;
; Run:  sh ../PeTTa/run.sh tests/acs_scan.metta < /dev/null \
;          2>&1 | grep should   # sixteen ✅
; ===========================================================================
!(import! &self "petta/kernel_defs.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")
!(import! &self "petta/evaluator_defs.metta")  ; covered/anssize/skelsize/would-mint/gm-income/gm-spend/count-answers

; ===========================================================================
; REPLAY / ABLATION (cond 4 — causal influence): run the kernel on $ws but SKIP
; one rule (a do-intervention) in its own space, generous fuel so the effect is
; STRUCTURAL not starvation; measure answers lost.
; ===========================================================================
; ablation = run the canonical genome on $ws but SKIP the named rule (the generic run-ablate
; from kernel_defs walks sorted-rules, skipping any in the list); generous fuel so the effect
; is STRUCTURAL, not starvation. `none` skips nothing (the baseline). (count-answers from evaluator_defs.)
(= (ablate-answers $skip $sp) (let $z1 (add-atom $sp (fuel gm 30)) (let $z2 (add-atom $sp (fuel ci 30)) (let $z3 (run-ablate $sp (cons-atom $skip ())) (count-answers $sp)))))

!(bind! &ab_base (new-space))
!(bind! &ab_qt (new-space))
!(bind! &ab_al (new-space))
!(bind! &ab_cp (new-space))
!(bind! &ab_pj (new-space))
; ablation impact (vs base 6): R_complete is INERT (0 loss) -> the prune candidate
!(test (ablate-answers none &ab_base) 6)        ; baseline: all answers
!(test (ablate-answers R_qtype &ab_qt) 0)       ; load-bearing (no typing -> nothing)
!(test (ablate-answers R_align &ab_al) 0)       ; load-bearing (no alignment -> no answers)
!(test (ablate-answers R_complete &ab_cp) 6)    ; INERT: costs fuel, 0 reward impact (prune candidate)
!(test (ablate-answers R_project &ab_pj) 0)     ; load-bearing (no projection -> no answers)

; ===========================================================================
; CLOSURE (cond 1+2): the rule-motif graph. Reachability with a visited set
; (terminates on cycles). cycle-through gm = "is fuel reachable from fuel" — i.e.
; does a closed metabolic loop exist? It does ONLY with the evaluator's E->gm edge.
; ===========================================================================
(= (succs $g $node) (collapse (match $g (medge $node $t) $t)))
(= (member-of $x $l) (case $l ((() False) ($ne (if (== (car-atom $l) $x) True (member-of $x (cdr-atom $l)))))))
(= (app $a $b) (case $a ((() $b) ($ne (cons-atom (car-atom $a) (app (cdr-atom $a) $b))))))
(= (any-reaches $g $frontier $goal $seen) (case $frontier ((() False) ($ne (let $h (car-atom $frontier) (if (== $h $goal) True (if (member-of $h $seen) (any-reaches $g (cdr-atom $frontier) $goal $seen) (any-reaches $g (app (succs $g $h) (cdr-atom $frontier)) $goal (cons-atom $h $seen)))))))))
(= (cycle-through $g $node) (any-reaches $g (succs $g $node) $node ()))

; shared edges (soma chain + fuel consumption) as a list; E-edges added only to &acs_full
(= (soma-edges) ((medge gm R_qtype) (medge gm R_align) (medge gm R_complete) (medge gm R_project) (medge R_qtype q-intent) (medge q-intent R_align) (medge R_align alignment) (medge alignment R_project) (medge alignment R_complete) (medge R_complete role-fill) (medge R_project candidate-answer)))
(= (add-edges $g $es) (case $es ((() done) ($ne (let $h (car-atom $es) (let $z (add-atom $g $h) (add-edges $g (cdr-atom $es))))))))
!(bind! &acs_full (new-space))
!(bind! &acs_soma (new-space))
!(add-edges &acs_full (soma-edges))
!(add-edges &acs_soma (soma-edges))
; the evaluator's closing edges (answer -> E -> fuel) — ONLY in the full graph
!(add-atom &acs_full (medge candidate-answer E))
!(add-atom &acs_full (medge E gm))
!(test (cycle-through &acs_full gm) True)       ; rules + evaluator: a closed metabolic cycle EXISTS
!(test (cycle-through &acs_soma gm) False)      ; soma rules ALONE: feed-forward DAG (no cycle)

; ===========================================================================
; SURPLUS (cond 3) + PROMOTION: income (eq-17 mint by clamp class) - spend (firings).
; The FULL genome carries inert R_complete (9 firings) -> spend > income -> DEFICIT;
; the autocatalytic CORE (R_complete pruned, certified inert above) is self-sustaining,
; and its surplus sign flips with the clamp -> promote one class, reject the other.
; ===========================================================================
; (covered/anssize/skelsize/would-mint/gm-income/gm-spend from evaluator_defs)
(= (gm-surplus $ws $cc) (- (gm-income $ws $cc) (gm-spend $ws)))

!(test (gm-income &ab_base physical-cause) 25)  ; CL_antecedent mints on physical-cause + abstain
!(test (gm-income &ab_base intentional) 16)     ; CL_goal mints on intentional + abstain
!(test (gm-spend &ab_base) 28)                  ; FULL genome firings (each spends 1 gm)
!(test (gm-surplus &ab_base physical-cause) -3) ; FULL genome: DEFICIT (inert R_complete's dead weight)
!(test (gm-spend &ab_cp) 19)                    ; CORE firings (R_complete pruned, certified inert above)
!(test (gm-surplus &ab_cp physical-cause) 6)    ; CORE under CL_antecedent: +6 SURPLUS (self-sustaining)
!(test (gm-surplus &ab_cp intentional) -3)      ; CORE under CL_goal: -3 DEFICIT (sign flips with the clamp)

; promotion: closure AND core-surplus>0 AND ablation-impact>0 (impact = base - ablate R_qtype)
(= (impact) (- (count-answers &ab_base) (count-answers &ab_qt)))
(= (all3 $a $b $c) (if $a (if $b (if $c True False) False) False))
(= (promoted? $cc) (all3 (cycle-through &acs_full gm) (> (gm-surplus &ab_cp $cc) 0) (> (impact) 0)))
!(test (promoted? physical-cause) True)         ; closure + core-surplus>0 + impact>0 -> PROMOTED
!(test (promoted? intentional) False)           ; same core, negative surplus -> REJECTED (clamp-switch)
