;; sh ../PeTTa/run.sh experiments/expt1-causal-qa/demo.metta < /dev/null 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | grep '^> '

!(import_prolog_function atomic_list_concat)
!(import! &self "petta/util.metta")
!(import! &self "petta/fuel.metta")
!(import! &self "petta/compiler.metta")
!(import! &self "petta/gate.metta")
!(import! &self "petta/reaction.metta")
!(import! &self "petta/grounder.metta")
!(import! &self "petta/evaluator.metta")
!(import! &self "petta/worker.metta")
!(import! &self "petta/epoch.metta")
!(import! &self "petta/chamber.metta")
!(import! &self "petta/acs.metta")
!(import! &self "experiments/expt1-causal-qa/molecules.metta")
!(import! &self "experiments/expt1-causal-qa/rules.metta")
!(import! &self "experiments/expt1-causal-qa/tasks.metta")
!(import! &self "experiments/expt1-causal-qa/configs.metta")

(= (pp $lst) (println! (atomic_list_concat (cons-atom "> " $lst))))

;; --- purse + mortality display helpers ---
;; the tokens + balances organism $O currently holds in space $ws
(= (purse $ws $O) (collapse (match $ws (fuel $O $t $n) ($t $n))))
;; the rules organism $O owns (via its genome's ruleset)
(= (org-rules $O)
   (filter-out skip (collapse (match &self (ruleset-member $rs $r)
                              (if (== (owner-of-ruleset $rs) $O) $r skip)))))
;; the (token n) cost vector of rule $r
(= (rule-cost $r) (collapse (match &self (rule-token-cost $r $t $n) ($t $n))))
;; can $O still afford to fire ANY of rules $rs from its current purse?
(= (can-fire? $ws $O $rs)
   (if (== $rs ()) False
       (if (afford? $ws $O (rule-cost (car-atom $rs))) True (can-fire? $ws $O (cdr-atom $rs)))))
;; alive iff it can still fire >= 1 of its rules; else starved to death (permanent deadlock)
(= (life $ws $O) (if (can-fire? $ws $O (org-rules $O)) alive DEAD))
;; the per-rule do-influence measured over an $n-task window. $n must arrive as an ARGUMENT:
;; a call left inside the match pattern is matched structurally, not evaluated, so it never binds.
(= (do-inf-win $n) (collapse (match &self (rule-do-influence $r target answer-reward $n $d) ($r $d))))
;; the ids of the ReasonFor edges derived on graph $g -- (norm E) is a one-hop normalization of
;; one cue, (trans E1 E2) a chained explanation, so the provenance names the derivation
(= (reasons $ws $g) (collapse (match $ws (sem-edge $g $i ReasonFor $x $y) $i)))
;; which rules fired in cycle $k of space $ws, in firing order
(= (cycle-rules $ws $k) (collapse (match $ws (event $k $s $r $key) $r)))
;; print one line per cycle the task $t occupied
(= (show-cycles $ws $ks)
   (if (== $ks ()) done
       (let $k (car-atom $ks)
            (let $z (pp ("  cycle " $k ": " (repr (cycle-rules $ws $k))))
                 (show-cycles $ws (cdr-atom $ks))))))

!(pp ("Initial endowment: " (repr (collapse (match &self (snapshot-fuel SNAP_qa $O $tok $n) ($O $tok $n))))))

;; ============================================================================
!(pp ("=============== STAGE 1: one arrival, through the worker layer ==============="))
;; ============================================================================
;; A context-chamber worker derives in its own space, an evaluator worker mints on what it
;; derived, an acs-scan worker certifies the log both left behind. Three §6.4 worker kinds,
;; one sequential handoff, nothing shared but the space they are handed.

!(add-atom &self (worker W_qa))
!(add-atom &self (worker-kind W_qa context-chamber))
!(add-atom &self (worker-chamber W_qa CH_expt1))
!(add-atom &self (worker-snapshot W_qa SNAP_qa))
!(add-atom &self (worker-task W_qa V3))
!(bind! &ws_qa (new-space))
!(add-atom &self (worker-space W_qa &ws_qa))

!(add-atom &self (worker W_eval))
!(add-atom &self (worker-kind W_eval evaluator))
!(add-atom &self (worker-clamp W_eval CL_deep))
!(add-atom &self (worker-space W_eval &ws_qa))

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

!(run-cc W_qa)
!(pp ("Chamber worker on task V3 -- runs the chamber to a standstill:"))
!(pp ("  " (len (fired-rules &ws_qa)) " rules fired = " (repr (fired-rules &ws_qa))))
!(pp ("  " (len (collapse (ground-skeleton &ws_qa V3_q1_as1))) " answers, citing " (repr (reasons &ws_qa V3g))))
!(pp ("  -- the proximate cause ['fridge stopped running'] and, via the chain, the root ['power went out']"))
!(pp ("  spent: sm " (members-spend &ws_qa (fired-rules &ws_qa) sm) " | tr " (members-spend &ws_qa (fired-rules &ws_qa) tr)))

!(run-eval W_eval)
!(pp ("Evaluator worker mints under CL_deep: sm " (chamber-income &ws_qa CL_deep sm) " | tr " (chamber-income &ws_qa CL_deep tr)))
!(pp ("  O_base purse: " (repr (purse &ws_qa O_base)) " -> " (life &ws_qa O_base)))
!(pp ("  O_chain purse: " (repr (purse &ws_qa O_chain)) " -> " (life &ws_qa O_chain)))

!(run-as W_scan)
!(pp ("ACS scanner certifies the log:"))
!(pp ("  R_A: " (repr (collapse (match &self (acs-member A_qa $r) $r)))))
!(pp ("  closure? " (closure-of A_qa) "  (the minting edge is FOOD, so this set is subsidized)"))
!(pp ("  autocatalytic? " (match &self (acs-autocatalytic A_qa $b) $b)))
!(pp ("  surplus? sm " (match &self (acs-surplus A_qa CL_deep sm $ns) $ns) " | tr " (match &self (acs-surplus A_qa CL_deep tr $nt) $nt)))
!(pp ("  causally load-bearing? " (match &self (acs-causal-influence A_qa $ci) $ci)))
!(pp ("  per-rule do-influence over " (window-of &ws_qa) " task(s): " (repr (do-inf-win (window-of &ws_qa)))))
!(pp ("  recurrent? " (match &self (acs-recurrent A_qa $rb) $rb) "  (one arrival is a candidate, not a track record)"))

;; ============================================================================
!(pp ("=============== STAGE 2: a stream of arrivals, under CL_deep ==============="))
;; ============================================================================
;; Recurrence is counted across TASKS: a strategy recurs when it turns again on NEWLY ARRIVED
;; material, not when one question is re-asked. Each task lands in a FRESH hot pool -- only the
;; purse and the event log cross the boundary (MSC eq 8) -- and runs cycles until the chamber
;; settles. The chain advances one hop per cycle (TECAN Alg 5.1), so a task takes three: two to
;; derive, one to discover there is nothing left to do.

!(bind! &ws_st (new-space))
!(restore-snapshot &ws_st SNAP_qa)
!(pp ("Arrivals V3, V4, V5 -- answers per task: " (repr (run-tasks &ws_st CH_expt1 CL_deep (V3 V4 V5) 1 9))))
!(pp ("V3 occupied cycles " (repr (cycles-of-task &ws_st V3)) ":"))
!(show-cycles &ws_st (cycles-of-task &ws_st V3))
!(pp ("Tasks served: " (repr (log-tasks &ws_st))))
!(pp ("  O_base purse: " (repr (purse &ws_st O_base)) " -> " (life &ws_st O_base)))
!(pp ("  O_chain purse: " (repr (purse &ws_st O_chain)) " -> " (life &ws_st O_chain) "  (tr grows: earns 2, spends 1, per arrival)"))

!(add-atom &self (worker W_scan2))
!(add-atom &self (worker-kind W_scan2 acs-scan))
!(add-atom &self (worker-chamber W_scan2 CH_expt1))
!(add-atom &self (worker-clamp W_scan2 CL_deep))
!(add-atom &self (worker-snapshot W_scan2 SNAP_qa))
!(add-atom &self (worker-acs W_scan2 A_qa2))
!(add-atom &self (worker-space W_scan2 &ws_st))
!(bind! &g_acs2 (new-space))
!(bind! &abl_acs2 (new-space))
!(add-atom &self (worker-graph-space W_scan2 &g_acs2))
!(add-atom &self (worker-ablate-space W_scan2 &abl_acs2))

!(run-as W_scan2)
!(pp ("ACS scanner over the stream:"))
!(pp ("  R_A: " (repr (collapse (match &self (acs-member A_qa2 $r) $r)))))
!(pp ("  surplus? sm " (match &self (acs-surplus A_qa2 CL_deep sm $ns) $ns) " | tr " (match &self (acs-surplus A_qa2 CL_deep tr $nt) $nt)))
!(pp ("  causally load-bearing? " (match &self (acs-causal-influence A_qa2 $ci) $ci)))
!(pp ("  per-rule do-influence over " (window-of &ws_st) " task(s): " (repr (do-inf-win (window-of &ws_st)))))
!(pp ("  recurrent? " (match &self (acs-recurrent A_qa2 $rb) $rb) "  (the same strategy turned for every arrival)"))

;; ============================================================================
!(pp ("=============== STAGE 3: the clamp switch -- typed starvation ==============="))
;; ============================================================================
;; The same genome, the same arrivals, a different reward regime. CL_shallow pays for a matched
;; answer skeleton but not for a transitive explanation, so O_chain earns no `tr` -- and `tr` is
;; what R_trans spends to chain. Its seed covers exactly one arrival. From the second, the root
;; cause is out of reach: not a wrong answer, an unaffordable one.

!(bind! &ws_s (new-space))
!(restore-snapshot &ws_s SNAP_qa)
!(pp ("Arrivals V3, V4, V5 -- answers per task: " (repr (run-tasks &ws_s CH_expt1 CL_shallow (V3 V4 V5) 1 9))))
!(pp ("  minted under CL_shallow: sm " (chamber-income &ws_s CL_shallow sm) " | tr " (chamber-income &ws_s CL_shallow tr)))
!(pp ("  O_base purse: " (repr (purse &ws_s O_base)) " -> " (life &ws_s O_base) "  (lives on sm alone)"))
!(pp ("  O_chain purse: " (repr (purse &ws_s O_chain)) " -> " (life &ws_s O_chain)))
!(pp ("V5, the last arrival, occupied cycles " (repr (cycles-of-task &ws_s V5)) ":"))
!(show-cycles &ws_s (cycles-of-task &ws_s V5))
!(pp ("  -- R_trans never enters the queue again: no tr, so it is never an affordable candidate."))
!(pp ("  -- V5's derived layer is now just " (repr (reasons &ws_s V5g)) ": the proximate cause, unchained."))
