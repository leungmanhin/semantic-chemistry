; ===========================================================================
; GATE — context admission + the per-firing fire DECISION. Context admission (MSC §3
; step 1) selects a chamber's rules by context-subsumption (`chamber-rules`); the
; per-firing gate `Gate(R,O,X)` (MSC eq 24 / §3 step 3) folds affordability + attention.
; Assumes util + fuel are loaded, and the growth home for attention dynamics
; (decay/rent/spread).
; ===========================================================================

; --- typed ATTENTION state (schema §2.4) + the attention gate. `(attention R tok v)`
; is a rule-level attention level (the TECAN-typed analogue of ECAN STI). A rule with
; no attention fact passes vacuously; one that declares attention passes iff every
; declared level is >= the threshold. Attention dynamics are not modelled here, so
; `in-attn?` always holds for now.
(= (attn-threshold) 1)

; is rule $r in the attentional focus, i.e. does it clear the attention threshold?
; (vacuously True when it has no attention fact)
(= (in-attn? $r)
   (all-at-least? (collapse (match &self (attention $r $tok $v) $v)) (attn-threshold)))

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

; --- the per-firing GATE `Gate(R,O,X)` (MSC eq 24 / §3 step 3): the fuel + attention
; decision for one candidate (context is already settled at admission). Additional eq-24
; factors (do-influence / novelty / −redundancy / +FuelMargin / +ACSBoost) are not
; modelled here. It reduces to `afford?` for now.
(= (gate? $ws $O $R $cost)
   (if (afford? $ws $O $cost)
       (in-attn? $R)
       False))

; chamber $ch's admitted rules, ordered by rule-priority (non-admitted drop out as `skip`)
(= (chamber-rules $ch)
   (map-snd (msort (filter-out skip (collapse (match &self (rule-priority $R $n) (if (rule-eligible-in? $ch $R) ($n $R) skip)))))))

; ALL rules ordered by rule-priority, no context filter (the raw run / structural assays)
(= (all-sorted-rules)
   (map-snd (msort (collapse (match &self (rule-priority $R $n) ($n $R))))))
