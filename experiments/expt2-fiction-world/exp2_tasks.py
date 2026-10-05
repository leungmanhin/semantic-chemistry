#!/usr/bin/env python3
"""Experiment 2 task generator: the QA twin (qa.json) and its accepted parses (qa_parsed.json) -> tasks.metta.

One task per live QA entry. Every task is asked against the standing doc `aelmere` (task-doc) and carries a graph of its
own (task-graph) holding its question-type marker and, for an N item, the premise's parse under the ingestion conventions
of exp2_adapter.py; a task citing events Parts also admits those Parts' passages as its text (task-graph). By category:
  F, W   one parsed query -> answer-skeleton(s); a why-query's (ReasonFor $r focus) is not landed: nothing in Exp-2 derives
         that relation, so a why-question's skeleton asks for the event in question, and a grounding finds that event, not
         its reason
  N      premise statement(s) in the task's own graph + the query, which names the premise's witnesses
  C      answered by derivation diff (question-mode diff), no skeleton. The supposition is restated positively and lands
         by parse shape: a corpus sentence restated word for word, a stated generic or a kind-level relation withholds
         the corpus rules that say it (task-ablate); a kind-level relation, an event or a fact also lands as a pattern
         graph (kind intervention) with its root — entity | event | fact;
         an added statement lands as a graph admitted only in the intervened run (task-addition), an added generic as a
         rule that runs only there (task-rule)
A pattern's conjuncts — a query's or an intervention's — take the premise-side conventions of the adapter (aliases,
singletons, one Object slot, typed variables for kind fillers, place attachment) and the task-layer conventions of
REALIGNMENT.md item 1:
  t2  a participant of an open-verb event, or a To slot, is any role: one alternative skeleton per role head
  t3  an open time is any temporal head, and a season on Time is also Through / During / Throughout: one alternative each
  t6  a kind-level relation atom (a head the corpus never uses, over constants) is its event frame
  a per-member property of a group is the group's property; a Skolem-function term is a variable; a variable the pattern
  names with a name the corpus gives to one individual is that individual
The parse records are read through parse_corrections.py, which applies the hand corrections of parse_corrections.json.
usage: python3 exp2_tasks.py [EXPERIMENT_DIR]       (default: this script's own directory)"""
import collections, itertools, json, os, re, sys
sys.dont_write_bytecode = True
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import exp2_adapter as A
from exp2_adapter import show, parse, statement, isvar, is_sk, conjs_of
from parse_corrections import load_record, corrected_sids
DIR, DOC = A.DIR, A.DOC
ROLES = ['Object', 'Agent', 'Experiencer', 'Recipient', 'Stimulus', 'Beneficiary', 'Goal', 'Source', 'Location']
TEMPORAL = ['Time', 'BeforeBy', 'TimeAtMost', 'During', 'Start', 'End', 'Before', 'After']
SEASON_HEADS = ['Time', 'Through', 'During', 'Throughout']
SEASONS = {'winter', 'summer', 'spring', 'autumn'}
QTYPE = {'F': 'FactQuestion', 'W': 'WhyQuestion', 'N': 'NextQuestion', 'C': 'CounterfactualQuestion'}
EXPLANATORY = {'ReasonFor', 'PurposeOf'}
ROMAN = {r: i for i, r in enumerate('I II III IV V VI VII VIII IX X'.split(), 1)}
MAX_ALTERNATIVES = 81
# ---- what the corpus says: its relation heads and their arities, its rules by kind signature ------------------
def tops_of(bd):
    if bd[0] == 'Implication': return conjs_of(bd[1]) + conjs_of(bd[2])
    if bd[0] in A.TENSE and len(bd) == 2 and isinstance(bd[1], tuple): return [bd[1]]
    return [bd]
KNOWN_HEADS, ARITY = set(), collections.defaultdict(set)
for _uid, _kind, _ss, _ in A.UNITS:
    for _st in _ss:
        _bd = statement(_st)[1]
        if isinstance(_bd, tuple) and _bd:
            for _c in tops_of(_bd):
                if isinstance(_c, tuple) and _c and isinstance(_c[0], str): KNOWN_HEADS.add(_c[0]); ARITY[_c[0]].add(len(_c) - 1)
def skvar(t):
    """a Skolem-function term (sk_f x …) in a pattern is a variable named after it"""
    if isinstance(t, tuple) and t and isinstance(t[0], str) and t[0].startswith('sk_'): return '$' + t[0] + '_' + '_'.join(str(x).strip('$') for x in t[1:])
    return tuple(skvar(x) for x in t) if isinstance(t, tuple) else t
