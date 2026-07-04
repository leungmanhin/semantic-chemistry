; ===========================================================================
; selection-epoch: the P3 lineage (TECAN T6).
; ---------------------------------------------------------------------------
; Uses the reusable P3 operators in petta/selection.metta (express a genome by running
; only its member rules; prune / recombine; surplus-based `fitter`). Fitness = metabolic
; surplus (income - spend), each genome expressed in its OWN space (generous fuel). The
; lineage (9 tests):
;  * founder {qtype,align,complete,project} surplus -3 (R_complete's 9 inert firings sink
;    it into DEFICIT); pruning R_complete -> +6 (the unique fitter, the only viable genome)
;    => selection rediscovers the dead-weight rule, lineage GNM_qa(-3) -> GNM_g1(+6).
;    Pruning any load-bearing rule collapses surplus (R_qtype 0, R_align -2, R_project -18).
;  * recombination of two answer-incapable genomes (one missing R_project, one missing
;    R_qtype) -> the union genome is viable again (6 answers).
;
; Run:  sh ../PeTTa/run.sh tests/selection_test.metta < /dev/null \
;          2>&1 | grep should   # nine ✅
; ===========================================================================
!(import! &self "petta/util.metta")
!(import! &self "petta/fuel.metta")
!(import! &self "petta/compiler.metta")
!(import! &self "petta/gate.metta")
!(import! &self "petta/reaction.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")
!(import! &self "petta/evaluator.metta")
!(import! &self "petta/selection.metta")   ; run-genome · prune · union-genome · express-surplus · fitter

; the demo's starting genome (= the full loaded rule set)
(= (founder) (R_qtype R_align R_complete R_project))

; --- fitness landscape: surplus of the founder vs each single-rule prune (own spaces) ----
!(bind! &g_found (new-space))
!(bind! &g_noComplete (new-space))
!(bind! &g_noQtype (new-space))
!(bind! &g_noAlign (new-space))
!(bind! &g_noProject (new-space))
!(test (express-surplus (founder) &g_found) -3)                        ; founder (4 rules): -3 (inert R_complete -> deficit)
!(test (express-surplus (prune R_complete (founder)) &g_noComplete) 6) ; prune the INERT R_complete: +6 (fitter, the only viable genome)
!(test (express-surplus (prune R_qtype (founder)) &g_noQtype) 0)       ; load-bearing: collapses to 0
!(test (express-surplus (prune R_align (founder)) &g_noAlign) -2)      ; load-bearing: deficit
!(test (express-surplus (prune R_project (founder)) &g_noProject) -18) ; load-bearing: deep deficit

; SELECTION rediscovers pruning R_complete -> the evolved genome GNM_g1 (lineage -3 -> +6)
!(bind! &sel_a (new-space))
!(bind! &sel_b (new-space))
!(test (fitter (founder) (prune R_complete (founder)) &sel_a &sel_b) (R_qtype R_align R_project))

; --- recombination rescues two answer-incapable genomes (each missing a load-bearing rule) --
!(bind! &g_recomb (new-space))
!(test (express-answers (R_qtype R_align R_complete) &g_recomb) 0)     ; missing R_project -> 0 answers
!(bind! &g_defB (new-space))
!(test (express-answers (R_align R_complete R_project) &g_defB) 0)     ; missing R_qtype -> 0 answers
!(bind! &g_child (new-space))
!(test (express-answers (union-genome (R_qtype R_align R_complete) (R_align R_complete R_project)) &g_child) 6) ; recombined union -> viable
