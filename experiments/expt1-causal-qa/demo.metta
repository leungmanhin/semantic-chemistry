;; sh ../PeTTa/run.sh experiments/expt1-causal-qa/demo.metta < /dev/null 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | grep '^> '

!(import_prolog_function atomic_list_concat)
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
;; the per-rule do-influence measured over an $n-cycle window. $n must arrive as an ARGUMENT:
;; a call left inside the match pattern is matched structurally, not evaluated, so it never binds.
(= (do-inf-win $n) (collapse (match &self (rule-do-influence $r target answer-reward $n $d) ($r $d))))

;; the context-chamber worker
!(add-atom &self (worker W_qa))
!(add-atom &self (worker-kind W_qa context-chamber))
!(add-atom &self (worker-chamber W_qa CH_expt1))
!(add-atom &self (worker-snapshot W_qa SNAP_qa))
!(bind! &ws_qa (new-space))
!(add-atom &self (worker-space W_qa &ws_qa))

;; the evaluator worker
!(add-atom &self (worker W_eval))
!(add-atom &self (worker-kind W_eval evaluator))
!(add-atom &self (worker-clamp W_eval CL_deep))
!(add-atom &self (worker-space W_eval &ws_qa))

;; the ACS scanner worker
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

!(pp ("Initial endowment: " (repr (collapse (match &self (snapshot-fuel SNAP_qa $O $tok $n) ($O $tok $n))))))

;; running the workers -- cycle 1
!(run-cc W_qa)
!(pp ("After running the chamber (cycle 1):"))
!(pp ((len (fired-rules &ws_qa)) " rules fired = " (repr (fired-rules &ws_qa))))
!(pp ((len (collapse (ground-skeleton &ws_qa V3_q1_as1))) " answers found:"))
!(pp ("- answer: " (repr (ground-skeleton &ws_qa V3_q1_as1))))
!(pp ("- ['power went out', 'fridge stopped running']"))
!(pp ("Chamber used: sm " (members-spend &ws_qa (fired-rules &ws_qa) sm) " | tr " (members-spend &ws_qa (fired-rules &ws_qa) tr)))

!(run-eval W_eval)
!(pp ("Evaluator minted (CL_deep): sm " (chamber-income &ws_qa CL_deep sm) " | tr " (chamber-income &ws_qa CL_deep tr)))
!(pp ("- O_base purse: " (repr (purse &ws_qa O_base)) " -> " (life &ws_qa O_base)))
!(pp ("- O_chain purse: " (repr (purse &ws_qa O_chain)) " -> " (life &ws_qa O_chain)))

!(run-as W_scan)
!(pp ("ACS scanning identified:"))
!(pp ("- R_A: " (repr (collapse (match &self (acs-member A_qa $r) $r)))))
;; !(pp ("- M_A: " (repr (collapse (match &self (acs-motif A_qa $m) $m)))))
!(pp ("- loop closure? " (closure-of A_qa)))
!(pp ("- loop autocatalytic? " (match &self (acs-autocatalytic A_qa $b) $b)))
!(pp ("- loop surplus? sm " (match &self (acs-surplus A_qa CL_deep sm $ns) $ns) " | tr " (match &self (acs-surplus A_qa CL_deep tr $nt) $nt)))
!(pp ("- loop causal-influence? " (match &self (acs-causal-influence A_qa $ci) $ci)))
!(pp ("- per-rule do-influence (over " (window-of &ws_qa) " cycle(s)): " (repr (do-inf-win (window-of &ws_qa)))))
!(pp ("- loop recurrent? " (match &self (acs-recurrent A_qa $rb) $rb)))

;; running the workers -- cycle 2
!(pp ("Decay removes " (len (derived-edges &ws_qa)) " derived edges + " (len (derived-tvs &ws_qa)) " TVs:"))
!(pp ((repr (derived-edges &ws_qa))))
!(pp ((repr (derived-tvs &ws_qa))))
!(decay &ws_qa)
!(set-cycle &ws_qa 2)

!(run-chamber &ws_qa CH_expt1)
!(pp ("After running the chamber (cycle 2):"))
!(pp ((len (collapse (ground-skeleton &ws_qa V3_q1_as1))) " answers found:"))
!(pp ("- answer: " (repr (ground-skeleton &ws_qa V3_q1_as1))))
!(pp ("- ['power went out', 'fridge stopped running']"))
!(pp ("Chamber used: sm " (members-spend &ws_qa (fired-rules &ws_qa) sm) " | tr " (members-spend &ws_qa (fired-rules &ws_qa) tr)))

