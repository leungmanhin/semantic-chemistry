; ============================================================================
; Experiment 1 — toy causal-QA — portable-facts DATA fixture
; ----------------------------------------------------------------------------
; 5 representative vignettes (V7 dual, V3 mechanism, V17 why-not, V20 abstain,
; V23 multi-cause) + edge-cluster vocabulary + both clamps + the chamber/worker.
; Schema: ../../ir/schema.md §2.1–2.8. Full corpus content: vignettes.md.
;
; This is DATA only — the organism's QA-strategy genome (rules) is authored with
; the P0 kernel, not here. Loads + round-trips in PeTTa:
;   sh /home/manhin/Dev/PeTTa/run.sh /home/manhin/Dev/semantic-chemistry/corpus/expt1-causal-qa/expt1_data.metta < /dev/null
;
; NOTE: exactly one !(add-atom ...) per line. `!` does NOT distribute across
; multiple expressions on a line — only the first would run.
; ============================================================================

; ---------------------------------------------------------------------------
; CHAMBER (context) — the Exp-1 causal-QA chamber, K-like (stable QA)
; ---------------------------------------------------------------------------
!(add-atom &mork (chamber CH_expt1))
!(add-atom &mork (chamber-context CH_expt1 causal-qa))
!(add-atom &mork (chamber-context CH_expt1 everyday))
!(add-atom &mork (chamber-life-history CH_expt1 K-like))

; ===========================================================================
; V7 · out-of-milk  — AMBIGUOUS-DUAL (physical antecedent + stated goal)
;   "Maria was out of milk. She drove to the store to buy a carton."
; ===========================================================================
!(add-atom &mork (sem-graph V7g))
!(add-atom &mork (sem-node V7g e1))
!(add-atom &mork (node-type V7g e1 OutOfMilk))
!(add-atom &mork (sem-node V7g maria))
!(add-atom &mork (node-type V7g maria Person))
!(add-atom &mork (sem-edge V7g r1 Experiencer e1 maria))
!(add-atom &mork (sem-node V7g e2))
!(add-atom &mork (node-type V7g e2 Drive))
!(add-atom &mork (sem-node V7g store))
!(add-atom &mork (node-type V7g store Store))
!(add-atom &mork (sem-edge V7g r2 Agent e2 maria))
!(add-atom &mork (sem-edge V7g r3 Destination e2 store))
!(add-atom &mork (sem-node V7g e3))
!(add-atom &mork (node-type V7g e3 Buy))
!(add-atom &mork (node-modal V7g e3 intended))
!(add-atom &mork (sem-node V7g carton))
!(add-atom &mork (node-type V7g carton Carton))
!(add-atom &mork (sem-edge V7g r4 Agent e3 maria))
!(add-atom &mork (sem-edge V7g r5 Theme e3 carton))
!(add-atom &mork (sem-node V7g g1))
!(add-atom &mork (node-type V7g g1 HaveMilk))
!(add-atom &mork (node-modal V7g g1 intended))
; explanatory edges
!(add-atom &mork (sem-edge V7g c1 CauseOf e1 e2))
!(add-atom &mork (edge-causal V7g c1 causal-forward))
!(add-atom &mork (sem-edge V7g c2 Motivates g1 e2))
!(add-atom &mork (sem-edge V7g c3 Enables e2 e3))
; task + ambiguous "why" with TWO class-tagged gold skeletons
!(add-atom &mork (qa-task T7))
!(add-atom &mork (qa-source T7 V7g))
!(add-atom &mork (qa-question T7 Q7a))
!(add-atom &mork (q-word Q7a why))
!(add-atom &mork (question-focus Q7a e2))
!(add-atom &mork (question-source Q7a V7g))
!(add-atom &mork (answer-skeleton Q7a SK7a_phys))
!(add-atom &mork (skeleton-class SK7a_phys physical-cause))
!(add-atom &mork (skeleton-cites SK7a_phys V7g c1))
!(add-atom &mork (skeleton-provenance SK7a_phys V7g e1))
!(add-atom &mork (answer-skeleton Q7a SK7a_int))
!(add-atom &mork (skeleton-class SK7a_int intentional))
!(add-atom &mork (skeleton-cites SK7a_int V7g c2))
!(add-atom &mork (skeleton-provenance SK7a_int V7g g1))
; second question: "what for" — goal only
!(add-atom &mork (qa-question T7 Q7b))
!(add-atom &mork (q-word Q7b what-for))
!(add-atom &mork (question-focus Q7b e2))
!(add-atom &mork (question-source Q7b V7g))
!(add-atom &mork (answer-skeleton Q7b SK7b_int))
!(add-atom &mork (skeleton-class SK7b_int intentional))
!(add-atom &mork (skeleton-cites SK7b_int V7g c2))
!(add-atom &mork (skeleton-provenance SK7b_int V7g g1))

