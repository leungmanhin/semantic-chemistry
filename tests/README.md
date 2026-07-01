# `tests/` — the Mortal Semantic Chemistry suite (P0–P4 demos-cum-tests)

Each file loads the Exp-1 data (`../experiments/expt1-causal-qa/`) + the engine (`../petta/`) and carries its own `!(test …)` assertions — so it **both demonstrates** a stage of the stack **and verifies** it. A failing `!(test)` prints `is X, should Y. ❌` and halts that file (`../../PeTTa/src/metta.pl`). The reference for correctness is **Ben's `docs/` PDFs**.

## Run

```sh
sh tests/run_suite.sh              # from the repo root (or anywhere in the repo)
```

Runs every `tests/*.metta` from the repo root (imports are repo-root-relative), tallies ✅/❌ per file, and exits non-zero on any failure. **Suite: 95 tests green.** One file at a time:

```sh
sh ../PeTTa/run.sh tests/kernel.metta < /dev/null 2>&1 | grep should
```

## The stages

- ✅ **P0 unified mortal kernel** (`kernel.metta`, 10) — the generic engine drives the genome expressed from its canonical IR. Seeded gm 27 / ci 7 it exhibits **P0 mortality: 27 firings, 5 answers, Q7b STARVES**. Per-match: `R_align` fires once **per edge** (7 cites; Q23 cites both causes separately); abstain is no soma rule (Q20 produces nothing); set-add dedups the shared alignment head.
- ✅ **P1 evaluator** (`evaluator.metta`, 6) — eq-17 **Match** scoring (graph-derived: `Match = covered/idealsize`) + the **clamp-switch**: gm-income flips **25 (physical) ↔ 16 (intentional)**. `Q3a` mint 3 (via the transitive-`CauseOf` ideal), `Q23` 6. Abstain is the evaluator's job (`abstain-income` mints 4 for a question whose graph-ideal is empty).
- ✅ **P4.2 worker ecology** (`workers.metta`, 10) — **separate-space-per-worker** isolation: each `context-chamber` worker gets its own `(new-space)`, IR stays shared in `&self`. Two workers, different fuel snapshots → isolated trajectories (`W_full` gm 28 → 28/6; `W_lean` gm 8 → 8/0), a `reducer` merges them (36 firings, 6 answers).
- ✅ **P4.3(i) ecan-epoch** (`ecan_epoch.metta`, 6) — the **metabolic-closure loop**: run → score+mint+credit → re-run. At a constrained seed (gm 23): **OFF** = 1 answer / 23 firings / starves; **ON** = **6 answers / 28 firings / ends gm 16 (surplus)** — minting funds the further answers.
- ✅ **P4.3(ii) acs-scan + replay** (`acs_scan.metta`, 16) — the **P2 ACS certification** on a hand-given candidate: ablation finds `R_complete` inert; closure = reachability (a metabolic cycle exists only with the evaluator's E→fuel edge); surplus = full-genome **DEFICIT −3** vs certified **CORE +6 / −3** (clamp-switch → promote one, reject the other).
- ✅ **P4.3(iii) selection-epoch** (`selection.metta`, 9) — the **P3 lineage**. Express a genome = run only its member rules; fitness = surplus. Founder **−3** (inert R_complete → deficit); **pruning R_complete → +6** (the only viable genome), lineage GNM_qa(−3) → GNM_g1(+6). Recombination rescues two answer-incapable genomes → viable (6 answers).
- ✅ **P4.4 backend-rendering** (`backend_render.metta`, 6) — backend-neutrality: the same worker IR renders identically under a `petta` and a `metta-il` tag (eq-30), satisfies the §5 checklist, and drives PeTTa to exactly the log it specifies.
- ✅ **context gate** (`context_gate.metta`, 6) — the generic **`rule-context` gate** (`kernel_defs`: `rule-eligible?`). Two synthetic rules (defined in the test, not the Exp-1 data) with identical LHS but different context — one a declared `chamber-context` (admitted, fires), one not (rejected, never fires) — exercise **both** branches of the gate, including the reject branch single-context Exp-1's own data can't reach.
- ✅ **ACS log-mining** (`acs_mine.metta`, 12) — **identify + confirm** the ACS by analyzing the event log. Derives the reaction graph generically from the fired rules' canonical IR (consumed/produced heads + fuel + the evaluator's closing edge), then **discovers** the ACS = the rules on a metabolic cycle (reach gm). `R_complete` falls out **structurally** — its `role-fill` is consumed by nothing, so it never reaches fuel — no ablation needed. Closure is metabolic (cycle only with the evaluator edge); the discovered core spends 19 and runs **+6** surplus.
- ✅ **engine demo** (`engine.metta`, 3) — a standalone fuel-gated firing loop (fire/debit/log/starve) hand-written on `R_qtype`; reads only data facts.
- ✅ **spaces battle-test** (`spaces_behavior.metta`, 11) — the regression guard proving fresh `(new-space)`s join under nested match (unlike `&mork`), join *across* spaces, and that handles are storable in facts; informed the P4.2 isolation choice.

Data is **not** here — the experiment's IR is pure portable facts under `../experiments/expt1-causal-qa/`; the reusable engine + evaluator body are in `../petta/`.
