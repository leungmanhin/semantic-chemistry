# `src/` — the Experiment-1 engine (P0 kernel · P1 evaluator · P2 ACS detection · P3 evolution)

`kernel.py` is the P0 stage of Mortal Semantic Chemistry: a **deterministic, replay-equivalent, fuel-gated chamber kernel** over the portable-facts IR (`../ir/schema.md`). It runs a **composing QA-strategy genome** — four rules whose products flow through a **live working state `X`**, so each stage feeds the next — as a mortal organism on the Experiment-1 causal-QA corpus.

This directory holds **four stages**: the **P0** kernel (`kernel.py`), the **P1** evaluator + clamps (`evaluator.py`) — scoring answers, minting typed fuel by clamp, closing the metabolic loop — **P2** ACS detection (`acs_detect.py`) — certifying the loop as a *mortal semantic ACS* and promoting it — and **P3** evolution (`evolve.py`) — mutating/recombining the genome and selecting by surplus. (P0=TECAN T1, P1=T2, P2=T3, P3=T6.)

## Run

```sh
python3 src/kernel.py      # P0: deterministic fuel-gated chamber, replay check
python3 src/evaluator.py   # P1: eq-17 scoring + clamp-switch + metabolic closure
python3 src/acs_detect.py  # P2: ACS detection + surplus + ablation + promotion
python3 src/evolve.py      # P3: genome mutation/recombination + selection by surplus
```

`kernel.py` loads `experiments/expt1-causal-qa/{molecules,tasks,configs}.metta` (the split IR) + `experiments/expt1-causal-qa/genome.metta` (organism), runs the chamber to quiescence-or-death, prints the staged pipeline trace + per-question status, **asserts replay equivalence**, and writes the event log to `runs/run_log.metta`. `evaluator.py` imports the kernel's firing core and runs the P1 experiments (below), writing `runs/run_log_p1.metta`. `acs_detect.py` consumes those runs to certify + promote the ACS, writing `runs/acs_p2.metta`.

## The composing pipeline (genome `GNM_qa`)

