; ===========================================================================
; ACS — reusable P2 ACS logic: ablation, graph reachability, surplus, and the
; log-miner (derive the reaction graph from the event log + rule IR, then discover the
; ACS = the rules on a metabolic cycle). Assumes the engine (reaction)
; and evaluator (evaluator.metta) are loaded by the consumer.
; ===========================================================================

; --- ablation: run the genome on $ws skipping one rule; count answers (generous fuel,
;     so the effect is STRUCTURAL not starvation). `none` skips nothing (baseline). ---

(= (ablate-answers $skip $sp)
   (let* (($z0 (seed-assay $sp (organisms) 30))
          ($z3 (run-ablate $sp (cons-atom $skip ()))))
     (count-answers $sp)))

; add every edge in $es to the graph space $gsp
(= (add-edges $gsp $es)
   (case $es
         ((() done)
          ($ne (let* (($h (car-atom $es))
                      ($z (add-atom $gsp $h)))
                 (add-edges $gsp (cdr-atom $es)))))))

; --- reachability on a graph of (medge Src Dst) facts (visited set; terminates on cycles) ---
; the direct successors of $node
(= (succs $g $node)
   (collapse (match $g (medge $node $t) $t)))

; BFS: does any node in $frontier reach $goal? ($seen guards against cycles)
(= (any-reaches $g $frontier $goal $seen)
   (case $frontier
         ((() False)
          ($ne (let $h (car-atom $frontier)
                    (if (== $h $goal)
                        True
                        (if (in-list? $h $seen)
                            (any-reaches $g (cdr-atom $frontier) $goal $seen)
                            (any-reaches $g (concat-lists (succs $g $h) (cdr-atom $frontier)) $goal (cons-atom $h $seen)))))))))

; is $to reachable from $from? / does $node sit on a cycle?
(= (reaches? $g $from $to) (any-reaches $g (succs $g $from) $to ()))
(= (cycle-through $g $node) (any-reaches $g (succs $g $node) $node ()))

; --- surplus = evaluator income under clamp $cl - firing spend, on a run space; and a 3-way AND ---
(= (gm-surplus $ws $cl) (- (gm-income $ws $cl) (gm-spend $ws)))
(= (all3 $a $b $c) (if $a (if $b (if $c True False) False) False))

; ===========================================================================
; LOG-MINING: derive the reaction graph from the event log + the fired rules' canonical
; IR, then discover the ACS = the fired rules that reach fuel (gm). Generic over any
; genome; variable-head edge clauses are skipped (`varhead`) — they consume food.
; ===========================================================================

; the distinct rules that fired (from the event log)
(= (fired-rules)
   (dedup (collapse (match &self (event $s $r $k) $r))))

; the head symbol of a pattern (a leading (var …) is a wildcard head -> `varhead`)
(= (pat-head $pat)
   (let $h (car-atom $pat) (case $h (((var $n) varhead) ($s $s)))))

; the head symbol of an LHS clause ((at SPACE PAT) or bare PAT)
(= (clause-head $c) (case $c (((at $sp $pat) (pat-head $pat)) ($bare (pat-head $bare)))))
(= (map-clause-head $l) (if (== $l ()) () (cons-atom (clause-head (car-atom $l)) (map-clause-head (cdr-atom $l)))))
(= (map-pat-head $l) (if (== $l ()) () (cons-atom (pat-head (car-atom $l)) (map-pat-head (cdr-atom $l)))))

; the consumed (LHS) / produced (RHS) head symbols of rule $r
(= (lhs-heads $r) (map-clause-head (match &self (rule-lhs $r $cs) $cs)))
(= (rhs-heads $r) (map-pat-head (match &self (rule-rhs $r $ps) $ps)))

; does rule $r cost gm? (i.e. it eats fuel -> an edge gm -> r)
(= (gm-cost? $r)
   (case (collapse (match &self (rule-token-cost $r gm $n) yes)) ((() False) ($x True))))

