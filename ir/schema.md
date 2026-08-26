# Mortal Semantic Chemistry — Portable-Facts IR Schema (P0)

**Status:** P0 draft. The backend-neutral fact vocabulary that all durable state is represented in.

This is the single most load-bearing artifact of the implementation. Per Mortal Semantic Chemistry §6.1 (hard prohibition #3), **all durable state lives in these portable S-expression facts** — never in PeTTa-private mutable predicates. PeTTa is the *first executor*; MeTTa-IL is a *later executor of the very same facts*. **Compliance test:** a future MeTTa-IL backend must read exactly these facts and produce an equivalent event log.

The facts below are the canonical IR. They are stored as **bare portable S-expressions** (no `add-atom` wrapper); the PeTTa executor loads them into a space via `import!` (which adds bare top-level S-exprs to `&self`) — see `../experiments/expt1-causal-qa/` (`molecules`/`tasks`/`configs`/`rules` + `load.metta`). A space (`&self`, a worker `(new-space)`, or `&mork`) is the executor's hot-pool *view* of the facts, not a private source of truth. A different backend may store them differently, but the fact *shapes* are fixed.

---

## 1. Naming conventions

- **Relation name first, grounded keys next, variables/values at the suffix** (MORK prefix-friendly schema discipline — keeps the trie prefix-shared and matches fast).
- One fact = one tuple. Multi-valued attributes (a fuel vector, a rule's token costs) are **expanded into one fact per element**, never packed into a list — so they index and diff cleanly.
- **IDs are opaque symbols** with a type prefix by convention: `G_*` graph, `N_*`/`n_*` node, `E_*`/`e_*` edge, `R*` rule, `O*` organism, `GNM*` genome, `RS*` ruleset, `CH_*` chamber, `A*` ACS, `W*` worker, `SNAP*` snapshot, `SEED*` seed, `LOG*` event log, `B*` binding. IDs are globally unique within a run.
- **Token-type symbols** follow the **TECAN typed alphabet** (TECAN §4.1 general + §8.4 semantic): `τ_graph_match`, `τ_causal`, `τ_pln_deduction`, `τ_compression`, `τ_paraphrase`, `τ_dequote`, … — written **ASCII** as `tau_graph_match`, `tau_causal`, … (literal `τ` avoided for MORK byte-safety). The set is extensible; domain clamps/chambers add more. (Exp-1 uses two tokens; the **PeTTa executor names them `sm` (skeleton-match, = `tau_graph_match`) and `tr` (transitive-explanation)** in its fact files + engine, plus `dq` (= `tau_dequote`, what a genome costs to express into a soma) — each symbol is the achievement it rewards or the operation it pays for. A backend may use any symbol, since the engine is generic over the token.)
- Truth values are two trailing reals `<strength> <confidence>` (PLN `stv`), each in `[0,1]`.

---

## 2. Fact catalog

### 2.1 Semantic graphs (the "molecules")

A semantic graph is a set of identified, variable-arity **edges** (§10.1 sem-graph form). Every relation — thematic roles, tense/aspect, discourse cues, derived explanatory links — is one `sem-edge` carrying its own id, so any edge can be cited, given a truth value, or named as another edge's argument.

| Fact | Meaning |
|------|---------|
| `(sem-graph G)` | Declares graph `G`. |
| `(sem-graph-kind G kind)` | What `G` is: `neo-davidsonian` (a molecule graph — the parser's event graph) \| `answer-skeleton` (a variable-bearing query, §2.7) \| `control` (internally-generated control state, never grounded against). |
| `(sem-edge G E Rel arg…)` | An edge of graph `G` with id `E`, relation head `Rel`, and **variable arity** — `(sem-edge G e Past ev)` unary, `(sem-edge G e Member n lemma)` binary, and so on. An argument is a node symbol, a literal, another edge's id (edge reference), or a `(var Name)` marker in a skeleton. |
| `(sem-edge-tv G E tv)` | Edge `E`'s truth value, kept as the parser emits it (e.g. `(STV 1.0 0.99)`). Separate from the edge so a TV-less edge is representable — an `And` decomposition gives its operands no TV, since the `And` is the sole truth-bearer. |

> **Edge ids carry provenance.** A parser-minted id is **atomic** (`v3_conn1`); a genome-derived product's id is a **compound** whose head names the deriving step and whose arguments are the premise ids (`(norm v3_conn1)`, `(trans e1 e2)`). That one convention lets the executor tell a given molecule from a derived product structurally — which is how a worker knows what to copy into a hot pool, how the detector tells food from a member's own product, and how the evaluator reads derivation depth — with no id vocabulary named anywhere in the engine.

> **Stability note:** the *internal* relation vocabulary (`Member`, `Patient`, `So`, `ReasonFor`, …) tracks the parser's output style and the genome's interpretive theory. The *fact shapes* — `sem-graph`/`sem-graph-kind`/`sem-edge`/`sem-edge-tv`, with ids on edges and arity left open — are the **backend-neutral** contract any executor reads.

### 2.2 Rules (the "reactions")

A rule is the fuel-aware form `C ^ G1 ^ HasFuel(O,R) ==> G2 ^ ConsumeFuel(O,R) ^ EmitTrace(O,R)` (MSC §4.1). The `HasFuel`/`ConsumeFuel`/`EmitTrace` parts are *operational* (handled by the kernel + the cost facts), not stored as graph literals.

| Fact | Meaning |
|------|---------|
| `(sem-rule R)` | Declares rule `R`. |
| `(rule-lhs R (clauses…))` | The match `C ^ G1`: a list of `(at SPACE PAT)` clauses (bare `PAT` = `at self`) with `(var Name)` variable markers. (Per-match; see the note below.) |
| `(rule-rhs R (prods…))` | The products `G2`: a list of product templates over the LHS variables — one firing per LHS match θ adds `θ(G2)` (set-union). |
| `(rule-context R C)` | Context/chamber tag the rule is licensed to fire in (the `C` of `C ^ G1`). A rule may list ≥1. |
| `(rule-tv R AXIS s c)` | A rule score along `AXIS` (strength + confidence). `intensional-implication` — §2.3's `s_C(G1,G2)` — is the canonical axis; the axis slot is OPEN (SC §5: `causal-support`, `paraphrase-support`, `qa-utility`, `novelty-yield`, …) and each consumer reads the axis it cares about — the views are NOT collapsed into one static weight. |
| `(rule-token-cost R token-type n)` | One component of the cost vector `κ_R` — firing consumes `n` of `token-type`. **One fact per token type**; absent type ⇒ cost 0. |

> **Rule form — canonical `rule-lhs`/`rule-rhs`, per-match.** The rules ARE the `rule-lhs`/`rule-rhs` facts above, stored in **per-match `C ^ G1 ==> G2`** form (MSC §4.3 eq 12–16: one firing per match θ, `X' = X ⊕ θ(G2)` set-union). The shapes are richer than a bare node/edge pattern: a clause is `(at SPACE PAT)` (`SPACE ∈ {self, ws}`; bare `PAT` = `at self`) and a variable is the inline data marker `(var Name)`. So `(rule-lhs R (clauses…))` is the conjunctive match (`C ^ G1`) and `(rule-rhs R (prods…))` is the products (`G2`). The engine (`petta/compiler.metta`) holds a **converter** that, at genome-expression time, mints co-referent PeTTa match-vars from the `(var Name)` markers and assembles each rule into a one-atom **runnable** view `(crule R KEY CLAUSES COST PRODS)` — an engine-internal compiled form, NOT the source of truth (it is one atom there only because per-atom variable co-reference requires it). What is deliberately **not** in a rule: **negation** (**abstain is no soma rule** — the rule simply doesn't match, and a skeleton with no grounding earns nothing) and **aggregation** (plurality is per-grounding at the evaluator, §2.8). `rule-context`/`rule-priority`/`rule-token-cost`/`rule-tv` are separate annotations on `R`. **Compliance:** a future MeTTa-IL backend reads these same `rule-lhs`/`rule-rhs` facts. *(Exp-1's genome is `experiments/expt1-causal-qa/rules.metta`, the substrate derivation genome. A control level on top of it is not authored — it is GENERATED, as these same facts, by `petta/ctrl_scaffold.metta`.)*

### 2.3 Organisms (the mortal units)

`O = (@R, X, F, C, L)` (MSC §4.1). The genome `@R` is the *quoted* ruleset (heritable, inert); the soma is the running process the kernel drives.

| Fact | Meaning |
|------|---------|
| `(organism O)` | Declares organism `O`. |
| `(organism-chamber O C)` | The chamber/context the organism lives in (`C`). |
| `(genome-of O GNM)` | `O`'s genome is `GNM`. |
| `(quoted-ruleset GNM RS)` | The genome `GNM` quotes ruleset `RS` (the heritable `@R`). |
| `(ruleset-member RS R)` | Rule `R` is in ruleset `RS`. **One fact per rule.** |
| `(fuel O token-type n)` | The organism currently holds `n` of `token-type` (a component of fuel vector `F_O`). **One fact per token type held.** Debited on firing (the firing organism resolved by `rule-organism`). A token with no fact reads as `0`. |
| `(genome-token-cost GNM token-type n)` | What genome `GNM` costs to **dequote into a soma** (MSC eq 20 `cexpr`). **One fact per token type. Required:** a genome with no declared cost cannot be expressed at all — expression is never free by omission. |
| `(expressed O)` | *Run-space state.* `O` has a soma in this hot pool. Written once, when the dequote cost is paid; the organism's rules do not run until it is present. |

> **Note:** `afford?`/`debit` (`petta/fuel.metta`) read and write the *firing organism's own* purse; a rule's organism is resolved from `ruleset-member` · `quoted-ruleset` · `genome-of` by `rule-organism`. Exp-1 declares two organisms — `O_base` owning the cue-normalizers, `O_chain` owning the transitive chainer (`experiments/expt1-causal-qa/configs.metta`) — each with its own independent purse, so `O_chain` can starve to death while `O_base` lives. Inter-organism token flow (splitter/joiner, shadow prices Λ) is not modelled here.

> **Expression vs firing.** Compiling a quoted rule into a runnable form is a shared, idempotent build artifact and is free. What costs is *having a soma*: an organism pays `genome-token-cost` once per hot pool and is then marked `(expressed O)`. This gives a death mode prior to starvation-by-firing — an organism that cannot afford to dequote runs nothing at all, however much firing fuel it holds. The charge is once per pool rather than per cycle because eq 20 keeps `cmaint` (being alive) separate from `cexpr` (the act of dequoting); a per-cycle charge would be rent under the wrong name.

### 2.4 Chambers (the contexts / reaction environments)

| Fact | Meaning |
|------|---------|
| `(chamber C)` | Declares chamber `C`. |
| `(chamber-context C pred)` | A context condition tagging the chamber (e.g. `fiction-world`, `aelmere`, `why-question`). ≥1 allowed; together they form `C` in the rule context match. |
| `(chamber-hot-rule C R)` | Rule `R` is in this chamber's **hot pool** (eligible to fire here this epoch). |
| `(chamber-graph C G)` | Semantic graph `G` is part of the chamber's working state `X`. Membership changes as events add/remove products. |
| `(chamber-life-history C strategy)` | `strategy ∈ {r-like, K-like, …}` on the life-history simplex (MSC §4.6). Aelmere ⇒ `r-like`. |
| `(gate-coeff k v)` | Coefficient `v` of eq-24 term `k` in the mortal gate (the doc's own letters: `d` do-influence, `g` cost, `h` fuel margin, `j` ACS boost). Undeclared = 0 = the term is OFF; with none declared every score is the constant 0.5 and queue ranking degenerates to `rule-priority` order. |
| `(gate-threshold u)` | The scheduler's **deterministic** admission bar: a candidate fires only if `u < Gate_C(R,O,X)` strictly (MSC eq 13's third conjunct). Undeclared = no admission bar — TECAN Alg 5.1's fire loop pops every affordable candidate — while the score still orders the queue. |

> **`chamber-hot-rule` and the computed gate.** `(chamber-hot-rule C R)` is a boolean placeholder for "attention above the hot threshold." The firing decision is **computed** (`petta/gate.metta`): admission = `rule-eligible-in?` (the context filter — the rule's `rule-context` must be a declared `chamber-context`) ∧ `afford?` (the firing organism's own purse covers `rule-token-cost`) ∧ `gate-open?` (MSC eq 13's `U < Gate_C` against the declared `(gate-threshold u)`; none declared = no bar). `Gate_C(R,O,X)` is the **mortal gate** (MSC eq 24 / TECAN Alg 5.2 TECANScore): σ(d·DoInf + j·ACSBoost + h·log(1+FuelMargin) − g·Cost) over the declared `(gate-coeff k v)`, reading the scan's `rule-do-influence` verdicts, the five-condition ACS certificate, the purse (eq-25 FuelMargin = min purse/cost), and the flat cost sum — one scalar consumed as both the fire-queue's priority key and the admission propensity. So hotness is *evaluated* from rule facts, the way `afford?` is computed over `fuel` facts — not stored as scalar STI. Not modelled: attention *dynamics* (decay / rent / spreading / stimulus), the plausibility terms `a·logit(s_R) + b·c_R` (the genome declares no `rule-tv`; whether `c_R` is PLN confidence or SC's rule-clarity is unsettled), novelty, the scalar redundancy, and shadow-priced cost — the economy arc, and a multi-chamber setting (Exp 2) where attention is scarce and contested.

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
| `(worker-budget-steps W n)` | **Deterministic** budget: max kernel steps (firings) to run, carried across the **whole task** rather than reset per cycle. Governs replay. |
| `(worker-cycles W n)` | Cycle allowance for the task the worker works (default 20). A task halts when its chamber settles, so this is a runaway guard, not a tuning dial. |
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
| `(event cycle seq R key)` | **What the executor emits today.** At position `seq` within `cycle`, rule `R` fired with firing-key `key` — the rule's *instantiated product list*, which is what makes one firing distinguishable from another of the same rule. It therefore subsumes `event-add` below, and the firing organism is recoverable from `R` (`rule-organism`). `seq` restarts at 0 each cycle; `cycle` is dated to the task it served by `(cycle-task cycle task)`. The richer per-event records below are the growth path, not the current shape. |
| `(binding B vname value)` | *Growth path.* The match `θ`: pattern variable `vname` bound to `value` (a node id / concept). **One fact per variable.** Today the binding is implicit in the firing key. |
| `(event-spend LOG seq token-type n)` | *Growth path.* Tokens debited at this event (= the rule's `κ_R`). One fact per token type. Today recoverable from `rule-token-cost`. |
| `(event-add LOG seq fact)` | *Growth path.* A graph fact added to `X` as the product `θ(G2)`. Today this IS the firing key. |
| `(event-del LOG seq fact)` | A graph fact removed from `X` (if the rule deletes). |
| `(event-gate LOG seq gate draw)` | Audit record: the gate value `Gate_C(R,O,X)` and the PRNG draw `U` at this step. Lets a replay *verify* (not just reproduce) determinism. |

### 2.7 QA tasks (Experiment-1 layer; additive)

The Experiment-1 toy causal-QA chamber (MSC §7.1) adds a task layer on top of the core. A **task** carries one or more **questions**, and each question carries one or more **answer-skeletons** — the parser's variable-bearing query, itself a `sem-graph` (§2.1) whose conjunct edges hold `(var Name)` slots. Alternative readings of one question are simply several skeletons.

| Fact | Meaning |
|------|---------|
| `(qa-task T)` | Declares task `T`. |
| `(qa-question T Q)` | Question `Q` belongs to task `T` (≥1; paraphrase variants share the task). |
| `(question-surface Q "…")` | The question's surface text, kept for reporting. Nothing reads it as structure — the query shape is the skeleton. |
| `(answer-skeleton Q GAS)` | Skeleton graph `GAS` is one reading of `Q`. `GAS` is a `sem-graph` of kind `answer-skeleton` whose `sem-edge`s carry `(var Name)` slots. |
| `(answer-skeleton-tv GAS tv)` | The query's truth-value pattern — usually the open `(var tv)`; a why-*not* question pins it, e.g. `(STV 0.0 (var conf))`. |

**No gold answers, and no stored answers.** Answering *is* grounding: the grounder solves a skeleton against the derived graph in the run space, and a solution is the fully-grounded conjunct list — every element a cited `sem-edge`, so provenance is built in. Nothing writes a candidate answer, a class, or a score back as a fact; the evaluator reads the groundings and mints (§2.8). Answer **plurality and depth come from the genome**, never from the query shape — a question licenses one sought relation, and how many ways it grounds depends on what the rules derived. **Abstention** is likewise structural: a skeleton with no grounding earns nothing, and no rule is needed to produce it.

### 2.8 Clamp config (the evaluator's reward regime)

> **Status note:** MSC §4.4 defines clamps *functionally* (a token source tied to a desired output class; minting score eq 17; scalar→typed-fuel conversion; chamber-local scope) but prescribes **no data representation** — the §6.1 portable-facts example contains no clamp/evaluator facts. The shapes below are **our design choice**, consistent with the portable-facts discipline: a clamp = a *parameterization of eq 17* stored as facts; the eq-17 term computations (Match, CausalClarity, …) are evaluator-worker **code**, not facts. **The worker-IR these sit alongside has a canonical source** (`docs/Goal-Guided…pdf` §20.2 + App A.3.2 — see §2.5), but **clamps specifically are not covered there** (MSC-specific), so these shapes have no external source to reconcile against and stand as our own.

| Fact | Meaning |
|------|---------|
| `(clamp CL)` | Declares clamp `CL`. |
| `(clamp-mint CL achievement token n)` | **Achievement-typed minting** (MSC §4.4 verbatim: *"the kind of good behavior shapes the kind of fuel earned"*). A grounding's achievements are detected structurally by the evaluator — `skeleton-match` for every grounding, `transitive-explanation` when the cited derivation is a chain — and this map says what each mints. One fact per (achievement, token); an achievement a clamp does not list mints nothing under it. Match is **binary per grounding**, so plurality pays per solution rather than being averaged into one score. |
| `(clamp-scope CL C)` | Chamber-local scoping (MSC: "clamping can also be local"). |
| `(worker-clamp W CL)` | The active clamp for a run — the experimental switch. A paired clamp-switch run = same snapshot+budget, different `worker-clamp`. |

**The clamp-switch is typed, not class-based.** Swapping the clamp changes *which token* a behaviour earns, and a rule starves when the token it spends stops being minted — so selection acts through the metabolism rather than through an answer-class filter. Exp-1's pair differ in exactly one fact: both mint `skeleton-match`, only the deep clamp mints `transitive-explanation`, and the chaining rule spends that token.

### 2.9 ACS detection + promotion (Experiment-1 layer; P2 output)

P2 (= TECAN T3, to be rebuilt on the sem-graph pipeline) certifies whether a rule loop is a **mortal semantic ACS** (the 5 conditions of MSC / TECAN eq 67) and promotes it only if it earns its keep. Outputs (written by the ACS-detector, not the soma):

| Fact | Meaning |
|------|---------|
| `(acs A)` / `(acs-chamber A C)` | Declares detected ACS `A` in chamber `C`. |
| `(acs-member A R)` | Rule `R` is a member of the ACS's (heritable) rule loop. One per rule. |
| `(acs-closure A kind)` | The structural-closure verdict (§4.5 cond 1), emitted **only when the set is genuinely closed** — every member lies on a member-to-member feeds cycle **and** has its whole **non-food premise injectively regenerated** by member products (each non-food premise clause matched to a *distinct* member product; a clause no member produces is food and exempt). The evaluator's minting edge is **FOOD, not closure**. `kind` ∈ `substrate` (the loop regenerates semantic domain motifs only) · `control` (only internally-generated control motifs — see `control-relation`) · `hybrid` (it alternates between the two). A **subsidized / food-fed candidate is NOT an ACS** (it fails closure), so it emits **no** `acs-closure` fact — that state is inferred as *metabolic surplus present + no `acs-closure`*. The injective test is what keeps a *contracting* self-loop (two premise clauses of a relation, one product of it) from passing as a closed singleton, while admitting a balanced singleton that regenerates its own catalyst. |
| `(acs-autocatalytic A bool)` | Condition 2: every member is enabled by a motif or token that lies **on** the loop's own cycle — the loop catalyzes itself. Checked per member, independently of how membership was found. |
| `(acs-surplus A CL token n)` | Metabolic surplus `E[minted]−E[spent]` for `token` under clamp `CL` (signed). Condition 3 holds iff positive componentwise. |
| `(rule-do-influence R target answer-reward tasks n)` | Per-rule causal coding (SC §3.7): the **leave-one-out** paired replay — the drop in *cumulative* minted reward when rule `R` alone is suppressed, against an unablated run of the same length, same snapshot / budget / context. `tasks` is the **window** it was measured over, and is part of the claim: a strategy that primes itself for the *next* arrival reads `0` over one task and load-bearing over two, and both readings are true of their own window. The scan uses the task sequence the observed log served, **capped by `(acs-window-max n)`** (config, default 3), so the replay pairs with the run being certified on a short log and stays bounded on a long one — past the task where the ablated and unablated trajectories separate each further one only adds a constant, so a bigger window rescales the delta without adding information. Each replayed task is **worked to settle**, not run for a fixed number of cycles, bounded by `(acs-replay-cycles n)` (config, default 20) as a runaway guard: a replay cut short never reaches the part of the derivation the baseline was measured over, and the pairing that makes the number mean anything is lost. Emitted per ACS member. |
| `(rule-redundancy R cycles bool)` | `True` iff that rule's do-influence over `cycles` is `0` — suppressing `R` alone leaves the reward unchanged, so `R` contributes nothing *on that horizon*. Carries the window for the same reason. |
| `(acs-heritable A GNM)` | The loop reifies as quoted genome `GNM`, copy-and-re-expressible. |
| `(acs-recurrent A bool)` | The loop's members all fire in ≥ `acs-recurrence-min` distinct cycles of the event log (recurrent species, not a one-epoch candidate). |

*No single "promoted / certified" verdict is stored — each condition above is its own fact. "Certified ACS under clamp `CL`" is the conjunction a consumer computes: `acs-closure` present ∧ every `acs-surplus …CL… > 0` ∧ `acs-causal-influence True` ∧ `acs-recurrent True`. The clamp-switch shows in `acs-surplus` — the same loop's token surplus is positive under one clamp, negative under another.*

**Relation-level declarations** these read — properties of a *relation*, not of a rule or an edge:

| Fact | Meaning |
|------|---------|
| `(control-relation Rel)` | `Rel` is an internally-generated **control** state (attention shift, activation, success trace, reusable template, learned gate) rather than a semantic domain motif. Read by the closure classifier to label `acs-closure` `substrate` / `control` / `hybrid`. An externally-supplied marker is food, not an endogenous control motif, and is left undeclared. |

### 2.10 Lineage + reproduction (Experiment-1 layer; P3 output)

P3 (= TECAN T6, to be rebuilt on the sem-graph pipeline) mutates / recombines the promoted ACS's quoted genome, selects by surplus under matched replay, and reproduces. Lineage outputs:

| Fact | Meaning |
|------|---------|
| `(lineage L)` / `(lineage-founder L GNM)` | A lineage `L` rooted at founder genome `GNM`. |
| `(genome-rule GNM R)` | Member rule `R` of genome `GNM` (the heritable ruleset; one per rule). |
| `(genome-fitness GNM CL token n)` | Fitness of `GNM` under clamp `CL` = metabolic surplus for `token` (signed), under matched replay. |
| `(birth GNM_child GNM_parent mutation)` | `GNM_child` was produced from `GNM_parent` by `mutation` (e.g. pruning a member rule). |
| `(birth-cost GNM_child token n)` | Reproduction cost the parent paid from surplus — incl. the `tau_dequote` germ→soma dequotation (eq 27). |
| `(lineage-improvement GNM_parent GNM_child token n)` | Signed fitness change child−parent under matched replay. Selection keeps `n>0`. |

---

## 3. Fuel-gated firing semantics (what the P0 kernel does with these facts)

One kernel **step** (MSC §4.3, eqs 13–16):

1. **Enumerate candidates** — for the chamber `C`, for each organism `O` in `C`, for each hot rule `R` (`chamber-hot-rule C R` ∧ `ruleset-member`(genome of `O`)`R`) whose `rule-context` is satisfied by `C`'s `chamber-context` facts, find every match `θ` of `rule-lhs R` against the chamber graphs `X`. **Candidate enumeration order MUST be canonical** (sort by `R` id, then a canonical serialization of `θ`) — see §4.
2. **Fuel filter** — keep candidate `(R,θ)` only if `F_O ≥ κ_R` componentwise: for every `(rule-token-cost R t n)`, the organism has `(fuel O t m)` with `m ≥ n`.
3. **Score + sample** — compute `Gate_C(R,O,X)` (MSC eq 24: strength, confidence, do-influence, novelty, −redundancy, −cost, +FuelMargin, +ACSBoost). Draw `U` from the seeded PRNG; the rule fires if `U < Gate` (or pick the arg-max candidate — P0 may start with deterministic arg-max and add sampling later, as long as it stays seed-deterministic). *(`petta/gate.metta`: `gate-score` computes eq 24 over the declared `(gate-coeff k v)` terms — do-influence, ACS boost, fuel margin, flat cost; plausibility/novelty/redundancy await their data — and `gate-open?` applies the deterministic-threshold reading against `(gate-threshold u)`; PRNG sampling from `(seed …)` is not modelled.)*
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

## 6. Beyond the P0 kernel (later stages)

- **Evaluator-minted fuel + clamps** → P1 (`petta/evaluator.metta`): eq-17 scoring, clamp-gated typed-fuel minting (never soma-minted), and the chamber↔evaluator epoch loop that credits earned fuel back, closing the metabolic loop. The clamp-switch flips which strategy runs a surplus (§2.8).
- **ACS detection + metabolic surplus + causal replay** → P2 (= TECAN T3): builds the rule-motif graph from the log, mines the closed self-recreating component, certifies the mortal-ACS conditions (structural closure — **endogenous**, substrate/control/hybrid; autocatalysis; componentwise surplus; causal influence by replay ablation; recurrence over the cycle-tagged log), and breaks causal influence down per member (SC §3 leave-one-out do-influence + redundancy). Heritability is P3. Facts in §2.9.
- **Genome mutation / reproduction** → P3 (= TECAN T6, to be rebuilt on the sem-graph pipeline): mutates / recombines the quoted genome as data, expresses member rules via `run-ablate` by membership, scores offspring by surplus under matched replay, and reproduces (surplus-funded, token-gated dequotation). Selection prunes inert members (those the per-rule do-influence measures at zero) and rejects loop-breaking mutations; recombination rescues complementary defective genomes; under `CL_goal` the founder cannot afford to reproduce. Facts in §2.10.
- **Multiple workers, reducers, ECAN epochs** → P4.
- **MeTTa-IL executor** → later; the whole point of this schema is that it drops in by log-equivalence, not rewrite.

---

## 7. Files

- `schema.md` — this spec (authoritative).
- **Worked examples** (load + round-trip in PeTTa) — the Experiment-1 fixtures:
  - `../experiments/expt1-causal-qa/{molecules,tasks,configs}.metta` — the IR (the V3 vignette): semantic graphs · QA tasks (questions only; the evaluator derives the target from the graph) · clamps + chamber/organisms/snapshot. Loaded together by `load.metta`.
  - `../experiments/expt1-causal-qa/rules.metta` — the genome: the four causal-QA rules as canonical per-match `rule-lhs`/`rule-rhs` IR with `(var Name)` markers (§2.2).
- **Reference engine** over these facts: `../petta/` — the engine (`util`/`fuel`/`compiler`/`gate`/`reaction`), the solve layer (`grounder`/`evaluator`), the metabolic `epoch` loop, the `acs` detector, and the worker layer (`worker` envelope + `chamber`/`ecan`/`reducer` bodies + `dispatch`); exercised by `../tests/` (`sh tests/run_suite.sh`).

See the corpus these rules come from: `experiments/fiction-world-v0/` (world_rules R1–R5 = Cycle A).
