#!/usr/bin/env python3
"""Groundability gate for the parsed QA records (qa_parsed.json), the query-side twin of firing_test.py.

Every entry is one task and one scope: all of its texts share one unit, so a question parsed with its premise
in CONTEXT names the premise's witnesses directly. Per text, by its mode (from qa.json):
  query         each alternative query line `(: $prf (And …) $tv)` (or an Implication-shaped generic question).
                Every symbol must exist in the pooled knowledge, the laws or this entry (`unmatched-symbol: X`);
                the derived heads (ReasonFor, PurposeOf) come from the genome and are skipped. The remaining
                conjuncts, the question's FOCUS, must ground in the pooled facts plus the entry's own premise under
                the ingestion conventions — `ok (grounds in UNIT)` — or unify with one world-rules / lore rule —
                `ok-law (in RULE)`, a law-level question answered by the rule rather than by a fact — else
                `focus-not-grounded at CONJUNCT`. A `To` slot on an open-verb focus ("what happens to X") is read
                as any participant role; an open `(Time e $t)` accepts any temporal head; a sealed Theme matches
                when its event kinds are covered by the fact's sealed content. The text passes if ANY alternative does.
  statement     an N premise or a C addition: a generic sentence parsed as an Implication `adds rule`; a ground
                sentence `fires R…` when a world-rules law binds one of its atoms, else `scene`. An N entry needs at
                least one premise that fires or adds a rule; a C addition may be scene-setting.
  intervention  a C removal: the statement's atoms, witnesses read as variables (a kind-level relation atom such as
                `(Attract mist_light nightmoth)` expands to its event frame), must match the pool by root — entity:
                every atom about the subject's kind / constant; event or fact: the pattern itself, naming the laws
                whose consequent would regenerate the event kind (`cuts R…`); rule: a world-rules or lore rule with
                the same premise and consequent kinds — else `intervention-matches-nothing`.
usage: python3 qa_gate.py [--mock] [--no-relax]
"""
import json, re, sys, collections, os
MOCK = '--mock' in sys.argv
LIMIT = next((int(a.split('=')[1]) for a in sys.argv if a.startswith('--limit=')), None)
sys.argv = ['firing_test.py', '--diagnose=NONE'] + [a for a in sys.argv[1:] if a == '--no-relax']
src = open('firing_test.py').read().replace('print(', 'noprint(')
ns = {'noprint': lambda *a, **k: None}
exec(compile(src, 'firing_test.py', 'exec'), ns)
facts, laws, by_head, kinds_of, unify, cands, match, order, canon, types_in, body, parse, RELAX, ATTACH = (
    ns[k] for k in 'facts laws by_head kinds_of unify cands match order canon types_in body parse RELAX ATTACH'.split())
wr = json.load(open('world_rules_parses.json')); lore = json.load(open('lore_parsed.json')) if os.path.exists('lore_parsed.json') else []
DERIVED = {'ReasonFor', 'PurposeOf'}
ROLES = ['Object', 'Agent', 'Experiencer', 'Recipient', 'Stimulus', 'Beneficiary', 'Goal', 'Source', 'Location']
TEMPORAL = ['Time', 'BeforeBy', 'TimeAtMost', 'During', 'Start', 'End', 'Before', 'After']
def skvar(t):
    """a Skolem-function term (sk_f x …) becomes a variable named after it"""
    if isinstance(t, tuple) and t and isinstance(t[0], str) and t[0].startswith('sk_'): return '$' + t[0] + '_' + '_'.join(str(x).strip('$') for x in t[1:])
    return tuple(skvar(x) for x in t) if isinstance(t, tuple) else t
def conjs_of(side): return list(side[1:]) if isinstance(side, tuple) and side and side[0] == 'And' else [side]
def kinds_in(conjs): return sorted(c[2] for c in conjs if isinstance(c, tuple) and len(c) == 3 and c[0] in ('Member', 'GroupOf') and isinstance(c[2], str) and not c[2].startswith('$'))
def symbols_of(term, out):
    if isinstance(term, str):
        if not term.startswith('$') and ':' not in term and not re.fullmatch(r'-?\d+(\.\d+)?', term) and not term.startswith('"'): out.add(term)
    else:
        for x in term: symbols_of(x, out)
