; ===========================================================================
; EPOCH LOOP — the task-working cycle, $ws-parameterized: a REDUCED form of a TECAN epoch
; (Alg 5.1 = score -> fire affordable ops -> evaluator-mint -> charge rent). A TASK is one
; arriving corpus item — a text and the questions asked of it. Working it means: pose it, let
; its text arrive into a FRESH hot pool, then run cycles until it is solved, stuck, or out of
; cycles; then mint + credit under the clamp. TECAN's rent + shadow-prices + scored gate are
; NOT built.
; ---------------------------------------------------------------------------
; What survives a task boundary is what MSC eq 8 puts inside the organism, O = (@R, X, F, C, L):
; the purse F and the event log L ride with the soma, while the hot pool X turns over. So an
; organism carries its metabolic position across arrivals — dead by starvation once it can
; afford to fire nothing, alive while income >= spend (thriving at surplus > 0, MSC eq 19,
; an expectation over REPEATED operation) — but carries no working material, because a task's
; text and everything derived from it retire with the task.
; Within a task, products PERSIST across cycles: a chain needs its intermediates to survive to
; the cycle that consumes them, and a rule whose products are already present does not re-fire
; (the guard is in `reaction.metta`), so a settled task stops spending.
; Runs in &self or a worker's space (the grounder binds the space). Assumes util + fuel +
; reaction + grounder + evaluator + worker are loaded — and worker.metta must be imported
; BEFORE this module, since `open-task` calls its `copy-molecules`: the transpiler binds a call
; to what is already defined, so a later import leaves the call silently inert.
; ===========================================================================

; --- REFRESH the hot pool for an arriving task: drop the working material — every sem-graph
; edge, TV and graph-kind pin, surface and derived alike — while leaving the purse, the event
; log and the cycle/task markers untouched. This is X turning over; F and L belong to the soma.
; Each list is collapsed BEFORE removal, so the space is not matched while it is being mutated.
(= (refresh-pool $ws)
   (let* (($z1 (remove-all $ws (collapse (match $ws (sem-edge $g $i $r $a) (sem-edge $g $i $r $a)))))
          ($z2 (remove-all $ws (collapse (match $ws (sem-edge $g $i $r $a $b) (sem-edge $g $i $r $a $b)))))
          ($z3 (remove-all $ws (collapse (match $ws (sem-edge $g $i $r $a $b $c) (sem-edge $g $i $r $a $b $c)))))
          ($z4 (remove-all $ws (collapse (match $ws (sem-edge-tv $g $i $tv) (sem-edge-tv $g $i $tv)))))
          ($z5 (remove-all $ws (collapse (match $ws (sem-graph-kind $g $k) (sem-graph-kind $g $k))))))
     done))

; --- reading the log's dating: which cycles ran at all, which TASKS they served, and which
; cycles served a given task. The detector counts turns per task off these.
(= (log-cycles $ws) (dedup (collapse (match $ws (event $c $s $r $key) $c))))
(= (log-tasks $ws) (dedup (collapse (match $ws (cycle-task $k $t) $t))))
(= (cycles-of-task $ws $t) (collapse (match $ws (cycle-task $k $t) $k)))

; the number of firings logged in cycle $k
(= (cycle-firings $ws $k) (foldall + (match $ws (event $k $s $r $key) 1) 0))

; --- set the current cycle marker in $ws (drop the old, add the new) — so `fire`/`fired?`
; scope to this cycle; the single event log then accumulates cycle-tagged, in place. The cycle
; is also DATED to the task it served (`(cycle-task K T)`, `all` when none is posed), which is
; what lets the detector count turns per task instead of per cycle.
(= (set-cycle $ws $k)
   (let* (($z0 (remove-all $ws (collapse (match $ws (cycle-now $old) (cycle-now $old)))))
          ($z1 (remove-all $ws (collapse (match $ws (cycle-task $k $oldt) (cycle-task $k $oldt)))))
          ($t (current-task $ws))
          ($z2 (add-atom $ws (cycle-task $k $t))))
     (add-atom $ws (cycle-now $k))))

