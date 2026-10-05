; Experiment 2 — NORMALIZERS: hand-written rules that bridge two renderings of one meaning, as Exp-1's genome
; normalizes discourse cues. The parser writes the same content in more than one shape, and a question may use the
; other one; these rules derive the second shape from the first. Per-match rule-lhs / rule-rhs IR in the form
; rules.metta uses (one graph variable per clause, uppercase synthetic variables, a firing's products as one new graph
; named by the firing, the authored truth value on rule-tv and every product); context aelmere; priorities above the
; landed laws'.

; --- N_use: an instrument of an event is used, by the event's agent, for that event — "the Keeper extinguishes the
; flame with a brass snuffer" is "the Keeper uses a brass snuffer to extinguish the flame"
(sem-rule N_use)
(rule-context N_use aelmere)
(rule-priority N_use 1000)
(rule-tv N_use authored 1.0 0.9)
(rule-lhs N_use ((sem-edge (var G1) (var E1) Instrument (var e) (var x)) (sem-edge (var G2) (var E2) Agent (var e) (var a))))
(rule-rhs N_use ((sem-graph-kind (N_use (var E1) (var E2)) neo-davidsonian)
                 (sem-edge (N_use (var E1) (var E2)) (N_use_p1 (var E1) (var E2)) Member (N_use_sk_use (var e)) use)
                 (sem-edge-tv (N_use (var E1) (var E2)) (N_use_p1 (var E1) (var E2)) (STV 1.0 0.9))
                 (sem-edge (N_use (var E1) (var E2)) (N_use_p2 (var E1) (var E2)) Agent (N_use_sk_use (var e)) (var a))
                 (sem-edge-tv (N_use (var E1) (var E2)) (N_use_p2 (var E1) (var E2)) (STV 1.0 0.9))
                 (sem-edge (N_use (var E1) (var E2)) (N_use_p3 (var E1) (var E2)) Object (N_use_sk_use (var e)) (var x))
                 (sem-edge-tv (N_use (var E1) (var E2)) (N_use_p3 (var E1) (var E2)) (STV 1.0 0.9))
                 (sem-edge (N_use (var E1) (var E2)) (N_use_p4 (var E1) (var E2)) For (N_use_sk_use (var e)) (var e))
                 (sem-edge-tv (N_use (var E1) (var E2)) (N_use_p4 (var E1) (var E2)) (STV 1.0 0.9))))

; --- N_keepers: every Keeper belongs to the Keepers, the body the corpus refers to as a whole (the_keepers; its
; mentions are identified in parse_corrections.json), so a statement about the body reaches its members through
; the group conventions, and a newly invested Keeper joins it
(sem-rule N_keepers)
(rule-context N_keepers aelmere)
(rule-priority N_keepers 1001)
(rule-tv N_keepers authored 1.0 0.9)
(rule-lhs N_keepers ((sem-edge (var G1) (var E1) Member (var x) keeper)))
(rule-rhs N_keepers ((sem-graph-kind (N_keepers (var E1)) neo-davidsonian)
                     (sem-edge (N_keepers (var E1)) (N_keepers_p1 (var E1)) PartOf (var x) the_keepers)
                     (sem-edge-tv (N_keepers (var E1)) (N_keepers_p1 (var E1)) (STV 1.0 0.9))))
