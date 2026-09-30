#!/usr/bin/env python3
"""Acceptance check for the Experiment 2 adapter: re-fire the laws over the emitted IR under EXACT matching.

Reads molecules.metta and rules.metta, turns every (sem-edge G E Rel args…) into a ground fact (graph and edge id kept,
so a clause's graph and edge-id variables bind like the engine's) and every rule-lhs clause list into a conjunctive
pattern with $-variables, and unifies each rule's premise against the facts with no relaxation at all — the ingestion conventions are materialized in the IR, so exact matching must reproduce the
firing test's relaxed result. Prints the fired / silent rules and, with a reference file of rule ids, the differences.
usage: python3 exp2_check.py [EXPERIMENT_DIR] [--ref FILE] [--lore]     (default dir: this script's own; --lore also checks the lore laws)"""
import os, re, sys, collections
REF = next((sys.argv[i + 1] for i, a in enumerate(sys.argv) if a == '--ref'), None)
args = [a for i, a in enumerate(sys.argv[1:], 1) if not a.startswith('--') and sys.argv[i - 1] != '--ref']
DIR = args[0] if args else os.path.dirname(os.path.abspath(__file__))
LORE = '--lore' in sys.argv
tok = re.compile(r'\(|\)|"[^"]*"|[^\s()]+')
def parse(s):
    toks = tok.findall(s); pos = 0
    def rd():
        nonlocal pos
        t = toks[pos]; pos += 1
        if t == '(':
            out = []
            while toks[pos] != ')': out.append(rd())
            pos += 1; return tuple(out)
        return t
    return rd()
def devar(t):
    if isinstance(t, tuple):
        if len(t) == 2 and t[0] == 'var': return '$' + t[1]
        return tuple(devar(x) for x in t)
    return t
facts = []
for ln in open(f'{DIR}/molecules.metta'):
    if ln.startswith('(sem-edge '):
        t = parse(ln); facts.append(tuple(t[1:]))   # (G E Rel args…)
by_head = collections.defaultdict(list)
for f in facts: by_head[f[2]].append(f)
rules = []
for ln in open(f'{DIR}/rules.metta'):
    if ln.startswith('(rule-lhs '):
        t = parse(ln); rid = t[1]
        if not LORE and not re.match(r'R\d', rid): continue
        conj = [devar(c)[1:] for c in t[2]]   # (sem-edge (var GN) (var EN) Rel args…) -> ($GN $EN Rel args…)
        rules.append((rid, [tuple(c) for c in conj]))
def unify(p, f, b):
    if isinstance(p, str):
        if p.startswith('$'):
            if p in b: return b[p] == f
            b[p] = f; return True
        return p == f
    if not isinstance(f, tuple) or len(p) != len(f): return False
    return all(unify(x, y, b) for x, y in zip(p, f))
def cands(c, b):
    xs = by_head.get(c[2], [])
    for i, a in enumerate(c):
        if i == 2: continue
        v = b.get(a) if isinstance(a, str) and a.startswith('$') else (a if isinstance(a, str) else None)
        if v is not None: xs = [f for f in xs if len(f) > i and f[i] == v]
    return xs
def match(rest, b):
    if not rest: return b
    scored = sorted(((len(cands(c, b)), i) for i, c in enumerate(rest)), key=lambda x: x[0]); n, i = scored[0]
    if n == 0: return None
    c = rest[i]
    for f in cands(c, b):
        nb = dict(b)
        if unify(c, f, nb):
            r = match(rest[:i] + rest[i+1:], nb)
            if r is not None: return r
    return None
fired = {}
for rid, conj in rules:
    b = match(list(conj), {})
    if b is not None: fired[rid] = b
print(f"rules: {len(rules)}   fired: {len(fired)}   silent: {len(rules) - len(fired)}   (exact matching over {len(facts)} facts)")
if REF:
    ref = {x.strip().replace('.', '_') for x in open(REF) if x.strip()}
    got = set(fired)
    print('fired but not in the reference:', sorted(got - ref) or 'none')
    print('in the reference but silent:   ', sorted(ref - got) or 'none')
else:
    print('silent:', ' '.join(rid for rid, _ in rules if rid not in fired))
