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
; ---------------------------------------------------------------------------
; The execution model is TECAN Alg 5.1 COLLECT-THEN-FIRE: `rules-pass` assembles the whole
; candidate queue against the epoch-start state and only then fires it, so a chain advances one
; hop per cycle and enumeration order stops deciding what is enabled. One pass is ONE EPOCH; the
; task loop in `epoch.metta` is what runs a derivation to completion.
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

; is EVERY fact in $ps already in $ws?
(= (all-present? $ws $ps)
   (case $ps
         ((() True)
          ($ne (if (present? $ws (car-atom $ps)) (all-present? $ws (cdr-atom $ps)) False)))))

; ---------------------------------------------------------------------------
; COLLECT-THEN-FIRE (TECAN Alg 5.1) — the engine. The candidate queue is assembled in full
; (line 10) BEFORE the first rewrite (line 16), so every precondition is evaluated against the
; EPOCH-START state: nothing in the queue was enabled by anything else in it, and a chain
; therefore advances ONE HOP PER CYCLE. That is deliberate in the doc — a pool cannot be ranked
; while it is being mutated. So ONE CHAMBER RUN IS ONE EPOCH, not a finished derivation: a
; caller that wants the whole chain works a task (`epoch.metta`), which runs cycles until the
; chamber settles.

; may this candidate fire NOW? not already fired this cycle, products not all already present
; (the settle guard), gate open. Evaluated at COLLECTION (Alg 5.1 line 5) and AGAIN at firing
; (line 14), because an earlier firing from the same queue may since have supplied the products
; or spent the fuel.
(= (admissible? $ws $O $rule $key $cost $prods)
   (if (fired? $ws $rule $key)
       False
       (if (all-present? $ws $prods)
           False
           (gate? $ws $O $rule $cost))))

; collect $rule's admissible candidates for organism $O as queue entries
; `(qcand RULE ORG KEY COST PRODS)`. Read-only: nothing fires here.
(= (collect-cands $ws $O $rule $cands)
   (case $cands
         ((() ())
          ($ne (let (cand $key $cost $prods) (car-atom $cands)
                    (if (admissible? $ws $O $rule $key $cost $prods)
                        (cons-atom (qcand $rule $O $key $cost $prods)
                                   (collect-cands $ws $O $rule (cdr-atom $cands)))
                        (collect-cands $ws $O $rule (cdr-atom $cands))))))))

; assemble the whole queue: every rule in $rules, enumerated against the state as it stands. A
; rule whose organism has NO SOMA is skipped without enumerating (Alg 5.1 line 3 collects from
; the organisms ACTIVE in the chamber — an unexpressed genome is inert code).
; QUEUE ORDER IS A PLACEHOLDER: Alg 5.1 pops BEST first, keyed by TECANScore, which allocates a
; scarce budget across affordable acts. We have no score yet, so the queue comes out in
; `rule-priority` order — a topological sort, not a value judgement. Deterministic, and
; immaterial while fuel covers every candidate; arbitrary the moment it does not.
(= (collect-rules $ws $rules)
   (case $rules
         ((() ())
          ($ne (let* (($r (car-atom $rules))
                      ($O (rule-organism $r))
                      ($rest (collect-rules $ws (cdr-atom $rules))))
                 (if (expressed? $ws $O)
                     (concat-lists (collect-cands $ws $O $r (msort (filter-out skip (collapse (rule-cands $ws $r))))) $rest)
                     $rest))))))

; fire the queue in order from $seq, halting at the step budget $b (Alg 5.1 line 12, b < B). An
; entry whose re-check fails is DROPPED and the queue continues rather than halting the run: the
; queue is mixed-rule and mixed-organism, so a later entry may be cheaper, or independent of
; whatever the earlier one exhausted.
(= (fire-queue $ws $q $seq $b)
   (if (budget-reached? $seq $b)
       $seq
       (case $q
             ((() $seq)
              ($ne (let (qcand $rule $O $key $cost $prods) (car-atom $q)
                        (if (admissible? $ws $O $rule $key $cost $prods)
                            (let $z (fire $ws $O $rule $key $cost $prods $seq)
                                 (fire-queue $ws (cdr-atom $q) (+ $seq 1) $b))
                            (fire-queue $ws (cdr-atom $q) $seq $b))))))))

