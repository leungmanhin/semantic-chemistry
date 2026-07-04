; ===========================================================================
; COMPILER — rules-as-data: convert the canonical rule-lhs/rule-rhs IR (with
; `(var Name)` markers) into a runnable `(crule …)`, and enumerate a rule's
; matches. Assumes util is loaded. Facts-free.
; ---------------------------------------------------------------------------
; A rule's SOURCE OF TRUTH is the backend-neutral canonical IR (separate facts):
;   (rule-lhs R (clause …))   clauses = `(at SPACE PAT)` / bare PAT, with `(var Name)` vars
;   (rule-rhs R (prod …))     product templates (per-MATCH: one firing per LHS match θ)
;   (rule-token-cost R tok n) · (rule-priority R n) · (rule-context R C)
; A rule's runnable form is one atom `(crule R KEY CLAUSES COST PRODS)`. `(var Name)`
; is a named variable AS DATA; the converter mints a co-referent PeTTa match-var per
; distinct Name (lhs+rhs converted TOGETHER so their shared Names co-refer), so the IR
; author writes clean separate facts and never sees `$`-vars.
; ===========================================================================

; --- the match ENUMERATOR (join a crule's clauses -> a candidate per solution) ---

; map a clause's SPACE tag (self / ws) to the actual space to match against
(= (resolve-space self $ws) &self)
(= (resolve-space ws   $ws) $ws)

; fold nested match over the clause list, yielding the (bound) $out template per solution
(= (clause-join $ws $lits $out)
   (case $lits
     ((() $out)
      ($ne (let* (($h (car-atom $lits))
                  ($rest (cdr-atom $lits)))
             (case $h
               (((at $sp $pat)
                     (let $space (resolve-space $sp $ws)
                          (match $space $pat (clause-join $ws $rest $out))))
                ($bare (match &self $bare (clause-join $ws $rest $out))))))))))

; enumerate rule $rule's candidates: pull its crule, join the clauses -> a (cand …) per match
(= (rule-cands $ws $rule)
   (match &self (crule $rule $key $clauses $cost $prods) (clause-join $ws $clauses (cand $key $cost $prods))))

; --- the canonical-IR CONVERTER (rule-lhs/rule-rhs + (var Name) -> a runnable crule) ---

; a fresh, distinct, unifiable match-variable
(= (fresh-var) $x)

; the (var Name) names appearing directly in term $t (one level of structure)
(= (vnames-list $t)
   (if (== (get-metatype $t) Expression)
       (case $t
             (((var $n) ($n))
              ($o       (vnames-concat $t))))
       ()))

; collect the (var Name) names across a list of terms
(= (vnames-concat $t) (if (== $t ()) () (concat-lists (vnames-list (car-atom $t)) (vnames-concat (cdr-atom $t)))))

; replace every (var $name) marker in term $t with the variable $var (recursing into subterms)
(= (subst-name $t $name $var)
   (if (== (get-metatype $t) Expression)
       (case $t
             (((var $n) (if (== $n $name) $var (map-subst $t $name $var)))
              ($o       (map-subst $t $name $var))))
       $t))

; map subst-name over the elements of a list
(= (map-subst $t $name $var) (if (== $t ()) () (cons-atom (subst-name (car-atom $t) $name $var) (map-subst (cdr-atom $t) $name $var))))

; instantiate every (var Name) marker in $t as a fresh co-referent match-var
(= (to-vars $t) (subst-all $t (dedup (vnames-list $t))))

; substitute a fresh var for each name in $names, one at a time
(= (subst-all $t $names) (if (== $names ()) $t (subst-all (subst-name $t (car-atom $names) (fresh-var)) (cdr-atom $names))))

; rule $R's cost vector as a list of (token n)
(= (cost-of $R) (collapse (match &self (rule-token-cost $R $tok $n) ($tok $n))))

; has rule $R already been converted to a runnable crule?
(= (crule-present? $R) (case (collapse (match &self (crule $R $k $c $co $p) yes)) ((() False) ($x True))))

; convert ONE rule's canonical IR -> a runnable (crule …) added to &self (idempotent). KEY =
; the (instantiated) product list — unique per match, so per-edge firings stay distinct.
(= (convert-rule $R)
   (if (crule-present? $R) done
       (match &self (rule-lhs $R $lhs) (match &self (rule-rhs $R $rhs)
         (let* (((both $clauses $prods) (to-vars (both $lhs $rhs)))
                ($cost (cost-of $R))
                ($z (add-atom &self (crule $R $prods $clauses $cost $prods))))
           done)))))

; express the whole genome: convert every rule that has a rule-lhs
(= (express) (express-rules (collapse (match &self (rule-lhs $R $lhs) $R))))
(= (express-rules $l) (if (== $l ()) done (let $z (convert-rule (car-atom $l)) (express-rules (cdr-atom $l)))))
