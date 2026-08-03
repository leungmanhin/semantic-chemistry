# Experiment 1 — Toy Causal-QA Corpus

The **first build target** for Mortal Semantic Chemistry (MSC §7.1): a short everyday-causal text + why-questions, answered by grounding a variable-bearing skeleton against a graph the genome derives. This corpus anchors stages **P0 → P2**, ahead of the larger fiction corpus (Experiment 2).

## Why the corpus is one vignette

Deliberate. MSC's §10.2 "1k–10k sentences" guidance is for the fiction-world domain (Aelmere already satisfies it). Exp 1 is the *simplest end-to-end causal-accountability test* (hard prohibition #8: start small + inspectable), so it carries the single vignette **V3** — a two-hop causal chain dense enough to exercise every mechanism in the stack: cue normalization, chaining, achievement-typed minting, the metabolic epoch loop, ACS certification, and control-level closure.

## What's in a vignette

A text + a **Neo-Davidsonian** semantic graph (events reified, roles as edges) + one or more questions. The graph is produced by the semantic parser over `corpus.json` and reshaped to §10.1 sem-graph IR by `../../ir/to_semgraph.py`. The evaluator derives the answer by grounding, so **no gold answer content is stored**.

V3 is *"The power went out during the storm, so the fridge stopped running, and as a result the food had spoiled by morning."* — two discourse cues (`So`, `AsAResult`) over three events, which the genome normalizes into a `ReasonFor` chain.

## Surface-marked text

The vignette text makes its causation **explicit** with discourse connectives (`so` / `as a result`), so the parser extracts the *cue* directly rather than inferring a causal relation. That split is load-bearing: the parser emits **surface** cues only, and the **derivation genome** (`rules.metta`) is the interpretive theory that turns them into the normalized `ReasonFor` layer the questions query. What the parser asserts and what the system concludes stay separable — which is what makes the genome selectable, ablatable, and chargeable for fuel.

## Questions

