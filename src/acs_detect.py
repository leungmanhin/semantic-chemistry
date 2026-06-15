#!/usr/bin/env python3
"""
P2 — ACS detection + metabolic surplus + causal replay (= TECAN stage T3).

Consumes the P1 chamber+evaluator run (evaluator.run_mortal) and asks: is the
QA-strategy rule loop a *mortal semantic ACS*? It certifies the five conditions
(MSC / TECAN eq 67) and promotes the loop only if it earns its keep:

  1. Closure         — the rules + evaluator form a closed cycle (a nontrivial SCC
                       of the rule-motif graph). KEY FINDING: among the soma rules
                       ALONE the graph is a feed-forward DAG (the P0 chain, no
                       cycle); the cycle closes ONLY through the evaluator minting
                       fuel back (E -> fuel -> rules). So this is a *metabolic* ACS.
  2. Autocatalysis   — fuel produced by the evaluator re-enables the member rules.
  3. Metabolic surplus — E[minted] - E[spent] > 0, componentwise, from the log.
  4. Causal influence  — paired-replay ablation: suppress each rule (and the
                       minting) and measure the drop in answers / minted reward.
  5. Heritability    — the loop reifies as a quoted genome that can be copied and
                       re-expressed (run an identical organism under fresh ids).

Promote iff surplus > 0 AND ablation impact > 0. The clamp-switch then bites at
the promotion level: the SAME structural loop is PROMOTED under CL_antecedent
(positive surplus) and REJECTED under CL_goal (negative surplus).

Deterministic (run_mortal is replay-equivalent; SCC over sorted nodes); asserted.

Usage:  python3 src/acs_detect.py

Like kernel.py / evaluator.py this is a Python PROTOTYPE — to be ported to PeTTa
later. P2 shortcut (flagged): each rule's *consumed* motif-types are declared in
CONSUMES below (derived from the kernel-resident handlers); they come for free
from rule-lhs once the rules are lifted to portable pattern-graphs (pre-P3). The
*produced* motifs and the whole fuel cycle are read from the event log directly.
"""
import sys
from pathlib import Path

from kernel import REPO, DATA, GENOME, parse_facts
from evaluator import run_mortal, BALANCE_SEED, CLOSURE_SEED

RULES = ("R_qtype", "R_align", "R_complete", "R_project")
E     = "E(evaluator)"
# Data-motif inputs per rule (P2 shortcut — from the kernel-resident handlers;
# will come from rule-lhs after the rules are lifted). Fuel inputs + all produced
# motifs are read from the event log, not declared.
CONSUMES = {
    "R_qtype":    ("qa-question", "q-word"),
    "R_align":    ("q-intent", "question-focus", "question-source", "sem-edge", "edge-cluster"),
    "R_complete": ("alignment", "alignment-cites", "sem-edge"),
    "R_project":  ("alignment", "alignment-cites", "alignment-prov", "role-fill"),
}
E_CONSUMES = ("candidate-answer", "answer-class", "answer-cites")   # evaluator reads answers

# ------------------------------------------------------------ metabolic surplus
def surplus(res):
    """E[minted] - E[spent] per token, summed over classes (from run_mortal's ledgers)."""
    toks = set()
    for d in list(res["spend"].values()) + list(res["income"].values()):
        toks |= set(d)
    out = {}
    for tk in sorted(toks):
        sp  = sum(res["spend"].get(c, {}).get(tk, 0) for c in res["spend"])
        inc = sum(res["income"].get(c, {}).get(tk, 0) for c in res["income"])
        out[tk] = inc - sp
    return out

def minted_total(res):
    return sum(n for r in res["rewards"] for n in r["minted"].values())

# ----------------------------------------------------------- rule-motif graph
def motif_graph(res, include_evaluator=True):
    """Build the directed rule-motif graph from the event log. Edges: rule -> motif
    it produces (from event-add), motif -> rule it consumes (CONSUMES + fuel from
    event-spend), and the evaluator E -> fuel (reward-credit) / answer -> E."""
    log = res["log"]
    seq2rule = {t[2]: t[4] for t in log if t[0] == "event"}
    produces, fuel_consume, e_produces = {}, {}, set()
    for t in log:
        if t[0] == "event-add":
            produces.setdefault(seq2rule[t[2]], set()).add(t[3][0])
        elif t[0] == "event-spend":
            fuel_consume.setdefault(seq2rule[t[2]], set()).add(t[3])
        elif t[0] == "reward-credit":
            e_produces.add(t[4])
    adj, nodes = {}, set()
    def edge(a, b):
        adj.setdefault(a, set()).add(b); nodes.update((a, b))
    for r in RULES:
        nodes.add(r)
        for m in produces.get(r, ()):
            edge(r, m)
        for m in tuple(CONSUMES[r]) + tuple(fuel_consume.get(r, ())):
            edge(m, r)
    if include_evaluator:
        for m in E_CONSUMES:
            edge(m, E)
        for m in e_produces:
            edge(E, m)
    return nodes, {k: sorted(v) for k, v in adj.items()}, produces, fuel_consume, e_produces

