; ===========================================================================
; KERNEL — the generic mortal-kernel ENGINE, facts-free, $ws-parameterized.
; ---------------------------------------------------------------------------
; The reusable firing mechanism, with NO domain logic and NO facts: a PER-ORGANISM typed-fuel
; ledger (`fuel O tok n`, schema §2.3), componentwise affordability, a computed GATE
; (context + afford + attention, MSC eq 24) driving fire (+ event log), fire-once-ever,
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

; --- the generic engine, on the worker space $ws (per-organism fuel ledger + gate + loop)
; Fuel is a PER-ORGANISM typed purse `(fuel O tok n)` (schema §2.3): afford/debit read and
; write the *firing organism's own* purse; the organism of a candidate is resolved per rule
; by `rule-organism`. Exp-1 has one organism (the whole genome), so a single purse serves it.

; the balance of token $t that organism $O holds in space $ws
(= (fuelof $ws $O $t)
   (match $ws (fuel $O $t $n) $n))

; spend $k of token $t from $O's purse (replace the old balance with the reduced one)
(= (debit $ws $O $t $k)
   (let* (($n (fuelof $ws $O $t))
          ($z (remove-atom $ws (fuel $O $t $n)))
          ($m (- $n $k)))
     (add-atom $ws (fuel $O $t $m))))

; can $O pay the whole cost vector? — True iff every (token n) is affordable componentwise
(= (afford $ws $O $cost)
   (case $cost
         ((() True)
          ($ne (let ($t $n)
                    (car-atom $cost)
                    (if (>= (fuelof $ws $O $t) $n)
                        (afford $ws $O (cdr-atom $cost))
                        False))))))

; spend a whole cost vector from $O's purse (debit each component in turn)
(= (debit-all $ws $O $cost)
   (case $cost
         ((() done)
          ($ne (let* ((($t $n) (car-atom $cost))
                      ($z (debit $ws $O $t $n)))
                 (debit-all $ws $O (cdr-atom $cost)))))))

; --- ORGANISM resolution (schema §2.3): which mortal organism fires a rule, and so
; whose purse pays. A rule maps to its organism via ruleset membership
; (ruleset-member RS R · quoted-ruleset GNM RS · genome-of O GNM); a rule in no ruleset
; (e.g. a synthetic test rule) falls back to the sole declared organism. Single-organism
; Exp-1: every rule -> O_qa. `the-organism` is the generic single-organism accessor used
; by single-purse accounting (emit-summary, credit, tests).

; all declared organisms
(= (organisms) (collapse (match &self (organism $o) $o)))

; the sole organism (single-organism accessor); O_none when none is declared
(= (the-organism)
   (let $os (organisms)
        (if (== $os ())
            O_none
            (car-atom $os))))

; the organism whose genome quotes ruleset $rs
(= (owner-of-ruleset $rs)
   (match &self (quoted-ruleset $gnm $rs) (match &self (genome-of $o $gnm) $o)))

; the organism that fires rule $R — via ruleset membership, falling back to the sole organism
(= (rule-organism $R)
   (let $os (collapse (match &self (ruleset-member $rs $R) (owner-of-ruleset $rs)))
        (if (== $os ()) (the-organism) (car-atom $os))))

; --- typed ATTENTION state (schema §2.4) + the attention gate. `(attention R tok v)` is a
; hand-set, rule-level attention level (the TECAN-typed analogue of ECAN STI). A rule with
; no attention fact passes vacuously; a rule that declares attention passes iff every
; declared level is >= the threshold. Attention dynamics (decay/rent/spread) are not
; modelled here, so on Exp-1 (no attention facts) `attn-ok?` always holds.
(= (attn-threshold) 1)

; every value in the list $vs is >= $thr (vacuously True on the empty list)
(= (all-ge $vs $thr)
   (case $vs
         ((() True)
          ($ne (if (>= (car-atom $vs) $thr)
                   (all-ge (cdr-atom $vs) $thr)
                   False)))))

; does rule $R clear the attention threshold? (vacuously True when it has no attention fact)
(= (attn-ok? $R)
   (all-ge (collapse (match &self (attention $R $tok $v) $v)) (attn-threshold)))

; --- the computed GATE `Gate_C(R,O,X)` (MSC eq 24 / schema §3 step 3): the single
; fire-decision for a candidate, folding context eligibility + affordability + attention.
; Additional eq-24 factors (do-influence / novelty / −redundancy / +FuelMargin / +ACSBoost)
; are not modelled here. On Exp-1 it reduces to `afford` (context pre-filtered by
; sorted-rules, attention vacuous).
(= (gate? $ws $O $R $cost)
   (if (rule-eligible? $R)
       (if (afford $ws $O $cost)
           (attn-ok? $R)
           False)
       False))

; --- set-semantics add: add a product only if not already present — the doc's X ⊕ θ(G2)
; is set-union, so per-match firing that re-emits a shared head (e.g. one alignment per cited
; edge) doesn't duplicate it.

