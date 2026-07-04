; ===========================================================================
; REACTION — the firing ENGINE, $ws-parameterized: set-union product add, the
; fire step (+ event log), fire-once-ever, the per-rule `walk`, and the generic
; data-driven run (`run-rules`) / ablation run (`run-ablate`). No domain logic and
; no facts. Every stage runs its genome through this engine. Assumes util, fuel,
; compiler, and gate are loaded.
; ---------------------------------------------------------------------------
; Parameterized by a WORKER SPACE $ws (separate-space-per-worker isolation):
; read-only IR + domain mappings live in &self, mutable per-worker state (fuel,
; products, events) in $ws. A candidate is `(cand KEY COST PRODS)`: KEY = unique
; firing key, COST = a list of `(token n)` costs, PRODS = a list of product facts.
; ===========================================================================

; --- set-semantics add: the doc's X ⊕ θ(G2) is set-union, so per-match firing that
; re-emits a shared head (e.g. one alignment per cited edge) doesn't duplicate it.

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

; the event log of a space as (event …) facts, ordered by firing sequence
(= (log-facts $ws) (msort (collapse (match $ws (event $s $r $k) (event $s $r $k)))))

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

; walk every rule in priority order, resolving each rule's firing organism, threading $seq
(= (walk-rules $ws $rules $seq)
   (case $rules
         ((() $seq)
          ($ne (let* (($r (car-atom $rules))
                      ($O (rule-organism $r))
                      ($seq2 (walk $ws $O $r (msort (filter-out skip (collapse (rule-cands $ws $r)))) $seq)))
                 (walk-rules $ws (cdr-atom $rules) $seq2))))))

; run from a given seq (used by the epoch loop to re-enter after crediting fuel)
(= (run-rules-from $ws $seq) (walk-rules $ws (sorted-rules) $seq))

; the full run: express the genome, then walk the rules from seq 0
(= (run-rules $ws) (let $z (express) (run-rules-from $ws 0)))

; --- generic ABLATION run (P2 paired-replay / P3 genome-by-membership): run-rules but SKIP
; every rule in the $skip list. acs ablates one rule; selection skips the non-member rules.

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
