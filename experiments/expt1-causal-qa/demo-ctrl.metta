;; sh ../PeTTa/run.sh experiments/expt1-causal-qa/demo-ctrl.metta < /dev/null 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | grep '^> '

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
!(import! &self "experiments/expt1-causal-qa/control-load.metta")

;; ------------ helpers ------------
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

;; --- control-state display helpers ---
;; the control motifs currently present in $ws, as (Relation edge-id) pairs
(= (ctrl-state $ws) (collapse (match $ws (sem-edge ctrlg $i $r $a) ($r $i))))

;; how many normalized ReasonFor edges the derivation layer holds
(= (n-reasonfor $ws) (foldall + (match $ws (sem-edge V3g $i ReasonFor $x $y) 1) 0))

;; did rule $r fire in cycle $k of $ws's log?
(= (fired-in? $ws $k $r) (if (> (foldall + (match $ws (event $k $s $r $key) 1) 0) 0) YES no))

;; the distinct rules that fired in cycle $k. NOT `fired-rules`, which spans the WHOLE log
;; (it feeds ACS membership mining, which is inherently cross-cycle) and so keeps naming a rule
;; that fired once and has been silent since.
(= (cycle-rules $ws $k) (msort (dedup (collapse (match $ws (event $k $s $r $key) $r)))))

;; the rules $O owns but can no longer afford — priced out of a capability, which is NOT the same
;; as being dead (see `life`: an organism dies only when it can afford NOTHING at all)
(= (starved-rules $ws $O)
   (filter-out skip (collapse (match &self (ruleset-member $rs $r)
                              (if (== (owner-of-ruleset $rs) $O)
                                  (if (afford? $ws $O (rule-cost $r)) skip $r)
                                  skip)))))

