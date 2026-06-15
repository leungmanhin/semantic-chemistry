#!/usr/bin/env python3
"""
P0 mechanical-sanity kernel — Mortal Semantic Chemistry, Experiment 1.

A deterministic, replay-equivalent, fuel-gated single-chamber loop over the
portable-facts IR (ir/schema.md). It runs a *composing* QA-strategy genome:
four rules whose products flow through a LIVE working state X, so each stage
feeds the next.

  R_qtype (0)   q-word            -> (q-intent Q intent)
  R_align (1)   q-intent + edges  -> (alignment AL Q cls) + cites + prov
  R_complete(2) alignment + roles -> (role-fill AL Role Filler)
  R_project (3) alignment+roles   -> (candidate-answer Q A) + class/cites/prov/roles

Each kernel STEP (ir/schema.md §3): re-enumerate candidates over the current X
across all rules, drop those whose products already exist, fuel-filter
(F_O >= kappa_R componentwise), select the canonical-first by (priority, rule,
binding), FIRE (apply products to X, append to the event log, debit fuel).
Stop at quiescence (no candidate) or starvation (no affordable candidate).

Demonstrates the P0 definition-of-done: a multi-rule strategy composing through
X; append-only event log; replay equivalence (asserted); and mortality by
fuel exhaustion. The kernel never mints fuel (hard prohibition #1) — scoring
candidate-answers and minting by clamp is P1.

P0 shortcuts (flagged, see src/README.md): rule logic is kernel-resident, not
yet portable pattern-graphs; selection is deterministic priority order (not yet
a seeded gate); matching is host-side Python (not yet MM2).

Usage:  python3 src/kernel.py
"""
import re
from pathlib import Path

REPO   = Path(__file__).resolve().parent.parent
DATA   = REPO / "corpus" / "expt1-causal-qa" / "expt1_data.metta"
GENOME = REPO / "corpus" / "expt1-causal-qa" / "genome_expt1.metta"
LOG_ID = "LOG_e1"

EXPLANATORY = ("physical-cause", "intentional")        # concession is never an answer class
INTENT_MAP = {"why": "explain", "what-made": "explain", "how-come": "explain",
              "what-for": "explain-goal", "trying-to-do": "explain-goal",
              "how": "explain-mechanism", "why-not": "explain-prevention"}
INTENT_CLASSES = {"explain": {"physical-cause", "intentional"},
                  "explain-goal": {"intentional"},
                  "explain-mechanism": {"physical-cause"},
                  "explain-prevention": {"physical-cause"}}

# ---------------------------------------------------------------- parse IR facts
def _tok(s):  return re.findall(r"\(|\)|[^\s()]+", s)
def _read(t, p):
    if t[p] == "(":
        p += 1; out = []
        while t[p] != ")":
            n, p = _read(t, p); out.append(n)
        return out, p + 1
    return t[p], p + 1

def parse_facts(path):
    facts = []
    for line in Path(path).read_text().splitlines():
        line = line.split(";", 1)[0].strip()
        if not line.startswith("!"):
            continue
        toks = _tok(line[1:])
        if not toks:
            continue
        node, _ = _read(toks, 0)
        if isinstance(node, list) and len(node) >= 3 and node[0] == "add-atom":
            facts.append(tuple(node[2]))               # flat fact tuple
    return facts

def q(W, head, arity):
    return [t for t in W if t and t[0] == head and len(t) == arity + 1]

# ----------------------------------------------------------------- rule handlers
# Each returns a list of candidate dicts: rule, prio, key, produces[tuples], cost.
def rule_qtype(W, org, costs):
    qwords = {t[1]: t[2] for t in q(W, "q-word", 2)}
    have   = {t[1] for t in q(W, "q-intent", 2)}
    out = []
    for _h, _t, Q in sorted(q(W, "qa-question", 2)):
        if Q in have or Q not in qwords:
            continue
        intent = INTENT_MAP.get(qwords[Q])
        if intent:
            out.append(dict(rule="R_qtype", prio=0, key=Q, cost=costs["R_qtype"],
                            produces=[("q-intent", Q, intent)],
                            desc=f"{Q}: q-word={qwords[Q]} -> {intent}"))
    return out

