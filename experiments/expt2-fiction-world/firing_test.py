#!/usr/bin/env python3
"""Does the corpus turn the cycles? For every world-rules law, test whether its PREMISE unifies with the
pooled ground atoms of the parsed corpora (events + lore + world rules), under the ingestion conventions
of REALIGNMENT.md item 1, and report which episode fires it. The silent laws are then diagnosed atom by
atom: which premise conjunct has no counterpart anywhere in the pool.

usage: python3 firing_test.py [--no-relax] [--diagnose R2,R4,...]
Conventions applied to the pool (each is one of item 1's rules):
  scope      every sk_* witness is scoped to its passage / sentence (collisions across sentences are accidents)
  singleton  a witness typed with a registry singleton kind resolves to the registry constant
  group      (GroupOf g K) also asserts (Member g K); a per-member rule (Implication (PartOf $x g) C) also asserts
             C with $x := g (the group as a whole)
  state      a state witness with an experiencer asserts the property of the experiencer:
             (Member s P) (Experiencer s x) => (Member x P)
  alias      symbol aliases and CardinalityPhrase string normalization
  relax      a kind-constant filler in a premise matches a witness typed with that kind, a bare kind constant in a
             fact's role slot counts as an anonymous witness of that kind, and Patient / Theme are one object slot
             (all off with --no-relax)
  tense      a (Past X) ground statement asserts X; the tense stays a marker on the unit
Records: world_rules_parses.json + lore_parsed.json (sentence records) and events_parsed.json (passage record)."""
import json, re, sys, collections, os
RELAX = '--no-relax' not in sys.argv
DIAG = set(); 
for a in sys.argv[1:]:
    if a.startswith('--diagnose'): DIAG = set(a.split('=', 1)[1].split(',')) if '=' in a else {'ALL'}
SINGLETON = {"council": "council", "watch": "watch", "village": "aelmere", "sea": "cold_sea", "moon": "moon", "coast": "coast",
             "tide_pool": "salt_bloom_tide_pools", "cauldron": "cauldron", "feather_store": "feather_store", "feather_bin": "feather_bin",
             "central_pool": "central_pool", "cove_stair": "cove_stair"}
ALIAS = {"night_moth": "nightmoth", "vesh": "old_vesh", "seawater": "sea_water", "winter_gloss": "wintergloss", '"a handful"': '"handful"', '"a few"': '"few"'}
OBJECT = {"Patient", "Theme"}
TENSE = {"Past"}
tok = re.compile(r'\(|\)|"[^"]*"|[^\s()]+')
def parse(s):
    toks = tok.findall(s); pos = 0
    def rd():
        nonlocal pos
        t = toks[pos]; pos += 1
        if t == "(":
            out = []
            while toks[pos] != ")": out.append(rd())
            pos += 1; return tuple(out)
        return t
    return rd()
def body(st):
    m = re.match(r"\(:\s+\S+\s+(.*)\s+\(STV [^)]*\)\)\s*$", st.strip())
    return parse(m.group(1)) if m else None
def load():
    units = []   # (unit id, [statements])
    for e in json.load(open("world_rules_parses.json")):
        for i, s in enumerate(e["stmts"]["texts"]): units.append((f"{e['id']}.{i+1}", s, "law"))
    if os.path.exists("lore_parsed.json"):
        for e in json.load(open("lore_parsed.json")):
            for i, s in enumerate(e["stmts"]["texts"]): units.append((f"{e['id']}.{i+1}", s or [], "lore"))
    if os.path.exists("events_parsed.json"):
        for e in json.load(open("events_parsed.json")):
            units.append((e["id"], e["stmts"].get("passage") or [], "event"))
    return units
def types_in(stmts):
    t = {}
    for st in stmts:
        for m in re.finditer(r"\((?:Member|GroupOf) (sk_\w+?_\d+) (\w+)\)", st): t.setdefault(m.group(1), m.group(2))
    return t
def canon(term, uid, types):
    if isinstance(term, str):
        if term.startswith("sk_"):
            k = types.get(term)
            return SINGLETON[k] if k in SINGLETON else f"{uid}:{term}"
        return ALIAS.get(term, term)
    if term and term[0] in OBJECT and RELAX: return ("Object",) + tuple(canon(x, uid, types) for x in term[1:])
    return tuple(canon(x, uid, types) for x in term)
