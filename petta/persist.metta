; ===========================================================================
; PERSIST — write MeTTa facts to a durable file via py-call (pathlib).
; ---------------------------------------------------------------------------
; repr renders each atom as its re-loadable S-expression; the lines are joined
; and written with pathlib.write_text — no shell, no runner trace to strip.
; The product is a bare-fact .metta file that import! reads straight back.
; ===========================================================================

; a list of atoms -> one newline-terminated string of re-loadable facts
(= (facts->text $atoms)
   (if (== $atoms ())
       ""
       (let* (($line (py-call (operator.add (repr (car-atom $atoms)) "\n")))
              ($rest (facts->text (cdr-atom $atoms))))
         (py-call (operator.add $line $rest)))))

; write string $s to $path, overwriting; returns $path
(= (spit $path $s)
   (let* (($p (py-call (pathlib.Path $path)))
          ($n (py-call (.write_text $p $s))))
     $path))

; write $atoms to $path as re-loadable bare facts; returns $path
(= (write-facts $path $atoms) (spit $path (facts->text $atoms)))
