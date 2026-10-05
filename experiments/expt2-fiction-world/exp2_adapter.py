#!/usr/bin/env python3
"""Experiment 2 ingestion adapter: the accepted Aelmere parse records -> the §10.1 sem-graph IR.

Reads world_rules_parses.json, lore_parsed.json and events_parsed.json (sentence and passage records) and
writes molecules.metta (one neo-davidsonian graph per parse unit with every ground fact of the three corpora: the
world-rules and lore sentences are the graphs of one doc, `aelmere`, the standing knowledge every task is asked against;
an event passage is a graph outside the doc, a text that arrives with the tasks citing it) and rules.metta (every world-rules
law, every lore law and every generic stated inside an episode as a per-match `rule-lhs` / `rule-rhs` rule, in the
contexts aelmere / aelmere-lore / aelmere-events; one graph variable per premise clause, so a law's premises may come
from different parses, and the products form a graph of their own named by the firing; a law's consequent takes the
fact-side conventions i, o and p, so a derived edge is shaped like a given one (PRODUCT_CONVENTIONS); the synthetic
variables are uppercase, `$E1` / `$G1` / `$T1`, so they never collide with the parser's lowercase variables). The
ingestion conventions of REALIGNMENT.md item 1 are applied as a deterministic pass; each convention is a
declaration in CONVENTIONS and an edge it adds or rewrites carries (sem-edge-source G E <letter>). The records are read
through parse_corrections.py, which applies the hand corrections of parse_corrections.json; an edge landed from a corrected
statement carries (sem-edge-source G E x).
  a  every sk_* witness is scoped to its unit (sentence or passage)          b/l  aliases + cardinality strings
  c/g a witness of a registry singleton kind is the registry instance        f    the Year-1 autumn equinox is keyed by year
  d  sealed propositions land nested, verbatim                               e    an undated past event inherits the passage's forward-moving 'now'
  h  a per-member rule over a group holds of the group (the rule is consumed) i    a group of kind K is a member of K (not a COLLECTIVE body)
  j  a kind constant in a law's role slot becomes a typed variable            n    a bare kind in a fact's role slot becomes a fresh witness of that kind
  k  Patient and Theme are one Object slot                                   m    a past-tense wrapper on a state is unwrapped; the tense stays an edge on the edge
  o  a state witness with an experiencer asserts the property, and a property the laws read as a state asserts the witness
  p  attachment to a place is one AttachedTo slot (the original edge stays)  q    a place that holds things attaches them
Denied content (strength < 0.5) — a bundle, a single atom, a tensed statement, a per-member statement over a group, the
product of a negative law — lands as ONE nested And edge so no part of it matches a rule, and takes no convention edge:
the interim while the engine reads no truth values; the target form is the exposed decomposition with
conjunction-elimination values (design decision D16).
usage: python3 exp2_adapter.py [EXPERIMENT_DIR]       (default: this script's own directory)"""
import json, os, re, sys, collections
sys.dont_write_bytecode = True
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from parse_corrections import load_record, corrected_sids
DIR = sys.argv[1] if len(sys.argv) > 1 else os.path.dirname(os.path.abspath(__file__))
DOC = 'aelmere'
CONVENTIONS = set('a b c d e f g h i j k l m n o p q'.split())
PRODUCT_CONVENTIONS = set('i o p'.split())   # the fact-side conventions a law's consequent takes; n is left out: a witness minted per
                                             # firing is a new individual that further laws fire on, and the cyclic laws then never settle
SINGLETON = {'council': 'the_council', 'watch': 'the_watch', 'village': 'aelmere', 'sea': 'cold_sea', 'moon': 'the_moon',
             'coast': 'the_coast', 'tide_pool': 'salt_bloom_tide_pools', 'cauldron': 'the_cauldron', 'feather_store': 'the_feather_store',
             'feather_bin': 'the_feather_bin', 'central_pool': 'the_central_pool', 'cove_stair': 'cove_stair'}
ALIAS = {'night_moth': 'nightmoth', 'vesh': 'old_vesh', 'seawater': 'sea_water', 'winter_gloss': 'wintergloss', 'turn_away': 'turn',
         'bring_down': 'bring', 'watch': 'the_watch', '"a handful"': '"handful"', '"a few"': '"few"'}