The parser maps each question to a variable-bearing **answer-skeleton** whose sought relation is the normal form `ReasonFor`. A question licenses ONE `ReasonFor` (hop-count is graph knowledge the asker doesn't have); the surface text is kept in `question-surface`. **Answer plurality and depth come from the genome, never from the query shape** — V3's *"Why did the food spoil?"* grounds two ways (the proximate cause and, via `R_trans`, the root cause), with the mechanism chain recoverable from the root answer's `(trans …)` provenance id.

## The clamp-switch

A **clamp** is the evaluator's reward regime (MSC §4.4): it maps a grounding's *achievements* to the typed fuel they mint (`(clamp-mint CL achievement tok n)`). Both clamps here pay a `skeleton-match` in `sm`; only `CL_deep` additionally pays a `transitive-explanation` in `tr` — the token `R_trans` must spend to chain. So the same corpus and chamber, with the clamp swapped, select different survivors: under `CL_deep` the chaining organism `O_chain` runs a `tr` surplus and both answers persist; under `CL_shallow` it earns no `tr`, starves, and the root answer disappears. Reward selects strategy, demonstrated at P1/P2 with no reproduction (P3) needed.

> **Clamp representation caveat:** MSC specifies clamps *functionally* (eq 17 + typed-token output + chamber-locality) but gives **no IR data shape**; the `clamp-mint` facts are ours.

## Files

This directory is **data only** — pure portable facts loaded by `import!`. The *logic* (the generic engine + the converter + the run + the evaluator) lives in `../../petta/`; the rules themselves are canonical per-match IR data **here** (`rules.metta`).

| File | What |
|------|------|
| `corpus.json` | the vignette text + questions as structured JSON (`id` / `sentences` / `questions` / `additional_info`) — the **input tier** (surface-marked parse target, parser-loadable) |
| `corpus_parsed.json` | the semantic parser's output over `corpus.json` — the vignette as PLN proof atoms (`(: id (Rel args) (STV s c))`), **surface level** (discourse cues, no causal relations) + a variable-bearing `queries` entry per question (normal form: `ReasonFor`) |
| `molecules.metta` | pure-fact IR: the parser-derived semantic graph in **§10.1 sem-graph form** (`sem-edge`/`sem-edge-tv`; variable-arity, edge-ref dedup, `And` decomposed with TV-less operands) — generated from `corpus_parsed.json` by `../../ir/to_semgraph.py` |
| `tasks.metta` | pure-fact IR: the **QA benchmark** — questions + their `answer-skeleton` sem-graphs (the parser's variable-bearing queries; the query TV kept as `answer-skeleton-tv`); no gold answer content — answering = grounding a skeleton against the derived graph |
| `configs.metta` | pure-fact IR: the Exp-1 **run config** — the chamber, the two mortal organisms (`O_base` owns the cue-normalizers `R_so`/`R_result`; `O_chain` owns the transitive chainer `R_trans` and starves under `CL_shallow`), the **clamps** (`CL_shallow`/`CL_deep`: `(clamp-mint CL achievement tok n)` — which achievement mints which typed fuel), and the shared fuel **snapshot** `SNAP_qa` (the canonical one-chamber-run endowment each worker restores; MSC §6.4). Worker *instances* are declared by their runners (the test exercising each kind), not here. |
| `rules.metta` | pure-fact IR: **the derivation genome** — cue-normalization rules (`R_so`/`R_result` ⊢ `ReasonFor`, `R_trans` chains derived edges) as canonical per-match `rule-lhs`/`rule-rhs` IR with `(var Name)` markers |
| `load.metta` | the **data loader** — imports molecules + tasks + configs + rules into `&self` (PeTTa side) |
| `control-rules.metta` | pure-fact IR: **the control genome** — the same derivation, re-expressed as a loop that sustains its own activation (see *Control-level closure* below). The substrate rules (`R_so_rf`/`R_result_rf`/`R_trans_rf`) are gated on an internal `Primed` state; `R_worked`/`R_learn`/`R_prime` turn a successful derivation back into it; `R_detect`/`R_explore` convert an arriving question into the first `Primed` out of the `ex` endowment |
| `control-configs.metta` | pure-fact IR: the control **run config** — the `ctrlg` control graph, `CH_ctrl`, the single organism `O_ctrl` owning all 8 rules, the clamp `CL_ctrl`, the snapshot `SNAP_ctrl` (incl. the one-off `ex`), plus the `(control-relation …)` declarations the closure classifier reads. The genome's food — a `WhyQuestion` marker per question — arrives on each task's own graph from the parser adapter, not from a control-tier task file |
| `control-load.metta` | the **control data loader** — molecules + tasks + the control tier; deliberately *not* the substrate genome/config (that chamber's context and question set stay separate) |
| `demo.metta` | the end-to-end **substrate** run: one arrival through the three worker kinds (chamber → evaluator → ACS scan), then a stream of arrivals under `CL_deep` where the strategy recurs, then the clamp-switch — under `CL_shallow` `O_chain` earns no `tr`, loses the chained answer from the second arrival on, and ends the run DEAD |
| `demo-ctrl.metta` | the end-to-end **control-closure** run: one arrival in which the ring turns a hop per cycle (detect → explore → derive → success trace → habit → re-prime) and certifies as a `hybrid`-closed, autocatalytic, causally load-bearing ACS — then the second arrival it cannot reach, which is the limit `ctrl_scaffold` exists to close |
| `README.md` | this file |

Regenerate the IR from the parse with `python3 ../../ir/to_semgraph.py corpus_parsed.json V3 mol` (and `… task` for the answer-skeletons).

## Control-level closure

A why-question's semantic content flows from question to answer and does not reconstruct the question, so a small QA example closes more naturally at the **control** level than the substrate level: the reusable thing is the inference-control pattern that recurs across many questions of the same type. `control-rules.metta` builds that loop — the substrate rules fire only while the strategy is `Primed`, and a successful derivation feeds back through

```
Primed -> ReasonFor -> Worked -> Habit -> Primed
```

so the loop regenerates control motifs *and* a semantic one — **hybrid** closure. Two rules stay outside it: `R_detect` turns an arriving `WhyQuestion` into an attempt, and `R_explore` spends a one-off `ex` **exploration endowment** to prime the strategy cold. Because a task runs cycles until its chamber settles, the ring closes **inside one task**: cycle 1 ignites the strategy and derives the answers, cycle 2 is `R_prime` firing off the habit cycle 1 consolidated — the closing edge, paid for by the loop's own product — and cycle 3 finds every product present and fires nothing, ending the task.

What this hand-written genome **cannot** do is carry across arrivals. A task's working material retires with the task, so the habit goes with it, and `ex` is spent — the second arrival cannot be primed at all. The ring is therefore certified on one task, and re-activating a strategy on a *later* one needs the memory to live where the task's pool cannot reach. That is what `petta/ctrl_scaffold.metta` derives: a control level generated around a chain the log says keeps working, rather than written by hand.

Two things this does **not** need: any change to the molecule shapes (the parser's substrate output is untouched — only a question-type marker is added), and any new node kind for control state (the control motifs are ordinary `sem-edge`s on the `ctrlg` graph, which is not `neo-davidsonian` and so never grounds an answer).

## Chamber

The Exp-1 chamber is **K-like** on the life-history simplex (MSC §4.6: "stable question answering, where each surviving organism must be trustworthy") — a deliberate contrast with Aelmere's r-like fiction chamber.

## What's where (logic vs data)

- **The genome** — `rules.metta` here: the **derivation genome**, the interpretive theory that normalizes the parser's surface cues into the explanatory layer the questions query (`R_so`/`R_result`: cue ⊢ `ReasonFor`; `R_trans`: chains **derived** `ReasonFor` edges — a rule feeding on rules' products), as **canonical per-match `rule-lhs`/`rule-rhs` IR** with `(var Name)` markers. Products carry provenance-bearing ids (`(norm E)`/`(trans E1 E2)`). Tokens: `sm` = skeleton-match fuel (`tau_graph_match`), `tr` = transitive-explanation fuel (see `../../ir/schema.md` §1).
- **The engine + solve code** — `../../petta/` : the engine (`util`/`fuel`/`compiler`/`gate`/`reaction`), the grounder (`grounder.metta`), and the evaluator (`evaluator.metta`). This dir is the *data* they operate on.
