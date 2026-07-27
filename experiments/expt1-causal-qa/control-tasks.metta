; Experiment 1 — CONTROL-TIER TASK FACTS: what the parser emits for the control genome, on top
; of the substrate molecules and questions it already emits (molecules.metta / tasks.metta are
; unchanged — a control-closed genome needs no new molecule shapes).
;
; Two additions. First, a QUESTION-TYPE MARKER per question: the parser already classifies the
; question to build its answer-skeleton, so naming that type is a control-tier edge on the
; control graph, and it is the genome's FOOD — the arriving task no rule regenerates. Second, a
; SECOND question over the same molecules, so the strategy is exercised across a stream rather
; than a single task: a reusable inference-control pattern is one that recurs over many questions
; of the same type.

; --- the arriving why-questions (control-tier food) ---
(sem-edge ctrlg wq_v3q1 WhyQuestion V3_q1)
(sem-edge ctrlg wq_v3q2 WhyQuestion V3_q2)

; --- V3_q2: a one-hop sibling of V3_q1 over the same molecule graph ---
(qa-question V3 V3_q2)
(question-surface V3_q2 "Why did the fridge stop running?")
(answer-skeleton V3_q2 V3_q2_as1)
(sem-graph V3_q2_as1)
(sem-graph-kind V3_q2_as1 answer-skeleton)
(answer-skeleton-tv V3_q2_as1 (var tv))
(sem-edge V3_q2_as1 V3_q2_as1_c1 Member (var e) stop)
(sem-edge V3_q2_as1 V3_q2_as1_c2 Agent (var e) (var f))
(sem-edge V3_q2_as1 V3_q2_as1_c3 Member (var f) fridge)
(sem-edge V3_q2_as1 V3_q2_as1_c4 Past (var e))
(sem-edge V3_q2_as1 V3_q2_as1_c5 ReasonFor (var w) (var e))