KIND_ALIAS = {k: v for k, v in ALIAS.items() if k not in ('vesh', 'watch')}   # a kind slot takes a kind's spelling, never a constant
COLLECTIVE = {'the_keepers': 'keeper'}   # a body the corpus refers to as a whole (parse_corrections.json identifies its mentions); not an individual of its kind
KEYED = {'autumn_equinox', 'spring_equinox', 'summer_solstice', 'midsummer', 'midwinter'}
OBJECT = {'Patient', 'Theme'}
ROLE_HEADS = {'Agent', 'Object', 'Experiencer', 'Recipient', 'Stimulus', 'Beneficiary', 'Goal', 'Source', 'Location', 'Instrument',
              'Around', 'Alongside', 'Against', 'Toward', 'With', 'Under', 'Over', 'Near', 'Off'}
ATTACH = {'LocatedIn', 'PartOf', 'Possession', 'Of', 'On', 'At'}
PLACES = {'sunken_cove', 'cliff_path', 'middle_row', 'east_row', 'west_row', 'harbor_row', 'northcove', 'hollows', 'cauldron_hall', 'aelmere',
          'the_watch', 'cove_stair', 'harbor', 'harbor_station', 'stilllight_station', 'salt_bloom_tide_pools', 'cold_sea', 'harbor_wall', 'faltern'}
PLACE_KINDS = {'cove', 'row', 'lantern_row', 'path', 'station', 'lantern_station', 'hall', 'wall', 'bin', 'cellar', 'room', 'harbor',
               'village', 'store', 'cliff', 'base', 'pool', 'tide_pool', 'shore', 'coast', 'inlet', 'ledger_room'}
TENSE = {'Past', 'Future'}
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
def show(t):
    if isinstance(t, str): return f'(var {t[1:]})' if t.startswith('$') else t
    return '(' + ' '.join(show(x) for x in t) + ')'
def unit_tag(u): return re.sub(r'[^A-Za-z0-9_-]', '_', u)
def statement(st):
    """(: id BODY (STV s c)) -> (id, body, (s, c))"""
    t = parse(st); assert t[0] == ':' and len(t) == 4, st
    tv = t[3]; return t[1], t[2], (float(tv[1]), float(tv[2]))
def isvar(x): return isinstance(x, str) and x.startswith('$')
def is_sk(x): return isinstance(x, str) and x.startswith('sk_')
# ---- the corpus-wide kind inventory (for j and n) ---------------------------------------------------------
TEXT = {}   # unit id -> its sentence (or its whole passage)
def load_units():
    """the parse records with parse_corrections.json applied: (unit id, kind, [statements], {corrected statement ids})"""
    units = []
    for e in load_record(f'{DIR}/world_rules_parses.json'):
        for i, ss in enumerate(e['stmts']['texts']): units.append((f"{e['id']}.{i+1}", 'law', ss or [], corrected_sids(e, i))); TEXT[f"{e['id']}.{i+1}"] = e['texts'][i]
    for e in load_record(f'{DIR}/lore_parsed.json'):
        for i, ss in enumerate(e['stmts']['texts']): units.append((f"{e['id']}.{i+1}", 'lore', ss or [], corrected_sids(e, i))); TEXT[f"{e['id']}.{i+1}"] = e['texts'][i]
    for e in load_record(f'{DIR}/events_parsed.json'):
        units.append((e['id'], 'event', e['stmts'].get('passage') or [], corrected_sids(e))); TEXT[e['id']] = ' '.join(e['texts'])
    return units
def kind_inventory(units):
    kinds = collections.Counter(); named = set()
    for uid, kind, ss, _ in units:
        for st in ss:
            for m in re.finditer(r'\((?:Member|GroupOf|Inheritance) \S+ (\w+)\)', st): kinds[m.group(1)] += 1
            for m in re.finditer(r'\(Name (\w+) "', st): named.add(m.group(1))
    return kinds, named
UNITS = load_units(); KINDS, NAMED = kind_inventory(UNITS)
NAMED = {ALIAS.get(n, n) for n in NAMED} - {'salt_bloom'}   # 'Salt-bloom' is capitalized once; it is a kind throughout
def is_kind(x):
    return isinstance(x, str) and x in KINDS and x not in NAMED and x not in PLACES and x not in set(SINGLETON.values()) and not x.startswith('"')
