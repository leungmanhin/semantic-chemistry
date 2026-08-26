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
!(import! &self "experiments/expt1-causal-qa/load.metta")
!(import! &self "petta/epoch.metta")
!(import! &self "petta/chamber.metta")
!(import! &self "petta/acs.metta")
!(import! &self "petta/ctrl_scaffold.metta")
!(import! &self "petta/dispatch.metta")

;; ------------ display helpers ------------
(= (pp $lst) (println! (atomic_list_concat (cons-atom "> " $lst))))
(= (ppnl) (pp ()))

;; the tokens + balances organism $O currently holds in space $ws
(= (purse $ws $O) (collapse (match $ws (fuel $O $t $n) ($t $n))))

;; which rules fired in cycle $k of $ws, in firing order
(= (cycle-rules $ws $k) (collapse (match $ws (event $k $s $r $key) $r)))

;; print one line per cycle in $ks, naming the rules that fired in it
(= (show-cycles $ws $ks)
   (if (== $ks ()) done
       (let $k (car-atom $ks)
            (let $z (pp ("    cycle " $k ": " (repr (cycle-rules $ws $k))))
                 (show-cycles $ws (cdr-atom $ks))))))

;; what the rules that fired in $ws cost it, per token
(= (spent $ws $tok) (members-spend $ws (fired-rules $ws) $tok))

;; the §4.5 conditions as the scanner left them for ACS $A. Closure has NO false value: a set
;; that does not close emits no acs-closure fact at all, and `closure-of` reads back `none`.
(= (acs-rules $A) (msort (collapse (match &self (acs-member $A $r) $r))))

;; ACS $A's surplus in token $tok under clamp $cl, as the scanner recorded it
(= (surplus-of $A $cl $tok) (match &self (acs-surplus $A $cl $tok $n) $n))

;; does EVERY costed token run a positive surplus? Condition 3 is componentwise, so one negative
;; component fails it however healthy the others look.
(= (surplus-ok? $A $cl $toks)
   (case $toks
         ((() True)
          ($ne (if (> (surplus-of $A $cl (car-atom $toks)) 0)
                   (surplus-ok? $A $cl (cdr-atom $toks))
                   False)))))

;; the costed tokens and their surpluses as one " | "-separated run of list elements, to be
;; concatenated onto the end of the condition-3 line
(= (surplus-parts $A $cl $toks)
   (case $toks
         ((() ())
          ($ne (let* (($tok (car-atom $toks))
                      ($rest (surplus-parts $A $cl (cdr-atom $toks)))
                      ($head (cons-atom $tok (cons-atom " " (cons-atom (surplus-of $A $cl $tok) ())))))
                 (if (== $rest ()) $head (concat-lists $head (cons-atom " | " $rest))))))))

;; the §4.5 conditions as the scanner left them for ACS $A. Closure has NO false value: a set
;; that does not close emits no acs-closure fact at all, and `closure-of` reads back `none`.
(= (show-acs $A $cl)
   (let* (($toks (members-tokens (acs-rules $A)))
          ($z1 (pp ("    members: " (repr (acs-rules $A)))))
          ($z2 (pp ("    cond 1 closure:       " (closure-of $A))))
          ($z3 (pp ("    cond 2 autocatalytic: " (match &self (acs-autocatalytic $A $b) $b))))
          ($z4 (pp (concat-lists ("    cond 3 surplus:       " (surplus-ok? $A $cl $toks) " -- ")
                                 (surplus-parts $A $cl $toks))))
          ($z6 (pp ("    cond 4 causal:        " (match &self (acs-causal-influence $A $ci) $ci)))))
     (pp ("    recurrent:            " (match &self (acs-recurrent $A $rb) $rb)))))

;; rule $r's canonical IR. The scaffold GENERATES portable facts -- the same rule-lhs/rule-rhs
;; shape the hand-written genome is written in -- so a generated rule is readable, storable and
;; heritable exactly as an authored one is, with nothing engine-private about it.
(= (show-rule $r)
   (let* (($z1 (pp ("    " (repr $r) " | costs " (repr (collapse (match &self (rule-token-cost $r $tk $tn) ($tk $tn)))))))
          ($z2 (pp ("        lhs " (repr (match &self (rule-lhs $r $l) $l))))))
     (pp ("        rhs " (repr (match &self (rule-rhs $r $pr) $pr))))))
(= (show-rules $rs) (if (== $rs ()) done (let $z (show-rule (car-atom $rs)) (show-rules (cdr-atom $rs)))))

