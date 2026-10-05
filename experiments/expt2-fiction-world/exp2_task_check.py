#!/usr/bin/env python3
"""Preview of the Experiment 2 task stream on its landed IR: what the chamber will derive and answer, in Python.

Reads molecules.metta, rules.metta, normalizers.metta and tasks.metta and executes them the way the engine does, under EXACT
matching:
a task's pool is the graphs it admits (its docs' graphs + its own); every rule fires on every match, collect-then-fire
(one hop per epoch, a firing refused when its products are already there), each premise in a graph of its own; then
every answer-skeleton is grounded, each conjunct in a graph of its own. Per task:
  F / W / N   the groundings of the skeleton: `derived` when a cited edge was made by a firing, `given` when all are
              corpus or premise edges. A skeleton that grounds nowhere is tried at LAW level — every conjunct unifying
              with one rule's atoms or with a pool edge, at least one from the rule — which names the rule that covers
              it; nothing in the engine answers from a rule, so that verdict is diagnostic. A why-question's skeleton
              asks for the event in question, so its grounding finds that event, not a reason.
  C           what the supposition touches (given edges held out by root, rules withheld, additions) and the
              derivation diff between the factual and the intervened run. Roots: entity — every edge mentioning an
              individual the pattern types; event — the edges of the pattern's eventualities (its variables that
              carry roles), wherever the whole pattern matches; fact — the matched edges. Held out at admission and
              again after every epoch, so a firing cannot bring an instance back.
--extra=G,G admits further graphs to every selected task, which separates what a task loses to its scope from what the
landed conventions miss.
usage: python3 exp2_task_check.py [EXPERIMENT_DIR] [--epochs=N] [--only=ID,ID] [--extra=G,G] [--contexts=C,C] [--ref GATE_OUTPUT] [--show]"""
import collections, os, re, sys, time
sys.dont_write_bytecode = True
ARGV = sys.argv[1:]
REF = next((ARGV[i + 1] for i, a in enumerate(ARGV) if a == '--ref'), None)
POS = [a for i, a in enumerate(ARGV) if not a.startswith('--') and (i == 0 or ARGV[i - 1] != '--ref')]
DIR = POS[0] if POS else os.path.dirname(os.path.abspath(__file__))
opt = lambda k, d: next((a.split('=', 1)[1] for a in ARGV if a.startswith(f'--{k}=')), d)
EPOCHS = int(opt('epochs', 6)); ONLY = set(opt('only', '').split(',')) - {''}; SHOW = '--show' in ARGV
EXTRA = [g for g in opt('extra', '').split(',') if g]   # graphs admitted to every selected task on top of its own
CONTEXTS = set(opt('contexts', 'aelmere,aelmere-lore,aelmere-events').split(','))
ROLE_HEADS = {'Agent', 'Object', 'Experiencer', 'Recipient', 'Stimulus', 'Beneficiary', 'Goal', 'Source', 'Location', 'Instrument',
              'Around', 'Alongside', 'Against', 'Toward', 'With', 'Under', 'Over', 'Near', 'Off'}
CAP = 400   # solutions kept per pattern
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
def show(t): return t if isinstance(t, str) else '(' + ' '.join(show(x) for x in t) + ')'
def isvar(t): return isinstance(t, tuple) and len(t) == 2 and t[0] == 'var'
def unify(p, f, b):
    """a pattern with (var Name) markers against a ground term"""
    if isinstance(p, tuple):
        if len(p) == 2 and p[0] == 'var':
            if p[1] in b: return b[p[1]] == f
            b[p[1]] = f; return True
        if not isinstance(f, tuple) or len(p) != len(f): return False
        return all(unify(x, y, b) for x, y in zip(p, f))
    return p == f
def subst(p, b):
    if isinstance(p, tuple):
        if len(p) == 2 and p[0] == 'var': return b.get(p[1], p)
        return tuple(subst(x, b) for x in p)
    return p
