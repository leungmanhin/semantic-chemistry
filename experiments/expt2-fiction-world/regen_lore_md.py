#!/usr/bin/env python3
"""Regenerate lore.md from lore.json (source of truth) + lore_notes.json (id -> design annotation).
Sections come from each entry's `rule` prefix (the roman numeral before the em dash)."""
import json, textwrap
SECTIONS = {"I": "I. Places of Aelmere", "II": "II. The Lantern-Keepers", "III": "III. The Council and Its History",
            "IV": "IV. Customs and Daily Rituals", "V": "V. The Wraiths and Their Lore", "VI": "VI. The Sky-cats",
            "VII": "VII. The Sea and the Tides", "VIII": "VIII. Recurring Objects and Materials",
            "IX": "IX. Daily Operations at Cauldron Hall", "X": "X. Seasonal Habits and Observations"}
entries = json.load(open("lore.json")); notes = json.load(open("lore_notes.json"))
md = ["# Lore of Aelmere\n\nBackground grounding for the entities of the world rules and the event narratives, written in the controlled language of `style_guide.md` (LORE register: named individuals, places, customs, and history; law instances repeat the causal patterns so mining has multiple instances). Lines beginning with `>` are design annotations and are not part of the parseable corpus; the machine-facing parse input is `lore.json`.\n"]
cur = None
for e in entries:
    sec = e["rule"].split(" — ")[0].strip()
    if sec != cur: md.append(f"## {SECTIONS[sec]}\n"); cur = sec
    md.append(textwrap.fill(" ".join(e["texts"]), width=78, break_on_hyphens=False) + "\n")
    if e["id"] in notes: md.append("> " + notes[e["id"]] + "\n")
open("lore.md", "w").write("\n".join(md))
print("lore.md regenerated:", len(entries), "entries,", sum(len(e["texts"]) for e in entries), "sentences")
