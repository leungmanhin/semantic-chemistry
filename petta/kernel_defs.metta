; ===========================================================================
; KERNEL DEFS — the generic mortal-kernel ENGINE, facts-free, $ws-parameterized.
; ---------------------------------------------------------------------------
; The reusable firing mechanism, with NO domain logic and NO facts: a typed-fuel
; ledger, componentwise affordability, gated fire (+ event log), fire-once-ever,
; and the per-rule `walk`. The causal-QA rule PROPOSERS live in causal_qa_rules.metta;
; the experiment's DATA lives in experiments/<expt>/load.metta. A different
; experiment reuses THIS engine and brings its own rule module + data.
;
; The engine is parameterized by a WORKER SPACE $ws (separate-space-per-worker
; isolation, chosen on the spaces_behavior.metta battle-test / design-decisions D6):
;   * read-only IR + domain mappings live in &self (loaded by the experiment loader);
;   * mutable per-worker state (fuel, products, events) lives in $ws.
; Proposers JOIN &self-IR with $ws-state by nested match across the two spaces.
; The P0 demo passes $ws = &self (IR + state both in &self) and is unchanged.
;
; A candidate is `(cand KEY COST PRODS)`: KEY = unique firing key, COST = a list
; of `(token n)` typed-fuel costs, PRODS = a list of product facts. `walk` fires
; each affordable, not-yet-fired candidate (debiting fuel, logging an event).
; ===========================================================================

; --- the generic engine, on the worker space $ws (fuel ledger + gated fire + loop)
(= (fuelof $ws $t) (match $ws (fuel $t $n) $n))
(= (debit $ws $t $k) (let $n (fuelof $ws $t) (let $z (remove-atom $ws (fuel $t $n)) (let $m (- $n $k) (add-atom $ws (fuel $t $m))))))
(= (afford $ws $cost) (case $cost ((() True) ($ne (let ($t $n) (car-atom $cost) (if (>= (fuelof $ws $t) $n) (afford $ws (cdr-atom $cost)) False))))))
(= (debit-all $ws $cost) (case $cost ((() done) ($ne (let ($t $n) (car-atom $cost) (let $z (debit $ws $t $n) (debit-all $ws (cdr-atom $cost))))))))
; set-semantics add (D9): add a product only if not already present — the doc's X ⊕ θ(G2)
; is set-union, so per-match firing that re-emits a shared head (e.g. one alignment per cited
; edge) doesn't duplicate it. No-op for the old aggregating rules (their products are unique).
(= (present? $ws $a) (case (collapse (match $ws $a $a)) ((() False) ($x True))))
(= (add-all $ws $ps) (case $ps ((() done) ($ne (let $h (car-atom $ps) (let $z (if (present? $ws $h) done (add-atom $ws $h)) (add-all $ws (cdr-atom $ps))))))))
(= (fire $ws $rule $key $cost $prods $seq) (let $a (add-all $ws $prods) (let $b (debit-all $ws $cost) (add-atom $ws (event $seq $rule $key)))))
; fire-once-EVER: a (rule,key) that already has an event is skipped (idempotent re-run,
; so an epoch can re-enter the chamber after crediting fuel without redoing work).
(= (fired? $ws $rule $key) (case (collapse (match $ws (event $s $rule $key) yes)) ((() False) ($any True))))
(= (walk $ws $rule $cands $seq) (case $cands ((() $seq) ($ne (let (cand $key $cost $prods) (car-atom $cands) (if (fired? $ws $rule $key) (walk $ws $rule (cdr-atom $cands) $seq) (if (afford $ws $cost) (let $z (fire $ws $rule $key $cost $prods $seq) (walk $ws $rule (cdr-atom $cands) (+ $seq 1))) $seq)))))))
; generic list util used by the proposers
(= (filter-out $x $l) (case $l ((() ()) ($ne (let $h (car-atom $l) (if (== $h $x) (filter-out $x (cdr-atom $l)) (cons-atom $h (filter-out $x (cdr-atom $l)))))))))

