# Aelmere Controlled-Language Style Guide (v4)

Design metadata — **NOT part of the parseable corpus**. This guide defines the
controlled language the corpus files are written in, derived from the parser's
competence envelope (`semantic-parsing-hitl/prompt.txt`) and REVISED against
three real gate runs (`world_rules_parses.json` + git history): sentences use only the
construction families the parser handles robustly, so raw parses come out
consistent without a mature FUSE-NF stage. Variation is not eliminated — it is
**bounded**: each relation keeps a small enumerated set of surface variants,
recorded in `expected_consolidation_map.md`, so consolidation mining has known
targets exactly as ACS detection has `cycle_map.md`.

Corpus-file conventions: lines beginning with `>` are design annotations
(cycle notes, threshold values, retired content) and are **skipped at
ingestion**. Each corpus `.md` has a JSON twin (`world_rules.json`: entries
`{id, rule, texts}`) — the parser consumes only the `texts` arrays; the `.md`
stays the annotated authoring view, and the JSON is the home of gate-ADMITTED
sentences. Rule TITLES are display labels only — never parsed, never gated.

## Registers

- **LAW register** (`world_rules.md`): timeless regularities. Sentence forms:
  conditionals, generics, negated generics, categorical copulars, deontic
  norms. Parses to `Implication` rules, kind-level properties, and copular
  atoms — the law IS the rule-molecule; no connective atoms here.
