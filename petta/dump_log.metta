; ===========================================================================
; DUMP-LOG — persist a run's event log to a file (re-loadable (event …) facts).
; ---------------------------------------------------------------------------
; PeTTa has no MeTTa-level file write, so persistence = println! the log (sorted by
; firing sequence) + a shell redirect: petta/dump_log.sh strips the runner's trace and
; writes the clean facts to runs/<log-id>.metta. This harness runs the P0 chamber to
; fixpoint (ample fuel) and dumps &self's event log; a worker could dump its own space
; the same way (log-events / print-log are generic over any space).
;
; Run (produces a file):  sh petta/dump_log.sh [output_path]
; ===========================================================================
!(import! &self "petta/kernel.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")

; the event log of a space, sorted by firing sequence (Seq is the first tuple element)
(= (log-events $ws) (msort (collapse (match $ws (event $s $r $k) ($s $r $k)))))

; print each firing as a re-loadable bare (event Seq Rule Key) fact, one per line
(= (print-log $l)
   (if (== $l ())
       done
       (let* ((($s $r $k) (car-atom $l))
              ($z (println! (event $s $r $k))))
         (print-log (cdr-atom $l)))))

!(add-atom &self (fuel O_qa gm 100))
!(add-atom &self (fuel O_qa ci 100))
!(run-rules &self)
!(print-log (log-events &self))
