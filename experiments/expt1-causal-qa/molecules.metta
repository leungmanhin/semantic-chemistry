; Experiment 1 — MOLECULES, pure portable facts in §10.1 sem-graph IR, parser-derived:
; the semantic parser (surface level: discourse cues, no causal relations) over corpus.json
; -> corpus_parsed.json -> this file via ir/to_semgraph.py. Each parsed atom
; (: id (Rel args) tv) -> (sem-edge G id Rel args) + (sem-edge-tv G id tv): splayed,
; variable-arity, nesting kept verbatim, TVs intact, $var -> (var var); a nested relation
; arg identical to an existing statement is referenced by its edge-id; statement-level
; (And …) compounds decompose into TV-less operand edges (the And is the sole truth-bearer).

; --- V3: The power went out during the storm, so the fridge stopped running, and as a result the food had spoiled by morning.
(sem-graph V3g)
(sem-graph-kind V3g neo-davidsonian)
(sem-edge V3g v3_goout_m Member sk_go_out_1 go_out)
(sem-edge-tv V3g v3_goout_m (STV 1.0 0.99))
(sem-edge V3g v3_goout_pat Patient sk_go_out_1 sk_power_1)
(sem-edge-tv V3g v3_goout_pat (STV 1.0 0.99))
(sem-edge V3g v3_power_m Member sk_power_1 power)
(sem-edge-tv V3g v3_power_m (STV 1.0 0.99))
(sem-edge V3g v3_goout_past Past sk_go_out_1)
(sem-edge-tv V3g v3_goout_past (STV 1.0 0.99))
(sem-edge V3g v3_goout_during During sk_go_out_1 sk_storm_1)
(sem-edge-tv V3g v3_goout_during (STV 1.0 0.99))
(sem-edge V3g v3_storm_m Member sk_storm_1 storm)
(sem-edge-tv V3g v3_storm_m (STV 1.0 0.99))
(sem-edge V3g v3_stop_m Member sk_stop_1 stop)
(sem-edge-tv V3g v3_stop_m (STV 1.0 0.99))
(sem-edge V3g v3_stop_ag Agent sk_stop_1 sk_fridge_1)
(sem-edge-tv V3g v3_stop_ag (STV 1.0 0.99))
(sem-edge V3g v3_fridge_m Member sk_fridge_1 fridge)
(sem-edge-tv V3g v3_fridge_m (STV 1.0 0.99))
(sem-edge V3g v3_stop_th Theme sk_stop_1 sk_run_1)
(sem-edge-tv V3g v3_stop_th (STV 1.0 0.99))
(sem-edge V3g v3_run_m Member sk_run_1 run)
(sem-edge-tv V3g v3_run_m (STV 1.0 0.99))
(sem-edge V3g v3_stop_past Past sk_stop_1)
(sem-edge-tv V3g v3_stop_past (STV 1.0 0.99))
(sem-edge V3g v3_spoil_m Member sk_spoil_1 spoil)
(sem-edge-tv V3g v3_spoil_m (STV 1.0 0.99))
(sem-edge V3g v3_spoil_pat Patient sk_spoil_1 sk_food_1)
(sem-edge-tv V3g v3_spoil_pat (STV 1.0 0.99))
(sem-edge V3g v3_food_m Member sk_food_1 food)
(sem-edge-tv V3g v3_food_m (STV 1.0 0.99))
(sem-edge V3g v3_spoil_past Past sk_spoil_1)
(sem-edge-tv V3g v3_spoil_past (STV 1.0 0.99))
(sem-edge V3g v3_spoil_time TimeAtMost sk_spoil_1 morning)
(sem-edge-tv V3g v3_spoil_time (STV 1.0 0.99))
(sem-edge V3g v3_conn1 So sk_go_out_1 sk_stop_1)
(sem-edge-tv V3g v3_conn1 (STV 1.0 0.99))
(sem-edge V3g v3_conn2 AsAResult sk_stop_1 sk_spoil_1)
(sem-edge-tv V3g v3_conn2 (STV 1.0 0.99))
