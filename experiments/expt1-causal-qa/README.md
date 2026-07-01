# Experiment 1 — Toy Causal-QA Corpus

The **first build target** for Mortal Semantic Chemistry (MSC §7.1): short everyday-causal texts + why/how questions, scored by an evaluator that derives the target answer from the graph. This corpus anchors stages **P0 → P2**, ahead of the larger fiction corpus (Experiment 2).

## Why this corpus is small (~24 vignettes, ~58 sentences)

Deliberate. MSC's §10.2 "1k–10k sentences" guidance is for the fiction-world domain (Aelmere already satisfies it). Exp 1 is the *simplest end-to-end causal-accountability test* (hard prohibition #8: start small + inspectable). The corpus is **dense, not large** — nearly every sentence carries an explanatory edge that some question interrogates.

## What's in a vignette

A 2–4 sentence text + a **Neo-Davidsonian** semantic graph (events reified, roles as edges, explanatory edges on top) + one or more questions. The 5 encoded graphs are produced by the semantic parser over `corpus.json` and adapted to IR (`../../ir/parser_adapter.md`); the 19 pending are hand-authored designs (Appendix). The evaluator derives the ideal answer (`Y*_q`) from the graph, so **no gold answer content is stored**.

## Surface-marked text

The vignette texts in `corpus.json` make their causation **explicit** with discourse connectives (`so` / `because` / purpose `to …` / `stopped/kept … from` / `despite`), so the semantic parser can extract the causal edges directly rather than infer them. The three co-occurrence negatives (V20–V22) are deliberately left **cue-free** (→ correct abstention), and V19 keeps its concessive `despite` (a trap, never an answer). Natural connectives carry **class-level** fidelity: a finer edge (`Trigger`, `Enable`) may surface as `CauseOf` / `Motivate`, but the answer *class* (physical / intentional / concession) — what the clamp-switch selects on — is preserved.

## Explanatory-edge vocabulary (8 edges, 3 clusters)

| Cluster | Edges | Answer class |
|---------|-------|--------------|
| **physical** | `CauseOf` `Trigger` `Enable` `Contribute` `Prevent` | `physical-cause` |
| **concession** | `Despite` | — (never an answer; trap material) |
| **intentional** | `Motivate` `Reason` | `intentional` |

The clusters double as the answer-classes a **clamp** selects (see below).

## Question types (pass 1)

`antecedent-why`, `how-mechanism` (multi-hop chains), `goal-why`, `belief-why`, `why-not`, `concession-why`. Surface form lives in `q-word` (`why`/`what-made`/`how`/`how-come`/`why-not`/`what-for`/`trying-to-do`) — the corpus does **not** pre-supply a question *type*; classifying it is the organism's *question-type-detector* + *paraphrase-collapse* work.

## The clamp-switch experiment (Package B)

