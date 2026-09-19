#!/usr/bin/env python3
"""Groundability gate for the parsed QA records (qa_parsed.json), the query-side twin of firing_test.py.

For every parse-facing text of every entry, by its mode (from qa.json):
  query         the parser's query line(s) `(: $prf (And …) $tv)`. Every non-variable symbol must exist in the pooled
                knowledge (kinds, relation heads, constants, names) — `unmatched-symbol: X` otherwise; the derived heads
                (ReasonFor, PurposeOf) are supplied by the genome, not the corpus, so they are skipped. The remaining
                conjuncts (the question's FOCUS) must ground in the pooled facts under the ingestion conventions —
                `ok (grounds in UNIT)`; `focus-in-rules-only` when they ground only inside a law (a law-level why-question,
                which needs the explanation machinery rather than fact grounding); `focus-not-grounded` otherwise.
  statement     an N premise or a C addition: the census must be ok and the premise must fire at least one world-rules
                law with one of its own witnesses bound — `fires R…` / `premise-fires-nothing`.
  intervention  a C removal: the statement's atoms, witnesses read as variables, form the intervention pattern; it must
                match at least one fact set in the pool — `matches N (cuts R…)` lists the laws whose consequent would
                regenerate the pattern's event/entity kind and so must be cut with it — else `intervention-matches-nothing`.
Verdict per entry: ok iff every text is ok. `--mock` runs the gate on a small record mocked from the parser's perspective.
usage: python3 qa_gate.py [--mock] [--no-relax]
"""
import json, re, sys, collections, os
MOCK = '--mock' in sys.argv
sys.argv = [a for a in sys.argv if a != '--mock']
src = open('firing_test.py').read().replace('print(', 'noprint(')
ns = {'noprint': lambda *a, **k: None}
sys.argv = ['firing_test.py', '--diagnose=NONE'] + [a for a in sys.argv[1:] if a == '--no-relax']
exec(compile(src, 'firing_test.py', 'exec'), ns)
facts, laws, by_head, kinds_of, unify, cands, match, order, canon, types_in, body, parse = (
    ns[k] for k in 'facts laws by_head kinds_of unify cands match order canon types_in body parse'.split())
wr = json.load(open('world_rules_parses.json'))
DERIVED = {'ReasonFor', 'PurposeOf'}
def symbols_of(term, out):
    if isinstance(term, str):
        if not term.startswith('$') and not re.fullmatch(r'-?\d+(\.\d+)?', term) and not term.startswith('"'): out.add(term)
    else:
        for x in term: symbols_of(x, out)
inventory = set()
for f in facts: symbols_of(f, inventory)
for uid, conj in laws:
    for c in conj: symbols_of(c, inventory)
inventory = {s for s in inventory if ':' not in s}   # witnesses are per unit, never a query's vocabulary
# facts stated inside the laws (premises + consequents), for the rules-only fallback
rule_atoms = collections.defaultdict(list)
for e in wr:
    for i, ss in enumerate(e['stmts']['texts']):
        uid = f"{e['id']}.{i+1}"; types = types_in(ss)
        for st in ss:
            bd = body(st)
            if isinstance(bd, tuple) and bd and bd[0] == 'Implication':
                for side in bd[1:]:
                    cs = list(side[1:]) if side and side[0] == 'And' else [side]
                    for c in cs:
                        cc = canon(c, uid, types)
                        if isinstance(cc, tuple) and cc: rule_atoms[cc[0]].append(cc)
def grounds(conjs, pool):
    """unify a conjunction against a fact index; the live pool needs no swap"""
    if pool is by_head: return match(order(conjs), {}, 0)
    saved = dict(by_head); by_head.clear(); by_head.update(pool)
    try: return match(order(conjs), {}, 0)
    finally: by_head.clear(); by_head.update(saved)
