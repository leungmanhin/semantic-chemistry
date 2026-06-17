; ===========================================================================
; EVALUATOR DEFS — the shared $ws-parameterized eq-17 scoring (worker layer).
; ---------------------------------------------------------------------------
; Factored (P4.4) out of ecan_epoch / acs_scan / selection, which all scored
; answers identically. A pure-defs library (no data, no run): IR (answer-skeleton
; / skeleton-class / skeleton-cites) is read from &self, the answer products
; (alignment-cites / candidate-answer / event) from the worker space $ws — so a
; consumer must also import kernel_defs.metta (which loads the IR). Mirrors the
; eq-17 Match of evaluator.metta (which keeps its own &self-only copy as the P1
; standalone demo). See design-decisions D3 (evaluator term-computations are
; worker code, not lifted data) and [[petta-findings]].
; ===========================================================================
(= (covered $ws $q $cls) (foldall + (match $ws (alignment-cites (al $q $cls) $g $e) (match &self (answer-skeleton $q $sk) (match &self (skeleton-class $sk $cls) (match &self (skeleton-cites $sk $g $e) 1)))) 0))
(= (anssize $ws $q $cls) (foldall + (match $ws (alignment-cites (al $q $cls) $g $e) 1) 0))
(= (skelsize $ws $q $cls) (foldall + (match &self (answer-skeleton $q $sk) (match &self (skeleton-class $sk $cls) (match &self (skeleton-cites $sk $g $e) 1))) 0))
(= (would-mint $ws $q $cls $cc) (if (== $cls $cc) (floor-math (* 6 (/ (* (covered $ws $q $cls) (covered $ws $q $cls)) (* (skelsize $ws $q $cls) (anssize $ws $q $cls))))) (if (== $cls abstain) 4 0)))
(= (gm-income $ws $cc) (foldall + (match $ws (candidate-answer $q (a $q $cls)) (would-mint $ws $q $cls $cc)) 0))
(= (gm-spend $ws) (foldall + (match $ws (event $s $r $k) 1) 0))
(= (count-answers $ws) (foldall + (match $ws (candidate-answer $q $a) 1) 0))