; ONE EPOCH over $rules from $seq, bounded by $b: collect the whole queue, then fire it. Every
; run entry point goes through here, ablation replays included, so a counterfactual always runs
; the same engine as the run it is paired against.
(= (rules-pass $ws $rules $seq $b)
   (fire-queue $ws (collect-rules $ws $rules) $seq $b))

; run ONE epoch from a given seq (raw: ALL rules, no context filter; unbounded)
(= (run-rules-from $ws $seq)
   (rules-pass $ws (all-sorted-rules) $seq none))

; the raw run: express the genome, then ONE epoch over ALL rules (no context admission)
(= (run-rules $ws)
   (let $z (express $ws)
        (run-rules-from $ws 0)))

; ONE epoch over chamber $ch's admitted rules from a given seq (used by the task loop, which
; runs one of these per cycle)
(= (run-chamber-from $ws $ch $seq)
   (rules-pass $ws (chamber-rules $ch) $seq none))

; a CHAMBER run: express the genome, then ONE epoch over chamber $ch's admitted rules (MSC §3
; step 1 context admission) — one cycle of the task loop
(= (run-chamber $ws $ch)
   (let $z (express $ws)
        (run-chamber-from $ws $ch 0)))

; a BUDGETED chamber epoch (MSC §6.4 worker-budget-steps): express, then one epoch over chamber
; $ch's admitted rules from seq 0, halting when the firing seq reaches $b (`none` = unbounded)
(= (run-chamber-b $ws $ch $b)
   (let $z (express $ws)
        (rules-pass $ws (chamber-rules $ch) 0 $b)))

; --- running to SETTLE. One epoch advances any chain by one hop, so a caller that wants a whole
; derivation runs epochs until one fires nothing. `epoch.metta`'s task loop is the form with the
; metabolic bookkeeping — a cycle per epoch, dated to the task it serves; these are the BARE
; assays, for running a genome with no task posed, so every firing lands in the same default
; cycle and only the firing seq is threaded to keep the log well-formed.

; run epochs over $rules from $seq until one fires nothing, or the step budget $b is reached
(= (settle-from $ws $rules $seq $b)
   (let $seq2 (rules-pass $ws $rules $seq $b)
        (if (== $seq2 $seq)
            $seq2
            (settle-from $ws $rules $seq2 $b))))

; the raw run to settle: express, then run ALL rules to a standstill (bounded by $b)
(= (run-rules-settle $ws $b)
   (let $z (express $ws)
        (settle-from $ws (all-sorted-rules) 0 $b)))

; a CHAMBER run to settle: express, then run chamber $ch's admitted rules to a standstill —
; the unit of chamber computation a context-chamber worker performs (MSC §6.4), with $b its
; deterministic step budget over the whole run
(= (run-chamber-settle $ws $ch $b)
   (let $z (express $ws)
        (settle-from $ws (chamber-rules $ch) 0 $b)))

; --- generic ABLATION run (P2 paired-replay / P3 genome-by-membership): a run that SKIPS
; every rule in the $skip list. The ACS replay-ablation (condition 4) suppresses the ACS
; member set chamber-scoped (`run-chamber-ablate`); selection suppresses the non-member
; genes raw (`run-ablate`).

; the raw ablation run: express the genome, then run ALL rules minus $skip (no context
; filter — the structural assay runs the given genome)
(= (run-ablate $ws $skip)
   (let $z (express $ws)
        (rules-pass $ws (filter-out-all $skip (all-sorted-rules)) 0 none)))

; the CHAMBER-scoped ablation run (the counterfactual for the ACS condition-4 replay):
; express, then run only chamber $ch's admitted rules minus $skip — the same contextual run
; `run-chamber` performs, minus the suppressed rules, so the two are paired
(= (run-chamber-ablate $ws $ch $skip)
   (let $z (express $ws)
        (rules-pass $ws (filter-out-all $skip (chamber-rules $ch)) 0 none)))
