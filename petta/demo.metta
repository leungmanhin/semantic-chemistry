; ===========================================================================
; DEMO — an end-to-end run of the mortal-chemistry pipeline on Exp-1.
; ---------------------------------------------------------------------------
; Answers the Exp-1 causal questions (V7 "Why did Maria drive?" is the running
; example) and, around that, drives EVERY stage prototyped so far — one banner
; per stage, each calling the REAL module (petta/{kernel,evaluator,workers,ecan,
; acs,selection}):
;   STAGE-0  the chamber       — the molecule graph, the question, organism, clamp
;   STAGE-1  P0 reaction        — the genome fires (fuel-gated) -> candidate answers
;   STAGE-2  P4 worker contract — the reaction as an isolated worker; persists its output log
;   STAGE-3  P1 evaluation      — eq-17 scoring + clamp-gated fuel minting (clamp-switch)
;   STAGE-4  P1 metabolic loop  — minting feeds back (epoch): OFF starves, ON self-sustains
;   STAGE-5  P2 ACS detection   — mine the reaction graph; the autocatalytic set; surplus
;   STAGE-6  P3 selection       — fitness = surplus; prune the inert rule; recombine
;
; Run (clean output — drops the loader fact-echo and the PeTTa transpiler trace):
;   sh ../PeTTa/run.sh petta/demo.metta < /dev/null 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | sed -n '/STAGE-0/,$p' | grep '^('
;   (`| grep STAGE` alone gives just the eight stage banners)
; ===========================================================================
!(import! &self "experiments/expt1-causal-qa/load.metta")
!(import! &self "petta/kernel.metta")
!(import! &self "petta/evaluator.metta")
!(import! &self "petta/workers.metta")
!(import! &self "petta/ecan.metta")
!(import! &self "petta/acs.metta")
!(import! &self "petta/selection.metta")

; --- helpers -----------------------------------------------------------------
; a per-question report over space $ws: the q-word (IR) + the products the run wrote
; (candidate answers, cited edges, completed participants); an empty answer list = ABSTAIN
(= (report $ws $q)
   (let* (($w (collapse (match &self (q-word $q $x) $x)))
          ($cands (collapse (match $ws (candidate-answer $q $a) $a)))
          ($cites (collapse (match $ws (cites $q $c $rel $src $f) (cite $rel $src))))
          ($fills (collapse (match $ws (role-fill $q $c2 $r $fl) (role $r $fl)))))
     (println! (ans-for $q word $w answers $cands because $cites participants $fills))))

; the explanatory edges into node $foc, tagged by answer-class (from the molecule graph)
(= (expl-edges-into $foc)
   (filter-out skip
     (collapse (match &self ($rel $src $foc)
                      (case (collapse (match &self (edge-cluster $rel $cls) $cls))
                            ((() skip)
                             ($cs (edge $rel $src -> $foc class (car-atom $cs)))))))))

; the demo's founder genome (the whole loaded ruleset)
(= (founder) (R_qtype R_align R_complete R_project))

; ===========================================================================
!(println! (STAGE-0 --- THE-CHAMBER ---))
!(println! (question Q7a why "Why did Maria drive to the store?" focus v7_drive source V7g))
!(println! (explanatory-edges-into-focus (expl-edges-into v7_drive)))
!(println! (organism (the-organism) genome (all-rules)))
!(println! (active-clamp CL_antecedent rewards-class (match &self (clamp-class CL_antecedent $c) $c)))

; ===========================================================================
!(println! (STAGE-1 --- P0-REACTION the-genome-fires-fuel-gated ---))
!(add-atom &self (fuel O_qa gm 100))
!(add-atom &self (fuel O_qa ci 100))
!(run-rules &self)
!(println! (chamber-totals firings (count-events &self) answers (count-answers &self)))
!(report &self Q7a)
;; !(report &self Q7b)
;; !(report &self Q3a)
;; !(report &self Q17)
;; !(report &self Q20)
;; !(report &self Q23)

