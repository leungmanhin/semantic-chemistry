; Experiment 1 — the QA BENCHMARK, pure portable facts in §10.1 sem-graph IR, parser-derived:
; questions + their ANSWER-SKELETONS (the parser's variable-bearing queries; (var _) slots;
; alternative readings = multiple skeletons; the query TV is kept as answer-skeleton-tv —
; e.g. a why-not question pins (STV 0.0 (var conf))). A question licenses ONE ReasonFor —
; answer plurality and depth come from the genome, never from the query shape. No gold
; answer content is stored: answering = grounding a skeleton against the derived graph.

; --- V3 questions
(qa-task V3)
(qa-question V3 V3_q1)
(question-surface V3_q1 "Why did the food spoil?")
(answer-skeleton V3_q1 V3_q1_as1)
(sem-graph V3_q1_as1)
(sem-graph-kind V3_q1_as1 answer-skeleton)
(answer-skeleton-tv V3_q1_as1 (var tv))
(sem-edge V3_q1_as1 V3_q1_as1_c1 Member (var e) spoil)
(sem-edge V3_q1_as1 V3_q1_as1_c2 Patient (var e) (var f))
(sem-edge V3_q1_as1 V3_q1_as1_c3 Member (var f) food)
(sem-edge V3_q1_as1 V3_q1_as1_c4 Past (var e))
(sem-edge V3_q1_as1 V3_q1_as1_c5 ReasonFor (var w) (var e))
