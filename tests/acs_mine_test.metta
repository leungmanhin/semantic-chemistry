; ===========================================================================
; ACS LOG-MINING — identify + confirm the mortal-ACS by analyzing the event log.
; ---------------------------------------------------------------------------
; Where acs_scan_test.metta CONFIRMS a hand-given candidate against a HAND-DRAWN graph,
; this DERIVES the graph generically (petta/acs.metta: build-graph over the fired rules'
; canonical IR + the evaluator's closing edge) and DISCOVERS the ACS = the fired rules
; on a metabolic cycle (that reach gm). R_complete falls out STRUCTURALLY — its role-fill
; is consumed by nothing, so it never reaches fuel; no ablation needed. Closure is
; metabolic (cycle only with the evaluator edge); the discovered core spends 19, surplus +6.
;
; Run:  sh ../PeTTa/run.sh tests/acs_mine_test.metta < /dev/null 2>&1 | grep should  # twelve ✅
; ===========================================================================
!(import! &self "petta/kernel.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")
!(import! &self "petta/evaluator.metta")
!(import! &self "petta/acs.metta")   ; fired-rules · build-graph · reaches? · acs-members · acs-spend/surplus

!(add-atom &self (fuel gm 100))
!(add-atom &self (fuel ci 100))
!(run-rules &self)

; build the graph FROM the log: &g_full has the evaluator's closing edge; &g_soma does not
!(bind! &g_full (new-space))
!(build-graph &g_full (fired-rules))
!(add-atom &g_full (medge candidate-answer E))
!(add-atom &g_full (medge E gm))
!(bind! &g_soma (new-space))
!(build-graph &g_soma (fired-rules))

; --- IDENTIFICATION: R_complete falls out (its product reaches no fuel) ---
!(test (len (fired-rules)) 4)                              ; all four rules fired
!(test (reaches? &g_full R_project gm) True)              ; product -> candidate-answer -> E -> gm
!(test (reaches? &g_full R_complete gm) False)            ; role-fill consumed by nothing -> dead-weight
!(test (member-of R_qtype (acs-members &g_full (fired-rules))) True)
!(test (member-of R_align (acs-members &g_full (fired-rules))) True)
!(test (member-of R_project (acs-members &g_full (fired-rules))) True)
!(test (member-of R_complete (acs-members &g_full (fired-rules))) False)
!(test (len (acs-members &g_full (fired-rules))) 3)       ; the ACS = {qtype, align, project}
; --- CLOSURE: metabolic, not structural (cycle only with the evaluator edge) ---
!(test (cycle-through &g_full gm) True)                   ; rules + evaluator: closed cycle
!(test (cycle-through &g_soma gm) False)                  ; soma alone: feed-forward DAG
; --- CONFIRMATION: the discovered ACS runs a surplus ---
!(test (acs-spend &g_full) 19)                            ; member firings (6 qtype + 7 align + 6 project)
!(test (acs-surplus &g_full physical-cause) 6)            ; income 25 - spend 19 = +6 (self-sustaining)