LAW_STATES = set()
for uid, kind, ss, _ in UNITS:
    if kind != 'law': continue
    for st in ss:
        if '(Implication' in st:
            prem = st.split('(Implication', 1)[1]
            exps = set(re.findall(r'\(Experiencer (\$\w+) ', prem))
            LAW_STATES |= {k for v, k in re.findall(r'\(Member (\$\w+) (\w+)\)', prem) if v in exps}
# ---- per-unit rewriting ------------------------------------------------------------------------------------
class Unit:
    def __init__(self, uid, kind, stmts, corrected=()):
        self.uid, self.kind, self.tag = uid, kind, unit_tag(uid)
        self.raw = [statement(st) for st in stmts]
        self.corrected = set(corrected); self.current_sid = None   # the statements parse_corrections.json touched; the one being landed
        self.types = {}   # raw witness -> kinds (from Member / GroupOf)
        for _, bd, _ in self.raw:
            if isinstance(bd, tuple) and len(bd) == 3 and bd[0] in ('Member', 'GroupOf') and is_sk(bd[1]) and isinstance(bd[2], str):
                self.types.setdefault(bd[1], set()).add(bd[2])
        self.years = {}   # raw witness -> year term (for f)
        for _, bd, _ in self.raw:
            if isinstance(bd, tuple) and len(bd) == 3 and bd[0] == 'Time' and is_sk(bd[1]) and isinstance(bd[2], tuple) and bd[2][0] == 'Year': self.years[bd[1]] = bd[2][1]
        self.minted = 0; self.edges = []; self.rules = []; self.sources = {}; self.ids = collections.Counter()
    def rename(self, x, kind=False):
        """a witness or constant under conventions a, b/l, c/g, f; in a kind slot only a kind's spelling is aliased, never a constant's"""
        if isinstance(x, tuple):
            if len(x) == 3 and x[0] in ('Member', 'GroupOf', 'Inheritance'): return (x[0], self.rename(x[1], x[0] == 'Inheritance'), self.rename(x[2], True))
            return tuple(self.rename(y) for y in x)
        if not isinstance(x, str): return x
        if is_sk(x):
            ks = self.types.get(x, set())
            if 'g' in CONVENTIONS:
                for k in ks:
                    if k in SINGLETON: return SINGLETON[k]
            if 'f' in CONVENTIONS and ks & KEYED and x in self.years: return f"{sorted(ks & KEYED)[0]}_y{self.years[x]}"
            return f"{self.tag}_{x}" if 'a' in CONVENTIONS else x
        return (KIND_ALIAS if kind else ALIAS).get(x, x) if 'b' in CONVENTIONS else x
    def mint(self, kind):
        self.minted += 1; return f"{self.tag}_sk_{kind}_m{self.minted}"
    def edge_id(self, base):
        self.ids[base] += 1; return f"{self.tag}_{base}" + ('' if self.ids[base] == 1 else f"_{self.ids[base]}")
    def add(self, base, body, tv, source=None):
        eid = self.edge_id(base); self.edges.append((eid, body, tv))
        if source: self.sources[eid] = source
        elif self.current_sid in self.corrected: self.sources[eid] = 'x'   # landed from a hand-corrected statement
        return eid
    def normalize_head(self, bd):
        if 'k' in CONVENTIONS and isinstance(bd, tuple) and bd and bd[0] in OBJECT: return ('Object',) + bd[1:]
        return bd
    def ground(self, sid, bd, tv, source=None):
        """emit one ground atom with the shape conventions (k, n, i, o, p, q)"""
        bd = self.normalize_head(self.rename(bd))
        if 'n' in CONVENTIONS and isinstance(bd, tuple) and len(bd) == 3 and bd[0] in ROLE_HEADS and is_kind(bd[2]):
            w = self.mint(bd[2]); self.add(f"{sid}_n", ('Member', w, bd[2]), tv, 'n'); bd = (bd[0], bd[1], w)
        eid = self.add(sid, bd, tv, source)
        if not (isinstance(bd, tuple) and len(bd) == 3): return eid
        h, x, y = bd
        if 'i' in CONVENTIONS and h == 'GroupOf' and x not in COLLECTIVE: self.add(f"{sid}_i", ('Member', x, y), tv, 'i')
        if 'o' in CONVENTIONS and h == 'Member' and isinstance(y, str) and y in LAW_STATES and not any(b2[0] == 'Experiencer' and b2[1] == x for _, b2, _ in self.raw_renamed()):
            w = self.mint(y); self.add(f"{sid}_o", ('Member', w, y), tv, 'o'); self.add(f"{sid}_o_exp", ('Experiencer', w, x), tv, 'o')
        if 'p' in CONVENTIONS and h in ATTACH and self.is_place(y): self.add(f"{sid}_p", ('AttachedTo', x, y), tv, 'p')
        return eid
    def raw_renamed(self):
        if not hasattr(self, '_rr'): self._rr = [(sid, self.normalize_head(self.rename(bd)), tv) for sid, bd, tv in self.raw if isinstance(bd, tuple)]
        return self._rr
    def is_place(self, y):
        if not isinstance(y, str): return False
        if y in PLACES: return True
        raw = next((r for r in self.types if self.rename(r) == y), None)
        return bool(raw and self.types[raw] & PLACE_KINDS)
    def convert(self):
        for sid, bd, tv in self.raw:
            self.current_sid = sid
            if not isinstance(bd, tuple) or not bd: continue
            head = bd[0]
            if head == 'Implication':
                if 'h' in CONVENTIONS and isinstance(bd[1], tuple) and bd[1] and bd[1][0] == 'PartOf' and isvar(bd[1][1]):
                    self.lift(sid, bd, tv); continue
                self.rules.append((sid, bd, tv)); continue
            if tv[0] < 0.5:   # denied content stays ONE nested And edge whatever its shape, so no part of it matches a rule
                self.add(sid, self.rename(bd) if head == 'And' else ('And', self.rename(bd)), tv); continue
            if head in TENSE and len(bd) == 2 and isinstance(bd[1], tuple):
                if 'm' in CONVENTIONS:
                    eid = self.ground(sid, bd[1], tv); self.add(f"{sid}_tense", (head, eid), tv, 'm')
                else: self.add(sid, self.rename(bd), tv)
                continue
            if head == 'And':
                for k, op in enumerate(bd[1:], 1):
                    if isinstance(op, tuple): self.ground(f"{sid}_c{k}", op, tv)
                continue
            self.ground(sid, bd, tv)
        if 'q' in CONVENTIONS: self.hold_containment()
        if 'e' in CONVENTIONS and self.kind == 'event': self.inherit_dates()
        self.states_to_properties()
    def lift(self, sid, bd, tv):
        """convention h: (Implication (PartOf $x g) C) -> C[$x := g], Skolem terms over g minted as witnesses"""
        var, grp = bd[1][1], bd[1][2]; sk = {}
        def inst(t):
            if isinstance(t, str): return grp if t == var else t
            if isinstance(t, tuple) and t and isinstance(t[0], str) and t[0].startswith('sk_'):
                key = show(t)
                if key not in sk: sk[key] = self.mint(t[0][3:])
                return sk[key]
            return tuple(inst(x) for x in t)
        cons = bd[2]; cs = [inst(c) for c in (cons[1:] if isinstance(cons, tuple) and cons and cons[0] == 'And' else [cons])]
        if tv[0] < 0.5:   # a denied per-member statement: one nested And edge over the group
            self.add(f"{sid}_h", ('And',) + tuple(self.rename(c) for c in cs if isinstance(c, tuple) and c), tv, 'h'); return
        for k, c in enumerate(cs, 1):
            if isinstance(c, tuple) and c: self.ground(f"{sid}_h{k}", c, tv, 'h')
    def hold_containment(self):
        ev = collections.defaultdict(dict)
        for eid, bd, tv in list(self.edges):
            if isinstance(bd, tuple) and len(bd) == 3 and bd[0] in ('Member', 'Agent', 'Object'): ev[bd[1]].setdefault(bd[0], []).append((bd[2], tv))
        for e, d in ev.items():
            if any(k == 'hold' for k, _ in d.get('Member', [])):
                for ag, tv in d.get('Agent', []):
                    if self.is_place(ag):
                        for ob, _ in d.get('Object', []): self.add(f"{e.split('_sk_')[-1]}_q", ('AttachedTo', ob, ag), tv, 'q')
    def inherit_dates(self):
        """convention e: a passage's 'now' only moves forward — a date mention sets it unless it is earlier, a flashback — and an
        undated past event takes the 'now' at its mention; the passage's first date serves an event told before any date"""
        is_date = lambda bd, k: isinstance(bd, tuple) and len(bd) == 3 and bd[0] == 'Time' and isinstance(bd[2], tuple) and len(bd[2]) == 2 and bd[2][0] == k and str(bd[2][1]).isdigit()
        dates = collections.defaultdict(dict); order = []   # a dated node -> its Day / Year terms, nodes in order of first mention
        for eid, bd, tv in self.edges:
            for k in ('Day', 'Year'):
                if is_date(bd, k):
                    if bd[1] not in dates: order.append(bd[1])
                    dates[bd[1]][k] = bd[2]
        first = dates[order[0]] if order else {}
        key = lambda d, y0: (int(d['Year'][1]) if d.get('Year') else y0, int(d['Day'][1]) if d.get('Day') else -1)
        now = {}; seen = set(); pending = []
        for eid, bd, tv in list(self.edges):
            node = bd[1] if isinstance(bd, tuple) and len(bd) >= 2 else None
            if node in dates and node not in seen and (is_date(bd, 'Day') or is_date(bd, 'Year')):
                seen.add(node); cand = dates[node]; y0 = key(now, -1)[0]
                if key(cand, y0) >= key(now, -1):
                    moved_year = 'Year' in cand and key(cand, y0)[0] > y0
                    now = {'Year': cand.get('Year', now.get('Year')), 'Day': cand.get('Day', None if moved_year else now.get('Day'))}
            if isinstance(bd, tuple) and len(bd) == 2 and bd[0] == 'Past' and isinstance(node, str) and 'Day' not in dates.get(node, {}) and node.startswith(self.tag + '_'):
                pending.append((eid, node, tv, dict(now) if now else first))
        for eid, ev, tv, at in pending:
            if at.get('Day'): self.add(f"{eid}_e_day", ('Time', ev, at['Day']), tv, 'e')
            if at.get('Year'): self.add(f"{eid}_e_year", ('Time', ev, at['Year']), tv, 'e')
    def states_to_properties(self):
        """convention o, forward: (Member s K) + (Experiencer s x) => (Member x K)"""
        if 'o' not in CONVENTIONS: return
        exp = {bd[1]: bd[2] for _, bd, _ in self.edges if isinstance(bd, tuple) and len(bd) == 3 and bd[0] == 'Experiencer'}
        have = {(bd[1], bd[2]) for _, bd, _ in self.edges if isinstance(bd, tuple) and len(bd) == 3 and bd[0] == 'Member'}
        for eid, bd, tv in list(self.edges):
            if isinstance(bd, tuple) and len(bd) == 3 and bd[0] == 'Member' and bd[1] in exp and isinstance(bd[2], str) and (exp[bd[1]], bd[2]) not in have and self.sources.get(eid) != 'o':
                self.add(f"{eid}_o_prop", ('Member', exp[bd[1]], bd[2]), tv, 'o'); have.add((exp[bd[1]], bd[2]))
