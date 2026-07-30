; ===========================================================================
; ACS TEST — P2 mortal-ACS detection on V3 (TECAN T3 / Alg 5.5 step 2 / MSC eq 18-19):
; the motif-keyed reaction graph (COMPOSITE motifs, UNIFICATION-matched), the food-generated
; reflexively-autocatalytic loop {R_so, R_result, R_trans}, and the clamp-switch on surplus.
; ---------------------------------------------------------------------------
; One chamber run (seed tr=1 so R_trans fires once) supplies the event log + derived layer.
; The miner keys the graph on the MOTIF — a rule's whole reactant/product PATTERN (composite,
; shared vars kept), matched producer→reactant by UNIFICATION. The set is FOOD-FED: the minting
; edge is FOOD, not closure, so V3 gets NO acs-closure fact — a subsidized candidate. R_so/
; R_result are feed-forward cue-converters; R_trans is endo-cyclic but its two-ReasonFor premise
; is not injectively covered once the converters peel away, so the CLOSED component is EMPTY and
; the member set falls back to the food-fed candidate — its subsidy read off as surplus-but-no-
; closure. Membership + closure are clamp-independent; only the metabolic SURPLUS flips — CL_deep
; (sm +1, tr +1) is viable; CL_shallow (sm +1, tr −1) fails condition 3 on the tr component. Food
; = the cues (R_so/R_result consume So/AsAResult, which no rule produces). Condition 4 (causal
; influence) is a REPLAY
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
; Run:  sh ../PeTTa/run.sh tests/acs_test.metta < /dev/null 2>&1 | grep should  # ninety-four ✅
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
!(import! &self "petta/epoch.metta")
!(import! &self "petta/acs.metta")
!(import! &self "petta/dispatch.metta")

; --- one chamber run supplies the log + derived layer (seed tr=1 so R_trans fires once) ---
!(bind! &ws0 (new-space))
!(set-task &ws0 V3)
!(set-cycle &ws0 1)          ; dates the log to the task, so a paired replay re-poses the same one
!(copy-molecules &ws0)
!(add-atom &ws0 (fuel O_base sm 10))
!(add-atom &ws0 (fuel O_chain sm 10))
!(add-atom &ws0 (fuel O_chain tr 1))
!(run-chamber &ws0 CH_expt1)
!(test (msort (fired-rules &ws0)) (R_result R_so R_trans))                   ; all three fired

; --- motifs are whole reactant/product PATTERNS (composite, shared vars kept), matched by
; UNIFICATION. R_trans's reactant is the two-edge CHAIN motif (shared middle mvar 1); a single
; ReasonFor product FEEDS it (unifies one of its clauses) — the doc's compositional closure. ---
!(test (rule-reactant R_trans) ((ReasonFor (mvar 0) (mvar 1)) (ReasonFor (mvar 1) (mvar 2))))  ; the CHAIN
!(test (rule-product R_trans) ((ReasonFor (mvar 0) (mvar 1))))                                 ; a single ReasonFor
!(test (rule-reactant R_so) ((So (mvar 0) (mvar 1))))                                          ; the So cue (food)
!(test (rule-product R_so) ((ReasonFor (mvar 0) (mvar 1))))                                    ; a ReasonFor
!(test (motif-feeds? (rule-product R_so) (rule-reactant R_trans)) True)                        ; ReasonFor feeds the chain
!(test (queried-products (all-products (fired-rules &ws0))) (((ReasonFor (mvar 0) (mvar 1))))); ReasonFor answers the query

; --- mine the graph; the food-generated loop = all three rules (in the food-fed network) ---
!(bind! &g (new-space))
!(build-graph &g (fired-rules &ws0))
!(test (msort (acs-members &g (fired-rules &ws0))) (R_result R_so R_trans))

