# `petta/` — the Mortal Semantic Chemistry engine (PeTTa backend)

The reusable, **facts-free logic** of the Mortal Semantic Chemistry stack on the PeTTa backend, in the **canonical per-match form**. The reference for correctness is **Ben's `docs/` PDFs**.

The clean cut across the repo:
- **`petta/` = logic** — the engine, the evaluator body, and the reusable P1–P3 mechanism modules (`acs`/`workers`/`selection`/`ecan`), imported by the suite (this directory).
- **`../tests/` = the suite** — the P0–P4 stage demos, each with its own `!(test …)` assertions (run with `sh tests/run_suite.sh`; 109 tests green).
- **`../experiments/<expt>/` = facts** — molecules · tasks · configs · the genome `rules.metta`.

A rule's **source of truth** is the backend-neutral **canonical IR** in `../experiments/expt1-causal-qa/rules.metta` — separate `rule-lhs`/`rule-rhs` facts with `(var Name)` markers, in pure per-match `C ^ G1 ==> G2` form (MSC §2.1, §4.3 eq 12–16: one firing per match θ, `X' = X ⊕ θ(G2)` set-union). The engine converts this to a runnable form at genome-expression time and walks the rules in `rule-priority` order, fuel-gating each firing.

## Files

| File | What |
|------|------|
| `kernel.metta` | the generic **ENGINE** (facts-free, `$ws`-parameterized, re-run-safe): a **per-organism** typed-fuel ledger (`fuel O tok n`, schema §2.3) · componentwise affordability · the **computed gate** `gate?` = `rule-eligible?` ∧ `afford` ∧ `attn-ok?` (MSC eq 24 / §3 step 3) driving fire + event log (`log-facts` reads the ordered log back) · the per-rule `walk`; **organism resolution** (`rule-organism`/`the-organism` — a rule → its owning organism via ruleset membership) and the **typed-attention gate** (`attn-ok?` over `(attention R tok v)`); the **canonical-IR interpreter** (`clause-join`/`rule-cands`); the **converter** (`to-vars`/`express`/`convert-rule` — `(var Name)` → co-referent match-vars); the **context gate** (`rule-eligible?` — a rule reaches the walk only if its `rule-context` is a declared `chamber-context`); and the generic data-driven **`run-rules`** / **`run-ablate`** (walk by `rule-priority`, optionally skipping a set). Set-semantics `add-all` (the doc's ⊕). The per-organism ledger, attention, and `gate?` are degenerate on single-organism Exp-1 — the attention dynamics and inter-organism economy are not modelled. NO domain logic, NO data. |
| `evaluator.metta` | the shared **evaluator body** — the `$ws`-parameterized eq-17 **Match** scoring on the canonical product shapes (`covered`/`idealsize`/`would-mint`/`gm-income`/`abstain-income`/`gm-spend`/`count-answers`), the target **derived from the graph** (no gold). |
| `acs.metta` | the **P2 ACS logic** — ablation, graph reachability, surplus, and the **log-miner** (derive the reaction graph from the event log + rule IR, then discover the ACS = the rules on a metabolic cycle). Used by `acs_scan_test` (certify a hand-given candidate) + `acs_mine_test` (discover it from the log). |
| `workers.metta` | the **§6.4 worker contract** — a dispatcher routing by `worker-kind` to a context-chamber body (own space · fuel from its snapshot · run the kernel · **persist its output log** to `runs/<log-id>.metta` when it declares a `worker-output-log` · summarise) or a reducer (merge summaries). Used by `workers_test`. |
| `selection.metta` | the **P3 lineage operators** — express a genome (run only its member rules), prune / recombine, surplus-based `fitter`. Used by `selection_test`. |
| `ecan.metta` | the **P1 metabolic-closure epoch loop** — run → score+mint+credit → re-run while progress + fuel. Used by `ecan_epoch_test`. |
| `demo.metta` | a **utility** (not a test) — an end-to-end **demo** of the whole pipeline on Exp-1 (V7 "Why did Maria drive?" as the running example), one banner per stage, each calling the real module: STAGE-0 the chamber · STAGE-1 P0 reaction (`kernel`) · STAGE-2 the §6.4 worker (`workers`) · STAGE-3 eq-17 minting + clamp-switch (`evaluator`) · STAGE-4 metabolic closure (`ecan`) · STAGE-5 ACS detection (`acs`) · STAGE-6 selection (`selection`). `sh ../PeTTa/run.sh petta/demo.metta < /dev/null 2>&1 \| sed 's/\\x1b\[[0-9;]*m//g' \| sed -n '/STAGE-0/,$p' \| grep '^('` |
| `persist.metta` | a small **I/O primitive** — write MeTTa atoms to a durable file as re-loadable bare facts via `py-call`: `repr` renders each atom to its S-expression, the lines are joined and written with `pathlib.write_text`. `facts->text` (render a list of atoms) · `spit` (write a string to a path) · `write-facts` (write a list of atoms). No shell, no runner trace to strip; the product is a `.metta` file that `import!` reads straight back. The worker uses it to write its output log. |

None of these logic modules carry data or a test of their own — each is a facts-free def collection that assumes the engine/evaluator is loaded by the consumer, and is exercised by the matching `*_test.metta` in `../tests/`.

## Why `&self` (not `&mork`)

`&mork`'s `match` (current MORK FFI) **cannot join**: a nested `&mork` match cross-products (the inner ignores the outer-bound var) and compound result-templates lose bindings. So derivation runs in `&self` (where nested `match` joins correctly), with each worker's mutable state in its own native `(new-space)`. MORK-accelerated conjunctive matching needs a `query-multi` FFI primitive (deferred). Other PeTTa idioms in play: `case`-over-`collapse` = fire-once dedup + negation; runtime var-minting in the converter; `&self` doesn't dedup so the engine uses set-semantics add; a failing `!(test)` aborts the file.

**Refinement (`../tests/spaces_behavior_test.metta`):** the no-join limitation is specific to the `&mork` FFI — *native* fresh `(new-space)`s join under nested match exactly like `&self`, and even join *across* spaces. That cross-space join is what lets the worker ecology keep the read-only IR shared in `&self` while each worker holds its mutable state in its own space.
