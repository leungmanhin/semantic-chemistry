; ===========================================================================
; P4.4 — BACKEND-RENDERING test: the worker IR is backend-neutral (MSC §11, §6.1;
;        schema §5 checklist; eq-30 log-equivalence). Closes P4.
; ---------------------------------------------------------------------------
; The worker IR is plain portable facts — (worker …)/(worker-kind …)/(worker-
; snapshot …)/(snapshot-fuel …)/(worker-budget-steps …)/(worker-backend …) — with
; NO backend-private state (hard prohibition #3). This file shows that the SAME IR:
;   (a) renders to a backend-NEUTRAL call spec, identical under a `petta` tag and a
;       `metta-il` tag (only the executor differs, not the logical computation) —
;       the eq-30 idea: Log_PeTTa(W,SNAP,seed,budget) ≡ Log_MeTTaIL(W,SNAP,seed,budget);
;   (b) satisfies the §5 backend-neutrality checklist (deterministic step budget,
;       not wall-clock; backend provenance recorded; §6.4 contract honoured);
;   (c) drives the PeTTa backend to exactly the log it specifies (IR -> backend -> log).
; We have only the PeTTa executor today, so the metta-il side is the rendered SPEC,
; not a run; the standing Python≡PeTTa log-equivalence is eq-30 one rung down.
;
; Run:  sh ../PeTTa/run.sh petta/backend_render.metta < /dev/null \
;          2>&1 | grep should   # six ✅
; ===========================================================================
!(import! &self "petta/causal_qa_rules.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")

; --- one snapshot, two workers — IDENTICAL IR except the backend tag ------------
!(bind! &ws_p (new-space))
!(add-atom &self (worker W_p))
!(add-atom &self (worker-kind W_p context-chamber))
!(add-atom &self (worker-backend W_p petta))
!(add-atom &self (worker-snapshot W_p SNAP))
!(add-atom &self (worker-budget-steps W_p 999))
!(add-atom &self (worker-space W_p &ws_p))
!(add-atom &self (worker W_il))
!(add-atom &self (worker-kind W_il context-chamber))
!(add-atom &self (worker-backend W_il metta-il))
!(add-atom &self (worker-snapshot W_il SNAP))
!(add-atom &self (worker-budget-steps W_il 999))
!(add-atom &self (snapshot-fuel SNAP gm 20))
!(add-atom &self (snapshot-fuel SNAP ci 6))

; --- (a) render the BACKEND-NEUTRAL call spec from the IR (the backend tag is NOT
;         part of the logical spec — only provenance) ----------------------------
(= (snapshot-fuel-of $snap) (collapse (match &self (snapshot-fuel $snap $t $n) (fuel $t $n))))
(= (render-spec $w) (let $snap (match &self (worker-snapshot $w $s) $s) (let $steps (match &self (worker-budget-steps $w $n) $n) (chamber-run $snap (snapshot-fuel-of $snap) $steps))))
!(test (== (render-spec W_p) (render-spec W_il)) True)   ; SAME IR -> SAME logical spec under either backend (eq-30)

; --- (b) §5 backend-neutrality checklist ----------------------------------------
(= (has-fact $pat) (case (collapse (match &self $pat yes)) ((() False) ($a True))))
!(test (has-fact (worker-budget-steps W_p $n)) True)     ; deterministic budget present (replayable)
!(test (has-fact (worker-budget-ms W_p $n)) False)       ; NOT a wall-clock replay budget (schema §4)
!(test (match &self (worker-backend W_p $b) $b) petta)   ; provenance: which executor produced the log
!(test (match &self (worker-backend W_il $b) $b) metta-il)

; --- (c) drive the PeTTa backend FROM the IR -> the log the IR specifies ---------
(= (seed-from-snapshot $w $ws) (let $snap (match &self (worker-snapshot $w $s) $s) (add-all $ws (collapse (match &self (snapshot-fuel $snap $t $n) (fuel $t $n))))))
(= (run-petta $w) (let $ws (match &self (worker-space $w $sp) $sp) (let $z (seed-from-snapshot $w $ws) (let $r (run $ws) (foldall + (match $ws (event $s $rule $k) 1) 0)))))
!(test (run-petta W_p) 20)   ; the PeTTa executor reproduces the P0 mortal log (20 firings) from the portable IR
