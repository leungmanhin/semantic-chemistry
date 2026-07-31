; Experiment 1 — CONTROL RUN CONFIG: the chamber, the organism that owns the control genome,
; the clamp, the fuel snapshot, and the two declarations the detector reads — which relations
; PERSIST across the cycle boundary, and which are internally-generated CONTROL states.

(sem-graph ctrlg)
(sem-graph-kind ctrlg control)

(chamber CH_ctrl)
(chamber-context CH_ctrl control-qa)
(chamber-life-history CH_ctrl K-like)

; --- the organism: ONE mortal organism owns the whole genome, so death is the loop's — it dies
; when it can no longer afford to fire any rule it has.
(organism O_ctrl)
(organism-chamber O_ctrl CH_ctrl)
(genome-of O_ctrl GNM_ctrl)
(quoted-ruleset GNM_ctrl RS_ctrl)
(ruleset-member RS_ctrl R_prime)
(ruleset-member RS_ctrl R_detect)
(ruleset-member RS_ctrl R_explore)
(ruleset-member RS_ctrl R_so_rf)
(ruleset-member RS_ctrl R_result_rf)
(ruleset-member RS_ctrl R_trans_rf)
(ruleset-member RS_ctrl R_worked)
(ruleset-member RS_ctrl R_learn)

; --- CONTROL relations: internally-generated control states, as opposed to semantic domain
; motifs. The closure classifier reads these to tell substrate / control / hybrid closure apart.
; WhyQuestion is deliberately NOT declared: it is supplied by the environment, not generated
; inside the system, so it is food rather than an endogenous control motif.
(control-relation Attempting)
(control-relation Primed)
(control-relation Worked)
(control-relation Habit)

; --- the clamp: pays a skeleton match in sm and a chain in tr. The skeleton rate covers the
; ring's six firings per cycle with a margin, so the loop earns more than it burns (eq 19).
(clamp CL_ctrl)
(clamp-mint CL_ctrl skeleton-match sm 3)
(clamp-mint CL_ctrl transitive-explanation tr 2)
(clamp-scope CL_ctrl CH_ctrl)

; --- the fuel SNAPSHOT: enough sm to fund the first cold task before any income arrives, one
; tr to seed the chainer, and a SINGLE ex — the exploration endowment. Nothing mints ex, so it
; is spent once and R_explore falls silent; from then on Primed comes only from the habit.
; The sm headroom also has to absorb the re-derivation the between-task decay forces: forgetting
; the derived layer means an already-explained text is normalized again while the next task is
; worked, so spend grows with the number of arrivals while income stays flat.
(genome-token-cost GNM_ctrl dq 1)
(snapshot-fuel SNAP_ctrl O_ctrl sm 12)
(snapshot-fuel SNAP_ctrl O_ctrl dq 1)
(snapshot-fuel SNAP_ctrl O_ctrl tr 1)
(snapshot-fuel SNAP_ctrl O_ctrl ex 1)
