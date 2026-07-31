; ===========================================================================
; COMPILER — rules-as-data: convert the canonical rule-lhs/rule-rhs IR (with
; `(var Name)` markers) into a runnable `(crule …)`, and enumerate a rule's
; matches. Assumes util is loaded.
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
(= (resolve-space ws $ws) $ws)

; fold nested match over the clause list, yielding the (bound) $out template per solution.
; A bare clause matches the RUN space $ws (the hot pool — molecules + derived edges;
; $ws is &self on a bare run, a worker's own space under isolation); an explicit
; (at self PAT) still routes to &self for a read-only-IR read.
(= (clause-join $ws $lits $out)
   (case $lits
     ((() $out)
      ($ne (let* (($h (car-atom $lits))
                  ($rest (cdr-atom $lits)))
             (case $h
               (((at $sp $pat)
                     (let $space (resolve-space $sp $ws)
                          (match $space $pat (clause-join $ws $rest $out))))
                ($bare (match $ws $bare (clause-join $ws $rest $out))))))))))

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
              ($o (vnames-concat $t))))
       ()))

; collect the (var Name) names across a list of terms
(= (vnames-concat $t)
   (if (== $t ())
       ()
       (concat-lists (vnames-list (car-atom $t)) (vnames-concat (cdr-atom $t)))))

; replace every (var $name) marker in term $t with the variable $var (recursing into subterms)
(= (subst-name $t $name $var)
   (if (== (get-metatype $t) Expression)
       (case $t
             (((var $n) (if (== $n $name) $var (map-subst $t $name $var)))
              ($o (map-subst $t $name $var))))
       $t))

; map subst-name over the elements of a list
(= (map-subst $t $name $var)
   (if (== $t ())
       ()
       (cons-atom (subst-name (car-atom $t) $name $var) (map-subst (cdr-atom $t) $name $var))))

; instantiate every (var Name) marker in $t as a fresh co-referent match-var
(= (to-vars $t)
   (subst-all $t (dedup (vnames-list $t))))

; substitute a fresh var for each name in $names, one at a time
(= (subst-all $t $names)
   (if (== $names ()) $t (subst-all (subst-name $t (car-atom $names) (fresh-var)) (cdr-atom $names))))

; rule $r's cost vector as a list of (token n)
(= (cost-of $r)
   (collapse (match &self (rule-token-cost $r $tok $n) ($tok $n))))

; has rule $r already been converted to a runnable crule?
(= (crule-present? $r)
   (case (collapse (match &self (crule $r $k $c $co $p) yes)) ((() False) ($x True))))

; convert ONE rule's canonical IR -> a runnable (crule …) added to &self (idempotent).
; KEY = the (instantiated) product list: content-addressed, so a match keeps the same key
; across re-enumeration (safe epoch re-entry) and per-edge firings stay distinct. Firing
; identity is the (rule, key) PAIR — the event log carries the rule — so equal products
; across DIFFERENT rules never collide. Within ONE rule, two matches θ whose RHS
; instantiation coincides (the RHS drops an LHS var, e.g. R_qtype dropping the task)
; collapse to one firing — vacuous under ⊕ set-union except the fuel debit. For strict
; per-θ accounting (charge every match, eq 12–16 read strictly), key on the instantiated
; LHS instead: (crule $r $clauses $clauses $cost $prods).
(= (convert-rule $r)
   (if (crule-present? $r)
       done
       (match &self (rule-lhs $r $lhs)
          (match &self (rule-rhs $r $rhs)
             (let* (((both $clauses $prods) (to-vars (both $lhs $rhs)))
                    ($cost (cost-of $r))
                    ($z (add-atom &self (crule $r $prods $clauses $cost $prods))))
               done)))))

; --- EXPRESSION (MSC eq 20 `cexpr`, "expression (gated dequoting)"). Compiling a quoted rule
; into a crule is a SHARED, idempotent build artifact and stays free; what costs is having a
; SOMA — a running instance of a genome in a particular hot pool. MSC is explicit that the two
; differ in kind ("a dequoted process ∗@P actually runs"; "if the act of dequoting is itself
; token-gated…"), so an organism pays its genome's dequote cost ONCE per hot pool, not per cycle
; (charging per cycle would re-implement rent, which is `cmaint`, under the wrong name).
; An organism that cannot afford to dequote has NO SOMA: it is marked nowhere, and none of its
; rules run. That is a death mode PRIOR to being unable to afford a firing.
; A genome with no declared cost expresses for free, so a config opts in by declaring one.

; the genome of organism $o
(= (organism-genome $o) (match &self (genome-of $o $gnm) $gnm))

; the dequote cost of genome $gnm as a (token n) list — empty when undeclared (free)
(= (genome-cost $gnm) (collapse (match &self (genome-token-cost $gnm $t $n) ($t $n))))

; does organism $o have a soma in $ws?
(= (expressed? $ws $o)
   (case (collapse (match $ws (expressed $o) yes)) ((() False) ($x True))))

; express $o into $ws: already expressed -> nothing owed; affordable -> debit and mark;
; otherwise it stays unexpressed and stays silent
(= (express-organism $ws $o)
   (if (expressed? $ws $o)
       done
       (let $c (genome-cost (organism-genome $o))
            (if (afford? $ws $o $c)
                (let $z (debit-all $ws $o $c) (add-atom $ws (expressed $o)))
                starved))))

(= (express-each $ws $os)
   (if (== $os ()) done (let $z (express-organism $ws (car-atom $os)) (express-each $ws (cdr-atom $os)))))

; express the genome into hot pool $ws: give every organism that can pay a soma there, then
; compile every rule that has a rule-lhs (shared, idempotent, free)
(= (express $ws)
   (let $z (express-each $ws (organisms))
        (express-rules (collapse (match &self (rule-lhs $r $lhs) $r)))))
(= (express-rules $l) (if (== $l ()) done (let $z (convert-rule (car-atom $l)) (express-rules (cdr-atom $l)))))
