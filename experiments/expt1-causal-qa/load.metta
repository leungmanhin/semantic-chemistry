; Experiment 1 — DATA LOADER. Imports the pure-fact IR into &self: molecules + QA
; benchmark + configs/mappings + the genome (rules.metta = the canonical per-match
; `rule-lhs`/`rule-rhs` rule bodies). The logic — the generic engine + converter +
; run — is in petta/kernel.metta; fuel is seeded by the runner. The petta/ modules
; import THIS loader (+ kernel, + evaluator where they score). Tokens: the IR
; uses gm/ci — the PeTTa short symbols for tau_graph_match/tau_causal (see ir/schema.md §1).
!(import! &self "experiments/expt1-causal-qa/molecules.metta")
!(import! &self "experiments/expt1-causal-qa/tasks.metta")
!(import! &self "experiments/expt1-causal-qa/configs.metta")
!(import! &self "experiments/expt1-causal-qa/rules.metta")
