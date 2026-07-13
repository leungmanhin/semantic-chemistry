; ===========================================================================
; EPOCH LOOP — the metabolic-closure cycle (TECAN Alg 5.1 / MSC §4.5 cond 1),
; $ws-parameterized. Each epoch RE-PERFORMS the chamber's function on a fresh posing
; of the task: run the genome to quiescence (fuel-gated re-derivation), ground the
; answer-skeletons, mint + credit typed fuel under the clamp, then DECAY the derived
; layer. The fuel purse persists across cycles; the derived explanatory layer does not
; — so an organism must keep earning to keep answering. It survives iff its per-cycle
; surplus stays > 0 (MSC eq 19); an organism whose every rule can fire nothing is dead
; by starvation (permanent deadlock). Re-posing the one task each cycle stands in for a
; stream of tasks (TECAN: an organism "repeatedly solves a family of tasks"). Runs in
; &self (the grounder binds &self); per-worker-space isolation arrives with the worker
; stage. Assumes util + fuel + reaction + grounder + evaluator are loaded.
; ===========================================================================

; --- DECAY: forget the derived explanatory layer, keep the molecules + fuel + the event
; log. The derived edges are the organism's metabolic PRODUCTS (the maintenance cost
; cmaint of eq 19); the molecules are the given environment, re-supplied when the task is
; re-posed. This is the maintenance/rent limit — no free memory of a past derivation.

; the derived (compound-id) explanatory edges in $ws, across relation arities (unary /
; binary / ternary — the arities the grounder handles): any sem-edge with a derived id
(= (derived-edges-1 $ws)
   (collapse (match $ws (sem-edge $g $id $r $a) (if (derived-id? $id) (sem-edge $g $id $r $a) skip))))
(= (derived-edges-2 $ws)
   (collapse (match $ws (sem-edge $g $id $r $a $b) (if (derived-id? $id) (sem-edge $g $id $r $a $b) skip))))
(= (derived-edges-3 $ws)
   (collapse (match $ws (sem-edge $g $id $r $a $b $c) (if (derived-id? $id) (sem-edge $g $id $r $a $b $c) skip))))
(= (derived-edges $ws)
   (filter-out skip (concat-lists (derived-edges-1 $ws)
                                  (concat-lists (derived-edges-2 $ws) (derived-edges-3 $ws)))))

; the TVs of the derived edges
(= (derived-tvs $ws)
   (filter-out skip
               (collapse (match $ws (sem-edge-tv $g $id $tv)
                                (if (derived-id? $id) (sem-edge-tv $g $id $tv) skip)))))

; remove every (already-ground) atom in list $atoms from $ws
(= (remove-all $ws $atoms)
   (case $atoms
         ((() done)
          ($ne (let* (($h (car-atom $atoms))
                      ($z (remove-atom $ws $h)))
                 (remove-all $ws (cdr-atom $atoms)))))))

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
