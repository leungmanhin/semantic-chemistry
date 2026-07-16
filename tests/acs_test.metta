; ===========================================================================
; ACS TEST — P2 mortal-ACS detection on V3 (TECAN T3 / Alg 5.5 step 2 / MSC eq 18-19):
; the motif-keyed reaction graph (COMPOSITE motifs, UNIFICATION-matched), the food-generated
; reflexively-autocatalytic loop {R_so, R_result, R_trans}, and the clamp-switch on surplus.
; ---------------------------------------------------------------------------
; One chamber run (seed tr=1 so R_trans fires once) supplies the event log + derived layer.
; The miner keys the graph on the MOTIF — a rule's whole reactant/product PATTERN (composite,
; shared vars kept), matched producer→reactant by UNIFICATION. The set is FOOD-FED: the minting
; edge is FOOD, not closure, so V3 gets NO acs-closure fact — a subsidized candidate (R_so/
; R_result are feed-forward cue-converters; only R_trans is endo-cyclic), its subsidy read off
; as surplus-but-no-closure. Membership + closure are clamp-independent;
; only PROMOTION flips — CL_deep surplus (sm +1, tr +1) → promoted; CL_shallow
; (sm +1, tr −1) → the tr component fails condition 3 → rejected. Food = the cues (R_so/
; R_result consume So/AsAResult, which no rule produces), so {R_trans} alone is not food-
; generated and the whole loop is the ACS. Condition 4 (causal influence) is a REPLAY
; ablation: re-derive with the members suppressed in an isolated space → the 2 answers drop
; to 0 (the negative control — suppress nothing — re-derives the full 2, so it does not drop).
; The verdict names both M_A (the cycle's motif species — the single ReasonFor motif AND the
; composite chain motif; food motifs excluded) and R_A (the rules), and flags autocatalysis
; (§4.5 cond 1-2). Finally the acs-scan
; WORKER (worker-kind acs-scan): `dispatch` → `run-as` runs the SAME certification in ISOLATED
; spaces and emits the §2.9 verdicts to &self; a second worker under CL_shallow flips the
; promotion — the clamp-switch through the worker layer. Finally RECURRENCE: one epoch is a
; structural candidate (a single cycle); adding a second cycle to the cycle-tagged event log
; makes the loop recurrent (>= recurrence-min).
;
; Run:  sh ../PeTTa/run.sh tests/acs_test.metta < /dev/null 2>&1 | grep should  # fifty-two ✅
; ===========================================================================
!(import! &self "petta/util.metta")
!(import! &self "petta/fuel.metta")
!(import! &self "petta/compiler.metta")
!(import! &self "petta/gate.metta")
!(import! &self "petta/reaction.metta")
!(import! &self "petta/grounder.metta")
!(import! &self "petta/evaluator.metta")
!(import! &self "petta/worker.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")
!(import! &self "petta/acs.metta")
!(import! &self "petta/dispatch.metta")

; --- one chamber run supplies the log + derived layer (seed tr=1 so R_trans fires once) ---
!(add-atom &self (fuel O_base sm 10))
!(add-atom &self (fuel O_chain sm 10))
!(add-atom &self (fuel O_chain tr 1))
!(run-chamber &self CH_expt1)
!(test (msort (fired-rules &self)) (R_result R_so R_trans))                   ; all three fired

; --- motifs are whole reactant/product PATTERNS (composite, shared vars kept), matched by
; UNIFICATION. R_trans's reactant is the two-edge CHAIN motif (shared middle mvar 1); a single
; ReasonFor product FEEDS it (unifies one of its clauses) — the doc's compositional closure. ---
!(test (rule-reactant R_trans) ((ReasonFor (mvar 0) (mvar 1)) (ReasonFor (mvar 1) (mvar 2))))  ; the CHAIN
!(test (rule-product R_trans) ((ReasonFor (mvar 0) (mvar 1))))                                 ; a single ReasonFor
!(test (rule-reactant R_so) ((So (mvar 0) (mvar 1))))                                          ; the So cue (food)
!(test (rule-product R_so) ((ReasonFor (mvar 0) (mvar 1))))                                    ; a ReasonFor
!(test (motif-feeds? (rule-product R_so) (rule-reactant R_trans)) True)                        ; ReasonFor feeds the chain
!(test (queried-products (all-products (fired-rules &self))) (((ReasonFor (mvar 0) (mvar 1))))); ReasonFor answers the query

