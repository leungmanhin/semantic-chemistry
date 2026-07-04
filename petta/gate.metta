; ===========================================================================
; GATE — the per-candidate fire DECISION (MSC eq 24 / schema §3 step 3): fold
; context eligibility + affordability + attention into one Gate(R,O,X); plus the
; eligible-and-priority-sorted rule list a run walks. Assumes util + fuel are
; loaded, and the growth home for attention dynamics (decay/rent/spread).
; Facts-free.
; ===========================================================================

; --- typed ATTENTION state (schema §2.4) + the attention gate. `(attention R tok v)`
; is a rule-level attention level (the TECAN-typed analogue of ECAN STI). A rule with
; no attention fact passes vacuously; one that declares attention passes iff every
; declared level is >= the threshold. Attention dynamics are not modelled here, so on
; Exp-1 (no attention facts) `attn-ok?` always holds.
(= (attn-threshold) 1)

; does rule $R clear the attention threshold? (vacuously True when it has no attention fact)
(= (attn-ok? $R)
   (all-ge (collapse (match &self (attention $R $tok $v) $v)) (attn-threshold)))

; --- context gate (MSC §3 step 1): a rule is eligible in the chamber iff its rule-context
; is among the chamber's chamber-context facts (context-subsumption). A rule with NO
; rule-context is unconstrained (always eligible). Only ELIGIBLE rules reach the priority
; walk (fuel then gates each firing).

; is context $c active, i.e. declared as some chamber's chamber-context?
(= (ctx-active? $c) (case (collapse (match &self (chamber-context $ch $c) yes)) ((() False) ($x True))))

; the contexts rule $R declares
(= (rule-contexts $R) (collapse (match &self (rule-context $R $c) $c)))

; is any context in $cs active?
(= (any-active? $cs) (case $cs ((() False) ($ne (if (ctx-active? (car-atom $cs)) True (any-active? (cdr-atom $cs)))))))

; is rule $R licensed here? unconstrained when it declares no context, else eligible
; iff one of its contexts is active
(= (rule-eligible? $R)
   (let $cs (rule-contexts $R)
        (if (== $cs ())
            True
            (any-active? $cs))))

; --- the computed GATE `Gate_C(R,O,X)` (MSC eq 24): the single fire-decision for a
; candidate, folding context eligibility + affordability + attention. Additional eq-24
; factors (do-influence / novelty / −redundancy / +FuelMargin / +ACSBoost) are not
; modelled here. On Exp-1 it reduces to `afford` (context pre-filtered by sorted-rules,
; attention vacuous).
(= (gate? $ws $O $R $cost)
   (if (rule-eligible? $R)
       (if (afford $ws $O $cost)
           (attn-ok? $R)
           False)
       False))

; the eligible rules, ordered by rule-priority (ineligible ones drop out as `skip`)
(= (sorted-rules)
   (map-snd (msort (filter-out skip
                               (collapse (match &self (rule-priority $R $n)
                                                (if (rule-eligible? $R) ($n $R) skip)))))))
