; Experiment 1 — the WORKER-DRIVEN pipeline on V3 ("why did the food spoil?"), ONE epoch,
; step by step. Each pipeline stage is a §6.4 worker; the chamber + evaluator + acs-scan
; workers share one isolated hot-pool space &ws_qa (a sequential handoff — the concurrency
; rule only forbids CONCURRENT mutation): the CONTEXT-CHAMBER worker derives the explanatory
; layer, the EVALUATOR worker mints typed fuel on that same space, and the ACS-SCAN worker
; CONSUMES the resulting event log to certify the food-generated autocatalytic loop.
;
; The ACS verdict from ONE epoch is a viable + useful CANDIDATE PRECURSOR — autocatalysis +
; causal influence + this-cycle surplus hold, but there is NO structural closure (the evaluator's
; reward is FOOD, not closure; V3's cue-converters are feed-forward), so it emits no acs-closure
; fact — a subsidized candidate (surplus but no closure). Recurrence + heritability (what make it
; a genuine ACS species) need multiple epochs and are P3.
;
; Run:  sh ../PeTTa/run.sh experiments/expt1-causal-qa/demo.metta < /dev/null 2>&1 \
;         | sed 's/\x1b\[[0-9;]*m//g' | sed -n '/STAGE-0/,$p' | grep '^('
; ===========================================================================
!(import! &self "petta/util.metta")
!(import! &self "petta/fuel.metta")
!(import! &self "petta/compiler.metta")
!(import! &self "petta/gate.metta")
!(import! &self "petta/reaction.metta")
!(import! &self "petta/grounder.metta")
!(import! &self "petta/evaluator.metta")
!(import! &self "petta/epoch.metta")
!(import! &self "petta/worker.metta")
!(import! &self "petta/chamber.metta")
!(import! &self "petta/acs.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")

; --- report helper: the firing count in a worker's space (wrapped in a def so the fold
; reduces cleanly, not as a top-level trace) ---
(= (n-events $ws) (foldall + (match $ws (event $c $s $r $k) 1) 0))

;; the context-chamber worker -- derives the explanatory layer into its own hot-pool space
!(add-atom &self (worker W_qa))
!(add-atom &self (worker-kind W_qa context-chamber))
!(add-atom &self (worker-chamber W_qa CH_expt1))
!(add-atom &self (worker-snapshot W_qa SNAP_qa))
!(bind! &ws_qa (new-space))
!(add-atom &self (worker-space W_qa &ws_qa))

;; the evaluator worker -- mints typed fuel on the SAME space (the sequential handoff)
!(add-atom &self (worker W_eval))
!(add-atom &self (worker-kind W_eval evaluator))
!(add-atom &self (worker-clamp W_eval CL_deep))
!(add-atom &self (worker-space W_eval &ws_qa))

;; the ACS scanner worker -- CONSUMES the chamber's log in &ws_qa; its own graph + ablation
;; spaces are bound at top-level (a worker body cannot mint a new-space)
!(add-atom &self (worker W_scan))
!(add-atom &self (worker-kind W_scan acs-scan))
!(add-atom &self (worker-chamber W_scan CH_expt1))
!(add-atom &self (worker-clamp W_scan CL_deep))
!(add-atom &self (worker-snapshot W_scan SNAP_qa))
!(add-atom &self (worker-acs W_scan A_qa))
!(add-atom &self (worker-space W_scan &ws_qa))
!(bind! &g_acs (new-space))
!(bind! &abl_acs (new-space))
!(add-atom &self (worker-graph-space W_scan &g_acs))
!(add-atom &self (worker-ablate-space W_scan &abl_acs))

;; running the workers -- cycle 1
; ===========================================================================
!(println! (STAGE-0 --- THE-TASK ---))
!(println! (question V3_q1 (match &self (question-surface V3_q1 $s) $s)))

; ===========================================================================
!(println! (STAGE-1 --- CHAMBER-WORKER derive-the-explanatory-layer ---))
!(run-cc W_qa)
!(println! (fired (n-events &ws_qa) rules (fired-rules &ws_qa)))
!(println! (derived-reasons (collapse (match &ws_qa (sem-edge V3g $e ReasonFor $x $y) ($x reason-for $y)))))
!(println! (answers (len (collapse (ground-skeleton &ws_qa V3_q1_as1)))))
!(println! (purses-after-derive O_base-sm (fuel-of &ws_qa O_base sm)
                                O_chain-sm (fuel-of &ws_qa O_chain sm) O_chain-tr (fuel-of &ws_qa O_chain tr)))

; ===========================================================================
!(println! (STAGE-2 --- EVALUATOR-WORKER mint-typed-fuel-on-the-same-space ---))
!(run-eval W_eval)
!(println! (purses-after-mint O_base-sm (fuel-of &ws_qa O_base sm)
                              O_chain-sm (fuel-of &ws_qa O_chain sm) O_chain-tr (fuel-of &ws_qa O_chain tr)))

; ===========================================================================
!(println! (STAGE-3 --- ACS-SCAN-WORKER certify-from-the-log subsidized-candidate ---))
!(run-as W_scan)
!(println! (R_A (collapse (match &self (acs-member A_qa $r) $r))))
!(println! (M_A (collapse (match &self (acs-motif A_qa $m) $m))))
!(println! (closure (closure-of A_qa)
                    autocatalytic (match &self (acs-autocatalytic A_qa $b) $b)))
!(println! (surplus-tr (match &self (acs-surplus A_qa CL_deep tr $n) $n)
                       recurrent (match &self (acs-recurrent A_qa $rb) $rb)))