; --- mine the graph; the food-generated loop = all three rules (in the food-fed network) ---
!(bind! &g (new-space))
!(build-graph &g (fired-rules &self))
!(test (msort (acs-members &g (fired-rules &self))) (R_result R_so R_trans))

; --- STRUCTURAL CLOSURE (§4.5 cond 1): ENDOGENOUS only — the minting edge is FOOD, not closure.
; R_trans is endo-cyclic (its ReasonFor product feeds its own two-edge chain premise); R_so/
; R_result are feed-forward food-converters (So/AsAResult are cues no rule regenerates), so the
; SET is NOT structurally closed — a subsidized candidate (no acs-closure fact; viable+useful,
; food-fed), its subsidy inferred as surplus-but-no-closure. ---
!(test (endo-cyclic? R_trans (acs-members &g (fired-rules &self))) True)      ; ReasonFor feeds its own chain
!(test (endo-cyclic? R_so (acs-members &g (fired-rules &self))) False)        ; So is food — feed-forward
!(test (structurally-closed? (acs-members &g (fired-rules &self))) False)     ; a feed-forward member ⇒ not closed
!(test (closure-kind (acs-members &g (fired-rules &self))) none)              ; not closed ⇒ no closure kind
!(test (closure-facts A_qa (acs-members &g (fired-rules &self))) ())          ; ⇒ NO acs-closure fact emitted (not an ACS)

; positive control: a synthetic 2-rule substrate ring (P→Q, Q→P) IS structurally closed — each
; rule's product regenerates the other's reactant, so both are endo-cyclic (the Exp-2 biomedical-
; ring shape). Validates the `substrate`-closed branch on a known closed loop. R_ring1/R_ring2
; never fire, so they touch no membership/graph/surplus computation above.
!(add-atom &self (rule-lhs R_ring1 ((sem-edge gg i1 P (var x)))))
!(add-atom &self (rule-rhs R_ring1 ((sem-edge gg i2 Q (var x)))))
!(add-atom &self (rule-lhs R_ring2 ((sem-edge gg i3 Q (var x)))))
!(add-atom &self (rule-rhs R_ring2 ((sem-edge gg i4 P (var x)))))
!(test (structurally-closed? (R_ring1 R_ring2)) True)                         ; mutual regeneration
!(test (closure-kind (R_ring1 R_ring2)) substrate)                           ; substrate-level closure
!(test (closure-facts AX (R_ring1 R_ring2)) ((acs-closure AX substrate)))    ; closed ⇒ the acs-closure fact IS emitted

; --- per-token surplus (eq 19), componentwise; only the tr component flips with the clamp ---
!(test (token-surplus &self (acs-members &g (fired-rules &self)) CL_deep sm) 1)     ; income 4 − spend 3
!(test (token-surplus &self (acs-members &g (fired-rules &self)) CL_deep tr) 1)     ; income 2 − spend 1
!(test (token-surplus &self (acs-members &g (fired-rules &self)) CL_shallow sm) 1)  ; income 4 − spend 3
!(test (token-surplus &self (acs-members &g (fired-rules &self)) CL_shallow tr) -1) ; income 0 − spend 1

; --- causal influence (condition 4): a REPLAY ablation in an isolated space. Suppressing the
; ACS members re-poses the chamber with nothing to derive ReasonFor → 0 answers, below the
; baseline 2 (removing the loop removes the answers). Negative control — suppress NOTHING (skip
; the empty set) — re-derives the full 2, so the count does NOT drop (a real counterfactual). ---
!(bind! &abl (new-space))
!(bind! &abl0 (new-space))
!(test (total-answers &self) 2)                                                    ; baseline: the loop present
!(test (ablated-answers &abl CH_expt1 SNAP_qa (acs-members &g (fired-rules &self))) 0)    ; loop suppressed → no answers
!(test (causal-influence? &self &abl CH_expt1 SNAP_qa (acs-members &g (fired-rules &self))) True)
!(test (causal-influence? &self &abl0 CH_expt1 SNAP_qa ()) False)                   ; suppress nothing → no drop