def rule_align(W, org, costs):
    cluster = {t[1]: t[2] for t in q(W, "edge-cluster", 2)}
    focus   = {t[1]: t[2] for t in q(W, "question-focus", 2)}
    source  = {t[1]: t[2] for t in q(W, "question-source", 2)}
    intents = {t[1]: t[2] for t in q(W, "q-intent", 2)}
    have    = {(t[2], t[3]) for t in q(W, "alignment", 3)}
    edges   = q(W, "sem-edge", 5)
    cite_cost = costs["R_align"]
    abst_cost = {"tau_graph_match": cite_cost.get("tau_graph_match", 1)}
    out = []
    for Q in sorted(intents):
        G, foc = source.get(Q), focus.get(Q)
        if not G or not foc:
            continue
        allow, by_cls, any_expl = INTENT_CLASSES[intents[Q]], {}, False
        for _h, g, e, rel, s, d in edges:
            if g == G and d == foc and cluster.get(rel) in EXPLANATORY:
                any_expl = True
                if cluster[rel] in allow:
                    by_cls.setdefault(cluster[rel], []).append((e, s))
        for cls in sorted(by_cls):
            if (Q, cls) in have:
                continue
            AL = f"AL_{Q}_{cls}"
            prod = [("alignment", AL, Q, cls)]
            prod += [("alignment-cites", AL, G, e) for e, _ in sorted(by_cls[cls])]
            prod += [("alignment-prov",  AL, G, s) for _, s in sorted(by_cls[cls])]
            out.append(dict(rule="R_align", prio=1, key=f"{Q}|{cls}", cost=cite_cost,
                            produces=prod, desc=f"{Q} {cls}: cite {[e for e,_ in sorted(by_cls[cls])]}"))
        if not any_expl and (Q, "abstain") not in have:
            out.append(dict(rule="R_align", prio=1, key=f"{Q}|abstain", cost=abst_cost,
                            produces=[("alignment", f"AL_{Q}_abstain", Q, "abstain")],
                            desc=f"{Q}: abstain (no explanatory edge into focus)"))
    return out

def rule_complete(W, org, costs):
    cluster = {t[1]: t[2] for t in q(W, "edge-cluster", 2)}
    esrc    = {(t[1], t[2]): t[4] for t in q(W, "sem-edge", 5)}      # (G,E) -> src
    edges   = q(W, "sem-edge", 5)
    cites   = q(W, "alignment-cites", 3)
    have    = {(t[1], t[2], t[3]) for t in q(W, "role-fill", 3)}
    out = []
    for _h, AL, Q, cls in q(W, "alignment", 3):
        if cls == "abstain":
            continue
        causes = sorted({(g, esrc[(g, e)]) for _a, al, g, e in cites
                         if al == AL and (g, e) in esrc})
        for G, cause in causes:
            for _e, g, e, rel, s, d in edges:                       # role edge OUT of the cause
                if g == G and s == cause and cluster.get(rel) is None and (AL, rel, d) not in have:
                    out.append(dict(rule="R_complete", prio=2, key=f"{AL}|{rel}|{d}",
                                    cost=costs["R_complete"], produces=[("role-fill", AL, rel, d)],
                                    desc=f"{AL}: role {rel}={d}"))
    return out

def rule_project(W, org, costs):
    cites = q(W, "alignment-cites", 3)
    provs = q(W, "alignment-prov", 3)
    roles = q(W, "role-fill", 3)
    out = []
    for _h, AL, Q, cls in sorted(q(W, "alignment", 3), key=lambda x: (x[2], x[3])):
        A = f"A_{Q}_{cls}"
        if ("candidate-answer", Q, A) in W:
            continue
        prod = [("candidate-answer", Q, A), ("answer-by", A, org)]
        if cls == "abstain":
            prod.append(("answer-abstain", A))
        else:
            prod.append(("answer-class", A, cls))
            prod += [("answer-cites", A, g, e) for _a, al, g, e in cites if al == AL]
            prod += [("answer-provenance", A, g, s) for _a, al, g, s in provs if al == AL]
            prod += [("answer-role", A, r, f) for _a, al, r, f in roles if al == AL]
        out.append(dict(rule="R_project", prio=3, key=f"{Q}|{cls}", cost=costs["R_project"],
                        produces=prod, desc=f"{Q} {cls} -> {A}"))
    return out

HANDLERS = [rule_qtype, rule_align, rule_complete, rule_project]

# ---------------------------------------------------------------- chamber readers
def read_org(W):
    return q(W, "organism", 1)[0][1]

def read_fuel(W, org):
    return {t[2]: int(t[3]) for t in q(W, "fuel", 3) if t[1] == org}

def read_costs(W):
    costs = {}
    for _h, r, tk, n in q(W, "rule-token-cost", 3):
        costs.setdefault(r, {})[tk] = int(n)
    return costs

def enumerate_candidates(W, org, costs, ablate=frozenset()):
    """All rule candidates over the current X, in canonical (prio, rule, key) order.
    `ablate` suppresses the named rules — the hook P2 paired-replay (do-influence)
    and P3 genome expression use to run only a chosen subset. An ablated rule's
    handler is skipped ENTIRELY (not just its output filtered), so a pruned genome
    that lacks that rule's cost facts still runs cleanly. Handler ↔ rule name is
    `rule_<x>` ↔ `R_<x>`."""
    cands = []
    for h in HANDLERS:
        if ("R_" + h.__name__.split("_", 1)[1]) in ablate:
            continue
        cands += h(W, org, costs)
    cands.sort(key=lambda c: (c["prio"], c["rule"], c["key"]))
    return cands

