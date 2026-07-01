; ===========================================================================
; KERNEL DEFS — the generic mortal-kernel ENGINE, facts-free, $ws-parameterized.
; ---------------------------------------------------------------------------
; The reusable firing mechanism, with NO domain logic and NO facts: a typed-fuel
; ledger, componentwise affordability, gated fire (+ event log), fire-once-ever,
; and the per-rule `walk`; the **canonical-IR converter** (rule-lhs/rule-rhs + (var Name)
; -> a runnable form, via runtime var-minting) + the generic data-driven `run-rules` /
; `run-ablate`. The rules + the experiment's DATA are canonical facts in experiments/<expt>/
; (rules.metta = the genome; molecules/tasks/configs). A different experiment reuses THIS
; engine and brings its own rules + data.
;
; The engine is parameterized by a WORKER SPACE $ws (separate-space-per-worker
; isolation, chosen on the spaces_behavior.metta battle-test):
;   * read-only IR + domain mappings live in &self (loaded by the experiment loader);
;   * mutable per-worker state (fuel, products, events) lives in $ws.
; Rules join &self-IR with $ws-state by nested match across the two spaces (converter + rule-cands).
; The P0 demo passes $ws = &self (IR + state both in &self).
;
; A candidate is `(cand KEY COST PRODS)`: KEY = unique firing key, COST = a list
; of `(token n)` typed-fuel costs, PRODS = a list of product facts. `walk` fires
; each affordable, not-yet-fired candidate (debiting fuel, logging an event).
; ===========================================================================

; --- the generic engine, on the worker space $ws (fuel ledger + gated fire + loop)
(= (fuelof $ws $t)
   (match $ws (fuel $t $n) $n))

(= (debit $ws $t $k)
   (let $n (fuelof $ws $t)
        (let $z (remove-atom $ws (fuel $t $n))
             (let $m (- $n $k)
                  (add-atom $ws (fuel $t $m))))))

(= (afford $ws $cost)
   (case $cost
         ((() True)
          ($ne (let ($t $n)
                    (car-atom $cost)
                    (if (>= (fuelof $ws $t) $n)
                        (afford $ws (cdr-atom $cost))
                        False))))))

(= (debit-all $ws $cost)
   (case $cost
         ((() done)
          ($ne (let ($t $n)
                    (car-atom $cost)
                    (let $z (debit $ws $t $n)
                         (debit-all $ws (cdr-atom $cost))))))))

; set-semantics add: add a product only if not already present — the doc's X ⊕ θ(G2)
; is set-union, so per-match firing that re-emits a shared head (e.g. one alignment per cited
; edge) doesn't duplicate it.
(= (present? $ws $a)
   (case (collapse (match $ws $a $a)) ((() False) ($x True))))

(= (add-all $ws $ps)
   (case $ps
         ((() done)
          ($ne (let $h (car-atom $ps) (let $z (if (present? $ws $h) done (add-atom $ws $h)) (add-all $ws (cdr-atom $ps))))))))

(= (fire $ws $rule $key $cost $prods $seq) (let $a (add-all $ws $prods) (let $b (debit-all $ws $cost) (add-atom $ws (event $seq $rule $key)))))
; fire-once-EVER: a (rule,key) that already has an event is skipped (idempotent re-run,
; so an epoch can re-enter the chamber after crediting fuel without redoing work).
(= (fired? $ws $rule $key) (case (collapse (match $ws (event $s $rule $key) yes)) ((() False) ($any True))))
(= (walk $ws $rule $cands $seq) (case $cands ((() $seq) ($ne (let (cand $key $cost $prods) (car-atom $cands) (if (fired? $ws $rule $key) (walk $ws $rule (cdr-atom $cands) $seq) (if (afford $ws $cost) (let $z (fire $ws $rule $key $cost $prods $seq) (walk $ws $rule (cdr-atom $cands) (+ $seq 1))) $seq)))))))
; generic list util used by the proposers
(= (filter-out $x $l) (case $l ((() ()) ($ne (let $h (car-atom $l) (if (== $h $x) (filter-out $x (cdr-atom $l)) (cons-atom $h (filter-out $x (cdr-atom $l)))))))))

