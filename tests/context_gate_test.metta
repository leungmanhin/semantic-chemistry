; ===========================================================================
; CONTEXT-GATE TEST — the generic rule-context gate (gate: rule-eligible-in?).
; ---------------------------------------------------------------------------
; Two SYNTHETIC rules (defined HERE, not in experiments/rules.metta), with identical
; LHS (match every qa-question) but different rule-context: R_ctxok's context is a
; declared chamber-context (causal-qa -> active), R_ctxbad's is not (offtopic ->
; inactive). The engine's context-subsumption gate admits R_ctxok and rejects R_ctxbad,
; so the eligible rule fires (once per qa-question) and the gated rule never does. This
; exercises BOTH branches of the gate — the reject branch single-context Exp-1's own
; data cannot reach on its own. Only tasks + configs are loaded (qa-question to match,
; chamber-context to gate against); no molecules and no Exp-1 rules.
;
; Run:  sh ../PeTTa/run.sh tests/context_gate_test.metta < /dev/null 2>&1 | grep should  # six ✅
; ===========================================================================
!(import! &self "petta/util.metta")
!(import! &self "petta/fuel.metta")
!(import! &self "petta/compiler.metta")
!(import! &self "petta/gate.metta")
!(import! &self "petta/reaction.metta")
!(import! &self "experiments/expt1-causal-qa/tasks.metta")
!(import! &self "experiments/expt1-causal-qa/configs.metta")

; R_ctxok — rule-context is a declared chamber-context (active) -> admitted
!(add-atom &self (rule-priority R_ctxok 5))
!(add-atom &self (rule-context R_ctxok causal-qa))
!(add-atom &self (rule-token-cost R_ctxok sm 1))
!(add-atom &self (rule-lhs R_ctxok ((qa-question (var T) (var Q)))))
!(add-atom &self (rule-rhs R_ctxok ((ctxok-fired (var Q)))))
; R_ctxbad — rule-context declared by no chamber (inactive) -> rejected
!(add-atom &self (rule-priority R_ctxbad 6))
!(add-atom &self (rule-context R_ctxbad offtopic))
!(add-atom &self (rule-token-cost R_ctxbad sm 1))
!(add-atom &self (rule-lhs R_ctxbad ((qa-question (var T) (var Q)))))
!(add-atom &self (rule-rhs R_ctxbad ((ctxbad-fired (var Q)))))
; both synthetic rules belong to a test organism O_ctx, so rule-organism resolves them to
; it (this test owns its organism — it does not depend on the experiment's org config)
!(add-atom &self (organism O_ctx))
!(add-atom &self (genome-of O_ctx GNM_ctx))
!(add-atom &self (genome-token-cost GNM_ctx dq 1))
!(add-atom &self (quoted-ruleset GNM_ctx RS_ctx))
!(add-atom &self (ruleset-member RS_ctx R_ctxok))
!(add-atom &self (ruleset-member RS_ctx R_ctxbad))

!(add-atom &self (fuel O_ctx sm 100))
!(add-atom &self (fuel O_ctx dq 1))
!(add-atom &self (fuel O_ctx tr 100))
!(run-chamber &self CH_expt1)

; the gate predicate directly (scoped to chamber CH_expt1)
!(test (ctx-active-in? CH_expt1 causal-qa) True)     ; causal-qa IS a context of CH_expt1
!(test (ctx-active-in? CH_expt1 offtopic) False)     ; offtopic is not a context of CH_expt1
!(test (rule-eligible-in? CH_expt1 R_ctxok) True)    ; -> admitted to CH_expt1
!(test (rule-eligible-in? CH_expt1 R_ctxbad) False)  ; -> rejected from CH_expt1
; the gate's EFFECT on firing (accept vs reject branch)
!(test (foldall + (match &self (ctxok-fired $q) 1) 0) 4)   ; ACCEPT: eligible rule fires, once per qa-question
!(test (foldall + (match &self (ctxbad-fired $q) 1) 0) 0)  ; REJECT: gated rule never fires
