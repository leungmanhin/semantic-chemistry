; ===========================================================================
; GATE — context admission + the MORTAL GATE `Gate_C(R,O,X)` (MSC eq 24 / TECAN
; Alg 5.2 TECANScore). Context admission (MSC §3 step 1) selects a chamber's
; rules by context-subsumption (`chamber-rules`). The mortal gate scores each
; rule's firing PROPENSITY in (0,1) — "a logistic regression over the rule's
; bookkeeping" — and one number serves both consumers: the priority queue's key
; (Alg 5.1, `rank-queue` in reaction.metta) and the admission conjunct
; `U < Gate_C` (MSC eq 13, `gate-open?`). Assumes util + fuel + compiler are
; loaded, and is the growth home for the unbuilt score terms (plausibility,
; novelty, scalar redundancy, shadow-priced cost).
; ===========================================================================

; --- context admission (MSC §3 step 1): a rule is admitted to a chamber iff its
; rule-context is one of THAT chamber's chamber-context facts (context-subsumption). A
; rule with NO rule-context is unconstrained (admitted anywhere). Context does not vary
; across a rule's candidates, so it filters the rule LIST (chamber-rules), not the
; per-firing gate — a chamber run walks only its admitted rules; the raw run walks all.

; is context $c one of chamber $ch's active contexts?
(= (ctx-active-in? $ch $c)
   (case (collapse (match &self (chamber-context $ch $c) yes)) ((() False) ($x True))))

; the contexts rule $r declares
(= (rule-contexts $r)
   (collapse (match &self (rule-context $r $c) $c)))

; is any context in $cs active in chamber $ch?
(= (any-active-in? $ch $cs)
   (case $cs
         ((() False)
          ($ne (if (ctx-active-in? $ch (car-atom $cs)) True (any-active-in? $ch (cdr-atom $cs)))))))

; is rule $r admitted to chamber $ch? unconstrained when it declares no context, else
; admitted iff one of its contexts is active in $ch
(= (rule-eligible-in? $ch $r)
   (let $cs (rule-contexts $r)
        (if (== $cs ())
            True
            (any-active-in? $ch $cs))))

; chamber $ch's admitted rules, ordered by rule-priority (non-admitted drop out as `skip`).
; Priority is the deterministic COLLECTION order and hence the queue's tiebreak — the queue's
; real key is the gate score (rank-queue).
(= (chamber-rules $ch)
   (map-snd (msort (filter-out skip (collapse (match &self (rule-priority $R $n) (if (rule-eligible-in? $ch $R) ($n $R) skip)))))))

; ALL rules ordered by rule-priority, no context filter (the raw run / structural assays)
(= (all-sorted-rules)
   (map-snd (msort (collapse (match &self (rule-priority $R $n) ($n $R))))))

; ---------------------------------------------------------------------------
; THE MORTAL GATE (MSC eq 24):
;
;   Gate_C(R,O,X) = sigma( a·logit(s_R) + b·c_R + d·DoInf_C(R) + e·Novelty_C(R)
;                          − f·Redundancy_C(R) − g·Cost(R)
;                          + h·log(1+FuelMargin(O,R)) + j·ACSBoost(R) )
;
; Terms carried: d·DoInf + j·ACSBoost + h·log(1+FuelMargin) − g·Cost. Not carried,
; each awaiting its data or its semantics: plausibility a·logit(s_R) + b·c_R (the
; genome declares no rule-tv, and whether c_R is PLN confidence or SC's rule-clarity
; is unsettled), e·Novelty (unbuilt), the scalar f·Redundancy (the scan's
; rule-redundancy verdict is a boolean), and shadow-priced cost (Cost is a flat token
; sum until prices exist). Every input is read, never presumed: an unmeasured rule
; contributes 0, an uncertified ACS boosts nothing.
; ---------------------------------------------------------------------------

; eq 24 coefficient $k, under the doc's own letters (d do-influence, g cost, h fuel
; margin, j ACS boost); undeclared = 0 = the term is OFF (TECAN Alg 5.2 is
; "intentionally modular: any term can first be a cheap heuristic"). A coefficient
; turns a propensity term on — it grants nothing: matching and payment are the other
; two eq-13 conjuncts regardless.
(= (gate-coeff-of $k)
   (case (collapse (match &self (gate-coeff $k $v) $v)) ((() 0) ($vs (car-atom $vs)))))

; any gate coefficient declared at all? with none, every score is the constant
; sigma(0) = 0.5 and ranking degenerates to collection order, so the ranker skips
(= (gate-coeffs-declared?)
   (case (collapse (match &self (gate-coeff $k $v) yes)) ((() False) ($x True))))

; the logistic squash onto (0,1)
(= (sigmoid $x) (/ 1 (+ 1 (exp (* -1 $x)))))

; natural log (log-math is log base B)
(= (ln $x) (log-math 2.718281828459045 $x))

; is fact $f (fully ground) present in &self?
(= (fact-present? $f)
   (case (collapse (match &self $f yes)) ((() False) ($x True))))

; --- d·DoInf: the rule's measured do-influence, read off the scan's verdict facts ---

; $r's measured do-influence (the leave-one-out reward drop the scan emitted). A rule
; measured over several windows reads the WIDEST window's figure (msort ascends on
; (window delta); rev-list heads the largest); an unmeasured rule reads 0.
(= (rule-doinf $r)
   (let $nds (msort (collapse (match &self (rule-do-influence $r target answer-reward $n $d) ($n $d))))
        (if (== $nds ())
            0
            (let ($nw $dw) (car-atom (rev-list $nds)) $dw))))