; ===========================================================================
; V3 · power-spoil — HOW-MECHANISM (multi-hop chain, single-class physical)
;   "The power went out... the fridge stopped... the food had spoiled."
; ===========================================================================
!(add-atom &mork (sem-graph V3g))
!(add-atom &mork (sem-node V3g e1))
!(add-atom &mork (node-type V3g e1 PowerOut))
!(add-atom &mork (sem-node V3g e2))
!(add-atom &mork (node-type V3g e2 FridgeStopped))
!(add-atom &mork (sem-node V3g e3))
!(add-atom &mork (node-type V3g e3 FoodSpoiled))
!(add-atom &mork (sem-edge V3g c1 CauseOf e1 e2))
!(add-atom &mork (edge-causal V3g c1 causal-forward))
!(add-atom &mork (sem-edge V3g c2 CauseOf e2 e3))
!(add-atom &mork (edge-causal V3g c2 causal-forward))
!(add-atom &mork (qa-task T3))
!(add-atom &mork (qa-source T3 V3g))
!(add-atom &mork (qa-question T3 Q3a))
!(add-atom &mork (q-word Q3a how))
!(add-atom &mork (question-focus Q3a e3))
!(add-atom &mork (question-source Q3a V3g))
!(add-atom &mork (answer-skeleton Q3a SK3a))
!(add-atom &mork (skeleton-class SK3a physical-cause))
!(add-atom &mork (skeleton-cites SK3a V3g c1))
!(add-atom &mork (skeleton-cites SK3a V3g c2))
!(add-atom &mork (skeleton-provenance SK3a V3g e1))
!(add-atom &mork (skeleton-provenance SK3a V3g e3))

; ===========================================================================
; V17 · sprinklers — WHY-NOT (Prevents; the queried event is ·prevented)
;   "A fire started... the sprinklers switched on... it never spread."
; ===========================================================================
!(add-atom &mork (sem-graph V17g))
!(add-atom &mork (sem-node V17g e1))
!(add-atom &mork (node-type V17g e1 FireStart))
!(add-atom &mork (sem-node V17g e2))
!(add-atom &mork (node-type V17g e2 Spread))
!(add-atom &mork (node-modal V17g e2 prevented))
!(add-atom &mork (sem-node V17g e3))
!(add-atom &mork (node-type V17g e3 SprinklersOn))
!(add-atom &mork (sem-edge V17g p1 Prevents e3 e2))
!(add-atom &mork (qa-task T17))
!(add-atom &mork (qa-source T17 V17g))
!(add-atom &mork (qa-question T17 Q17))
!(add-atom &mork (q-word Q17 why-not))
!(add-atom &mork (question-focus Q17 e2))
!(add-atom &mork (question-source Q17 V17g))
!(add-atom &mork (answer-skeleton Q17 SK17))
!(add-atom &mork (skeleton-class SK17 physical-cause))
!(add-atom &mork (skeleton-cites SK17 V17g p1))
!(add-atom &mork (skeleton-provenance SK17 V17g e3))

; ===========================================================================
; V20 · streetlights — NEGATIVE (unsupported bridge → ABSTAIN)
;   "The streetlights came on at dusk. Maria drove to the store."
;   (no causal edge between e1 and e2 — co-occurrence only)
; ===========================================================================
!(add-atom &mork (sem-graph V20g))
!(add-atom &mork (sem-node V20g e1))
!(add-atom &mork (node-type V20g e1 StreetlightsOn))
!(add-atom &mork (sem-node V20g e2))
!(add-atom &mork (node-type V20g e2 Drive))
!(add-atom &mork (sem-node V20g maria))
!(add-atom &mork (node-type V20g maria Person))
!(add-atom &mork (sem-edge V20g r1 Agent e2 maria))
!(add-atom &mork (qa-task T20))
!(add-atom &mork (qa-source T20 V20g))
!(add-atom &mork (qa-question T20 Q20))
!(add-atom &mork (q-word Q20 why))
!(add-atom &mork (question-focus Q20 e2))
!(add-atom &mork (question-source Q20 V20g))
; abstain skeleton: no class/cites/provenance
!(add-atom &mork (answer-skeleton Q20 SK20))
!(add-atom &mork (skeleton-abstain SK20))

; ===========================================================================
; V23 · dense-cake — MULTI-CAUSE redundancy trap (two Contributes; cite BOTH)
;   "The cake was dense. ...too little baking powder, and ...overmixed..."
; ===========================================================================
!(add-atom &mork (sem-graph V23g))
!(add-atom &mork (sem-node V23g e1))
!(add-atom &mork (node-type V23g e1 Dense))
!(add-atom &mork (sem-node V23g k1src))
!(add-atom &mork (node-type V23g k1src TooLittlePowder))
!(add-atom &mork (sem-node V23g k2src))
!(add-atom &mork (node-type V23g k2src Overmixed))
!(add-atom &mork (sem-edge V23g k1 Contributes k1src e1))
!(add-atom &mork (sem-edge V23g k2 Contributes k2src e1))
!(add-atom &mork (qa-task T23))
!(add-atom &mork (qa-source T23 V23g))
!(add-atom &mork (qa-question T23 Q23))
!(add-atom &mork (q-word Q23 why))
!(add-atom &mork (question-focus Q23 e1))
!(add-atom &mork (question-source Q23 V23g))
!(add-atom &mork (answer-skeleton Q23 SK23))
!(add-atom &mork (skeleton-class SK23 physical-cause))
!(add-atom &mork (skeleton-cites SK23 V23g k1))
!(add-atom &mork (skeleton-cites SK23 V23g k2))
!(add-atom &mork (skeleton-provenance SK23 V23g k1src))
!(add-atom &mork (skeleton-provenance SK23 V23g k2src))

