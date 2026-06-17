; ===========================================================================
; P4.3 (i) — ecan-epoch WORKER: the P1 metabolic-closure loop (TECAN T2 loop).
; ---------------------------------------------------------------------------
; The first multi-run worker kind. An epoch = [chamber phase: run the kernel to
; quiescence/starvation on $ws] -> [evaluator phase: score the NEW answers by
; eq-17 Match, mint typed fuel by the active clamp, CREDIT it back into $ws's
; fuel ledger] -> repeat while there is progress AND fresh fuel. This is what
; turns the P0 feed-forward chain into a self-sustaining mortal ACS: the fuel an
; answer mints funds answering the next question (metabolic closure, §4.5 cond 1).
;
; Relies on the re-run-safe kernel (kernel_defs.metta: fire-once `walk` + run-from)
; so an epoch re-enters the chamber without redoing fired work. Evaluator is the
; $ws-parameterized eq-17 Match from evaluator.metta (here crediting gm directly,
; not via the tau_* ledger). Clamp = CL_antecedent (rewards physical-cause + abstain).
;
; Demonstration (constrained CLOSURE seed gm=15): feedback OFF (one pass, no mint)
; starves; feedback ON (the epoch loop) earns fuel by answering and reaches more
; answers. ON > OFF == "minting funds further computation" (cf. src/evaluator.py).
;
; Run:  sh ../PeTTa/run.sh petta/ecan_epoch.metta < /dev/null \
;          2>&1 | grep should   # six ✅ (OFF: 1 answer, starved gm=0 | ON: 7 answers, surplus gm=19)
; ===========================================================================
!(import! &self "petta/causal_qa_rules.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")
!(import! &self "petta/evaluator_defs.metta")  ; covered/anssize/skelsize/would-mint/gm-income/gm-spend/count-answers

; --- the eq-17 Match mint under the CL_antecedent clamp = would-mint at physical-cause
(= (gm-mint $ws $q $cls) (would-mint $ws $q $cls physical-cause))

; --- credit minted gm back to the fuel ledger (evaluator-side, NOT a soma firing)
(= (credit-gm $ws $m) (let $n (fuelof $ws gm) (let $z (remove-atom $ws (fuel gm $n)) (let $tot (+ $n $m) (add-atom $ws (fuel gm $tot))))))

; --- the unscored candidate-answers (as (ans Q CLS)); score-credit-mark each once
(= (unscored $ws) (filter-out skip (collapse (match $ws (candidate-answer $q (a $q $cls)) (case (collapse (match $ws (scored (a $q $cls)) yes)) ((() (ans $q $cls)) ($any skip)))))))
(= (credit-one $ws $q $cls) (let $m (gm-mint $ws $q $cls) (let $z1 (add-atom $ws (scored (a $q $cls))) (let $z2 (credit-gm $ws $m) $m))))
(= (credit-all $ws $as) (case $as ((() 0) ($ne (let (ans $q $cls) (car-atom $as) (let $m (credit-one $ws $q $cls) (+ $m (credit-all $ws (cdr-atom $as)))))))))

(= (count-events $ws) (foldall + (match $ws (event $s $r $k) 1) 0))
; (count-answers from evaluator_defs)

; --- THE EPOCH LOOP: run -> score+mint+credit new -> re-run while progress + fuel
(= (epoch $ws) (let $seq0 (count-events $ws) (let $z (run-from $ws $seq0) (let $new (unscored $ws) (let $cr (credit-all $ws $new) (if (== $new ()) done (if (> $cr 0) (epoch $ws) done)))))))

; --- feedback OFF: one pass, no minting (P0 baseline at the constrained seed) ---
!(bind! &ws_off (new-space))
!(add-atom &ws_off (fuel gm 15))
!(add-atom &ws_off (fuel ci 20))
!(run &ws_off)
!(test (count-answers &ws_off) 1)     ; OFF: starves at the constrained seed -> 1 answer only
!(test (count-events &ws_off) 15)     ; spent all 15 gm
!(test (fuelof &ws_off gm) 0)         ; ...and died (no minting to replenish)

; --- feedback ON: the epoch loop credits minted fuel back (metabolic closure) ---
!(bind! &ws_on (new-space))
!(add-atom &ws_on (fuel gm 15))
!(add-atom &ws_on (fuel ci 20))
!(epoch &ws_on)
!(test (count-answers &ws_on) 7)      ; ON: the epoch loop reaches ALL answers (incl. Q7b, which P0 starved)
!(test (count-events &ws_on) 21)      ; +6 firings the seed alone could not afford
!(test (fuelof &ws_on gm) 19)         ; ...ending in metabolic SURPLUS (minted >> spent) = self-sustaining