; --- j·ACSBoost: membership in an ESTABLISHED ACS, read off the scan's certificate ---
; eq 24: "the new j term boosts rules that belong to an established ACS". The boost flows
; through the CERTIFICATE — the conjunction of the five §4.5 condition verdicts — so it
; exists only once a scan has certified the ring the rule serves.

; does ACS $A carry a closure fact? (the scan emits one ONLY when structurally closed)
(= (closure-present? $A)
   (case (collapse (match &self (acs-closure $A $k) yes)) ((() False) ($x True))))

; the clamps $A carries surplus verdicts under
(= (surplus-clamps $A)
   (dedup (collapse (match &self (acs-surplus $A $cl $t $n) $cl))))

; every number in $ns is > 0 (vacuously True on ())
(= (all-positive? $ns)
   (case $ns
         ((() True)
          ($ne (if (> (car-atom $ns) 0) (all-positive? (cdr-atom $ns)) False)))))

; is every surplus verdict of $A under clamp $cl positive?
(= (viable-under? $A $cl)
   (all-positive? (collapse (match &self (acs-surplus $A $cl $t $n) $n))))

; viable under at least one measured clamp — NO measured clamp is refused, not presumed
(= (viable-under-some? $A $cls)
   (case $cls
         ((() False)
          ($ne (if (viable-under? $A (car-atom $cls)) True (viable-under-some? $A (cdr-atom $cls)))))))

; is $A ESTABLISHED — certified on all five §4.5 conditions? structurally closed ∧
; autocatalytic ∧ metabolically viable under some measured clamp ∧ causally
; load-bearing ∧ recurrent across tasks
(= (established-acs? $A)
   (if (closure-present? $A)
       (if (fact-present? (acs-autocatalytic $A True))
           (if (fact-present? (acs-causal-influence $A True))
               (if (fact-present? (acs-recurrent $A True))
                   (viable-under-some? $A (surplus-clamps $A))
                   False)
               False)
           False)
       False))

; does any ACS in $as certify as established?
(= (in-established? $as)
   (case $as
         ((() False)
          ($ne (if (established-acs? (car-atom $as)) True (in-established? (cdr-atom $as)))))))

; 1 iff $r belongs to an established ACS, else 0
(= (acs-boost $r)
   (if (in-established? (collapse (match &self (acs-member $A $r) $A))) 1 0))

; --- h·log(1+FuelMargin): eq 25 — the starvation axis ---

; eq 25: FuelMargin(O,R) = min over costed tokens of purse/cost, "the ratio of available
; to required fuel for whichever token the rule is most starved of". A rule with no token
; costs has no starvation axis and reads 0 (its h-term stays neutral at log 1).
(= (fuel-margin $ws $O $r)
   (let $cost (cost-of $r)
        (if (== $cost ()) 0 (margin-min $ws $O $cost))))

; the min of purse/cost over the (token n) components of $cost (non-empty)
(= (margin-min $ws $O $cost)
   (let* ((($t $n) (car-atom $cost))
          ($m (/ (fuel-of $ws $O $t) $n))
          ($rest (cdr-atom $cost)))
     (if (== $rest ()) $m (min $m (margin-min $ws $O $rest)))))

; --- g·Cost: the flat scalar cost until shadow prices exist ---

; the flat token sum of $r's cost vector (scalarizing a TYPED vector honestly is TECAN's
; shadow-priced lambda^T·kappa; with no prices every token weighs 1)
(= (flat-cost $r) (sum-snd (cost-of $r)))

; the sum of the n's over a ((token n) …) list
(= (sum-snd $ps)
   (case $ps ((() 0) ($ne (let ($t $n) (car-atom $ps) (+ $n (sum-snd (cdr-atom $ps))))))))

; --- the score + the admission conjunct ---

; Gate_C(R,O,X): organism $O's propensity to fire rule $r, against $ws's purse. One
; number, two consumers: the queue's priority key and the eq-13 admission propensity.
(= (gate-score $ws $O $r)
   (let* (($dt (* (gate-coeff-of d) (rule-doinf $r)))
          ($jt (* (gate-coeff-of j) (acs-boost $r)))
          ($ht (* (gate-coeff-of h) (ln (+ 1 (fuel-margin $ws $O $r)))))
          ($gt (* (gate-coeff-of g) (flat-cost $r))))
     (sigmoid (- (+ $dt (+ $jt $ht)) $gt))))

; MSC eq 13's third conjunct, U < Gate_C: admission against the scheduler's DETERMINISTIC
; priority threshold `(gate-threshold u)` (eq 13 sanctions "a scheduler draw or
; deterministic priority threshold"; the seeded stochastic draw is unbuilt — determinism
; keeps every ablation replay paired with its baseline). No declared threshold = no
; admission bar (TECAN Alg 5.1's fire loop pops every affordable candidate) while the
; score still orders the queue. Re-evaluated at fire time against the CURRENT purse
; (Alg 5.1 line 14), so a candidate can pass collection and die at the gate.
(= (gate-open? $ws $O $r)
   (case (collapse (match &self (gate-threshold $u) $u))
         ((() True)
          ($us (> (gate-score $ws $O $r) (car-atom $us))))))
