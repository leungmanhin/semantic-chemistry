# Fiction-World v0 — The Lantern-Keepers of Aelmere

A small, custom fiction-world corpus designed as the v0 evaluation domain for the Semantic Chemistry minimal prototype (parent paper §10).

## Why this world

The world is engineered around four overlapping causal cycles so that ACS (Active Autocatalytic Set) detection has something real to find. The shape deliberately mirrors §6's biomedical example: a positive autocatalytic cycle plus a negative regulator plus context conditions, scaled down to a single coastal village.

## Files

| File | Purpose | Sentence count (approx) |
|------|---------|-------------------------|
| `world_premise.md` | One-page setup: geography, time, central tensions | ~50 |
| `world_rules.md` | 30 explicit world rules in the CONTROLLED LANGUAGE (`style_guide.md` v3): each a When/Whenever-conditional + bounded variant + generic/copular/negated-generic facts; `>` lines = design annotations, not corpus | 108 |
| `world_rules.json` | **Machine-facing parse input** for the world rules — one entry per rule (`id`, `rule`, `texts`); the parser consumes exactly the `texts` arrays (annotations, headers, and rule titles excluded by construction). The `.md` is the annotated authoring view; the JSON is what the parse-gate admits. | 108 |
| `world_rules_parses.json` | Latest gate-run record (per-sentence parses + fireability census + reviewer judgments) — the evidence behind the guide/corpus revisions; earlier runs live in git history. NOT ingested. | n/a |
| `lore.md` | Background: places, people, customs, recurring objects, history (free prose — controlled re-skin pending) | ~500 |
| `events.md` | Specific event narratives demonstrating rule consequences (free prose — controlled re-skin pending) | ~400 |
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

The parser reads the **JSON files** (`world_rules.json` now; JSON twins for `lore.md` and `events.md` after the pilot): each entry's `texts` array lists exactly the sentences to parse, so nothing else in the repo can be mistaken for corpus. The `.md` corpus files are the annotated authoring view (`>` lines = design annotations). `world_premise.md` is mostly setup and can be included or excluded as a baseline experiment. `cycle_map.md`, `style_guide.md`, `expected_consolidation_map.md`, and this README are design metadata and are NOT ingested.

## Canonical entities

For consistency across files, the following entities are canonical:

**People:** Meren Tallowhand (chief Keeper), Old Vesh (retired Keeper, historian), Coraline Ash (apprentice, new arrival), Joren Salt (fisherman), Brindle Coombe (Council member), Sailsworn (Council member), Hesper (Cauldron Hall warden), Pell (apprentice, second-year)

**Places:** Aelmere (the village), Cliff Path (lantern route), Sunken Cove (wraith-haunted), Salt-bloom Tide-pools (north harvest), Cauldron Hall (distillation), Cliff-spires (sky-cat roosts), the Watch (council hall), the Hollows (inland fog forest), the Northcove (cliff-shielded), the Stilllight Lantern (at Sunken Cove)

**Materials:** mire-essence (oil), silken threads (moth deposits), salt-bloom (winter additive), wintergloss (anti-moth herb), sky-cat feathers (anti-wraith)

**Creatures:** nightmoths, sky-cats, wraiths

## Status

Hand-authored draft (no LLM-assisted expansion yet). Intended as a seed corpus that can later be expanded with LLM-generated paraphrase variations and additional event narratives once the FUSE-NF parser is wired up.