def ground(t): return not isvar(t) and (not isinstance(t, tuple) or all(ground(x) for x in t))
def mentions(t, xs): return t in xs or (isinstance(t, tuple) and any(mentions(x, xs) for x in t))
class Pool:
    """edges (G E Rel arg…) indexed by relation, arity and argument"""
    def __init__(self): self.facts = set(); self.by = collections.defaultdict(list); self.idx = collections.defaultdict(list)
    def keys(self, f):
        n = len(f) - 3; yield ('R', f[2], n); yield ('R', None, n)
        for i, a in enumerate(f[3:]): yield ('A', f[2], n, i, a); yield ('A', None, n, i, a)
        yield ('E', f[1])
    def add(self, f):
        if f in self.facts: return False
        self.facts.add(f)
        for k in self.keys(f): self.idx[k].append(f)
        return True
    def remove(self, f):
        if f not in self.facts: return False
        self.facts.discard(f)
        for k in self.keys(f): self.idx[k].remove(f)
        return True
    def cands(self, c, b):
        n = len(c) - 3; rel = c[2] if isinstance(c[2], str) else b.get(c[2][1]) if isvar(c[2]) else None
        e = subst(c[1], b)
        if ground(e): return self.idx.get(('E', e), [])
        best = None
        for i, a in enumerate(c[3:]):
            v = subst(a, b)
            if ground(v):
                xs = self.idx.get(('A', rel, n, i, v), [])
                if best is None or len(xs) < len(best): best = xs
        return best if best is not None else self.idx.get(('R', rel, n), [])
def matches(pool, clauses, b0=None, cap=None):
    """every binding of a clause list, the most constrained clause first at each step"""
    out = []
    def dfs(rest, b):
        if cap and len(out) >= cap: return
        if not rest: out.append(b); return
        best = None
        for i, c in enumerate(rest):
            xs = pool.cands(c, b)
            if not xs: return
            if best is None or len(xs) < len(best[1]): best = (i, xs)
        i, xs = best; c = rest[i]; rest2 = rest[:i] + rest[i + 1:]
        for f in list(xs):
            nb = dict(b)
            if unify(c, f, nb): dfs(rest2, nb)
    dfs(list(clauses), dict(b0 or {})); return out
# ---- the landed IR ---------------------------------------------------------------------------------------------
def facts_of(name):
    """the top-level facts of a .metta file, a fact spanning as many lines as it needs"""
    buf, depth = [], 0
    for ln in open(f'{DIR}/{name}'):
        if not buf and not ln.startswith('('): continue
        bare = re.sub(r'"[^"]*"', '', ln); buf.append(ln); depth += bare.count('(') - bare.count(')')
        if depth <= 0:
            text = ''.join(buf); buf, depth = [], 0
            if text.strip().startswith('('): yield parse(text)
EDGES = collections.defaultdict(list); KIND = {}; DOCS = collections.defaultdict(list)
RULES = {}; TASKS = collections.OrderedDict(); SKELETON = collections.defaultdict(list); SKEL_TV = {}
def task(t): return TASKS.setdefault(t, dict(docs=[], graphs=[], questions=[], rules=[], ablate=[], additions=[], interventions=[]))
for name in [n for n in ('molecules.metta', 'rules.metta', 'normalizers.metta', 'tasks.metta') if os.path.exists(f'{DIR}/{n}')]:
    for f in facts_of(name):
        h = f[0]
        if h == 'sem-edge': EDGES[f[1]].append(tuple(f[1:]))
        elif h == 'sem-graph-kind': KIND[f[1]] = f[2]
        elif h == 'doc-graph': DOCS[f[1]].append(f[2])
        elif h in ('rule-context', 'rule-lhs', 'rule-rhs'): RULES.setdefault(f[1], {})[h[5:]] = f[2]
        elif h == 'qa-task': task(f[1])
        elif h == 'task-doc': task(f[1])['docs'].append(f[2])
        elif h == 'task-graph': task(f[1])['graphs'].append(f[2])
        elif h == 'qa-question': task(f[1])['questions'].append(f[2])
        elif h == 'task-rule': task(f[1])['rules'].append(f[2])
        elif h == 'task-ablate': task(f[1])['ablate'].append(f[2])
        elif h == 'task-addition': task(f[1])['additions'].append(f[2])
        elif h == 'task-intervention': task(f[1])['interventions'].append((f[2], f[3]))
        elif h == 'answer-skeleton': SKELETON[f[1]].append(f[2])
        elif h == 'answer-skeleton-tv': SKEL_TV[f[1]] = f[2]