# ---- the rules pool: every Implication of the world rules and the lore, variables renamed per rule
rules = []   # (uid, [premise conjs], [consequent conjs]) with '?uid.v' variables
for rec, tag in ((wr, 'R'), (lore, 'L')):
    for e in rec:
        for i, ss in enumerate(e['stmts']['texts']):
            uid = f"{e['id']}.{i+1}"; types = types_in(ss or [])
            for st in ss or []:
                bd = body(st)
                if isinstance(bd, tuple) and bd and bd[0] == 'Implication':
                    prem = conjs_of(canon(skvar(bd[1]), uid, types)); cons = conjs_of(canon(skvar(bd[2]), uid, types))
                    ren = lambda t: (('?' + uid + '.' + t[1:]) if isinstance(t, str) and t.startswith('$') else (tuple(ren(x) for x in t) if isinstance(t, tuple) else t))
                    rules.append((uid, [ren(c) for c in prem], [ren(c) for c in cons]))
inventory = set()
for f in facts: symbols_of(f, inventory)
for uid, prem, cons in rules:
    for c in prem + cons: symbols_of(c, inventory)
inventory = {s for s in inventory if not s.startswith('?')}
idx = collections.defaultdict(list)     # (head, position, value) -> facts
wok = collections.defaultdict(set)      # kind -> witnesses / constants typed with it
def index_fact(f, add=True):
    for i, a in enumerate(f[1:], 1):
        key = (f[0], i, a if isinstance(a, str) else repr(a))
        if add: idx[key].append(f)
        elif f in idx[key]: idx[key].remove(f)
    if add and len(f) == 3 and f[0] == 'Member' and isinstance(f[1], str) and isinstance(f[2], str): wok[f[2]].add(f[1])
for f in facts:
    if isinstance(f, tuple) and f: index_fact(f)
superkinds = collections.defaultdict(set)
for f in facts:
    if isinstance(f, tuple) and len(f) == 3 and f[0] == 'Inheritance' and isinstance(f[1], str) and isinstance(f[2], str): superkinds[f[1]].add(f[2])
subkinds = collections.defaultdict(set)
for k, sups in superkinds.items():
    for sp in sups: subkinds[sp].add(k)
KNOWN_HEADS = {f[0] for f in facts if isinstance(f, tuple) and f} | {c[0] for _, p, cn in rules for c in p + cn if isinstance(c, tuple) and c}
# ---- two-way unification (variables on both sides), with the relaxations of the firing test on constants
def walk(t, b):
    while isinstance(t, str) and (t.startswith('$') or t.startswith('?')) and t in b: t = b[t]
    return t
def isvar(t): return isinstance(t, str) and (t.startswith('$') or t.startswith('?'))
def unify2(a, c, b):
    a, c = walk(a, b), walk(c, b)
    if isvar(a):
        if a != c: b[a] = c
        return True
    if isvar(c): b[c] = a; return True
    if isinstance(a, str) or isinstance(c, str):
        if a == c: return True
        return bool(RELAX and isinstance(a, str) and isinstance(c, str) and (a in kinds_of.get(c, ()) or any(a in superkinds.get(k, ()) for k in kinds_of.get(c, ()))))
    if len(a) != len(c): return False
    if RELAX and a and a[0] in ATTACH and c[0] == 'AttachedTo': return all(unify2(x, y, b) for x, y in zip(a[1:], c[1:]))
    if RELAX and c and c[0] in ATTACH and a[0] == 'AttachedTo': return all(unify2(x, y, b) for x, y in zip(a[1:], c[1:]))
    return all(unify2(x, y, b) for x, y in zip(a, c))
def sealed_covers(q, f):
    """a query's sealed content is covered when its event kinds all appear in the fact's sealed content"""
    kq, kf = set(kinds_in(conjs_of(q))), set(kinds_in(conjs_of(f)))
    return bool(kq) and kq <= kf
