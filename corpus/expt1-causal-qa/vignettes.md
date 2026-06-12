# Experiment-1 Vignettes — Toy Causal QA

24 short everyday-causal vignettes. Each has a 2–4 sentence text, a hand-authored Neo-Davidsonian graph, and one or more questions with **class-tagged gold skeletons**. Mundane, no world-building, parser-independent (graphs hand-authored). See `README.md` for the design and `../../ir/schema.md` §2.7–2.8 for the fact shapes.

## Notation (legend)

- **nodes:** `id=Type[role:filler, …]`. A trailing `·intended` / `·prevented` marks `node-modal` (a goal/purpose state, or a non-occurring blocked event).
- **edges:** `Rel(src→dst)` — relation from the 8-edge vocabulary (clusters: **physical** = CauseOf/Triggers/Enables/Contributes/Prevents; **concession** = Despite; **intentional** = Motivates/Reason).
- **questions:** `Q <q-word> "surface text"` → one or more gold answers.
- **answer:** `⟨phys⟩` / `⟨int⟩` = `skeleton-class`; `cite Rel(a→b)` = `skeleton-cites`; `prov n` = `skeleton-provenance`; `+` joins multiple required cites (multi-cause / mechanism chains). `ABSTAIN` = `skeleton-abstain`.
- A question with **two** skeletons (one per class) is *ambiguous-dual* — the clamp-switch material. A **single-class** question scores under its matching clamp; under the other clamp the evaluator derives **abstain** (no skeleton of the active class). Concession (`Despite`) is **never** an answer class — it is trap material.

---

## Group A — non-agentive physical causation (antecedent-why, how-mechanism)

Single-class `⟨phys⟩`. No goal is possible (no agent intention), so under `clamp-goal` the gold is abstain.

**V1 · rain-flood**
"Heavy rain fell all night. By morning the low road was flooded."
nodes: e1=Rain, e2=Flood[theme:road]
edges: CauseOf(e1→e2)
Q why "Why was the low road flooded?" → ⟨phys⟩ cite CauseOf(e1→e2) prov e1

**V2 · early-frost**
"An early frost settled over the garden. The tomato plants blackened and died."
nodes: e1=Frost, e2=Die[theme:plants]
edges: CauseOf(e1→e2)
Q why "Why did the tomato plants die?" → ⟨phys⟩ cite CauseOf(e1→e2) prov e1

**V3 · power-spoil** (mechanism)
"The power went out during the storm. The fridge stopped running, and by morning the food had spoiled."
nodes: e1=PowerOut, e2=FridgeStopped, e3=FoodSpoiled
edges: CauseOf(e1→e2), CauseOf(e2→e3)
Q how "How did the food end up spoiled?" → ⟨phys⟩ cite CauseOf(e1→e2)+CauseOf(e2→e3) prov e1+e3
Q why "Why did the food spoil?" → ⟨phys⟩ cite CauseOf(e2→e3) prov e2

**V4 · dropped-glass**
"The waiter knocked the glass off the edge. It hit the tiles and shattered."
nodes: e1=Knock[agent:waiter,theme:glass], e2=Shatter[theme:glass]
edges: Triggers(e1→e2)
Q what-made "What made the glass shatter?" → ⟨phys⟩ cite Triggers(e1→e2) prov e1

**V5 · snow-roof**
"Snow piled up for days on the old barn. The roof finally collapsed under the weight."
nodes: e1=SnowLoad[theme:roof], e2=Collapse[theme:roof]
edges: CauseOf(e1→e2)
Q why "Why did the barn roof collapse?" → ⟨phys⟩ cite CauseOf(e1→e2) prov e1

**V6 · drought-restrictions** (mechanism)
"A long drought dried the hills. The reservoir fell to a record low, so the town brought in water restrictions."
nodes: e1=Drought, e2=ReservoirLow, e3=WaterRestrictions
edges: CauseOf(e1→e2), CauseOf(e2→e3)
Q how "How did the town end up with water restrictions?" → ⟨phys⟩ cite CauseOf(e1→e2)+CauseOf(e2→e3) prov e1+e3

---

## Group B — agentive, ambiguous-dual (physical antecedent **and** stated goal)

The clamp-switch core. Text states both the antecedent and the goal, so both skeletons have provenance.

