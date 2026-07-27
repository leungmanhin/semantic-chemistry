; Experiment 1 — CONTROL GENOME: the same causal-QA derivation, re-expressed as a loop that
; sustains its own activation. The substrate rules (`_rf` = derives ReasonFor) are GATED on an
; internal `Primed` state, and three control rules turn a successful derivation back into that
; state, closing the ring
;   Primed -> ReasonFor -> Worked -> Habit -> Primed
; which regenerates both semantic and control motifs — closure at the HYBRID level (§4.5 cond 1).
; R_detect + R_explore sit OUTSIDE the ring: they convert an arriving question into the FIRST
; Primed, paid in `ex` (the exploration welfare the evaluator never mints), so once that endowment
; is spent the ring is the strategy's only life support.
;
; Firing order matters: the engine walks a chamber's rules ONCE per cycle in priority order, so
; R_prime runs FIRST — the habit re-primes the strategy at the top of the cycle, before the
; substrate rules look for Primed.
;
; The substrate products keep the plain (norm E) / (trans E1 E2) provenance ids of an ungated
; derivation: the gate must NOT enter the id, or the evaluator's depth-based achievement typing
; would read a one-hop answer as a chain. Control states carry FIXED compound ids — one state per
; strategy per cycle, not one per match, so a control rule costs one firing however many matches
; it has — and no TV: they are states, not truth-bearing claims. The strategy-generic scaffold
; (R_explore/R_learn/R_prime) keeps the strategy as (var s); the rules that are specific to this
; strategy name `cause-strat` outright.
; Tokens: sm = skeleton-match fuel, tr = transitive-explanation fuel, ex = exploration welfare.

; --- R_prime: the consolidated habit re-primes the strategy — THE closing edge ---------
(rule-context    R_prime control-qa)
(rule-priority   R_prime 0)
(rule-token-cost R_prime sm 1)
(rule-lhs R_prime ((sem-edge ctrlg (var h) Habit (var s))))
(rule-rhs R_prime ((sem-edge ctrlg (pr (var s)) Primed (var s))))

; --- R_detect: an arriving why-question routes to the causal strategy (food intake) -----
(rule-context    R_detect control-qa)
(rule-priority   R_detect 1)
(rule-token-cost R_detect sm 1)
(rule-lhs R_detect ((sem-edge ctrlg (var e) WhyQuestion (var q))))
(rule-rhs R_detect ((sem-edge ctrlg (att (var e)) Attempting (var q) cause-strat)))

; --- R_explore: effortful cold spin-up, paid out of the exploration endowment -----------
(rule-context    R_explore control-qa)
(rule-priority   R_explore 2)
(rule-token-cost R_explore ex 1)
(rule-lhs R_explore ((sem-edge ctrlg (var a) Attempting (var q) (var s))))
(rule-rhs R_explore ((sem-edge ctrlg (exp (var s)) Primed (var s))))

; --- R_so_rf: "X, so Y" — fires only while the strategy is primed ----------------------
(rule-context    R_so_rf control-qa)
(rule-priority   R_so_rf 3)
(rule-token-cost R_so_rf sm 1)
(rule-lhs R_so_rf ((sem-edge ctrlg (var p) Primed cause-strat)
                   (sem-edge (var g) (var e) So (var x) (var y))
                   (sem-edge-tv (var g) (var e) (var tv))))
(rule-rhs R_so_rf ((sem-edge (var g) (norm (var e)) ReasonFor (var x) (var y))
                   (sem-edge-tv (var g) (norm (var e)) (var tv))))

; --- R_result_rf: "X, and as a result Y" — likewise gated ------------------------------
(rule-context    R_result_rf control-qa)
(rule-priority   R_result_rf 4)
(rule-token-cost R_result_rf sm 1)
(rule-lhs R_result_rf ((sem-edge ctrlg (var p) Primed cause-strat)
                       (sem-edge (var g) (var e) AsAResult (var x) (var y))
                       (sem-edge-tv (var g) (var e) (var tv))))
(rule-rhs R_result_rf ((sem-edge (var g) (norm (var e)) ReasonFor (var x) (var y))
                       (sem-edge-tv (var g) (norm (var e)) (var tv))))

; --- R_trans_rf: reasons chain — the reason of my reason explains me too ---------------
(rule-context    R_trans_rf control-qa)
(rule-priority   R_trans_rf 5)
(rule-token-cost R_trans_rf sm 1)
(rule-token-cost R_trans_rf tr 1)
(rule-lhs R_trans_rf ((sem-edge ctrlg (var p) Primed cause-strat)
                      (sem-edge (var g) (var e1) ReasonFor (var x) (var y))
                      (sem-edge (var g) (var e2) ReasonFor (var y) (var z))
                      (sem-edge-tv (var g) (var e1) (var tv))))
(rule-rhs R_trans_rf ((sem-edge (var g) (trans (var e1) (var e2)) ReasonFor (var x) (var z))
                      (sem-edge-tv (var g) (trans (var e1) (var e2)) (var tv))))

; --- R_worked: a derived explanation IS the success trace ------------------------------
; It fires on the DERIVATION, never on an evaluator verdict — the soma may not read its own
; reward. A ReasonFor edge carries no strategy provenance, so the trace names cause-strat here.
(rule-context    R_worked control-qa)
(rule-priority   R_worked 6)
(rule-token-cost R_worked sm 1)
(rule-lhs R_worked ((sem-edge (var g) (var e) ReasonFor (var x) (var y))))
(rule-rhs R_worked ((sem-edge ctrlg (wk cause-strat) Worked cause-strat)))

; --- R_learn: the success trace consolidates into a habit (a persistent motif) ---------
(rule-context    R_learn control-qa)
(rule-priority   R_learn 7)
(rule-token-cost R_learn sm 1)
(rule-lhs R_learn ((sem-edge ctrlg (var w) Worked (var s))))
(rule-rhs R_learn ((sem-edge ctrlg (hb (var s)) Habit (var s))))