;; the do-influence of just the rules in $rs, as measured over a $n-cycle window (the facts are
;; keyed on the rule, so every scan's members land in the same pool — the window tells them apart)
(= (do-inf-of $n $rs)
   (filter-out skip (collapse (match &self (rule-do-influence $r target answer-reward $n $d)
                              (if (in-list? $r $rs) ($r $d) skip)))))
;; the member rules of ACS $A
(= (members-of $A) (msort (collapse (match &self (acs-member $A $r) $r))))

;; print one line per cycle in $ks, naming the rules that fired in it
(= (show-cycles $ws $ks)
   (if (== $ks ()) done
       (let $k (car-atom $ks)
            (let $z (pp ("  cycle " $k ": " (repr (cycle-rules $ws $k))))
                 (show-cycles $ws (cdr-atom $ks))))))
;; ------------ end of helpers ------------

;; the run space the arrivals land in. The task STREAM is the harness's business, not a worker's
;; -- a worker is handed one unit of work -- so the demo poses each arrival itself and lets the
;; evaluator and scanner workers read what it leaves behind.
!(bind! &ws_c (new-space))
!(restore-snapshot &ws_c SNAP_ctrl)

;; the evaluator worker
!(add-atom &self (worker W_eval_c))
!(add-atom &self (worker-kind W_eval_c evaluator))
!(add-atom &self (worker-clamp W_eval_c CL_ctrl))
!(add-atom &self (worker-space W_eval_c &ws_c))

;; the ACS scanner worker #1
!(add-atom &self (worker W_scan_c))
!(add-atom &self (worker-kind W_scan_c acs-scan))
!(add-atom &self (worker-chamber W_scan_c CH_ctrl))
!(add-atom &self (worker-clamp W_scan_c CL_ctrl))
!(add-atom &self (worker-snapshot W_scan_c SNAP_ctrl))
!(add-atom &self (worker-acs W_scan_c A_ctrl))
!(add-atom &self (worker-space W_scan_c &ws_c))
!(bind! &g_ctrl (new-space))
!(bind! &abl_ctrl (new-space))
!(add-atom &self (worker-graph-space W_scan_c &g_ctrl))
!(add-atom &self (worker-ablate-space W_scan_c &abl_ctrl))

;; the ACS scanner worker #2
!(add-atom &self (worker W_scan_c2))
!(add-atom &self (worker-kind W_scan_c2 acs-scan))
!(add-atom &self (worker-chamber W_scan_c2 CH_ctrl))
!(add-atom &self (worker-clamp W_scan_c2 CL_ctrl))
!(add-atom &self (worker-snapshot W_scan_c2 SNAP_ctrl))
!(add-atom &self (worker-acs W_scan_c2 A_ctrl2))
!(add-atom &self (worker-space W_scan_c2 &ws_c))
!(bind! &g_ctrl2 (new-space))
!(bind! &abl_ctrl2 (new-space))
!(add-atom &self (worker-graph-space W_scan_c2 &g_ctrl2))
!(add-atom &self (worker-ablate-space W_scan_c2 &abl_ctrl2))

;; ex is the exploration endowment: no clamp mints it, so it is spent once and never replaced
!(pp ("Initial endowment: " (repr (collapse (match &self (snapshot-fuel SNAP_ctrl $O $tok $n) ($O $tok $n))))))
!(pp ("Question-type markers arriving as food: " (repr (collapse (match &self (sem-edge $g $i WhyQuestion $q) $q)))))

!(pp ("=============== ARRIVAL 1: the ring turns, one hop per cycle ==============="))
;; A task runs cycles until its chamber settles, and each cycle collects its candidates against
;; the state as it stood when the cycle began (TECAN Alg 5.1). So the strategy unfolds a hop at a
;; time and the log spells it out: the question type is noticed, the `ex` exploration endowment
;; ignites the strategy cold, the gated substrate rules derive, the success trace is laid down,
;; the habit is consolidated -- and only then does that habit re-prime the strategy. That last
;; step is the closing edge, and the loop paid for it out of its own product.
!(open-task &ws_c V3)
!(pp ("Answers: " (work-task &ws_c CH_ctrl 1 9 none)))
!(pp ("- 'Why did the food spoil?' -> ['fridge stopped running', 'power went out']"))
!(pp ("The task occupied cycles " (repr (cycles-of-task &ws_c V3)) ":"))
!(show-cycles &ws_c (cycles-of-task &ws_c V3))
!(pp ("  -- the last one found every product already present and fired nothing, which ends the task"))
!(pp ("Control state now: " (repr (ctrl-state &ws_c))))
!(pp ("Chamber used: sm " (members-spend &ws_c (fired-rules &ws_c) sm) " | tr " (members-spend &ws_c (fired-rules &ws_c) tr) " | ex " (members-spend &ws_c (fired-rules &ws_c) ex)))

!(run-eval W_eval_c)
!(pp ("Evaluator minted (CL_ctrl): sm " (chamber-income &ws_c CL_ctrl sm) " | tr " (chamber-income &ws_c CL_ctrl tr)))
!(pp ("- O_ctrl purse: " (repr (purse &ws_c O_ctrl)) " -> " (life &ws_c O_ctrl)))

!(run-as W_scan_c)
!(pp ("ACS scanning identified:"))
!(pp ("- R_A: " (repr (msort (collapse (match &self (acs-member A_ctrl $r) $r))))))
!(pp ("  -- outside it: R_detect and R_explore, which take in food and are not regenerated by it"))
!(pp ("- loop closure? " (closure-of A_ctrl) "  (it regenerates control motifs AND a semantic one)"))
!(pp ("- loop autocatalytic? " (match &self (acs-autocatalytic A_ctrl $b) $b)))
!(pp ("- loop surplus? sm " (match &self (acs-surplus A_ctrl CL_ctrl sm $ns) $ns) " | tr " (match &self (acs-surplus A_ctrl CL_ctrl tr $nt) $nt)))
!(pp ("- loop causally load-bearing? " (match &self (acs-causal-influence A_ctrl $ci) $ci)))
!(pp ("- loop recurrent? " (match &self (acs-recurrent A_ctrl $rb) $rb) "  (one arrival is a candidate, not a track record)"))

!(pp ("=============== ARRIVAL 2: the limit of a hand-written control level ==============="))
;; Recurrence needs the strategy to turn AGAIN, on newly arrived material. It cannot. A task's
;; working material retires with the task, so the habit went with it; and `ex` is a one-off
;; exploration endowment that no clamp mints, so there is nothing left to ignite the strategy
;; cold a second time. The organism is solvent -- it simply has no way to reach itself across
;; the boundary.
!(open-task &ws_c V4)
!(pp ("Control state carried over: " (repr (ctrl-state &ws_c)) "  (nothing -- the pool is fresh)"))
!(pp ("Answers: " (work-task &ws_c CH_ctrl 8 9 none)))
!(pp ("The task occupied cycles " (repr (cycles-of-task &ws_c V4)) ":"))
!(show-cycles &ws_c (cycles-of-task &ws_c V4))
!(pp ("  -- only the food intake fires: R_explore has no endowment, R_prime has no habit to read,"))
!(pp ("     and the gated substrate rules stay shut because nothing primed them."))
!(pp ("- O_ctrl purse: " (repr (purse &ws_c O_ctrl)) " -> " (life &ws_c O_ctrl) "  (not dead -- just unreachable)"))

!(run-as W_scan_c2)
!(pp ("- loop recurrent after two arrivals? " (match &self (acs-recurrent A_ctrl2 $rb2) $rb2)))
!(pp (""))
!(pp ("This is the limit of writing the control level BY HAND: re-activating a strategy on a"))
!(pp ("later task needs the memory to live somewhere the task's pool cannot reach. Deriving the"))
!(pp ("control level instead -- petta/ctrl_scaffold.metta -- is what closes it."))
