# Parser output → IR adapter

How to convert the semantic parser's **PeTTaChainer PLN** output (produced per
`../semantic-parsing-hitl/prompt.txt`) into this experiment's **portable-facts IR**
(`experiments/expt1-causal-qa/molecules.metta` + `tasks.metta`; shapes in `schema.md` §2.1).
One vignette's parse becomes one graph `G`. These notes are the adapter spec — usable directly
as an LLM instruction, or as the basis for a deterministic script.

## Input — parser PLN

Flat atoms `(: <proof_name> <content> (STV <strength> <confidence>))`, one per line:
- a vignette's **statements** parse to assertions — events Neo-Davidsonian (`(Member <ev> <verb>)`
  + thematic-role atoms + status), copular states flat or reified, causal/discourse links as
  binary relation atoms;
- each **question** parses to one or more **query** lines `(: $prf (And …) $tv)`.

Coreference is symbol reuse **within** a vignette; symbols may collide **across** vignettes
(`sk_drive_1`, `maria` recur), which is why ids are re-scoped per graph (rule 2).

## Output — IR

For each node `N` in graph `G`: `(node-graph G N)` + `(Member N <lemma>)`. Roles and explanatory
links are binary `(Rel Src Dst)` (relation as head). `(node-modal N intended|prevented)` marks a
purpose/goal eventuality or a blocked (non-occurring) event. **Node ids are globally unique**
(per-vignette prefix). No `STV`, no proof-names, no tense/aspect.

## Rules

1. **Graph id** — one graph per vignette: `V<n>g`. Every node gets `(node-graph V<n>g N)`.
2. **Globally-unique ids** — rename every parser symbol (`sk_<x>_<k>`, bare names) to
   `v<n>_<short>` (`sk_drive_1`→`v7_drive`, `maria`→`v7_maria`). Required: id-less binary edges
   would otherwise merge across graphs.
3. **Event / state → node** — `(Member <sk> <lemma>)` → `(node-graph G v<n>_<x>)` +
   `(Member v<n>_<x> <lemma>)`.
4. **Strip wrappers** — drop the `(: <name> … (STV …))` wrapper; keep only the content atom.
5. **Drop non-graph atoms** — tense/aspect status (`Past`/`Future`/`Ongoing`) and circumstantial
   obliques (`Time`/`Location`). Keep the causal graph + its participants.
6. **Thematic roles kept** — `Agent`, `Patient`, `Theme`, `Experiencer`, `Recipient`,
   `Destination`. Normalize `Goal` (a "to <place>" oblique) → `Destination`.
7. **Explanatory / discourse edges kept verbatim** (head + two args): `CauseOf`, `Trigger`,
   `Enable`, `Contribute`, `Prevent`, `Motivate`, `Reason`, `Despite`.
8. **Copular state as a causal endpoint** — keep the reified witness (`(Member v<n>_s <prop>)` +
   `(Experiencer v<n>_s <subj>)`); **drop** the duplicate flat `(Member <subj> <prop>)` the parser
   also emits (the IR uses the node).
9. **Negated-event bundle** — `(: _ (And (Member sk_e v) <roles…> (Past sk_e)) (STV 0.0 _))` →
   unpack to a normal node: `(Member v<n>_e v)` + `(node-modal v<n>_e prevented)` + its roles; drop
   the strength-0 wrapper. The accompanying `(Prevent <p> sk_e)` becomes an ordinary edge into it.
10. **Intended** — `(Intended sk_e)` → `(node-modal v<n>_e intended)`.
11. **Name** — `(Name n "…")` marks a named individual: type the node by the class evident from
    context (people → `(Member v<n>_x person)`) and drop the string. With no evident class the node
    may stay untyped (still a valid edge referent).
12. **GroupOf** — `(GroupOf g <kind>)` → `(Member v<n>_g <kind>)` (drop plurality; the IR does not
    model groups).
