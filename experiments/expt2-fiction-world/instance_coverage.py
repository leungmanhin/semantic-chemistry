#!/usr/bin/env python3
"""Count, per cycle step, the episodes that instantiate it (the recurrence check behind cycle_map.md), and
list the episodes that carry a complete Cycle-A turn in one passage.   usage: python3 instance_coverage.py [events.json]"""
import json, re, sys
ev = json.load(open(sys.argv[1] if len(sys.argv) > 1 else "events.json"))
STEPS = {
 "A  R1 burn → mist-light":        r"produced (strong |weak )?mist-light|gave weak mist-light",
 "A  R2 mist-light → moths":       r"mist-light attracted|drew (a crowd of |crowds of |many |a handful of )?nightmoths",
 "A  R3 moth lands → threads":     r"left silken threads|landed on the lantern",
 "A  R4 boil threads → essence":   r"boiled (the )?silken threads|formed in the (three |first |second |third )?cauldron",
 "A  R5 store / draw essence":     r"stored the mire-essence|filled the reservoir|refreshed the mire-essence|refilled the mire-essence|drew the stored mire-essence|with the stored mire-essence",
 "B  R6 crowd → sky-cats descend": r"crowd of nightmoths gathered|sky-cats descended",
 "B  R7 hunt → crowd shrinks":     r"hunted (the nightmoth crowd|nightmoths)|crowd .* shrank",
 "B  R8 survivors → Hollows":      r"fled to the Hollows",
 "C  R10 molt → feathers fall":    r"molted|feathers (had )?fell|feathers fall",
 "C  R15 ground feathers ward":    r"ground(ed)? (the )?feathers|warded",
 "D  R11/R12 untended/dim → wraith": r"burned dim|wraith emerged",
 "D  R13/R14 drain → weak light":  r"drained (mire-essence|six lanterns|lanterns)|drained lantern",
 "G  R16/R17 cold wind / salt-bloom": r"cold wind|salt-bloom",
 "G  R18–R20 new-moon harvest":    r"harvested salt-bloom|spring tide|new moon",
 "G  R21 wintergloss":             r"wintergloss",
 "G  R22 Northcove shielded":      r"Northcove",
}
hit = lambda e, rx: any(re.search(rx, t) for t in e["texts"])
print(f"{'cycle step':38s} {'episodes':>9s}")
for k, rx in STEPS.items(): print(f"{k:38s} {sum(hit(e, rx) for e in ev):9d}")
A = [STEPS[k] for k in STEPS if k.startswith("A ")]
print("\ncomplete Cycle-A turns in one passage (R1..R5 all present):", [e["id"] for e in ev if all(hit(e, rx) for rx in A)])
B = [STEPS[k] for k in STEPS if k.startswith("B ")]
print("complete Cycle-B turns in one passage (R6..R8 all present):", [e["id"] for e in ev if all(hit(e, rx) for rx in B)])
C = [STEPS[k] for k in STEPS if k.startswith("C ")]
print("Cycle-C molt + warding in one passage:", [e["id"] for e in ev if all(hit(e, rx) for rx in C)])
