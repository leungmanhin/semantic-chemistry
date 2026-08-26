# Aelmere Controlled-Language Style Guide (v1)

Design metadata — **NOT part of the parseable corpus**. This guide defines the
controlled language the corpus files are written in, derived from the parser's
competence envelope (`semantic-parsing-hitl/prompt.txt`): sentences use only the
construction families the parser handles robustly, so raw parses come out
consistent without a mature FUSE-NF stage. Variation is not eliminated — it is
**bounded**: each relation keeps a small enumerated set of surface variants,
recorded in `expected_consolidation_map.md`, so consolidation mining has known
targets exactly as ACS detection has `cycle_map.md`.

Corpus-file convention: lines beginning with `>` are design annotations
(cycle notes, threshold values) and are **skipped at ingestion**. Each corpus
`.md` has a JSON twin (`world_rules.json`: entries `{id, rule, texts}`) — the
parser consumes only the `texts` arrays, so the JSON is the machine-facing
form and the natural home of gate-ADMITTED sentences; the `.md` stays the
annotated authoring view.

## Registers

- **LAW register** (`world_rules.md`): timeless regularities. Sentence forms:
  conditionals, generics, negated generics, categorical copulars, deontic norms.
  Parses to `Implication` rules, kind-level properties, and copular atoms — the
  law IS the rule-molecule; no connective atoms here.
- **EPISODIC register** (`events.md`, `lore.md` narrative parts — future
  re-skin): particular events with tense. Causal linkage uses the bounded
  connective cues (see below), which parse to surface heads (`Because`, `So`,
  `AsAResult`) — normalization to `ReasonFor` is downstream (genome) work, per
  the parser spec's own instruction not to normalize connectives.

## Sanctioned sentence templates (LAW register)

| Template | Form | Parses to |
|---|---|---|
| T-COND | "When ⟨clause⟩, ⟨clause⟩." / "If ⟨clause⟩, ⟨clause⟩." | `Implication` rule |
| T-GEN | "⟨Kind-plural⟩ ⟨verb phrase⟩." (optional frequency adverb) | generic rule, strength by adverb |
| T-NEGGEN | "⟨Kind-plural/kind⟩ does/do not ⟨verb phrase⟩." | strength-0.0 rule |
| T-COP | "⟨Kind⟩ is ⟨kind / property⟩." | categorical copular |
| T-DEON | "⟨Kind⟩ must / may / may not ⟨verb phrase⟩." | reified norm on the kind |

Rules of thumb: active voice; the subject re-names its referent explicitly
("the lantern produces…", not "it produces…"); one clause per comma side of a
conditional; conjunction of two premises in an antecedent is allowed ("When X
and Y, Z"). **Prefer positive relation verbs in conditional consequents**
(ward, resist, repel); express blocking as a positive law plus a separate
T-NEGGEN ("Wraiths do not approach a warded lantern."), never as a negated
consequent or a negated antecedent.

## Authored truth values

Frequency adverbs are the sanctioned strength dial (the parser maps them):
bare generic = 0.9 · "always" = 1.0 · "usually"/"often" = 0.8 · "sometimes" =
0.5 · "rarely" = 0.1 · "never" / "does not" = 0.0. In a controlled corpus the
truth values are **authored**, not accidental.

## Bounded variation (the designed paraphrase families)

Each law appears as a When-variant and an If-variant, and each core relation
keeps at most two verb variants (e.g. produce/give, attract/draw, store/keep).
The complete enumeration, with canonical targets, lives in
`expected_consolidation_map.md`. Do not introduce a variant that is not in the
map; extend the map first.

## Outside the envelope (banned in v1)

Numeric measures and units ("a thumb's depth", "between ten and forty",
"three-quarters the rate") · thresholds as numbers ("exceeds twenty per
night") · durations and calendar arithmetic ("for at least three years",
"six generations ago") · comparatives and superlatives ("more slowly",
"largest") · partitives · focus particles and clefts ("only", "even") ·
"unless"/"without" antecedents (negated antecedents are unsupported) ·
propositional attitudes in the LAW register ("the Keepers believe…") ·
periphrastic causatives beyond have/get/make/let ("orders X burned") ·
free-choice ("no matter how long") · pronoun subjects in conditionals.

**Replacement policies:** numbers/thresholds → qualitative closed vocabulary
("many", "few", "a crowd") with the exact value recorded in a `>` design
annotation or `cycle_map.md` · "only at PLACE" → positive law at PLACE + a
T-NEGGEN for elsewhere · beliefs → either drop or restate as a neutral T-COP ·
requirement-on-things ("must be fresh") → a positive law for the good case +
a T-NEGGEN for the bad case.

## Entity registry (closed lexicon)

People/roles: Keeper, senior Keeper, apprentice, newcomer, heir, the Council,
Salt-bloom Warden. Places: Aelmere, Cliff Path, Sunken Cove, Northcove, the
Hollows, Cauldron Hall, the Watch, cliff-spires, Salt-bloom Tide-pools,
Stilllight Lantern, lantern-row, lantern-station. Things: lantern, wick,
mire-essence, mist-light, ordinary oil, fresh water, sea-water, silken thread,
clay vessel, copper cauldron, salt-bloom, chalky residue, wintergloss, feather,
ground feathers, feather store, feather ration, central pool, ledger.
Creatures: nightmoth, sky-cat, wraith. Times/tides: night, dawn, winter,
summer, autumn, new moon, full moon, moon phase, spring tide, cold wind.
Hyphenated compounds are fixed lexicon entries; use them verbatim.

## The parse-gate (admission protocol)

A sentence enters the corpus only after passing all checks — fail-closed; a
failing sentence is **rewritten, not the parser patched**:

1. **Schema validity** (deterministic): every output line is a well-formed
   `(: name content (STV s c))` atom; heads and roles are drawn from the
   parser's inventory; parentheses balance.
2. **Registry conformance** (deterministic): every entity symbol resolves to
   the registry above; every relation verb is in the consolidation map's
   enumerations.
3. **Stability under re-parse** (deterministic rule over sampled parses):
   parse the sentence k times (k ≥ 2), canonicalize (alpha-rename witnesses,
   sort atoms), and require structural agreement. Disagreement means the
   sentence sits on an ambiguity boundary — reject and rewrite. LLM
   non-determinism is thereby used as an ambiguity detector, not suffered as
   noise.
4. **Expected-core conformance** (deterministic, template-driven): a sentence
   authored from a template has a known core shape — a T-COND must yield an
   `Implication` whose premise and conclusion mention the intended
   participants; an episodic cue sentence must yield its surface connective
   head. Check presence of the core atoms modulo symbol names.

Residual semantic spot-checking is HITL, but bounded: once per sentence at
authoring time, never a runtime concern.

## What v1 knowingly gives up (and where it went)

Exact thresholds and rates (→ `>` annotations + `cycle_map.md`) · durations
and dates in laws (→ annotations) · the harbor-water alternative for boiling
(R4: Tide-pools only) · belief attributions (→ future lore re-skin) ·
wild-NL robustness (→ the FUSE-NF track; a held-out "wild annex" of free
paraphrases can be generated for its future stress-testing).