def kinds_in(conjs):
    return tuple(sorted(c[2] for c in conjs if isinstance(c, tuple) and len(c) == 3 and c[0] in ('Member', 'GroupOf') and isinstance(c[2], str) and not isvar(c[2])))
def signature(u, bd):
    """a generic's kind signature: the kinds its premise types and the kinds its consequent types"""
    side = lambda s: kinds_in([u.normalize_head(u.rename(skvar(c))) for c in conjs_of(s)])
    return side(bd[1]), side(bd[2])
def symbols_in(t, out):
    if isinstance(t, tuple):
        for x in t: symbols_in(x, out)
    elif not isvar(t): out.add(t)
    return out
LANDED = A.landed_units()
RULES_OF_TEXT = collections.defaultdict(list)   # a corpus sentence -> the rules it lands
RULE_SAYS = {}                                  # rule -> (the kinds its consequent types, every symbol it mentions, its strength, its sentence)
for _u, _rs in LANDED:
    for _rid, _sid, _bd, _tv in _rs:
        RULES_OF_TEXT[A.TEXT[_u.uid].strip()].append(_rid)
        _atoms = [_u.normalize_head(_u.rename(skvar(c))) for c in conjs_of(_bd[1]) + conjs_of(_bd[2])]
        RULE_SAYS[_rid] = (set(signature(_u, _bd)[1]), set().union(*(symbols_in(c, set()) for c in _atoms)), _tv[0], A.TEXT[_u.uid])
def concluding(kinds, mentions):
    """the positive rules that conclude every one of `kinds` and mention a symbol of each group in `mentions`"""
    return [rid for rid, (ck, syms, strength, _) in RULE_SAYS.items() if strength >= 0.5 and kinds and set(kinds) <= ck and all(g & syms for g in mentions)]
_names = collections.defaultdict(set)
for _u, _rs in LANDED:
    for _eid, _bd, _tv in _u.edges:
        if isinstance(_bd, tuple) and len(_bd) == 3 and _bd[0] == 'Name' and isinstance(_bd[1], str): _names[_bd[2]].add(_bd[1])
NAMED = {name: next(iter(cs)) for name, cs in _names.items() if len(cs) == 1}   # a name the corpus gives to exactly one constant
PASSAGES = collections.defaultdict(list)   # events Part -> its passages' graphs
for _u, _rs in LANDED:
    if _u.kind == 'event' and _u.edges: PASSAGES[int(re.match(r'E(\d+)-', _u.uid).group(1))].append(_u.tag)
def cited_passages(raw):
    """the passages of the events Parts an entry cites ("events Part V", "events Parts I, IV, VII", "events Part VII–VIII")"""
    m = re.search(r'events Parts? ([IVX,–\- ]+)', raw or ''); parts = []
    for piece in re.split(r',\s*', m.group(1).strip()) if m else []:
        ends = [ROMAN[x.strip()] for x in re.split(r'[–-]', piece) if x.strip() in ROMAN]
        if ends: parts += range(ends[0], ends[-1] + 1)
    return [g for p in parts for g in PASSAGES[p]]
# ---- statements ------------------------------------------------------------------------------------------------
def expand_frames(stmts):
    """t6: a kind-level relation atom is its event frame"""
    out = []
    for st in stmts:
        sid, bd, tv = statement(st)
        if isinstance(bd, tuple) and len(bd) == 3 and bd[0] not in KNOWN_HEADS and bd[0][:1].isupper() and all(isinstance(x, str) and not isvar(x) for x in bd[1:]):
            ev, tvs = f"sk_{bd[0].lower()}_rel", f"(STV {tv[0]} {tv[1]})"
            out += [f"(: {sid}_frame (Member {ev} {bd[0].lower()}) {tvs})", f"(: {sid}_agent (Agent {ev} {bd[1]}) {tvs})", f"(: {sid}_object (Object {ev} {bd[2]}) {tvs})"]
        else: out.append(st)
    return out
def entry_unit(tid, landed, typing_only, corrected=()):
    """the entry's one scope: `landed` statements become its facts; `typing_only` statements only type its witnesses"""
    u = A.Unit(tid, 'task', landed, corrected)
    for st in typing_only:
        bd = statement(st)[1]
        if isinstance(bd, tuple) and len(bd) == 3 and bd[0] in ('Member', 'GroupOf') and is_sk(bd[1]) and isinstance(bd[2], str): u.types.setdefault(bd[1], set()).add(bd[2])
    u.convert(); return u
