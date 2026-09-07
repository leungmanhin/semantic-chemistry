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

## Retired in v5 (run-4 driven — the final micro-pass, 9 edits)

- R22 s1/s2: definite-plural consequents ("lanterns in that cove") → "each
  lantern in that cove" (the run-4 census death was a NESTED rule hung off a
  minted lantern group in the conclusion).
- The thrice-reproduced capital-K habits (R4 s3, R10 s4, R20 s2, R29 s1) →
  "Each Keeper …"; R8 s2 → the each-form its sibling proved.
- R30 s1 "wraith activity … increases" → the concrete trigger "a wraith
  drains a lantern at the Sunken Cove" (ties Cycle D to the social loop);
  the Tier-1 increase ↔ rise pair is therefore retired. R30 s4 → the event
  form "When a station reports a drained lantern, the Council prioritizes
  that station" after three failed wordings.

## Advisory backlog (post-admission — reviewer remarks on admitted sentences)

Logged, not acted on, per the convergence protocol; each earns a targeted
edit only if it reproduces (adjudicator-confirmed) in a later run.

- R4 s3: "the Salt-bloom Tide-pools" recorded as ONE named tide-pool (a
  capitalised multi-word name loses plurality). Registry decision pending:
  keep the proper name (accept singular) or lowercase the head noun.
- R20 s2: "times X to Y" has no fitting slot — parsed as spatial destination.
  Candidate: "Each Keeper harvests salt-bloom at the new-moon spring tide."
- R22 s2: "stays lit" yields one shared lit-state across shelterings;
  candidate = a plain finite verb as in s1 ("burns steadily").
- R30 s1: "a station near the Sunken Cove" lifted out of the condition and
  asserted to exist; "at the Sunken Cove" attached to the lantern, not the
  draining. Candidate: "Whenever a wraith drains a lantern at the Sunken
  Cove, each station near the Sunken Cove requests feather rations from the
  Council."

## Advisory backlog — lore (deferred after gate run 2; single-instance
## reviewer remarks with their worked rewrites, applied only if they reproduce)

- Titles and offices: "Cauldron Hall Warden" / "Salt-bloom Warden" /
  "Council speaker" → "the warden of Cauldron Hall", "the Salt-bloom
  warden", "the speaker of the Council" (L1-07 s6/s7, L2-05 s2/s3, L2-06
  s1/s2, L3-02 s5, L3-04 s3, L4-08 s9, L10-05 s5); "Tessa Brae is the
  village's chief Feather-Collector" → two sentences (a Feather-Collector;
  leads the feather-collectors of the village).
- Coordinated object lists → one clause per item (L1-13 s3 boats, L1-15 s2
  ledgers, L2-13 s2 the case, L9-06 s2 records); L2-22 s2 → "puts … into a
  common pool"; L4-09 s8 → "Keeper children who do not apprentice often
  fish / farm in the Hollows / trade on the coast".
- Council membership idioms → "is a member of the Council" (L2-04 s1, L2-05
  s1, L2-06 s3); "Old Vesh attends Council" → "attends the Council".
- Comparatives without a standard → plain adjective (L1-15 s3/s5 "older"
  ledgers, L2-03 s5 "older rituals"); L2-18 s3 → "have already become";
  "The Watch ledgers go back many years" → "are old".
- "There are no formal prayers" → "No prayer is formal."; "There is no
  substitute for mire-essence" → "No material can replace mire-essence.";
  "One apprentice serves …" → "A single apprentice serves …".
- Postural and result-state verbs: "come to a slow boil" → "begin to boil
  slowly"; "keeps the cauldrons at a steady simmer" → "keeps the cauldrons
  simmering steadily"; "the cauldrons sit idle" → "are idle"; "sits at a
  long oak table" → "meets at"; "stand at the front of the shelves" → "are
  stored at"; "By late afternoon" → "By evening"; "at the end of the day" →
  "in the evening"; "The slick is the precursor of mire-essence" →
  "Mire-essence forms from the slick."
- Single dropped words (flavor): "outward", "far" → "to distant waters",
  "down the coast" → "from a village down the coast", "by heart" →
  "memorize", "in that winter" → "Sixty-three years ago, in winter",
  "between the harbor and the Watch" → two "beside" sentences, "leads
  down"/"walks down" → "descends", "stay near" → "shelter near", "the
  ashes" → "the ash", "The plan worked" → "was successful", "The village
  rises late" → "The villagers wake at mid-morning".
- Possessives inside kind claims: "A brass snuffer is a Keeper's personal
  tool" → "A brass snuffer is a tool. Every Keeper owns a personal brass
  snuffer." (same for the wick-trimmer); "Each lantern is fixed to its
  station" → "has its own station, and … is fixed to that station";
  "iron-lidded box" → "… and the bin has an iron lid"; "hold keys" → one
  key each; cousin sentences → symmetric "X and Y are cousins".
- Kept on precedent or by design: L5-05 s1 (= R15's plural feathers),
  L7-04 s4 (= R16 s1), L6-04 s5 and L7-03's "After" (= R7 s4), L3-01 s5
  (membership recorded as PartOf), the two seasonal-colour copulars (the
  parser's own rule emits the unconditional half), the "first-year /
  second-year" labels (translator over-unpacking).

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
