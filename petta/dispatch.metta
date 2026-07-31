; ===========================================================================
; DISPATCH — the §6.4 worker DISPATCHER: route a worker to its kind's body. The bodies live
; in their own modules (`chamber` = context-chamber, `ecan` = ecan-epoch, `reducer` =
; reducer, `acs` = acs-scan's `run-as`, `evaluator` = evaluator's `run-eval`,
; `ctrl_scaffold` = ctrl-scaffold's `run-cs`); the shared envelope is in `worker`. This module
; is the switchboard only. Assumes the body modules for the kinds it will dispatch are
; loaded by the consumer.
; ===========================================================================

; route worker $w to its kind's body (context-chamber -> run-cc; ecan-epoch -> run-ee;
; reducer -> run-reduce; acs-scan -> run-as; evaluator -> run-eval; ctrl-scaffold -> run-cs)
(= (dispatch $w)
   (case (match &self (worker-kind $w $k) $k)
         ((context-chamber (run-cc $w))
          (ecan-epoch (run-ee $w))
          (reducer (run-reduce $w))
          (acs-scan (run-as $w))
          (evaluator (run-eval $w))
          (ctrl-scaffold (run-cs $w))
          ($other (unknown-worker-kind $w)))))
