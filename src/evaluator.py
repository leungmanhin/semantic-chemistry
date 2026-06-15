#!/usr/bin/env python3
"""
P1 evaluator + clamps — Mortal Semantic Chemistry, Experiment 1.

This is the layer P0 deliberately left out (schema.md §6, hard prohibition #1):
the EVALUATOR. It runs *outside* the fuel-gated firing loop and does three things
the soma is forbidden to do for itself:

  1. SCORE   each candidate-answer against its gold skeleton(s) by a faithful
             subset of MSC eq 17 (Match - Unsupportedness - Redundancy),
             parameterized by the ACTIVE CLAMP's coefficients (clamp-coeff).
  2. MINT    typed fuel by the active clamp's class (clamp-class / clamp-token).
             Off-class answers earn nothing; fabrication is penalized; correct
             abstention is honoured. Minting is NEVER done by a soma rule.
  3. CREDIT  the minted fuel back to the organism, so answering a question funds
             answering the NEXT one. This is what turns the P0 feed-forward CHAIN
             into a self-sustaining mortal ACS — the autocatalytic loop closes
             *metabolically* (fuel economy), not graph-structurally.

The run is an EPOCH loop:  [chamber phase: fire_to_quiescence]  ->  [evaluator
phase: score + mint + credit]  ->  repeat.  The two phases stay cleanly separated
(the chamber phase is the unmodified P0 kernel; only the evaluator mints).

The CLAMP-SWITCH is the headline experiment (expt1_causal_qa_design Package B):
the SAME snapshot + seed + budget, run once under CL_antecedent (rewards the
physical-cause class) and once under CL_goal (rewards the intentional class).
Reward selects strategy: the rewarded class runs a metabolic SURPLUS while the
other runs a DEFICIT, and the surplus/deficit FLIP when the clamp is swapped.
Q7a's dual answers (physical + intentional) are the pivot.

Determinism: the evaluator is a pure function of (W, clamp); answers are scored
in canonical id order; so the whole P1 run is replay-equivalent (asserted).

Like src/kernel.py this is a Python PROTOTYPE — to be ported to PeTTa once the
design is confirmed working (the Python version is then the replay/mint oracle).
Note the asymmetry vs the rules: the clamp CONFIG is portable facts, but the
eq-17 term computations below are evaluator-worker CODE the PeTTa port will
reimplement against the same facts (schema.md §2.8; design_decisions D3).

Usage:  python3 src/evaluator.py
"""
from pathlib import Path

from kernel import (REPO, DATA, GENOME, LOG_ID, q, fmt, parse_facts,
                    read_org, read_costs, fire_to_quiescence)

# ---- P1 economy constants (the clamp's score->fuel calibration; tunable) -------
# tau_graph_match is the binding / closure currency: every rule spends it, and
# the clamp mints it back on a well-scored, correctly-classed answer. causal-
# inference-token is seeded non-binding (so it never confounds the gm economy);
# the antecedent clamp additionally refunds it on causal citations.
#
# Two seed levels, for two distinct demonstrations:
#  - BALANCE_SEED is generous (covers all firings) so BOTH clamps answer every
#    question; the clamp-switch then shows as an order-INDEPENDENT per-class
#    surplus/deficit flip (the rigorous "reward selects strategy" signal).
#  - CLOSURE_SEED is constrained so the organism starves on seed fuel alone; the
#    fuel it MINTS by answering is what funds the rest — metabolic closure.
BALANCE_SEED  = {"tau_graph_match": 24, "tau_causal": 20}
CLOSURE_SEED  = {"tau_graph_match": 15, "tau_causal": 20}
SEED_FUEL     = BALANCE_SEED   # default
SCALE         = 6     # match 1.0 -> 6 tau_graph_match minted; calibrated so the rewarded
                      # strategy runs a POSITIVE metabolic surplus (minted>spent) — see P2
