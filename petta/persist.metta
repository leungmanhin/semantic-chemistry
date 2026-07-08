; ===========================================================================
; PERSIST — the worker OUTPUT contract: write MeTTa facts to a durable file via
; py-call (pathlib), plus the §6.4 envelope helpers a worker body uses to emit its
; ordered event log + summary facts. `repr` renders each atom to a re-loadable
; S-expression; the product is a bare-fact .metta file that `import!` reads back.
; Assumes fuel + reaction are loaded (emit-summary reads the purse; persist-log
; reads the event log).
; ===========================================================================

; --- the write primitive: a list of atoms -> a re-loadable .metta file ---

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
(= (write-facts $path $atoms)
   (spit $path (facts->text $atoms)))

; --- the §6.4 worker-output envelope (used by every worker body) ---

; the file path for a log id: runs/<log-id>.metta
(= (log-path $logid)
   (py-call (operator.add (py-call (operator.add "runs/" (repr $logid))) ".metta")))

; persist worker $w's ordered event log (§6.4 output) from space $ws to
; runs/<log-id>.metta, iff it declares a worker-output-log destination; otherwise a
; no-op (logless workers stay hermetic)
(= (persist-log $w $ws)
   (let $ids (collapse (match &self (worker-output-log $w $logid) $logid))
        (if (== $ids ())
            no-output-log
            (write-facts (log-path (car-atom $ids)) (log-facts $ws)))))

; persist an explicit list of $facts (a worker's summary/verdict output) to
; runs/<id>.metta iff the worker declares a worker-output-facts destination;
; otherwise a no-op (hermetic by default, like persist-log)
(= (persist-facts $w $facts)
   (let $ids (collapse (match &self (worker-output-facts $w $id) $id))
        (if (== $ids ())
            no-output-facts
            (write-facts (log-path (car-atom $ids)) $facts))))

; the §6.4 worker summary goes to &self, keyed by worker: total firings / answers, plus
; each organism's leftover purse per token (one organism may starve while another survives)
(= (emit-summary $w $ws)
   (let* (($f (foldall + (match $ws (event $s $r $k) 1) 0))
          ($z1 (add-atom &self (worker-summary $w firings $f)))
          ($a (foldall + (match $ws (candidate-answer $q $an) 1) 0))
          ($z2 (add-atom &self (worker-summary $w answers $a))))
     (emit-fuel-left $w $ws)))

; emit one (worker-summary $w fuel $O $t $g) per organism-token purse left in $ws
(= (emit-fuel-left $w $ws)
   (emit-purses $w (collapse (match $ws (fuel $O $t $g) ($O $t $g)))))

(= (emit-purses $w $ps)
   (if (== $ps ())
       done
       (let* ((($O $t $g) (car-atom $ps))
              ($z (add-atom &self (worker-summary $w fuel $O $t $g))))
         (emit-purses $w (cdr-atom $ps)))))
