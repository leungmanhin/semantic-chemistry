# Experiment 1 — Toy Causal-QA Corpus

The **first build target** for Mortal Semantic Chemistry (MSC §7.1): a short everyday-causal text + why-questions, answered by grounding a variable-bearing skeleton against a graph the genome derives. This corpus anchors stages **P0 → P2**, ahead of the larger fiction corpus (Experiment 2).

## Why the corpus is four vignettes

Deliberate. MSC's §10.2 "1k–10k sentences" guidance is for the fiction-world domain (Aelmere already satisfies it). Exp 1 is the *simplest end-to-end causal-accountability test* (hard prohibition #8: start small + inspectable), so it carries four short vignettes — **V3, V4, V5, V6** — each a two-hop causal chain over the same cue vocabulary. One would be enough to exercise cue normalization, chaining, achievement-typed minting and the task loop; the others are what make **recurrence** observable, since a strategy recurs by turning again on newly ARRIVED material rather than on a question re-asked, and what let a derived strategy be shown working on a text no ancestor of it ever saw.

## What's in a vignette

A text + a **Neo-Davidsonian** semantic graph (events reified, roles as edges) + one or more questions. The graph is produced by the semantic parser over `corpus.json` and reshaped to §10.1 sem-graph IR by `../../ir/to_semgraph.py`. The evaluator derives the answer by grounding, so **no gold answer content is stored**.

V3 is *"The power went out during the storm, so the fridge stopped running, and as a result the food had spoiled by morning."* — two discourse cues (`So`, `AsAResult`) over three events, which the genome normalizes into a `ReasonFor` chain.

## Surface-marked text

The vignette text makes its causation **explicit** with discourse connectives (`so` / `as a result`), so the parser extracts the *cue* directly rather than inferring a causal relation. That split is load-bearing: the parser emits **surface** cues only, and the **derivation genome** (`rules.metta`) is the interpretive theory that turns them into the normalized `ReasonFor` layer the questions query. What the parser asserts and what the system concludes stay separable — which is what makes the genome selectable, ablatable, and chargeable for fuel.

## Questions

