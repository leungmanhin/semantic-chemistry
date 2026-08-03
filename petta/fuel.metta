; ===========================================================================
; FUEL — the per-organism typed-fuel LEDGER + organism-purse resolution. A purse
; is `(fuel O tok n)` (schema §2.3): afford?/debit read and write the firing
; organism's own purse; a rule's organism is resolved by ruleset membership.
; This is the metabolic substrate the reaction engine spends on, and the growth
; home for the token economy (inter-organism flow, rent, shadow prices).
; ===========================================================================

; the balance of token $t that organism $O holds in space $ws
; $O's balance of token $t — ZERO when it holds no such fact. A bare `match` would return
; EMPTY there, and the emptiness propagates through `afford?` instead of deciding it, so an
; organism that has simply never held a token would neither afford nor fail to.
; does organism $O hold a balance FACT in token $t? (distinct from `fuel-of` = 0, which is what a
; spent purse also reads: this asks whether the purse exists at all)
(= (has-fuel? $ws $O $t)
   (case (collapse (match $ws (fuel $O $t $n) yes)) ((() False) ($x True))))

(= (fuel-of $ws $O $t)
   (case (collapse (match $ws (fuel $O $t $n) $n)) ((() 0) ($ns (car-atom $ns)))))

; can $O pay the whole cost vector? — True iff every (token n) is affordable componentwise
(= (afford? $ws $O $cost)
   (case $cost
         ((() True)
          ($ne (let ($t $n)
                    (car-atom $cost)
                    (if (>= (fuel-of $ws $O $t) $n)
                        (afford? $ws $O (cdr-atom $cost))
                        False))))))

; spend $k of token $t from $O's purse (replace the old balance with the reduced one)
(= (debit $ws $O $t $k)
   (let* (($n (fuel-of $ws $O $t))
          ($z (remove-atom $ws (fuel $O $t $n)))
          ($m (- $n $k)))
     (add-atom $ws (fuel $O $t $m))))

; spend a whole cost vector from $O's purse (debit each component in turn)
(= (debit-all $ws $O $cost)
   (case $cost
         ((() done)
          ($ne (let* ((($t $n) (car-atom $cost))
                      ($z (debit $ws $O $t $n)))
                 (debit-all $ws $O (cdr-atom $cost)))))))

; credit $m of token $t to $O's purse; a purse that does not exist yet is CREATED
; (an organism can earn a token type it never held)
(= (credit $ws $O $t $m)
   (case (collapse (match $ws (fuel $O $t $n) $n))
         ((() (add-atom $ws (fuel $O $t $m)))
          ($ns (let* (($n (car-atom $ns))
                      ($z (remove-atom $ws (fuel $O $t $n)))
                      ($tot (+ $n $m)))
                 (add-atom $ws (fuel $O $t $tot)))))))

; --- ORGANISM resolution (schema §2.3): which mortal organism fires a rule, and
; so whose purse pays. A rule maps to its organism via ruleset membership
; (ruleset-member RS R · quoted-ruleset GNM RS · genome-of O GNM); a rule owned by
; no ruleset resolves to O_none — no purse, so it cannot afford to fire.

; all declared organisms
(= (organisms)
   (collapse (match &self (organism $o) $o)))

; the organism whose genome quotes ruleset $rs
(= (owner-of-ruleset $rs)
   (match &self (quoted-ruleset $gnm $rs) (match &self (genome-of $o $gnm) $o)))

; the organism that fires rule $r — via ruleset membership; O_none when the rule is
; owned by no ruleset (an unowned rule has no purse and so cannot fire)
(= (rule-organism $r)
   (let $os (collapse (match &self (ruleset-member $rs $r) (owner-of-ruleset $rs)))
        (if (== $os ()) O_none (car-atom $os))))

; --- STRUCTURAL-assay seeding: a replay/fitness assay runs a genome with generous fuel
; so its outcome exhibits STRUCTURE (which rules matter), not starvation. The token
; alphabet comes from the loaded genome's own cost vectors — no token is named here.

; the distinct tokens the loaded genome's rules spend
(= (genome-tokens)
   (dedup (collapse (match &self (rule-token-cost $r $tok $n) $tok))))

; seed $amt of every token in $toks into organism $O's purse in $sp
(= (seed-purse $sp $O $toks $amt)
   (if (== $toks ()) done
       (let* (($t (car-atom $toks))
              ($z (add-atom $sp (fuel $O $t $amt))))
         (seed-purse $sp $O (cdr-atom $toks) $amt))))

; seed every organism in $orgs with $amt of every genome token (the assay endowment)
(= (seed-assay $sp $orgs $amt)
   (if (== $orgs ())
       done
       (let* (($O (car-atom $orgs))
              ($z (seed-purse $sp $O (genome-tokens) $amt)))
         (seed-assay $sp (cdr-atom $orgs) $amt))))
