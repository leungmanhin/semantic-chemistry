; Experiment 2 — RULES: every world-rules law (context aelmere), every lore law (aelmere-lore) and every generic stated
; inside an episode (aelmere-events) as canonical
; per-match rule-lhs / rule-rhs IR with (var Name) markers, landed by exp2_adapter.py. A product's edge id names the
; rule and the premise edges it fired on; a consequent's Skolem term is kept as a witness constructor over the premise
; variables; the authored truth value rides on rule-tv's `authored` axis and on every product edge.

; --- R1.1: When a lantern burns mire-essence, the lantern produces mist-light.
(sem-rule R1_1)
(rule-context R1_1 aelmere)
(rule-priority R1_1 0)
(rule-tv R1_1 authored 1.0 0.9)
(rule-lhs R1_1 ((sem-edge (var g) (var e1) Member (var e) burn) (sem-edge (var g) (var e2) Agent (var e) (var y)) (sem-edge (var g) (var e3) Member (var y) lantern) (sem-edge (var g) (var e4) Object (var e) (var t1)) (sem-edge (var g) (var e5) Member (var t1) mire_essence)))
(rule-rhs R1_1 ((sem-edge (var g) (R1_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R1_1_sk_produce (var e)) produce) (sem-edge-tv (var g) (R1_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R1_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Agent (R1_1_sk_produce (var e)) (var y)) (sem-edge-tv (var g) (R1_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R1_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Object (R1_1_sk_produce (var e)) mist_light) (sem-edge-tv (var g) (R1_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R1_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) During (R1_1_sk_produce (var e)) (var e)) (sem-edge-tv (var g) (R1_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- R1.2: Whenever a lantern burns mire-essence, the lantern gives mist-light.
(sem-rule R1_2)
(rule-context R1_2 aelmere)
(rule-priority R1_2 1)
(rule-tv R1_2 authored 1.0 0.9)
(rule-lhs R1_2 ((sem-edge (var g) (var e1) Member (var x) burn) (sem-edge (var g) (var e2) Agent (var x) (var lantern)) (sem-edge (var g) (var e3) Member (var lantern) lantern) (sem-edge (var g) (var e4) Object (var x) (var t1)) (sem-edge (var g) (var e5) Member (var t1) mire_essence)))
(rule-rhs R1_2 ((sem-edge (var g) (R1_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R1_2_sk_give (var x)) give) (sem-edge-tv (var g) (R1_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R1_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Agent (R1_2_sk_give (var x)) (var lantern)) (sem-edge-tv (var g) (R1_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R1_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Object (R1_2_sk_give (var x)) mist_light) (sem-edge-tv (var g) (R1_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R1_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) During (R1_2_sk_give (var x)) (var x)) (sem-edge-tv (var g) (R1_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- R1.4: Ordinary oil does not produce mist-light.
(sem-rule R1_4)
(rule-context R1_4 aelmere)
(rule-priority R1_4 2)
(rule-tv R1_4 authored 0.0 0.9)
(rule-lhs R1_4 ((sem-edge (var g) (var e1) Member (var x) oil) (sem-edge (var g) (var e2) Member (var x) ordinary)))
(rule-rhs R1_4 ((sem-edge (var g) (R1_4_p1 (var e1) (var e2)) And (Member (R1_4_sk_produce (var x)) produce) (Agent (R1_4_sk_produce (var x)) (var x)) (Object (R1_4_sk_produce (var x)) mist_light)) (sem-edge-tv (var g) (R1_4_p1 (var e1) (var e2)) (STV 0.0 0.9))))

; --- R2.1: When a lantern shows mist-light at night, the mist-light attracts nightmoths.
(sem-rule R2_1)
(rule-context R2_1 aelmere)
(rule-priority R2_1 3)
(rule-tv R2_1 authored 1.0 0.9)
(rule-lhs R2_1 ((sem-edge (var g) (var e1) Member (var l) lantern) (sem-edge (var g) (var e2) Member (var s) show) (sem-edge (var g) (var e3) Agent (var s) (var l)) (sem-edge (var g) (var e4) Object (var s) (var m)) (sem-edge (var g) (var e5) Member (var m) mist_light) (sem-edge (var g) (var e6) Time (var s) night)))
(rule-rhs R2_1 ((sem-edge (var g) (R2_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (R2_1_sk_attract (var s)) attract) (sem-edge-tv (var g) (R2_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R2_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Agent (R2_1_sk_attract (var s)) (var m)) (sem-edge-tv (var g) (R2_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R2_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Object (R2_1_sk_attract (var s)) nightmoth) (sem-edge-tv (var g) (R2_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R2_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) During (R2_1_sk_attract (var s)) (var s)) (sem-edge-tv (var g) (R2_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9))))

; --- R2.2: Whenever a lantern shows mist-light at night, the mist-light draws nightmoths.
(sem-rule R2_2)
(rule-context R2_2 aelmere)
(rule-priority R2_2 4)
(rule-tv R2_2 authored 1.0 0.9)
(rule-lhs R2_2 ((sem-edge (var g) (var e1) Member (var e) show) (sem-edge (var g) (var e2) Member (var x) lantern) (sem-edge (var g) (var e3) Agent (var e) (var x)) (sem-edge (var g) (var e4) Object (var e) (var t1)) (sem-edge (var g) (var e5) Member (var t1) mist_light) (sem-edge (var g) (var e6) Time (var e) night)))
(rule-rhs R2_2 ((sem-edge (var g) (R2_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (R2_2_sk_draw (var e)) draw) (sem-edge-tv (var g) (R2_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R2_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Agent (R2_2_sk_draw (var e)) mist_light) (sem-edge-tv (var g) (R2_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R2_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Object (R2_2_sk_draw (var e)) nightmoth) (sem-edge-tv (var g) (R2_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R2_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) During (R2_2_sk_draw (var e)) (var e)) (sem-edge-tv (var g) (R2_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9))))

; --- R2.3: Nightmoths do not see ordinary firelight.
(sem-rule R2_3)
(rule-context R2_3 aelmere)
(rule-priority R2_3 5)
(rule-tv R2_3 authored 0.0 0.9)
(rule-lhs R2_3 ((sem-edge (var g) (var e1) Member (var x) nightmoth)))
(rule-rhs R2_3 ((sem-edge (var g) (R2_3_p1 (var e1)) And (Member (R2_3_sk_see (var x)) see) (Experiencer (R2_3_sk_see (var x)) (var x)) (Stimulus (R2_3_sk_see (var x)) ordinary_firelight)) (sem-edge-tv (var g) (R2_3_p1 (var e1)) (STV 0.0 0.9))))

; --- R2.4: Nightmoths rarely fly on a cold night.
(sem-rule R2_4)
(rule-context R2_4 aelmere)
(rule-priority R2_4 6)
(rule-tv R2_4 authored 0.1 0.9)
(rule-lhs R2_4 ((sem-edge (var g) (var e1) Member (var x) nightmoth)))
(rule-rhs R2_4 ((sem-edge (var g) (R2_4_p1 (var e1)) And (Member (R2_4_sk_fly (var x)) fly) (Agent (R2_4_sk_fly (var x)) (var x)) (Time (R2_4_sk_fly (var x)) (R2_4_sk_night (var x))) (Member (R2_4_sk_night (var x)) night) (Member (R2_4_sk_night (var x)) cold)) (sem-edge-tv (var g) (R2_4_p1 (var e1)) (STV 0.1 0.9))))

; --- R3.1: When a nightmoth lands on a lantern, the nightmoth leaves silken threads on the lantern.
(sem-rule R3_1)
(rule-context R3_1 aelmere)
(rule-priority R3_1 7)
(rule-tv R3_1 authored 1.0 0.9)
(rule-lhs R3_1 ((sem-edge (var g) (var e1) Member (var e) land) (sem-edge (var g) (var e2) Agent (var e) (var x)) (sem-edge (var g) (var e3) Member (var x) nightmoth) (sem-edge (var g) (var e4) Location (var e) (var y)) (sem-edge (var g) (var e5) Member (var y) lantern)))
(rule-rhs R3_1 ((sem-edge (var g) (R3_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R3_1_sk_leave (var e)) leave) (sem-edge-tv (var g) (R3_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R3_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Agent (R3_1_sk_leave (var e)) (var x)) (sem-edge-tv (var g) (R3_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R3_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Object (R3_1_sk_leave (var e)) (R3_1_sk_threads (var e))) (sem-edge-tv (var g) (R3_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R3_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) GroupOf (R3_1_sk_threads (var e)) silken_thread) (sem-edge-tv (var g) (R3_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R3_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) Location (R3_1_sk_leave (var e)) (var y)) (sem-edge-tv (var g) (R3_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R3_1_p6 (var e1) (var e2) (var e3) (var e4) (var e5)) During (R3_1_sk_leave (var e)) (var e)) (sem-edge-tv (var g) (R3_1_p6 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- R3.2: Whenever a nightmoth is resting on a lantern, the nightmoth sheds silken threads onto the lantern.
(sem-rule R3_2)
(rule-context R3_2 aelmere)
(rule-priority R3_2 8)
(rule-tv R3_2 authored 1.0 0.9)
(rule-lhs R3_2 ((sem-edge (var g) (var e1) Member (var x) nightmoth) (sem-edge (var g) (var e2) Member (var y) lantern) (sem-edge (var g) (var e3) Member (var e) rest) (sem-edge (var g) (var e4) Experiencer (var e) (var x)) (sem-edge (var g) (var e5) Location (var e) (var y)) (sem-edge (var g) (var e6) Ongoing (var e))))
(rule-rhs R3_2 ((sem-edge (var g) (R3_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (R3_2_sk_shed (var x) (var y)) shed) (sem-edge-tv (var g) (R3_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R3_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Agent (R3_2_sk_shed (var x) (var y)) (var x)) (sem-edge-tv (var g) (R3_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R3_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Object (R3_2_sk_shed (var x) (var y)) silken_thread) (sem-edge-tv (var g) (R3_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R3_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Goal (R3_2_sk_shed (var x) (var y)) (var y)) (sem-edge-tv (var g) (R3_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R3_2_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) During (R3_2_sk_shed (var x) (var y)) (var e)) (sem-edge-tv (var g) (R3_2_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9))))

; --- R3.3: Every silken thread comes from the underside of a nightmoth.
(sem-rule R3_3)
(rule-context R3_3 aelmere)
(rule-priority R3_3 9)
(rule-tv R3_3 authored 1.0 0.9)
(rule-lhs R3_3 ((sem-edge (var g) (var e1) Member (var x) silken_thread)))
(rule-rhs R3_3 ((sem-edge (var g) (R3_3_p1 (var e1)) Member (R3_3_sk_come (var x)) come) (sem-edge-tv (var g) (R3_3_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R3_3_p2 (var e1)) Object (R3_3_sk_come (var x)) (var x)) (sem-edge-tv (var g) (R3_3_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R3_3_p3 (var e1)) Source (R3_3_sk_come (var x)) (R3_3_sk_underside (var x))) (sem-edge-tv (var g) (R3_3_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R3_3_p4 (var e1)) Member (R3_3_sk_underside (var x)) underside) (sem-edge-tv (var g) (R3_3_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R3_3_p5 (var e1)) Member (R3_3_sk_nightmoth (var x)) nightmoth) (sem-edge-tv (var g) (R3_3_p5 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R3_3_p6 (var e1)) PartOf (R3_3_sk_underside (var x)) (R3_3_sk_nightmoth (var x))) (sem-edge-tv (var g) (R3_3_p6 (var e1)) (STV 1.0 0.9))))

; --- R4.1: When a Keeper boils silken threads in sea-water, mire-essence forms in the cauldron.
(sem-rule R4_1)
(rule-context R4_1 aelmere)
(rule-priority R4_1 10)
(rule-tv R4_1 authored 1.0 0.9)
(rule-lhs R4_1 ((sem-edge (var g) (var e1) Member (var e) boil) (sem-edge (var g) (var e2) Member (var x) keeper) (sem-edge (var g) (var e3) Agent (var e) (var x)) (sem-edge (var g) (var e4) Object (var e) (var t1)) (sem-edge (var g) (var e5) Member (var t1) silken_thread) (sem-edge (var g) (var e6) Location (var e) (var t2)) (sem-edge (var g) (var e7) Member (var t2) sea_water)))
(rule-rhs R4_1 ((sem-edge (var g) (R4_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Member (R4_1_sk_form (var e)) form) (sem-edge-tv (var g) (R4_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R4_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Object (R4_1_sk_form (var e)) mire_essence) (sem-edge-tv (var g) (R4_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R4_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Member (R4_1_sk_cauldron (var e)) cauldron) (sem-edge-tv (var g) (R4_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R4_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Location (R4_1_sk_form (var e)) (R4_1_sk_cauldron (var e))) (sem-edge-tv (var g) (R4_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R4_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) During (R4_1_sk_form (var e)) (var e)) (sem-edge-tv (var g) (R4_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9))))

; --- R4.2: Whenever a Keeper boils silken threads in sea-water, the cauldron yields mire-essence.
(sem-rule R4_2)
(rule-context R4_2 aelmere)
(rule-priority R4_2 11)
(rule-tv R4_2 authored 1.0 0.9)
(rule-lhs R4_2 ((sem-edge (var g) (var e1) Member (var b) boil) (sem-edge (var g) (var e2) Agent (var b) (var k)) (sem-edge (var g) (var e3) Member (var k) keeper) (sem-edge (var g) (var e4) Object (var b) (var t1)) (sem-edge (var g) (var e5) Member (var t1) silken_thread) (sem-edge (var g) (var e6) Location (var b) (var t2)) (sem-edge (var g) (var e7) Member (var t2) sea_water)))
(rule-rhs R4_2 ((sem-edge (var g) (R4_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Member (R4_2_sk_yield (var b)) yield) (sem-edge-tv (var g) (R4_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R4_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Agent (R4_2_sk_yield (var b)) the_cauldron) (sem-edge-tv (var g) (R4_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R4_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Object (R4_2_sk_yield (var b)) mire_essence) (sem-edge-tv (var g) (R4_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R4_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) During (R4_2_sk_yield (var b)) (var b)) (sem-edge-tv (var g) (R4_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9))))

; --- R4.3: Each Keeper takes the sea-water from the Salt-bloom Tide-pools.
(sem-rule R4_3)
(rule-context R4_3 aelmere)
(rule-priority R4_3 12)
(rule-tv R4_3 authored 1.0 0.9)
(rule-lhs R4_3 ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs R4_3 ((sem-edge (var g) (R4_3_p1 (var e1)) Member (R4_3_sk_take (var x)) take) (sem-edge-tv (var g) (R4_3_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R4_3_p2 (var e1)) Agent (R4_3_sk_take (var x)) (var x)) (sem-edge-tv (var g) (R4_3_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R4_3_p3 (var e1)) Object (R4_3_sk_take (var x)) R4_3_sk_sea_water_1) (sem-edge-tv (var g) (R4_3_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R4_3_p4 (var e1)) Source (R4_3_sk_take (var x)) salt_bloom_tide_pools) (sem-edge-tv (var g) (R4_3_p4 (var e1)) (STV 1.0 0.9))))

; --- R5.1: When mire-essence forms in the cauldron, a Keeper stores the mire-essence in clay vessels.
(sem-rule R5_1)
(rule-context R5_1 aelmere)
(rule-priority R5_1 13)
(rule-tv R5_1 authored 1.0 0.9)
(rule-lhs R5_1 ((sem-edge (var g) (var e1) Member (var x) form) (sem-edge (var g) (var e2) Object (var x) (var t1)) (sem-edge (var g) (var e3) Member (var t1) mire_essence) (sem-edge (var g) (var e4) Location (var x) the_cauldron)))
(rule-rhs R5_1 ((sem-edge (var g) (R5_1_p1 (var e1) (var e2) (var e3) (var e4)) Member (R5_1_sk_store (var x)) store) (sem-edge-tv (var g) (R5_1_p1 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R5_1_p2 (var e1) (var e2) (var e3) (var e4)) Agent (R5_1_sk_store (var x)) (R5_1_sk_keeper (var x))) (sem-edge-tv (var g) (R5_1_p2 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R5_1_p3 (var e1) (var e2) (var e3) (var e4)) Member (R5_1_sk_keeper (var x)) keeper) (sem-edge-tv (var g) (R5_1_p3 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R5_1_p4 (var e1) (var e2) (var e3) (var e4)) Object (R5_1_sk_store (var x)) mire_essence) (sem-edge-tv (var g) (R5_1_p4 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R5_1_p5 (var e1) (var e2) (var e3) (var e4)) Location (R5_1_sk_store (var x)) clay_vessel) (sem-edge-tv (var g) (R5_1_p5 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R5_1_p6 (var e1) (var e2) (var e3) (var e4)) During (R5_1_sk_store (var x)) (var x)) (sem-edge-tv (var g) (R5_1_p6 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9))))

; --- R5.2: Whenever mire-essence forms in the cauldron, a Keeper keeps the mire-essence in clay vessels.
(sem-rule R5_2)
(rule-context R5_2 aelmere)
(rule-priority R5_2 14)
(rule-tv R5_2 authored 1.0 0.9)
(rule-lhs R5_2 ((sem-edge (var g) (var e1) Member (var x) form) (sem-edge (var g) (var e2) Object (var x) (var m)) (sem-edge (var g) (var e3) Member (var m) mire_essence) (sem-edge (var g) (var e4) Location (var x) the_cauldron)))
(rule-rhs R5_2 ((sem-edge (var g) (R5_2_p1 (var e1) (var e2) (var e3) (var e4)) Member (R5_2_sk_keep (var x)) keep) (sem-edge-tv (var g) (R5_2_p1 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R5_2_p2 (var e1) (var e2) (var e3) (var e4)) Agent (R5_2_sk_keep (var x)) (R5_2_sk_keeper (var x))) (sem-edge-tv (var g) (R5_2_p2 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R5_2_p3 (var e1) (var e2) (var e3) (var e4)) Member (R5_2_sk_keeper (var x)) keeper) (sem-edge-tv (var g) (R5_2_p3 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R5_2_p4 (var e1) (var e2) (var e3) (var e4)) Object (R5_2_sk_keep (var x)) (var m)) (sem-edge-tv (var g) (R5_2_p4 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R5_2_p5 (var e1) (var e2) (var e3) (var e4)) Location (R5_2_sk_keep (var x)) clay_vessel) (sem-edge-tv (var g) (R5_2_p5 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R5_2_p6 (var e1) (var e2) (var e3) (var e4)) During (R5_2_sk_keep (var x)) (var x)) (sem-edge-tv (var g) (R5_2_p6 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9))))

; --- R5.3: Whenever a Keeper tends a lantern, that Keeper draws the stored mire-essence.
(sem-rule R5_3)
(rule-context R5_3 aelmere)
(rule-priority R5_3 15)
(rule-tv R5_3 authored 1.0 0.9)
(rule-lhs R5_3 ((sem-edge (var g) (var e1) Member (var x) tend) (sem-edge (var g) (var e2) Agent (var x) (var k)) (sem-edge (var g) (var e3) Member (var k) keeper) (sem-edge (var g) (var e4) Object (var x) (var l)) (sem-edge (var g) (var e5) Member (var l) lantern)))
(rule-rhs R5_3 ((sem-edge (var g) (R5_3_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R5_3_sk_draw (var x)) draw) (sem-edge-tv (var g) (R5_3_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R5_3_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Agent (R5_3_sk_draw (var x)) (var k)) (sem-edge-tv (var g) (R5_3_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R5_3_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Object (R5_3_sk_draw (var x)) (R5_3_sk_essence (var x))) (sem-edge-tv (var g) (R5_3_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R5_3_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R5_3_sk_essence (var x)) mire_essence) (sem-edge-tv (var g) (R5_3_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R5_3_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R5_3_sk_essence (var x)) stored) (sem-edge-tv (var g) (R5_3_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R5_3_p6 (var e1) (var e2) (var e3) (var e4) (var e5)) During (R5_3_sk_draw (var x)) (var x)) (sem-edge-tv (var g) (R5_3_p6 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- R5.4: Stored mire-essence feeds lantern lighting.
(sem-rule R5_4)
(rule-context R5_4 aelmere)
(rule-priority R5_4 16)
(rule-tv R5_4 authored 0.9 0.9)
(rule-lhs R5_4 ((sem-edge (var g) (var e1) Member (var x) mire_essence) (sem-edge (var g) (var e2) Member (var x) stored)))
(rule-rhs R5_4 ((sem-edge (var g) (R5_4_p1 (var e1) (var e2)) Member (R5_4_sk_feed (var x)) feed) (sem-edge-tv (var g) (R5_4_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (R5_4_p2 (var e1) (var e2)) Agent (R5_4_sk_feed (var x)) (var x)) (sem-edge-tv (var g) (R5_4_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (R5_4_p3 (var e1) (var e2)) Object (R5_4_sk_feed (var x)) lantern_lighting) (sem-edge-tv (var g) (R5_4_p3 (var e1) (var e2)) (STV 0.9 0.9))))

; --- R6.1: When a crowd of nightmoths gathers at a lantern-row, sky-cats descend from the cliff-spires.
(sem-rule R6_1)
(rule-context R6_1 aelmere)
(rule-priority R6_1 17)
(rule-tv R6_1 authored 1.0 0.9)
(rule-lhs R6_1 ((sem-edge (var g) (var e1) Member (var c) crowd) (sem-edge (var g) (var e2) GroupOf (var c) nightmoth) (sem-edge (var g) (var e3) Member (var g) gather) (sem-edge (var g) (var e4) Agent (var g) (var c)) (sem-edge (var g) (var e5) Location (var g) (var lr)) (sem-edge (var g) (var e6) Member (var lr) lantern_row)))
(rule-rhs R6_1 ((sem-edge (var g) (R6_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) GroupOf (R6_1_sk_skycats (var g)) sky_cat) (sem-edge-tv (var g) (R6_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R6_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (R6_1_sk_descend (var g)) descend) (sem-edge-tv (var g) (R6_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R6_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Agent (R6_1_sk_descend (var g)) (R6_1_sk_skycats (var g))) (sem-edge-tv (var g) (R6_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R6_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Source (R6_1_sk_descend (var g)) R6_1_sk_cliffspires_1) (sem-edge-tv (var g) (R6_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R6_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) During (R6_1_sk_descend (var g)) (var g)) (sem-edge-tv (var g) (R6_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9))))

; --- R6.2: Whenever a crowd of nightmoths settles on a lantern-row, sky-cats descend from the cliff-spires.
(sem-rule R6_2)
(rule-context R6_2 aelmere)
(rule-priority R6_2 18)
(rule-tv R6_2 authored 1.0 0.9)
(rule-lhs R6_2 ((sem-edge (var g) (var e1) Member (var x) settle) (sem-edge (var g) (var e2) Agent (var x) (var c)) (sem-edge (var g) (var e3) Member (var c) crowd) (sem-edge (var g) (var e4) GroupOf (var c) nightmoth) (sem-edge (var g) (var e5) Location (var x) (var l)) (sem-edge (var g) (var e6) Member (var l) lantern_row)))
(rule-rhs R6_2 ((sem-edge (var g) (R6_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (R6_2_sk_descend (var x)) descend) (sem-edge-tv (var g) (R6_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R6_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Agent (R6_2_sk_descend (var x)) (R6_2_sk_skycats (var x))) (sem-edge-tv (var g) (R6_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R6_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) GroupOf (R6_2_sk_skycats (var x)) sky_cat) (sem-edge-tv (var g) (R6_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R6_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Source (R6_2_sk_descend (var x)) R6_2_sk_cliff_spires_1) (sem-edge-tv (var g) (R6_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R6_2_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) During (R6_2_sk_descend (var x)) (var x)) (sem-edge-tv (var g) (R6_2_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9))))

; --- R6.3: When a handful of nightmoths gathers at a lantern-row, sky-cats stay on the cliff-spires.
(sem-rule R6_3)
(rule-context R6_3 aelmere)
(rule-priority R6_3 19)
(rule-tv R6_3 authored 1.0 0.9)
(rule-lhs R6_3 ((sem-edge (var g) (var e1) Member (var x) gather) (sem-edge (var g) (var e2) Agent (var x) (var g)) (sem-edge (var g) (var e3) GroupOf (var g) nightmoth) (sem-edge (var g) (var e4) CardinalityPhrase (var g) "handful") (sem-edge (var g) (var e5) Location (var x) (var lr)) (sem-edge (var g) (var e6) Member (var lr) lantern_row) (sem-edge (var g) (var e7) Member (var y) sky_cat)))
(rule-rhs R6_3 ((sem-edge (var g) (R6_3_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Member (R6_3_sk_stay (var x) (var y)) stay) (sem-edge-tv (var g) (R6_3_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R6_3_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Experiencer (R6_3_sk_stay (var x) (var y)) (var y)) (sem-edge-tv (var g) (R6_3_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R6_3_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) On (R6_3_sk_stay (var x) (var y)) R6_3_sk_cliff_spires_1) (sem-edge-tv (var g) (R6_3_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R6_3_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) During (R6_3_sk_stay (var x) (var y)) (var x)) (sem-edge-tv (var g) (R6_3_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9))))

; --- R7.1: When a sky-cat descends, the sky-cat hunts nightmoths.
(sem-rule R7_1)
(rule-context R7_1 aelmere)
(rule-priority R7_1 20)
(rule-tv R7_1 authored 1.0 0.9)
(rule-lhs R7_1 ((sem-edge (var g) (var e1) Member (var x) sky_cat) (sem-edge (var g) (var e2) Member (var d) descend) (sem-edge (var g) (var e3) Agent (var d) (var x))))
(rule-rhs R7_1 ((sem-edge (var g) (R7_1_p1 (var e1) (var e2) (var e3)) Member (R7_1_sk_hunt (var d)) hunt) (sem-edge-tv (var g) (R7_1_p1 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R7_1_p2 (var e1) (var e2) (var e3)) Agent (R7_1_sk_hunt (var d)) (var x)) (sem-edge-tv (var g) (R7_1_p2 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R7_1_p3 (var e1) (var e2) (var e3)) Object (R7_1_sk_hunt (var d)) nightmoth) (sem-edge-tv (var g) (R7_1_p3 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R7_1_p4 (var e1) (var e2) (var e3)) During (R7_1_sk_hunt (var d)) (var d)) (sem-edge-tv (var g) (R7_1_p4 (var e1) (var e2) (var e3)) (STV 1.0 0.9))))

; --- R7.2: When a sky-cat hunts nightmoths at a lantern-row, the nightmoth crowd at that lantern-row shrinks.
(sem-rule R7_2)
(rule-context R7_2 aelmere)
(rule-priority R7_2 21)
(rule-tv R7_2 authored 1.0 0.9)
(rule-lhs R7_2 ((sem-edge (var g) (var e1) Member (var e) hunt) (sem-edge (var g) (var e2) Agent (var e) (var s)) (sem-edge (var g) (var e3) Member (var s) sky_cat) (sem-edge (var g) (var e4) Object (var e) (var t1)) (sem-edge (var g) (var e5) Member (var t1) nightmoth) (sem-edge (var g) (var e6) Location (var e) (var y)) (sem-edge (var g) (var e7) Member (var y) lantern_row)))
(rule-rhs R7_2 ((sem-edge (var g) (R7_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Member (R7_2_sk_shrink (var e)) shrink) (sem-edge-tv (var g) (R7_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R7_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Object (R7_2_sk_shrink (var e)) (R7_2_sk_crowd (var e))) (sem-edge-tv (var g) (R7_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R7_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Member (R7_2_sk_crowd (var e)) crowd) (sem-edge-tv (var g) (R7_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R7_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) GroupOf (R7_2_sk_crowd (var e)) nightmoth) (sem-edge-tv (var g) (R7_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R7_2_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) LocatedIn (R7_2_sk_crowd (var e)) (var y)) (sem-edge-tv (var g) (R7_2_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R7_2_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) During (R7_2_sk_shrink (var e)) (var e)) (sem-edge-tv (var g) (R7_2_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9))))

; --- R7.3: Whenever a sky-cat hunts nightmoths at a lantern-row, the nightmoth crowd at that lantern-row thins.
(sem-rule R7_3)
(rule-context R7_3 aelmere)
(rule-priority R7_3 22)
(rule-tv R7_3 authored 1.0 0.9)
(rule-lhs R7_3 ((sem-edge (var g) (var e1) Member (var c) sky_cat) (sem-edge (var g) (var e2) Member (var h) hunt) (sem-edge (var g) (var e3) Agent (var h) (var c)) (sem-edge (var g) (var e4) Object (var h) (var t1)) (sem-edge (var g) (var e5) Member (var t1) nightmoth) (sem-edge (var g) (var e6) Member (var r) lantern_row) (sem-edge (var g) (var e7) Location (var h) (var r))))
(rule-rhs R7_3 ((sem-edge (var g) (R7_3_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Member (R7_3_sk_thin (var h)) thin) (sem-edge-tv (var g) (R7_3_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R7_3_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Object (R7_3_sk_thin (var h)) (R7_3_sk_crowd (var r))) (sem-edge-tv (var g) (R7_3_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R7_3_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Member (R7_3_sk_crowd (var r)) crowd) (sem-edge-tv (var g) (R7_3_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R7_3_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) GroupOf (R7_3_sk_crowd (var r)) nightmoth) (sem-edge-tv (var g) (R7_3_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R7_3_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) LocatedIn (R7_3_sk_crowd (var r)) (var r)) (sem-edge-tv (var g) (R7_3_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R7_3_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) During (R7_3_sk_thin (var h)) (var h)) (sem-edge-tv (var g) (R7_3_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9))))

; --- R7.4: After a sky-cat hunts at a lantern-row, the thread harvest at that lantern-row falls.
(sem-rule R7_4)
(rule-context R7_4 aelmere)
(rule-priority R7_4 23)
(rule-tv R7_4 authored 1.0 0.9)
(rule-lhs R7_4 ((sem-edge (var g) (var e1) Member (var x) hunt) (sem-edge (var g) (var e2) Agent (var x) (var c)) (sem-edge (var g) (var e3) Member (var c) sky_cat) (sem-edge (var g) (var e4) Location (var x) (var r)) (sem-edge (var g) (var e5) Member (var r) lantern_row)))
(rule-rhs R7_4 ((sem-edge (var g) (R7_4_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R7_4_sk_fall (var x)) fall) (sem-edge-tv (var g) (R7_4_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R7_4_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Object (R7_4_sk_fall (var x)) (R7_4_sk_harvest (var r))) (sem-edge-tv (var g) (R7_4_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R7_4_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R7_4_sk_harvest (var r)) thread_harvest) (sem-edge-tv (var g) (R7_4_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R7_4_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) LocatedIn (R7_4_sk_harvest (var r)) (var r)) (sem-edge-tv (var g) (R7_4_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R7_4_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) Before (var x) (R7_4_sk_fall (var x))) (sem-edge-tv (var g) (R7_4_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- R8.1: When a sky-cat hunts at a lantern-row, each nightmoth that survives the hunt flees to a dim lantern.
(sem-rule R8_1)
(rule-context R8_1 aelmere)
(rule-priority R8_1 24)
(rule-tv R8_1 authored 1.0 0.9)
(rule-lhs R8_1 ((sem-edge (var g) (var e1) Member (var c) sky_cat) (sem-edge (var g) (var e2) Member (var h) hunt) (sem-edge (var g) (var e3) Agent (var h) (var c)) (sem-edge (var g) (var e4) Location (var h) (var lr)) (sem-edge (var g) (var e5) Member (var lr) lantern_row) (sem-edge (var g) (var e6) Member (var n) nightmoth) (sem-edge (var g) (var e7) Member (var sv) survive) (sem-edge (var g) (var e8) Agent (var sv) (var n)) (sem-edge (var g) (var e9) Object (var sv) (var h))))
(rule-rhs R8_1 ((sem-edge (var g) (R8_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) Member (R8_1_sk_flee (var n) (var h)) flee) (sem-edge-tv (var g) (R8_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) (STV 1.0 0.9)) (sem-edge (var g) (R8_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) Agent (R8_1_sk_flee (var n) (var h)) (var n)) (sem-edge-tv (var g) (R8_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) (STV 1.0 0.9)) (sem-edge (var g) (R8_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) Goal (R8_1_sk_flee (var n) (var h)) (R8_1_sk_lantern (var n) (var h))) (sem-edge-tv (var g) (R8_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) (STV 1.0 0.9)) (sem-edge (var g) (R8_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) Member (R8_1_sk_lantern (var n) (var h)) lantern) (sem-edge-tv (var g) (R8_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) (STV 1.0 0.9)) (sem-edge (var g) (R8_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) Member (R8_1_sk_lantern (var n) (var h)) dim) (sem-edge-tv (var g) (R8_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) (STV 1.0 0.9)) (sem-edge (var g) (R8_1_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) During (R8_1_sk_flee (var n) (var h)) (var h)) (sem-edge-tv (var g) (R8_1_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) (STV 1.0 0.9))))

; --- R8.2: Whenever a sky-cat hunts at a lantern-row, each nightmoth that survives the hunt moves to the Hollows.
(sem-rule R8_2)
(rule-context R8_2 aelmere)
(rule-priority R8_2 25)
(rule-tv R8_2 authored 1.0 0.9)
(rule-lhs R8_2 ((sem-edge (var g) (var e1) Member (var x) sky_cat) (sem-edge (var g) (var e2) Member (var h) hunt) (sem-edge (var g) (var e3) Agent (var h) (var x)) (sem-edge (var g) (var e4) Member (var y) lantern_row) (sem-edge (var g) (var e5) Location (var h) (var y)) (sem-edge (var g) (var e6) Member (var m) nightmoth) (sem-edge (var g) (var e7) Member (var s) survive) (sem-edge (var g) (var e8) Agent (var s) (var m)) (sem-edge (var g) (var e9) Object (var s) (var h))))
(rule-rhs R8_2 ((sem-edge (var g) (R8_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) Member (R8_2_sk_move (var h) (var m)) move) (sem-edge-tv (var g) (R8_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) (STV 1.0 0.9)) (sem-edge (var g) (R8_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) Agent (R8_2_sk_move (var h) (var m)) (var m)) (sem-edge-tv (var g) (R8_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) (STV 1.0 0.9)) (sem-edge (var g) (R8_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) Goal (R8_2_sk_move (var h) (var m)) hollows) (sem-edge-tv (var g) (R8_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) (STV 1.0 0.9)) (sem-edge (var g) (R8_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) During (R8_2_sk_move (var h) (var m)) (var h)) (sem-edge-tv (var g) (R8_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) (STV 1.0 0.9))))

; --- R8.3: Whenever a nightmoth reaches the Hollows, the lanterns at the Hollows gain silken threads.
(sem-rule R8_3)
(rule-context R8_3 aelmere)
(rule-priority R8_3 26)
(rule-tv R8_3 authored 1.0 0.9)
(rule-lhs R8_3 ((sem-edge (var g) (var e1) Member (var x) reach) (sem-edge (var g) (var e2) Agent (var x) (var m)) (sem-edge (var g) (var e3) Member (var m) nightmoth) (sem-edge (var g) (var e4) Object (var x) hollows)))
(rule-rhs R8_3 ((sem-edge (var g) (R8_3_p1 (var e1) (var e2) (var e3) (var e4)) Member (R8_3_sk_gain (var x)) gain) (sem-edge-tv (var g) (R8_3_p1 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R8_3_p2 (var e1) (var e2) (var e3) (var e4)) Agent (R8_3_sk_gain (var x)) R8_3_sk_lanterns_1) (sem-edge-tv (var g) (R8_3_p2 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R8_3_p3 (var e1) (var e2) (var e3) (var e4)) Object (R8_3_sk_gain (var x)) (R8_3_sk_threads (var x))) (sem-edge-tv (var g) (R8_3_p3 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R8_3_p4 (var e1) (var e2) (var e3) (var e4)) GroupOf (R8_3_sk_threads (var x)) silken_thread) (sem-edge-tv (var g) (R8_3_p4 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R8_3_p5 (var e1) (var e2) (var e3) (var e4)) During (R8_3_sk_gain (var x)) (var x)) (sem-edge-tv (var g) (R8_3_p5 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9))))

; --- R9.1: Sky-cats roost on the cliff-spires during the day.
(sem-rule R9_1)
(rule-context R9_1 aelmere)
(rule-priority R9_1 27)
(rule-tv R9_1 authored 0.9 0.9)
(rule-lhs R9_1 ((sem-edge (var g) (var e1) Member (var x) sky_cat)))
(rule-rhs R9_1 ((sem-edge (var g) (R9_1_p1 (var e1)) Member (R9_1_sk_roost (var x)) roost) (sem-edge-tv (var g) (R9_1_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (R9_1_p2 (var e1)) Agent (R9_1_sk_roost (var x)) (var x)) (sem-edge-tv (var g) (R9_1_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (R9_1_p3 (var e1)) Location (R9_1_sk_roost (var x)) R9_1_sk_group_1) (sem-edge-tv (var g) (R9_1_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (R9_1_p4 (var e1)) Time (R9_1_sk_roost (var x)) day) (sem-edge-tv (var g) (R9_1_p4 (var e1)) (STV 0.9 0.9))))

; --- R9.2: Sky-cats do not enter the village.
(sem-rule R9_2)
(rule-context R9_2 aelmere)
(rule-priority R9_2 28)
(rule-tv R9_2 authored 0.0 0.9)
(rule-lhs R9_2 ((sem-edge (var g) (var e1) Member (var x) sky_cat)))
(rule-rhs R9_2 ((sem-edge (var g) (R9_2_p1 (var e1)) And (Member (R9_2_sk_enter (var x)) enter) (Agent (R9_2_sk_enter (var x)) (var x)) (Object (R9_2_sk_enter (var x)) aelmere)) (sem-edge-tv (var g) (R9_2_p1 (var e1)) (STV 0.0 0.9))))

; --- R10.1: When a sky-cat molts, feathers fall to the base of the cliff.
(sem-rule R10_1)
(rule-context R10_1 aelmere)
(rule-priority R10_1 29)
(rule-tv R10_1 authored 1.0 0.9)
(rule-lhs R10_1 ((sem-edge (var g) (var e1) Member (var x) molt) (sem-edge (var g) (var e2) Object (var x) (var c)) (sem-edge (var g) (var e3) Member (var c) sky_cat)))
(rule-rhs R10_1 ((sem-edge (var g) (R10_1_p1 (var e1) (var e2) (var e3)) GroupOf (R10_1_sk_feathers (var x)) feather) (sem-edge-tv (var g) (R10_1_p1 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R10_1_p2 (var e1) (var e2) (var e3)) Member (R10_1_sk_fall (var x)) fall) (sem-edge-tv (var g) (R10_1_p2 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R10_1_p3 (var e1) (var e2) (var e3)) Object (R10_1_sk_fall (var x)) (R10_1_sk_feathers (var x))) (sem-edge-tv (var g) (R10_1_p3 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R10_1_p4 (var e1) (var e2) (var e3)) Goal (R10_1_sk_fall (var x)) R10_1_sk_base_1) (sem-edge-tv (var g) (R10_1_p4 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R10_1_p5 (var e1) (var e2) (var e3)) During (R10_1_sk_fall (var x)) (var x)) (sem-edge-tv (var g) (R10_1_p5 (var e1) (var e2) (var e3)) (STV 1.0 0.9))))

; --- R10.2: Whenever a sky-cat molts, the sky-cat sheds feathers onto the base of the cliff.
(sem-rule R10_2)
(rule-context R10_2 aelmere)
(rule-priority R10_2 30)
(rule-tv R10_2 authored 1.0 0.9)
(rule-lhs R10_2 ((sem-edge (var g) (var e1) Member (var x) molt) (sem-edge (var g) (var e2) Object (var x) (var y)) (sem-edge (var g) (var e3) Member (var y) sky_cat)))
(rule-rhs R10_2 ((sem-edge (var g) (R10_2_p1 (var e1) (var e2) (var e3)) Member (R10_2_sk_shed (var x)) shed) (sem-edge-tv (var g) (R10_2_p1 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R10_2_p2 (var e1) (var e2) (var e3)) Agent (R10_2_sk_shed (var x)) (var y)) (sem-edge-tv (var g) (R10_2_p2 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R10_2_p3 (var e1) (var e2) (var e3)) Object (R10_2_sk_shed (var x)) feather) (sem-edge-tv (var g) (R10_2_p3 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R10_2_p4 (var e1) (var e2) (var e3)) Goal (R10_2_sk_shed (var x)) R10_2_sk_base_1) (sem-edge-tv (var g) (R10_2_p4 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R10_2_p5 (var e1) (var e2) (var e3)) During (R10_2_sk_shed (var x)) (var x)) (sem-edge-tv (var g) (R10_2_p5 (var e1) (var e2) (var e3)) (STV 1.0 0.9))))

; --- R10.3: Apprentices collect the fallen feathers in the morning.
(sem-rule R10_3)
(rule-context R10_3 aelmere)
(rule-priority R10_3 31)
(rule-tv R10_3 authored 0.9 0.9)
(rule-lhs R10_3 ((sem-edge (var g) (var e1) Member (var x) apprentice)))
(rule-rhs R10_3 ((sem-edge (var g) (R10_3_p1 (var e1)) Member (R10_3_sk_collect (var x)) collect) (sem-edge-tv (var g) (R10_3_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (R10_3_p2 (var e1)) Agent (R10_3_sk_collect (var x)) (var x)) (sem-edge-tv (var g) (R10_3_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (R10_3_p3 (var e1)) Object (R10_3_sk_collect (var x)) R10_3_sk_feather_1) (sem-edge-tv (var g) (R10_3_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (R10_3_p4 (var e1)) Time (R10_3_sk_collect (var x)) morning) (sem-edge-tv (var g) (R10_3_p4 (var e1)) (STV 0.9 0.9))))

; --- R10.4: Each Keeper stores the collected feathers in a bin at the Watch.
(sem-rule R10_4)
(rule-context R10_4 aelmere)
(rule-priority R10_4 32)
(rule-tv R10_4 authored 1.0 0.9)
(rule-lhs R10_4 ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs R10_4 ((sem-edge (var g) (R10_4_p1 (var e1)) Member (R10_4_sk_store (var x)) store) (sem-edge-tv (var g) (R10_4_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R10_4_p2 (var e1)) Agent (R10_4_sk_store (var x)) (var x)) (sem-edge-tv (var g) (R10_4_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R10_4_p3 (var e1)) Object (R10_4_sk_store (var x)) R10_4_sk_feathers_1) (sem-edge-tv (var g) (R10_4_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R10_4_p4 (var e1)) Member (R10_4_sk_bin (var x)) bin) (sem-edge-tv (var g) (R10_4_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R10_4_p5 (var e1)) Location (R10_4_sk_store (var x)) (R10_4_sk_bin (var x))) (sem-edge-tv (var g) (R10_4_p5 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R10_4_p6 (var e1)) LocatedIn (R10_4_sk_bin (var x)) the_watch) (sem-edge-tv (var g) (R10_4_p6 (var e1)) (STV 1.0 0.9))))

; --- R11.1: When a Keeper leaves a lantern untended overnight, the lantern dies before dawn.
(sem-rule R11_1)
(rule-context R11_1 aelmere)
(rule-priority R11_1 33)
(rule-tv R11_1 authored 1.0 0.9)
(rule-lhs R11_1 ((sem-edge (var g) (var e1) Member (var k) keeper) (sem-edge (var g) (var e2) Member (var l) lantern) (sem-edge (var g) (var e3) Member (var e1) leave) (sem-edge (var g) (var e4) Agent (var e1) (var k)) (sem-edge (var g) (var e5) Object (var e1) (var l)) (sem-edge (var g) (var e6) Member (var u) untended) (sem-edge (var g) (var e7) Experiencer (var u) (var l)) (sem-edge (var g) (var e8) Still (var u)) (sem-edge (var g) (var e9) Result (var e1) (var u)) (sem-edge (var g) (var e10) Member (var l) untended) (sem-edge (var g) (var e11) Time (var e1) night)))
(rule-rhs R11_1 ((sem-edge (var g) (R11_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) Member (R11_1_sk_die (var e1)) die) (sem-edge-tv (var g) (R11_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) (STV 1.0 0.9)) (sem-edge (var g) (R11_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) Object (R11_1_sk_die (var e1)) (var l)) (sem-edge-tv (var g) (R11_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) (STV 1.0 0.9)) (sem-edge (var g) (R11_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) During (R11_1_sk_die (var e1)) (var e1)) (sem-edge-tv (var g) (R11_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) (STV 1.0 0.9)) (sem-edge (var g) (R11_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) TimeAtMost (R11_1_sk_die (var e1)) dawn) (sem-edge-tv (var g) (R11_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) (STV 1.0 0.9))))

; --- R11.2: When a lantern is untended through the night, the lantern goes out before dawn.
(sem-rule R11_2)
(rule-context R11_2 aelmere)
(rule-priority R11_2 34)
(rule-tv R11_2 authored 1.0 0.9)
(rule-lhs R11_2 ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) Member (var s) untended) (sem-edge (var g) (var e3) Experiencer (var s) (var x)) (sem-edge (var g) (var e4) Time (var s) night)))
(rule-rhs R11_2 ((sem-edge (var g) (R11_2_p1 (var e1) (var e2) (var e3) (var e4)) Member (R11_2_sk_go_out (var s)) go_out) (sem-edge-tv (var g) (R11_2_p1 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R11_2_p2 (var e1) (var e2) (var e3) (var e4)) Object (R11_2_sk_go_out (var s)) (var x)) (sem-edge-tv (var g) (R11_2_p2 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R11_2_p3 (var e1) (var e2) (var e3) (var e4)) During (R11_2_sk_go_out (var s)) (var s)) (sem-edge-tv (var g) (R11_2_p3 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R11_2_p4 (var e1) (var e2) (var e3) (var e4)) TimeAtMost (R11_2_sk_go_out (var s)) dawn) (sem-edge-tv (var g) (R11_2_p4 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9))))

; --- R11.3: Each Keeper refreshes the mire-essence and trims the wick during the night.
(sem-rule R11_3)
(rule-context R11_3 aelmere)
(rule-priority R11_3 35)
(rule-tv R11_3 authored 1.0 0.9)
(rule-lhs R11_3 ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs R11_3 ((sem-edge (var g) (R11_3_p1 (var e1)) Member (R11_3_sk_refresh (var x)) refresh) (sem-edge-tv (var g) (R11_3_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R11_3_p2 (var e1)) Agent (R11_3_sk_refresh (var x)) (var x)) (sem-edge-tv (var g) (R11_3_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R11_3_p3 (var e1)) Object (R11_3_sk_refresh (var x)) R11_3_sk_mire_essence_1) (sem-edge-tv (var g) (R11_3_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R11_3_p4 (var e1)) Time (R11_3_sk_refresh (var x)) night) (sem-edge-tv (var g) (R11_3_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R11_3_p5 (var e1)) Member (R11_3_sk_trim (var x)) trim) (sem-edge-tv (var g) (R11_3_p5 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R11_3_p6 (var e1)) Agent (R11_3_sk_trim (var x)) (var x)) (sem-edge-tv (var g) (R11_3_p6 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R11_3_p7 (var e1)) Object (R11_3_sk_trim (var x)) R11_3_sk_wick_1) (sem-edge-tv (var g) (R11_3_p7 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R11_3_p8 (var e1)) Time (R11_3_sk_trim (var x)) night) (sem-edge-tv (var g) (R11_3_p8 (var e1)) (STV 1.0 0.9))))

; --- R12.1: Whenever a lantern at the Sunken Cove dies before dawn, a wraith emerges from the cove's water.
(sem-rule R12_1)
(rule-context R12_1 aelmere)
(rule-priority R12_1 36)
(rule-tv R12_1 authored 1.0 0.9)
(rule-lhs R12_1 ((sem-edge (var g) (var e1) Member (var e) die) (sem-edge (var g) (var e2) Object (var e) (var l)) (sem-edge (var g) (var e3) Member (var l) lantern) (sem-edge (var g) (var e4) AttachedTo (var l) sunken_cove) (sem-edge (var g) (var e5) TimeAtMost (var e) dawn)))
(rule-rhs R12_1 ((sem-edge (var g) (R12_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R12_1_sk_emerge (var e)) emerge) (sem-edge-tv (var g) (R12_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R12_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R12_1_sk_wraith (var e)) wraith) (sem-edge-tv (var g) (R12_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R12_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Agent (R12_1_sk_emerge (var e)) (R12_1_sk_wraith (var e))) (sem-edge-tv (var g) (R12_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R12_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) Source (R12_1_sk_emerge (var e)) R12_1_sk_water_1) (sem-edge-tv (var g) (R12_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R12_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) During (R12_1_sk_emerge (var e)) (var e)) (sem-edge-tv (var g) (R12_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- R12.2: Whenever a lantern at the Sunken Cove goes out at night, a wraith rises from the cove's water.
(sem-rule R12_2)
(rule-context R12_2 aelmere)
(rule-priority R12_2 37)
(rule-tv R12_2 authored 1.0 0.9)
(rule-lhs R12_2 ((sem-edge (var g) (var e1) Member (var e) go_out) (sem-edge (var g) (var e2) Object (var e) (var x)) (sem-edge (var g) (var e3) Member (var x) lantern) (sem-edge (var g) (var e4) AttachedTo (var x) sunken_cove) (sem-edge (var g) (var e5) Time (var e) night)))
(rule-rhs R12_2 ((sem-edge (var g) (R12_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R12_2_sk_wraith (var e)) wraith) (sem-edge-tv (var g) (R12_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R12_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R12_2_sk_rise (var e)) rise) (sem-edge-tv (var g) (R12_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R12_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Agent (R12_2_sk_rise (var e)) (R12_2_sk_wraith (var e))) (sem-edge-tv (var g) (R12_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R12_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) Source (R12_2_sk_rise (var e)) R12_2_sk_water_1) (sem-edge-tv (var g) (R12_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R12_2_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) During (R12_2_sk_rise (var e)) (var e)) (sem-edge-tv (var g) (R12_2_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- R12.3: Lanterns away from the Sunken Cove do not raise wraiths.
(sem-rule R12_3)
(rule-context R12_3 aelmere)
(rule-priority R12_3 38)
(rule-tv R12_3 authored 0.0 0.9)
(rule-lhs R12_3 ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) AwayFrom (var x) sunken_cove)))
(rule-rhs R12_3 ((sem-edge (var g) (R12_3_p1 (var e1) (var e2)) And (Member (R12_3_sk_raise (var x)) raise) (Agent (R12_3_sk_raise (var x)) (var x)) (Object (R12_3_sk_raise (var x)) wraith)) (sem-edge-tv (var g) (R12_3_p1 (var e1) (var e2)) (STV 0.0 0.9))))

; --- R13.1: When a wraith approaches a lit lantern, the wraith drains mire-essence from the lantern.
(sem-rule R13_1)
(rule-context R13_1 aelmere)
(rule-priority R13_1 39)
(rule-tv R13_1 authored 1.0 0.9)
(rule-lhs R13_1 ((sem-edge (var g) (var e1) Member (var x) wraith) (sem-edge (var g) (var e2) Member (var y) lantern) (sem-edge (var g) (var e3) Member (var y) lit) (sem-edge (var g) (var e4) Member (var e) approach) (sem-edge (var g) (var e5) Agent (var e) (var x)) (sem-edge (var g) (var e6) Object (var e) (var y))))
(rule-rhs R13_1 ((sem-edge (var g) (R13_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (R13_1_sk_drain (var x) (var y)) drain) (sem-edge-tv (var g) (R13_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R13_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Agent (R13_1_sk_drain (var x) (var y)) (var x)) (sem-edge-tv (var g) (R13_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R13_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Object (R13_1_sk_drain (var x) (var y)) mire_essence) (sem-edge-tv (var g) (R13_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R13_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Source (R13_1_sk_drain (var x) (var y)) (var y)) (sem-edge-tv (var g) (R13_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R13_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) During (R13_1_sk_drain (var x) (var y)) (var e)) (sem-edge-tv (var g) (R13_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9))))

; --- R13.2: Whenever a wraith nears a lit lantern, the wraith pulls mire-essence from the lantern.
(sem-rule R13_2)
(rule-context R13_2 aelmere)
(rule-priority R13_2 40)
(rule-tv R13_2 authored 1.0 0.9)
(rule-lhs R13_2 ((sem-edge (var g) (var e1) Member (var w) wraith) (sem-edge (var g) (var e2) Member (var e) near) (sem-edge (var g) (var e3) Agent (var e) (var w)) (sem-edge (var g) (var e4) Object (var e) (var l)) (sem-edge (var g) (var e5) Member (var l) lantern) (sem-edge (var g) (var e6) Member (var l) lit)))
(rule-rhs R13_2 ((sem-edge (var g) (R13_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (R13_2_sk_pull (var e)) pull) (sem-edge-tv (var g) (R13_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R13_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Agent (R13_2_sk_pull (var e)) (var w)) (sem-edge-tv (var g) (R13_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R13_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Object (R13_2_sk_pull (var e)) mire_essence) (sem-edge-tv (var g) (R13_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R13_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Source (R13_2_sk_pull (var e)) (var l)) (sem-edge-tv (var g) (R13_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R13_2_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) During (R13_2_sk_pull (var e)) (var e)) (sem-edge-tv (var g) (R13_2_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9))))

; --- R13.3: Drained lanterns burn dimly.
(sem-rule R13_3)
(rule-context R13_3 aelmere)
(rule-priority R13_3 41)
(rule-tv R13_3 authored 0.9 0.9)
(rule-lhs R13_3 ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) Member (var x) drained)))
(rule-rhs R13_3 ((sem-edge (var g) (R13_3_p1 (var e1) (var e2)) Member (R13_3_sk_burn (var x)) burn) (sem-edge-tv (var g) (R13_3_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (R13_3_p2 (var e1) (var e2)) Object (R13_3_sk_burn (var x)) (var x)) (sem-edge-tv (var g) (R13_3_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (R13_3_p3 (var e1) (var e2)) Manner (R13_3_sk_burn (var x)) dimly) (sem-edge-tv (var g) (R13_3_p3 (var e1) (var e2)) (STV 0.9 0.9))))

; --- R14.1: When a wraith drains a lantern, the lantern gives weak mist-light.
(sem-rule R14_1)
(rule-context R14_1 aelmere)
(rule-priority R14_1 42)
(rule-tv R14_1 authored 1.0 0.9)
(rule-lhs R14_1 ((sem-edge (var g) (var e1) Member (var e) drain) (sem-edge (var g) (var e2) Agent (var e) (var w)) (sem-edge (var g) (var e3) Member (var w) wraith) (sem-edge (var g) (var e4) Object (var e) (var l)) (sem-edge (var g) (var e5) Member (var l) lantern)))
(rule-rhs R14_1 ((sem-edge (var g) (R14_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R14_1_sk_give (var e)) give) (sem-edge-tv (var g) (R14_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R14_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Agent (R14_1_sk_give (var e)) (var l)) (sem-edge-tv (var g) (R14_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R14_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Object (R14_1_sk_give (var e)) (R14_1_sk_light (var e))) (sem-edge-tv (var g) (R14_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R14_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R14_1_sk_light (var e)) mist_light) (sem-edge-tv (var g) (R14_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R14_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R14_1_sk_light (var e)) weak) (sem-edge-tv (var g) (R14_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R14_1_p6 (var e1) (var e2) (var e3) (var e4) (var e5)) During (R14_1_sk_give (var e)) (var e)) (sem-edge-tv (var g) (R14_1_p6 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- R14.2: Whenever a wraith drains a lantern, the lantern shows dim mist-light.
(sem-rule R14_2)
(rule-context R14_2 aelmere)
(rule-priority R14_2 43)
(rule-tv R14_2 authored 1.0 0.9)
(rule-lhs R14_2 ((sem-edge (var g) (var e1) Member (var e) drain) (sem-edge (var g) (var e2) Agent (var e) (var w)) (sem-edge (var g) (var e3) Member (var w) wraith) (sem-edge (var g) (var e4) Object (var e) (var y)) (sem-edge (var g) (var e5) Member (var y) lantern)))
(rule-rhs R14_2 ((sem-edge (var g) (R14_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R14_2_sk_show (var e)) show) (sem-edge-tv (var g) (R14_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R14_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Agent (R14_2_sk_show (var e)) (var y)) (sem-edge-tv (var g) (R14_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R14_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Object (R14_2_sk_show (var e)) (R14_2_sk_light (var e))) (sem-edge-tv (var g) (R14_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R14_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R14_2_sk_light (var e)) mist_light) (sem-edge-tv (var g) (R14_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R14_2_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R14_2_sk_light (var e)) dim) (sem-edge-tv (var g) (R14_2_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R14_2_p6 (var e1) (var e2) (var e3) (var e4) (var e5)) During (R14_2_sk_show (var e)) (var e)) (sem-edge-tv (var g) (R14_2_p6 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- R14.3: Weak mist-light rarely attracts nightmoths.
(sem-rule R14_3)
(rule-context R14_3 aelmere)
(rule-priority R14_3 44)
(rule-tv R14_3 authored 0.1 0.9)
(rule-lhs R14_3 ((sem-edge (var g) (var e1) Member (var x) mist_light) (sem-edge (var g) (var e2) Member (var x) weak)))
(rule-rhs R14_3 ((sem-edge (var g) (R14_3_p1 (var e1) (var e2)) And (Member (R14_3_sk_attract (var x)) attract) (Agent (R14_3_sk_attract (var x)) (var x)) (Object (R14_3_sk_attract (var x)) nightmoth)) (sem-edge-tv (var g) (R14_3_p1 (var e1) (var e2)) (STV 0.1 0.9))))

; --- R14.4: When a lantern attracts a handful of nightmoths, the thread harvest at that lantern falls.
(sem-rule R14_4)
(rule-context R14_4 aelmere)
(rule-priority R14_4 45)
(rule-tv R14_4 authored 1.0 0.9)
(rule-lhs R14_4 ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) Member (var e1) attract) (sem-edge (var g) (var e3) Agent (var e1) (var x)) (sem-edge (var g) (var e4) Object (var e1) (var g)) (sem-edge (var g) (var e5) GroupOf (var g) nightmoth) (sem-edge (var g) (var e6) CardinalityPhrase (var g) "handful")))
(rule-rhs R14_4 ((sem-edge (var g) (R14_4_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (R14_4_sk_fall (var e1)) fall) (sem-edge-tv (var g) (R14_4_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R14_4_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Object (R14_4_sk_fall (var e1)) (R14_4_sk_harvest (var x))) (sem-edge-tv (var g) (R14_4_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R14_4_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (R14_4_sk_harvest (var x)) thread_harvest) (sem-edge-tv (var g) (R14_4_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R14_4_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) LocatedIn (R14_4_sk_harvest (var x)) (var x)) (sem-edge-tv (var g) (R14_4_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R14_4_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) During (R14_4_sk_fall (var e1)) (var e1)) (sem-edge-tv (var g) (R14_4_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9))))

; --- R15.1: When a Keeper grinds feathers and scatters the feathers around a lit lantern, the feathers ward the lantern against wraiths.
(sem-rule R15_1)
(rule-context R15_1 aelmere)
(rule-priority R15_1 46)
(rule-tv R15_1 authored 1.0 0.9)
(rule-lhs R15_1 ((sem-edge (var g) (var e1) Member (var k) keeper) (sem-edge (var g) (var e2) GroupOf (var f) feather) (sem-edge (var g) (var e3) Member (var e1) grind) (sem-edge (var g) (var e4) Agent (var e1) (var k)) (sem-edge (var g) (var e5) Object (var e1) (var f)) (sem-edge (var g) (var e6) Member (var e2) scatter) (sem-edge (var g) (var e7) Agent (var e2) (var k)) (sem-edge (var g) (var e8) Object (var e2) (var f)) (sem-edge (var g) (var e9) Around (var e2) (var n)) (sem-edge (var g) (var e10) Member (var n) lantern) (sem-edge (var g) (var e11) Member (var n) lit)))
(rule-rhs R15_1 ((sem-edge (var g) (R15_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) Member (R15_1_sk_ward (var f) (var n)) ward) (sem-edge-tv (var g) (R15_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) (STV 1.0 0.9)) (sem-edge (var g) (R15_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) Agent (R15_1_sk_ward (var f) (var n)) (var f)) (sem-edge-tv (var g) (R15_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) (STV 1.0 0.9)) (sem-edge (var g) (R15_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) Object (R15_1_sk_ward (var f) (var n)) (var n)) (sem-edge-tv (var g) (R15_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) (STV 1.0 0.9)) (sem-edge (var g) (R15_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) Against (R15_1_sk_ward (var f) (var n)) wraith) (sem-edge-tv (var g) (R15_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) (STV 1.0 0.9)) (sem-edge (var g) (R15_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) During (R15_1_sk_ward (var f) (var n)) (var e2)) (sem-edge-tv (var g) (R15_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) (STV 1.0 0.9))))

; --- R15.2: Whenever a Keeper grinds feathers and spreads the feathers around a lit lantern, the feathers shield the lantern against wraiths.
(sem-rule R15_2)
(rule-context R15_2 aelmere)
(rule-priority R15_2 47)
(rule-tv R15_2 authored 1.0 0.9)
(rule-lhs R15_2 ((sem-edge (var g) (var e1) Member (var k) keeper) (sem-edge (var g) (var e2) GroupOf (var fg) feather) (sem-edge (var g) (var e3) Member (var g) grind) (sem-edge (var g) (var e4) Agent (var g) (var k)) (sem-edge (var g) (var e5) Object (var g) (var fg)) (sem-edge (var g) (var e6) Member (var l) lantern) (sem-edge (var g) (var e7) Member (var l) lit) (sem-edge (var g) (var e8) Member (var s) spread) (sem-edge (var g) (var e9) Agent (var s) (var k)) (sem-edge (var g) (var e10) Object (var s) (var fg)) (sem-edge (var g) (var e11) Around (var s) (var l))))
(rule-rhs R15_2 ((sem-edge (var g) (R15_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) Member (R15_2_sk_shield (var g) (var s)) shield) (sem-edge-tv (var g) (R15_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) (STV 1.0 0.9)) (sem-edge (var g) (R15_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) Agent (R15_2_sk_shield (var g) (var s)) (var fg)) (sem-edge-tv (var g) (R15_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) (STV 1.0 0.9)) (sem-edge (var g) (R15_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) Object (R15_2_sk_shield (var g) (var s)) (var l)) (sem-edge-tv (var g) (R15_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) (STV 1.0 0.9)) (sem-edge (var g) (R15_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) Against (R15_2_sk_shield (var g) (var s)) wraith) (sem-edge-tv (var g) (R15_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) (STV 1.0 0.9)) (sem-edge (var g) (R15_2_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) During (R15_2_sk_shield (var g) (var s)) (var s)) (sem-edge-tv (var g) (R15_2_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9) (var e10) (var e11)) (STV 1.0 0.9))))

; --- R15.3: Wraiths do not approach a warded lantern.
(sem-rule R15_3)
(rule-context R15_3 aelmere)
(rule-priority R15_3 48)
(rule-tv R15_3 authored 0.0 0.9)
(rule-lhs R15_3 ((sem-edge (var g) (var e1) Member (var x) wraith) (sem-edge (var g) (var e2) Member (var y) lantern) (sem-edge (var g) (var e3) Member (var y) warded)))
(rule-rhs R15_3 ((sem-edge (var g) (R15_3_p1 (var e1) (var e2) (var e3)) And (Member (R15_3_sk_approach (var x) (var y)) approach) (Agent (R15_3_sk_approach (var x) (var y)) (var x)) (Object (R15_3_sk_approach (var x) (var y)) (var y))) (sem-edge-tv (var g) (R15_3_p1 (var e1) (var e2) (var e3)) (STV 0.0 0.9))))

; --- R15.4: Fresh ground feathers ward lanterns.
(sem-rule R15_4)
(rule-context R15_4 aelmere)
(rule-priority R15_4 49)
(rule-tv R15_4 authored 0.9 0.9)
(rule-lhs R15_4 ((sem-edge (var g) (var e1) Member (var x) feather) (sem-edge (var g) (var e2) Member (var x) ground) (sem-edge (var g) (var e3) Member (var x) fresh)))
(rule-rhs R15_4 ((sem-edge (var g) (R15_4_p1 (var e1) (var e2) (var e3)) Member (R15_4_sk_ward (var x)) ward) (sem-edge-tv (var g) (R15_4_p1 (var e1) (var e2) (var e3)) (STV 0.9 0.9)) (sem-edge (var g) (R15_4_p2 (var e1) (var e2) (var e3)) Agent (R15_4_sk_ward (var x)) (var x)) (sem-edge-tv (var g) (R15_4_p2 (var e1) (var e2) (var e3)) (STV 0.9 0.9)) (sem-edge (var g) (R15_4_p3 (var e1) (var e2) (var e3)) Object (R15_4_sk_ward (var x)) lantern) (sem-edge-tv (var g) (R15_4_p3 (var e1) (var e2) (var e3)) (STV 0.9 0.9))))

; --- R15.5: Stale ground feathers do not ward lanterns.
(sem-rule R15_5)
(rule-context R15_5 aelmere)
(rule-priority R15_5 50)
(rule-tv R15_5 authored 0.0 0.9)
(rule-lhs R15_5 ((sem-edge (var g) (var e1) Member (var x) feather) (sem-edge (var g) (var e2) Member (var x) stale) (sem-edge (var g) (var e3) Member (var x) ground)))
(rule-rhs R15_5 ((sem-edge (var g) (R15_5_p1 (var e1) (var e2) (var e3)) And (Member (R15_5_sk_ward (var x)) ward) (Agent (R15_5_sk_ward (var x)) (var x)) (Object (R15_5_sk_ward (var x)) lantern)) (sem-edge-tv (var g) (R15_5_p1 (var e1) (var e2) (var e3)) (STV 0.0 0.9))))

; --- R16.1: Whenever a cold wind blows off the sea at night, that wind extinguishes unprepared lanterns.
(sem-rule R16_1)
(rule-context R16_1 aelmere)
(rule-priority R16_1 51)
(rule-tv R16_1 authored 1.0 0.9)
(rule-lhs R16_1 ((sem-edge (var g) (var e1) Member (var w) wind) (sem-edge (var g) (var e2) Member (var w) cold) (sem-edge (var g) (var e3) Member (var b) blow) (sem-edge (var g) (var e4) Agent (var b) (var w)) (sem-edge (var g) (var e5) Source (var b) cold_sea) (sem-edge (var g) (var e6) Time (var b) night) (sem-edge (var g) (var e7) Member (var l) lantern) (sem-edge (var g) (var e8) Member (var l) unprepared)))
(rule-rhs R16_1 ((sem-edge (var g) (R16_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Member (R16_1_sk_extinguish (var b) (var l)) extinguish) (sem-edge-tv (var g) (R16_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (R16_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Agent (R16_1_sk_extinguish (var b) (var l)) (var w)) (sem-edge-tv (var g) (R16_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (R16_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Object (R16_1_sk_extinguish (var b) (var l)) (var l)) (sem-edge-tv (var g) (R16_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (R16_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) During (R16_1_sk_extinguish (var b) (var l)) (var b)) (sem-edge-tv (var g) (R16_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9))))

; --- R16.2: When a cold wind strikes the Cliff Path at night, unprepared lanterns go out.
(sem-rule R16_2)
(rule-context R16_2 aelmere)
(rule-priority R16_2 52)
(rule-tv R16_2 authored 1.0 0.9)
(rule-lhs R16_2 ((sem-edge (var g) (var e1) Member (var e) strike) (sem-edge (var g) (var e2) Agent (var e) (var w)) (sem-edge (var g) (var e3) Member (var w) wind) (sem-edge (var g) (var e4) Member (var w) cold) (sem-edge (var g) (var e5) Object (var e) cliff_path) (sem-edge (var g) (var e6) Time (var e) night) (sem-edge (var g) (var e7) Member (var y) lantern) (sem-edge (var g) (var e8) Member (var y) unprepared)))
(rule-rhs R16_2 ((sem-edge (var g) (R16_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Member (R16_2_sk_go_out (var e) (var y)) go_out) (sem-edge-tv (var g) (R16_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (R16_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Object (R16_2_sk_go_out (var e) (var y)) (var y)) (sem-edge-tv (var g) (R16_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (R16_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) During (R16_2_sk_go_out (var e) (var y)) (var e)) (sem-edge-tv (var g) (R16_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9))))

; --- R17.1: Whenever a Keeper adds salt-bloom to mire-essence in winter, that mire-essence burns slowly.
(sem-rule R17_1)
(rule-context R17_1 aelmere)
(rule-priority R17_1 53)
(rule-tv R17_1 authored 1.0 0.9)
(rule-lhs R17_1 ((sem-edge (var g) (var e1) Member (var x) add) (sem-edge (var g) (var e2) Agent (var x) (var k)) (sem-edge (var g) (var e3) Member (var k) keeper) (sem-edge (var g) (var e4) Object (var x) (var t1)) (sem-edge (var g) (var e5) Member (var t1) salt_bloom) (sem-edge (var g) (var e6) Goal (var x) (var m)) (sem-edge (var g) (var e7) Member (var m) mire_essence) (sem-edge (var g) (var e8) Time (var x) winter)))
(rule-rhs R17_1 ((sem-edge (var g) (R17_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Member (R17_1_sk_burn (var x)) burn) (sem-edge-tv (var g) (R17_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (R17_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Object (R17_1_sk_burn (var x)) (var m)) (sem-edge-tv (var g) (R17_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (R17_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Manner (R17_1_sk_burn (var x)) slowly) (sem-edge-tv (var g) (R17_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (R17_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) During (R17_1_sk_burn (var x)) (var x)) (sem-edge-tv (var g) (R17_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9))))

; --- R17.2: Whenever a Keeper mixes salt-bloom into mire-essence in winter, that mire-essence burns slowly.
(sem-rule R17_2)
(rule-context R17_2 aelmere)
(rule-priority R17_2 54)
(rule-tv R17_2 authored 1.0 0.9)
(rule-lhs R17_2 ((sem-edge (var g) (var e1) Member (var k) keeper) (sem-edge (var g) (var e2) Member (var e1) mix) (sem-edge (var g) (var e3) Agent (var e1) (var k)) (sem-edge (var g) (var e4) Object (var e1) (var t1)) (sem-edge (var g) (var e5) Member (var t1) salt_bloom) (sem-edge (var g) (var e6) Goal (var e1) (var t2)) (sem-edge (var g) (var e7) Member (var t2) mire_essence) (sem-edge (var g) (var e8) Time (var e1) winter)))
(rule-rhs R17_2 ((sem-edge (var g) (R17_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Member (R17_2_sk_burn (var e1)) burn) (sem-edge-tv (var g) (R17_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (R17_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Object (R17_2_sk_burn (var e1)) mire_essence) (sem-edge-tv (var g) (R17_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (R17_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Manner (R17_2_sk_burn (var e1)) slowly) (sem-edge-tv (var g) (R17_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (R17_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) During (R17_2_sk_burn (var e1)) (var e1)) (sem-edge-tv (var g) (R17_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9))))

; --- R17.3: When a cold wind strikes a salt-bloomed lantern, the lantern stays lit.
(sem-rule R17_3)
(rule-context R17_3 aelmere)
(rule-priority R17_3 55)
(rule-tv R17_3 authored 1.0 0.9)
(rule-lhs R17_3 ((sem-edge (var g) (var e1) Member (var wd) wind) (sem-edge (var g) (var e2) Member (var wd) cold) (sem-edge (var g) (var e3) Member (var e) strike) (sem-edge (var g) (var e4) Agent (var e) (var wd)) (sem-edge (var g) (var e5) Object (var e) (var l)) (sem-edge (var g) (var e6) Member (var l) lantern) (sem-edge (var g) (var e7) Member (var l) salt_bloomed)))
(rule-rhs R17_3 ((sem-edge (var g) (R17_3_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Member (R17_3_sk_lit (var e)) lit) (sem-edge-tv (var g) (R17_3_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R17_3_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Experiencer (R17_3_sk_lit (var e)) (var l)) (sem-edge-tv (var g) (R17_3_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R17_3_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Still (R17_3_sk_lit (var e))) (sem-edge-tv (var g) (R17_3_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R17_3_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Member (var l) lit) (sem-edge-tv (var g) (R17_3_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R17_3_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) During (R17_3_sk_lit (var e)) (var e)) (sem-edge-tv (var g) (R17_3_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9))))

; --- R18.1: When a Keeper harvests salt-bloom at the new moon, that salt-bloom stays potent.
(sem-rule R18_1)
(rule-context R18_1 aelmere)
(rule-priority R18_1 56)
(rule-tv R18_1 authored 1.0 0.9)
(rule-lhs R18_1 ((sem-edge (var g) (var e1) Member (var e) harvest) (sem-edge (var g) (var e2) Agent (var e) (var k)) (sem-edge (var g) (var e3) Member (var k) keeper) (sem-edge (var g) (var e4) Object (var e) (var s)) (sem-edge (var g) (var e5) Member (var s) salt_bloom) (sem-edge (var g) (var e6) Time (var e) new_moon)))
(rule-rhs R18_1 ((sem-edge (var g) (R18_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (R18_1_sk_potent (var s)) potent) (sem-edge-tv (var g) (R18_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R18_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Experiencer (R18_1_sk_potent (var s)) (var s)) (sem-edge-tv (var g) (R18_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R18_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Still (R18_1_sk_potent (var s))) (sem-edge-tv (var g) (R18_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R18_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (var s) potent) (sem-edge-tv (var g) (R18_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9))))

; --- R18.2: Whenever a Keeper gathers salt-bloom at the new moon, that salt-bloom stays potent.
(sem-rule R18_2)
(rule-context R18_2 aelmere)
(rule-priority R18_2 57)
(rule-tv R18_2 authored 1.0 0.9)
(rule-lhs R18_2 ((sem-edge (var g) (var e1) Member (var k) keeper) (sem-edge (var g) (var e2) Member (var g) gather) (sem-edge (var g) (var e3) Agent (var g) (var k)) (sem-edge (var g) (var e4) Object (var g) (var b)) (sem-edge (var g) (var e5) Member (var b) salt_bloom) (sem-edge (var g) (var e6) Time (var g) new_moon)))
(rule-rhs R18_2 ((sem-edge (var g) (R18_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (R18_2_sk_potent (var b)) potent) (sem-edge-tv (var g) (R18_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R18_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Experiencer (R18_2_sk_potent (var b)) (var b)) (sem-edge-tv (var g) (R18_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R18_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Still (R18_2_sk_potent (var b))) (sem-edge-tv (var g) (R18_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R18_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (var b) potent) (sem-edge-tv (var g) (R18_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9))))

; --- R18.3: Every time a Keeper gathers salt-bloom at the full moon, that salt-bloom turns to chalky residue.
(sem-rule R18_3)
(rule-context R18_3 aelmere)
(rule-priority R18_3 58)
(rule-tv R18_3 authored 1.0 0.9)
(rule-lhs R18_3 ((sem-edge (var g) (var e1) Member (var k) keeper) (sem-edge (var g) (var e2) Member (var g) gather) (sem-edge (var g) (var e3) Agent (var g) (var k)) (sem-edge (var g) (var e4) Member (var s) salt_bloom) (sem-edge (var g) (var e5) Object (var g) (var s)) (sem-edge (var g) (var e6) Time (var g) full_moon)))
(rule-rhs R18_3 ((sem-edge (var g) (R18_3_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (R18_3_sk_turn (var g)) turn) (sem-edge-tv (var g) (R18_3_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R18_3_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Object (R18_3_sk_turn (var g)) (var s)) (sem-edge-tv (var g) (R18_3_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R18_3_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) During (R18_3_sk_turn (var g)) (var g)) (sem-edge-tv (var g) (R18_3_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R18_3_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (R18_3_sk_residue (var g)) chalky_residue) (sem-edge-tv (var g) (R18_3_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R18_3_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Experiencer (R18_3_sk_residue (var g)) (var s)) (sem-edge-tv (var g) (R18_3_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R18_3_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (var s) chalky_residue) (sem-edge-tv (var g) (R18_3_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R18_3_p7 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Result (R18_3_sk_turn (var g)) (R18_3_sk_residue (var g))) (sem-edge-tv (var g) (R18_3_p7 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9))))

; --- R18.4: Every time a Keeper gathers salt-bloom at the half moon, that salt-bloom turns to chalky residue.
(sem-rule R18_4)
(rule-context R18_4 aelmere)
(rule-priority R18_4 59)
(rule-tv R18_4 authored 1.0 0.9)
(rule-lhs R18_4 ((sem-edge (var g) (var e1) Member (var x) gather) (sem-edge (var g) (var e2) Agent (var x) (var k)) (sem-edge (var g) (var e3) Member (var k) keeper) (sem-edge (var g) (var e4) Object (var x) (var sb)) (sem-edge (var g) (var e5) Member (var sb) salt_bloom) (sem-edge (var g) (var e6) Time (var x) half_moon)))
(rule-rhs R18_4 ((sem-edge (var g) (R18_4_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (R18_4_sk_turn (var x)) turn) (sem-edge-tv (var g) (R18_4_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R18_4_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Object (R18_4_sk_turn (var x)) (var sb)) (sem-edge-tv (var g) (R18_4_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R18_4_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) During (R18_4_sk_turn (var x)) (var x)) (sem-edge-tv (var g) (R18_4_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R18_4_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (R18_4_sk_chalky_residue (var x)) chalky_residue) (sem-edge-tv (var g) (R18_4_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R18_4_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Experiencer (R18_4_sk_chalky_residue (var x)) (var sb)) (sem-edge-tv (var g) (R18_4_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R18_4_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (var sb) chalky_residue) (sem-edge-tv (var g) (R18_4_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R18_4_p7 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Result (R18_4_sk_turn (var x)) (R18_4_sk_chalky_residue (var x))) (sem-edge-tv (var g) (R18_4_p7 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9))))

; --- R19.1: When a spring tide fills the tide-pools, salt-bloom blooms in the tide-pools.
(sem-rule R19_1)
(rule-context R19_1 aelmere)
(rule-priority R19_1 60)
(rule-tv R19_1 authored 1.0 0.9)
(rule-lhs R19_1 ((sem-edge (var g) (var e1) Member (var t) spring_tide) (sem-edge (var g) (var e2) Member (var e1) fill) (sem-edge (var g) (var e3) Agent (var e1) (var t)) (sem-edge (var g) (var e4) Object (var e1) salt_bloom_tide_pools)))
(rule-rhs R19_1 ((sem-edge (var g) (R19_1_p1 (var e1) (var e2) (var e3) (var e4)) Member (R19_1_sk_bloom (var e1)) bloom) (sem-edge-tv (var g) (R19_1_p1 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R19_1_p2 (var e1) (var e2) (var e3) (var e4)) Object (R19_1_sk_bloom (var e1)) salt_bloom) (sem-edge-tv (var g) (R19_1_p2 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R19_1_p3 (var e1) (var e2) (var e3) (var e4)) Location (R19_1_sk_bloom (var e1)) salt_bloom_tide_pools) (sem-edge-tv (var g) (R19_1_p3 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R19_1_p4 (var e1) (var e2) (var e3) (var e4)) During (R19_1_sk_bloom (var e1)) (var e1)) (sem-edge-tv (var g) (R19_1_p4 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9))))

; --- R19.2: Whenever a spring tide fills the tide-pools, salt-bloom grows in the tide-pools.
(sem-rule R19_2)
(rule-context R19_2 aelmere)
(rule-priority R19_2 61)
(rule-tv R19_2 authored 1.0 0.9)
(rule-lhs R19_2 ((sem-edge (var g) (var e1) Member (var t) spring_tide) (sem-edge (var g) (var e2) Member (var f) fill) (sem-edge (var g) (var e3) Agent (var f) (var t)) (sem-edge (var g) (var e4) Object (var f) salt_bloom_tide_pools)))
(rule-rhs R19_2 ((sem-edge (var g) (R19_2_p1 (var e1) (var e2) (var e3) (var e4)) Member (R19_2_sk_grow (var f)) grow) (sem-edge-tv (var g) (R19_2_p1 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R19_2_p2 (var e1) (var e2) (var e3) (var e4)) Object (R19_2_sk_grow (var f)) salt_bloom) (sem-edge-tv (var g) (R19_2_p2 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R19_2_p3 (var e1) (var e2) (var e3) (var e4)) Location (R19_2_sk_grow (var f)) salt_bloom_tide_pools) (sem-edge-tv (var g) (R19_2_p3 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R19_2_p4 (var e1) (var e2) (var e3) (var e4)) During (R19_2_sk_grow (var f)) (var f)) (sem-edge-tv (var g) (R19_2_p4 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9))))

; --- R20.1: Spring tides occur at new moon or at full moon.
(sem-rule R20_1)
(rule-context R20_1 aelmere)
(rule-priority R20_1 62)
(rule-tv R20_1 authored 1.0 0.99)
(rule-lhs R20_1 ((sem-edge (var g) (var e1) Member (var x) spring_tide)))
(rule-rhs R20_1 ((sem-edge (var g) (R20_1_p1 (var e1)) Or (Time (var x) new_moon) (Time (var x) full_moon)) (sem-edge-tv (var g) (R20_1_p1 (var e1)) (STV 1.0 0.99))))

; --- R20.2: Each Keeper times the salt-bloom harvest to the new-moon spring tide.
(sem-rule R20_2)
(rule-context R20_2 aelmere)
(rule-priority R20_2 63)
(rule-tv R20_2 authored 1.0 0.9)
(rule-lhs R20_2 ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs R20_2 ((sem-edge (var g) (R20_2_p1 (var e1)) Member (R20_2_sk_time (var x)) time) (sem-edge-tv (var g) (R20_2_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R20_2_p2 (var e1)) Agent (R20_2_sk_time (var x)) (var x)) (sem-edge-tv (var g) (R20_2_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R20_2_p3 (var e1)) Object (R20_2_sk_time (var x)) R20_2_sk_harvest_1) (sem-edge-tv (var g) (R20_2_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R20_2_p4 (var e1)) Goal (R20_2_sk_time (var x)) R20_2_sk_tide_1) (sem-edge-tv (var g) (R20_2_p4 (var e1)) (STV 1.0 0.9))))

; --- R21.1: Whenever a lantern burns wintergloss, the wintergloss repels nightmoths from that lantern.
(sem-rule R21_1)
(rule-context R21_1 aelmere)
(rule-priority R21_1 64)
(rule-tv R21_1 authored 1.0 0.9)
(rule-lhs R21_1 ((sem-edge (var g) (var e1) Member (var x) burn) (sem-edge (var g) (var e2) Agent (var x) (var l)) (sem-edge (var g) (var e3) Member (var l) lantern) (sem-edge (var g) (var e4) Object (var x) (var t1)) (sem-edge (var g) (var e5) Member (var t1) wintergloss)))
(rule-rhs R21_1 ((sem-edge (var g) (R21_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R21_1_sk_repel (var x)) repel) (sem-edge-tv (var g) (R21_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R21_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Agent (R21_1_sk_repel (var x)) wintergloss) (sem-edge-tv (var g) (R21_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R21_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Object (R21_1_sk_repel (var x)) nightmoth) (sem-edge-tv (var g) (R21_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R21_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) Source (R21_1_sk_repel (var x)) (var l)) (sem-edge-tv (var g) (R21_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R21_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) During (R21_1_sk_repel (var x)) (var x)) (sem-edge-tv (var g) (R21_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- R21.2: Whenever a lantern burns wintergloss alongside mire-essence, every nightmoth avoids that lantern.
(sem-rule R21_2)
(rule-context R21_2 aelmere)
(rule-priority R21_2 65)
(rule-tv R21_2 authored 1.0 0.9)
(rule-lhs R21_2 ((sem-edge (var g) (var e1) Member (var e) burn) (sem-edge (var g) (var e2) Agent (var e) (var x)) (sem-edge (var g) (var e3) Member (var x) lantern) (sem-edge (var g) (var e4) Object (var e) (var t1)) (sem-edge (var g) (var e5) Member (var t1) wintergloss) (sem-edge (var g) (var e6) Alongside (var e) (var t2)) (sem-edge (var g) (var e7) Member (var t2) mire_essence) (sem-edge (var g) (var e8) Member (var y) nightmoth)))
(rule-rhs R21_2 ((sem-edge (var g) (R21_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Member (R21_2_sk_avoid (var e) (var y)) avoid) (sem-edge-tv (var g) (R21_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (R21_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Agent (R21_2_sk_avoid (var e) (var y)) (var y)) (sem-edge-tv (var g) (R21_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (R21_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Object (R21_2_sk_avoid (var e) (var y)) (var x)) (sem-edge-tv (var g) (R21_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (R21_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) During (R21_2_sk_avoid (var e) (var y)) (var e)) (sem-edge-tv (var g) (R21_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9))))

; --- R22.1: Whenever a cliff-spire shields a cove against north winds, each lantern in that cove burns stably through winter.
(sem-rule R22_1)
(rule-context R22_1 aelmere)
(rule-priority R22_1 66)
(rule-tv R22_1 authored 1.0 0.9)
(rule-lhs R22_1 ((sem-edge (var g) (var e1) Member (var e) shield) (sem-edge (var g) (var e2) Agent (var e) (var cs)) (sem-edge (var g) (var e3) Member (var cs) cliff_spire) (sem-edge (var g) (var e4) Object (var e) (var cv)) (sem-edge (var g) (var e5) Member (var cv) cove) (sem-edge (var g) (var e6) Against (var e) (var t1)) (sem-edge (var g) (var e7) Member (var t1) north_wind) (sem-edge (var g) (var e8) Member (var l) lantern) (sem-edge (var g) (var e9) AttachedTo (var l) (var cv))))
(rule-rhs R22_1 ((sem-edge (var g) (R22_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) Member (R22_1_sk_burn (var e) (var l)) burn) (sem-edge-tv (var g) (R22_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) (STV 1.0 0.9)) (sem-edge (var g) (R22_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) Object (R22_1_sk_burn (var e) (var l)) (var l)) (sem-edge-tv (var g) (R22_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) (STV 1.0 0.9)) (sem-edge (var g) (R22_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) Manner (R22_1_sk_burn (var e) (var l)) stably) (sem-edge-tv (var g) (R22_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) (STV 1.0 0.9)) (sem-edge (var g) (R22_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) Through (R22_1_sk_burn (var e) (var l)) winter) (sem-edge-tv (var g) (R22_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) (STV 1.0 0.9)) (sem-edge (var g) (R22_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) During (R22_1_sk_burn (var e) (var l)) (var e)) (sem-edge-tv (var g) (R22_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8) (var e9)) (STV 1.0 0.9))))

; --- R22.2: Whenever a cliff-spire shelters a cove, each lantern in that cove stays lit through winter.
(sem-rule R22_2)
(rule-context R22_2 aelmere)
(rule-priority R22_2 67)
(rule-tv R22_2 authored 1.0 0.9)
(rule-lhs R22_2 ((sem-edge (var g) (var e1) Member (var x) cliff_spire) (sem-edge (var g) (var e2) Member (var sh) shelter) (sem-edge (var g) (var e3) Agent (var sh) (var x)) (sem-edge (var g) (var e4) Member (var c) cove) (sem-edge (var g) (var e5) Object (var sh) (var c)) (sem-edge (var g) (var e6) Member (var l) lantern) (sem-edge (var g) (var e7) AttachedTo (var l) (var c))))
(rule-rhs R22_2 ((sem-edge (var g) (R22_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Member (R22_2_sk_lit (var l)) lit) (sem-edge-tv (var g) (R22_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R22_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Experiencer (R22_2_sk_lit (var l)) (var l)) (sem-edge-tv (var g) (R22_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R22_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Still (R22_2_sk_lit (var l))) (sem-edge-tv (var g) (R22_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R22_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Time (R22_2_sk_lit (var l)) winter) (sem-edge-tv (var g) (R22_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R22_2_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) During (R22_2_sk_lit (var l)) (var sh)) (sem-edge-tv (var g) (R22_2_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (R22_2_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Member (var l) lit) (sem-edge-tv (var g) (R22_2_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9))))

; --- R22.4: Northcove lanterns never go out when cold winds blow.
(sem-rule R22_4)
(rule-context R22_4 aelmere)
(rule-priority R22_4 68)
(rule-tv R22_4 authored 0.0 0.9)
(rule-lhs R22_4 ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) AttachedTo (var x) northcove) (sem-edge (var g) (var e3) Member (var w) blow) (sem-edge (var g) (var e4) Member (var c) wind) (sem-edge (var g) (var e5) Member (var c) cold) (sem-edge (var g) (var e6) Object (var w) (var c))))
(rule-rhs R22_4 ((sem-edge (var g) (R22_4_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) And (Member (R22_4_sk_go_out (var x) (var w)) go_out) (Object (R22_4_sk_go_out (var x) (var w)) (var x)) (During (R22_4_sk_go_out (var x) (var w)) (var w))) (sem-edge-tv (var g) (R22_4_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 0.0 0.9))))

; --- R23.1: Whenever a senior Keeper retires, an heir inherits that Keeper's lantern-station.
(sem-rule R23_1)
(rule-context R23_1 aelmere)
(rule-priority R23_1 69)
(rule-tv R23_1 authored 1.0 0.9)
(rule-lhs R23_1 ((sem-edge (var g) (var e1) Member (var e) retire) (sem-edge (var g) (var e2) Agent (var e) (var k)) (sem-edge (var g) (var e3) Member (var k) senior_keeper)))
(rule-rhs R23_1 ((sem-edge (var g) (R23_1_p1 (var e1) (var e2) (var e3)) Member (R23_1_sk_heir (var k)) heir) (sem-edge-tv (var g) (R23_1_p1 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R23_1_p2 (var e1) (var e2) (var e3)) Member (R23_1_sk_inherit (var k)) inherit) (sem-edge-tv (var g) (R23_1_p2 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R23_1_p3 (var e1) (var e2) (var e3)) Agent (R23_1_sk_inherit (var k)) (R23_1_sk_heir (var k))) (sem-edge-tv (var g) (R23_1_p3 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R23_1_p4 (var e1) (var e2) (var e3)) Object (R23_1_sk_inherit (var k)) (R23_1_sk_lantern_station (var k))) (sem-edge-tv (var g) (R23_1_p4 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R23_1_p5 (var e1) (var e2) (var e3)) Member (R23_1_sk_lantern_station (var k)) lantern_station) (sem-edge-tv (var g) (R23_1_p5 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R23_1_p6 (var e1) (var e2) (var e3)) Possession (R23_1_sk_lantern_station (var k)) (var k)) (sem-edge-tv (var g) (R23_1_p6 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R23_1_p7 (var e1) (var e2) (var e3)) During (R23_1_sk_inherit (var k)) (var e)) (sem-edge-tv (var g) (R23_1_p7 (var e1) (var e2) (var e3)) (STV 1.0 0.9))))

; --- R23.2: Whenever a senior Keeper dies, an heir inherits that Keeper's lantern-station.
(sem-rule R23_2)
(rule-context R23_2 aelmere)
(rule-priority R23_2 70)
(rule-tv R23_2 authored 1.0 0.9)
(rule-lhs R23_2 ((sem-edge (var g) (var e1) Member (var k) senior_keeper) (sem-edge (var g) (var e2) Member (var d) die) (sem-edge (var g) (var e3) Object (var d) (var k))))
(rule-rhs R23_2 ((sem-edge (var g) (R23_2_p1 (var e1) (var e2) (var e3)) Member (R23_2_sk_heir (var k)) heir) (sem-edge-tv (var g) (R23_2_p1 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R23_2_p2 (var e1) (var e2) (var e3)) Member (R23_2_sk_inherit (var k)) inherit) (sem-edge-tv (var g) (R23_2_p2 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R23_2_p3 (var e1) (var e2) (var e3)) Agent (R23_2_sk_inherit (var k)) (R23_2_sk_heir (var k))) (sem-edge-tv (var g) (R23_2_p3 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R23_2_p4 (var e1) (var e2) (var e3)) Object (R23_2_sk_inherit (var k)) (R23_2_sk_station (var k))) (sem-edge-tv (var g) (R23_2_p4 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R23_2_p5 (var e1) (var e2) (var e3)) Member (R23_2_sk_station (var k)) lantern_station) (sem-edge-tv (var g) (R23_2_p5 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R23_2_p6 (var e1) (var e2) (var e3)) Possession (R23_2_sk_station (var k)) (var k)) (sem-edge-tv (var g) (R23_2_p6 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (R23_2_p7 (var e1) (var e2) (var e3)) During (R23_2_sk_inherit (var k)) (var d)) (sem-edge-tv (var g) (R23_2_p7 (var e1) (var e2) (var e3)) (STV 1.0 0.9))))

; --- R23.4: The Council must approve any station transfer.
(sem-rule R23_4)
(rule-context R23_4 aelmere)
(rule-priority R23_4 71)
(rule-tv R23_4 authored 1.0 0.99)
(rule-lhs R23_4 ((sem-edge (var g) (var e1) Member (var t) station_transfer)))
(rule-rhs R23_4 ((sem-edge (var g) (R23_4_p1 (var e1)) Member (R23_4_sk_approve (var t)) approve) (sem-edge-tv (var g) (R23_4_p1 (var e1)) (STV 1.0 0.99)) (sem-edge (var g) (R23_4_p2 (var e1)) Agent (R23_4_sk_approve (var t)) the_council) (sem-edge-tv (var g) (R23_4_p2 (var e1)) (STV 1.0 0.99)) (sem-edge (var g) (R23_4_p3 (var e1)) Object (R23_4_sk_approve (var t)) (var t)) (sem-edge-tv (var g) (R23_4_p3 (var e1)) (STV 1.0 0.99)) (sem-edge (var g) (R23_4_p4 (var e1)) Obligated (R23_4_sk_approve (var t))) (sem-edge-tv (var g) (R23_4_p4 (var e1)) (STV 1.0 0.99))))

; --- R24.2: Each newcomer apprentices under a senior Keeper.
(sem-rule R24_2)
(rule-context R24_2 aelmere)
(rule-priority R24_2 72)
(rule-tv R24_2 authored 1.0 0.9)
(rule-lhs R24_2 ((sem-edge (var g) (var e1) Member (var x) newcomer)))
(rule-rhs R24_2 ((sem-edge (var g) (R24_2_p1 (var e1)) Member (R24_2_sk_apprentice (var x)) apprentice) (sem-edge-tv (var g) (R24_2_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R24_2_p2 (var e1)) Agent (R24_2_sk_apprentice (var x)) (var x)) (sem-edge-tv (var g) (R24_2_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R24_2_p3 (var e1)) Under (R24_2_sk_apprentice (var x)) (R24_2_sk_senior_keeper (var x))) (sem-edge-tv (var g) (R24_2_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R24_2_p4 (var e1)) Member (R24_2_sk_senior_keeper (var x)) senior_keeper) (sem-edge-tv (var g) (R24_2_p4 (var e1)) (STV 1.0 0.9))))

; --- R24.3: New apprentices do not tend a lantern alone.
(sem-rule R24_3)
(rule-context R24_3 aelmere)
(rule-priority R24_3 73)
(rule-tv R24_3 authored 0.0 0.9)
(rule-lhs R24_3 ((sem-edge (var g) (var e1) Member (var x) apprentice) (sem-edge (var g) (var e2) Member (var x) new)))
(rule-rhs R24_3 ((sem-edge (var g) (R24_3_p1 (var e1) (var e2)) And (Member (R24_3_sk_tend (var x)) tend) (Agent (R24_3_sk_tend (var x)) (var x)) (Object (R24_3_sk_tend (var x)) (R24_3_sk_lantern (var x))) (Member (R24_3_sk_lantern (var x)) lantern) (Manner (R24_3_sk_tend (var x)) alone)) (sem-edge-tv (var g) (R24_3_p1 (var e1) (var e2)) (STV 0.0 0.9))))

; --- R25.1: When an apprentice's solo count is large, the Council invests the apprentice as a Keeper.
(sem-rule R25_1)
(rule-context R25_1 aelmere)
(rule-priority R25_1 74)
(rule-tv R25_1 authored 1.0 0.9)
(rule-lhs R25_1 ((sem-edge (var g) (var e1) Member (var x) apprentice) (sem-edge (var g) (var e2) Member (var c) solo_count) (sem-edge (var g) (var e3) Possession (var c) (var x)) (sem-edge (var g) (var e4) Member (var c) large)))
(rule-rhs R25_1 ((sem-edge (var g) (R25_1_p1 (var e1) (var e2) (var e3) (var e4)) Member (R25_1_sk_invest (var x)) invest) (sem-edge-tv (var g) (R25_1_p1 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R25_1_p2 (var e1) (var e2) (var e3) (var e4)) Agent (R25_1_sk_invest (var x)) the_council) (sem-edge-tv (var g) (R25_1_p2 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R25_1_p3 (var e1) (var e2) (var e3) (var e4)) Object (R25_1_sk_invest (var x)) (var x)) (sem-edge-tv (var g) (R25_1_p3 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R25_1_p4 (var e1) (var e2) (var e3) (var e4)) Member (R25_1_sk_keeper (var x)) keeper) (sem-edge-tv (var g) (R25_1_p4 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R25_1_p5 (var e1) (var e2) (var e3) (var e4)) Experiencer (R25_1_sk_keeper (var x)) (var x)) (sem-edge-tv (var g) (R25_1_p5 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R25_1_p6 (var e1) (var e2) (var e3) (var e4)) Member (var x) keeper) (sem-edge-tv (var g) (R25_1_p6 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R25_1_p7 (var e1) (var e2) (var e3) (var e4)) Result (R25_1_sk_invest (var x)) (R25_1_sk_keeper (var x))) (sem-edge-tv (var g) (R25_1_p7 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9))))

; --- R25.2: When a lantern of an apprentice fails, that apprentice's solo count resets.
(sem-rule R25_2)
(rule-context R25_2 aelmere)
(rule-priority R25_2 75)
(rule-tv R25_2 authored 1.0 0.9)
(rule-lhs R25_2 ((sem-edge (var g) (var e1) Member (var e) fail) (sem-edge (var g) (var e2) Object (var e) (var l)) (sem-edge (var g) (var e3) Member (var l) lantern) (sem-edge (var g) (var e4) Possession (var l) (var a)) (sem-edge (var g) (var e5) Member (var a) apprentice)))
(rule-rhs R25_2 ((sem-edge (var g) (R25_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R25_2_sk_solo_count (var a)) solo_count) (sem-edge-tv (var g) (R25_2_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R25_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Possession (R25_2_sk_solo_count (var a)) (var a)) (sem-edge-tv (var g) (R25_2_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R25_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R25_2_sk_reset (var a)) reset) (sem-edge-tv (var g) (R25_2_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R25_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) Object (R25_2_sk_reset (var a)) (R25_2_sk_solo_count (var a))) (sem-edge-tv (var g) (R25_2_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R25_2_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) During (R25_2_sk_reset (var a)) (var e)) (sem-edge-tv (var g) (R25_2_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- R25.3: When an apprentice's lantern dims, that apprentice's solo count resets.
(sem-rule R25_3)
(rule-context R25_3 aelmere)
(rule-priority R25_3 76)
(rule-tv R25_3 authored 1.0 0.9)
(rule-lhs R25_3 ((sem-edge (var g) (var e1) Member (var x) apprentice) (sem-edge (var g) (var e2) Member (var y) lantern) (sem-edge (var g) (var e3) Possession (var y) (var x)) (sem-edge (var g) (var e4) Member (var e) dim) (sem-edge (var g) (var e5) Object (var e) (var y))))
(rule-rhs R25_3 ((sem-edge (var g) (R25_3_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R25_3_sk_reset (var x)) reset) (sem-edge-tv (var g) (R25_3_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R25_3_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (R25_3_sk_solo_count (var x)) solo_count) (sem-edge-tv (var g) (R25_3_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R25_3_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Possession (R25_3_sk_solo_count (var x)) (var x)) (sem-edge-tv (var g) (R25_3_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R25_3_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) Object (R25_3_sk_reset (var x)) (R25_3_sk_solo_count (var x))) (sem-edge-tv (var g) (R25_3_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (R25_3_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) During (R25_3_sk_reset (var x)) (var e)) (sem-edge-tv (var g) (R25_3_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- R26.2: Whenever the moon is full, the Council meets at the Watch.
(sem-rule R26_2)
(rule-context R26_2 aelmere)
(rule-priority R26_2 77)
(rule-tv R26_2 authored 1.0 0.9)
(rule-lhs R26_2 ((sem-edge (var g) (var e1) Member (var x) full) (sem-edge (var g) (var e2) Experiencer (var x) the_moon)))
(rule-rhs R26_2 ((sem-edge (var g) (R26_2_p1 (var e1) (var e2)) Member (R26_2_sk_meet (var x)) meet) (sem-edge-tv (var g) (R26_2_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (R26_2_p2 (var e1) (var e2)) Agent (R26_2_sk_meet (var x)) the_council) (sem-edge-tv (var g) (R26_2_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (R26_2_p3 (var e1) (var e2)) Location (R26_2_sk_meet (var x)) the_watch) (sem-edge-tv (var g) (R26_2_p3 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (R26_2_p4 (var e1) (var e2)) During (R26_2_sk_meet (var x)) (var x)) (sem-edge-tv (var g) (R26_2_p4 (var e1) (var e2)) (STV 1.0 0.9))))

; --- R27.1: When the Council convenes, the Council redistributes mire-essence across the lantern-stations.
(sem-rule R27_1)
(rule-context R27_1 aelmere)
(rule-priority R27_1 78)
(rule-tv R27_1 authored 1.0 0.9)
(rule-lhs R27_1 ((sem-edge (var g) (var e1) Member (var c) convene) (sem-edge (var g) (var e2) Agent (var c) the_council)))
(rule-rhs R27_1 ((sem-edge (var g) (R27_1_p1 (var e1) (var e2)) Member (R27_1_sk_redistribute (var c)) redistribute) (sem-edge-tv (var g) (R27_1_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (R27_1_p2 (var e1) (var e2)) Agent (R27_1_sk_redistribute (var c)) the_council) (sem-edge-tv (var g) (R27_1_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (R27_1_p3 (var e1) (var e2)) Object (R27_1_sk_redistribute (var c)) mire_essence) (sem-edge-tv (var g) (R27_1_p3 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (R27_1_p4 (var e1) (var e2)) Across (R27_1_sk_redistribute (var c)) R27_1_sk_group_1) (sem-edge-tv (var g) (R27_1_p4 (var e1) (var e2)) (STV 1.0 0.9))))

; --- R27.2: Whenever the Council meets, the Council reallocates mire-essence among the lantern-stations.
(sem-rule R27_2)
(rule-context R27_2 aelmere)
(rule-priority R27_2 79)
(rule-tv R27_2 authored 1.0 0.9)
(rule-lhs R27_2 ((sem-edge (var g) (var e1) Member (var e) meet) (sem-edge (var g) (var e2) Agent (var e) the_council)))
(rule-rhs R27_2 ((sem-edge (var g) (R27_2_p1 (var e1) (var e2)) Member (R27_2_sk_reallocate (var e)) reallocate) (sem-edge-tv (var g) (R27_2_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (R27_2_p2 (var e1) (var e2)) Agent (R27_2_sk_reallocate (var e)) the_council) (sem-edge-tv (var g) (R27_2_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (R27_2_p3 (var e1) (var e2)) Object (R27_2_sk_reallocate (var e)) mire_essence) (sem-edge-tv (var g) (R27_2_p3 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (R27_2_p4 (var e1) (var e2)) Among (R27_2_sk_reallocate (var e)) R27_2_sk_stations_1) (sem-edge-tv (var g) (R27_2_p4 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (R27_2_p5 (var e1) (var e2)) During (R27_2_sk_reallocate (var e)) (var e)) (sem-edge-tv (var g) (R27_2_p5 (var e1) (var e2)) (STV 1.0 0.9))))

; --- R27.3: Productive stations contribute mire-essence to a central pool.
(sem-rule R27_3)
(rule-context R27_3 aelmere)
(rule-priority R27_3 80)
(rule-tv R27_3 authored 0.9 0.9)
(rule-lhs R27_3 ((sem-edge (var g) (var e1) Member (var x) station) (sem-edge (var g) (var e2) Member (var x) productive)))
(rule-rhs R27_3 ((sem-edge (var g) (R27_3_p1 (var e1) (var e2)) Member (R27_3_sk_contribute (var x)) contribute) (sem-edge-tv (var g) (R27_3_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (R27_3_p2 (var e1) (var e2)) Agent (R27_3_sk_contribute (var x)) (var x)) (sem-edge-tv (var g) (R27_3_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (R27_3_p3 (var e1) (var e2)) Object (R27_3_sk_contribute (var x)) mire_essence) (sem-edge-tv (var g) (R27_3_p3 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (R27_3_p4 (var e1) (var e2)) Recipient (R27_3_sk_contribute (var x)) the_central_pool) (sem-edge-tv (var g) (R27_3_p4 (var e1) (var e2)) (STV 0.9 0.9))))

; --- R27.4: Burdened stations draw mire-essence from the central pool.
(sem-rule R27_4)
(rule-context R27_4 aelmere)
(rule-priority R27_4 81)
(rule-tv R27_4 authored 0.9 0.9)
(rule-lhs R27_4 ((sem-edge (var g) (var e1) Member (var x) station) (sem-edge (var g) (var e2) Member (var x) burdened)))
(rule-rhs R27_4 ((sem-edge (var g) (R27_4_p1 (var e1) (var e2)) Member (R27_4_sk_draw (var x)) draw) (sem-edge-tv (var g) (R27_4_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (R27_4_p2 (var e1) (var e2)) Agent (R27_4_sk_draw (var x)) (var x)) (sem-edge-tv (var g) (R27_4_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (R27_4_p3 (var e1) (var e2)) Object (R27_4_sk_draw (var x)) mire_essence) (sem-edge-tv (var g) (R27_4_p3 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (R27_4_p4 (var e1) (var e2)) Source (R27_4_sk_draw (var x)) R27_4_sk_pool_1) (sem-edge-tv (var g) (R27_4_p4 (var e1) (var e2)) (STV 0.9 0.9))))

; --- R28.1: Sky-cats hunt often through summer.
(sem-rule R28_1)
(rule-context R28_1 aelmere)
(rule-priority R28_1 82)
(rule-tv R28_1 authored 0.8 0.9)
(rule-lhs R28_1 ((sem-edge (var g) (var e1) Member (var x) sky_cat)))
(rule-rhs R28_1 ((sem-edge (var g) (R28_1_p1 (var e1)) Member (R28_1_sk_hunt (var x)) hunt) (sem-edge-tv (var g) (R28_1_p1 (var e1)) (STV 0.8 0.9)) (sem-edge (var g) (R28_1_p2 (var e1)) Agent (R28_1_sk_hunt (var x)) (var x)) (sem-edge-tv (var g) (R28_1_p2 (var e1)) (STV 0.8 0.9)) (sem-edge (var g) (R28_1_p3 (var e1)) Time (R28_1_sk_hunt (var x)) summer) (sem-edge-tv (var g) (R28_1_p3 (var e1)) (STV 0.8 0.9))))

; --- R28.2: Whenever a sky-cat hunts through summer, many feathers accumulate at the base of the cliff by autumn.
(sem-rule R28_2)
(rule-context R28_2 aelmere)
(rule-priority R28_2 83)
(rule-tv R28_2 authored 1.0 0.9)
(rule-lhs R28_2 ((sem-edge (var g) (var e1) Member (var c) sky_cat) (sem-edge (var g) (var e2) Member (var h) hunt) (sem-edge (var g) (var e3) Agent (var h) (var c)) (sem-edge (var g) (var e4) Time (var h) summer)))
(rule-rhs R28_2 ((sem-edge (var g) (R28_2_p1 (var e1) (var e2) (var e3) (var e4)) GroupOf (R28_2_sk_feathers (var h)) feather) (sem-edge-tv (var g) (R28_2_p1 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R28_2_p2 (var e1) (var e2) (var e3) (var e4)) CardinalityPhrase (R28_2_sk_feathers (var h)) "many") (sem-edge-tv (var g) (R28_2_p2 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R28_2_p3 (var e1) (var e2) (var e3) (var e4)) Member (R28_2_sk_accumulate (var h)) accumulate) (sem-edge-tv (var g) (R28_2_p3 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R28_2_p4 (var e1) (var e2) (var e3) (var e4)) Object (R28_2_sk_accumulate (var h)) (R28_2_sk_feathers (var h))) (sem-edge-tv (var g) (R28_2_p4 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R28_2_p5 (var e1) (var e2) (var e3) (var e4)) Location (R28_2_sk_accumulate (var h)) R28_2_sk_base_1) (sem-edge-tv (var g) (R28_2_p5 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R28_2_p6 (var e1) (var e2) (var e3) (var e4)) During (R28_2_sk_accumulate (var h)) (var h)) (sem-edge-tv (var g) (R28_2_p6 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R28_2_p7 (var e1) (var e2) (var e3) (var e4)) TimeAtMost (R28_2_sk_accumulate (var h)) autumn) (sem-edge-tv (var g) (R28_2_p7 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9))))

; --- R28.3: Whenever a sky-cat hunts in summer, the autumn feather store grows.
(sem-rule R28_3)
(rule-context R28_3 aelmere)
(rule-priority R28_3 84)
(rule-tv R28_3 authored 1.0 0.9)
(rule-lhs R28_3 ((sem-edge (var g) (var e1) Member (var c) sky_cat) (sem-edge (var g) (var e2) Member (var h) hunt) (sem-edge (var g) (var e3) Agent (var h) (var c)) (sem-edge (var g) (var e4) Time (var h) summer)))
(rule-rhs R28_3 ((sem-edge (var g) (R28_3_p1 (var e1) (var e2) (var e3) (var e4)) Member (R28_3_sk_grow (var h)) grow) (sem-edge-tv (var g) (R28_3_p1 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R28_3_p2 (var e1) (var e2) (var e3) (var e4)) Object (R28_3_sk_grow (var h)) R28_3_sk_store_1) (sem-edge-tv (var g) (R28_3_p2 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R28_3_p3 (var e1) (var e2) (var e3) (var e4)) During (R28_3_sk_grow (var h)) (var h)) (sem-edge-tv (var g) (R28_3_p3 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9))))

; --- R29.1: When the feather store at the Watch is large, each Keeper tends the Sunken Cove lanterns safely in winter.
(sem-rule R29_1)
(rule-context R29_1 aelmere)
(rule-priority R29_1 85)
(rule-tv R29_1 authored 1.0 0.9)
(rule-lhs R29_1 ((sem-edge (var g) (var e1) Member the_feather_store large) (sem-edge (var g) (var e2) Member (var x) keeper)))
(rule-rhs R29_1 ((sem-edge (var g) (R29_1_p1 (var e1) (var e2)) Member (R29_1_sk_tend (var x)) tend) (sem-edge-tv (var g) (R29_1_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (R29_1_p2 (var e1) (var e2)) Agent (R29_1_sk_tend (var x)) (var x)) (sem-edge-tv (var g) (R29_1_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (R29_1_p3 (var e1) (var e2)) Object (R29_1_sk_tend (var x)) R29_1_sk_lanterns_1) (sem-edge-tv (var g) (R29_1_p3 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (R29_1_p4 (var e1) (var e2)) Manner (R29_1_sk_tend (var x)) safely) (sem-edge-tv (var g) (R29_1_p4 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (R29_1_p5 (var e1) (var e2)) Time (R29_1_sk_tend (var x)) winter) (sem-edge-tv (var g) (R29_1_p5 (var e1) (var e2)) (STV 1.0 0.9))))

; --- R29.3: When the feather store is small, wraith risk grows.
(sem-rule R29_3)
(rule-context R29_3 aelmere)
(rule-priority R29_3 86)
(rule-tv R29_3 authored 1.0 0.9)
(rule-lhs R29_3 ((sem-edge (var g) (var e1) Member the_feather_store small)))
(rule-rhs R29_3 ((sem-edge (var g) (R29_3_p1 (var e1)) Member R29_3_sk_grow_1 grow) (sem-edge-tv (var g) (R29_3_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (R29_3_p2 (var e1)) Object R29_3_sk_grow_1 wraith_risk) (sem-edge-tv (var g) (R29_3_p2 (var e1)) (STV 1.0 0.9))))

; --- R30.1: Whenever a wraith drains a lantern at the Sunken Cove, a station near the Sunken Cove requests feather rations from the Council.
(sem-rule R30_1)
(rule-context R30_1 aelmere)
(rule-priority R30_1 87)
(rule-tv R30_1 authored 1.0 0.9)
(rule-lhs R30_1 ((sem-edge (var g) (var e1) Member (var x) wraith) (sem-edge (var g) (var e2) Member (var d) drain) (sem-edge (var g) (var e3) Agent (var d) (var x)) (sem-edge (var g) (var e4) Member (var l) lantern) (sem-edge (var g) (var e5) Object (var d) (var l)) (sem-edge (var g) (var e6) AttachedTo (var l) sunken_cove)))
(rule-rhs R30_1 ((sem-edge (var g) (R30_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (R30_1_sk_request (var d)) request) (sem-edge-tv (var g) (R30_1_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R30_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Agent (R30_1_sk_request (var d)) R30_1_sk_station_1) (sem-edge-tv (var g) (R30_1_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R30_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Object (R30_1_sk_request (var d)) feather_ration) (sem-edge-tv (var g) (R30_1_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R30_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Source (R30_1_sk_request (var d)) the_council) (sem-edge-tv (var g) (R30_1_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R30_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) During (R30_1_sk_request (var d)) (var d)) (sem-edge-tv (var g) (R30_1_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9))))

; --- R30.2: Whenever wraith sightings at the Sunken Cove rise, the stations ask the Council for feather rations.
(sem-rule R30_2)
(rule-context R30_2 aelmere)
(rule-priority R30_2 88)
(rule-tv R30_2 authored 1.0 0.9)
(rule-lhs R30_2 ((sem-edge (var g) (var e1) Member (var e) rise) (sem-edge (var g) (var e2) Object (var e) wraith_sighting) (sem-edge (var g) (var e3) Location (var e) sunken_cove) (sem-edge (var g) (var e4) AttachedTo (var s) R30_2_sk_stations_1)))
(rule-rhs R30_2 ((sem-edge (var g) (R30_2_p1 (var e1) (var e2) (var e3) (var e4)) Member (R30_2_sk_ask (var s) (var e)) ask) (sem-edge-tv (var g) (R30_2_p1 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R30_2_p2 (var e1) (var e2) (var e3) (var e4)) Agent (R30_2_sk_ask (var s) (var e)) (var s)) (sem-edge-tv (var g) (R30_2_p2 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R30_2_p3 (var e1) (var e2) (var e3) (var e4)) Recipient (R30_2_sk_ask (var s) (var e)) the_council) (sem-edge-tv (var g) (R30_2_p3 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R30_2_p4 (var e1) (var e2) (var e3) (var e4)) Object (R30_2_sk_ask (var s) (var e)) feather_ration) (sem-edge-tv (var g) (R30_2_p4 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (R30_2_p5 (var e1) (var e2) (var e3) (var e4)) During (R30_2_sk_ask (var s) (var e)) (var e)) (sem-edge-tv (var g) (R30_2_p5 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9))))

; --- R30.4: When a station reports a drained lantern, the Council prioritizes that station.
(sem-rule R30_4)
(rule-context R30_4 aelmere)
(rule-priority R30_4 89)
(rule-tv R30_4 authored 1.0 0.9)
(rule-lhs R30_4 ((sem-edge (var g) (var e1) Member (var e) report) (sem-edge (var g) (var e2) Agent (var e) (var s)) (sem-edge (var g) (var e3) Member (var s) station) (sem-edge (var g) (var e4) Object (var e) (var l)) (sem-edge (var g) (var e5) Member (var l) lantern) (sem-edge (var g) (var e6) Member (var l) drained)))
(rule-rhs R30_4 ((sem-edge (var g) (R30_4_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (R30_4_sk_prioritize (var e)) prioritize) (sem-edge-tv (var g) (R30_4_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R30_4_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Agent (R30_4_sk_prioritize (var e)) the_council) (sem-edge-tv (var g) (R30_4_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R30_4_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Object (R30_4_sk_prioritize (var e)) (var s)) (sem-edge-tv (var g) (R30_4_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (R30_4_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) During (R30_4_sk_prioritize (var e)) (var e)) (sem-edge-tv (var g) (R30_4_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9))))

; --- L1-02.5: Each Keeper walks the Cliff Path every night.
(sem-rule L1-02_5_keeper_walk_rule)
(rule-context L1-02_5_keeper_walk_rule aelmere-lore)
(rule-priority L1-02_5_keeper_walk_rule 90)
(rule-tv L1-02_5_keeper_walk_rule authored 1.0 0.9)
(rule-lhs L1-02_5_keeper_walk_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L1-02_5_keeper_walk_rule ((sem-edge (var g) (L1-02_5_keeper_walk_rule_p1 (var e1)) Member (L1-02_5_sk_walk (var x)) walk) (sem-edge-tv (var g) (L1-02_5_keeper_walk_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L1-02_5_keeper_walk_rule_p2 (var e1)) Agent (L1-02_5_sk_walk (var x)) (var x)) (sem-edge-tv (var g) (L1-02_5_keeper_walk_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L1-02_5_keeper_walk_rule_p3 (var e1)) Object (L1-02_5_sk_walk (var x)) cliff_path) (sem-edge-tv (var g) (L1-02_5_keeper_walk_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L1-02_5_keeper_walk_rule_p4 (var e1)) Time (L1-02_5_sk_walk (var x)) night) (sem-edge-tv (var g) (L1-02_5_keeper_walk_rule_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L1-02_5_keeper_walk_rule_p5 (var e1)) Every (L1-02_5_sk_walk (var x)) 1 day) (sem-edge-tv (var g) (L1-02_5_keeper_walk_rule_p5 (var e1)) (STV 1.0 0.9))))

; --- L1-03.4: Whenever wind reflects off harbor water at a harbor lantern, that lantern burns its mire-essence quickly.
(sem-rule L1-03_4_whenever_reflect_burn)
(rule-context L1-03_4_whenever_reflect_burn aelmere-lore)
(rule-priority L1-03_4_whenever_reflect_burn 91)
(rule-tv L1-03_4_whenever_reflect_burn authored 1.0 0.9)
(rule-lhs L1-03_4_whenever_reflect_burn ((sem-edge (var g) (var e1) Member (var e) reflect) (sem-edge (var g) (var e2) Object (var e) (var t1)) (sem-edge (var g) (var e3) Member (var t1) wind) (sem-edge (var g) (var e4) Source (var e) (var t2)) (sem-edge (var g) (var e5) Member (var t2) harbor_water) (sem-edge (var g) (var e6) Location (var e) (var y)) (sem-edge (var g) (var e7) Member (var y) harbor_lantern)))
(rule-rhs L1-03_4_whenever_reflect_burn ((sem-edge (var g) (L1-03_4_whenever_reflect_burn_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Member (L1-03_4_sk_burn (var e)) burn) (sem-edge-tv (var g) (L1-03_4_whenever_reflect_burn_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (L1-03_4_whenever_reflect_burn_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Agent (L1-03_4_sk_burn (var e)) (var y)) (sem-edge-tv (var g) (L1-03_4_whenever_reflect_burn_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (L1-03_4_whenever_reflect_burn_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Object (L1-03_4_sk_burn (var e)) (L1-03_4_sk_mire_essence (var y))) (sem-edge-tv (var g) (L1-03_4_whenever_reflect_burn_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (L1-03_4_whenever_reflect_burn_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Member (L1-03_4_sk_mire_essence (var y)) mire_essence) (sem-edge-tv (var g) (L1-03_4_whenever_reflect_burn_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (L1-03_4_whenever_reflect_burn_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Possession (L1-03_4_sk_mire_essence (var y)) (var y)) (sem-edge-tv (var g) (L1-03_4_whenever_reflect_burn_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (L1-03_4_whenever_reflect_burn_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Manner (L1-03_4_sk_burn (var e)) quickly) (sem-edge-tv (var g) (L1-03_4_whenever_reflect_burn_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (L1-03_4_whenever_reflect_burn_p7 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) During (L1-03_4_sk_burn (var e)) (var e)) (sem-edge-tv (var g) (L1-03_4_whenever_reflect_burn_p7 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9))))

; --- L1-03.5: Harbor-lantern Keepers live near the harbor.
(sem-rule L1-03_5_hlk_live_rule)
(rule-context L1-03_5_hlk_live_rule aelmere-lore)
(rule-priority L1-03_5_hlk_live_rule 92)
(rule-tv L1-03_5_hlk_live_rule authored 0.9 0.9)
(rule-lhs L1-03_5_hlk_live_rule ((sem-edge (var g) (var e1) Member (var x) harbor_lantern_keeper)))
(rule-rhs L1-03_5_hlk_live_rule ((sem-edge (var g) (L1-03_5_hlk_live_rule_p1 (var e1)) Member (L1-03_5_sk_live (var x)) live) (sem-edge-tv (var g) (L1-03_5_hlk_live_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L1-03_5_hlk_live_rule_p2 (var e1)) Agent (L1-03_5_sk_live (var x)) (var x)) (sem-edge-tv (var g) (L1-03_5_hlk_live_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L1-03_5_hlk_live_rule_p3 (var e1)) Near (L1-03_5_sk_live (var x)) L1-03_5_sk_harbor_1) (sem-edge-tv (var g) (L1-03_5_hlk_live_rule_p3 (var e1)) (STV 0.9 0.9))))

; --- L1-04.7: When the tide is low, the grave markers are visible below the surface.
(sem-rule L1-04_7_t1_rule)
(rule-context L1-04_7_t1_rule aelmere-lore)
(rule-priority L1-04_7_t1_rule 93)
(rule-tv L1-04_7_t1_rule authored 1.0 0.9)
(rule-lhs L1-04_7_t1_rule ((sem-edge (var g) (var e1) Member (var s) low) (sem-edge (var g) (var e2) Experiencer (var s) L1-04_7_sk_tide_1) (sem-edge (var g) (var e3) PartOf (var x) L1-04_7_sk_group_1)))
(rule-rhs L1-04_7_t1_rule ((sem-edge (var g) (L1-04_7_t1_rule_p1 (var e1) (var e2) (var e3)) Member (L1-04_7_sk_visible (var s) (var x)) visible) (sem-edge-tv (var g) (L1-04_7_t1_rule_p1 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L1-04_7_t1_rule_p2 (var e1) (var e2) (var e3)) Experiencer (L1-04_7_sk_visible (var s) (var x)) (var x)) (sem-edge-tv (var g) (L1-04_7_t1_rule_p2 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L1-04_7_t1_rule_p3 (var e1) (var e2) (var e3)) During (L1-04_7_sk_visible (var s) (var x)) (var s)) (sem-edge-tv (var g) (L1-04_7_t1_rule_p3 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L1-04_7_t1_rule_p4 (var e1) (var e2) (var e3)) Below (L1-04_7_sk_visible (var s) (var x)) L1-04_7_sk_surface_1) (sem-edge-tv (var g) (L1-04_7_t1_rule_p4 (var e1) (var e2) (var e3)) (STV 1.0 0.9))))

; --- L1-05.11: Every Keeper fears the Stilllight Station.
(sem-rule L1-05_11_keeper_fear_rule)
(rule-context L1-05_11_keeper_fear_rule aelmere-lore)
(rule-priority L1-05_11_keeper_fear_rule 94)
(rule-tv L1-05_11_keeper_fear_rule authored 1.0 0.9)
(rule-lhs L1-05_11_keeper_fear_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L1-05_11_keeper_fear_rule ((sem-edge (var g) (L1-05_11_keeper_fear_rule_p1 (var e1)) Member (L1-05_11_sk_fear (var x)) fear) (sem-edge-tv (var g) (L1-05_11_keeper_fear_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L1-05_11_keeper_fear_rule_p2 (var e1)) Experiencer (L1-05_11_sk_fear (var x)) (var x)) (sem-edge-tv (var g) (L1-05_11_keeper_fear_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L1-05_11_keeper_fear_rule_p3 (var e1)) Stimulus (L1-05_11_sk_fear (var x)) stilllight_station) (sem-edge-tv (var g) (L1-05_11_keeper_fear_rule_p3 (var e1)) (STV 1.0 0.9))))

; --- L1-06.6: Whenever a spring tide comes, the tide-pools fill and overflow.
(sem-rule L1-06_6_whenever_fill)
(rule-context L1-06_6_whenever_fill aelmere-lore)
(rule-priority L1-06_6_whenever_fill 95)
(rule-tv L1-06_6_whenever_fill authored 1.0 0.9)
(rule-lhs L1-06_6_whenever_fill ((sem-edge (var g) (var e1) Member (var t) spring_tide) (sem-edge (var g) (var e2) Member (var x) come) (sem-edge (var g) (var e3) Object (var x) (var t))))
(rule-rhs L1-06_6_whenever_fill ((sem-edge (var g) (L1-06_6_whenever_fill_p1 (var e1) (var e2) (var e3)) Member (L1-06_6_sk_fill (var x)) fill) (sem-edge-tv (var g) (L1-06_6_whenever_fill_p1 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L1-06_6_whenever_fill_p2 (var e1) (var e2) (var e3)) Object (L1-06_6_sk_fill (var x)) salt_bloom_tide_pools) (sem-edge-tv (var g) (L1-06_6_whenever_fill_p2 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L1-06_6_whenever_fill_p3 (var e1) (var e2) (var e3)) During (L1-06_6_sk_fill (var x)) (var x)) (sem-edge-tv (var g) (L1-06_6_whenever_fill_p3 (var e1) (var e2) (var e3)) (STV 1.0 0.9))))

; --- L1-06.6: Whenever a spring tide comes, the tide-pools fill and overflow.
(sem-rule L1-06_6_whenever_overflow)
(rule-context L1-06_6_whenever_overflow aelmere-lore)
(rule-priority L1-06_6_whenever_overflow 96)
(rule-tv L1-06_6_whenever_overflow authored 1.0 0.9)
(rule-lhs L1-06_6_whenever_overflow ((sem-edge (var g) (var e1) Member (var t) spring_tide) (sem-edge (var g) (var e2) Member (var x) come) (sem-edge (var g) (var e3) Object (var x) (var t))))
(rule-rhs L1-06_6_whenever_overflow ((sem-edge (var g) (L1-06_6_whenever_overflow_p1 (var e1) (var e2) (var e3)) Member (L1-06_6_sk_overflow (var x)) overflow) (sem-edge-tv (var g) (L1-06_6_whenever_overflow_p1 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L1-06_6_whenever_overflow_p2 (var e1) (var e2) (var e3)) Object (L1-06_6_sk_overflow (var x)) salt_bloom_tide_pools) (sem-edge-tv (var g) (L1-06_6_whenever_overflow_p2 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L1-06_6_whenever_overflow_p3 (var e1) (var e2) (var e3)) During (L1-06_6_sk_overflow (var x)) (var x)) (sem-edge-tv (var g) (L1-06_6_whenever_overflow_p3 (var e1) (var e2) (var e3)) (STV 1.0 0.9))))

; --- L1-06.7: Keepers visit the tide-pools at harvest time.
(sem-rule L1-06_7_keeper_visit_rule)
(rule-context L1-06_7_keeper_visit_rule aelmere-lore)
(rule-priority L1-06_7_keeper_visit_rule 97)
(rule-tv L1-06_7_keeper_visit_rule authored 0.9 0.9)
(rule-lhs L1-06_7_keeper_visit_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L1-06_7_keeper_visit_rule ((sem-edge (var g) (L1-06_7_keeper_visit_rule_p1 (var e1)) Member (L1-06_7_sk_visit (var x)) visit) (sem-edge-tv (var g) (L1-06_7_keeper_visit_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L1-06_7_keeper_visit_rule_p2 (var e1)) Agent (L1-06_7_sk_visit (var x)) (var x)) (sem-edge-tv (var g) (L1-06_7_keeper_visit_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L1-06_7_keeper_visit_rule_p3 (var e1)) Object (L1-06_7_sk_visit (var x)) salt_bloom_tide_pools) (sem-edge-tv (var g) (L1-06_7_keeper_visit_rule_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L1-06_7_keeper_visit_rule_p4 (var e1)) Time (L1-06_7_sk_visit (var x)) harvest_time) (sem-edge-tv (var g) (L1-06_7_keeper_visit_rule_p4 (var e1)) (STV 0.9 0.9))))

; --- L1-07.5: Each cauldron sits on a stone hearth.
(sem-rule L1-07_5_cauldron_on_hearth)
(rule-context L1-07_5_cauldron_on_hearth aelmere-lore)
(rule-priority L1-07_5_cauldron_on_hearth 98)
(rule-tv L1-07_5_cauldron_on_hearth authored 1.0 0.9)
(rule-lhs L1-07_5_cauldron_on_hearth ((sem-edge (var g) (var e1) Member (var x) cauldron)))
(rule-rhs L1-07_5_cauldron_on_hearth ((sem-edge (var g) (L1-07_5_cauldron_on_hearth_p1 (var e1)) On (var x) (L1-07_5_sk_hearth (var x))) (sem-edge-tv (var g) (L1-07_5_cauldron_on_hearth_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L1-07_5_cauldron_on_hearth_p2 (var e1)) Member (L1-07_5_sk_hearth (var x)) stone_hearth) (sem-edge-tv (var g) (L1-07_5_cauldron_on_hearth_p2 (var e1)) (STV 1.0 0.9))))

; --- L1-09.7: Keepers keep the lanterns at the Hollows dim.
(sem-rule L1-09_7_lp5_keeper_rule)
(rule-context L1-09_7_lp5_keeper_rule aelmere-lore)
(rule-priority L1-09_7_lp5_keeper_rule 99)
(rule-tv L1-09_7_lp5_keeper_rule authored 0.9 0.9)
(rule-lhs L1-09_7_lp5_keeper_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L1-09_7_lp5_keeper_rule ((sem-edge (var g) (L1-09_7_lp5_keeper_rule_p1 (var e1)) Member (L1-09_7_sk_keep (var x)) keep) (sem-edge-tv (var g) (L1-09_7_lp5_keeper_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L1-09_7_lp5_keeper_rule_p2 (var e1)) Agent (L1-09_7_sk_keep (var x)) (var x)) (sem-edge-tv (var g) (L1-09_7_lp5_keeper_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L1-09_7_lp5_keeper_rule_p3 (var e1)) Object (L1-09_7_sk_keep (var x)) L1-09_7_sk_lantern_1) (sem-edge-tv (var g) (L1-09_7_lp5_keeper_rule_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L1-09_7_lp5_keeper_rule_p4 (var e1)) Result (L1-09_7_sk_keep (var x)) L1-09_7_sk_dim_1) (sem-edge-tv (var g) (L1-09_7_lp5_keeper_rule_p4 (var e1)) (STV 0.9 0.9))))

; --- L1-09.8: Whenever a nightmoth flees the Cliff Path, the nightmoth goes to a dim lantern in the Hollows.
(sem-rule L1-09_8_e2_rule)
(rule-context L1-09_8_e2_rule aelmere-lore)
(rule-priority L1-09_8_e2_rule 100)
(rule-tv L1-09_8_e2_rule authored 1.0 0.9)
(rule-lhs L1-09_8_e2_rule ((sem-edge (var g) (var e1) Member (var m) nightmoth) (sem-edge (var g) (var e2) Member (var e) flee) (sem-edge (var g) (var e3) Agent (var e) (var m)) (sem-edge (var g) (var e4) Object (var e) cliff_path)))
(rule-rhs L1-09_8_e2_rule ((sem-edge (var g) (L1-09_8_e2_rule_p1 (var e1) (var e2) (var e3) (var e4)) Member (L1-09_8_sk_go (var e)) go) (sem-edge-tv (var g) (L1-09_8_e2_rule_p1 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L1-09_8_e2_rule_p2 (var e1) (var e2) (var e3) (var e4)) Agent (L1-09_8_sk_go (var e)) (var m)) (sem-edge-tv (var g) (L1-09_8_e2_rule_p2 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L1-09_8_e2_rule_p3 (var e1) (var e2) (var e3) (var e4)) Goal (L1-09_8_sk_go (var e)) (L1-09_8_sk_lantern (var e))) (sem-edge-tv (var g) (L1-09_8_e2_rule_p3 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L1-09_8_e2_rule_p4 (var e1) (var e2) (var e3) (var e4)) Member (L1-09_8_sk_lantern (var e)) lantern) (sem-edge-tv (var g) (L1-09_8_e2_rule_p4 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L1-09_8_e2_rule_p5 (var e1) (var e2) (var e3) (var e4)) Member (L1-09_8_sk_lantern (var e)) dim) (sem-edge-tv (var g) (L1-09_8_e2_rule_p5 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L1-09_8_e2_rule_p6 (var e1) (var e2) (var e3) (var e4)) LocatedIn (L1-09_8_sk_lantern (var e)) hollows) (sem-edge-tv (var g) (L1-09_8_e2_rule_p6 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L1-09_8_e2_rule_p7 (var e1) (var e2) (var e3) (var e4)) During (L1-09_8_sk_go (var e)) (var e)) (sem-edge-tv (var g) (L1-09_8_e2_rule_p7 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9))))

; --- L1-10.7: Northcove lanterns burn through winter.
(sem-rule L1-10_7_l78_lantern_burn_rule)
(rule-context L1-10_7_l78_lantern_burn_rule aelmere-lore)
(rule-priority L1-10_7_l78_lantern_burn_rule 101)
(rule-tv L1-10_7_l78_lantern_burn_rule authored 0.9 0.9)
(rule-lhs L1-10_7_l78_lantern_burn_rule ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) AttachedTo (var x) northcove)))
(rule-rhs L1-10_7_l78_lantern_burn_rule ((sem-edge (var g) (L1-10_7_l78_lantern_burn_rule_p1 (var e1) (var e2)) Member (L1-10_7_sk_burn (var x)) burn) (sem-edge-tv (var g) (L1-10_7_l78_lantern_burn_rule_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L1-10_7_l78_lantern_burn_rule_p2 (var e1) (var e2)) Object (L1-10_7_sk_burn (var x)) (var x)) (sem-edge-tv (var g) (L1-10_7_l78_lantern_burn_rule_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L1-10_7_l78_lantern_burn_rule_p3 (var e1) (var e2)) Time (L1-10_7_sk_burn (var x)) winter) (sem-edge-tv (var g) (L1-10_7_l78_lantern_burn_rule_p3 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L1-10.8: Northcove lanterns need no salt-bloom.
(sem-rule L1-10_8_lantern_no_saltbloom)
(rule-context L1-10_8_lantern_no_saltbloom aelmere-lore)
(rule-priority L1-10_8_lantern_no_saltbloom 102)
(rule-tv L1-10_8_lantern_no_saltbloom authored 0.0 0.9)
(rule-lhs L1-10_8_lantern_no_saltbloom ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) AttachedTo (var x) northcove)))
(rule-rhs L1-10_8_lantern_no_saltbloom ((sem-edge (var g) (L1-10_8_lantern_no_saltbloom_p1 (var e1) (var e2)) And (Member (L1-10_8_sk_need (var x)) need) (Experiencer (L1-10_8_sk_need (var x)) (var x)) (Stimulus (L1-10_8_sk_need (var x)) salt_bloom)) (sem-edge-tv (var g) (L1-10_8_lantern_no_saltbloom_p1 (var e1) (var e2)) (STV 0.0 0.9))))

; --- L1-10.9: Northcove lanterns never go out in winter.
(sem-rule L1-10_9_e3_rule)
(rule-context L1-10_9_e3_rule aelmere-lore)
(rule-priority L1-10_9_e3_rule 103)
(rule-tv L1-10_9_e3_rule authored 0.0 0.9)
(rule-lhs L1-10_9_e3_rule ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) AttachedTo (var x) northcove)))
(rule-rhs L1-10_9_e3_rule ((sem-edge (var g) (L1-10_9_e3_rule_p1 (var e1) (var e2)) And (Member (L1-10_9_sk_go_out (var x)) go_out) (Object (L1-10_9_sk_go_out (var x)) (var x)) (Time (L1-10_9_sk_go_out (var x)) winter)) (sem-edge-tv (var g) (L1-10_9_e3_rule_p1 (var e1) (var e2)) (STV 0.0 0.9))))

; --- L1-11.7: When sky-cats sit on the cliff-spires in the morning, the day stays calm.
(sem-rule L1-11_7_whenever_sit_calm)
(rule-context L1-11_7_whenever_sit_calm aelmere-lore)
(rule-priority L1-11_7_whenever_sit_calm 104)
(rule-tv L1-11_7_whenever_sit_calm authored 0.9 0.9)
(rule-lhs L1-11_7_whenever_sit_calm ((sem-edge (var g) (var e1) Member (var x) sky_cat) (sem-edge (var g) (var e2) Member (var e) sit) (sem-edge (var g) (var e3) Experiencer (var e) (var x)) (sem-edge (var g) (var e4) Location (var e) L1-11_7_sk_cliff_spire_1) (sem-edge (var g) (var e5) Time (var e) morning)))
(rule-rhs L1-11_7_whenever_sit_calm ((sem-edge (var g) (L1-11_7_whenever_sit_calm_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (L1-11_7_sk_calm (var e)) calm) (sem-edge-tv (var g) (L1-11_7_whenever_sit_calm_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 0.9 0.9)) (sem-edge (var g) (L1-11_7_whenever_sit_calm_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (L1-11_7_sk_day (var e)) day) (sem-edge-tv (var g) (L1-11_7_whenever_sit_calm_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 0.9 0.9)) (sem-edge (var g) (L1-11_7_whenever_sit_calm_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Experiencer (L1-11_7_sk_calm (var e)) (L1-11_7_sk_day (var e))) (sem-edge-tv (var g) (L1-11_7_whenever_sit_calm_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 0.9 0.9)) (sem-edge (var g) (L1-11_7_whenever_sit_calm_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) Still (L1-11_7_sk_calm (var e))) (sem-edge-tv (var g) (L1-11_7_whenever_sit_calm_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 0.9 0.9)) (sem-edge (var g) (L1-11_7_whenever_sit_calm_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (L1-11_7_sk_day (var e)) calm) (sem-edge-tv (var g) (L1-11_7_whenever_sit_calm_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 0.9 0.9)) (sem-edge (var g) (L1-11_7_whenever_sit_calm_p6 (var e1) (var e2) (var e3) (var e4) (var e5)) During (L1-11_7_sk_calm (var e)) (var e)) (sem-edge-tv (var g) (L1-11_7_whenever_sit_calm_p6 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 0.9 0.9))))

; --- L1-13.3: Boats from down the coast bring grain, salt, cloth, and ironmongery to the market.
(sem-rule L1-13_3_boats_bring_rule)
(rule-context L1-13_3_boats_bring_rule aelmere-lore)
(rule-priority L1-13_3_boats_bring_rule 105)
(rule-tv L1-13_3_boats_bring_rule authored 0.9 0.9)
(rule-lhs L1-13_3_boats_bring_rule ((sem-edge (var g) (var e1) Member (var x) boat) (sem-edge (var g) (var e2) From (var x) the_coast)))
(rule-rhs L1-13_3_boats_bring_rule ((sem-edge (var g) (L1-13_3_boats_bring_rule_p1 (var e1) (var e2)) Member (L1-13_3_sk_bring (var x)) bring) (sem-edge-tv (var g) (L1-13_3_boats_bring_rule_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L1-13_3_boats_bring_rule_p2 (var e1) (var e2)) Agent (L1-13_3_sk_bring (var x)) (var x)) (sem-edge-tv (var g) (L1-13_3_boats_bring_rule_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L1-13_3_boats_bring_rule_p3 (var e1) (var e2)) Object (L1-13_3_sk_bring (var x)) grain) (sem-edge-tv (var g) (L1-13_3_boats_bring_rule_p3 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L1-13_3_boats_bring_rule_p4 (var e1) (var e2)) Object (L1-13_3_sk_bring (var x)) salt) (sem-edge-tv (var g) (L1-13_3_boats_bring_rule_p4 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L1-13_3_boats_bring_rule_p5 (var e1) (var e2)) Object (L1-13_3_sk_bring (var x)) cloth) (sem-edge-tv (var g) (L1-13_3_boats_bring_rule_p5 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L1-13_3_boats_bring_rule_p6 (var e1) (var e2)) Object (L1-13_3_sk_bring (var x)) ironmongery) (sem-edge-tv (var g) (L1-13_3_boats_bring_rule_p6 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L1-13_3_boats_bring_rule_p7 (var e1) (var e2)) Goal (L1-13_3_sk_bring (var x)) L1-13_3_sk_market_1) (sem-edge-tv (var g) (L1-13_3_boats_bring_rule_p7 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L1-13.5: Imported salt does not yield mire-essence.
(sem-rule L1-13_5_imported_salt_no_yield)
(rule-context L1-13_5_imported_salt_no_yield aelmere-lore)
(rule-priority L1-13_5_imported_salt_no_yield 106)
(rule-tv L1-13_5_imported_salt_no_yield authored 0.0 0.9)
(rule-lhs L1-13_5_imported_salt_no_yield ((sem-edge (var g) (var e1) Member (var x) salt) (sem-edge (var g) (var e2) Member (var x) imported)))
(rule-rhs L1-13_5_imported_salt_no_yield ((sem-edge (var g) (L1-13_5_imported_salt_no_yield_p1 (var e1) (var e2)) And (Member (L1-13_5_sk_yield (var x)) yield) (Agent (L1-13_5_sk_yield (var x)) (var x)) (Object (L1-13_5_sk_yield (var x)) mire_essence)) (sem-edge-tv (var g) (L1-13_5_imported_salt_no_yield_p1 (var e1) (var e2)) (STV 0.0 0.9))))

; --- L1-13.6: Every distillation requires sea-water from the Salt-bloom Tide-pools.
(sem-rule L1-13_6_distillation_require_rule)
(rule-context L1-13_6_distillation_require_rule aelmere-lore)
(rule-priority L1-13_6_distillation_require_rule 107)
(rule-tv L1-13_6_distillation_require_rule authored 1.0 0.9)
(rule-lhs L1-13_6_distillation_require_rule ((sem-edge (var g) (var e1) Member (var x) distillation)))
(rule-rhs L1-13_6_distillation_require_rule ((sem-edge (var g) (L1-13_6_distillation_require_rule_p1 (var e1)) Member (L1-13_6_sk_require (var x)) require) (sem-edge-tv (var g) (L1-13_6_distillation_require_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L1-13_6_distillation_require_rule_p2 (var e1)) Agent (L1-13_6_sk_require (var x)) (var x)) (sem-edge-tv (var g) (L1-13_6_distillation_require_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L1-13_6_distillation_require_rule_p3 (var e1)) Object (L1-13_6_sk_require (var x)) (L1-13_6_sk_sea_water (var x))) (sem-edge-tv (var g) (L1-13_6_distillation_require_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L1-13_6_distillation_require_rule_p4 (var e1)) Member (L1-13_6_sk_sea_water (var x)) sea_water) (sem-edge-tv (var g) (L1-13_6_distillation_require_rule_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L1-13_6_distillation_require_rule_p5 (var e1)) From (L1-13_6_sk_sea_water (var x)) salt_bloom_tide_pools) (sem-edge-tv (var g) (L1-13_6_distillation_require_rule_p5 (var e1)) (STV 1.0 0.9))))

; --- L1-14.4: When a Keeper stores a clay vessel, the Keeper dates that vessel.
(sem-rule L1-14_4_keeper_dates_rule)
(rule-context L1-14_4_keeper_dates_rule aelmere-lore)
(rule-priority L1-14_4_keeper_dates_rule 108)
(rule-tv L1-14_4_keeper_dates_rule authored 1.0 0.9)
(rule-lhs L1-14_4_keeper_dates_rule ((sem-edge (var g) (var e1) Member (var k) keeper) (sem-edge (var g) (var e2) Member (var s) store) (sem-edge (var g) (var e3) Agent (var s) (var k)) (sem-edge (var g) (var e4) Object (var s) (var v)) (sem-edge (var g) (var e5) Member (var v) clay_vessel)))
(rule-rhs L1-14_4_keeper_dates_rule ((sem-edge (var g) (L1-14_4_keeper_dates_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (L1-14_4_sk_date (var k) (var v)) date) (sem-edge-tv (var g) (L1-14_4_keeper_dates_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L1-14_4_keeper_dates_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Agent (L1-14_4_sk_date (var k) (var v)) (var k)) (sem-edge-tv (var g) (L1-14_4_keeper_dates_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L1-14_4_keeper_dates_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Object (L1-14_4_sk_date (var k) (var v)) (var v)) (sem-edge-tv (var g) (L1-14_4_keeper_dates_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L1-14_4_keeper_dates_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) During (L1-14_4_sk_date (var k) (var v)) (var s)) (sem-edge-tv (var g) (L1-14_4_keeper_dates_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- L2-06.5: Whenever the moon is full, Hesper reports essence production to the Council.
(sem-rule L2-06_5_whenever_rule)
(rule-context L2-06_5_whenever_rule aelmere-lore)
(rule-priority L2-06_5_whenever_rule 109)
(rule-tv L2-06_5_whenever_rule authored 1.0 0.9)
(rule-lhs L2-06_5_whenever_rule ((sem-edge (var g) (var e1) Member (var x) full) (sem-edge (var g) (var e2) Experiencer (var x) the_moon)))
(rule-rhs L2-06_5_whenever_rule ((sem-edge (var g) (L2-06_5_whenever_rule_p1 (var e1) (var e2)) Member (L2-06_5_sk_report (var x)) report) (sem-edge-tv (var g) (L2-06_5_whenever_rule_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L2-06_5_whenever_rule_p2 (var e1) (var e2)) Agent (L2-06_5_sk_report (var x)) hesper) (sem-edge-tv (var g) (L2-06_5_whenever_rule_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L2-06_5_whenever_rule_p3 (var e1) (var e2)) Object (L2-06_5_sk_report (var x)) essence_production) (sem-edge-tv (var g) (L2-06_5_whenever_rule_p3 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L2-06_5_whenever_rule_p4 (var e1) (var e2)) Recipient (L2-06_5_sk_report (var x)) the_council) (sem-edge-tv (var g) (L2-06_5_whenever_rule_p4 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L2-06_5_whenever_rule_p5 (var e1) (var e2)) During (L2-06_5_sk_report (var x)) (var x)) (sem-edge-tv (var g) (L2-06_5_whenever_rule_p5 (var e1) (var e2)) (STV 1.0 0.9))))

; --- L2-11.4: Council members often consult Marra Tallowhand's logs.
(sem-rule L2-11_4_cm_consult_rule)
(rule-context L2-11_4_cm_consult_rule aelmere-lore)
(rule-priority L2-11_4_cm_consult_rule 110)
(rule-tv L2-11_4_cm_consult_rule authored 0.8 0.9)
(rule-lhs L2-11_4_cm_consult_rule ((sem-edge (var g) (var e1) Member (var x) council_member)))
(rule-rhs L2-11_4_cm_consult_rule ((sem-edge (var g) (L2-11_4_cm_consult_rule_p1 (var e1)) Member (L2-11_4_sk_consult (var x)) consult) (sem-edge-tv (var g) (L2-11_4_cm_consult_rule_p1 (var e1)) (STV 0.8 0.9)) (sem-edge (var g) (L2-11_4_cm_consult_rule_p2 (var e1)) Agent (L2-11_4_sk_consult (var x)) (var x)) (sem-edge-tv (var g) (L2-11_4_cm_consult_rule_p2 (var e1)) (STV 0.8 0.9)) (sem-edge (var g) (L2-11_4_cm_consult_rule_p3 (var e1)) Object (L2-11_4_sk_consult (var x)) L2-11_4_sk_log_1) (sem-edge-tv (var g) (L2-11_4_cm_consult_rule_p3 (var e1)) (STV 0.8 0.9))))

; --- L2-12.1: Each Keeper tends a station alone.
(sem-rule L2-12_1_keeper_tends)
(rule-context L2-12_1_keeper_tends aelmere-lore)
(rule-priority L2-12_1_keeper_tends 111)
(rule-tv L2-12_1_keeper_tends authored 1.0 0.9)
(rule-lhs L2-12_1_keeper_tends ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L2-12_1_keeper_tends ((sem-edge (var g) (L2-12_1_keeper_tends_p1 (var e1)) Member (L2-12_1_sk_tend (var x)) tend) (sem-edge-tv (var g) (L2-12_1_keeper_tends_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-12_1_keeper_tends_p2 (var e1)) Agent (L2-12_1_sk_tend (var x)) (var x)) (sem-edge-tv (var g) (L2-12_1_keeper_tends_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-12_1_keeper_tends_p3 (var e1)) Object (L2-12_1_sk_tend (var x)) (L2-12_1_sk_station (var x))) (sem-edge-tv (var g) (L2-12_1_keeper_tends_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-12_1_keeper_tends_p4 (var e1)) Member (L2-12_1_sk_station (var x)) station) (sem-edge-tv (var g) (L2-12_1_keeper_tends_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-12_1_keeper_tends_p5 (var e1)) Manner (L2-12_1_sk_tend (var x)) alone) (sem-edge-tv (var g) (L2-12_1_keeper_tends_p5 (var e1)) (STV 1.0 0.9))))

; --- L2-12.2: When a Keeper trains an apprentice, the Keeper and the apprentice tend the station together.
(sem-rule L2-12_2_train_tend_rule)
(rule-context L2-12_2_train_tend_rule aelmere-lore)
(rule-priority L2-12_2_train_tend_rule 112)
(rule-tv L2-12_2_train_tend_rule authored 1.0 0.9)
(rule-lhs L2-12_2_train_tend_rule ((sem-edge (var g) (var e1) Member (var t) train) (sem-edge (var g) (var e2) Agent (var t) (var k)) (sem-edge (var g) (var e3) Object (var t) (var a)) (sem-edge (var g) (var e4) Member (var k) keeper) (sem-edge (var g) (var e5) Member (var a) apprentice)))
(rule-rhs L2-12_2_train_tend_rule ((sem-edge (var g) (L2-12_2_train_tend_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (L2-12_2_sk_tend (var t)) tend) (sem-edge-tv (var g) (L2-12_2_train_tend_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L2-12_2_train_tend_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Agent (L2-12_2_sk_tend (var t)) (var k)) (sem-edge-tv (var g) (L2-12_2_train_tend_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L2-12_2_train_tend_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Agent (L2-12_2_sk_tend (var t)) (var a)) (sem-edge-tv (var g) (L2-12_2_train_tend_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L2-12_2_train_tend_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) Object (L2-12_2_sk_tend (var t)) L2-12_2_sk_station_1) (sem-edge-tv (var g) (L2-12_2_train_tend_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L2-12_2_train_tend_rule_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) During (L2-12_2_sk_tend (var t)) (var t)) (sem-edge-tv (var g) (L2-12_2_train_tend_rule_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- L2-12.3: When a week is a high-wraith week, two Keepers tend the Stilllight Lantern together.
(sem-rule L2-12_3_hww_rule)
(rule-context L2-12_3_hww_rule aelmere-lore)
(rule-priority L2-12_3_hww_rule 113)
(rule-tv L2-12_3_hww_rule authored 1.0 0.9)
(rule-lhs L2-12_3_hww_rule ((sem-edge (var g) (var e1) Member (var w) high_wraith_week)))
(rule-rhs L2-12_3_hww_rule ((sem-edge (var g) (L2-12_3_hww_rule_p1 (var e1)) GroupOf (L2-12_3_sk_keepers (var w)) keeper) (sem-edge-tv (var g) (L2-12_3_hww_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-12_3_hww_rule_p2 (var e1)) Cardinality (L2-12_3_sk_keepers (var w)) 2) (sem-edge-tv (var g) (L2-12_3_hww_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-12_3_hww_rule_p3 (var e1)) Member (L2-12_3_sk_tend (var w)) tend) (sem-edge-tv (var g) (L2-12_3_hww_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-12_3_hww_rule_p4 (var e1)) Agent (L2-12_3_sk_tend (var w)) (L2-12_3_sk_keepers (var w))) (sem-edge-tv (var g) (L2-12_3_hww_rule_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-12_3_hww_rule_p5 (var e1)) Object (L2-12_3_sk_tend (var w)) stilllight_lantern) (sem-edge-tv (var g) (L2-12_3_hww_rule_p5 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-12_3_hww_rule_p6 (var e1)) During (L2-12_3_sk_tend (var w)) (var w)) (sem-edge-tv (var g) (L2-12_3_hww_rule_p6 (var e1)) (STV 1.0 0.9))))

; --- L2-12.4: Night shifts begin at sundown.
(sem-rule L2-12_4_lp7_rule)
(rule-context L2-12_4_lp7_rule aelmere-lore)
(rule-priority L2-12_4_lp7_rule 114)
(rule-tv L2-12_4_lp7_rule authored 0.9 0.9)
(rule-lhs L2-12_4_lp7_rule ((sem-edge (var g) (var e1) Member (var x) night_shift)))
(rule-rhs L2-12_4_lp7_rule ((sem-edge (var g) (L2-12_4_lp7_rule_p1 (var e1)) Member (L2-12_4_sk_begin (var x)) begin) (sem-edge-tv (var g) (L2-12_4_lp7_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L2-12_4_lp7_rule_p2 (var e1)) Object (L2-12_4_sk_begin (var x)) (var x)) (sem-edge-tv (var g) (L2-12_4_lp7_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L2-12_4_lp7_rule_p3 (var e1)) Time (L2-12_4_sk_begin (var x)) sundown) (sem-edge-tv (var g) (L2-12_4_lp7_rule_p3 (var e1)) (STV 0.9 0.9))))

; --- L2-12.5: Each Keeper checks the lantern at midnight.
(sem-rule L2-12_5_keeper_check_rule)
(rule-context L2-12_5_keeper_check_rule aelmere-lore)
(rule-priority L2-12_5_keeper_check_rule 115)
(rule-tv L2-12_5_keeper_check_rule authored 1.0 0.9)
(rule-lhs L2-12_5_keeper_check_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L2-12_5_keeper_check_rule ((sem-edge (var g) (L2-12_5_keeper_check_rule_p1 (var e1)) Member (L2-12_5_sk_check (var x)) check) (sem-edge-tv (var g) (L2-12_5_keeper_check_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-12_5_keeper_check_rule_p2 (var e1)) Agent (L2-12_5_sk_check (var x)) (var x)) (sem-edge-tv (var g) (L2-12_5_keeper_check_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-12_5_keeper_check_rule_p3 (var e1)) Object (L2-12_5_sk_check (var x)) L2-12_5_sk_lantern_1) (sem-edge-tv (var g) (L2-12_5_keeper_check_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-12_5_keeper_check_rule_p4 (var e1)) Time (L2-12_5_sk_check (var x)) midnight) (sem-edge-tv (var g) (L2-12_5_keeper_check_rule_p4 (var e1)) (STV 1.0 0.9))))

; --- L2-12.6: Each Keeper checks the lantern at the third watch.
(sem-rule L2-12_6_keeper_check_rule)
(rule-context L2-12_6_keeper_check_rule aelmere-lore)
(rule-priority L2-12_6_keeper_check_rule 116)
(rule-tv L2-12_6_keeper_check_rule authored 1.0 0.9)
(rule-lhs L2-12_6_keeper_check_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L2-12_6_keeper_check_rule ((sem-edge (var g) (L2-12_6_keeper_check_rule_p1 (var e1)) Member (L2-12_6_sk_check (var x)) check) (sem-edge-tv (var g) (L2-12_6_keeper_check_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-12_6_keeper_check_rule_p2 (var e1)) Agent (L2-12_6_sk_check (var x)) (var x)) (sem-edge-tv (var g) (L2-12_6_keeper_check_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-12_6_keeper_check_rule_p3 (var e1)) Object (L2-12_6_sk_check (var x)) L2-12_6_sk_lantern_1) (sem-edge-tv (var g) (L2-12_6_keeper_check_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-12_6_keeper_check_rule_p4 (var e1)) Time (L2-12_6_sk_check (var x)) third_watch) (sem-edge-tv (var g) (L2-12_6_keeper_check_rule_p4 (var e1)) (STV 1.0 0.9))))

; --- L2-13.1: Each Keeper carries a leather case.
(sem-rule L2-13_1_keeper_carry)
(rule-context L2-13_1_keeper_carry aelmere-lore)
(rule-priority L2-13_1_keeper_carry 117)
(rule-tv L2-13_1_keeper_carry authored 1.0 0.9)
(rule-lhs L2-13_1_keeper_carry ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L2-13_1_keeper_carry ((sem-edge (var g) (L2-13_1_keeper_carry_p1 (var e1)) Member (L2-13_1_sk_carry (var x)) carry) (sem-edge-tv (var g) (L2-13_1_keeper_carry_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-13_1_keeper_carry_p2 (var e1)) Agent (L2-13_1_sk_carry (var x)) (var x)) (sem-edge-tv (var g) (L2-13_1_keeper_carry_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-13_1_keeper_carry_p3 (var e1)) Object (L2-13_1_sk_carry (var x)) (L2-13_1_sk_case (var x))) (sem-edge-tv (var g) (L2-13_1_keeper_carry_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-13_1_keeper_carry_p4 (var e1)) Member (L2-13_1_sk_case (var x)) leather_case) (sem-edge-tv (var g) (L2-13_1_keeper_carry_p4 (var e1)) (STV 1.0 0.9))))

; --- L2-14.1: Keepers wear long oilcloth coats.
(sem-rule L2-14_1_keepers_wear)
(rule-context L2-14_1_keepers_wear aelmere-lore)
(rule-priority L2-14_1_keepers_wear 118)
(rule-tv L2-14_1_keepers_wear authored 0.9 0.9)
(rule-lhs L2-14_1_keepers_wear ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L2-14_1_keepers_wear ((sem-edge (var g) (L2-14_1_keepers_wear_p1 (var e1)) Member (L2-14_1_sk_wear (var x)) wear) (sem-edge-tv (var g) (L2-14_1_keepers_wear_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L2-14_1_keepers_wear_p2 (var e1)) Agent (L2-14_1_sk_wear (var x)) (var x)) (sem-edge-tv (var g) (L2-14_1_keepers_wear_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L2-14_1_keepers_wear_p3 (var e1)) Object (L2-14_1_sk_wear (var x)) (L2-14_1_sk_coat (var x))) (sem-edge-tv (var g) (L2-14_1_keepers_wear_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L2-14_1_keepers_wear_p4 (var e1)) Member (L2-14_1_sk_coat (var x)) oilcloth_coat) (sem-edge-tv (var g) (L2-14_1_keepers_wear_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L2-14_1_keepers_wear_p5 (var e1)) Member (L2-14_1_sk_coat (var x)) long) (sem-edge-tv (var g) (L2-14_1_keepers_wear_p5 (var e1)) (STV 0.9 0.9))))

; --- L2-14.3: Mire-essence stains every Keeper's coat.
(sem-rule L2-14_3_keeper_stain_rule)
(rule-context L2-14_3_keeper_stain_rule aelmere-lore)
(rule-priority L2-14_3_keeper_stain_rule 119)
(rule-tv L2-14_3_keeper_stain_rule authored 1.0 0.9)
(rule-lhs L2-14_3_keeper_stain_rule ((sem-edge (var g) (var e1) Member (var k) keeper)))
(rule-rhs L2-14_3_keeper_stain_rule ((sem-edge (var g) (L2-14_3_keeper_stain_rule_p1 (var e1)) Member (L2-14_3_sk_stain (var k)) stain) (sem-edge-tv (var g) (L2-14_3_keeper_stain_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-14_3_keeper_stain_rule_p2 (var e1)) Agent (L2-14_3_sk_stain (var k)) mire_essence) (sem-edge-tv (var g) (L2-14_3_keeper_stain_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-14_3_keeper_stain_rule_p3 (var e1)) Object (L2-14_3_sk_stain (var k)) (L2-14_3_sk_coat (var k))) (sem-edge-tv (var g) (L2-14_3_keeper_stain_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-14_3_keeper_stain_rule_p4 (var e1)) Member (L2-14_3_sk_coat (var k)) coat) (sem-edge-tv (var g) (L2-14_3_keeper_stain_rule_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-14_3_keeper_stain_rule_p5 (var e1)) Possession (L2-14_3_sk_coat (var k)) (var k)) (sem-edge-tv (var g) (L2-14_3_keeper_stain_rule_p5 (var e1)) (STV 1.0 0.9))))

; --- L2-14.4: Every first-year apprentice wears an unstained coat.
(sem-rule L2-14_4_fya_wear_rule)
(rule-context L2-14_4_fya_wear_rule aelmere-lore)
(rule-priority L2-14_4_fya_wear_rule 120)
(rule-tv L2-14_4_fya_wear_rule authored 1.0 0.9)
(rule-lhs L2-14_4_fya_wear_rule ((sem-edge (var g) (var e1) Member (var x) first_year_apprentice)))
(rule-rhs L2-14_4_fya_wear_rule ((sem-edge (var g) (L2-14_4_fya_wear_rule_p1 (var e1)) Member (L2-14_4_sk_wear (var x)) wear) (sem-edge-tv (var g) (L2-14_4_fya_wear_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-14_4_fya_wear_rule_p2 (var e1)) Agent (L2-14_4_sk_wear (var x)) (var x)) (sem-edge-tv (var g) (L2-14_4_fya_wear_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-14_4_fya_wear_rule_p3 (var e1)) Object (L2-14_4_sk_wear (var x)) (L2-14_4_sk_coat (var x))) (sem-edge-tv (var g) (L2-14_4_fya_wear_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-14_4_fya_wear_rule_p4 (var e1)) Member (L2-14_4_sk_coat (var x)) coat) (sem-edge-tv (var g) (L2-14_4_fya_wear_rule_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-14_4_fya_wear_rule_p5 (var e1)) Member (L2-14_4_sk_coat (var x)) unstained) (sem-edge-tv (var g) (L2-14_4_fya_wear_rule_p5 (var e1)) (STV 1.0 0.9))))

; --- L2-15.2: Whenever an heir inherits a Keeper's lantern-station, that heir inherits that Keeper's notebook.
(sem-rule L2-15_2_heir_inherit_whenever)
(rule-context L2-15_2_heir_inherit_whenever aelmere-lore)
(rule-priority L2-15_2_heir_inherit_whenever 121)
(rule-tv L2-15_2_heir_inherit_whenever authored 1.0 0.9)
(rule-lhs L2-15_2_heir_inherit_whenever ((sem-edge (var g) (var e1) Member (var h) heir) (sem-edge (var g) (var e2) Member (var k) keeper) (sem-edge (var g) (var e3) Member (var e) inherit) (sem-edge (var g) (var e4) Agent (var e) (var h)) (sem-edge (var g) (var e5) Object (var e) (var ls)) (sem-edge (var g) (var e6) Member (var ls) lantern_station) (sem-edge (var g) (var e7) Possession (var ls) (var k))))
(rule-rhs L2-15_2_heir_inherit_whenever ((sem-edge (var g) (L2-15_2_heir_inherit_whenever_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Member (L2-15_2_sk_inherit_notebook (var h) (var k)) inherit) (sem-edge-tv (var g) (L2-15_2_heir_inherit_whenever_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (L2-15_2_heir_inherit_whenever_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Agent (L2-15_2_sk_inherit_notebook (var h) (var k)) (var h)) (sem-edge-tv (var g) (L2-15_2_heir_inherit_whenever_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (L2-15_2_heir_inherit_whenever_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Object (L2-15_2_sk_inherit_notebook (var h) (var k)) (L2-15_2_sk_notebook (var k))) (sem-edge-tv (var g) (L2-15_2_heir_inherit_whenever_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (L2-15_2_heir_inherit_whenever_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Member (L2-15_2_sk_notebook (var k)) notebook) (sem-edge-tv (var g) (L2-15_2_heir_inherit_whenever_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (L2-15_2_heir_inherit_whenever_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Possession (L2-15_2_sk_notebook (var k)) (var k)) (sem-edge-tv (var g) (L2-15_2_heir_inherit_whenever_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (L2-15_2_heir_inherit_whenever_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) During (L2-15_2_sk_inherit_notebook (var h) (var k)) (var e)) (sem-edge-tv (var g) (L2-15_2_heir_inherit_whenever_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9))))

; --- L2-16.3: Whenever a Keeper leaves a station, the Council assigns an apprentice to that station.
(sem-rule L2-16_3_whenever_leave_assign)
(rule-context L2-16_3_whenever_leave_assign aelmere-lore)
(rule-priority L2-16_3_whenever_leave_assign 122)
(rule-tv L2-16_3_whenever_leave_assign authored 1.0 0.9)
(rule-lhs L2-16_3_whenever_leave_assign ((sem-edge (var g) (var e1) Member (var e) leave) (sem-edge (var g) (var e2) Agent (var e) (var k)) (sem-edge (var g) (var e3) Object (var e) (var s)) (sem-edge (var g) (var e4) Member (var k) keeper) (sem-edge (var g) (var e5) Member (var s) station)))
(rule-rhs L2-16_3_whenever_leave_assign ((sem-edge (var g) (L2-16_3_whenever_leave_assign_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (L2-16_3_sk_assign (var k) (var s)) assign) (sem-edge-tv (var g) (L2-16_3_whenever_leave_assign_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L2-16_3_whenever_leave_assign_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Agent (L2-16_3_sk_assign (var k) (var s)) the_council) (sem-edge-tv (var g) (L2-16_3_whenever_leave_assign_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L2-16_3_whenever_leave_assign_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Object (L2-16_3_sk_assign (var k) (var s)) (L2-16_3_sk_apprentice (var k) (var s))) (sem-edge-tv (var g) (L2-16_3_whenever_leave_assign_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L2-16_3_whenever_leave_assign_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (L2-16_3_sk_apprentice (var k) (var s)) apprentice) (sem-edge-tv (var g) (L2-16_3_whenever_leave_assign_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L2-16_3_whenever_leave_assign_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) Goal (L2-16_3_sk_assign (var k) (var s)) (var s)) (sem-edge-tv (var g) (L2-16_3_whenever_leave_assign_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L2-16_3_whenever_leave_assign_p6 (var e1) (var e2) (var e3) (var e4) (var e5)) During (L2-16_3_sk_assign (var k) (var s)) (var e)) (sem-edge-tv (var g) (L2-16_3_whenever_leave_assign_p6 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- L2-16.4: Whenever an apprentice completes thirty solo nights, the Council assigns that apprentice to a station.
(sem-rule L2-16_4_apprentice_station_rule)
(rule-context L2-16_4_apprentice_station_rule aelmere-lore)
(rule-priority L2-16_4_apprentice_station_rule 123)
(rule-tv L2-16_4_apprentice_station_rule authored 1.0 0.9)
(rule-lhs L2-16_4_apprentice_station_rule ((sem-edge (var g) (var e1) Member (var a) apprentice) (sem-edge (var g) (var e2) Member (var e) complete) (sem-edge (var g) (var e3) Agent (var e) (var a)) (sem-edge (var g) (var e4) Object (var e) (var g)) (sem-edge (var g) (var e5) GroupOf (var g) solo_night) (sem-edge (var g) (var e6) Cardinality (var g) 30)))
(rule-rhs L2-16_4_apprentice_station_rule ((sem-edge (var g) (L2-16_4_apprentice_station_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (L2-16_4_sk_assign (var e)) assign) (sem-edge-tv (var g) (L2-16_4_apprentice_station_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L2-16_4_apprentice_station_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Agent (L2-16_4_sk_assign (var e)) the_council) (sem-edge-tv (var g) (L2-16_4_apprentice_station_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L2-16_4_apprentice_station_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Object (L2-16_4_sk_assign (var e)) (var a)) (sem-edge-tv (var g) (L2-16_4_apprentice_station_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L2-16_4_apprentice_station_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Goal (L2-16_4_sk_assign (var e)) (L2-16_4_sk_station (var e))) (sem-edge-tv (var g) (L2-16_4_apprentice_station_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L2-16_4_apprentice_station_rule_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (L2-16_4_sk_station (var e)) station) (sem-edge-tv (var g) (L2-16_4_apprentice_station_rule_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L2-16_4_apprentice_station_rule_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) During (L2-16_4_sk_assign (var e)) (var e)) (sem-edge-tv (var g) (L2-16_4_apprentice_station_rule_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9))))

; --- L2-18.1: Keepers rarely take apprentices from outside Keeper families.
(sem-rule L2-18_1_lp15_rule)
(rule-context L2-18_1_lp15_rule aelmere-lore)
(rule-priority L2-18_1_lp15_rule 124)
(rule-tv L2-18_1_lp15_rule authored 0.1 0.9)
(rule-lhs L2-18_1_lp15_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L2-18_1_lp15_rule ((sem-edge (var g) (L2-18_1_lp15_rule_p1 (var e1)) And (Member (L2-18_1_sk_take (var x)) take) (Agent (L2-18_1_sk_take (var x)) (var x)) (Object (L2-18_1_sk_take (var x)) (L2-18_1_sk_apprentice (var x))) (Member (L2-18_1_sk_apprentice (var x)) apprentice) (FromOutside (L2-18_1_sk_apprentice (var x)) keeper_family)) (sem-edge-tv (var g) (L2-18_1_lp15_rule_p1 (var e1)) (STV 0.1 0.9))))

; --- L2-19.1: Every Keeper considers that lantern-tending is sacred.
(sem-rule L2-19_1_keeper_considers_rule)
(rule-context L2-19_1_keeper_considers_rule aelmere-lore)
(rule-priority L2-19_1_keeper_considers_rule 125)
(rule-tv L2-19_1_keeper_considers_rule authored 1.0 0.9)
(rule-lhs L2-19_1_keeper_considers_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L2-19_1_keeper_considers_rule ((sem-edge (var g) (L2-19_1_keeper_considers_rule_p1 (var e1)) Member (L2-19_1_sk_consider (var x)) consider) (sem-edge-tv (var g) (L2-19_1_keeper_considers_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-19_1_keeper_considers_rule_p2 (var e1)) Experiencer (L2-19_1_sk_consider (var x)) (var x)) (sem-edge-tv (var g) (L2-19_1_keeper_considers_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-19_1_keeper_considers_rule_p3 (var e1)) Object (L2-19_1_sk_consider (var x)) (Inheritance lantern_tending sacred)) (sem-edge-tv (var g) (L2-19_1_keeper_considers_rule_p3 (var e1)) (STV 1.0 0.9))))

; --- L2-20.2: Whenever a birth takes place, a Keeper repeats the phrase.
(sem-rule L2-20_2_birth_repeat_whenever)
(rule-context L2-20_2_birth_repeat_whenever aelmere-lore)
(rule-priority L2-20_2_birth_repeat_whenever 126)
(rule-tv L2-20_2_birth_repeat_whenever authored 1.0 0.9)
(rule-lhs L2-20_2_birth_repeat_whenever ((sem-edge (var g) (var e1) Member (var b) birth)))
(rule-rhs L2-20_2_birth_repeat_whenever ((sem-edge (var g) (L2-20_2_birth_repeat_whenever_p1 (var e1)) Member (L2-20_2_sk_repeat (var b)) repeat) (sem-edge-tv (var g) (L2-20_2_birth_repeat_whenever_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-20_2_birth_repeat_whenever_p2 (var e1)) Agent (L2-20_2_sk_repeat (var b)) (L2-20_2_sk_keeper (var b))) (sem-edge-tv (var g) (L2-20_2_birth_repeat_whenever_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-20_2_birth_repeat_whenever_p3 (var e1)) Member (L2-20_2_sk_keeper (var b)) keeper) (sem-edge-tv (var g) (L2-20_2_birth_repeat_whenever_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-20_2_birth_repeat_whenever_p4 (var e1)) Object (L2-20_2_sk_repeat (var b)) L2-20_2_sk_phrase_1) (sem-edge-tv (var g) (L2-20_2_birth_repeat_whenever_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-20_2_birth_repeat_whenever_p5 (var e1)) During (L2-20_2_sk_repeat (var b)) (var b)) (sem-edge-tv (var g) (L2-20_2_birth_repeat_whenever_p5 (var e1)) (STV 1.0 0.9))))

; --- L2-20.3: Whenever a funeral takes place, a Keeper repeats the phrase.
(sem-rule L2-20_3_funeral_repeat_rule)
(rule-context L2-20_3_funeral_repeat_rule aelmere-lore)
(rule-priority L2-20_3_funeral_repeat_rule 127)
(rule-tv L2-20_3_funeral_repeat_rule authored 1.0 0.9)
(rule-lhs L2-20_3_funeral_repeat_rule ((sem-edge (var g) (var e1) Member (var x) funeral)))
(rule-rhs L2-20_3_funeral_repeat_rule ((sem-edge (var g) (L2-20_3_funeral_repeat_rule_p1 (var e1)) Member (L2-20_3_sk_repeat (var x)) repeat) (sem-edge-tv (var g) (L2-20_3_funeral_repeat_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-20_3_funeral_repeat_rule_p2 (var e1)) Member (L2-20_3_sk_keeper (var x)) keeper) (sem-edge-tv (var g) (L2-20_3_funeral_repeat_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-20_3_funeral_repeat_rule_p3 (var e1)) Agent (L2-20_3_sk_repeat (var x)) (L2-20_3_sk_keeper (var x))) (sem-edge-tv (var g) (L2-20_3_funeral_repeat_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-20_3_funeral_repeat_rule_p4 (var e1)) Object (L2-20_3_sk_repeat (var x)) L2-20_3_sk_phrase_1) (sem-edge-tv (var g) (L2-20_3_funeral_repeat_rule_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-20_3_funeral_repeat_rule_p5 (var e1)) During (L2-20_3_sk_repeat (var x)) (var x)) (sem-edge-tv (var g) (L2-20_3_funeral_repeat_rule_p5 (var e1)) (STV 1.0 0.9))))

; --- L2-20.4: Whenever the Council closes a session, a Keeper repeats the phrase.
(sem-rule L2-20_4_lorep19_whenever_rule)
(rule-context L2-20_4_lorep19_whenever_rule aelmere-lore)
(rule-priority L2-20_4_lorep19_whenever_rule 128)
(rule-tv L2-20_4_lorep19_whenever_rule authored 1.0 0.9)
(rule-lhs L2-20_4_lorep19_whenever_rule ((sem-edge (var g) (var e1) Member (var x) close) (sem-edge (var g) (var e2) Agent (var x) the_council) (sem-edge (var g) (var e3) Object (var x) (var s)) (sem-edge (var g) (var e4) Member (var s) session)))
(rule-rhs L2-20_4_lorep19_whenever_rule ((sem-edge (var g) (L2-20_4_lorep19_whenever_rule_p1 (var e1) (var e2) (var e3) (var e4)) Member (L2-20_4_sk_repeat (var x)) repeat) (sem-edge-tv (var g) (L2-20_4_lorep19_whenever_rule_p1 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L2-20_4_lorep19_whenever_rule_p2 (var e1) (var e2) (var e3) (var e4)) Agent (L2-20_4_sk_repeat (var x)) (L2-20_4_sk_keeper (var x))) (sem-edge-tv (var g) (L2-20_4_lorep19_whenever_rule_p2 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L2-20_4_lorep19_whenever_rule_p3 (var e1) (var e2) (var e3) (var e4)) Member (L2-20_4_sk_keeper (var x)) keeper) (sem-edge-tv (var g) (L2-20_4_lorep19_whenever_rule_p3 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L2-20_4_lorep19_whenever_rule_p4 (var e1) (var e2) (var e3) (var e4)) Object (L2-20_4_sk_repeat (var x)) L2-20_4_sk_phrase_1) (sem-edge-tv (var g) (L2-20_4_lorep19_whenever_rule_p4 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L2-20_4_lorep19_whenever_rule_p5 (var e1) (var e2) (var e3) (var e4)) During (L2-20_4_sk_repeat (var x)) (var x)) (sem-edge-tv (var g) (L2-20_4_lorep19_whenever_rule_p5 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9))))

; --- L2-21.1: When a Keeper fails a station, the Council judges that Keeper.
(sem-rule L2-21_1_keeper_fail_judge_rule)
(rule-context L2-21_1_keeper_fail_judge_rule aelmere-lore)
(rule-priority L2-21_1_keeper_fail_judge_rule 129)
(rule-tv L2-21_1_keeper_fail_judge_rule authored 1.0 0.9)
(rule-lhs L2-21_1_keeper_fail_judge_rule ((sem-edge (var g) (var e1) Member (var k) keeper) (sem-edge (var g) (var e2) Member (var f) fail) (sem-edge (var g) (var e3) Agent (var f) (var k)) (sem-edge (var g) (var e4) Member (var s) station) (sem-edge (var g) (var e5) Object (var f) (var s))))
(rule-rhs L2-21_1_keeper_fail_judge_rule ((sem-edge (var g) (L2-21_1_keeper_fail_judge_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (L2-21_1_sk_judge (var f)) judge) (sem-edge-tv (var g) (L2-21_1_keeper_fail_judge_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L2-21_1_keeper_fail_judge_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Agent (L2-21_1_sk_judge (var f)) the_council) (sem-edge-tv (var g) (L2-21_1_keeper_fail_judge_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L2-21_1_keeper_fail_judge_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Object (L2-21_1_sk_judge (var f)) (var k)) (sem-edge-tv (var g) (L2-21_1_keeper_fail_judge_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L2-21_1_keeper_fail_judge_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) During (L2-21_1_sk_judge (var f)) (var f)) (sem-edge-tv (var g) (L2-21_1_keeper_fail_judge_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- L2-22.1: The village pays each Keeper in food and shelter.
(sem-rule L2-22_1_village_pays_keeper)
(rule-context L2-22_1_village_pays_keeper aelmere-lore)
(rule-priority L2-22_1_village_pays_keeper 130)
(rule-tv L2-22_1_village_pays_keeper authored 1.0 0.9)
(rule-lhs L2-22_1_village_pays_keeper ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L2-22_1_village_pays_keeper ((sem-edge (var g) (L2-22_1_village_pays_keeper_p1 (var e1)) Member (L2-22_1_sk_pay (var x)) pay) (sem-edge-tv (var g) (L2-22_1_village_pays_keeper_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-22_1_village_pays_keeper_p2 (var e1)) Agent (L2-22_1_sk_pay (var x)) aelmere) (sem-edge-tv (var g) (L2-22_1_village_pays_keeper_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-22_1_village_pays_keeper_p3 (var e1)) Recipient (L2-22_1_sk_pay (var x)) (var x)) (sem-edge-tv (var g) (L2-22_1_village_pays_keeper_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-22_1_village_pays_keeper_p4 (var e1)) Instrument (L2-22_1_sk_pay (var x)) food) (sem-edge-tv (var g) (L2-22_1_village_pays_keeper_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-22_1_village_pays_keeper_p5 (var e1)) Instrument (L2-22_1_sk_pay (var x)) shelter) (sem-edge-tv (var g) (L2-22_1_village_pays_keeper_p5 (var e1)) (STV 1.0 0.9))))

; --- L2-22.3: Each Keeper draws a share from the pool.
(sem-rule L2-22_3_keeper_draw_rule)
(rule-context L2-22_3_keeper_draw_rule aelmere-lore)
(rule-priority L2-22_3_keeper_draw_rule 131)
(rule-tv L2-22_3_keeper_draw_rule authored 1.0 0.9)
(rule-lhs L2-22_3_keeper_draw_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L2-22_3_keeper_draw_rule ((sem-edge (var g) (L2-22_3_keeper_draw_rule_p1 (var e1)) Member (L2-22_3_sk_draw (var x)) draw) (sem-edge-tv (var g) (L2-22_3_keeper_draw_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-22_3_keeper_draw_rule_p2 (var e1)) Agent (L2-22_3_sk_draw (var x)) (var x)) (sem-edge-tv (var g) (L2-22_3_keeper_draw_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-22_3_keeper_draw_rule_p3 (var e1)) Object (L2-22_3_sk_draw (var x)) (L2-22_3_sk_share (var x))) (sem-edge-tv (var g) (L2-22_3_keeper_draw_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-22_3_keeper_draw_rule_p4 (var e1)) Member (L2-22_3_sk_share (var x)) share) (sem-edge-tv (var g) (L2-22_3_keeper_draw_rule_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L2-22_3_keeper_draw_rule_p5 (var e1)) Source (L2-22_3_sk_draw (var x)) L2-22_3_sk_pool_1) (sem-edge-tv (var g) (L2-22_3_keeper_draw_rule_p5 (var e1)) (STV 1.0 0.9))))

; --- L3-01.3: Council members serve permanently.
(sem-rule L3-01_3_cm_serve_rule)
(rule-context L3-01_3_cm_serve_rule aelmere-lore)
(rule-priority L3-01_3_cm_serve_rule 132)
(rule-tv L3-01_3_cm_serve_rule authored 0.9 0.9)
(rule-lhs L3-01_3_cm_serve_rule ((sem-edge (var g) (var e1) Member (var x) council_member)))
(rule-rhs L3-01_3_cm_serve_rule ((sem-edge (var g) (L3-01_3_cm_serve_rule_p1 (var e1)) Member (L3-01_3_sk_serve (var x)) serve) (sem-edge-tv (var g) (L3-01_3_cm_serve_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L3-01_3_cm_serve_rule_p2 (var e1)) Agent (L3-01_3_sk_serve (var x)) (var x)) (sem-edge-tv (var g) (L3-01_3_cm_serve_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L3-01_3_cm_serve_rule_p3 (var e1)) Duration (L3-01_3_sk_serve (var x)) permanently) (sem-edge-tv (var g) (L3-01_3_cm_serve_rule_p3 (var e1)) (STV 0.9 0.9))))

; --- L3-02.1: Whenever the moon is full, the Council meets.
(sem-rule L3-02_1_whenever_full_meet)
(rule-context L3-02_1_whenever_full_meet aelmere-lore)
(rule-priority L3-02_1_whenever_full_meet 133)
(rule-tv L3-02_1_whenever_full_meet authored 1.0 0.9)
(rule-lhs L3-02_1_whenever_full_meet ((sem-edge (var g) (var e1) Member (var x) full) (sem-edge (var g) (var e2) Experiencer (var x) the_moon)))
(rule-rhs L3-02_1_whenever_full_meet ((sem-edge (var g) (L3-02_1_whenever_full_meet_p1 (var e1) (var e2)) Member (L3-02_1_sk_meet (var x)) meet) (sem-edge-tv (var g) (L3-02_1_whenever_full_meet_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L3-02_1_whenever_full_meet_p2 (var e1) (var e2)) Agent (L3-02_1_sk_meet (var x)) the_council) (sem-edge-tv (var g) (L3-02_1_whenever_full_meet_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L3-02_1_whenever_full_meet_p3 (var e1) (var e2)) During (L3-02_1_sk_meet (var x)) (var x)) (sem-edge-tv (var g) (L3-02_1_whenever_full_meet_p3 (var e1) (var e2)) (STV 1.0 0.9))))

; --- L3-02.6: The speaker calls each item of business.
(sem-rule L3-02_6_speaker_calls_rule)
(rule-context L3-02_6_speaker_calls_rule aelmere-lore)
(rule-priority L3-02_6_speaker_calls_rule 134)
(rule-tv L3-02_6_speaker_calls_rule authored 1.0 0.9)
(rule-lhs L3-02_6_speaker_calls_rule ((sem-edge (var g) (var e1) Member (var x) item) (sem-edge (var g) (var e2) Of (var x) business)))
(rule-rhs L3-02_6_speaker_calls_rule ((sem-edge (var g) (L3-02_6_speaker_calls_rule_p1 (var e1) (var e2)) Member (L3-02_6_sk_call (var x)) call) (sem-edge-tv (var g) (L3-02_6_speaker_calls_rule_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L3-02_6_speaker_calls_rule_p2 (var e1) (var e2)) Agent (L3-02_6_sk_call (var x)) L3-02_6_sk_speaker_1) (sem-edge-tv (var g) (L3-02_6_speaker_calls_rule_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L3-02_6_speaker_calls_rule_p3 (var e1) (var e2)) Object (L3-02_6_sk_call (var x)) (var x)) (sem-edge-tv (var g) (L3-02_6_speaker_calls_rule_p3 (var e1) (var e2)) (STV 1.0 0.9))))

; --- L3-03.2: When consensus fails, the Council votes by a show of hands.
(sem-rule L3-03_2_consensus_fail_vote_rule)
(rule-context L3-03_2_consensus_fail_vote_rule aelmere-lore)
(rule-priority L3-03_2_consensus_fail_vote_rule 135)
(rule-tv L3-03_2_consensus_fail_vote_rule authored 1.0 0.9)
(rule-lhs L3-03_2_consensus_fail_vote_rule ((sem-edge (var g) (var e1) Member (var x) fail) (sem-edge (var g) (var e2) Object (var x) consensus)))
(rule-rhs L3-03_2_consensus_fail_vote_rule ((sem-edge (var g) (L3-03_2_consensus_fail_vote_rule_p1 (var e1) (var e2)) Member (L3-03_2_sk_vote (var x)) vote) (sem-edge-tv (var g) (L3-03_2_consensus_fail_vote_rule_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L3-03_2_consensus_fail_vote_rule_p2 (var e1) (var e2)) Agent (L3-03_2_sk_vote (var x)) the_council) (sem-edge-tv (var g) (L3-03_2_consensus_fail_vote_rule_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L3-03_2_consensus_fail_vote_rule_p3 (var e1) (var e2)) Instrument (L3-03_2_sk_vote (var x)) (L3-03_2_sk_show_of_hands (var x))) (sem-edge-tv (var g) (L3-03_2_consensus_fail_vote_rule_p3 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L3-03_2_consensus_fail_vote_rule_p4 (var e1) (var e2)) Member (L3-03_2_sk_show_of_hands (var x)) show_of_hands) (sem-edge-tv (var g) (L3-03_2_consensus_fail_vote_rule_p4 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L3-03_2_consensus_fail_vote_rule_p5 (var e1) (var e2)) During (L3-03_2_sk_vote (var x)) (var x)) (sem-edge-tv (var g) (L3-03_2_consensus_fail_vote_rule_p5 (var e1) (var e2)) (STV 1.0 0.9))))

; --- L3-03.3: Every vote is decided by a simple majority.
(sem-rule L3-03_3_vote_decide_rule)
(rule-context L3-03_3_vote_decide_rule aelmere-lore)
(rule-priority L3-03_3_vote_decide_rule 136)
(rule-tv L3-03_3_vote_decide_rule authored 1.0 0.9)
(rule-lhs L3-03_3_vote_decide_rule ((sem-edge (var g) (var e1) Member (var x) vote)))
(rule-rhs L3-03_3_vote_decide_rule ((sem-edge (var g) (L3-03_3_vote_decide_rule_p1 (var e1)) Member (L3-03_3_sk_decide (var x)) decide) (sem-edge-tv (var g) (L3-03_3_vote_decide_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L3-03_3_vote_decide_rule_p2 (var e1)) Object (L3-03_3_sk_decide (var x)) (var x)) (sem-edge-tv (var g) (L3-03_3_vote_decide_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L3-03_3_vote_decide_rule_p3 (var e1)) Agent (L3-03_3_sk_decide (var x)) (L3-03_3_sk_majority (var x))) (sem-edge-tv (var g) (L3-03_3_vote_decide_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L3-03_3_vote_decide_rule_p4 (var e1)) Member (L3-03_3_sk_majority (var x)) simple_majority) (sem-edge-tv (var g) (L3-03_3_vote_decide_rule_p4 (var e1)) (STV 1.0 0.9))))

; --- L3-04.1: Whenever the moon is full, the Council redistributes mire-essence reserves.
(sem-rule L3-04_1_whenever_full_redistribute)
(rule-context L3-04_1_whenever_full_redistribute aelmere-lore)
(rule-priority L3-04_1_whenever_full_redistribute 137)
(rule-tv L3-04_1_whenever_full_redistribute authored 1.0 0.9)
(rule-lhs L3-04_1_whenever_full_redistribute ((sem-edge (var g) (var e1) Member (var x) full) (sem-edge (var g) (var e2) Experiencer (var x) the_moon)))
(rule-rhs L3-04_1_whenever_full_redistribute ((sem-edge (var g) (L3-04_1_whenever_full_redistribute_p1 (var e1) (var e2)) Member (L3-04_1_sk_redistribute (var x)) redistribute) (sem-edge-tv (var g) (L3-04_1_whenever_full_redistribute_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L3-04_1_whenever_full_redistribute_p2 (var e1) (var e2)) Agent (L3-04_1_sk_redistribute (var x)) the_council) (sem-edge-tv (var g) (L3-04_1_whenever_full_redistribute_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L3-04_1_whenever_full_redistribute_p3 (var e1) (var e2)) Object (L3-04_1_sk_redistribute (var x)) mire_essence_reserve) (sem-edge-tv (var g) (L3-04_1_whenever_full_redistribute_p3 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L3-04_1_whenever_full_redistribute_p4 (var e1) (var e2)) During (L3-04_1_sk_redistribute (var x)) (var x)) (sem-edge-tv (var g) (L3-04_1_whenever_full_redistribute_p4 (var e1) (var e2)) (STV 1.0 0.9))))

; --- L3-04.2: Each lantern-station reports its monthly production to the Council.
(sem-rule L3-04_2_ls_report_rule)
(rule-context L3-04_2_ls_report_rule aelmere-lore)
(rule-priority L3-04_2_ls_report_rule 138)
(rule-tv L3-04_2_ls_report_rule authored 1.0 0.9)
(rule-lhs L3-04_2_ls_report_rule ((sem-edge (var g) (var e1) Member (var x) lantern_station)))
(rule-rhs L3-04_2_ls_report_rule ((sem-edge (var g) (L3-04_2_ls_report_rule_p1 (var e1)) Member (L3-04_2_sk_report (var x)) report) (sem-edge-tv (var g) (L3-04_2_ls_report_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L3-04_2_ls_report_rule_p2 (var e1)) Agent (L3-04_2_sk_report (var x)) (var x)) (sem-edge-tv (var g) (L3-04_2_ls_report_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L3-04_2_ls_report_rule_p3 (var e1)) Member (L3-04_2_sk_production (var x)) production) (sem-edge-tv (var g) (L3-04_2_ls_report_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L3-04_2_ls_report_rule_p4 (var e1)) Member (L3-04_2_sk_production (var x)) monthly) (sem-edge-tv (var g) (L3-04_2_ls_report_rule_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L3-04_2_ls_report_rule_p5 (var e1)) Agent (L3-04_2_sk_production (var x)) (var x)) (sem-edge-tv (var g) (L3-04_2_ls_report_rule_p5 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L3-04_2_ls_report_rule_p6 (var e1)) Object (L3-04_2_sk_report (var x)) (L3-04_2_sk_production (var x))) (sem-edge-tv (var g) (L3-04_2_ls_report_rule_p6 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L3-04_2_ls_report_rule_p7 (var e1)) Recipient (L3-04_2_sk_report (var x)) the_council) (sem-edge-tv (var g) (L3-04_2_ls_report_rule_p7 (var e1)) (STV 1.0 0.9))))

; --- L3-05.4: The Council records each redistribution in the ledgers.
(sem-rule L3-05_4_council_records_rule)
(rule-context L3-05_4_council_records_rule aelmere-lore)
(rule-priority L3-05_4_council_records_rule 139)
(rule-tv L3-05_4_council_records_rule authored 1.0 0.9)
(rule-lhs L3-05_4_council_records_rule ((sem-edge (var g) (var e1) Member (var x) redistribution)))
(rule-rhs L3-05_4_council_records_rule ((sem-edge (var g) (L3-05_4_council_records_rule_p1 (var e1)) Member (L3-05_4_sk_record (var x)) record) (sem-edge-tv (var g) (L3-05_4_council_records_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L3-05_4_council_records_rule_p2 (var e1)) Agent (L3-05_4_sk_record (var x)) the_council) (sem-edge-tv (var g) (L3-05_4_council_records_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L3-05_4_council_records_rule_p3 (var e1)) Object (L3-05_4_sk_record (var x)) (var x)) (sem-edge-tv (var g) (L3-05_4_council_records_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L3-05_4_council_records_rule_p4 (var e1)) Location (L3-05_4_sk_record (var x)) L3-05_4_sk_ledger_1) (sem-edge-tv (var g) (L3-05_4_council_records_rule_p4 (var e1)) (STV 1.0 0.9))))

; --- L3-06.4: Whenever a Keeper retires, the Council staffs that Keeper's station again.
(sem-rule L3-06_4_keeper_retire_staff)
(rule-context L3-06_4_keeper_retire_staff aelmere-lore)
(rule-priority L3-06_4_keeper_retire_staff 140)
(rule-tv L3-06_4_keeper_retire_staff authored 1.0 0.9)
(rule-lhs L3-06_4_keeper_retire_staff ((sem-edge (var g) (var e1) Member (var e) retire) (sem-edge (var g) (var e2) Agent (var e) (var k)) (sem-edge (var g) (var e3) Member (var k) keeper)))
(rule-rhs L3-06_4_keeper_retire_staff ((sem-edge (var g) (L3-06_4_keeper_retire_staff_p1 (var e1) (var e2) (var e3)) Member (L3-06_4_sk_staff (var e)) staff) (sem-edge-tv (var g) (L3-06_4_keeper_retire_staff_p1 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L3-06_4_keeper_retire_staff_p2 (var e1) (var e2) (var e3)) Agent (L3-06_4_sk_staff (var e)) the_council) (sem-edge-tv (var g) (L3-06_4_keeper_retire_staff_p2 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L3-06_4_keeper_retire_staff_p3 (var e1) (var e2) (var e3)) Object (L3-06_4_sk_staff (var e)) (L3-06_4_sk_station (var k))) (sem-edge-tv (var g) (L3-06_4_keeper_retire_staff_p3 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L3-06_4_keeper_retire_staff_p4 (var e1) (var e2) (var e3)) Member (L3-06_4_sk_station (var k)) station) (sem-edge-tv (var g) (L3-06_4_keeper_retire_staff_p4 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L3-06_4_keeper_retire_staff_p5 (var e1) (var e2) (var e3)) Possession (L3-06_4_sk_station (var k)) (var k)) (sem-edge-tv (var g) (L3-06_4_keeper_retire_staff_p5 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L3-06_4_keeper_retire_staff_p6 (var e1) (var e2) (var e3)) During (L3-06_4_sk_staff (var e)) (var e)) (sem-edge-tv (var g) (L3-06_4_keeper_retire_staff_p6 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L3-06_4_keeper_retire_staff_p7 (var e1) (var e2) (var e3)) Again (L3-06_4_sk_staff (var e))) (sem-edge-tv (var g) (L3-06_4_keeper_retire_staff_p7 (var e1) (var e2) (var e3)) (STV 1.0 0.9))))

; --- L3-06.5: Whenever a Keeper dies, the Council staffs that Keeper's station again.
(sem-rule L3-06_5_keeper_die_staff_rule)
(rule-context L3-06_5_keeper_die_staff_rule aelmere-lore)
(rule-priority L3-06_5_keeper_die_staff_rule 141)
(rule-tv L3-06_5_keeper_die_staff_rule authored 1.0 0.9)
(rule-lhs L3-06_5_keeper_die_staff_rule ((sem-edge (var g) (var e1) Member (var k) keeper) (sem-edge (var g) (var e2) Member (var e) die) (sem-edge (var g) (var e3) Object (var e) (var k))))
(rule-rhs L3-06_5_keeper_die_staff_rule ((sem-edge (var g) (L3-06_5_keeper_die_staff_rule_p1 (var e1) (var e2) (var e3)) Member (L3-06_5_sk_staff (var e)) staff) (sem-edge-tv (var g) (L3-06_5_keeper_die_staff_rule_p1 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L3-06_5_keeper_die_staff_rule_p2 (var e1) (var e2) (var e3)) Agent (L3-06_5_sk_staff (var e)) the_council) (sem-edge-tv (var g) (L3-06_5_keeper_die_staff_rule_p2 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L3-06_5_keeper_die_staff_rule_p3 (var e1) (var e2) (var e3)) Object (L3-06_5_sk_staff (var e)) (L3-06_5_sk_station (var k))) (sem-edge-tv (var g) (L3-06_5_keeper_die_staff_rule_p3 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L3-06_5_keeper_die_staff_rule_p4 (var e1) (var e2) (var e3)) Member (L3-06_5_sk_station (var k)) station) (sem-edge-tv (var g) (L3-06_5_keeper_die_staff_rule_p4 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L3-06_5_keeper_die_staff_rule_p5 (var e1) (var e2) (var e3)) Possession (L3-06_5_sk_station (var k)) (var k)) (sem-edge-tv (var g) (L3-06_5_keeper_die_staff_rule_p5 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L3-06_5_keeper_die_staff_rule_p6 (var e1) (var e2) (var e3)) Again (L3-06_5_sk_staff (var e))) (sem-edge-tv (var g) (L3-06_5_keeper_die_staff_rule_p6 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L3-06_5_keeper_die_staff_rule_p7 (var e1) (var e2) (var e3)) During (L3-06_5_sk_staff (var e)) (var e)) (sem-edge-tv (var g) (L3-06_5_keeper_die_staff_rule_p7 (var e1) (var e2) (var e3)) (STV 1.0 0.9))))

; --- L3-06.6: Letters from neighbouring villages are read aloud by the Council.
(sem-rule L3-06_6_letters_read_rule)
(rule-context L3-06_6_letters_read_rule aelmere-lore)
(rule-priority L3-06_6_letters_read_rule 142)
(rule-tv L3-06_6_letters_read_rule authored 0.9 0.9)
(rule-lhs L3-06_6_letters_read_rule ((sem-edge (var g) (var e1) Member (var x) letter) (sem-edge (var g) (var e2) From (var x) (var v)) (sem-edge (var g) (var e3) Member (var v) village) (sem-edge (var g) (var e4) Member (var v) neighbouring)))
(rule-rhs L3-06_6_letters_read_rule ((sem-edge (var g) (L3-06_6_letters_read_rule_p1 (var e1) (var e2) (var e3) (var e4)) Member (L3-06_6_sk_read (var x)) read) (sem-edge-tv (var g) (L3-06_6_letters_read_rule_p1 (var e1) (var e2) (var e3) (var e4)) (STV 0.9 0.9)) (sem-edge (var g) (L3-06_6_letters_read_rule_p2 (var e1) (var e2) (var e3) (var e4)) Agent (L3-06_6_sk_read (var x)) the_council) (sem-edge-tv (var g) (L3-06_6_letters_read_rule_p2 (var e1) (var e2) (var e3) (var e4)) (STV 0.9 0.9)) (sem-edge (var g) (L3-06_6_letters_read_rule_p3 (var e1) (var e2) (var e3) (var e4)) Object (L3-06_6_sk_read (var x)) (var x)) (sem-edge-tv (var g) (L3-06_6_letters_read_rule_p3 (var e1) (var e2) (var e3) (var e4)) (STV 0.9 0.9)) (sem-edge (var g) (L3-06_6_letters_read_rule_p4 (var e1) (var e2) (var e3) (var e4)) Manner (L3-06_6_sk_read (var x)) aloud) (sem-edge-tv (var g) (L3-06_6_letters_read_rule_p4 (var e1) (var e2) (var e3) (var e4)) (STV 0.9 0.9))))

; --- L3-08.3: The Council decides all Keeper matters.
(sem-rule L3-08_3_decide_rule)
(rule-context L3-08_3_decide_rule aelmere-lore)
(rule-priority L3-08_3_decide_rule 143)
(rule-tv L3-08_3_decide_rule authored 1.0 0.9)
(rule-lhs L3-08_3_decide_rule ((sem-edge (var g) (var e1) Member (var x) keeper_matter)))
(rule-rhs L3-08_3_decide_rule ((sem-edge (var g) (L3-08_3_decide_rule_p1 (var e1)) Member (L3-08_3_sk_decide (var x)) decide) (sem-edge-tv (var g) (L3-08_3_decide_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L3-08_3_decide_rule_p2 (var e1)) Agent (L3-08_3_sk_decide (var x)) the_council) (sem-edge-tv (var g) (L3-08_3_decide_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L3-08_3_decide_rule_p3 (var e1)) Object (L3-08_3_sk_decide (var x)) (var x)) (sem-edge-tv (var g) (L3-08_3_decide_rule_p3 (var e1)) (STV 1.0 0.9))))

; --- L3-10.2: No wraith emerged in the near-miss winters.
(sem-rule L3-10_2_wraith_no_emerge)
(rule-context L3-10_2_wraith_no_emerge aelmere-lore)
(rule-priority L3-10_2_wraith_no_emerge 144)
(rule-tv L3-10_2_wraith_no_emerge authored 0.0 0.9)
(rule-lhs L3-10_2_wraith_no_emerge ((sem-edge (var g) (var e1) Member (var x) wraith)))
(rule-rhs L3-10_2_wraith_no_emerge ((sem-edge (var g) (L3-10_2_wraith_no_emerge_p1 (var e1)) And (Member (L3-10_2_sk_emerge (var x)) emerge) (Agent (L3-10_2_sk_emerge (var x)) (var x)) (Time (L3-10_2_sk_emerge (var x)) L3-10_2_sk_winters_1)) (sem-edge-tv (var g) (L3-10_2_wraith_no_emerge_p1 (var e1)) (STV 0.0 0.9))))

; --- L3-10.3: Apprentices study the near-miss winters.
(sem-rule L3-10_3_l268_study_rule)
(rule-context L3-10_3_l268_study_rule aelmere-lore)
(rule-priority L3-10_3_l268_study_rule 145)
(rule-tv L3-10_3_l268_study_rule authored 0.9 0.9)
(rule-lhs L3-10_3_l268_study_rule ((sem-edge (var g) (var e1) Member (var x) apprentice)))
(rule-rhs L3-10_3_l268_study_rule ((sem-edge (var g) (L3-10_3_l268_study_rule_p1 (var e1)) Member (L3-10_3_sk_study (var x)) study) (sem-edge-tv (var g) (L3-10_3_l268_study_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L3-10_3_l268_study_rule_p2 (var e1)) Agent (L3-10_3_sk_study (var x)) (var x)) (sem-edge-tv (var g) (L3-10_3_l268_study_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L3-10_3_l268_study_rule_p3 (var e1)) Object (L3-10_3_sk_study (var x)) L3-10_3_sk_winter_1) (sem-edge-tv (var g) (L3-10_3_l268_study_rule_p3 (var e1)) (STV 0.9 0.9))))

; --- L3-11.1: Villages on this coast do not keep lanterns.
(sem-rule L3-11_1_villages_no_keep_lanterns)
(rule-context L3-11_1_villages_no_keep_lanterns aelmere-lore)
(rule-priority L3-11_1_villages_no_keep_lanterns 146)
(rule-tv L3-11_1_villages_no_keep_lanterns authored 0.0 0.9)
(rule-lhs L3-11_1_villages_no_keep_lanterns ((sem-edge (var g) (var e1) Member (var x) village) (sem-edge (var g) (var e2) AttachedTo (var x) the_coast)))
(rule-rhs L3-11_1_villages_no_keep_lanterns ((sem-edge (var g) (L3-11_1_villages_no_keep_lanterns_p1 (var e1) (var e2)) And (Member (L3-11_1_sk_keep (var x)) keep) (Agent (L3-11_1_sk_keep (var x)) (var x)) (Object (L3-11_1_sk_keep (var x)) lantern)) (sem-edge-tv (var g) (L3-11_1_villages_no_keep_lanterns_p1 (var e1) (var e2)) (STV 0.0 0.9))))

; --- L3-11.4: Keepers from Aelmere exchange letters with the lantern-keepers of Faltern.
(sem-rule L3-11_4_keepers_exchange)
(rule-context L3-11_4_keepers_exchange aelmere-lore)
(rule-priority L3-11_4_keepers_exchange 147)
(rule-tv L3-11_4_keepers_exchange authored 0.9 0.9)
(rule-lhs L3-11_4_keepers_exchange ((sem-edge (var g) (var e1) Member (var x) keeper) (sem-edge (var g) (var e2) From (var x) aelmere)))
(rule-rhs L3-11_4_keepers_exchange ((sem-edge (var g) (L3-11_4_keepers_exchange_p1 (var e1) (var e2)) Member (L3-11_4_sk_exchange (var x)) exchange) (sem-edge-tv (var g) (L3-11_4_keepers_exchange_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L3-11_4_keepers_exchange_p2 (var e1) (var e2)) Agent (L3-11_4_sk_exchange (var x)) (var x)) (sem-edge-tv (var g) (L3-11_4_keepers_exchange_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L3-11_4_keepers_exchange_p3 (var e1) (var e2)) Agent (L3-11_4_sk_exchange (var x)) L3-11_4_sk_lkeepers_1) (sem-edge-tv (var g) (L3-11_4_keepers_exchange_p3 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L3-11_4_keepers_exchange_p4 (var e1) (var e2)) Object (L3-11_4_sk_exchange (var x)) letter) (sem-edge-tv (var g) (L3-11_4_keepers_exchange_p4 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L4-01.1: Keepers sleep during the day.
(sem-rule L4-01_1_keeper_sleep_rule)
(rule-context L4-01_1_keeper_sleep_rule aelmere-lore)
(rule-priority L4-01_1_keeper_sleep_rule 148)
(rule-tv L4-01_1_keeper_sleep_rule authored 0.9 0.9)
(rule-lhs L4-01_1_keeper_sleep_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L4-01_1_keeper_sleep_rule ((sem-edge (var g) (L4-01_1_keeper_sleep_rule_p1 (var e1)) Member (L4-01_1_sk_sleep (var x)) sleep) (sem-edge-tv (var g) (L4-01_1_keeper_sleep_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L4-01_1_keeper_sleep_rule_p2 (var e1)) Agent (L4-01_1_sk_sleep (var x)) (var x)) (sem-edge-tv (var g) (L4-01_1_keeper_sleep_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L4-01_1_keeper_sleep_rule_p3 (var e1)) Time (L4-01_1_sk_sleep (var x)) day) (sem-edge-tv (var g) (L4-01_1_keeper_sleep_rule_p3 (var e1)) (STV 0.9 0.9))))

; --- L4-01.5: Each Keeper eats a small meal at sundown before the shift.
(sem-rule L4-01_5_keeper_eat_rule)
(rule-context L4-01_5_keeper_eat_rule aelmere-lore)
(rule-priority L4-01_5_keeper_eat_rule 149)
(rule-tv L4-01_5_keeper_eat_rule authored 1.0 0.9)
(rule-lhs L4-01_5_keeper_eat_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L4-01_5_keeper_eat_rule ((sem-edge (var g) (L4-01_5_keeper_eat_rule_p1 (var e1)) Member (L4-01_5_sk_eat (var x)) eat) (sem-edge-tv (var g) (L4-01_5_keeper_eat_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-01_5_keeper_eat_rule_p2 (var e1)) Agent (L4-01_5_sk_eat (var x)) (var x)) (sem-edge-tv (var g) (L4-01_5_keeper_eat_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-01_5_keeper_eat_rule_p3 (var e1)) Object (L4-01_5_sk_eat (var x)) (L4-01_5_sk_meal (var x))) (sem-edge-tv (var g) (L4-01_5_keeper_eat_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-01_5_keeper_eat_rule_p4 (var e1)) Member (L4-01_5_sk_meal (var x)) meal) (sem-edge-tv (var g) (L4-01_5_keeper_eat_rule_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-01_5_keeper_eat_rule_p5 (var e1)) Member (L4-01_5_sk_meal (var x)) small) (sem-edge-tv (var g) (L4-01_5_keeper_eat_rule_p5 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-01_5_keeper_eat_rule_p6 (var e1)) Time (L4-01_5_sk_eat (var x)) sundown) (sem-edge-tv (var g) (L4-01_5_keeper_eat_rule_p6 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-01_5_keeper_eat_rule_p7 (var e1)) Member (L4-01_5_sk_shift (var x)) shift) (sem-edge-tv (var g) (L4-01_5_keeper_eat_rule_p7 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-01_5_keeper_eat_rule_p8 (var e1)) Before (L4-01_5_sk_eat (var x)) (L4-01_5_sk_shift (var x))) (sem-edge-tv (var g) (L4-01_5_keeper_eat_rule_p8 (var e1)) (STV 1.0 0.9))))

; --- L4-01.6: Each Keeper carries the leather case to the station at sundown.
(sem-rule L4-01_6_kpr_rule)
(rule-context L4-01_6_kpr_rule aelmere-lore)
(rule-priority L4-01_6_kpr_rule 150)
(rule-tv L4-01_6_kpr_rule authored 1.0 0.9)
(rule-lhs L4-01_6_kpr_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L4-01_6_kpr_rule ((sem-edge (var g) (L4-01_6_kpr_rule_p1 (var e1)) Member (L4-01_6_sk_carry (var x)) carry) (sem-edge-tv (var g) (L4-01_6_kpr_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-01_6_kpr_rule_p2 (var e1)) Agent (L4-01_6_sk_carry (var x)) (var x)) (sem-edge-tv (var g) (L4-01_6_kpr_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-01_6_kpr_rule_p3 (var e1)) Object (L4-01_6_sk_carry (var x)) L4-01_6_sk_case_1) (sem-edge-tv (var g) (L4-01_6_kpr_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-01_6_kpr_rule_p4 (var e1)) Goal (L4-01_6_sk_carry (var x)) L4-01_6_sk_station_1) (sem-edge-tv (var g) (L4-01_6_kpr_rule_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-01_6_kpr_rule_p5 (var e1)) Time (L4-01_6_sk_carry (var x)) sundown) (sem-edge-tv (var g) (L4-01_6_kpr_rule_p5 (var e1)) (STV 1.0 0.9))))

; --- L4-01.7: Each apprentice walks to the station with a senior Keeper.
(sem-rule L4-01_7_apprentice_walk_rule)
(rule-context L4-01_7_apprentice_walk_rule aelmere-lore)
(rule-priority L4-01_7_apprentice_walk_rule 151)
(rule-tv L4-01_7_apprentice_walk_rule authored 1.0 0.9)
(rule-lhs L4-01_7_apprentice_walk_rule ((sem-edge (var g) (var e1) Member (var x) apprentice)))
(rule-rhs L4-01_7_apprentice_walk_rule ((sem-edge (var g) (L4-01_7_apprentice_walk_rule_p1 (var e1)) Member (L4-01_7_sk_walk (var x)) walk) (sem-edge-tv (var g) (L4-01_7_apprentice_walk_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-01_7_apprentice_walk_rule_p2 (var e1)) Agent (L4-01_7_sk_walk (var x)) (var x)) (sem-edge-tv (var g) (L4-01_7_apprentice_walk_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-01_7_apprentice_walk_rule_p3 (var e1)) Goal (L4-01_7_sk_walk (var x)) L4-01_7_sk_station_1) (sem-edge-tv (var g) (L4-01_7_apprentice_walk_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-01_7_apprentice_walk_rule_p4 (var e1)) CoAgent (L4-01_7_sk_walk (var x)) (L4-01_7_sk_keeper (var x))) (sem-edge-tv (var g) (L4-01_7_apprentice_walk_rule_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-01_7_apprentice_walk_rule_p5 (var e1)) Member (L4-01_7_sk_keeper (var x)) senior_keeper) (sem-edge-tv (var g) (L4-01_7_apprentice_walk_rule_p5 (var e1)) (STV 1.0 0.9))))

; --- L4-02.3: Replacement lanterns do not need a touch from the Council.
(sem-rule L4-02_3_rl_no_need)
(rule-context L4-02_3_rl_no_need aelmere-lore)
(rule-priority L4-02_3_rl_no_need 152)
(rule-tv L4-02_3_rl_no_need authored 0.0 0.9)
(rule-lhs L4-02_3_rl_no_need ((sem-edge (var g) (var e1) Member (var x) replacement_lantern)))
(rule-rhs L4-02_3_rl_no_need ((sem-edge (var g) (L4-02_3_rl_no_need_p1 (var e1)) And (Member (L4-02_3_sk_need (var x)) need) (Experiencer (L4-02_3_sk_need (var x)) (var x)) (Stimulus (L4-02_3_sk_need (var x)) (L4-02_3_sk_touch (var x))) (Member (L4-02_3_sk_touch (var x)) touch) (From (L4-02_3_sk_touch (var x)) the_council)) (sem-edge-tv (var g) (L4-02_3_rl_no_need_p1 (var e1)) (STV 0.0 0.9))))

; --- L4-03.4: When a station needs warding, the Keeper scatters ground feathers around the lantern.
(sem-rule L4-03_4_warding_rule)
(rule-context L4-03_4_warding_rule aelmere-lore)
(rule-priority L4-03_4_warding_rule 153)
(rule-tv L4-03_4_warding_rule authored 1.0 0.9)
(rule-lhs L4-03_4_warding_rule ((sem-edge (var g) (var e1) Member (var s) station) (sem-edge (var g) (var e2) Member (var e) need) (sem-edge (var g) (var e3) Experiencer (var e) (var s)) (sem-edge (var g) (var e4) Stimulus (var e) (var t1)) (sem-edge (var g) (var e5) Member (var t1) warding)))
(rule-rhs L4-03_4_warding_rule ((sem-edge (var g) (L4-03_4_warding_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (L4-03_4_sk_scatter (var e)) scatter) (sem-edge-tv (var g) (L4-03_4_warding_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L4-03_4_warding_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Agent (L4-03_4_sk_scatter (var e)) L4-03_4_sk_keeper_1) (sem-edge-tv (var g) (L4-03_4_warding_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L4-03_4_warding_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Object (L4-03_4_sk_scatter (var e)) (L4-03_4_sk_feathers (var e))) (sem-edge-tv (var g) (L4-03_4_warding_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L4-03_4_warding_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (L4-03_4_sk_feathers (var e)) feather) (sem-edge-tv (var g) (L4-03_4_warding_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L4-03_4_warding_rule_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (L4-03_4_sk_feathers (var e)) ground) (sem-edge-tv (var g) (L4-03_4_warding_rule_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L4-03_4_warding_rule_p6 (var e1) (var e2) (var e3) (var e4) (var e5)) Location (L4-03_4_sk_scatter (var e)) L4-03_4_sk_lantern_1) (sem-edge-tv (var g) (L4-03_4_warding_rule_p6 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L4-03_4_warding_rule_p7 (var e1) (var e2) (var e3) (var e4) (var e5)) During (L4-03_4_sk_scatter (var e)) (var e)) (sem-edge-tv (var g) (L4-03_4_warding_rule_p7 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- L4-04.4: Wicks carbonize over a long burn.
(sem-rule L4-04_4_wick_carbonize_rule)
(rule-context L4-04_4_wick_carbonize_rule aelmere-lore)
(rule-priority L4-04_4_wick_carbonize_rule 154)
(rule-tv L4-04_4_wick_carbonize_rule authored 0.9 0.9)
(rule-lhs L4-04_4_wick_carbonize_rule ((sem-edge (var g) (var e1) Member (var x) wick)))
(rule-rhs L4-04_4_wick_carbonize_rule ((sem-edge (var g) (L4-04_4_wick_carbonize_rule_p1 (var e1)) Member (L4-04_4_sk_carbonize (var x)) carbonize) (sem-edge-tv (var g) (L4-04_4_wick_carbonize_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L4-04_4_wick_carbonize_rule_p2 (var e1)) Object (L4-04_4_sk_carbonize (var x)) (var x)) (sem-edge-tv (var g) (L4-04_4_wick_carbonize_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L4-04_4_wick_carbonize_rule_p3 (var e1)) Member (L4-04_4_sk_burn (var x)) burn) (sem-edge-tv (var g) (L4-04_4_wick_carbonize_rule_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L4-04_4_wick_carbonize_rule_p4 (var e1)) Member (L4-04_4_sk_burn (var x)) long) (sem-edge-tv (var g) (L4-04_4_wick_carbonize_rule_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L4-04_4_wick_carbonize_rule_p5 (var e1)) Over (L4-04_4_sk_carbonize (var x)) (L4-04_4_sk_burn (var x))) (sem-edge-tv (var g) (L4-04_4_wick_carbonize_rule_p5 (var e1)) (STV 0.9 0.9))))

; --- L4-08.7: On Lantern-night every Keeper tends a station.
(sem-rule L4-08_7_keeper_tend_rule)
(rule-context L4-08_7_keeper_tend_rule aelmere-lore)
(rule-priority L4-08_7_keeper_tend_rule 155)
(rule-tv L4-08_7_keeper_tend_rule authored 1.0 0.9)
(rule-lhs L4-08_7_keeper_tend_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L4-08_7_keeper_tend_rule ((sem-edge (var g) (L4-08_7_keeper_tend_rule_p1 (var e1)) Member (L4-08_7_sk_tend (var x)) tend) (sem-edge-tv (var g) (L4-08_7_keeper_tend_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-08_7_keeper_tend_rule_p2 (var e1)) Agent (L4-08_7_sk_tend (var x)) (var x)) (sem-edge-tv (var g) (L4-08_7_keeper_tend_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-08_7_keeper_tend_rule_p3 (var e1)) Object (L4-08_7_sk_tend (var x)) (L4-08_7_sk_station (var x))) (sem-edge-tv (var g) (L4-08_7_keeper_tend_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-08_7_keeper_tend_rule_p4 (var e1)) Member (L4-08_7_sk_station (var x)) station) (sem-edge-tv (var g) (L4-08_7_keeper_tend_rule_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-08_7_keeper_tend_rule_p5 (var e1)) Time (L4-08_7_sk_tend (var x)) lantern_night) (sem-edge-tv (var g) (L4-08_7_keeper_tend_rule_p5 (var e1)) (STV 1.0 0.9))))

; --- L4-08.8: On Lantern-night every villager walks the Cliff Path at midnight.
(sem-rule L4-08_8_r1_rule)
(rule-context L4-08_8_r1_rule aelmere-lore)
(rule-priority L4-08_8_r1_rule 156)
(rule-tv L4-08_8_r1_rule authored 1.0 0.9)
(rule-lhs L4-08_8_r1_rule ((sem-edge (var g) (var e1) Member (var x) villager)))
(rule-rhs L4-08_8_r1_rule ((sem-edge (var g) (L4-08_8_r1_rule_p1 (var e1)) Member (L4-08_8_sk_walk (var x)) walk) (sem-edge-tv (var g) (L4-08_8_r1_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-08_8_r1_rule_p2 (var e1)) Agent (L4-08_8_sk_walk (var x)) (var x)) (sem-edge-tv (var g) (L4-08_8_r1_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-08_8_r1_rule_p3 (var e1)) Object (L4-08_8_sk_walk (var x)) cliff_path) (sem-edge-tv (var g) (L4-08_8_r1_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-08_8_r1_rule_p4 (var e1)) Time (L4-08_8_sk_walk (var x)) lantern_night) (sem-edge-tv (var g) (L4-08_8_r1_rule_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L4-08_8_r1_rule_p5 (var e1)) Time (L4-08_8_sk_walk (var x)) midnight) (sem-edge-tv (var g) (L4-08_8_r1_rule_p5 (var e1)) (STV 1.0 0.9))))

; --- L4-09.1: Children learn the names of the lantern-stations by heart.
(sem-rule L4-09_1_children_learn)
(rule-context L4-09_1_children_learn aelmere-lore)
(rule-priority L4-09_1_children_learn 157)
(rule-tv L4-09_1_children_learn authored 0.9 0.9)
(rule-lhs L4-09_1_children_learn ((sem-edge (var g) (var e1) Member (var x) child)))
(rule-rhs L4-09_1_children_learn ((sem-edge (var g) (L4-09_1_children_learn_p1 (var e1)) Member (L4-09_1_sk_learn (var x)) learn) (sem-edge-tv (var g) (L4-09_1_children_learn_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L4-09_1_children_learn_p2 (var e1)) Agent (L4-09_1_sk_learn (var x)) (var x)) (sem-edge-tv (var g) (L4-09_1_children_learn_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L4-09_1_children_learn_p3 (var e1)) Object (L4-09_1_sk_learn (var x)) L4-09_1_sk_names_1) (sem-edge-tv (var g) (L4-09_1_children_learn_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L4-09_1_children_learn_p4 (var e1)) By (L4-09_1_sk_learn (var x)) heart) (sem-edge-tv (var g) (L4-09_1_children_learn_p4 (var e1)) (STV 0.9 0.9))))

; --- L4-09.2: Children chant the station names in games.
(sem-rule L4-09_2_children_chant_rule)
(rule-context L4-09_2_children_chant_rule aelmere-lore)
(rule-priority L4-09_2_children_chant_rule 158)
(rule-tv L4-09_2_children_chant_rule authored 0.9 0.9)
(rule-lhs L4-09_2_children_chant_rule ((sem-edge (var g) (var e1) Member (var x) child)))
(rule-rhs L4-09_2_children_chant_rule ((sem-edge (var g) (L4-09_2_children_chant_rule_p1 (var e1)) Member (L4-09_2_sk_chant (var x)) chant) (sem-edge-tv (var g) (L4-09_2_children_chant_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L4-09_2_children_chant_rule_p2 (var e1)) Agent (L4-09_2_sk_chant (var x)) (var x)) (sem-edge-tv (var g) (L4-09_2_children_chant_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L4-09_2_children_chant_rule_p3 (var e1)) Object (L4-09_2_sk_chant (var x)) L4-09_2_sk_name_1) (sem-edge-tv (var g) (L4-09_2_children_chant_rule_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L4-09_2_children_chant_rule_p4 (var e1)) In (L4-09_2_sk_chant (var x)) game) (sem-edge-tv (var g) (L4-09_2_children_chant_rule_p4 (var e1)) (STV 0.9 0.9))))

; --- L4-09.3: Keepers often marry into fisher families.
(sem-rule L4-09_3_keeper_marry_rule)
(rule-context L4-09_3_keeper_marry_rule aelmere-lore)
(rule-priority L4-09_3_keeper_marry_rule 159)
(rule-tv L4-09_3_keeper_marry_rule authored 0.8 0.9)
(rule-lhs L4-09_3_keeper_marry_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L4-09_3_keeper_marry_rule ((sem-edge (var g) (L4-09_3_keeper_marry_rule_p1 (var e1)) Member (L4-09_3_sk_marry (var x)) marry) (sem-edge-tv (var g) (L4-09_3_keeper_marry_rule_p1 (var e1)) (STV 0.8 0.9)) (sem-edge (var g) (L4-09_3_keeper_marry_rule_p2 (var e1)) Agent (L4-09_3_sk_marry (var x)) (var x)) (sem-edge-tv (var g) (L4-09_3_keeper_marry_rule_p2 (var e1)) (STV 0.8 0.9)) (sem-edge (var g) (L4-09_3_keeper_marry_rule_p3 (var e1)) Into (L4-09_3_sk_marry (var x)) (L4-09_3_sk_family (var x))) (sem-edge-tv (var g) (L4-09_3_keeper_marry_rule_p3 (var e1)) (STV 0.8 0.9)) (sem-edge (var g) (L4-09_3_keeper_marry_rule_p4 (var e1)) Member (L4-09_3_sk_family (var x)) fisher_family) (sem-edge-tv (var g) (L4-09_3_keeper_marry_rule_p4 (var e1)) (STV 0.8 0.9))))

; --- L4-09.4: Whenever a Keeper marries a member of a fisher family, that Keeper keeps the station.
(sem-rule L4-09_4_keeper_marry_rule)
(rule-context L4-09_4_keeper_marry_rule aelmere-lore)
(rule-priority L4-09_4_keeper_marry_rule 160)
(rule-tv L4-09_4_keeper_marry_rule authored 1.0 0.9)
(rule-lhs L4-09_4_keeper_marry_rule ((sem-edge (var g) (var e1) Member (var k) keeper) (sem-edge (var g) (var e2) Member (var e) marry) (sem-edge (var g) (var e3) Agent (var e) (var k)) (sem-edge (var g) (var e4) Object (var e) (var m)) (sem-edge (var g) (var e5) Member (var f) fisher_family) (sem-edge (var g) (var e6) PartOf (var m) (var f))))
(rule-rhs L4-09_4_keeper_marry_rule ((sem-edge (var g) (L4-09_4_keeper_marry_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (L4-09_4_sk_keep (var e)) keep) (sem-edge-tv (var g) (L4-09_4_keeper_marry_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L4-09_4_keeper_marry_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Agent (L4-09_4_sk_keep (var e)) (var k)) (sem-edge-tv (var g) (L4-09_4_keeper_marry_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L4-09_4_keeper_marry_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Object (L4-09_4_sk_keep (var e)) L4-09_4_sk_station_1) (sem-edge-tv (var g) (L4-09_4_keeper_marry_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L4-09_4_keeper_marry_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) During (L4-09_4_sk_keep (var e)) (var e)) (sem-edge-tv (var g) (L4-09_4_keeper_marry_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9))))

; --- L4-09.5: The children of any Keeper may apprentice.
(sem-rule L4-09_5_keeper_apprentice_rule)
(rule-context L4-09_5_keeper_apprentice_rule aelmere-lore)
(rule-priority L4-09_5_keeper_apprentice_rule 161)
(rule-tv L4-09_5_keeper_apprentice_rule authored 1.0 0.99)
(rule-lhs L4-09_5_keeper_apprentice_rule ((sem-edge (var g) (var e1) Member (var k) keeper) (sem-edge (var g) (var e2) Member (var c) child) (sem-edge (var g) (var e3) Possession (var c) (var k))))
(rule-rhs L4-09_5_keeper_apprentice_rule ((sem-edge (var g) (L4-09_5_keeper_apprentice_rule_p1 (var e1) (var e2) (var e3)) Member (L4-09_5_sk_apprentice (var c)) apprentice) (sem-edge-tv (var g) (L4-09_5_keeper_apprentice_rule_p1 (var e1) (var e2) (var e3)) (STV 1.0 0.99)) (sem-edge (var g) (L4-09_5_keeper_apprentice_rule_p2 (var e1) (var e2) (var e3)) Agent (L4-09_5_sk_apprentice (var c)) (var c)) (sem-edge-tv (var g) (L4-09_5_keeper_apprentice_rule_p2 (var e1) (var e2) (var e3)) (STV 1.0 0.99)) (sem-edge (var g) (L4-09_5_keeper_apprentice_rule_p3 (var e1) (var e2) (var e3)) Permitted (L4-09_5_sk_apprentice (var c))) (sem-edge-tv (var g) (L4-09_5_keeper_apprentice_rule_p3 (var e1) (var e2) (var e3)) (STV 1.0 0.99))))

; --- L4-10.2: There are no graves in Aelmere.
(sem-rule L4-10_2_no_grave_aelmere)
(rule-context L4-10_2_no_grave_aelmere aelmere-lore)
(rule-priority L4-10_2_no_grave_aelmere 162)
(rule-tv L4-10_2_no_grave_aelmere authored 0.0 0.9)
(rule-lhs L4-10_2_no_grave_aelmere ((sem-edge (var g) (var e1) Member (var x) grave)))
(rule-rhs L4-10_2_no_grave_aelmere ((sem-edge (var g) (L4-10_2_no_grave_aelmere_p1 (var e1)) And (LocatedIn (var x) aelmere)) (sem-edge-tv (var g) (L4-10_2_no_grave_aelmere_p1 (var e1)) (STV 0.0 0.9))))

; --- L4-11.1: Non-Keeper villagers avoid the Sunken Cove.
(sem-rule L4-11_1_villager_avoid)
(rule-context L4-11_1_villager_avoid aelmere-lore)
(rule-priority L4-11_1_villager_avoid 163)
(rule-tv L4-11_1_villager_avoid authored 0.9 0.9)
(rule-lhs L4-11_1_villager_avoid ((sem-edge (var g) (var e1) Member (var x) villager) (sem-edge (var g) (var e2) Member (var x) non_keeper)))
(rule-rhs L4-11_1_villager_avoid ((sem-edge (var g) (L4-11_1_villager_avoid_p1 (var e1) (var e2)) Member (L4-11_1_sk_avoid (var x)) avoid) (sem-edge-tv (var g) (L4-11_1_villager_avoid_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L4-11_1_villager_avoid_p2 (var e1) (var e2)) Agent (L4-11_1_sk_avoid (var x)) (var x)) (sem-edge-tv (var g) (L4-11_1_villager_avoid_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L4-11_1_villager_avoid_p3 (var e1) (var e2)) Object (L4-11_1_sk_avoid (var x)) sunken_cove) (sem-edge-tv (var g) (L4-11_1_villager_avoid_p3 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L4-11.4: Parents scold children who play near the Cove Stair.
(sem-rule L4-11_4_parents_scold_rule)
(rule-context L4-11_4_parents_scold_rule aelmere-lore)
(rule-priority L4-11_4_parents_scold_rule 164)
(rule-tv L4-11_4_parents_scold_rule authored 0.9 0.9)
(rule-lhs L4-11_4_parents_scold_rule ((sem-edge (var g) (var e1) Member (var p) parent) (sem-edge (var g) (var e2) Member (var c) child) (sem-edge (var g) (var e3) Member (var e) play) (sem-edge (var g) (var e4) Agent (var e) (var c)) (sem-edge (var g) (var e5) Location (var e) cove_stair)))
(rule-rhs L4-11_4_parents_scold_rule ((sem-edge (var g) (L4-11_4_parents_scold_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (L4-11_4_sk_scold (var p) (var c)) scold) (sem-edge-tv (var g) (L4-11_4_parents_scold_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 0.9 0.9)) (sem-edge (var g) (L4-11_4_parents_scold_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Agent (L4-11_4_sk_scold (var p) (var c)) (var p)) (sem-edge-tv (var g) (L4-11_4_parents_scold_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 0.9 0.9)) (sem-edge (var g) (L4-11_4_parents_scold_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Object (L4-11_4_sk_scold (var p) (var c)) (var c)) (sem-edge-tv (var g) (L4-11_4_parents_scold_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 0.9 0.9))))

; --- L4-12.4: Keepers carry a notched candle for time-keeping.
(sem-rule L4-12_4_lo31_rule)
(rule-context L4-12_4_lo31_rule aelmere-lore)
(rule-priority L4-12_4_lo31_rule 165)
(rule-tv L4-12_4_lo31_rule authored 0.9 0.9)
(rule-lhs L4-12_4_lo31_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L4-12_4_lo31_rule ((sem-edge (var g) (L4-12_4_lo31_rule_p1 (var e1)) Member (L4-12_4_sk_carry (var x)) carry) (sem-edge-tv (var g) (L4-12_4_lo31_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L4-12_4_lo31_rule_p2 (var e1)) Agent (L4-12_4_sk_carry (var x)) (var x)) (sem-edge-tv (var g) (L4-12_4_lo31_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L4-12_4_lo31_rule_p3 (var e1)) Object (L4-12_4_sk_carry (var x)) (L4-12_4_sk_candle (var x))) (sem-edge-tv (var g) (L4-12_4_lo31_rule_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L4-12_4_lo31_rule_p4 (var e1)) Member (L4-12_4_sk_candle (var x)) candle) (sem-edge-tv (var g) (L4-12_4_lo31_rule_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L4-12_4_lo31_rule_p5 (var e1)) Member (L4-12_4_sk_candle (var x)) notched) (sem-edge-tv (var g) (L4-12_4_lo31_rule_p5 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L4-12_4_lo31_rule_p6 (var e1)) For (L4-12_4_sk_candle (var x)) L4-12_4_sk_keep_1) (sem-edge-tv (var g) (L4-12_4_lo31_rule_p6 (var e1)) (STV 0.9 0.9))))

; --- L5-02.2: Wraiths rise from the water in the Sunken Cove.
(sem-rule L5-02_2_wraiths_rise)
(rule-context L5-02_2_wraiths_rise aelmere-lore)
(rule-priority L5-02_2_wraiths_rise 166)
(rule-tv L5-02_2_wraiths_rise authored 0.9 0.9)
(rule-lhs L5-02_2_wraiths_rise ((sem-edge (var g) (var e1) Member (var x) wraith)))
(rule-rhs L5-02_2_wraiths_rise ((sem-edge (var g) (L5-02_2_wraiths_rise_p1 (var e1)) Member (L5-02_2_sk_rise (var x)) rise) (sem-edge-tv (var g) (L5-02_2_wraiths_rise_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-02_2_wraiths_rise_p2 (var e1)) Agent (L5-02_2_sk_rise (var x)) (var x)) (sem-edge-tv (var g) (L5-02_2_wraiths_rise_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-02_2_wraiths_rise_p3 (var e1)) Source (L5-02_2_sk_rise (var x)) L5-02_2_sk_water_1) (sem-edge-tv (var g) (L5-02_2_wraiths_rise_p3 (var e1)) (STV 0.9 0.9))))

; --- L5-02.3: Every Keeper believes that the people who died in the storm-surge became wraiths.
(sem-rule L5-02_3_keeper_believe_rule)
(rule-context L5-02_3_keeper_believe_rule aelmere-lore)
(rule-priority L5-02_3_keeper_believe_rule 167)
(rule-tv L5-02_3_keeper_believe_rule authored 1.0 0.9)
(rule-lhs L5-02_3_keeper_believe_rule ((sem-edge (var g) (var e1) Member (var k) keeper)))
(rule-rhs L5-02_3_keeper_believe_rule ((sem-edge (var g) (L5-02_3_keeper_believe_rule_p1 (var e1)) Member (L5-02_3_sk_believe (var k)) believe) (sem-edge-tv (var g) (L5-02_3_keeper_believe_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L5-02_3_keeper_believe_rule_p2 (var e1)) Experiencer (L5-02_3_sk_believe (var k)) (var k)) (sem-edge-tv (var g) (L5-02_3_keeper_believe_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L5-02_3_keeper_believe_rule_p3 (var e1)) Object (L5-02_3_sk_believe (var k)) (And (Member L5-02_3_sk_die_1 die) (Patient L5-02_3_sk_die_1 L5-02_3_sk_people_1) (Location L5-02_3_sk_die_1 L5-02_3_sk_storm_surge_1) (Past L5-02_3_sk_die_1) (Implication (PartOf (var y) L5-02_3_sk_people_1) (And (Member (L5-02_3_sk_die (var y)) die) (Patient (L5-02_3_sk_die (var y)) (var y)) (Location (L5-02_3_sk_die (var y)) L5-02_3_sk_storm_surge_1) (Past (L5-02_3_sk_die (var y))))) (Member L5-02_3_sk_become_1 become) (Patient L5-02_3_sk_become_1 L5-02_3_sk_people_1) (Past L5-02_3_sk_become_1) (Member L5-02_3_sk_wraith_1 wraith) (Experiencer L5-02_3_sk_wraith_1 L5-02_3_sk_people_1) (Result L5-02_3_sk_become_1 L5-02_3_sk_wraith_1) (Implication (PartOf (var z) L5-02_3_sk_people_1) (Member (var z) wraith)))) (sem-edge-tv (var g) (L5-02_3_keeper_believe_rule_p3 (var e1)) (STV 1.0 0.9))))

; --- L5-03.2: Wraiths drain mire-essence from lit lanterns.
(sem-rule L5-03_2_wraith_drain)
(rule-context L5-03_2_wraith_drain aelmere-lore)
(rule-priority L5-03_2_wraith_drain 168)
(rule-tv L5-03_2_wraith_drain authored 0.9 0.9)
(rule-lhs L5-03_2_wraith_drain ((sem-edge (var g) (var e1) Member (var x) wraith)))
(rule-rhs L5-03_2_wraith_drain ((sem-edge (var g) (L5-03_2_wraith_drain_p1 (var e1)) Member (L5-03_2_sk_drain (var x)) drain) (sem-edge-tv (var g) (L5-03_2_wraith_drain_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-03_2_wraith_drain_p2 (var e1)) Agent (L5-03_2_sk_drain (var x)) (var x)) (sem-edge-tv (var g) (L5-03_2_wraith_drain_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-03_2_wraith_drain_p3 (var e1)) Object (L5-03_2_sk_drain (var x)) mire_essence) (sem-edge-tv (var g) (L5-03_2_wraith_drain_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-03_2_wraith_drain_p4 (var e1)) Source (L5-03_2_sk_drain (var x)) (L5-03_2_sk_lantern (var x))) (sem-edge-tv (var g) (L5-03_2_wraith_drain_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-03_2_wraith_drain_p5 (var e1)) Member (L5-03_2_sk_lantern (var x)) lantern) (sem-edge-tv (var g) (L5-03_2_wraith_drain_p5 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-03_2_wraith_drain_p6 (var e1)) Member (L5-03_2_sk_lantern (var x)) lit) (sem-edge-tv (var g) (L5-03_2_wraith_drain_p6 (var e1)) (STV 0.9 0.9))))

; --- L5-03.3: Drained lanterns burn dimly.
(sem-rule L5-03_3_drained_lantern_burn)
(rule-context L5-03_3_drained_lantern_burn aelmere-lore)
(rule-priority L5-03_3_drained_lantern_burn 169)
(rule-tv L5-03_3_drained_lantern_burn authored 0.9 0.9)
(rule-lhs L5-03_3_drained_lantern_burn ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) Member (var x) drained)))
(rule-rhs L5-03_3_drained_lantern_burn ((sem-edge (var g) (L5-03_3_drained_lantern_burn_p1 (var e1) (var e2)) Member (L5-03_3_sk_burn (var x)) burn) (sem-edge-tv (var g) (L5-03_3_drained_lantern_burn_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L5-03_3_drained_lantern_burn_p2 (var e1) (var e2)) Object (L5-03_3_sk_burn (var x)) (var x)) (sem-edge-tv (var g) (L5-03_3_drained_lantern_burn_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L5-03_3_drained_lantern_burn_p3 (var e1) (var e2)) Manner (L5-03_3_sk_burn (var x)) dimly) (sem-edge-tv (var g) (L5-03_3_drained_lantern_burn_p3 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L5-03.4: Whenever a lantern at the Sunken Cove dies before dawn, a wraith rises from the cove's water.
(sem-rule L5-03_4_whenever_die_rise)
(rule-context L5-03_4_whenever_die_rise aelmere-lore)
(rule-priority L5-03_4_whenever_die_rise 170)
(rule-tv L5-03_4_whenever_die_rise authored 1.0 0.9)
(rule-lhs L5-03_4_whenever_die_rise ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) AttachedTo (var x) sunken_cove) (sem-edge (var g) (var e3) Member (var e1) die) (sem-edge (var g) (var e4) Object (var e1) (var x)) (sem-edge (var g) (var e5) TimeAtMost (var e1) dawn)))
(rule-rhs L5-03_4_whenever_die_rise ((sem-edge (var g) (L5-03_4_whenever_die_rise_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (L5-03_4_sk_rise (var e1)) rise) (sem-edge-tv (var g) (L5-03_4_whenever_die_rise_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L5-03_4_whenever_die_rise_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (L5-03_4_sk_wraith (var e1)) wraith) (sem-edge-tv (var g) (L5-03_4_whenever_die_rise_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L5-03_4_whenever_die_rise_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Agent (L5-03_4_sk_rise (var e1)) (L5-03_4_sk_wraith (var e1))) (sem-edge-tv (var g) (L5-03_4_whenever_die_rise_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L5-03_4_whenever_die_rise_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) Source (L5-03_4_sk_rise (var e1)) L5-03_4_sk_water_1) (sem-edge-tv (var g) (L5-03_4_whenever_die_rise_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L5-03_4_whenever_die_rise_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) During (L5-03_4_sk_rise (var e1)) (var e1)) (sem-edge-tv (var g) (L5-03_4_whenever_die_rise_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- L5-03.5: Keepers know the wraith rule.
(sem-rule L5-03_5_keeper_know)
(rule-context L5-03_5_keeper_know aelmere-lore)
(rule-priority L5-03_5_keeper_know 171)
(rule-tv L5-03_5_keeper_know authored 0.9 0.9)
(rule-lhs L5-03_5_keeper_know ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L5-03_5_keeper_know ((sem-edge (var g) (L5-03_5_keeper_know_p1 (var e1)) Member (L5-03_5_sk_know (var x)) know) (sem-edge-tv (var g) (L5-03_5_keeper_know_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-03_5_keeper_know_p2 (var e1)) Experiencer (L5-03_5_sk_know (var x)) (var x)) (sem-edge-tv (var g) (L5-03_5_keeper_know_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-03_5_keeper_know_p3 (var e1)) Stimulus (L5-03_5_sk_know (var x)) L5-03_5_sk_wraith_rule_1) (sem-edge-tv (var g) (L5-03_5_keeper_know_p3 (var e1)) (STV 0.9 0.9))))

; --- L5-04.1: Wraiths persist for several weeks before they fade back into the cove.
(sem-rule L5-04_1_wraith_persist_fade)
(rule-context L5-04_1_wraith_persist_fade aelmere-lore)
(rule-priority L5-04_1_wraith_persist_fade 172)
(rule-tv L5-04_1_wraith_persist_fade authored 0.9 0.9)
(rule-lhs L5-04_1_wraith_persist_fade ((sem-edge (var g) (var e1) Member (var x) wraith)))
(rule-rhs L5-04_1_wraith_persist_fade ((sem-edge (var g) (L5-04_1_wraith_persist_fade_p1 (var e1)) Member (L5-04_1_sk_persist (var x)) persist) (sem-edge-tv (var g) (L5-04_1_wraith_persist_fade_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-04_1_wraith_persist_fade_p2 (var e1)) Experiencer (L5-04_1_sk_persist (var x)) (var x)) (sem-edge-tv (var g) (L5-04_1_wraith_persist_fade_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-04_1_wraith_persist_fade_p3 (var e1)) MeasureAtLeast (L5-04_1_sk_persist (var x)) duration 2 week) (sem-edge-tv (var g) (L5-04_1_wraith_persist_fade_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-04_1_wraith_persist_fade_p4 (var e1)) Member (L5-04_1_sk_fade (var x)) fade) (sem-edge-tv (var g) (L5-04_1_wraith_persist_fade_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-04_1_wraith_persist_fade_p5 (var e1)) Object (L5-04_1_sk_fade (var x)) (var x)) (sem-edge-tv (var g) (L5-04_1_wraith_persist_fade_p5 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-04_1_wraith_persist_fade_p6 (var e1)) Goal (L5-04_1_sk_fade (var x)) L5-04_1_sk_cove_1) (sem-edge-tv (var g) (L5-04_1_wraith_persist_fade_p6 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-04_1_wraith_persist_fade_p7 (var e1)) Before (L5-04_1_sk_persist (var x)) (L5-04_1_sk_fade (var x))) (sem-edge-tv (var g) (L5-04_1_wraith_persist_fade_p7 (var e1)) (STV 0.9 0.9))))

; --- L5-04.2: Persisting wraiths approach lit lanterns each night.
(sem-rule L5-04_2_lp46_rule)
(rule-context L5-04_2_lp46_rule aelmere-lore)
(rule-priority L5-04_2_lp46_rule 173)
(rule-tv L5-04_2_lp46_rule authored 0.9 0.9)
(rule-lhs L5-04_2_lp46_rule ((sem-edge (var g) (var e1) Member (var x) wraith) (sem-edge (var g) (var e2) Member (var x) persisting)))
(rule-rhs L5-04_2_lp46_rule ((sem-edge (var g) (L5-04_2_lp46_rule_p1 (var e1) (var e2)) Member (L5-04_2_sk_approach (var x)) approach) (sem-edge-tv (var g) (L5-04_2_lp46_rule_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L5-04_2_lp46_rule_p2 (var e1) (var e2)) Agent (L5-04_2_sk_approach (var x)) (var x)) (sem-edge-tv (var g) (L5-04_2_lp46_rule_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L5-04_2_lp46_rule_p3 (var e1) (var e2)) Object (L5-04_2_sk_approach (var x)) (L5-04_2_sk_lantern (var x))) (sem-edge-tv (var g) (L5-04_2_lp46_rule_p3 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L5-04_2_lp46_rule_p4 (var e1) (var e2)) Member (L5-04_2_sk_lantern (var x)) lantern) (sem-edge-tv (var g) (L5-04_2_lp46_rule_p4 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L5-04_2_lp46_rule_p5 (var e1) (var e2)) Member (L5-04_2_sk_lantern (var x)) lit) (sem-edge-tv (var g) (L5-04_2_lp46_rule_p5 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L5-04_2_lp46_rule_p6 (var e1) (var e2)) Time (L5-04_2_sk_approach (var x)) night) (sem-edge-tv (var g) (L5-04_2_lp46_rule_p6 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L5-04_2_lp46_rule_p7 (var e1) (var e2)) Every (L5-04_2_sk_approach (var x)) 1 day) (sem-edge-tv (var g) (L5-04_2_lp46_rule_p7 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L5-04.3: Wraiths drain many lanterns while they persist.
(sem-rule L5-04_3_wraith_drain_rule)
(rule-context L5-04_3_wraith_drain_rule aelmere-lore)
(rule-priority L5-04_3_wraith_drain_rule 174)
(rule-tv L5-04_3_wraith_drain_rule authored 0.9 0.9)
(rule-lhs L5-04_3_wraith_drain_rule ((sem-edge (var g) (var e1) Member (var x) wraith)))
(rule-rhs L5-04_3_wraith_drain_rule ((sem-edge (var g) (L5-04_3_wraith_drain_rule_p1 (var e1)) Member (L5-04_3_sk_drain (var x)) drain) (sem-edge-tv (var g) (L5-04_3_wraith_drain_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-04_3_wraith_drain_rule_p2 (var e1)) Agent (L5-04_3_sk_drain (var x)) (var x)) (sem-edge-tv (var g) (L5-04_3_wraith_drain_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-04_3_wraith_drain_rule_p3 (var e1)) Object (L5-04_3_sk_drain (var x)) (L5-04_3_sk_lanterns (var x))) (sem-edge-tv (var g) (L5-04_3_wraith_drain_rule_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-04_3_wraith_drain_rule_p4 (var e1)) GroupOf (L5-04_3_sk_lanterns (var x)) lantern) (sem-edge-tv (var g) (L5-04_3_wraith_drain_rule_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-04_3_wraith_drain_rule_p5 (var e1)) CardinalityPhrase (L5-04_3_sk_lanterns (var x)) "many") (sem-edge-tv (var g) (L5-04_3_wraith_drain_rule_p5 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-04_3_wraith_drain_rule_p6 (var e1)) Member (L5-04_3_sk_persist (var x)) persist) (sem-edge-tv (var g) (L5-04_3_wraith_drain_rule_p6 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-04_3_wraith_drain_rule_p7 (var e1)) Experiencer (L5-04_3_sk_persist (var x)) (var x)) (sem-edge-tv (var g) (L5-04_3_wraith_drain_rule_p7 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L5-04_3_wraith_drain_rule_p8 (var e1)) During (L5-04_3_sk_drain (var x)) (L5-04_3_sk_persist (var x))) (sem-edge-tv (var g) (L5-04_3_wraith_drain_rule_p8 (var e1)) (STV 0.9 0.9))))

; --- L5-05.1: When a Keeper scatters ground feathers around a lantern, the feathers ward the lantern against wraiths.
(sem-rule L5-05_1_keeper_scatter_wards)
(rule-context L5-05_1_keeper_scatter_wards aelmere-lore)
(rule-priority L5-05_1_keeper_scatter_wards 175)
(rule-tv L5-05_1_keeper_scatter_wards authored 1.0 0.9)
(rule-lhs L5-05_1_keeper_scatter_wards ((sem-edge (var g) (var e1) Member (var k) keeper) (sem-edge (var g) (var e2) Member (var l) lantern) (sem-edge (var g) (var e3) Member (var f) feather) (sem-edge (var g) (var e4) Member (var f) ground) (sem-edge (var g) (var e5) Member (var s) scatter) (sem-edge (var g) (var e6) Agent (var s) (var k)) (sem-edge (var g) (var e7) Object (var s) (var f)) (sem-edge (var g) (var e8) Around (var s) (var l))))
(rule-rhs L5-05_1_keeper_scatter_wards ((sem-edge (var g) (L5-05_1_keeper_scatter_wards_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Member (L5-05_1_sk_ward (var s)) ward) (sem-edge-tv (var g) (L5-05_1_keeper_scatter_wards_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (L5-05_1_keeper_scatter_wards_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Agent (L5-05_1_sk_ward (var s)) (var f)) (sem-edge-tv (var g) (L5-05_1_keeper_scatter_wards_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (L5-05_1_keeper_scatter_wards_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Object (L5-05_1_sk_ward (var s)) (var l)) (sem-edge-tv (var g) (L5-05_1_keeper_scatter_wards_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (L5-05_1_keeper_scatter_wards_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Against (L5-05_1_sk_ward (var s)) wraith) (sem-edge-tv (var g) (L5-05_1_keeper_scatter_wards_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (L5-05_1_keeper_scatter_wards_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) During (L5-05_1_sk_ward (var s)) (var s)) (sem-edge-tv (var g) (L5-05_1_keeper_scatter_wards_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9))))

; --- L5-05.2: Each feather warding lasts about a month.
(sem-rule L5-05_2_fw_last_rule)
(rule-context L5-05_2_fw_last_rule aelmere-lore)
(rule-priority L5-05_2_fw_last_rule 176)
(rule-tv L5-05_2_fw_last_rule authored 1.0 0.9)
(rule-lhs L5-05_2_fw_last_rule ((sem-edge (var g) (var e1) Member (var x) feather_warding)))
(rule-rhs L5-05_2_fw_last_rule ((sem-edge (var g) (L5-05_2_fw_last_rule_p1 (var e1)) Member (L5-05_2_sk_last (var x)) last) (sem-edge-tv (var g) (L5-05_2_fw_last_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L5-05_2_fw_last_rule_p2 (var e1)) Experiencer (L5-05_2_sk_last (var x)) (var x)) (sem-edge-tv (var g) (L5-05_2_fw_last_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L5-05_2_fw_last_rule_p3 (var e1)) Measure (L5-05_2_sk_last (var x)) duration (ParticleFromNormal 1 0.1) month) (sem-edge-tv (var g) (L5-05_2_fw_last_rule_p3 (var e1)) (STV 1.0 0.9))))

; --- L5-05.8: No wraith has ever entered a village house.
(sem-rule L5-05_8_wraith_enter_rule)
(rule-context L5-05_8_wraith_enter_rule aelmere-lore)
(rule-priority L5-05_8_wraith_enter_rule 177)
(rule-tv L5-05_8_wraith_enter_rule authored 0.0 0.9)
(rule-lhs L5-05_8_wraith_enter_rule ((sem-edge (var g) (var e1) Member (var x) wraith)))
(rule-rhs L5-05_8_wraith_enter_rule ((sem-edge (var g) (L5-05_8_wraith_enter_rule_p1 (var e1)) And (Member (L5-05_8_sk_enter (var x)) enter) (Agent (L5-05_8_sk_enter (var x)) (var x)) (Object (L5-05_8_sk_enter (var x)) (L5-05_8_sk_house (var x))) (Member (L5-05_8_sk_house (var x)) village_house) (Past (L5-05_8_sk_enter (var x)))) (sem-edge-tv (var g) (L5-05_8_wraith_enter_rule_p1 (var e1)) (STV 0.0 0.9))))

; --- L5-06.5: Every Keeper considers that the plan was dangerous.
(sem-rule L5-06_5_keeper_consider_rule)
(rule-context L5-06_5_keeper_consider_rule aelmere-lore)
(rule-priority L5-06_5_keeper_consider_rule 178)
(rule-tv L5-06_5_keeper_consider_rule authored 1.0 0.9)
(rule-lhs L5-06_5_keeper_consider_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L5-06_5_keeper_consider_rule ((sem-edge (var g) (L5-06_5_keeper_consider_rule_p1 (var e1)) Member (L5-06_5_sk_consider (var x)) consider) (sem-edge-tv (var g) (L5-06_5_keeper_consider_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L5-06_5_keeper_consider_rule_p2 (var e1)) Experiencer (L5-06_5_sk_consider (var x)) (var x)) (sem-edge-tv (var g) (L5-06_5_keeper_consider_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L5-06_5_keeper_consider_rule_p3 (var e1)) Object (L5-06_5_sk_consider (var x)) (Past (Member L5-06_5_sk_plan_1 dangerous))) (sem-edge-tv (var g) (L5-06_5_keeper_consider_rule_p3 (var e1)) (STV 1.0 0.9))))

; --- L5-07.1: No wraith has emerged in the past twenty-six years.
(sem-rule L5-07_1_wraith_no_emerge)
(rule-context L5-07_1_wraith_no_emerge aelmere-lore)
(rule-priority L5-07_1_wraith_no_emerge 179)
(rule-tv L5-07_1_wraith_no_emerge authored 0.0 0.9)
(rule-lhs L5-07_1_wraith_no_emerge ((sem-edge (var g) (var e1) Member (var x) wraith)))
(rule-rhs L5-07_1_wraith_no_emerge ((sem-edge (var g) (L5-07_1_wraith_no_emerge_p1 (var e1)) And (Member (L5-07_1_sk_emerge (var x)) emerge) (Agent (L5-07_1_sk_emerge (var x)) (var x)) (Past (L5-07_1_sk_emerge (var x))) (WithinLast (L5-07_1_sk_emerge (var x)) 26 year)) (sem-edge-tv (var g) (L5-07_1_wraith_no_emerge_p1 (var e1)) (STV 0.0 0.9))))

; --- L6-01.1: Sky-cats have always lived on the cliff-spires.
(sem-rule L6-01_1_skycat_live)
(rule-context L6-01_1_skycat_live aelmere-lore)
(rule-priority L6-01_1_skycat_live 180)
(rule-tv L6-01_1_skycat_live authored 1.0 0.9)
(rule-lhs L6-01_1_skycat_live ((sem-edge (var g) (var e1) Member (var x) sky_cat)))
(rule-rhs L6-01_1_skycat_live ((sem-edge (var g) (L6-01_1_skycat_live_p1 (var e1)) Member (L6-01_1_sk_live (var x)) live) (sem-edge-tv (var g) (L6-01_1_skycat_live_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L6-01_1_skycat_live_p2 (var e1)) Agent (L6-01_1_sk_live (var x)) (var x)) (sem-edge-tv (var g) (L6-01_1_skycat_live_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L6-01_1_skycat_live_p3 (var e1)) Location (L6-01_1_sk_live (var x)) L6-01_1_sk_cliff_spire_1) (sem-edge-tv (var g) (L6-01_1_skycat_live_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L6-01_1_skycat_live_p4 (var e1)) Ongoing (L6-01_1_sk_live (var x))) (sem-edge-tv (var g) (L6-01_1_skycat_live_p4 (var e1)) (STV 1.0 0.9))))

; --- L6-02.2: Every sky-cat has broad feathered wings.
(sem-rule L6-02_2_sky_cat_wing_rule)
(rule-context L6-02_2_sky_cat_wing_rule aelmere-lore)
(rule-priority L6-02_2_sky_cat_wing_rule 181)
(rule-tv L6-02_2_sky_cat_wing_rule authored 1.0 0.9)
(rule-lhs L6-02_2_sky_cat_wing_rule ((sem-edge (var g) (var e1) Member (var x) sky_cat)))
(rule-rhs L6-02_2_sky_cat_wing_rule ((sem-edge (var g) (L6-02_2_sky_cat_wing_rule_p1 (var e1)) Member (L6-02_2_sk_have (var x)) have) (sem-edge-tv (var g) (L6-02_2_sky_cat_wing_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L6-02_2_sky_cat_wing_rule_p2 (var e1)) Holder (L6-02_2_sk_have (var x)) (var x)) (sem-edge-tv (var g) (L6-02_2_sky_cat_wing_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L6-02_2_sky_cat_wing_rule_p3 (var e1)) Object (L6-02_2_sk_have (var x)) (L6-02_2_sk_wings (var x))) (sem-edge-tv (var g) (L6-02_2_sky_cat_wing_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L6-02_2_sky_cat_wing_rule_p4 (var e1)) Member (L6-02_2_sk_wings (var x)) wing) (sem-edge-tv (var g) (L6-02_2_sky_cat_wing_rule_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L6-02_2_sky_cat_wing_rule_p5 (var e1)) Member (L6-02_2_sk_wings (var x)) broad) (sem-edge-tv (var g) (L6-02_2_sky_cat_wing_rule_p5 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L6-02_2_sky_cat_wing_rule_p6 (var e1)) Member (L6-02_2_sk_wings (var x)) feathered) (sem-edge-tv (var g) (L6-02_2_sky_cat_wing_rule_p6 (var e1)) (STV 1.0 0.9))))

; --- L6-02.5: Sky-cats fly silently.
(sem-rule L6-02_5_skycat_fly)
(rule-context L6-02_5_skycat_fly aelmere-lore)
(rule-priority L6-02_5_skycat_fly 182)
(rule-tv L6-02_5_skycat_fly authored 0.9 0.9)
(rule-lhs L6-02_5_skycat_fly ((sem-edge (var g) (var e1) Member (var x) sky_cat)))
(rule-rhs L6-02_5_skycat_fly ((sem-edge (var g) (L6-02_5_skycat_fly_p1 (var e1)) Member (L6-02_5_sk_fly (var x)) fly) (sem-edge-tv (var g) (L6-02_5_skycat_fly_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L6-02_5_skycat_fly_p2 (var e1)) Agent (L6-02_5_sk_fly (var x)) (var x)) (sem-edge-tv (var g) (L6-02_5_skycat_fly_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L6-02_5_skycat_fly_p3 (var e1)) Manner (L6-02_5_sk_fly (var x)) silently) (sem-edge-tv (var g) (L6-02_5_skycat_fly_p3 (var e1)) (STV 0.9 0.9))))

; --- L6-02.6: Keepers rarely witness a sky-cat hunt.
(sem-rule L6-02_6_keeper_witness_rule)
(rule-context L6-02_6_keeper_witness_rule aelmere-lore)
(rule-priority L6-02_6_keeper_witness_rule 183)
(rule-tv L6-02_6_keeper_witness_rule authored 0.1 0.9)
(rule-lhs L6-02_6_keeper_witness_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L6-02_6_keeper_witness_rule ((sem-edge (var g) (L6-02_6_keeper_witness_rule_p1 (var e1)) And (Member (L6-02_6_sk_witness (var x)) witness) (Experiencer (L6-02_6_sk_witness (var x)) (var x)) (Member (L6-02_6_sk_hunt (var x)) hunt) (Object (L6-02_6_sk_hunt (var x)) sky_cat) (Stimulus (L6-02_6_sk_witness (var x)) (L6-02_6_sk_hunt (var x)))) (sem-edge-tv (var g) (L6-02_6_keeper_witness_rule_p1 (var e1)) (STV 0.1 0.9))))

; --- L6-03.2: Sky-cats hunt alone.
(sem-rule L6-03_2_skycat_hunt)
(rule-context L6-03_2_skycat_hunt aelmere-lore)
(rule-priority L6-03_2_skycat_hunt 184)
(rule-tv L6-03_2_skycat_hunt authored 0.9 0.9)
(rule-lhs L6-03_2_skycat_hunt ((sem-edge (var g) (var e1) Member (var x) sky_cat)))
(rule-rhs L6-03_2_skycat_hunt ((sem-edge (var g) (L6-03_2_skycat_hunt_p1 (var e1)) Member (L6-03_2_sk_hunt (var x)) hunt) (sem-edge-tv (var g) (L6-03_2_skycat_hunt_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L6-03_2_skycat_hunt_p2 (var e1)) Agent (L6-03_2_sk_hunt (var x)) (var x)) (sem-edge-tv (var g) (L6-03_2_skycat_hunt_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L6-03_2_skycat_hunt_p3 (var e1)) Manner (L6-03_2_sk_hunt (var x)) alone) (sem-edge-tv (var g) (L6-03_2_skycat_hunt_p3 (var e1)) (STV 0.9 0.9))))

; --- L6-03.3: Sky-cats roost together.
(sem-rule L6-03_3_skycat_roost)
(rule-context L6-03_3_skycat_roost aelmere-lore)
(rule-priority L6-03_3_skycat_roost 185)
(rule-tv L6-03_3_skycat_roost authored 0.9 0.9)
(rule-lhs L6-03_3_skycat_roost ((sem-edge (var g) (var e1) Member (var x) sky_cat)))
(rule-rhs L6-03_3_skycat_roost ((sem-edge (var g) (L6-03_3_skycat_roost_p1 (var e1)) Member (L6-03_3_sk_roost (var x)) roost) (sem-edge-tv (var g) (L6-03_3_skycat_roost_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L6-03_3_skycat_roost_p2 (var e1)) Agent (L6-03_3_sk_roost (var x)) (var x)) (sem-edge-tv (var g) (L6-03_3_skycat_roost_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L6-03_3_skycat_roost_p3 (var e1)) Manner (L6-03_3_sk_roost (var x)) together) (sem-edge-tv (var g) (L6-03_3_skycat_roost_p3 (var e1)) (STV 0.9 0.9))))

; --- L6-04.1: Whenever a crowd of nightmoths gathers at a lantern-row, sky-cats descend to hunt.
(sem-rule L6-04_1_whenever_gather_descend)
(rule-context L6-04_1_whenever_gather_descend aelmere-lore)
(rule-priority L6-04_1_whenever_gather_descend 186)
(rule-tv L6-04_1_whenever_gather_descend authored 1.0 0.9)
(rule-lhs L6-04_1_whenever_gather_descend ((sem-edge (var g) (var e1) Member (var x) gather) (sem-edge (var g) (var e2) Agent (var x) (var g)) (sem-edge (var g) (var e3) Member (var g) crowd) (sem-edge (var g) (var e4) GroupOf (var g) nightmoth) (sem-edge (var g) (var e5) Location (var x) (var l)) (sem-edge (var g) (var e6) Member (var l) lantern_row)))
(rule-rhs L6-04_1_whenever_gather_descend ((sem-edge (var g) (L6-04_1_whenever_gather_descend_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (L6-04_1_sk_descend (var x)) descend) (sem-edge-tv (var g) (L6-04_1_whenever_gather_descend_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L6-04_1_whenever_gather_descend_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Agent (L6-04_1_sk_descend (var x)) (L6-04_1_sk_skycats (var x))) (sem-edge-tv (var g) (L6-04_1_whenever_gather_descend_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L6-04_1_whenever_gather_descend_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) GroupOf (L6-04_1_sk_skycats (var x)) sky_cat) (sem-edge-tv (var g) (L6-04_1_whenever_gather_descend_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L6-04_1_whenever_gather_descend_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) During (L6-04_1_sk_descend (var x)) (var x)) (sem-edge-tv (var g) (L6-04_1_whenever_gather_descend_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L6-04_1_whenever_gather_descend_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (L6-04_1_sk_hunt (var x)) hunt) (sem-edge-tv (var g) (L6-04_1_whenever_gather_descend_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L6-04_1_whenever_gather_descend_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Agent (L6-04_1_sk_hunt (var x)) (L6-04_1_sk_skycats (var x))) (sem-edge-tv (var g) (L6-04_1_whenever_gather_descend_p6 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L6-04_1_whenever_gather_descend_p7 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) To (L6-04_1_sk_descend (var x)) (L6-04_1_sk_hunt (var x))) (sem-edge-tv (var g) (L6-04_1_whenever_gather_descend_p7 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9))))

; --- L6-04.2: When a handful of nightmoths gathers at a lantern-row, sky-cats stay on the cliff-spires.
(sem-rule L6-04_2_e404_rule)
(rule-context L6-04_2_e404_rule aelmere-lore)
(rule-priority L6-04_2_e404_rule 187)
(rule-tv L6-04_2_e404_rule authored 0.9 0.9)
(rule-lhs L6-04_2_e404_rule ((sem-edge (var g) (var e1) Member (var x) gather) (sem-edge (var g) (var e2) Agent (var x) (var g)) (sem-edge (var g) (var e3) GroupOf (var g) nightmoth) (sem-edge (var g) (var e4) CardinalityPhrase (var g) "handful") (sem-edge (var g) (var e5) Location (var x) (var lr)) (sem-edge (var g) (var e6) Member (var lr) lantern_row) (sem-edge (var g) (var e7) Member (var y) sky_cat)))
(rule-rhs L6-04_2_e404_rule ((sem-edge (var g) (L6-04_2_e404_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Member (L6-04_2_sk_stay (var x) (var y)) stay) (sem-edge-tv (var g) (L6-04_2_e404_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 0.9 0.9)) (sem-edge (var g) (L6-04_2_e404_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Experiencer (L6-04_2_sk_stay (var x) (var y)) (var y)) (sem-edge-tv (var g) (L6-04_2_e404_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 0.9 0.9)) (sem-edge (var g) (L6-04_2_e404_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Location (L6-04_2_sk_stay (var x) (var y)) L6-04_2_sk_group_1) (sem-edge-tv (var g) (L6-04_2_e404_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 0.9 0.9)) (sem-edge (var g) (L6-04_2_e404_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) During (L6-04_2_sk_stay (var x) (var y)) (var x)) (sem-edge-tv (var g) (L6-04_2_e404_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 0.9 0.9))))

; --- L6-04.3: Keepers use the crowd rule.
(sem-rule L6-04_3_keepers_use_rule)
(rule-context L6-04_3_keepers_use_rule aelmere-lore)
(rule-priority L6-04_3_keepers_use_rule 188)
(rule-tv L6-04_3_keepers_use_rule authored 0.9 0.9)
(rule-lhs L6-04_3_keepers_use_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L6-04_3_keepers_use_rule ((sem-edge (var g) (L6-04_3_keepers_use_rule_p1 (var e1)) Member (L6-04_3_sk_use (var x)) use) (sem-edge-tv (var g) (L6-04_3_keepers_use_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L6-04_3_keepers_use_rule_p2 (var e1)) Agent (L6-04_3_sk_use (var x)) (var x)) (sem-edge-tv (var g) (L6-04_3_keepers_use_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L6-04_3_keepers_use_rule_p3 (var e1)) Object (L6-04_3_sk_use (var x)) L6-04_3_sk_rule_1) (sem-edge-tv (var g) (L6-04_3_keepers_use_rule_p3 (var e1)) (STV 0.9 0.9))))

; --- L6-04.5: After a sky-cat hunts at a lantern-row, the thread harvest at that lantern-row falls.
(sem-rule L6-04_5_hunt_fall_rule)
(rule-context L6-04_5_hunt_fall_rule aelmere-lore)
(rule-priority L6-04_5_hunt_fall_rule 189)
(rule-tv L6-04_5_hunt_fall_rule authored 1.0 0.9)
(rule-lhs L6-04_5_hunt_fall_rule ((sem-edge (var g) (var e1) Member (var sc) sky_cat) (sem-edge (var g) (var e2) Member (var lr) lantern_row) (sem-edge (var g) (var e3) Member (var h) hunt) (sem-edge (var g) (var e4) Agent (var h) (var sc)) (sem-edge (var g) (var e5) Location (var h) (var lr))))
(rule-rhs L6-04_5_hunt_fall_rule ((sem-edge (var g) (L6-04_5_hunt_fall_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (L6-04_5_sk_thread_harvest (var lr)) thread_harvest) (sem-edge-tv (var g) (L6-04_5_hunt_fall_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L6-04_5_hunt_fall_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) LocatedIn (L6-04_5_sk_thread_harvest (var lr)) (var lr)) (sem-edge-tv (var g) (L6-04_5_hunt_fall_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L6-04_5_hunt_fall_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (L6-04_5_sk_fall (var h)) fall) (sem-edge-tv (var g) (L6-04_5_hunt_fall_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L6-04_5_hunt_fall_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) Object (L6-04_5_sk_fall (var h)) (L6-04_5_sk_thread_harvest (var lr))) (sem-edge-tv (var g) (L6-04_5_hunt_fall_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L6-04_5_hunt_fall_rule_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) Before (var h) (L6-04_5_sk_fall (var h))) (sem-edge-tv (var g) (L6-04_5_hunt_fall_rule_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- L6-05.1: Whenever a sky-cat hunts on the Cliff Path, each nightmoth that survives the hunt flees to the Hollows.
(sem-rule L6-05_1_whenever_hunt_flee)
(rule-context L6-05_1_whenever_hunt_flee aelmere-lore)
(rule-priority L6-05_1_whenever_hunt_flee 190)
(rule-tv L6-05_1_whenever_hunt_flee authored 1.0 0.9)
(rule-lhs L6-05_1_whenever_hunt_flee ((sem-edge (var g) (var e1) Member (var h) hunt) (sem-edge (var g) (var e2) Agent (var h) (var c)) (sem-edge (var g) (var e3) Member (var c) sky_cat) (sem-edge (var g) (var e4) Location (var h) cliff_path) (sem-edge (var g) (var e5) Member (var m) nightmoth) (sem-edge (var g) (var e6) Member (var sv) survive) (sem-edge (var g) (var e7) Agent (var sv) (var m)) (sem-edge (var g) (var e8) Object (var sv) (var h))))
(rule-rhs L6-05_1_whenever_hunt_flee ((sem-edge (var g) (L6-05_1_whenever_hunt_flee_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Member (L6-05_1_sk_flee (var m) (var h)) flee) (sem-edge-tv (var g) (L6-05_1_whenever_hunt_flee_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (L6-05_1_whenever_hunt_flee_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Agent (L6-05_1_sk_flee (var m) (var h)) (var m)) (sem-edge-tv (var g) (L6-05_1_whenever_hunt_flee_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (L6-05_1_whenever_hunt_flee_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Goal (L6-05_1_sk_flee (var m) (var h)) hollows) (sem-edge-tv (var g) (L6-05_1_whenever_hunt_flee_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (L6-05_1_whenever_hunt_flee_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) During (L6-05_1_sk_flee (var m) (var h)) (var h)) (sem-edge-tv (var g) (L6-05_1_whenever_hunt_flee_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9))))

; --- L6-05.2: Whenever a sky-cat hunts on the Cliff Path, the lanterns at the Hollows gain nightmoths.
(sem-rule L6-05_2_lo39_rule)
(rule-context L6-05_2_lo39_rule aelmere-lore)
(rule-priority L6-05_2_lo39_rule 191)
(rule-tv L6-05_2_lo39_rule authored 1.0 0.9)
(rule-lhs L6-05_2_lo39_rule ((sem-edge (var g) (var e1) Member (var x) hunt) (sem-edge (var g) (var e2) Agent (var x) (var y)) (sem-edge (var g) (var e3) Member (var y) sky_cat) (sem-edge (var g) (var e4) Location (var x) cliff_path)))
(rule-rhs L6-05_2_lo39_rule ((sem-edge (var g) (L6-05_2_lo39_rule_p1 (var e1) (var e2) (var e3) (var e4)) Member (L6-05_2_sk_gain (var x)) gain) (sem-edge-tv (var g) (L6-05_2_lo39_rule_p1 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L6-05_2_lo39_rule_p2 (var e1) (var e2) (var e3) (var e4)) Agent (L6-05_2_sk_gain (var x)) L6-05_2_sk_lantern_1) (sem-edge-tv (var g) (L6-05_2_lo39_rule_p2 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L6-05_2_lo39_rule_p3 (var e1) (var e2) (var e3) (var e4)) Object (L6-05_2_sk_gain (var x)) nightmoth) (sem-edge-tv (var g) (L6-05_2_lo39_rule_p3 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L6-05_2_lo39_rule_p4 (var e1) (var e2) (var e3) (var e4)) During (L6-05_2_sk_gain (var x)) (var x)) (sem-edge-tv (var g) (L6-05_2_lo39_rule_p4 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9))))

; --- L6-06.1: Sky-cats molt in late summer.
(sem-rule L6-06_1_skycat_molt)
(rule-context L6-06_1_skycat_molt aelmere-lore)
(rule-priority L6-06_1_skycat_molt 192)
(rule-tv L6-06_1_skycat_molt authored 0.9 0.9)
(rule-lhs L6-06_1_skycat_molt ((sem-edge (var g) (var e1) Member (var x) sky_cat)))
(rule-rhs L6-06_1_skycat_molt ((sem-edge (var g) (L6-06_1_skycat_molt_p1 (var e1)) Member (L6-06_1_sk_molt (var x)) molt) (sem-edge-tv (var g) (L6-06_1_skycat_molt_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L6-06_1_skycat_molt_p2 (var e1)) Object (L6-06_1_sk_molt (var x)) (var x)) (sem-edge-tv (var g) (L6-06_1_skycat_molt_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L6-06_1_skycat_molt_p3 (var e1)) Time (L6-06_1_sk_molt (var x)) late_summer) (sem-edge-tv (var g) (L6-06_1_skycat_molt_p3 (var e1)) (STV 0.9 0.9))))

; --- L6-06.2: Sky-cats molt in early autumn.
(sem-rule L6-06_2_skycat_molt_rule)
(rule-context L6-06_2_skycat_molt_rule aelmere-lore)
(rule-priority L6-06_2_skycat_molt_rule 193)
(rule-tv L6-06_2_skycat_molt_rule authored 0.9 0.9)
(rule-lhs L6-06_2_skycat_molt_rule ((sem-edge (var g) (var e1) Member (var x) sky_cat)))
(rule-rhs L6-06_2_skycat_molt_rule ((sem-edge (var g) (L6-06_2_skycat_molt_rule_p1 (var e1)) Member (L6-06_2_sk_molt (var x)) molt) (sem-edge-tv (var g) (L6-06_2_skycat_molt_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L6-06_2_skycat_molt_rule_p2 (var e1)) Agent (L6-06_2_sk_molt (var x)) (var x)) (sem-edge-tv (var g) (L6-06_2_skycat_molt_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L6-06_2_skycat_molt_rule_p3 (var e1)) Time (L6-06_2_sk_molt (var x)) early_autumn) (sem-edge-tv (var g) (L6-06_2_skycat_molt_rule_p3 (var e1)) (STV 0.9 0.9))))

; --- L6-06.3: Whenever a sky-cat molts, feathers fall to the base of the cliff.
(sem-rule L6-06_3_whenever_molt_fall)
(rule-context L6-06_3_whenever_molt_fall aelmere-lore)
(rule-priority L6-06_3_whenever_molt_fall 194)
(rule-tv L6-06_3_whenever_molt_fall authored 1.0 0.9)
(rule-lhs L6-06_3_whenever_molt_fall ((sem-edge (var g) (var e1) Member (var c) sky_cat) (sem-edge (var g) (var e2) Member (var x) molt) (sem-edge (var g) (var e3) Object (var x) (var c))))
(rule-rhs L6-06_3_whenever_molt_fall ((sem-edge (var g) (L6-06_3_whenever_molt_fall_p1 (var e1) (var e2) (var e3)) GroupOf (L6-06_3_sk_feathers (var x)) feather) (sem-edge-tv (var g) (L6-06_3_whenever_molt_fall_p1 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L6-06_3_whenever_molt_fall_p2 (var e1) (var e2) (var e3)) Member (L6-06_3_sk_fall (var x)) fall) (sem-edge-tv (var g) (L6-06_3_whenever_molt_fall_p2 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L6-06_3_whenever_molt_fall_p3 (var e1) (var e2) (var e3)) Object (L6-06_3_sk_fall (var x)) (L6-06_3_sk_feathers (var x))) (sem-edge-tv (var g) (L6-06_3_whenever_molt_fall_p3 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L6-06_3_whenever_molt_fall_p4 (var e1) (var e2) (var e3)) Goal (L6-06_3_sk_fall (var x)) L6-06_3_sk_base_1) (sem-edge-tv (var g) (L6-06_3_whenever_molt_fall_p4 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L6-06_3_whenever_molt_fall_p5 (var e1) (var e2) (var e3)) During (L6-06_3_sk_fall (var x)) (var x)) (sem-edge-tv (var g) (L6-06_3_whenever_molt_fall_p5 (var e1) (var e2) (var e3)) (STV 1.0 0.9))))

; --- L6-06.5: Ground feathers of sky-cats ward lanterns against wraiths.
(sem-rule L6-06_5_ward_rule)
(rule-context L6-06_5_ward_rule aelmere-lore)
(rule-priority L6-06_5_ward_rule 195)
(rule-tv L6-06_5_ward_rule authored 0.9 0.9)
(rule-lhs L6-06_5_ward_rule ((sem-edge (var g) (var e1) Member (var f) ground_feather) (sem-edge (var g) (var e2) Member (var c) sky_cat) (sem-edge (var g) (var e3) PartOf (var f) (var c))))
(rule-rhs L6-06_5_ward_rule ((sem-edge (var g) (L6-06_5_ward_rule_p1 (var e1) (var e2) (var e3)) Member (L6-06_5_sk_ward (var f) (var c)) ward) (sem-edge-tv (var g) (L6-06_5_ward_rule_p1 (var e1) (var e2) (var e3)) (STV 0.9 0.9)) (sem-edge (var g) (L6-06_5_ward_rule_p2 (var e1) (var e2) (var e3)) Agent (L6-06_5_sk_ward (var f) (var c)) (var f)) (sem-edge-tv (var g) (L6-06_5_ward_rule_p2 (var e1) (var e2) (var e3)) (STV 0.9 0.9)) (sem-edge (var g) (L6-06_5_ward_rule_p3 (var e1) (var e2) (var e3)) Object (L6-06_5_sk_ward (var f) (var c)) lantern) (sem-edge-tv (var g) (L6-06_5_ward_rule_p3 (var e1) (var e2) (var e3)) (STV 0.9 0.9)) (sem-edge (var g) (L6-06_5_ward_rule_p4 (var e1) (var e2) (var e3)) Against (L6-06_5_sk_ward (var f) (var c)) wraith) (sem-edge-tv (var g) (L6-06_5_ward_rule_p4 (var e1) (var e2) (var e3)) (STV 0.9 0.9))))

; --- L6-06.6: Every Keeper considers that sky-cats are sacred.
(sem-rule L6-06_6_keeper_considers)
(rule-context L6-06_6_keeper_considers aelmere-lore)
(rule-priority L6-06_6_keeper_considers 196)
(rule-tv L6-06_6_keeper_considers authored 1.0 0.9)
(rule-lhs L6-06_6_keeper_considers ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L6-06_6_keeper_considers ((sem-edge (var g) (L6-06_6_keeper_considers_p1 (var e1)) Member (L6-06_6_sk_consider (var x)) consider) (sem-edge-tv (var g) (L6-06_6_keeper_considers_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L6-06_6_keeper_considers_p2 (var e1)) Experiencer (L6-06_6_sk_consider (var x)) (var x)) (sem-edge-tv (var g) (L6-06_6_keeper_considers_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L6-06_6_keeper_considers_p3 (var e1)) Object (L6-06_6_sk_consider (var x)) (Inheritance sky_cat sacred)) (sem-edge-tv (var g) (L6-06_6_keeper_considers_p3 (var e1)) (STV 1.0 0.9))))

; --- L6-06.7: Keepers never harm a sky-cat.
(sem-rule L6-06_7_lorep58_rule)
(rule-context L6-06_7_lorep58_rule aelmere-lore)
(rule-priority L6-06_7_lorep58_rule 197)
(rule-tv L6-06_7_lorep58_rule authored 0.0 0.9)
(rule-lhs L6-06_7_lorep58_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L6-06_7_lorep58_rule ((sem-edge (var g) (L6-06_7_lorep58_rule_p1 (var e1)) And (Member (L6-06_7_sk_harm (var x)) harm) (Agent (L6-06_7_sk_harm (var x)) (var x)) (Object (L6-06_7_sk_harm (var x)) (L6-06_7_sk_sky_cat (var x))) (Member (L6-06_7_sk_sky_cat (var x)) sky_cat)) (sem-edge-tv (var g) (L6-06_7_lorep58_rule_p1 (var e1)) (STV 0.0 0.9))))

; --- L6-06.8: Sky-cats sometimes carry a nightmoth to the spires in flight.
(sem-rule L6-06_8_skycat_carry_rule)
(rule-context L6-06_8_skycat_carry_rule aelmere-lore)
(rule-priority L6-06_8_skycat_carry_rule 198)
(rule-tv L6-06_8_skycat_carry_rule authored 0.5 0.9)
(rule-lhs L6-06_8_skycat_carry_rule ((sem-edge (var g) (var e1) Member (var x) sky_cat)))
(rule-rhs L6-06_8_skycat_carry_rule ((sem-edge (var g) (L6-06_8_skycat_carry_rule_p1 (var e1)) Member (L6-06_8_sk_carry (var x)) carry) (sem-edge-tv (var g) (L6-06_8_skycat_carry_rule_p1 (var e1)) (STV 0.5 0.9)) (sem-edge (var g) (L6-06_8_skycat_carry_rule_p2 (var e1)) Agent (L6-06_8_sk_carry (var x)) (var x)) (sem-edge-tv (var g) (L6-06_8_skycat_carry_rule_p2 (var e1)) (STV 0.5 0.9)) (sem-edge (var g) (L6-06_8_skycat_carry_rule_p3 (var e1)) Object (L6-06_8_sk_carry (var x)) (L6-06_8_sk_nightmoth (var x))) (sem-edge-tv (var g) (L6-06_8_skycat_carry_rule_p3 (var e1)) (STV 0.5 0.9)) (sem-edge (var g) (L6-06_8_skycat_carry_rule_p4 (var e1)) Member (L6-06_8_sk_nightmoth (var x)) nightmoth) (sem-edge-tv (var g) (L6-06_8_skycat_carry_rule_p4 (var e1)) (STV 0.5 0.9)) (sem-edge (var g) (L6-06_8_skycat_carry_rule_p5 (var e1)) Goal (L6-06_8_sk_carry (var x)) L6-06_8_sk_spire_1) (sem-edge-tv (var g) (L6-06_8_skycat_carry_rule_p5 (var e1)) (STV 0.5 0.9)) (sem-edge (var g) (L6-06_8_skycat_carry_rule_p6 (var e1)) In (L6-06_8_sk_carry (var x)) flight) (sem-edge-tv (var g) (L6-06_8_skycat_carry_rule_p6 (var e1)) (STV 0.5 0.9))))

; --- L6-07.1: Keepers count the visible sky-cats on the cliff-spires each morning.
(sem-rule L6-07_1_keeper_count_rule)
(rule-context L6-07_1_keeper_count_rule aelmere-lore)
(rule-priority L6-07_1_keeper_count_rule 199)
(rule-tv L6-07_1_keeper_count_rule authored 0.9 0.9)
(rule-lhs L6-07_1_keeper_count_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L6-07_1_keeper_count_rule ((sem-edge (var g) (L6-07_1_keeper_count_rule_p1 (var e1)) Member (L6-07_1_sk_count (var x)) count) (sem-edge-tv (var g) (L6-07_1_keeper_count_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L6-07_1_keeper_count_rule_p2 (var e1)) Agent (L6-07_1_sk_count (var x)) (var x)) (sem-edge-tv (var g) (L6-07_1_keeper_count_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L6-07_1_keeper_count_rule_p3 (var e1)) Object (L6-07_1_sk_count (var x)) L6-07_1_sk_group_1) (sem-edge-tv (var g) (L6-07_1_keeper_count_rule_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L6-07_1_keeper_count_rule_p4 (var e1)) Time (L6-07_1_sk_count (var x)) morning) (sem-edge-tv (var g) (L6-07_1_keeper_count_rule_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L6-07_1_keeper_count_rule_p5 (var e1)) Every (L6-07_1_sk_count (var x)) 1 day) (sem-edge-tv (var g) (L6-07_1_keeper_count_rule_p5 (var e1)) (STV 0.9 0.9))))

; --- L6-07.2: Keepers track the weight of the feather harvest.
(sem-rule L6-07_2_lorep61_rule)
(rule-context L6-07_2_lorep61_rule aelmere-lore)
(rule-priority L6-07_2_lorep61_rule 200)
(rule-tv L6-07_2_lorep61_rule authored 0.9 0.9)
(rule-lhs L6-07_2_lorep61_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L6-07_2_lorep61_rule ((sem-edge (var g) (L6-07_2_lorep61_rule_p1 (var e1)) Member (L6-07_2_sk_track (var x)) track) (sem-edge-tv (var g) (L6-07_2_lorep61_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L6-07_2_lorep61_rule_p2 (var e1)) Agent (L6-07_2_sk_track (var x)) (var x)) (sem-edge-tv (var g) (L6-07_2_lorep61_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L6-07_2_lorep61_rule_p3 (var e1)) Object (L6-07_2_sk_track (var x)) L6-07_2_sk_weight_1) (sem-edge-tv (var g) (L6-07_2_lorep61_rule_p3 (var e1)) (STV 0.9 0.9))))

; --- L6-08.3: Wraiths that are in the Sunken Cove sometimes harm sky-cats.
(sem-rule L6-08_3_wraith_harm_rule)
(rule-context L6-08_3_wraith_harm_rule aelmere-lore)
(rule-priority L6-08_3_wraith_harm_rule 201)
(rule-tv L6-08_3_wraith_harm_rule authored 0.5 0.9)
(rule-lhs L6-08_3_wraith_harm_rule ((sem-edge (var g) (var e1) Member (var x) wraith) (sem-edge (var g) (var e2) AttachedTo (var x) sunken_cove)))
(rule-rhs L6-08_3_wraith_harm_rule ((sem-edge (var g) (L6-08_3_wraith_harm_rule_p1 (var e1) (var e2)) Member (L6-08_3_sk_harm (var x)) harm) (sem-edge-tv (var g) (L6-08_3_wraith_harm_rule_p1 (var e1) (var e2)) (STV 0.5 0.9)) (sem-edge (var g) (L6-08_3_wraith_harm_rule_p2 (var e1) (var e2)) Agent (L6-08_3_sk_harm (var x)) (var x)) (sem-edge-tv (var g) (L6-08_3_wraith_harm_rule_p2 (var e1) (var e2)) (STV 0.5 0.9)) (sem-edge (var g) (L6-08_3_wraith_harm_rule_p3 (var e1) (var e2)) Object (L6-08_3_sk_harm (var x)) sky_cat) (sem-edge-tv (var g) (L6-08_3_wraith_harm_rule_p3 (var e1) (var e2)) (STV 0.5 0.9))))

; --- L6-08.4: When a moth-count at the Stilllight Lantern is low, sky-cats stay on the cliff-spires.
(sem-rule L6-08_4_skycat_rule)
(rule-context L6-08_4_skycat_rule aelmere-lore)
(rule-priority L6-08_4_skycat_rule 202)
(rule-tv L6-08_4_skycat_rule authored 1.0 0.9)
(rule-lhs L6-08_4_skycat_rule ((sem-edge (var g) (var e1) Member (var x) sky_cat) (sem-edge (var g) (var e2) Member (var c) moth_count) (sem-edge (var g) (var e3) LocatedIn (var c) stilllight_lantern) (sem-edge (var g) (var e4) Member (var c) low)))
(rule-rhs L6-08_4_skycat_rule ((sem-edge (var g) (L6-08_4_skycat_rule_p1 (var e1) (var e2) (var e3) (var e4)) On (var x) L6-08_4_sk_spires_1) (sem-edge-tv (var g) (L6-08_4_skycat_rule_p1 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9))))

; --- L6-08.5: Keepers do not feed sky-cats.
(sem-rule L6-08_5_keeper_no_feed)
(rule-context L6-08_5_keeper_no_feed aelmere-lore)
(rule-priority L6-08_5_keeper_no_feed 203)
(rule-tv L6-08_5_keeper_no_feed authored 0.0 0.9)
(rule-lhs L6-08_5_keeper_no_feed ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L6-08_5_keeper_no_feed ((sem-edge (var g) (L6-08_5_keeper_no_feed_p1 (var e1)) And (Member (L6-08_5_sk_feed (var x)) feed) (Agent (L6-08_5_sk_feed (var x)) (var x)) (Object (L6-08_5_sk_feed (var x)) sky_cat)) (sem-edge-tv (var g) (L6-08_5_keeper_no_feed_p1 (var e1)) (STV 0.0 0.9))))

; --- L6-08.6: Apprentices never approach the cliff-spires.
(sem-rule L6-08_6_appr_rule)
(rule-context L6-08_6_appr_rule aelmere-lore)
(rule-priority L6-08_6_appr_rule 204)
(rule-tv L6-08_6_appr_rule authored 0.0 0.9)
(rule-lhs L6-08_6_appr_rule ((sem-edge (var g) (var e1) Member (var x) apprentice)))
(rule-rhs L6-08_6_appr_rule ((sem-edge (var g) (L6-08_6_appr_rule_p1 (var e1)) And (Member (L6-08_6_sk_approach (var x)) approach) (Agent (L6-08_6_sk_approach (var x)) (var x)) (Object (L6-08_6_sk_approach (var x)) L6-08_6_sk_group_1)) (sem-edge-tv (var g) (L6-08_6_appr_rule_p1 (var e1)) (STV 0.0 0.9))))

; --- L7-01.3: Spring tides occur at new moon or at full moon.
(sem-rule L7-01_3_e429_rule)
(rule-context L7-01_3_e429_rule aelmere-lore)
(rule-priority L7-01_3_e429_rule 205)
(rule-tv L7-01_3_e429_rule authored 1.0 0.99)
(rule-lhs L7-01_3_e429_rule ((sem-edge (var g) (var e1) Member (var x) spring_tide)))
(rule-rhs L7-01_3_e429_rule ((sem-edge (var g) (L7-01_3_e429_rule_p1 (var e1)) Or (Time (var x) new_moon) (Time (var x) full_moon)) (sem-edge-tv (var g) (L7-01_3_e429_rule_p1 (var e1)) (STV 1.0 0.99))))

; --- L7-01.4: Whenever a spring tide fills the Salt-bloom Tide-pools, salt-bloom blooms in the pools.
(sem-rule L7-01_4_st1_rule)
(rule-context L7-01_4_st1_rule aelmere-lore)
(rule-priority L7-01_4_st1_rule 206)
(rule-tv L7-01_4_st1_rule authored 1.0 0.9)
(rule-lhs L7-01_4_st1_rule ((sem-edge (var g) (var e1) Member (var e) fill) (sem-edge (var g) (var e2) Agent (var e) (var t)) (sem-edge (var g) (var e3) Member (var t) spring_tide) (sem-edge (var g) (var e4) Object (var e) salt_bloom_tide_pools)))
(rule-rhs L7-01_4_st1_rule ((sem-edge (var g) (L7-01_4_st1_rule_p1 (var e1) (var e2) (var e3) (var e4)) Member (L7-01_4_sk_bloom (var e)) bloom) (sem-edge-tv (var g) (L7-01_4_st1_rule_p1 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L7-01_4_st1_rule_p2 (var e1) (var e2) (var e3) (var e4)) Object (L7-01_4_sk_bloom (var e)) salt_bloom) (sem-edge-tv (var g) (L7-01_4_st1_rule_p2 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L7-01_4_st1_rule_p3 (var e1) (var e2) (var e3) (var e4)) Location (L7-01_4_sk_bloom (var e)) salt_bloom_tide_pools) (sem-edge-tv (var g) (L7-01_4_st1_rule_p3 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L7-01_4_st1_rule_p4 (var e1) (var e2) (var e3) (var e4)) During (L7-01_4_sk_bloom (var e)) (var e)) (sem-edge-tv (var g) (L7-01_4_st1_rule_p4 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9))))

; --- L7-01.6: Neap tides occur at the quarter moons.
(sem-rule L7-01_6_neaptide_qm_rule)
(rule-context L7-01_6_neaptide_qm_rule aelmere-lore)
(rule-priority L7-01_6_neaptide_qm_rule 207)
(rule-tv L7-01_6_neaptide_qm_rule authored 0.9 0.9)
(rule-lhs L7-01_6_neaptide_qm_rule ((sem-edge (var g) (var e1) Member (var x) neap_tide)))
(rule-rhs L7-01_6_neaptide_qm_rule ((sem-edge (var g) (L7-01_6_neaptide_qm_rule_p1 (var e1)) Time (var x) quarter_moon) (sem-edge-tv (var g) (L7-01_6_neaptide_qm_rule_p1 (var e1)) (STV 0.9 0.9))))

; --- L7-02.2: Whenever a Keeper harvests salt-bloom at the new-moon spring tide, that salt-bloom stays potent for the season.
(sem-rule L7-02_2_keeper_harvest_rule)
(rule-context L7-02_2_keeper_harvest_rule aelmere-lore)
(rule-priority L7-02_2_keeper_harvest_rule 208)
(rule-tv L7-02_2_keeper_harvest_rule authored 1.0 0.9)
(rule-lhs L7-02_2_keeper_harvest_rule ((sem-edge (var g) (var e1) Member (var k) keeper) (sem-edge (var g) (var e2) Member (var h) harvest) (sem-edge (var g) (var e3) Agent (var h) (var k)) (sem-edge (var g) (var e4) Member (var s) salt_bloom) (sem-edge (var g) (var e5) Object (var h) (var s)) (sem-edge (var g) (var e6) Time (var h) new_moon_spring_tide)))
(rule-rhs L7-02_2_keeper_harvest_rule ((sem-edge (var g) (L7-02_2_keeper_harvest_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (L7-02_2_sk_potent (var s)) potent) (sem-edge-tv (var g) (L7-02_2_keeper_harvest_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L7-02_2_keeper_harvest_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Experiencer (L7-02_2_sk_potent (var s)) (var s)) (sem-edge-tv (var g) (L7-02_2_keeper_harvest_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L7-02_2_keeper_harvest_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Still (L7-02_2_sk_potent (var s))) (sem-edge-tv (var g) (L7-02_2_keeper_harvest_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L7-02_2_keeper_harvest_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (var s) potent) (sem-edge-tv (var g) (L7-02_2_keeper_harvest_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L7-02_2_keeper_harvest_rule_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Measure (L7-02_2_sk_potent (var s)) duration 1 season) (sem-edge-tv (var g) (L7-02_2_keeper_harvest_rule_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9))))

; --- L7-02.4: Salt-bloom from the full-moon tide turns to chalky residue.
(sem-rule L7-02_4_sb_turns_residue)
(rule-context L7-02_4_sb_turns_residue aelmere-lore)
(rule-priority L7-02_4_sb_turns_residue 209)
(rule-tv L7-02_4_sb_turns_residue authored 0.9 0.9)
(rule-lhs L7-02_4_sb_turns_residue ((sem-edge (var g) (var e1) Member (var x) salt_bloom) (sem-edge (var g) (var e2) From (var x) L7-02_4_sk_full_moon_tide_1)))
(rule-rhs L7-02_4_sb_turns_residue ((sem-edge (var g) (L7-02_4_sb_turns_residue_p1 (var e1) (var e2)) Member (L7-02_4_sk_turn (var x)) turn) (sem-edge-tv (var g) (L7-02_4_sb_turns_residue_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L7-02_4_sb_turns_residue_p2 (var e1) (var e2)) Object (L7-02_4_sk_turn (var x)) (var x)) (sem-edge-tv (var g) (L7-02_4_sb_turns_residue_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L7-02_4_sb_turns_residue_p3 (var e1) (var e2)) Member (L7-02_4_sk_residue (var x)) chalky_residue) (sem-edge-tv (var g) (L7-02_4_sb_turns_residue_p3 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L7-02_4_sb_turns_residue_p4 (var e1) (var e2)) Experiencer (L7-02_4_sk_residue (var x)) (var x)) (sem-edge-tv (var g) (L7-02_4_sb_turns_residue_p4 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L7-02_4_sb_turns_residue_p5 (var e1) (var e2)) Member (var x) chalky_residue) (sem-edge-tv (var g) (L7-02_4_sb_turns_residue_p5 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L7-02_4_sb_turns_residue_p6 (var e1) (var e2)) Result (L7-02_4_sk_turn (var x)) (L7-02_4_sk_residue (var x))) (sem-edge-tv (var g) (L7-02_4_sb_turns_residue_p6 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L7-03.1: Whenever a spring tide ends, a Cauldron Hall apprentice refills the cisterns from the deep ebb.
(sem-rule L7-03_1_whenever_tide_refill)
(rule-context L7-03_1_whenever_tide_refill aelmere-lore)
(rule-priority L7-03_1_whenever_tide_refill 210)
(rule-tv L7-03_1_whenever_tide_refill authored 1.0 0.9)
(rule-lhs L7-03_1_whenever_tide_refill ((sem-edge (var g) (var e1) Member (var t) spring_tide) (sem-edge (var g) (var e2) Member (var x) end) (sem-edge (var g) (var e3) Object (var x) (var t))))
(rule-rhs L7-03_1_whenever_tide_refill ((sem-edge (var g) (L7-03_1_whenever_tide_refill_p1 (var e1) (var e2) (var e3)) Member (L7-03_1_sk_refill (var x)) refill) (sem-edge-tv (var g) (L7-03_1_whenever_tide_refill_p1 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L7-03_1_whenever_tide_refill_p2 (var e1) (var e2) (var e3)) Agent (L7-03_1_sk_refill (var x)) (L7-03_1_sk_apprentice (var x))) (sem-edge-tv (var g) (L7-03_1_whenever_tide_refill_p2 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L7-03_1_whenever_tide_refill_p3 (var e1) (var e2) (var e3)) Member (L7-03_1_sk_apprentice (var x)) apprentice) (sem-edge-tv (var g) (L7-03_1_whenever_tide_refill_p3 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L7-03_1_whenever_tide_refill_p4 (var e1) (var e2) (var e3)) Possession (L7-03_1_sk_apprentice (var x)) cauldron_hall) (sem-edge-tv (var g) (L7-03_1_whenever_tide_refill_p4 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L7-03_1_whenever_tide_refill_p5 (var e1) (var e2) (var e3)) Object (L7-03_1_sk_refill (var x)) L7-03_1_sk_cistern_1) (sem-edge-tv (var g) (L7-03_1_whenever_tide_refill_p5 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L7-03_1_whenever_tide_refill_p6 (var e1) (var e2) (var e3)) Source (L7-03_1_sk_refill (var x)) L7-03_1_sk_ebb_1) (sem-edge-tv (var g) (L7-03_1_whenever_tide_refill_p6 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L7-03_1_whenever_tide_refill_p7 (var e1) (var e2) (var e3)) During (L7-03_1_sk_refill (var x)) (var x)) (sem-edge-tv (var g) (L7-03_1_whenever_tide_refill_p7 (var e1) (var e2) (var e3)) (STV 1.0 0.9))))

; --- L7-03.3: First-year apprentices usually fill the cisterns.
(sem-rule L7-03_3_fya_fill_rule)
(rule-context L7-03_3_fya_fill_rule aelmere-lore)
(rule-priority L7-03_3_fya_fill_rule 211)
(rule-tv L7-03_3_fya_fill_rule authored 0.8 0.9)
(rule-lhs L7-03_3_fya_fill_rule ((sem-edge (var g) (var e1) Member (var x) first_year_apprentice)))
(rule-rhs L7-03_3_fya_fill_rule ((sem-edge (var g) (L7-03_3_fya_fill_rule_p1 (var e1)) Member (L7-03_3_sk_fill (var x)) fill) (sem-edge-tv (var g) (L7-03_3_fya_fill_rule_p1 (var e1)) (STV 0.8 0.9)) (sem-edge (var g) (L7-03_3_fya_fill_rule_p2 (var e1)) Agent (L7-03_3_sk_fill (var x)) (var x)) (sem-edge-tv (var g) (L7-03_3_fya_fill_rule_p2 (var e1)) (STV 0.8 0.9)) (sem-edge (var g) (L7-03_3_fya_fill_rule_p3 (var e1)) Object (L7-03_3_sk_fill (var x)) L7-03_3_sk_cistern_1) (sem-edge-tv (var g) (L7-03_3_fya_fill_rule_p3 (var e1)) (STV 0.8 0.9))))

; --- L7-04.2: Whenever a winter night is clear, the cold-threshold wind comes off the Cold Sea.
(sem-rule L7-04_2_whenever_clear_wind)
(rule-context L7-04_2_whenever_clear_wind aelmere-lore)
(rule-priority L7-04_2_whenever_clear_wind 212)
(rule-tv L7-04_2_whenever_clear_wind authored 1.0 0.9)
(rule-lhs L7-04_2_whenever_clear_wind ((sem-edge (var g) (var e1) Member (var n) winter_night) (sem-edge (var g) (var e2) Member (var n) clear)))
(rule-rhs L7-04_2_whenever_clear_wind ((sem-edge (var g) (L7-04_2_whenever_clear_wind_p1 (var e1) (var e2)) Member (L7-04_2_sk_come (var n)) come) (sem-edge-tv (var g) (L7-04_2_whenever_clear_wind_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L7-04_2_whenever_clear_wind_p2 (var e1) (var e2)) Object (L7-04_2_sk_come (var n)) L7-04_2_sk_wind_1) (sem-edge-tv (var g) (L7-04_2_whenever_clear_wind_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L7-04_2_whenever_clear_wind_p3 (var e1) (var e2)) Source (L7-04_2_sk_come (var n)) cold_sea) (sem-edge-tv (var g) (L7-04_2_whenever_clear_wind_p3 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L7-04_2_whenever_clear_wind_p4 (var e1) (var e2)) During (L7-04_2_sk_come (var n)) (var n)) (sem-edge-tv (var g) (L7-04_2_whenever_clear_wind_p4 (var e1) (var e2)) (STV 1.0 0.9))))

; --- L7-04.4: The cold-threshold wind extinguishes unprotected lanterns.
(sem-rule L7-04_4_e1_rule)
(rule-context L7-04_4_e1_rule aelmere-lore)
(rule-priority L7-04_4_e1_rule 213)
(rule-tv L7-04_4_e1_rule authored 0.9 0.9)
(rule-lhs L7-04_4_e1_rule ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) Member (var x) unprotected)))
(rule-rhs L7-04_4_e1_rule ((sem-edge (var g) (L7-04_4_e1_rule_p1 (var e1) (var e2)) Member (L7-04_4_sk_extinguish (var x)) extinguish) (sem-edge-tv (var g) (L7-04_4_e1_rule_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L7-04_4_e1_rule_p2 (var e1) (var e2)) Agent (L7-04_4_sk_extinguish (var x)) L7-04_4_sk_wind_1) (sem-edge-tv (var g) (L7-04_4_e1_rule_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L7-04_4_e1_rule_p3 (var e1) (var e2)) Object (L7-04_4_sk_extinguish (var x)) (var x)) (sem-edge-tv (var g) (L7-04_4_e1_rule_p3 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L7-04.6: Whenever a Keeper mixes salt-bloom into mire-essence, that mire-essence burns slowly.
(sem-rule L7-04_6_whenever_mix_burn)
(rule-context L7-04_6_whenever_mix_burn aelmere-lore)
(rule-priority L7-04_6_whenever_mix_burn 214)
(rule-tv L7-04_6_whenever_mix_burn authored 1.0 0.9)
(rule-lhs L7-04_6_whenever_mix_burn ((sem-edge (var g) (var e1) Member (var k) keeper) (sem-edge (var g) (var e2) Member (var e) mix) (sem-edge (var g) (var e3) Agent (var e) (var k)) (sem-edge (var g) (var e4) Object (var e) (var t1)) (sem-edge (var g) (var e5) Member (var t1) salt_bloom) (sem-edge (var g) (var e6) Goal (var e) (var m)) (sem-edge (var g) (var e7) Member (var m) mire_essence)))
(rule-rhs L7-04_6_whenever_mix_burn ((sem-edge (var g) (L7-04_6_whenever_mix_burn_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Member (L7-04_6_sk_burn (var e)) burn) (sem-edge-tv (var g) (L7-04_6_whenever_mix_burn_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (L7-04_6_whenever_mix_burn_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Object (L7-04_6_sk_burn (var e)) (var m)) (sem-edge-tv (var g) (L7-04_6_whenever_mix_burn_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (L7-04_6_whenever_mix_burn_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Manner (L7-04_6_sk_burn (var e)) slowly) (sem-edge-tv (var g) (L7-04_6_whenever_mix_burn_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (L7-04_6_whenever_mix_burn_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) During (L7-04_6_sk_burn (var e)) (var e)) (sem-edge-tv (var g) (L7-04_6_whenever_mix_burn_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9))))

; --- L7-04.7: Salt-bloomed lanterns survive cold-threshold nights.
(sem-rule L7-04_7_lantern_survive_rule)
(rule-context L7-04_7_lantern_survive_rule aelmere-lore)
(rule-priority L7-04_7_lantern_survive_rule 215)
(rule-tv L7-04_7_lantern_survive_rule authored 0.9 0.9)
(rule-lhs L7-04_7_lantern_survive_rule ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) Member (var x) salt_bloomed)))
(rule-rhs L7-04_7_lantern_survive_rule ((sem-edge (var g) (L7-04_7_lantern_survive_rule_p1 (var e1) (var e2)) Member (L7-04_7_sk_survive (var x)) survive) (sem-edge-tv (var g) (L7-04_7_lantern_survive_rule_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L7-04_7_lantern_survive_rule_p2 (var e1) (var e2)) Agent (L7-04_7_sk_survive (var x)) (var x)) (sem-edge-tv (var g) (L7-04_7_lantern_survive_rule_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L7-04_7_lantern_survive_rule_p3 (var e1) (var e2)) Object (L7-04_7_sk_survive (var x)) cold_threshold_night) (sem-edge-tv (var g) (L7-04_7_lantern_survive_rule_p3 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L7-04.8: Whenever a cold-threshold night comes, unprepared lanterns on the Cliff Path die.
(sem-rule L7-04_8_night_lantern_die_rule)
(rule-context L7-04_8_night_lantern_die_rule aelmere-lore)
(rule-priority L7-04_8_night_lantern_die_rule 216)
(rule-tv L7-04_8_night_lantern_die_rule authored 1.0 0.9)
(rule-lhs L7-04_8_night_lantern_die_rule ((sem-edge (var g) (var e1) Member (var e) come) (sem-edge (var g) (var e2) Object (var e) (var n)) (sem-edge (var g) (var e3) Member (var n) cold_threshold_night) (sem-edge (var g) (var e4) Member (var l) lantern) (sem-edge (var g) (var e5) Member (var l) unprepared) (sem-edge (var g) (var e6) AttachedTo (var l) cliff_path)))
(rule-rhs L7-04_8_night_lantern_die_rule ((sem-edge (var g) (L7-04_8_night_lantern_die_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Member (L7-04_8_sk_die (var e) (var l)) die) (sem-edge-tv (var g) (L7-04_8_night_lantern_die_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L7-04_8_night_lantern_die_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) Object (L7-04_8_sk_die (var e) (var l)) (var l)) (sem-edge-tv (var g) (L7-04_8_night_lantern_die_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9)) (sem-edge (var g) (L7-04_8_night_lantern_die_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) During (L7-04_8_sk_die (var e) (var l)) (var e)) (sem-edge-tv (var g) (L7-04_8_night_lantern_die_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6)) (STV 1.0 0.9))))

; --- L7-05.1: Autumn storms come over the Cold Sea.
(sem-rule L7-05_1_storm_come_rule)
(rule-context L7-05_1_storm_come_rule aelmere-lore)
(rule-priority L7-05_1_storm_come_rule 217)
(rule-tv L7-05_1_storm_come_rule authored 0.9 0.9)
(rule-lhs L7-05_1_storm_come_rule ((sem-edge (var g) (var e1) Member (var s) autumn_storm)))
(rule-rhs L7-05_1_storm_come_rule ((sem-edge (var g) (L7-05_1_storm_come_rule_p1 (var e1)) Member (L7-05_1_sk_come (var s)) come) (sem-edge-tv (var g) (L7-05_1_storm_come_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L7-05_1_storm_come_rule_p2 (var e1)) Object (L7-05_1_sk_come (var s)) (var s)) (sem-edge-tv (var g) (L7-05_1_storm_come_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L7-05_1_storm_come_rule_p3 (var e1)) Over (L7-05_1_sk_come (var s)) cold_sea) (sem-edge-tv (var g) (L7-05_1_storm_come_rule_p3 (var e1)) (STV 0.9 0.9))))

; --- L7-05.2: Early-winter storms come over the Cold Sea.
(sem-rule L7-05_2_storm_come_rule)
(rule-context L7-05_2_storm_come_rule aelmere-lore)
(rule-priority L7-05_2_storm_come_rule 218)
(rule-tv L7-05_2_storm_come_rule authored 0.9 0.9)
(rule-lhs L7-05_2_storm_come_rule ((sem-edge (var g) (var e1) Member (var x) early_winter_storm)))
(rule-rhs L7-05_2_storm_come_rule ((sem-edge (var g) (L7-05_2_storm_come_rule_p1 (var e1)) Member (L7-05_2_sk_come (var x)) come) (sem-edge-tv (var g) (L7-05_2_storm_come_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L7-05_2_storm_come_rule_p2 (var e1)) Object (L7-05_2_sk_come (var x)) (var x)) (sem-edge-tv (var g) (L7-05_2_storm_come_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L7-05_2_storm_come_rule_p3 (var e1)) Location (L7-05_2_sk_come (var x)) cold_sea) (sem-edge-tv (var g) (L7-05_2_storm_come_rule_p3 (var e1)) (STV 0.9 0.9))))

; --- L7-05.4: Autumn storms sometimes destroy Cliff Path lanterns.
(sem-rule L7-05_4_storms_destroy)
(rule-context L7-05_4_storms_destroy aelmere-lore)
(rule-priority L7-05_4_storms_destroy 219)
(rule-tv L7-05_4_storms_destroy authored 0.5 0.9)
(rule-lhs L7-05_4_storms_destroy ((sem-edge (var g) (var e1) Member (var x) autumn_storm)))
(rule-rhs L7-05_4_storms_destroy ((sem-edge (var g) (L7-05_4_storms_destroy_p1 (var e1)) Member (L7-05_4_sk_destroy (var x)) destroy) (sem-edge-tv (var g) (L7-05_4_storms_destroy_p1 (var e1)) (STV 0.5 0.9)) (sem-edge (var g) (L7-05_4_storms_destroy_p2 (var e1)) Agent (L7-05_4_sk_destroy (var x)) (var x)) (sem-edge-tv (var g) (L7-05_4_storms_destroy_p2 (var e1)) (STV 0.5 0.9)) (sem-edge (var g) (L7-05_4_storms_destroy_p3 (var e1)) Object (L7-05_4_sk_destroy (var x)) (L7-05_4_sk_lantern (var x))) (sem-edge-tv (var g) (L7-05_4_storms_destroy_p3 (var e1)) (STV 0.5 0.9)) (sem-edge (var g) (L7-05_4_storms_destroy_p4 (var e1)) Member (L7-05_4_sk_lantern (var x)) lantern) (sem-edge-tv (var g) (L7-05_4_storms_destroy_p4 (var e1)) (STV 0.5 0.9)) (sem-edge (var g) (L7-05_4_storms_destroy_p5 (var e1)) Possession (L7-05_4_sk_lantern (var x)) cliff_path) (sem-edge-tv (var g) (L7-05_4_storms_destroy_p5 (var e1)) (STV 0.5 0.9))))

; --- L7-05.8: A bad winter for lanterns is a bad winter for fishing.
(sem-rule L7-05_8_winter_bad_rule)
(rule-context L7-05_8_winter_bad_rule aelmere-lore)
(rule-priority L7-05_8_winter_bad_rule 220)
(rule-tv L7-05_8_winter_bad_rule authored 0.9 0.9)
(rule-lhs L7-05_8_winter_bad_rule ((sem-edge (var g) (var e1) Member (var w) winter) (sem-edge (var g) (var e2) Member (var w) bad_for_lanterns)))
(rule-rhs L7-05_8_winter_bad_rule ((sem-edge (var g) (L7-05_8_winter_bad_rule_p1 (var e1) (var e2)) Member (var w) bad_for_fishing) (sem-edge-tv (var g) (L7-05_8_winter_bad_rule_p1 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L7-06.1: Retreating spring tides sometimes trap small fish in the tide-pools.
(sem-rule L7-06_1_retreat_trap_rule)
(rule-context L7-06_1_retreat_trap_rule aelmere-lore)
(rule-priority L7-06_1_retreat_trap_rule 221)
(rule-tv L7-06_1_retreat_trap_rule authored 0.5 0.9)
(rule-lhs L7-06_1_retreat_trap_rule ((sem-edge (var g) (var e1) Member (var x) spring_tide) (sem-edge (var g) (var e2) Member (var x) retreating)))
(rule-rhs L7-06_1_retreat_trap_rule ((sem-edge (var g) (L7-06_1_retreat_trap_rule_p1 (var e1) (var e2)) Member (L7-06_1_sk_trap (var x)) trap) (sem-edge-tv (var g) (L7-06_1_retreat_trap_rule_p1 (var e1) (var e2)) (STV 0.5 0.9)) (sem-edge (var g) (L7-06_1_retreat_trap_rule_p2 (var e1) (var e2)) Agent (L7-06_1_sk_trap (var x)) (var x)) (sem-edge-tv (var g) (L7-06_1_retreat_trap_rule_p2 (var e1) (var e2)) (STV 0.5 0.9)) (sem-edge (var g) (L7-06_1_retreat_trap_rule_p3 (var e1) (var e2)) Object (L7-06_1_sk_trap (var x)) (L7-06_1_sk_fish (var x))) (sem-edge-tv (var g) (L7-06_1_retreat_trap_rule_p3 (var e1) (var e2)) (STV 0.5 0.9)) (sem-edge (var g) (L7-06_1_retreat_trap_rule_p4 (var e1) (var e2)) Member (L7-06_1_sk_fish (var x)) fish) (sem-edge-tv (var g) (L7-06_1_retreat_trap_rule_p4 (var e1) (var e2)) (STV 0.5 0.9)) (sem-edge (var g) (L7-06_1_retreat_trap_rule_p5 (var e1) (var e2)) Member (L7-06_1_sk_fish (var x)) small) (sem-edge-tv (var g) (L7-06_1_retreat_trap_rule_p5 (var e1) (var e2)) (STV 0.5 0.9)) (sem-edge (var g) (L7-06_1_retreat_trap_rule_p6 (var e1) (var e2)) Location (L7-06_1_sk_trap (var x)) salt_bloom_tide_pools) (sem-edge-tv (var g) (L7-06_1_retreat_trap_rule_p6 (var e1) (var e2)) (STV 0.5 0.9))))

; --- L7-06.2: Keepers take the trapped fish home on harvest mornings.
(sem-rule L7-06_2_keepers_take_rule)
(rule-context L7-06_2_keepers_take_rule aelmere-lore)
(rule-priority L7-06_2_keepers_take_rule 222)
(rule-tv L7-06_2_keepers_take_rule authored 0.9 0.9)
(rule-lhs L7-06_2_keepers_take_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L7-06_2_keepers_take_rule ((sem-edge (var g) (L7-06_2_keepers_take_rule_p1 (var e1)) Member (L7-06_2_sk_take (var x)) take) (sem-edge-tv (var g) (L7-06_2_keepers_take_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L7-06_2_keepers_take_rule_p2 (var e1)) Agent (L7-06_2_sk_take (var x)) (var x)) (sem-edge-tv (var g) (L7-06_2_keepers_take_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L7-06_2_keepers_take_rule_p3 (var e1)) Object (L7-06_2_sk_take (var x)) (L7-06_2_sk_fish (var x))) (sem-edge-tv (var g) (L7-06_2_keepers_take_rule_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L7-06_2_keepers_take_rule_p4 (var e1)) Member (L7-06_2_sk_fish (var x)) fish) (sem-edge-tv (var g) (L7-06_2_keepers_take_rule_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L7-06_2_keepers_take_rule_p5 (var e1)) Member (L7-06_2_sk_fish (var x)) trapped) (sem-edge-tv (var g) (L7-06_2_keepers_take_rule_p5 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L7-06_2_keepers_take_rule_p6 (var e1)) Goal (L7-06_2_sk_take (var x)) home) (sem-edge-tv (var g) (L7-06_2_keepers_take_rule_p6 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L7-06_2_keepers_take_rule_p7 (var e1)) Time (L7-06_2_sk_take (var x)) harvest_morning) (sem-edge-tv (var g) (L7-06_2_keepers_take_rule_p7 (var e1)) (STV 0.9 0.9))))

; --- L8-01.4: Mire-essence burns with a pale silver flame.
(sem-rule L8-01_4_me_burn_rule)
(rule-context L8-01_4_me_burn_rule aelmere-lore)
(rule-priority L8-01_4_me_burn_rule 223)
(rule-tv L8-01_4_me_burn_rule authored 0.9 0.9)
(rule-lhs L8-01_4_me_burn_rule ((sem-edge (var g) (var e1) Member (var x) mire_essence)))
(rule-rhs L8-01_4_me_burn_rule ((sem-edge (var g) (L8-01_4_me_burn_rule_p1 (var e1)) Member (L8-01_4_sk_burn (var x)) burn) (sem-edge-tv (var g) (L8-01_4_me_burn_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-01_4_me_burn_rule_p2 (var e1)) Object (L8-01_4_sk_burn (var x)) (var x)) (sem-edge-tv (var g) (L8-01_4_me_burn_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-01_4_me_burn_rule_p3 (var e1)) Instrument (L8-01_4_sk_burn (var x)) (L8-01_4_sk_flame (var x))) (sem-edge-tv (var g) (L8-01_4_me_burn_rule_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-01_4_me_burn_rule_p4 (var e1)) Member (L8-01_4_sk_flame (var x)) flame) (sem-edge-tv (var g) (L8-01_4_me_burn_rule_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-01_4_me_burn_rule_p5 (var e1)) Member (L8-01_4_sk_flame (var x)) pale) (sem-edge-tv (var g) (L8-01_4_me_burn_rule_p5 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-01_4_me_burn_rule_p6 (var e1)) Member (L8-01_4_sk_flame (var x)) silver) (sem-edge-tv (var g) (L8-01_4_me_burn_rule_p6 (var e1)) (STV 0.9 0.9))))

; --- L8-01.7: Keepers make mire-essence from silken threads and sea-water.
(sem-rule L8-01_7_keepers_make)
(rule-context L8-01_7_keepers_make aelmere-lore)
(rule-priority L8-01_7_keepers_make 224)
(rule-tv L8-01_7_keepers_make authored 0.9 0.9)
(rule-lhs L8-01_7_keepers_make ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L8-01_7_keepers_make ((sem-edge (var g) (L8-01_7_keepers_make_p1 (var e1)) Member (L8-01_7_sk_make (var x)) make) (sem-edge-tv (var g) (L8-01_7_keepers_make_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-01_7_keepers_make_p2 (var e1)) Agent (L8-01_7_sk_make (var x)) (var x)) (sem-edge-tv (var g) (L8-01_7_keepers_make_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-01_7_keepers_make_p3 (var e1)) Object (L8-01_7_sk_make (var x)) mire_essence) (sem-edge-tv (var g) (L8-01_7_keepers_make_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-01_7_keepers_make_p4 (var e1)) Source (L8-01_7_sk_make (var x)) silken_thread) (sem-edge-tv (var g) (L8-01_7_keepers_make_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-01_7_keepers_make_p5 (var e1)) Source (L8-01_7_sk_make (var x)) sea_water) (sem-edge-tv (var g) (L8-01_7_keepers_make_p5 (var e1)) (STV 0.9 0.9))))

; --- L8-02.1: Stored mire-essence stays good for years.
(sem-rule L8-02_1_me1_rule)
(rule-context L8-02_1_me1_rule aelmere-lore)
(rule-priority L8-02_1_me1_rule 225)
(rule-tv L8-02_1_me1_rule authored 0.9 0.9)
(rule-lhs L8-02_1_me1_rule ((sem-edge (var g) (var e1) Member (var x) mire_essence) (sem-edge (var g) (var e2) Member (var x) stored)))
(rule-rhs L8-02_1_me1_rule ((sem-edge (var g) (L8-02_1_me1_rule_p1 (var e1) (var e2)) Member (L8-02_1_sk_good (var x)) good) (sem-edge-tv (var g) (L8-02_1_me1_rule_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L8-02_1_me1_rule_p2 (var e1) (var e2)) Experiencer (L8-02_1_sk_good (var x)) (var x)) (sem-edge-tv (var g) (L8-02_1_me1_rule_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L8-02_1_me1_rule_p3 (var e1) (var e2)) Still (L8-02_1_sk_good (var x))) (sem-edge-tv (var g) (L8-02_1_me1_rule_p3 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L8-02_1_me1_rule_p4 (var e1) (var e2)) Member (var x) good) (sem-edge-tv (var g) (L8-02_1_me1_rule_p4 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L8-02_1_me1_rule_p5 (var e1) (var e2)) MeasureAtLeast (L8-02_1_sk_good (var x)) duration 2 year) (sem-edge-tv (var g) (L8-02_1_me1_rule_p5 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L8-03.1: Silken threads are the deposits that nightmoths leave on lantern rims.
(sem-rule L8-03_1_nm_leave_rule)
(rule-context L8-03_1_nm_leave_rule aelmere-lore)
(rule-priority L8-03_1_nm_leave_rule 226)
(rule-tv L8-03_1_nm_leave_rule authored 0.9 0.9)
(rule-lhs L8-03_1_nm_leave_rule ((sem-edge (var g) (var e1) Member (var x) nightmoth)))
(rule-rhs L8-03_1_nm_leave_rule ((sem-edge (var g) (L8-03_1_nm_leave_rule_p1 (var e1)) Member (L8-03_1_sk_leave (var x)) leave) (sem-edge-tv (var g) (L8-03_1_nm_leave_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-03_1_nm_leave_rule_p2 (var e1)) Agent (L8-03_1_sk_leave (var x)) (var x)) (sem-edge-tv (var g) (L8-03_1_nm_leave_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-03_1_nm_leave_rule_p3 (var e1)) Object (L8-03_1_sk_leave (var x)) silken_thread) (sem-edge-tv (var g) (L8-03_1_nm_leave_rule_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-03_1_nm_leave_rule_p4 (var e1)) Location (L8-03_1_sk_leave (var x)) lantern_rim) (sem-edge-tv (var g) (L8-03_1_nm_leave_rule_p4 (var e1)) (STV 0.9 0.9))))

; --- L8-03.3: Keepers scrape the threads off the warm stone with a flat blade.
(sem-rule L8-03_3_keeper_scrape)
(rule-context L8-03_3_keeper_scrape aelmere-lore)
(rule-priority L8-03_3_keeper_scrape 227)
(rule-tv L8-03_3_keeper_scrape authored 0.9 0.9)
(rule-lhs L8-03_3_keeper_scrape ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L8-03_3_keeper_scrape ((sem-edge (var g) (L8-03_3_keeper_scrape_p1 (var e1)) Member (L8-03_3_sk_scrape (var x)) scrape) (sem-edge-tv (var g) (L8-03_3_keeper_scrape_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-03_3_keeper_scrape_p2 (var e1)) Agent (L8-03_3_sk_scrape (var x)) (var x)) (sem-edge-tv (var g) (L8-03_3_keeper_scrape_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-03_3_keeper_scrape_p3 (var e1)) Object (L8-03_3_sk_scrape (var x)) L8-03_3_sk_thread_1) (sem-edge-tv (var g) (L8-03_3_keeper_scrape_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-03_3_keeper_scrape_p4 (var e1)) Source (L8-03_3_sk_scrape (var x)) L8-03_3_sk_stone_1) (sem-edge-tv (var g) (L8-03_3_keeper_scrape_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-03_3_keeper_scrape_p5 (var e1)) Instrument (L8-03_3_sk_scrape (var x)) (L8-03_3_sk_blade (var x))) (sem-edge-tv (var g) (L8-03_3_keeper_scrape_p5 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-03_3_keeper_scrape_p6 (var e1)) Member (L8-03_3_sk_blade (var x)) blade) (sem-edge-tv (var g) (L8-03_3_keeper_scrape_p6 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-03_3_keeper_scrape_p7 (var e1)) Member (L8-03_3_sk_blade (var x)) flat) (sem-edge-tv (var g) (L8-03_3_keeper_scrape_p7 (var e1)) (STV 0.9 0.9))))

; --- L8-03.4: Well-attended lanterns yield a small heap of threads each night in moth-season.
(sem-rule L8-03_4_lantern_yield_rule)
(rule-context L8-03_4_lantern_yield_rule aelmere-lore)
(rule-priority L8-03_4_lantern_yield_rule 228)
(rule-tv L8-03_4_lantern_yield_rule authored 0.9 0.9)
(rule-lhs L8-03_4_lantern_yield_rule ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) Member (var x) well_attended)))
(rule-rhs L8-03_4_lantern_yield_rule ((sem-edge (var g) (L8-03_4_lantern_yield_rule_p1 (var e1) (var e2)) Member (L8-03_4_sk_yield (var x)) yield) (sem-edge-tv (var g) (L8-03_4_lantern_yield_rule_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L8-03_4_lantern_yield_rule_p2 (var e1) (var e2)) Agent (L8-03_4_sk_yield (var x)) (var x)) (sem-edge-tv (var g) (L8-03_4_lantern_yield_rule_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L8-03_4_lantern_yield_rule_p3 (var e1) (var e2)) Object (L8-03_4_sk_yield (var x)) (L8-03_4_sk_heap (var x))) (sem-edge-tv (var g) (L8-03_4_lantern_yield_rule_p3 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L8-03_4_lantern_yield_rule_p4 (var e1) (var e2)) Member (L8-03_4_sk_heap (var x)) heap) (sem-edge-tv (var g) (L8-03_4_lantern_yield_rule_p4 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L8-03_4_lantern_yield_rule_p5 (var e1) (var e2)) Member (L8-03_4_sk_heap (var x)) small) (sem-edge-tv (var g) (L8-03_4_lantern_yield_rule_p5 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L8-03_4_lantern_yield_rule_p6 (var e1) (var e2)) GroupOf (L8-03_4_sk_heap (var x)) thread) (sem-edge-tv (var g) (L8-03_4_lantern_yield_rule_p6 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L8-03_4_lantern_yield_rule_p7 (var e1) (var e2)) Time (L8-03_4_sk_yield (var x)) night) (sem-edge-tv (var g) (L8-03_4_lantern_yield_rule_p7 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L8-03_4_lantern_yield_rule_p8 (var e1) (var e2)) Every (L8-03_4_sk_yield (var x)) 1 day) (sem-edge-tv (var g) (L8-03_4_lantern_yield_rule_p8 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L8-03_4_lantern_yield_rule_p9 (var e1) (var e2)) Time (L8-03_4_sk_yield (var x)) moth_season) (sem-edge-tv (var g) (L8-03_4_lantern_yield_rule_p9 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L8-04.2: Whenever a tide-pool stone is submerged, salt-bloom grows on that stone.
(sem-rule L8-04_2_whenever_submerge_grow)
(rule-context L8-04_2_whenever_submerge_grow aelmere-lore)
(rule-priority L8-04_2_whenever_submerge_grow 229)
(rule-tv L8-04_2_whenever_submerge_grow authored 1.0 0.9)
(rule-lhs L8-04_2_whenever_submerge_grow ((sem-edge (var g) (var e1) Member (var e) submerge) (sem-edge (var g) (var e2) Object (var e) (var s)) (sem-edge (var g) (var e3) Member (var s) tide_pool_stone)))
(rule-rhs L8-04_2_whenever_submerge_grow ((sem-edge (var g) (L8-04_2_whenever_submerge_grow_p1 (var e1) (var e2) (var e3)) Member (L8-04_2_sk_grow (var e)) grow) (sem-edge-tv (var g) (L8-04_2_whenever_submerge_grow_p1 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L8-04_2_whenever_submerge_grow_p2 (var e1) (var e2) (var e3)) Object (L8-04_2_sk_grow (var e)) salt_bloom) (sem-edge-tv (var g) (L8-04_2_whenever_submerge_grow_p2 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L8-04_2_whenever_submerge_grow_p3 (var e1) (var e2) (var e3)) Location (L8-04_2_sk_grow (var e)) (var s)) (sem-edge-tv (var g) (L8-04_2_whenever_submerge_grow_p3 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L8-04_2_whenever_submerge_grow_p4 (var e1) (var e2) (var e3)) During (L8-04_2_sk_grow (var e)) (var e)) (sem-edge-tv (var g) (L8-04_2_whenever_submerge_grow_p4 (var e1) (var e2) (var e3)) (STV 1.0 0.9))))

; --- L8-04.3: Salt-bloom crusts have a faint smell of salt.
(sem-rule L8-04_3_sbc_have_rule)
(rule-context L8-04_3_sbc_have_rule aelmere-lore)
(rule-priority L8-04_3_sbc_have_rule 230)
(rule-tv L8-04_3_sbc_have_rule authored 0.9 0.9)
(rule-lhs L8-04_3_sbc_have_rule ((sem-edge (var g) (var e1) Member (var x) salt_bloom_crust)))
(rule-rhs L8-04_3_sbc_have_rule ((sem-edge (var g) (L8-04_3_sbc_have_rule_p1 (var e1)) Member (L8-04_3_sk_have (var x)) have) (sem-edge-tv (var g) (L8-04_3_sbc_have_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-04_3_sbc_have_rule_p2 (var e1)) Holder (L8-04_3_sk_have (var x)) (var x)) (sem-edge-tv (var g) (L8-04_3_sbc_have_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-04_3_sbc_have_rule_p3 (var e1)) Object (L8-04_3_sk_have (var x)) (L8-04_3_sk_smell (var x))) (sem-edge-tv (var g) (L8-04_3_sbc_have_rule_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-04_3_sbc_have_rule_p4 (var e1)) Member (L8-04_3_sk_smell (var x)) smell) (sem-edge-tv (var g) (L8-04_3_sbc_have_rule_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-04_3_sbc_have_rule_p5 (var e1)) Member (L8-04_3_sk_smell (var x)) faint) (sem-edge-tv (var g) (L8-04_3_sbc_have_rule_p5 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-04_3_sbc_have_rule_p6 (var e1)) Of (L8-04_3_sk_smell (var x)) salt) (sem-edge-tv (var g) (L8-04_3_sbc_have_rule_p6 (var e1)) (STV 0.9 0.9))))

; --- L8-04.4: Keepers harvest salt-bloom with a wooden scraper.
(sem-rule L8-04_4_keepers_harvest)
(rule-context L8-04_4_keepers_harvest aelmere-lore)
(rule-priority L8-04_4_keepers_harvest 231)
(rule-tv L8-04_4_keepers_harvest authored 0.9 0.9)
(rule-lhs L8-04_4_keepers_harvest ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L8-04_4_keepers_harvest ((sem-edge (var g) (L8-04_4_keepers_harvest_p1 (var e1)) Member (L8-04_4_sk_harvest (var x)) harvest) (sem-edge-tv (var g) (L8-04_4_keepers_harvest_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-04_4_keepers_harvest_p2 (var e1)) Agent (L8-04_4_sk_harvest (var x)) (var x)) (sem-edge-tv (var g) (L8-04_4_keepers_harvest_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-04_4_keepers_harvest_p3 (var e1)) Object (L8-04_4_sk_harvest (var x)) salt_bloom) (sem-edge-tv (var g) (L8-04_4_keepers_harvest_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-04_4_keepers_harvest_p4 (var e1)) Instrument (L8-04_4_sk_harvest (var x)) (L8-04_4_sk_scraper (var x))) (sem-edge-tv (var g) (L8-04_4_keepers_harvest_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-04_4_keepers_harvest_p5 (var e1)) Member (L8-04_4_sk_scraper (var x)) wooden_scraper) (sem-edge-tv (var g) (L8-04_4_keepers_harvest_p5 (var e1)) (STV 0.9 0.9))))

; --- L8-04.7: Keepers add salt-bloom to mire-essence in winter.
(sem-rule L8-04_7_e3_rule)
(rule-context L8-04_7_e3_rule aelmere-lore)
(rule-priority L8-04_7_e3_rule 232)
(rule-tv L8-04_7_e3_rule authored 0.9 0.9)
(rule-lhs L8-04_7_e3_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L8-04_7_e3_rule ((sem-edge (var g) (L8-04_7_e3_rule_p1 (var e1)) Member (L8-04_7_sk_add (var x)) add) (sem-edge-tv (var g) (L8-04_7_e3_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-04_7_e3_rule_p2 (var e1)) Agent (L8-04_7_sk_add (var x)) (var x)) (sem-edge-tv (var g) (L8-04_7_e3_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-04_7_e3_rule_p3 (var e1)) Object (L8-04_7_sk_add (var x)) salt_bloom) (sem-edge-tv (var g) (L8-04_7_e3_rule_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-04_7_e3_rule_p4 (var e1)) Goal (L8-04_7_sk_add (var x)) mire_essence) (sem-edge-tv (var g) (L8-04_7_e3_rule_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-04_7_e3_rule_p5 (var e1)) Time (L8-04_7_sk_add (var x)) winter) (sem-edge-tv (var g) (L8-04_7_e3_rule_p5 (var e1)) (STV 0.9 0.9))))

; --- L8-04.8: Whenever a Keeper adds salt-bloom to mire-essence, that mire-essence burns slowly.
(sem-rule L8-04_8_whenever_add_burn)
(rule-context L8-04_8_whenever_add_burn aelmere-lore)
(rule-priority L8-04_8_whenever_add_burn 233)
(rule-tv L8-04_8_whenever_add_burn authored 1.0 0.9)
(rule-lhs L8-04_8_whenever_add_burn ((sem-edge (var g) (var e1) Member (var k) keeper) (sem-edge (var g) (var e2) Member (var a) add) (sem-edge (var g) (var e3) Agent (var a) (var k)) (sem-edge (var g) (var e4) Object (var a) (var t1)) (sem-edge (var g) (var e5) Member (var t1) salt_bloom) (sem-edge (var g) (var e6) Goal (var a) (var m)) (sem-edge (var g) (var e7) Member (var m) mire_essence)))
(rule-rhs L8-04_8_whenever_add_burn ((sem-edge (var g) (L8-04_8_whenever_add_burn_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Member (L8-04_8_sk_burn (var a)) burn) (sem-edge-tv (var g) (L8-04_8_whenever_add_burn_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (L8-04_8_whenever_add_burn_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Agent (L8-04_8_sk_burn (var a)) (var m)) (sem-edge-tv (var g) (L8-04_8_whenever_add_burn_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (L8-04_8_whenever_add_burn_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) Manner (L8-04_8_sk_burn (var a)) slowly) (sem-edge-tv (var g) (L8-04_8_whenever_add_burn_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9)) (sem-edge (var g) (L8-04_8_whenever_add_burn_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) During (L8-04_8_sk_burn (var a)) (var a)) (sem-edge-tv (var g) (L8-04_8_whenever_add_burn_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7)) (STV 1.0 0.9))))

; --- L8-05.2: Wintergloss grows in the Hollows.
(sem-rule L8-05_2_wintergloss_grow_hollows)
(rule-context L8-05_2_wintergloss_grow_hollows aelmere-lore)
(rule-priority L8-05_2_wintergloss_grow_hollows 234)
(rule-tv L8-05_2_wintergloss_grow_hollows authored 0.9 0.9)
(rule-lhs L8-05_2_wintergloss_grow_hollows ((sem-edge (var g) (var e1) Member (var x) wintergloss)))
(rule-rhs L8-05_2_wintergloss_grow_hollows ((sem-edge (var g) (L8-05_2_wintergloss_grow_hollows_p1 (var e1)) Member (L8-05_2_sk_grow (var x)) grow) (sem-edge-tv (var g) (L8-05_2_wintergloss_grow_hollows_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-05_2_wintergloss_grow_hollows_p2 (var e1)) Object (L8-05_2_sk_grow (var x)) (var x)) (sem-edge-tv (var g) (L8-05_2_wintergloss_grow_hollows_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-05_2_wintergloss_grow_hollows_p3 (var e1)) Location (L8-05_2_sk_grow (var x)) hollows) (sem-edge-tv (var g) (L8-05_2_wintergloss_grow_hollows_p3 (var e1)) (STV 0.9 0.9))))

; --- L8-05.4: Whenever a lantern burns dried wintergloss alongside mire-essence, the wintergloss repels nightmoths from that lantern.
(sem-rule L8-05_4_lantern_burn_repel_rule)
(rule-context L8-05_4_lantern_burn_repel_rule aelmere-lore)
(rule-priority L8-05_4_lantern_burn_repel_rule 235)
(rule-tv L8-05_4_lantern_burn_repel_rule authored 1.0 0.9)
(rule-lhs L8-05_4_lantern_burn_repel_rule ((sem-edge (var g) (var e1) Member (var e) burn) (sem-edge (var g) (var e2) Agent (var e) (var x)) (sem-edge (var g) (var e3) Member (var x) lantern) (sem-edge (var g) (var e4) Object (var e) (var y)) (sem-edge (var g) (var e5) Member (var y) wintergloss) (sem-edge (var g) (var e6) Member (var y) dried) (sem-edge (var g) (var e7) Alongside (var e) (var t1)) (sem-edge (var g) (var e8) Member (var t1) mire_essence)))
(rule-rhs L8-05_4_lantern_burn_repel_rule ((sem-edge (var g) (L8-05_4_lantern_burn_repel_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Member (L8-05_4_sk_repel (var e)) repel) (sem-edge-tv (var g) (L8-05_4_lantern_burn_repel_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (L8-05_4_lantern_burn_repel_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Agent (L8-05_4_sk_repel (var e)) (var y)) (sem-edge-tv (var g) (L8-05_4_lantern_burn_repel_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (L8-05_4_lantern_burn_repel_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Object (L8-05_4_sk_repel (var e)) nightmoth) (sem-edge-tv (var g) (L8-05_4_lantern_burn_repel_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (L8-05_4_lantern_burn_repel_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Source (L8-05_4_sk_repel (var e)) (var x)) (sem-edge-tv (var g) (L8-05_4_lantern_burn_repel_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (L8-05_4_lantern_burn_repel_rule_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) During (L8-05_4_sk_repel (var e)) (var e)) (sem-edge-tv (var g) (L8-05_4_lantern_burn_repel_rule_p5 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9))))

; --- L8-05.5: Keepers rarely burn wintergloss.
(sem-rule L8-05_5_n4_keeper_burn_rule)
(rule-context L8-05_5_n4_keeper_burn_rule aelmere-lore)
(rule-priority L8-05_5_n4_keeper_burn_rule 236)
(rule-tv L8-05_5_n4_keeper_burn_rule authored 0.1 0.9)
(rule-lhs L8-05_5_n4_keeper_burn_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L8-05_5_n4_keeper_burn_rule ((sem-edge (var g) (L8-05_5_n4_keeper_burn_rule_p1 (var e1)) And (Member (L8-05_5_sk_burn (var x)) burn) (Agent (L8-05_5_sk_burn (var x)) (var x)) (Object (L8-05_5_sk_burn (var x)) wintergloss)) (sem-edge-tv (var g) (L8-05_5_n4_keeper_burn_rule_p1 (var e1)) (STV 0.1 0.9))))

; --- L8-06.1: Collectors dry the feathers from sky-cats.
(sem-rule L8-06_1_collectors_dry)
(rule-context L8-06_1_collectors_dry aelmere-lore)
(rule-priority L8-06_1_collectors_dry 237)
(rule-tv L8-06_1_collectors_dry authored 0.9 0.9)
(rule-lhs L8-06_1_collectors_dry ((sem-edge (var g) (var e1) Member (var x) collector)))
(rule-rhs L8-06_1_collectors_dry ((sem-edge (var g) (L8-06_1_collectors_dry_p1 (var e1)) Member (L8-06_1_sk_dry (var x)) dry) (sem-edge-tv (var g) (L8-06_1_collectors_dry_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-06_1_collectors_dry_p2 (var e1)) Agent (L8-06_1_sk_dry (var x)) (var x)) (sem-edge-tv (var g) (L8-06_1_collectors_dry_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-06_1_collectors_dry_p3 (var e1)) Object (L8-06_1_sk_dry (var x)) L8-06_1_sk_feather_1) (sem-edge-tv (var g) (L8-06_1_collectors_dry_p3 (var e1)) (STV 0.9 0.9))))

; --- L8-06.2: Collectors grind the dried feathers in a mortar.
(sem-rule L8-06_2_e2_collectors_grind)
(rule-context L8-06_2_e2_collectors_grind aelmere-lore)
(rule-priority L8-06_2_e2_collectors_grind 238)
(rule-tv L8-06_2_e2_collectors_grind authored 0.9 0.9)
(rule-lhs L8-06_2_e2_collectors_grind ((sem-edge (var g) (var e1) Member (var x) collector)))
(rule-rhs L8-06_2_e2_collectors_grind ((sem-edge (var g) (L8-06_2_e2_collectors_grind_p1 (var e1)) Member (L8-06_2_sk_grind (var x)) grind) (sem-edge-tv (var g) (L8-06_2_e2_collectors_grind_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-06_2_e2_collectors_grind_p2 (var e1)) Agent (L8-06_2_sk_grind (var x)) (var x)) (sem-edge-tv (var g) (L8-06_2_e2_collectors_grind_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-06_2_e2_collectors_grind_p3 (var e1)) Object (L8-06_2_sk_grind (var x)) L8-06_2_sk_feathers_1) (sem-edge-tv (var g) (L8-06_2_e2_collectors_grind_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-06_2_e2_collectors_grind_p4 (var e1)) Location (L8-06_2_sk_grind (var x)) (L8-06_2_sk_mortar (var x))) (sem-edge-tv (var g) (L8-06_2_e2_collectors_grind_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-06_2_e2_collectors_grind_p5 (var e1)) Member (L8-06_2_sk_mortar (var x)) mortar) (sem-edge-tv (var g) (L8-06_2_e2_collectors_grind_p5 (var e1)) (STV 0.9 0.9))))

; --- L8-06.3: Copper boxes in the Watch hold the ground feathers.
(sem-rule L8-06_3_cb_hold_rule)
(rule-context L8-06_3_cb_hold_rule aelmere-lore)
(rule-priority L8-06_3_cb_hold_rule 239)
(rule-tv L8-06_3_cb_hold_rule authored 0.9 0.9)
(rule-lhs L8-06_3_cb_hold_rule ((sem-edge (var g) (var e1) Member (var x) copper_box) (sem-edge (var g) (var e2) AttachedTo (var x) the_watch)))
(rule-rhs L8-06_3_cb_hold_rule ((sem-edge (var g) (L8-06_3_cb_hold_rule_p1 (var e1) (var e2)) Member (L8-06_3_sk_hold (var x)) hold) (sem-edge-tv (var g) (L8-06_3_cb_hold_rule_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L8-06_3_cb_hold_rule_p2 (var e1) (var e2)) Agent (L8-06_3_sk_hold (var x)) (var x)) (sem-edge-tv (var g) (L8-06_3_cb_hold_rule_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L8-06_3_cb_hold_rule_p3 (var e1) (var e2)) Object (L8-06_3_sk_hold (var x)) L8-06_3_sk_feathers_1) (sem-edge-tv (var g) (L8-06_3_cb_hold_rule_p3 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L8-06.5: The Council issues feather rations at each full-moon meeting.
(sem-rule L8-06_5_council_issue_rule)
(rule-context L8-06_5_council_issue_rule aelmere-lore)
(rule-priority L8-06_5_council_issue_rule 240)
(rule-tv L8-06_5_council_issue_rule authored 1.0 0.9)
(rule-lhs L8-06_5_council_issue_rule ((sem-edge (var g) (var e1) Member (var m) full_moon_meeting)))
(rule-rhs L8-06_5_council_issue_rule ((sem-edge (var g) (L8-06_5_council_issue_rule_p1 (var e1)) Member (L8-06_5_sk_issue (var m)) issue) (sem-edge-tv (var g) (L8-06_5_council_issue_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-06_5_council_issue_rule_p2 (var e1)) Agent (L8-06_5_sk_issue (var m)) the_council) (sem-edge-tv (var g) (L8-06_5_council_issue_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-06_5_council_issue_rule_p3 (var e1)) Object (L8-06_5_sk_issue (var m)) feather_ration) (sem-edge-tv (var g) (L8-06_5_council_issue_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-06_5_council_issue_rule_p4 (var e1)) During (L8-06_5_sk_issue (var m)) (var m)) (sem-edge-tv (var g) (L8-06_5_council_issue_rule_p4 (var e1)) (STV 1.0 0.9))))

; --- L8-07.5: Keepers extinguish the lantern at dawn with a brass snuffer.
(sem-rule L8-07_5_keeper_extinguish_rule)
(rule-context L8-07_5_keeper_extinguish_rule aelmere-lore)
(rule-priority L8-07_5_keeper_extinguish_rule 241)
(rule-tv L8-07_5_keeper_extinguish_rule authored 0.9 0.9)
(rule-lhs L8-07_5_keeper_extinguish_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L8-07_5_keeper_extinguish_rule ((sem-edge (var g) (L8-07_5_keeper_extinguish_rule_p1 (var e1)) Member (L8-07_5_sk_extinguish (var x)) extinguish) (sem-edge-tv (var g) (L8-07_5_keeper_extinguish_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-07_5_keeper_extinguish_rule_p2 (var e1)) Agent (L8-07_5_sk_extinguish (var x)) (var x)) (sem-edge-tv (var g) (L8-07_5_keeper_extinguish_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-07_5_keeper_extinguish_rule_p3 (var e1)) Object (L8-07_5_sk_extinguish (var x)) L8-07_5_sk_lantern_1) (sem-edge-tv (var g) (L8-07_5_keeper_extinguish_rule_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-07_5_keeper_extinguish_rule_p4 (var e1)) Time (L8-07_5_sk_extinguish (var x)) dawn) (sem-edge-tv (var g) (L8-07_5_keeper_extinguish_rule_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-07_5_keeper_extinguish_rule_p5 (var e1)) Instrument (L8-07_5_sk_extinguish (var x)) (L8-07_5_sk_snuffer (var x))) (sem-edge-tv (var g) (L8-07_5_keeper_extinguish_rule_p5 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-07_5_keeper_extinguish_rule_p6 (var e1)) Member (L8-07_5_sk_snuffer (var x)) brass_snuffer) (sem-edge-tv (var g) (L8-07_5_keeper_extinguish_rule_p6 (var e1)) (STV 0.9 0.9))))

; --- L8-07.6: Keepers often inherit the snuffer with the station.
(sem-rule L8-07_6_keeper_inherit)
(rule-context L8-07_6_keeper_inherit aelmere-lore)
(rule-priority L8-07_6_keeper_inherit 242)
(rule-tv L8-07_6_keeper_inherit authored 0.8 0.9)
(rule-lhs L8-07_6_keeper_inherit ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L8-07_6_keeper_inherit ((sem-edge (var g) (L8-07_6_keeper_inherit_p1 (var e1)) Member (L8-07_6_sk_inherit (var x)) inherit) (sem-edge-tv (var g) (L8-07_6_keeper_inherit_p1 (var e1)) (STV 0.8 0.9)) (sem-edge (var g) (L8-07_6_keeper_inherit_p2 (var e1)) Agent (L8-07_6_sk_inherit (var x)) (var x)) (sem-edge-tv (var g) (L8-07_6_keeper_inherit_p2 (var e1)) (STV 0.8 0.9)) (sem-edge (var g) (L8-07_6_keeper_inherit_p3 (var e1)) Object (L8-07_6_sk_inherit (var x)) (L8-07_6_sk_snuffer (var x))) (sem-edge-tv (var g) (L8-07_6_keeper_inherit_p3 (var e1)) (STV 0.8 0.9)) (sem-edge (var g) (L8-07_6_keeper_inherit_p4 (var e1)) Member (L8-07_6_sk_snuffer (var x)) snuffer) (sem-edge-tv (var g) (L8-07_6_keeper_inherit_p4 (var e1)) (STV 0.8 0.9)) (sem-edge (var g) (L8-07_6_keeper_inherit_p5 (var e1)) Member (L8-07_6_sk_station (var x)) station) (sem-edge-tv (var g) (L8-07_6_keeper_inherit_p5 (var e1)) (STV 0.8 0.9)) (sem-edge (var g) (L8-07_6_keeper_inherit_p6 (var e1)) With (L8-07_6_sk_inherit (var x)) (L8-07_6_sk_station (var x))) (sem-edge-tv (var g) (L8-07_6_keeper_inherit_p6 (var e1)) (STV 0.8 0.9))))

; --- L8-08.2: Each lantern stands on a stone pedestal.
(sem-rule L8-08_2_lantern_rule)
(rule-context L8-08_2_lantern_rule aelmere-lore)
(rule-priority L8-08_2_lantern_rule 243)
(rule-tv L8-08_2_lantern_rule authored 1.0 0.9)
(rule-lhs L8-08_2_lantern_rule ((sem-edge (var g) (var e1) Member (var x) lantern)))
(rule-rhs L8-08_2_lantern_rule ((sem-edge (var g) (L8-08_2_lantern_rule_p1 (var e1)) Member (L8-08_2_sk_pedestal (var x)) stone_pedestal) (sem-edge-tv (var g) (L8-08_2_lantern_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-08_2_lantern_rule_p2 (var e1)) On (var x) (L8-08_2_sk_pedestal (var x))) (sem-edge-tv (var g) (L8-08_2_lantern_rule_p2 (var e1)) (STV 1.0 0.9))))

; --- L8-08.3: Every lantern has a glass dome.
(sem-rule L8-08_3_every_lantern_has_dome)
(rule-context L8-08_3_every_lantern_has_dome aelmere-lore)
(rule-priority L8-08_3_every_lantern_has_dome 244)
(rule-tv L8-08_3_every_lantern_has_dome authored 1.0 0.9)
(rule-lhs L8-08_3_every_lantern_has_dome ((sem-edge (var g) (var e1) Member (var x) lantern)))
(rule-rhs L8-08_3_every_lantern_has_dome ((sem-edge (var g) (L8-08_3_every_lantern_has_dome_p1 (var e1)) Member (L8-08_3_sk_have (var x)) have) (sem-edge-tv (var g) (L8-08_3_every_lantern_has_dome_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-08_3_every_lantern_has_dome_p2 (var e1)) Holder (L8-08_3_sk_have (var x)) (var x)) (sem-edge-tv (var g) (L8-08_3_every_lantern_has_dome_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-08_3_every_lantern_has_dome_p3 (var e1)) Object (L8-08_3_sk_have (var x)) (L8-08_3_sk_dome (var x))) (sem-edge-tv (var g) (L8-08_3_every_lantern_has_dome_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-08_3_every_lantern_has_dome_p4 (var e1)) Member (L8-08_3_sk_dome (var x)) glass_dome) (sem-edge-tv (var g) (L8-08_3_every_lantern_has_dome_p4 (var e1)) (STV 1.0 0.9))))

; --- L8-08.5: Every lantern has an iron reservoir for mire-essence.
(sem-rule L8-08_5_lantern_has_reservoir)
(rule-context L8-08_5_lantern_has_reservoir aelmere-lore)
(rule-priority L8-08_5_lantern_has_reservoir 245)
(rule-tv L8-08_5_lantern_has_reservoir authored 1.0 0.9)
(rule-lhs L8-08_5_lantern_has_reservoir ((sem-edge (var g) (var e1) Member (var x) lantern)))
(rule-rhs L8-08_5_lantern_has_reservoir ((sem-edge (var g) (L8-08_5_lantern_has_reservoir_p1 (var e1)) Member (L8-08_5_sk_have (var x)) have) (sem-edge-tv (var g) (L8-08_5_lantern_has_reservoir_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-08_5_lantern_has_reservoir_p2 (var e1)) Holder (L8-08_5_sk_have (var x)) (var x)) (sem-edge-tv (var g) (L8-08_5_lantern_has_reservoir_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-08_5_lantern_has_reservoir_p3 (var e1)) Object (L8-08_5_sk_have (var x)) (L8-08_5_sk_reservoir (var x))) (sem-edge-tv (var g) (L8-08_5_lantern_has_reservoir_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-08_5_lantern_has_reservoir_p4 (var e1)) Member (L8-08_5_sk_reservoir (var x)) iron_reservoir) (sem-edge-tv (var g) (L8-08_5_lantern_has_reservoir_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-08_5_lantern_has_reservoir_p5 (var e1)) For (L8-08_5_sk_reservoir (var x)) mire_essence) (sem-edge-tv (var g) (L8-08_5_lantern_has_reservoir_p5 (var e1)) (STV 1.0 0.9))))

; --- L8-08.6: Each lantern is fixed to its station.
(sem-rule L8-08_6_e4_rule)
(rule-context L8-08_6_e4_rule aelmere-lore)
(rule-priority L8-08_6_e4_rule 246)
(rule-tv L8-08_6_e4_rule authored 1.0 0.9)
(rule-lhs L8-08_6_e4_rule ((sem-edge (var g) (var e1) Member (var x) lantern)))
(rule-rhs L8-08_6_e4_rule ((sem-edge (var g) (L8-08_6_e4_rule_p1 (var e1)) Member (L8-08_6_sk_fixed (var x)) fixed) (sem-edge-tv (var g) (L8-08_6_e4_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-08_6_e4_rule_p2 (var e1)) Experiencer (L8-08_6_sk_fixed (var x)) (var x)) (sem-edge-tv (var g) (L8-08_6_e4_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-08_6_e4_rule_p3 (var e1)) Member (L8-08_6_sk_station (var x)) station) (sem-edge-tv (var g) (L8-08_6_e4_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-08_6_e4_rule_p4 (var e1)) To (L8-08_6_sk_fixed (var x)) (L8-08_6_sk_station (var x))) (sem-edge-tv (var g) (L8-08_6_e4_rule_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-08_6_e4_rule_p5 (var e1)) Member (var x) fixed) (sem-edge-tv (var g) (L8-08_6_e4_rule_p5 (var e1)) (STV 1.0 0.9))))

; --- L8-09.5: Each compartment holds one new-moon harvest.
(sem-rule L8-09_5_each_compartment_holds)
(rule-context L8-09_5_each_compartment_holds aelmere-lore)
(rule-priority L8-09_5_each_compartment_holds 247)
(rule-tv L8-09_5_each_compartment_holds authored 1.0 0.9)
(rule-lhs L8-09_5_each_compartment_holds ((sem-edge (var g) (var e1) Member (var x) compartment)))
(rule-rhs L8-09_5_each_compartment_holds ((sem-edge (var g) (L8-09_5_each_compartment_holds_p1 (var e1)) Member (L8-09_5_sk_hold (var x)) hold) (sem-edge-tv (var g) (L8-09_5_each_compartment_holds_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-09_5_each_compartment_holds_p2 (var e1)) Agent (L8-09_5_sk_hold (var x)) (var x)) (sem-edge-tv (var g) (L8-09_5_each_compartment_holds_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-09_5_each_compartment_holds_p3 (var e1)) Object (L8-09_5_sk_hold (var x)) (L8-09_5_sk_harvest (var x))) (sem-edge-tv (var g) (L8-09_5_each_compartment_holds_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-09_5_each_compartment_holds_p4 (var e1)) Member (L8-09_5_sk_harvest (var x)) new_moon_harvest) (sem-edge-tv (var g) (L8-09_5_each_compartment_holds_p4 (var e1)) (STV 1.0 0.9))))

; --- L8-09.6: Hesper dates and labels each harvest.
(sem-rule L8-09_6_hesper_dates_harvest)
(rule-context L8-09_6_hesper_dates_harvest aelmere-lore)
(rule-priority L8-09_6_hesper_dates_harvest 248)
(rule-tv L8-09_6_hesper_dates_harvest authored 1.0 0.9)
(rule-lhs L8-09_6_hesper_dates_harvest ((sem-edge (var g) (var e1) Member (var y) harvest)))
(rule-rhs L8-09_6_hesper_dates_harvest ((sem-edge (var g) (L8-09_6_hesper_dates_harvest_p1 (var e1)) Member (L8-09_6_sk_date (var y)) date) (sem-edge-tv (var g) (L8-09_6_hesper_dates_harvest_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-09_6_hesper_dates_harvest_p2 (var e1)) Agent (L8-09_6_sk_date (var y)) hesper) (sem-edge-tv (var g) (L8-09_6_hesper_dates_harvest_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-09_6_hesper_dates_harvest_p3 (var e1)) Object (L8-09_6_sk_date (var y)) (var y)) (sem-edge-tv (var g) (L8-09_6_hesper_dates_harvest_p3 (var e1)) (STV 1.0 0.9))))

; --- L8-09.6: Hesper dates and labels each harvest.
(sem-rule L8-09_6_hesper_labels_harvest)
(rule-context L8-09_6_hesper_labels_harvest aelmere-lore)
(rule-priority L8-09_6_hesper_labels_harvest 249)
(rule-tv L8-09_6_hesper_labels_harvest authored 1.0 0.9)
(rule-lhs L8-09_6_hesper_labels_harvest ((sem-edge (var g) (var e1) Member (var y) harvest)))
(rule-rhs L8-09_6_hesper_labels_harvest ((sem-edge (var g) (L8-09_6_hesper_labels_harvest_p1 (var e1)) Member (L8-09_6_sk_label (var y)) label) (sem-edge-tv (var g) (L8-09_6_hesper_labels_harvest_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-09_6_hesper_labels_harvest_p2 (var e1)) Agent (L8-09_6_sk_label (var y)) hesper) (sem-edge-tv (var g) (L8-09_6_hesper_labels_harvest_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L8-09_6_hesper_labels_harvest_p3 (var e1)) Object (L8-09_6_sk_label (var y)) (var y)) (sem-edge-tv (var g) (L8-09_6_hesper_labels_harvest_p3 (var e1)) (STV 1.0 0.9))))

; --- L8-09.7: Keepers use old salt-bloom before new salt-bloom within a season.
(sem-rule L8-09_7_keepers_use_order)
(rule-context L8-09_7_keepers_use_order aelmere-lore)
(rule-priority L8-09_7_keepers_use_order 250)
(rule-tv L8-09_7_keepers_use_order authored 0.9 0.9)
(rule-lhs L8-09_7_keepers_use_order ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L8-09_7_keepers_use_order ((sem-edge (var g) (L8-09_7_keepers_use_order_p1 (var e1)) Member (L8-09_7_sk_use_old (var x)) use) (sem-edge-tv (var g) (L8-09_7_keepers_use_order_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-09_7_keepers_use_order_p2 (var e1)) Agent (L8-09_7_sk_use_old (var x)) (var x)) (sem-edge-tv (var g) (L8-09_7_keepers_use_order_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-09_7_keepers_use_order_p3 (var e1)) Object (L8-09_7_sk_use_old (var x)) old_salt_bloom) (sem-edge-tv (var g) (L8-09_7_keepers_use_order_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-09_7_keepers_use_order_p4 (var e1)) Member (L8-09_7_sk_use_new (var x)) use) (sem-edge-tv (var g) (L8-09_7_keepers_use_order_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-09_7_keepers_use_order_p5 (var e1)) Agent (L8-09_7_sk_use_new (var x)) (var x)) (sem-edge-tv (var g) (L8-09_7_keepers_use_order_p5 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-09_7_keepers_use_order_p6 (var e1)) Object (L8-09_7_sk_use_new (var x)) new_salt_bloom) (sem-edge-tv (var g) (L8-09_7_keepers_use_order_p6 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L8-09_7_keepers_use_order_p7 (var e1)) Before (L8-09_7_sk_use_old (var x)) (L8-09_7_sk_use_new (var x))) (sem-edge-tv (var g) (L8-09_7_keepers_use_order_p7 (var e1)) (STV 0.9 0.9))))

; --- L9-01.1: Threads arrive at Cauldron Hall each morning.
(sem-rule L9-01_1_threads_arrive_rule)
(rule-context L9-01_1_threads_arrive_rule aelmere-lore)
(rule-priority L9-01_1_threads_arrive_rule 251)
(rule-tv L9-01_1_threads_arrive_rule authored 0.9 0.9)
(rule-lhs L9-01_1_threads_arrive_rule ((sem-edge (var g) (var e1) Member (var x) thread)))
(rule-rhs L9-01_1_threads_arrive_rule ((sem-edge (var g) (L9-01_1_threads_arrive_rule_p1 (var e1)) Member (L9-01_1_sk_arrive (var x)) arrive) (sem-edge-tv (var g) (L9-01_1_threads_arrive_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L9-01_1_threads_arrive_rule_p2 (var e1)) Object (L9-01_1_sk_arrive (var x)) (var x)) (sem-edge-tv (var g) (L9-01_1_threads_arrive_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L9-01_1_threads_arrive_rule_p3 (var e1)) Location (L9-01_1_sk_arrive (var x)) cauldron_hall) (sem-edge-tv (var g) (L9-01_1_threads_arrive_rule_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L9-01_1_threads_arrive_rule_p4 (var e1)) Time (L9-01_1_sk_arrive (var x)) morning) (sem-edge-tv (var g) (L9-01_1_threads_arrive_rule_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L9-01_1_threads_arrive_rule_p5 (var e1)) Every (L9-01_1_sk_arrive (var x)) 1 day) (sem-edge-tv (var g) (L9-01_1_threads_arrive_rule_p5 (var e1)) (STV 0.9 0.9))))

; --- L9-01.2: Each Keeper leaves the night's threads in a wicker basket at the Hall door.
(sem-rule L9-01_2_keeper_leaves)
(rule-context L9-01_2_keeper_leaves aelmere-lore)
(rule-priority L9-01_2_keeper_leaves 252)
(rule-tv L9-01_2_keeper_leaves authored 1.0 0.9)
(rule-lhs L9-01_2_keeper_leaves ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L9-01_2_keeper_leaves ((sem-edge (var g) (L9-01_2_keeper_leaves_p1 (var e1)) Member (L9-01_2_sk_leave (var x)) leave) (sem-edge-tv (var g) (L9-01_2_keeper_leaves_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-01_2_keeper_leaves_p2 (var e1)) Agent (L9-01_2_sk_leave (var x)) (var x)) (sem-edge-tv (var g) (L9-01_2_keeper_leaves_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-01_2_keeper_leaves_p3 (var e1)) Object (L9-01_2_sk_leave (var x)) (L9-01_2_sk_threads (var x))) (sem-edge-tv (var g) (L9-01_2_keeper_leaves_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-01_2_keeper_leaves_p4 (var e1)) GroupOf (L9-01_2_sk_threads (var x)) thread) (sem-edge-tv (var g) (L9-01_2_keeper_leaves_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-01_2_keeper_leaves_p5 (var e1)) Possession (L9-01_2_sk_threads (var x)) night) (sem-edge-tv (var g) (L9-01_2_keeper_leaves_p5 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-01_2_keeper_leaves_p6 (var e1)) Location (L9-01_2_sk_leave (var x)) L9-01_2_sk_basket_1) (sem-edge-tv (var g) (L9-01_2_keeper_leaves_p6 (var e1)) (STV 1.0 0.9))))

; --- L9-02.3: Whenever a distillation runs in a cauldron and that cauldron boils hard, that distillation fails.
(sem-rule L9-02_3_whenever_distill_fail)
(rule-context L9-02_3_whenever_distill_fail aelmere-lore)
(rule-priority L9-02_3_whenever_distill_fail 253)
(rule-tv L9-02_3_whenever_distill_fail authored 1.0 0.9)
(rule-lhs L9-02_3_whenever_distill_fail ((sem-edge (var g) (var e1) Member (var x) run) (sem-edge (var g) (var e2) Agent (var x) (var d)) (sem-edge (var g) (var e3) Member (var d) distillation) (sem-edge (var g) (var e4) Location (var x) (var c)) (sem-edge (var g) (var e5) Member (var c) cauldron) (sem-edge (var g) (var e6) Member (var y) boil) (sem-edge (var g) (var e7) Object (var y) (var c)) (sem-edge (var g) (var e8) Manner (var y) hard)))
(rule-rhs L9-02_3_whenever_distill_fail ((sem-edge (var g) (L9-02_3_whenever_distill_fail_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Member (L9-02_3_sk_fail (var x)) fail) (sem-edge-tv (var g) (L9-02_3_whenever_distill_fail_p1 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (L9-02_3_whenever_distill_fail_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) Object (L9-02_3_sk_fail (var x)) (var d)) (sem-edge-tv (var g) (L9-02_3_whenever_distill_fail_p2 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9)) (sem-edge (var g) (L9-02_3_whenever_distill_fail_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) During (L9-02_3_sk_fail (var x)) (var x)) (sem-edge-tv (var g) (L9-02_3_whenever_distill_fail_p3 (var e1) (var e2) (var e3) (var e4) (var e5) (var e6) (var e7) (var e8)) (STV 1.0 0.9))))

; --- L9-02.4: Whenever a cauldron boils hard, that cauldron yields a thin slick of poor essence.
(sem-rule L9-02_4_cauldron_boil_yield_rule)
(rule-context L9-02_4_cauldron_boil_yield_rule aelmere-lore)
(rule-priority L9-02_4_cauldron_boil_yield_rule 254)
(rule-tv L9-02_4_cauldron_boil_yield_rule authored 1.0 0.9)
(rule-lhs L9-02_4_cauldron_boil_yield_rule ((sem-edge (var g) (var e1) Member (var c) cauldron) (sem-edge (var g) (var e2) Member (var b) boil) (sem-edge (var g) (var e3) Object (var b) (var c)) (sem-edge (var g) (var e4) Manner (var b) hard)))
(rule-rhs L9-02_4_cauldron_boil_yield_rule ((sem-edge (var g) (L9-02_4_cauldron_boil_yield_rule_p1 (var e1) (var e2) (var e3) (var e4)) Member (L9-02_4_sk_yield (var c)) yield) (sem-edge-tv (var g) (L9-02_4_cauldron_boil_yield_rule_p1 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L9-02_4_cauldron_boil_yield_rule_p2 (var e1) (var e2) (var e3) (var e4)) Agent (L9-02_4_sk_yield (var c)) (var c)) (sem-edge-tv (var g) (L9-02_4_cauldron_boil_yield_rule_p2 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L9-02_4_cauldron_boil_yield_rule_p3 (var e1) (var e2) (var e3) (var e4)) Object (L9-02_4_sk_yield (var c)) (L9-02_4_sk_slick (var c))) (sem-edge-tv (var g) (L9-02_4_cauldron_boil_yield_rule_p3 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L9-02_4_cauldron_boil_yield_rule_p4 (var e1) (var e2) (var e3) (var e4)) Member (L9-02_4_sk_slick (var c)) slick) (sem-edge-tv (var g) (L9-02_4_cauldron_boil_yield_rule_p4 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L9-02_4_cauldron_boil_yield_rule_p5 (var e1) (var e2) (var e3) (var e4)) Member (L9-02_4_sk_slick (var c)) thin) (sem-edge-tv (var g) (L9-02_4_cauldron_boil_yield_rule_p5 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L9-02_4_cauldron_boil_yield_rule_p6 (var e1) (var e2) (var e3) (var e4)) Member (L9-02_4_sk_slick (var c)) essence) (sem-edge-tv (var g) (L9-02_4_cauldron_boil_yield_rule_p6 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L9-02_4_cauldron_boil_yield_rule_p7 (var e1) (var e2) (var e3) (var e4)) Member (L9-02_4_sk_slick (var c)) poor) (sem-edge-tv (var g) (L9-02_4_cauldron_boil_yield_rule_p7 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L9-02_4_cauldron_boil_yield_rule_p8 (var e1) (var e2) (var e3) (var e4)) During (L9-02_4_sk_yield (var c)) (var b)) (sem-edge-tv (var g) (L9-02_4_cauldron_boil_yield_rule_p8 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9))))

; --- L9-02.6: By late afternoon a dark slick forms at the bottom of each cauldron.
(sem-rule L9-02_6_cauldron_slick_rule)
(rule-context L9-02_6_cauldron_slick_rule aelmere-lore)
(rule-priority L9-02_6_cauldron_slick_rule 255)
(rule-tv L9-02_6_cauldron_slick_rule authored 1.0 0.9)
(rule-lhs L9-02_6_cauldron_slick_rule ((sem-edge (var g) (var e1) Member (var x) cauldron)))
(rule-rhs L9-02_6_cauldron_slick_rule ((sem-edge (var g) (L9-02_6_cauldron_slick_rule_p1 (var e1)) Member (L9-02_6_sk_form (var x)) form) (sem-edge-tv (var g) (L9-02_6_cauldron_slick_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-02_6_cauldron_slick_rule_p2 (var e1)) Object (L9-02_6_sk_form (var x)) (L9-02_6_sk_slick (var x))) (sem-edge-tv (var g) (L9-02_6_cauldron_slick_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-02_6_cauldron_slick_rule_p3 (var e1)) Member (L9-02_6_sk_slick (var x)) slick) (sem-edge-tv (var g) (L9-02_6_cauldron_slick_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-02_6_cauldron_slick_rule_p4 (var e1)) Member (L9-02_6_sk_slick (var x)) dark) (sem-edge-tv (var g) (L9-02_6_cauldron_slick_rule_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-02_6_cauldron_slick_rule_p5 (var e1)) Location (L9-02_6_sk_form (var x)) (L9-02_6_sk_bottom (var x))) (sem-edge-tv (var g) (L9-02_6_cauldron_slick_rule_p5 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-02_6_cauldron_slick_rule_p6 (var e1)) PartOf (L9-02_6_sk_bottom (var x)) (var x)) (sem-edge-tv (var g) (L9-02_6_cauldron_slick_rule_p6 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-02_6_cauldron_slick_rule_p7 (var e1)) Member (L9-02_6_sk_bottom (var x)) bottom) (sem-edge-tv (var g) (L9-02_6_cauldron_slick_rule_p7 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-02_6_cauldron_slick_rule_p8 (var e1)) TimeAtMost (L9-02_6_sk_form (var x)) late_afternoon) (sem-edge-tv (var g) (L9-02_6_cauldron_slick_rule_p8 (var e1)) (STV 1.0 0.9))))

; --- L9-03.1: Hesper skims each cauldron at sundown.
(sem-rule L9-03_1_hesper_skims)
(rule-context L9-03_1_hesper_skims aelmere-lore)
(rule-priority L9-03_1_hesper_skims 256)
(rule-tv L9-03_1_hesper_skims authored 1.0 0.9)
(rule-lhs L9-03_1_hesper_skims ((sem-edge (var g) (var e1) Member (var x) cauldron)))
(rule-rhs L9-03_1_hesper_skims ((sem-edge (var g) (L9-03_1_hesper_skims_p1 (var e1)) Member (L9-03_1_sk_skim (var x)) skim) (sem-edge-tv (var g) (L9-03_1_hesper_skims_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-03_1_hesper_skims_p2 (var e1)) Agent (L9-03_1_sk_skim (var x)) hesper) (sem-edge-tv (var g) (L9-03_1_hesper_skims_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-03_1_hesper_skims_p3 (var e1)) Object (L9-03_1_sk_skim (var x)) (var x)) (sem-edge-tv (var g) (L9-03_1_hesper_skims_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-03_1_hesper_skims_p4 (var e1)) Time (L9-03_1_sk_skim (var x)) sundown) (sem-edge-tv (var g) (L9-03_1_hesper_skims_p4 (var e1)) (STV 1.0 0.9))))

; --- L9-03.3: Each cauldron yields a vessel that is partly full of mire-essence.
(sem-rule L9-03_3_cauldron_yield_rule)
(rule-context L9-03_3_cauldron_yield_rule aelmere-lore)
(rule-priority L9-03_3_cauldron_yield_rule 257)
(rule-tv L9-03_3_cauldron_yield_rule authored 1.0 0.9)
(rule-lhs L9-03_3_cauldron_yield_rule ((sem-edge (var g) (var e1) Member (var x) cauldron)))
(rule-rhs L9-03_3_cauldron_yield_rule ((sem-edge (var g) (L9-03_3_cauldron_yield_rule_p1 (var e1)) Member (L9-03_3_sk_yield (var x)) yield) (sem-edge-tv (var g) (L9-03_3_cauldron_yield_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-03_3_cauldron_yield_rule_p2 (var e1)) Agent (L9-03_3_sk_yield (var x)) (var x)) (sem-edge-tv (var g) (L9-03_3_cauldron_yield_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-03_3_cauldron_yield_rule_p3 (var e1)) Object (L9-03_3_sk_yield (var x)) (L9-03_3_sk_vessel (var x))) (sem-edge-tv (var g) (L9-03_3_cauldron_yield_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-03_3_cauldron_yield_rule_p4 (var e1)) Member (L9-03_3_sk_vessel (var x)) vessel) (sem-edge-tv (var g) (L9-03_3_cauldron_yield_rule_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-03_3_cauldron_yield_rule_p5 (var e1)) Member (L9-03_3_sk_full (var x)) full) (sem-edge-tv (var g) (L9-03_3_cauldron_yield_rule_p5 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-03_3_cauldron_yield_rule_p6 (var e1)) Experiencer (L9-03_3_sk_full (var x)) (L9-03_3_sk_vessel (var x))) (sem-edge-tv (var g) (L9-03_3_cauldron_yield_rule_p6 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-03_3_cauldron_yield_rule_p7 (var e1)) Of (L9-03_3_sk_full (var x)) mire_essence) (sem-edge-tv (var g) (L9-03_3_cauldron_yield_rule_p7 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-03_3_cauldron_yield_rule_p8 (var e1)) Degree (L9-03_3_sk_vessel (var x)) full partly) (sem-edge-tv (var g) (L9-03_3_cauldron_yield_rule_p8 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-03_3_cauldron_yield_rule_p9 (var e1)) Member (L9-03_3_sk_vessel (var x)) full) (sem-edge-tv (var g) (L9-03_3_cauldron_yield_rule_p9 (var e1)) (STV 1.0 0.9))))

; --- L9-03.4: Good threads yield a full vessel.
(sem-rule L9-03_4_threads_yield)
(rule-context L9-03_4_threads_yield aelmere-lore)
(rule-priority L9-03_4_threads_yield 258)
(rule-tv L9-03_4_threads_yield authored 0.9 0.9)
(rule-lhs L9-03_4_threads_yield ((sem-edge (var g) (var e1) Member (var x) thread) (sem-edge (var g) (var e2) Member (var x) good)))
(rule-rhs L9-03_4_threads_yield ((sem-edge (var g) (L9-03_4_threads_yield_p1 (var e1) (var e2)) Member (L9-03_4_sk_yield (var x)) yield) (sem-edge-tv (var g) (L9-03_4_threads_yield_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L9-03_4_threads_yield_p2 (var e1) (var e2)) Agent (L9-03_4_sk_yield (var x)) (var x)) (sem-edge-tv (var g) (L9-03_4_threads_yield_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L9-03_4_threads_yield_p3 (var e1) (var e2)) Object (L9-03_4_sk_yield (var x)) (L9-03_4_sk_vessel (var x))) (sem-edge-tv (var g) (L9-03_4_threads_yield_p3 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L9-03_4_threads_yield_p4 (var e1) (var e2)) Member (L9-03_4_sk_vessel (var x)) vessel) (sem-edge-tv (var g) (L9-03_4_threads_yield_p4 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L9-03_4_threads_yield_p5 (var e1) (var e2)) Member (L9-03_4_sk_vessel (var x)) full) (sem-edge-tv (var g) (L9-03_4_threads_yield_p5 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L9-03.5: Poor threads yield a thin slick.
(sem-rule L9-03_5_poor_thread_yield_rule)
(rule-context L9-03_5_poor_thread_yield_rule aelmere-lore)
(rule-priority L9-03_5_poor_thread_yield_rule 259)
(rule-tv L9-03_5_poor_thread_yield_rule authored 0.9 0.9)
(rule-lhs L9-03_5_poor_thread_yield_rule ((sem-edge (var g) (var e1) Member (var x) thread) (sem-edge (var g) (var e2) Member (var x) poor)))
(rule-rhs L9-03_5_poor_thread_yield_rule ((sem-edge (var g) (L9-03_5_poor_thread_yield_rule_p1 (var e1) (var e2)) Member (L9-03_5_sk_yield (var x)) yield) (sem-edge-tv (var g) (L9-03_5_poor_thread_yield_rule_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L9-03_5_poor_thread_yield_rule_p2 (var e1) (var e2)) Agent (L9-03_5_sk_yield (var x)) (var x)) (sem-edge-tv (var g) (L9-03_5_poor_thread_yield_rule_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L9-03_5_poor_thread_yield_rule_p3 (var e1) (var e2)) Object (L9-03_5_sk_yield (var x)) (L9-03_5_sk_slick (var x))) (sem-edge-tv (var g) (L9-03_5_poor_thread_yield_rule_p3 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L9-03_5_poor_thread_yield_rule_p4 (var e1) (var e2)) Member (L9-03_5_sk_slick (var x)) slick) (sem-edge-tv (var g) (L9-03_5_poor_thread_yield_rule_p4 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L9-03_5_poor_thread_yield_rule_p5 (var e1) (var e2)) Member (L9-03_5_sk_slick (var x)) thin) (sem-edge-tv (var g) (L9-03_5_poor_thread_yield_rule_p5 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L9-03.6: Hesper dates and labels each vessel.
(sem-rule L9-03_6_hesper_dates)
(rule-context L9-03_6_hesper_dates aelmere-lore)
(rule-priority L9-03_6_hesper_dates 260)
(rule-tv L9-03_6_hesper_dates authored 1.0 0.9)
(rule-lhs L9-03_6_hesper_dates ((sem-edge (var g) (var e1) Member (var x) vessel)))
(rule-rhs L9-03_6_hesper_dates ((sem-edge (var g) (L9-03_6_hesper_dates_p1 (var e1)) Member (L9-03_6_sk_date (var x)) date) (sem-edge-tv (var g) (L9-03_6_hesper_dates_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-03_6_hesper_dates_p2 (var e1)) Agent (L9-03_6_sk_date (var x)) hesper) (sem-edge-tv (var g) (L9-03_6_hesper_dates_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-03_6_hesper_dates_p3 (var e1)) Object (L9-03_6_sk_date (var x)) (var x)) (sem-edge-tv (var g) (L9-03_6_hesper_dates_p3 (var e1)) (STV 1.0 0.9))))

; --- L9-03.6: Hesper dates and labels each vessel.
(sem-rule L9-03_6_hesper_labels)
(rule-context L9-03_6_hesper_labels aelmere-lore)
(rule-priority L9-03_6_hesper_labels 261)
(rule-tv L9-03_6_hesper_labels authored 1.0 0.9)
(rule-lhs L9-03_6_hesper_labels ((sem-edge (var g) (var e1) Member (var x) vessel)))
(rule-rhs L9-03_6_hesper_labels ((sem-edge (var g) (L9-03_6_hesper_labels_p1 (var e1)) Member (L9-03_6_sk_label (var x)) label) (sem-edge-tv (var g) (L9-03_6_hesper_labels_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-03_6_hesper_labels_p2 (var e1)) Agent (L9-03_6_sk_label (var x)) hesper) (sem-edge-tv (var g) (L9-03_6_hesper_labels_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (L9-03_6_hesper_labels_p3 (var e1)) Object (L9-03_6_sk_label (var x)) (var x)) (sem-edge-tv (var g) (L9-03_6_hesper_labels_p3 (var e1)) (STV 1.0 0.9))))

; --- L9-04.2: Boiled sea-water does not serve for a second distillation.
(sem-rule L9-04_2_boiled_sw_no_serve)
(rule-context L9-04_2_boiled_sw_no_serve aelmere-lore)
(rule-priority L9-04_2_boiled_sw_no_serve 262)
(rule-tv L9-04_2_boiled_sw_no_serve authored 0.0 0.9)
(rule-lhs L9-04_2_boiled_sw_no_serve ((sem-edge (var g) (var e1) Member (var x) sea_water) (sem-edge (var g) (var e2) Member (var x) boiled)))
(rule-rhs L9-04_2_boiled_sw_no_serve ((sem-edge (var g) (L9-04_2_boiled_sw_no_serve_p1 (var e1) (var e2)) And (Member (L9-04_2_sk_serve (var x)) serve) (Experiencer (L9-04_2_sk_serve (var x)) (var x)) (For (L9-04_2_sk_serve (var x)) (L9-04_2_sk_distillation (var x))) (Member (L9-04_2_sk_distillation (var x)) distillation) (Ordinal (L9-04_2_sk_distillation (var x)) 2 distillation)) (sem-edge-tv (var g) (L9-04_2_boiled_sw_no_serve_p1 (var e1) (var e2)) (STV 0.0 0.9))))

; --- L9-04.3: Apprentices scrub the cauldrons with sand.
(sem-rule L9-04_3_apprentice_scrub_rule)
(rule-context L9-04_3_apprentice_scrub_rule aelmere-lore)
(rule-priority L9-04_3_apprentice_scrub_rule 263)
(rule-tv L9-04_3_apprentice_scrub_rule authored 0.9 0.9)
(rule-lhs L9-04_3_apprentice_scrub_rule ((sem-edge (var g) (var e1) Member (var x) apprentice)))
(rule-rhs L9-04_3_apprentice_scrub_rule ((sem-edge (var g) (L9-04_3_apprentice_scrub_rule_p1 (var e1)) Member (L9-04_3_sk_scrub (var x)) scrub) (sem-edge-tv (var g) (L9-04_3_apprentice_scrub_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L9-04_3_apprentice_scrub_rule_p2 (var e1)) Agent (L9-04_3_sk_scrub (var x)) (var x)) (sem-edge-tv (var g) (L9-04_3_apprentice_scrub_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L9-04_3_apprentice_scrub_rule_p3 (var e1)) Object (L9-04_3_sk_scrub (var x)) the_cauldron) (sem-edge-tv (var g) (L9-04_3_apprentice_scrub_rule_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L9-04_3_apprentice_scrub_rule_p4 (var e1)) Instrument (L9-04_3_sk_scrub (var x)) sand) (sem-edge-tv (var g) (L9-04_3_apprentice_scrub_rule_p4 (var e1)) (STV 0.9 0.9))))

; --- L9-05.1: Typical days fill several vessels with mire-essence.
(sem-rule L9-05_1_typicaldays_fill_rule)
(rule-context L9-05_1_typicaldays_fill_rule aelmere-lore)
(rule-priority L9-05_1_typicaldays_fill_rule 264)
(rule-tv L9-05_1_typicaldays_fill_rule authored 0.9 0.9)
(rule-lhs L9-05_1_typicaldays_fill_rule ((sem-edge (var g) (var e1) Member (var d) day) (sem-edge (var g) (var e2) Member (var d) typical)))
(rule-rhs L9-05_1_typicaldays_fill_rule ((sem-edge (var g) (L9-05_1_typicaldays_fill_rule_p1 (var e1) (var e2)) Member (L9-05_1_sk_fill (var d)) fill) (sem-edge-tv (var g) (L9-05_1_typicaldays_fill_rule_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L9-05_1_typicaldays_fill_rule_p2 (var e1) (var e2)) Agent (L9-05_1_sk_fill (var d)) (var d)) (sem-edge-tv (var g) (L9-05_1_typicaldays_fill_rule_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L9-05_1_typicaldays_fill_rule_p3 (var e1) (var e2)) Object (L9-05_1_sk_fill (var d)) (L9-05_1_sk_vessels (var d))) (sem-edge-tv (var g) (L9-05_1_typicaldays_fill_rule_p3 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L9-05_1_typicaldays_fill_rule_p4 (var e1) (var e2)) GroupOf (L9-05_1_sk_vessels (var d)) vessel) (sem-edge-tv (var g) (L9-05_1_typicaldays_fill_rule_p4 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L9-05_1_typicaldays_fill_rule_p5 (var e1) (var e2)) CardinalityPhrase (L9-05_1_sk_vessels (var d)) "several") (sem-edge-tv (var g) (L9-05_1_typicaldays_fill_rule_p5 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L9-05_1_typicaldays_fill_rule_p6 (var e1) (var e2)) Instrument (L9-05_1_sk_fill (var d)) mire_essence) (sem-edge-tv (var g) (L9-05_1_typicaldays_fill_rule_p6 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L9-05.2: Heavy-thread days fill four vessels with mire-essence.
(sem-rule L9-05_2_htd_fill_vessels)
(rule-context L9-05_2_htd_fill_vessels aelmere-lore)
(rule-priority L9-05_2_htd_fill_vessels 265)
(rule-tv L9-05_2_htd_fill_vessels authored 0.9 0.9)
(rule-lhs L9-05_2_htd_fill_vessels ((sem-edge (var g) (var e1) Member (var x) heavy_thread_day)))
(rule-rhs L9-05_2_htd_fill_vessels ((sem-edge (var g) (L9-05_2_htd_fill_vessels_p1 (var e1)) Member (L9-05_2_sk_fill (var x)) fill) (sem-edge-tv (var g) (L9-05_2_htd_fill_vessels_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L9-05_2_htd_fill_vessels_p2 (var e1)) Agent (L9-05_2_sk_fill (var x)) (var x)) (sem-edge-tv (var g) (L9-05_2_htd_fill_vessels_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L9-05_2_htd_fill_vessels_p3 (var e1)) Object (L9-05_2_sk_fill (var x)) (L9-05_2_sk_vessels (var x))) (sem-edge-tv (var g) (L9-05_2_htd_fill_vessels_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L9-05_2_htd_fill_vessels_p4 (var e1)) GroupOf (L9-05_2_sk_vessels (var x)) vessel) (sem-edge-tv (var g) (L9-05_2_htd_fill_vessels_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L9-05_2_htd_fill_vessels_p5 (var e1)) Cardinality (L9-05_2_sk_vessels (var x)) 4) (sem-edge-tv (var g) (L9-05_2_htd_fill_vessels_p5 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L9-05_2_htd_fill_vessels_p6 (var e1)) Instrument (L9-05_2_sk_fill (var x)) mire_essence) (sem-edge-tv (var g) (L9-05_2_htd_fill_vessels_p6 (var e1)) (STV 0.9 0.9))))

; --- L9-05.3: Thin days fill one vessel with mire-essence.
(sem-rule L9-05_3_thin_day_fill_rule)
(rule-context L9-05_3_thin_day_fill_rule aelmere-lore)
(rule-priority L9-05_3_thin_day_fill_rule 266)
(rule-tv L9-05_3_thin_day_fill_rule authored 0.9 0.9)
(rule-lhs L9-05_3_thin_day_fill_rule ((sem-edge (var g) (var e1) Member (var x) day) (sem-edge (var g) (var e2) Member (var x) thin)))
(rule-rhs L9-05_3_thin_day_fill_rule ((sem-edge (var g) (L9-05_3_thin_day_fill_rule_p1 (var e1) (var e2)) Member (L9-05_3_sk_fill (var x)) fill) (sem-edge-tv (var g) (L9-05_3_thin_day_fill_rule_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L9-05_3_thin_day_fill_rule_p2 (var e1) (var e2)) Agent (L9-05_3_sk_fill (var x)) (var x)) (sem-edge-tv (var g) (L9-05_3_thin_day_fill_rule_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L9-05_3_thin_day_fill_rule_p3 (var e1) (var e2)) Object (L9-05_3_sk_fill (var x)) (L9-05_3_sk_vessel (var x))) (sem-edge-tv (var g) (L9-05_3_thin_day_fill_rule_p3 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L9-05_3_thin_day_fill_rule_p4 (var e1) (var e2)) Member (L9-05_3_sk_vessel (var x)) vessel) (sem-edge-tv (var g) (L9-05_3_thin_day_fill_rule_p4 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L9-05_3_thin_day_fill_rule_p5 (var e1) (var e2)) Instrument (L9-05_3_sk_fill (var x)) mire_essence) (sem-edge-tv (var g) (L9-05_3_thin_day_fill_rule_p5 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L9-05.5: Whenever a wraith drains a lantern, the thread harvest at that lantern falls.
(sem-rule L9-05_5_lp81_rule)
(rule-context L9-05_5_lp81_rule aelmere-lore)
(rule-priority L9-05_5_lp81_rule 267)
(rule-tv L9-05_5_lp81_rule authored 1.0 0.9)
(rule-lhs L9-05_5_lp81_rule ((sem-edge (var g) (var e1) Member (var w) wraith) (sem-edge (var g) (var e2) Member (var d) drain) (sem-edge (var g) (var e3) Agent (var d) (var w)) (sem-edge (var g) (var e4) Object (var d) (var l)) (sem-edge (var g) (var e5) Member (var l) lantern)))
(rule-rhs L9-05_5_lp81_rule ((sem-edge (var g) (L9-05_5_lp81_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (L9-05_5_sk_fall (var d)) fall) (sem-edge-tv (var g) (L9-05_5_lp81_rule_p1 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L9-05_5_lp81_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) Object (L9-05_5_sk_fall (var d)) (L9-05_5_sk_harvest (var l))) (sem-edge-tv (var g) (L9-05_5_lp81_rule_p2 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L9-05_5_lp81_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) Member (L9-05_5_sk_harvest (var l)) thread_harvest) (sem-edge-tv (var g) (L9-05_5_lp81_rule_p3 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L9-05_5_lp81_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) LocatedIn (L9-05_5_sk_harvest (var l)) (var l)) (sem-edge-tv (var g) (L9-05_5_lp81_rule_p4 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9)) (sem-edge (var g) (L9-05_5_lp81_rule_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) During (L9-05_5_sk_fall (var d)) (var d)) (sem-edge-tv (var g) (L9-05_5_lp81_rule_p5 (var e1) (var e2) (var e3) (var e4) (var e5)) (STV 1.0 0.9))))

; --- L9-05.6: When the thread basket is empty, the cauldrons sit idle.
(sem-rule L9-05_6_e3_basket_idle_rule)
(rule-context L9-05_6_e3_basket_idle_rule aelmere-lore)
(rule-priority L9-05_6_e3_basket_idle_rule 268)
(rule-tv L9-05_6_e3_basket_idle_rule authored 1.0 0.9)
(rule-lhs L9-05_6_e3_basket_idle_rule ((sem-edge (var g) (var e1) Member L9-05_6_sk_basket_1 empty) (sem-edge (var g) (var e2) PartOf (var x) the_cauldron)))
(rule-rhs L9-05_6_e3_basket_idle_rule ((sem-edge (var g) (L9-05_6_e3_basket_idle_rule_p1 (var e1) (var e2)) Member (var x) idle) (sem-edge-tv (var g) (L9-05_6_e3_basket_idle_rule_p1 (var e1) (var e2)) (STV 1.0 0.9))))

; --- L10-01.2: Moth-counts recover through spring.
(sem-rule L10-01_2_mothcount_rule)
(rule-context L10-01_2_mothcount_rule aelmere-lore)
(rule-priority L10-01_2_mothcount_rule 269)
(rule-tv L10-01_2_mothcount_rule authored 0.9 0.9)
(rule-lhs L10-01_2_mothcount_rule ((sem-edge (var g) (var e1) Member (var x) moth_count)))
(rule-rhs L10-01_2_mothcount_rule ((sem-edge (var g) (L10-01_2_mothcount_rule_p1 (var e1)) Member (L10-01_2_sk_recover (var x)) recover) (sem-edge-tv (var g) (L10-01_2_mothcount_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L10-01_2_mothcount_rule_p2 (var e1)) Object (L10-01_2_sk_recover (var x)) (var x)) (sem-edge-tv (var g) (L10-01_2_mothcount_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L10-01_2_mothcount_rule_p3 (var e1)) Time (L10-01_2_sk_recover (var x)) spring) (sem-edge-tv (var g) (L10-01_2_mothcount_rule_p3 (var e1)) (STV 0.9 0.9))))

; --- L10-02.2: Mild periods separate the cold stretches.
(sem-rule L10-02_2_e4_mild_separate)
(rule-context L10-02_2_e4_mild_separate aelmere-lore)
(rule-priority L10-02_2_e4_mild_separate 270)
(rule-tv L10-02_2_e4_mild_separate authored 0.9 0.9)
(rule-lhs L10-02_2_e4_mild_separate ((sem-edge (var g) (var e1) Member (var x) period) (sem-edge (var g) (var e2) Member (var x) mild)))
(rule-rhs L10-02_2_e4_mild_separate ((sem-edge (var g) (L10-02_2_e4_mild_separate_p1 (var e1) (var e2)) Member (L10-02_2_sk_separate (var x)) separate) (sem-edge-tv (var g) (L10-02_2_e4_mild_separate_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L10-02_2_e4_mild_separate_p2 (var e1) (var e2)) Agent (L10-02_2_sk_separate (var x)) (var x)) (sem-edge-tv (var g) (L10-02_2_e4_mild_separate_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L10-02_2_e4_mild_separate_p3 (var e1) (var e2)) Object (L10-02_2_sk_separate (var x)) L10-02_2_sk_stretches_1) (sem-edge-tv (var g) (L10-02_2_e4_mild_separate_p3 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L10-02.3: Keepers forecast cold-threshold stretches from the spire weathercocks.
(sem-rule L10-02_3_forecast_rule)
(rule-context L10-02_3_forecast_rule aelmere-lore)
(rule-priority L10-02_3_forecast_rule 271)
(rule-tv L10-02_3_forecast_rule authored 0.9 0.9)
(rule-lhs L10-02_3_forecast_rule ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L10-02_3_forecast_rule ((sem-edge (var g) (L10-02_3_forecast_rule_p1 (var e1)) Member (L10-02_3_sk_forecast (var x)) forecast) (sem-edge-tv (var g) (L10-02_3_forecast_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L10-02_3_forecast_rule_p2 (var e1)) Agent (L10-02_3_sk_forecast (var x)) (var x)) (sem-edge-tv (var g) (L10-02_3_forecast_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L10-02_3_forecast_rule_p3 (var e1)) Object (L10-02_3_sk_forecast (var x)) cold_threshold_stretch) (sem-edge-tv (var g) (L10-02_3_forecast_rule_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L10-02_3_forecast_rule_p4 (var e1)) Source (L10-02_3_sk_forecast (var x)) L10-02_3_sk_group_1) (sem-edge-tv (var g) (L10-02_3_forecast_rule_p4 (var e1)) (STV 0.9 0.9))))

; --- L10-02.4: Keepers forecast cold-threshold stretches from the hearth smoke.
(sem-rule L10-02_4_keepers_forecast)
(rule-context L10-02_4_keepers_forecast aelmere-lore)
(rule-priority L10-02_4_keepers_forecast 272)
(rule-tv L10-02_4_keepers_forecast authored 0.9 0.9)
(rule-lhs L10-02_4_keepers_forecast ((sem-edge (var g) (var e1) Member (var x) keeper)))
(rule-rhs L10-02_4_keepers_forecast ((sem-edge (var g) (L10-02_4_keepers_forecast_p1 (var e1)) Member (L10-02_4_sk_forecast (var x)) forecast) (sem-edge-tv (var g) (L10-02_4_keepers_forecast_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L10-02_4_keepers_forecast_p2 (var e1)) Agent (L10-02_4_sk_forecast (var x)) (var x)) (sem-edge-tv (var g) (L10-02_4_keepers_forecast_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L10-02_4_keepers_forecast_p3 (var e1)) Object (L10-02_4_sk_forecast (var x)) cold_threshold_stretch) (sem-edge-tv (var g) (L10-02_4_keepers_forecast_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L10-02_4_keepers_forecast_p4 (var e1)) Source (L10-02_4_sk_forecast (var x)) L10-02_4_sk_hearth_smoke_1) (sem-edge-tv (var g) (L10-02_4_keepers_forecast_p4 (var e1)) (STV 0.9 0.9))))

; --- L10-03.1: Sky-cats hunt often in summer.
(sem-rule L10-03_1_skycat_hunt_rule)
(rule-context L10-03_1_skycat_hunt_rule aelmere-lore)
(rule-priority L10-03_1_skycat_hunt_rule 273)
(rule-tv L10-03_1_skycat_hunt_rule authored 0.8 0.9)
(rule-lhs L10-03_1_skycat_hunt_rule ((sem-edge (var g) (var e1) Member (var x) sky_cat)))
(rule-rhs L10-03_1_skycat_hunt_rule ((sem-edge (var g) (L10-03_1_skycat_hunt_rule_p1 (var e1)) Member (L10-03_1_sk_hunt (var x)) hunt) (sem-edge-tv (var g) (L10-03_1_skycat_hunt_rule_p1 (var e1)) (STV 0.8 0.9)) (sem-edge (var g) (L10-03_1_skycat_hunt_rule_p2 (var e1)) Agent (L10-03_1_sk_hunt (var x)) (var x)) (sem-edge-tv (var g) (L10-03_1_skycat_hunt_rule_p2 (var e1)) (STV 0.8 0.9)) (sem-edge (var g) (L10-03_1_skycat_hunt_rule_p3 (var e1)) Time (L10-03_1_sk_hunt (var x)) summer) (sem-edge-tv (var g) (L10-03_1_skycat_hunt_rule_p3 (var e1)) (STV 0.8 0.9))))

; --- L10-03.2: Sky-cats hunt often in early autumn.
(sem-rule L10-03_2_lo79_rule)
(rule-context L10-03_2_lo79_rule aelmere-lore)
(rule-priority L10-03_2_lo79_rule 274)
(rule-tv L10-03_2_lo79_rule authored 0.8 0.9)
(rule-lhs L10-03_2_lo79_rule ((sem-edge (var g) (var e1) Member (var x) sky_cat)))
(rule-rhs L10-03_2_lo79_rule ((sem-edge (var g) (L10-03_2_lo79_rule_p1 (var e1)) Member (L10-03_2_sk_hunt (var x)) hunt) (sem-edge-tv (var g) (L10-03_2_lo79_rule_p1 (var e1)) (STV 0.8 0.9)) (sem-edge (var g) (L10-03_2_lo79_rule_p2 (var e1)) Agent (L10-03_2_sk_hunt (var x)) (var x)) (sem-edge-tv (var g) (L10-03_2_lo79_rule_p2 (var e1)) (STV 0.8 0.9)) (sem-edge (var g) (L10-03_2_lo79_rule_p3 (var e1)) Time (L10-03_2_sk_hunt (var x)) early_autumn) (sem-edge-tv (var g) (L10-03_2_lo79_rule_p3 (var e1)) (STV 0.8 0.9))))

; --- L10-03.3: Sky-cats hunt rarely in deep winter.
(sem-rule L10-03_3_sk_hunt_rule)
(rule-context L10-03_3_sk_hunt_rule aelmere-lore)
(rule-priority L10-03_3_sk_hunt_rule 275)
(rule-tv L10-03_3_sk_hunt_rule authored 0.1 0.9)
(rule-lhs L10-03_3_sk_hunt_rule ((sem-edge (var g) (var e1) Member (var x) sky_cat)))
(rule-rhs L10-03_3_sk_hunt_rule ((sem-edge (var g) (L10-03_3_sk_hunt_rule_p1 (var e1)) And (Member (L10-03_3_sk_hunt (var x)) hunt) (Agent (L10-03_3_sk_hunt (var x)) (var x)) (Time (L10-03_3_sk_hunt (var x)) deep_winter)) (sem-edge-tv (var g) (L10-03_3_sk_hunt_rule_p1 (var e1)) (STV 0.1 0.9))))

; --- L10-03.4: Sky-cats resume hunting in spring.
(sem-rule L10-03_4_skycat_resume_rule)
(rule-context L10-03_4_skycat_resume_rule aelmere-lore)
(rule-priority L10-03_4_skycat_resume_rule 276)
(rule-tv L10-03_4_skycat_resume_rule authored 0.9 0.9)
(rule-lhs L10-03_4_skycat_resume_rule ((sem-edge (var g) (var e1) Member (var x) sky_cat)))
(rule-rhs L10-03_4_skycat_resume_rule ((sem-edge (var g) (L10-03_4_skycat_resume_rule_p1 (var e1)) Member (L10-03_4_sk_resume (var x)) resume) (sem-edge-tv (var g) (L10-03_4_skycat_resume_rule_p1 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L10-03_4_skycat_resume_rule_p2 (var e1)) Agent (L10-03_4_sk_resume (var x)) (var x)) (sem-edge-tv (var g) (L10-03_4_skycat_resume_rule_p2 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L10-03_4_skycat_resume_rule_p3 (var e1)) Object (L10-03_4_sk_resume (var x)) (L10-03_4_sk_hunt (var x))) (sem-edge-tv (var g) (L10-03_4_skycat_resume_rule_p3 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L10-03_4_skycat_resume_rule_p4 (var e1)) Time (L10-03_4_sk_resume (var x)) spring) (sem-edge-tv (var g) (L10-03_4_skycat_resume_rule_p4 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L10-03_4_skycat_resume_rule_p5 (var e1)) Member (L10-03_4_sk_hunt (var x)) hunt) (sem-edge-tv (var g) (L10-03_4_skycat_resume_rule_p5 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L10-03_4_skycat_resume_rule_p6 (var e1)) Agent (L10-03_4_sk_hunt (var x)) (var x)) (sem-edge-tv (var g) (L10-03_4_skycat_resume_rule_p6 (var e1)) (STV 0.9 0.9)) (sem-edge (var g) (L10-03_4_skycat_resume_rule_p7 (var e1)) Ongoing (L10-03_4_sk_hunt (var x))) (sem-edge-tv (var g) (L10-03_4_skycat_resume_rule_p7 (var e1)) (STV 0.9 0.9))))

; --- L10-03.5: When nightmoths are scarce, sky-cats sometimes hunt insects.
(sem-rule L10-03_5_skycat_hunt)
(rule-context L10-03_5_skycat_hunt aelmere-lore)
(rule-priority L10-03_5_skycat_hunt 277)
(rule-tv L10-03_5_skycat_hunt authored 0.5 0.9)
(rule-lhs L10-03_5_skycat_hunt ((sem-edge (var g) (var e1) Member (var x) sky_cat) (sem-edge (var g) (var e2) KindProperty nightmoth scarce)))
(rule-rhs L10-03_5_skycat_hunt ((sem-edge (var g) (L10-03_5_skycat_hunt_p1 (var e1) (var e2)) Member (L10-03_5_sk_hunt (var x)) hunt) (sem-edge-tv (var g) (L10-03_5_skycat_hunt_p1 (var e1) (var e2)) (STV 0.5 0.9)) (sem-edge (var g) (L10-03_5_skycat_hunt_p2 (var e1) (var e2)) Agent (L10-03_5_sk_hunt (var x)) (var x)) (sem-edge-tv (var g) (L10-03_5_skycat_hunt_p2 (var e1) (var e2)) (STV 0.5 0.9)) (sem-edge (var g) (L10-03_5_skycat_hunt_p3 (var e1) (var e2)) Object (L10-03_5_sk_hunt (var x)) insect) (sem-edge-tv (var g) (L10-03_5_skycat_hunt_p3 (var e1) (var e2)) (STV 0.5 0.9))))

; --- L10-04.1: Whenever a sky-cat hunts on the Cliff Path, the lanterns at the Hollows produce many threads.
(sem-rule L10-04_1_lo80_rule)
(rule-context L10-04_1_lo80_rule aelmere-lore)
(rule-priority L10-04_1_lo80_rule 278)
(rule-tv L10-04_1_lo80_rule authored 1.0 0.9)
(rule-lhs L10-04_1_lo80_rule ((sem-edge (var g) (var e1) Member (var x) hunt) (sem-edge (var g) (var e2) Agent (var x) (var sc)) (sem-edge (var g) (var e3) Member (var sc) sky_cat) (sem-edge (var g) (var e4) Location (var x) cliff_path)))
(rule-rhs L10-04_1_lo80_rule ((sem-edge (var g) (L10-04_1_lo80_rule_p1 (var e1) (var e2) (var e3) (var e4)) Member (L10-04_1_sk_produce (var x)) produce) (sem-edge-tv (var g) (L10-04_1_lo80_rule_p1 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L10-04_1_lo80_rule_p2 (var e1) (var e2) (var e3) (var e4)) Agent (L10-04_1_sk_produce (var x)) L10-04_1_sk_lantern_1) (sem-edge-tv (var g) (L10-04_1_lo80_rule_p2 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L10-04_1_lo80_rule_p3 (var e1) (var e2) (var e3) (var e4)) Object (L10-04_1_sk_produce (var x)) (L10-04_1_sk_thread (var x))) (sem-edge-tv (var g) (L10-04_1_lo80_rule_p3 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L10-04_1_lo80_rule_p4 (var e1) (var e2) (var e3) (var e4)) GroupOf (L10-04_1_sk_thread (var x)) thread) (sem-edge-tv (var g) (L10-04_1_lo80_rule_p4 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L10-04_1_lo80_rule_p5 (var e1) (var e2) (var e3) (var e4)) CardinalityPhrase (L10-04_1_sk_thread (var x)) "many") (sem-edge-tv (var g) (L10-04_1_lo80_rule_p5 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L10-04_1_lo80_rule_p6 (var e1) (var e2) (var e3) (var e4)) During (L10-04_1_sk_produce (var x)) (var x)) (sem-edge-tv (var g) (L10-04_1_lo80_rule_p6 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9))))

; --- L10-04.6: Keepers at the Hollows often tend lanterns in pairs.
(sem-rule L10-04_6_keeper_tend_rule)
(rule-context L10-04_6_keeper_tend_rule aelmere-lore)
(rule-priority L10-04_6_keeper_tend_rule 279)
(rule-tv L10-04_6_keeper_tend_rule authored 0.8 0.9)
(rule-lhs L10-04_6_keeper_tend_rule ((sem-edge (var g) (var e1) Member (var x) keeper) (sem-edge (var g) (var e2) AttachedTo (var x) hollows)))
(rule-rhs L10-04_6_keeper_tend_rule ((sem-edge (var g) (L10-04_6_keeper_tend_rule_p1 (var e1) (var e2)) Member (L10-04_6_sk_tend (var x)) tend) (sem-edge-tv (var g) (L10-04_6_keeper_tend_rule_p1 (var e1) (var e2)) (STV 0.8 0.9)) (sem-edge (var g) (L10-04_6_keeper_tend_rule_p2 (var e1) (var e2)) Agent (L10-04_6_sk_tend (var x)) (var x)) (sem-edge-tv (var g) (L10-04_6_keeper_tend_rule_p2 (var e1) (var e2)) (STV 0.8 0.9)) (sem-edge (var g) (L10-04_6_keeper_tend_rule_p3 (var e1) (var e2)) Object (L10-04_6_sk_tend (var x)) lantern) (sem-edge-tv (var g) (L10-04_6_keeper_tend_rule_p3 (var e1) (var e2)) (STV 0.8 0.9)) (sem-edge (var g) (L10-04_6_keeper_tend_rule_p4 (var e1) (var e2)) In (L10-04_6_sk_tend (var x)) pair) (sem-edge-tv (var g) (L10-04_6_keeper_tend_rule_p4 (var e1) (var e2)) (STV 0.8 0.9))))

; --- L10-05.4: Whenever a new year begins, the Council begins a new ledger.
(sem-rule L10-05_4_yearly_ledger_rule)
(rule-context L10-05_4_yearly_ledger_rule aelmere-lore)
(rule-priority L10-05_4_yearly_ledger_rule 280)
(rule-tv L10-05_4_yearly_ledger_rule authored 1.0 0.9)
(rule-lhs L10-05_4_yearly_ledger_rule ((sem-edge (var g) (var e1) Member (var e) begin) (sem-edge (var g) (var e2) Object (var e) (var y)) (sem-edge (var g) (var e3) Member (var y) year) (sem-edge (var g) (var e4) Member (var y) new)))
(rule-rhs L10-05_4_yearly_ledger_rule ((sem-edge (var g) (L10-05_4_yearly_ledger_rule_p1 (var e1) (var e2) (var e3) (var e4)) Member (L10-05_4_sk_begin_ledger (var e)) begin) (sem-edge-tv (var g) (L10-05_4_yearly_ledger_rule_p1 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L10-05_4_yearly_ledger_rule_p2 (var e1) (var e2) (var e3) (var e4)) Agent (L10-05_4_sk_begin_ledger (var e)) the_council) (sem-edge-tv (var g) (L10-05_4_yearly_ledger_rule_p2 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L10-05_4_yearly_ledger_rule_p3 (var e1) (var e2) (var e3) (var e4)) Object (L10-05_4_sk_begin_ledger (var e)) (L10-05_4_sk_ledger (var e))) (sem-edge-tv (var g) (L10-05_4_yearly_ledger_rule_p3 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L10-05_4_yearly_ledger_rule_p4 (var e1) (var e2) (var e3) (var e4)) Member (L10-05_4_sk_ledger (var e)) ledger) (sem-edge-tv (var g) (L10-05_4_yearly_ledger_rule_p4 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L10-05_4_yearly_ledger_rule_p5 (var e1) (var e2) (var e3) (var e4)) Member (L10-05_4_sk_ledger (var e)) new) (sem-edge-tv (var g) (L10-05_4_yearly_ledger_rule_p5 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9)) (sem-edge (var g) (L10-05_4_yearly_ledger_rule_p6 (var e1) (var e2) (var e3) (var e4)) During (L10-05_4_sk_begin_ledger (var e)) (var e)) (sem-edge-tv (var g) (L10-05_4_yearly_ledger_rule_p6 (var e1) (var e2) (var e3) (var e4)) (STV 1.0 0.9))))

; --- L10-05.5: The Council speaker dates the first page of each new ledger.
(sem-rule L10-05_5_speaker_dates)
(rule-context L10-05_5_speaker_dates aelmere-lore)
(rule-priority L10-05_5_speaker_dates 281)
(rule-tv L10-05_5_speaker_dates authored 1.0 0.9)
(rule-lhs L10-05_5_speaker_dates ((sem-edge (var g) (var e1) Member (var l) ledger) (sem-edge (var g) (var e2) Member (var l) new)))
(rule-rhs L10-05_5_speaker_dates ((sem-edge (var g) (L10-05_5_speaker_dates_p1 (var e1) (var e2)) Member (L10-05_5_sk_date (var l)) date) (sem-edge-tv (var g) (L10-05_5_speaker_dates_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L10-05_5_speaker_dates_p2 (var e1) (var e2)) Agent (L10-05_5_sk_date (var l)) L10-05_5_sk_speaker_1) (sem-edge-tv (var g) (L10-05_5_speaker_dates_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L10-05_5_speaker_dates_p3 (var e1) (var e2)) Object (L10-05_5_sk_date (var l)) (L10-05_5_sk_page (var l))) (sem-edge-tv (var g) (L10-05_5_speaker_dates_p3 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L10-05_5_speaker_dates_p4 (var e1) (var e2)) Member (L10-05_5_sk_page (var l)) page) (sem-edge-tv (var g) (L10-05_5_speaker_dates_p4 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L10-05_5_speaker_dates_p5 (var e1) (var e2)) PartOf (L10-05_5_sk_page (var l)) (var l)) (sem-edge-tv (var g) (L10-05_5_speaker_dates_p5 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (L10-05_5_speaker_dates_p6 (var e1) (var e2)) Ordinal (L10-05_5_sk_page (var l)) 1 page) (sem-edge-tv (var g) (L10-05_5_speaker_dates_p6 (var e1) (var e2)) (STV 1.0 0.9))))

; --- L10-06.3: Whenever an equinox passes, Aron Brae makes vessels.
(sem-rule L10-06_3_lo85_rule)
(rule-context L10-06_3_lo85_rule aelmere-lore)
(rule-priority L10-06_3_lo85_rule 282)
(rule-tv L10-06_3_lo85_rule authored 1.0 0.9)
(rule-lhs L10-06_3_lo85_rule ((sem-edge (var g) (var e1) Member (var x) pass) (sem-edge (var g) (var e2) Object (var x) (var y)) (sem-edge (var g) (var e3) Member (var y) equinox)))
(rule-rhs L10-06_3_lo85_rule ((sem-edge (var g) (L10-06_3_lo85_rule_p1 (var e1) (var e2) (var e3)) Member (L10-06_3_sk_make (var x)) make) (sem-edge-tv (var g) (L10-06_3_lo85_rule_p1 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L10-06_3_lo85_rule_p2 (var e1) (var e2) (var e3)) Agent (L10-06_3_sk_make (var x)) aron_brae) (sem-edge-tv (var g) (L10-06_3_lo85_rule_p2 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L10-06_3_lo85_rule_p3 (var e1) (var e2) (var e3)) Object (L10-06_3_sk_make (var x)) vessel) (sem-edge-tv (var g) (L10-06_3_lo85_rule_p3 (var e1) (var e2) (var e3)) (STV 1.0 0.9)) (sem-edge (var g) (L10-06_3_lo85_rule_p4 (var e1) (var e2) (var e3)) During (L10-06_3_sk_make (var x)) (var x)) (sem-edge-tv (var g) (L10-06_3_lo85_rule_p4 (var e1) (var e2) (var e3)) (STV 1.0 0.9))))

; --- L10-06.8: The glassworks re-fires damaged domes.
(sem-rule L10-06_8_fire_rule)
(rule-context L10-06_8_fire_rule aelmere-lore)
(rule-priority L10-06_8_fire_rule 283)
(rule-tv L10-06_8_fire_rule authored 0.9 0.9)
(rule-lhs L10-06_8_fire_rule ((sem-edge (var g) (var e1) Member (var x) dome) (sem-edge (var g) (var e2) Member (var x) damaged)))
(rule-rhs L10-06_8_fire_rule ((sem-edge (var g) (L10-06_8_fire_rule_p1 (var e1) (var e2)) Member (L10-06_8_sk_fire (var x)) fire) (sem-edge-tv (var g) (L10-06_8_fire_rule_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L10-06_8_fire_rule_p2 (var e1) (var e2)) Agent (L10-06_8_sk_fire (var x)) L10-06_8_sk_glassworks_1) (sem-edge-tv (var g) (L10-06_8_fire_rule_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L10-06_8_fire_rule_p3 (var e1) (var e2)) Object (L10-06_8_sk_fire (var x)) (var x)) (sem-edge-tv (var g) (L10-06_8_fire_rule_p3 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L10-06_8_fire_rule_p4 (var e1) (var e2)) Again (L10-06_8_sk_fire (var x))) (sem-edge-tv (var g) (L10-06_8_fire_rule_p4 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L10-06.10: Traders from Faltern and the inland farms come to the market each week.
(sem-rule L10-06_10_trader_faltern_rule)
(rule-context L10-06_10_trader_faltern_rule aelmere-lore)
(rule-priority L10-06_10_trader_faltern_rule 284)
(rule-tv L10-06_10_trader_faltern_rule authored 0.9 0.9)
(rule-lhs L10-06_10_trader_faltern_rule ((sem-edge (var g) (var e1) Member (var x) trader) (sem-edge (var g) (var e2) From (var x) faltern)))
(rule-rhs L10-06_10_trader_faltern_rule ((sem-edge (var g) (L10-06_10_trader_faltern_rule_p1 (var e1) (var e2)) Member (L10-06_10_sk_come (var x)) come) (sem-edge-tv (var g) (L10-06_10_trader_faltern_rule_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L10-06_10_trader_faltern_rule_p2 (var e1) (var e2)) Agent (L10-06_10_sk_come (var x)) (var x)) (sem-edge-tv (var g) (L10-06_10_trader_faltern_rule_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L10-06_10_trader_faltern_rule_p3 (var e1) (var e2)) Goal (L10-06_10_sk_come (var x)) L10-06_10_sk_market_1) (sem-edge-tv (var g) (L10-06_10_trader_faltern_rule_p3 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L10-06_10_trader_faltern_rule_p4 (var e1) (var e2)) Every (L10-06_10_sk_come (var x)) 1 week) (sem-edge-tv (var g) (L10-06_10_trader_faltern_rule_p4 (var e1) (var e2)) (STV 0.9 0.9))))

; --- L10-06.10: Traders from Faltern and the inland farms come to the market each week.
(sem-rule L10-06_10_trader_farms_rule)
(rule-context L10-06_10_trader_farms_rule aelmere-lore)
(rule-priority L10-06_10_trader_farms_rule 285)
(rule-tv L10-06_10_trader_farms_rule authored 0.9 0.9)
(rule-lhs L10-06_10_trader_farms_rule ((sem-edge (var g) (var e1) Member (var x) trader) (sem-edge (var g) (var e2) From (var x) L10-06_10_sk_farms_1)))
(rule-rhs L10-06_10_trader_farms_rule ((sem-edge (var g) (L10-06_10_trader_farms_rule_p1 (var e1) (var e2)) Member (L10-06_10_sk_come (var x)) come) (sem-edge-tv (var g) (L10-06_10_trader_farms_rule_p1 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L10-06_10_trader_farms_rule_p2 (var e1) (var e2)) Agent (L10-06_10_sk_come (var x)) (var x)) (sem-edge-tv (var g) (L10-06_10_trader_farms_rule_p2 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L10-06_10_trader_farms_rule_p3 (var e1) (var e2)) Goal (L10-06_10_sk_come (var x)) L10-06_10_sk_market_1) (sem-edge-tv (var g) (L10-06_10_trader_farms_rule_p3 (var e1) (var e2)) (STV 0.9 0.9)) (sem-edge (var g) (L10-06_10_trader_farms_rule_p4 (var e1) (var e2)) Every (L10-06_10_sk_come (var x)) 1 week) (sem-edge-tv (var g) (L10-06_10_trader_farms_rule_p4 (var e1) (var e2)) (STV 0.9 0.9))))

; --- E1-01: The autumn equinox took place on day 0 of Year 1. Every autumn equinox begins moth-season. The East Row is a lantern-row on the Cliff Path. The Middle Row is a lantern-row on the Cliff Path. The Harbor Row is a lantern-row along the harbor wall. The Harbor Station is a lantern-station on the Cliff Path near the harbor.
(sem-rule E1-01_eq_begin_rule)
(rule-context E1-01_eq_begin_rule aelmere-events)
(rule-priority E1-01_eq_begin_rule 286)
(rule-tv E1-01_eq_begin_rule authored 1.0 0.9)
(rule-lhs E1-01_eq_begin_rule ((sem-edge (var g) (var e1) Member (var x) autumn_equinox)))
(rule-rhs E1-01_eq_begin_rule ((sem-edge (var g) (E1-01_eq_begin_rule_p1 (var e1)) Member (E1-01_sk_begin (var x)) begin) (sem-edge-tv (var g) (E1-01_eq_begin_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (E1-01_eq_begin_rule_p2 (var e1)) Agent (E1-01_sk_begin (var x)) (var x)) (sem-edge-tv (var g) (E1-01_eq_begin_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (E1-01_eq_begin_rule_p3 (var e1)) Object (E1-01_sk_begin (var x)) moth_season) (sem-edge-tv (var g) (E1-01_eq_begin_rule_p3 (var e1)) (STV 1.0 0.9))))

; --- E1-06: In the late summer of Year 1, one day before the autumn equinox, Meren Tallowhand walked to a station on the Cliff Path at sundown. Meren Tallowhand lit the lantern at the station. The lantern burned mire-essence. The lantern produced mist-light. The lantern showed mist-light at night. The mist-light attracted nightmoths. Meren Tallowhand tended the lantern that night. Meren Tallowhand counted seventeen nightmoths at the lantern at the third watch. A handful of nightmoths gathered at the Middle Row that night. All the sky-cats stayed on the cliff-spires that night.
(sem-rule E1-06_s10_stay_rule)
(rule-context E1-06_s10_stay_rule aelmere-events)
(rule-priority E1-06_s10_stay_rule 287)
(rule-tv E1-06_s10_stay_rule authored 1.0 0.9)
(rule-lhs E1-06_s10_stay_rule ((sem-edge (var g) (var e1) Member (var x) sky_cat)))
(rule-rhs E1-06_s10_stay_rule ((sem-edge (var g) (E1-06_s10_stay_rule_p1 (var e1)) Member (E1-06_sk_stay (var x)) stay) (sem-edge-tv (var g) (E1-06_s10_stay_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (E1-06_s10_stay_rule_p2 (var e1)) Experiencer (E1-06_sk_stay (var x)) (var x)) (sem-edge-tv (var g) (E1-06_s10_stay_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (E1-06_s10_stay_rule_p3 (var e1)) Location (E1-06_sk_stay (var x)) E1-06_sk_cliff_spire_1) (sem-edge-tv (var g) (E1-06_s10_stay_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (E1-06_s10_stay_rule_p4 (var e1)) Time (E1-06_sk_stay (var x)) night) (sem-edge-tv (var g) (E1-06_s10_stay_rule_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (E1-06_s10_stay_rule_p5 (var e1)) Time (E1-06_sk_stay (var x)) (Year 1)) (sem-edge-tv (var g) (E1-06_s10_stay_rule_p5 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (E1-06_s10_stay_rule_p6 (var e1)) Past (E1-06_sk_stay (var x))) (sem-edge-tv (var g) (E1-06_s10_stay_rule_p6 (var e1)) (STV 1.0 0.9))))

; --- E1-08: On day 0 of Year 1, the night of the autumn equinox was clear and mild. Keepers counted about twenty-five nightmoths at each lantern of the Cliff Path. A crowd of nightmoths gathered at the East Row. Three sky-cats descended from the cliff-spires. The three sky-cats hunted the nightmoth crowd at the East Row. The nightmoth crowd at the East Row shrank. Keepers counted seven of the nightmoths at the East Row at the third watch. Some nightmoths survived the hunt. The surviving nightmoths fled to the Hollows. The surviving nightmoths reached the Hollows.
(sem-rule E1-08_s2_rule)
(rule-context E1-08_s2_rule aelmere-events)
(rule-priority E1-08_s2_rule 288)
(rule-tv E1-08_s2_rule authored 1.0 0.9)
(rule-lhs E1-08_s2_rule ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) AttachedTo (var x) cliff_path)))
(rule-rhs E1-08_s2_rule ((sem-edge (var g) (E1-08_s2_rule_p1 (var e1) (var e2)) Member (E1-08_sk_count (var x)) count) (sem-edge-tv (var g) (E1-08_s2_rule_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E1-08_s2_rule_p2 (var e1) (var e2)) Agent (E1-08_sk_count (var x)) E1-08_sk_keepers_1) (sem-edge-tv (var g) (E1-08_s2_rule_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E1-08_s2_rule_p3 (var e1) (var e2)) Object (E1-08_sk_count (var x)) (E1-08_sk_moths (var x))) (sem-edge-tv (var g) (E1-08_s2_rule_p3 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E1-08_s2_rule_p4 (var e1) (var e2)) GroupOf (E1-08_sk_moths (var x)) nightmoth) (sem-edge-tv (var g) (E1-08_s2_rule_p4 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E1-08_s2_rule_p5 (var e1) (var e2)) Cardinality (E1-08_sk_moths (var x)) (ParticleFromNormal 25 2.5)) (sem-edge-tv (var g) (E1-08_s2_rule_p5 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E1-08_s2_rule_p6 (var e1) (var e2)) Location (E1-08_sk_count (var x)) (var x)) (sem-edge-tv (var g) (E1-08_s2_rule_p6 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E1-08_s2_rule_p7 (var e1) (var e2)) Past (E1-08_sk_count (var x))) (sem-edge-tv (var g) (E1-08_s2_rule_p7 (var e1) (var e2)) (STV 1.0 0.9))))

; --- E2-01: On day 16 of Year 1, a cold wind blew off the sea at night. The cold wind was a north wind. The cold wind struck the Cliff Path at night. The cold wind came before the first hard frost. The salt-bloom season had not yet started. The keepers on the Cliff Path had not yet added salt-bloom to the mire-essence of their lanterns. That night, eleven lanterns on the Middle Row were unprepared. The eleven lanterns went out before dawn. No lantern at the Sunken Cove went out. No lantern in the Northcove went out. The cliff-spires sheltered the Northcove against the north wind.
(sem-rule E2-01_s9_rule)
(rule-context E2-01_s9_rule aelmere-events)
(rule-priority E2-01_s9_rule 289)
(rule-tv E2-01_s9_rule authored 0.0 0.9)
(rule-lhs E2-01_s9_rule ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) AttachedTo (var x) sunken_cove)))
(rule-rhs E2-01_s9_rule ((sem-edge (var g) (E2-01_s9_rule_p1 (var e1) (var e2)) And (Member (E2-01_sk_go_out (var x)) go_out) (Object (E2-01_sk_go_out (var x)) (var x)) (Past (E2-01_sk_go_out (var x)))) (sem-edge-tv (var g) (E2-01_s9_rule_p1 (var e1) (var e2)) (STV 0.0 0.9))))

; --- E2-01: On day 16 of Year 1, a cold wind blew off the sea at night. The cold wind was a north wind. The cold wind struck the Cliff Path at night. The cold wind came before the first hard frost. The salt-bloom season had not yet started. The keepers on the Cliff Path had not yet added salt-bloom to the mire-essence of their lanterns. That night, eleven lanterns on the Middle Row were unprepared. The eleven lanterns went out before dawn. No lantern at the Sunken Cove went out. No lantern in the Northcove went out. The cliff-spires sheltered the Northcove against the north wind.
(sem-rule E2-01_s10_rule)
(rule-context E2-01_s10_rule aelmere-events)
(rule-priority E2-01_s10_rule 290)
(rule-tv E2-01_s10_rule authored 0.0 0.9)
(rule-lhs E2-01_s10_rule ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) AttachedTo (var x) northcove)))
(rule-rhs E2-01_s10_rule ((sem-edge (var g) (E2-01_s10_rule_p1 (var e1) (var e2)) And (Member (E2-01_sk_go_out (var x)) go_out) (Object (E2-01_sk_go_out (var x)) (var x)) (Past (E2-01_sk_go_out (var x)))) (sem-edge-tv (var g) (E2-01_s10_rule_p1 (var e1) (var e2)) (STV 0.0 0.9))))

; --- E3-04: On day 34 of Year 1, the harvest party returned to Cauldron Hall at dawn and carried twelve full buckets of salt-bloom. The harvest was heavy. Hesper poured the salt-bloom into the salt-bloom store. Hesper wrote the date on each compartment of the store. The salt-bloom stayed potent.
(sem-rule E3-04_compartment_write_rule)
(rule-context E3-04_compartment_write_rule aelmere-events)
(rule-priority E3-04_compartment_write_rule 291)
(rule-tv E3-04_compartment_write_rule authored 1.0 0.9)
(rule-lhs E3-04_compartment_write_rule ((sem-edge (var g) (var e1) PartOf (var c) E3-04_sk_salt_bloom_store_1) (sem-edge (var g) (var e2) Member (var c) compartment)))
(rule-rhs E3-04_compartment_write_rule ((sem-edge (var g) (E3-04_compartment_write_rule_p1 (var e1) (var e2)) Member (E3-04_sk_write (var c)) write) (sem-edge-tv (var g) (E3-04_compartment_write_rule_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E3-04_compartment_write_rule_p2 (var e1) (var e2)) Agent (E3-04_sk_write (var c)) hesper) (sem-edge-tv (var g) (E3-04_compartment_write_rule_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E3-04_compartment_write_rule_p3 (var e1) (var e2)) Object (E3-04_sk_write (var c)) E3-04_sk_date_1) (sem-edge-tv (var g) (E3-04_compartment_write_rule_p3 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E3-04_compartment_write_rule_p4 (var e1) (var e2)) Location (E3-04_sk_write (var c)) (var c)) (sem-edge-tv (var g) (E3-04_compartment_write_rule_p4 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E3-04_compartment_write_rule_p5 (var e1) (var e2)) Past (E3-04_sk_write (var c))) (sem-edge-tv (var g) (E3-04_compartment_write_rule_p5 (var e1) (var e2)) (STV 1.0 0.9))))

; --- E4-04: On day 75 of Year 1, a sky-cat hunted nightmoths at the Sunken Cove on a clear night. Sky-cats rarely hunt at the Sunken Cove. The Council discussed burning wintergloss at the Stilllight Lantern. Wintergloss repels nightmoths from a lantern. The Council declined the wintergloss, because the Stilllight Lantern drew a handful of nightmoths.
(sem-rule E4-04_s2_skycat_hunt_rule)
(rule-context E4-04_s2_skycat_hunt_rule aelmere-events)
(rule-priority E4-04_s2_skycat_hunt_rule 292)
(rule-tv E4-04_s2_skycat_hunt_rule authored 0.1 0.9)
(rule-lhs E4-04_s2_skycat_hunt_rule ((sem-edge (var g) (var e1) Member (var x) sky_cat)))
(rule-rhs E4-04_s2_skycat_hunt_rule ((sem-edge (var g) (E4-04_s2_skycat_hunt_rule_p1 (var e1)) And (Member (E4-04_sk_hunt (var x)) hunt) (Agent (E4-04_sk_hunt (var x)) (var x)) (Location (E4-04_sk_hunt (var x)) sunken_cove)) (sem-edge-tv (var g) (E4-04_s2_skycat_hunt_rule_p1 (var e1)) (STV 0.1 0.9))))

; --- E5-01: On day 92 of Year 1, the first hard frost came. The harbor was white with rime in the morning. The cold wind blew off the sea from dusk until dawn. Keepers on the Cliff Path added salt-bloom to the mire-essence in winter. Every lantern on the Cliff Path was salt-bloomed. The cold wind struck the salt-bloomed lanterns of the Cliff Path at night. The mire-essence burned slowly. Every lantern on the Cliff Path stayed lit from dusk until dawn.
(sem-rule E5-01_s5_lantern_rule)
(rule-context E5-01_s5_lantern_rule aelmere-events)
(rule-priority E5-01_s5_lantern_rule 293)
(rule-tv E5-01_s5_lantern_rule authored 1.0 0.9)
(rule-lhs E5-01_s5_lantern_rule ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) AttachedTo (var x) cliff_path)))
(rule-rhs E5-01_s5_lantern_rule ((sem-edge (var g) (E5-01_s5_lantern_rule_p1 (var e1) (var e2)) Member (E5-01_sk_salt_bloom (var x)) salt_bloom) (sem-edge-tv (var g) (E5-01_s5_lantern_rule_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E5-01_s5_lantern_rule_p2 (var e1) (var e2)) Object (E5-01_sk_salt_bloom (var x)) (var x)) (sem-edge-tv (var g) (E5-01_s5_lantern_rule_p2 (var e1) (var e2)) (STV 1.0 0.9))))

; --- E5-01: On day 92 of Year 1, the first hard frost came. The harbor was white with rime in the morning. The cold wind blew off the sea from dusk until dawn. Keepers on the Cliff Path added salt-bloom to the mire-essence in winter. Every lantern on the Cliff Path was salt-bloomed. The cold wind struck the salt-bloomed lanterns of the Cliff Path at night. The mire-essence burned slowly. Every lantern on the Cliff Path stayed lit from dusk until dawn.
(sem-rule E5-01_s8_lantern_lit_flat_rule)
(rule-context E5-01_s8_lantern_lit_flat_rule aelmere-events)
(rule-priority E5-01_s8_lantern_lit_flat_rule 294)
(rule-tv E5-01_s8_lantern_lit_flat_rule authored 1.0 0.9)
(rule-lhs E5-01_s8_lantern_lit_flat_rule ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) AttachedTo (var x) cliff_path)))
(rule-rhs E5-01_s8_lantern_lit_flat_rule ((sem-edge (var g) (E5-01_s8_lantern_lit_flat_rule_p1 (var e1) (var e2)) Past (Member (var x) lit)) (sem-edge-tv (var g) (E5-01_s8_lantern_lit_flat_rule_p1 (var e1) (var e2)) (STV 1.0 0.9))))

; --- E5-01: On day 92 of Year 1, the first hard frost came. The harbor was white with rime in the morning. The cold wind blew off the sea from dusk until dawn. Keepers on the Cliff Path added salt-bloom to the mire-essence in winter. Every lantern on the Cliff Path was salt-bloomed. The cold wind struck the salt-bloomed lanterns of the Cliff Path at night. The mire-essence burned slowly. Every lantern on the Cliff Path stayed lit from dusk until dawn.
(sem-rule E5-01_s8_lantern_lit_state_rule)
(rule-context E5-01_s8_lantern_lit_state_rule aelmere-events)
(rule-priority E5-01_s8_lantern_lit_state_rule 295)
(rule-tv E5-01_s8_lantern_lit_state_rule authored 1.0 0.9)
(rule-lhs E5-01_s8_lantern_lit_state_rule ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) AttachedTo (var x) cliff_path)))
(rule-rhs E5-01_s8_lantern_lit_state_rule ((sem-edge (var g) (E5-01_s8_lantern_lit_state_rule_p1 (var e1) (var e2)) Member (E5-01_sk_lit (var x)) lit) (sem-edge-tv (var g) (E5-01_s8_lantern_lit_state_rule_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E5-01_s8_lantern_lit_state_rule_p2 (var e1) (var e2)) Experiencer (E5-01_sk_lit (var x)) (var x)) (sem-edge-tv (var g) (E5-01_s8_lantern_lit_state_rule_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E5-01_s8_lantern_lit_state_rule_p3 (var e1) (var e2)) Still (E5-01_sk_lit (var x))) (sem-edge-tv (var g) (E5-01_s8_lantern_lit_state_rule_p3 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E5-01_s8_lantern_lit_state_rule_p4 (var e1) (var e2)) Start (E5-01_sk_lit (var x)) dusk) (sem-edge-tv (var g) (E5-01_s8_lantern_lit_state_rule_p4 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E5-01_s8_lantern_lit_state_rule_p5 (var e1) (var e2)) End (E5-01_sk_lit (var x)) dawn) (sem-edge-tv (var g) (E5-01_s8_lantern_lit_state_rule_p5 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E5-01_s8_lantern_lit_state_rule_p6 (var e1) (var e2)) Past (E5-01_sk_lit (var x))) (sem-edge-tv (var g) (E5-01_s8_lantern_lit_state_rule_p6 (var e1) (var e2)) (STV 1.0 0.9))))

; --- E5-04: On day 111 of Year 1, Lantern-night fell. Lantern-night is the longest night of the year. The night was clear and very cold. Every lantern in Aelmere was lit. Meren Tallowhand lit the Stilllight Lantern at sundown as the speaker of the Council. Every villager walked the Cliff Path at midnight from the harbor wall to the cliff-spires. The cold wind blew strongly that night. Every lantern on the Cliff Path held. Coraline Ash walked beside Pell. Joren Salt walked beside Meren Tallowhand. The villagers told stories at the harbor fires until dawn. Old Vesh told the story of the bad winter of sixty-three years ago. Three sky-cats were visible on the cliff-spires in the morning.
(sem-rule E5-04_r_lantern_lit)
(rule-context E5-04_r_lantern_lit aelmere-events)
(rule-priority E5-04_r_lantern_lit 296)
(rule-tv E5-04_r_lantern_lit authored 1.0 0.9)
(rule-lhs E5-04_r_lantern_lit ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) AttachedTo (var x) aelmere)))
(rule-rhs E5-04_r_lantern_lit ((sem-edge (var g) (E5-04_r_lantern_lit_p1 (var e1) (var e2)) Member (E5-04_sk_light (var x)) light) (sem-edge-tv (var g) (E5-04_r_lantern_lit_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E5-04_r_lantern_lit_p2 (var e1) (var e2)) Object (E5-04_sk_light (var x)) (var x)) (sem-edge-tv (var g) (E5-04_r_lantern_lit_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E5-04_r_lantern_lit_p3 (var e1) (var e2)) Past (E5-04_sk_light (var x))) (sem-edge-tv (var g) (E5-04_r_lantern_lit_p3 (var e1) (var e2)) (STV 1.0 0.9))))

; --- E5-04: On day 111 of Year 1, Lantern-night fell. Lantern-night is the longest night of the year. The night was clear and very cold. Every lantern in Aelmere was lit. Meren Tallowhand lit the Stilllight Lantern at sundown as the speaker of the Council. Every villager walked the Cliff Path at midnight from the harbor wall to the cliff-spires. The cold wind blew strongly that night. Every lantern on the Cliff Path held. Coraline Ash walked beside Pell. Joren Salt walked beside Meren Tallowhand. The villagers told stories at the harbor fires until dawn. Old Vesh told the story of the bad winter of sixty-three years ago. Three sky-cats were visible on the cliff-spires in the morning.
(sem-rule E5-04_r_villager_walk)
(rule-context E5-04_r_villager_walk aelmere-events)
(rule-priority E5-04_r_villager_walk 297)
(rule-tv E5-04_r_villager_walk authored 1.0 0.9)
(rule-lhs E5-04_r_villager_walk ((sem-edge (var g) (var e1) Member (var x) villager)))
(rule-rhs E5-04_r_villager_walk ((sem-edge (var g) (E5-04_r_villager_walk_p1 (var e1)) Member (E5-04_sk_walk (var x)) walk) (sem-edge-tv (var g) (E5-04_r_villager_walk_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (E5-04_r_villager_walk_p2 (var e1)) Agent (E5-04_sk_walk (var x)) (var x)) (sem-edge-tv (var g) (E5-04_r_villager_walk_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (E5-04_r_villager_walk_p3 (var e1)) Object (E5-04_sk_walk (var x)) cliff_path) (sem-edge-tv (var g) (E5-04_r_villager_walk_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (E5-04_r_villager_walk_p4 (var e1)) Time (E5-04_sk_walk (var x)) midnight) (sem-edge-tv (var g) (E5-04_r_villager_walk_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (E5-04_r_villager_walk_p5 (var e1)) Source (E5-04_sk_walk (var x)) E5-04_sk_harbor_wall_1) (sem-edge-tv (var g) (E5-04_r_villager_walk_p5 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (E5-04_r_villager_walk_p6 (var e1)) Goal (E5-04_sk_walk (var x)) E5-04_sk_cliff_spires_1) (sem-edge-tv (var g) (E5-04_r_villager_walk_p6 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (E5-04_r_villager_walk_p7 (var e1)) Past (E5-04_sk_walk (var x))) (sem-edge-tv (var g) (E5-04_r_villager_walk_p7 (var e1)) (STV 1.0 0.9))))

; --- E5-04: On day 111 of Year 1, Lantern-night fell. Lantern-night is the longest night of the year. The night was clear and very cold. Every lantern in Aelmere was lit. Meren Tallowhand lit the Stilllight Lantern at sundown as the speaker of the Council. Every villager walked the Cliff Path at midnight from the harbor wall to the cliff-spires. The cold wind blew strongly that night. Every lantern on the Cliff Path held. Coraline Ash walked beside Pell. Joren Salt walked beside Meren Tallowhand. The villagers told stories at the harbor fires until dawn. Old Vesh told the story of the bad winter of sixty-three years ago. Three sky-cats were visible on the cliff-spires in the morning.
(sem-rule E5-04_r_lantern_hold)
(rule-context E5-04_r_lantern_hold aelmere-events)
(rule-priority E5-04_r_lantern_hold 298)
(rule-tv E5-04_r_lantern_hold authored 1.0 0.9)
(rule-lhs E5-04_r_lantern_hold ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) AttachedTo (var x) cliff_path)))
(rule-rhs E5-04_r_lantern_hold ((sem-edge (var g) (E5-04_r_lantern_hold_p1 (var e1) (var e2)) Member (E5-04_sk_hold (var x)) hold) (sem-edge-tv (var g) (E5-04_r_lantern_hold_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E5-04_r_lantern_hold_p2 (var e1) (var e2)) Experiencer (E5-04_sk_hold (var x)) (var x)) (sem-edge-tv (var g) (E5-04_r_lantern_hold_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E5-04_r_lantern_hold_p3 (var e1) (var e2)) Past (E5-04_sk_hold (var x))) (sem-edge-tv (var g) (E5-04_r_lantern_hold_p3 (var e1) (var e2)) (STV 1.0 0.9))))

; --- E7-06: On day 259 of Year 1, Coraline Ash lit the lantern of the Harbor Station at sundown on the thirtieth night of the solo stretch. Coraline Ash completed thirty solo nights. Coraline Ash's solo count reached thirty. Coraline Ash's solo count was large. Pell and Coraline Ash met at dawn on day 260 of Year 1. Coraline Ash and Pell walked back to Aelmere together. The Council met in an informal session on day 260 of Year 1. The Council invested Coraline Ash as a Keeper. Coraline Ash lit her first lantern as a Keeper at sundown. Meren Tallowhand placed a hand on Coraline Ash's shoulder. Meren Tallowhand repeated the phrase. Every villager present repeated the phrase.
(sem-rule E7-06_s12_rule)
(rule-context E7-06_s12_rule aelmere-events)
(rule-priority E7-06_s12_rule 299)
(rule-tv E7-06_s12_rule authored 1.0 0.9)
(rule-lhs E7-06_s12_rule ((sem-edge (var g) (var e1) Member (var x) villager) (sem-edge (var g) (var e2) Member (var x) present)))
(rule-rhs E7-06_s12_rule ((sem-edge (var g) (E7-06_s12_rule_p1 (var e1) (var e2)) Member (E7-06_sk_repeat (var x)) repeat) (sem-edge-tv (var g) (E7-06_s12_rule_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E7-06_s12_rule_p2 (var e1) (var e2)) Agent (E7-06_sk_repeat (var x)) (var x)) (sem-edge-tv (var g) (E7-06_s12_rule_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E7-06_s12_rule_p3 (var e1) (var e2)) Object (E7-06_sk_repeat (var x)) E7-06_sk_phrase_1) (sem-edge-tv (var g) (E7-06_s12_rule_p3 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E7-06_s12_rule_p4 (var e1) (var e2)) Past (E7-06_sk_repeat (var x))) (sem-edge-tv (var g) (E7-06_s12_rule_p4 (var e1) (var e2)) (STV 1.0 0.9))))

; --- E7-10: On day 301 of Year 1, the keepers of the Harbor Row together collected the silken threads from the lanterns of the Harbor Row at dawn. The keepers carried the silken threads to Cauldron Hall. Hesper boiled the silken threads in sea-water. Mire-essence formed in the cauldrons by evening. Hesper stored the mire-essence in four clay vessels. The keepers of the Harbor Row drew the stored mire-essence at sundown. Tessa Brae collected thirty of the fallen feathers at the base of the cliff in the morning. Tessa Brae added the feathers to the feather bin. Bevin Coombe took feathers from the feather bin. Bevin Coombe ground the feathers. The Stilllight Lantern was lit. Bevin Coombe scattered the ground feathers around the Stilllight Lantern at sundown. The ground feathers warded the Stilllight Lantern against wraiths. No wraith approached the Stilllight Lantern that night.
(sem-rule E7-10_s14_noapproach_rule)
(rule-context E7-10_s14_noapproach_rule aelmere-events)
(rule-priority E7-10_s14_noapproach_rule 300)
(rule-tv E7-10_s14_noapproach_rule authored 0.0 0.9)
(rule-lhs E7-10_s14_noapproach_rule ((sem-edge (var g) (var e1) Member (var x) wraith)))
(rule-rhs E7-10_s14_noapproach_rule ((sem-edge (var g) (E7-10_s14_noapproach_rule_p1 (var e1)) And (Member (E7-10_sk_approach (var x)) approach) (Agent (E7-10_sk_approach (var x)) (var x)) (Object (E7-10_sk_approach (var x)) stilllight_lantern) (Time (E7-10_sk_approach (var x)) night) (Past (E7-10_sk_approach (var x)))) (sem-edge-tv (var g) (E7-10_s14_noapproach_rule_p1 (var e1)) (STV 0.0 0.9))))

; --- E8-04: On day 395 of Year 2, the first cold snap of Year 2 came. Every lantern on the Cliff Path already held salt-bloom in its mire-essence. No lantern went out. The lanterns of the three bright stations burned extra mire-essence. The lanterns of the three bright stations produced strong mist-light. The lanterns showed mist-light at night. The strong mist-light attracted crowds of nightmoths. Keepers counted about thirty nightmoths per night at each bright station. A crowd of nightmoths gathered at the Middle Row on six of the next ten nights. Sky-cats descended from the cliff-spires on those six nights. The sky-cats hunted the nightmoth crowds at the Middle Row on those six nights. The sky-cats molted during the hunts. Feathers fell to the base of the cliff. The feather harvest in the following month was strong.
(sem-rule E8-04_lantern_hold_rule)
(rule-context E8-04_lantern_hold_rule aelmere-events)
(rule-priority E8-04_lantern_hold_rule 301)
(rule-tv E8-04_lantern_hold_rule authored 1.0 0.9)
(rule-lhs E8-04_lantern_hold_rule ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) AttachedTo (var x) cliff_path)))
(rule-rhs E8-04_lantern_hold_rule ((sem-edge (var g) (E8-04_lantern_hold_rule_p1 (var e1) (var e2)) Member (E8-04_sk_hold (var x)) hold) (sem-edge-tv (var g) (E8-04_lantern_hold_rule_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E8-04_lantern_hold_rule_p2 (var e1) (var e2)) Agent (E8-04_sk_hold (var x)) (var x)) (sem-edge-tv (var g) (E8-04_lantern_hold_rule_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E8-04_lantern_hold_rule_p3 (var e1) (var e2)) Object (E8-04_sk_hold (var x)) salt_bloom) (sem-edge-tv (var g) (E8-04_lantern_hold_rule_p3 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E8-04_lantern_hold_rule_p4 (var e1) (var e2)) Location (E8-04_sk_hold (var x)) (E8-04_sk_mire_essence (var x))) (sem-edge-tv (var g) (E8-04_lantern_hold_rule_p4 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E8-04_lantern_hold_rule_p5 (var e1) (var e2)) Member (E8-04_sk_mire_essence (var x)) mire_essence) (sem-edge-tv (var g) (E8-04_lantern_hold_rule_p5 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E8-04_lantern_hold_rule_p6 (var e1) (var e2)) Possession (E8-04_sk_mire_essence (var x)) (var x)) (sem-edge-tv (var g) (E8-04_lantern_hold_rule_p6 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E8-04_lantern_hold_rule_p7 (var e1) (var e2)) Past (E8-04_sk_hold (var x))) (sem-edge-tv (var g) (E8-04_lantern_hold_rule_p7 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E8-04_lantern_hold_rule_p8 (var e1) (var e2)) Already (E8-04_sk_hold (var x))) (sem-edge-tv (var g) (E8-04_lantern_hold_rule_p8 (var e1) (var e2)) (STV 1.0 0.9))))

; --- E8-04: On day 395 of Year 2, the first cold snap of Year 2 came. Every lantern on the Cliff Path already held salt-bloom in its mire-essence. No lantern went out. The lanterns of the three bright stations burned extra mire-essence. The lanterns of the three bright stations produced strong mist-light. The lanterns showed mist-light at night. The strong mist-light attracted crowds of nightmoths. Keepers counted about thirty nightmoths per night at each bright station. A crowd of nightmoths gathered at the Middle Row on six of the next ten nights. Sky-cats descended from the cliff-spires on those six nights. The sky-cats hunted the nightmoth crowds at the Middle Row on those six nights. The sky-cats molted during the hunts. Feathers fell to the base of the cliff. The feather harvest in the following month was strong.
(sem-rule E8-04_lantern_goout_rule)
(rule-context E8-04_lantern_goout_rule aelmere-events)
(rule-priority E8-04_lantern_goout_rule 302)
(rule-tv E8-04_lantern_goout_rule authored 0.0 0.9)
(rule-lhs E8-04_lantern_goout_rule ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) AttachedTo (var x) cliff_path)))
(rule-rhs E8-04_lantern_goout_rule ((sem-edge (var g) (E8-04_lantern_goout_rule_p1 (var e1) (var e2)) And (Member (E8-04_sk_go_out (var x)) go_out) (Object (E8-04_sk_go_out (var x)) (var x)) (Past (E8-04_sk_go_out (var x)))) (sem-edge-tv (var g) (E8-04_lantern_goout_rule_p1 (var e1) (var e2)) (STV 0.0 0.9))))

; --- E9-05: On day 470 of Year 2, the first snow of Year 2 fell in the early evening. The snow was gone by dawn. Every lantern burned normally that night. The cold wind did not blow that night. The mist-light was visible from a great distance, because the snow reflected the mist-light. Coraline Ash counted many nightmoths at the Harbor Station that week.
(sem-rule E9-05_p3_lantern_rule)
(rule-context E9-05_p3_lantern_rule aelmere-events)
(rule-priority E9-05_p3_lantern_rule 303)
(rule-tv E9-05_p3_lantern_rule authored 1.0 0.9)
(rule-lhs E9-05_p3_lantern_rule ((sem-edge (var g) (var e1) Member (var x) lantern)))
(rule-rhs E9-05_p3_lantern_rule ((sem-edge (var g) (E9-05_p3_lantern_rule_p1 (var e1)) Member (E9-05_sk_burn (var x)) burn) (sem-edge-tv (var g) (E9-05_p3_lantern_rule_p1 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (E9-05_p3_lantern_rule_p2 (var e1)) Object (E9-05_sk_burn (var x)) (var x)) (sem-edge-tv (var g) (E9-05_p3_lantern_rule_p2 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (E9-05_p3_lantern_rule_p3 (var e1)) Manner (E9-05_sk_burn (var x)) normally) (sem-edge-tv (var g) (E9-05_p3_lantern_rule_p3 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (E9-05_p3_lantern_rule_p4 (var e1)) Time (E9-05_sk_burn (var x)) (Year 2)) (sem-edge-tv (var g) (E9-05_p3_lantern_rule_p4 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (E9-05_p3_lantern_rule_p5 (var e1)) Time (E9-05_sk_burn (var x)) (Day 470)) (sem-edge-tv (var g) (E9-05_p3_lantern_rule_p5 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (E9-05_p3_lantern_rule_p6 (var e1)) Time (E9-05_sk_burn (var x)) night) (sem-edge-tv (var g) (E9-05_p3_lantern_rule_p6 (var e1)) (STV 1.0 0.9)) (sem-edge (var g) (E9-05_p3_lantern_rule_p7 (var e1)) Past (E9-05_sk_burn (var x))) (sem-edge-tv (var g) (E9-05_p3_lantern_rule_p7 (var e1)) (STV 1.0 0.9))))

; --- E9-08: On day 510 of Year 2, a cold wind blew off the sea for two weeks in midwinter. Every lantern on the Cliff Path held through the two weeks. The Northcove was unaffected. Keepers on the Cliff Path refilled the mire-essence at midnight and at the third watch. Keepers on the Cliff Path used extra salt-bloom per lantern. The Council raised the salt-bloom ration by ten percent for the two weeks. A handful of nightmoths flew in the cold wind each night. The thread harvest on the Cliff Path was steady through the two weeks. Cauldron Hall distilled at its normal cadence.
(sem-rule E9-08_s2_lantern_rule)
(rule-context E9-08_s2_lantern_rule aelmere-events)
(rule-priority E9-08_s2_lantern_rule 304)
(rule-tv E9-08_s2_lantern_rule authored 1.0 0.9)
(rule-lhs E9-08_s2_lantern_rule ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) AttachedTo (var x) cliff_path)))
(rule-rhs E9-08_s2_lantern_rule ((sem-edge (var g) (E9-08_s2_lantern_rule_p1 (var e1) (var e2)) Member (E9-08_sk_hold (var x)) hold) (sem-edge-tv (var g) (E9-08_s2_lantern_rule_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E9-08_s2_lantern_rule_p2 (var e1) (var e2)) Experiencer (E9-08_sk_hold (var x)) (var x)) (sem-edge-tv (var g) (E9-08_s2_lantern_rule_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E9-08_s2_lantern_rule_p3 (var e1) (var e2)) Past (E9-08_sk_hold (var x))) (sem-edge-tv (var g) (E9-08_s2_lantern_rule_p3 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E9-08_s2_lantern_rule_p4 (var e1) (var e2)) Measure (E9-08_sk_hold (var x)) duration 2 week) (sem-edge-tv (var g) (E9-08_s2_lantern_rule_p4 (var e1) (var e2)) (STV 1.0 0.9))))

; --- E10-06: On day 620 of Year 2, the night was clear and warm. Keepers counted about twenty-eight nightmoths at each lantern of the Cliff Path. A crowd of nightmoths gathered at the East Row. A crowd of nightmoths gathered at the Middle Row. Sky-cats descended from the cliff-spires. The sky-cats hunted the nightmoth crowds at the East Row and at the Middle Row. Keepers counted about ten nightmoths at the East Row at the third watch. Keepers counted about ten nightmoths at the Middle Row at the third watch. Tessa Brae collected thirty-five feathers the next morning. Hesper distilled four vessels of mire-essence that day.
(sem-rule E10-06_s2_lantern_rule)
(rule-context E10-06_s2_lantern_rule aelmere-events)
(rule-priority E10-06_s2_lantern_rule 305)
(rule-tv E10-06_s2_lantern_rule authored 1.0 0.9)
(rule-lhs E10-06_s2_lantern_rule ((sem-edge (var g) (var e1) Member (var x) lantern) (sem-edge (var g) (var e2) AttachedTo (var x) cliff_path)))
(rule-rhs E10-06_s2_lantern_rule ((sem-edge (var g) (E10-06_s2_lantern_rule_p1 (var e1) (var e2)) Member (E10-06_sk_count (var x)) count) (sem-edge-tv (var g) (E10-06_s2_lantern_rule_p1 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E10-06_s2_lantern_rule_p2 (var e1) (var e2)) Agent (E10-06_sk_count (var x)) E10-06_sk_keepers_1) (sem-edge-tv (var g) (E10-06_s2_lantern_rule_p2 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E10-06_s2_lantern_rule_p3 (var e1) (var e2)) Object (E10-06_sk_count (var x)) (E10-06_sk_lantern_moths (var x))) (sem-edge-tv (var g) (E10-06_s2_lantern_rule_p3 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E10-06_s2_lantern_rule_p4 (var e1) (var e2)) GroupOf (E10-06_sk_lantern_moths (var x)) nightmoth) (sem-edge-tv (var g) (E10-06_s2_lantern_rule_p4 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E10-06_s2_lantern_rule_p5 (var e1) (var e2)) Cardinality (E10-06_sk_lantern_moths (var x)) (ParticleFromNormal 28 2.8)) (sem-edge-tv (var g) (E10-06_s2_lantern_rule_p5 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E10-06_s2_lantern_rule_p6 (var e1) (var e2)) Location (E10-06_sk_count (var x)) (var x)) (sem-edge-tv (var g) (E10-06_s2_lantern_rule_p6 (var e1) (var e2)) (STV 1.0 0.9)) (sem-edge (var g) (E10-06_s2_lantern_rule_p7 (var e1) (var e2)) Past (E10-06_sk_count (var x))) (sem-edge-tv (var g) (E10-06_s2_lantern_rule_p7 (var e1) (var e2)) (STV 1.0 0.9))))

; --- E10-13: On day 631 of Year 2, the keepers of the East Row together collected the silken threads from the lanterns of the East Row at dawn. Hesper boiled the silken threads in sea-water. Mire-essence formed in the cauldrons by evening. Hesper stored the mire-essence in three clay vessels. The keepers of the East Row drew the stored mire-essence at sundown. The keepers of the East Row lit the lanterns of the East Row with the stored mire-essence at sundown. Tessa Brae collected forty of the fallen feathers at the base of the cliff in the morning. Tessa Brae added the feathers to the feather bin. Bevin Coombe took feathers from the feather bin. Bevin Coombe ground the feathers. The Stilllight Lantern was lit. Bevin Coombe scattered the ground feathers around the Stilllight Lantern at sundown. The ground feathers warded the Stilllight Lantern against wraiths. No wraith approached the Stilllight Lantern that night.
(sem-rule E10-13_s14_no_approach)
(rule-context E10-13_s14_no_approach aelmere-events)
(rule-priority E10-13_s14_no_approach 306)
(rule-tv E10-13_s14_no_approach authored 0.0 0.9)
(rule-lhs E10-13_s14_no_approach ((sem-edge (var g) (var e1) Member (var x) wraith)))
(rule-rhs E10-13_s14_no_approach ((sem-edge (var g) (E10-13_s14_no_approach_p1 (var e1)) And (Member (E10-13_sk_approach (var x)) approach) (Agent (E10-13_sk_approach (var x)) (var x)) (Object (E10-13_sk_approach (var x)) stilllight_lantern) (Time (E10-13_sk_approach (var x)) night) (Past (E10-13_sk_approach (var x)))) (sem-edge-tv (var g) (E10-13_s14_no_approach_p1 (var e1)) (STV 0.0 0.9))))
