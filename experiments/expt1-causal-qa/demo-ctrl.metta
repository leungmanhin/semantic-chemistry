;; sh ../PeTTa/run.sh experiments/expt1-causal-qa/demo-ctrl.metta < /dev/null 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | grep '^> '

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
;; ------------ end of helpers ------------

;; the context-chamber worker
!(add-atom &self (worker W_ctrl))
!(add-atom &self (worker-kind W_ctrl context-chamber))
!(add-atom &self (worker-chamber W_ctrl CH_ctrl))
!(add-atom &self (worker-snapshot W_ctrl SNAP_ctrl))
!(bind! &ws_c (new-space))
!(add-atom &self (worker-space W_ctrl &ws_c))

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
!(pp ("Questions arriving as food: " (repr (collapse (match &self (sem-edge ctrlg $i WhyQuestion $q) $q)))))

!(pp ("============ CYCLE 1 ============"))
!(run-cc W_ctrl)
!(pp ("After running the chamber (cycle 1):"))
!(pp ((len (cycle-rules &ws_c 1)) " rules fired this cycle = " (repr (cycle-rules &ws_c 1))))
!(pp ((total-answers &ws_c) " answers found:"))
!(pp ("- 'Why did the food spoil?'          -> ['fridge stopped running', 'power went out']"))
!(pp ("- 'Why did the fridge stop running?' -> ['power went out']"))
!(pp ("Control state now: " (repr (ctrl-state &ws_c))))
!(pp ("Chamber used: sm " (members-spend &ws_c (fired-rules &ws_c) sm) " | tr " (members-spend &ws_c (fired-rules &ws_c) tr) " | ex " (members-spend &ws_c (fired-rules &ws_c) ex)))

!(run-eval W_eval_c)
!(pp ("Evaluator minted (CL_ctrl): sm " (chamber-income &ws_c CL_ctrl sm) " | tr " (chamber-income &ws_c CL_ctrl tr)))
!(pp ("- O_ctrl purse: " (repr (purse &ws_c O_ctrl)) " -> " (life &ws_c O_ctrl)))
;; !(pp ("- priced out of: " (repr (starved-rules &ws_c O_ctrl)) " -- a lost capability, not a death"))

!(run-as W_scan_c)
!(pp ("ACS scanning identified:"))
!(pp ("- R_A: " (repr (msort (collapse (match &self (acs-member A_ctrl $r) $r))))))
!(pp ("- loop closure? " (closure-of A_ctrl)))  ;; -- the habit exists but has never been USED, so nothing closes yet
!(pp ("- loop surplus? sm " (match &self (acs-surplus A_ctrl CL_ctrl sm $ns) $ns) " | tr " (match &self (acs-surplus A_ctrl CL_ctrl tr $nt) $nt)))
!(pp ("- loop recurrent? " (match &self (acs-recurrent A_ctrl $rb) $rb)))

!(pp ("============ DECAY ============"))
;; the derived layer is forgotten, the habit is not
!(pp ("Decay drops " (len (derived-edges &ws_c)) " derived edges:"))
!(decay &ws_c)
;; !(pp ("- ReasonFor edges surviving: " (n-reasonfor &ws_c) " (the whole explanatory layer must be re-derived)"))
!(pp ("- control state surviving: " (repr (ctrl-state &ws_c))))
!(pp ("- persistent relations: " (repr (match &self (persistent $x) (persistent $x)))))

!(pp ("============ CYCLE 2 ============"))
!(set-cycle &ws_c 2)
!(run-chamber &ws_c CH_ctrl)
!(pp ("After running the chamber (cycle 2):"))
!(pp ((len (cycle-rules &ws_c 2)) " rules fired this cycle = " (repr (cycle-rules &ws_c 2))))
!(pp ((total-answers &ws_c) " answers found:"))
!(pp ("- 'Why did the food spoil?'          -> ['fridge stopped running', 'power went out']"))
!(pp ("- 'Why did the fridge stop running?' -> ['power went out']"))
!(pp ("Control state now: " (repr (ctrl-state &ws_c))))
!(pp ("Chamber used: sm " (members-spend &ws_c (fired-rules &ws_c) sm) " | tr " (members-spend &ws_c (fired-rules &ws_c) tr)))

!(run-eval W_eval_c)
!(pp ("Evaluator minted (CL_ctrl): sm " (chamber-income &ws_c CL_ctrl sm) " | tr " (chamber-income &ws_c CL_ctrl tr)))
!(pp ("- O_ctrl purse: " (repr (purse &ws_c O_ctrl)) " -> " (life &ws_c O_ctrl)))
;; !(pp ("- priced out of: " (repr (starved-rules &ws_c O_ctrl)) " -- a lost capability, not a death"))

!(pp ("============ DECAY ============"))
!(pp ("Decay drops " (len (derived-edges &ws_c)) " derived edges:"))
!(decay &ws_c)
;; !(pp ("- ReasonFor edges surviving: " (n-reasonfor &ws_c) " (the whole explanatory layer must be re-derived)"))
!(pp ("- control state surviving: " (repr (ctrl-state &ws_c))))
!(pp ("- persistent relations: " (repr (match &self (persistent $x) (persistent $x)))))

