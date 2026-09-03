# Expected-Consolidation Map (v4)

Design metadata — **NOT part of the parseable corpus**. The closed enumeration
of surface variation deliberately retained in the controlled corpus
(`style_guide.md` v4), and what a consolidation/normalization miner is
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
| shield (cove) | shield ↔ shelter | R22 |
| redistribute | redistribute ↔ reallocate | R27 |
| request | request ↔ ask for | R30 |
| increase | increase ↔ rise | R30 |

## Tier 2 — argument-structure alternations (merge with slot re-mapping)

| Family | Variants | Rules | The re-mapping to learn |
|---|---|---|---|
| essence formation | "mire-essence **forms** in the cauldron" ↔ "the cauldron **yields** mire-essence" | R4 | intransitive theme-subject ↔ transitive source-subject |
| feather fall | "feathers **fall** to the cliff base" ↔ "the sky-cat **sheds** feathers onto the cliff base" | R10 | inchoative ↔ causative (agent added) |
| extinction | "that wind **extinguishes** unprepared lanterns" ↔ "unprepared lanterns **go out**" | R16 | causative ↔ inchoative (agent dropped) |
| ~~potency keeping~~ | ~~"keeps its potency" ↔ "stays potent"~~ | R18 | **RETIRED (run 2)**: the possessed-attribute side mis-parses ("its" link lost, spurious continuation added) — a tested-and-failed alternation; both variants now use "stays potent" |
| ~~shielding~~ | ~~active "shield" ↔ passive "is blocked … by"~~ | R22 | **RETIRED (run 3)**: the passive antecedent Skolemizes non-deterministically (fireable in run 2, dead in run 3 on identical text) — tested-and-failed alternation #2; replaced by the Tier-1 shield ↔ shelter pair |
| stable burning | "lanterns **burn stably**" ↔ "lanterns **stay lit**" | R22 | manner adverb ↔ resultative copular |
| ~~safe tending~~ | ~~"tend … safely" ↔ "winter tending stays safe"~~ | R29 | **RETIRED (v4)**: the nominalized side failed in two wordings (episode reading, then a collapsed conditional); the variant sentence was dropped, R29 s1 stands alone |

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

## Retired in v3 (run-2 driven)

- R20's two per-phase laws → ONE disjunctive generic ("at new moon or at full
  moon"): separately they jointly asserted every spring tide at both moons —
  the first cross-sentence JOINT-consistency catch.
- R18's "keeps its potency" → "stays potent" (Tier-2 pair retired, above).
- R2 s4 restored to (essentially) its v1 shape — "Nightmoths rarely fly on a
  cold night" — after the judge's own run-1 rewrite failed its run-2 audit.
- R25 "many solo nights" → "solo count is large" (census-dead in run 2; the
  large-store T-COND-STATE template is proven good twice at R29 s1).

## Retired in v4 (run-3 driven — the admission pass)

- 16 edits from the REPRODUCED set (12) + pattern-level first-looks (4);
  R29's variant sentence dropped (107 sentences). Occasion-keying (rule 7)
  applied to every reproduced instance; "a Keeper"/"Each Keeper" replaces the
  capital-K group reading in R5/R11; compounds → possessives ("the cove's
  water"); slot fixes from the judge's stable suggestions ("against north
  winds", "when cold winds blow", "whose lanterns are drained", "quickly").
- R20 stays the disjunctive generic despite run 3's request to split it back
  — a decided representation tradeoff (opacity to a when-question beats a
  joint contradiction); judge reversal #2 on record.

## Watch list (kept on evidence, re-check at the next gate run)

- "The Keepers …" habit sentences still in the corpus (R4 s3, R9 s3, R10 s4,
  R20 s2, R21 s3/s4, R27 s5): parse variably across runs (habit rule / bare
  name / anonymous group); the capital-K-as-name reading is now a REPRODUCED
  pattern (fixed in R5/R11), so any of these that reproduces a complaint
  converts to "Each Keeper …".
- R25 s2 vs s3: identical possessive-in-trigger shape — s2 (fails) died the
  census in run 2 while s3 (dims) passed; s2 rewritten to the of-phrase
  form, s3 kept — same-shape parse variance on record.
- (v4) R22 s1's bare-plural antecedent was singularized in the admission pass; no bare-plural antecedent subjects remain. Former note: R22 s1
  ("cliff-spires shield…"); all others were singularized.
- Kept-verbatim sentences flagged only in run 2 (the 15 flips — e.g. R11 s1,
  R12 s1's "the cove water", R30 s1/s4, R22 s1): untouched per the
  convergence protocol; they rewrite only if the complaint reproduces.
