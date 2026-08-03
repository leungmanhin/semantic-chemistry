; ===========================================================================
; WORKER — the shared worker ENVELOPE (MSC §6.4): the worker-generic infrastructure that
; EVERY worker kind reuses. A "worker" is the general unit; each KIND has its own body
; module. This module holds only what those bodies share: materialize the
; molecules into a worker's ISOLATED hot-pool space (never &self — "no two threads
; mutate the same chamber hot pool"), restore fuel from a declarative snapshot, read the
; deterministic step budget, and emit the run summary. The read-only IR (rules, configs,
; clamps, answer-skeletons) stays in &self; only the genome's COMPILED crules land in &self
; (idempotent shared compilation). Assumes util + fuel + grounder loaded (the grounder supplies
; the posed task, which scopes which text a worker admits).
; ===========================================================================

; --- the hot pool: materialize the durable MOLECULE facts (the non-answer-skeleton
; sem-graphs) into the worker's space — the parser's SURFACE edges only, never derived
; products, so the worker re-derives the explanatory layer from scratch in its own space.
; Scoped to the ADMITTED graphs: a task's text arrives WITH the task, so a run that poses one
; task sees only that text. Earlier texts are not withdrawn (add-all is set-union), so what
; arrived stays — the environment accumulates, and the chemistry is monotone. ---

; is graph $g a molecule graph (i.e. NOT an answer-skeleton)?
(= (mol-graph? $g)
   (case (collapse (match &self (sem-graph-kind $g answer-skeleton) yes)) ((() True) ($x False))))

; is $g an admitted molecule graph — one of $gs, and not an answer-skeleton?
(= (admitted-graph? $g $gs) (if (in-list? $g $gs) (mol-graph? $g) False))

; copy this sem-edge? — only edges on an admitted graph carrying a parser (non-derived) id
(= (mol-surface? $g $e $gs) (if (admitted-graph? $g $gs) (if (derived-id? $e) False True) False))

; every molecule fact of the admitted graphs $gs: the graph-kind pin + the surface sem-edges
; (any arity) + TVs
(= (molecule-facts $gs)
   (filter-out skip
     (concat-lists (collapse (match &self (sem-graph-kind $g $k) (if (admitted-graph? $g $gs) (sem-graph-kind $g $k) skip)))
       (concat-lists (collapse (match &self (sem-edge $g $e $r $a) (if (mol-surface? $g $e $gs) (sem-edge $g $e $r $a) skip)))
         (concat-lists (collapse (match &self (sem-edge $g $e $r $a $b) (if (mol-surface? $g $e $gs) (sem-edge $g $e $r $a $b) skip)))
           (concat-lists (collapse (match &self (sem-edge $g $e $r $a $b $c) (if (mol-surface? $g $e $gs) (sem-edge $g $e $r $a $b $c) skip)))
                         (collapse (match &self (sem-edge-tv $g $e $tv) (if (mol-surface? $g $e $gs) (sem-edge-tv $g $e $tv) skip)))))))))

; copy the POSED task's molecules into worker space $ws — its text arriving with it. With no
; task posed every task's text is admitted, which is what a bare single-task run wants.
(= (copy-molecules $ws) (add-all $ws (molecule-facts (posed-graphs $ws))))

; --- the worker's TASK (§6.4): which arriving task this worker is given. Undeclared means
; `all` — a worker handed no particular task works the whole corpus, which is what every
; worker did before tasks were modelled. ---
(= (worker-task-of $w)
   (case (collapse (match &self (worker-task $w $t) $t)) ((() all) ($ts (car-atom $ts)))))

; OPEN the hot pool: pose the worker's task in its space and hand it a FRESH pool holding just
; that task's text. Posing first is what makes the pool task-scoped — the text arrives because
; the task did — and refreshing is what lets a worker be handed a second arrival in a space it
; has already run in, instead of deriving over the previous task's leftovers.
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

; pose $t and hand the chamber a fresh pool holding just that task's text
(= (open-task $ws $t)
   (let* (($z0 (set-task $ws $t))
          ($z1 (refresh-pool $ws)))
     (copy-molecules $ws)))

; OPEN a worker's hot pool: pose the task IT was handed, into a fresh pool.
(= (open-hot-pool $ws $w) (open-task $ws (worker-task-of $w)))

; --- SEED fuel from snapshot $snap (the declarative initial endowment) into $ws, per (organism,
; token): an organism that ALREADY holds a balance in that token keeps what it has. Restoring
; seeds an empty purse; it does not top up a live one — so handing a worker a second arrival in
; a space it has already run in can neither refill it nor leave two balance facts for one token.
(= (restore-snapshot $ws $snap)
   (seed-fuel $ws (collapse (match &self (snapshot-fuel $snap $O $t $n) ($O $t $n)))))

(= (seed-fuel $ws $fs)
   (case $fs
         ((() done)
          ($ne (let* ((($O $t $n) (car-atom $fs))
                      ($z (if (has-fuel? $ws $O $t) done (add-atom $ws (fuel $O $t $n)))))
                 (seed-fuel $ws (cdr-atom $fs)))))))

; the first cycle number free in $ws — one past the highest already dated, so a worker handed a
; second arrival numbers its cycles AFTER the ones already in the log rather than overwriting
; their task dating
(= (next-cycle $ws)
   (let $ks (msort (collapse (match $ws (cycle-task $k $t) $k)))
        (if (== $ks ()) 1 (+ 1 (car-atom (rev-list $ks))))))

; --- the output envelope (§6.4): summarise the run to &self — total firings + one
; (worker-purse W O tok n) per surviving purse (the append-only log stays in $ws) ---
(= (emit-summary $w $ws)
   (let* (($firings (foldall + (match $ws (event $c $s $r $k) 1) 0))
          ($z1 (add-atom &self (worker-firings $w $firings))))
     (add-all &self (collapse (match $ws (fuel $O $t $n) (worker-purse $w $O $t $n))))))

; the worker's cycle allowance (`worker-cycles`; default 20). A task halts when its chamber
; settles, so this is a runaway guard rather than a tuning dial.
(= (worker-cycles-of $w)
   (case (collapse (match &self (worker-cycles $w $n) $n)) ((() 20) ($ns (car-atom $ns)))))

; the worker's deterministic step budget (MSC §6.4 worker-budget-steps; `none` = unbounded)
(= (worker-budget $w)
   (case (collapse (match &self (worker-budget-steps $w $n) $n)) ((() none) ($ns (car-atom $ns)))))