QMODE = {f[1]: f[2] for f in facts_of('tasks.metta') if f[0] == 'question-mode'}
SURFACE = {f[1]: f[2] for f in facts_of('tasks.metta') if f[0] == 'question-surface'}
for r in RULES.values(): r['clauses'] = [tuple(c[1:]) for c in r['lhs'] if c[0] == 'sem-edge']; r['prods'] = [tuple(p[1:]) for p in r['rhs'] if p[0] == 'sem-edge']
CORPUS_RULES = [rid for rid, r in RULES.items() if r['context'] in CONTEXTS]
def pattern_of(g): return [(('var', ('g', e[1])), ('var', ('e', e[1]))) + tuple(e[2:]) for e in EDGES[g]]   # each conjunct in a graph of its own
# ---- the chamber: collect-then-fire to a fixpoint ----------------------------------------------------------------
def react(pool, rules, delta, epochs=EPOCHS, after_epoch=None, log=None):
    """fire `rules` over `pool` until nothing new appears; `delta` = the edges new since the pool last settled"""
    for ep in range(1, epochs + 1):
        new = []
        for rid in rules:
            r = RULES[rid]; seen = set()
            for i, c in enumerate(r['clauses']):
                for f in [x for x in pool.cands(c, {}) if x in delta]:
                    b = {}
                    if not unify(c, f, b): continue
                    for m in matches(pool, r['clauses'][:i] + r['clauses'][i + 1:], b, cap=20000):
                        key = tuple(sorted((repr(k), v) for k, v in m.items()))
                        if key in seen: continue
                        seen.add(key)
                        prods = [subst(p, m) for p in r['prods']]
                        if all(p in pool.facts for p in prods): continue
                        new += prods
                        if log is not None: log[rid] += 1
        delta = {p for p in new if pool.add(p)}
        if after_epoch: delta -= after_epoch(pool)
        if not delta: return ep
    return None   # not settled within the epochs
def is_derived(f): return isinstance(f[1], tuple)
# ---- grounding ---------------------------------------------------------------------------------------------------
def groundings(pool, pattern):
    """(solutions, each the list of cited edges)"""
    out = []
    for b in matches(pool, pattern, cap=CAP): out.append([subst(c, b) for c in pattern])
    return out
def cites_derived(pool, pattern):
    """is there a grounding that cites a derived edge? Searched directly, one conjunct pinned to a derived edge at a time"""
    for i in sorted(range(len(pattern)), key=lambda i: len(pool.cands(pattern[i], {}))):
        for f in [f for f in pool.cands(pattern[i], {}) if is_derived(f)]:
            b = {}
            if unify(pattern[i], f, b) and matches(pool, pattern[:i] + pattern[i + 1:], b, cap=1): return True
    return False
def verdict(pool, pattern, sols):
    """'derived' when some grounding cites an edge a firing made, 'given' when none does, 'none' without a grounding"""
    if not sols: return 'none'
    if any(any(is_derived(f) for f in s) for s in sols): return 'derived'
    return 'derived' if len(sols) >= CAP and cites_derived(pool, pattern) else 'given'   # the kept solutions may all be given ones
def walk(t, b):
    while isvar(t) and t[1] in b: t = b[t[1]]
    return t
def occurs(v, t, b):
    t = walk(t, b)
    return t[1] == v if isvar(t) else isinstance(t, tuple) and any(occurs(v, x, b) for x in t)
def unify2(a, c, b):
    """variables on both sides (a skeleton against a rule's atoms), with the occurs check"""
    a, c = walk(a, b), walk(c, b)
    if isvar(a):
        if a == c: return True
        if occurs(a[1], c, b): return False
        b[a[1]] = c; return True
    if isvar(c):
        if occurs(c[1], a, b): return False
        b[c[1]] = a; return True
    if isinstance(a, str) or isinstance(c, str): return a == c
    return len(a) == len(c) and all(unify2(x, y, b) for x, y in zip(a, c))
def rename_rule(rid, t):
    if isvar(t): return ('var', (rid, t[1]))
    return tuple(rename_rule(rid, x) for x in t) if isinstance(t, tuple) else t
RULE_ATOMS = {rid: [rename_rule(rid, c[2:]) for c in RULES[rid]['clauses'] + RULES[rid]['prods']] for rid in RULES}
def subst_walk(t, b):
    t = walk(t, b)
    return t if isvar(t) or not isinstance(t, tuple) else tuple(subst_walk(x, b) for x in t)