# ---- rules ----------------------------------------------------------------------------------------------------
def conjs_of(side): return list(side[1:]) if isinstance(side, tuple) and side and side[0] == 'And' else [side]
def premise_conjuncts(unit, prem, fresh):
    """a pattern's conjuncts under the premise-side conventions: j (a kind constant in a role slot becomes a typed variable,
    named by `fresh`) and p (attachment to a place constant, or to a variable typed with a place kind, is one AttachedTo slot)"""
    typed = {}   # pattern variable -> its kinds, for the place test on a variable object
    for c in prem:
        c = unit.rename(c)
        if isinstance(c, tuple) and len(c) == 3 and c[0] in ('Member', 'GroupOf') and isvar(c[1]) and isinstance(c[2], str): typed.setdefault(c[1], set()).add(c[2])
    out = []
    for c in prem:
        c = unit.normalize_head(unit.rename(c))
        if not isinstance(c, tuple) or len(c) != 3: out.append(c); continue
        h, x, y = c
        if 'j' in CONVENTIONS and h in ROLE_HEADS and is_kind(y): v = fresh(); out += [(h, x, v), ('Member', v, y)]
        elif 'p' in CONVENTIONS and h in ATTACH and (unit.is_place(y) or (isvar(y) and typed.get(y, set()) & PLACE_KINDS)): out.append(('AttachedTo', x, y))
        else: out.append(c)
    return out
