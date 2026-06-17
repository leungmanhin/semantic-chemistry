; ===========================================================================
; DUMP harness — print the P0 kernel event log for the end-to-end Python≡PeTTa
; equivalence capstone (src/equivalence.py parses the (EV seq rule key) lines).
; Not a test; seeds the canonical P0 fuel (gm 20 / ci 6) and runs once.
; ===========================================================================
!(import! &self "petta/causal_qa_rules.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")
!(add-atom &self (fuel gm 20))
!(add-atom &self (fuel ci 6))
!(run &self)
!(collapse (match &self (event $s $r $k) (println! (EV $s $r $k))))
