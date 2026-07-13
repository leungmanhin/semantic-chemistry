; ===========================================================================
; ACS — P2 mortal-ACS detection (TECAN T3 / Alg 5.5 step 2 / MSC eq 18-19): mine the
; reaction graph from the event log + rule IR, discover the food-generated reflexively-
; autocatalytic loop A = (M_A, R_A), certify its §4.5 conditions, and emit the §2.9 verdicts —
; both M_A (the cycle's motif species) and R_A (the rules), plus closure + autocatalysis
; (structural), metabolic surplus + causal influence (the promotion gate), and RECURRENCE over
; the cycle-tagged event log (one epoch = a structural candidate); heritability is P3.
; Also hosts the acs-scan WORKER body (`run-as`) — the SAME certification run as a §6.4 worker
; kind, in isolated spaces (dispatched by `dispatch.metta`).
; ---------------------------------------------------------------------------
; The reaction graph is keyed on the graph-MOTIF — a rule's whole reactant/product PATTERN
; (a list of sem-edge clauses, jointly canonicalized so shared variables are kept), NOT a bare
; relation. Product-feeds-reactant is decided by UNIFICATION (a common instance), so a specific
; product meets a general premise (subsumption) and a single edge feeds a multi-edge premise
; ("products feed motifs that return to M_A within bounded steps"). Closure is
; METABOLIC: the soma rules alone are feed-forward, so the cycle closes only through the
; evaluator's minting edge (answer-relation → E → token → rule-that-costs-it). Membership +
; closure are clamp-INDEPENDENT (the graph uses every mintable token); the clamp-switch
; shows only in PROMOTION, via the componentwise metabolic surplus (eq 19) — a member's
; token whose income < spend fails condition 3 under that clamp. The food set is the
; parser's cues (a rule whose input relation is never rule-produced consumes food).
; Condition 4 (causal influence) is a REPLAY ablation: re-derive the chamber's answers in a
; caller-bound ISOLATED space with the ACS members suppressed; if the answer count drops
; below the baseline, the loop causally produces those answers. Assumes util + fuel +
; compiler + reaction + grounder + evaluator + worker loaded; the event log + derived layer
; of one chamber run supply the log + income (the log reads take the run space $ws — &self on
; a bare run, the worker's own space via `run-as`, which CONSUMES the log a prior context-
; chamber worker left there rather than re-deriving — MSC §6.4 P2 "scan event logs"); the
; worker envelope's `copy-molecules`/`restore-snapshot` set up the ablation replay space.
; ===========================================================================

; --- reachability on a (medge Src Dst) graph (visited set; terminates on cycles) ---

; the direct successors / predecessors of $node
(= (succs $g $node) (collapse (match $g (medge $node $t) $t)))
(= (preds $g $node) (collapse (match $g (medge $s $node) $s)))

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

; does $node sit on a cycle (reach itself)?
(= (cycle-through $g $node) (any-reaches $g (succs $g $node) $node ()))

; --- MOTIF extraction + matching: the reaction graph is keyed on the graph-MOTIF (§4.5 M_A),
; and a motif is a graph PATTERN — a LIST of sem-edge clauses `(Rel arg…)` with the graph +
; edge-id bookkeeping stripped and the (var …) slots renamed to positional `(mvar N)` (jointly
; across the whole motif, so shared variables — the links between clauses — are preserved, and
; recursively, so nested compound args canonicalize too). A rule's reactant motif is its whole
; LHS (G1), its product motif its whole RHS (G2); so a multi-edge premise like a causal chain
; is ONE composite motif, not decomposed. Whether a product feeds a reactant is decided by
; UNIFICATION (a common instance) — which handles a specific product meeting a more-general
; premise (subsumption) and nested compound arguments, up to variable renaming. ---

; the first-occurrence index of $x in $l (or its length if absent — the index it would take)
(= (idx-of $x $l) (idx-of-from $x $l 0))
(= (idx-of-from $x $l $i)
   (case $l ((() $i) ($ne (if (== (car-atom $l) $x) $i (idx-of-from $x (cdr-atom $l) (+ $i 1)))))))

; append $x to $l iff not already present (the ordered set of vars seen so far)
(= (append-if-new $x $l) (if (in-list? $x $l) $l (concat-lists $l (cons-atom $x ()))))

; --- CANONICALIZE: collect the (var …) slots jointly (first-occurrence order), then replace
; each with (mvar <its index>); both passes recurse into nested compound arguments ---
(= (collect-vars $t $acc)
   (case $t (((var $v) (append-if-new $t $acc))
            ($o (if (== (get-metatype $t) Expression) (collect-vars-list $t $acc) $acc)))))
(= (collect-vars-list $t $acc)
   (if (== $t ()) $acc (collect-vars-list (cdr-atom $t) (collect-vars (car-atom $t) $acc))))
(= (subst-vars $t $vars)
   (case $t (((var $v) (mvar (idx-of $t $vars)))
            ($o (if (== (get-metatype $t) Expression) (subst-vars-list $t $vars) $t)))))
(= (subst-vars-list $t $vars)
   (if (== $t ()) () (cons-atom (subst-vars (car-atom $t) $vars) (subst-vars-list (cdr-atom $t) $vars))))

; the raw (Rel arg…) of one clause (graph + id stripped); `(at SPACE PAT)` unwraps; a non-sem-
; edge clause (e.g. sem-edge-tv) or a (var …) wildcard relation names no motif → nomotif
(= (mk-raw $r $args) (if (== (get-metatype $r) Symbol) (cons-atom $r $args) nomotif))
(= (clause-head-args $c)
   (case $c
         (((at $sp $pat) (clause-head-args $pat))
          ((sem-edge $g $id $r $a) (mk-raw $r (cons-atom $a ())))
          ((sem-edge $g $id $r $a $b) (mk-raw $r (cons-atom $a (cons-atom $b ()))))
          ((sem-edge $g $id $r $a $b $d) (mk-raw $r (cons-atom $a (cons-atom $b (cons-atom $d ())))))
          ($other nomotif))))
(= (raw-clauses $clauses)
   (if (== $clauses ()) ()
       (let $m (clause-head-args (car-atom $clauses))
            (if (== $m nomotif) (raw-clauses (cdr-atom $clauses)) (cons-atom $m (raw-clauses (cdr-atom $clauses)))))))

; THE composite motif of a clause list: its sem-edge clauses, jointly canonicalized
(= (canon-motif $clauses) (let $raw (raw-clauses $clauses) (subst-vars-list $raw (collect-vars-list $raw ()))))

; the reactant motif (whole LHS / G1) and product motif (whole RHS / G2) of rule $r
(= (rule-reactant $r) (canon-motif (match &self (rule-lhs $r $cs) $cs)))
(= (rule-product $r) (canon-motif (match &self (rule-rhs $r $ps) $ps)))

; --- UNIFICATION: do two clause patterns have a common instance? Their (mvar N) slots are
; independent, so tag one side `(lv N)` and the other `(rv N)` before unifying over a binding
; environment (assoc list); recurses structurally, so nested compounds are handled. ---
(= (uvar? $t) (case $t (((lv $n) True) ((rv $n) True) ($o False))))
(= (tag-side $side $t)
   (case $t (((mvar $n) ($side $n)) ($o (if (== (get-metatype $t) Expression) (tag-list $side $t) $t)))))
(= (tag-list $side $t) (if (== $t ()) () (cons-atom (tag-side $side (car-atom $t)) (tag-list $side (cdr-atom $t)))))
(= (lookup $t $env)
   (case $env ((() notfound) ($ne (let ($k $v) (car-atom $env) (if (== $k $t) $v (lookup $t (cdr-atom $env))))))))
(= (u-walk $t $env) (if (uvar? $t) (let $r (lookup $t $env) (if (== $r notfound) $t (u-walk $r $env))) $t))
(= (occurs? $var $t $env)
   (let $w (u-walk $t $env) (if (== $w $var) True (if (== (get-metatype $w) Expression) (occurs-list? $var $w $env) False))))
(= (occurs-list? $var $t $env)
   (if (== $t ()) False (if (occurs? $var (car-atom $t) $env) True (occurs-list? $var (cdr-atom $t) $env))))
(= (bind $var $val $env) (if (occurs? $var $val $env) fail (cons-atom ($var $val) $env)))
(= (unify $a $b $env)
   (if (== $env fail) fail
       (let $wa (u-walk $a $env)
            (let $wb (u-walk $b $env)
                 (if (== $wa $wb) $env
                     (if (uvar? $wa) (bind $wa $wb $env)
                         (if (uvar? $wb) (bind $wb $wa $env)
                             (if (== (get-metatype $wa) Expression)
                                 (if (== (get-metatype $wb) Expression) (unify-lists $wa $wb $env) fail) fail))))))))
(= (unify-lists $a $b $env)
   (if (== $a ()) (if (== $b ()) $env fail)
       (if (== $b ()) fail (unify-lists (cdr-atom $a) (cdr-atom $b) (unify (car-atom $a) (car-atom $b) $env)))))
(= (clauses-unify? $p1 $p2) (if (== (unify (tag-side lv $p1) (tag-side rv $p2) ()) fail) False True))

; does product motif $P feed reactant motif $Q — supply (unify with) one of $Q's clauses?
(= (clause-unifies-any $p $Q) (if (== $Q ()) False (if (clauses-unify? $p (car-atom $Q)) True (clause-unifies-any $p (cdr-atom $Q)))))
(= (motif-feeds? $P $Q) (if (== $P ()) False (if (clause-unifies-any (car-atom $P) $Q) True (motif-feeds? (cdr-atom $P) $Q))))

; --- the fired rules + firing counts (from the cycle-tagged event log in run space $ws).
; fired-rules spans ALL cycles (structure / membership); rule-firings counts only the CURRENT
; cycle — eq-19 surplus is per-cycle, so on a multi-cycle log the spend must align with the
; current cycle's income (a no-op on a single-cycle log). ---
(= (fired-rules $ws) (dedup (collapse (match $ws (event $c $s $r $k) $r))))
(= (rule-firings $ws $r)
   (let $cyc (current-cycle $ws) (foldall + (match $ws (event $cyc $s $r $k) 1) 0)))

; --- the metabolic-closure ingredients (clamp-independent, for membership) ---

; every token some clamp can mint (the evaluator's minting alphabet)
(= (mintable-tokens) (dedup (collapse (match &self (clamp-mint $cl $a $tok $n) $tok))))

; the rules that cost token $tok (the token funds them)
(= (rules-costing $tok) (dedup (collapse (match &self (rule-token-cost $r $tok $n) $r))))

; is graph $g an answer-skeleton?
(= (answer-skel? $g) (case (collapse (match &self (sem-graph-kind $g answer-skeleton) yes)) ((() False) ($x True))))

; the canonical single clauses appearing in answer-skeletons (the motifs answers query); a
; product motif answers a query iff one of its clauses unifies one of these
(= (canon1 $semedge) (let $m (canon-motif ($semedge)) (if (== $m ()) skip (car-atom $m))))
(= (answer-clauses)
   (dedup (filter-out skip
     (concat-lists (collapse (match &self (sem-edge $g $c $r $a) (if (answer-skel? $g) (canon1 (sem-edge $g $c $r $a)) skip)))
       (concat-lists (collapse (match &self (sem-edge $g $c $r $a $b) (if (answer-skel? $g) (canon1 (sem-edge $g $c $r $a $b)) skip)))
                     (collapse (match &self (sem-edge $g $c $r $a $b $d) (if (answer-skel? $g) (canon1 (sem-edge $g $c $r $a $b $d)) skip))))))))

; --- build the reaction graph in space $g: reactant→rule→product, product-feeds-reactant, +
; the metabolic closure ---

; add each medge in list $es to $g
(= (add-edges $g $es)
   (case $es
         ((() done)
          ($ne (let* (($h (car-atom $es)) ($z (add-atom $g $h))) (add-edges $g (cdr-atom $es)))))))

; each rule's two edges: reactant-motif → rule (consumes G1), rule → product-motif (makes G2)
(= (rule-edges $r) (cons-atom (medge (rule-reactant $r) $r) (cons-atom (medge $r (rule-product $r)) ())))
(= (rules-edges $rs) (case $rs ((() ()) ($ne (concat-lists (rule-edges (car-atom $rs)) (rules-edges (cdr-atom $rs)))))))

; the distinct reactant / product motifs of a rule list (a set — many rules may share a motif)
(= (all-reactants $rs) (dedup (reactants-of $rs)))
(= (reactants-of $rs) (case $rs ((() ()) ($ne (cons-atom (rule-reactant (car-atom $rs)) (reactants-of (cdr-atom $rs)))))))
(= (all-products $rs) (dedup (products-of $rs)))
(= (products-of $rs) (case $rs ((() ()) ($ne (cons-atom (rule-product (car-atom $rs)) (products-of (cdr-atom $rs)))))))

; feeds edges: product motif P → reactant motif Q wherever P supplies (unifies) one of Q's
; clauses — this is the doc's "products feed motifs that return to M_A within bounded steps",
; so a single ReasonFor product feeds the two-edge chain premise
(= (feeds-from $P $reactants)
   (case $reactants
         ((() ())
          ($ne (let $Q (car-atom $reactants)
                    (if (motif-feeds? $P $Q)
                        (cons-atom (medge $P $Q) (feeds-from $P (cdr-atom $reactants)))
                        (feeds-from $P (cdr-atom $reactants))))))))
(= (feeds-edges $products $reactants)
   (case $products
         ((() ())
          ($ne (concat-lists (feeds-from (car-atom $products) $reactants) (feeds-edges (cdr-atom $products) $reactants))))))

; the metabolic-closure edges: answer-motif → E, E → token, token → funded rule (an answer-
; motif is a product motif that feeds an answer-skeleton clause)
(= (motif-E-edges $motifs) (if (== $motifs ()) () (cons-atom (medge (car-atom $motifs) E) (motif-E-edges (cdr-atom $motifs)))))
(= (E-tok-edges $toks) (if (== $toks ()) () (cons-atom (medge E (car-atom $toks)) (E-tok-edges (cdr-atom $toks)))))
(= (tok-fund-edges $tok $rs) (if (== $rs ()) () (cons-atom (medge $tok (car-atom $rs)) (tok-fund-edges $tok (cdr-atom $rs)))))
(= (toks-fund-edges $toks)
   (case $toks ((() ()) ($ne (concat-lists (tok-fund-edges (car-atom $toks) (rules-costing (car-atom $toks))) (toks-fund-edges (cdr-atom $toks)))))))
(= (queried-products $products)
   (case $products
         ((() ())
          ($ne (let $P (car-atom $products)
                    (if (motif-feeds? $P (answer-clauses))
                        (cons-atom $P (queried-products (cdr-atom $products)))
                        (queried-products (cdr-atom $products))))))))
(= (closure-edges $rs)
   (concat-lists (motif-E-edges (queried-products (all-products $rs)))
                 (concat-lists (E-tok-edges (mintable-tokens)) (toks-fund-edges (mintable-tokens)))))

; build the whole reaction graph (rule edges + feeds edges + metabolic closure) into $g
(= (build-graph $g $rs)
   (add-edges $g (concat-lists (rules-edges $rs)
                   (concat-lists (feeds-edges (all-products $rs) (all-reactants $rs)) (closure-edges $rs)))))

; --- MEMBERSHIP: the fired rules on a metabolic cycle (each reaches itself) ---
(= (acs-members $g $rs)
   (case $rs
         ((() ())
          ($ne (let $r (car-atom $rs)
                    (if (cycle-through $g $r)
                        (cons-atom $r (acs-members $g (cdr-atom $rs)))
                        (acs-members $g (cdr-atom $rs))))))))

; --- M_A (§4.5): the graph-motif SPECIES. A member rule's motif patterns are its candidate
; motifs; those on the metabolic cycle = M_A (the loop regenerates them). Food motifs
; (consumed but never produced, so off every cycle) are external and stay out. ---

; the distinct motifs the members consume or produce (candidate motif species): each member's
; reactant motif (its whole LHS) and product motif (its whole RHS)
(= (motifs-touched $members)
   (case $members
         ((() ())
          ($ne (concat-lists (cons-atom (rule-reactant (car-atom $members)) (cons-atom (rule-product (car-atom $members)) ()))
                             (motifs-touched (cdr-atom $members)))))))

; M_A: the motif species that lie on the metabolic cycle
(= (acs-motifs $g $members) (cycling-only $g (dedup (motifs-touched $members))))
(= (cycling-only $g $ms)
   (case $ms
         ((() ())
          ($ne (let $m (car-atom $ms)
                    (if (cycle-through $g $m)
                        (cons-atom $m (cycling-only $g (cdr-atom $ms)))
                        (cycling-only $g (cdr-atom $ms))))))))

; --- AUTOCATALYSIS (§4.5 cond 2): each member is enabled by a motif/token ON the cycle — a
; motif another member regenerates, or a token the ACS macro-atom mints. Holds for our
; cycle-based membership by construction, but computed independently (a real per-member check). ---
(= (any-cycling? $g $nodes)
   (case $nodes ((() False) ($ne (if (cycle-through $g (car-atom $nodes)) True (any-cycling? $g (cdr-atom $nodes)))))))
(= (member-autocat? $g $r) (any-cycling? $g (preds $g $r)))
(= (autocatalytic? $g $members)
   (if (== $members ()) False (all-autocat? $g $members)))
(= (all-autocat? $g $members)
   (case $members
         ((() True)
          ($ne (if (member-autocat? $g (car-atom $members)) (all-autocat? $g (cdr-atom $members)) False)))))

; --- per-token metabolic SURPLUS (eq 19): income under $cl − the members' token spend ---

; the per-firing $tok cost of rule $r (0 if it does not cost $tok)
(= (token-cost $r $tok)
   (case (collapse (match &self (rule-token-cost $r $tok $n) $n)) ((() 0) ($ns (car-atom $ns)))))

; $tok spent by rule $r over its firings (in run space $ws) / by a whole rule list
(= (rule-token-spend $ws $r $tok) (* (rule-firings $ws $r) (token-cost $r $tok)))
(= (members-spend $ws $rs $tok)
   (case $rs ((() 0) ($ne (+ (rule-token-spend $ws (car-atom $rs) $tok) (members-spend $ws (cdr-atom $rs) $tok))))))

; the signed surplus of the ACS members for token $tok under clamp $cl (eq 19); income is
; grounded against the run space $ws (where the derived layer lives)
(= (token-surplus $ws $members $cl $tok) (- (chamber-income $ws $cl $tok) (members-spend $ws $members $tok)))

; the distinct tokens the members cost (the components condition 3 checks)
(= (members-tokens $members)
   (dedup (filter-out skip (collapse (match &self (rule-token-cost $r $tok $n) (if (in-list? $r $members) $tok skip))))))

; is the surplus > 0 for EVERY token the members cost? (condition 3, componentwise)
(= (surplus-positive? $ws $members $cl $toks)
   (case $toks
         ((() True)
          ($ne (if (> (token-surplus $ws $members $cl (car-atom $toks)) 0)
                   (surplus-positive? $ws $members $cl (cdr-atom $toks))
                   False)))))

; --- causal influence (condition 4): a REPLAY ablation (the stronger form). Re-derive the
; chamber's answers in the isolated space $abl with the ACS members SUPPRESSED, restoring
; the snapshot fuel; if the count drops below the baseline (the certification run's
; total-answers in $ws), the loop causally PRODUCES those answers. An actual counterfactual
; re-run, not the structural "a member names an answer-queried relation" proxy. ---

; run the chamber in the isolated space $abl with the rules $skip suppressed (molecules +
; snapshot fuel materialized first), and return the resulting answer count
(= (ablated-answers $abl $ch $snap $skip)
   (let* (($z0 (copy-molecules $abl))
          ($z1 (restore-snapshot $abl $snap))
          ($z2 (run-chamber-ablate $abl $ch $skip)))
     (total-answers $abl)))

; does suppressing the members in $abl drop the answer count below the $ws baseline?
(= (causal-influence? $ws $abl $ch $snap $members)
   (> (total-answers $ws) (ablated-answers $abl $ch $snap $members)))

; --- the PROMOTION verdict: closure + autocatalysis hold structurally for a nonempty member
; set (both emitted as their own verdicts), it causally matters (cond 4, the replay ablation),
; and its surplus is positive componentwise (cond 3). Heritability (cond 5) is a P3 concern,
; not gated here. The clamp enters only via the surplus. ---
(= (and3 $a $b $c) (if $a (if $b (if $c True False) False) False))
(= (acs-promoted? $ws $abl $ch $snap $members $cl)
   (and3 (surplus-positive? $ws $members $cl (members-tokens $members))
         (causal-influence? $ws $abl $ch $snap $members)
         (if (== $members ()) False True)))

; --- RECURRENCE (§4.5 "sustains itself in an event log" / §6.4 P2 "recurrent" loops): a
; genuine ACS is not a one-off closed loop — it must RECUR across cycles. The loop recurs iff
; its members all fire in >= (recurrence-min) distinct cycles of $ws's cycle-tagged event log.
; ONE epoch is a single cycle, so a single-epoch scan reports a structural CANDIDATE; recurrence
; (+ heritability, cond 5) is the P3 / multi-epoch upgrade. ---

; the recurrence threshold (present in >= this many cycles = recurrent); config, default 2
(= (recurrence-min)
   (case (collapse (match &self (acs-recurrence-min $n) $n)) ((() 2) ($ns (car-atom $ns)))))

; the distinct cycle tags in $ws's event log
(= (log-cycles $ws) (dedup (collapse (match $ws (event $c $s $r $key) $c))))

; did rule $r fire in cycle $c of $ws's event log?
(= (fired-in-cycle? $ws $r $c)
   (case (collapse (match $ws (event $c $s $r $key) yes)) ((() False) ($x True))))

; did EVERY member fire in cycle $c (the loop closed that cycle)?
(= (loop-in-cycle? $ws $members $c)
   (case $members
         ((() True)
          ($ne (if (fired-in-cycle? $ws (car-atom $members) $c)
                   (loop-in-cycle? $ws (cdr-atom $members) $c)
                   False)))))

; the number of distinct cycles in which the whole loop is present
(= (recurrence-count $ws $members) (count-loop-cycles $ws $members (log-cycles $ws)))
(= (count-loop-cycles $ws $members $cycles)
   (case $cycles
         ((() 0)
          ($ne (+ (if (loop-in-cycle? $ws $members (car-atom $cycles)) 1 0)
                  (count-loop-cycles $ws $members (cdr-atom $cycles)))))))

; recurrent iff the loop is present in >= $min distinct cycles
(= (recurrent? $ws $members $min) (>= (recurrence-count $ws $members) $min))

; --- the §2.9 verdict facts for ACS $A on the (already-built) graph $g under clamp $cl ---
(= (member-facts $A $rules)
   (if (== $rules ()) () (cons-atom (acs-member $A (car-atom $rules)) (member-facts $A (cdr-atom $rules)))))

; one acs-motif per M_A species (the cycle's motif relations) — the R_A side is member-facts
(= (motif-facts $A $motifs)
   (if (== $motifs ()) () (cons-atom (acs-motif $A (car-atom $motifs)) (motif-facts $A (cdr-atom $motifs)))))

(= (surplus-facts $A $ws $members $cl $toks)
   (case $toks
         ((() ())
          ($ne (let $t (car-atom $toks)
                    (cons-atom (acs-surplus $A $cl $t (token-surplus $ws $members $cl $t))
                               (surplus-facts $A $ws $members $cl (cdr-atom $toks))))))))

; the full §2.9 verdict list = the ACS A = (M_A, R_A) + its conditions: one acs-member per
; cycle rule (R_A) + one acs-motif per motif species (M_A) + metabolic closure + autocatalysis
; (cond 1+2, structural) + one signed acs-surplus per costed token (cond 3) + the acs-promoted
; verdict under $cl (cond 3+4 — its condition 4 runs the replay ablation in the caller-bound
; space $abl, re-posing chamber $ch from snapshot $snap) + acs-recurrent (the loop recurs across
; $ws's cycle-tagged event log — False for a single epoch, the structural-candidate case)
(= (acs-verdicts $A $g $ws $abl $ch $snap $cl)
   (let* (($members (acs-members $g (fired-rules $ws)))
          ($toks (members-tokens $members)))
     (concat-lists (member-facts $A $members)
       (concat-lists (motif-facts $A (acs-motifs $g $members))
         (cons-atom (acs-closure $A metabolic)
           (cons-atom (acs-autocatalytic $A (autocatalytic? $g $members))
             (concat-lists (surplus-facts $A $ws $members $cl $toks)
                           (cons-atom (acs-promoted $A $cl (acs-promoted? $ws $abl $ch $snap $members $cl))
                                      (cons-atom (acs-recurrent $A (recurrent? $ws $members (recurrence-min))) ())))))))))

; --- the acs-scan WORKER body (worker-kind `acs-scan`): the whole certification as a §6.4
; worker. Its run space $ws is populated by a prior context-chamber worker; run-as CONSUMES
; that log (never re-deriving), builds the graph in its graph space, and condition 4 replays
; the ablation in its ablation space. The graph + ablation spaces are bound at top-level by
; the runner (a body cannot mint a `(new-space)`) and read from worker facts. Dispatched by
; `dispatch.metta`. ---

; add the ACS verdict facts (each keyed on the ACS name) to &self — the worker's output.
; add-all is set-union, so re-dispatch under the SAME clamp is idempotent; under a DIFFERENT
; clamp the new verdicts sit alongside (they are keyed on the clamp).
(= (emit-verdicts $verdicts) (add-all &self $verdicts))

; CONSUME the run space $ws a prior context-chamber worker populated (its log + derived layer +
; income; MSC §6.4 P2 "scan event logs") -> build the reaction graph in $g from that log ->
; certify under $cl (condition 4 replays the ablation in $abl from the snapshot) -> emit the
; §2.9 verdicts (the worker's output). It does NOT derive.
(= (run-as $w)
   (let* (($ws (match &self (worker-space $w $sp) $sp))
          ($g (match &self (worker-graph-space $w $gs) $gs))
          ($abl (match &self (worker-ablate-space $w $as) $as))
          ($ch (match &self (worker-chamber $w $c) $c))
          ($cl (match &self (worker-clamp $w $c2) $c2))
          ($snap (match &self (worker-snapshot $w $s) $s))
          ($A (match &self (worker-acs $w $a) $a))
          ($z3 (build-graph $g (fired-rules $ws))))
     (emit-verdicts (acs-verdicts $A $g $ws $abl $ch $snap $cl))))
