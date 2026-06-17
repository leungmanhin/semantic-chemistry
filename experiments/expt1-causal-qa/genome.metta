; ============================================================================
; P0 Experiment-1 organism genome — composing QA-strategy pipeline.
; ----------------------------------------------------------------------------
; Portable facts: organism O_qa, its quoted ruleset, typed fuel, and FOUR
; QA-strategy rules that compose through the chamber's live working state X
; (each rule's products are added to X and matched by the next stage).
;
; Pipeline (rule-priority enforces the staged order; data dependencies also do):
;   R_qtype   (pri 0)  question-type-detector + paraphrase-collapse:
;                      q-word -> (q-intent Q intent)
;   R_align   (pri 1)  causal-alignment: consumes q-intent; for explanatory
;                      edges into the focus (filtered by intent's class), emits
;                      (alignment AL Q cls) + (alignment-cites ...) + (alignment-prov ...);
;                      abstains when the focus has no explanatory edge.
;   R_complete(pri 2)  role-completion: enriches an alignment with the cause's
;                      participants -> (role-fill AL Role Filler)
;   R_project (pri 3)  answer-skeleton-projection: assembles the final
;                      (candidate-answer Q A) + class + cites + provenance + roles.
;
; Maps to MSC Exp-1's expected ACS rules (§7.1): question-type detector,
; causal-alignment, role-completion, paraphrase-collapse (folded into R_qtype),
; answer-skeleton projection. Still TODO (noted in src/README.md):
; compact-explanation-packer (multi-hop mechanism compression).
;
; P0 SHORTCUT (flagged): each rule's match/produce logic is kernel-resident
; ((rule-impl R kernel-resident)), NOT yet a portable rule-lhs/rule-rhs pattern
; graph. Lift before P3 (a genome must be data to mutate).
; ============================================================================

; --- organism O_qa, in the Exp-1 chamber ---
(organism O_qa)
(organism-chamber O_qa CH_expt1)
(genome-of O_qa GNM_qa)
(quoted-ruleset GNM_qa RS_qa)
(ruleset-member RS_qa R_qtype)
(ruleset-member RS_qa R_align)
(ruleset-member RS_qa R_complete)
(ruleset-member RS_qa R_project)

; --- R_qtype: question-type detector + paraphrase-collapse ---
(sem-rule R_qtype)
(rule-context R_qtype causal-qa)
(rule-impl R_qtype kernel-resident)
(rule-priority R_qtype 0)
(rule-token-cost R_qtype tau_graph_match 1)
(chamber-hot-rule CH_expt1 R_qtype)

; --- R_align: causal-alignment (consumes q-intent; cites cost a causal token) ---
(sem-rule R_align)
(rule-context R_align causal-qa)
(rule-impl R_align kernel-resident)
(rule-priority R_align 1)
(rule-token-cost R_align tau_graph_match 1)
(rule-token-cost R_align tau_causal 1)
(chamber-hot-rule CH_expt1 R_align)

; --- R_complete: role-completion ---
(sem-rule R_complete)
(rule-context R_complete causal-qa)
(rule-impl R_complete kernel-resident)
(rule-priority R_complete 2)
(rule-token-cost R_complete tau_graph_match 1)
(chamber-hot-rule CH_expt1 R_complete)

; --- R_project: answer-skeleton projection (final answer) ---
(sem-rule R_project)
(rule-context R_project causal-qa)
(rule-impl R_project kernel-resident)
(rule-priority R_project 3)
(rule-token-cost R_project tau_graph_match 1)
(chamber-hot-rule CH_expt1 R_project)

; --- typed fuel vector F_O (hand-seeded for P0; earning it is P1's evaluator) ---
;     Tuned so the pipeline runs most questions fully through all stages but
;     STARVES before projecting the last one — mortality mid-pipeline, and the
;     starvation is on tau_graph_match here (every stage needs it).
(fuel O_qa tau_graph_match 20)
(fuel O_qa tau_causal 6)
