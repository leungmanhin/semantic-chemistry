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

; drop every element of list $xs from list $l
(= (filter-out-all $xs $l)
   (case $xs ((() $l)
              ($ne (filter-out-all (cdr-atom $xs) (filter-out (car-atom $xs) $l))))))

; remove the FIRST occurrence of $x from list $l (leaving any later duplicates)
(= (remove-one $x $l)
   (case $l ((() ())
             ($ne (if (== (car-atom $l) $x) (cdr-atom $l) (cons-atom (car-atom $l) (remove-one $x (cdr-atom $l))))))))

; remove every (already-ground) atom in list $atoms from space $ws. Each list is collapsed
; BEFORE removal by the caller, so the space is not matched while it is being mutated.
(= (remove-all $ws $atoms)
   (case $atoms
         ((() done)
          ($ne (let* (($h (car-atom $atoms))
                      ($z (remove-atom $ws $h)))
                 (remove-all $ws (cdr-atom $atoms)))))))

; the length of list $l
(= (len $l) (if (== $l ()) 0 (+ 1 (len (cdr-atom $l)))))

; list $l back to front. NOT named `reverse` — that collides with the SWI-Prolog builtin
; `reverse/2` the transpiler would emit, which silently kills every def after it in this file.
(= (rev-list $l) (rev-onto $l ()))
(= (rev-onto $l $acc) (if (== $l ()) $acc (rev-onto (cdr-atom $l) (cons-atom (car-atom $l) $acc))))

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