def law_level(pool, pattern, rules, limit=6000):
    """the first rule whose atoms, with pool edges, cover every conjunct of the pattern (at least one from the rule)"""
    conjs = sorted((c[2:] for c in pattern), key=lambda c: -sum(1 for x in c if not isvar(x)))
    for rid in rules:
        atoms = RULE_ATOMS[rid]
        if not any(unify2(c, a, {}) for c in conjs for a in atoms): continue
        nodes = [0]
        def dfs(rest, b, used):
            if nodes[0] > limit: return False
            if not rest: return used
            c = rest[0]
            for a in atoms:
                nodes[0] += 1; nb = dict(b)
                if unify2(c, a, nb) and dfs(rest[1:], nb, True): return True
            fs = pool.cands((('var', '_g'), ('var', '_e')) + tuple(subst_walk(x, b) for x in c), {})
            for f in sorted(fs, key=repr) if len(fs) <= 3000 else ():
                nodes[0] += 1; nb = dict(b)
                if unify2(c, f[2:], nb) and dfs(rest[1:], nb, used): return True
            return False
        if dfs(conjs, {}, False): return rid
    return None
# ---- interventions -----------------------------------------------------------------------------------------------
def held_out(pool, interventions):
    """the edges an intervention holds out of the pool right now"""
    out = set()
    for g, root in interventions:
        pat = pattern_of(g)
        if root == 'entity':
            c = pat[0]; ents = {subst(c[3], b) for b in matches(pool, [c])} if isvar(c[3]) else {c[3]}
            out |= {f for f in pool.facts if any(mentions(a, ents) for a in f[3:]) or mentions(f[1], ents)}
        elif root == 'event':
            ev = {c[3][1] for c in pat if c[2] in ROLE_HEADS and isvar(c[3])}
            for b in matches(pool, pat, cap=CAP * 10):
                out |= {subst(c, b) for c in pat if isvar(c[3]) and c[3][1] in ev}
        else:
            for b in matches(pool, pat, cap=CAP * 10): out |= {subst(c, b) for c in pat}
    return out
# ---- the run -----------------------------------------------------------------------------------------------------
def admitted(t, extra=()):
    gs = [g for d in t['docs'] for g in DOCS[d]] + t['graphs'] + list(extra) + EXTRA
    return [e for g in gs for e in EDGES[g]]
