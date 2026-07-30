; Experiment 1 — CONTROL-TIER TASK FACTS: what the parser emits for the control genome, on top
; of the substrate molecules and questions it already emits (molecules.metta / tasks.metta are
; unchanged — a control-closed genome needs no new molecule shapes).
;
; One addition: a QUESTION-TYPE MARKER per question. The parser already classifies the question
; to build its answer-skeleton, so naming that type is a control-tier edge — and it is the
; genome's FOOD, the arriving task no rule regenerates. The marker sits on the TASK'S OWN graph,
; because it arrives with that task's text; the strategy's internal states (Attempting / Primed /
; Worked / Habit) live on the system-level control graph instead, since they outlive any one task.
; The stream of tasks the strategy is exercised over is the corpus itself: a reusable
; inference-control pattern is one that recurs over many questions of the same type.

(sem-edge V3g wq_v3q1 WhyQuestion V3_q1)
(sem-edge V4g wq_v4q1 WhyQuestion V4_q1)
(sem-edge V5g wq_v5q1 WhyQuestion V5_q1)
