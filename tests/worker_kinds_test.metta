; ===========================================================================
; WORKER KINDS: the analysis passes dispatched through the §6.4 worker contract
; (backlog #13) + the §2.9/§2.10 VERDICT facts they emit (backlog #14). One
; dispatcher (petta/workers.metta) routes worker-kind -> body: context-chamber /
; reducer plus acs-scan (run-acs), ecan-epoch (run-epoch), reproduction (run-select).
; Each analysis worker asserts its verdict facts to &self and persists them to
; runs/<id>.metta via a declared worker-output-facts destination.
;
; Run:  sh ../PeTTa/run.sh tests/worker_kinds_test.metta < /dev/null 2>&1 | grep should
; ===========================================================================
!(import! &self "petta/util.metta")
!(import! &self "petta/fuel.metta")
!(import! &self "petta/compiler.metta")
!(import! &self "petta/gate.metta")
!(import! &self "petta/reaction.metta")
!(import! &self "experiments/expt1-causal-qa/load.metta")
!(import! &self "petta/evaluator.metta")
!(import! &self "petta/persist.metta")
!(import! &self "petta/chamber.metta")
!(import! &self "petta/reducer.metta")
!(import! &self "petta/ecan.metta")
!(import! &self "petta/acs.metta")
!(import! &self "petta/selection.metta")
!(import! &self "petta/workers.metta")

; --- populate the chamber's event log in &self (what the acs-scan worker mines) ---
!(add-atom &self (fuel O_qa gm 100))
!(add-atom &self (fuel O_qa ci 100))
!(run-rules &self)

; --- acs-scan worker: mine the ACS, emit + persist the §2.9 verdict facts -----
!(bind! &ws_acs (new-space))
!(add-atom &self (worker W_acs))
!(add-atom &self (worker-kind W_acs acs-scan))
!(add-atom &self (worker-space W_acs &ws_acs))
!(add-atom &self (worker-clamp W_acs CL_antecedent))
!(add-atom &self (worker-acs W_acs ACS_e1))
!(add-atom &self (worker-output-facts W_acs ACSV_e1))
!(dispatch W_acs)

!(test (foldall + (match &self (acs-member ACS_e1 $r) 1) 0) 3)          ; 3 ACS members (R_complete excluded)
!(test (match &self (acs-closure ACS_e1 $c) $c) metabolic)              ; closure is metabolic
!(test (match &self (acs-surplus ACS_e1 physical-cause gm $n) $n) 6)    ; surplus +6
!(test (match &self (acs-promoted ACS_e1 physical-cause $b) $b) True)   ; promoted under the antecedent clamp

; --- ecan-epoch worker: a chamber run with metabolic feedback in its own space ---
!(bind! &ws_epoch (new-space))
!(add-atom &self (worker W_epoch))
!(add-atom &self (worker-kind W_epoch ecan-epoch))
!(add-atom &self (worker-chamber W_epoch CH_expt1))
!(add-atom &self (worker-space W_epoch &ws_epoch))
!(add-atom &self (worker-snapshot W_epoch SNAP_epoch))
!(add-atom &self (worker-clamp W_epoch CL_antecedent))
!(add-atom &self (worker-output-log W_epoch LOG_epoch))
!(add-atom &self (snapshot-fuel SNAP_epoch O_qa gm 23))
!(add-atom &self (snapshot-fuel SNAP_epoch O_qa ci 20))
!(dispatch W_epoch)

!(test (match &self (worker-summary W_epoch answers $a) $a) 6)          ; feedback completes 6/6
!(test (match &self (worker-summary W_epoch firings $f) $f) 28)         ; 28 firings
!(test (match &self (worker-summary W_epoch fuel O_qa gm $g) $g) 16)    ; ends alive with 16 gm
!(test (match &self (worker-summary W_epoch fuel O_qa ci $g) $g) 13)    ; ...and 13 ci (7 R_align firings off the 20 seed) — every token's purse is reported

; --- reproduction worker: one lineage step, emit + persist the §2.10 verdict facts ---
!(add-atom &self (worker W_repro))
!(add-atom &self (worker-kind W_repro reproduction))
!(add-atom &self (worker-clamp W_repro CL_antecedent))
!(add-atom &self (worker-lineage W_repro LIN_e1 GNM_qa GNM_g1))
!(add-atom &self (worker-mutation W_repro R_complete))
!(add-atom &self (worker-output-facts W_repro LINV_e1))
!(bind! &sp_parent (new-space))
!(bind! &sp_child (new-space))
!(add-atom &self (worker-space-parent W_repro &sp_parent))
!(add-atom &self (worker-space-child W_repro &sp_child))
!(dispatch W_repro)

!(test (match &self (genome-fitness GNM_qa physical-cause gm $n) $n) -3)   ; founder runs a deficit
!(test (match &self (genome-fitness GNM_g1 physical-cause gm $n) $n) 6)    ; pruned child turns a surplus
!(test (match &self (lineage-improvement GNM_qa GNM_g1 gm $n) $n) 9)       ; +9 improvement
!(test (match &self (birth GNM_g1 GNM_qa $mut) $mut) (pruned R_complete))   ; child born by pruning R_complete