; add the consumed-input edges (head -> r) for rule $r (skipping varhead wildcard clauses)
(= (add-in-edges $g $r $hs)
   (if (== $hs ())
       done
       (let* (($h (car-atom $hs))
              ($z (if (== $h varhead) done (add-atom $g (medge $h $r)))))
         (add-in-edges $g $r (cdr-atom $hs)))))

; add the produced-output edges (r -> head) for rule $r
(= (add-out-edges $g $r $ps)
   (if (== $ps ())
       done
       (let* (($p (car-atom $ps))
              ($z (add-atom $g (medge $r $p))))
         (add-out-edges $g $r (cdr-atom $ps)))))

; add all of rule $r's edges: gm->r if it costs gm, plus its in- and out-edges
(= (add-rule-edges $g $r)
   (let* (($z0 (if (gm-cost? $r) (add-atom $g (medge gm $r)) done))
          ($z1 (add-in-edges $g $r (lhs-heads $r))))
     (add-out-edges $g $r (rhs-heads $r))))

; build the whole reaction graph in space $g from the rules $rs
(= (build-graph $g $rs)
   (if (== $rs ())
       done
       (let $z (add-rule-edges $g (car-atom $rs)) (build-graph $g (cdr-atom $rs)))))

; the ACS = the fired rules on a metabolic cycle (those that reach gm)
(= (acs-members $g $rs)
   (case $rs
         ((() ())
          ($ne (let $r (car-atom $rs)
                    (if (reaches? $g $r gm)
                        (cons-atom $r (acs-members $g (cdr-atom $rs)))
                        (acs-members $g (cdr-atom $rs))))))))

; how many times rule $r fired / the total firings of a rule list
(= (rule-firings $r) (foldall + (match &self (event $s $r $k) 1) 0))
(= (sum-firings $rs) (case $rs ((() 0) ($ne (+ (rule-firings (car-atom $rs)) (sum-firings (cdr-atom $rs)))))))

; the ACS's total spend (firings of its members) and its surplus under clamp $cl
(= (acs-spend $g) (sum-firings (acs-members $g (fired-rules))))
(= (acs-surplus-of $g $cl) (- (gm-income &self $cl) (acs-spend $g)))

; ===========================================================================
; ACS-SCAN WORKER (worker-kind acs-scan) + the §2.9 verdict facts it emits. Assumes
; persist is loaded (persist-facts) — the verdicts follow the D11 worker-output pattern.
; ===========================================================================

; the (acs-member A R) fact for each rule in $rules
(= (member-facts $A $rules)
   (if (== $rules ())
       ()
       (cons-atom (acs-member $A (car-atom $rules)) (member-facts $A (cdr-atom $rules)))))

; the ACS verdict facts (schema §2.9) for ACS $A on reaction-graph $g under clamp $cl:
; one acs-member per cycle rule + metabolic closure + signed gm surplus (labelled by the
; clamp's rewarded class) + the promotion verdict
(= (acs-verdict-facts $A $g $cl)
   (let* (($cc (clamp-class-of $cl))
          ($members (acs-members $g (fired-rules)))
          ($surplus (acs-surplus-of $g $cl))
          ($promoted (> $surplus 0)))
     (concat-lists (member-facts $A $members)
       (cons-atom (acs-closure $A metabolic)
         (cons-atom (acs-surplus $A $cc gm $surplus)
           (cons-atom (acs-promoted $A $cc $promoted) ()))))))

; acs-scan worker body: mine the reaction graph from the event log into its own space
; (closed by the evaluator's candidate-answer -> E -> gm minting edge), compute the ACS
; verdict facts, assert them to &self, persist them (if declared), and summarise
(= (run-acs $w)
   (let* (($ws (match &self (worker-space $w $sp) $sp))
          ($A (match &self (worker-acs $w $a) $a))
          ($cl (match &self (worker-clamp $w $c) $c))
          ($z1 (build-graph $ws (fired-rules)))
          ($z2 (add-atom $ws (medge candidate-answer E)))
          ($z3 (add-atom $ws (medge E gm)))
          ($verdicts (acs-verdict-facts $A $ws $cl))
          ($z4 (add-all &self $verdicts))
          ($z5 (persist-facts $w $verdicts)))
     (add-atom &self (worker-summary $w acs $A))))
