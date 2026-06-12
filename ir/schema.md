# Mortal Semantic Chemistry — Portable-Facts IR Schema (P0)

**Status:** P0 draft, 2026-06-08. The backend-neutral fact vocabulary that all durable state is represented in.

This is the single most load-bearing artifact of the implementation. Per Mortal Semantic Chemistry §6.1 (hard prohibition #3), **all durable state lives in these portable S-expression facts** — never in PeTTa-private mutable predicates. PeTTa is the *first executor*; MeTTa-IL is a *later executor of the very same facts*. **Compliance test:** a future MeTTa-IL backend must read exactly these facts and produce an equivalent event log.

The facts below are the canonical IR. In the PeTTa executor they are loaded with `(add-atom &mork <fact>)` (see `../corpus/expt1-causal-qa/expt1_data.metta`); `&mork` is the executor's hot-pool *view* of the facts, not a private source of truth. A different backend may store them differently, but the fact *shapes* are fixed.

---

## 1. Naming conventions

- **Relation name first, grounded keys next, variables/values at the suffix** (MORK prefix-friendly schema discipline — keeps the trie prefix-shared and matches fast).
- One fact = one tuple. Multi-valued attributes (a fuel vector, a rule's token costs) are **expanded into one fact per element**, never packed into a list — so they index and diff cleanly.
- **IDs are opaque symbols** with a type prefix by convention: `G_*` graph, `N_*`/`n_*` node, `E_*`/`e_*` edge, `R*` rule, `O*` organism, `GNM*` genome, `RS*` ruleset, `CH_*` chamber, `W*` worker, `SNAP*` snapshot, `SEED*` seed, `LOG*` event log, `B*` binding. IDs are globally unique within a run.
- **Token-type symbols** come from the open MSC alphabet (`graph-match-token`, `causal-inference-token`, `pln-deduction-token`, `dequote-token`, …). The set is extensible; domain clamps add more.
- Truth values are two trailing reals `<strength> <confidence>` (PLN `stv`), each in `[0,1]`.

---

## 2. Fact catalog

### 2.1 Semantic graphs (the "molecules")

A semantic graph is a set of typed nodes and labelled edges. Rule LHS/RHS patterns are *also* semantic graphs, distinguished only by carrying `node-var` markers.

| Fact | Meaning |
|------|---------|
| `(sem-graph G)` | Declares graph `G`. |
| `(sem-node G N)` | Node `N` belongs to graph `G`. |
| `(node-type G N Type)` | Node `N` has semantic type `Type` (a concept symbol, e.g. `SilkenThreads`, `Boil`). A node may have ≥1 type facts. |
| `(node-var G N vname)` | Node `N` is a **pattern variable** named `vname` (rule-local). Only appears in rule LHS/RHS graphs. A matcher binds `vname` to a concrete node. |
| `(sem-edge G E Rel Nsrc Ndst)` | Edge `E` in `G`: relation `Rel` from `Nsrc` to `Ndst` (e.g. `Theme`, `Instrument`, `CauseOf`). |
| `(edge-tv G E s c)` | PLN truth value on edge `E` (optional). |
| `(edge-causal G E kind)` | Causal-coding label, `kind ∈ {causal-forward, correlational}` (FUSE-NF Stage 6 output; optional in P0). |
| `(node-modal G N m)` | Modality marker: `m ∈ {intended, prevented}`. `intended` = a goal/purpose state or event not (yet) realized in the text (the source of a `Motivates` edge); `prevented` = an event that did *not* occur because something blocked it (the target of a `Prevents` edge). Unmarked nodes are realized/actual. |

> **Stability note (Q2):** the *internal* node/edge vocabulary (`Boil`, `Theme`, Neo-Davidsonian event reification, …) is **illustrative pending the LLM parser** — it will be pinned when the parser's output style is known. The *fact shapes* in this table (`sem-graph`/`sem-node`/`node-type`/`node-var`/`sem-edge`) are **stable** regardless of the parser.

### 2.2 Rules (the "reactions")

A rule is the fuel-aware form `C ^ G1 ^ HasFuel(O,R) ==> G2 ^ ConsumeFuel(O,R) ^ EmitTrace(O,R)` (MSC §4.1). The `HasFuel`/`ConsumeFuel`/`EmitTrace` parts are *operational* (handled by the kernel + the cost facts), not stored as graph literals.

| Fact | Meaning |
|------|---------|
| `(sem-rule R)` | Declares rule `R`. |
| `(rule-lhs R Glhs)` | LHS pattern graph (the reactant to match, `G1`). |
| `(rule-rhs R Grhs)` | RHS product graph (`G2`) — added on firing. Shares `node-var` names with the LHS. |
| `(rule-context R C)` | Context/chamber tag the rule is licensed to fire in (the `C` of `C ^ G1`). A rule may list ≥1. |
| `(rule-tv R intensional-implication s c)` | The rule's PLN intensional-implication strength `s_C(G1,G2)` + confidence. |
| `(rule-token-cost R token-type n)` | One component of the cost vector `κ_R` — firing consumes `n` of `token-type`. **One fact per token type**; absent type ⇒ cost 0. |

### 2.3 Organisms (the mortal units)

`O = (@R, X, F, C, L)` (MSC §4.1). The genome `@R` is the *quoted* ruleset (heritable, inert); the soma is the running process the kernel drives.

| Fact | Meaning |
|------|---------|
| `(organism O)` | Declares organism `O`. |
| `(organism-chamber O C)` | The chamber/context the organism lives in (`C`). |
| `(genome-of O GNM)` | `O`'s genome is `GNM`. |
| `(quoted-ruleset GNM RS)` | The genome `GNM` quotes ruleset `RS` (the heritable `@R`). |
| `(ruleset-member RS R)` | Rule `R` is in ruleset `RS`. **One fact per rule.** |
| `(fuel O token-type n)` | The organism currently holds `n` of `token-type` (a component of fuel vector `F_O`). **One fact per token type held.** Debited on firing. |

### 2.4 Chambers (the contexts / reaction environments)

| Fact | Meaning |
|------|---------|
| `(chamber C)` | Declares chamber `C`. |
| `(chamber-context C pred)` | A context condition tagging the chamber (e.g. `fiction-world`, `aelmere`, `why-question`). ≥1 allowed; together they form `C` in the rule context match. |
| `(chamber-hot-rule C R)` | Rule `R` is in this chamber's **hot pool** (eligible to fire here this epoch). |
| `(chamber-graph C G)` | Semantic graph `G` is part of the chamber's working state `X`. Membership changes as events add/remove products. |
| `(chamber-life-history C strategy)` | `strategy ∈ {r-like, K-like, …}` on the life-history simplex (MSC §4.6). Aelmere ⇒ `r-like`. |

### 2.5 Workers + replay handles

A worker runs one bounded, replayable unit of chamber computation (MSC §6.4 contract). For P0 there is one worker over one chamber. **Canonical source:** `docs/Goal-Guided…pdf` §20.2 + App A.3.2 ("Portable worker IR facts") + App E.2 give the worker-IR vocabulary, the backend-neutral contract, and the PeTTa orchestration skeleton — our facts below match it. The full worker-kind set (`context-chamber`, `moses-deme`, `acs-scan`, `ecan-epoch`, `bridge-fit`, `reducer`) and `par-group`/`reducer` facts come online at P4; P0 uses only `context-chamber`.

| Fact | Meaning |
|------|---------|
| `(worker W)` | Declares worker `W`. |
| `(worker-kind W kind)` | e.g. `context-chamber`, `acs-scan`, `replay`, `reducer`. P0 uses `context-chamber`. |
| `(worker-backend W backend)` | `petta` now; `metta-il` later. The fact that *records which executor produced a log* — central to the log-equivalence test. |
| `(worker-chamber W C)` | The chamber this worker advances. |
| `(worker-snapshot W SNAP)` | Initial state handle (see below). |
| `(worker-seed W SEED)` | PRNG seed handle. |
| `(worker-budget-steps W n)` | **Deterministic** budget: max kernel steps (ticks) to run. Governs replay. |
| `(worker-budget-ms W n)` | *Optional* wall-clock soft-cap for orchestration (P4). **Must NOT influence the logical event log** — see §4. |
| `(worker-output-log W LOG)` | The event log this worker writes. |
| `(snapshot SNAP C)` | A captured initial state of chamber `C`. Its *contents* = the set of `chamber-graph`, `sem-*`, `fuel`, `ruleset-member` facts scoped to `C` at capture time. Restore = re-assert exactly those. |
| `(seed SEED k)` | The integer seed value `k` for the deterministic PRNG. |

### 2.6 Event log (the replayable history `L`)

The event log is an **ordered** sequence of firing records, indexed by an integer `seq`. It is the authoritative output of a worker and the object the replay-equivalence test compares. Each firing `event(O,R,θ,κ_R,X,X')` (MSC eq 16) expands to:

| Fact | Meaning |
|------|---------|
| `(event-log LOG)` | Declares log `LOG`. |
| `(log-chamber LOG C)` | The chamber this log records. |
| `(event LOG seq O R B)` | At step `seq`, organism `O` fired rule `R` under binding `B`. `seq` is dense and strictly increasing from 0. |
| `(binding B vname value)` | The match `θ`: pattern variable `vname` bound to `value` (a node id / concept). **One fact per variable.** |
| `(event-spend LOG seq token-type n)` | Tokens debited at this event (= the rule's `κ_R`). One fact per token type. |
| `(event-add LOG seq fact)` | A graph fact added to `X` as the product `θ(G2)`. `fact` is a quoted sem-* tuple. |
| `(event-del LOG seq fact)` | A graph fact removed from `X` (if the rule deletes). |
| `(event-gate LOG seq gate draw)` | Audit record: the gate value `Gate_C(R,O,X)` and the PRNG draw `U` at this step. Lets a replay *verify* (not just reproduce) determinism. |

### 2.7 QA tasks + gold skeletons (Experiment-1 layer; additive)

The Experiment-1 toy causal-QA chamber (MSC §7.1) adds a task layer on top of the core. A **task** wraps one source vignette graph and carries one or more **questions** (paraphrase variants are separate questions on the same task). Gold answers are **class-tagged skeletons** — the `Y*_q` targets of MSC eq 17 — enabling the clamp-switch experiment (see `corpus/expt1-causal-qa/README.md`).

| Fact | Meaning |
|------|---------|
| `(qa-task T)` | Declares task `T`. |
| `(qa-source T G)` | The vignette graph the task is about. |
| `(qa-question T Q)` | Question `Q` belongs to task `T` (≥1; paraphrase variants share the task). |
| `(q-word Q w)` | Surface interrogative form: `why \| what-made \| how-come \| how \| why-not \| trying-to-do \| what-for`. The organism's *question-type detector* + *paraphrase-collapse* rules operate on this — the corpus does NOT pre-supply a question type. |
| `(question-focus Q N)` | The event node being asked about. *(P0/P1 simplification: focus is given. Resolving focus from a parsed question-graph becomes organism work when the LLM parser lands.)* |
| `(question-source Q G)` | Denormalized copy of `qa-source` (single-pattern-match convenience). |

**Gold skeletons** (evaluator-side; soma rules must not match on `skeleton-*` facts — enforced at P1 by space separation or fact-tag discipline):

| Fact | Meaning |
|------|---------|
| `(answer-skeleton Q SK)` | Skeleton `SK` is a gold answer for `Q`. A question may carry **two** (one per class) — that is an *ambiguous dual* question, the clamp-switch material. |
| `(skeleton-class SK cls)` | `cls ∈ {physical-cause, intentional}`. **Omitted for abstain skeletons** (abstaining is correct under every clamp). |
| `(skeleton-cites SK G E)` | Explanatory edge(s) a correct answer must cite. ≥1 per positive skeleton; multi-cause/mechanism skeletons list several. |
| `(skeleton-provenance SK G N)` | Source node(s) the answer must trace back to (the provenance clamp). ≥1. |
| `(skeleton-abstain SK)` | Gold = decline to answer (no text-supported edge). No cites/provenance/class. |

**Runtime candidate answers** (chamber output → evaluator input — written by the soma):

| Fact | Meaning |
|------|---------|
| `(candidate-answer Q A)` / `(answer-by A O)` | Organism `O` proposed answer `A` for `Q`. |
| `(answer-class A cls)` | The answer's class (`physical-cause` \| `intentional`), set from the cited edge's `edge-cluster` (§2.8). Absent on an abstain answer. |
| `(answer-cites A G E)` / `(answer-provenance A G N)` | What the answer cites / traces to. |
| `(answer-role A Role Filler)` | A participant the answer carries (role-completion output, e.g. `Experiencer=maria`). |
| `(answer-abstain A)` | The organism explicitly abstains. |

**P1 evaluator outputs** (written ONLY by the evaluator, never the soma — hard prohibition #1):

| Fact | Meaning |
|------|---------|
| `(answer-score A term v)` | The eq-17 term breakdown the evaluator computed for `A`: `term ∈ {match, unsupportedness, redundancy, …}`, `v ∈ [0,1]`. Audit of *why* `A` was (or wasn't) rewarded under the active clamp. |
| `(answer-reward A token n)` | Minted typed fuel credited to `A`'s organism — the eq-17 score mapped through the active clamp's `clamp-token` map (§2.8). The mint currency is an *operational* token (e.g. `graph-match-token`) so it can re-fund firing — this is what closes the metabolic loop. |
| `(reward-credit LOG epoch O token n)` | The organism-side credit event: at evaluation `epoch`, `n` of `token` was added to `O`'s fuel vector. The inverse of `event-spend`; lets a reader reconstruct the fuel economy across the chamber↔evaluator epoch loop. |
| `(log-clamp LOG CL)` | Records which clamp `CL` was active for the run that produced `LOG` (the clamp-switch handle — pairs with `worker-clamp`, §2.8). |

**Dual-question semantics:** a question with skeletons of both classes is *ambiguous*; the active clamp selects which is scored. A question with a single class scores only under the matching clamp; **under the other clamp the correct behavior is abstain** (the evaluator derives this: no skeleton of the active class ⇒ abstain-gold). No extra corpus facts needed.

### 2.8 Edge clusters + clamp config (P1 preview — interim shape)

> **Status note:** MSC §4.4 defines clamps *functionally* (a token source tied to a desired output class; minting score eq 17; scalar→typed-fuel conversion; chamber-local scope) but prescribes **no data representation** — the §6.1 portable-facts example contains no clamp/evaluator facts. The shapes below are **our design choice**, consistent with the portable-facts discipline: a clamp = a *parameterization of eq 17* stored as facts; the eq-17 term computations (Match, CausalClarity, …) are evaluator-worker **code**, not facts. **The worker-IR these sit alongside has a canonical source** (`docs/Goal-Guided…pdf` §20.2 + App A.3.2 — see §2.5), but **clamps specifically are not covered there** (MSC-specific), so these shapes have no external source to reconcile against and stand as our own.

| Fact | Meaning |
|------|---------|
| `(edge-cluster Rel cls)` | Vocabulary-level: assigns explanatory relation `Rel` to an answer-class. Exp-1 set: `CauseOf/Triggers/Enables/Contributes/Prevents → physical-cause`; `Motivates/Reason → intentional`; `Despite → concession` (never an answer class — concessive edges are trap material). |
| `(clamp CL)` | Declares clamp `CL`. |
| `(clamp-class CL cls)` | The answer-class this clamp rewards (selects which skeleton `Y*_q` the Match term scores against). The clamp-switch experiment = swap `physical-cause` ↔ `intentional`. |
| `(clamp-coeff CL term w)` | eq-17 coefficient, e.g. `(clamp-coeff CL_a match 1.0)`, `(clamp-coeff CL_a unsupportedness 2.0)`. One fact per term. |
| `(clamp-token CL signal token)` | Score→typed-fuel mapping, e.g. `(clamp-token CL_a skeleton-match answer-reward-token)`. |
| `(clamp-scope CL C)` | Chamber-local scoping (MSC: "clamping can also be local"). |
| `(worker-clamp W CL)` | The active clamp for a run — the experimental switch. A paired clamp-switch run = same snapshot+seed+budget, different `worker-clamp`. |

---

## 3. Fuel-gated firing semantics (what the P0 kernel does with these facts)

One kernel **step** (MSC §4.3, eqs 13–16):

1. **Enumerate candidates** — for the chamber `C`, for each organism `O` in `C`, for each hot rule `R` (`chamber-hot-rule C R` ∧ `ruleset-member`(genome of `O`)`R`) whose `rule-context` is satisfied by `C`'s `chamber-context` facts, find every match `θ` of `rule-lhs R` against the chamber graphs `X`. **Candidate enumeration order MUST be canonical** (sort by `R` id, then a canonical serialization of `θ`) — see §4.
2. **Fuel filter** — keep candidate `(R,θ)` only if `F_O ≥ κ_R` componentwise: for every `(rule-token-cost R t n)`, the organism has `(fuel O t m)` with `m ≥ n`.
3. **Score + sample** — compute `Gate_C(R,O,X)` (MSC eq 24: strength, confidence, do-influence, novelty, −redundancy, −cost, +FuelMargin, +ACSBoost). Draw `U` from the seeded PRNG; the rule fires if `U < Gate` (or pick the arg-max candidate — P0 may start with deterministic arg-max and add sampling later, as long as it stays seed-deterministic).
4. **Fire, in lockstep:**
   - `X' = X ⊕ θ(G2)` → emit `event-add`/`event-del` facts; update `chamber-graph`.
   - `F'_O = F_O − κ_R` → debit `fuel` facts; emit `event-spend`.
   - `L' = L · event(...)` → append `event` + `binding` + `event-gate` facts at the next `seq`.
5. **Stop** when `seq` reaches `worker-budget-steps`, or no candidate is both matched and fuel-enabled (the organism has **starved** — record cause of death), or the chamber reaches a fixed point.

Reward/fuel **minting is NOT part of this loop** — that is the evaluator layer (P1, MSC §4.4). The active soma never mints its own fuel (hard prohibition #1).

---

## 4. The replay-equivalence invariant (P0 definition-of-done)

> **`run(snapshot, seed, budget)` must produce a byte-identical event log every time, on a given backend; and an *equivalent* log across backends (modulo backend tag + harmless ID-allocation differences).**

This is the single criterion that P0 must pass. Three non-obvious constraints it forces — design them in now:

1. **Budget must be deterministic.** Use `worker-budget-steps` (tick count) or a total-fuel budget — **never `worker-budget-ms`** as the replay budget. Wall-clock is entropy; it would make the log non-reproducible. `worker-budget-ms` may exist as a P4 orchestration soft-cap, but it must only *truncate* a run at a step boundary, never change *which* rule fires at a given step.
2. **Candidate enumeration must be canonically ordered.** Set iteration / hash order is not guaranteed across runs or backends. Before sampling, sort candidates by `(rule-id, canonical(θ))`. Otherwise the same seed draws against a different candidate list and the log diverges. This is also why MeTTa-IL log-equivalence is "modulo harmless ID-allocation": fresh-ID counters may differ, so compare logs up to a consistent ID renaming, not raw symbol equality.
3. **All randomness comes from `(seed SEED k)`.** One PRNG, seeded only from the fact. No `Math.random`, no clock, no address-of, no set-hash. `event-gate` logs each draw so a replay can assert it reproduced the same `U` sequence.

Restore semantics: restoring `SNAP` re-asserts exactly the chamber-scoped facts captured at snapshot time and clears all `event*` facts for the run; then re-running with the same `seed` + `budget` must reproduce the log.

---

## 5. Backend-neutrality / compliance checklist

A change is IR-legal only if it keeps all of these true:

- [ ] Durable state is expressible as the facts in §2 — nothing essential lives only in a PeTTa predicate, a Prolog assertion, or kernel-local memory.
- [ ] The event log (§2.6) fully determines what happened — a reader needs no PeTTa internals to reconstruct the run.
- [ ] No fact shape depends on PeTTa/Prolog evaluation order or `&self`/`&mork` specifics.
- [ ] `run(snapshot, seed, budget-steps)` is reproducible (§4).
- [ ] The worker honors the §6.4 contract: inputs = `{worker facts, snapshot, seed, budget, backend tag}`; outputs = `{ordered event log, graph delta, token delta, summary facts}`.

---

## 6. What P0 deliberately leaves out (later stages)

- **Evaluator-minted fuel + clamps** → P1 — **DONE** (`src/evaluator.py`): eq-17 scoring, clamp-gated typed-fuel minting (never soma-minted), and the chamber↔evaluator epoch loop that credits earned fuel back, closing the metabolic loop. The clamp-switch (`CL_antecedent` ↔ `CL_goal`) flips which strategy runs a surplus.
- **ACS detection + metabolic surplus + causal replay** → P2 (consumes the event log + the new `reward-credit`/`answer-reward` facts).
- **Genomes mutation/reproduction (`mutate_or_recombine`, lineage)** → P3. The `genome-of`/`quoted-ruleset` facts exist now so the IR is ready, but P0 never mutates them.
- **Multiple workers, reducers, ECAN epochs** → P4.
- **MeTTa-IL executor** → later; the whole point of this schema is that it drops in by log-equivalence, not rewrite.

---

## 7. Files

- `schema.md` — this spec (authoritative).
- **Worked examples** (load + round-trip in PeTTa) — the Experiment-1 fixtures:
  - `../corpus/expt1-causal-qa/expt1_data.metta` — data: 5 vignettes as semantic graphs + QA tasks + gold skeletons + edge-clusters + both clamps + chamber/worker.
  - `../corpus/expt1-causal-qa/genome_expt1.metta` — the organism `O_qa`: quoted ruleset + typed fuel + rule headers (§2.2–2.3).
- **Reference engine** over these facts: `../src/` (`kernel.py` = P0 fuel-gated loop; `evaluator.py` = P1 scoring/minting). Generated event logs land in `../runs/`.

See the corpus these rules come from: `corpus/fiction-world-v0/` (world_rules R1–R5 = Cycle A).