; is fact $a already present in $ws?
(= (present? $ws $a)
   (case (collapse (match $ws $a $a)) ((() False) ($x True))))

; add each product in $ps to $ws, skipping any already present (set-union)
(= (add-all $ws $ps)
   (case $ps
         ((() done)
          ($ne (let* (($h (car-atom $ps))
                      ($z (if (present? $ws $h) done (add-atom $ws $h))))
                 (add-all $ws (cdr-atom $ps)))))))

; fire a candidate: add its products, debit $O's purse, and log the event at $seq
(= (fire $ws $O $rule $key $cost $prods $seq)
   (let* (($a (add-all $ws $prods))
          ($b (debit-all $ws $O $cost)))
     (add-atom $ws (event $seq $rule $key))))

; fire-once-EVER: a (rule,key) that already has an event is skipped (idempotent re-run,
; so an epoch can re-enter the chamber after crediting fuel without redoing work).
(= (fired? $ws $rule $key)
   (case (collapse (match $ws (event $s $rule $key) yes)) ((() False) ($any True))))

; walk a rule's candidate list for organism $O: skip already-fired candidates; fire the next
; iff the gate passes (then continue at seq+1); a shut gate halts this rule (cold / unaffordable
; — later same-cost candidates would fail too), returning $seq.
(= (walk $ws $O $rule $cands $seq)
   (case $cands
         ((() $seq)
          ($ne (let (cand $key $cost $prods)
                    (car-atom $cands)
                    (if (fired? $ws $rule $key)
                        (walk $ws $O $rule (cdr-atom $cands) $seq)
                        (if (gate? $ws $O $rule $cost)
                            (let $z (fire $ws $O $rule $key $cost $prods $seq)
                                 (walk $ws $O $rule (cdr-atom $cands) (+ $seq 1)))
                            $seq)))))))

; generic list util: drop every occurrence of $x from list $l
(= (filter-out $x $l)
   (case $l
         ((() ())
          ($ne (let $h (car-atom $l) (if (== $h $x) (filter-out $x (cdr-atom $l)) (cons-atom $h (filter-out $x (cdr-atom $l)))))))))

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

; generic list util: append list $b onto list $a
(= (concat-lists $a $b)
   (case $a ((() $b)
             ($ne (cons-atom (car-atom $a) (concat-lists (cdr-atom $a) $b))))))

; map a clause's SPACE tag (self / ws) to the actual space to match against
(= (resolve-space self $ws) &self)
(= (resolve-space ws   $ws) $ws)

; fold nested match over the clause list, yielding the (bound) $out template per solution
(= (clause-join $ws $lits $out)
   (case $lits
     ((() $out)
      ($ne (let* (($h (car-atom $lits))
                  ($rest (cdr-atom $lits)))
             (case $h
               (((at $sp $pat)
                     (let $space (resolve-space $sp $ws)
                          (match $space $pat (clause-join $ws $rest $out))))
                ($bare (match &self $bare (clause-join $ws $rest $out))))))))))

; enumerate rule $rule's candidates: pull its crule, join the clauses -> a (cand …) per match
(= (rule-cands $ws $rule)
   (match &self (crule $rule $key $clauses $cost $prods) (clause-join $ws $clauses (cand $key $cost $prods))))

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

; a fresh, distinct, unifiable match-variable
(= (fresh-var) $x)

; the (var Name) names appearing directly in term $t (one level of structure)
(= (vnames-list $t)
   (if (== (get-metatype $t) Expression)
       (case $t
             (((var $n) ($n))
              ($o       (vnames-concat $t))))
       ()))

; collect the (var Name) names across a list of terms
(= (vnames-concat $t) (if (== $t ()) () (concat-lists (vnames-list (car-atom $t)) (vnames-concat (cdr-atom $t)))))

; generic list util: drop duplicate elements, keeping first occurrences
(= (dedup $l) (if (== $l ()) () (let $h (car-atom $l) (cons-atom $h (dedup (filter-out $h (cdr-atom $l)))))))

; replace every (var $name) marker in term $t with the variable $var (recursing into subterms)
(= (subst-name $t $name $var)
   (if (== (get-metatype $t) Expression)
       (case $t
             (((var $n) (if (== $n $name) $var (map-subst $t $name $var)))
              ($o       (map-subst $t $name $var))))
       $t))

; map subst-name over the elements of a list
(= (map-subst $t $name $var) (if (== $t ()) () (cons-atom (subst-name (car-atom $t) $name $var) (map-subst (cdr-atom $t) $name $var))))

; instantiate every (var Name) marker in $t as a fresh co-referent match-var
(= (to-vars $t) (subst-all $t (dedup (vnames-list $t))))

