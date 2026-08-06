; ===========================================================================
; EXPRESSION TEST — dequoting costs fuel (MSC eq 20 `cexpr`, "expression (gated dequoting)").
; ---------------------------------------------------------------------------
; Compiling a quoted rule into a crule is a shared, idempotent build artifact and stays free.
; What costs is having a SOMA: a running instance of a genome in a particular hot pool. MSC
; separates the two in kind — "a dequoted process ∗@P actually runs", and "if the act of
; dequoting is itself token-gated…" — so an organism pays its genome's dequote cost ONCE per
; hot pool. Not per cycle: eq 20 keeps `cmaint` (being alive) apart from `cexpr` (the act of
; dequoting), and charging every cycle would re-implement rent under the wrong name.
; The sharp consequence is a death mode PRIOR to starvation-by-firing: an organism that cannot
; afford to dequote has no soma at all, so none of its rules run however much firing fuel it
; holds. Inert code, not a running process.
;
; Run:  sh ../PeTTa/run.sh tests/expression_test.metta < /dev/null 2>&1 | grep should
; ===========================================================================
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

; the declared costs: each genome dequotes for one dq
!(test (genome-cost GNM_base) ((dq 1)))
!(test (genome-cost GNM_chain) ((dq 1)))
!(test (organism-genome O_base) GNM_base)
; `()` from genome-cost means UNDECLARED, and undeclared is refused — never free (see the
; closing block)
!(test (genome-cost GNM_nosuch) ())

; a purse holds ZERO of a token it has no fact for — not "empty". `afford?` has to be able to
; decide on a token an organism has simply never held.
!(bind! &wz (new-space))
!(test (fuel-of &wz O_base dq) 0)
!(test (afford? &wz O_base ((dq 1))) False)

; --- EXPRESSION: charged once, on the first run, per hot pool ---------------------------
!(bind! &we (new-space))
!(set-task &we V3)
!(copy-molecules &we)
!(restore-snapshot &we SNAP_qa)
!(test (expressed? &we O_base) False)              ; no soma yet
!(test (fuel-of &we O_base dq) 3)
!(set-cycle &we 1)
!(run-chamber-settle &we CH_expt1 none)
!(test (expressed? &we O_base) True)               ; dequoted...
!(test (fuel-of &we O_base dq) 2)                  ; ...and paid for, one dq of the three
!(test (fuel-of &we O_chain dq) 1)                 ; each genome pays its own
!(test (total-answers &we) 2)

; a second cycle does NOT re-charge: the soma is already running, and staying alive is rent
; (`cmaint`), which is a different line of eq 20 and not built here
!(set-cycle &we 2)
!(run-chamber &we CH_expt1)
!(test (fuel-of &we O_base dq) 2)
!(test (foldall + (match &we (fuel O_base dq $n) 1) 0) 1)   ; one balance fact, not a debt

; the soma outlives the task's working material: refresh-pool turns X over, F and L and the
; expression itself ride with the organism
!(refresh-pool &we)
!(test (expressed? &we O_base) True)
; ...but a harness reset clears it, so the loop can be re-run from scratch
!(reset-run &we)
!(test (expressed? &we O_base) False)

; --- NO SOMA: the death mode that comes BEFORE starvation-by-firing ---------------------
; This organism is rich in firing fuel and cannot run at all, because it cannot afford to be
; expressed. Distinct from a starved soma, which is expressed but cannot pay for a candidate.
!(bind! &wn (new-space))
!(set-task &wn V3)
!(copy-molecules &wn)
!(add-atom &wn (fuel O_base sm 100))               ; plenty to fire with...
!(add-atom &wn (fuel O_chain sm 100))
!(add-atom &wn (fuel O_chain tr 100))
!(set-cycle &wn 1)                                 ; ...but no dq at all
!(run-chamber-settle &wn CH_expt1 none)
!(test (expressed? &wn O_base) False)
!(test (collapse (match &wn (event $c $s $r $k) $r)) ())          ; nothing ran
!(test (total-answers &wn) 0)
!(test (fuel-of &wn O_base sm) 100)                ; and nothing was spent trying

; give it just enough to dequote and the same genome comes alive unchanged
!(add-atom &wn (fuel O_base dq 1))
!(add-atom &wn (fuel O_chain dq 1))
!(run-chamber-settle &wn CH_expt1 none)
!(test (expressed? &wn O_base) True)
!(test (total-answers &wn) 2)
!(test (fuel-of &wn O_base dq) 0)

; --- PARTIAL expression: one organism affords a soma, the other does not ----------------
; O_base runs and normalizes the cues; O_chain has no soma, so the chained answer never appears
; even though it holds ample sm and tr.
!(bind! &wp (new-space))
!(set-task &wp V3)
!(copy-molecules &wp)
!(add-atom &wp (fuel O_base sm 100))
!(add-atom &wp (fuel O_base dq 1))
!(add-atom &wp (fuel O_chain sm 100))
!(add-atom &wp (fuel O_chain tr 100))
!(set-cycle &wp 1)
!(run-chamber-settle &wp CH_expt1 none)
!(test (expressed? &wp O_base) True)
!(test (expressed? &wp O_chain) False)
!(test (msort (collapse (match &wp (event $c $s $r $k) $r))) (R_result R_so))  ; R_trans is O_chain's
!(test (total-answers &wp) 1)                      ; the proximate answer only
!(test (fuel-of &wp O_chain tr) 100)               ; untouched: it never got to try

; --- NEVER FREE BY OMISSION -------------------------------------------------------------
; A genome with no declared dequote cost cannot be expressed AT ALL. Expression must not be
; free just because someone forgot to price it: a missing declaration then shows up at once as
; an organism that does not run, rather than as one that quietly runs unpriced — which is the
; failure that would go unnoticed. This organism is rich in every token and still refused.
!(add-atom &self (organism O_unpriced))
!(add-atom &self (genome-of O_unpriced GNM_unpriced))
!(bind! &wu (new-space))
!(add-atom &wu (fuel O_unpriced sm 100))
!(add-atom &wu (fuel O_unpriced dq 100))
!(test (genome-cost GNM_unpriced) ())
!(test (express-organism &wu O_unpriced) undeclared)
!(test (expressed? &wu O_unpriced) False)
; ...and an organism with no genome at all is likewise inert, not free
!(add-atom &self (organism O_genomeless))
!(test (organism-genome O_genomeless) none)
!(test (express-organism &wu O_genomeless) undeclared)
