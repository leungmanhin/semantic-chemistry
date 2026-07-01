; ===========================================================================
; The MORTAL ENGINE in PeTTa (TECAN T7) — fuel-gated firing loop + event log.
; ---------------------------------------------------------------------------
; This file isolates the ENGINE mechanism: typed fuel as `(fuel TOKEN N)` facts; a
; candidate fires only if affordable; firing DEBITS fuel (remove+add), LOGS an
; `(event seq rule …)`, and recurses; the loop STARVES when fuel runs out — i.e.
; the mortal death (a fuel-gated loop stopping on starvation). State mutation via
; add/remove-atom in &self; recursion drives the steps; `car-atom`/`cdr-atom` walk
; the candidate list; arithmetic gates on fuel.
;
; Demonstrated on R_qtype with only 4 fuel for 6 questions → it fires 4, debits
; to 0, logs 4 events, and STARVES (2 questions left untyped). Verified below.
;
; The unified loop over ALL the rules — re-enumerate candidates, walk them in
; (priority, rule, key) order, fuel-gate + fire, recurse — IS the engine's generic
; `run-rules` (kernel.metta). This file isolates the bare fuel-gated mechanism
; on a single rule (R_qtype), for clarity / as a regression guard on the primitive.
;
; Run:  sh ../PeTTa/run.sh tests/engine_test.metta < /dev/null \
;          2>&1 | grep should     # three ✅
; ===========================================================================
!(import! &self "experiments/expt1-causal-qa/load.metta")

; typed fuel as a fact — seed only 4 (for 6 questions) so it STARVES
!(add-atom &self (fuel gm 4))
(= (fuelof $tok) (match &self (fuel $tok $n) $n))
(= (debit $tok $k) (let* (($n (fuelof $tok)) ($z (remove-atom &self (fuel $tok $n))) ($m (- $n $k))) (add-atom &self (fuel $tok $m))))

; R_qtype candidates (canonical-sorted) ; fire one = add product + debit + log event
(= (qtype-cands) (collapse (match &self (qa-question $t $q) (match &self (q-word $q $w) (match &self (intent-map $w $i) (qt $q $i))))))
(= (fire-qt $q $i $seq) (let* (($a (add-atom &self (q-intent $q $i))) ($b (debit gm 1))) (add-atom &self (event $seq R_qtype $q))))

; the fuel-gated loop: walk candidates; fire each while affordable; STARVE when not
(= (walk $list $seq) (case $list ((() $seq) ($ne (if (>= (fuelof gm) 1) (let* (((qt $q $i) (car-atom $list)) ($z (fire-qt $q $i $seq))) (walk (cdr-atom $list) (+ $seq 1))) $seq)))))
!(walk (msort (qtype-cands)) 0)

; --- verify the mortal behaviour: starvation (mortal death) -----------------
!(test (foldall + (match &self (q-intent $q $i) 1) 0) 4)        ; fired exactly 4 (then starved)
!(test (fuelof gm) 0)                                            ; fuel exhausted (death by starvation)
!(test (foldall + (match &self (event $s R_qtype $q) 1) 0) 4)   ; 4 events logged
