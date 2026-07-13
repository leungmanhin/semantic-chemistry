; ===========================================================================
; WORKER — the shared worker ENVELOPE (MSC §6.4): the worker-generic infrastructure that
; EVERY worker kind reuses. A "worker" is the general unit; each KIND has its own body
; module. This module holds only what those bodies share: materialize the
; molecules into a worker's ISOLATED hot-pool space (never &self — "no two threads
; mutate the same chamber hot pool"), restore fuel from a declarative snapshot, read the
; deterministic step budget, and emit the run summary. The read-only IR (rules, configs,
; clamps, answer-skeletons) stays in &self; only the genome's COMPILED crules land in &self
; (idempotent shared compilation). Assumes util + fuel loaded.
; ===========================================================================

; --- the hot pool: materialize the durable MOLECULE facts (the non-answer-skeleton
; sem-graphs) into the worker's space — the parser's SURFACE edges only, never derived
; products, so the worker re-derives the explanatory layer from scratch in its own space ---

; is graph $g a molecule graph (i.e. NOT an answer-skeleton)?
(= (mol-graph? $g)
   (case (collapse (match &self (sem-graph-kind $g answer-skeleton) yes)) ((() True) ($x False))))

; copy this sem-edge? — only edges on a molecule graph carrying a parser (non-derived) id
(= (mol-surface? $g $e) (if (mol-graph? $g) (if (derived-id? $e) False True) False))

; every molecule fact to copy: the graph-kind pin + the surface sem-edges (any arity) + TVs
(= (molecule-facts)
   (filter-out skip
     (concat-lists (collapse (match &self (sem-graph-kind $g $k) (if (mol-graph? $g) (sem-graph-kind $g $k) skip)))
       (concat-lists (collapse (match &self (sem-edge $g $e $r $a) (if (mol-surface? $g $e) (sem-edge $g $e $r $a) skip)))
         (concat-lists (collapse (match &self (sem-edge $g $e $r $a $b) (if (mol-surface? $g $e) (sem-edge $g $e $r $a $b) skip)))
           (concat-lists (collapse (match &self (sem-edge $g $e $r $a $b $c) (if (mol-surface? $g $e) (sem-edge $g $e $r $a $b $c) skip)))
                         (collapse (match &self (sem-edge-tv $g $e $tv) (if (mol-surface? $g $e) (sem-edge-tv $g $e $tv) skip)))))))))

; copy the molecules into worker space $ws (add-all skips any already present)
(= (copy-molecules $ws) (add-all $ws (molecule-facts)))

; --- restore fuel from snapshot $snap (declarative initial state) into $ws ---
(= (restore-snapshot $ws $snap)
   (add-all $ws (collapse (match &self (snapshot-fuel $snap $O $t $n) (fuel $O $t $n)))))

; --- the output envelope (§6.4): summarise the run to &self — total firings + one
; (worker-purse W O tok n) per surviving purse (the append-only log stays in $ws) ---
(= (emit-summary $w $ws)
   (let* (($firings (foldall + (match $ws (event $c $s $r $k) 1) 0))
          ($z1 (add-atom &self (worker-firings $w $firings))))
     (add-all &self (collapse (match $ws (fuel $O $t $n) (worker-purse $w $O $t $n))))))

; the worker's deterministic step budget (MSC §6.4 worker-budget-steps; `none` = unbounded)
(= (worker-budget $w)
   (case (collapse (match &self (worker-budget-steps $w $n) $n)) ((() none) ($ns (car-atom $ns)))))
