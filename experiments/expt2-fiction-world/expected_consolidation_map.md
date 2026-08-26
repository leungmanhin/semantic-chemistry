# Expected-Consolidation Map (v1)

Design metadata — **NOT part of the parseable corpus**. The closed enumeration
of surface variation deliberately retained in the controlled corpus
(`style_guide.md`), and what a consolidation/normalization miner is expected
to do with each family. This is `cycle_map.md`'s counterpart one level down:
cycle_map grades ACS detection against engineered loops; this file grades
consolidation mining against engineered paraphrase families. Three tiers:
**merge** (same relation, plain synonym), **alternation** (same relation,
different argument structure — the harder tier), and **negative control**
(superficially similar, must NOT merge).

## Structural variants

| Family | Variants | Expected outcome |
|---|---|---|
| Law form | "When A, B." ↔ "If A, B." | Identical `Implication` modulo witness names — consolidation-free by construction; any structural disagreement is a parse-gate failure, not a mining target. |

## Tier 1 — plain synonym merges (same slots)

| Relation (canonical) | Variants | Rules |
|---|---|---|
| produce | produce ↔ give | R1 |
| attract | attract ↔ draw | R2 |
| leave | leave ↔ shed | R3 |
| store | store ↔ keep | R5 |
| gather (moths) | gather ↔ crowd | R6 |
| shrink | shrink ↔ thin | R7 |
| flee | flee toward ↔ move to | R8 |
| emerge | emerge ↔ rise | R12 |
| drain | drain ↔ pull | R13 |
| show (light) | give ↔ show | R2, R14 |
| ward | ward ↔ shield | R15 |
| add | add ↔ mix | R17 |
| harvest | harvest ↔ gather | R18 |
| bloom | bloom ↔ grow | R19 |
| convene | convene ↔ meet | R26 |
| redistribute | redistribute ↔ reallocate | R27 |
| request | request ↔ ask for | R30 |
| increase | increase ↔ rise | R30 |

## Tier 2 — argument-structure alternations (merge with slot re-mapping)

| Family | Variants | Rules | The re-mapping to learn |
|---|---|---|---|
| essence formation | "mire-essence **forms** in the cauldron" ↔ "the cauldron **yields** mire-essence" | R4 | intransitive theme-subject ↔ transitive source-subject |
| feather fall | "feathers **fall** to the cliff base" ↔ "the sky-cats **shed** feathers onto the cliff base" | R10 | inchoative ↔ causative (agent added) |
| extinction | "the cold wind **extinguishes** unprepared lanterns" ↔ "unprepared lanterns **go out**" | R16 | causative ↔ inchoative (agent dropped) |
| safe tending | "the Keepers **tend** the lanterns **safely**" ↔ "winter tending **stays safe**" | R29 | manner adverb ↔ copular on the nominalized activity |
| stable burning | "lanterns **burn stably**" ↔ "lanterns **stay lit**" | R22 | manner adverb ↔ resultative copular |

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
rarely = 0.1 · never / does not = 0.0. Used deliberately: strict physical laws
carry "always"/bare, tendencies carry "usually"/"rarely", prohibitions and
non-effects carry "does not"/"never".