; --- the clamp-switch lives ENTIRELY in the componentwise surplus (tested above): membership +
; closure + causal influence are clamp-independent; only token-surplus flips (tr +1 under CL_deep
; vs −1 under CL_shallow). There is no acs-promoted summary fact — a consumer conjoins the per-
; condition verdicts (acs-closure present ∧ every acs-surplus > 0 ∧ causal ∧ recurrent) itself. ---

; --- the §2.9 verdict facts ---
!(test (in-list? (acs-member A_qa R_trans) (acs-verdicts A_qa &g &self &abl CH_expt1 SNAP_qa CL_deep)) True)
!(test (in-list? (acs-closure A_qa substrate) (acs-verdicts A_qa &g &self &abl CH_expt1 SNAP_qa CL_deep)) False)  ; V3 not closed ⇒ no acs-closure fact in the verdict list
!(test (in-list? (acs-surplus A_qa CL_deep tr 1) (acs-verdicts A_qa &g &self &abl CH_expt1 SNAP_qa CL_deep)) True)
!(test (in-list? (acs-causal-influence A_qa True) (acs-verdicts A_qa &g &self &abl CH_expt1 SNAP_qa CL_deep)) True)

; --- A = (M_A, R_A): the verdict names both M_A (the cycle's motif species) and R_A (the
; rules), plus autocatalysis (cond 2). M_A now includes the COMPOSITE chain motif (R_trans's
; two-edge premise, shared middle) alongside the single ReasonFor motif; food motifs (So/
; AsAResult, never produced) are off every cycle and excluded. ---
!(test (len (acs-motifs &g (acs-members &g (fired-rules &self)))) 2)                                          ; two motif species
!(test (in-list? ((ReasonFor (mvar 0) (mvar 1))) (acs-motifs &g (acs-members &g (fired-rules &self)))) True)  ; the single ReasonFor motif
!(test (in-list? ((ReasonFor (mvar 0) (mvar 1)) (ReasonFor (mvar 1) (mvar 2))) (acs-motifs &g (acs-members &g (fired-rules &self)))) True)  ; the CHAIN motif
!(test (autocatalytic? &g (acs-members &g (fired-rules &self))) True)             ; cond 2 holds
!(test (in-list? (acs-motif A_qa ((ReasonFor (mvar 0) (mvar 1)))) (acs-verdicts A_qa &g &self &abl CH_expt1 SNAP_qa CL_deep)) True)
!(test (in-list? (acs-motif A_qa ((ReasonFor (mvar 0) (mvar 1)) (ReasonFor (mvar 1) (mvar 2)))) (acs-verdicts A_qa &g &self &abl CH_expt1 SNAP_qa CL_deep)) True)  ; the chain motif is a verdict
!(test (in-list? (acs-motif A_qa ((So (mvar 0) (mvar 1)))) (acs-verdicts A_qa &g &self &abl CH_expt1 SNAP_qa CL_deep)) False)  ; food motif excluded
!(test (in-list? (acs-autocatalytic A_qa True) (acs-verdicts A_qa &g &self &abl CH_expt1 SNAP_qa CL_deep)) True)

; ===========================================================================
; --- the acs-scan WORKER (worker-kind acs-scan): the SAME certification hosted as a §6.4
; worker. `dispatch` routes it to `run-as`, which CONSUMES the event log a prior context-
; chamber worker left in its run space (here materialized directly), builds the graph in its
; graph space, certifies (condition 4 replays the ablation in its ablation space from the
; snapshot), and EMITS the §2.9 verdicts to &self. The scratch spaces are bound here at top-
; level (a worker body cannot mint a new-space).
!(add-atom &self (worker W_scan))
!(add-atom &self (worker-kind W_scan acs-scan))
!(add-atom &self (worker-chamber W_scan CH_expt1))
!(add-atom &self (worker-clamp W_scan CL_deep))
!(add-atom &self (worker-snapshot W_scan SNAP_qa))
!(add-atom &self (worker-acs W_scan A_qa))
!(bind! &ws_scan (new-space))
!(bind! &g_scan (new-space))
!(bind! &abl_scan (new-space))
!(add-atom &self (worker-space W_scan &ws_scan))
!(add-atom &self (worker-graph-space W_scan &g_scan))
!(add-atom &self (worker-ablate-space W_scan &abl_scan))
; run-as CONSUMES a chamber's log, so a chamber run must populate its space first (a context-
; chamber worker does this in the pipeline; here we materialize that output directly)
!(copy-molecules &ws_scan)
!(restore-snapshot &ws_scan SNAP_qa)
!(run-chamber &ws_scan CH_expt1)
!(dispatch W_scan)