MINT_FLOOR    = 0.0   # mint only when the eq-17 score strictly exceeds this
ABSTAIN_SCALE = 0.75  # correct abstention mints (SCALE*ABSTAIN_SCALE) ~ its cost
CI_REWARD     = 2     # causal-citation -> tau_causal refunded (>= R_align's per-answer spend
                      # so the rewarded loop is componentwise self-sustaining)
BUDGET        = 100   # deterministic step budget (schema.md §4)

# ------------------------------------------------------------------ fact readers
def answer_info(W, A):
    abstain = any(t[1] == A for t in q(W, "answer-abstain", 1))
    cls = next((t[2] for t in q(W, "answer-class", 2) if t[1] == A), None)
    return dict(cls=("abstain" if abstain else cls), abstain=abstain,
                cites={(t[2], t[3]) for t in q(W, "answer-cites", 3) if t[1] == A},
                prov ={(t[2], t[3]) for t in q(W, "answer-provenance", 3) if t[1] == A})

def gold_skeletons(W, Q):
    out = []
    for _h, q_, SK in q(W, "answer-skeleton", 2):
        if q_ != Q:
            continue
        out.append(dict(
            sk=SK,
            cls=next((t[2] for t in q(W, "skeleton-class", 2) if t[1] == SK), None),
            abstain=any(t[1] == SK for t in q(W, "skeleton-abstain", 1)),
            cites={(t[2], t[3]) for t in q(W, "skeleton-cites", 3) if t[1] == SK},
            prov ={(t[2], t[3]) for t in q(W, "skeleton-provenance", 3) if t[1] == SK}))
    return out

def clamp_info(W, CL):
    return dict(
        cls=next((t[2] for t in q(W, "clamp-class", 2) if t[1] == CL), None),
        coeff={t[2]: float(t[3]) for t in q(W, "clamp-coeff", 3) if t[1] == CL},
        tokens={t[2]: t[3] for t in q(W, "clamp-token", 3) if t[1] == CL})

def graph_edges(W, G):
    return {(G, t[2]) for t in q(W, "sem-edge", 5) if t[1] == G}

def edge_cluster(W, G, E):
    rel = next((t[3] for t in q(W, "sem-edge", 5) if t[1] == G and t[2] == E), None)
    return next((t[2] for t in q(W, "edge-cluster", 2) if t[1] == rel), None)

# ------------------------------------------------------------- eq-17 scoring (subset)
def score_answer(W, A, Q, clamp):
    """A faithful subset of MSC eq 17 under the active clamp:
        score = a*Match - lambda*Unsupportedness - nu*Redundancy
    Match is class-gated: an answer earns only against a gold skeleton of the
    clamp's class. Returns dict(terms, score, kind, ai)."""
    ai     = answer_info(W, A)
    golds  = gold_skeletons(W, Q)
    active = next((g for g in golds if g["cls"] == clamp["cls"]), None)
    # gold for THIS clamp is "abstain" when an explicit abstain skeleton exists,
    # or there is simply no skeleton of the active class (schema.md §2.7).
    gold_abstain = any(g["abstain"] for g in golds) or (active is None)
    coeff  = clamp["coeff"]
    terms  = {"match": 0.0, "unsupportedness": 0.0, "redundancy": 0.0}

    if ai["abstain"]:
        kind = "abstain-correct" if gold_abstain else "abstain-wrong"
        terms["match"] = 1.0 if gold_abstain else 0.0
    elif ai["cls"] != clamp["cls"]:
        kind = "off-class"                       # produced, but not this clamp's class
    elif active is None or not active["cites"]:
        kind = "unsupported"                     # answered where the gold is abstain
        terms["unsupportedness"] = 1.0
    else:
        kind = "answer"
        covered   = ai["cites"] & active["cites"]
        recall    = len(covered) / len(active["cites"])
        precision = len(covered) / len(ai["cites"]) if ai["cites"] else 0.0
        terms["match"] = recall * precision      # cover the gold cites, no padding
        srcG = next((t[2] for t in q(W, "question-source", 2) if t[1] == Q), None)
        present = {ce for ce in ai["cites"] if srcG and ce in graph_edges(W, srcG)}
        terms["unsupportedness"] = (len(ai["cites"]) - len(present)) / len(ai["cites"])
        terms["redundancy"] = len(ai["cites"] - active["cites"]) / len(ai["cites"])

    score = (coeff.get("match", 0.0)            * terms["match"]
             - coeff.get("unsupportedness", 0.0) * terms["unsupportedness"]
             - coeff.get("redundancy", 0.0)      * terms["redundancy"])
    return dict(terms=terms, score=score, kind=kind, ai=ai)

