; ===========================================================================
; GROUNDER — grounds an answer-skeleton sem-graph against the molecule sem-graphs:
; the query-solving step of the pipeline (SC §4.5 answer projection: the skeleton
; IS the variable-bearing query pattern). The skeleton's conjunct sem-edges become joinable clause
; patterns — their (var …) markers co-refer by name, and each conjunct's matched
; molecule edge is exposed as a (var <conjunct-id>) binding — joined by the
; compiler's clause-join. A solution = the fully-grounded conjunct list: every
; element is a cited molecule sem-edge, so provenance is built in.
; Each conjunct's graph slot is a variable of its own, pinned to a neo-davidsonian graph,
; so one solution may span graphs — the task's own text, the docs it names, the graphs the
; firings made — while never joining on the skeleton's own facts. Assumes util + compiler
; are loaded.
; ===========================================================================

; the skeleton's conjunct patterns as joinable clauses, per relation arity (unary / binary /
; ternary); the matched molecule edge-id surfaces as (var <cid>), its graph as (var (g <cid>))
(= (skel-clauses-1 $gas)
   (collapse (match &self (sem-edge $gas $c $r $a) (sem-edge (var (g $c)) (var $c) $r $a))))

(= (skel-clauses-2 $gas)
   (collapse (match &self (sem-edge $gas $c $r $a $b) (sem-edge (var (g $c)) (var $c) $r $a $b))))

(= (skel-clauses-3 $gas)
   (collapse (match &self (sem-edge $gas $c $r $a $b $d) (sem-edge (var (g $c)) (var $c) $r $a $b $d))))

; one kind pin per conjunct: its graph must be a molecule graph — given, or made by a firing —
; never the skeleton's own graph or a control graph
(= (skel-pins $gas)
   (concat-lists (collapse (match &self (sem-edge $gas $c $r $a) (sem-graph-kind (var (g $c)) neo-davidsonian)))
     (concat-lists (collapse (match &self (sem-edge $gas $c $r $a $b) (sem-graph-kind (var (g $c)) neo-davidsonian)))
                   (collapse (match &self (sem-edge $gas $c $r $a $b $d) (sem-graph-kind (var (g $c)) neo-davidsonian))))))

; all clauses: the conjuncts, each binding its graph, then their kind pins
(= (skel-clauses $gas)
   (concat-lists (skel-clauses-1 $gas)
                 (concat-lists (skel-clauses-2 $gas)
                               (concat-lists (skel-clauses-3 $gas) (skel-pins $gas)))))

; ground answer-skeleton $gas against run space $ws (the hot pool holding the molecules +
; derived edges): one solution per complete join — the solution IS the grounded conjunct
; list (each element a cited molecule sem-edge). The skeleton STRUCTURE is read from &self
; (read-only IR, via skel-clauses); only the join hits $ws.
(= (ground-skeleton $ws $gas)
   (let (both $clauses $out) (to-vars (both (skel-clauses $gas) (skel-clauses $gas)))
        (clause-join $ws $clauses $out)))

; --- THE POSED TASK. A task is one arriving corpus item — a text together with the questions
; asked of it — and tasks are posed ONE AT A TIME, then retire. That is the unit the docs
; measure reuse in: a genome earns by "repeatedly solving variants of the same question type"
; (MSC §7.1), so what recurs is a strategy re-applied to NEW material.
; The run space carries `(task-now T)` while T is posed; with no marker every task
; counts as posed, which is what a bare single-task run wants.

; the task posed in $ws, or `all` when none is
(= (current-task $ws)
   (case (collapse (match $ws (task-now $t) $t)) ((() all) ($ts (car-atom $ts)))))

; pose task $t in $ws, replacing whatever was posed (posing `all` widens to the whole corpus)
(= (set-task $ws $t)
   (let $z (remove-all $ws (collapse (match $ws (task-now $old) (task-now $old))))
        (add-atom $ws (task-now $t))))

; retire the posed task: with nothing posed there is nothing to answer and nothing to earn
(= (retire-task $ws)
   (remove-all $ws (collapse (match $ws (task-now $t) (task-now $t)))))

; the questions posed right now — the current task's, or every task's when none is posed
(= (posed-questions $ws)
   (let $t (current-task $ws)
        (if (== $t all)
            (collapse (match &self (qa-question $v $q) $q))
            (collapse (match &self (qa-question $t $q) $q)))))

; the molecule graphs the posed task supplies — its own text (task-graph) and every graph of
; the docs it names (task-doc); every task's when none is posed
(= (posed-graphs $ws)
   (let $t (current-task $ws)
        (if (== $t all)
            (concat-lists (collapse (match &self (task-graph $v $g) $g))
                          (collapse (match &self (task-doc $v $d) (match &self (doc-graph $d $g) $g))))
            (concat-lists (collapse (match &self (task-graph $t $g) $g))
                          (collapse (match &self (task-doc $t $d) (match &self (doc-graph $d $g) $g)))))))

; --- ANSWER COUNT: the system's OUTPUT in space $ws = total groundings summed over the POSED
; questions' answer-skeletons. The epoch loop reads it as the per-cycle fitness proxy; the
; ACS replay-ablation reads it as the baseline / ablated answer count. The skeleton STRUCTURE
; + the question index live in &self; only the join hits $ws.

; # groundings of one answer-skeleton $gas against $ws
(= (skeleton-answers $ws $gas) (len (collapse (ground-skeleton $ws $gas))))

; # groundings summed over all of question $q's answer-skeletons
(= (question-answers $ws $q)
   (foldall + (match &self (answer-skeleton $q $gas) (skeleton-answers $ws $gas)) 0))

; # groundings summed over every POSED question (the system's total output this run)
(= (total-answers $ws) (sum-answers $ws (posed-questions $ws)))
(= (sum-answers $ws $qs)
   (case $qs ((() 0) ($ne (+ (question-answers $ws (car-atom $qs)) (sum-answers $ws (cdr-atom $qs)))))))