; the acs worker consumed the pre-populated run space (isolation): it answers the question
; (2 groundings) and holds the 3-firing log the certification scanned
!(test (total-answers &ws_scan) 2)
!(test (foldall + (match &ws_scan (event $c $s $r $k) 1) 0) 3)

; the §2.9 verdicts were EMITTED to &self (keyed on the ACS name A_qa); under CL_deep the tr
; surplus is +1 (viable — the loop pays for itself under this clamp)
!(test (match &self (acs-member A_qa R_trans) yes) yes)
!(test (match &self (acs-motif A_qa ((ReasonFor (mvar 0) (mvar 1)))) yes) yes)
!(test (collapse (match &self (acs-closure A_qa $c) $c)) ())                       ; V3 not closed ⇒ worker emits no acs-closure
!(test (closure-of A_qa) none)                                                     ; the display reader shows none
!(test (match &self (acs-autocatalytic A_qa $b) $b) True)
!(test (match &self (acs-surplus A_qa CL_deep tr $n) $n) 1)

; --- a SECOND acs-scan worker over the SAME ACS under CL_shallow: membership + closure clamp-
; independent, but the tr surplus FLIPS to −1 (the loop starves under this clamp) — the clamp-
; switch through the worker layer ---
!(add-atom &self (worker W_scanS))
!(add-atom &self (worker-kind W_scanS acs-scan))
!(add-atom &self (worker-chamber W_scanS CH_expt1))
!(add-atom &self (worker-clamp W_scanS CL_shallow))
!(add-atom &self (worker-snapshot W_scanS SNAP_qa))
!(add-atom &self (worker-acs W_scanS A_qa))
!(bind! &ws_scanS (new-space))
!(bind! &g_scanS (new-space))
!(bind! &abl_scanS (new-space))
!(add-atom &self (worker-space W_scanS &ws_scanS))
!(add-atom &self (worker-graph-space W_scanS &g_scanS))
!(add-atom &self (worker-ablate-space W_scanS &abl_scanS))
!(copy-molecules &ws_scanS)
!(restore-snapshot &ws_scanS SNAP_qa)
!(run-chamber &ws_scanS CH_expt1)
!(dispatch W_scanS)
!(test (match &self (acs-surplus A_qa CL_shallow tr $n) $n) -1)

; isolation, both directions: neither worker leaked derivation into &self (still the bare
; run's 2 answers, not 4)
!(test (total-answers &self) 2)

; ===========================================================================
; --- RECURRENCE (§4.5 "sustains itself in an event log" / §6.4 P2 "recurrent"): the single
; chamber run at the top fired in ONE cycle (cycle 1), so the loop is only a STRUCTURAL
; CANDIDATE. The cycle-tagged event log accumulates in place; here we add a second
; cycle of the loop {R_so, R_result, R_trans} firing, and it reads as recurrent (>= recurrence-min). ---
!(test (recurrence-count &self (acs-members &g (fired-rules &self))) 1)   ; single run: one cycle
!(test (recurrent? &self (acs-members &g (fired-rules &self)) 2) False)   ; candidate, not yet recurrent
!(add-atom &self (event 2 1 R_so k1))
!(add-atom &self (event 2 2 R_result k2))
!(add-atom &self (event 2 3 R_trans k3))
!(test (recurrence-count &self (acs-members &g (fired-rules &self))) 2)   ; the loop closes in 2 cycles
!(test (recurrent? &self (acs-members &g (fired-rules &self)) 2) True)    ; recurrent
!(test (in-list? (acs-recurrent A_qa True) (acs-verdicts A_qa &g &self &abl CH_expt1 SNAP_qa CL_deep)) True)

; rule-firings scopes to the CURRENT cycle (per-cycle surplus, eq-19): with cycle-now = 2 it
; counts cycle-2's one R_so firing, not both cycles' — so a multi-cycle log keeps surplus per-cycle
!(add-atom &self (cycle-now 2))
!(test (rule-firings &self R_so) 1)
