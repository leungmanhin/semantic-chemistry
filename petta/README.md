# `petta/` — the Mortal Semantic Chemistry engine (PeTTa backend)

The reusable, **facts-free logic** of the Mortal Semantic Chemistry stack on the PeTTa backend, in the **canonical per-match form**. The reference for correctness is **Ben's `docs/` PDFs**.

The clean cut across the repo:
- **`petta/` = logic** — the engine (`util`/`fuel`/`compiler`/`gate`/`reaction`), the evaluator body, the worker layer (`persist`/`chamber`/`reducer`/`workers`), and the P1–P3 mechanism modules (`acs`/`ecan`/`selection`), imported by the suite (this directory).
- **`../tests/` = the suite** — the P0–P4 stage demos, each with its own `!(test …)` assertions (run with `sh tests/run_suite.sh`; 120 tests green).
- **`../experiments/<expt>/` = facts** — molecules · tasks · configs · the genome `rules.metta`.

A rule's **source of truth** is the backend-neutral **canonical IR** in `../experiments/expt1-causal-qa/rules.metta` — separate `rule-lhs`/`rule-rhs` facts with `(var Name)` markers, in pure per-match `C ^ G1 ==> G2` form (MSC §2.1, §4.3 eq 12–16: one firing per match θ, `X' = X ⊕ θ(G2)` set-union). The engine converts this to a runnable form at genome-expression time and walks the rules in `rule-priority` order, fuel-gating each firing.

## Files

| File | What |
|------|------|
| `util.metta` | generic **list/term helpers** (no domain, no facts): `filter-out` · `concat-lists` · `in-list?` · `dedup` · `map-snd` · `all-ge` · `len`. Loaded first; the other modules build on these. |
| `fuel.metta` | the per-organism typed-fuel **LEDGER** + organism-purse resolution — `fuelof`/`afford`/`debit`/`debit-all` on `(fuel O tok n)` (schema §2.3), and `rule-organism`/`the-organism` (a rule → its owning organism via ruleset membership). The metabolic substrate the engine spends on; the growth home for the token economy. Degenerate (single purse) on single-organism Exp-1. |
| `compiler.metta` | **rules-as-data**: the canonical-IR **converter** (`to-vars`/`express`/`convert-rule` — `(var Name)` → co-referent match-vars, `rule-lhs`/`rule-rhs` → a runnable `(crule …)`) + the match **enumerator** (`clause-join`/`rule-cands`). |
| `gate.metta` | the per-candidate fire **DECISION** (MSC eq 24 / §3 step 3): `gate?` = `rule-eligible?` ∧ `afford` ∧ `attn-ok?`; the **context gate** (`rule-eligible?` — a rule reaches the walk only if its `rule-context` is a declared `chamber-context`), the **typed-attention gate** (`attn-ok?` over `(attention R tok v)`), and `sorted-rules` (eligible rules by `rule-priority`). Attention/gate are degenerate on single-organism Exp-1. |
| `reaction.metta` | the firing **ENGINE** (`$ws`-parameterized, re-run-safe): set-semantics `add-all` (the doc's ⊕) · `fire` + event log (`log-facts` reads the ordered log back) · fire-once `walk` · the generic data-driven **`run-rules`** / **`run-ablate`** (walk by `rule-priority`, optionally skipping a set). Every stage runs its genome through this. NO domain logic, NO data. |
| `evaluator.metta` | the shared **evaluator body** — the `$ws`-parameterized eq-17 **Match** scoring on the canonical product shapes (`covered`/`idealsize`/`would-mint`/`gm-income`/`abstain-income`/`gm-spend`/`count-answers`), the target **derived from the graph** (no gold). |
| `persist.metta` | the worker **OUTPUT contract** — the write primitive (`facts->text`/`spit`/`write-facts`: `repr` → `pathlib.write_text`, a re-loadable `.metta` file, no shell) + the §6.4 envelope helpers a worker body uses: `log-path`, `persist-log` (write the ordered event log to `runs/<log-id>.metta` iff a `worker-output-log` is declared), `emit-summary` (the per-worker summary facts), and `persist-facts` (write an explicit verdict fact-list, gated on a declared `worker-output-facts`). |
| `chamber.metta` | the **context-chamber worker body** (`worker-kind context-chamber`) — `run-cc`: own space · snapshot fuel into the organism's purse · run the reaction · persist its output log · summarise to `&self`. |
| `reducer.metta` | the **reducer worker body** (`worker-kind reducer`) — `run-reduce`: a deterministic merge of the per-worker summaries into `(reduced …)` facts. |
| `workers.metta` | the **§6.4 worker DISPATCHER** — `dispatch` (a `case` on `worker-kind`) routes a worker to its body module: `context-chamber`→`chamber`, `reducer`→`reducer`, `acs-scan`→`acs`, `ecan-epoch`→`ecan`, `reproduction`→`selection`. The switchboard only; bodies + envelope helpers live in their own modules. Used by `workers_test` + `worker_kinds_test`. |
| `acs.metta` | the **P2 ACS logic** — ablation, graph reachability, surplus, and the **log-miner** (derive the reaction graph from the event log + rule IR, then discover the ACS = the rules on a metabolic cycle). The **acs-scan worker body** `run-acs` emits the §2.9 verdict facts (`acs-member`/`acs-closure`/`acs-surplus`/`acs-promoted`) to `&self` and persists them. Used by `acs_scan_test` + `acs_mine_test` + `worker_kinds_test`. |
| `ecan.metta` | the **P1 metabolic-closure epoch loop** — run → score+mint+credit → re-run while progress + fuel. The **ecan-epoch worker body** `run-epoch` runs it as a dispatched worker. Used by `ecan_epoch_test` + `worker_kinds_test`. |
| `selection.metta` | the **P3 lineage operators** — express a genome (run only its member rules), prune / recombine, surplus-based `fitter`. The **reproduction worker body** `run-select` runs one lineage step and emits the §2.10 verdict facts (`genome-fitness`/`birth`/`lineage-improvement`). Used by `selection_test` + `worker_kinds_test`. |
| `demo.metta` | a **utility** (not a test) — an end-to-end **demo** of the whole pipeline on Exp-1 (V7 "Why did Maria drive?" as the running example), one banner per stage, each calling the real module: STAGE-0 the chamber · STAGE-1 P0 reaction (`reaction`) · STAGE-2 the §6.4 worker (`chamber`/`workers`) · STAGE-3 eq-17 minting + clamp-switch (`evaluator`) · STAGE-4 metabolic closure (`ecan`) · STAGE-5 ACS detection (`acs`) · STAGE-6 selection (`selection`). `sh ../PeTTa/run.sh petta/demo.metta < /dev/null 2>&1 \| sed 's/\\x1b\[[0-9;]*m//g' \| sed -n '/STAGE-0/,$p' \| grep '^('` |

None of these logic modules carry data or a test of their own — each is a facts-free def collection that assumes the engine/evaluator is loaded by the consumer, and is exercised by the matching `*_test.metta` in `../tests/`.

## Why `&self` (not `&mork`)

`&mork`'s `match` (current MORK FFI) **cannot join**: a nested `&mork` match cross-products (the inner ignores the outer-bound var) and compound result-templates lose bindings. So derivation runs in `&self` (where nested `match` joins correctly), with each worker's mutable state in its own native `(new-space)`. MORK-accelerated conjunctive matching needs a `query-multi` FFI primitive (deferred). Other PeTTa idioms in play: `case`-over-`collapse` = fire-once dedup + negation; runtime var-minting in the converter; `&self` doesn't dedup so the engine uses set-semantics add; a failing `!(test)` aborts the file.

**Refinement (`../tests/spaces_behavior_test.metta`):** the no-join limitation is specific to the `&mork` FFI — *native* fresh `(new-space)`s join under nested match exactly like `&self`, and even join *across* spaces. That cross-space join is what lets the worker ecology keep the read-only IR shared in `&self` while each worker holds its mutable state in its own space.
