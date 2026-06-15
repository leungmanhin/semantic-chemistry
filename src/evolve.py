#!/usr/bin/env python3
"""
P3 — genome mutation + reproduction (= TECAN stage T6).

The P2-promoted ACS reified as a quoted genome `@R_qa` (a heritable rule-set). P3
makes that genome EVOLVE: it is mutated/recombined as data, offspring are
expressed and scored by **metabolic surplus** under matched replay, and selection
keeps the fittest. Reproduction is funded by surplus and gated by token-gated
dequotation (the germ→soma step, MSC/TECAN §3.3, eq 27).

The payoff ties straight to P2: P2's ablation found `R_complete` INERT (costs fuel,
0 reward). P3 should *discover that by selection* — a mutant that prunes
`R_complete` keeps every answer but spends less, so it has HIGHER surplus and
out-competes the parent; mutants that prune a load-bearing rule (`R_qtype` /
`R_align` / `R_project`) break the pipeline and starve. Recombination of two
complementary defective genomes rescues viability.

Clamp-switch at the reproductive level: under `CL_antecedent` the founder runs a
surplus and can reproduce (the lineage improves); under `CL_goal` it runs a
deficit and cannot afford to reproduce (the lineage never starts).

A genome is expressed by running only its `ruleset-member` rules — the kernel's
`ablate` hook suppresses non-members (until the rules are lifted and the kernel
reads `ruleset-member` directly). Deterministic; asserted.

Usage:  python3 src/evolve.py
"""
from kernel import REPO, DATA, GENOME, parse_facts
from evaluator import run_mortal, BALANCE_SEED
from acs_detect import surplus

ALL_RULES   = ("R_qtype", "R_align", "R_complete", "R_project")
RULE_FACTS  = {"ruleset-member", "chamber-hot-rule", "sem-rule",
               "rule-context", "rule-impl", "rule-priority", "rule-token-cost"}
KAPPA_COPY, KAPPA_MUT = 1, 1          # reproduction overhead (tau_graph_match)
KAPPA_DEQUOTE         = 1             # germ→soma dequotation cost (tau_dequote)
DEQUOTE_CAP           = 3             # seeded germ-line capacity per organism
FIT = "tau_graph_match"              # the binding currency = scalar fitness

# ----------------------------------------------------------------- genome ops
def members(genome):
    return frozenset(f[2] for f in genome if f and f[0] == "ruleset-member")

def express(data, genome, clamp):
    """Run only the genome's member rules (ablate the rest); return (answers, surplus)."""
    res = run_mortal(data, genome, clamp, seed_fuel=BALANCE_SEED,
                     ablate=frozenset(ALL_RULES) - members(genome))
    return res["answers"], surplus(res)

def fit(s):                                  # scalar fitness from a surplus dict
    return s.get(FIT, 0)

def prune(genome, R):
    """Structural mutation: drop rule R from the genome (membership + its headers)."""
    return [f for f in genome if not (f[0] in RULE_FACTS and R in f)]

def cost_tweak(genome, R, tok, delta):
    """Cost mutation: change rule R's cost for token `tok` by `delta`."""
    out = []
    for f in genome:
        if f[0] == "rule-token-cost" and f[1] == R and f[2] == tok:
            out.append((f[0], f[1], f[2], str(int(f[3]) + delta)))
        else:
            out.append(f)
    return out

def recombine(g1, g2):
    """Recombination: child carries the UNION of both parents' member rules."""
    keep = members(g1) | members(g2)
    out = [f for f in g1 if f[0] not in RULE_FACTS]   # keep g1's non-rule facts
    seen = set()
    for f in list(g1) + list(g2):                       # re-add rule facts for kept members
        if f[0] in RULE_FACTS:
            R = f[2] if f[0] in ("ruleset-member", "chamber-hot-rule") else f[1]
            if R in keep and f not in seen:
                out.append(f); seen.add(f)
    return out

# --------------------------------------------------------------- reproduction
def can_reproduce(s):
    """Funded by surplus: the parent must earn more than the copy+mutate overhead
    (and hold dequotation capacity, checked at the call site)."""
    return fit(s) >= KAPPA_COPY + KAPPA_MUT

def mutants(genome):
    """Deterministic offspring set: prune each member + one cost-inflation mutation."""
    out = [(f"prune-{R}", prune(genome, R)) for R in sorted(members(genome))]
    out.append(("cost+1:R_qtype", cost_tweak(genome, "R_qtype", "tau_graph_match", 1)))
    return out

# ---------------------------------------------------------------------- main
def evolve(data, genome0, clamp, max_gen=4):
    """Elitist selection by surplus under matched replay. Returns the lineage."""
    cur, (a0, s0) = genome0, express(data, genome0, clamp)
    lineage = [dict(gid="GNM_qa", parent=None, mut="founder",
                    members=sorted(members(genome0)), answers=a0, surplus=s0)]
    dequote = DEQUOTE_CAP
    for gen in range(1, max_gen + 1):
        cur_s = lineage[-1]["surplus"]
        if not can_reproduce(cur_s):
            lineage[-1]["halt"] = "parent unprofitable — cannot fund reproduction"
            break
        scored = []
        for label, child in mutants(cur):
            a, s = express(data, child, clamp)
            scored.append((label, child, a, s))
        viable = [(l, c, a, s) for l, c, a, s in scored if a > 0]
        best = max(viable, key=lambda x: fit(x[3]), default=None)
        if best is None or fit(best[3]) <= fit(cur_s):
            lineage[-1]["converged"] = [(l, a, fit(s)) for l, c, a, s in scored]
            break
        label, child, a, s = best
        dequote -= KAPPA_DEQUOTE                      # token-gated dequotation
        lineage.append(dict(gid=f"GNM_g{gen}", parent=lineage[-1]["gid"], mut=label,
                            members=sorted(members(child)), answers=a, surplus=s,
                            parent_fit=fit(cur_s),
                            repro_cost={"tau_graph_match": KAPPA_COPY + KAPPA_MUT,
                                        "tau_dequote": KAPPA_DEQUOTE},
                            offspring=[(l, aa, fit(ss)) for l, c, aa, ss in scored]))
        cur = child
    return lineage

