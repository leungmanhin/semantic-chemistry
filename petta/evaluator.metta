; ===========================================================================
; EVALUATOR — scores each GROUNDING (a solution returned by ground-skeleton) and
; mints typed fuel under a clamp (MSC §4.4: the evaluator is the sole minting
; authority — the soma never mints). Match is BINARY per grounding: every solution
; is a match, and each mints separately (per-solution piece-rate: answer plurality
; pays, partial work pays partially). The kind of good behavior shapes the KIND of
; fuel earned: a grounding's ACHIEVEMENTS are detected structurally, and the clamp
; maps each achievement to the token + amount it mints ((clamp-mint CL a tok n)):
;   skeleton-match          — every successful grounding      (§4.4 "answer-skeleton match")
;   transitive-explanation  — the cited derivation is a chain (§4.4 "compact causal explanation")
; Achievements read the provenance-bearing edge-ids by STRUCTURE (the IR convention:
; a derived id = a compound whose head names the deriving step and whose args are the
; premise edge-ids — no genome id-vocabulary is named here). The mint is credited to
; the organism whose rule derived the cited edge (producer looked up in the event
; log). Growth: the abstain reference-oracle; provenance-aware eq-17 terms
; (Unsupportedness/Redundancy) when a real proof store supplies L. Also hosts the evaluator
; WORKER body (`run-eval`, worker-kind `evaluator`): mint every question in a worker's
; already-derived space under its clamp, then emit the resulting purses. Assumes util +
; fuel + grounder are loaded.
; ===========================================================================