def main():
    t0 = time.time(); standing = Pool(); doc_graphs = {g for gs in DOCS.values() for g in gs}
    for g in doc_graphs:
        for e in EDGES[g]: standing.add(e)
    given = len(standing.facts); fired = collections.Counter()
    settled = react(standing, CORPUS_RULES, set(standing.facts), log=fired)
    print(f"standing knowledge: {len(doc_graphs)} graphs, {given} edges; {len(CORPUS_RULES)} rules in {sorted(CONTEXTS)}: {len(fired)} fire {sum(fired.values())} times, "
          f"{len(standing.facts) - given} derived edges, {'settled in ' + str(settled) + ' epochs' if settled else 'NOT settled in ' + str(EPOCHS)}  ({time.time() - t0:.1f}s)")
    ref = gate_verdicts(REF) if REF else {}
    tally = collections.Counter(); rows = []
    for tid, t in TASKS.items():
        if ONLY and tid not in ONLY: continue
        cat = tid[0]; lines = []; print(tid, end=' ', file=sys.stderr, flush=True)
        if any(QMODE.get(q) == 'diff' for q in t['questions']):
            base = [e for e in admitted(t)]
            fpool = Pool()
            for f in standing.facts: fpool.add(f)
            react(fpool, CORPUS_RULES, {e for e in base if fpool.add(e)})
            ipool = Pool(); adds = admitted(t, t['additions'])
            for e in adds: ipool.add(e)
            gone = held_out(ipool, t['interventions']); n_given = len(gone)
            for f in gone: ipool.remove(f)
            rules = [r for r in CORPUS_RULES if r not in t['ablate']] + t['rules']
            def hook(pool):
                h = held_out(pool, t['interventions'])
                for f in h: pool.remove(f)
                return h
            st = react(ipool, rules, set(ipool.facts), after_epoch=hook if t['interventions'] else None)
            lost = {f for f in fpool.facts - ipool.facts if is_derived(f)}; gained = {f for f in ipool.facts - fpool.facts if is_derived(f)}
            touches = n_given or t['ablate'] or t['additions'] or t['rules']
            v = 'touches' if touches else 'touches-nothing'
            lines.append(f"supposition: {n_given} given edges held out ({', '.join(r for _, r in t['interventions']) or 'no pattern'}), {len(t['ablate'])} rules withheld, "
                         f"{sum(len(EDGES[g]) for g in t['additions'])} edges and {len(t['rules'])} rules added; diff: {len(lost)} derived edges lost, {len(gained)} gained"
                         + ('' if st else '  [intervened run not settled]'))
            tally[(cat, v)] += 1; tally[(cat, 'diff-nonempty' if lost or gained else 'diff-empty')] += 1
            rows.append((tid, v, lines)); continue
        mark = set(standing.facts)
        delta = {e for e in admitted(t) if standing.add(e)}
        st = react(standing, CORPUS_RULES, delta)
        best = 'none'; n = 0; law = None
        for q in t['questions']:
            for gas in SKELETON[q]:
                pat = pattern_of(gas); sols = groundings(standing, pat); n += len(sols)
                v = verdict(standing, pat, sols)
                if ['none', 'given', 'derived'].index(v) > ['none', 'given', 'derived'].index(best): best = v
            if best == 'none':
                for gas in SKELETON[q]:
                    law = law_level(standing, pattern_of(gas), CORPUS_RULES)
                    if law: break
        for f in standing.facts - mark: standing.remove(f)
        fv = best if best != 'none' else ('law-level' if law else 'none')
        lines.append(f"grounds: {fv}{' (' + law + ')' if law and best == 'none' else ''} [{n}{'+' if n >= CAP else ''}]" + ('' if st else '  [not settled]'))
        tally[(cat, 'grounds ' + fv)] += 1
        rows.append((tid, fv, lines))
    for tid, v, lines in rows:
        g = ref.get(tid)
        if SHOW or ONLY or (g and compare(tid, v, g) == 'differ'):
            print(f"[{tid}] {SURFACE.get(tid + '_q1', '')}")
            for ln in lines: print('    ' + ln)
            if g: print(f"    gate: {'; '.join(g)}")
    wide_edges = sum(1 for es in EDGES.values() for e in es if len(e) - 3 > 3 and KIND.get(e[0]) == 'neo-davidsonian')
    wide_prods = sum(1 for rid in CORPUS_RULES for p in RULES[rid]['prods'] if len(p) - 3 > 3)
    wide_skel = sorted({q.rsplit('_q', 1)[0] for q, gs in SKELETON.items() for g in gs for e in EDGES[g] if len(e) - 3 > 3})
    pinned = sorted(g.rsplit('_q', 1)[0] for g, tv in SKEL_TV.items() if not isvar(tv))
    print(f"--- beyond the engine today: {wide_edges} given edges, {wide_prods} rule products and conjuncts of {', '.join(wide_skel) or 'no task'} take more than three "
          f"relation arguments; {', '.join(pinned) or 'no task'} pins a truth value, which nothing reads yet")
    print('--- by category   (W: a grounding finds the event asked about, not its reason)')
    for k in sorted(tally): print(f"   {k[0]}  {k[1]:28s} {tally[k]}")
    if ref:
        cmp = collections.Counter(compare(tid, v, ref[tid]) for tid, v, _ in rows if tid in ref)
        print(f"against the gate: {cmp['agree']} agree, {cmp['scope']} differ because the gate grounded in a passage the task does not admit, {cmp['differ']} differ otherwise"
              f" ({', '.join(tid for tid, v, _ in rows if tid in ref and compare(tid, v, ref[tid]) == 'differ') or 'none'})")
    print(f"({time.time() - t0:.0f}s)")
def gate_verdicts(path):
    out = collections.defaultdict(list); cur = None
    for ln in open(path):
        m = re.search(r'\[(\w+)\] (ok|NOT ok)\s*$', ln)
        if m: cur = m.group(1); continue
        m = re.match(r'\s+(query|statement|intervention)\s+(.*)', ln)
        if m and cur: out[cur].append(f"{m.group(1)} {m.group(2).strip()}")
    return out
def compare(tid, v, g):
    """the preview's verdict against the gate's: 'agree', 'scope' (the gate grounded in a graph the task does not admit) or 'differ'"""
    q = next((x for x in g if x.startswith('query')), None)
    if tid[0] == 'C': return 'agree' if v == 'touches' else 'differ'
    if q is None: return 'agree'
    if 'ok-law' in q: return 'agree' if v == 'law-level' else 'differ'
    if 'grounds in derived' in q: return 'agree' if v == 'derived' else 'differ'
    if q.startswith('query ok'):
        if v in ('given', 'derived'): return 'agree'
        t = TASKS[tid]; mine = {g2 for d in t['docs'] for g2 in DOCS[d]} | set(t['graphs'])
        used = {re.sub(r'[^A-Za-z0-9_-]', '_', u) for u in re.findall(r'\b[RLE]\d+-?\d*(?:\.\d+)?', q)}
        return 'scope' if used - mine else 'differ'
    return 'agree' if v == 'none' else 'differ'
if __name__ == '__main__': main()
