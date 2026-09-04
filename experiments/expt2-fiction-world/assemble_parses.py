#!/usr/bin/env python3
"""Assemble a full parse record from the accepted record plus a pending-subset record.

usage:  python3 assemble_parses.py [--check] [PENDING_PARSES=world_rules_pending_parses.json]
        (lore:  python3 assemble_parses.py lore_pending_parses.json lore_parses.json lore.json)
                                   [FULL_PARSES=world_rules_parses.json]
                                   [CORPUS=world_rules.json]

Sentences are matched by exact text (unique across the corpus). For every corpus
sentence the assembler takes the per-sentence stmts/review/census entry from the
PENDING record if present there, else from the FULL record; a sentence found in
neither is reported as STILL PENDING. The merged record is written back to
FULL_PARSES in corpus order (a .bak copy of the previous record is kept), and the
census is summarised — admission = every sentence `ok`.
"""
import json, os, shutil, sys
CHECK = '--check' in sys.argv; sys.argv = [a for a in sys.argv if a != '--check']
pend_p = sys.argv[1] if len(sys.argv) > 1 else 'world_rules_pending_parses.json'
full_p = sys.argv[2] if len(sys.argv) > 2 else 'world_rules_parses.json'
corp_p = sys.argv[3] if len(sys.argv) > 3 else 'world_rules.json'
corpus = json.load(open(corp_p)); full = json.load(open(full_p)) if os.path.exists(full_p) else []
pend = json.load(open(pend_p)) if os.path.exists(pend_p) else []
KEYS = ('stmts', 'review', 'census')
def index(rec):
    out = {}
    for e in rec:
        for i, s in enumerate(e['texts']):
            out[s] = {k: e[k]['texts'][i] for k in KEYS if k in e and 'texts' in e[k]}
    return out
have = index(full); have.update(index(pend))   # pending wins
merged, missing, dead = [], [], []
for r in corpus:
    ent = {'id': r['id'], 'rule': r['rule'], 'texts': list(r['texts'])}
    for k in KEYS: ent[k] = {'texts': []}
    for s in r['texts']:
        if s not in have: missing.append((r['id'], s)); [ent[k]['texts'].append(None) for k in KEYS]; continue
        for k in KEYS: ent[k]['texts'].append(have[s].get(k))
        if have[s].get('census') not in (None, 'ok'): dead.append((r['id'], have[s]['census'], s))
    merged.append(ent)
if not CHECK:
    if os.path.exists(full_p): shutil.copy(full_p, full_p + '.bak')
    json.dump(merged, open(full_p, 'w'), indent=2, ensure_ascii=False); open(full_p, 'a').write('\n')
n = sum(len(r['texts']) for r in corpus)
print(f'merged {n - len(missing)}/{n} sentences into {full_p} ({len(index(pend))} from pending)')
for rid, s in missing: print(f'  STILL PENDING [{rid}] {s}')
for rid, c, s in dead: print(f'  CENSUS {c} [{rid}] {s[:70]}')
print('ADMISSION:', 'clean — every sentence census ok' if not missing and not dead else 'NOT yet')