;; the cycles in $ks numbered $k0 or later. A task re-posed later in a stream shares its name with
;; its earlier turn, so the cycles of the second turn have to be picked out by number.
(= (cycles-from $ks $k0)
   (case $ks
         ((() ())
          ($ne (let $k (car-atom $ks)
                    (if (>= $k $k0)
                        (cons-atom $k (cycles-from (cdr-atom $ks) $k0))
                        (cycles-from (cdr-atom $ks) $k0)))))))

;; the event log as one line per firing. An (event ...) fact's fourth field is the firing KEY --
;; the instantiated product list, which is what makes a firing unique -- left out here for width.
(= (show-log $es)
   (if (== $es ()) done
       (let (event $c $s $r $k) (car-atom $es)
            (let $z (pp ("    cycle " $c " #" $s " " (repr $r)))
                 (show-log (cdr-atom $es))))))

;; move organism $O's purse from space $from into space $to -- the offspring leaves the chamber
;; its parents ran in carrying exactly what they endowed it with, and nothing else
(= (carry-purse $from $to $O)
   (add-all $to (collapse (match $from (fuel $O $t $n) (fuel $O $t $n)))))
;; ------------ end of helpers ------------

;; ------------ the endowment ------------
;; SNAP_qa seeds enough `tr` and `dq` for the parents to afford REPRODUCTION later. That headroom
;; is a SUBSIDY, not a convenience: no clamp mints `dq`, so expression capacity is non-renewable
;; here, the same standing the control genome's one-off `ex` exploration endowment has. Earning it
;; instead -- MSC §7.1's "reproduction tokens for rule genomes that repeatedly solve variants of
;; the same question type" -- needs the evaluator to mint on RECURRENCE, which it cannot yet see.

!(pp ("=============== Initial Endowment ==============="))
!(bind! &ws (new-space))
!(restore-snapshot &ws SNAP_qa)
!(pp ((repr (collapse (match &self (snapshot-fuel SNAP_qa $O $tok $n) ($O $tok $n))))))
!(ppnl)

;; O_base owns the cue-normalizers R_so/R_result; O_chain owns the chainer R_trans and eats what O_base produces.
;; Neither is a closed loop: both live on minted reward.

;; TWO context-chamber workers over ONE space, each handed one arrival. A worker is the §6.4
;; unit of chamber computation -- it is given a task, works it until the chamber settles, and
;; emits its summary -- while the STREAM is the harness's business: it decides what arrives and
;; in what order. Sharing the space is what lets the purse and the event log carry across the
;; boundary, which is what MSC eq 8 puts inside the organism.

;; the evaluator worker mints on whatever the chamber left in the space
!(add-atom &self (worker W_eval))
!(add-atom &self (worker-kind W_eval evaluator))
!(add-atom &self (worker-clamp W_eval CL_deep))
!(add-atom &self (worker-space W_eval &ws))

;; ============================================================================
!(pp ("=============== TASK 1: 'Why did the food spoil?' ==============="))
;; ============================================================================
!(add-atom &self (worker W_qa1))
!(add-atom &self (worker-kind W_qa1 context-chamber))
!(add-atom &self (worker-chamber W_qa1 CH_expt1))
!(add-atom &self (worker-snapshot W_qa1 SNAP_qa))
!(add-atom &self (worker-task W_qa1 V3))
!(add-atom &self (worker-space W_qa1 &ws))
!(pp ("  context-chamber worker created: W_qa1"))
!(dispatch W_qa1)

!(pp ("  the chamber ran " (len (cycles-of-task &ws V3)) " cycles:"))
!(pp ("  no. of answers found: " (total-answers &ws)))
!(show-cycles &ws (cycles-of-task &ws V3))
!(pp ("  spent: sm " (spent &ws sm) " | tr " (spent &ws tr)))

!(run-eval W_eval)
!(pp ("  evaluator minted (CL_deep): sm " (chamber-income &ws CL_deep sm) " | tr " (chamber-income &ws CL_deep tr)))

!(pp ("  organisms: O_base " (repr (purse &ws O_base)) " | O_chain " (repr (purse &ws O_chain))))
!(ppnl)

;; ============================================================================
!(pp ("=============== TASK 2: 'Why did the shops lose business?' ==============="))
;; ============================================================================
;; A fresh hot pool: task 1's text and everything derived from it retired with the task.
;; Only the purse and the event log crossed the boundary (MSC eq 8).