; --- STRUCTURAL CLOSURE (§4.5 cond 1): ENDOGENOUS only — the minting edge is FOOD, not closure.
; R_trans is endo-cyclic (its ReasonFor product feeds its own two-edge chain premise); R_so/
; R_result are feed-forward food-converters (So/AsAResult are cues no rule regenerates), so the
; SET is NOT structurally closed — a subsidized candidate (no acs-closure fact; viable+useful,
; food-fed), its subsidy inferred as surplus-but-no-closure. ---
!(test (endo-cyclic? R_trans (acs-members &g (fired-rules &ws0))) True)      ; ReasonFor feeds its own chain
!(test (endo-cyclic? R_so (acs-members &g (fired-rules &ws0))) False)        ; So is food — feed-forward
!(test (structurally-closed? (acs-members &g (fired-rules &ws0))) False)     ; a feed-forward member ⇒ not closed
!(test (closure-kind (acs-members &g (fired-rules &ws0))) none)              ; not closed ⇒ no closure kind
!(test (closure-facts A_qa (acs-members &g (fired-rules &ws0))) ())          ; ⇒ NO acs-closure fact emitted (not an ACS)

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

; --- #2 SUBSET-MINING: the ENDO-COMPONENT is the closed self-recreating subnetwork. Closure now
; needs endo-cyclic AND injective non-food-premise coverage, so the contracting self-loop
; {R_trans} (two ReasonFor in, one out) is NOT a closed singleton: the candidate set's several
; ReasonFor producers cover it, but once the feed-forward converters peel away it stands alone
; with one producer for a two-ReasonFor premise and fails. V3 thus has an EMPTY closed component
; ⇒ acs-member-set falls back to the food-fed candidate network (the subsidized story is kept). ---
!(test (injective-covered? R_trans (fired-rules &ws0)) True)                ; candidate set: 3 ReasonFor producers cover it
!(test (injective-covered? R_trans (R_trans)) False)                        ; alone: 2 ReasonFor premise, 1 producer
!(test (endo-satisfied? R_trans (R_trans)) False)                           ; on a cycle, but not injectively covered
!(test (structurally-closed? (R_trans)) False)                              ; ⇒ the lone self-loop is not closed
!(test (endo-component (fired-rules &ws0)) ())                             ; V3 peels to an EMPTY closed component
!(test (msort (acs-member-set &g (fired-rules &ws0))) (R_result R_so R_trans))  ; ⇒ fall back to the candidate network
; a genuine 2-rule ring IS its own closed component (each 1-clause premise met by a distinct producer)
!(test (injective-covered? R_ring1 (R_ring1 R_ring2)) True)
!(test (msort (endo-component (R_ring1 R_ring2))) (R_ring1 R_ring2))

