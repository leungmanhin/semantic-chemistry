# Cycle Map — Design Reference

This file is a design aid for human reviewers. It is NOT part of the parseable corpus.

## The four cycles

```
                    ┌─────────────────────────────────────────┐
                    │           CYCLE A (production)          │
                    │                                         │
        ┌──── lantern ──R1──> mist-light ──R2──> nightmoths   │
        │     (lit)                              (attracted)   │
        │                                              │ R3   │
        │                                              ▼      │
        │     mire ◄──R5── cauldron ◄──R4── silken-threads    │
        │     essence      harvest         (boiled in sea-water)
        │       │                                              │
        └───────┘ (essence enables more lanterns to be lit)    │
                                                               │
                    ┌────────────────────────────────┐         │
                    │      CYCLE B (regulator)       │         │
                    │                                │         │
            nightmoths (above threshold)             │         │
                  │  R6                              │         │
                  ▼                                  │         │
            sky-cat-descent ──R7──> moth-reduction ──┘ (reduces R3 input)
                  │
                  │ R10
                  ▼
            feathers-fall ─── ┐
                              │           CYCLE C (cross-coupling)
                              │
                              ▼
                    feather-warding ──R15──> wraith-safe lantern-tending
                                                      │
                                                      ▼
                                              (more R1, feeds Cycle A)

                    ┌────────────────────────────────┐
                    │       CYCLE D (counter)        │
                    │                                │
            un-tended-lantern ──R11──> flame-dies-before-dawn
                                                │  R12 (at Sunken Cove)
                                                ▼
                                          wraith-emerges
                                                │  R13
                                                ▼
                                          mire-essence-drained
                                                │  R14
                                                ▼
                                          dim-flame ──> less mist-light (reduces R2)
```

## Context gates

- **R16 (cold wind):** sea-breeze below cold-threshold extinguishes lanterns unless salt-bloom (R17) is added
- **R17 / R18 / R19 / R20 (salt-bloom availability):** chained dependency on new moon + spring tide + tide-pool harvest
- **R21 (wintergloss):** burned alongside mire-essence repels nightmoths (anti-Cycle-A)
- **R22 (cliff-shielding):** location-specific stability (Northcove never loses lanterns to cold)

## Rule-to-cycle index

| Cycle | Rules involved |
|-------|----------------|
| A (production) | R1, R2, R3, R4, R5 |
| B (sky-cat regulator) | R6, R7, R8, R9, R10 |
| C (feather coupling) | R10, R15, R29 |
| D (wraith counter) | R11, R12, R13, R14 |
| Context gates | R16, R17, R18, R19, R20, R21, R22 |
| Social rules | R23, R24, R25, R26, R27 |
| Higher-order | R28, R29, R30 |

## Expected ACS to detect (v0 success criterion)

The primary ACS our system should detect is **Cycle A** (lantern → mist-light → nightmoths → silken-threads → mire-essence → lantern). All five steps must appear in event-log frequencies, and the closure-around-back-to-mire-essence must be inferable from the rule-corpus PLN truth values.

A stronger result would also detect **Cycle C** (the positive feather coupling), since it spans Cycle B's regulator into Cycle A's production — i.e., it's the "the regulator's byproduct helps the producer" closure, which is exactly the kind of nontrivial autocatalysis we want chemistry to surface.

Cycle B and Cycle D are *negative* feedback loops — they should NOT be classified as ACSs (they reduce their own activator), but they should be detectable as regulatory motifs.

## Ablation candidates (for paired-replay reward drop)

Per parent §10.3, we need to ablate the ACS and show benchmark reward drops. Suggested ablations:

1. **Ablate Cycle A:** remove R4 (silken-threads → mire-essence) and confirm QA about why-mire-essence-is-abundant becomes wrong.
2. **Ablate Cycle C:** remove R15 (feathers ward wraiths) and confirm QA about Sunken-Cove safety becomes wrong.
3. **Ablate the cliff-shielding gate (R22):** confirm that QA about why-Northcove-is-stable becomes wrong.

The paired-replay protocol: snapshot before ablation, run QA, restore, score difference.