def product_conjuncts(unit, lhs, cons):
    """a law's consequent under the fact-side conventions named in PRODUCT_CONVENTIONS, so a derived edge is shaped like a
    given one: i (a group of kind K is a member of K), p (attachment to a place also fills the one AttachedTo slot), o (a
    state witness with an experiencer asserts the property; a property the laws read as a state asserts the witness), and,
    when enabled, n (a bare kind in a role slot is a witness of that kind, minted per firing over the atom's subject)"""
    typed = collections.defaultdict(set)   # term -> the kinds the premise or the consequent types it with
    for c in lhs + cons:
        if isinstance(c, tuple) and len(c) == 3 and c[0] in ('Member', 'GroupOf') and isinstance(c[2], str): typed[c[1]].add(c[2])
    out = []; minted = collections.Counter()
    def add(c):
        if c not in out: out.append(c)
    for c in cons:
        if not (isinstance(c, tuple) and len(c) == 3): add(c); continue
        h, x, y = c
        if 'n' in PRODUCT_CONVENTIONS and h in ROLE_HEADS and is_kind(y):
            minted[y] += 1; w = (f"{unit.tag}_sk_{y}_m{minted[y]}", x); add(('Member', w, y)); typed[w].add(y); y = w
        add((h, x, y))
        if 'i' in PRODUCT_CONVENTIONS and h == 'GroupOf': add(('Member', x, y))
        if 'p' in PRODUCT_CONVENTIONS and h in ATTACH and (unit.is_place(y) or typed.get(y, set()) & PLACE_KINDS): add(('AttachedTo', x, y))
    if 'o' in PRODUCT_CONVENTIONS:
        exp = {c[1]: c[2] for c in out if isinstance(c, tuple) and len(c) == 3 and c[0] == 'Experiencer'}
        for h, x, k in [c for c in out if isinstance(c, tuple) and len(c) == 3 and c[0] == 'Member' and isinstance(c[2], str)]:
            if x in exp: add(('Member', exp[x], k))
            elif k in LAW_STATES and not any(e == x and k in typed.get(s, ()) for s, e in exp.items()):
                w = (f"{unit.tag}_sk_{k}_o", x); add(('Member', w, k)); add(('Experiencer', w, x))
    return out
