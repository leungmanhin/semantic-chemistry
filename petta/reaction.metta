; ===========================================================================
; REACTION — the firing ENGINE, $ws-parameterized: set-union product add, the
; fire step (+ cycle-tagged event log), fire-once-per-cycle, the per-rule `walk` (step-budgeted), and the
; generic raw run (`run-rules`) / chamber run (`run-chamber`, budgeted `run-chamber-b`) /
; ablation runs (`run-ablate` raw, `run-chamber-ablate` chamber-scoped).
; Every stage runs its genome through this engine. Assumes util, fuel,
; compiler, and gate are loaded.
; ---------------------------------------------------------------------------
; Parameterized by a WORKER SPACE $ws (separate-space-per-worker isolation):
; read-only IR + domain mappings live in &self, mutable per-worker state (fuel,
; products, events) in $ws. A candidate is `(cand KEY COST PRODS)`: KEY = unique
; firing key, COST = a list of `(token n)` costs, PRODS = a list of product facts.
; ===========================================================================

; --- set-semantics add: the doc's X ⊕ θ(G2) is set-union, so per-match firing that
; re-emits a shared head (e.g. one alignment per cited edge) doesn't duplicate it.

; is fact $f already present in $ws?
(= (present? $ws $f)
   (case (collapse (match $ws $f $f)) ((() False) ($x True))))

; add each product in $ps to $ws, skipping any already present (set-union)
(= (add-all $ws $ps)
   (case $ps
         ((() done)
          ($ne (let* (($h (car-atom $ps))
                      ($z (if (present? $ws $h) done (add-atom $ws $h))))
                 (add-all $ws (cdr-atom $ps)))))))

; the current cycle marker in $ws (set by the epoch loop each cycle; a bare run has no
; marker and defaults to cycle 1, so single-run behaviour is unchanged)
(= (current-cycle $ws)
   (case (collapse (match $ws (cycle-now $k) $k)) ((() 1) ($ks (car-atom $ks)))))

; fire a candidate: add its products, debit $O's purse, and log the event at $seq, tagged
; with the current cycle
(= (fire $ws $O $rule $key $cost $prods $seq)
   (let* (($a (add-all $ws $prods))
          ($b (debit-all $ws $O $cost))
          ($c (current-cycle $ws)))
     (add-atom $ws (event $c $seq $rule $key))))

; fire-once-PER-CYCLE: a (rule,key) that already has an event IN THE CURRENT CYCLE is
; skipped; a new cycle (the epoch bumps `cycle-now`) lets the rule fire again — the
; re-performance the metabolic loop needs, without ever clearing the log.
(= (fired? $ws $rule $key)
   (let $c (current-cycle $ws)
        (case (collapse (match $ws (event $c $s $rule $key) yes)) ((() False) ($any True)))))

; the event log of a space as (event …) facts, ordered by cycle then firing sequence
(= (log-facts $ws) (msort (collapse (match $ws (event $c $s $r $k) (event $c $s $r $k)))))

; has the firing seq reached the worker-budget-steps $b? (`none` = unbounded — MSC §6.4:
; the deterministic step cap that halts a bounded run at a step boundary)
(= (budget-reached? $seq $b) (if (== $b none) False (>= $seq $b)))

; walk a rule's candidate list for organism $O: halt at the step budget $b; else skip
; already-fired candidates and fire the next iff the gate passes (continue at seq+1); a shut
; gate halts this rule (cold / unaffordable — later same-cost candidates would fail too).
(= (walk $ws $O $rule $cands $seq $b)
   (if (budget-reached? $seq $b)
       $seq
       (case $cands
             ((() $seq)
              ($ne (let (cand $key $cost $prods) (car-atom $cands)
                        (if (fired? $ws $rule $key)
                            (walk $ws $O $rule (cdr-atom $cands) $seq $b)
                            (if (gate? $ws $O $rule $cost)
                                (let $z (fire $ws $O $rule $key $cost $prods $seq)
                                     (walk $ws $O $rule (cdr-atom $cands) (+ $seq 1) $b))
                                $seq))))))))

; walk every rule in priority order (halting at the step budget $b), resolving each rule's
; firing organism, threading $seq
(= (walk-rules $ws $rules $seq $b)
   (if (budget-reached? $seq $b)
       $seq
       (case $rules
             ((() $seq)
              ($ne (let* (($r (car-atom $rules))
                          ($O (rule-organism $r))
                          ($seq2 (walk $ws $O $r (msort (filter-out skip (collapse (rule-cands $ws $r)))) $seq $b)))
                     (walk-rules $ws (cdr-atom $rules) $seq2 $b)))))))

; run from a given seq (raw: ALL rules, no context filter; unbounded)
(= (run-rules-from $ws $seq)
   (walk-rules $ws (all-sorted-rules) $seq none))

; the raw run: express the genome, then walk ALL rules from seq 0 (no context admission)
(= (run-rules $ws)
   (let $z (express)
        (run-rules-from $ws 0)))

; a chamber run from a given seq (only $ch's admitted rules; used by the epoch loop to
; re-enter after crediting fuel)
(= (run-chamber-from $ws $ch $seq)
   (walk-rules $ws (chamber-rules $ch) $seq none))

; a CHAMBER run: express the genome, then walk only chamber $ch's admitted rules (MSC §3
; step 1 context admission) — the contextual run a context-chamber worker performs
(= (run-chamber $ws $ch)
   (let $z (express)
        (run-chamber-from $ws $ch 0)))

; a BUDGETED chamber run (MSC §6.4 worker-budget-steps): express, then walk chamber $ch's
; admitted rules from seq 0, halting when the firing seq reaches $b (`none` = unbounded)
(= (run-chamber-b $ws $ch $b)
   (let $z (express)
        (walk-rules $ws (chamber-rules $ch) 0 $b)))

; --- generic ABLATION run (P2 paired-replay / P3 genome-by-membership): a run that SKIPS
; every rule in the $skip list. The ACS replay-ablation (condition 4) suppresses the ACS
; member set chamber-scoped (`run-chamber-ablate`); selection suppresses the non-member
; genes raw (`run-ablate`).

; like walk-rules but skip any rule in $skip
(= (walk-rules-skip $ws $rules $seq $skip)
   (case $rules
         ((() $seq)
          ($ne (let $r (car-atom $rules)
                    (if (in-list? $r $skip)
                        (walk-rules-skip $ws (cdr-atom $rules) $seq $skip)
                        (let* (($O (rule-organism $r))
                               ($seq2 (walk $ws $O $r (msort (filter-out skip (collapse (rule-cands $ws $r)))) $seq none)))
                          (walk-rules-skip $ws (cdr-atom $rules) $seq2 $skip))))))))

; the raw ablation run: express the genome, then walk ALL rules skipping $skip (no context
; filter — the structural assay runs the given genome)
(= (run-ablate $ws $skip)
   (let $z (express)
        (walk-rules-skip $ws (all-sorted-rules) 0 $skip)))

; the CHAMBER-scoped ablation run (the counterfactual for the ACS condition-4 replay):
; express, then walk only chamber $ch's admitted rules skipping $skip — the same contextual
; run `run-chamber` performs, minus the suppressed rules, so the two are paired
(= (run-chamber-ablate $ws $ch $skip)
   (let $z (express)
        (walk-rules-skip $ws (chamber-rules $ch) 0 $skip)))
