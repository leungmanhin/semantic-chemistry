# Experiment 1 — Toy Causal-QA Corpus

The **first build target** for Mortal Semantic Chemistry (MSC §7.1): short everyday-causal texts + why/how questions with gold answer-skeletons. This corpus anchors stages **P0 → P2**, ahead of the larger Aelmere fiction corpus (`../fiction-world-v0/`, = Experiment 2).

## Why this corpus is small (~24 vignettes, ~58 sentences)

Deliberate. MSC's §10.2 "1k–10k sentences" guidance is for the fiction-world domain (Aelmere already satisfies it). Exp 1 is the *simplest end-to-end causal-accountability test* (hard prohibition #8: start small + inspectable). The corpus is **dense, not large** — nearly every sentence carries an explanatory edge that some question interrogates.

## What's in a vignette

A 2–4 sentence text + a hand-authored **Neo-Davidsonian** semantic graph (events reified, roles as edges, explanatory edges on top) + one or more questions, each with **class-tagged gold skeletons**. Hand-authored graphs keep it **parser-independent** (the LLM parser, scoping Q2, is still open; when it lands we remap the internal vocabulary — the fact *shapes* are stable).

## Explanatory-edge vocabulary (8 edges, 3 clusters)

| Cluster | Edges | Answer class |
|---------|-------|--------------|
| **physical** | `CauseOf` `Triggers` `Enables` `Contributes` `Prevents` | `physical-cause` |
| **concession** | `Despite` | — (never an answer; trap material) |
| **intentional** | `Motivates` `Reason` | `intentional` |

The clusters double as the answer-classes a **clamp** selects (see below).

## Question types (pass 1)

`antecedent-why`, `how-mechanism` (multi-hop chains), `goal-why`, `belief-why`, `why-not`, `concession-why`. Surface form lives in `q-word` (`why`/`what-made`/`how`/`how-come`/`why-not`/`what-for`/`trying-to-do`) — the corpus does **not** pre-supply a question *type*; classifying it is the organism's *question-type-detector* + *paraphrase-collapse* work.

## The clamp-switch experiment (Package B)

