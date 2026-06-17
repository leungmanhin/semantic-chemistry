; ===========================================================================
; CAUSAL-QA RULES — the causal-QA rule module: the 5 proposers + the priority-
; ordered run. Pure LOGIC (facts-free): it reads the domain mappings (intent-map /
; intent-allows / explanatory / edge-cluster) and the molecule/task IR from &self,
; which the experiment's loader provides (experiments/expt1-causal-qa/load.metta).
; Reuses the generic ENGINE in kernel_defs.metta (walk / fire / fuel / fire-once).
;
; A proposer yields `(cand KEY COST PRODS)` for each match; the engine's `walk`
; fuel-gates + fires them. IR-reads hit &self; product-reads hit the worker space
; $ws (cross-space join). This is the per-experiment "rule-set"; a different
; experiment (e.g. Aelmere) brings its OWN such module, reusing the same engine.
;
; Used via: import causal_qa_rules (brings the engine) + the experiment's load.metta.
; See kernel.metta (P0 demo) / workers.metta (P4) for callers.
; ===========================================================================
!(import! &self "petta/kernel_defs.metta")

; --- the 5 rule PROPOSERS: IR-reads from &self, product-reads from $ws ----------
; qt reads only IR -> no $ws; the others read prior products from $ws (cross-space join).
(= (qt-cands) (collapse (match &self (qa-question $t $q) (match &self (q-word $q $w) (match &self (intent-map $w $i) (cand $q ((gm 1)) ((q-intent $q $i))))))))
(= (al-cands $ws) (filter-out skip (collapse (match $ws (q-intent $q $i) (match &self (question-source $q $g) (match &self (question-focus $q $foc) (match &self (intent-allows $i $cls) (case (collapse (match &self (sem-edge $g $e $rel $src $foc) (match &self (edge-cluster $rel $cls) yes))) ((() skip) ($a (cand (al $q $cls) ((gm 1) (ci 1)) (cons-atom (alignment (al $q $cls) $q $cls) (collapse (match &self (sem-edge $g $e2 $rel2 $src2 $foc) (match &self (edge-cluster $rel2 $cls) (superpose ((alignment-cites (al $q $cls) $g $e2) (alignment-prov (al $q $cls) $g $src2))))))))))))))))))
(= (abstain-cands $ws) (filter-out skip (collapse (match $ws (q-intent $q $i) (match &self (question-source $q $g) (match &self (question-focus $q $foc) (case (collapse (match &self (sem-edge $g $e $rel $src $foc) (match &self (edge-cluster $rel $ec) (match &self (explanatory $ec) yes)))) ((() (cand (al $q abstain) ((gm 1)) ((alignment (al $q abstain) $q abstain)))) ($a skip)))))))))
(= (complete-cands $ws) (filter-out skip (collapse (match $ws (alignment-cites (al $q $cls) $g $e) (match &self (sem-edge $g $e $rel $cause $foc) (match &self (sem-edge $g $e2 $rel2 $cause $d) (case (collapse (match &self (edge-cluster $rel2 $x) yes)) ((() (cand (rf $q $cls $rel2 $d) ((gm 1)) ((role-fill (al $q $cls) $rel2 $d)))) ($a skip)))))))))
(= (project-cands $ws) (collapse (match $ws (alignment (al $q $cls) $q $cls) (if (== $cls abstain) (cand (a $q $cls) ((gm 1)) ((candidate-answer $q (a $q $cls)) (answer-by (a $q $cls) O_qa) (answer-abstain (a $q $cls)))) (cand (a $q $cls) ((gm 1)) ((candidate-answer $q (a $q $cls)) (answer-by (a $q $cls) O_qa) (answer-class (a $q $cls) $cls)))))))

; --- the run: walk each rule in priority order on $ws, threading the counter -----
; run-from lets an epoch start numbering at the current event count (no seq collision
; across re-runs); run = run-from 0 (the single-pass entry, unchanged for P0).
(= (run-from $ws $seq0) (let $s0 (walk $ws R_qtype (msort (qt-cands)) $seq0) (let $s1 (walk $ws R_align (msort (al-cands $ws)) $s0) (let $s2 (walk $ws R_abstain (msort (abstain-cands $ws)) $s1) (let $s3 (walk $ws R_complete (msort (complete-cands $ws)) $s2) (walk $ws R_project (msort (project-cands $ws)) $s3))))))
(= (run $ws) (run-from $ws 0))