13. **Question → task facts** — per question emit `(qa-task T)` / `(qa-source T G)` /
    `(qa-question T Q)` / `(q-word Q W)` / `(question-focus Q F)` / `(question-source Q G)`. `W` is
    the surface question word (`why` / `what-for` / `how` / `why-not` / `what-made` / `how-come`).
    `F` is the **focus** node — the event the asked relation points into (the `<focus>` slot of the
    query's `(CauseOf|Motivate|Prevent $x <focus>)`). The query's relation shape independently
    confirms `W`: `Motivate` alone = *what-for*; `CauseOf` (± `Motivate`) = *why*; a `CauseOf` chain
    = *how*; `Prevent` = *why-not*.

## Consumer-config dependencies

The IR fires correctly only if `configs.metta` matches the heads/roles the parser emits:
- **`edge-cluster`** keys must be the parser's **base/lemma** relation heads:
  `CauseOf`/`Trigger`/`Enable`/`Contribute`/`Prevent` → `physical-cause`, `Motivate`/`Reason` →
  `intentional`, `Despite` → `concession`.
- **`role-relation`** must list every role that appears on a **cause** event (so `R_complete` can
  complete it): `Agent`, `Experiencer`, `Theme`, `Destination`, and `Patient` (action-event causes
  carry `Patient`).

## Worked example — V7

Parser (abbreviated):

    (: e_out_of_milk (Member sk_out_of_milk_1 out_of_milk) (STV 1.0 0.99))
    (: e_out_of_milk_exp (Experiencer sk_out_of_milk_1 maria) (STV 1.0 0.99))
    (: e_out_of_milk_past (Past sk_out_of_milk_1) (STV 1.0 0.99))
    (: maria_out_of_milk (Member maria out_of_milk) (STV 1.0 0.99))
    (: e_drive (Member sk_drive_1 drive) (STV 1.0 0.99))
    (: e_drive_goal (Goal sk_drive_1 sk_store_1) (STV 1.0 0.99))
    (: e_buy_intended (Intended sk_buy_1) (STV 1.0 0.99))
    (: c_out_of_milk_drive (CauseOf sk_out_of_milk_1 sk_drive_1) (STV 1.0 0.99))
    (: m_buy_drive (Motivate sk_buy_1 sk_drive_1) (STV 1.0 0.99))
    (: maria_name (Name maria "Maria") (STV 1.0 0.99))

IR:

    (node-graph V7g v7_oom)   (Member v7_oom out_of_milk)
    (node-graph V7g v7_maria) (Member v7_maria person) (Experiencer v7_oom v7_maria)
    (node-graph V7g v7_drive) (Member v7_drive drive)
    (node-graph V7g v7_store) (Member v7_store store)
    (Agent v7_drive v7_maria) (Destination v7_drive v7_store)
    (node-graph V7g v7_buy)   (Member v7_buy buy) (node-modal v7_buy intended)
    (node-graph V7g v7_carton)(Member v7_carton carton)
    (Agent v7_buy v7_maria)   (Theme v7_buy v7_carton)
    (CauseOf v7_oom v7_drive) (Motivate v7_buy v7_drive)

Applied: rule 8 drops the flat `(Member maria out_of_milk)`; rule 6 maps `Goal`→`Destination`;
rule 5 drops `Past`; rule 10 maps `Intended`→`node-modal intended`; rule 11 types `maria` `person`.
The question "Why did Maria drive to the store?" → focus `v7_drive`, `q-word` `why` (a dual
`CauseOf`+`Motivate` query).

## Accepted divergences (class-level fidelity)

The parser's natural output differs from a hand-authored graph in style, not class:
- action-events with participants (`stop[Patient:fridge]`) vs opaque state-nodes (`fridge_stopped`);
- `CauseOf` (from "because") where a hand graph might use `Contribute`; `Motivate(purpose→action)`
  vs `Motivates(goal)`+`Enable`.

The answer **class** (physical / intentional / concession) into each focus is preserved — which is
what the clamp selects on. Quantity modifiers ("too little") on a Theme are currently dropped by
the parser.