**V7 · out-of-milk**
"Maria was out of milk. She drove to the store to buy a carton."
nodes: e1=OutOfMilk[exp:maria], e2=Drive[agent:maria,dest:store], e3=Buy[agent:maria,theme:carton]·intended, g1=HaveMilk·intended
edges: CauseOf(e1→e2), Motivates(g1→e2), Enables(e2→e3)
Q why "Why did Maria drive to the store?" → ⟨phys⟩ cite CauseOf(e1→e2) prov e1 · ⟨int⟩ cite Motivates(g1→e2) prov g1
Q what-for "What did Maria drive to the store for?" → ⟨int⟩ cite Motivates(g1→e2) prov g1

**V8 · dead-battery**
"Tom's phone battery was dead. He walked to a café to charge it."
nodes: e1=DeadBattery[poss:tom], e2=WalkTo[agent:tom,dest:cafe], e3=Charge[agent:tom,theme:phone]·intended, g1=PhoneCharged·intended
edges: CauseOf(e1→e2), Motivates(g1→e2), Enables(e2→e3)
Q why "Why did Tom walk to a café?" → ⟨phys⟩ cite CauseOf(e1→e2) prov e1 · ⟨int⟩ cite Motivates(g1→e2) prov g1

**V9 · cold-room**
"Lena was cold. She got up and closed the window to warm the room."
nodes: e1=Cold[exp:lena], e2=Close[agent:lena,theme:window], g1=WarmRoom·intended
edges: CauseOf(e1→e2), Motivates(g1→e2)
Q why "Why did Lena close the window?" → ⟨phys⟩ cite CauseOf(e1→e2) prov e1 · ⟨int⟩ cite Motivates(g1→e2) prov g1

**V10 · hungry**
"Sam was hungry after the run. He made a sandwich to eat before work."
nodes: e1=Hungry[exp:sam], e2=Make[agent:sam,theme:sandwich], g1=Eat·intended
edges: CauseOf(e1→e2), Motivates(g1→e2)
Q why "Why did Sam make a sandwich?" → ⟨phys⟩ cite CauseOf(e1→e2) prov e1 · ⟨int⟩ cite Motivates(g1→e2) prov g1

**V11 · wilting-plants**
"Priya's basil was wilting on the sill. She watered it to bring it back."
nodes: e1=Wilting[theme:basil], e2=Water[agent:priya,theme:basil], g1=Revive·intended
edges: CauseOf(e1→e2), Motivates(g1→e2)
Q why "Why did Priya water the basil?" → ⟨phys⟩ cite CauseOf(e1→e2) prov e1 · ⟨int⟩ cite Motivates(g1→e2) prov g1

**V12 · missed-bus**
"Raj missed the morning bus. He called a taxi to get to work on time."
nodes: e1=MissedBus[exp:raj], e2=CallTaxi[agent:raj], g1=ReachWork·intended
edges: CauseOf(e1→e2), Motivates(g1→e2)
Q why "Why did Raj call a taxi?" → ⟨phys⟩ cite CauseOf(e1→e2) prov e1 · ⟨int⟩ cite Motivates(g1→e2) prov g1
Q what-for "What did Raj call a taxi for?" → ⟨int⟩ cite Motivates(g1→e2) prov g1

**V13 · cracked-screen**
"Nadia's laptop screen was cracked. She took it to the repair shop to have it fixed."
nodes: e1=Cracked[theme:screen,poss:nadia], e2=TakeTo[agent:nadia,theme:laptop,dest:shop], g1=Fixed·intended
edges: CauseOf(e1→e2), Motivates(g1→e2)
Q why "Why did Nadia take her laptop to the repair shop?" → ⟨phys⟩ cite CauseOf(e1→e2) prov e1 · ⟨int⟩ cite Motivates(g1→e2) prov g1

---

## Group C — intentional / belief (single-class `⟨int⟩`)

Goal-primary or belief-mediated. No stated physical antecedent, so under `clamp-antecedent` the gold is abstain.

**V14 · umbrella-belief**
"Omar thought it would rain later, so he took an umbrella when he left."
nodes: b1=BelieveRain[exp:omar], e1=Take[agent:omar,theme:umbrella]
edges: Reason(b1→e1)
Q why "Why did Omar take an umbrella?" → ⟨int⟩ cite Reason(b1→e1) prov b1

**V15 · surprise-cake**
"Ella wanted to surprise her sister. She baked a cake before the party."
nodes: g1=SurpriseSister·intended, e1=Bake[agent:ella,theme:cake]
edges: Motivates(g1→e1)
Q why "Why did Ella bake a cake?" → ⟨int⟩ cite Motivates(g1→e1) prov g1

**V16 · long-path-belief**
"The hikers believed the rope bridge was unsafe, so they took the long path around."
nodes: b1=BelieveUnsafe[exp:hikers], e1=Take[agent:hikers,theme:longpath]
edges: Reason(b1→e1)
Q why "Why did the hikers take the long path?" → ⟨int⟩ cite Reason(b1→e1) prov b1