def mint(scored, clamp, W):
    """Convert an eq-17 score to TYPED fuel via the clamp's clamp-token map.
    Never called from inside the firing loop (hard prohibition #1)."""
    minted, score, kind, ai = {}, scored["score"], scored["kind"], scored["ai"]
    if score <= MINT_FLOOR:
        return minted                            # off-class / unsupported / wrong-abstain
    tokens = clamp["tokens"]
    base   = score * (ABSTAIN_SCALE if kind == "abstain-correct" else 1.0)
    if "skeleton-match" in tokens:               # the operational closure token
        n = round(SCALE * base)
        if n > 0:
            minted[tokens["skeleton-match"]] = minted.get(tokens["skeleton-match"], 0) + n
    if "causal-citation" in tokens and kind == "answer":
        if any(edge_cluster(W, g, e) == "physical-cause" for g, e in ai["cites"]):
            tok = tokens["causal-citation"]
            minted[tok] = minted.get(tok, 0) + CI_REWARD
    return minted

# --------------------------------------------- per-firing class attribution (spend)
def pick_class(pick):
    """The answer-class a firing's work belongs to (for per-class metabolism)."""
    r = pick["rule"]
    if r == "R_align":
        for p in pick["produces"]:
            if p[0] == "alignment":
                return p[3]
    elif r == "R_complete":
        for p in pick["produces"]:
            if p[0] == "role-fill":
                return p[1].split("_", 2)[2]      # AL_<Q>_<cls> -> cls
    elif r == "R_project":
        for p in pick["produces"]:
            if p[0] == "answer-class":
                return p[2]
            if p[0] == "answer-abstain":
                return "abstain"
    return "overhead"                            # R_qtype: pre-class question overhead

