; ===========================================================================
; CTRL-SCAFFOLD TEST — reading the scan for a candidate worth wrapping (step 1).
; ---------------------------------------------------------------------------
; Scaffolding does not detect anything of its own: the ACS scanner already reads the task-dated
; log, and this is a second CONSUMER of that scan. A candidate is worth wrapping exactly when the
; scanner's per-condition verdicts say it RECURS across arrivals (so a track record justifies the
; expense) and does NOT close on its own (so there is something for a control level to supply).
; The two clamps make the discrimination for us: `CL_deep` funds the chainer, so the same three
; rules do the work on both arrivals and the candidate recurs; `CL_shallow` starves it, the
; second arrival goes unchained, and the same candidate is not recurrent.
;
; Run:  sh ../PeTTa/run.sh tests/ctrl_scaffold_test.metta < /dev/null 2>&1 | grep should
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
!(import! &self "petta/ctrl_scaffold.metta")

; --- TWO arrivals under the clamp that funds chaining: the scan certifies a candidate that
; recurs and does not close — which is exactly the wrapping trigger --------------------------
!(bind! &wd (new-space))
!(restore-snapshot &wd SNAP_qa)
!(bind! &gd (new-space))
!(bind! &ad (new-space))
!(test (run-tasks &wd CH_expt1 CL_deep (V3 V4) 1 9) (2 2))
!(test (log-tasks &wd) (V3 V4))
!(build-graph &gd (fired-rules &wd))

; the scanner's own reading of the log
!(test (msort (acs-member-set &gd (fired-rules &wd))) (R_result R_so R_trans))
!(test (recurrent? &wd (acs-member-set &gd (fired-rules &wd)) 2) True)      ; a track record
!(test (closure-facts A_qa (acs-member-set &gd (fired-rules &wd))) ())      ; ...and no closure

; emit the verdicts and read the trigger off them — no second detection anywhere
!(add-all &self (acs-verdicts A_qa &gd &wd &ad CH_expt1 SNAP_qa CL_deep))
!(test (msort (acs-chain A_qa)) (R_result R_so R_trans))
!(test (verdict-recurrent? A_qa) True)
!(test (verdict-closed? A_qa) False)
!(test (scaffoldable? A_qa) True)

; --- a candidate that does NOT recur is not worth wrapping. Under CL_shallow the chainer earns
; no tr, cannot chain the second arrival, and the loop is absent from that task — so the same
; three rules, with the same structure, fail the trigger on their record alone. ---------------
!(bind! &ws (new-space))
!(restore-snapshot &ws SNAP_qa)
!(bind! &gs (new-space))
!(bind! &as (new-space))
!(test (run-tasks &ws CH_expt1 CL_shallow (V3 V4) 1 9) (2 1))
!(build-graph &gs (fired-rules &ws))
!(test (msort (acs-member-set &gs (fired-rules &ws))) (R_result R_so R_trans))   ; same members...
!(test (recurrent? &ws (acs-member-set &gs (fired-rules &ws)) 2) False)          ; ...no record
!(add-all &self (acs-verdicts A_sh &gs &ws &as CH_expt1 SNAP_qa CL_shallow))
!(test (verdict-recurrent? A_sh) False)
!(test (scaffoldable? A_sh) False)

; --- a CLOSED candidate needs no wrapper: the control genome's ring already closes, so however
; well it recurs there is nothing for a control level to add. -------------------------------
!(add-atom &self (acs-recurrent A_closed True))
!(add-atom &self (acs-closure A_closed hybrid))
!(test (verdict-recurrent? A_closed) True)
!(test (verdict-closed? A_closed) True)
!(test (scaffoldable? A_closed) False)

; --- and an unknown candidate triggers nothing (absence is not a licence) -------------------
!(test (acs-chain A_never) ())
!(test (verdict-recurrent? A_never) False)
!(test (scaffoldable? A_never) False)

; --- WHERE THE CHAIN DELIVERS (generator input, not detection) --------------------------
; The set is dataflow-connected, NOT an ordered sequence — R_so and R_result both feed R_trans,
; so there is no unique "first" to read off — and the ordering that does exist in the data
; (`rule-priority`) is the hand-assigned hack we are removing. So the delivering end is computed:
; a member whose OWN premise the chain feeds, and whose product a query asks for.
!(test (chain-answer-motifs (R_so R_result R_trans)) (((ReasonFor (mvar 0) (mvar 1)))))
!(test (chain-dependent? R_trans (R_so R_result R_trans)) True)     ; its premise is member-fed
!(test (chain-dependent? R_so (R_so R_result R_trans)) False)       ; its premise is a food cue
!(test (answers? R_trans) True)
!(test (chain-answering-members (R_so R_result R_trans)) (R_trans))
; a set with no delivering member has nothing a success trace could watch
!(test (chain-answering-members (R_so R_result)) ())

; ===========================================================================
; STEP 2 — THE GENERATOR: a pure function from a scaffoldable candidate to the wrapper's facts.
; ===========================================================================
!(add-atom &self (scaffold-rule-cost sm 1))
!(add-atom &self (scaffold-dequote-cost dq 1))