# ---- patterns: a query's or an intervention's conjuncts ---------------------------------------------------------
def pattern_alternatives(u, conjs, fresh):
    """the alternative conjunct lists of one pattern, each under the premise-side conventions"""
    conjs = [skvar(c) for c in conjs]
    named = {c[1]: NAMED[c[2]] for c in conjs if isinstance(c, tuple) and len(c) == 3 and c[0] == 'Name' and isvar(c[1]) and c[2] in NAMED}
    def resolve(t): return named.get(t, t) if isinstance(t, str) else tuple(resolve(x) for x in t)
    conjs = [resolve(c) for c in conjs]                                                                      # a variable the question names is that individual
    conjs = [('Member', c[1][2], c[2][2]) if (isinstance(c, tuple) and len(c) == 3 and c[0] == 'Implication' and isinstance(c[1], tuple) and c[1][0] == 'PartOf'
                                           and isinstance(c[2], tuple) and c[2][0] == 'Member' and c[2][1] == c[1][1]) else c for c in conjs]   # a group's per-member property
    open_ev = {c[1] for c in conjs if isinstance(c, tuple) and len(c) == 3 and c[0] == 'Member' and isvar(c[1]) and isvar(c[2])}
    slots = []
    for c in conjs:
        h = u.normalize_head(c)[0] if isinstance(c, tuple) and c else None
        if h and len(c) == 3 and not isinstance(c[2], tuple) and (h == 'To' or (h in ROLES and c[1] in open_ev)):
            slots.append([(r, c[1], c[2]) for r in ROLES])                                                    # t2
        elif h == 'Time' and len(c) == 3 and isvar(c[2]):
            slots.append([(th, c[1], c[2]) + tuple(fresh() for _ in range(n - 2)) for th in TEMPORAL for n in sorted(ARITY.get(th, {2}))])   # t3
        elif h == 'Time' and len(c) == 3 and c[2] in SEASONS:
            slots.append([(sh, c[1], c[2]) for sh in SEASON_HEADS])                                           # t3
        else: slots.append([c])
    alts = []
    for combo in itertools.product(*slots):
        cj = A.premise_conjuncts(u, list(combo), fresh)
        if cj not in alts: alts.append(cj)
    return alts
def query_patterns(u, lines):
    """every alternative skeleton of one question: (conjuncts, truth-value pattern)"""
    out = []; n = [0]
    def fresh(): n[0] += 1; return f"$T{n[0]}"
    for ln in lines:
        m = re.match(r'\(:\s+\$\w+\s+(.*)\s+(\$\w+|\(STV [^)]*\))\)\s*$', ln.strip()); assert m, ln
        bd, tv = parse(m.group(1)), parse(m.group(2)) if m.group(2).startswith('(') else m.group(2)
        conjs = conjs_of(bd[1]) + conjs_of(bd[2]) if bd[0] == 'Implication' else conjs_of(bd)
        conjs = [c for c in conjs if not (isinstance(c, tuple) and c and c[0] in EXPLANATORY)]   # the parser's why-query slot; nothing in Exp-2 derives it
        for cj in pattern_alternatives(u, conjs, fresh):
            if (cj, tv) not in out: out.append((cj, tv))
    return out
def witness_vars(u, t):
    """an intervention's own witnesses are its variables; a singleton or a named individual stays the constant it is"""
    if isinstance(t, tuple): return tuple(witness_vars(u, x) for x in t)
    return '$' + t if is_sk(t) and u.rename(t) == f"{u.tag}_{t}" else t
def is_frame(bd):
    return isinstance(bd, tuple) and len(bd) == 3 and bd[0] not in KNOWN_HEADS and bd[0][:1].isupper() and all(isinstance(x, str) and not isvar(x) for x in bd[1:])
