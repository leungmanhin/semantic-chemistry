; Experiment 1 — TASKS (the QA benchmark): questions only. No gold answer content is
; stored — the evaluator (petta/evaluator.metta) derives the ideal answer Y*_q from
; the molecule graph (intent-aware), so correctness is scored against the graph, not gold.

(qa-task T7)
(qa-source T7 V7g)
(qa-question T7 Q7a)
(q-word Q7a why)
(question-focus Q7a v7_drive)
(question-source Q7a V7g)
(qa-question T7 Q7b)
(q-word Q7b what-for)
(question-focus Q7b v7_drive)
(question-source Q7b V7g)

(qa-task T3)
(qa-source T3 V3g)
(qa-question T3 Q3a)
(q-word Q3a how)
(question-focus Q3a v3_spoil)
(question-source Q3a V3g)

(qa-task T17)
(qa-source T17 V17g)
(qa-question T17 Q17)
(q-word Q17 why-not)
(question-focus Q17 v17_spread)
(question-source Q17 V17g)

(qa-task T20)
(qa-source T20 V20g)
(qa-question T20 Q20)
(q-word Q20 why)
(question-focus Q20 v20_drive)
(question-source Q20 V20g)

(qa-task T23)
(qa-source T23 V23g)
(qa-question T23 Q23)
(q-word Q23 why)
(question-focus Q23 v23_dense)
(question-source Q23 V23g)