- **LORE register** (`lore.md`): grounding facts about NAMED individuals,
  places, customs, and history. Sentence forms: named copulars ("Meren
  Tallowhand is the chief Keeper", "The Watch is a small stone hall"),
  static location ("The Sunken Cove lies west of the village", "X stands at
  Y" — `LocatedIn` is containment only; other prepositions are surface
  heads), possession/parts ("The Watch holds the feather store"), habits as
  bare-plural generics or "Each Keeper …" / "Every N …" (never "A Keeper
  checks …" — a singular indefinite with a verb is ONE anonymous Keeper, see
  Generic discipline), exact counts in ONE template
  ("The Cliff Path holds one hundred and twelve lanterns", "There are nine
  cliff-spires" — QA-critical counts only), relative time as "N years ago"
  (the parser's `BeforeBy … now` form; QA-critical dates only), and LAW
  INSTANCES restating world rules in the When/Whenever templates (the
  deliberate repeats mining needs). Beliefs are kept ONLY where the
  belief-ness is the content (four deliberate sealed sentences: L2-20,
  L5-02, L5-07 ×2, L10-05); everything else decorative became a plain fact or
  a `>` annotation. Superlatives, ranges, ages, durations, and "only" were
  demoted to annotations throughout.
- **EPISODIC register** (`events.md` — future re-skin): particular events with tense. Causal linkage uses the bounded
  connective cues (because / so / as a result), which parse to surface heads —
  normalization to `ReasonFor` is downstream (genome) work, per the parser
  spec's own instruction not to normalize connectives.

**Authoring policy (agreed 2026-09-03):** the corpus exists to study ACS
discovery in the chemical soup, not to exercise linguistic coverage. A
sentence that is hard for the parser is simply REWRITTEN in a simpler form
that conveys the same meaning and serves the same purpose — never kept for
coverage's sake. What "same purpose" protects: the four cycles' causal
structure, enough episodic INSTANCES of each rule firing for recurrence and
the §2.3 statistics, the facts the QA pairs depend on, and the bounded
paraphrase families of the consolidation map (simplify freely, but do not
collapse all designed variation). Decorative beliefs and reported speech may
become plain facts or be dropped; sealing constructions are kept only where
the content is the point (the counterfactual QA category).

## Sanctioned sentence templates (LAW register)

| Template | Form | Parses to |
|---|---|---|
| T-COND | "When ⟨antecedent⟩, ⟨consequent⟩." / "Whenever ⟨antecedent⟩, ⟨consequent⟩." ("Every time" = synonym of Whenever) | `Implication` rule; Whenever/Every-time force the per-occurrence reading and are PREFERRED for event antecedents (discipline rule 7) |
| T-COND-STATE | "When ⟨NP⟩ is ⟨state/adjective⟩, ⟨consequent⟩." | rule over the state — the ONLY sanctioned stative antecedent (never an event verb of holding/staying) |
| T-GEN | "⟨Kind-PLURAL⟩ ⟨verb phrase⟩." (optional frequency adverb) | generic rule, strength by adverb |
| T-NEGGEN | "⟨Kind-plural/kind⟩ does/do not ⟨verb phrase⟩." | strength-0.0 rule |
| T-COP | "⟨Kind⟩ is ⟨kind / property⟩." | categorical copular |
| T-DEON | "⟨Kind-plural⟩ must / may / may not ⟨verb phrase⟩." | reified norm on the kind — keep it BARE (no trailing PPs; state the relation in its own sentence) |

**"If" is RETIRED** (v2): the gate run showed If-antecedents parse
non-equivalently to When — untimed, kind-level, or unfireable readings — so
the structural variant pair is **{When, Whenever}**.

## Antecedent discipline (the load-bearing rules — every one gate-verified)

1. **Singular indefinite subject + finite verb**: "When a lantern burns
   mire-essence…", "Whenever a sky-cat molts…". Bare-plural subjects ("When
   sky-cats molt…") are UNRELIABLE — they can Skolemize the trigger event
   into the premise and produce a mechanically dead rule.
2. **No participles or event nominalizations** as triggers ("fleeing
   nightmoths", "a sky-cat hunt", "frequent hunting") — they become
   constructed terms nothing asserts. Use finite verbs; restrictive relative
   clauses with finite verbs are sanctioned ("the nightmoths that survive
   the hunt").
3. **No definite-plural group agents — anywhere in a conditional**: "the
   Keepers" in an antecedent mints a private anonymous group witness per
   sentence, and (REPRODUCED across runs 2–3) capital-K "the Keepers" in a
   consequent parses as a bare PROPER NAME with no link to the keeper kind.
   Use "a Keeper" in conditionals (antecedent or consequent) and "Each
   Keeper …" for habit generics (v5 converted the thrice-reproduced cases).
   The few remaining "The Keepers …" habits (R9 s3, R21 s3/s4, R27 s5) are
   tolerated only while stable-good.
4. **Every "that N" must be bound in-sentence** by an indefinite introduced
   in the antecedent clause ("…hunts at a lantern-row, … at that
   lantern-row…").
5. **No many/few determiners**: proportion words are the strength dial, not
   counters — in a premise they become unmatchable conditions. Use singular
   collectives from the registry: "a crowd of nightmoths", "a handful of
   nightmoths".
6. **Consequents link back**: name the antecedent's participants ("that
   mire-essence", "that lantern-row"); prefer positive relation verbs
   (ward, resist, repel); express blocking as a positive law plus a separate
   T-NEGGEN — never a negated consequent or negated antecedent.
7. **Prefer Whenever/Every-time for EVENT antecedents** (run-2 finding):
   plain When can key the consequent to a participant instead of the
   occasion, so repeated occasions collapse into one event. When remains
   confidently correct for STATIVE antecedents (T-COND-STATE: "When the
   feather store is large…"). Caveat (run 4): Whenever does NOT reliably
   cure occasion-keying — the parser's consequent keying varies on its own —
   so this is a preference with partial evidence, not a guarantee.
8. **Trigger participants carry no modifiers**: a participial or state
   adjective on a mass/plural participant in a trigger ("ground feathers",
   "stored mire-essence") is unstable — say the producing act as its own
   finite clause ("grinds feathers and scatters the feathers…"), add an
   article ("the stored mire-essence"), or use a registry-fused compound.
9. **Position/state verbs are not triggers**: "rests on", "a night is cold"
   name no happening. Use the progressive ("is resting on") or fold the
   condition into the clause it restricts ("Nightmoths rarely fly on a cold
   night").
10. **Noun-noun compounds must be registry entries or of-phrases**: an
    unregistered compound ("the cliff base", "the cove water") makes the
    parser invent a link — write "the base of the cliff", "the cove's
    water", or register the compound.
11. **Adjectives never sit on bare-plural objects** ("dim lanterns", "cold
    winds" invent witnesses or mis-attach to the set): use a singular
    indefinite object ("flees to a dim lantern") or move the adjective into
    a condition clause ("When a cold wind strikes…").

## Generic discipline

Generics are **bare plurals only**: "Drained lanterns burn dimly." A singular
indefinite with a plain verb ("A drained lantern burns dimly") parses as one
particular episode and yields NO rule. The parser's own rule (lore gate run
1: 36 such sentences passed the census silently): an indefinite "a/an" is
generic ONLY in a copular or definitional predication ("A sky-cat is a small
winged animal") or under a modal ("A wraith cannot enter the Watch", "A
Council member may retire"); with a verbal predicate it is a witness — write
the bare plural or an explicit universal ("Every sky-cat has broad feathered
wings", "Each Keeper checks the lantern at midnight"). A singular indefinite
is KEPT only for a genuinely specific existential ("A stone landing stands at
the foot of the Cove Stair"). A conditional's consequent may refer back with
"the N" ("When a lantern burns mire-essence, the lantern produces
mist-light") — twenty admitted laws do; "that N" is a preference, not a
requirement. A frequency adverb carries a strength only on a KIND subject
("Keepers rarely burn wintergloss"); on a definite or named subject ("The
Council often …") it has no slot — state a period or drop it. A capitalized
PLURAL label as subject ("The Keepers …") is a members-less named body with
no link to the kind: write "Keepers …" (habit), "Each Keeper …" (per-station
duty) or "Every Keeper believes/considers that …" (attitude). `lint_corpus.py`
flags every one of these shapes before a parse.

**LORE-register shapes that mis-parse silently (gate runs 1–2, pattern-level):**
a mass or process noun as the subject of a verb ("Mire-essence smells …",
"Distillation thins", "Salt-bloom slows the burn") yields one flat event about
the kind — give the clause a countable bearer ("The smell of mire-essence is
…", "The distillation yield thins", "The copper cauldrons produce
mire-essence") or restate it as a Whenever-law. A recurring occasion phrase
("at each full moon", "after each equinox", "on clear winter nights", "in
autumn and early winter") has no carrier — write "Whenever the moon is full,
…", "Whenever a winter night is clear, …", one sentence per season. A
part-whole compound ("the cliff base", "the harbor mouth", "sky-cat
feathers") and a proper-noun premodifier on a definite plural ("the Hollows
lanterns") → "the base of the cliff", "feathers of sky-cats", "the lanterns
at the Hollows". A container of a mass ("a vessel of mire-essence", "vessels
full of mire-essence") loses the mass → "fill N vessels with mire-essence",
"a vessel that is partly full of mire-essence". A definite witness inside an
antecedent ("When the moth-count at … is low") only ever matches itself —
bind an indefinite ("When a moth-count at the Stilllight Lantern is low").

## Authored truth values

Frequency adverbs are the sanctioned strength dial (the parser maps them):
bare generic = 0.9 · "always" = 1.0 · "usually"/"often" = 0.8 · "sometimes" =
0.5 · "rarely" = 0.1 · "never" / "does not" = 0.0. In a controlled corpus the
truth values are **authored**, not accidental. A frequency adverb belongs in a
GENERIC, never inside a conditional's antecedent (there it is spent on the
rule's own reliability and asserted as standing fact — split it into its own
sentence).

## Bounded variation (the designed paraphrase families)

Each law appears in two conditional variants (When/Whenever, or
Whenever/Every-time where the occasion reading must be forced), and each core
relation keeps at most two verb variants (produce/give, attract/draw,
die/go-out …). The complete enumeration, with canonical targets and the
expected merge tier, lives in `expected_consolidation_map.md`. Do not
introduce a variant that is not in the map; extend the map first.

## Outside the envelope (banned)

Numeric measures and units · thresholds as numbers · durations and calendar
arithmetic · comparatives, superlatives, and correlative comparatives ("the
more …, the more …") · partitives ("most of the …") · focus particles and
clefts ("only", "even") · "unless"/"without" antecedents (negated antecedents
unsupported) · "other ⟨kind⟩" ("other moon phases" — 'other' has no encodable
form; enumerate representatives instead) · disjunctive antecedents ("at the
full moon or the half moon" — split into one sentence per disjunct) ·
propositional attitudes in the LAW register · periphrastic causatives beyond
have/get/make/let · free-choice ("no matter how long") · pronoun subjects
(re-name the referent: "the sky-cat sheds", not "it sheds") · bare definites
with no in-sentence antecedent ("that lantern-row" unbound, "the burn",
"elsewhere") · "some ⟨kind⟩" (an existential witness, not a proportion —
write "A few Keepers" / "Many Keepers") · exceptives and exclusivity
("nothing else", "no other N" — no declarative carrier: the positive fact
stands, the exclusion becomes a T-NEGGEN or an annotation) · a capitalized
PLURAL label as subject ("The Keepers …" — see Generic discipline) · a reason
between two GENERICS ("sacred because feathers ward …" — `because` links two
happenings only).

**Replacement policies:** numbers/thresholds → registry collectives ("a
crowd", "a handful") with exact values in `>` annotations or `cycle_map.md` ·
"only at PLACE" → positive law at PLACE + a T-NEGGEN for "away from PLACE" ·
beliefs → drop or restate as neutral T-COP · requirement-on-things → positive
law for the good case + T-NEGGEN for the bad case · "other ⟨kind⟩" →
enumerate named representatives + a `>` annotation stating the general
intent · uniqueness ("the ONLY shielded cove") → plain T-COP + a `>`
annotation · unregistered compounds → of-phrases. Disjunction ("or") remains
banned in ANTECEDENTS but is ALLOWED in a generic statement ("Spring tides
occur at new moon or at full moon") — and is required when two separate
exceptionless laws would jointly contradict.

## Entity registry (closed lexicon)

People/roles: Keeper, senior Keeper, apprentice, newcomer, heir, the Council,
Salt-bloom Warden, Stilllight Keeper. Places: Aelmere, Cliff Path, Sunken
Cove, Northcove, the Hollows, Cauldron Hall, the Watch, cliff-spires,
Salt-bloom Tide-pools, Stilllight Lantern, Stilllight Station (the
lantern-station at the Sunken Cove — R29's "the Sunken-Cove station" is the
same station), lantern-row, lantern-station. Things: lantern, wick,
mire-essence, mist-light, ordinary oil, fresh water, sea-water, silken thread,
clay vessel, copper cauldron, salt-bloom, chalky residue, wintergloss,
feather, ground feathers, feather store, feather ration, central pool,
ledger, solo count. Collectives: crowd (of nightmoths), handful (of
nightmoths). Registry compounds ("ground feathers", "feather store",
"mist-light" …) are the ONLY sanctioned noun-noun forms — any other
noun-noun pairing must become an of-phrase or a possessive.
Creatures: nightmoth, sky-cat, wraith. Times/tides: night, dawn, winter,
summer, autumn, new moon, full moon, half moon, moon phase, spring tide, cold
wind. Hyphenated compounds are fixed lexicon entries; use them verbatim.

**Singleton kinds** — the parser encodes "the Council", "the Watch", "the
village" as per-sentence definite witnesses BY DESIGN (a capitalized common
noun used as the only label is a common noun, never a name), so ingestion
resolves a witness typed with one of these kinds to the registry constant:
council, watch, village (= Aelmere), feather bin, feather store, central
pool, Cove Stair, sea (= the Cold Sea), moon, tide-pools (= the Salt-bloom
Tide-pools), cauldron (the cauldron in use — R4/R5's "the cauldron"). Ten
admitted world_rules laws carry one of these witnesses in their PREMISE, so
this resolution is what lets them fire on facts from other sentences. A bare
definite PLURAL of a registry kind ("the villagers", "the cliff-spires")
denotes the kind: ingestion turns the parser's per-member rule premise
`(PartOf $x sk_group)` into `(Member $x kind)` (our extension). Multi-word capitalized names ("Cauldron Hall", "Stilllight
Station", "Meren Tallowhand") and kind words already yield one stable symbol
per surface form. **Symbol aliases** applied at ingestion (parser-side
segmentation variance): `night_moth` → `nightmoth`, `vesh` → `old_vesh`,
`seawater` → `sea_water`.

## The parse-gate (admission protocol)

A sentence enters the corpus only after passing all checks — fail-closed; a
failing sentence is **rewritten, not the parser patched**:

0. **Authoring lint** (`lint_corpus.py`, deterministic, BEFORE any parse):
   the shapes that mis-parse silently — the census passes them — banned
   words, indefinite-verbal generics, the capitalized plural label,
   non-registry names, "After P, Q", coordinated lists, frequency adverbs on
   a specific subject. Hits are rewritten or consciously kept (a specific
   existential).
1. **Schema validity** (deterministic): every output line is a well-formed
   `(: name content (STV s c))` atom; heads and roles from the parser's
   inventory; parentheses balance.
2. **Registry conformance** (deterministic): every entity symbol resolves to
   the registry; every relation verb is in the consolidation map.
3. **Stability under re-parse** (deterministic rule over sampled parses):
   parse k ≥ 2 times, canonicalize (alpha-rename witnesses, sort atoms),
   require structural agreement; disagreement = ambiguity boundary = reject.
4. **Expected-core conformance** (deterministic, template-driven): a T-COND
   must yield an `Implication` mentioning the intended participants; an
   episodic cue sentence must yield its surface connective head.
5. **FIREABILITY census** (deterministic — the exporter's own flag, no
   agent involved): every `Implication` premise must be satisfiable — plain
   variables, or Skolem constants asserted as facts elsewhere in the same
   parse. The two failure flags are `sk-function-in-premise` (a term like
   `(sk_die $l)` that no fact can ever bind) and
   `unasserted-sk-constant-in-premise` (a dormant rule). Root cause is a
   PARSER-side mistranslation class — premise existentials Skolemized when
   they should be plain variables (Skolemization belongs in conclusions) —
   so discipline rules 1, 8 and 9 are partly workarounds that route around
   it; when the parser fix lands they relax to preferences. Because the
   parse upstream is stochastic, the census must be `ok` on ALL k parses
   (run 3: an identical sentence was fireable in one run and dead in the
   next). Nuance: a SEALED rule (attitude, counterfactual — intentionally
   inert) would be flagged uniformly, but the lore run's four sealed
   sentences all passed — content nested under an attitude's `Theme` is not
   scanned as a top-level rule — so no tagging or exemption is needed so
   far. Caveat: a factive verb ("confirm") may ALSO assert the sealed
   content at top level while the parser never classifies factivity, so a
   world-true fact must never live only inside an attitude complement. An
   EMPTY parse (no statement at all — the parser's deliberate refusal to
   invent, e.g. "Sky-cats eat nothing else") also passes the census:
   `assemble_parses.py` lists it as `EMPTY` and admission requires none —
   the sentence is dropped or restated.

**The judge layer**: an LLM reviewer (as in `world_rules_parses.json`) is an
AUTHORING-TIME ADVISOR — it proposes rewrites and surfaces new patterns for
this guide. Admission itself stays mechanical (checks 1–5); everything the
judge proposes goes back through the gate. Its non-determinism is harmless in
that position and catches what the mechanical checks cannot: stably-wrong
parses.

**The convergence protocol** (v3, from comparing runs 1–2): a judge complaint
triggers a rewrite ONLY if it reproduces across ≥2 independent judge runs —
the k-stability principle applied to the judge itself. Run 2 measured a ~35%
flip rate on identical sentences and several reversals of the judge's own
run-1 prescriptions, so single-run complaints are noise, not defects.
ADMISSION = mechanical checks green. Residual judge commentary on admitted
sentences is logged as advisory backlog, never rewrite fuel.

**Incremental admission** (v5): parsing the full corpus every round is
expensive, so accepted sentences are FROZEN and only edited sentences are
re-parsed — `<corpus>_pending.json` (`world_rules_pending.json`,
`lore_pending.json`) carries just those (same schema), and
`assemble_parses.py` merges the returned `<corpus>_pending_parses.json` into
the accepted record (`world_rules_parses.json`, `lore_parsed.json`) by exact
sentence match and reports the census.
Where the pipeline offers an ADJUDICATOR, an adjudicator-confirmed complaint
is the reproducibility signal.

## What the controlled corpus knowingly gives up (and where it went)

Exact thresholds and rates (→ `>` annotations + `cycle_map.md`) · durations
and dates in laws (→ annotations) · the harbor-water alternative for boiling ·
belief attributions (→ future lore re-skin) · "near" moon-phase timing (→ "at",
annotation keeps "near") · Council emergency meetings, the hunting→molting
mechanism sentence, Northcove uniqueness (→ annotations; no fireable
encodings) · wild-NL robustness (→ the FUSE-NF track; a held-out "wild annex"
of free paraphrases can be generated for its future stress-testing) · diet
exclusivity ("nothing else") and "no other N" uniqueness (→ T-NEGGEN forms
+ annotations) · the reason linking two generics ("sacred because feathers
ward" → annotation + the QA oracle) · "unsettled" in the wraith belief and
"for the Keepers" on the Mid-summer feast (→ annotations).
