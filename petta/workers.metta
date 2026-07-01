; ===========================================================================
; WORKERS — the §6.4 worker contract: a dispatcher routing by worker-kind to a
; context-chamber body (own space, fuel from its snapshot, run the kernel on that space,
; summarise to &self) or a reducer (deterministic merge of the per-worker summaries).
; Facts-free; assumes the engine (kernel.metta) is loaded by the consumer. Exercised by
; tests/workers_test.metta.
; ===========================================================================
; route a worker to its kind's body
(= (dispatch $w) (let $k (match &self (worker-kind $w $kind) $kind) (if (== $k context-chamber) (run-cc $w) (if (== $k reducer) (run-reduce $w) unknown-kind))))
; context-chamber worker: own space, fuel from snapshot INTO the worker organism's purse,
; run kernel on $ws, summarise to &self (single-organism Exp-1: the-organism = O_qa)
(= (run-cc $w) (let $ws (match &self (worker-space $w $sp) $sp) (let $snap (match &self (worker-snapshot $w $s) $s) (let $O (the-organism) (let $z1 (add-all $ws (collapse (match &self (snapshot-fuel $snap $t $n) (fuel $O $t $n)))) (let $z2 (run-rules $ws) (emit-summary $w $ws)))))))
; the §6.4 worker output goes to &self, keyed by worker; the LOG stays in $ws
(= (emit-summary $w $ws) (let $f (foldall + (match $ws (event $s $r $k) 1) 0) (let $z1 (add-atom &self (worker-summary $w firings $f)) (let $a (foldall + (match $ws (candidate-answer $q $an) 1) 0) (let $z2 (add-atom &self (worker-summary $w answers $a)) (let $g (fuelof $ws (the-organism) gm) (add-atom &self (worker-summary $w fuel-gm $g))))))))
; reducer: deterministic merge of the per-worker summaries across all workers
(= (run-reduce $w) (let $tf (foldall + (match &self (worker-summary $cw firings $n) $n) 0) (let $z1 (add-atom &self (reduced total-firings $tf)) (let $ta (foldall + (match &self (worker-summary $cw2 answers $m) $m) 0) (add-atom &self (reduced total-answers $ta))))))
