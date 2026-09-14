# Experiment 2 — The Lantern-Keepers of Aelmere

A small, custom fiction-world corpus designed as the Experiment-2 evaluation domain for the Semantic Chemistry minimal prototype (parent paper §10.2).

## Why this world

The world is engineered around four overlapping causal cycles so that ACS (Active Autocatalytic Set) detection has something real to find. The shape deliberately mirrors §6's biomedical example: a positive autocatalytic cycle plus a negative regulator plus context conditions, scaled down to a single coastal village.

## Files

| File | Purpose | Sentence count (approx) |
|------|---------|-------------------------|
| `world_premise.md` | One-page setup: geography, time, central tensions | ~50 |
| `world_rules.md` | 30 explicit world rules in the CONTROLLED LANGUAGE (`style_guide.md` v4 — the admission pass): each a When/Whenever-conditional + bounded variant + generic/copular/negated-generic facts; `>` lines = design annotations, not corpus | 107 |
| `world_rules.json` | **Machine-facing parse input** for the world rules — one entry per rule (`id`, `rule`, `texts`); the parser consumes exactly the `texts` arrays (annotations, headers, and rule titles excluded by construction). The `.md` is the annotated authoring view; the JSON is what the parse-gate admits. | 107 |
| `world_rules_pending.json` · `lore_pending.json` · `events_pending.json` | **The re-parse subset**: only the sentences edited since the last accepted run, in the same `{id, rule, texts}` schema — parse THIS, not the full corpus (incremental admission; everything else is frozen as accepted). Created per re-parse batch; absent when nothing is pending. | (varies) |
| `assemble_parses.py` | Merges a pending-subset parse record into the accepted full record in corpus order — per sentence for world rules and lore (matched by entry id + text), per whole entry for the events PASSAGE record (`stmts.passage` / `census.passage` per entry, `review.texts` per sentence); `--check` reports without writing. Prints the census summary — admission = every unit `ok` and no EMPTY parse. A passage whose only flagged rules sit inside a sealing head (an attitude's `Theme`, `Whether`, `Counterfactual`) counts as `ok (sealed)`. | n/a |
| `world_rules_parses.json` | Latest gate-run record (per-sentence parses + fireability census + reviewer judgments) — the evidence behind the guide/corpus revisions; earlier runs live in git history. NOT ingested. | n/a |
| `lore.md` | Background in the CONTROLLED LANGUAGE (LORE register, v3 — the batch-2 pass after gate run 2): 105 paragraph entries across the ten sections; generated from `lore.json` by `regen_lore_md.py` (`>` lines = design annotations from `lore_notes.json`) | 614 |
| `lore.json` | **Machine-facing parse input** for the lore — entries `{id, rule, texts}` (`id` = section-paragraph, e.g. `L5-02`; `rule` = section label); the SOURCE OF TRUTH for lore text. | 614 |
| `lore_notes.json` · `events_notes.json` · `regen_md.py` | Design annotations by entry id, and the md regenerator for both corpora (edit the JSON → `python3 regen_md.py lore` / `events`). NOT ingested. | n/a |
| `lore_parsed.json` | Lore's accepted gate-run record (every sentence: parses + fireability census + reviewer judgments) — the accepted record that `lore_pending_parses.json` merges into. NOT ingested. | n/a |
| `firing_test.py` | The corpus-turns-the-cycle test: unifies every world-rules premise against the pooled ground atoms of the parsed corpora under the ingestion conventions of `REALIGNMENT.md` item 1 (witness scoping, singleton-to-registry-constant resolution, group-as-member and group-level per-member rules, aliases, kind-filler matching in both directions, state-witness properties, past-tense unwrapping, Patient/Theme as one slot; `--no-relax` switches the relaxation family off) and reports which episode fires each law; `--diagnose` lists the premise conjuncts of the silent laws that have no counterpart anywhere. The ingestion adapter's acceptance test. | n/a |
| `instance_coverage.py` | Counts, per cycle step, the episodes that instantiate it and lists the episodes carrying a complete Cycle-A or Cycle-B turn in one passage — the recurrence check behind `cycle_map.md`. | n/a |
| `lint_corpus.py` | Deterministic authoring lint over a corpus JSON: the sentence shapes that mis-parse SILENTLY (census still `ok`) — indefinite-verbal generics, the capitalized plural label, banned words, non-registry names, coordinated lists, frequency adverbs on a specific subject. Run before every parse. | n/a |
| `events.json` | **Machine-facing parse input** for the events — one entry per EPISODE (`id` = part-episode, e.g. `E5-06`; `rule` = part label; `texts` = the episode's sentences in order). **Parse each entry's `texts` as ONE passage** so that a definite refers back within the episode. The SOURCE OF TRUTH for event text. | 687 |
| `events.md` | The events in the CONTROLLED LANGUAGE (EPISODIC register): 83 dated episodes over two years, one happening per sentence, the bounded cues because / so / as a result; generated from `events.json` by `regen_md.py` (`>` lines = design annotations from `events_notes.json`) | 687 |
| `qa_pairs.md` | Evaluation: factual recall, why-questions, what-next, counterfactuals | ~105 QA pairs |
| `cycle_map.md` | Reference diagram + rule-to-cycle index (NOT for parsing — design aid) | n/a |
| `style_guide.md` | The controlled language: registers, sanctioned templates, banned constructions, entity registry, authored-TV dial, and the PARSE-GATE admission protocol (NOT for parsing — design aid) | n/a |
| `expected_consolidation_map.md` | The enumerated paraphrase families and their expected merges — Tier-1 synonym merges, Tier-2 argument-structure alternations, Tier-3 negative controls — consolidation mining's grading key, as `cycle_map.md` is ACS detection's (NOT for parsing) | n/a |

Total sentence count target: ≥ 1000 narrative sentences. QA pair count: ≥ 100.

## Reading order for design review

1. `world_premise.md` — orient yourself
2. `cycle_map.md` — see the load-bearing causal structure at a glance
3. `world_rules.md` — confirm the rules cycle as intended
4. Skim `lore.md` + `events.md` — sanity-check the prose tone and rule grounding
5. Spot-check `qa_pairs.md` — confirm question types span the four categories

## Reading order for ingestion (FUSE-NF input)

The parser reads the **JSON files** (`world_rules.json`, `lore.json`, `events.json`): each entry's `texts` array lists exactly the sentences to parse, so nothing else in the repo can be mistaken for corpus. World rules and lore are parsed sentence by sentence; each events entry is parsed as ONE passage. The `.md` corpus files are the annotated authoring view (`>` lines = design annotations). `world_premise.md` is mostly setup and can be included or excluded as a baseline experiment. `cycle_map.md`, `style_guide.md`, `expected_consolidation_map.md`, and this README are design metadata and are NOT ingested.

## Canonical entities

For consistency across files, the following entities are canonical:

**People:** Meren Tallowhand (chief Keeper), Old Vesh (retired Keeper, historian), Coraline Ash (apprentice, new arrival), Joren Salt (fisherman), Brindle Coombe (Council member), Sailsworn (Council member), Hesper (Cauldron Hall warden), Pell (apprentice, second-year)

**Places:** Aelmere (the village), Cliff Path (lantern route), Sunken Cove (wraith-haunted), Salt-bloom Tide-pools (north harvest), Cauldron Hall (distillation), Cliff-spires (sky-cat roosts), the Watch (council hall), the Hollows (inland fog forest), the Northcove (cliff-shielded), the Stilllight Lantern (at Sunken Cove)

**Materials:** mire-essence (oil), silken threads (moth deposits), salt-bloom (winter additive), wintergloss (anti-moth herb), sky-cat feathers (anti-wraith)

**Creatures:** nightmoths, sky-cats, wraiths

## Status

`world_rules` is ADMITTED: all 107 sentences pass the fireability census (five gate runs, incremental admission from run 5); `world_rules_parses.json` is the accepted parse record and the reviewer's residual remarks live in `expected_consolidation_map.md`'s advisory backlog. `lore` is ADMITTED after five gate runs (`lore_parsed.json`, 614 sentences census-clean). `events` is re-skinned into the EPISODIC register (83 episodes, 687 sentences, `events.json`, including nine routine-night episodes that each close a full loop turn inside one passage); it is ADMITTED on the mechanical bar after three gate runs per entry as a passage (`events_parsed.json`, 83 passages: 82 census `ok` and 1 whose only flagged rule sits inside a sealed report, which the assembler exempts as `ok (sealed)`). `firing_test.py` fires 55 of 89 laws on that record (49 without the relaxation conventions); the silent laws are paraphrase twins whose sibling fires, negative and social laws without an instance, two laws whose antecedent never happens by story design (no lantern at the Sunken Cove is left untended or dies), and eight laws whose literal antecedent state the corpus does not yet carry (a Keeper typing for Bevin Coombe, lanterns located in the Northcove, the feather store's size, warded and away-from states, summer hunts, a drained-lantern report). The QA file dates Coraline Ash's investiture to the spring of Year 2 (F30) while the corpus calendar puts it on day 260 of Year 1; the QA line is the one to fix. Later expansion with LLM-generated paraphrase variants goes through the same parse-gate.
