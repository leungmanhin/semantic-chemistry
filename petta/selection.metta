; ===========================================================================
; SELECTION — reusable P3 lineage operators: EXPRESS a genome (run only its member
; rules, `run-ablate` skipping the non-members), mutation (prune / recombine), and
; surplus-based selection (`fitter`). Facts-free; assumes the engine (kernel.metta) +
; evaluator (evaluator.metta) are loaded by the consumer. Exercised by
; tests/selection_test.metta.
; ===========================================================================

; all rules in the loaded genome (generic: every rule with a rule-lhs)
(= (all-rules) (collapse (match &self (rule-lhs $R $lhs) $R)))

; the rules in $rules NOT in genome $g (what run-ablate must skip to express $g)
(= (non-members $rules $g)
   (case $rules
         ((() ())
          ($ne (let $r (car-atom $rules)
                    (if (in-list? $r $g)
                        (non-members (cdr-atom $rules) $g)
                        (cons-atom $r (non-members (cdr-atom $rules) $g))))))))

; EXPRESS a genome = run ONLY its members (run-ablate skipping the non-members)
(= (run-genome $ws $g) (run-ablate $ws (non-members (all-rules) $g)))

; mutation: drop rule $r from genome list $l
(= (prune $r $l)
   (case $l
         ((() ())
          ($ne (let $h (car-atom $l)
                    (if (== $h $r)
                        (prune $r (cdr-atom $l))
                        (cons-atom $h (prune $r (cdr-atom $l)))))))))

; recombination: the union of two genome lists (append $b's non-members onto $a)
(= (union-genome $a $b)
   (case $b
         ((() $a)
          ($ne (let $h (car-atom $b)
                    (if (in-list? $h $a)
                        (union-genome $a (cdr-atom $b))
                        (union-genome (cons-atom $h $a) (cdr-atom $b))))))))

; express a genome in its OWN space (generous fuel -> structural fitness), return surplus / answers
; (seed the organism's typed purse; single-organism Exp-1: the-organism = O_qa)
(= (express-surplus $g $sp)
   (let* (($O (the-organism))
          ($z1 (add-atom $sp (fuel $O gm 40)))
          ($z2 (add-atom $sp (fuel $O ci 40)))
          ($z3 (run-genome $sp $g)))
     (- (gm-income $sp physical-cause) (gm-spend $sp))))

(= (express-answers $g $sp)
   (let* (($O (the-organism))
          ($z1 (add-atom $sp (fuel $O gm 40)))
          ($z2 (add-atom $sp (fuel $O ci 40)))
          ($z3 (run-genome $sp $g)))
     (count-answers $sp)))

; SELECTION: the higher-surplus of two genomes (each expressed in its own space)
(= (fitter $ga $gb $sa $sb) (if (> (express-surplus $gb $sb) (express-surplus $ga $sa)) $gb $ga))
