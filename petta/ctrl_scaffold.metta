; ===========================================================================
; CTRL-SCAFFOLD — building a control level around a rule chain the system found useful.
; ---------------------------------------------------------------------------
; A causal-QA chain like "normalize the cues, then chain the reasons" RECURS across arrivals and
; earns, but it is not an ACS: semantic content flows from question to answer and never
; reconstructs the question, so the chain is a food-fed feed-forward DAG with no closure. Ben's
; ACS notes locate the closure elsewhere — "a reusable inference-control pattern can recur across
; many questions of the same type" — i.e. at the CONTROL level. This module derives that control
; level from the chain's own track record, rather than having it written by hand.
;
; DETECTION IS NOT DONE HERE. The ACS scanner already reads the task-dated log and says
; everything needed; scaffolding is a second CONSUMER of that same scan, not a second scan. A
; candidate is worth wrapping exactly when the scanner's own per-condition verdicts say it
; RECURS across arrivals and does NOT close on its own — a conjunction, in keeping with there
; being deliberately no single "promoted" summary fact. Re-deriving recurrence here would put a
; second notion of "the recurring set" in the codebase for no gain.
; Nothing below names a relation, question type or corpus item, so the same scaffolding serves
; any domain. Assumes util + reaction + epoch + acs are loaded.
; ===========================================================================

; --- READING THE SCAN: which candidate is worth wrapping, and what is in it ---

; the members the scanner recorded for candidate $a (its R_A)
(= (acs-chain $a) (collapse (match &self (acs-member $a $r) $r)))

; did the scanner find $a recurrent across arrivals?
(= (verdict-recurrent? $a)
   (case (collapse (match &self (acs-recurrent $a True) yes)) ((() False) ($x True))))

; did it find $a structurally closed? (`acs-closure` is emitted ONLY when it is, so absence is
; the negative — the same way a subsidized candidate is read off elsewhere)
(= (verdict-closed? $a)
   (case (collapse (match &self (acs-closure $a $k) yes)) ((() False) ($x True))))

; SCAFFOLDABLE: it recurs, so wrapping it is justified by a track record; and it does not close,
; so there is something for a control level to supply. A closed candidate needs no wrapper, and
; a one-off derivation has not earned one.
(= (scaffoldable? $a)
   (if (verdict-recurrent? $a)
       (if (verdict-closed? $a) False True)
       False))

; --- WHERE THE CHAIN DELIVERS. A chain SUCCEEDS when a member whose own premise the chain feeds
; produces something a query asks for. A member fed only by food is doing a one-hop derivation,
; and its product is NOT evidence the chain worked. That distinction cannot be made at the motif
; level — in a causal-QA genome the one-hop and the chained product are the same motif — so it is
; made on the producing member instead, and the success trace then premises on that member's own
; RHS pattern, provenance id included, which only a completed chain can match.
; The members are a connected SET, not an ordered sequence (two rules may both feed a third), so
; "the end of the chain" is computed from dataflow rather than read off a position. It is
; deliberately NOT read off `rule-priority`, which would work today and break as soon as the
; hand-assigned ordering goes.

; the motifs the set produces that some answer-skeleton asks for (the query shape decides, not a
; named relation)
(= (chain-answer-motifs $rs) (queried-products (all-products $rs)))

; is $m's premise fed by some OTHER member of $rs? (its own self-loop does not make it dependent)
(= (chain-dependent? $m $rs) (any-feeds-into $m (filter-out $m $rs)))
(= (any-feeds-into $m $others)
   (case $others
         ((() False)
          ($ne (if (rule-feeds-rule? (car-atom $others) $m)
                   True
                   (any-feeds-into $m (cdr-atom $others)))))))

; does $m produce something a query asks for?
(= (answers? $m) (if (== (queried-products (cons-atom (rule-product $m) ())) ()) False True))

; the chain's DELIVERING members: chain-dependent AND answering
(= (chain-answering-members $rs) (keep-answering $rs $rs))
(= (keep-answering $todo $rs)
   (case $todo
         ((() ())
          ($ne (let $m (car-atom $todo)
                    (if (chain-dependent? $m $rs)
                        (if (answers? $m)
                            (cons-atom $m (keep-answering (cdr-atom $todo) $rs))
                            (keep-answering (cdr-atom $todo) $rs))
                        (keep-answering (cdr-atom $todo) $rs)))))))

