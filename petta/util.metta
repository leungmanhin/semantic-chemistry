; ===========================================================================
; UTIL — generic list/term helpers. Loaded first by every consumer;
; the other petta/ modules build on these.
; ===========================================================================

; every value in the list $vs is >= $thr (vacuously True on the empty list)
(= (all-at-least? $vs $thr)
   (case $vs
         ((() True)
          ($ne (if (>= (car-atom $vs) $thr)
                   (all-at-least? (cdr-atom $vs) $thr)
                   False)))))

; drop every occurrence of $x from list $l
(= (filter-out $x $l)
   (case $l
         ((() ())
          ($ne (let $h (car-atom $l) (if (== $h $x) (filter-out $x (cdr-atom $l)) (cons-atom $h (filter-out $x (cdr-atom $l)))))))))

; append list $b onto list $a
(= (concat-lists $a $b)
   (case $a ((() $b)
             ($ne (cons-atom (car-atom $a) (concat-lists (cdr-atom $a) $b))))))

; remove the FIRST occurrence of $x from list $l (leaving any later duplicates)
(= (remove-one $x $l)
   (case $l ((() ())
             ($ne (if (== (car-atom $l) $x) (cdr-atom $l) (cons-atom (car-atom $l) (remove-one $x (cdr-atom $l))))))))

; the length of list $l
(= (len $l) (if (== $l ()) 0 (+ 1 (len (cdr-atom $l)))))

; is $x a member of list $l?
(= (in-list? $x $l) (case $l ((() False) ($ne (if (== (car-atom $l) $x) True (in-list? $x (cdr-atom $l)))))))

; drop duplicate elements, keeping first occurrences
(= (dedup $l) (if (== $l ()) () (let $h (car-atom $l) (cons-atom $h (dedup (filter-out $h (cdr-atom $l)))))))

; keep the second element of each (a b) pair in a list
(= (map-snd $l) (if (== $l ()) () (let ($n $r) (car-atom $l) (cons-atom $r (map-snd (cdr-atom $l))))))

; the elements of list $a that also appear in list $b (intersection, in $a's order)
(= (intersect $a $b)
   (case $a
         ((() ())
          ($ne (let $h (car-atom $a)
                    (if (in-list? $h $b)
                        (cons-atom $h (intersect (cdr-atom $a) $b))
                        (intersect (cdr-atom $a) $b)))))))

; does any element of list $a appear in list $b?
(= (any-in-list? $a $b)
   (case $a ((() False) ($ne (if (in-list? (car-atom $a) $b) True (any-in-list? (cdr-atom $a) $b))))))

; is $id a DERIVED edge-id? The parser mints ATOMIC ids (Symbol); the genome mints compound
; provenance ids like (norm e) / (trans e1 e2) (Expression), so a compound id marks a product.
(= (derived-id? $id) (== (get-metatype $id) Expression))

; a relation declared `(persistent R)` (in &self) is a PERSISTENT molecule: its derived edges
; are decay-exempt (they carry across cycles) and count as a self-sustaining anchor for closure.
; Shared by decay (epoch) and the ACS self-sustains guard (acs). No such fact for classic V3.
(= (persistent-rel? $r)
   (case (collapse (match &self (persistent $r) $r)) ((() False) ($x True))))