# ----------------------------------------------------------------- the mortal run
def run_mortal(data, genome, clamp_id, seed_fuel=None, feedback=True, budget=BUDGET, ablate=frozenset()):
    """Epoch loop: fire to quiescence/starvation, then the evaluator scores + mints
    + credits, then re-fire on the replenished fuel. With feedback=False no fuel is
    minted (the P0 baseline) — used to show closure does real work."""
    W      = set(data) | set(genome)
    org    = read_org(W)
    costs  = read_costs(W)
    clamp  = clamp_info(W, clamp_id)
    fuel   = dict(seed_fuel or SEED_FUEL)
    log, trace, rewards, mint_facts = [], [], [], []
    scored, seq, epoch = set(), 0, 0

    while seq < budget:
        seq, _ = fire_to_quiescence(W, fuel, costs, org, log, trace, seq, budget, ablate)
        ca  = {A: Q for _h, Q, A in q(W, "candidate-answer", 2)}
        new = sorted(A for A in ca if A not in scored)
        if not new:
            break                                 # no progress -> finished or dead
        minted_any = False
        for A in new:                             # canonical id order -> deterministic
            scored.add(A)
            sc     = score_answer(W, A, ca[A], clamp)
            minted = mint(sc, clamp, W) if feedback else {}
            rewards.append(dict(A=A, Q=ca[A], cls=sc["ai"]["cls"], kind=sc["kind"],
                                terms=sc["terms"], score=sc["score"], minted=minted))
            for term, v in sc["terms"].items():
                mint_facts.append(("answer-score", A, term, round(v, 3)))
            for tok, n in minted.items():
                if n <= 0:
                    continue
                fuel[tok] = fuel.get(tok, 0) + n  # CREDIT (evaluator-side, not a firing)
                log.append(("reward-credit", LOG_ID, epoch, org, tok, n))
                mint_facts.append(("answer-reward", A, tok, n))
                minted_any = True
        epoch += 1
        if not (feedback and minted_any):
            break                                 # no fresh fuel -> chamber can't advance

    # per-class metabolism: spend (from the trace) vs income (from the mints)
    spend, income = {}, {}
    for _seq, pick in trace:
        cls = pick_class(pick)
        for tok, n in pick["cost"].items():
            spend.setdefault(cls, {})[tok] = spend.setdefault(cls, {}).get(tok, 0) + n
    for r in rewards:
        for tok, n in r["minted"].items():
            income.setdefault(r["cls"], {})[tok] = income.setdefault(r["cls"], {}).get(tok, 0) + n

    total_q  = {Q for _h, _t, Q in q(W, "qa-question", 2)}
    answ_q   = {Q for _h, Q, _a in q(W, "candidate-answer", 2)}
    fate = ("survived — every question reached an answer" if answ_q >= total_q
            else f"starved — {len(answ_q)}/{len(total_q)} questions answered")
    return dict(W=W, org=org, log=log, trace=trace, rewards=rewards, mint_facts=mint_facts,
                fuel=fuel, spend=spend, income=income, epochs=epoch, firings=len(trace),
                answers=len(answ_q), total=len(total_q), fate=fate, clamp=clamp_id)

# ------------------------------------------------------------------------- balance
def class_balance(res, token="tau_graph_match"):
    classes = sorted(set(res["spend"]) | set(res["income"]))
    rows = []
    for c in classes:
        s = res["spend"].get(c, {}).get(token, 0)
        i = res["income"].get(c, {}).get(token, 0)
        rows.append((c, i, s, i - s))
    return rows

# ------------------------------------------------------------------------- reports
def print_run(res):
    print(f"  clamp {res['clamp']:<13} epochs={res['epochs']}  firings={res['firings']}"
          f"  answers={res['answers']}/{res['total']}")
    print(f"    fate: {res['fate']}")
    print(f"    final fuel: {res['fuel']}")
    print("    eq-17 scoring (per candidate-answer, under this clamp):")
    for r in sorted(res["rewards"], key=lambda x: x["A"]):
        t = r["terms"]
        mintstr = " ".join(f"{k}+{v}" for k, v in r["minted"].items()) or "—"
        print(f"      {r['A']:<24} {r['kind']:<15} "
              f"M={t['match']:.2f} U={t['unsupportedness']:.2f} R={t['redundancy']:.2f}"
              f"  score={r['score']:+.2f}  mint:{mintstr}")
    print("    per-class metabolism (tau_graph_match):  income  spend  balance")
    for c, i, s, b in class_balance(res):
        flag = "  <- SURPLUS" if b > 0 else ("  <- deficit" if b < 0 else "")
        print(f"      {c:<15} {i:>7} {s:>6} {b:>+8}{flag}")

