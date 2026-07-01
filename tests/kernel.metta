; ===========================================================================
; THE UNIFIED MORTAL KERNEL in PeTTa — P0 demo, CANONICAL per-match form.
; ---------------------------------------------------------------------------
; The whole P0 kernel: the generic ENGINE (kernel_defs) drives the causal-QA genome
; EXPRESSED from its CANONICAL IR (rules.metta: rule-lhs/rule-rhs + (var Name),
; per-match `C ^ G1 ==> G2`). `run-rules` expresses the genome (canonical IR -> runnable
; crules via the converter) then walks the rules in rule-priority order, fuel-gating each
; firing (MSC §4.3 eq 12-16: one firing per match θ, X' = X ⊕ θ(G2) set-union).
;
; Seeded gm 27 / ci 7 it shows P0 MORTALITY: 27 firings, 5 answers, and **Q7b STARVES**
; (aligned but unprojected — gm exhausts at the last projection). Per-match details: R_align
; fires once PER EDGE (7 cites; Q23 cites both causes — use AND overmix — separately); abstain
; is NO soma rule (Q20 produces nothing — the alignment rule simply doesn't match its focus);
; set-add dedups the shared alignment head; role-completion fills each cause's participants.
;
; Run:  sh ../PeTTa/run.sh tests/kernel.metta < /dev/null 2>&1 | grep should     # ten ✅
; ===========================================================================
!(import! &self "petta/kernel_defs.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")

; gm 27 (6 qtype + 7 align + 9 complete + 5 project, then starves) / ci 7 (7 align edges)
!(add-atom &self (fuel gm 27))
!(add-atom &self (fuel ci 7))
!(run-rules &self)

!(test (foldall + (match &self (q-intent $q $i) 1) 0) 6)              ; all 6 questions typed
!(test (foldall + (match &self (alignment $q $c) 1) 0) 6)            ; 6 distinct alignments
!(test (foldall + (match &self (cites $q $c $rel $src $foc) 1) 0) 7)          ; 7 per-edge align firings
!(test (foldall + (match &self (cites Q23 physical-cause CauseOf $src v23_dense) 1) 0) 2)  ; Q23 cites use AND overmix (per-match)
!(test (foldall + (match &self (role-fill $q $c $r $f) 1) 0) 9)      ; cause participants completed
!(test (foldall + (match &self (candidate-answer Q20 $a) 1) 0) 0)   ; Q20 abstains (no edge -> no answer)
!(test (foldall + (match &self (event $s $r $k) 1) 0) 27)            ; 27 firings (gm-starved at last projection)
!(test (foldall + (match &self (candidate-answer $q $a) 1) 0) 5)    ; 5 answers (Q7b STARVED)
!(test (foldall + (match &self (candidate-answer Q7b $a) 1) 0) 0)   ; Q7b aligned-but-unprojected (mortality)
!(test (fuelof &self gm) 0)                                          ; gm exhausted (death)