!(pp ("============ CYCLE 3 ============"))
!(set-cycle &ws_c 3)
!(run-chamber &ws_c CH_ctrl)
!(pp ("After running the chamber (cycle 3):"))
!(pp ((len (cycle-rules &ws_c 3)) " rules fired this cycle = " (repr (cycle-rules &ws_c 3))))
!(pp ((total-answers &ws_c) " answers found:"))
!(pp ("- 'Why did the food spoil?'          -> ['fridge stopped running', 'power went out']"))
!(pp ("- 'Why did the fridge stop running?' -> ['power went out']"))
!(pp ("Control state now: " (repr (ctrl-state &ws_c))))
!(pp ("Chamber used: sm " (members-spend &ws_c (fired-rules &ws_c) sm) " | tr " (members-spend &ws_c (fired-rules &ws_c) tr)))

!(run-eval W_eval_c)
!(pp ("Evaluator minted (CL_ctrl): sm " (chamber-income &ws_c CL_ctrl sm) " | tr " (chamber-income &ws_c CL_ctrl tr)))
!(pp ("- O_ctrl purse: " (repr (purse &ws_c O_ctrl)) " -> " (life &ws_c O_ctrl)))
;; !(pp ("- priced out of: " (repr (starved-rules &ws_c O_ctrl)) " -- a lost capability, not a death"))
;; -- the loop earns more than it burns, so it can keep running indefinitely

!(run-as W_scan_c2)
!(pp ("ACS scanning identified:"))
!(pp ("- R_A: " (repr (msort (collapse (match &self (acs-member A_ctrl2 $r) $r))))))
;; -- outside the loop: (R_detect R_explore) -- they take in food, they are not regenerated by it
!(pp ("- loop closure? " (closure-of A_ctrl2)))
;; -- it regenerates control motifs (Primed/Worked/Habit) AND a semantic one (ReasonFor)
!(pp ("- loop autocatalytic? " (match &self (acs-autocatalytic A_ctrl2 $b) $b)))
!(pp ("- loop surplus? sm " (match &self (acs-surplus A_ctrl2 CL_ctrl sm $ns) $ns) " | tr " (match &self (acs-surplus A_ctrl2 CL_ctrl tr $nt) $nt)))
!(pp ("- loop causal-influence? " (match &self (acs-causal-influence A_ctrl2 $ci) $ci)))
!(pp ("- loop recurrent? " (match &self (acs-recurrent A_ctrl2 $rb) $rb)))
;; -- the whole ring closed in cycles 2 and 3

;; !(pp ("Per-rule do-influence over the loop (leave-one-out, minted reward delta):"))
;; !(pp ("- measured over a " (window-of &ws_c) "-cycle window -- the replay runs as long as the certified log and <= max cap"))
;; !(pp ("- baseline cumulative minted reward: " (windowed-reward &abl_ctrl2 CH_ctrl SNAP_ctrl CL_ctrl (window-of &ws_c) ()) " (11 per cycle = 9 sm + 2 tr)"))
;; !(pp ("- " (repr (do-inf-of (window-of &ws_c) (members-of A_ctrl2)))))
;; !(pp ("- every member is measured the SAME way: skip that one rule, replay a run of the same"))
;; !(pp ("  length, diff the cumulative minted reward. No rule is treated specially."))
;; !(pp ("- what a CONTROL rule needs is the WINDOW: its product acts on the cycle AFTER the one"))
;; !(pp ("  that derives it. Suppress any of the three and the loop flatlines once the cold start"))
;; !(pp ("  is spent, so it forfeits every later cycle's income."))
;; !(pp ("- the same rule, narrower window -- R_prime over ONE cycle: baseline "
;;       (windowed-reward &abl_ctrl2 CH_ctrl SNAP_ctrl CL_ctrl 1 ()) " vs ablated "
;;       (windowed-reward &abl_ctrl2 CH_ctrl SNAP_ctrl CL_ctrl 1 (R_prime)) " => delta 0"))
;; !(pp ("  over TWO cycles: baseline "
;;       (windowed-reward &abl_ctrl2 CH_ctrl SNAP_ctrl CL_ctrl 2 ()) " vs ablated "
;;       (windowed-reward &abl_ctrl2 CH_ctrl SNAP_ctrl CL_ctrl 2 (R_prime)) " => it flatlines."))
;; !(pp ("  Nothing about the rule changed -- only how long we watched."))
;; !(pp ("------------ ablate R_prime, the one edge that closes the ring ------------"))
;; !(bind! &ws_k (new-space))
;; !(copy-molecules &ws_k)
;; !(restore-snapshot &ws_k SNAP_ctrl)
;; !(set-cycle &ws_k 1)
;; !(run-chamber-ablate &ws_k CH_ctrl (R_prime))
;; !(pp ("Cycle 1: " (total-answers &ws_k) " answers -- unaffected, the ex endowment still primes the strategy"))
;; !(decay &ws_k)
;; !(set-cycle &ws_k 2)
;; !(run-chamber-ablate &ws_k CH_ctrl (R_prime))
;; !(pp ("Cycle 2: " (total-answers &ws_k) " answers -- nothing re-primes it, so the strategy stops answering"))
;; !(pp ("- O_ctrl purse: " (repr (purse &ws_k O_ctrl)) " -> " (life &ws_k O_ctrl)))
;; !(pp ("- note it is still SOLVENT: this is not starvation but loss of CLOSURE."))
;; !(pp ("- demo.metta kills an organism by taking away the token it spends;"))
;; !(pp ("  here the organism can still pay, but nothing regenerates the state it needs to act on."))

!(pp ("Event log (cycle seq rule):"))
!(pp ((repr (collapse (match &ws_c (event $cycle $seq $rule $key) (event $cycle $seq $rule $key))))))