; the derivation depth of an edge-id: a parser-given id is atomic (depth 0); a DERIVED
; id is a compound (step premise-id …) whose depth = its number of atomic id-leaves
; (= source edges consumed; e.g. the V3 genome's (norm E) = 1, (trans A B) = |A|+|B|)
(= (id-depth $id)
   (if (== (get-metatype $id) Expression)
       (leaf-count (cdr-atom $id))
       0))

; count atomic leaves across a list of id-trees (each compound's head is a step name,
; not a leaf)
(= (leaf-count $l)
   (case $l
         ((() 0)
          ($ne (let $h (car-atom $l)
                    (+ (if (== (get-metatype $h) Expression)
                           (leaf-count (cdr-atom $h))
                           1)
                       (leaf-count (cdr-atom $l))))))))

; the edge-id of a solution element (a grounded sem-edge of any arity; non-edges -> none)
(= (element-id $el)
   (case $el
         (((sem-edge $g $id $r $a) $id)
          ((sem-edge $g $id $r $a $b) $id)
          ((sem-edge $g $id $r $a $b $c) $id)
          ($other none))))

; a solution's derivation depth = the summed depth of its cited edge-ids
(= (solution-depth $sol)
   (case $sol
         ((() 0)
          ($ne (+ (id-depth (element-id (car-atom $sol)))
                  (solution-depth (cdr-atom $sol)))))))

; the depths of a solution list (report helper)
(= (depths-of $sols)
   (case $sols
         ((() ())
          ($ne (cons-atom (solution-depth (car-atom $sols)) (depths-of (cdr-atom $sols)))))))

; --- achievements: what a grounding accomplished, detected structurally ---

; every grounding is a skeleton match; one whose cited derivation is a chain
; (depth >= 2) is additionally a transitive explanation
(= (solution-achievements $sol)
   (if (>= (solution-depth $sol) 2)
       (skeleton-match transitive-explanation)
       (skeleton-match)))

; --- the clamp (pure data): (clamp-mint CL achievement tok n) ---

; the (tok n) mints clamp $cl pays for achievement $a
(= (achievement-mints $cl $a)
   (collapse (match &self (clamp-mint $cl $a $tok $n) ($tok $n))))

; every (tok n) a solution mints under $cl, across its achievements
(= (mints-of $cl $as)
   (case $as
         ((() ())
          ($ne (concat-lists (achievement-mints $cl (car-atom $as))
                             (mints-of $cl (cdr-atom $as)))))))

(= (solution-mints $cl $sol)
   (mints-of $cl (solution-achievements $sol)))

; the amount of token $tok in a mint list
(= (sum-tok $tok $mints)
   (case $mints
         ((() 0)
          ($ne (let ($t $n)
                    (car-atom $mints)
                    (+ (if (== $t $tok) $n 0) (sum-tok $tok (cdr-atom $mints))))))))

; the amount of token $tok ONE grounding mints under $cl
(= (solution-mint $cl $tok $sol)
   (sum-tok $tok (solution-mints $cl $sol)))

; --- income (pure), per token: skeleton / question / chamber ---

; total $tok minted over a solution list
(= (mint-sum $cl $tok $sols)
   (case $sols
         ((() 0)
          ($ne (+ (solution-mint $cl $tok (car-atom $sols))
                  (mint-sum $cl $tok (cdr-atom $sols)))))))

(= (skeleton-income $ws $gas $cl $tok)
   (mint-sum $cl $tok (collapse (ground-skeleton $ws $gas))))

(= (question-income $ws $q $cl $tok)
   (foldall + (match &self (answer-skeleton $q $gas) (skeleton-income $ws $gas $cl $tok)) 0))

(= (chamber-income $ws $cl $tok)
   (foldall + (match &self (qa-question $v $q) (question-income $ws $q $cl $tok)) 0))

; --- crediting: each minted (tok n) goes to the organism whose rule DERIVED the cite ---

; the first derived (depth>0) cite of a solution — the answer edge; none if pure lookup
(= (derived-cite $sol)
   (case $sol
         ((() none)
          ($ne (let $h (car-atom $sol)
                    (if (> (id-depth (element-id $h)) 0)
                        $h
                        (derived-cite (cdr-atom $sol))))))))

; the rule that produced $edge: the event whose product-key contains it (the event log
; key IS the instantiated product list — provenance from L)
(= (producer-of $ws $edge)
   (let $rs (filter-out skip (collapse (match $ws (event $c $s $r $k) (if (in-list? $edge $k) $r skip))))
        (if (== $rs ()) none (car-atom $rs))))

; the earning organism of a solution (rule -> organism via ruleset membership)
(= (solution-earner $ws $sol)
   (rule-organism (producer-of $ws (derived-cite $sol))))

; credit every (tok n) in $mints to organism $O; returns the total tokens credited
(= (credit-mints $ws $O $mints)
   (case $mints
         ((() 0)
          ($ne (let* ((($t $n) (car-atom $mints))
                      ($z (credit $ws $O $t $n)))
                 (+ $n (credit-mints $ws $O (cdr-atom $mints))))))))

; credit every solution in $sols under $cl; returns the total tokens credited
(= (credit-sols $ws $cl $sols)
   (case $sols
         ((() 0)
          ($ne (let* (($sol (car-atom $sols))
                      ($O (solution-earner $ws $sol))
                      ($m (credit-mints $ws $O (solution-mints $cl $sol))))
                 (+ $m (credit-sols $ws $cl (cdr-atom $sols))))))))

; the skeletons of question $q
(= (skeletons-of $q)
   (collapse (match &self (answer-skeleton $q $gas) $gas)))

; ground + credit every skeleton of $q under $cl; returns the total tokens credited
(= (credit-skels $ws $cl $gasl)
   (case $gasl
         ((() 0)
          ($ne (+ (credit-sols $ws $cl (collapse (ground-skeleton $ws (car-atom $gasl))))
                  (credit-skels $ws $cl (cdr-atom $gasl)))))))

(= (credit-question $ws $q $cl)
   (credit-skels $ws $cl (skeletons-of $q)))

; --- MINT every question in $ws under clamp $cl (the evaluator's per-cycle income): run
; credit-question over the whole task set. A context-chamber worker fills $ws first; the
; evaluator reads that output graph and mints — it never derives. ---
(= (credit-all-questions $ws $cl)
   (credit-each $ws (collapse (match &self (qa-question $v $q) $q)) $cl))

(= (credit-each $ws $qs $cl)
   (case $qs
         ((() done)
          ($ne (let* (($q (car-atom $qs))
                      ($z (credit-question $ws $q $cl)))
                 (credit-each $ws (cdr-atom $qs) $cl))))))

; --- the EVALUATOR worker body (worker-kind `evaluator`): mint typed fuel for every
; question in the worker's space under its clamp, then emit the resulting purses (the token
; delta) to &self. Dispatched by dispatch.metta.
(= (run-eval $w)
   (let* (($ws (match &self (worker-space $w $sp) $sp))
          ($cl (match &self (worker-clamp $w $c) $c))
          ($z (credit-all-questions $ws $cl)))
     (add-all &self (collapse (match $ws (fuel $O $t $n) (worker-purse $w $O $t $n))))))