!(add-atom &self (worker W_qa2))
!(add-atom &self (worker-kind W_qa2 context-chamber))
!(add-atom &self (worker-chamber W_qa2 CH_expt1))
!(add-atom &self (worker-snapshot W_qa2 SNAP_qa))
!(add-atom &self (worker-task W_qa2 V4))
!(add-atom &self (worker-space W_qa2 &ws))
!(pp ("  context-chamber worker created: W_qa2"))
!(dispatch W_qa2)

!(pp ("  the chamber ran " (len (cycles-of-task &ws V4)) " cycles:"))
!(pp ("  no. of answers found: " (total-answers &ws)))
;; the SAME space, so the purse carried -- and the worker numbered its cycles after the ones already logged rather than over them
!(show-cycles &ws (cycles-of-task &ws V4))
!(pp ("  spent: sm " (spent &ws sm) " | tr " (spent &ws tr)))

!(run-eval W_eval)
!(pp ("  evaluator minted (CL_deep): sm " (chamber-income &ws CL_deep sm) " | tr " (chamber-income &ws CL_deep tr)))

!(pp ("  organisms: O_base " (repr (purse &ws O_base)) " | O_chain " (repr (purse &ws O_chain))))
!(ppnl)

;; ============================================================================
!(pp ("=============== ACS SCAN ==============="))
;; ============================================================================
;; The scanner mines the reaction graph out of the two-task log and certifies §4.5 condition by
;; condition. The chain earns its keep and the answers depend on it -- but it does not CLOSE: the
;; cue motifs it eats are food no rule regenerates, and the reward that funds it is food too, so
;; it is a useful strategy that does not close

!(add-atom &self (worker W_scan))
!(add-atom &self (worker-kind W_scan acs-scan))
!(add-atom &self (worker-chamber W_scan CH_expt1))
!(add-atom &self (worker-clamp W_scan CL_deep))
!(add-atom &self (worker-snapshot W_scan SNAP_qa))
!(add-atom &self (worker-acs W_scan ACS_qa))
!(add-atom &self (worker-space W_scan &ws))
!(bind! &g_scan (new-space))
!(bind! &abl_scan (new-space))
!(add-atom &self (worker-graph-space W_scan &g_scan))
!(add-atom &self (worker-ablate-space W_scan &abl_scan))
!(pp ("  ACS scanner worker created: W_scan"))
!(dispatch W_scan)
!(show-acs ACS_qa CL_deep)

;; `none` is not a failing grade: a set that does not close emits no acs-closure fact at all,
;; because a subsidized candidate is not an ACS.

;; scaffoldable = recurs across arrivals AND does not close
!(pp ("  scaffoldable? " (scaffoldable? ACS_qa)))
!(ppnl)

