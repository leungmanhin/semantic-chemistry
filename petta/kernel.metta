; ===========================================================================
; THE UNIFIED MORTAL KERNEL in PeTTa (TECAN T7) — P0 demo run.
; ---------------------------------------------------------------------------
; The whole P0 kernel in MeTTa: a GENERIC engine (uniform candidates
; `(cand KEY COST PRODS)` + one `walk` that gates on typed fuel, fires, debits,
; logs `(event seq rule key)`, recurses) driven by 5 rule PROPOSERS, sequenced in
; priority order (R_qtype < R_align/R_abstain < R_complete < R_project) exactly as
; src/kernel.py. Typed fuel = `(fuel gm N)`/`(fuel ci N)` facts; affordability +
; debit are componentwise. R_align fires once per (Q,cls) group (cites aggregated).
;
; The engine + 5 proposers + (run) now live in kernel_defs.metta (shared with the
; P4 worker ecology, workers.metta — one source of truth for the hot loop). This
; file is the standalone P0 DEMO: import the body, seed the Python kernel's fuel
; (gm 20 / ci 6), run, and assert log-equivalence.
;
; Seeded with gm 20 / ci 6 it reproduces P0's MORTALITY: 20 firings, 6 candidate-
; answers, and **Q7b STARVES** (aligned but unprojected) — i.e. LOG-EQUIVALENT to
; src/kernel.py (modulo the harmless id renaming `(al/a Q cls)` vs `AL_*`/`A_*`,
; and abstain being its own rule). Verified by the tests below.
;
; Idioms (see memory: petta-findings): derive in &self (&mork can't join);
; case-over-collapse = group-dedup + negation; `skip`+filter-out = "no candidate";
; let-bind before add-atom (add-atom does NOT evaluate its arg); let-force (- n k).
;
; Run:  sh ../PeTTa/run.sh petta/kernel.metta < /dev/null \
;          2>&1 | grep should     # seven ✅
; ===========================================================================
!(import! &self "petta/causal_qa_rules.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")

; --- typed fuel = the Python kernel's seed (gm 20 / ci 6) -> reproduces P0 mortality
!(add-atom &self (fuel gm 20))
!(add-atom &self (fuel ci 6))

; P0 demo: IR + mutable state both in &self, so the worker space IS &self
!(run &self)

; --- verify LOG-EQUIVALENCE to the Python P0 kernel (mortal run, gm20/ci6) ----
!(test (foldall + (match &self (q-intent $q $i) 1) 0) 6)          ; all 6 questions typed
!(test (foldall + (match &self (alignment $al $q $c) 1) 0) 7)     ; 6 positive + 1 abstain (Q23 deduped)
!(test (foldall + (match &self (role-fill $al $r $f) 1) 0) 1)     ; Q7a-phys Experiencer=maria
!(test (foldall + (match &self (event $s $r $k) 1) 0) 20)         ; exactly 20 firings (= Python)
!(test (foldall + (match &self (candidate-answer $q $a) 1) 0) 6)  ; 6 answers (Q7b STARVED)
!(test (foldall + (match &self (candidate-answer Q7b $a) 1) 0) 0) ; Q7b aligned-but-unprojected
!(test (fuelof &self gm) 0)                                       ; fuel exhausted (death)
