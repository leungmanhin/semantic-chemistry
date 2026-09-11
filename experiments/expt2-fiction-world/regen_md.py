#!/usr/bin/env python3
"""Regenerate a corpus .md from its JSON source of truth plus its notes file (id -> design annotation).
Sections come from each entry's `rule` prefix (the roman numeral before the em dash).
usage: python3 regen_md.py lore|events"""
import json, sys, textwrap
CORPORA = {
 "lore": dict(json="lore.json", notes="lore_notes.json", md="lore.md", title="Lore of Aelmere",
    intro="Background grounding for the entities of the world rules and the event narratives, written in the controlled language of `style_guide.md` (LORE register: named individuals, places, customs, and history; law instances repeat the causal patterns so mining has multiple instances). Lines beginning with `>` are design annotations and are not part of the parseable corpus; the machine-facing parse input is `lore.json`.",
    sections={"I": "I. Places of Aelmere", "II": "II. The Lantern-Keepers", "III": "III. The Council and Its History",
              "IV": "IV. Customs and Daily Rituals", "V": "V. The Wraiths and Their Lore", "VI": "VI. The Sky-cats",
              "VII": "VII. The Sea and the Tides", "VIII": "VIII. Recurring Objects and Materials",
              "IX": "IX. Daily Operations at Cauldron Hall", "X": "X. Seasonal Habits and Observations"}),
 "events": dict(json="events.json", notes="events_notes.json", md="events.md", title="Event Narratives",
    intro="Dated episodes of two years in Aelmere, written in the controlled language of `style_guide.md` (EPISODIC register: one happening per sentence, past tense, named or definite participants, the bounded connective cues because / so / as a result, sealing only where a report's content is the point). Days count from the Year-1 autumn equinox (day 0); Year 2 begins on day 365. Each paragraph is ONE EPISODE and is parsed as ONE PASSAGE, so a definite refers back within the episode; the episodes give the world rules their concrete instances. Lines beginning with `>` are design annotations and are not part of the parseable corpus; the machine-facing parse input is `events.json`.",
    sections={"I": "Part I. The Equinox Week", "II": "Part II. The First Cold Snap", "III": "Part III. The First Salt-bloom Harvest",
              "IV": "Part IV. The Sky-cat Drought", "V": "Part V. First Frost and Midwinter", "VI": "Part VI. The Second New-moon Harvest",
              "VII": "Part VII. Midspring Recovery", "VIII": "Part VIII. The Following Autumn", "IX": "Part IX. Smaller Incidents Through Year 2",
              "X": "Part X. Spring of Year 2"}),
}
c = CORPORA[sys.argv[1]]
entries = json.load(open(c["json"])); notes = json.load(open(c["notes"]))
md = [f"# {c['title']}\n\n{c['intro']}\n"]
cur = None
for e in entries:
    sec = e["rule"].split(" — ")[0].strip()
    if sec != cur: md.append(f"## {c['sections'][sec]}\n"); cur = sec
    md.append(textwrap.fill(" ".join(e["texts"]), width=78, break_on_hyphens=False) + "\n")
    if e["id"] in notes: md.append("> " + notes[e["id"]] + "\n")
open(c["md"], "w").write("\n".join(md))
print(c["md"], "regenerated:", len(entries), "entries,", sum(len(e["texts"]) for e in entries), "sentences")
