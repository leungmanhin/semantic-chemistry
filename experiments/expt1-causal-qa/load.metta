; Experiment 1 — DATA LOADER. Imports the pure-fact IR (molecules + QA benchmark
; + configs/mappings) into &self. The PeTTa machinery imports THIS to get Exp-1's
; data; the logic (engine + proposers) is in petta/. The genome is NOT loaded here
; — in the PeTTa port the proposers are code and the fuel is seeded by the runner;
; genome.metta is the Python side's organism/ruleset/cost facts.
!(import! &self "experiments/expt1-causal-qa/molecules.metta")
!(import! &self "experiments/expt1-causal-qa/tasks.metta")
!(import! &self "experiments/expt1-causal-qa/configs.metta")
