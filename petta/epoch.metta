; ===========================================================================
; EPOCH LOOP — the metabolic-closure cycle, $ws-parameterized: a REDUCED form of a TECAN
; epoch (Alg 5.1 = score -> fire affordable ops -> evaluator-mint -> charge rent). Here each
; cycle re-derives the genome (fuel-gated), grounds the answer-skeletons, mints + credits
; typed fuel under the clamp, then DECAYS the derived layer. TECAN's rent + shadow-prices +
; scored gate are NOT built; the decay + single-task re-posing are OURS (see the DECAY note).
; The fuel purse persists across cycles; the derived explanatory layer does not — so an
; organism must keep earning to keep answering: dead by starvation (permanent deadlock) once
; it can afford to fire nothing, alive while income >= spend so its typed fuel never runs out
; (thriving at surplus > 0, MSC eq 19). Re-posing the one task each cycle stands in for a
; stream of tasks. Runs in &self or a worker's space (the grounder binds the space). Assumes
; util + fuel + reaction + grounder + evaluator are loaded.
; ===========================================================================

; --- DECAY: drop the derived explanatory layer each cycle, keep the molecules + fuel + the
; event log + any relation declared `(persistent R)` (a persistent molecule, exempt from the
; forgetting — our stand-in for TECAN importance-graded retention: a consolidated motif is
; retained across cycles so a control loop can close through it). This is our device to make
; the eq-19 metabolic accounting VISIBLE: by forgetting
; the products, an organism must RE-DERIVE them each cycle, so a rule whose token income < its
; firing spend eventually can't afford to re-fire and its answers vanish (starvation / permanent
; deadlock). It is NOT the maintenance cost: cmaint is TECAN's RENT — a per-cycle fuel charge
; that kills IDLE loops (a separate, unbuilt mechanism). Decay charges NO fuel, so an idle
; organism keeps its purse and does NOT starve here (it just goes silent); the death in the demo
; is eq-19 starvation via forced re-spend, not rent. Loosely a "forgetting" (atom removal, TECAN
; §4.6). Molecules = the given environment (re-supplied); the derived edges = the organism's
; own products, not kept for free.

; the derived (compound-id) explanatory edges in $ws to forget, across relation arities
; (unary / binary / ternary — the arities the grounder handles): any sem-edge with a
; derived id whose relation is NOT persistent
(= (derived-edges-1 $ws)
   (collapse (match $ws (sem-edge $g $id $r $a)
                    (if (derived-id? $id) (if (persistent-rel? $r) skip (sem-edge $g $id $r $a)) skip))))
(= (derived-edges-2 $ws)
   (collapse (match $ws (sem-edge $g $id $r $a $b)
                    (if (derived-id? $id) (if (persistent-rel? $r) skip (sem-edge $g $id $r $a $b)) skip))))
(= (derived-edges-3 $ws)
   (collapse (match $ws (sem-edge $g $id $r $a $b $c)
                    (if (derived-id? $id) (if (persistent-rel? $r) skip (sem-edge $g $id $r $a $b $c)) skip))))
(= (derived-edges $ws)
   (filter-out skip (concat-lists (derived-edges-1 $ws)
                                  (concat-lists (derived-edges-2 $ws) (derived-edges-3 $ws)))))

; the ids of the PERSISTENT edges in $ws — their TVs are exempt too, so a kept edge never
; dangles a forgotten TV
(= (persistent-ids-1 $ws)
   (collapse (match $ws (sem-edge $g $id $r $a) (if (persistent-rel? $r) $id skip))))
(= (persistent-ids-2 $ws)
   (collapse (match $ws (sem-edge $g $id $r $a $b) (if (persistent-rel? $r) $id skip))))
(= (persistent-ids-3 $ws)
   (collapse (match $ws (sem-edge $g $id $r $a $b $c) (if (persistent-rel? $r) $id skip))))
(= (persistent-ids $ws)
   (filter-out skip (concat-lists (persistent-ids-1 $ws)
                                  (concat-lists (persistent-ids-2 $ws) (persistent-ids-3 $ws)))))

; the TVs of the derived edges to forget: a derived id that is NOT a persistent edge's
(= (derived-tvs $ws)
   (let $pids (persistent-ids $ws)
        (filter-out skip
                    (collapse (match $ws (sem-edge-tv $g $id $tv)
                                     (if (derived-id? $id)
                                         (if (in-list? $id $pids) skip (sem-edge-tv $g $id $tv))
                                         skip))))))

; decay: drop the derived edges + their TVs (NOT the event log). Each list is collapsed
; BEFORE removal, so the space is not matched while it is being mutated.
(= (decay $ws)
   (let* (($z1 (remove-all $ws (derived-edges $ws)))
          ($z2 (remove-all $ws (derived-tvs $ws))))
     done))

; --- set the current cycle marker in $ws (drop the old, add the new) — so `fire`/`fired?`
; scope to this cycle; the single event log then accumulates cycle-tagged, in place.
(= (set-cycle $ws $k)
   (let $z (remove-all $ws (collapse (match $ws (cycle-now $old) (cycle-now $old))))
        (add-atom $ws (cycle-now $k))))

; --- ONE EPOCH (cycle $k): tag the cycle -> re-derive (fuel-gated) -> count -> mint+credit
; -> decay the derived layer. Returns the answer count; the purse change across the call is
; the eq-19 realized surplus. The cycle-tagged event log persists across cycles.
(= (run-epoch $ws $ch $cl $k)
   (let* (($z0 (set-cycle $ws $k))
          ($z1 (run-chamber $ws $ch))
          ($answers (total-answers $ws))
          ($z2 (credit-all-questions $ws $cl))
          ($z3 (decay $ws)))
     $answers))

; --- run epochs $k..$n; return the answer-count trajectory, one per cycle ---
(= (run-epochs $ws $ch $cl $k $n)
   (if (> $k $n)
       ()
       (let $a (run-epoch $ws $ch $cl $k)
            (cons-atom $a (run-epochs $ws $ch $cl (+ $k 1) $n)))))

(= (epochs $ws $ch $cl $n) (run-epochs $ws $ch $cl 1 $n))

; --- TRACED run: per cycle collect (answers surplus) for organism $O's token $tok, where
; surplus = the purse change across the cycle (−spend +mint) = the eq-19 realized surplus.
(= (run-epochs-traced $ws $ch $cl $k $n $O $tok)
   (if (> $k $n)
       ()
       (let* (($before (fuel-of $ws $O $tok))
              ($a (run-epoch $ws $ch $cl $k))
              ($after (fuel-of $ws $O $tok)))
         (cons-atom ($a (- $after $before))
                    (run-epochs-traced $ws $ch $cl (+ $k 1) $n $O $tok)))))

(= (epochs-traced $ws $ch $cl $n $O $tok) (run-epochs-traced $ws $ch $cl 1 $n $O $tok))

; --- harness reset: clear the purses + the cycle-tagged event log + the cycle marker in $ws
; so the loop can be re-run fresh (e.g. under another clamp)
(= (reset-run $ws)
   (let* (($z1 (remove-all $ws (collapse (match $ws (event $c $s $r $key) (event $c $s $r $key)))))
          ($z2 (remove-all $ws (collapse (match $ws (cycle-now $k) (cycle-now $k))))))
     (remove-all $ws (collapse (match $ws (fuel $o $t $n) (fuel $o $t $n))))))