; --- closure-KIND classifier (substrate / control / hybrid), from the motifs the loop
; REGENERATES (its members' non-food premise relations) vs `(control-relation R)` declarations.
; The P→Q→P ring above is all-semantic ⇒ substrate; here we declare control motifs. ---
!(add-atom &self (control-relation CtrlA))
!(add-atom &self (control-relation CtrlC))
; a HYBRID ring: control CtrlA ⇌ semantic SemB (regenerates one of each)
!(add-atom &self (rule-lhs R_hy1 ((sem-edge hg h1 CtrlA (var x)))))
!(add-atom &self (rule-rhs R_hy1 ((sem-edge hg h2 SemB (var x)))))
!(add-atom &self (rule-lhs R_hy2 ((sem-edge hg h3 SemB (var x)))))
!(add-atom &self (rule-rhs R_hy2 ((sem-edge hg h4 CtrlA (var x)))))
!(test (msort (closure-rels (R_hy1 R_hy2))) (CtrlA SemB))             ; regenerates one control + one semantic
!(test (closure-kind (R_hy1 R_hy2)) hybrid)                          ; ⇒ hybrid closure
!(test (closure-facts AH (R_hy1 R_hy2)) ((acs-closure AH hybrid)))
; a pure CONTROL ring: control CtrlA ⇌ control CtrlC
!(add-atom &self (rule-lhs R_co1 ((sem-edge cg c1 CtrlA (var x)))))
!(add-atom &self (rule-rhs R_co1 ((sem-edge cg c2 CtrlC (var x)))))
!(add-atom &self (rule-lhs R_co2 ((sem-edge cg c3 CtrlC (var x)))))
!(add-atom &self (rule-rhs R_co2 ((sem-edge cg c4 CtrlA (var x)))))
!(test (closure-kind (R_co1 R_co2)) control)                        ; all-control ⇒ control closure
; the all-semantic P→Q→P ring stays substrate (control declared for OTHER relations only)
!(test (closure-kind (R_ring1 R_ring2)) substrate)

; --- per-token surplus (eq 19), componentwise; only the tr component flips with the clamp ---
!(test (token-surplus &ws0 (acs-members &g (fired-rules &ws0)) CL_deep sm) 1)     ; income 4 − spend 3
!(test (token-surplus &ws0 (acs-members &g (fired-rules &ws0)) CL_deep tr) 1)     ; income 2 − spend 1
!(test (token-surplus &ws0 (acs-members &g (fired-rules &ws0)) CL_shallow sm) 1)  ; income 4 − spend 3
!(test (token-surplus &ws0 (acs-members &g (fired-rules &ws0)) CL_shallow tr) -1) ; income 0 − spend 1

; --- causal influence (condition 4): a REPLAY ablation in an isolated space. Suppressing the
; ACS members re-poses the chamber with nothing to derive ReasonFor → 0 answers, below the
; baseline 2 (removing the loop removes the answers). Negative control — suppress NOTHING (skip
; the empty set) — re-derives the full 2, so the count does NOT drop (a real counterfactual). ---
!(bind! &abl (new-space))
!(bind! &abl0 (new-space))
!(test (total-answers &ws0) 2)                                                    ; baseline: the loop present
!(test (ablated-answers &abl CH_expt1 SNAP_qa V3 (acs-members &g (fired-rules &ws0))) 0)  ; loop suppressed → no answers
!(test (causal-influence? &ws0 &abl CH_expt1 SNAP_qa (acs-members &g (fired-rules &ws0))) True)
!(test (causal-influence? &ws0 &abl0 CH_expt1 SNAP_qa ()) False)                   ; suppress nothing → no drop

; --- RULE-LEVEL causal coding (SC §3): per-member do-influence by LEAVE-ONE-OUT replay (baseline
; minted reward − reward with that ONE member disabled). In V3 all three members are load-bearing
; (none redundant): R_result produces the base ReasonFor both answers need (ablating it → 0 reward,
; do-influence = the full baseline 6); R_so and R_trans are each required for the 2-hop chain
; answer (do-influence 4). So the minimal ACS is all three. ---
!(test (member-do-influences &ws0 &abl CH_expt1 SNAP_qa CL_deep (R_so R_result R_trans)) ((R_so 4) (R_result 6) (R_trans 4)))
!(test (minimal-acs &ws0 &abl CH_expt1 SNAP_qa CL_deep (R_so R_result R_trans)) (R_so R_result R_trans))   ; all load-bearing
; the redundancy + minimal-ACS logic on a synthetic (rule delta) list: a delta-0 member is
; REDUNDANT and dropped from the minimal ACS
!(test (do-inf-facts 1 ((Ra 3) (Rb 0) (Rc 2)))
       ((rule-do-influence Ra target answer-reward 1 3) (rule-redundancy Ra 1 False)
        (rule-do-influence Rb target answer-reward 1 0) (rule-redundancy Rb 1 True)
        (rule-do-influence Rc target answer-reward 1 2) (rule-redundancy Rc 1 False)))
!(test (minimal-acs &ws0 &abl CH_expt1 SNAP_qa CL_shallow (R_so R_result R_trans)) (R_so R_result R_trans))  ; also minimal under the other clamp

; --- the replay WINDOW is the TASK SEQUENCE the observed log served, CAPPED. Uncapped it would
; replay a production log's thousands of tasks per member, for a delta that only rescales past the
; point the trajectories separate. The cap bounds the cost and bounds the CLAIM: a 0 means "no
; difference within n tasks". Here the log served one task, so the window is 1 and every number
; above stands. ---
!(test (window-max) 3)                                   ; the default cap
!(test (replay-tasks &ws0) (V3))                         ; the replay re-poses the task actually worked
!(test (window-of &ws0) 1)                              ; a one-task log is not padded up to the cap
!(bind! &ws_long (new-space))
!(add-atom &ws_long (cycle-task 1 T1))
!(add-atom &ws_long (cycle-task 2 T2))
!(add-atom &ws_long (cycle-task 3 T3))
!(add-atom &ws_long (cycle-task 4 T4))
!(add-atom &ws_long (cycle-task 5 T5))
!(add-atom &ws_long (event 1 0 R_so k))
!(add-atom &ws_long (event 2 0 R_so k))
!(test (len (log-cycles &ws_long)) 2)                    ; two cycles actually logged a firing...
!(test (len (log-tasks &ws_long)) 5)                     ; ...across five tasks served
!(test (window-of &ws_long) 3)                           ; but the replay is capped at 3
!(test (replay-tasks &ws_long) (T1 T2 T3))               ; the first three, in arrival order
!(add-atom &self (acs-window-max 4))                     ; the cap is config
!(test (window-of &ws_long) 4)
!(remove-atom &self (acs-window-max 4))
!(test (window-of &ws_long) 3)                           ; back to the default
; a log with no task dating at all falls back to a single whole-corpus replay
!(bind! &ws_untagged (new-space))
!(add-atom &ws_untagged (event 1 0 R_so k))
!(test (replay-tasks &ws_untagged) (all))
; the do-influence facts appear in the verdict list (per member, keyed on the rule)
!(test (in-list? (rule-do-influence R_trans target answer-reward 1 4) (acs-verdicts A_qa &g &ws0 &abl CH_expt1 SNAP_qa CL_deep)) True)
!(test (in-list? (rule-redundancy R_result 1 False) (acs-verdicts A_qa &g &ws0 &abl CH_expt1 SNAP_qa CL_deep)) True)

; --- the clamp-switch lives ENTIRELY in the componentwise surplus (tested above): membership +
; closure + causal influence are clamp-independent; only token-surplus flips (tr +1 under CL_deep
; vs −1 under CL_shallow). There is no acs-promoted summary fact — a consumer conjoins the per-
; condition verdicts (acs-closure present ∧ every acs-surplus > 0 ∧ causal ∧ recurrent) itself. ---

; --- the §2.9 verdict facts ---
!(test (in-list? (acs-member A_qa R_trans) (acs-verdicts A_qa &g &ws0 &abl CH_expt1 SNAP_qa CL_deep)) True)
!(test (in-list? (acs-closure A_qa substrate) (acs-verdicts A_qa &g &ws0 &abl CH_expt1 SNAP_qa CL_deep)) False)  ; V3 not closed ⇒ no acs-closure fact in the verdict list
!(test (in-list? (acs-surplus A_qa CL_deep tr 1) (acs-verdicts A_qa &g &ws0 &abl CH_expt1 SNAP_qa CL_deep)) True)
!(test (in-list? (acs-causal-influence A_qa True) (acs-verdicts A_qa &g &ws0 &abl CH_expt1 SNAP_qa CL_deep)) True)

; --- A = (M_A, R_A): the verdict names both M_A (the cycle's motif species) and R_A (the
; rules), plus autocatalysis (cond 2). M_A now includes the COMPOSITE chain motif (R_trans's
; two-edge premise, shared middle) alongside the single ReasonFor motif; food motifs (So/
; AsAResult, never produced) are off every cycle and excluded. ---
!(test (len (acs-motifs &g (acs-members &g (fired-rules &ws0)))) 2)                                          ; two motif species
!(test (in-list? ((ReasonFor (mvar 0) (mvar 1))) (acs-motifs &g (acs-members &g (fired-rules &ws0)))) True)  ; the single ReasonFor motif
!(test (in-list? ((ReasonFor (mvar 0) (mvar 1)) (ReasonFor (mvar 1) (mvar 2))) (acs-motifs &g (acs-members &g (fired-rules &ws0)))) True)  ; the CHAIN motif
!(test (autocatalytic? &g (acs-members &g (fired-rules &ws0))) True)             ; cond 2 holds
!(test (in-list? (acs-motif A_qa ((ReasonFor (mvar 0) (mvar 1)))) (acs-verdicts A_qa &g &ws0 &abl CH_expt1 SNAP_qa CL_deep)) True)
!(test (in-list? (acs-motif A_qa ((ReasonFor (mvar 0) (mvar 1)) (ReasonFor (mvar 1) (mvar 2)))) (acs-verdicts A_qa &g &ws0 &abl CH_expt1 SNAP_qa CL_deep)) True)  ; the chain motif is a verdict
!(test (in-list? (acs-motif A_qa ((So (mvar 0) (mvar 1)))) (acs-verdicts A_qa &g &ws0 &abl CH_expt1 SNAP_qa CL_deep)) False)  ; food motif excluded
!(test (in-list? (acs-autocatalytic A_qa True) (acs-verdicts A_qa &g &ws0 &abl CH_expt1 SNAP_qa CL_deep)) True)

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
!(set-task &ws_scan V3)
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
!(test (match &self (rule-do-influence R_trans target answer-reward 1 $d) $d) 4)      ; the worker emitted the per-rule do-influence

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
!(set-task &ws_scanS V3)
!(copy-molecules &ws_scanS)
!(restore-snapshot &ws_scanS SNAP_qa)
!(run-chamber &ws_scanS CH_expt1)
!(dispatch W_scanS)
!(test (match &self (acs-surplus A_qa CL_shallow tr $n) $n) -1)

; isolation, both directions: neither worker leaked derivation into &self (still the bare
; run's 2 answers, not 4)
!(test (total-answers &ws0) 2)

; ===========================================================================
; --- RECURRENCE (§4.5 "sustains itself in an event log" / §6.4 P2 "recurrent"): counted across
; TASKS, not cycles — the docs' metric is "recurrence of useful motifs across tasks", so a loop
; recurs when it turns again on NEWLY ARRIVED material rather than when one question is re-asked.
; The chamber run at the top worked ONE task, so the loop is only a STRUCTURAL CANDIDATE; here a
; second task arrives, the same loop turns on it, and it reads as recurrent (>= recurrence-min). ---
!(test (recurrence-count &ws0 (acs-members &g (fired-rules &ws0))) 1)   ; one task worked so far
!(test (recurrent? &ws0 (acs-members &g (fired-rules &ws0)) 2) False)   ; candidate, not yet recurrent
!(add-atom &ws0 (cycle-task 2 V4))                                     ; a second task arrives...
!(add-atom &ws0 (event 2 1 R_so k1))                                   ; ...and the loop turns again
!(add-atom &ws0 (event 2 2 R_result k2))
!(add-atom &ws0 (event 2 3 R_trans k3))
!(test (log-tasks &ws0) (V3 V4))
!(test (loop-in-task? &ws0 (acs-members &g (fired-rules &ws0)) V4) True)
!(test (recurrence-count &ws0 (acs-members &g (fired-rules &ws0))) 2)   ; the loop turned for both
!(test (recurrent? &ws0 (acs-members &g (fired-rules &ws0)) 2) True)    ; recurrent ACROSS TASKS
!(test (in-list? (acs-recurrent A_qa True) (acs-verdicts A_qa &g &ws0 &abl CH_expt1 SNAP_qa CL_deep)) True)

; a loop that turned for only ONE of the two tasks is NOT recurrent — the second arrival is what
; distinguishes a reusable strategy from a one-off derivation
!(test (loop-in-task? &ws0 (R_so R_result R_trans R_absent) V3) False)
!(test (recurrence-count &ws0 (R_so R_result R_trans R_absent)) 0)

; rule-firings scopes to the POSED TASK's cycles (per-task surplus, eq-19): posing V3 counts only
; the cycles that served V3, posing V4 only V4's — so a multi-task log keeps surplus per task
!(test (rule-firings &ws0 R_so) 1)                                     ; V3 is posed: its cycle 1
!(set-task &ws0 V4)
!(test (rule-firings &ws0 R_so) 1)                                     ; V4: its cycle 2
!(set-task &ws0 V3)

; ===========================================================================
; --- MUTUAL REDUNDANCY: leave-one-out measures individual necessity, but minimality is a JOINT
; property, and the two come apart. R_dup1/R_dup2 derive the IDENTICAL product edge (same product
; id, so whichever fires second is a no-op under ⊕ set-union): either ALONE reproduces the answer,
; but dropping BOTH loses it. Each therefore measures do-influence 0 — a correct per-rule
; measurement — while the naive "drop every zero-influence member" reading would return the EMPTY
; set. `minimal-acs` greedy-sequential ablation keeps one of the pair instead.
; Declared LAST: the synthetic question shifts every income/answer total, so nothing above may
; depend on it. ---
!(add-atom &self (sem-graph-kind dupg neo-davidsonian))
!(add-atom &self (sem-edge dupg dm1 Cue dc1 dc2))
!(add-atom &self (sem-edge-tv dupg dm1 (stv 1.0 0.9)))
!(add-atom &self (rule-context R_dup1 dup-ctx))
!(add-atom &self (rule-priority R_dup1 0))
!(add-atom &self (rule-token-cost R_dup1 sm 1))
!(add-atom &self (rule-lhs R_dup1 ((sem-edge (var g) (var e) Cue (var x) (var y)) (sem-edge-tv (var g) (var e) (var tv)))))
!(add-atom &self (rule-rhs R_dup1 ((sem-edge (var g) (dn (var e)) ReasonFor (var x) (var y)) (sem-edge-tv (var g) (dn (var e)) (var tv)))))
!(add-atom &self (rule-context R_dup2 dup-ctx))
!(add-atom &self (rule-priority R_dup2 1))
!(add-atom &self (rule-token-cost R_dup2 sm 1))
!(add-atom &self (rule-lhs R_dup2 ((sem-edge (var g) (var e) Cue (var x) (var y)) (sem-edge-tv (var g) (var e) (var tv)))))
!(add-atom &self (rule-rhs R_dup2 ((sem-edge (var g) (dn (var e)) ReasonFor (var x) (var y)) (sem-edge-tv (var g) (dn (var e)) (var tv)))))
!(add-atom &self (chamber CH_dup))
!(add-atom &self (chamber-context CH_dup dup-ctx))
!(add-atom &self (organism O_dup))
!(add-atom &self (genome-of O_dup GNM_dup))
!(add-atom &self (quoted-ruleset GNM_dup RS_dup))
!(add-atom &self (ruleset-member RS_dup R_dup1))
!(add-atom &self (ruleset-member RS_dup R_dup2))
!(add-atom &self (snapshot-fuel SNAP_dup O_dup sm 10))
!(add-atom &self (clamp CL_dup))
!(add-atom &self (clamp-mint CL_dup skeleton-match sm 2))
!(add-atom &self (clamp-scope CL_dup CH_dup))
!(add-atom &self (qa-task DUP))
!(add-atom &self (task-graph DUP dupg))          ; the synthetic task's own text
!(add-atom &self (qa-question DUP Q_dup))
!(add-atom &self (answer-skeleton Q_dup GAS_dup))
!(add-atom &self (sem-graph GAS_dup))
!(add-atom &self (sem-graph-kind GAS_dup answer-skeleton))
!(add-atom &self (sem-edge GAS_dup dqc1 ReasonFor (var w) (var z)))
!(bind! &ws_dup (new-space))
!(bind! &abl_dup (new-space))
!(set-task &ws_dup DUP)
!(set-cycle &ws_dup 1)
!(copy-molecules &ws_dup)
!(restore-snapshot &ws_dup SNAP_dup)
!(run-chamber &ws_dup CH_dup)
; only ONE of them fires: the second finds its product already present and skips, so a
; duplicate derivation now costs nothing rather than paying twice for the same edge
!(test (msort (fired-rules &ws_dup)) (R_dup1))
!(test (total-reward &ws_dup CL_dup) 2)                                                      ; baseline: the answer is minted
!(test (ablated-reward &abl_dup CH_dup SNAP_dup CL_dup (R_dup1)) 2)                          ; either ALONE is droppable...
!(test (ablated-reward &abl_dup CH_dup SNAP_dup CL_dup (R_dup2)) 2)
!(test (ablated-reward &abl_dup CH_dup SNAP_dup CL_dup (R_dup1 R_dup2)) 0)                   ; ...but BOTH together are necessary
!(test (member-do-influences &ws_dup &abl_dup CH_dup SNAP_dup CL_dup (R_dup1 R_dup2)) ((R_dup1 0) (R_dup2 0)))  ; each measures 0
!(test (minimal-acs &ws_dup &abl_dup CH_dup SNAP_dup CL_dup (R_dup1 R_dup2)) (R_dup2))       ; greedy keeps one (not the empty set)