def add_unit(uid, stmts):
    """canonicalize a QA text's atoms as a unit of the pool; returns its facts"""
    types = types_in(stmts); new = []
    for st in stmts:
        bd = body(st)
        if bd is None or (isinstance(bd, tuple) and bd and bd[0] == 'Implication'): continue
        if isinstance(bd, tuple) and len(bd) == 2 and bd[0] == 'Past' and isinstance(bd[1], tuple): bd = bd[1]
        f = canon(bd, uid, types); new.append(f)
        if isinstance(f, tuple) and f and f[0] == 'GroupOf': new.append(('Member', f[1], f[2]))
    for f in new:
        if isinstance(f, tuple) and f: by_head[f[0]].append(f)
        if isinstance(f, tuple) and len(f) == 3 and f[0] == 'Member' and isinstance(f[1], str) and isinstance(f[2], str): kinds_of[f[1]].add(f[2])
    return new
def remove_unit(new):
    for f in new:
        if isinstance(f, tuple) and f and f in by_head[f[0]]: by_head[f[0]].remove(f)
def fires(uid):
    """laws whose premise binds at least one witness of unit uid"""
    out = []
    for law, conj in laws:
        oc = order(conj); hit = False
        for i in range(len(oc)):
            anchors = [f for f in cands(oc[i], {}) if any(isinstance(x, str) and x.startswith(uid + ':') for x in f)]
            for f in anchors:
                b = {}
                if unify(oc[i], f, b) and match([c for j, c in enumerate(oc) if j != i], b, 0) is not None: hit = True; break
            if hit: break
        if hit: out.append(law)
    return out
def check_query(lines):
    verdicts = []
    for ln in lines:
        bd = body(ln) if ln.startswith('(:') else None
        if bd is None:
            m = re.match(r'\(:\s+\$\w+\s+(.*)\s+(\$\w+|\(STV [^)]*\))\)\s*$', ln.strip())
            bd = parse(m.group(1)) if m else None
        if bd is None: verdicts.append('unparsed-query'); continue
        conjs = list(bd[1:]) if bd[0] == 'And' else [bd]
        conjs = [canon(c, 'Q', {}) for c in conjs]
        syms = set()
        for c in conjs: symbols_of(c, syms)
        missing = sorted(s for s in syms if s not in inventory and s not in DERIVED)
        if missing: verdicts.append('unmatched-symbol: ' + ', '.join(missing)); continue
        focus = [c for c in conjs if not (isinstance(c, tuple) and c and c[0] in DERIVED)]
        b = grounds(focus, by_head)
        if b is not None:
            units = sorted({v.split(':')[0] for v in b.values() if isinstance(v, str) and ':' in v})
            verdicts.append('ok (grounds in ' + ', '.join(units or ['constants']) + ')'); continue
        if grounds(focus, rule_atoms) is not None: verdicts.append('focus-in-rules-only'); continue
        verdicts.append('focus-not-grounded')
    return verdicts
def check_statement(uid, stmts):
    new = add_unit(uid, stmts)
    try: fired = fires(uid)
    finally: remove_unit(new)
    return ('fires ' + ', '.join(fired)) if fired else 'premise-fires-nothing'
def variabilize(f, uid):
    return tuple(('$' + x.split(':', 1)[1]) if isinstance(x, str) and x.startswith(uid + ':') else x for x in f) if isinstance(f, tuple) else f
def law_cuts(kinds):
    """laws whose consequent introduces an event/entity of one of these kinds (they would regenerate the removed pattern)"""
    cut = []
    for e in wr:
        for i, ss in enumerate(e['stmts']['texts']):
            for st in ss:
                bd = body(st)
                if isinstance(bd, tuple) and bd and bd[0] == 'Implication':
                    cons = bd[2]; cs = list(cons[1:]) if cons and cons[0] == 'And' else [cons]
                    if any(isinstance(c, tuple) and len(c) == 3 and c[0] == 'Member' and c[2] in kinds for c in cs): cut.append(f"{e['id']}.{i+1}")
    return cut