Texts carry **both** an antecedent and (for agent actions) a goal, so an ambiguous `"why?"` has two gold skeletons — one `⟨physical-cause⟩`, one `⟨intentional⟩`. A **clamp** (the evaluator's reward, MSC §4.4 / eq 17) selects which class earns fuel:

- under `clamp-antecedent` → the antecedent-extraction strategy earns surplus and survives; the goal strategy starves;
- under `clamp-goal` → the reverse.

Same corpus + chamber, **swap the clamp → a different surviving strategy-ACS**. That is the purest demonstration of the core thesis (reward selects strategy), reachable at P1/P2 with no reproduction (P3) needed. Single-class questions score under their matching clamp and are **abstain-gold under the other**; concessive `Despite` and the negative vignettes are traps that the unsupported-bridge / redundancy taxes police.

> **Clamp representation caveat:** MSC specifies clamps *functionally* (eq 17 + typed-token output + chamber-locality) but gives **no IR data shape**. Our `(clamp …)` facts (`../../ir/schema.md` §2.8) are an interim design choice, to reconcile with the referenced-but-missing doc [3] ("Portable worker IR…") if obtained.

## Files

This directory is **data only** — pure portable facts (no `!(add-atom …)` wrapper; loaded by `import!` on the PeTTa side, by `parse_facts` on the Python side). The *logic* (engine + causal-QA rule proposers + evaluator) lives in `../../petta/` (`kernel_defs.metta`, `causal_qa_rules.metta`, `evaluator_defs.metta`).

| File | What |
|------|------|
| `corpus.txt` | the 24 raw vignette texts + question surface-forms — the **input tier** (parse target) |
| `molecules.metta` | pure-fact IR: the 5 encoded semantic graphs (the parsed-text molecules) |
| `tasks.metta` | pure-fact IR: the **QA benchmark** — questions + gold answer-skeletons (the 5) |
| `configs.metta` | pure-fact IR: causal-QA **domain mappings** (edge-cluster, intent-map, …) + the Exp-1 **run config** (clamps, chamber, worker, seed) |
| `genome.metta` | pure-fact IR: the organism `O_qa` — ruleset membership, per-rule token-costs, seed fuel |
| `load.metta` | the **data loader** — imports molecules + tasks + configs into `&self` (PeTTa side) |
| `README.md` | this file (+ the hand-authored-graph **Appendix** below) |

The IR encodes a representative slice — V7 (dual), V3 (mechanism), V17 (why-not), V20 (abstain), V23 (multi-cause) — enough to exercise every fact shape (`../../ir/schema.md` §2.7–2.8). The remaining **19 vignettes' hand-authored graphs are preserved in the Appendix** below; they get transcribed into `molecules.metta` / `tasks.metta` as the chamber scales to the full corpus.

## Chamber

The Exp-1 chamber is **K-like** on the life-history simplex (MSC §4.6: "stable question answering, where each surviving organism must be trustworthy") — a deliberate contrast with Aelmere's r-like fiction chamber.

## What's where (logic vs data)

- **The organism's genome metadata** — `genome.metta` here (ruleset membership, per-rule token-costs, seed fuel). It declares the rules but flags them `kernel-resident`: the **rule logic** itself (the proposers `question-type-detector` / `causal-alignment` / `role-completion` / `paraphrase-collapse` / `answer-skeleton-projection`; the `compact-explanation-packer` is still TODO) lives in `../../petta/causal_qa_rules.metta`, not here. (Lifting that logic into portable `rule-lhs`/`rule-rhs` data is design-decision D3, deferred.)
- **The engine + evaluator code** — `../../petta/kernel_defs.metta` (P0 engine) + `../../petta/evaluator_defs.metta` (P1 eq-17 scoring). This dir is the *data* they operate on.

## Notation legend (for the Appendix graphs)

- **nodes:** `id=Type[role:filler, …]`. A trailing `·intended` / `·prevented` marks `node-modal` (a goal/purpose state, or a blocked non-event).
- **edges:** `Rel(src→dst)` from the 8-edge vocabulary (clusters in the table above).
- **questions:** `Q <q-word> "surface text"` → one or more gold answers.
- **answer:** `⟨phys⟩` / `⟨int⟩` = `skeleton-class`; `cite Rel(a→b)` = `skeleton-cites`; `prov n` = `skeleton-provenance`; `+` joins multiple required cites (multi-cause / mechanism chains); `ABSTAIN` = `skeleton-abstain`.
- Two skeletons (one per class) = *ambiguous-dual* (the clamp-switch material). A single-class question scores under its matching clamp and is **abstain-gold** under the other. `Despite` is never an answer class (trap material).

## Coverage (all 24)

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

24 vignettes · ~58 sentences · 5 negatives (21%). All 8 edges + both `node-modal` values exercised. **5 are encoded as IR** (V3, V7, V17, V20, V23 → `molecules.metta` / `tasks.metta`); the other **19 are below**.

## Appendix — hand-authored graphs (19 vignettes pending IR encoding)

The Neo-Davidsonian graphs + gold skeletons for the vignettes **not yet** in `molecules.metta` / `tasks.metta` (the 5 encoded ones are authoritative there). Transcribe these into the IR as the corpus scales to the full Experiment 1. Raw texts for all 24 are in `corpus.txt`; notation per the legend above.

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

**V6 · drought-restrictions**
"A long drought dried the hills. The reservoir fell to a record low, so the town brought in water restrictions."
nodes: e1=Drought, e2=ReservoirLow, e3=WaterRestrictions
edges: CauseOf(e1→e2), CauseOf(e2→e3)
Q how "How did the town end up with water restrictions?" → ⟨phys⟩ cite CauseOf(e1→e2)+CauseOf(e2→e3) prov e1+e3

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

**V18 · covered-plants**
"A hard frost was forecast, but the gardener covered the seedlings overnight, and they did not freeze."
nodes: e1=FrostForecast, e2=Freeze[theme:seedlings]·prevented, e3=Cover[agent:gardener,theme:seedlings]
edges: Prevents(e3→e2)
Q why-not "Why didn't the seedlings freeze?" → ⟨phys⟩ cite Prevents(e3→e2) prov e3

**V19 · rain-match**
"Despite the heavy rain, the match went ahead, because the pitch drained well."
nodes: e1=Rain, e2=MatchContinued, e3=GoodDrainage[theme:pitch]
edges: Despite(e1→e2), Enables(e3→e2)
Q why "Why did the match go ahead despite the rain?" → ⟨phys⟩ cite Enables(e3→e2) prov e3
  (a candidate citing Despite(e1→e2) — "because of the rain" — is wrong: concessive, not causal.)

**V21 · black-cat**
"A black cat crossed the road in the morning. That afternoon, Dan's car broke down."
nodes: e1=CatCrossed, e2=Breakdown[theme:car,poss:dan]
edges: *(none — temporal co-occurrence only)*
Q why "Why did Dan's car break down?" → ABSTAIN

**V22 · clock-dog**
"The clock struck noon. The dog began to bark."
nodes: e1=ClockNoon, e2=Bark[agent:dog]
edges: *(none — co-occurrence only)*
Q why "Why did the dog start barking?" → ABSTAIN

**V24 · river-flood**
"The river flooded the valley. Heavy rain had fallen for days, and the dam's gates had been left open."
nodes: e1=Flood[theme:valley], c1=HeavyRain, c2=GatesOpen[theme:dam]
edges: Contributes(c1→e1), Contributes(c2→e1)
Q why "Why did the river flood the valley?" → ⟨phys⟩ cite Contributes(c1→e1)+Contributes(c2→e1) prov c1+c2