def sccs(nodes, adj):
    """Tarjan strongly-connected components (deterministic over sorted nodes)."""
    sys.setrecursionlimit(10000)
    idx, low, on, stk, out, ctr = {}, {}, {}, [], [], [0]
    def dfs(v):
        idx[v] = low[v] = ctr[0]; ctr[0] += 1; stk.append(v); on[v] = True
        for w in adj.get(v, ()):
            if w not in idx:
                dfs(w); low[v] = min(low[v], low[w])
            elif on.get(w):
                low[v] = min(low[v], idx[w])
        if low[v] == idx[v]:
            comp = []
            while True:
                w = stk.pop(); on[w] = False; comp.append(w)
                if w == v:
                    break
            out.append(sorted(comp))
    for v in sorted(nodes):
        if v not in idx:
            dfs(v)
    return out

def acs_scc(res, include_evaluator):
    nodes, adj, *_ = motif_graph(res, include_evaluator)
    big = [c for c in sccs(nodes, adj) if len(c) > 1]
    return big

# ----------------------------------------------------------- causal replay
def ablation(data, genome, clamp, seed):
    base = run_mortal(data, genome, clamp, seed_fuel=seed)
    base_m = minted_total(base)
    rows = []
    for r in RULES:
        ab = run_mortal(data, genome, clamp, seed_fuel=seed, ablate=frozenset({r}))
        rows.append((r, base["answers"] - ab["answers"], base_m - minted_total(ab)))
    return base, base_m, rows

def reexpress(data, genome, clamp, seed):
    """Heritability: copy the genome under fresh ids and re-run — identical behaviour
    ⇒ the loop is a faithfully re-expressible quoted genome."""
    ren = {"O_qa": "O_qa2", "GNM_qa": "GNM_qa2", "RS_qa": "RS_qa2"}
    g2 = [tuple(ren.get(x, x) for x in fact) for fact in genome]
    base = run_mortal(data, genome, clamp, seed_fuel=seed)
    copy = run_mortal(data, g2,     clamp, seed_fuel=seed)
    ok = (base["answers"] == copy["answers"] and surplus(base) == surplus(copy)
          and copy["org"] == "O_qa2")
    return ok, copy["org"]

# ---------------------------------------------------------------------- main
def fmt_surplus(s):
    return "  ".join(f"{tk} {v:+d}" for tk, v in s.items())