def intervention(u, text, stmts, root):
    """(pattern conjuncts, effective root, withheld rule ids, notes) of one intervention text. The rules a supposition
    withholds: the rules of the corpus sentence it restates word for word; else, for a generic it states, the positive
    rules concluding what it concludes about what it is about; and, for a kind-level relation, the positive rules
    concluding that event kind of those participants."""
    parsed = [statement(st) for st in stmts]
    genus = collections.defaultdict(set)   # the supposition's own taxonomy: a kind and the kinds it says it inherits from
    for sid, bd, tv in parsed:
        if isinstance(bd, tuple) and len(bd) == 3 and bd[0] == 'Inheritance' and all(isinstance(x, str) for x in bd[1:]): genus[u.rename(bd[1])].add(u.rename(bd[2]))
    about = lambda k: {k} | genus.get(k, set())
    facts, notes = [], []; ablate = list(RULES_OF_TEXT.get(text.strip(), []))
    for sid, bd, tv in parsed:
        if not isinstance(bd, tuple) or not bd: continue
        if is_frame(bd) and not ablate: ablate += concluding({bd[0].lower()}, [about(u.rename(bd[1])), about(u.rename(bd[2]))])
        if bd[0] == 'Implication' and not (isinstance(bd[1], tuple) and bd[1] and bd[1][0] == 'PartOf' and isvar(bd[1][1])) and not RULES_OF_TEXT.get(text.strip()):
            prem_kinds, cons_kinds = signature(u, bd); found = concluding(cons_kinds, [about(k) for k in prem_kinds])
            ablate += [r for r in found if r not in ablate]
            if not found: notes.append(f"the stated generic ({sid}) has no corpus rule concluding {', '.join(cons_kinds) or 'a typed kind'}")
    for sid, bd, tv in (statement(st) for st in expand_frames(stmts)):
        if not isinstance(bd, tuple) or not bd: continue
        if bd[0] == 'Implication':
            if isinstance(bd[1], tuple) and bd[1] and bd[1][0] == 'PartOf' and isvar(bd[1][1]):   # a per-member statement holds of the group
                grp = bd[1][2]; sub = lambda t: (grp if t == bd[1][1] else tuple(sub(x) for x in t) if isinstance(t, tuple) else t)
                facts += [skvar(sub(c)) for c in conjs_of(bd[2])]
            continue
        if bd[0] in A.TENSE and len(bd) == 2 and isinstance(bd[1], tuple): bd = bd[1]
        facts += list(bd[1:]) if bd[0] == 'And' and tv[0] >= 0.5 else [bd]
    facts = [witness_vars(u, c) for c in facts if c[0] != 'Name' and not (c[0] == 'Inheritance' and all(isinstance(x, str) and not is_sk(x) for x in c[1:]))]
    n = [0]
    def fresh(): n[0] += 1; return f"$T{n[0]}"
    if root == 'entity':   # the entity is the first node the statement types
        first = next((c for c in facts if len(c) == 3 and c[0] in ('Member', 'GroupOf')), None)
        facts = [('Member', first[1], first[2])] if first else []
    pats = pattern_alternatives(u, facts, fresh) if facts and root != 'rule' else []
    if len(pats) > 1: notes.append(f"{len(pats)} alternative patterns; the first is landed")
    return (pats[0] if pats else []), ('rule' if ablate and not pats else root), ablate, notes