; ===========================================================================
!(println! (STAGE-2 --- P4-WORKER-CONTRACT run-W_expt1-own-space-persist-its-output-log ---))
!(bind! &ws_worker (new-space))
!(add-atom &self (worker-space W_expt1 &ws_worker))
!(dispatch W_expt1)
!(println! (worker W_expt1
             firings (match &self (worker-summary W_expt1 firings $f) $f)
             answers (match &self (worker-summary W_expt1 answers $a) $a)
             gm-left (match &self (worker-summary W_expt1 fuel-gm $g) $g)))
!(println! (worker-produced-Q7a (collapse (match &ws_worker (candidate-answer Q7a $a) $a))))
!(println! (worker-output-log-written-to (log-path (match &self (worker-output-log W_expt1 $l) $l))))

; ===========================================================================
!(println! (STAGE-3 --- P1-EVALUATION eq17-minting-and-the-clamp-switch ---))
!(println! (Q7a-mint-under-antecedent-clamp
             physical (would-mint &self Q7a physical-cause physical-cause)
             intentional (would-mint &self Q7a intentional physical-cause)))
!(println! (chamber-gm-income
             clamp-antecedent-physical (gm-income &self physical-cause)
             clamp-goal-intentional (gm-income &self intentional)
             abstain (abstain-income &self)))

; ===========================================================================
!(println! (STAGE-4 --- P1-METABOLIC-CLOSURE the-epoch-loop-pays-its-own-way ---))
!(bind! &ws_off (new-space))
!(add-atom &ws_off (fuel O_qa gm 23))
!(add-atom &ws_off (fuel O_qa ci 20))
!(run-rules &ws_off)
!(println! (feedback-OFF answers (count-answers &ws_off) firings (count-events &ws_off) gm-left (fuelof &ws_off O_qa gm)))
!(bind! &ws_on (new-space))
!(add-atom &ws_on (fuel O_qa gm 23))
!(add-atom &ws_on (fuel O_qa ci 20))
!(epoch &ws_on)
!(println! (feedback-ON answers (count-answers &ws_on) firings (count-events &ws_on) gm-left (fuelof &ws_on O_qa gm)))

; ===========================================================================
!(println! (STAGE-5 --- P2-ACS-DETECTION mine-the-reaction-graph-from-the-log ---))
!(bind! &g (new-space))
!(build-graph &g (fired-rules))
; close the loop with the evaluator's minting edge: candidate-answer -> E -> gm (fuel)
!(add-atom &g (medge candidate-answer E))
!(add-atom &g (medge E gm))
!(println! (rules-that-fired (fired-rules)))
!(println! (ACS-members (acs-members &g (fired-rules))))
!(println! (reaches-fuel R_project (reaches? &g R_project gm) R_complete (reaches? &g R_complete gm)))
!(println! (metabolic-closure cycle-through-gm (cycle-through &g gm)))
!(println! (ACS-economy spend (acs-spend &g) surplus-physical (acs-surplus &g physical-cause)))
; paired-replay ablation: drop R_complete -> same answers (it is inert / dead-weight)
!(bind! &ab_base (new-space))
!(bind! &ab_noComplete (new-space))
!(println! (ablation baseline (ablate-answers none &ab_base) drop-R_complete (ablate-answers R_complete &ab_noComplete)))

; ===========================================================================
!(println! (STAGE-6 --- P3-SELECTION fitness-is-surplus ---))
!(bind! &g_found (new-space))
!(bind! &g_lean (new-space))
!(println! (founder-genome (founder) surplus (express-surplus (founder) &g_found)))
!(println! (pruned-genome (prune R_complete (founder)) surplus (express-surplus (prune R_complete (founder)) &g_lean)))
!(bind! &sa (new-space))
!(bind! &sb (new-space))
!(println! (selection-picks (fitter (founder) (prune R_complete (founder)) &sa &sb)))

; ===========================================================================
!(println! (DONE --- full-P0-to-P3-pipeline-on-Exp-1 ---))