def shape(conjs):
    """a rule's structural signature: heads + constants, variables abstracted, order-free"""
    return tuple(sorted(tuple('$' if isinstance(x, str) and x.startswith('$') else x for x in c) if isinstance(c, tuple) else c for c in conjs))
def check_intervention(uid, stmts, root):
    types = types_in(stmts)
    rules = [body(st) for st in stmts if isinstance(body(st), tuple) and body(st)[0] == 'Implication']
    if root == 'rule':
        if not rules: return 'intervention-empty (no rule parsed)'
        hits = []
        for bd in rules:
            prem = canon(bd[1], uid, types); cons = canon(bd[2], uid, types)
            sig = (shape(list(prem[1:]) if prem[0] == 'And' else [prem]), shape(list(cons[1:]) if cons[0] == 'And' else [cons]))
            for e in wr + lore_rules:
                for i, ss in enumerate(e['stmts']['texts']):
                    for st in ss:
                        b2 = body(st)
                        if isinstance(b2, tuple) and b2 and b2[0] == 'Implication':
                            u2 = f"{e['id']}.{i+1}"; t2 = types_in(ss)
                            p2 = canon(b2[1], u2, t2); c2 = canon(b2[2], u2, t2)
                            if sig == (shape(list(p2[1:]) if p2[0] == 'And' else [p2]), shape(list(c2[1:]) if c2[0] == 'And' else [c2])): hits.append(u2)
        return f"matches rule {', '.join(hits)}" if hits else 'intervention-matches-nothing (no rule with this shape)'
    pat = []
    for st in stmts:
        bd = body(st)
        if bd is None or (isinstance(bd, tuple) and bd and bd[0] in ('Implication', 'Name')): continue
        if isinstance(bd, tuple) and len(bd) == 2 and bd[0] == 'Past' and isinstance(bd[1], tuple): bd = bd[1]
        f = canon(bd, uid, types)
        if isinstance(f, tuple) and f: pat.append(variabilize(f, uid))
    if not pat: return 'intervention-empty'
    if root == 'entity':   # the whole entity goes: every atom mentioning a witness or constant of the subject's kind / the subject constant
        subj = [c for c in pat if c[0] in ('Member', 'GroupOf') and isinstance(c[1], str)]
        if not subj: return 'intervention-empty (no subject)'
        kinds = {c[2] for c in subj if c[1].startswith('$')}; consts = {c[1] for c in subj if not c[1].startswith('$')}
        ents = {f[1] for f in by_head['Member'] if f[2] in kinds} | consts
        n = sum(1 for f in facts if isinstance(f, tuple) and any(x in ents for x in f))
        return f"matches {len(ents)} entities / {n} atoms (cuts {', '.join(law_cuts(kinds)) or 'no law'})" if ents else 'intervention-matches-nothing'
    b = grounds(pat, by_head)
    kinds = {c[2] for c in pat if c[0] == 'Member' and isinstance(c[1], str) and c[1].startswith('$')}
    cut = law_cuts(kinds) if root == 'event' else []
    if b is None: return f"intervention-matches-nothing{' (cuts ' + ', '.join(cut) + ')' if cut else ''}"
    units = sorted({v.split(':')[0] for v in b.values() if isinstance(v, str) and ':' in v})
    return f"matches (in {', '.join(units or ['constants'])}; cuts {', '.join(cut) or 'no law'})"