# ---- main ------------------------------------------------------------------------------------------------------
def main():
    qa = {e['id']: e for e in json.load(open(f'{DIR}/qa.json'))}
    out = ["; Experiment 2 — the TASK stream, pure portable facts in §10.1 sem-graph IR, landed by exp2_tasks.py from the QA twin",
           "; (qa.json) and its accepted parses (qa_parsed.json). Every task is asked against the standing doc (task-doc) and has a",
           "; graph of its own (task-graph) with its question-type marker and, for an N item, the premise's parse; a task citing",
           "; events Parts also admits their passages. F / W / N questions carry answer-skeletons — alternatives are the readings a",
           "; question licenses (any role of an open verb's participant, any temporal head of an open time). A C question is answered",
           "; by derivation diff (question-mode diff): its supposition lands as intervention patterns, withheld rules, and graphs or",
           "; rules that run only in the intervened run. No gold answer is stored: answering is grounding."]
    stats = collections.Counter(); notes = []; prio = sum(len(rs) for _, rs in LANDED)
    for e in load_record(f'{DIR}/qa_parsed.json'):
        q = qa[e['id']]
        if q.get('retired'): continue
        tid, cat, own = e['id'], q['category'], f"{e['id']}g"
        texts = list(zip(e['texts'], e['stmts']['texts'], q['modes'], q.get('roots') or [None] * len(e['texts'])))
        readings = [x for t, st, mode, root in texts if mode != 'query' for x in (st or []) if not x.strip().startswith('(: ')]
        if readings: notes.append(f"{tid}: {len(readings)} alternative readings (Interpretation) are not landed")
        texts = [(t, [x for x in (st or []) if mode == 'query' or x.strip().startswith('(: ')], mode, root) for t, st, mode, root in texts]
        said = [x for t, st, mode, root in texts if mode == 'statement' for x in expand_frames(st)]
        supposed = [x for t, st, mode, root in texts if mode == 'intervention' for x in st]
        u = entry_unit(tid, said, supposed, set().union(*(corrected_sids(e, i) for i in range(len(texts)))))
        surface = ' '.join(t for t, st, mode, root in texts if mode != 'query')
        out.append(f"\n; --- {tid}: {(q['premise'] + ' ' if cat == 'C' and q.get('premise') else surface + ' ' if surface and cat != 'C' else '')}{q['question']}")
        if cat == 'C' and surface: out.append(f";     restated: {surface}")
        qid = f"{tid}_q1"
        out += [f"(qa-task {tid})", f"(task-doc {tid} {DOC})", f"(sem-graph {own})", f"(sem-graph-kind {own} neo-davidsonian)", f"(task-graph {tid} {own})"]
        out += [f"(task-graph {tid} {g})" for g in cited_passages(q.get('cites_raw'))]
        out += [f"(qa-question {tid} {qid})", f"(question-surface {qid} {json.dumps(q['question'], ensure_ascii=False)})", f"(sem-edge {own} qt_{qid} {QTYPE[cat]} {qid})"]
        stats['tasks-' + cat] += 1; stats['passage-admissions'] += len(cited_passages(q.get('cites_raw')))
        # what the entry SAYS: an N premise is the task's own text; a C addition is admitted only in the intervened run
        land = own
        if cat == 'C' and (u.edges or u.rules):
            land = f"{tid}a"
            if u.edges: out += [f"(sem-graph {land})", f"(sem-graph-kind {land} neo-davidsonian)", f"(task-addition {tid} {land})"]
        for eid, bd, tv in u.edges:
            out.append(f"(sem-edge {land} {eid} {show(bd)[1:-1]})"); out.append(f"(sem-edge-tv {land} {eid} (STV {tv[0]} {tv[1]}))")
            if eid in u.sources: out.append(f"(sem-edge-source {land} {eid} {u.sources[eid]})")
            stats['edges-' + ('addition' if cat == 'C' else 'premise')] += 1
        for sid, bd, tv in u.rules:   # a generic the entry adds: a rule licensed in the task's own context
            rid = f"{u.tag}_{sid}"; out += [f"(task-rule {tid} {rid})", A.rule_text(u, rid, bd, tv, tid, prio)]; prio += 1; stats['task-rules'] += 1
            if cat != 'C': notes.append(f"{tid}: a premise states a generic; it lands as a task rule")
        # what the entry SUPPOSES AWAY
        k = 0
        for t, st, mode, root in texts:
            if mode != 'intervention': continue
            pat, eff, ablate, ns = intervention(u, t, st or [], root)
            notes += [f"{tid}: {n}" for n in ns]
            for rid in ablate: out += [f";     withholds {rid}: {RULE_SAYS[rid][3]}", f"(task-ablate {tid} {rid})"]; stats['withheld-rules'] += 1
            if pat:
                k += 1; ig = f"{tid}_i{k}"
                out += [f"(task-intervention {tid} {ig} {eff})", f"(sem-graph {ig})", f"(sem-graph-kind {ig} intervention)"]
                out += [f"(sem-edge {ig} {ig}_c{i} {show(c)[1:-1]})" for i, c in enumerate(pat, 1)]
                stats['patterns-' + eff] += 1
            elif not ablate: notes.append(f"{tid}: the intervention lands nothing")
        # what the entry ASKS
        if q['question_mode'] == 'diff': out.append(f"(question-mode {qid} diff)")
        for t, st, mode, root in texts:
            if mode != 'query': continue
            pats = query_patterns(u, st or [])
            if len(pats) > MAX_ALTERNATIVES: notes.append(f"{tid}: {len(pats)} alternative skeletons, cut to {MAX_ALTERNATIVES}"); pats = pats[:MAX_ALTERNATIVES]
            for j, (conjs, tv) in enumerate(pats, 1):
                gas = f"{qid}_as{j}"
                out += [f"(answer-skeleton {qid} {gas})", f"(sem-graph {gas})", f"(sem-graph-kind {gas} answer-skeleton)", f"(answer-skeleton-tv {gas} {show(tv)})"]
                out += [f"(sem-edge {gas} {gas}_c{i} {show(c)[1:-1]})" for i, c in enumerate(conjs, 1)]
            stats['skeletons'] += len(pats); stats[f'questions-with-{min(len(pats), 9) if len(pats) < 9 else "9+"}-skeletons'] += 1
    open(f'{DIR}/tasks.metta', 'w').write('\n'.join(out) + '\n')
    print('tasks.metta:', {k: v for k, v in sorted(stats.items())})
    for n in notes: print('  note —', n)
if __name__ == '__main__': main()