; --- the generic RULE-AS-DATA interpreter ----------------------------------
; A rule's runnable form is one atom `(crule R KEY CLAUSES COST PRODS)` (the converter below
; builds it from the canonical rule-lhs/rule-rhs IR): CLAUSES = a conjunctive join, each
; `(at SPACE PAT)` (SPACE ∈ {self,ws}) or bare PAT (= `at self`); KEY/PRODS = templates over
; the variables CLAUSES binds. `clause-join` folds nested `match` over CLAUSES and yields, per
; binding, the (variable-bound) `(cand KEY COST PRODS)` — reproducing a hand-written proposer's
; nested match, driven by data. (Verified: a clause pulled from the stored atom binds against the
; space AND co-refers with the same vars in KEY/PRODS.) **Per-match** (MSC §4.3): one candidate per
; LHS match θ, with PRODS = θ(G2). Rules carry NO negation or aggregation — those live in the data
; (positive vocab, e.g. `role-relation`) / the evaluator (abstain + set-based scoring). So a
; single pass suffices.
; (`concat-lists` is a generic list util — also used by the converter; let-force the resolved
; space + head clause, since `match` doesn't reduce its pattern arg.)
(= (concat-lists $a $b) (case $a ((() $b) ($ne (cons-atom (car-atom $a) (concat-lists (cdr-atom $a) $b))))))
(= (resolve-space self $ws) &self)
(= (resolve-space ws   $ws) $ws)
(= (clause-join $ws $lits $out)
   (case $lits
     ((() $out)
      ($ne (let $h (car-atom $lits)
             (let $rest (cdr-atom $lits)
               (case $h
                 (((at $sp $pat) (let $space (resolve-space $sp $ws)
                                   (match $space $pat (clause-join $ws $rest $out))))
                  ($bare         (match &self $bare (clause-join $ws $rest $out)))))))))))
(= (rule-cands $ws $rule)
   (match &self (crule $rule $key $clauses $cost $prods)
     (clause-join $ws $clauses (cand $key $cost $prods))))

; ===========================================================================
; CANONICAL-IR RULES + CONVERTER + GENERIC RUN (the "lifted" source-of-truth form)
; ---------------------------------------------------------------------------
; A rule's SOURCE OF TRUTH is the backend-neutral canonical IR (separate facts):
;   (rule-lhs R (clause …))   clauses = `(at SPACE PAT)` / bare PAT, with `(var Name)` vars
;   (rule-rhs R (prod …))     product templates (per-MATCH: one firing per LHS match θ)
;   (rule-token-cost R tok n) · (rule-priority R n) · (rule-context R C)
; `(var Name)` is a named variable AS DATA (an inline marker) — portable, and
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
(= (crule-present? $R) (case (collapse (match &self (crule $R $k $c $co $p) yes)) ((() False) ($x True))))
(= (convert-rule $R)
   (if (crule-present? $R) done
       (match &self (rule-lhs $R $lhs) (match &self (rule-rhs $R $rhs)
         (let (both $clauses $prods) (to-vars (both $lhs $rhs))
           (let $cost (cost-of $R)
             (let $z (add-atom &self (crule $R $prods $clauses $cost $prods)) done)))))))
(= (express) (express-rules (collapse (match &self (rule-lhs $R $lhs) $R))))
(= (express-rules $l) (if (== $l ()) done (let $z (convert-rule (car-atom $l)) (express-rules (cdr-atom $l)))))
; generic data-driven run: express the genome, then walk rules in rule-priority order.
(= (map-snd $l) (if (== $l ()) () (let ($n $r) (car-atom $l) (cons-atom $r (map-snd (cdr-atom $l))))))
; --- context gate (MSC §3 step 1): a rule is eligible in the chamber iff its rule-context
; is among the chamber's chamber-context facts (context-subsumption). A rule with NO
; rule-context is unconstrained (always eligible). Single-context Exp-1 admits every rule
; (overkill, correct); a rule whose context is declared by no chamber is rejected. Only
; ELIGIBLE rules reach the priority walk (fuel then gates each firing).
(= (ctx-active? $c) (case (collapse (match &self (chamber-context $ch $c) yes)) ((() False) ($x True))))
(= (rule-contexts $R) (collapse (match &self (rule-context $R $c) $c)))
(= (any-active? $cs) (case $cs ((() False) ($ne (if (ctx-active? (car-atom $cs)) True (any-active? (cdr-atom $cs)))))))
(= (rule-eligible? $R) (let $cs (rule-contexts $R) (if (== $cs ()) True (any-active? $cs))))
(= (sorted-rules) (map-snd (msort (filter-out skip (collapse (match &self (rule-priority $R $n) (if (rule-eligible? $R) ($n $R) skip)))))))
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