; it is PURE — building the list stores nothing, so the wrapper is inspectable before it exists
!(test (len (scaffold-facts A_qa (R_so R_result R_trans) WhyQuestion causal-qa)) 57)
!(test (collapse (match &self (organism (org (strat A_qa))) yes)) ())
; and DETERMINISTIC: names are functions of the candidate, never gensym, so a replay rebuilds
; the identical wrapper
!(test (== (scaffold-facts A_qa (R_so R_result R_trans) WhyQuestion causal-qa)
           (scaffold-facts A_qa (R_so R_result R_trans) WhyQuestion causal-qa)) True)

; it FAILS CLOSED like expression does: no declared rule cost, or nothing delivered, means no
; wrapper — a control rule that fires free, or one with no success to trace, is not worth minting
!(test (scaffold-facts A_qa (R_so R_result) WhyQuestion causal-qa) ())
!(remove-atom &self (scaffold-rule-cost sm 1))
!(test (scaffold-facts A_qa (R_so R_result R_trans) WhyQuestion causal-qa) ())
!(add-atom &self (scaffold-rule-cost sm 1))

; --- now mint it and read the wrapper back ----------------------------------------------
!(add-all &self (scaffold-facts A_qa (R_so R_result R_trans) WhyQuestion causal-qa))

; a GATED COPY: the activation premise is prepended, the RHS is untouched — so product ids, and
; with them the evaluator's depth-based achievement typing, are exactly as before
!(test (match &self (rule-lhs (gated R_so (strat A_qa)) $l) $l)
       ((sem-edge (ctrlg (strat A_qa)) (var p) Primed (strat A_qa))
        (sem-edge (var g) (var e) So (var x) (var y))
        (sem-edge-tv (var g) (var e) (var tv))))
!(test (== (match &self (rule-rhs (gated R_so (strat A_qa)) $l) $l)
           (match &self (rule-rhs R_so $l2) $l2)) True)
!(test (cost-of (gated R_so (strat A_qa))) ((sm 1)))

; THE SUCCESS TRACE IS STRICT. At the motif level a one-hop and a chained product are the SAME
; thing — both a bare ReasonFor — so no motif could tell them apart:
!(test (== (rule-product R_so) (rule-product R_trans)) True)
; ...which is why the trace premises on the delivering member's own RHS pattern, provenance id
; included. Only a completed chain mints a `(trans …)` id, so a food-fed one-hop cannot claim
; the success of a chain it never took part in.
!(test (match &self (rule-lhs (worked R_trans (strat A_qa)) $l) $l)
       ((sem-edge (var g) (trans (var e1) (var e2)) ReasonFor (var x) (var z))))

; THE RING the chain could not form on its own: Primed → (the chain's work) → Worked → Habit →
; Primed, with `recall` as the way in from an arriving cue
!(test (match &self (rule-lhs (recall (strat A_qa)) $l) $l)
       ((sem-edge (var g) (var e) WhyQuestion (var q))))
!(test (match &self (rule-rhs (worked R_trans (strat A_qa)) $l) $l)
       ((sem-edge (ctrlg (strat A_qa)) (wk (strat A_qa)) Worked (strat A_qa))))
!(test (match &self (rule-rhs (learn (strat A_qa)) $l) $l)
       ((sem-edge (ctrlg (strat A_qa)) (hb (strat A_qa)) Habit (strat A_qa))))
!(test (match &self (rule-lhs (prime (strat A_qa)) $l) $l)
       ((sem-edge (ctrlg (strat A_qa)) (var h) Habit (strat A_qa))))
!(test (match &self (rule-rhs (prime (strat A_qa)) $l) $l)
       ((sem-edge (ctrlg (strat A_qa)) (pr (strat A_qa)) Primed (strat A_qa))))
; `recall` and `prime` mint DIFFERENT ids, so the way in and the closing edge can both fire
!(test (== (match &self (rule-rhs (recall (strat A_qa)) $l) $l)
           (match &self (rule-rhs (prime (strat A_qa)) $l2) $l2)) False)

; THE OFFSPRING: an organism owning the wrapper, with its own genome and its own dequote price —
; required, since expression fails closed and an unpriced genome could never be expressed
!(test (msort (collapse (match &self (ruleset-member (rs (strat A_qa)) $r) $r)))
       ((gated R_result (strat A_qa)) (gated R_so (strat A_qa)) (gated R_trans (strat A_qa))
        (learn (strat A_qa)) (prime (strat A_qa)) (recall (strat A_qa)) (worked R_trans (strat A_qa))))
!(test (organism-genome (org (strat A_qa))) (gnm (strat A_qa)))
!(test (genome-cost (gnm (strat A_qa))) ((dq 1)))
!(test (match &self (organism-chamber (org (strat A_qa)) $c) $c) CH_expt1)   ; derived from context

; the control vocabulary the wrapper introduces is declared, which is what lets the closure
; classifier read the resulting closure as control-level rather than substrate
!(test (control-rel? Primed) True)
!(test (control-rel? Worked) True)
!(test (control-rel? Habit) True)
!(test (control-rel? ReasonFor) False)
; and the strategy carries its routing key + scope as attributes rather than in its name
!(test (match &self (strategy-cue (strat A_qa) $c) $c) WhyQuestion)
!(test (match &self (strategy-context (strat A_qa) $c) $c) causal-qa)
!(test (match &self (strategy-chain (strat A_qa) $c) $c) A_qa)
