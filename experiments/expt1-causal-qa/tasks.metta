; Experiment 1 — the QA BENCHMARK, pure portable facts in §10.1 sem-graph IR, parser-derived:
; questions + their ANSWER-SKELETONS (the parser's variable-bearing queries; (var _) slots;
; alternative readings = multiple skeletons; the query TV is kept as answer-skeleton-tv —
; e.g. a why-not question pins (STV 0.0 (var conf))). A question licenses ONE ReasonFor —
; answer plurality and depth come from the genome, never from the query shape. No gold
; answer content is stored: answering = grounding a skeleton against the derived graph.

; --- V3 questions
(qa-task V3)
(task-graph V3 V3g)
(qa-question V3 V3_q1)
(question-surface V3_q1 "Why did the food spoil?")
(sem-edge V3g qt_V3_q1 WhyQuestion V3_q1)
(answer-skeleton V3_q1 V3_q1_as1)
(sem-graph V3_q1_as1)
(sem-graph-kind V3_q1_as1 answer-skeleton)
(answer-skeleton-tv V3_q1_as1 (var tv))
(sem-edge V3_q1_as1 V3_q1_as1_c1 Member (var e) spoil)
(sem-edge V3_q1_as1 V3_q1_as1_c2 Patient (var e) (var f))
(sem-edge V3_q1_as1 V3_q1_as1_c3 Member (var f) food)
(sem-edge V3_q1_as1 V3_q1_as1_c4 Past (var e))
(sem-edge V3_q1_as1 V3_q1_as1_c5 ReasonFor (var w) (var e))

; --- V4 questions
(qa-task V4)
(task-graph V4 V4g)
(qa-question V4 V4_q1)
(question-surface V4_q1 "Why did the shops lose business?")
(sem-edge V4g qt_V4_q1 WhyQuestion V4_q1)
(answer-skeleton V4_q1 V4_q1_as1)
(sem-graph V4_q1_as1)
(sem-graph-kind V4_q1_as1 answer-skeleton)
(answer-skeleton-tv V4_q1_as1 (var tv))
(sem-edge V4_q1_as1 V4_q1_as1_c1 Member (var e) lose)
(sem-edge V4_q1_as1 V4_q1_as1_c2 Agent (var e) (var f))
(sem-edge V4_q1_as1 V4_q1_as1_c3 Member (var f) shop)
(sem-edge V4_q1_as1 V4_q1_as1_c4 Past (var e))
(sem-edge V4_q1_as1 V4_q1_as1_c5 ReasonFor (var w) (var e))

; --- V5 questions
(qa-task V5)
(task-graph V5 V5g)
(qa-question V5 V5_q1)
(question-surface V5_q1 "Why did the market empty?")
(sem-edge V5g qt_V5_q1 WhyQuestion V5_q1)
(answer-skeleton V5_q1 V5_q1_as1)
(sem-graph V5_q1_as1)
(sem-graph-kind V5_q1_as1 answer-skeleton)
(answer-skeleton-tv V5_q1_as1 (var tv))
(sem-edge V5_q1_as1 V5_q1_as1_c1 Member (var e) empty)
(sem-edge V5_q1_as1 V5_q1_as1_c2 Patient (var e) (var f))
(sem-edge V5_q1_as1 V5_q1_as1_c3 Member (var f) market)
(sem-edge V5_q1_as1 V5_q1_as1_c4 Past (var e))
(sem-edge V5_q1_as1 V5_q1_as1_c5 ReasonFor (var w) (var e))
