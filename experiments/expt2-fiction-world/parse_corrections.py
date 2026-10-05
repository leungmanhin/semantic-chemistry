#!/usr/bin/env python3
"""Hand corrections to the parser's records, applied when a record is loaded; the records stay as the parser wrote them.

parse_corrections.json holds one entry per correction: the record file, the entry id, the text index (a passage record has
none), what to do — `replace` one statement `with` another, `remove` statements, `add` statements, or `identify` a witness
the parser minted as a known individual (every occurrence in that text becomes the constant) — and the reason. A
statement to replace or remove, and a witness to identify, must be present, or loading fails: a record that no longer
matches its correction is caught rather than landed half-corrected. A corrected or added statement's id is listed under
the entry's `corrected`, so the adapter can mark the edges it lands (sem-edge-source x).
usage: python3 parse_corrections.py [EXPERIMENT_DIR]    (lists the corrections and checks that every target is present)"""
import json, os, re, sys
def sid_of(st):
    m = re.match(r'\(:\s+(\S+)\s', st.strip()); return m.group(1) if m else None
def load_record(path):
    """the record file at `path` with the corrections of its directory applied"""
    rec = json.load(open(path)); folder, name = os.path.split(os.path.abspath(path))
    table = os.path.join(folder, 'parse_corrections.json')
    if not os.path.exists(table): return rec
    by_id = {e['id']: e for e in rec}
    for c in json.load(open(table)):
        if c['record'] != name: continue
        e = by_id[c['id']]; key = c.get('text', 'passage')
        stmts = e['stmts']['texts'][c['text']] if 'text' in c else e['stmts']['passage']
        touched = e.setdefault('corrected', {}).setdefault(str(key), [])
        for old in ([c['replace']] if 'replace' in c else []) + c.get('remove', []):
            assert stmts.count(old) == 1, f"parse_corrections.json: {c['record']} {c['id']} — the statement to correct is not present exactly once: {old[:80]}"
            stmts.remove(old)
        for new in ([c['with']] if 'replace' in c else []) + c.get('add', []):
            stmts.append(new); touched.append(sid_of(new))
    for c in json.load(open(table)):   # identifications last, so they also reach the statements a correction added
        if c['record'] != name or 'identify' not in c: continue
        e = by_id[c['id']]; stmts = e['stmts']['texts'][c['text']] if 'text' in c else e['stmts']['passage']
        for witness, const in c['identify'].items():
            pat = re.compile(r'(?<![\w$])' + re.escape(witness) + r'(?!\w)')
            assert any(pat.search(s) for s in stmts), f"parse_corrections.json: {c['record']} {c['id']} — nothing to identify as {const}: {witness}"
            stmts[:] = [pat.sub(const, s) for s in stmts]
    return rec
def corrected_sids(entry, text=None):
    """the statement ids a correction touched in one text of a loaded record entry"""
    return set(entry.get('corrected', {}).get(str(text if text is not None else 'passage'), []))
if __name__ == '__main__':
    folder = sys.argv[1] if len(sys.argv) > 1 else os.path.dirname(os.path.abspath(__file__))
    for name in sorted({c['record'] for c in json.load(open(os.path.join(folder, 'parse_corrections.json')))}):
        rec = load_record(os.path.join(folder, name))
        for e in rec:
            for k, sids in e.get('corrected', {}).items(): print(f"{name} {e['id']} text {k}: {', '.join(sids)}")
    for c in json.load(open(os.path.join(folder, 'parse_corrections.json'))):
        if 'identify' in c: print(f"{c['record']} {c['id']} text {c.get('text', 'passage')}: {', '.join(f'{w} is {k}' for w, k in c['identify'].items())}")