; ===========================================================================
; THE GENERATOR — a PURE function from a scaffoldable candidate to the FACT LIST that wraps it.
; Purity is structural, not stylistic: `add-atom` does not evaluate its argument, so writing
; ~35 facts with constructed compound ids one at a time would silently store literal expressions.
; A pre-built list handed to a single `add-all` (step 3) evaluates at the call boundary instead.
; It also makes the wrapper inspectable and testable without mutating anything.
;
; What gets generated, following Ben's control-level loop — detect a question type, activate the
; strategy, derive, leave a success trace, and thereby make the strategy easier to activate next
; time — is a ring the chain cannot form on its own:
;     Primed -> (the chain's own work) -> Worked -> Habit -> Primed
; The chain's members are copied with an activation premise added; their RHS is untouched, so
; product ids and the evaluator's depth-based typing are unaffected. All generated names are
; FUNCTIONS of the candidate's name, so no gensym and replay-equivalence holds.
; ===========================================================================

; --- config knobs (data, per domain) ---
; what one generated control rule costs to fire, and what the offspring's genome costs to
; express. Both are read, never defaulted: a silently free rule or a free soma is the failure
; mode we removed from expression, and it would come straight back here.
(= (scaffold-rule-cost) (collapse (match &self (scaffold-rule-cost $t $n) ($t $n))))
(= (scaffold-dequote-cost) (collapse (match &self (scaffold-dequote-cost $t $n) ($t $n))))

; --- small builders ---

; the sem-edge clauses of a clause list (a rule's RHS also carries TV clauses, which a premise
; has no use for)
(= (sem-edge-clause? $c)
   (case $c (((sem-edge $g $i $r $a) True)
             ((sem-edge $g $i $r $a $b) True)
             ((sem-edge $g $i $r $a $b $d) True)
             ($o False))))
(= (sem-edge-clauses $cs)
   (case $cs
         ((() ())
          ($ne (let $c (car-atom $cs)
                    (if (sem-edge-clause? $c)
                        (cons-atom $c (sem-edge-clauses (cdr-atom $cs)))
                        (sem-edge-clauses (cdr-atom $cs))))))))

; one (rule-token-cost R tok n) per component
(= (cost-facts $r $cost)
   (case $cost
         ((() ())
          ($ne (let ($t $n) (car-atom $cost)
                    (cons-atom (rule-token-cost $r $t $n) (cost-facts $r (cdr-atom $cost))))))))

; the facts that declare ONE rule: context, priority, premise, products, costs
(= (rule-facts $r $ctx $pri $cost $lhs $rhs)
   (concat-lists (cons-atom (rule-context $r $ctx)
                   (cons-atom (rule-priority $r $pri)
                     (cons-atom (rule-lhs $r $lhs) (cons-atom (rule-rhs $r $rhs) ()))))
                 (cost-facts $r $cost)))

; --- the gated copies: each member, with an activation premise prepended ---
(= (gated-facts $rs $s $cg $ctx $i)
   (case $rs
         ((() ())
          ($ne (let* (($m (car-atom $rs))
                      ($lhs (cons-atom (sem-edge $cg (var p) Primed $s) (match &self (rule-lhs $m $l1) $l1)))
                      ($rhs (match &self (rule-rhs $m $l2) $l2)))
                 (concat-lists (rule-facts (gated $m $s) $ctx $i (cost-of $m) $lhs $rhs)
                               (gated-facts (cdr-atom $rs) $s $cg $ctx (+ $i 1))))))))

; --- the success trace: one per delivering member, premised on THAT member's own product
; pattern (id template included), so a one-hop derivation by a food-fed member cannot claim it ---
(= (worked-facts $ans $s $cg $ctx $cost $i)
   (case $ans
         ((() ())
          ($ne (let* (($m (car-atom $ans))
                      ($lhs (sem-edge-clauses (match &self (rule-rhs $m $l3) $l3))))
                 (concat-lists (rule-facts (worked $m $s) $ctx $i $cost $lhs
                                           (cons-atom (sem-edge $cg (wk $s) Worked $s) ()))
                               (worked-facts (cdr-atom $ans) $s $cg $ctx $cost (+ $i 1))))))))

; --- the ids of every generated rule, in the order they are declared ---
(= (gated-ids $rs $s) (if (== $rs ()) () (cons-atom (gated (car-atom $rs) $s) (gated-ids (cdr-atom $rs) $s))))
(= (worked-ids $ans $s) (if (== $ans ()) () (cons-atom (worked (car-atom $ans) $s) (worked-ids (cdr-atom $ans) $s))))
(= (generated-rule-ids $chain $ans $s)
   (concat-lists (cons-atom (prime $s) (cons-atom (recall $s) (cons-atom (learn $s) ())))
                 (concat-lists (gated-ids $chain $s) (worked-ids $ans $s))))

; --- the offspring: an organism owning the wrapper, with its own genome and dequote price ---
(= (member-facts-of $rs $ids)
   (if (== $ids ()) () (cons-atom (ruleset-member $rs (car-atom $ids)) (member-facts-of $rs (cdr-atom $ids)))))
(= (chamber-of-context $ctx)
   (case (collapse (match &self (chamber-context $ch $ctx) $ch)) ((() none) ($cs (car-atom $cs)))))
(= (organism-facts $s $ctx $ids)
   (concat-lists (cons-atom (organism (org $s))
                   (cons-atom (organism-chamber (org $s) (chamber-of-context $ctx))
                     (cons-atom (genome-of (org $s) (gnm $s))
                       (cons-atom (quoted-ruleset (gnm $s) (rs $s)) ()))))
                 (concat-lists (cost-facts-genome (gnm $s) (scaffold-dequote-cost))
                               (member-facts-of (rs $s) $ids))))
(= (cost-facts-genome $gnm $cost)
   (case $cost
         ((() ())
          ($ne (let ($t $n) (car-atom $cost)
                    (cons-atom (genome-token-cost $gnm $t $n) (cost-facts-genome $gnm (cdr-atom $cost))))))))

; --- the strategy handle + the control vocabulary the wrapper introduces. The relation names are
; the SCAFFOLD's own (domain-independent); each state is keyed by the strategy handle, so two
; strategies never collide. Declaring them `control-relation` is what lets the closure classifier
; read the resulting closure as control/hybrid rather than substrate. ---
(= (strategy-facts $a $s $cg $cue $ctx)
   (cons-atom (strategy $s)
     (cons-atom (strategy-chain $s $a)
       (cons-atom (strategy-cue $s $cue)
         (cons-atom (strategy-context $s $ctx)
           (cons-atom (sem-graph $cg)
             (cons-atom (sem-graph-kind $cg control)
               (cons-atom (control-relation Primed)
                 (cons-atom (control-relation Worked)
                   (cons-atom (control-relation Habit) ()))))))))))

; --- THE GENERATOR. Returns () when a cost knob is undeclared or the chain delivers nothing:
; a wrapper whose rules fire free, or one with no success to trace, is not worth minting.
(= (scaffold-facts $a $chain $cue $ctx)
   (let* (($s (strat $a))
          ($cg (ctrlg $s))
          ($cost (scaffold-rule-cost))
          ($ans (chain-answering-members $chain))
          ($n (len $chain)))
     (if (== $cost ())
         ()
         (if (== $ans ())
             ()
             (concat-lists (strategy-facts $a $s $cg $cue $ctx)
               (concat-lists (organism-facts $s $ctx (generated-rule-ids $chain $ans $s))
                 (concat-lists (rule-facts (prime $s) $ctx 0 $cost
                                           (cons-atom (sem-edge $cg (var h) Habit $s) ())
                                           (cons-atom (sem-edge $cg (pr $s) Primed $s) ()))
                   (concat-lists (rule-facts (recall $s) $ctx 1 $cost
                                             (cons-atom (sem-edge (var g) (var e) $cue (var q)) ())
                                             (cons-atom (sem-edge $cg (rc $s) Primed $s) ()))
                     (concat-lists (gated-facts $chain $s $cg $ctx 2)
                       (concat-lists (worked-facts $ans $s $cg $ctx $cost (+ $n 2))
                                     (rule-facts (learn $s) $ctx (+ $n 3) $cost
                                                 (cons-atom (sem-edge $cg (var w) Worked $s) ())
                                                 (cons-atom (sem-edge $cg (hb $s) Habit $s) ()))))))))))))

; ===========================================================================
; REPRODUCTION — who pays, and what the offspring starts with.
; ---------------------------------------------------------------------------
; The wrapper is not an edit to anyone's genome: the chain's members belong to DIFFERENT
; organisms (in Exp-1 two of them), so there is no single genome to extend. §4.5's heritability
; condition names the operation instead — a genome can be "copied, mutated, RECOMBINED, and
; re-expressed" — so the wrapper is the recombinant OFFSPRING of the organisms that contributed
; the chain, and eq 20 puts the bill on them: `crep` is "copying and mutating the genome plus
; endowing offspring".
; Costs are declared PER CONTRIBUTED MEMBER, which makes the split exactly proportional with no
; fractional tokens: a parent that gave two rules pays twice what one that gave one pays, and
; endows twice as much. The consequence is the point of doing it this way — a parent too poor to
; endow CANNOT reproduce, so consolidation is something only a solvent organism can afford, and
; mortality gates learning.
; ===========================================================================

(= (scaffold-mutate-cost) (collapse (match &self (scaffold-mutate-cost $t $n) ($t $n))))
(= (scaffold-endowment) (collapse (match &self (scaffold-endowment $t $n) ($t $n))))

; --- cost-vector arithmetic ---
(= (tokens-of $c) (if (== $c ()) () (let ($t $n) (car-atom $c) (cons-atom $t (tokens-of (cdr-atom $c))))))
(= (cost-of-token $t $c)
   (case $c ((() 0) ($ne (let ($t2 $n) (car-atom $c) (if (== $t2 $t) $n (cost-of-token $t (cdr-atom $c))))))))
(= (scale-cost $c $k)
   (case $c ((() ()) ($ne (let ($t $n) (car-atom $c) (cons-atom ($t (* $n $k)) (scale-cost (cdr-atom $c) $k)))))))
(= (cost-plus $a $b) (sum-tokens $a $b (dedup (concat-lists (tokens-of $a) (tokens-of $b)))))
(= (sum-tokens $a $b $ts)
   (if (== $ts ()) ()
       (let $t (car-atom $ts)
            (cons-atom ($t (+ (cost-of-token $t $a) (cost-of-token $t $b)))
                       (sum-tokens $a $b (cdr-atom $ts))))))

; --- the parents and what each owes ---

; the organisms whose genomes contributed the chain's members
(= (chain-parents $chain) (dedup (owners-of $chain)))
(= (owners-of $rs) (if (== $rs ()) () (cons-atom (rule-organism (car-atom $rs)) (owners-of (cdr-atom $rs)))))

; how many of the chain's members $o contributed
(= (contribution $o $rs)
   (case $rs ((() 0) ($ne (+ (if (== (rule-organism (car-atom $rs)) $o) 1 0) (contribution $o (cdr-atom $rs)))))))

; what $o owes: (mutate + endowment) once per member it contributed
(= (parent-due $o $chain)
   (scale-cost (cost-plus (scaffold-mutate-cost) (scaffold-endowment)) (contribution $o $chain)))

; can EVERY parent pay its share? All-or-nothing: a half-built wrapper is worse than none, and a
; parent that cannot endow has no business reproducing
(= (parents-can-pay? $ws $parents $chain)
   (case $parents
         ((() True)
          ($ne (let $o (car-atom $parents)
                    (if (afford? $ws $o (parent-due $o $chain))
                        (parents-can-pay? $ws (cdr-atom $parents) $chain)
                        False))))))

; credit a whole cost vector to $o's purse
(= (credit-all $ws $o $c)
   (case $c
         ((() done)
          ($ne (let* ((($t $n) (car-atom $c))
                      ($z (credit $ws $o $t $n)))
                 (credit-all $ws $o (cdr-atom $c)))))))

; debit each parent and move its share of the endowment into the offspring's purse
(= (charge-parents $ws $parents $chain $o2)
   (case $parents
         ((() done)
          ($ne (let* (($o (car-atom $parents))
                      ($k (contribution $o $chain))
                      ($z1 (debit-all $ws $o (parent-due $o $chain)))
                      ($z2 (credit-all $ws $o2 (scale-cost (scaffold-endowment) $k))))
                 (charge-parents $ws (cdr-atom $parents) $chain $o2))))))

; ===========================================================================
; THE ctrl-scaffold WORKER BODY (worker-kind `ctrl-scaffold`). It performs the operation; the
; ORGANISMS hold and spend the fuel — the same separation the evaluator worker has, where the
; worker mints but the purses belong to somas. Genome facts go to &self (read-only shared IR);
; the debits and the endowment are per-space state.
; Returns a status: `scaffolded` | `not-scaffoldable` | `no-wrapper` | `unaffordable`.
; ===========================================================================

; the domain's declared routing cue — which arriving relation marks a task (data, per domain)
(= (task-cue)
   (case (collapse (match &self (task-cue-relation $r) $r)) ((() none) ($rs (car-atom $rs)))))

; the context a chamber runs in
(= (chamber-ctx $ch)
   (case (collapse (match &self (chamber-context $ch $c) $c)) ((() none) ($cs (car-atom $cs)))))

(= (run-cs $w)
   (let* (($ws (match &self (worker-space $w $sp) $sp))
          ($a (match &self (worker-acs $w $x) $x))
          ($ch (match &self (worker-chamber $w $c) $c))
          ($chain (acs-chain $a))
          ($facts (scaffold-facts $a $chain (task-cue) (chamber-ctx $ch))))
     (if (scaffoldable? $a)
         (if (== $facts ())
             no-wrapper
             (if (parents-can-pay? $ws (chain-parents $chain) $chain)
                 (let* (($z1 (charge-parents $ws (chain-parents $chain) $chain (org (strat $a))))
                        ($z2 (add-all &self $facts))
                        ($z3 (add-atom &self (scaffold-of $a (strat $a)))))
                   scaffolded)
                 unaffordable))
         not-scaffoldable)))
