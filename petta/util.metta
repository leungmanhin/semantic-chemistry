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

; the length of list $l
(= (len $l) (if (== $l ()) 0 (+ 1 (len (cdr-atom $l)))))

; is $x a member of list $l?
(= (in-list? $x $l) (case $l ((() False) ($ne (if (== (car-atom $l) $x) True (in-list? $x (cdr-atom $l)))))))

; drop duplicate elements, keeping first occurrences
(= (dedup $l) (if (== $l ()) () (let $h (car-atom $l) (cons-atom $h (dedup (filter-out $h (cdr-atom $l)))))))

; keep the second element of each (a b) pair in a list
(= (map-snd $l) (if (== $l ()) () (let ($n $r) (car-atom $l) (cons-atom $r (map-snd (cdr-atom $l))))))
