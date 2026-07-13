; Experiment 1 — RUN CONFIG, pure portable facts: the chamber, the two mortal organisms
; that own the genome, the clamps, and the shared fuel snapshot. Worker INSTANCES are
; declared by their runners (the test that exercises each kind), not here.

(chamber CH_expt1)
(chamber-context CH_expt1 causal-qa)
(chamber-life-history CH_expt1 K-like)

; --- organisms (schema §2.3): the genome runs as TWO mortal organisms, so that death is
; organism-level (a starved organism is one whose every rule can fire nothing). O_base owns
; the cue-normalizers (cost sm only); O_chain owns the transitive chainer (costs sm + tr)
; and FEEDS on O_base's derived ReasonFor edges — a rule eating rules' products. The engine
; resolves each rule -> its organism (rule-organism), so each organism's own typed purse pays
; for its firings. O_chain's only income is the root answer (which needs R_trans to fire, so
; it needs tr): under CL_shallow it earns no tr, its per-cycle tr surplus is negative, and it
; starves to death (eq 19); O_base lives on sm. Under CL_deep O_chain's tr income sustains it.
(organism O_base)
(organism-chamber O_base CH_expt1)
(genome-of O_base GNM_base)
(quoted-ruleset GNM_base RS_base)
(ruleset-member RS_base R_so)
(ruleset-member RS_base R_result)

(organism O_chain)
(organism-chamber O_chain CH_expt1)
(genome-of O_chain GNM_chain)
(quoted-ruleset GNM_chain RS_chain)
(ruleset-member RS_chain R_trans)

; --- clamps (MSC §4.4): the evaluator converts a grounding's ACHIEVEMENTS into typed
; fuel — the clamp maps each achievement to the token + amount it mints. The shallow
; clamp pays only the skeleton match, so O_chain earns no tr and starves; the deep clamp
; additionally pays transitive-explanation in tr, so O_chain's chaining is self-sustaining.
(clamp CL_shallow)
(clamp-mint CL_shallow skeleton-match sm 2)
(clamp-scope CL_shallow CH_expt1)

(clamp CL_deep)
(clamp-mint CL_deep skeleton-match sm 2)
(clamp-mint CL_deep transitive-explanation tr 2)
(clamp-scope CL_deep CH_expt1)

; --- the shared fuel SNAPSHOT (MSC §6.4): the canonical initial endowment a worker restores
; into its isolated hot-pool space — enough for one chamber run (R_so/R_result spend sm,
; R_trans spends sm + tr, seed tr = 1). Each worker instance (declared by its runner, in the
; test that exercises its kind) restores this via (worker-snapshot W SNAP_qa).
(snapshot-fuel SNAP_qa O_base sm 10)
(snapshot-fuel SNAP_qa O_chain sm 10)
(snapshot-fuel SNAP_qa O_chain tr 1)