; --- D3: the generic RULE-AS-DATA interpreter (lifts hand-written proposers to data)
; A rule body is ONE atom `(crule R KEY CLAUSES GUARDS COST PRODS)`:
;   CLAUSES  positive join literals — each `(at SPACE PAT)` (SPACE ∈ {self,ws}) or bare
;            PAT (= `at self`). Their nested `match` binds the rule's variables. (Verified:
;            a clause pulled from the stored atom binds against the space AND co-refers
;            with the same variables in KEY/GUARDS/PRODS — that is what makes this data-driven.)
;   GUARDS   list of `(exists SUB)` / `(absent SUB)` — existence / negation-as-failure checks.
;   COST     typed-fuel cost list (componentwise, as the engine's `afford` expects).
;   PRODS    product templates — each a literal fact, or `(collect SUB SUBPRODS)` which
;            emits SUBPRODS once per match of SUB (aggregation: one candidate bundling many).
; KEY / GUARDS / PRODS are templates over the variables CLAUSES binds. The crule is read
; from &self (the IR/genome); $ws is the worker space (run products + the `at ws` reads).
;
; TWO PHASES — because Prolog `collapse`/findall COPIES its template and frees any
; non-ground shared variable, so an aggregation or guard that runs while the join vars are
; still logic variables silently matches *everything* (a real bug found building this):
;   phase 1  `clause-join` folds nested `match` over CLAUSES and yields, per binding, an
;            INERT `(hit KEY GUARDS COST PRODS)`. An inert term gets its variables fully
;            ground-substituted (it is data, not reduced), so KEY/GUARDS/PRODS come out CONSTANTS.
;   phase 2  over those ground values: check GUARDS, then build PRODS (expanding collects).
;            Every `collapse` now sees only constants — no variable capture, no leak.
; (let-force the resolved space + head clause; match/cons/collapse don't reduce their args.)
(= (resolve-space self $ws) &self)
(= (resolve-space ws   $ws) $ws)
; phase 1: the positive conjunctive join (binds vars), threading $out untouched to the base.
(= (clause-join $ws $lits $out)
   (case $lits
     ((() $out)
      ($ne (let $h (car-atom $lits)
             (let $rest (cdr-atom $lits)
               (case $h
                 (((at $sp $pat) (let $space (resolve-space $sp $ws)
                                   (match $space $pat (clause-join $ws $rest $out))))
                  ($bare         (match &self $bare (clause-join $ws $rest $out)))))))))))
; phase 2a: guards, evaluated over the ground captured values (collapse sees only constants).
(= (sub-empty? $ws $sub) (case (collapse (clause-join $ws $sub yes)) ((() True) ($any False))))
(= (guard-ok? $ws (exists $sub)) (if (sub-empty? $ws $sub) False True))
(= (guard-ok? $ws (absent $sub)) (sub-empty? $ws $sub))
(= (guards-pass? $ws $guards)
   (case $guards ((() True)
      ($ne (let $g (car-atom $guards) (if (guard-ok? $ws $g) (guards-pass? $ws (cdr-atom $guards)) False))))))
; phase 2b: build the product list, expanding each (collect SUB SUBPRODS) into all its matches.
(= (concat-lists $a $b) (case $a ((() $b) ($ne (cons-atom (car-atom $a) (concat-lists (cdr-atom $a) $b))))))
(= (expand-prod $ws $h)
   (case $h (((collect $sub $subprods) (collapse (clause-join $ws $sub (superpose $subprods))))
             ($lit (cons-atom $lit ())))))
(= (build-prods $ws $prods)
   (case $prods ((() ())
      ($ne (let $hh (car-atom $prods) (concat-lists (expand-prod $ws $hh) (build-prods $ws (cdr-atom $prods))))))))
; the proposer: phase 1 (inert ground capture) then phase 2 (guards + build) -> (cand …) | skip.
(= (rule-cands $ws $rule)
   (let (hit $k $guards $cost $prods)
        (match &self (crule $rule $key $clauses $guards0 $cost0 $prods0)
           (clause-join $ws $clauses (hit $key $guards0 $cost0 $prods0)))
        (if (guards-pass? $ws $guards)
            (let $built (build-prods $ws $prods) (cand $k $cost $built))
            skip)))

; ===========================================================================
; D9: CANONICAL-IR RULES + CONVERTER + GENERIC RUN (the "lifted" source-of-truth form)
; ---------------------------------------------------------------------------
; A rule's SOURCE OF TRUTH is the backend-neutral canonical IR (separate facts):
;   (rule-lhs R (clause …))   clauses = `(at SPACE PAT)` / bare PAT, with `(var Name)` vars
;   (rule-rhs R (prod …))     product templates (per-MATCH: one firing per LHS match θ)
;   (rule-token-cost R tok n) · (rule-priority R n) · (rule-context R C)
; `(var Name)` is a named variable AS DATA (schema §2.1 node-var, inline) — portable, and
; the CONVERTER mints a co-referent PeTTa match-var per distinct Name (verified: a runtime
; `(fresh-var)` is a real, distinct, unifiable variable). lhs+rhs are converted TOGETHER so
; their shared Names co-refer; the result is assembled into the one-atom `(crule …)` the
; interpreter consumes — which is where the per-atom co-reference requirement is satisfied,
; so the IR author writes clean separate facts and never sees `$`-vars.
(= (fresh-var) $x)
(= (vnames-list $t) (if (== (get-metatype $t) Expression) (case $t (((var $n) ($n)) ($o (vnames-concat $t)))) ()))
(= (vnames-concat $t) (if (== $t ()) () (concat-lists (vnames-list (car-atom $t)) (vnames-concat (cdr-atom $t)))))
(= (dedup $l) (if (== $l ()) () (let $h (car-atom $l) (cons-atom $h (dedup (filter-out $h (cdr-atom $l)))))))
(= (subst-name $t $name $var) (if (== (get-metatype $t) Expression) (case $t (((var $n) (if (== $n $name) $var (map-subst $t $name $var))) ($o (map-subst $t $name $var)))) $t))
(= (map-subst $t $name $var) (if (== $t ()) () (cons-atom (subst-name (car-atom $t) $name $var) (map-subst (cdr-atom $t) $name $var))))
(= (to-vars $t) (subst-all $t (dedup (vnames-list $t))))
(= (subst-all $t $names) (if (== $names ()) $t (subst-all (subst-name $t (car-atom $names) (fresh-var)) (cdr-atom $names))))
(= (cost-of $R) (collapse (match &self (rule-token-cost $R $tok $n) ($tok $n))))
; convert ONE rule's canonical IR -> a runnable (crule …) added to &self (idempotent). KEY =
; the (instantiated) product list — unique per match, so per-edge firings stay distinct.
(= (crule-present? $R) (case (collapse (match &self (crule $R $k $c $g $co $p) yes)) ((() False) ($x True))))
(= (convert-rule $R)
   (if (crule-present? $R) done
       (match &self (rule-lhs $R $lhs) (match &self (rule-rhs $R $rhs)
         (let (both $clauses $prods) (to-vars (both $lhs $rhs))
           (let $cost (cost-of $R)
             (let $z (add-atom &self (crule $R $prods $clauses () $cost $prods)) done)))))))
(= (express) (express-rules (collapse (match &self (rule-lhs $R $lhs) $R))))
(= (express-rules $l) (if (== $l ()) done (let $z (convert-rule (car-atom $l)) (express-rules (cdr-atom $l)))))
; generic data-driven run: express the genome, then walk rules in rule-priority order.
(= (map-snd $l) (if (== $l ()) () (let ($n $r) (car-atom $l) (cons-atom $r (map-snd (cdr-atom $l))))))
(= (sorted-rules) (map-snd (msort (collapse (match &self (rule-priority $R $n) ($n $R))))))
(= (walk-rules $ws $rules $seq) (case $rules ((() $seq) ($ne (let $r (car-atom $rules) (let $seq2 (walk $ws $r (msort (filter-out skip (collapse (rule-cands $ws $r)))) $seq) (walk-rules $ws (cdr-atom $rules) $seq2)))))))
(= (run-rules-from $ws $seq0) (walk-rules $ws (sorted-rules) $seq0))
(= (run-rules $ws) (let $z (express) (run-rules-from $ws 0)))
; generic ABLATION run (P2 paired-replay / P3 genome-by-membership): run-rules but SKIP every
; rule in the $skip list. acs_scan ablates one rule; selection/evolve skip the non-member rules.
(= (in-list? $x $l) (case $l ((() False) ($ne (if (== (car-atom $l) $x) True (in-list? $x (cdr-atom $l)))))))
(= (walk-rules-skip $ws $rules $seq $skip)
   (case $rules ((() $seq)
     ($ne (let $r (car-atom $rules)
            (if (in-list? $r $skip)
                (walk-rules-skip $ws (cdr-atom $rules) $seq $skip)
                (let $seq2 (walk $ws $r (msort (filter-out skip (collapse (rule-cands $ws $r)))) $seq)
                  (walk-rules-skip $ws (cdr-atom $rules) $seq2 $skip))))))))
(= (run-ablate $ws $skip) (let $z (express) (walk-rules-skip $ws (sorted-rules) 0 $skip)))