; ===========================================================================
!(println! (STAGE-4 --- SECOND-EPOCH mimic-another-cycle-on-the-SAME-log ---))
; the epoch loop's per-cycle body, by hand — run-cc/run-eval are one-shot (run-cc would
; re-restore the snapshot fuel, undoing the metabolic depletion). So DECAY cycle 1's derived
; layer -> SET-CYCLE 2 -> RUN-CHAMBER (re-derive; NOT run-cc, so no fuel re-restore) -> the
; evaluator worker mints again (run-eval only mints, safe to reuse). O_chain self-sustains
; under CL_deep, so R_trans fires again and the loop closes a SECOND time.
!(decay &ws_qa)
!(set-cycle &ws_qa 2)
!(run-chamber &ws_qa CH_expt1)
!(run-eval W_eval)
!(println! (cycles-in-log (msort (log-cycles &ws_qa))))
!(println! (answers-cycle-2 (len (collapse (ground-skeleton &ws_qa V3_q1_as1)))
                            O_chain-tr (fuel-of &ws_qa O_chain tr)))

; ===========================================================================
!(println! (STAGE-5 --- ACS-RE-CERTIFY now-recurrent-over-the-2-cycle-log ---))
; a fresh acs worker reads the SAME &ws_qa log — now 2 cycles, so the loop RECURS (>= 2). The
; cycle-2 derived layer (un-decayed) supplies the baseline + the per-cycle surplus.
!(add-atom &self (worker W_scan2))
!(add-atom &self (worker-kind W_scan2 acs-scan))
!(add-atom &self (worker-chamber W_scan2 CH_expt1))
!(add-atom &self (worker-clamp W_scan2 CL_deep))
!(add-atom &self (worker-snapshot W_scan2 SNAP_qa))
!(add-atom &self (worker-acs W_scan2 A_qa2))
!(add-atom &self (worker-space W_scan2 &ws_qa))
!(bind! &g_acs2 (new-space))
!(bind! &abl_acs2 (new-space))
!(add-atom &self (worker-graph-space W_scan2 &g_acs2))
!(add-atom &self (worker-ablate-space W_scan2 &abl_acs2))
!(run-as W_scan2)
!(println! (R_A (collapse (match &self (acs-member A_qa2 $r) $r))))
!(println! (recurrent-NOW (match &self (acs-recurrent A_qa2 $rb) $rb)
                          surplus-tr-CL_deep (match &self (acs-surplus A_qa2 CL_deep tr $n) $n)))

; ===========================================================================
!(println! (STAGE-6 --- CL_shallow-CONTRAST the-same-loop-starved-to-death ---))
; the SAME pipeline in a SEPARATE space under CL_shallow. The clamp bites ONLY at the evaluator
; (mints no tr) and the acs (promotion); the chamber derivation is identical, so its worker is
; here only for space-isolation. chamber-derive -> eval (no tr) -> 2nd epoch (R_trans starves)
; -> certify (the loop stopped closing -> recurrent False; tr surplus fails -> the loop starves).
; --- chamber worker: identical derivation, its own space ---
!(add-atom &self (worker W_qa_s))
!(add-atom &self (worker-kind W_qa_s context-chamber))
!(add-atom &self (worker-chamber W_qa_s CH_expt1))
!(add-atom &self (worker-snapshot W_qa_s SNAP_qa))
!(bind! &ws_s (new-space))
!(add-atom &self (worker-space W_qa_s &ws_s))
!(run-cc W_qa_s)
; --- evaluator worker under CL_shallow: mints sm but NO tr (the typed starvation begins) ---
!(add-atom &self (worker W_eval_s))
!(add-atom &self (worker-kind W_eval_s evaluator))
!(add-atom &self (worker-clamp W_eval_s CL_shallow))
!(add-atom &self (worker-space W_eval_s &ws_s))
!(run-eval W_eval_s)
!(println! (mint-CL_shallow-earns-no-tr O_chain-tr (fuel-of &ws_s O_chain tr)))
; --- 2nd epoch under CL_shallow: O_chain has no tr, so R_trans can fire nothing -> the root
; (chain) answer dies (2 -> 1) ---
!(decay &ws_s)
!(set-cycle &ws_s 2)
!(run-chamber &ws_s CH_expt1)
!(run-eval W_eval_s)
!(println! (answers-cycle-2-root-dies (len (collapse (ground-skeleton &ws_s V3_q1_as1)))))
; --- certify under CL_shallow on the SAME &ws_s log: the loop stopped closing in cycle 2 ---
!(add-atom &self (worker W_scan_s))
!(add-atom &self (worker-kind W_scan_s acs-scan))
!(add-atom &self (worker-chamber W_scan_s CH_expt1))
!(add-atom &self (worker-clamp W_scan_s CL_shallow))
!(add-atom &self (worker-snapshot W_scan_s SNAP_qa))
!(add-atom &self (worker-acs W_scan_s A_qa_s))
!(add-atom &self (worker-space W_scan_s &ws_s))
!(bind! &g_s (new-space))
!(bind! &abl_s (new-space))
!(add-atom &self (worker-graph-space W_scan_s &g_s))
!(add-atom &self (worker-ablate-space W_scan_s &abl_s))
!(run-as W_scan_s)
!(println! (CL_shallow-verdict recurrent (match &self (acs-recurrent A_qa_s $rb) $rb)
                               surplus-tr (match &self (acs-surplus A_qa_s CL_shallow tr $n) $n)))
