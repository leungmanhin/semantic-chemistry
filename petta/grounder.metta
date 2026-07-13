; ===========================================================================
; GROUNDER — grounds an answer-skeleton sem-graph against the molecule sem-graphs:
; the query-solving step of the pipeline (a MeTTa-match stand-in for a PLN
; backward-chainer query). The skeleton's conjunct sem-edges become joinable clause
; patterns — their (var …) markers co-refer by name, and each conjunct's matched
; molecule edge is exposed as a (var <conjunct-id>) binding — joined by the
; compiler's clause-join. A solution = the fully-grounded conjunct list: every
; element is a cited molecule sem-edge, so provenance is built in.
; The first clause pins (var g) to a neo-davidsonian graph, which keeps the join
; off the skeleton's own facts; (var g) otherwise ranges over ALL molecule graphs —
; question↔graph scoping is not modeled here. Assumes util + compiler are loaded.
; ===========================================================================

; the skeleton's conjunct patterns as joinable clauses, per relation arity
; (unary / binary / ternary); the matched molecule edge-id surfaces as (var <cid>)
(= (skel-clauses-1 $gas)
   (collapse (match &self (sem-edge $gas $c $r $a) (sem-edge (var g) (var $c) $r $a))))

(= (skel-clauses-2 $gas)
   (collapse (match &self (sem-edge $gas $c $r $a $b) (sem-edge (var g) (var $c) $r $a $b))))

(= (skel-clauses-3 $gas)
   (collapse (match &self (sem-edge $gas $c $r $a $b $d) (sem-edge (var g) (var $c) $r $a $b $d))))

; all clauses: pin (var g) to a molecule graph first, then join the conjuncts
(= (skel-clauses $gas)
   (cons-atom (sem-graph-kind (var g) neo-davidsonian)
              (concat-lists (skel-clauses-1 $gas)
                            (concat-lists (skel-clauses-2 $gas) (skel-clauses-3 $gas)))))

; ground answer-skeleton $gas against run space $ws (the hot pool holding the molecules +
; derived edges): one solution per complete join — the solution IS the grounded conjunct
; list (each element a cited molecule sem-edge). The skeleton STRUCTURE is read from &self
; (read-only IR, via skel-clauses); only the join hits $ws.
(= (ground-skeleton $ws $gas)
   (let (both $clauses $out) (to-vars (both (skel-clauses $gas) (skel-clauses $gas)))
        (clause-join $ws $clauses $out)))

; --- ANSWER COUNT: the system's OUTPUT in space $ws = total groundings summed over every
; question's answer-skeletons. The epoch loop reads it as the per-cycle fitness proxy; the
; ACS replay-ablation reads it as the baseline / ablated answer count. The skeleton STRUCTURE
; + the question index live in &self; only the join hits $ws.

; # groundings of one answer-skeleton $gas against $ws
(= (skeleton-answers $ws $gas) (len (collapse (ground-skeleton $ws $gas))))

; # groundings summed over all of question $q's answer-skeletons
(= (question-answers $ws $q)
   (foldall + (match &self (answer-skeleton $q $gas) (skeleton-answers $ws $gas)) 0))

; # groundings summed over every question (the system's total output this run)
(= (total-answers $ws)
   (foldall + (match &self (qa-question $v $q) (question-answers $ws $q)) 0))