!(run-eval W_eval)
!(pp ("Evaluator minted (CL_deep): sm " (chamber-income &ws_qa CL_deep sm) " | tr " (chamber-income &ws_qa CL_deep tr)))
!(pp ("- O_base purse: " (repr (purse &ws_qa O_base)) " -> " (life &ws_qa O_base)))
!(pp ("- O_chain purse: " (repr (purse &ws_qa O_chain)) " -> " (life &ws_qa O_chain)))

;; a 2nd ACS scanner worker -- reads the SAME &ws_qa log (now 2 cycles) so the loop RECURS;
;; its own acs name (A_qa2) + graph/ablation spaces keep its verdicts separate from scan 1
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
!(pp ("ACS scanning identified:"))
!(pp ("- R_A: " (repr (collapse (match &self (acs-member A_qa2 $r) $r)))))
;; !(pp ("- M_A: " (repr (collapse (match &self (acs-motif A_qa2 $m) $m)))))
!(pp ("- loop closure? " (closure-of A_qa)))
!(pp ("- loop autocatalytic? " (match &self (acs-autocatalytic A_qa2 $b) $b)))
!(pp ("- loop surplus? sm " (match &self (acs-surplus A_qa2 CL_deep sm $ns) $ns) " | tr " (match &self (acs-surplus A_qa2 CL_deep tr $nt) $nt)))
!(pp ("- loop causal-influence? " (match &self (acs-causal-influence A_qa2 $ci) $ci)))
!(pp ("- per-rule do-influence (over " (window-of &ws_qa) " cycle(s)): " (repr (do-inf-win (window-of &ws_qa)))))
!(pp ("- loop recurrent? " (match &self (acs-recurrent A_qa2 $rb) $rb)))

!(pp ("Event log:"))
!(pp ((repr (match &ws_qa (event $cycle $seq $rule $key) (event $cycle $seq $rule $key)))))

!(pp ("------------ chamber switch to CL_shallow ------------"))

;; the context-chamber worker
!(add-atom &self (worker W_qa_s))
!(add-atom &self (worker-kind W_qa_s context-chamber))
!(add-atom &self (worker-chamber W_qa_s CH_expt1))
!(add-atom &self (worker-snapshot W_qa_s SNAP_qa))
!(bind! &ws_s (new-space))
!(add-atom &self (worker-space W_qa_s &ws_s))

;; the evaluator worker
!(add-atom &self (worker W_eval_s))
!(add-atom &self (worker-kind W_eval_s evaluator))
!(add-atom &self (worker-clamp W_eval_s CL_shallow))
!(add-atom &self (worker-space W_eval_s &ws_s))

;; running the workers -- cycle 1
!(run-cc W_qa_s)
!(pp ("After running the chamber (cycle 1):"))
!(pp ((len (collapse (ground-skeleton &ws_s V3_q1_as1))) " answer(s) found (cycle 1):"))
!(pp ("- answer: " (repr (ground-skeleton &ws_s V3_q1_as1))))
!(pp ("- ['power went out', 'fridge stopped running']"))
!(pp ("Chamber used: sm " (members-spend &ws_s (fired-rules &ws_s) sm) " | tr " (members-spend &ws_s (fired-rules &ws_s) tr)))

!(run-eval W_eval_s)
!(pp ("Evaluator minted (CL_shallow): sm " (chamber-income &ws_s CL_shallow sm) " | tr " (chamber-income &ws_s CL_shallow tr)))
!(pp ("- O_base purse: " (repr (purse &ws_s O_base)) " -> " (life &ws_s O_base)))
!(pp ("- O_chain purse: " (repr (purse &ws_s O_chain)) " -> " (life &ws_s O_chain)))

;; running the workers -- cycle 2
!(decay &ws_s)
!(set-cycle &ws_s 2)

!(run-chamber &ws_s CH_expt1)
!(pp ("After running the chamber (cycle 2):"))
!(pp ((len (collapse (ground-skeleton &ws_s V3_q1_as1))) " answer(s) found (cycle 2):"))
!(pp ("- answer: " (repr (ground-skeleton &ws_s V3_q1_as1))))
!(pp ("- ['fridge stopped running']"))
!(pp ("Chamber used: sm " (members-spend &ws_s (fired-rules &ws_s) sm) " | tr " (members-spend &ws_s (fired-rules &ws_s) tr)))

!(run-eval W_eval_s)
!(pp ("Evaluator minted (CL_shallow): sm " (chamber-income &ws_s CL_shallow sm) " | tr " (chamber-income &ws_s CL_shallow tr)))
!(pp ("- O_base purse: " (repr (purse &ws_s O_base)) " -> " (life &ws_s O_base)))
!(pp ("- O_chain purse: " (repr (purse &ws_s O_chain)) " -> " (life &ws_s O_chain)))

!(pp ("Event log:"))
!(pp ((repr (match &ws_s (event $cycle $seq $rule $key) (event $cycle $seq $rule $key)))))