; substitute a fresh var for each name in $names, one at a time
(= (subst-all $t $names) (if (== $names ()) $t (subst-all (subst-name $t (car-atom $names) (fresh-var)) (cdr-atom $names))))

; rule $R's cost vector as a list of (token n)
(= (cost-of $R) (collapse (match &self (rule-token-cost $R $tok $n) ($tok $n))))

; has rule $R already been converted to a runnable crule?
(= (crule-present? $R) (case (collapse (match &self (crule $R $k $c $co $p) yes)) ((() False) ($x True))))

; convert ONE rule's canonical IR -> a runnable (crule …) added to &self (idempotent). KEY =
; the (instantiated) product list — unique per match, so per-edge firings stay distinct.
(= (convert-rule $R)
   (if (crule-present? $R) done
       (match &self (rule-lhs $R $lhs) (match &self (rule-rhs $R $rhs)
         (let* (((both $clauses $prods) (to-vars (both $lhs $rhs)))
                ($cost (cost-of $R))
                ($z (add-atom &self (crule $R $prods $clauses $cost $prods))))
           done)))))

; express the whole genome: convert every rule that has a rule-lhs
(= (express) (express-rules (collapse (match &self (rule-lhs $R $lhs) $R))))
(= (express-rules $l) (if (== $l ()) done (let $z (convert-rule (car-atom $l)) (express-rules (cdr-atom $l)))))

; keep the second element of each (a b) pair in a list
(= (map-snd $l) (if (== $l ()) () (let ($n $r) (car-atom $l) (cons-atom $r (map-snd (cdr-atom $l))))))

; --- context gate (MSC §3 step 1): a rule is eligible in the chamber iff its rule-context
; is among the chamber's chamber-context facts (context-subsumption). A rule with NO
; rule-context is unconstrained (always eligible). Single-context Exp-1 admits every rule
; (overkill, correct); a rule whose context is declared by no chamber is rejected. Only
; ELIGIBLE rules reach the priority walk (fuel then gates each firing).

; is context $c active, i.e. declared as some chamber's chamber-context?
(= (ctx-active? $c) (case (collapse (match &self (chamber-context $ch $c) yes)) ((() False) ($x True))))

; the contexts rule $R declares
(= (rule-contexts $R) (collapse (match &self (rule-context $R $c) $c)))

; is any context in $cs active?
(= (any-active? $cs) (case $cs ((() False) ($ne (if (ctx-active? (car-atom $cs)) True (any-active? (cdr-atom $cs)))))))

; is rule $R licensed here? unconstrained when it declares no context, else eligible
; iff one of its contexts is active
(= (rule-eligible? $R)
   (let $cs (rule-contexts $R)
        (if (== $cs ())
            True
            (any-active? $cs))))

; the eligible rules, ordered by rule-priority (ineligible ones drop out as `skip`)
(= (sorted-rules)
   (map-snd (msort (filter-out skip
                               (collapse (match &self (rule-priority $R $n)
                                                (if (rule-eligible? $R) ($n $R) skip)))))))

; walk every rule in priority order, resolving each rule's firing organism, threading $seq
(= (walk-rules $ws $rules $seq)
   (case $rules
         ((() $seq)
          ($ne (let* (($r (car-atom $rules))
                      ($O (rule-organism $r))
                      ($seq2 (walk $ws $O $r (msort (filter-out skip (collapse (rule-cands $ws $r)))) $seq)))
                 (walk-rules $ws (cdr-atom $rules) $seq2))))))

; run from a given seq (used by the epoch loop to re-enter after crediting fuel)
(= (run-rules-from $ws $seq0) (walk-rules $ws (sorted-rules) $seq0))

; the full run: express the genome, then walk the rules from seq 0
(= (run-rules $ws) (let $z (express) (run-rules-from $ws 0)))

; --- generic ABLATION run (P2 paired-replay / P3 genome-by-membership): run-rules but SKIP
; every rule in the $skip list. acs ablates one rule; selection skips the non-member rules.

; generic list util: is $x a member of list $l?
(= (in-list? $x $l) (case $l ((() False) ($ne (if (== (car-atom $l) $x) True (in-list? $x (cdr-atom $l)))))))

; like walk-rules but skip any rule in $skip
(= (walk-rules-skip $ws $rules $seq $skip)
   (case $rules ((() $seq)
     ($ne (let $r (car-atom $rules)
            (if (in-list? $r $skip)
                (walk-rules-skip $ws (cdr-atom $rules) $seq $skip)
                (let* (($O (rule-organism $r))
                       ($seq2 (walk $ws $O $r (msort (filter-out skip (collapse (rule-cands $ws $r)))) $seq)))
                  (walk-rules-skip $ws (cdr-atom $rules) $seq2 $skip))))))))

; the full ablation run: express the genome, then walk skipping $skip
(= (run-ablate $ws $skip) (let $z (express) (walk-rules-skip $ws (sorted-rules) 0 $skip)))
