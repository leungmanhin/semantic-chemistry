; ===========================================================================
; SELECTION — reusable P3 lineage operators: EXPRESS a genome (run only its member
; rules, `run-ablate` skipping the non-members), mutation (prune / recombine), and
; surplus-based selection (`fitter`). Facts-free; assumes the engine (reaction) +
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

; ===========================================================================
; REPRODUCTION WORKER (worker-kind reproduction) + the §2.10 lineage verdict facts.
; Assumes persist is loaded (persist-facts). One lineage step: parent -> prune -> child.
; ===========================================================================

; the §2.10 lineage verdict facts for one prune step: lineage + founder, parent & child
; genome-fitness (signed surplus under clamp-class $cc), the birth, and the signed improvement
(= (lineage-verdict-facts $lin $pid $cid $prune-rule $cc $pfit $cfit)
   (let $imp (- $cfit $pfit)
     (cons-atom (lineage $lin)
       (cons-atom (lineage-founder $lin $pid)
         (cons-atom (genome-fitness $pid $cc gm $pfit)
           (cons-atom (genome-fitness $cid $cc gm $cfit)
             (cons-atom (birth $cid $pid (pruned $prune-rule))
               (cons-atom (lineage-improvement $pid $cid gm $imp) ()))))))))

; reproduction worker body: express the parent genome (the full loaded ruleset) and its
; pruned child, each in its own space, score both by surplus, assert the §2.10 lineage
; verdict facts to &self, persist them (if declared), and summarise
(= (run-select $w)
   (let* ((($lin $pid $cid) (match &self (worker-lineage $w $l $p $ch) ($l $p $ch)))
          ($prune-rule (match &self (worker-mutation $w $m) $m))
          ($cl (match &self (worker-clamp $w $c) $c))
          ($cc (match &self (clamp-class $cl $x) $x))
          ($ps (match &self (worker-space-parent $w $sp) $sp))
          ($cs (match &self (worker-space-child $w $sc) $sc))
          ($parent (all-rules))
          ($child (prune $prune-rule $parent))
          ($pfit (express-surplus $parent $ps))
          ($cfit (express-surplus $child $cs))
          ($verdicts (lineage-verdict-facts $lin $pid $cid $prune-rule $cc $pfit $cfit))
          ($z1 (add-all &self $verdicts))
          ($z2 (persist-facts $w $verdicts)))
     (add-atom &self (worker-summary $w lineage $lin))))
