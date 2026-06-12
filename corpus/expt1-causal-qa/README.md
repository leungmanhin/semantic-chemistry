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

| File | What |
|------|------|
| `vignettes.md` | the 24 vignettes — text + graph + questions + gold skeletons (authoritative content) |
| `expt1_data.metta` | a loadable fixture: 5 representative vignettes encoded as portable facts + the edge-cluster vocab + both clamps + the chamber/worker. Verified loading in PeTTa. |
| `README.md` | this file |

The fixture encodes a representative slice (V7 dual, V3 mechanism, V17 why-not, V20 abstain, V23 multi-cause) — enough to exercise every new fact shape (`../../ir/schema.md` §2.7–2.8). The remaining vignettes live in `vignettes.md`; they get encoded (by hand or a small generator) as the chamber scales.

## Chamber

The Exp-1 chamber is **K-like** on the life-history simplex (MSC §4.6: "stable question answering, where each surviving organism must be trustworthy") — a deliberate contrast with Aelmere's r-like fiction chamber.

## Not in this corpus (next steps)

- **The organism's QA-strategy genome** — the rules (`question-type-detector`, `causal-alignment`, `role-completion`, `paraphrase-collapse`, `answer-skeleton-projection`, `compact-explanation-packer`) are authored **with the P0 kernel**, not here. This corpus is the *data* they operate on.
- **The evaluator + clamp scoring code** — P1.