; --- WORK the posed task from cycle $k, for at most $left more cycles. Each cycle tags itself
; and runs the chamber's admitted rules; the loop halts when a whole cycle fires NOTHING (the
; chamber has settled — nothing further is derivable from what it holds) or the cycle allowance
; runs out. Returns the answer count reached.
; Halting on SETTLED rather than on "an answer appeared" is deliberate: a control loop does its
; consolidating AFTER the answer — the success trace and the re-priming come last — so stopping
; at the first grounding would cut the loop off mid-turn. A derivation needs as many cycles as
; its chain is deep, which is why this is a loop and not a single pass; how many belongs to the
; task, not to the engine.
(= (work-task $ws $ch $cl $k $left)
   (if (== $left 0)
       (total-answers $ws)
       (let* (($z0 (set-cycle $ws $k))
              ($z1 (run-chamber $ws $ch)))
         (if (== (cycle-firings $ws $k) 0)
             (total-answers $ws)
             (work-task $ws $ch $cl (+ $k 1) (- $left 1))))))

; --- WORK the posed task with the rules in $skip SUPPRESSED: the ablating twin of `work-task`,
; and it has to stay a twin. A counterfactual is only paired with its real run if both are given
; the same chance to settle — a replay cut short at one cycle understates what the suppressed
; rules were worth, by exactly the part of the chain it never reached.
(= (work-task-ablate $ws $ch $k $left $skip)
   (if (== $left 0)
       done
       (let* (($z0 (set-cycle $ws $k))
              ($z1 (run-chamber-ablate $ws $ch $skip)))
         (if (== (cycle-firings $ws $k) 0)
             done
             (work-task-ablate $ws $ch (+ $k 1) (- $left 1) $skip)))))

; --- ONE TASK: pose it -> refresh the hot pool -> its text arrives -> work it (up to $max
; cycles from cycle $k) -> mint + credit. Returns the answer count; the purse change across the
; call is that task's eq-19 realized surplus. The task stays POSED afterwards, so the finished
; run is inspectable; posing the next task replaces it, and `retire-task` ends the stream.
(= (run-task $ws $ch $cl $t $k $max)
   (let* (($z0 (open-task $ws $t))
          ($answers (work-task $ws $ch $cl $k $max))
          ($z1 (credit-all-questions $ws $cl)))
     $answers))

; pose $t and hand the chamber a fresh pool holding just that task's text
(= (open-task $ws $t)
   (let* (($z0 (set-task $ws $t))
          ($z1 (refresh-pool $ws)))
     (copy-molecules $ws)))

; --- run a STREAM of tasks $ts, each allowed $max cycles, numbering cycles from $k; returns the
; answer count per task. The stream itself is the caller's — a chamber is handed the tasks that
; arrive, it does not decide what arrives.
(= (run-tasks $ws $ch $cl $ts $k $max)
   (case $ts
         ((() ())
          ($ne (let* (($t (car-atom $ts))
                      ($a (run-task $ws $ch $cl $t $k $max))
                      ($next (+ $k (len (cycles-of-task $ws $t)))))
                 (cons-atom $a (run-tasks $ws $ch $cl (cdr-atom $ts) $next $max)))))))

; --- harness reset: clear the purses + the cycle-tagged event log + the cycle/task markers in
; $ws so the loop can be re-run fresh (e.g. under another clamp)
(= (reset-run $ws)
   (let* (($z1 (remove-all $ws (collapse (match $ws (event $c $s $r $key) (event $c $s $r $key)))))
          ($z2 (remove-all $ws (collapse (match $ws (cycle-now $k) (cycle-now $k)))))
          ($z3 (remove-all $ws (collapse (match $ws (cycle-task $k2 $t2) (cycle-task $k2 $t2)))))
          ($z4 (remove-all $ws (collapse (match $ws (task-now $t3) (task-now $t3)))))
          ($z5 (remove-all $ws (collapse (match $ws (expressed $o2) (expressed $o2))))))
     (remove-all $ws (collapse (match $ws (fuel $o $t $n) (fuel $o $t $n))))))