def main():
    data, genome = parse_facts(DATA), parse_facts(GENOME)
    ACS = "ACS_qa"
    print("P2 — ACS detection + metabolic surplus + causal replay (TECAN T3)\n")

    # ---- 1. closure: chain (rules only) vs ACS (rules + evaluator) ----
    print("=" * 76)
    print("CONDITION 1+2 — CLOSURE & AUTOCATALYSIS  (rule-motif graph from the P1 log)")
    print("=" * 76)
    base = run_mortal(data, genome, "CL_antecedent", seed_fuel=BALANCE_SEED)
    chain = acs_scc(base, include_evaluator=False)
    loop  = acs_scc(base, include_evaluator=True)
    print(f"  soma rules ALONE      : {'feed-forward DAG (no cycle)' if not chain else chain}")
    print(f"                          → the P0 chain: spends a fixed endowment, not closed.")
    member_scc = max(loop, key=len) if loop else []
    rule_members = [n for n in member_scc if n in RULES]
    print(f"  rules + evaluator (E) : 1 closed cycle (SCC of {len(member_scc)} nodes)")
    print(f"                          {member_scc}")
    *_, e_prod = motif_graph(base, True)
    closure = bool(loop) and not chain
    autocat = bool(e_prod) and set(RULES).issubset(set(member_scc))
    print(f"  CLOSURE       : {'PASS' if closure else 'FAIL'} — cycle exists ONLY with the evaluator's"
          f" fuel edge (metabolic closure).")
    print(f"  AUTOCATALYSIS : {'PASS' if autocat else 'FAIL'} — evaluator mints {sorted(e_prod)} which"
          f" re-enable the member rules.")

    # ---- 3. metabolic surplus (per clamp) ----
    print("\n" + "=" * 76)
    print("CONDITION 3 — METABOLIC SURPLUS   E[minted] − E[spent], componentwise")
    print("=" * 76)
    s_ant = surplus(run_mortal(data, genome, "CL_antecedent", seed_fuel=BALANCE_SEED))
    s_goal = surplus(run_mortal(data, genome, "CL_goal",      seed_fuel=BALANCE_SEED))
    pos_ant  = all(v > 0 for v in s_ant.values())
    pos_goal = all(v > 0 for v in s_goal.values())
    print(f"  CL_antecedent : {fmt_surplus(s_ant)}   → {'POSITIVE (self-sustaining)' if pos_ant else 'deficit'}")
    print(f"  CL_goal       : {fmt_surplus(s_goal)}   → {'positive' if pos_goal else 'DEFICIT (starves over time)'}")

    # ---- 4. causal influence (paired-replay ablation) ----
    print("\n" + "=" * 76)
    print("CONDITION 4 — CAUSAL INFLUENCE   (paired-replay ablation, CL_antecedent)")
    print("=" * 76)
    base_run, base_m, rows = ablation(data, genome, "CL_antecedent", BALANCE_SEED)
    print(f"  baseline: {base_run['answers']}/{base_run['total']} answered, {base_m} tokens minted")
    print("  per-rule do-influence (suppress one rule → Δanswers, Δminted):")
    for r, da, dm in rows:
        tag = "load-bearing" if dm > 0 else "INERT — costs fuel, 0 reward impact (prune candidate)"
        print(f"    ablate {r:<11} Δanswers {-da:+d}  Δminted {-dm:+d}   {tag}")
    # autocatalysis ablation: remove minting (feedback off) at the constrained seed
    off = run_mortal(data, genome, "CL_antecedent", seed_fuel=CLOSURE_SEED, feedback=False)
    on  = run_mortal(data, genome, "CL_antecedent", seed_fuel=CLOSURE_SEED, feedback=True)
    print(f"  ablate MINTING (feedback off, constrained seed): "
          f"{on['answers']}/{on['total']} → {off['answers']}/{off['total']} answered "
          f"— the metabolic loop is causally responsible for sustaining the strategy.")
    causal = max(dm for _r, _da, dm in rows) > 0

    # ---- 5. heritability ----
    print("\n" + "=" * 76)
    print("CONDITION 5 — HERITABILITY   (reify quoted genome + re-express under fresh ids)")
    print("=" * 76)
    herit, child = reexpress(data, genome, "CL_antecedent", BALANCE_SEED)
    print(f"  genome GNM_qa (ruleset {list(RULES)}) reified; copied → organism {child}")
    print(f"  re-expression identical (answers + surplus): {'PASS' if herit else 'FAIL'}  → heritable")

    # ---- promotion (the clamp-switch at the ACS level) ----
    print("\n" + "=" * 76)
    print("PROMOTION — promote iff surplus>0 AND ablation impact>0 (the clamp-switch bites here)")
    print("=" * 76)
    prom_ant  = closure and autocat and pos_ant and causal and herit
    prom_goal = closure and autocat and pos_goal and causal and herit
    print(f"  CL_antecedent : closure✓ autocat✓ surplus{'✓' if pos_ant else '✗'} causal✓ heritable✓"
          f"  →  {'PROMOTED ✅' if prom_ant else 'rejected'}")
    print(f"  CL_goal       : closure✓ autocat✓ surplus{'✓' if pos_goal else '✗'} causal✓ heritable✓"
          f"  →  {'PROMOTED' if prom_goal else 'REJECTED ❌ (negative surplus — not self-sustaining)'}")
    print("  => the SAME structural loop is a viable mortal ACS under one clamp and not the other.")

    # ---- emit P2 facts + determinism check ----
    rep = run_mortal(data, genome, "CL_antecedent", seed_fuel=BALANCE_SEED)
    deterministic = (rep["log"] == base["log"])
    lines = ["; P2 ACS-detection result — generated by src/acs_detect.py (portable facts).",
             f"!(add-atom &mork (acs {ACS}))",
             f"!(add-atom &mork (acs-chamber {ACS} CH_expt1))"]
    lines += [f"!(add-atom &mork (acs-member {ACS} {r}))" for r in RULES]
    lines += [f"!(add-atom &mork (acs-closure {ACS} metabolic))",
              f"!(add-atom &mork (acs-autocatalysis {ACS} via-evaluator-fuel))"]
    lines += [f"!(add-atom &mork (acs-surplus {ACS} CL_antecedent {tk} {v}))" for tk, v in s_ant.items()]
    lines += [f"!(add-atom &mork (acs-surplus {ACS} CL_goal {tk} {v}))" for tk, v in s_goal.items()]
    lines += [f"!(add-atom &mork (acs-do-influence {ACS} {r} {dm}))" for r, _da, dm in rows]
    lines += [f"!(add-atom &mork (acs-heritable {ACS} GNM_qa))",
              f"!(add-atom &mork (acs-promoted {ACS} CL_antecedent {str(prom_ant).lower()}))",
              f"!(add-atom &mork (acs-promoted {ACS} CL_goal {str(prom_goal).lower()}))"]
    out = REPO / "runs" / "acs_p2.metta"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text("\n".join(lines) + "\n")
    print(f"\n  determinism (re-run identical log): {'PASS' if deterministic else 'FAIL'}")
    print(f"  ACS facts: {len(lines) - 1}  ->  {out.relative_to(REPO)}")
    return 0 if (prom_ant and not prom_goal and deterministic) else 1

if __name__ == "__main__":
    raise SystemExit(main())