The parser maps each question to a variable-bearing **answer-skeleton** whose sought relation is the normal form `ReasonFor`. A question licenses ONE `ReasonFor` (hop-count is graph knowledge the asker doesn't have); the surface text is kept in `question-surface`. **Answer plurality and depth come from the genome, never from the query shape** — V3's *"Why did the food spoil?"* grounds two ways (the proximate cause and, via `R_trans`, the root cause), with the mechanism chain recoverable from the root answer's `(trans …)` provenance id.

## The clamp-switch

A **clamp** is the evaluator's reward regime (MSC §4.4): it maps a grounding's *achievements* to the typed fuel they mint (`(clamp-mint CL achievement tok n)`). The two clamps here differ in exactly ONE line: both pay a `skeleton-match` in `sm` at the same rate, and only `CL_deep` additionally pays a `transitive-explanation` in `tr` — the token `R_trans` must spend to chain. The `sm` rate is set high enough that a derived CONTROL level can also pay for itself: gating a strategy costs a firing per gated rule, so a regime that only just covers the substrate leaves nothing for a control level built on top of it. So the same corpus and chamber, with the clamp swapped, select different survivors: under `CL_deep` the chaining organism `O_chain` runs a `tr` surplus and both answers persist; under `CL_shallow` it earns no `tr`, starves, and the root answer disappears. Reward selects strategy, demonstrated at P1/P2 with no reproduction (P3) needed.

> **Clamp representation caveat:** MSC specifies clamps *functionally* (eq 17 + typed-token output + chamber-locality) but gives **no IR data shape**; the `clamp-mint` facts are ours.

## Files

This directory is **data only** — pure portable facts loaded by `import!`. The *logic* (the generic engine + the converter + the run + the evaluator) lives in `../../petta/`; the rules themselves are canonical per-match IR data **here** (`rules.metta`).

| File | What |
|------|------|
| `corpus.json` | the vignette text + questions as structured JSON (`id` / `sentences` / `questions` / `additional_info`) — the **input tier** (surface-marked parse target, parser-loadable) |
| `corpus_parsed.json` | the semantic parser's output over `corpus.json` — the vignette as PLN proof atoms (`(: id (Rel args) (STV s c))`), **surface level** (discourse cues, no causal relations) + a variable-bearing `queries` entry per question (normal form: `ReasonFor`) |
| `molecules.metta` | pure-fact IR: the parser-derived semantic graph in **§10.1 sem-graph form** (`sem-edge`/`sem-edge-tv`; variable-arity, edge-ref dedup, `And` decomposed with TV-less operands) — generated from `corpus_parsed.json` by `../../ir/to_semgraph.py` |
| `tasks.metta` | pure-fact IR: the **QA benchmark** — questions + their `answer-skeleton` sem-graphs (the parser's variable-bearing queries; the query TV kept as `answer-skeleton-tv`); no gold answer content — answering = grounding a skeleton against the derived graph |
| `configs.metta` | pure-fact IR: the Exp-1 **run config** — the chambers (`CH_expt1` and the offspring's `CH_scaffold`), the two mortal organisms (`O_base` owns the cue-normalizers `R_so`/`R_result`; `O_chain` owns the transitive chainer `R_trans` and starves under `CL_shallow`), the **clamps** (`CL_shallow`/`CL_deep`: `(clamp-mint CL achievement tok n)` — which achievement mints which typed fuel), and the shared fuel **snapshot** `SNAP_qa` (the canonical one-chamber-run endowment each worker restores; MSC §6.4). Worker *instances* are declared by their runners (the test exercising each kind), not here. |
| `rules.metta` | pure-fact IR: **the derivation genome** — cue-normalization rules (`R_so`/`R_result` ⊢ `ReasonFor`, `R_trans` chains derived edges) as canonical per-match `rule-lhs`/`rule-rhs` IR with `(var Name)` markers |
| `load.metta` | the **data loader** — imports molecules + tasks + configs + rules into `&self` (PeTTa side) |
| `demo.metta` | the end-to-end **substrate** run: one arrival through the three worker kinds (chamber → evaluator → ACS scan), then a stream of arrivals under `CL_deep` where the strategy recurs, then the clamp-switch — under `CL_shallow` `O_chain` earns no `tr`, loses the chained answer from the second arrival on, and ends the run DEAD |
| `demo.metta` | the end-to-end run, and the whole arc in one file: two arrivals worked by the hand-made chain through the three §6.4 worker kinds → the scan finds the chain recurrent, useful and **not closed** → ctrl-scaffold bills the parents and mints a recombinant offspring wrapping it in a control level, whose genome is printed as ordinary `rule-lhs`/`rule-rhs` IR → the offspring is handed two arrivals of its own and the same detector certifies it on **all five conditions at once**, purse growing. Then the catch: the identical genome from the identical endowment under `CL_shallow` runs out of `tr`, and the root cause drops out of the answer. Certification is regime-relative. Ends with the event logs |
| `README.md` | this file |

Regenerate the IR from the parse with `python3 ../../ir/to_semgraph.py corpus_parsed.json V3 mol` (and `… task` for the answer-skeletons).

## Control-level closure — derived, not authored

A why-question's semantic content flows from question to answer and does not reconstruct the question, so a small QA example closes more naturally at the **control** level than the substrate level: the reusable thing is the inference-control pattern that recurs across many questions of the same type. The substrate chain here never closes on its own — the cues it eats are food no rule regenerates, and the reward that funds it is food too — so it certifies as viable, causally load-bearing and recurrent, but **subsidized**.

What closes it is a control level the system **builds for itself**: `petta/ctrl_scaffold.metta` reads the scan's own verdicts, and where a chain recurs and does not close it generates gated copies of each member plus an activator, a success trace, a consolidation and the edge that feeds success back into activation —

```
Primed -> ReasonFor -> Worked -> Primed
```

— under a recombinant offspring organism its parents pay for. That ring regenerates control motifs *and* a semantic one, so it classifies as **hybrid** closure. The wrapper is ordinary portable IR, so the derived rules are as readable and as heritable as authored ones; `demo.metta` prints them.

An earlier version of this experiment carried that ring **hand-written**, as a `control-*.metta` data tier. It is gone: it demonstrated the target shape but could not reach across arrivals (a task's working material retires with the task, so the habit went with it), which is precisely the limit the derived version exists to close.

## Chamber

The Exp-1 chamber is **K-like** on the life-history simplex (MSC §4.6: "stable question answering, where each surviving organism must be trustworthy") — a deliberate contrast with Aelmere's r-like fiction chamber.

## What's where (logic vs data)

- **The genome** — `rules.metta` here: the **derivation genome**, the interpretive theory that normalizes the parser's surface cues into the explanatory layer the questions query (`R_so`/`R_result`: cue ⊢ `ReasonFor`; `R_trans`: chains **derived** `ReasonFor` edges — a rule feeding on rules' products), as **canonical per-match `rule-lhs`/`rule-rhs` IR** with `(var Name)` markers. Products carry provenance-bearing ids (`(norm E)`/`(trans E1 E2)`). Tokens: `sm` = skeleton-match fuel (`tau_graph_match`), `tr` = transitive-explanation fuel (see `../../ir/schema.md` §1).
- **The engine + solve code** — `../../petta/` : the engine (`util`/`fuel`/`compiler`/`gate`/`reaction`), the grounder (`grounder.metta`), and the evaluator (`evaluator.metta`). This dir is the *data* they operate on.
