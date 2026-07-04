; ===========================================================================
; FUEL — the per-organism typed-fuel LEDGER + organism-purse resolution. A purse
; is `(fuel O tok n)` (schema §2.3): afford/debit read and write the firing
; organism's own purse; a rule's organism is resolved by ruleset membership.
; This is the metabolic substrate the reaction engine spends on, and the growth
; home for the token economy (inter-organism flow, rent, shadow prices).
; Facts-free.
; ===========================================================================

; the balance of token $t that organism $O holds in space $ws
(= (fuelof $ws $O $t)
   (match $ws (fuel $O $t $n) $n))

; spend $k of token $t from $O's purse (replace the old balance with the reduced one)
(= (debit $ws $O $t $k)
   (let* (($n (fuelof $ws $O $t))
          ($z (remove-atom $ws (fuel $O $t $n)))
          ($m (- $n $k)))
     (add-atom $ws (fuel $O $t $m))))

; can $O pay the whole cost vector? — True iff every (token n) is affordable componentwise
(= (afford $ws $O $cost)
   (case $cost
         ((() True)
          ($ne (let ($t $n)
                    (car-atom $cost)
                    (if (>= (fuelof $ws $O $t) $n)
                        (afford $ws $O (cdr-atom $cost))
                        False))))))

; spend a whole cost vector from $O's purse (debit each component in turn)
(= (debit-all $ws $O $cost)
   (case $cost
         ((() done)
          ($ne (let* ((($t $n) (car-atom $cost))
                      ($z (debit $ws $O $t $n)))
                 (debit-all $ws $O (cdr-atom $cost)))))))

; --- ORGANISM resolution (schema §2.3): which mortal organism fires a rule, and
; so whose purse pays. A rule maps to its organism via ruleset membership
; (ruleset-member RS R · quoted-ruleset GNM RS · genome-of O GNM); a rule in no
; ruleset falls back to the sole declared organism. `the-organism` is the generic
; single-organism accessor used by single-purse accounting.

; all declared organisms
(= (organisms) (collapse (match &self (organism $o) $o)))

; the sole organism (single-organism accessor); O_none when none is declared
(= (the-organism)
   (let $os (organisms)
        (if (== $os ())
            O_none
            (car-atom $os))))

; the organism whose genome quotes ruleset $rs
(= (owner-of-ruleset $rs)
   (match &self (quoted-ruleset $gnm $rs) (match &self (genome-of $o $gnm) $o)))

; the organism that fires rule $R — via ruleset membership, falling back to the sole organism
(= (rule-organism $R)
   (let $os (collapse (match &self (ruleset-member $rs $R) (owner-of-ruleset $rs)))
        (if (== $os ()) (the-organism) (car-atom $os))))