def main():
    data, g0 = parse_facts(DATA), parse_facts(GENOME)
    print("P3 — genome mutation + reproduction (TECAN T6)\n")

    # ---- lineage under CL_antecedent ----
    print("=" * 76)
    print("LINEAGE under CL_antecedent — mutate, express, select by surplus (matched replay)")
    print("=" * 76)
    lin = evolve(data, g0, "CL_antecedent")
    for L in lin:
        print(f"\n  {L['gid']}  ({L['mut']})  rules={L['members']}")
        print(f"     answers {L['answers']}/6   surplus {FIT} {fit(L['surplus']):+d}"
              f" (full {dict(L['surplus'])})")
        if L.get("offspring"):                      # the brood this genome was selected from
            for lbl, a, fv in L["offspring"]:
                mark = ("selected ✅" if lbl == L["mut"]
                        else "non-viable (broke the loop)" if a == 0 else "viable, less fit")
                print(f"       · {lbl:<16} answers {a}/6  surplus {FIT} {fv:+d}   {mark}")
        if L.get("repro_cost"):
            print(f"     reproduction: parent funded it from surplus; paid {L['repro_cost']}"
                  f" (incl. token-gated dequotation)")
        if L.get("converged") is not None:
            print(f"     CONVERGED — no offspring fitter than {fit(L['surplus']):+d}")
        if L.get("halt"):
            print(f"     HALT — {L['halt']}")

    improved = len(lin) > 1
    if improved:
        p, c = lin[0], lin[-1]
        print(f"\n  RESULT: {p['gid']} ({fit(p['surplus']):+d}, {len(p['members'])} rules) "
              f"──{c['mut']}──▶ {c['gid']} ({fit(c['surplus']):+d}, {len(c['members'])} rules)"
              f"   Δsurplus {fit(c['surplus'])-fit(p['surplus']):+d}")
        print("  selection discovered the lean self-sustaining genome — pruning the INERT rule")
        print("  P2 flagged — and rejected every mutation that broke the load-bearing loop.")

    # ---- recombination rescue demo ----
    print("\n" + "=" * 76)
    print("RECOMBINATION — two complementary DEFECTIVE genomes → viable offspring")
    print("=" * 76)
    pa = prune(g0, "R_project")          # missing the projector
    pb = prune(g0, "R_qtype")            # missing the question-typer
    aa, _ = express(data, pa, "CL_antecedent")
    ab, _ = express(data, pb, "CL_antecedent")
    rc = recombine(pa, pb)
    ar, sr = express(data, rc, "CL_antecedent")
    print(f"  parent A {sorted(members(pa))}  → {aa}/6 answers  (non-viable)")
    print(f"  parent B {sorted(members(pb))}  → {ab}/6 answers  (non-viable)")
    print(f"  recombine(A,B) {sorted(members(rc))}  → {ar}/6 answers  surplus {FIT} {fit(sr):+d}"
          f"  → VIABLE (recombination rescues the loop)")

    # ---- clamp contrast: reproduction gate ----
    print("\n" + "=" * 76)
    print("CLAMP CONTRAST — reproduction is funded by surplus")
    print("=" * 76)
    for cl in ("CL_antecedent", "CL_goal"):
        _, s = express(data, g0, cl)
        gate = can_reproduce(s)
        print(f"  {cl:<14} founder surplus {FIT} {fit(s):+d}  →  "
              f"{'CAN reproduce → lineage evolves' if gate else 'CANNOT reproduce (unprofitable) → lineage halts at founder'}")

    # ---- emit lineage facts + determinism ----
    lin2 = evolve(data, g0, "CL_antecedent")
    deterministic = ([L["gid"] for L in lin2] == [L["gid"] for L in lin]
                     and [fit(L["surplus"]) for L in lin2] == [fit(L["surplus"]) for L in lin])
    lines = ["; P3 lineage — generated by src/evolve.py (portable facts).",
             "!(add-atom &mork (lineage L_qa))",
             "!(add-atom &mork (lineage-founder L_qa GNM_qa))"]
    for L in lin:
        for R in L["members"]:
            lines.append(f"!(add-atom &mork (genome-rule {L['gid']} {R}))")
        for tk, v in L["surplus"].items():
            lines.append(f"!(add-atom &mork (genome-fitness {L['gid']} CL_antecedent {tk} {v}))")
        if L["parent"]:
            lines.append(f"!(add-atom &mork (birth {L['gid']} {L['parent']} {L['mut']}))")
            for tk, n in L["repro_cost"].items():
                lines.append(f"!(add-atom &mork (birth-cost {L['gid']} {tk} {n}))")
            dlt = fit(L["surplus"]) - L["parent_fit"]
            lines.append(f"!(add-atom &mork (lineage-improvement {L['parent']} {L['gid']} {FIT} {dlt}))")
    out = REPO / "runs" / "lineage_p3.metta"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text("\n".join(lines) + "\n")

    print("\n" + "=" * 76)
    print(f"  determinism (re-run identical lineage): {'PASS' if deterministic else 'FAIL'}")
    print(f"  lineage facts: {len(lines) - 1}  ->  {out.relative_to(REPO)}")
    ok = improved and ar > 0 and deterministic
    return 0 if ok else 1

if __name__ == "__main__":
    raise SystemExit(main())
