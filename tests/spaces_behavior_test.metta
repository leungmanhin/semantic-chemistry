; ===========================================================================
; MULTI-SPACE BEHAVIOR — battle-test + regression guard for the worker-
; isolation design (namespacing-by-W  vs  separate-space-per-worker).
; ---------------------------------------------------------------------------
; Probed once with println! (throwaway), then frozen here as !(test) with the
; observed values, so the multi-space guarantees the worker ecology relies on
; stay true under future PeTTa changes. The TWO decisive results:
;   Q2  — a fresh (new-space) JOINS under nested match (=2, not the cross-product
;         4): the &mork no-join bug was MORK-FFI-specific, NOT general to nesting.
;   Q7  — a nested match JOINS ACROSS two native spaces (IR in &self ⋈ mutable in
;         &wa = 1): so separate-space workers can keep the read-only IR SHARED in
;         &self and hold ONLY their mutable state per-space (no per-worker IR copy).
; Together with Q3 (space handles are storable in facts) this de-risks the
; separate-space-per-worker approach completely. (See memory: petta-findings.)
;
; Run: sh ../PeTTa/run.sh tests/spaces_behavior_test.metta < /dev/null \
;         2>&1 | grep should     # eleven ✅
; ===========================================================================

; --- setup: two fresh worker spaces ---
!(bind! &wa (new-space))
!(bind! &wb (new-space))
!(add-atom &wa (foo 1))
!(add-atom &wa (foo 2))
!(add-atom &wa (bar 1 a))
!(add-atom &wa (bar 2 b))
!(add-atom &wb (foo 99))

(= (cfoo $s) (foldall + (match $s (foo $x) 1) 0))

; Q1 independence
!(test (cfoo &wa) 2)
!(test (cfoo &wb) 1)

; Q2 JOIN inside a fresh space (the &mork-killer): 2, not the cross-product 4
!(test (foldall + (match &wa (foo $x) (match &wa (bar $x $y) 1)) 0) 2)
; Q2b same join via the (, ...) conjunction form
!(test (foldall + (match &wa (, (foo $x) (bar $x $y)) 1) 0) 2)

; Q3 store a space handle in a &self fact, retrieve, match against it
!(add-atom &self (wspace W1 &wa))
!(add-atom &self (wspace W2 &wb))
(= (cfoo-via $w) (let $s (match &self (wspace $w $sp) $sp) (cfoo $s)))
!(test (cfoo-via W1) 2)
!(test (cfoo-via W2) 1)

; Q4 write via a param handle is isolated
(= (addit $s $a) (add-atom $s $a))
!(addit &wa (foo 3))
!(test (cfoo &wa) 3)
!(test (cfoo &wb) 1)

; Q5 remove-atom via a param space (the engine debits fuel this way)
!(add-atom &wa (fuel sm 5))
(= (rmit $s $a) (remove-atom $s $a))
!(rmit &wa (fuel sm 5))
!(test (foldall + (match &wa (fuel sm $n) 1) 0) 0)

; Q6 copy ALL atoms src->fresh wc (could seed read-only IR into a worker space)
!(bind! &src (new-space))
!(bind! &wc (new-space))
!(add-atom &src (ro x))
!(add-atom &src (ro y))
(= (copy-all $from $to) (collapse (match $from $a (add-atom $to $a))))
!(copy-all &src &wc)
!(test (foldall + (match &wc (ro $z) 1) 0) 2)

; Q7 CROSS-SPACE join: IR in &self, mutable in &wa, join on a shared id => 1
!(add-atom &self (ir-node n1 red))
!(add-atom &wa (mark n1))
!(test (foldall + (match &self (ir-node $n $c) (match &wa (mark $n) 1)) 0) 1)
