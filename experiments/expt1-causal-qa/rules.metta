; Experiment 1 — RULES: the derivation GENOME, canonical per-match `rule-lhs`/`rule-rhs`
; IR with (var Name) markers (the engine's converter compiles each to a runnable crule;
; rules fire per LHS match θ, products ⊕ set-union). The genome is the INTERPRETIVE
; THEORY: the parser emits surface discourse cues only, and these rules derive the
; normalized explanatory layer — `ReasonFor`, the relation the answer-skeletons query
; (SC §4.5) — the fuse-nf-normalizer's job expressed as selectable genes.
;
; Products carry deterministic, provenance-bearing edge-ids — (norm E) names its source
; cue edge, (trans E1 E2) its two premise edges — and copy the premise TV (PLN TV
; formulas arrive with the chainer). The IR convention the engine reads structurally:
; a DERIVED edge-id is a compound whose head names the deriving step and whose
; arguments are the premise edge-ids (so depth/provenance need no id vocabulary).
; Tokens: sm = skeleton-match fuel (tau_graph_match), tr = transitive-explanation fuel.

; --- R_so: "X, so Y" — the cue asserts X is the reason for Y -------------------
(rule-context    R_so causal-qa)
(rule-priority   R_so 0)
(rule-token-cost R_so sm 1)
(rule-lhs R_so ((sem-edge (var g) (var e) So (var x) (var y))
                (sem-edge-tv (var g) (var e) (var tv))))
(rule-rhs R_so ((sem-edge (var g) (norm (var e)) ReasonFor (var x) (var y))
                (sem-edge-tv (var g) (norm (var e)) (var tv))))

; --- R_result: "X, and as a result Y" ------------------------------------------
(rule-context    R_result causal-qa)
(rule-priority   R_result 1)
(rule-token-cost R_result sm 1)
(rule-lhs R_result ((sem-edge (var g) (var e) AsAResult (var x) (var y))
                    (sem-edge-tv (var g) (var e) (var tv))))
(rule-rhs R_result ((sem-edge (var g) (norm (var e)) ReasonFor (var x) (var y))
                    (sem-edge-tv (var g) (norm (var e)) (var tv))))

; --- R_trans: reasons chain — the reason of my reason explains me too ----------
; (consumes DERIVED ReasonFor edges: a level-2 rule feeding on level-1 products)
(rule-context    R_trans causal-qa)
(rule-priority   R_trans 2)
(rule-token-cost R_trans sm 1)
(rule-token-cost R_trans tr 1)
(rule-lhs R_trans ((sem-edge (var g) (var e1) ReasonFor (var x) (var y))
                   (sem-edge (var g) (var e2) ReasonFor (var y) (var z))
                   (sem-edge-tv (var g) (var e1) (var tv))))
(rule-rhs R_trans ((sem-edge (var g) (trans (var e1) (var e2)) ReasonFor (var x) (var z))
                   (sem-edge-tv (var g) (trans (var e1) (var e2)) (var tv))))