# -------------------------------------------------------------- the chamber phase
def fire_to_quiescence(W, fuel, costs, org, log, trace, seq, budget=None, ablate=frozenset()):
    """Fire the fuel-gated pipeline over the LIVE X until no affordable candidate
    remains (quiescence / starvation) or the step budget is reached. Mutates W,
    fuel, log, trace in place; returns (next_seq, leftover_candidates).

    This is the kernel's firing core — shared by the P0 single run (run_chamber),
    the P1 epoch loop (evaluator.run_mortal), and P2 paired-replay (`ablate`). Fuel
    MINTING is never done here (schema.md §3, hard prohibition #1) — only the
    evaluator layer mints."""
    affordable = lambda c: all(fuel.get(t, 0) >= n for t, n in c.items())
    while budget is None or seq < budget:
        pick = next((c for c in enumerate_candidates(W, org, costs, ablate)
                     if affordable(c["cost"])), None)
        if pick is None:
            break
        for t, n in pick["cost"].items():                # debit fuel (lockstep)
            fuel[t] -= n
        log.append(("event", LOG_ID, seq, org, pick["rule"], f"B{seq}"))
        for t in sorted(pick["cost"]):
            log.append(("event-spend", LOG_ID, seq, t, pick["cost"][t]))
        for p in pick["produces"]:
            W.add(p)                                      # apply product to live X
            log.append(("event-add", LOG_ID, seq, p))
        trace.append((seq, pick))
        seq += 1
    leftover = list(enumerate_candidates(W, org, costs, ablate))   # enabled-but-unaffordable?
    return seq, leftover

# --------------------------------------------------------------- the chamber run
def run_chamber(data_facts, genome_facts, budget=None):
    """P0 single-phase run: one chamber phase to quiescence / starvation, no minting."""
    W     = set(data_facts) | set(genome_facts)
    org   = read_org(W)
    fuel  = read_fuel(W, org)
    costs = read_costs(W)
    log, trace = [], []
    seq, leftover = fire_to_quiescence(W, fuel, costs, org, log, trace, 0, budget)
    cause = "quiescent (no rule can fire)" if not leftover else \
            "starved (candidates remain but none affordable)"
    return dict(log=log, trace=trace, fuel=fuel, cause=cause, W=W, org=org, leftover=leftover)

# ------------------------------------------------------------------------- output
def fmt(x):
    return "(" + " ".join(fmt(e) for e in x) + ")" if isinstance(x, (list, tuple)) else str(x)

def main():
    r = run_chamber(parse_facts(DATA), parse_facts(GENOME))
    W = r["W"]
    print(f"P0 kernel — Experiment 1 · chamber CH_expt1 · organism {r['org']}")
    print(f"  firings: {len(r['trace'])}\n")
    print("  pipeline trace (priority-staged):")
    for seq, c in r["trace"]:
        print(f"   [{seq:>2}] p{c['prio']} {c['rule']:<11} {c['desc']}")

    # per-question pipeline completion
    intents = {t[1] for t in q(W, "q-intent", 2)}
    aligned = {t[2] for t in q(W, "alignment", 3)}
    answered = {t[1] for t in q(W, "candidate-answer", 2)}     # Q for each candidate-answer
    print("\n  per-question status:")
    for _h, _t, Q in sorted(q(W, "qa-question", 2)):
        ans = [t[2] for t in q(W, "candidate-answer", 2) if t[1] == Q]
        stage = ("answered: " + ", ".join(sorted(ans))) if ans else (
                "aligned-but-unprojected (starved)" if Q in aligned else
                "intent-only (starved)" if Q in intents else "untouched")
        print(f"   {Q:<5} {stage}")

    print(f"\n  remaining fuel : {r['fuel']}")
    print(f"  stop           : {r['cause']}")
    if r["leftover"]:
        print("  starved on     : " +
              ", ".join(sorted({c['rule'] for c in r['leftover']})) +
              "  (needs " + ", ".join(sorted({t for c in r['leftover'] for t in c['cost']})) + ")")

    # replay equivalence
    r2 = run_chamber(parse_facts(DATA), parse_facts(GENOME))
    ok = (r["log"] == r2["log"])
    print(f"\n  REPLAY EQUIVALENCE: {'PASS — identical event log' if ok else 'FAIL'}")

    # emit event log as portable facts
    out = REPO / "runs" / "run_log.metta"
    out.parent.mkdir(parents=True, exist_ok=True)
    lines = ["; P0 run event log — generated by src/kernel.py (portable facts).",
             f"!(add-atom &mork (event-log {LOG_ID}))",
             f"!(add-atom &mork (log-chamber {LOG_ID} CH_expt1))"]
    lines += [f"!(add-atom &mork {fmt(e)})" for e in r["log"]]
    out.write_text("\n".join(lines) + "\n")
    print(f"  event log facts: {len(r['log'])}  ->  {out.relative_to(REPO)}")
    return 0 if ok else 1

if __name__ == "__main__":
    raise SystemExit(main())
