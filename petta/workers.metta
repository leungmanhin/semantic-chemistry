; ===========================================================================
; WORKERS — the §6.4 worker DISPATCHER: route a worker to its kind's body. The
; bodies live in their own modules (chamber · reducer · …) and the shared envelope
; helpers in persist; this module is the switchboard only. Assumes the body modules
; are loaded by the consumer.
; ===========================================================================

; route a worker to its kind's body (each body lives in its own module — the consumer
; loads the body modules for the kinds it will dispatch)
(= (dispatch $w)
   (let $k (match &self (worker-kind $w $kind) $kind)
        (case $k
              ((context-chamber (run-cc $w))
               (reducer         (run-reduce $w))
               (acs-scan        (run-acs $w))
               (ecan-epoch      (run-epoch $w))
               (reproduction    (run-select $w))
               ($other          unknown-kind)))))
