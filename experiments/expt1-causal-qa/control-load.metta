; Experiment 1 — CONTROL DATA LOADER. Imports the pure-fact IR for the control-closed run: the
; shared sem-graph molecules and questions (unchanged by the control genome) + the control-tier
; task facts + the control run config + the control genome. The substrate genome and run config
; (rules.metta / configs.metta) are deliberately NOT loaded: this run's chamber admits the
; control-qa context only, and loading a second question set into a shared space would shift
; every answer and income total. The logic — the engine (petta/{util,fuel,compiler,gate,reaction})
; + the grounder — is imported by the consumer; fuel comes from the snapshot.
!(import! &self "experiments/expt1-causal-qa/molecules.metta")
!(import! &self "experiments/expt1-causal-qa/tasks.metta")
!(import! &self "experiments/expt1-causal-qa/control-tasks.metta")
!(import! &self "experiments/expt1-causal-qa/control-configs.metta")
!(import! &self "experiments/expt1-causal-qa/control-rules.metta")
