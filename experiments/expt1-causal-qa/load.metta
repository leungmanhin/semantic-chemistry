; Experiment 1 — DATA LOADER. Imports the pure-fact IR into &self: the sem-graph
; molecules + the QA benchmark (questions + answer-skeletons) + the run config + the
; derivation genome (rules.metta: canonical per-match `rule-lhs`/`rule-rhs` IR). The
; logic — the engine (petta/{util,fuel,compiler,gate,reaction}) + the grounder — is
; imported by the consumer; fuel is seeded by the runner. Tokens: sm = skeleton-match
; fuel (tau_graph_match), tr = transitive-explanation fuel (ir/schema.md §1).
!(import! &self "experiments/expt1-causal-qa/molecules.metta")
!(import! &self "experiments/expt1-causal-qa/tasks.metta")
!(import! &self "experiments/expt1-causal-qa/configs.metta")
!(import! &self "experiments/expt1-causal-qa/rules.metta")