lore_rules = json.load(open('lore_parsed.json')) if os.path.exists('lore_parsed.json') else []
def gate(qa, rec):
    modes = {e['id']: e['modes'] for e in qa}; roots = {e['id']: e.get('roots', [None] * len(e['texts'])) for e in qa}; clean = 0
    for e in rec:
        verdicts = []
        for i, (t, st) in enumerate(zip(e['texts'], e['stmts']['texts'])):
            mode = modes[e['id']][i]; uid = f"{e['id']}.{i+1}"
            if st is None: verdicts.append((mode, 'PENDING')); continue
            if not st: verdicts.append((mode, 'EMPTY')); continue
            if mode == 'query': verdicts.append((mode, ' | '.join(check_query(st))))
            elif mode == 'statement': verdicts.append((mode, check_statement(uid, st)))
            elif mode == 'intervention': verdicts.append((mode, check_intervention(uid, st, roots[e['id']][i])))
        ok = all(v.startswith(('ok', 'fires', 'matches')) or 'cuts R' in v for _, v in verdicts)
        clean += ok
        print(f"[{e['id']}] {'ok' if ok else 'NOT ok'}")
        for (m, v), t in zip(verdicts, e['texts']): print(f"    {m:12s} {v}\n                 {t[:90]}")
    print(f"GATE: {clean}/{len(rec)} entries ok")
MOCK_REC = [
 {"id": "F11", "rule": "F — Factual recall", "texts": ["Who tends the Stilllight Lantern?"], "stmts": {"texts": [[
   "(: $prf (And (Member $e tend) (Agent $e $x) (Theme $e stilllight_lantern) (Name $x $n)) $tv)"]]}},
 {"id": "W15", "rule": "W — Why-questions", "texts": ["Why did a wraith emerge from the Sunken Cove on day 120 of Year 1?"], "stmts": {"texts": [[
   "(: $prf (And (Member $e emerge) (Agent $e $w) (Member $w wraith) (Source $e $s) (Member $s water) (LocatedIn $s sunken_cove) (Time $e (Day 120)) (Time $e (Year 1)) (Past $e) (ReasonFor $r $e)) $tv)"]]}},
 {"id": "N2", "rule": "N — What-next", "texts": ["A lantern at the Sunken Cove dies before dawn.", "What happens within the next lunar cycle?"], "stmts": {"texts": [
   ["(: n2_l (Member sk_lantern_1 lantern) (STV 1.0 0.99))", "(: n2_loc (LocatedIn sk_lantern_1 sunken_cove) (STV 1.0 0.99))",
    "(: n2_d (Member sk_die_1 die) (STV 1.0 0.99))", "(: n2_pat (Patient sk_die_1 sk_lantern_1) (STV 1.0 0.99))", "(: n2_t (TimeAtMost sk_die_1 dawn) (STV 1.0 0.99))"],
   ["(: $prf (And (Member $e $k) (During $e $c) (Member $c lunar_cycle)) $tv)"]]}},
 {"id": "C2", "rule": "C — Counterfactuals", "texts": ["Mist-light attracts nightmoths."], "stmts": {"texts": [[
   "(: c2_a (Member sk_attract_1 attract) (STV 1.0 0.99))", "(: c2_ag (Agent sk_attract_1 mist_light) (STV 1.0 0.99))",
   "(: c2_th (Theme sk_attract_1 sk_moths_1) (STV 1.0 0.99))", "(: c2_g (GroupOf sk_moths_1 nightmoth) (STV 1.0 0.99))"]]}},
 {"id": "C12", "rule": "C — Counterfactuals", "texts": ["The Northcove is a small cove."], "stmts": {"texts": [[
   "(: c12_n (Name northcove \"Northcove\") (STV 1.0 0.99))", "(: c12_c (Member northcove cove) (STV 1.0 0.99))", "(: c12_s (Member northcove small) (STV 1.0 0.99))"]]}},
]
if __name__ == '__main__':
    qa = json.load(open('qa.json'))
    if MOCK:
        print('== MOCK records (mocked from the parser\'s perspective; not real parses)'); gate(qa, MOCK_REC)
    elif os.path.exists('qa_parsed.json'): gate(qa, json.load(open('qa_parsed.json')))
    else: print('no qa_parsed.json yet; run with --mock to exercise the gate')
