# Expected-Consolidation Map (v2)

Design metadata — **NOT part of the parseable corpus**. The closed enumeration
of surface variation deliberately retained in the controlled corpus
(`style_guide.md` v2), and what a consolidation/normalization miner is
expected to do with each family. This is `cycle_map.md`'s counterpart one
level down: cycle_map grades ACS detection against engineered loops; this
file grades consolidation mining against engineered paraphrase families.
Three tiers: **merge** (same relation, plain synonym), **alternation** (same
relation, different argument structure — the harder tier), and **negative
control** (superficially similar, must NOT merge).

## Structural variants

| Family | Variants | Expected outcome |
|---|---|---|
| Law form | "When A, B." ↔ "Whenever A, B." | Same per-occurrence `Implication` — near-identical parses expected; structural disagreement is a parse-gate failure, not a mining target. |

> **Retired (v2):** the v1 pair was {When, If}, claimed "identical by
> construction". The first gate run REFUTED that: If-antecedents parsed
> untimed, kind-level, or unfireable. "If" is retired from the language;
> "Every time" is an allowed synonym of Whenever.

## Tier 1 — plain synonym merges (same slots)

| Relation (canonical) | Variants | Rules |
|---|---|---|
| produce | produce ↔ give | R1 |
| attract | attract ↔ draw | R2 |
| leave | leave ↔ shed | R3 |
| store | store ↔ keep | R5 |
| gather (moths) | gather ↔ settle | R6 |
| shrink | shrink ↔ thin | R7 |
| flee | flee toward ↔ move to | R8 |
| die (lantern) | die ↔ go out | R11, R12 |
| emerge | emerge ↔ rise | R12 |
| approach | approach ↔ near | R13 |
| drain | drain ↔ pull | R13 |
| show (light) | give ↔ show | R2, R14 |
| ward | ward ↔ shield | R15 |
| scatter | scatter ↔ spread | R15 |
| add | add ↔ mix | R17 |
| harvest | harvest ↔ gather | R18 |
| bloom | bloom ↔ grow | R19 |
| convene | convene ↔ meet | R26, R27 |
| redistribute | redistribute ↔ reallocate | R27 |
| request | request ↔ ask for | R30 |
| increase | increase ↔ rise | R30 |

## Tier 2 — argument-structure alternations (merge with slot re-mapping)

| Family | Variants | Rules | The re-mapping to learn |
|---|---|---|---|
| essence formation | "mire-essence **forms** in the cauldron" ↔ "the cauldron **yields** mire-essence" | R4 | intransitive theme-subject ↔ transitive source-subject |
| feather fall | "feathers **fall** to the cliff base" ↔ "the sky-cat **sheds** feathers onto the cliff base" | R10 | inchoative ↔ causative (agent added) |
| extinction | "that wind **extinguishes** unprepared lanterns" ↔ "unprepared lanterns **go out**" | R16 | causative ↔ inchoative (agent dropped) |
| potency keeping | "that salt-bloom **keeps its potency**" ↔ "that salt-bloom **stays potent**" | R18 | possessed-attribute ↔ copular state |
| shielding | "cliff-spires **shield** a cove from north winds" ↔ "a cove **is blocked** from the north wind **by** cliff-spires" | R22 | active ↔ passive |
| stable burning | "lanterns **burn stably**" ↔ "lanterns **stay lit**" | R22 | manner adverb ↔ resultative copular |
| safe tending | "the Keepers **tend** the lanterns **safely**" ↔ "winter tending **stays safe**" | R29 | manner adverb ↔ copular on the nominalized activity |

## Tier 3 — negative controls (must NOT merge)

| Pair | Why it must stay apart | Rules |
|---|---|---|
| retire ↔ die | Two DIFFERENT antecedent conditions sharing one consequent (inheritance) — two laws, not one paraphrased law. | R23 |
| gather (moths) ↔ gather (salt-bloom) | Same lemma, different relation (congregate vs collect); merging conflates creature behavior with Keeper labor. | R6 vs R18 |
| feathers accumulate ↔ feather store grows | Level shift (substance at a place vs stock of an institution) — causally linked, not synonymous. | R28 |
| repel (wintergloss→moths) ↔ ward (feathers→wraiths) | Both "keep away" verbs, different relations in different cycles; merging would fuse Cycle B's regulator with Cycle C's protector. | R21 vs R15 |

## Episodic cue family (future `events.md` re-skin)

| Cues (bounded set) | Parse to | Downstream canonical |
|---|---|---|
| "because" · "so" · "as a result" | surface heads `Because` / `So` / `AsAResult` | `ReasonFor` — derived by seeded/genome rules, never by the translator (per the parser spec) |

## Authored truth values (frequency dial)

bare generic = 0.9 · always = 1.0 · usually/often = 0.8 · sometimes = 0.5 ·
rarely = 0.1 · never / does not = 0.0. Used deliberately; a frequency adverb
never sits inside a conditional's antecedent (split it into its own generic).

## Retired content (v2 — where it went)

- R26 "The Council rarely meets at other times." → dropped ("at other times"
  names no encodable occasion); emergency-meeting intent → `>` annotation.
- R28 "Frequent hunting causes frequent molting." → dropped (nominalized
  subjects yield an episode, not a law); mechanism → `>` annotation.
- R18 "other moon phases" → enumerated as full moon + half moon, one sentence
  per phase (no 'other'; no disjunctive antecedents).
- R24 "A newcomer must apprentice under a senior Keeper." → split into a bare
  deontic + a relation sentence (a norm's trailing PP mis-slots).
- R8 "extra" (threads) · R12 "when they die" tail · R20 "near" (→ "at") ·
  R22 Northcove uniqueness → dropped or demoted to annotations.

## Watch list (kept on evidence, re-check at the next gate run)

- R21 s3 vs s4: identical "The Keepers ⟨adv⟩ burn wintergloss…" shape parsed
  differently across the two sentences in run 1 (habit rule vs bare name) —
  exactly what the k-stability check exists to catch.
- R25 s1: "many solo nights" as an OBJECT determiner inside a relative clause
  survived run 1; the many/few ban is antecedent-scoped for now.
- Bare-plural antecedent subjects judged good in run 1 and kept: R22 s1
  ("cliff-spires shield…"); all others were singularized.