SEASON_HEADS = ['Time', 'Through', 'During', 'Throughout']
SEASONS = ('winter', 'summer', 'spring', 'autumn')
def heads_for(c, b):
    if c[0] == 'To': return ROLES
    if c[0] == 'Time' and len(c) == 3 and isvar(walk(c[2], b)): return TEMPORAL
    if c[0] == 'Time' and len(c) == 3 and walk(c[2], b) in SEASONS: return SEASON_HEADS
    return [c[0], 'AttachedTo'] if (RELAX and c[0] in ATTACH) else [c[0]]
def candidates(c, b=None):
    """facts that could match conjunct c under binding b, from the (head, position, value) index"""
    if not isinstance(c, tuple) or not c: return []
    b = b or {}; heads = heads_for(c, b); best = None
    for i, a in enumerate(c[1:], 1):
        v = walk(a, b)
        if isvar(v): continue
        if isinstance(v, tuple):
            if any(isvar(x) for x in v): continue
            xs = [f for h in heads for f in idx.get((h, i, repr(v)), [])]
        else:
            vals = {v}
            if RELAX and ':' not in v: vals |= wok.get(v, set()) | {w for k in subkinds.get(v, ()) for w in wok.get(k, ())}
            xs = [f for h in heads for val in vals for f in idx.get((h, i, val), [])]
        if best is None or len(xs) < len(best): best = xs
    if best is not None: return best
    return [f for h in heads for f in by_head.get(h, [])]
def unify_q(c, f, b):
    if c[0] == 'To' and f[0] in ROLES: return unify2(c[1], f[1], b) and unify2(c[2], f[2], b)
    if c[0] == 'Time' and len(c) == 3 and isvar(walk(c[2], b)) and f[0] in TEMPORAL: return unify2(c[1], f[1], b)
    if c[0] == 'Time' and len(c) == 3 and f[0] in SEASON_HEADS and walk(c[2], b) in ('winter', 'summer', 'spring', 'autumn'): return unify2(c[1], f[1], b) and unify2(c[2], f[2], b)
    if c[0] == 'Theme' and len(c) == 3 and isinstance(c[2], tuple) and f[0] in ('Theme', 'Object') and isinstance(f[2], tuple):
        return unify2(c[1], f[1], b) and sealed_covers(c[2], f[2])
    return unify2(c, f, b)
def match_q(conjs, limit=50000):
    """DFS over all bindings, the most constrained conjunct first at every step; returns (binding, None) or
    (None, the conjunct that could not be satisfied at the deepest point reached)"""
    best = [-1, None]; nodes = [0]
    def dfs(rest, b):
        if nodes[0] > limit: return None
        if len(conjs) - len(rest) > best[0]: best[0] = len(conjs) - len(rest); best[1] = rest[0] if rest else None
        if not rest: return b
        scored = sorted(((len(candidates(c, b)), i) for i, c in enumerate(rest)), key=lambda x: x[0])
        n, i = scored[0]; c = rest[i]
        if n == 0:
            if len(conjs) - len(rest) >= best[0]: best[1] = c
            return None
        for f in candidates(c, b):
            nodes[0] += 1; nb = dict(b)
            if unify_q(c, f, nb):
                r = dfs(rest[:i] + rest[i+1:], nb)
                if r is not None: return r
        return None
    b = dfs(list(conjs), {})
    return (b, None) if b is not None else (None, best[1])
def match_rules(conjs, limit=4000):
    """a law-level focus: every conjunct unifies with an atom of ONE rule (premise or consequent) or with a pool fact,
    variables shared, the most constrained conjunct first; at least one conjunct must come from the rule"""
    fk = set(kinds_in(conjs))
    for uid, prem, cons in rules:
        atoms = prem + cons
        if fk and not (fk & set(kinds_in(atoms))): continue
        if not any(any(unify_q(c, a, {}) for a in atoms) for c in conjs): continue
        nodes = [0]
        def dfs(rest, b, used):
            if nodes[0] > limit: return None
            if not rest: return used
            scored = sorted(((len(candidates(c, b)) + sum(1 for a in atoms if unify_q(c, a, dict(b))), i) for i, c in enumerate(rest)), key=lambda x: x[0])
            n, i = scored[0]; c = rest[i]
            if n == 0: return None
            for a in atoms:
                nodes[0] += 1; nb = dict(b)
                if unify_q(c, a, nb):
                    r = dfs(rest[:i] + rest[i+1:], nb, True)
                    if r: return r
            for f in candidates(c, b):
                nodes[0] += 1; nb = dict(b)
                if unify_q(c, f, nb):
                    r = dfs(rest[:i] + rest[i+1:], nb, used)
                    if r: return r
            return None
        if dfs(list(conjs), {}, False): return uid
    return None
