#!/usr/bin/env python3
"""Authoring lint for the QA twin (qa.json), Experiment 2's task stream, run before the expensive parse.

Each entry is {id, rule, texts, modes, category, question_md, answer, cites_raw, cites, …}: `texts` are the
parse-facing sentences (a question for F/W; a premise and a question for N; the intervention statement(s) for C,
whose question is answered by derivation diff and is not parsed), `modes` names each text's parse mode
(query / statement / intervention). Classes:
  structure     modes parallel to texts; F/W = one query; N = statement(s) then a query; C = interventions/statements,
                no query; a query ends with '?', a statement with '.'
  banned        words outside the envelope: unless / without / only / other / else / than / whose / most,
                'rather than', 'instead of', 'not only', sentence-initial If
  list          a coordinated list of three or more items (one joint event)
  quote         quotation marks or parentheses inside a parse-facing text (sealing / no carrier)
  cross-item    a text that leans on another item ('the same lantern', 'this scenario')
  hedge         a hedge with no carrier (perhaps, presumably, most likely, e.g., approximately, typically, usually)
  comparative   a comparative or superlative (no carrier: more / fewer / lower / larger / -er than / worst / compared)
  off-corpus    a content word that occurs in none of the three corpus files — the parser would mint a symbol the
                knowledge base never uses, so a query cannot ground and a premise cannot fire a law
  unanswerable  the reference answer says the corpus does not answer (advisory: keep as a negative task, or retire)
  retired       an entry kept in the record with its reason but carrying no parse-facing text
usage: python3 lint_qa.py [--write-pending]
       --write-pending writes qa_pending.json: every entry with a text not yet in qa_parsed.json ({id, rule, texts})
"""
import json, os, re, sys, collections
CORPORA = ['world_rules.json', 'lore.json', 'events.json']
BANNED = re.compile(r"\b(unless|without|only|other|else|than|whose|most)\b|^If\b|\brather than\b|\binstead of\b|\bnot only\b")
LIST = re.compile(r",\s*[^,]+,\s*(and|or)\s+")
QUOTE = re.compile(r'["“”()]')
CROSS = re.compile(r"\b(the same|this scenario|in this scenario|that scenario|as above)\b", re.I)
HEDGE = re.compile(r"\b(perhaps|presumably|most likely|likely|e\.g\.|approximately|typically|usually|sometimes|often)\b", re.I)
STOP = set("""a an the of in at on to for from with by that this these those it its their there be been being is are was were has have had
do does did not no and or as into onto about which who whom whose what where when why how many much would could should must may might
will can shall one first next following after before during over under within per each every all any some such than then
suppose what's who's year years day days of
happens happen happened predict predicts predicted enable enables effect effects occur occurs respect located total
next design specifically specific particular various multiple just itself elsewhere simply though""".split())
IRREGULAR = {'write': 'wrote', 'written': 'wrote', 'drive': 'drove', 'rise': 'rose', 'build': 'built', 'begin': 'began', 'go': 'went',
             'take': 'took', 'make': 'made', 'leave': 'left', 'give': 'gave', 'bring': 'brought', 'fall': 'fell', 'find': 'found',
             'hold': 'held', 'keep': 'kept', 'lead': 'led', 'lose': 'lost', 'meet': 'met', 'run': 'ran', 'say': 'said', 'see': 'saw',
             'sit': 'sat', 'send': 'sent', 'stand': 'stood', 'strike': 'struck', 'teach': 'taught', 'tell': 'told', 'wear': 'wore',
             'win': 'won', 'blow': 'blew', 'fly': 'flew', 'grow': 'grew', 'draw': 'drew', 'throw': 'threw', 'shrink': 'shrank',
             'eat': 'ate', 'light': 'lit', 'become': 'became', 'catch': 'caught', 'choose': 'chose', 'do': 'did', 'dig': 'dug',
             'get': 'got', 'know': 'knew', 'lie': 'lay', 'pay': 'paid', 'ring': 'rang', 'sing': 'sang', 'sink': 'sank',
             'sleep': 'slept', 'speak': 'spoke', 'steal': 'stole', 'swim': 'swam', 'wake': 'woke', 'feed': 'fed', 'come': 'came',
             'burn': 'burned', 'dies': 'die', 'dying': 'die'}