def rule_text(unit, rid, bd, tv, ctx, prio):
    """a law as per-match rule-lhs / rule-rhs IR: variables (var x), Skolem terms kept as witness constructors,
    the premise under the premise-side conventions, the consequent under the fact-side ones"""
    prem, cons = conjs_of(bd[1]), conjs_of(bd[2]); n = [0]
    def fresh(): n[0] += 1; return f"$T{n[0]}"
    lhs = premise_conjuncts(unit, prem, fresh)
    evars = [f"$E{i}" for i in range(1, len(lhs) + 1)]   # synthetic variables ($E edge ids, $G graphs, $T typed fillers) are UPPERCASE: the parser's own are lowercase
    clauses = [f"(sem-edge (var G{i}) {show(ev)} {show(c)[1:-1]})" for i, (ev, c) in enumerate(zip(evars, lhs), 1)]
    pg = f"({rid} {' '.join(show(v) for v in evars)})"   # the firing's own graph: its products are one new molecule, named by what made it
    prods = [f"(sem-graph-kind {pg} neo-davidsonian)"]; cons = [unit.normalize_head(unit.rename(c)) for c in cons]
    if tv[0] >= 0.5: cons = product_conjuncts(unit, lhs, cons)
    if tv[0] < 0.5:   # a negative law's product is a denied conjunction: ONE nested And edge (interim; see the landing note)
        pid = f"({rid}_p1 {' '.join(show(v) for v in evars)})"
        prods.append(f"(sem-edge {pg} {pid} And {' '.join(show(c) for c in cons)})")
        prods.append(f"(sem-edge-tv {pg} {pid} (STV {tv[0]} {tv[1]}))")
    else:
        for k, c in enumerate(cons, 1):
            pid = f"({rid}_p{k} {' '.join(show(v) for v in evars)})"
            prods.append(f"(sem-edge {pg} {pid} {show(c)[1:-1]})")
            prods.append(f"(sem-edge-tv {pg} {pid} (STV {tv[0]} {tv[1]}))")
    L = [f"(sem-rule {rid})", f"(rule-context {rid} {ctx})", f"(rule-priority {rid} {prio})", f"(rule-tv {rid} authored {tv[0]} {tv[1]})",
         f"(rule-lhs {rid} ({' '.join(clauses)}))", f"(rule-rhs {rid} ({' '.join(prods)}))"]
    return '\n'.join(L)
