# `petta/` — the Mortal Semantic Chemistry stack in PeTTa

This directory is the **executable Mortal Semantic Chemistry stack** (P0–P4) on the PeTTa backend, running the **canonical per-match form**. The reference for correctness is **Ben's `docs/` PDFs**.

A rule's **source of truth** is the backend-neutral **canonical IR** in `../experiments/expt1-causal-qa/rules.metta` — separate `rule-lhs`/`rule-rhs` facts with `(var Name)` markers, in pure per-match `C ^ G1 ==> G2` form (MSC §2.1, §4.3 eq 12–16: one firing per match θ, `X' = X ⊕ θ(G2)` set-union). The **engine** (`kernel_defs.metta`) holds a **converter** that, at genome-expression time, mints co-referent PeTTa match-vars and assembles each rule into a runnable form, plus a generic data-driven `run-rules` that walks the rules in `rule-priority` order, fuel-gating each firing. So `petta/` = **logic** (engine + converter + run + evaluator + worker kinds); `experiments/<expt>/` = **facts** (molecules · tasks · configs · the genome `rules.metta`).

**Suite: 75 tests green** across the modules below.

## Status (P0–P4, canonical per-match)

- ✅ **P0 unified mortal kernel** (`kernel.metta`, 10 ✅) — the generic engine drives the genome expressed from its canonical IR. Seeded gm 19 / ci 7 it exhibits **P0 mortality: 19 firings, 5 answers, Q7b STARVES** (aligned but unprojected). Per-match: `R_align` fires once **per edge** (7 cites; Q23 cites k1 *and* k2 separately); **abstain is no soma rule** (Q20 produces nothing — the alignment rule simply doesn't match its focus); set-add dedups the shared alignment head.
- ✅ **P1 evaluator** (`evaluator.metta`, 6 ✅) — eq-17 **Match** scoring (`covered²/(skel·ans)`, `floor-math` mint round) + the **clamp-switch**: gm-income flips **25 (physical) ↔ 16 (intentional)**. `Q3a` mint 3 (Match 0.5), `Q23` 6 (2/2). **Abstain is the evaluator's job now**: `abstain-income` mints 4 for a gold-abstain question the soma left unanswered (gated by `typed?`, so a broken genome earns no spurious abstain reward).
- ✅ **P4.2 worker ecology** (`workers.metta`, 10 ✅) — **separate-space-per-worker** isolation (chosen on the `spaces_behavior.metta` battle-test): each `context-chamber` worker gets its own `(new-space)`; the read-only IR stays shared in `&self`; the engine is `$ws`-parameterized. Two workers over the same IR, different fuel snapshots → isolated mortal trajectories (`W_full` gm 20/ci 7 → 20 firings/6 answers; `W_lean` gm 8 → starves at 8/0), and a `reducer` merges their summaries (28 firings, 6 answers).
- ✅ **P4.3(i) ecan-epoch** (`ecan_epoch.metta`, 6 ✅) — the **P1 metabolic-closure loop**: run → score+mint+credit → re-run while there's progress + fuel (re-run-safe via the fire-once `walk` + seq threading). At a constrained seed (gm 15): feedback **OFF** = 1 answer, 15 firings, starves; **ON** = **6 answers, 20 firings, ends at gm 16 (surplus)** — minting funds the further answers and the loop pays its own way.
- ✅ **P4.3(ii) acs-scan + replay** (`acs_scan.metta`, 14 ✅) — the **P2 mortal-ACS certification**. *Ablation* (cond 4): suppress one rule in its own space (generous fuel → structural) — base 6 answers; R_qtype/R_align/R_project load-bearing (→0/0/0), **R_complete INERT (→6, 0 impact)** = the dead-weight rule P3 prunes. *Closure* (cond 1+2): reachability on the rule-motif graph — a closed metabolic cycle exists **only with the evaluator's E→fuel edge** (True), not among the soma rules alone (False) ⇒ closure is *metabolic*. *Surplus* (cond 3) + *promotion*: income − spend = **+5 under CL_antecedent vs −4 under CL_goal**; the same loop is **PROMOTED under one clamp, REJECTED under the other** (clamp-switch at the ACS level).
- ✅ **P4.3(iii) selection-epoch** (`selection.metta`, 9 ✅) — the **P3 lineage**. Express a genome = run only its member rules (generic `run-ablate` skipping the non-members); fitness = metabolic surplus. Founder {qtype,align,complete,project} = **+5**; **pruning the inert R_complete → +6** (the unique fitter) so selection rediscovers it and the lineage steps GNM_qa(+5) → GNM_g1(+6); pruning any load-bearing rule collapses surplus (R_qtype 0, R_align −2, R_project −10). **Recombination** of two answer-incapable genomes (one missing R_project, one missing R_qtype) → the union genome is **viable again (6 answers)**.
- ✅ **P4.4 backend-rendering** (`backend_render.metta`, 6 ✅) — the worker IR is backend-neutral portable facts: the same IR (a) renders to a call spec **identical under a `petta` and a `metta-il` tag** (the eq-30 idea — only the executor differs); (b) satisfies the §5 checklist (deterministic step budget, not wall-clock; backend provenance); (c) drives the PeTTa executor to **exactly the log it specifies** (IR → backend → the 19-firing P0 log).

## Run

```sh
# from the repo root; the PeTTa runner is the sibling ../PeTTa/run.sh
sh ../PeTTa/run.sh petta/kernel.metta < /dev/null 2>&1 | grep should   # ten ✅
```

## Files

| File | What |
|------|------|
| `kernel_defs.metta` | the generic **ENGINE** (facts-free, `$ws`-parameterized, re-run-safe): fuel ledger · componentwise affordability · gated fire + event log · the per-rule `walk`; **the canonical-IR interpreter** (`clause-join`/`rule-cands`); **the converter** (`to-vars`/`express`/`convert-rule` — `(var Name)` → co-referent match-vars); and the generic data-driven **`run-rules`** / **`run-ablate`** (walk rules by `rule-priority`, optionally skipping a set). Set-semantics `add-all` (the doc's ⊕). NO domain logic, NO data. No test of its own; exercised via the others. |
| `kernel.metta` | **P0** — the unified mortal kernel demo (per-match, mortality, Q7b starves); 10 tests |
| `evaluator.metta` | **P1** — eq-17 Match scoring + the clamp-switch (25/16) + abstain-via-evaluator; 6 tests |
| `evaluator_defs.metta` | **shared evaluator body** — the `$ws`-parameterized eq-17 scoring on the canonical product shapes (`covered`/`anssize`/`skelsize`/`would-mint`/`gm-income`/`abstain-income`/`gm-spend`/`count-answers`), imported by ecan/acs/selection (no test of its own) |
| `workers.metta` | **P4.2** — the §6.4 worker contract + dispatcher + separate-space-per-worker isolation + a `reducer`; 10 tests |
| `ecan_epoch.metta` | **P4.3(i)** — the metabolic-closure epoch loop (run → score+mint+credit → re-run); 6 tests (OFF 1 / ON 6 + surplus) |
| `acs_scan.metta` | **P4.3(ii)** — the P2 ACS certification: ablation (R_complete inert), metabolic-closure reachability, surplus +5/−4, promotion clamp-switch; 14 tests |
| `selection.metta` | **P4.3(iii)** — the P3 lineage: express a genome by membership, fitness = surplus, prune-R_complete is the fitter (+5→+6), recombination rescues; 9 tests |
| `backend_render.metta` | **P4.4** — backend-neutrality: same worker IR → spec (petta ≡ metta-il), §5 checklist, IR → PeTTa → the specified log; 6 tests |
| `engine.metta` | a **standalone engine-mechanism demo** — a fuel-gated firing loop (fire/debit/log/starve) hand-written on R_qtype; reads only data facts; 3 tests |
| `spaces_behavior.metta` | **multi-space battle-test / regression guard** — 11 tests proving fresh `(new-space)`s join under nested match (unlike `&mork`), join *across* spaces, and that handles are storable in facts; informed the P4.2 isolation choice |

**Data is not in `petta/`.** The experiment's IR is pure portable facts under `../experiments/expt1-causal-qa/` (`molecules` · `tasks` · `configs` · the genome `rules.metta`); a runnable file imports those four fact files (or the convenience `load.metta`) plus the engine. This is the clean cut: `petta/` = logic, `experiments/<expt>/` = facts.

## Why `&self` (not `&mork`)

`&mork`'s `match` (current MORK FFI) **cannot join**: a nested `&mork` match cross-products (the inner ignores the outer-bound var) and compound result-templates lose bindings. So derivation runs in `&self` (where nested `match` joins correctly), with each worker's mutable state in its own native `(new-space)`. MORK-accelerated conjunctive matching needs a `query-multi` FFI primitive (deferred). Other PeTTa idioms in play: `case`-over-`collapse` = fire-once dedup + negation; runtime var-minting in the converter; `&self` doesn't dedup so the engine uses set-semantics add; a failing `!(test)` aborts the file.

**Refinement (P4.2, `spaces_behavior.metta`):** the no-join limitation is specific to the `&mork` FFI — *native* fresh `(new-space)`s join under nested match exactly like `&self`, and even join *across* spaces. That cross-space join is what lets the worker ecology keep the read-only IR shared in `&self` while each worker holds its mutable state in its own space.
