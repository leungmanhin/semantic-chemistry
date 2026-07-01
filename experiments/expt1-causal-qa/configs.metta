; Experiment 1 — CONFIGS, pure portable facts. Two sections:
;  (1) causal-QA DOMAIN MAPPINGS — edge clusters + q-word intent map. Family knowledge
;      (reusable across causal-QA experiments), read as facts by the rules + evaluator.
;      Factor to a shared file when a second causal-QA experiment appears.
;  (2) RUN CONFIG — Exp-1 instance: clamps, chamber, worker, snapshot, seed.

; --- (1) domain mappings -------------------------------------------------------
(edge-cluster CauseOf physical-cause)
(edge-cluster Trigger physical-cause)
(edge-cluster Enable physical-cause)
(edge-cluster Contribute physical-cause)
(edge-cluster Prevent physical-cause)
(edge-cluster Despite concession)
(edge-cluster Motivate intentional)
(edge-cluster Reason intentional)
(intent-map why explain)
(intent-map what-made explain)
(intent-map how-come explain)
(intent-map what-for explain-goal)
(intent-map trying-to-do explain-goal)
(intent-map how explain-mechanism)
(intent-map why-not explain-prevention)
(intent-allows explain physical-cause)
(intent-allows explain intentional)
(intent-allows explain-goal intentional)
(intent-allows explain-mechanism physical-cause)
(intent-allows explain-prevention physical-cause)
(explanatory physical-cause)
(explanatory intentional)
; role relations (non-causal participant edges) — the POSITIVE complement of edge-cluster,
; so role-completion (R_complete) matches them without a negation.
(role-relation Agent)
(role-relation Experiencer)
(role-relation Theme)
(role-relation Destination)
(role-relation Patient)

; --- (2) run configuration -----------------------------------------------------
(chamber CH_expt1)
(chamber-context CH_expt1 causal-qa)
(chamber-context CH_expt1 everyday)
(chamber-life-history CH_expt1 K-like)

; --- organism (schema §2.3): Exp-1 runs the whole genome as ONE mortal organism O_qa.
; Its genome GNM_qa quotes the ruleset RS_qa (the 4 causal-QA rules); the engine resolves
; each rule -> O_qa (rule-organism) so O_qa's typed purse `(fuel O_qa …)` pays for firing.
(organism O_qa)
(organism-chamber O_qa CH_expt1)
(genome-of O_qa GNM_qa)
(quoted-ruleset GNM_qa RS_qa)
(ruleset-member RS_qa R_qtype)
(ruleset-member RS_qa R_align)
(ruleset-member RS_qa R_complete)
(ruleset-member RS_qa R_project)

(clamp CL_antecedent)
(clamp-class CL_antecedent physical-cause)
(clamp-coeff CL_antecedent match 1.0)
(clamp-coeff CL_antecedent unsupportedness 2.0)
(clamp-coeff CL_antecedent redundancy 1.0)
(clamp-token CL_antecedent skeleton-match gm)
(clamp-token CL_antecedent causal-citation ci)
(clamp-scope CL_antecedent CH_expt1)

(clamp CL_goal)
(clamp-class CL_goal intentional)
(clamp-coeff CL_goal match 1.0)
(clamp-coeff CL_goal unsupportedness 2.0)
(clamp-token CL_goal skeleton-match gm)
(clamp-scope CL_goal CH_expt1)
(chamber-graph CH_expt1 V7g)
(chamber-graph CH_expt1 V3g)
(chamber-graph CH_expt1 V17g)
(chamber-graph CH_expt1 V20g)
(chamber-graph CH_expt1 V23g)

(worker W_expt1)
(worker-kind W_expt1 context-chamber)
(worker-backend W_expt1 petta)
(worker-chamber W_expt1 CH_expt1)
(worker-snapshot W_expt1 SNAP_e1)
(worker-seed W_expt1 SEED_e1)
(worker-budget-steps W_expt1 100)
(worker-output-log W_expt1 LOG_e1)
(worker-clamp W_expt1 CL_antecedent)
(snapshot SNAP_e1 CH_expt1)
; the snapshot's fuel endowment — what a worker launched from it starts with
(snapshot-fuel SNAP_e1 gm 30)
(snapshot-fuel SNAP_e1 ci 10)
(seed SEED_e1 7)
(event-log LOG_e1)
(log-chamber LOG_e1 CH_expt1)
