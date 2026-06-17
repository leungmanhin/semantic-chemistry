#!/usr/bin/env python3
"""
End-to-end Python ≡ PeTTa log-equivalence capstone for the P0–P4 port.

The per-module PeTTa tests freeze hand-checked numbers against the Python oracle;
this harness instead does the WHOLE-RUN diff the freezing stands in for — it runs
both backends and compares their logs directly, across the two core layers:
  P0  the kernel event log (firings)
  P1  the evaluator mints (typed fuel by clamp)
It is the eq-30 test one rung down (Log_Python ≡ Log_PeTTa), the rehearsal for the
later Log_PeTTa ≡ Log_MeTTaIL backend swap. Host-orchestrated by design (the replay-
comparison / evaluator layer, MSC §6.2), so it lives in Python and drives the PeTTa
executor as a subprocess (petta/dump_p0_log.metta, petta/dump_p1_log.metta).

Equivalence is "modulo backend tags + harmless id-allocation differences" (eq-30),
so we compare NORMALIZED MULTISETS rather than a strict seq-by-seq diff —
  * id-renaming:    Python AL_<Q>_<cls> / A_<Q>_<cls>  ==  PeTTa (al <Q> <cls>) / (a <Q> <cls>)
  * abstain split:  Python folds abstain into R_align; PeTTa has R_abstain as its own
                    rule (same firings, different seq within the align stage).
Both sides normalize each firing to (stage, Q, cls[, role, filler]) and each mint to
(Q, cls, token, n). PASS iff the multisets are equal on both layers.

Usage:  python3 src/equivalence.py        # exit 0 = PASS
"""
import os
import re
import subprocess
from collections import Counter
from pathlib import Path

from kernel import REPO, DATA, GENOME, parse_facts, run_chamber, _tok, _read
from evaluator import run_mortal, BALANCE_SEED

# PeTTa runner: a sibling repo by default (../PeTTa/run.sh); override with $PETTA_RUN.
PETTA_RUN = Path(os.environ.get("PETTA_RUN", str(REPO.parent / "PeTTa" / "run.sh")))
DUMP_P0   = REPO / "petta" / "dump_p0_log.metta"
DUMP_P1   = REPO / "petta" / "dump_p1_log.metta"

def _petta(dump):
    """Run a PeTTa dump harness; return its stdout+stderr with ANSI stripped."""
    out = subprocess.run(["sh", str(PETTA_RUN), str(dump)], cwd=str(REPO),
                         capture_output=True, text=True, stdin=subprocess.DEVNULL)
    return re.sub(r"\x1b\[[0-9;]*m", "", out.stdout + out.stderr)

# ----------------------------------------------------- P0: kernel firing log ----
def norm_py_fire(rule, key):
    if rule == "R_qtype":
        return ("qtype", key)
    if rule == "R_align":
        Q, cls = key.split("|")                      # "Q|cls" (cls may be 'abstain')
        return ("align", Q, cls)
    if rule == "R_complete":
        AL, rel, d = key.split("|")                  # "AL_<Q>_<cls>|rel|filler"
        _, Q, cls = AL.split("_", 2)
        return ("complete", Q, cls, rel, d)
    if rule == "R_project":
        Q, cls = key.split("|")
        return ("project", Q, cls)
    raise ValueError(f"unknown Python rule {rule}")

def norm_petta_fire(rule, key):
    if rule == "R_qtype":
        return ("qtype", key)                        # key = Q (atom)
    if rule in ("R_align", "R_abstain"):
        _al, Q, cls = key                            # (al Q cls)
        return ("align", Q, cls)
    if rule == "R_complete":
        _rf, Q, cls, rel, d = key                    # (rf Q cls rel filler)
        return ("complete", Q, cls, rel, d)
    if rule == "R_project":
        _a, Q, cls = key                             # (a Q cls)
        return ("project", Q, cls)
    raise ValueError(f"unknown PeTTa rule {rule}")

def python_fires():
    r = run_chamber(parse_facts(DATA), parse_facts(GENOME))
    return Counter(norm_py_fire(p["rule"], p["key"]) for _s, p in r["trace"])

def petta_fires():
    c = Counter()
    for line in _petta(DUMP_P0).splitlines():
        if line.strip().startswith("(EV "):
            _ev, _seq, rule, key = _read(_tok(line.strip()), 0)[0]
            c[norm_petta_fire(rule, key)] += 1
    return c

# ----------------------------------------------------- P1: evaluator mints ------
def python_mints():
    res = run_mortal(parse_facts(DATA), parse_facts(GENOME), "CL_antecedent", seed_fuel=BALANCE_SEED)
    c = Counter()
    for f in res["mint_facts"]:
        if f[0] == "answer-reward":
            _, A, tok, n = f
            _, Q, cls = A.split("_", 2)              # A_<Q>_<cls>
            c[(Q, cls, tok, int(n))] += 1
    return c

def petta_mints():
    c = Counter()
    for line in _petta(DUMP_P1).splitlines():
        if line.strip().startswith("(MINT "):
            _m, Q, cls, tok, n = _read(_tok(line.strip()), 0)[0]
            c[(Q, cls, tok, int(n))] += 1
    return c

# ------------------------------------------------------------------------- report
def report(label, py, pt):
    only_py, only_pt = py - pt, pt - py
    ok = not only_py and not only_pt
    print(f"  {label:<34} Python {sum(py.values()):>2}  PeTTa {sum(pt.values()):>2}  "
          f"-> {'PASS' if ok else 'FAIL'}")
    for s, n in only_py.items():
        print(f"      only Python ×{n}: {s}")
    for s, n in only_pt.items():
        print(f"      only PeTTa  ×{n}: {s}")
    return ok

def main():
    print("End-to-end log-equivalence  —  Python src/  ≡  PeTTa petta/   (eq-30, one rung down)\n")
    ok0 = report("P0 kernel firings", python_fires(), petta_fires())
    ok1 = report("P1 evaluator mints (CL_antecedent)", python_mints(), petta_mints())
    ok = ok0 and ok1
    print(f"\n  OVERALL: {'PASS — both core layers whole-run log-equivalent' if ok else 'FAIL'}")
    print("  (modulo the documented id-renaming + abstain-as-own-rule, eq-30.)")
    return 0 if ok else 1

if __name__ == "__main__":
    raise SystemExit(main())