def units_of(b): return sorted({v.split(':')[0] for v in b.values() if isinstance(v, str) and ':' in v and not v.startswith('?')})
# ---- an entry's own atoms (its scope)
def entry_atoms(uid, stmts):
    """(ground facts canonicalized under uid, rules parsed as (premise, consequent)) of one text"""
    types = types_in(stmts); fs, rs = [], []
    for st in stmts:
        bd = body(st)
        if bd is None: continue
        if isinstance(bd, tuple) and bd and bd[0] == 'Implication': rs.append((conjs_of(canon(skvar(bd[1]), uid, types)), conjs_of(canon(skvar(bd[2]), uid, types)))); continue
        if isinstance(bd, tuple) and len(bd) == 2 and bd[0] == 'Past' and isinstance(bd[1], tuple): bd = bd[1]
        f = canon(bd, uid, types)
        if isinstance(f, tuple) and f:
            if len(f) == 3 and f[0] not in KNOWN_HEADS and f[0][:1].isupper() and all(isinstance(x, str) and not x.startswith('$') for x in f[1:]):
                ev = f"{uid}:sk_{f[0].lower()}_rel"   # a kind-level relation atom expands to its event frame
                fs += [('Member', ev, f[0].lower()), ('Agent', ev, f[1]), ('Object', ev, f[2])]; continue
            fs.append(f)
            if f[0] == 'GroupOf': fs.append(('Member', f[1], f[2]))
    return fs, rs
def add_facts(fs):
    for f in fs:
        by_head[f[0]].append(f); index_fact(f)
        if len(f) == 3 and f[0] == 'Member' and isinstance(f[1], str) and isinstance(f[2], str): kinds_of[f[1]].add(f[2])
def remove_facts(fs):
    for f in fs:
        if f in by_head[f[0]]: by_head[f[0]].remove(f)
        index_fact(f, add=False)
law_cons = {}   # law uid -> consequent conjuncts with the premise's own $-variables (Skolem terms as $sk_ variables)
for e in wr:
    for i, ss in enumerate(e['stmts']['texts']):
        uid = f"{e['id']}.{i+1}"; types = types_in(ss)
        for st in ss:
            bd = body(st)
            if isinstance(bd, tuple) and bd and bd[0] == 'Implication': law_cons[uid] = conjs_of(canon(skvar(bd[2]), uid, types))
def derive(uid, fs):
    """one forward hop: for every law a premise fires, its consequent instantiated under that binding"""
    out = []; fset = set(fs)
    for law, conj in laws:
        oc = order(conj)
        for i in range(len(oc)):
            for f in [x for x in cands(oc[i], {}) if x in fset]:
                b = {}
                if unify(oc[i], f, b):
                    b2 = match([c for j, c in enumerate(oc) if j != i], b, 0)
                    if b2 is None: continue
                    def inst(t):
                        if isinstance(t, str) and t.startswith('$'): return b2.get(t, f"{uid}:{t[1:]}_{law}")
                        return tuple(inst(x) for x in t) if isinstance(t, tuple) else t
                    for c in law_cons.get(law, []):
                        g = inst(c)
                        if isinstance(g, tuple) and g and not any(isinstance(x, str) and x.startswith('$') for x in g):
                            out.append(g)
                            if g[0] == 'GroupOf': out.append(('Member', g[1], g[2]))
    return out
def fires_on(fs):
    """laws whose premise binds at least one of these atoms"""
    out = []; fset = set(fs)
    for law, conj in laws:
        oc = order(conj); hit = False
        for i in range(len(oc)):
            for f in [x for x in cands(oc[i], {}) if x in fset]:
                b = {}
                if unify(oc[i], f, b) and match([c for j, c in enumerate(oc) if j != i], b, 0) is not None: hit = True; break
            if hit: break
        if hit: out.append(law)
    return out
