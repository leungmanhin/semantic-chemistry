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
(= (add-all $ws $ps) (case $ps ((() done) ($ne (let $h (car-atom $ps) (let $z (add-atom $ws $h) (add-all $ws (cdr-atom $ps))))))))
(= (fire $ws $rule $key $cost $prods $seq) (let $a (add-all $ws $prods) (let $b (debit-all $ws $cost) (add-atom $ws (event $seq $rule $key)))))
; fire-once-EVER: a (rule,key) that already has an event is skipped (idempotent re-run,
; so an epoch can re-enter the chamber after crediting fuel without redoing work).
(= (fired? $ws $rule $key) (case (collapse (match $ws (event $s $rule $key) yes)) ((() False) ($any True))))
(= (walk $ws $rule $cands $seq) (case $cands ((() $seq) ($ne (let (cand $key $cost $prods) (car-atom $cands) (if (fired? $ws $rule $key) (walk $ws $rule (cdr-atom $cands) $seq) (if (afford $ws $cost) (let $z (fire $ws $rule $key $cost $prods $seq) (walk $ws $rule (cdr-atom $cands) (+ $seq 1))) $seq)))))))
; generic list util used by the proposers
(= (filter-out $x $l) (case $l ((() ()) ($ne (let $h (car-atom $l) (if (== $h $x) (filter-out $x (cdr-atom $l)) (cons-atom $h (filter-out $x (cdr-atom $l)))))))))
