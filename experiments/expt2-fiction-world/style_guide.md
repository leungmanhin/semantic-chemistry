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
- **EPISODIC register** (`events.md`, `lore.md` narrative parts — future
  re-skin): particular events with tense. Causal linkage uses the bounded
  connective cues (because / so / as a result), which parse to surface heads —
  normalization to `ReasonFor` is downstream (genome) work, per the parser
  spec's own instruction not to normalize connectives.

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
particular episode and yields NO rule.

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
"elsewhere").

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
Salt-bloom Warden. Places: Aelmere, Cliff Path, Sunken Cove, Northcove, the
Hollows, Cauldron Hall, the Watch, cliff-spires, Salt-bloom Tide-pools,
Stilllight Lantern, lantern-row, lantern-station. Things: lantern, wick,
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

## The parse-gate (admission protocol)

A sentence enters the corpus only after passing all checks — fail-closed; a
failing sentence is **rewritten, not the parser patched**:

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
   inert) is flagged uniformly; none exist in the LAW register, but the
   episodic register's counterfactual/belief sentences will need the
   exporter to tag sealed rules or the gate to exempt them.

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
re-parsed — `world_rules_pending.json` carries just those (same schema), and
`assemble_parses.py` merges the returned `world_rules_pending_parses.json`
into the accepted record by exact sentence match and reports the census.
Where the pipeline offers an ADJUDICATOR, an adjudicator-confirmed complaint
is the reproducibility signal.

## What the controlled corpus knowingly gives up (and where it went)

Exact thresholds and rates (→ `>` annotations + `cycle_map.md`) · durations
and dates in laws (→ annotations) · the harbor-water alternative for boiling ·
belief attributions (→ future lore re-skin) · "near" moon-phase timing (→ "at",
annotation keeps "near") · Council emergency meetings, the hunting→molting
mechanism sentence, Northcove uniqueness (→ annotations; no fireable
encodings) · wild-NL robustness (→ the FUSE-NF track; a held-out "wild annex"
of free paraphrases can be generated for its future stress-testing).