# ---- main ------------------------------------------------------------------------------------------------------
def landed_units():
    """every unit converted, with the landed id of each of its rules: [(unit, [(rid, sid, body, tv)])]"""
    out = []; seen = set()
    for uid, kind, ss, corrected in UNITS:
        u = Unit(uid, kind, ss, corrected); u.convert(); rs = []
        for sid, bd, tv in u.rules:
            rid = f"R{u.tag[1:]}" if kind == 'law' else f"{u.tag}_{sid}"   # world laws R4_1; lore / event rules by unit and parser id
            if rid in seen: rid = f"{rid}_{sid}"
            seen.add(rid); rs.append((rid, sid, bd, tv))
        out.append((u, rs))
    return out
CONTEXT = {'law': 'aelmere', 'lore': 'aelmere-lore', 'event': 'aelmere-events'}
def main():
    mol = ["; Experiment 2 — MOLECULES, pure portable facts in §10.1 sem-graph IR: one neo-davidsonian graph per parse unit with",
           "; every ground fact of the three admitted corpora (world_rules_parses.json, lore_parsed.json, events_parsed.json),",
           f"; landed by exp2_adapter.py. The world-rules and lore sentences are the graphs of one doc, {DOC}: the standing",
           "; knowledge every task is asked against. An event passage is a graph outside the doc: a text that arrives with the",
           "; tasks citing it. Ingestion conventions per REALIGNMENT.md item 1 (each adapter-added edge names its convention in",
           "; sem-edge-source). A graph is named by its unit; edge ids are unit-prefixed parser ids; witnesses are unit-scoped.",
           f"(sem-doc {DOC})"]
    rules = ["; Experiment 2 — RULES: every world-rules law (context aelmere), every lore law (aelmere-lore) and every generic stated",
             "; inside an episode (aelmere-events) as canonical",
             "; per-match rule-lhs / rule-rhs IR with (var Name) markers, landed by exp2_adapter.py. Each premise clause carries its",
             "; own graph variable, so a law's premises may come from different parses; a firing's products form one new graph named",
             "; by the rule and the premise edges it fired on, and a product's edge id names the same; a consequent's Skolem term is",
             "; kept as a witness constructor over the premise variables; the authored truth value rides on rule-tv's `authored`",
             "; axis and on every product edge."]
    stats = collections.Counter(); prio = 0
    for u, rs in landed_units():
        if u.edges: mol += [f"\n; --- {u.uid}: {TEXT[u.uid]}", f"(sem-graph {u.tag})", f"(sem-graph-kind {u.tag} neo-davidsonian)"] + ([f"(doc-graph {DOC} {u.tag})"] if u.kind != 'event' else [])
        for eid, bd, tv in u.edges:
            mol.append(f"(sem-edge {u.tag} {eid} {show(bd)[1:-1]})")
            mol.append(f"(sem-edge-tv {u.tag} {eid} (STV {tv[0]} {tv[1]}))")
            if eid in u.sources: mol.append(f"(sem-edge-source {u.tag} {eid} {u.sources[eid]})")
            stats['edges'] += 1; stats['edge-' + u.sources.get(eid, 'parser')] += 1
            stats['denied'] += tv[0] < 0.5; stats['denied-loose'] += tv[0] < 0.5 and bd[0] != 'And'
        for rid, sid, bd, tv in rs:
            rules.append(f"\n; --- {u.uid}: {TEXT[u.uid]}")
            rules.append(rule_text(u, rid, bd, tv, CONTEXT[u.kind], prio)); prio += 1
            stats['rules-' + u.kind] += 1
    assert not stats['denied-loose'], 'a denied statement landed as a plain edge'
    open(f'{DIR}/molecules.metta', 'w').write('\n'.join(mol) + '\n')
    open(f'{DIR}/rules.metta', 'w').write('\n'.join(rules) + '\n')
    print('molecules.metta:', stats['edges'], 'edges;', {k: v for k, v in stats.items() if k.startswith('edge-')}, '; denied (nested):', stats['denied'])
    print('rules.metta:', stats['rules-law'], 'world laws,', stats['rules-lore'], 'lore laws,', stats['rules-event'], 'event generics')
if __name__ == '__main__': main()