def law_cuts(kinds):
    return [uid for uid, prem, cons in rules if uid[0] == 'R' and set(kinds_in(cons)) & set(kinds)]
# ---- checks
def check_query(uid, lines, own, types):
    best = None
    for ln in lines:
        m = re.match(r'\(:\s+\$\w+\s+(.*)\s+(\$\w+|\(STV [^)]*\))\)\s*$', ln.strip())
        bd = parse(m.group(1)) if m else None
        if bd is None: v = 'unparsed-query'
        else:
            conjs = conjs_of(canon(skvar(bd[1]), uid, types)) + conjs_of(canon(skvar(bd[2]), uid, types)) if bd[0] == 'Implication' else conjs_of(canon(skvar(bd), uid, types))
            syms = set()
            for c in conjs: symbols_of(c, syms)
            missing = sorted(s for s in syms if s not in inventory and s not in own and s not in DERIVED)
            if missing: v = 'unmatched-symbol: ' + ', '.join(missing)
            else:
                focus = [c for c in conjs if not (isinstance(c, tuple) and c and c[0] in DERIVED)]
                b, fail = match_q(focus)
                if b is not None:
                    us = units_of(b); v = 'ok (grounds in ' + ', '.join(('derived ' + x.split('_')[-1]) if '_R' in x else x for x in (us or ['constants'])) + ')'
                else:
                    r = match_rules(focus)
                    v = f'ok-law (in {r})' if r else f'focus-not-grounded at {fail}'
        rank = 2 if v.startswith('ok (') else 1 if v.startswith('ok-law') else 0
        if best is None or rank > best[0]: best = (rank, v)
    return best[1]
def check_statement(fs, rs):
    if rs: return 'adds rule (' + ' / '.join(', '.join(kinds_in(p)) + ' => ' + ', '.join(kinds_in(c)) for p, c in rs) + ')'
    fired = fires_on(fs)
    return ('fires ' + ', '.join(fired)) if fired else 'scene'
def check_intervention(uid, fs, rs, root):
    if root == 'rule':
        if not rs: return 'intervention-matches-nothing (no rule parsed)'
        hits = [ruid for p, c in rs for ruid, rp, rc in rules if (kinds_in(p), kinds_in(c)) == (kinds_in(rp), kinds_in(rc))]
        return f"matches rule {', '.join(hits)}" if hits else 'intervention-matches-nothing (no rule with these kinds)'
    pat = [tuple(('$' + x.split(':', 1)[1]) if isinstance(x, str) and x.startswith(uid + ':') else x for x in f) for f in fs if f[0] != 'Name']
    if not pat: return 'intervention-empty'
    kinds = kinds_in(pat)
    if root == 'entity':
        subj = [c for c in pat if c[0] in ('Member', 'GroupOf') and isinstance(c[1], str)]
        ks = {c[2] for c in subj if c[1].startswith('$')}; consts = {c[1] for c in subj if not c[1].startswith('$')}
        ents = {f[1] for f in by_head['Member'] if f[2] in ks} | consts
        n = sum(1 for f in facts if isinstance(f, tuple) and any(x in ents for x in f))
        return f"matches {len(ents)} entities / {n} atoms (cuts {', '.join(law_cuts(ks)) or 'no law'})" if ents else 'intervention-matches-nothing'
    b, fail = match_q(pat)
    cut = law_cuts(kinds) if root == 'event' else []
    if b is None: return f"intervention-matches-nothing at {fail}" + (f" (cuts {', '.join(cut)})" if cut else '')
    return f"matches (in {', '.join(units_of(b) or ['constants'])}; cuts {', '.join(cut) or 'no law'})"
