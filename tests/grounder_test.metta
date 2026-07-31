; ===========================================================================
; GROUNDER TEST — the solve pipeline on the §10.1 sem-graph IR (V3): the genome
; derives the explanatory layer, then answer-skeletons ground against it.
; ---------------------------------------------------------------------------
; Molecules and skeletons are the semantic parser's actual output (surface cues; the
; queries ask ReasonFor). The genome (rules.metta) normalizes cues into ReasonFor
; edges — R_so, R_result at level 1; R_trans chains DERIVED edges at level 2 — every
; firing fuel-gated on its organism's purse (O_base owns R_so/R_result, O_chain owns
; R_trans). Grounding (petta/grounder) then solves each
; skeleton; a solution's elements are cited (derived) sem-edges, provenance in the
; minted ids ((norm E) / (trans E1 E2)). The why-question licenses ONE ReasonFor, yet
; grounds TWO ways (proximate + root cause) — the mechanism CHAIN is recoverable from the
; root answer's trans-id provenance, not from the query's shape.
;
; Run:  sh ../PeTTa/run.sh tests/grounder_test.metta < /dev/null 2>&1 | grep should  # eighteen ✅
; ===========================================================================
!(import! &self "petta/util.metta")
!(import! &self "petta/fuel.metta")
!(import! &self "petta/compiler.metta")
!(import! &self "petta/gate.metta")
!(import! &self "petta/reaction.metta")
!(import! &self "petta/grounder.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")

; does any solution in $sols cite $edge?
(= (cites? $sols $edge)
   (case $sols
         ((() False)
          ($ne (if (in-list? $edge (car-atom $sols))
                   True
                   (cites? (cdr-atom $sols) $edge))))))

; --- the reaction: seed each organism's purse, run the genome (all firings fuel-gated).
; O_base owns R_so/R_result (cost sm); O_chain owns R_trans (costs sm + tr).
!(add-atom &self (fuel O_base sm 10))
!(add-atom &self (fuel O_base dq 1))
!(add-atom &self (fuel O_chain sm 10))
!(add-atom &self (fuel O_chain dq 1))
!(add-atom &self (fuel O_chain tr 5))
!(run-rules &self)

; the genome is TEXT-GENERIC: loaded straight into &self, all three corpus texts are present,
; so each of the three rules fires once per text — the same strategy applied to new material.
!(test (foldall + (match &self (event $c $s $r $k) 1) 0) 9)              ; (R_so + R_result + R_trans) x 3
!(test (fuel-of &self O_base sm) 4)                                   ; O_base: R_so + R_result @ sm 1, x3
!(test (fuel-of &self O_chain sm) 7)                                  ; O_chain: R_trans @ sm 1, x3
!(test (fuel-of &self O_chain tr) 2)                                  ; only R_trans costs tr
!(test (foldall + (match &self (sem-edge V3g $e ReasonFor $x $y) 1) 0) 3)  ; 2 normalized + 1 chained
!(test (foldall + (match &self (sem-edge V4g $e ReasonFor $x $y) 1) 0) 3)  ; and the same shape on V4

; --- grounding: each why-question grounds two ways (proximate + root) ---
!(test (len (collapse (ground-skeleton &self V3_q1_as1))) 2)
!(test (len (collapse (ground-skeleton &self V4_q1_as1))) 2)

; posing a task scopes the OUTPUT to that task's questions, though both texts are derived here
!(add-atom &self (task-now V3))
!(test (current-task &self) V3)
!(test (posed-questions &self) (V3_q1))
!(test (posed-graphs &self) (V3g))
!(test (total-answers &self) 2)
!(remove-atom &self (task-now V3))
!(add-atom &self (task-now V4))
!(test (posed-questions &self) (V4_q1))
!(test (total-answers &self) 2)
!(remove-atom &self (task-now V4))
!(test (current-task &self) all)
!(test (total-answers &self) 6)                                       ; nothing posed: every question counts

; the proximate cause (the normalized as-a-result cue)...
!(test (cites? (collapse (ground-skeleton &self V3_q1_as1))
               (sem-edge V3g (norm v3_conn2) ReasonFor sk_stop_1 sk_spoil_1)) True)
; ...and, in the other grounding, the ROOT cause via the chained edge — the mechanism
; chain (go_out -> stop -> spoil) carried by that cite's provenance id, not the query shape
!(test (cites? (collapse (ground-skeleton &self V3_q1_as1))
               (sem-edge V3g (trans (norm v3_conn1) (norm v3_conn2)) ReasonFor sk_go_out_1 sk_spoil_1)) True)
