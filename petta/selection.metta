; ===========================================================================
; P4.3 (iii) — selection-epoch WORKER: the P3 lineage port (TECAN T6).
; ---------------------------------------------------------------------------
; The last P4.3 worker kind. EXPRESS a genome = run the kernel with only its
; soma rules active (run-ablate skipping the non-members); abstain is the
; evaluator.s job now, in the genome's OWN space (generous fuel, so
; fitness is structural). FITNESS = metabolic surplus (income - spend). The P3
; lineage (9 tests):
;  * founder {qtype,align,complete,project} surplus +5; pruning the INERT
;    R_complete -> +6 (the unique fitter) => selection rediscovers the dead-weight
;    rule and the lineage steps GNM_qa(+5) -> GNM_g1(+6). Pruning any load-bearing
;    rule collapses surplus (R_qtype 0, R_align -2, R_project -10).
;  * recombination of two answer-incapable genomes (one missing R_project, one
;    missing R_qtype) -> the union genome is viable again (6 answers).
; Per-genome expression in isolated spaces is exactly what the worker isolation
; (D6) + run-ablate (acs_scan) enable.
;
; Run:  sh ../PeTTa/run.sh petta/selection.metta < /dev/null \
;          2>&1 | grep should   # nine ✅
; ===========================================================================
!(import! &self "petta/kernel_defs.metta")
!(import! &self "experiments/expt1-causal-qa/molecules.metta")
!(import! &self "experiments/expt1-causal-qa/tasks.metta")
!(import! &self "experiments/expt1-causal-qa/configs.metta")
!(import! &self "experiments/expt1-causal-qa/rules.metta")
!(import! &self "petta/evaluator_defs.metta")  ; covered/anssize/skelsize/would-mint/gm-income/gm-spend/count-answers

; --- genome = list of soma rules present; EXPRESS it = run the kernel with only
;     those rules active (R_abstain is the always-on alignment fallback). This is
;     run-ablate generalized: gate each soma rule by membership. ------------------
(= (member-of $x $l) (case $l ((() False) ($ne (if (== (car-atom $l) $x) True (member-of $x (cdr-atom $l)))))))
(= (all-rules) (R_qtype R_align R_complete R_project))
(= (non-members $rules $g) (case $rules ((() ()) ($ne (let $r (car-atom $rules) (if (member-of $r $g) (non-members (cdr-atom $rules) $g) (cons-atom $r (non-members (cdr-atom $rules) $g))))))))
; EXPRESS a genome = run-ablate skipping the non-member rules (= run ONLY the members).
; abstain is the evaluator's job now (abstain-income), not an always-on soma rule.
(= (run-genome $ws $g) (run-ablate $ws (non-members (all-rules) $g)))

; --- mutation operators on the genome (lists) — mirror evolve.metta -------------
(= (prune $r $l) (case $l ((() ()) ($ne (let $h (car-atom $l) (if (== $h $r) (prune $r (cdr-atom $l)) (cons-atom $h (prune $r (cdr-atom $l)))))))))
(= (union-genome $a $b) (case $b ((() $a) ($ne (let $h (car-atom $b) (if (member-of $h $a) (union-genome $a (cdr-atom $b)) (union-genome (cons-atom $h $a) (cdr-atom $b))))))))
(= (founder) (R_qtype R_align R_complete R_project))

; (eq-17 Match scoring — covered/anssize/skelsize/would-mint/gm-income/gm-spend/count-answers
;  — comes from evaluator_defs.metta, imported above. surplus = income - spend.)

; express a genome in its OWN space (generous fuel -> structural), return surplus
(= (express-surplus $g $sp) (let $z1 (add-atom $sp (fuel gm 40)) (let $z2 (add-atom $sp (fuel ci 40)) (let $z3 (run-genome $sp $g) (- (gm-income $sp physical-cause) (gm-spend $sp))))))
(= (express-answers $g $sp) (let $z1 (add-atom $sp (fuel gm 40)) (let $z2 (add-atom $sp (fuel ci 40)) (let $z3 (run-genome $sp $g) (count-answers $sp)))))
; SELECTION: pick the higher-surplus of two genomes (each expressed in its own space)
(= (fitter $ga $gb $sa $sb) (if (> (express-surplus $gb $sb) (express-surplus $ga $sa)) $gb $ga))

; --- fitness landscape: founder vs each single-rule prune (own spaces) ----------
!(bind! &g_found (new-space))
!(bind! &g_noComplete (new-space))
!(bind! &g_noQtype (new-space))
!(bind! &g_noAlign (new-space))
!(bind! &g_noProject (new-space))
; fitness landscape: surplus of the founder vs each single-rule prune
!(test (express-surplus (founder) &g_found) 5)                         ; founder (4 rules): +4
!(test (express-surplus (prune R_complete (founder)) &g_noComplete) 6) ; prune the INERT R_complete: +5 (fitter!)
!(test (express-surplus (prune R_qtype (founder)) &g_noQtype) 0)       ; load-bearing: collapses to 0
!(test (express-surplus (prune R_align (founder)) &g_noAlign) -2)      ; load-bearing: deficit
!(test (express-surplus (prune R_project (founder)) &g_noProject) -10) ; load-bearing: deep deficit

; SELECTION rediscovers pruning R_complete -> the evolved genome GNM_g1 (lineage +4 -> +5)
!(bind! &sel_a (new-space))
!(bind! &sel_b (new-space))
!(test (fitter (founder) (prune R_complete (founder)) &sel_a &sel_b) (R_qtype R_align R_project))

; --- recombination rescues two defective (single-answer-incapable) genomes ------
!(bind! &g_recomb (new-space))
; recombination rescues two answer-incapable genomes (each missing a load-bearing rule)
!(test (express-answers (R_qtype R_align R_complete) &g_recomb) 0)     ; missing R_project -> 0 answers
!(bind! &g_defB (new-space))
!(test (express-answers (R_align R_complete R_project) &g_defB) 0)     ; missing R_qtype -> 0 answers
!(bind! &g_child (new-space))
!(test (express-answers (union-genome (R_qtype R_align R_complete) (R_align R_complete R_project)) &g_child) 6) ; recombined union -> viable