facts, laws = [], []
for uid, stmts, kind in load():
    types = types_in(stmts); pending = []   # group-lifted consequents, added after the unit's own facts
    for st in stmts:
        bd = body(st)
        if bd is None: continue
        if isinstance(bd, tuple) and bd and bd[0] == "Implication":
            prem = canon(bd[1], uid, types); conj = list(prem[1:]) if prem[0] == "And" else [prem]
            # a per-member rule over a group applies to the group itself: its consequent holds with $x := g, and a
            # Skolem-function term over g becomes a fresh witness of the unit (group convention)
            if len(conj) == 1 and isinstance(bd[1], tuple) and bd[1][0] == "PartOf" and isinstance(bd[1][1], str) and bd[1][1].startswith("$"):
                var, grp = bd[1][1], bd[1][2]
                def inst(t):
                    if isinstance(t, str): return grp if t == var else t
                    if t and isinstance(t[0], str) and t[0].startswith("sk_"): return f"{t[0]}({','.join(map(str, t[1:]))})"
                    return tuple(inst(x) for x in t)
                cons = inst(bd[2]); cons = list(cons[1:]) if cons and cons[0] == "And" else [cons]
                for c in cons: pending.append(canon(c, uid, types))
            if kind == "law" and not any(isinstance(a, tuple) and a[0] == "PartOf" for a in conj):
                laws.append((uid, conj))
            continue
        if isinstance(bd, tuple) and len(bd) == 2 and bd[0] in TENSE and isinstance(bd[1], tuple): bd = bd[1]   # (Past X) asserts X
        f = canon(bd, uid, types); facts.append(f)
        if isinstance(f, tuple) and f and f[0] == "GroupOf": facts.append(("Member", f[1], f[2]))
    facts.extend(pending)
# a state witness with an experiencer asserts the property of the experiencer: (Member s P) (Experiencer s x) => (Member x P)
exp = {f[1]: f[2] for f in facts if isinstance(f, tuple) and len(f) == 3 and f[0] == "Experiencer"}
facts.extend(("Member", exp[f[1]], f[2]) for f in list(facts)
             if isinstance(f, tuple) and len(f) == 3 and f[0] == "Member" and f[1] in exp and isinstance(f[2], str))
kinds_of = collections.defaultdict(set)
for f in facts:
    if isinstance(f, tuple) and len(f) == 3 and f[0] == "Member" and isinstance(f[1], str) and isinstance(f[2], str): kinds_of[f[1]].add(f[2])
by_head = collections.defaultdict(list)
for f in facts:
    if isinstance(f, tuple) and f: by_head[f[0]].append(f)
def unify(pat, fact, b):
    if isinstance(pat, str):
        if pat.startswith("$"):
            if pat in b: return b[pat] == fact
            b[pat] = fact; return True
        return pat == fact or (RELAX and isinstance(fact, str) and pat in kinds_of.get(fact, ()))
    if not isinstance(fact, tuple) or len(pat) != len(fact): return False
    return all(unify(p, f, b) for p, f in zip(pat, fact))
def cands(pat, b):
    xs = by_head.get(pat[0], []) if isinstance(pat, tuple) else []
    # narrow by any argument already bound or constant
    for i, a in enumerate(pat[1:], 1):
        key = b.get(a) if isinstance(a, str) and a.startswith("$") else (a if isinstance(a, str) else None)
        if key is None: continue
        if RELAX and isinstance(a, str) and not a.startswith("$") and i == 2 and pat[0] == "Member": continue
        # under relax a kind-constant filler also admits a witness typed with that kind (unify makes the final call)
        loose = RELAX and isinstance(a, str) and not a.startswith("$")
        xs = [f for f in xs if len(f) > i and (f[i] == key or (loose and isinstance(f[i], str) and key in kinds_of.get(f[i], ())))]
    return xs
def match(conj, b, i):
    if i == len(conj): return b
    c = conj[i]
    if RELAX and c[0] == "Member" and len(c) == 3 and isinstance(c[1], str) and c[1].startswith("$") and b.get(c[1]) == c[2]:
        return match(conj, b, i + 1)   # a bare kind constant in a role slot is an anonymous witness of its own kind
    for f in cands(conj[i], b):
        nb = dict(b)
        if unify(conj[i], f, nb):
            r = match(conj, nb, i + 1)
            if r is not None: return r
    return None
def order(conj):   # most selective conjuncts first: constants and already-seen variables
    return sorted(conj, key=lambda c: len(cands(c, {})))
fired, silent = {}, []
for uid, conj in laws:
    b = match(order(conj), {}, 0)
    if b is None: silent.append((uid, conj)); continue
    eps = sorted({v.split(":")[0] for v in b.values() if isinstance(v, str) and ":" in v and v.startswith("E")})
    fired[uid] = eps or ["(lore / constants)"]
print(f"laws: {len(laws)}   fired: {len(fired)}   silent: {len(silent)}   relax={'on' if RELAX else 'off'}")
for uid in sorted(fired, key=lambda u: (int(u[1:].split('.')[0]), int(u.split('.')[1]))): print(f"  {uid:8s} fires on {fired[uid][:6]}")
print("\nsilent laws:")
for uid, conj in silent: print(f"  {uid}")
if DIAG:
    print("\n=== diagnosis: premise conjuncts with NO counterpart in the pool ===")
    for uid, conj in silent:
        if DIAG != {'ALL'} and uid.split('.')[0] not in DIAG: continue
        print(f"\n{uid}")
        for c in conj:
            n = sum(1 for f in cands(c, {}) if unify(c, f, {}))
            print(f"   {'MISSING' if n == 0 else f'{n:6d} '}  {c}")
