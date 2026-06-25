; Experiment 1 — RULES in the CANONICAL per-match `C ^ G1 ==> G2` IR (D9). The genome's
; source of truth: separate `rule-lhs`/`rule-rhs` facts with `(var Name)` markers (named
; variables AS DATA), backend-neutral. The engine's converter (petta/kernel_defs.metta:
; express / convert-rule / to-vars) mints co-referent PeTTa match-vars and assembles each
; rule into the runnable `(crule …)` at genome-expression time. Rules fire PER-MATCH θ
; (MSC §4.3 eq 12–16): one firing per LHS match, `X' = X ⊕ θ(G2)` (set-union).
;
; This is THE genome now (the D9 swap is complete): the old D3 `crule` form, the
; causal_qa_rules proposers, and the Python prototype are all gone; every petta/ module
; runs these rules via the engine's converter + generic run. Tokens: gm = tau_graph_match,
; ci = tau_causal. (See [[design-decisions]] D9.)
;
; vs the old form: abstain is NOT a rule (it's the alignment rule simply not matching +
; the evaluator scoring the absence); align fires PER EDGE (no aggregation, no exists-guard
; — no edge ⇒ no match ⇒ no fire); complete's "rel is not causal" is the POSITIVE
; `(role-relation …)` vocabulary (configs.metta), not a negation.

; --- R_qtype: question-type detector + paraphrase-collapse (a clean join) ---------
(rule-context    R_qtype causal-qa)
(rule-priority   R_qtype 0)
(rule-token-cost R_qtype gm 1)
(rule-lhs R_qtype ((qa-question (var T) (var Q)) (q-word (var Q) (var W)) (intent-map (var W) (var I))))
(rule-rhs R_qtype ((q-intent (var Q) (var I))))

; --- R_align: causal-alignment, PER EDGE (fires once per explanatory edge into the focus) -
(rule-context    R_align causal-qa)
(rule-priority   R_align 1)
(rule-token-cost R_align gm 1)
(rule-token-cost R_align ci 1)
(rule-lhs R_align ((at ws (q-intent (var Q) (var I)))
                   (at self (intent-allows (var I) (var Cls)))
                   (at self (question-focus (var Q) (var Foc)))
                   (at self (question-source (var Q) (var G)))
                   (at self (sem-edge (var G) (var E) (var Rel) (var Src) (var Foc)))
                   (at self (edge-cluster (var Rel) (var Cls)))))
(rule-rhs R_align ((alignment (var Q) (var Cls))
                   (cites (var Q) (var Cls) (var G) (var E))
                   (prov  (var Q) (var Cls) (var G) (var Src))))

; --- R_complete: role-completion (cause's non-causal participants; POSITIVE role-relation) -
(rule-context    R_complete causal-qa)
(rule-priority   R_complete 2)
(rule-token-cost R_complete gm 1)
(rule-lhs R_complete ((at ws (cites (var Q) (var Cls) (var G) (var E)))
                      (at self (sem-edge (var G) (var E) (var Rel) (var Cause) (var Foc)))
                      (at self (sem-edge (var G) (var E2) (var Rel2) (var Cause) (var Filler)))
                      (at self (role-relation (var Rel2)))))
(rule-rhs R_complete ((role-fill (var Q) (var Cls) (var Rel2) (var Filler))))

; --- R_project: answer-skeleton projection (one candidate-answer per alignment) -----
(rule-context    R_project causal-qa)
(rule-priority   R_project 3)
(rule-token-cost R_project gm 1)
(rule-lhs R_project ((at ws (alignment (var Q) (var Cls)))))
(rule-rhs R_project ((candidate-answer (var Q) (a (var Q) (var Cls)))
                     (answer-by (a (var Q) (var Cls)) O_qa)
                     (answer-class (a (var Q) (var Cls)) (var Cls))))