Texts carry **both** an antecedent and (for agent actions) a goal, so an ambiguous `"why?"` focus carries two explanatory edges — a physical `CauseOf` and an intentional `Motivate`. A **clamp** (the evaluator's reward, MSC §4.4 / eq 17) selects which class earns fuel:

- under `clamp-antecedent` → the antecedent-extraction strategy earns surplus and survives; the goal strategy starves;
- under `clamp-goal` → the reverse.

Same corpus + chamber, **swap the clamp → a different surviving strategy-ACS**. That is the purest demonstration of the core thesis (reward selects strategy), reachable at P1/P2 with no reproduction (P3) needed. A single-class question (only one allowed-class edge into its focus) earns only under its matching clamp and correctly **abstains** under the other (its graph-ideal is empty there); concessive `Despite` (off-class) and the co-occurrence-only negative vignettes are traps that earn nothing — the unsupported-bridge / redundancy taxes police fabricated or off-target cites.

> **Clamp representation caveat:** MSC specifies clamps *functionally* (eq 17 + typed-token output + chamber-locality) but gives **no IR data shape**. Our `(clamp …)` facts (`../../ir/schema.md` §2.8) are an interim design choice.

## Files

This directory is **data only** — pure portable facts loaded by `import!`. The *logic* (the generic engine + the converter + the run + the evaluator) lives in `../../petta/` (`kernel.metta`, `evaluator.metta`); the rules themselves are canonical per-match IR data **here** (`rules.metta`).

| File | What |
|------|------|
| `corpus.json` | the 24 vignette texts + questions as structured JSON (`id` / `statements` / `questions` / `additional_info`) — the **input tier** (surface-marked parse target, parser-loadable) |
| `molecules.metta` | pure-fact IR: the 5 parser-derived semantic graphs (parsed from `corpus.json`, adapted per `../../ir/parser_adapter.md`) |
| `tasks.metta` | pure-fact IR: the **QA benchmark** — questions only (the 5); no gold answer content, the evaluator derives the target from the graph |
| `configs.metta` | pure-fact IR: causal-QA **domain mappings** (edge-cluster, intent-map, …) + the Exp-1 **run config** (clamps, chamber, worker, seed) |
| `rules.metta` | pure-fact IR: **the genome** — the four causal-QA rules as canonical per-match `rule-lhs`/`rule-rhs` IR with `(var Name)` markers |
| `load.metta` | the **data loader** — imports molecules + tasks + configs + rules into `&self` (PeTTa side) |
| `README.md` | this file (+ the hand-authored-graph **Appendix** below) |

The IR encodes a representative slice — V7 (dual), V3 (mechanism), V17 (why-not), V20 (abstain), V23 (multi-cause) — enough to exercise every fact shape (`../../ir/schema.md` §2.7–2.8). The remaining **19 vignettes' hand-authored graphs are preserved in the Appendix** below; they get transcribed into `molecules.metta` / `tasks.metta` as the chamber scales to the full corpus.

## Chamber

The Exp-1 chamber is **K-like** on the life-history simplex (MSC §4.6: "stable question answering, where each surviving organism must be trustworthy") — a deliberate contrast with Aelmere's r-like fiction chamber.

## What's where (logic vs data)

- **The genome** — `rules.metta` here: the four causal-QA rules (`R_qtype` question-type-detector + paraphrase-collapse, `R_align` causal-alignment, `R_complete` role-completion, `R_project` answer-projection) as **canonical per-match `rule-lhs`/`rule-rhs` IR** with `(var Name)` markers (the lifting is complete; the `compact-explanation-packer` is still TODO; **abstain is the evaluator's job**, not a rule). Tokens use `gm`/`ci` (the PeTTa short symbols for `tau_graph_match`/`tau_causal`; see `../../ir/schema.md` §1).
- **The engine + evaluator code** — `../../petta/kernel.metta` (P0 engine) + `../../petta/evaluator.metta` (eq-17 scoring, target derived from the graph). This dir is the *data* they operate on.

## Notation legend (for the Appendix graphs)

- **nodes:** `id=Type[role:filler, …]`. A trailing `·intended` / `·prevented` marks `node-modal` (a goal/purpose state, or a blocked non-event).
- **edges:** `Rel(src→dst)` from the 8-edge vocabulary (clusters in the table above).
- **questions:** `Q <q-word> "surface text"` → its intended answer(s).
- **intended answer** (what the graph-derived evaluator should score highest): `⟨phys⟩` / `⟨int⟩` = answer class; `cite Rel(a→b)` = the explanatory edge a correct answer cites; `prov n` = provenance node; `+` joins multiple required cites (multi-cause / mechanism chains); `ABSTAIN` = correct abstention (the focus has no groundable explanatory edge — an empty ideal).
- Two answers (one per class) = *ambiguous-dual* (the clamp-switch material): the focus carries both a physical and an intentional edge. A single-class question earns only under its matching clamp and abstains under the other. `Despite` is never an answer class (trap material).

## Coverage (all 24)

| Aspect | Vignettes |
|--------|-----------|
| antecedent-why `⟨phys⟩` | V1,V2,V3,V5,V7–V13 |
| how-mechanism (multi-hop) | V3, V6 |
| proximate `Trigger` | V4 |
| goal-why `⟨int⟩` (Motivate) | V7–V13, V15 |
| belief `Reason` | V14, V16 |
| ambiguous-dual (clamp-switch core) | V7–V13 |
| why-not `Prevent` (`·prevented`) | V17, V18 |
| concession `Despite` (trap) | V19 |
| unsupported-bridge → abstain | V20, V21, V22 |
| multi-cause `Contribute` (redundancy) | V23, V24 |

24 vignettes · ~58 sentences · 5 negatives (21%). All 8 edges + both `node-modal` values exercised. **5 are encoded as IR** (V3, V7, V17, V20, V23 → `molecules.metta` / `tasks.metta`); the other **19 are below**.

## Appendix — hand-authored graphs (19 vignettes pending IR encoding)

The Neo-Davidsonian graphs + intended answers for the vignettes **not yet** in `molecules.metta` / `tasks.metta` (the 5 encoded ones are authoritative there). Transcribe these into the IR as the corpus scales to the full Experiment 1. Raw texts for all 24 are in `corpus.json`; notation per the legend above.

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
edges: Trigger(e1→e2)
Q what-made "What made the glass shatter?" → ⟨phys⟩ cite Trigger(e1→e2) prov e1

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
edges: CauseOf(e1→e2), Motivate(g1→e2), Enable(e2→e3)
Q why "Why did Tom walk to a café?" → ⟨phys⟩ cite CauseOf(e1→e2) prov e1 · ⟨int⟩ cite Motivate(g1→e2) prov g1

**V9 · cold-room**
"Lena was cold. She got up and closed the window to warm the room."
nodes: e1=Cold[exp:lena], e2=Close[agent:lena,theme:window], g1=WarmRoom·intended
edges: CauseOf(e1→e2), Motivate(g1→e2)
Q why "Why did Lena close the window?" → ⟨phys⟩ cite CauseOf(e1→e2) prov e1 · ⟨int⟩ cite Motivate(g1→e2) prov g1

**V10 · hungry**
"Sam was hungry after the run. He made a sandwich to eat before work."
nodes: e1=Hungry[exp:sam], e2=Make[agent:sam,theme:sandwich], g1=Eat·intended
edges: CauseOf(e1→e2), Motivate(g1→e2)
Q why "Why did Sam make a sandwich?" → ⟨phys⟩ cite CauseOf(e1→e2) prov e1 · ⟨int⟩ cite Motivate(g1→e2) prov g1

**V11 · wilting-plants**
"Priya's basil was wilting on the sill. She watered it to bring it back."
nodes: e1=Wilting[theme:basil], e2=Water[agent:priya,theme:basil], g1=Revive·intended
edges: CauseOf(e1→e2), Motivate(g1→e2)
Q why "Why did Priya water the basil?" → ⟨phys⟩ cite CauseOf(e1→e2) prov e1 · ⟨int⟩ cite Motivate(g1→e2) prov g1

**V12 · missed-bus**
"Raj missed the morning bus. He called a taxi to get to work on time."
nodes: e1=MissedBus[exp:raj], e2=CallTaxi[agent:raj], g1=ReachWork·intended
edges: CauseOf(e1→e2), Motivate(g1→e2)
Q why "Why did Raj call a taxi?" → ⟨phys⟩ cite CauseOf(e1→e2) prov e1 · ⟨int⟩ cite Motivate(g1→e2) prov g1
Q what-for "What did Raj call a taxi for?" → ⟨int⟩ cite Motivate(g1→e2) prov g1

**V13 · cracked-screen**
"Nadia's laptop screen was cracked. She took it to the repair shop to have it fixed."
nodes: e1=Cracked[theme:screen,poss:nadia], e2=TakeTo[agent:nadia,theme:laptop,dest:shop], g1=Fixed·intended
edges: CauseOf(e1→e2), Motivate(g1→e2)
Q why "Why did Nadia take her laptop to the repair shop?" → ⟨phys⟩ cite CauseOf(e1→e2) prov e1 · ⟨int⟩ cite Motivate(g1→e2) prov g1

**V14 · umbrella-belief**
"Omar thought it would rain later, so he took an umbrella when he left."
nodes: b1=BelieveRain[exp:omar], e1=Take[agent:omar,theme:umbrella]
edges: Reason(b1→e1)
Q why "Why did Omar take an umbrella?" → ⟨int⟩ cite Reason(b1→e1) prov b1

**V15 · surprise-cake**
"Ella wanted to surprise her sister. She baked a cake before the party."
nodes: g1=SurpriseSister·intended, e1=Bake[agent:ella,theme:cake]
edges: Motivate(g1→e1)
Q why "Why did Ella bake a cake?" → ⟨int⟩ cite Motivate(g1→e1) prov g1

**V16 · long-path-belief**
"The hikers believed the rope bridge was unsafe, so they took the long path around."
nodes: b1=BelieveUnsafe[exp:hikers], e1=Take[agent:hikers,theme:longpath]
edges: Reason(b1→e1)
Q why "Why did the hikers take the long path?" → ⟨int⟩ cite Reason(b1→e1) prov b1

**V18 · covered-plants**
"A hard frost was forecast, but the gardener covered the seedlings overnight, and they did not freeze."
nodes: e1=FrostForecast, e2=Freeze[theme:seedlings]·prevented, e3=Cover[agent:gardener,theme:seedlings]
edges: Prevent(e3→e2)
Q why-not "Why didn't the seedlings freeze?" → ⟨phys⟩ cite Prevent(e3→e2) prov e3

**V19 · rain-match**
"Despite the heavy rain, the match went ahead, because the pitch drained well."
nodes: e1=Rain, e2=MatchContinued, e3=GoodDrainage[theme:pitch]
edges: Despite(e1→e2), Enable(e3→e2)
Q why "Why did the match go ahead despite the rain?" → ⟨phys⟩ cite Enable(e3→e2) prov e3
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
edges: Contribute(c1→e1), Contribute(c2→e1)
Q why "Why did the river flood the valley?" → ⟨phys⟩ cite Contribute(c1→e1)+Contribute(c2→e1) prov c1+c2