---

## Group D — why-not (Prevents)

The queried event did **not** occur (`·prevented`); the answer cites the preventer.

**V17 · sprinklers**
"A fire started in the kitchen, but the sprinklers switched on, and it never spread to the rest of the house."
nodes: e1=FireStart[loc:kitchen], e2=Spread[theme:fire]·prevented, e3=SprinklersOn
edges: Prevents(e3→e2)
Q why-not "Why didn't the fire spread to the rest of the house?" → ⟨phys⟩ cite Prevents(e3→e2) prov e3

**V18 · covered-plants**
"A hard frost was forecast, but the gardener covered the seedlings overnight, and they did not freeze."
nodes: e1=FrostForecast, e2=Freeze[theme:seedlings]·prevented, e3=Cover[agent:gardener,theme:seedlings]
edges: Prevents(e3→e2)
Q why-not "Why didn't the seedlings freeze?" → ⟨phys⟩ cite Prevents(e3→e2) prov e3

---

## Group E — concession (Despite)

`Despite` is a **trap** edge (never an answer class). The real cause is a separate physical edge.

**V19 · rain-match**
"Despite the heavy rain, the match went ahead, because the pitch drained well."
nodes: e1=Rain, e2=MatchContinued, e3=GoodDrainage[theme:pitch]
edges: Despite(e1→e2), Enables(e3→e2)
Q why "Why did the match go ahead despite the rain?" → ⟨phys⟩ cite Enables(e3→e2) prov e3
  (a candidate citing Despite(e1→e2) — "because of the rain" — is wrong: concessive, not causal.)

---

## Group F — negatives (~20%)

**V20 · streetlights** (unsupported bridge → abstain)
"The streetlights came on at dusk. Maria drove to the store."
nodes: e1=StreetlightsOn[time:dusk], e2=Drive[agent:maria,dest:store]
edges: *(none between e1 and e2 — co-occurrence only)*
Q why "Why did Maria drive to the store?" → ABSTAIN (no stated cause; asserting CauseOf(e1→e2) is an unsupported bridge → taxed)

**V21 · black-cat** (superstition bridge → abstain)
"A black cat crossed the road in the morning. That afternoon, Dan's car broke down."
nodes: e1=CatCrossed, e2=Breakdown[theme:car,poss:dan]
edges: *(none — temporal co-occurrence only)*
Q why "Why did Dan's car break down?" → ABSTAIN

**V22 · clock-dog** (unsupported bridge → abstain)
"The clock struck noon. The dog began to bark."
nodes: e1=ClockNoon, e2=Bark[agent:dog]
edges: *(none — co-occurrence only)*
Q why "Why did the dog start barking?" → ABSTAIN

**V23 · dense-cake** (multi-cause redundancy trap)
"The cake came out dense. The baker had used too little baking powder, and had overmixed the batter."
nodes: e1=Dense[theme:cake], c1=TooLittlePowder, c2=Overmixed
edges: Contributes(c1→e1), Contributes(c2→e1)
Q why "Why was the cake dense?" → ⟨phys⟩ cite Contributes(c1→e1)+Contributes(c2→e1) prov c1+c2
  (must cite **both** contributors; inventing a third cause or inflating one path's confidence is taxed.)

**V24 · river-flood** (multi-cause redundancy trap)
"The river flooded the valley. Heavy rain had fallen for days, and the dam's gates had been left open."
nodes: e1=Flood[theme:valley], c1=HeavyRain, c2=GatesOpen[theme:dam]
edges: Contributes(c1→e1), Contributes(c2→e1)
Q why "Why did the river flood the valley?" → ⟨phys⟩ cite Contributes(c1→e1)+Contributes(c2→e1) prov c1+c2

---

## Coverage summary

| Aspect | Vignettes |
|--------|-----------|
| antecedent-why `⟨phys⟩` | V1,V2,V3,V5,V7–V13 |
| how-mechanism (multi-hop) | V3, V6 |
| proximate `Triggers` | V4 |
| goal-why `⟨int⟩` (Motivates) | V7–V13, V15 |
| belief `Reason` | V14, V16 |
| ambiguous-dual (clamp-switch core) | V7–V13 |
| why-not `Prevents` (`·prevented`) | V17, V18 |
| concession `Despite` (trap) | V19 |
| unsupported-bridge → abstain | V20, V21, V22 |
| multi-cause `Contributes` (redundancy) | V23, V24 |

24 vignettes · ~58 sentences · 5 negatives (21%). All 8 edges + both `node-modal` values exercised.
