; Experiment 1 — DATA LOADER. Imports the pure-fact IR into &self: molecules + QA
; benchmark + configs/mappings + the genome (rules.metta = the canonical per-match
; `rule-lhs`/`rule-rhs` rule bodies, D9). The logic — the generic engine + converter +
; run — is in petta/kernel_defs.metta; fuel is seeded by the runner. (genome.metta is a
; legacy organism/ruleset/cost stub in the tau_* token names; rules.metta uses gm/ci —
; reconciling the token names is a minor later cleanup.) petta/ modules currently import
; the four fact files individually; this loader is the one-import convenience.
!(import! &self "experiments/expt1-causal-qa/molecules.metta")
!(import! &self "experiments/expt1-causal-qa/tasks.metta")
!(import! &self "experiments/expt1-causal-qa/configs.metta")
!(import! &self "experiments/expt1-causal-qa/rules.metta")
