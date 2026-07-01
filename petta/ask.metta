; ===========================================================================
; ASK — answer questions end-to-end (a single-question view of the chamber).
; ---------------------------------------------------------------------------
; Loads the chamber (molecules + tasks + configs + rules), runs the reaction
; (fuel-gated per-match rule firing, MSC §4.3) to fixpoint with ample fuel, then
; reports what the chamber formed for each question: its candidate answers, the
; explanatory edges they cite (relation + source node = provenance), and the
; completed cause-participants. The chamber-level reward shows the clamp-switch
; (income each answer-class mints, eq-17); an empty answer list = ABSTAIN.
;
; Run:  sh ../PeTTa/run.sh petta/ask.metta < /dev/null 2>&1 | grep -E 'ans-for|chamber|clamp'
; ===========================================================================
!(import! &self "experiments/expt1-causal-qa/load.metta")
!(import! &self "petta/kernel.metta")
!(import! &self "petta/evaluator.metta")

; a healthy chamber: ample fuel, so every reachable answer is produced (no starvation)
!(add-atom &self (fuel gm 100))
!(add-atom &self (fuel ci 100))
!(run-rules &self)

; report for question $q: q-word, candidate answers, cited edges (rel + source), participants
(= (report $q)
   (let $w (collapse (match &self (q-word $q $x) $x))
   (let $cands (collapse (match &self (candidate-answer $q $a) $a))
   (let $cites (collapse (match &self (cites $q $c $rel $src $f) (cite $rel $src)))
   (let $fills (collapse (match &self (role-fill $q $c2 $r $fl) (role $r $fl)))
   (println! (ans-for $q word $w answers $cands because $cites participants $fills)))))))

!(report Q7a)
!(report Q7b)
!(report Q3a)
!(report Q17)
!(report Q20)
!(report Q23)

; chamber-level reward (the clamp-switch): what each answer-class mints over the answer set
!(println! (chamber-income physical (gm-income &self physical-cause) intentional (gm-income &self intentional) abstain (abstain-income &self)))
; the V7 dual under the ACTIVE clamp (CL_antecedent = physical-cause): which answer earns fuel
!(println! (Q7a-active-clamp physical-mints (would-mint &self Q7a physical-cause physical-cause) intentional-mints (would-mint &self Q7a intentional physical-cause)))
