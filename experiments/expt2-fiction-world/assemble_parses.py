#!/usr/bin/env python3
"""Assemble a full parse record from the accepted record plus a pending-subset record.

usage:  python3 assemble_parses.py [--check] [PENDING_PARSES] [FULL_PARSES] [CORPUS]
        world rules: python3 assemble_parses.py                (defaults: world_rules_*.json)
        lore:        python3 assemble_parses.py lore_pending_parses.json lore_parsed.json lore.json
        events:      python3 assemble_parses.py events_pending_parses.json events_parsed.json events.json

Two record shapes are handled. A SENTENCE record (world rules, lore) holds per-sentence
`stmts` / `review` / `census` arrays parallel to `texts`; sentences are matched by entry id
plus exact text (a sentence may recur in another entry as a deliberate instance), and each
corpus sentence takes its entry from the PENDING record if present there, else from the FULL
record. A PASSAGE record (events) holds one `stmts.passage` list and one `census.passage`
value per entry, with `review.texts` still per sentence; an entry is matched as a whole by
id plus its exact text list, PENDING first, then FULL. Anything unmatched is STILL PENDING.
The merged record is written back to FULL_PARSES in corpus order (a .bak copy of the previous
record is kept) and the census is summarised — admission = every unit `ok` AND no EMPTY parse
(a unit whose parse holds no statement contributes nothing; it is dropped or restated).
"""
import json, os, shutil, sys
CHECK = '--check' in sys.argv; sys.argv = [a for a in sys.argv if a != '--check']
pend_p = sys.argv[1] if len(sys.argv) > 1 else 'world_rules_pending_parses.json'
full_p = sys.argv[2] if len(sys.argv) > 2 else 'world_rules_parses.json'
corp_p = sys.argv[3] if len(sys.argv) > 3 else 'world_rules.json'
corpus = json.load(open(corp_p)); full = json.load(open(full_p)) if os.path.exists(full_p) else []
pend = json.load(open(pend_p)) if os.path.exists(pend_p) else []
KEYS = ('stmts', 'review', 'census')
def is_passage(e): return isinstance(e.get('stmts'), dict) and 'passage' in e['stmts']
import re
# A rule nested under a sealing head (an attitude's Theme, Whether, Counterfactual) is inert by design, so a
# census flag caused only by such rules is not a defect: exempt the passage iff every TOP-LEVEL Implication has
# a fireable premise (no sk-function term, every sk constant asserted at top level).
def sealed_only(stmts):
    top_sk = set()
    for st in stmts:
        if '(Implication' not in st: top_sk.update(re.findall(r'\bsk_\w+?_\d+\b', st))
    for st in stmts:
        if '(Implication' not in st: continue
        body = st.split('(Implication', 1)[1]
        pre = st.split('(Implication', 1)[0]
        if re.search(r'\((Theme|Whether|Counterfactual|Directive|Forbid|Question)\b', pre): continue   # sealed rule
        depth = 0; i = 0
        while i < len(body):
            if body[i] == '(': depth += 1
            elif body[i] == ')':
                depth -= 1
                if depth == 0: break
            i += 1
        premise = body[:i + 1]
        if re.search(r'\(sk_\w+ \$', premise): return False
        if any(k not in top_sk for k in re.findall(r'\bsk_\w+?_\d+\b', premise)): return False
    return True
PASSAGE = any(is_passage(e) for e in full + pend)

# index the records: per (id, text) for sentence records, per (id, text-tuple) for passage records
def index(rec):
    out = {}
    for e in rec:
        if is_passage(e): out[(e['id'], tuple(e['texts']))] = e; continue
        for i, s in enumerate(e['texts']):
            out[(e['id'], s)] = {k: e[k]['texts'][i] for k in KEYS if k in e and 'texts' in e[k]}
    return out
have = index(full); have.update(index(pend))   # pending wins
merged, missing, dead, empty = [], [], [], []
for r in corpus:
    if PASSAGE:
        key = (r['id'], tuple(r['texts']))
        if key in have:
            e = have[key]
            merged.append({'id': r['id'], 'rule': r['rule'], 'texts': list(r['texts']), 'stmts': e['stmts'],
                           'review': e.get('review', {'texts': []}), 'census': e['census']})
            c = e['census'].get('passage')
            if c != 'ok' and sealed_only(e['stmts'].get('passage') or []): c = 'ok (sealed)'
            if c not in ('ok', 'ok (sealed)'): dead.append((r['id'], c, r['texts'][0]))
            if not e['stmts'].get('passage'): empty.append((r['id'], r['texts'][0]))
        else:
            missing.append((r['id'], f"{r['texts'][0]} … ({len(r['texts'])} sentences)"))
            merged.append({'id': r['id'], 'rule': r['rule'], 'texts': list(r['texts']), 'stmts': {'passage': None},
                           'review': {'texts': [None] * len(r['texts'])}, 'census': {'passage': None}})
        continue
    ent = {'id': r['id'], 'rule': r['rule'], 'texts': list(r['texts'])}
    for k in KEYS: ent[k] = {'texts': []}
    for s in r['texts']:
        key = (r['id'], s)
        if key not in have: missing.append((r['id'], s)); [ent[k]['texts'].append(None) for k in KEYS]; continue
        for k in KEYS: ent[k]['texts'].append(have[key].get(k))
        if have[key].get('census') not in (None, 'ok'): dead.append((r['id'], have[key]['census'], s))
        if have[key].get('stmts') == []: empty.append((r['id'], s))
    merged.append(ent)
if not CHECK:
    if os.path.exists(full_p): shutil.copy(full_p, full_p + '.bak')
    json.dump(merged, open(full_p, 'w'), indent=2, ensure_ascii=False); open(full_p, 'a').write('\n')
unit = 'passages' if PASSAGE else 'sentences'
n = len(corpus) if PASSAGE else sum(len(r['texts']) for r in corpus)
print(f'merged {n - len(missing)}/{n} {unit} into {full_p} ({len(index(pend))} from pending)')
for rid, s in missing: print(f'  STILL PENDING [{rid}] {s}')
for rid, c, s in dead: print(f'  CENSUS {c} [{rid}] {s[:70]}')
for rid, s in empty: print(f'  EMPTY parse [{rid}] {s[:70]}')
print('ADMISSION:', f'clean — every {unit[:-1]} census ok, none empty' if not (missing or dead or empty) else 'NOT yet')
