#!/usr/bin/env python3
"""Deterministic authoring lint for a controlled-language corpus JSON ({id, rule, texts} entries).

Flags the sentence shapes the parse gate has shown to mis-parse SILENTLY (the fireability
census still says ok), so the author catches them before the expensive parse:
  banned         a word outside the envelope (unless/without/only/other/else/than/whose, sentence-initial If, superlative most)
  indef-generic  singular-indefinite subject + verbal predicate in a non-episodic, non-modal sentence
                 -> one anonymous witness, no rule; a verbal generic needs a bare plural or Each/Every
  plural-label   a capitalized plural label ("The Keepers", "Council of Keepers") -> a members-less named body
  non-registry   a station/place named outside the registry ("Stilllight station", "Sunken Cove station")
  after-cond     an "After P, Q" conditional (inverted once in a gate run; prefer Whenever)
  list           a coordinated list of three or more items -> one joint event
  freq-specific  a frequency adverb on a definite or named subject (no licensed slot; only kind subjects carry it)
usage: python3 lint_corpus.py [CORPUS.json ...]     (default: lore.json)
"""
import json, re, sys, collections

COND = re.compile(r'^(When|Whenever|Every time|After|If)\b')
COPULAR = re.compile(r"^(A|An)\s+(?:[\w\-']+\s+){0,4}?(is|are|was|were)\b")
MODAL = re.compile(r'\b(may|must|cannot|can|might|should)\b')
IRREGULAR_PAST = re.compile(r'\b(came|drove|rose|built|forged|began|went|took|made|left|gave|brought|fell|found|held|kept|led|lost|met|ran|said|saw|sat|sent|stood|struck|taught|told|wore|won|wrote|has|have|had|ago|once)\b')
FUNCTION_NEXT = {'the','a','an','into','onto','to','from','with','at','in','on','over','off','by','for','of','before','after',
                 'until','through','toward','towards','down','up','out','away','back','and','or','that','its','his','her','their'}
CHECKS = {
 'banned':        re.compile(r"\b(unless|without|only|other|else|than|whose)\b|^If\b|\bmost\b"),
 'plural-label':  re.compile(r"\b(The|the|Some|some) Keepers\b|Hollows Keepers|Aelmere Keepers|Council of Keepers|\b(The|the) (Collectors|Wardens)\b"),
 'non-registry':  re.compile(r"Stilllight station|Stilllight feather|Sunken Cove station|\bthe Stilllight\b(?! (Lantern|Station|Keeper))"),
 'after-cond':    re.compile(r"^After\b[^,]*,"),
 'list':          re.compile(r",\s*[^,]+,\s*(and|or)\s+"),
 'freq-specific': re.compile(r"^(The (Council|Watch|village|Warden|speaker|fleet|glassworks|inspection)|[A-Z][a-z]+ [A-Z][a-z]+|Hesper|Pell|Sailsworn|Norren|Wynne)\b[^,]*?\b(usually|often|rarely|sometimes|occasionally|periodically)\b"),
}

# a past-tense -ed verb (episode) vs. a participial adjective ("an unstained coat"): the adjective is followed by a content word
def is_episodic(t):
    if IRREGULAR_PAST.search(t): return True
    for m in re.finditer(r"\b([\w\-]{3,}ed)\b\s*([\w\-]*)", t):
        nxt = m.group(2).lower()
        if nxt == '' or nxt in FUNCTION_NEXT: return True
    return False

QUANT = re.compile(r'^(A|An)\s+(few|dozen|handful|crowd|couple|number|pair)\b')
# hits are REVIEW items: a specific existential ("A stone landing stands at the foot of the Cove Stair") is kept as is
def indef_generic(t):
    return bool(re.match(r'^(A|An)\s', t)) and not QUANT.match(t) and not COND.match(t) and not COPULAR.match(t) and not MODAL.search(t) and not is_episodic(t)

def lint(path):
    hits = collections.defaultdict(list)
    for e in json.load(open(path)):
        for i, t in enumerate(e['texts']):
            loc = f"{e['id']} s{i+1}"
            for name, rx in CHECKS.items():
                if rx.search(t): hits[name].append((loc, t))
            if indef_generic(t): hits['indef-generic'].append((loc, t))
    print(f"== {path}: {sum(len(e['texts']) for e in json.load(open(path)))} sentences")
    for name in ['banned','indef-generic','plural-label','non-registry','after-cond','list','freq-specific']:
        print(f"  {name}: {len(hits[name])}")
        for loc, t in hits[name]: print(f"      {loc}: {t}")
    return hits

if __name__ == '__main__':
    for p in (sys.argv[1:] or ['lore.json']): lint(p)
