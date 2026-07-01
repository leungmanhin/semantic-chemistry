# `tests/` — the Mortal Semantic Chemistry suite (P0–P4 demos-cum-tests)

Each `*_test.metta` file loads the Exp-1 data (`../experiments/expt1-causal-qa/`) + the engine and its stage's logic module (`../petta/`), then wires a scenario + its own `!(test …)` assertions — so it **both demonstrates** a stage of the stack **and verifies** it. The *generic* mechanism lives in `../petta/` (`kernel` · `evaluator` · `acs` · `workers` · `selection` · `ecan`); the test file is thin (import + scenario + asserts). A failing `!(test)` prints `is X, should Y. ❌` and halts that file (`../../PeTTa/src/metta.pl`). The reference for correctness is **Ben's `docs/` PDFs**.

## Run

```sh
sh tests/run_suite.sh              # from the repo root (or anywhere in the repo)
```

Runs every `tests/*.metta` from the repo root (imports are repo-root-relative), tallies ✅/❌ per file, and exits non-zero on any failure. **Suite: 109 tests green.** One file at a time:

```sh
sh ../PeTTa/run.sh tests/kernel_test.metta < /dev/null 2>&1 | grep should
```

## The stages

- ✅ **P0 unified mortal kernel** (`kernel_test.metta`, 10) — the generic engine (`petta/kernel`) drives the genome expressed from its canonical IR. Seeded gm 27 / ci 7 it exhibits **P0 mortality: 27 firings, 5 answers, Q7b STARVES**. Per-match: `R_align` fires once **per edge** (7 cites; Q23 cites both causes separately); abstain is no soma rule; set-add dedups the shared alignment head.
- ✅ **P1 evaluator** (`evaluator_test.metta`, 6) — eq-17 **Match** scoring (`petta/evaluator`; graph-derived `Match = covered/idealsize`) + the **clamp-switch**: gm-income flips **25 (physical) ↔ 16 (intentional)**. `Q3a` mint 3 (via the transitive-`CauseOf` ideal), `Q23` 6. Abstain mints 4 for a question whose graph-ideal is empty.
- ✅ **worker ecology** (`workers_test.metta`, 10; logic `petta/workers`) — **separate-space-per-worker** isolation: each `context-chamber` worker gets its own `(new-space)`, IR shared in `&self`. Two workers, different fuel snapshots → isolated trajectories (`W_full` gm 28 → 28/6; `W_lean` gm 8 → 8/0), a `reducer` merges them (36 firings, 6 answers).
- ✅ **ecan-epoch** (`ecan_epoch_test.metta`, 6; logic `petta/ecan`) — the **metabolic-closure loop**: run → score+mint+credit → re-run. At a constrained seed (gm 23): **OFF** = 1 answer / 23 firings / starves; **ON** = **6 answers / 28 firings / ends gm 16 (surplus)**.
- ✅ **acs-scan + replay** (`acs_scan_test.metta`, 16; logic `petta/acs`) — the **P2 ACS certification** on a hand-given candidate: ablation finds `R_complete` inert; closure = reachability (a metabolic cycle exists only with the evaluator's E→fuel edge); surplus = full-genome **DEFICIT −3** vs certified **CORE +6 / −3** (clamp-switch → promote one, reject the other).
- ✅ **ACS log-mining** (`acs_mine_test.metta`, 12; logic `petta/acs`) — **identify + confirm** the ACS by analyzing the event log. Derives the reaction graph generically from the fired rules' canonical IR (consumed/produced heads + fuel + the evaluator's closing edge), then **discovers** the ACS = the rules on a metabolic cycle. `R_complete` falls out **structurally** — its `role-fill` reaches no fuel — no ablation. Closure metabolic; the discovered core spends 19, surplus **+6**.
- ✅ **selection-epoch** (`selection_test.metta`, 9; logic `petta/selection`) — the **P3 lineage**. Express a genome = run only its member rules; fitness = surplus. Founder **−3** (inert R_complete → deficit); **pruning R_complete → +6** (the only viable genome), lineage GNM_qa(−3) → GNM_g1(+6). Recombination rescues two answer-incapable genomes → viable (6 answers).
- ✅ **backend-rendering** (`backend_render_test.metta`, 6) — backend-neutrality: the same worker IR renders identically under a `petta` and a `metta-il` tag (eq-30), satisfies the §5 checklist, and drives PeTTa to exactly the log it specifies.
- ✅ **context gate** (`context_gate_test.metta`, 6) — the generic **`rule-context` gate** (`petta/kernel`: `rule-eligible?`). Two synthetic rules (defined in the test, not the Exp-1 data) with identical LHS but different context — one a declared `chamber-context` (admitted, fires), one not (rejected, never fires) — exercise **both** branches, including the reject branch single-context Exp-1's own data can't reach.
- ✅ **per-organism fuel + attention gate** (`tecan_shell_test.metta`, 14; logic `petta/kernel`) — the per-organism fuel ledger, attention state, and computed gate, degenerate on single-organism Exp-1. Synthetic organisms/rules exercise (1) **`rule-organism`** resolution via ruleset membership (two organisms resolve distinctly), (2) the **per-organism purse** — `afford`/`debit` hit the firing organism's own `(fuel O tok n)`, two organisms in one space stay **isolated**, and (3) the **computed gate** `gate?` = `rule-eligible?` ∧ `afford` ∧ `attn-ok?`, hitting the afford-fail and attention-below-threshold (cold-rule) **reject branches**. The full genome on O_qa's single purse is exercised by `kernel_test`.
- ✅ **engine demo** (`engine_test.metta`, 3) — a standalone fuel-gated firing loop (fire/debit/log/starve) hand-written on `R_qtype`; reads only data facts.
- ✅ **spaces battle-test** (`spaces_behavior_test.metta`, 11) — the regression guard proving fresh `(new-space)`s join under nested match (unlike `&mork`), join *across* spaces, and that handles are storable in facts; the basis for the worker-isolation choice.

Data is **not** here — the experiment's IR is pure portable facts under `../experiments/expt1-causal-qa/`; the reusable logic is in `../petta/`.