def gate(qa, rec):
    meta = {e['id']: e for e in qa}; clean = 0; summary = collections.Counter()
    for e in (rec[:LIMIT] if LIMIT else rec):
        q = meta[e['id']]; uid = e['id']
        if q.get('retired'): continue
        print(e['id'], file=sys.stderr, end=' ', flush=True)
        parsed = [(t, st, q['modes'][i], q.get('roots', [None] * 9)[i]) for i, (t, st) in enumerate(zip(e['texts'], e['stmts']['texts']))]
        own_facts, per_text = [], []; etypes = types_in([x for _, st, _, _ in parsed for x in (st or [])])
        for t, st, mode, root in parsed:
            fs, rs = entry_atoms(uid, st or []) if st else ([], [])
            per_text.append((fs, rs)); own_facts += fs
        add_facts(own_facts); derived = derive(uid, own_facts) if q['category'] in 'NC' else []; add_facts(derived); own = set()
        for f in own_facts + derived: symbols_of(f, own)
        try:
            verdicts = []
            for (t, st, mode, root), (fs, rs) in zip(parsed, per_text):
                if st is None: verdicts.append((mode, 'PENDING')); continue
                if not st: verdicts.append((mode, 'EMPTY')); continue
                if mode == 'query': verdicts.append((mode, check_query(uid, st, own, etypes)))
                elif mode == 'statement': verdicts.append((mode, check_statement(fs, rs)))
                elif mode == 'intervention': verdicts.append((mode, check_intervention(uid, fs, rs, root)))
        finally: remove_facts(own_facts); remove_facts(derived)
        st_ok = [v for m, v in verdicts if m == 'statement']
        ok = all(v.startswith(('ok', 'fires', 'adds', 'matches', 'scene')) for _, v in verdicts) and \
             (q['category'] != 'N' or any(v.startswith(('fires', 'adds')) for v in st_ok))
        clean += ok
        for m, v in verdicts: summary[(m, v.split(' ')[0].split(':')[0])] += 1
        print(f"[{e['id']}] {'ok' if ok else 'NOT ok'}")
        for (m, v), t in zip(verdicts, e['texts']): print(f"    {m:12s} {v}\n                 {t[:90]}")
    print(f"GATE: {clean}/{sum(1 for e in rec if not meta[e['id']].get('retired'))} entries ok")
    for k in sorted(summary): print(f"   {k[0]:12s} {k[1]:28s} {summary[k]}")
MOCK_REC = [
 {"id": "F11", "rule": "F — Factual recall", "texts": ["Who tends the Stilllight Lantern?"], "stmts": {"texts": [[
   "(: $prf (And (Member $e tend) (Agent $e $x) (Theme $e stilllight_lantern) (Name $x $n)) $tv)"]]}},
 {"id": "N6", "rule": "N — What-next", "texts": ["A cold wind strikes the Cliff Path at night.", "A lantern on the Cliff Path is unprepared.", "What happens to the unprepared lantern?"], "stmts": {"texts": [
   ["(: w (Member sk_wind_1 wind) (STV 1.0 0.99))", "(: c (Member sk_wind_1 cold) (STV 1.0 0.99))", "(: s (Member sk_strike_1 strike) (STV 1.0 0.99))", "(: a (Agent sk_strike_1 sk_wind_1) (STV 1.0 0.99))", "(: o (Theme sk_strike_1 cliff_path) (STV 1.0 0.99))", "(: t (Time sk_strike_1 night) (STV 1.0 0.99))"],
   ["(: l (Member sk_lantern_1 lantern) (STV 1.0 0.99))", "(: p (On sk_lantern_1 cliff_path) (STV 1.0 0.99))", "(: u (Member sk_lantern_1 unprepared) (STV 1.0 0.99))"],
   ["(: $prf (And (Member $e $verb) (To $e sk_lantern_1)) $tv)"]]}},
 {"id": "C2", "rule": "C — Counterfactuals", "texts": ["Mist-light attracts nightmoths."], "stmts": {"texts": [["(: r (Attract mist_light nightmoth) (STV 0.9 0.9))"]]}},
]
if __name__ == '__main__':
    qa = json.load(open('qa.json'))
    if MOCK: print("== MOCK records (mocked from the parser's perspective; not real parses)"); gate(qa, MOCK_REC)
    elif os.path.exists('qa_parsed.json'): gate(qa, json.load(open('qa_parsed.json')))
    else: print('no qa_parsed.json yet; run with --mock to exercise the gate')