; ---------------------------------------------------------------------------
; EDGE-CLUSTER VOCABULARY — relation -> answer-class (vocabulary level)
; ---------------------------------------------------------------------------
!(add-atom &mork (edge-cluster CauseOf physical-cause))
!(add-atom &mork (edge-cluster Triggers physical-cause))
!(add-atom &mork (edge-cluster Enables physical-cause))
!(add-atom &mork (edge-cluster Contributes physical-cause))
!(add-atom &mork (edge-cluster Prevents physical-cause))
!(add-atom &mork (edge-cluster Despite concession))
!(add-atom &mork (edge-cluster Motivates intentional))
!(add-atom &mork (edge-cluster Reason intentional))

; ---------------------------------------------------------------------------
; CLAMPS — interim IR (a parameterization of MSC eq 17). The clamp-switch:
;   same snapshot+seed+budget, swap (worker-clamp W_expt1 …) -> different ACS.
; ---------------------------------------------------------------------------
!(add-atom &mork (clamp CL_antecedent))
!(add-atom &mork (clamp-class CL_antecedent physical-cause))
!(add-atom &mork (clamp-coeff CL_antecedent match 1.0))
!(add-atom &mork (clamp-coeff CL_antecedent unsupportedness 2.0))
!(add-atom &mork (clamp-coeff CL_antecedent redundancy 1.0))
!(add-atom &mork (clamp-token CL_antecedent skeleton-match tau_graph_match))
!(add-atom &mork (clamp-token CL_antecedent causal-citation tau_causal))
!(add-atom &mork (clamp-scope CL_antecedent CH_expt1))
!(add-atom &mork (clamp CL_goal))
!(add-atom &mork (clamp-class CL_goal intentional))
!(add-atom &mork (clamp-coeff CL_goal match 1.0))
!(add-atom &mork (clamp-coeff CL_goal unsupportedness 2.0))
!(add-atom &mork (clamp-token CL_goal skeleton-match tau_graph_match))
!(add-atom &mork (clamp-scope CL_goal CH_expt1))

; ---------------------------------------------------------------------------
; WORKER + REPLAY HANDLES — one context-chamber worker; clamp-antecedent active
; ---------------------------------------------------------------------------
!(add-atom &mork (chamber-graph CH_expt1 V7g))
!(add-atom &mork (chamber-graph CH_expt1 V3g))
!(add-atom &mork (chamber-graph CH_expt1 V17g))
!(add-atom &mork (chamber-graph CH_expt1 V20g))
!(add-atom &mork (chamber-graph CH_expt1 V23g))
!(add-atom &mork (worker W_expt1))
!(add-atom &mork (worker-kind W_expt1 context-chamber))
!(add-atom &mork (worker-backend W_expt1 petta))
!(add-atom &mork (worker-chamber W_expt1 CH_expt1))
!(add-atom &mork (worker-snapshot W_expt1 SNAP_e1))
!(add-atom &mork (worker-seed W_expt1 SEED_e1))
!(add-atom &mork (worker-budget-steps W_expt1 100))
!(add-atom &mork (worker-output-log W_expt1 LOG_e1))
!(add-atom &mork (worker-clamp W_expt1 CL_antecedent))
!(add-atom &mork (snapshot SNAP_e1 CH_expt1))
!(add-atom &mork (seed SEED_e1 7))
!(add-atom &mork (event-log LOG_e1))
!(add-atom &mork (log-chamber LOG_e1 CH_expt1))

; ===========================================================================
; SMOKE-TEST READ-BACK  (templates full-echo the pattern — &mork match idiom)
; ===========================================================================
; 1) all QA tasks
!(match &mork (qa-task $t) (qa-task $t))
; 2) V7's dual gold skeletons for the ambiguous "why" + all skeleton classes
!(match &mork (answer-skeleton Q7a $sk) (answer-skeleton Q7a $sk))
!(match &mork (skeleton-class $sk $cls) (skeleton-class $sk $cls))
; 3) the abstain skeleton (negative)
!(match &mork (skeleton-abstain $sk) (skeleton-abstain $sk))
; 4) node-modal markers (intended goals + prevented events)
!(match &mork (node-modal $g $n $m) (node-modal $g $n $m))
; 5) edge-cluster vocabulary
!(match &mork (edge-cluster $rel $cls) (edge-cluster $rel $cls))
; 6) the two clamps' classes + the active clamp
!(match &mork (clamp-class $cl $cls) (clamp-class $cl $cls))
!(match &mork (worker-clamp W_expt1 $cl) (worker-clamp W_expt1 $cl))
; 7) V23 multi-cause: both required cites
!(match &mork (skeleton-cites SK23 $g $e) (skeleton-cites SK23 $g $e))