;; ============================================================================
!(pp ("=============== THE CONTROL SCAFFOLD ==============="))
;; ============================================================================
;; The chain keeps working and cannot close on its own, so the system builds the control level
;; that would close it -- gated copies of each member, an activator that fires on the arriving
;; question type, a success trace, and the edge that feeds success back into activation. The
;; wrapper is a RECOMBINANT OFFSPRING of the organisms that contributed the chain (§4.5 "copied,
;; mutated, recombined"), so its parents pay for it, per member each gave.

!(add-atom &self (worker W_cs))
!(add-atom &self (worker-kind W_cs ctrl-scaffold))
!(add-atom &self (worker-acs W_cs ACS_qa))
!(add-atom &self (worker-chamber W_cs CH_scaffold))
!(add-atom &self (worker-space W_cs &ws))
!(pp ("  control-scaffold worker created: W_scan"))

!(pp ("  the chain to wrap: " (repr (msort (acs-chain ACS_qa)))))

;; O_base contributed 2 of its 3 members, O_chain 1, so the bill splits 2:1
!(pp ("  before -- O_base " (repr (purse &ws O_base)) " | O_chain " (repr (purse &ws O_chain))))
!(dispatch W_cs)
!(pp ("  after -- O_base " (repr (purse &ws O_base)) " | O_chain " (repr (purse &ws O_chain))))
!(ppnl)

!(pp ("  === OFFSPRING ==="))
!(pp ("  organism: " (repr (org (strat ACS_qa)))))
!(pp ("  endowed:  " (repr (purse &ws (org (strat ACS_qa))))))
!(pp ("  genome: " (repr (match &self (genome-of (org (strat ACS_qa)) $g) $g))))

;; Its genome, as portable IR: GENERATED facts in the same rule-lhs/rule-rhs form the hand-written
;; genome is authored in, so a derived rule is as readable, as storable and as heritable as one we
;; wrote ourselves. It is admitted to the offspring's OWN chamber, because a gated copy keeps its
;; original's RHS verbatim and so mints identical product ids -- in one chamber the settle guard
;; would let whichever fired first silently win, and telling them apart needs the scored gate.
;; The ring: recall -> the gated copies -> worked -> prime, and prime does from then on
;; what recall did once. Only `recall` eats food; the rest feed each other.
;; Note what reproduction cost the parents: O_base is down to its last few sm and has NO dq left,
;; so it keeps the soma it already has but could never express itself into a new chamber again.

!(show-rules (msort (chamber-rules CH_scaffold)))
!(pp ("  [control-scaffold high-level loop: Primed -> (the chain's own work) -> Worked -> Primed]"))
!(ppnl)

;; ============================================================================
!(pp ("=============== NEW ARRIVALS, NOW TO THE OFFSPRING ==============="))
;; ============================================================================
;; Closure is NOT assumed because the wrapper was built to close. Whether it actually does
;; depends on things only a run can settle -- whether the offspring can afford to express itself,
;; whether the arriving cue really routes to `recall`, and whether the delivering member ever
;; lays down the success trace (its premise carries the (trans ...) provenance id, so only a
;; COMPLETED chain satisfies it). So the offspring is handed arrivals of its own -- texts no
;; ancestor chain has seen -- and the SAME detector, unchanged, reads the log it leaves.

!(bind! &ws_off (new-space))
!(carry-purse &ws &ws_off (org (strat ACS_qa)))

;; the offspring's own snapshot: what its parents actually endowed it with. Its purse is already
;; in the space, so restoring is a no-op here -- the fact is what the scanner's ablation replay
;; re-seeds from, and pairing needs it to be the real endowment.
!(add-atom &self (snapshot-fuel SNAP_wrap (org (strat ACS_qa)) sm 12))
!(add-atom &self (snapshot-fuel SNAP_wrap (org (strat ACS_qa)) tr 3))
!(add-atom &self (snapshot-fuel SNAP_wrap (org (strat ACS_qa)) dq 3))

;; a new evaluator worker
!(add-atom &self (worker W_eval_off))
!(add-atom &self (worker-kind W_eval_off evaluator))
!(add-atom &self (worker-clamp W_eval_off CL_deep))
!(add-atom &self (worker-space W_eval_off &ws_off))

;; ============================================================================
!(pp ("=============== TASK 3: 'Why did the market empty?' ==============="))
;; ============================================================================
!(add-atom &self (worker W_off1))
!(add-atom &self (worker-kind W_off1 context-chamber))
!(add-atom &self (worker-chamber W_off1 CH_scaffold))
!(add-atom &self (worker-snapshot W_off1 SNAP_wrap))
!(add-atom &self (worker-task W_off1 V5))
!(add-atom &self (worker-space W_off1 &ws_off))
!(pp ("  context-chamber worker created: W_off1"))
!(dispatch W_off1)

!(pp ("  the chamber ran " (len (cycles-of-task &ws_off V5)) " cycles:"))
!(pp ("  no. of answers found: " (total-answers &ws_off)))
!(show-cycles &ws_off (cycles-of-task &ws_off V5))
!(pp ("  spent: sm " (spent &ws_off sm) " | tr " (spent &ws_off tr)))
!(run-eval W_eval_off)
!(pp ("  evaluator minted (CL_deep): sm " (chamber-income &ws_off CL_deep sm) " | tr " (chamber-income &ws_off CL_deep tr)))
!(pp ("  offspring: " (repr (purse &ws_off (org (strat ACS_qa))))))
!(ppnl)

;; ============================================================================
!(pp ("=============== TASK 4: 'Why did the bakery shut?' ==============="))
;; ============================================================================
!(add-atom &self (worker W_off2))
!(add-atom &self (worker-kind W_off2 context-chamber))
!(add-atom &self (worker-chamber W_off2 CH_scaffold))
!(add-atom &self (worker-snapshot W_off2 SNAP_wrap))
!(add-atom &self (worker-task W_off2 V6))
!(add-atom &self (worker-space W_off2 &ws_off))
!(pp ("  context-chamber worker created: W_off2"))
!(dispatch W_off2)

!(pp ("  the chamber ran " (len (cycles-of-task &ws_off V6)) " cycles:"))
!(pp ("  no. of answers found: " (total-answers &ws_off)))
!(show-cycles &ws_off (cycles-of-task &ws_off V6))
!(run-eval W_eval_off)
!(pp ("  evaluator minted (CL_deep): sm " (chamber-income &ws_off CL_deep sm) " | tr " (chamber-income &ws_off CL_deep tr)))
!(pp ("  offspring: " (repr (purse &ws_off (org (strat ACS_qa))))))  ;; -- it GREW
!(ppnl)

;; ============================================================================
!(pp ("=============== ACS SCAN ==============="))
;; ============================================================================
!(add-atom &self (worker W_scan2))
!(add-atom &self (worker-kind W_scan2 acs-scan))
!(add-atom &self (worker-chamber W_scan2 CH_scaffold))
!(add-atom &self (worker-clamp W_scan2 CL_deep))
!(add-atom &self (worker-snapshot W_scan2 SNAP_wrap))
!(add-atom &self (worker-acs W_scan2 ACS_wrap))
!(add-atom &self (worker-space W_scan2 &ws_off))
!(bind! &g_scan2 (new-space))
!(bind! &abl_scan2 (new-space))
!(add-atom &self (worker-graph-space W_scan2 &g_scan2))
!(add-atom &self (worker-ablate-space W_scan2 &abl_scan2))
!(pp ("  ACS scanner worker created: W_scan2"))
!(dispatch W_scan2)
!(show-acs ACS_wrap CL_deep)

;; !(pp ("  scaffoldable? " (scaffoldable? ACS_wrap) "  -- nothing left to scaffold: it closes now."))
!(ppnl)

;; `recall` is absent from the members: it eats an arriving cue no rule makes,
;; so it peels out as food intake, exactly as the hand-written genome's intake rules do.
;; THE CHAIN THAT COULD NOT CLOSE NOW DOES, at the hybrid level -- the ring regenerates its
;; own control motifs (Primed / Worked) AND the semantic one (ReasonFor) -- and it is
;; viable while it does: every costed component runs a surplus, so the organism is not living
;; off its endowment. All five conditions we detect are satisfied at once.
;;
;; !! READ CONDITION 4 NARROWLY. It is an ALL-OR-NOTHING assay on the whole set (TECAN Alg 5.5's
;; AblationImpact(A)): suppress every member and the answers drop 2 -> 0. It does NOT say each
;; member is load-bearing, and here they are not. The per-member leave-one-out (SC §3 rule-level
;; causal coding, `member-do-influences`) splits the set in two:
;;
;;     gated R_so 12 | gated R_result 20 | gated R_trans 12 | worked 0 | prime 0
;;
;; and the ablation isolates it: suppressing only `worked` + `prime` still answers 2, while
;; suppressing only the three gated copies gives 0. So the condition-4 verdict is carried
;; ENTIRELY by the copied chain; `minimal-acs` accordingly drops both control members and hands
;; back a set that no longer closes -- condition 1 and the minimality search disagreeing about
;; the same rules.
;;
;; The control level contributes CLOSURE and nothing else. `recall` re-primes free on every
;; arrival, so `prime` fires last, after everything needing `Primed` has already fired, and its
;; product is never consumed; the fresh pool means it does not carry to the next task either.
;; The closing edge is redundant with the food-intake rule. This is not a window artifact --
;; Route B's hand-written `R_prime` read 0 over one cycle and 22 over three, whereas this reads
;; 0 over any number of arrivals, because the alternative never falls silent. That is the trade
;; the derived version makes: the hand-written ring was causally essential but could not cross
;; arrivals; this one crosses arrivals and is causally idle. Making the control level earn its
;; keep needs activation to be CONTESTED -- several strategies competing for a scarce gate
;; (THE GATE section below is that gate; the contest is Exp 2's shape) -- or `recall` priced
;; in a token nothing mints, which is the `ex` welfare shape again.

;; ============================================================================
!(pp ("=============== THE CLAMP SWITCH ==============="))
;; ============================================================================
;; Nothing about the wrapper changes. Run the identical genome, from the identical endowment,
;; under CL_shallow -- the same reward regime in every respect but ONE line: it mints no `tr`.
;; The gated chainer costs `tr` per firing, so once the inherited seed is gone the chain is
;; simply never an affordable candidate again, and the ROOT cause drops out of the answer.
;;
;; Note WHERE the drop lands. A clamp governs INCOME, and income is credited AFTER a task is
;; worked -- so switching the clamp cannot change the arrival you switch on. It changes what the
;; organism can afford on the NEXT one. Here the offspring inherited three `tr`, so it chains
;; three more times and the fourth arrival is the first it cannot.
!(bind! &ws_lean (new-space))
!(carry-purse &ws &ws_lean (org (strat ACS_qa)))

!(pp ("The same offspring, same endowment " (repr (purse &ws_lean (org (strat ACS_qa)))) ", under CL_shallow:"))
!(pp ("  answers per arrival (V3, V4, V5, V6): " (repr (run-tasks &ws_lean CH_scaffold CL_shallow (V3 V4 V5 V6) 1 9))))
!(pp ("  purse now: " (repr (purse &ws_lean (org (strat ACS_qa)))) " -- sm still grows, but tr is GONE"))
!(pp ("  the last arrival got only this far:"))
!(show-cycles &ws_lean (cycles-of-task &ws_lean V6))
!(ppnl)

;; no tr, so the gated chainer never enters the queue;
;; and with no chained product there is nothing for `worked` to trace,
;; so the ring stops closing in the same breath.
;; Only the proximate cause survives. Not a wrong answer -- an unaffordable one.
;; So closure and viability are separate conditions because they can DISAGREE:
;; the same ring is a certified ACS under one reward regime and a decaying one under another.

;; ============================================================================
!(pp ("=============== THE EVENT LOG ==============="))
;; ============================================================================
;; L in MSC eq 8: append-only, cycle-tagged, and the thing every later verdict is read off --
;; ACS membership, recurrence across tasks, and the paired ablation replays all mine this.

!(pp ("The parents' log, over the two arrivals they worked:"))
!(show-log (log-facts &ws))

!(pp ("The offspring's log, thriving under CL_deep:"))
!(show-log (log-facts &ws_off))

!(pp ("The same offspring's log, starving under CL_shallow:"))
!(show-log (log-facts &ws_lean))
!(ppnl)

;; ============================================================================
!(pp ("=============== THE GATE (MSC eq 24) ==============="))
;; ============================================================================
;; Where the certificate CASHES OUT. The mortal gate scores every candidate's firing
;; propensity -- sigma over the rule's bookkeeping, each term weighted by its declared
;; (gate-coeff k v) -- and its j-term reads the scan's certificate: "+j*ACSBoost(R) boosts
;; rules that belong to an established ACS". That is the ACS notes' "thereby making the
;; same question-answering strategy more likely to activate again", and it is why the
;; causally idle closing edge above still buys something: closure is what CERTIFIES
;; ACS_wrap, and every member -- `prime` included -- inherits the raised propensity. The
;; parents' chain never closed, so no certificate and no boost, however useful the rules.
;; With ample fuel and nothing competing, the boost decides nothing here; it decides which
;; strategy gets a scarce gate when several contest it, which is Exp 2's shape.

!(add-atom &self (gate-coeff j 2))
!(pp ("Firing propensity under (gate-coeff j 2):"))
!(pp ("  parent R_so (chain never closed, no certificate): " (gate-score &ws (rule-organism R_so) R_so)))
!(pp ("  gated R_so copy (member of certified ACS_wrap):     " (gate-score &ws_off (rule-organism (gated R_so (strat ACS_qa))) (gated R_so (strat ACS_qa)))))
!(pp ("  prime (causally idle -- the SAME certificate):    " (gate-score &ws_off (rule-organism (prime (strat ACS_qa))) (prime (strat ACS_qa)))))

;; and the scheduler's admission bar (MSC eq 13, fire iff U < Gate_C): a threshold set
;; between the two scores admits the packaged strategy and refuses the bare one outright.
;; when no threshold fact exists, `gate-open?` simply imposes no admission bar
;; (that's TECAN Alg 5.1's baseline, whose fire loop pops every affordable candidate — declaring a threshold is what activates MSC eq 13's `U < Gate_C` conjunct)
;; threshold value 0.6 is picked for the demo purely because it sits between the two printed scores (0.5 and 0.881), making the refuse/admit contrast visible

!(add-atom &self (gate-threshold 0.6))
!(pp ("Admission at (gate-threshold 0.6): parent R_so " (gate-open? &ws (rule-organism R_so) R_so)
      " | gated copy " (gate-open? &ws_off (rule-organism (gated R_so (strat ACS_qa))) (gated R_so (strat ACS_qa)))))