COMPARATIVE = re.compile(r"\b(more|less|fewer|lower|higher|larger|smaller|brighter|dimmer|safer|worse|worst|best|better|compared|specifically)\b|\b\w+er than\b", re.I)
def words(t): return [w for w in re.findall(r"[a-z][a-z\-']*", t.lower())]
def stems(w):
    out = {w, IRREGULAR.get(w, w)}
    for suf in ('s', 'es', 'ed', 'd', 'ing', 'ly', "'s"):
        if w.endswith(suf) and len(w) - len(suf) >= 3: out.add(w[:-len(suf)])
    if w.endswith('ies'): out.add(w[:-3] + 'y')
    if w.endswith('ing') and len(w) > 5: out.add(w[:-3] + 'e')
    if w.endswith('-'): out.add(w.rstrip('-'))
    return out
def corpus_lexicon():
    lex = set()
    for p in CORPORA:
        if not os.path.exists(p): continue
        for e in json.load(open(p)):
            for t in e['texts']:
                for w in words(t): lex |= stems(w); lex |= set(w.split('-'))
    return lex
def off_corpus(t, lex):
    bad = []
    for w in words(t):
        if w in STOP or len(w) < 3: continue
        if stems(w) & lex: continue
        if all(part in lex or part in STOP for part in w.split('-')): continue
        bad.append(w)
    return bad
def lint(qa):
    lex = corpus_lexicon(); hits = collections.defaultdict(list)
    for e in qa:
        cat, texts, modes = e['category'], e['texts'], e['modes']
        loc = e['id']
        if e.get('retired'): hits['retired'].append((loc, e['retired'])); continue
        if len(texts) != len(modes): hits['structure'].append((loc, 'modes not parallel to texts'))
        if cat in 'FW' and modes != ['query']: hits['structure'].append((loc, f'{cat} must be one query, got {modes}'))
        if cat == 'N' and not (modes[-1:] == ['query'] and all(m == 'statement' for m in modes[:-1]) and len(modes) >= 2):
            hits['structure'].append((loc, f'N must be statement(s) then a query, got {modes}'))
        if cat == 'C' and ('query' in modes or not modes): hits['structure'].append((loc, f'C carries no query (diff answer), got {modes}'))
        for t, m in zip(texts, modes):
            if m == 'query' and not t.endswith('?'): hits['structure'].append((loc, f'query without ?: {t}'))
            if m != 'query' and not t.endswith('.'): hits['structure'].append((loc, f'statement without .: {t}'))
            if BANNED.search(t): hits['banned'].append((loc, t))
            if LIST.search(t): hits['list'].append((loc, t))
            if QUOTE.search(t): hits['quote'].append((loc, t))
            if CROSS.search(t): hits['cross-item'].append((loc, t))
            if HEDGE.search(t): hits['hedge'].append((loc, t))
            if COMPARATIVE.search(t): hits['comparative'].append((loc, t))
            oc = off_corpus(t, lex)
            if oc: hits['off-corpus'].append((loc, f"{', '.join(oc)}  <- {t}"))
        if re.search(r'corpus does not', e.get('answer', ''), re.I): hits['unanswerable'].append((loc, e['answer'][:90]))
    print(f"== qa.json: {len(qa)} entries, {sum(len(e['texts']) for e in qa)} parse-facing texts")
    for name in ['structure', 'banned', 'list', 'quote', 'cross-item', 'hedge', 'comparative', 'off-corpus', 'unanswerable', 'retired']:
        print(f"  {name}: {len(hits[name])}")
        for loc, t in hits[name]: print(f"      {loc}: {t}")
    return hits
def write_pending(qa):
    have = set()
    if os.path.exists('qa_parsed.json'):
        for e in json.load(open('qa_parsed.json')):
            for i, t in enumerate(e['texts']):
                if e['stmts']['texts'][i] is not None: have.add((e['id'], t))
    pend = [{'id': e['id'], 'rule': e['rule'], 'texts': list(e['texts'])} for e in qa if e['texts'] and any((e['id'], t) not in have for t in e['texts'])]
    json.dump(pend, open('qa_pending.json', 'w'), indent=2, ensure_ascii=False); open('qa_pending.json', 'a').write('\n')
    print(f"qa_pending.json: {len(pend)} entries / {sum(len(e['texts']) for e in pend)} texts")
if __name__ == '__main__':
    qa = json.load(open('qa.json'))
    lint(qa)
    if '--write-pending' in sys.argv: write_pending(qa)
