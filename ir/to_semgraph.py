#!/usr/bin/env python3
"""Parser→IR adapter: semantic-parser PLN atoms  ->  §10.1-style sem-graph records.

Faithful reshaping (nothing dropped, nothing flattened, nothing invented):
  (: ID (Rel Args...) TV)  ->  (sem-edge G ID Rel Args...)   [splay top level, nesting kept]
                               (sem-edge-tv G ID TV)          [TV atom kept intact, e.g. (STV s c)]
  $var -> (var var)         [stored facts can't hold live MeTTa vars; matches the rule-IR convention]

Edge-reference de-duplication: if a nested ARGUMENT atom (Rel a b) is identical to an
existing standalone statement in the same graph, the argument is replaced by that
statement's id (an edge reference), so every relation is a sem-edge and arguments are
nodes OR edge-ids -- never an embedded relation literal. This dedups e.g. a nested
(Past (Member sk_cake_1 dense)) -> (Past e_cake_dense_flat).

Statement-level (And op1 op2 ...) compounds are DECOMPOSED: each operand becomes a
standalone TV-LESS sem-edge (id {sid}_cK, or a reference to an identical existing edge),
and the And edge holds the operand ids. Operands carry no TV because the And is the sole
truth-bearer (e.g. a negated conjunction at strength 0.0 -- asserting operand TVs would
assert the non-event's parts as true). Other compounds ((Implication ...)) stay
verbatim -- Implication is promoted to the sem-rule schema when the rules layer lands.

Questions: each query pattern (And c1 c2 ...) -> an answer-skeleton sem-graph (conjuncts as
sem-edges with (var _) slots). Multiple alternative queries -> multiple answer-skeletons.
A corpus item is one TASK: (qa-task V) with (task-graph V Vg) naming the molecule graph its
questions are asked against, so posing the task admits exactly that text. Each question also gets
a question-TYPE marker as an edge on that graph -- the parser classifies the question to build its
skeleton, so the type is parser output, and it arrives with the task as food no rule regenerates.

Usage:  to_semgraph.py <parsed.json> [ID,ID,...] [mol|task]
"""
import json, re, sys

def top_elements(s):
    """'(a b (c d) \"x y\")' -> ['a','b','(c d)','\"x y\"']  (respects parens + quotes)"""
    s = s.strip(); assert s[0] == '(' and s[-1] == ')', s
    out, depth, cur, inq = [], 0, '', False
    for ch in s[1:-1]:
        if inq:
            cur += ch;  inq = (ch != '"');  continue
        if ch == '"': inq = True; cur += ch; continue
        if ch == '(': depth += 1; cur += ch; continue
        if ch == ')': depth -= 1; cur += ch; continue
        if ch in ' \t' and depth == 0:
            if cur: out.append(cur); cur = ''
        else: cur += ch
    if cur: out.append(cur)
    return out

def norm(s):                          # canonical whitespace, for content matching
    return re.sub(r'\s+', ' ', s.strip())

def vars_to_data(s):                  # $x -> (var x)
    return re.sub(r'\$(\w+)', r'(var \1)', s)

def ref_args(sid, args, content2id):
    """replace any nested relation-atom arg that already exists standalone by its edge-id"""
    out = []
    for a in args:
        ref = content2id.get(norm(a))
        out.append(ref if (a.startswith('(') and ref and ref != sid) else a)
    return out

def reshape_statement(g, atom, content2id):
    # atom = '(: ID (Rel ...) (TV ...))'
    _colon, sid, stmt, tv = top_elements(atom)
    parts = top_elements(stmt)                       # [Rel, arg1, arg2, ...]
    head, args = parts[0], parts[1:]
    tv = vars_to_data(tv)
    if head == 'And':
        # decompose: operands -> standalone TV-less sem-edges (or refs to identical
        # existing edges); the And edge holds the operand ids and carries the TV
        L, refs = [], []
        for k, op in enumerate(args, 1):
            ref = content2id.get(norm(op))
            if ref and ref != sid:
                refs.append(ref)
            else:
                cid = f'{sid}_c{k}'
                op_parts = top_elements(op)
                body = vars_to_data(' '.join([op_parts[0]] + ref_args(cid, op_parts[1:], content2id)))
                L.append(f'(sem-edge {g} {cid} {body})')
                refs.append(cid)
        L.append(f'(sem-edge {g} {sid} And {" ".join(refs)})')
        L.append(f'(sem-edge-tv {g} {sid} {tv})')
        return L
    body = vars_to_data(' '.join([head] + ref_args(sid, args, content2id)))
    return [f'(sem-edge {g} {sid} {body})', f'(sem-edge-tv {g} {sid} {tv})']

def reshape_skeleton(gas, query_atom):
    _colon, _prf, pattern, tv = top_elements(query_atom)    # (: $prf (And c1 ...) TV)
    conj = top_elements(pattern)                            # ['And', c1, c2, ...]
    assert conj[0] == 'And', conj[0]
    L = [f'(sem-graph {gas})', f'(sem-graph-kind {gas} answer-skeleton)',
         f'(answer-skeleton-tv {gas} {vars_to_data(tv)})']  # the query's TV is semantic
    for i, c in enumerate(conj[1:], 1):                     # (e.g. (STV 0.0 $conf) = why-not)
        L.append(f'(sem-edge {gas} {gas}_c{i} {vars_to_data(" ".join(top_elements(c)))})')
    return L

def reshape_molecule(v):
    vid = v['id']; g = f'{vid}g'
    content2id = {}                                  # normalized statement content -> its id
    for atom in v['statements']:
        _c, sid, stmt, _tv = top_elements(atom)
        content2id.setdefault(norm(stmt), sid)
    L = [f'; --- {vid}: {" ".join(v["sentences"])}',
         f'(sem-graph {g})', f'(sem-graph-kind {g} neo-davidsonian)']
    for atom in v['statements']:
        L += reshape_statement(g, atom, content2id)
    return '\n'.join(L)

def reshape_tasks(v):
    vid = v['id']; L = [f'; --- {vid} questions', f'(qa-task {vid})', f'(task-graph {vid} {vid}g)']
    types = v.get('question_types', [])
    for qi, qtext in enumerate(v['questions'], 1):
        q = f'{vid}_q{qi}'
        L.append(f'(qa-question {vid} {q})')
        L.append(f'(question-surface {q} {json.dumps(qtext)})')
        if qi <= len(types):                       # the question-TYPE marker, on the task's graph
            L.append(f'(sem-edge {vid}g qt_{q} {types[qi-1]} {q})')
        for aj, query in enumerate(v['queries'][qi-1], 1):
            gas = f'{q}_as{aj}'
            L.append(f'(answer-skeleton {q} {gas})')
            L += reshape_skeleton(gas, query)
    return '\n'.join(L)

if __name__ == '__main__':
    data = {x['id']: x for x in json.load(open(sys.argv[1]))}
    ids  = sys.argv[2].split(',') if len(sys.argv) > 2 else list(data)
    part = sys.argv[3] if len(sys.argv) > 3 else 'mol'
    fn   = reshape_molecule if part == 'mol' else reshape_tasks
    print('\n\n'.join(fn(data[i]) for i in ids))
