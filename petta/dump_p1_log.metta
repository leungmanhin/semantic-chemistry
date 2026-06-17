; ===========================================================================
; DUMP harness — print the P1 evaluator mints (clamp CL_antecedent) for the
; end-to-end equivalence capstone (src/equivalence.py parses the (MINT Q cls tok n)
; lines). Ample fuel so every answer is produced; mint by the CL_antecedent clamp:
; physical-cause -> gm = floor(6*Match) + tau_causal 2 ; abstain -> gm 4 ; else 0.
; ===========================================================================
!(import! &self "petta/causal_qa_rules.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")
!(import! &self "petta/evaluator_defs.metta")
!(add-atom &self (fuel gm 60))
!(add-atom &self (fuel ci 60))
!(run &self)
(= (dump-mint $q $cls) (case $cls ((physical-cause (let $m (would-mint &self $q $cls physical-cause) (let $z (println! (MINT $q $cls tau_graph_match $m)) (println! (MINT $q $cls tau_causal 2))))) (abstain (println! (MINT $q abstain tau_graph_match 4))) ($other ()))))
!(collapse (match &self (candidate-answer $q (a $q $cls)) (dump-mint $q $cls)))
