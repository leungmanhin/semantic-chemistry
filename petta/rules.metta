; ===========================================================================
; P0 GENOME LIFTED INTO PeTTa (TECAN T7 backend port) — Experiment 1.
; ---------------------------------------------------------------------------
; The whole QA-strategy genome is now DATA-in-PeTTa: each rule is a nested
; `match` rewrite over &self (nested match = join, add-atom = produce), NOT a
; Python handler. Every product is checked with `test` against the Python kernel
; (src/kernel.py) = the replay oracle. PRODUCT-LEVEL LOG-EQUIVALENCE holds,
; modulo a harmless id renaming: PeTTa ids are compound atoms `(al Q cls)` /
; `(a Q cls)` where Python used strings `AL_Q_cls` / `A_Q_cls` (schema §4
; "modulo harmless ID-allocation differences").
;
; SUBSTRATE NOTES (see memory: petta-findings):
;  • &mork `match` can't join (nested → cross-product; compound templates lose
;    bindings) → derive in &self. The experiment IR is PURE FACTS under
;    experiments/expt1-causal-qa/ (molecules/tasks/configs), loaded by its load.metta.
;  • &self joins correctly but does NOT dedup → "fire once per group" =
;    `(case (collapse (match ...)) ((() skip) ($any do-once)))`; that same
;    case-over-collapse is the negation idiom (Empty list ⇒ no match).
;  • Python's INTENT_MAP / INTENT_CLASSES / EXPLANATORY tables are now data
;    (intent-map / intent-allows / explanatory facts in configs.metta).
;
; This file is a standalone PRODUCT demo: the rules run to fixpoint (no fuel) and
; every product is checked against the Python kernel. The full fuel-gated SELECTION
; loop + event log is the kernel (kernel_defs = engine + causal_qa_rules = proposers).
;
; Run:  sh ../PeTTa/run.sh petta/rules.metta < /dev/null \
;          2>&1 | grep should     # expect six ✅
; ===========================================================================
!(import! &self "experiments/expt1-causal-qa/load.metta")

; --- lookup tables, now DATA -----------------------------------------------

; --- R_qtype : q-word -> q-intent (via intent-map) -------------------------
!(collapse (match &self (qa-question $t $q) (match &self (q-word $q $w) (match &self (intent-map $w $i) (add-atom &self (q-intent $q $i))))))

; --- R_align : cites + provs (per allowed explanatory edge INTO the focus) --
!(collapse (match &self (q-intent $q $i) (match &self (question-source $q $g) (match &self (question-focus $q $foc) (match &self (sem-edge $g $e $rel $src $foc) (match &self (edge-cluster $rel $cls) (match &self (intent-allows $i $cls) ((add-atom &self (alignment-cites (al $q $cls) $g $e)) (add-atom &self (alignment-prov (al $q $cls) $g $src))))))))))

; --- R_align : the alignment fact, once per (Q,cls) (case-over-collapse dedup)
!(collapse (match &self (q-intent $q $i) (match &self (question-source $q $g) (match &self (question-focus $q $foc) (match &self (intent-allows $i $cls) (case (collapse (match &self (sem-edge $g $e $rel $src $foc) (match &self (edge-cluster $rel $cls) yes))) ((() ()) ($any (add-atom &self (alignment (al $q $cls) $q $cls))))))))))

; --- R_abstain : Q with intent but NO explanatory edge into focus (negation) -
!(collapse (match &self (q-intent $q $i) (match &self (question-source $q $g) (match &self (question-focus $q $foc) (case (collapse (match &self (sem-edge $g $e $rel $src $foc) (match &self (edge-cluster $rel $ec) (match &self (explanatory $ec) yes)))) ((() (add-atom &self (alignment (al $q abstain) $q abstain))) ($any ())))))))

; --- R_complete : role edge OUT of the cause (sem-edge from cause, NO cluster)
!(collapse (match &self (alignment-cites (al $q $cls) $g $e) (match &self (sem-edge $g $e $rel $cause $foc) (match &self (sem-edge $g $e2 $rel2 $cause $d) (case (collapse (match &self (edge-cluster $rel2 $x) yes)) ((() (add-atom &self (role-fill (al $q $cls) $rel2 $d))) ($any ())))))))

; --- R_project : assemble candidate-answer + class/abstain + cites/provs/roles
!(collapse (match &self (alignment (al $q $cls) $q $cls) ((add-atom &self (candidate-answer $q (a $q $cls))) (add-atom &self (answer-by (a $q $cls) O_qa)) (if (== $cls abstain) (add-atom &self (answer-abstain (a $q $cls))) (add-atom &self (answer-class (a $q $cls) $cls))))))
!(collapse (match &self (alignment-cites (al $q $cls) $g $e) (add-atom &self (answer-cites (a $q $cls) $g $e))))
!(collapse (match &self (alignment-prov (al $q $cls) $g $s) (add-atom &self (answer-provenance (a $q $cls) $g $s))))
!(collapse (match &self (role-fill (al $q $cls) $r $f) (add-atom &self (answer-role (a $q $cls) $r $f))))

; ===========================================================================
; PRODUCT-EQUIVALENCE TESTS vs the Python kernel (six ✅)
; ===========================================================================
!(test (msort (collapse (match &self (q-intent $q $i) (q-intent $q $i))))
       ((q-intent Q17 explain-prevention) (q-intent Q20 explain) (q-intent Q23 explain) (q-intent Q3a explain-mechanism) (q-intent Q7a explain) (q-intent Q7b explain-goal)))
!(test (msort (collapse (match &self (alignment $al $q $cls) (alignment $al $q $cls))))
       ((alignment (al Q17 physical-cause) Q17 physical-cause) (alignment (al Q20 abstain) Q20 abstain) (alignment (al Q23 physical-cause) Q23 physical-cause) (alignment (al Q3a physical-cause) Q3a physical-cause) (alignment (al Q7a intentional) Q7a intentional) (alignment (al Q7a physical-cause) Q7a physical-cause) (alignment (al Q7b intentional) Q7b intentional)))
!(test (msort (collapse (match &self (candidate-answer $q $a) (candidate-answer $q $a))))
       ((candidate-answer Q17 (a Q17 physical-cause)) (candidate-answer Q20 (a Q20 abstain)) (candidate-answer Q23 (a Q23 physical-cause)) (candidate-answer Q3a (a Q3a physical-cause)) (candidate-answer Q7a (a Q7a intentional)) (candidate-answer Q7a (a Q7a physical-cause)) (candidate-answer Q7b (a Q7b intentional))))
!(test (msort (collapse (match &self (answer-cites $a $g $e) (answer-cites $a $g $e))))
       ((answer-cites (a Q17 physical-cause) V17g p1) (answer-cites (a Q23 physical-cause) V23g k1) (answer-cites (a Q23 physical-cause) V23g k2) (answer-cites (a Q3a physical-cause) V3g c2) (answer-cites (a Q7a intentional) V7g c2) (answer-cites (a Q7a physical-cause) V7g c1) (answer-cites (a Q7b intentional) V7g c2)))
!(test (msort (collapse (match &self (answer-role $a $r $f) (answer-role $a $r $f))))
       ((answer-role (a Q7a physical-cause) Experiencer maria)))
!(test (msort (collapse (match &self (answer-abstain $a) (answer-abstain $a))))
       ((answer-abstain (a Q20 abstain))))