# ---------------------------------------------------------------------------- main
def main():
    data, genome = parse_facts(DATA), parse_facts(GENOME)

    print("P1 evaluator + clamps — Experiment 1 · chamber CH_expt1")

    # --- 1. clamp-switch: per-class metabolic surplus/deficit (order-independent)
    print("\n" + "=" * 76)
    print("CLAMP-SWITCH — same snapshot+seed+budget, swap the clamp (reward selects strategy)")
    print("=" * 76)
    runs = {}
    for cl in ("CL_antecedent", "CL_goal"):
        runs[cl] = run_mortal(data, genome, cl, seed_fuel=BALANCE_SEED)
        print()
        print_run(runs[cl])

    print("\n  RESULT — the surplus class FLIPS with the clamp:")
    for cl in ("CL_antecedent", "CL_goal"):
        bal = {c: b for c, _i, _s, b in class_balance(runs[cl])}
        win = max(("physical-cause", "intentional"), key=lambda c: bal.get(c, 0))
        print(f"    {cl:<14} physical {bal.get('physical-cause', 0):+d} | "
              f"intentional {bal.get('intentional', 0):+d}   ->  pays for itself: {win}")
    print("    (order-independent: both clamps answer every question; only the minting differs.)")

    # --- 2. metabolic closure: minted fuel funds further computation (chain -> ACS)
    print("\n" + "=" * 76)
    print("METABOLIC CLOSURE — at a constrained seed, does minting fund more computation?")
    print("=" * 76)
    for cl in ("CL_antecedent", "CL_goal"):
        off = run_mortal(data, genome, cl, seed_fuel=CLOSURE_SEED, feedback=False)
        on  = run_mortal(data, genome, cl, seed_fuel=CLOSURE_SEED, feedback=True)
        print(f"  {cl:<14} feedback OFF: {off['answers']}/{off['total']} answered "
              f"({off['firings']} firings)   ->   ON: {on['answers']}/{on['total']} answered "
              f"({on['firings']} firings)   = +{on['firings'] - off['firings']} firings earned")
    print("  CL_antecedent: the fuel earned by answering questions funds the rest — the P0")
    print("  feed-forward chain is now a self-sustaining mortal ACS. (CL_goal cannot bootstrap:")
    print("  the first answer it can afford is physical, which the goal-clamp does not reward —")
    print("  viability is clamp-coupled. This cascade is order-sensitive; the §1 balance is not.)")

    # --- 3. invariants
    print("\n" + "=" * 76)
    print("INVARIANTS")
    print("=" * 76)
    soma_minted = any(p[0] in ("answer-reward", "reward-credit")
                      for _s, pk in runs["CL_antecedent"]["trace"] for p in pk["produces"])
    print(f"  hard prohibition #1 (no soma-minted fuel): "
          f"{'VIOLATED' if soma_minted else 'OK — only the evaluator mints'}")
    rep = run_mortal(data, genome, "CL_antecedent", seed_fuel=BALANCE_SEED)
    ok  = (rep["log"] == runs["CL_antecedent"]["log"] and
           rep["mint_facts"] == runs["CL_antecedent"]["mint_facts"])
    print(f"  replay equivalence (P1 = chamber + evaluator): "
          f"{'PASS — identical event log + mints' if ok else 'FAIL'}")

    # emit the P1 event + mint log as portable facts
    out = REPO / "runs" / "run_log_p1.metta"
    out.parent.mkdir(parents=True, exist_ok=True)
    res = runs["CL_antecedent"]
    lines = ["; P1 run log (clamp CL_antecedent, BALANCE_SEED) — generated by src/evaluator.py.",
             "; event-* = chamber firings; reward-credit/answer-reward/answer-score = evaluator.",
             f"!(add-atom &mork (event-log {LOG_ID}))",
             f"!(add-atom &mork (log-chamber {LOG_ID} CH_expt1))",
             f"!(add-atom &mork (log-clamp {LOG_ID} {res['clamp']}))"]
    lines += [f"!(add-atom &mork {fmt(e)})" for e in res["log"]]
    lines += [f"!(add-atom &mork {fmt(f)})" for f in res["mint_facts"]]
    out.write_text("\n".join(lines) + "\n")
    print(f"  P1 log facts: {len(res['log']) + len(res['mint_facts'])}  ->  {out.relative_to(REPO)}")
    return 0 if ok and not soma_minted else 1

if __name__ == "__main__":
    raise SystemExit(main())