Each rule reads from the live `X` (including earlier rules' products) and writes new products into it. `rule-priority` enforces the stage order deterministically; data dependencies reinforce it.

```
 R_qtype (0)   q-word              -> (q-intent Q intent)            question-type detect + paraphrase-collapse
 R_align (1)   q-intent + edges    -> (alignment AL Q cls) + cites   causal-alignment (intent filters the class)
 R_complete(2) alignment + roles   -> (role-fill AL Role Filler)     role-completion (enrich the cause)
 R_project (3) alignment + roles   -> (candidate-answer Q A) + ...    answer-skeleton projection (final answer)
```

Maps to MSC Exp-1's expected ACS rules (§7.1). `paraphrase-collapse` is folded into `R_qtype` (it normalizes `why`/`what-made`/`how-come` → one intent). Still TODO: `compact-explanation-packer` (multi-hop mechanism compression — `R_align` currently cites the direct edge into the focus, not the full chain).

## What it demonstrates (the P0 definition-of-done, `../ir/schema.md` §4)

- **A composing strategy** — `q-intent → alignment → role-fill → candidate-answer` flows through `X`; this is the loop P2's ACS detection will look for.
- **Fuel-gated firing** with a **typed** fuel vector (`F_O ≥ κ_R` componentwise).
- **Append-only event log** (`event` / `event-spend` / `event-add`); the kernel's output re-ingests into PeTTa (all firings verified round-tripping).
- **Deterministic selection ⇒ replay equivalence** (re-run + compared; PASS).
- **Mortality** — the organism **starves mid-pipeline**: it answers 5 questions then runs out of fuel before projecting the last alignment.

Observed run: **20 firings** → Q17/Q20(abstain)/Q23/Q3a/Q7a all answered (Q7a yields **both** dual answers — `intentional` *and* `physical-cause` with `Experiencer=maria` from role-completion), and **Q7b is aligned-but-unprojected (starved)**. The intent filter is visible: `what-for` (Q7b) produced only the intentional alignment; `why` (Q7a) produced both classes.

## P1 — evaluator + clamps (`evaluator.py`)

P0 only *produces* answers; it never mints fuel (hard prohibition #1). P1 adds the **evaluator**, which runs *outside* the firing loop and does the three things the soma may not do for itself:

1. **Score** each `candidate-answer` against its gold skeleton(s) by a faithful subset of **MSC eq 17** (`Match − Unsupportedness − Redundancy`), with the **active clamp's** coefficients.
2. **Mint** typed fuel by the clamp's class (`clamp-class` / `clamp-token`) — off-class answers earn nothing, fabrication is penalized, correct abstention is honoured.
3. **Credit** that fuel back to the organism, so answering a question funds the next — turning the P0 feed-forward **chain** into a self-sustaining **mortal ACS**. The run is an epoch loop: `[chamber phase: fire_to_quiescence] → [evaluator: score+mint+credit] → repeat`, the two phases cleanly separated.

What it demonstrates:

- **The clamp-switch** (the headline). Same snapshot+seed+budget; swap `CL_antecedent` (rewards `physical-cause`) ↔ `CL_goal` (rewards `intentional`). The **per-class metabolic balance flips**: physical `+12`/intentional `−4` under antecedent, physical `−9`/intentional `+8` under goal — and at this calibration the **whole-organism surplus flips sign too** (`+4/+2` self-sustaining under antecedent vs `−5/−6` deficit under goal; this is what P2 certifies). Both clamps answer all 6 questions, so *only the minting differs* — **reward alone selects which reasoning strategy pays for itself** (order-independent).
- **eq-17 scoring is meaningful.** `Q3a` (the multi-hop mechanism) scores `Match=0.50` — the evaluator *measures* the known shortcut (R_align cites the direct edge, not the full chain → the missing `compact-explanation-packer`). `Q20` is `abstain-correct`; off-class answers score `0`.
- **Metabolic closure.** At a constrained seed the organism starves on seed fuel alone (`1/6`); with feedback the fuel it *earns* funds the rest (`6/6`, +6 firings). The loop is closed. (Under `CL_goal` the first affordable answer is physical → unrewarded → it cannot bootstrap; viability is clamp-coupled. This cascade is order-sensitive — the balance result above is not.)
- **Invariants:** minting is evaluator-only (no soma rule writes `answer-reward`/`reward-credit`); the full P1 run (chamber + evaluator) is **replay-equivalent** (asserted — identical event log + mints).

New evaluator-output facts (`../ir/schema.md` §2.7): `answer-score`, `answer-reward`, `reward-credit`, `log-clamp`. The clamp `clamp-token` map now mints an **operational** token (`tau_graph_match`) so minted fuel can re-fund firing.

## P2 — ACS detection + promotion (`acs_detect.py`)

P2 consumes the P1 run and asks whether the QA-strategy loop is a **mortal semantic ACS** — certifying the five conditions (`../ir/schema.md` §2.9; MSC/TECAN eq 67) and promoting it only if it earns its keep:

- **Closure & autocatalysis (the headline).** Built from the event log, the rule-motif graph over the **soma rules alone is a feed-forward DAG — no cycle** (the P0 chain). The cycle appears **only when the evaluator's fuel edge is added** (`E → fuel → rules`): one SCC of 15 nodes. So the loop closes **metabolically**, not graph-structurally — exactly the mortal-computation tweak.
- **Metabolic surplus.** `E[minted]−E[spent]` from the log: `CL_antecedent` `+4 tau_graph_match / +2 tau_causal` (self-sustaining) vs `CL_goal` `−5 / −6` (deficit).
- **Causal influence (paired-replay ablation).** Suppress each rule and re-run: `R_qtype`/`R_align`/`R_project` each drop reward by the full `33` minted tokens (load-bearing); **`R_complete` drops `0`** — it costs fuel but adds no scored reward, so it's an **inert member / prune candidate** (the selection pressure the mortal framing predicts). Ablating the *minting* collapses `6/6 → 1/6`.
- **Heritability.** The loop reifies as quoted genome `GNM_qa`; copying it under fresh ids and re-running is identical → re-expressible.
- **Promotion = the clamp-switch at the ACS level.** Promote iff surplus>0 ∧ ablation-impact>0 ∧ closure ∧ autocatalysis ∧ heritability. The **same structural loop is PROMOTED under `CL_antecedent` and REJECTED under `CL_goal`** (negative surplus). Deterministic (asserted); facts → `../runs/acs_p2.metta`.

P2 shortcut (flagged): each rule's *consumed* motif-types are declared in `acs_detect.CONSUMES` (from the kernel-resident handlers) — they come free from `rule-lhs` once the rules are lifted; produced motifs + the whole fuel cycle are read from the log.

## P3 — genome mutation + reproduction (`evolve.py`)

P3 makes the promoted ACS **evolve**. The genome is mutable data: P3 mutates/recombines it, expresses each offspring by running only its `ruleset-member` rules (via the kernel's `ablate` hook), scores them by **metabolic surplus under matched replay**, and reproduces — funded by surplus, gated by token-gated dequotation (`tau_dequote`, the germ→soma step).

- **Selection rediscovers P2's finding.** From the founder `{R_qtype,R_align,R_complete,R_project}` (`+4`), the only fitter mutant is **`prune-R_complete`** (`+5`, same 6/6 answers, one less `tau_graph_match` spent) — selection lands on exactly the lean genome P2 flagged as inert. Every load-bearing prune starves (`0/6`); the cost-inflation mutant survives but is less fit. Then it **converges**.
- **Recombination** of two complementary *defective* genomes (one missing `R_project`, one missing `R_qtype` — both `0/6`) yields a **viable** child (`6/6`) — recombination rescues the loop.
- **Clamp-switch at the reproductive level.** Reproduction is funded by surplus: under `CL_antecedent` the founder (`+4`) **can reproduce → the lineage improves `+4→+5`**; under `CL_goal` the founder (`−5`) is unprofitable and **cannot reproduce → the lineage halts at the founder**.
- Deterministic (asserted); lineage facts (`../ir/schema.md` §2.10) → `../runs/lineage_p3.metta`.

P3 shortcut (flagged): a genome is expressed by ablating its non-member rules (until the rules are lifted and the kernel reads `ruleset-member` directly); offspring endowment is the standard `BALANCE_SEED` (in a full chamber it would come from the parent's accumulated multi-batch surplus).

## P0 shortcuts

| Shortcut | Status |
|----------|--------|
| Products applied to a **live `X`** so rules compose | **DONE** (was the first-slice gap) |
| Rule logic is **kernel-resident** (`(rule-impl R kernel-resident)`), not portable `rule-lhs`/`rule-rhs` pattern-graphs | open — lift **before P3** (a genome must be data to mutate) |
| Selection is **deterministic priority order** (arg-max over a trivial score) | open — seeded gate (`schema.md` §3 step 3, MSC eq 24) later |
| Matching is **host-side Python** | open — move to MM2/MORK later (Goal-Guided §20.1 allows host-side at Stage 0) |
| `R_align` cites the **direct** edge into focus, not the full multi-hop chain | open — `compact-explanation-packer` rule later |
| No evaluator/clamp yet — the kernel only **produces** answers, never mints fuel | **DONE in P1** (`evaluator.py`); the *kernel* still never mints (hard prohibition #1) |

## Files

| File | What |
|------|------|
| `kernel.py` | the deterministic chamber kernel (parse IR → live-`X` fuel-gated loop → event log → replay check); exposes the firing core `fire_to_quiescence` |
| `evaluator.py` | **P1** — eq-17 scorer + clamp-gated minting + the chamber↔evaluator epoch loop (clamp-switch + metabolic closure); imports the kernel |
| `acs_detect.py` | **P2** — ACS detection: rule-motif graph + SCC, 5-condition certification, paired-replay ablation, heritability, promotion; imports kernel + evaluator |
| `evolve.py` | **P3** — genome mutation/recombination + surplus-selection + reproduction (lineage); imports kernel + evaluator + acs_detect |
| `equivalence.py` | end-to-end **Python≡PeTTa** log-equivalence capstone (eq-30): diffs P0 firings + P1 mints vs the `petta/dump_*` outputs |
| `../experiments/expt1-causal-qa/` | the Exp-1 **data** (pure facts): `molecules`/`tasks`/`configs` (the split IR) + `genome.metta` (organism `O_qa`) + `corpus.txt` (raw texts) |
| `../runs/run_log.metta` | **generated** by `kernel.py` — the P0 event log, as portable facts (re-ingestible by PeTTa) |
| `../runs/run_log_p1.metta` | **generated** by `evaluator.py` — the P1 log: chamber firings + evaluator mints/credits |
| `../runs/acs_p2.metta` | **generated** by `acs_detect.py` — the detected ACS + surplus / do-influence / promotion verdicts |
| `../runs/lineage_p3.metta` | **generated** by `evolve.py` — the lineage: genome rules, fitness, births, costs, improvements |

## Next steps (P3 done → P4)

1. ~~**P1 — evaluator + clamps**~~ — **DONE** (`evaluator.py`).
2. ~~**P2 — ACS detection + surplus + causal replay**~~ — **DONE** (`acs_detect.py`).
3. ~~**P3 — genome mutation / reproduction**~~ — **DONE** (`evolve.py`): mutation/recombination, surplus-selection, reproduction; lineage improved `+4→+5` by pruning the inert rule.
4. **P4 — coarse-grained worker ecology (= TECAN T5/T7):** multiple chamber workers + ACS scans + reducers on append-only logs (no shared-hot-pool concurrent mutation); the worker IR + backend-rendering tests. Also where the **PeTTa port** lands (Python → PeTTa, kept log-equivalent — the Python stack becomes the replay oracle).
5. **Cross-cutting, any time:** lift the rules to portable `rule-lhs`/`rule-rhs` pattern-graphs (removes the kernel-resident + ablate-expression + consume-map shortcuts at once); `compact-explanation-packer` (`Q3a` `0.50 → ~1.00`); shadow prices Λ + the full TECAN gate (eqs 37–39).
