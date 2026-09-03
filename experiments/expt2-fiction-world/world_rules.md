# World Rules

Thirty load-bearing rules of the Lantern-Keepers' world, written in the
controlled language of `style_guide.md` (LAW register, v5 — incremental admission
after four parse-gate runs): each rule is stated as a When- or
Whenever-conditional, restated as a bounded variant, and completed by generic
/ copular / negated-generic facts. The designed paraphrase families are
enumerated in `expected_consolidation_map.md`. Lines beginning with `>` are
design annotations and are not part of the parseable corpus; the
machine-facing parse input is `world_rules.json`.

## R1 — Lighting a lantern produces mist-light

When a lantern burns mire-essence, the lantern produces mist-light. Whenever a
lantern burns mire-essence, the lantern gives mist-light. Mist-light is a pale
silver flame. Ordinary oil does not produce mist-light.

## R2 — Mist-light attracts nightmoths

When a lantern shows mist-light at night, the mist-light attracts nightmoths.
Whenever a lantern shows mist-light at night, the mist-light draws nightmoths.
Nightmoths do not see ordinary firelight. Nightmoths rarely fly on a cold
night.

## R3 — Nightmoths landing on lanterns leave silken threads

When a nightmoth lands on a lantern, the nightmoth leaves silken threads on
the lantern. Whenever a nightmoth is resting on a lantern, the nightmoth sheds
silken threads onto the lantern. Every silken thread comes from the underside
of a nightmoth.

## R4 — Silken threads boiled in sea-water yield mire-essence

When a Keeper boils silken threads in sea-water, mire-essence forms in the
cauldron. Whenever a Keeper boils silken threads in sea-water, the cauldron
yields mire-essence. Each Keeper takes the sea-water from the Salt-bloom
Tide-pools. Fresh water does not yield mire-essence.

## R5 — Stored mire-essence feeds future lighting

When mire-essence forms in the cauldron, a Keeper stores the mire-essence in
clay vessels. Whenever mire-essence forms in the cauldron, a Keeper keeps the
mire-essence in clay vessels. Whenever a Keeper tends a lantern, that Keeper
draws the stored mire-essence. Stored mire-essence feeds lantern lighting.

> Cycle A closes here: lantern → mist-light → moths → threads → mire-essence → lantern.

## R6 — A crowd of nightmoths brings sky-cats down

When a crowd of nightmoths gathers at a lantern-row, sky-cats descend from the
cliff-spires. Whenever a crowd of nightmoths settles on a lantern-row,
sky-cats descend from the cliff-spires. When a handful of nightmoths gathers
at a lantern-row, sky-cats stay on the cliff-spires.

> Design values (not corpus): a "crowd" ≈ more than twenty moths per lantern-row section per night; a "handful" ≈ fewer than twenty.

## R7 — Sky-cats hunting reduces nightmoth populations

When a sky-cat descends, the sky-cat hunts nightmoths. When a sky-cat hunts
nightmoths at a lantern-row, the nightmoth crowd at that lantern-row shrinks.
Whenever a sky-cat hunts nightmoths at a lantern-row, the nightmoth crowd at
that lantern-row thins. After a sky-cat hunts at a lantern-row, the thread
harvest at that lantern-row falls.

## R8 — Hunted nightmoths flee to dimmer lights

When a sky-cat hunts at a lantern-row, each nightmoth that survives the hunt
flees to a dim lantern. Whenever a sky-cat hunts at a lantern-row, each
nightmoth that survives the hunt moves to the Hollows. Whenever a nightmoth
reaches the Hollows, the lanterns at the Hollows gain silken threads.

## R9 — Sky-cats roost on the cliff-spires by day

Sky-cats roost on the cliff-spires during the day. Sky-cats do not enter the
village. The Keepers tolerate sky-cats.

## R10 — Sky-cats molt feathers to the cliff base

When a sky-cat molts, feathers fall to the base of the cliff. Whenever a
sky-cat molts, the sky-cat sheds feathers onto the base of the cliff.
Apprentices collect the fallen feathers in the morning. Each Keeper stores the
collected feathers in a bin at the Watch.

## R11 — Untended lanterns die before dawn

When a Keeper leaves a lantern untended overnight, the lantern dies before
dawn. When a lantern is untended through the night, the lantern goes out
before dawn. Each Keeper refreshes the mire-essence and trims the wick during
the night.

## R12 — Dead lanterns at the Sunken Cove raise wraiths

Whenever a lantern at the Sunken Cove dies before dawn, a wraith emerges from
the cove's water. Whenever a lantern at the Sunken Cove goes out at night, a
wraith rises from the cove's water. Lanterns away from the Sunken Cove do not
raise wraiths. The Sunken Cove is the village's drowned graveyard.

## R13 — Wraiths drain mire-essence from lit lanterns

When a wraith approaches a lit lantern, the wraith drains mire-essence from
the lantern. Whenever a wraith nears a lit lantern, the wraith pulls
mire-essence from the lantern. Drained lanterns burn dimly.

## R14 — Drained lanterns give weak mist-light

When a wraith drains a lantern, the lantern gives weak mist-light. Whenever a
wraith drains a lantern, the lantern shows dim mist-light. Weak mist-light
rarely attracts nightmoths. When a lantern attracts a handful of nightmoths,
the thread harvest at that lantern falls.

> Cycle D closes here: untended → wraith → drained → weak mist-light → less production.

## R15 — Ground feathers ward lanterns from wraiths

When a Keeper grinds feathers and scatters the feathers around a lit lantern,
the feathers ward the lantern against wraiths. Whenever a Keeper grinds
feathers and spreads the feathers around a lit lantern, the feathers shield
the lantern against wraiths. Wraiths do not approach a warded lantern. Fresh
ground feathers ward lanterns. Stale ground feathers do not ward lanterns.

> Cycle C hinge: the regulator's byproduct (feathers) protects production in the wraith zone.

## R16 — Cold winds extinguish unprepared lanterns

Whenever a cold wind blows off the sea at night, that wind extinguishes
unprepared lanterns. When a cold wind strikes the Cliff Path at night,
unprepared lanterns go out. Lanterns in shielded coves stay safe from cold
winds.

## R17 — Salt-bloom in winter slows the burn

Whenever a Keeper adds salt-bloom to mire-essence in winter, that mire-essence
burns slowly. Whenever a Keeper mixes salt-bloom into mire-essence in winter,
that mire-essence burns slowly. When a cold wind strikes a salt-bloomed
lantern, the lantern stays lit.

## R18 — Salt-bloom is harvested at new moon

When a Keeper harvests salt-bloom at the new moon, that salt-bloom stays
potent. Whenever a Keeper gathers salt-bloom at the new moon, that salt-bloom
stays potent. Every time a Keeper gathers salt-bloom at the full moon, that
salt-bloom turns to chalky residue. Every time a Keeper gathers salt-bloom at
the half moon, that salt-bloom turns to chalky residue.

> Design note: the full moon and the half moon stand in for ALL non-new phases ("other moon phases" has no encodable form).

## R19 — Spring tides bloom salt-bloom in the tide-pools

When a spring tide fills the tide-pools, salt-bloom blooms in the tide-pools.
Whenever a spring tide fills the tide-pools, salt-bloom grows in the
tide-pools. Salt-bloom is a pale crystalline crust. Salt-bloom quickly
dissolves into the seawater.

## R20 — Spring tides occur near new moon and full moon

Spring tides occur at new moon or at full moon. Each Keeper times the
salt-bloom harvest to the new-moon spring tide.

> Design notes: "at" approximates the original "near"; the two phases are one
> disjunctive generic — two separate exceptionless laws jointly asserted every
> spring tide at both moons.

## R21 — Wintergloss repels nightmoths

Whenever a lantern burns wintergloss, the wintergloss repels nightmoths from
that lantern. Whenever a lantern burns wintergloss alongside mire-essence,
every nightmoth avoids that lantern. The Keepers rarely burn wintergloss. The
Keepers sometimes burn wintergloss at the Stilllight Lantern.

## R22 — Cliff-spires shield the Northcove

Whenever a cliff-spire shields a cove against north winds, each lantern in
that cove burns stably through winter. Whenever a cliff-spire shelters a cove,
each lantern in that cove stays lit through winter. The Northcove is a
shielded cove in Aelmere. Northcove lanterns never go out when cold winds
blow.

> Design value (not corpus): the Northcove is Aelmere's ONLY shielded cove (a definite predicate nominal has no carrier).

## R23 — Keepers inherit lantern-stations

Whenever a senior Keeper retires, an heir inherits that Keeper's
lantern-station. Whenever a senior Keeper dies, an heir inherits that Keeper's
lantern-station. A Keeper's family keeps that Keeper's inherited station. The
Council must approve any station transfer.

## R24 — Newcomers apprentice under a senior Keeper

Newcomers must apprentice. Each newcomer apprentices under a senior Keeper.
New apprentices do not tend a lantern alone. The Council permits an apprentice
to begin solo tending.

## R25 — Sustained solo tending completes apprenticeship

When an apprentice's solo count is large, the Council invests the apprentice
as a Keeper. When a lantern of an apprentice fails, that apprentice's solo
count resets. When an apprentice's lantern dims, that apprentice's solo count
resets.

> Design value (not corpus): a "large" solo count = thirty consecutive solo nights of tending.

## R26 — The Council convenes at full moon

When the moon is full, the Council convenes at the Watch. Whenever the moon is
full, the Council meets at the Watch.

> Design note: outside full moons the Council meets only in declared emergency (the "rarely meets at other times" sentence retired — "at other times" names no encodable occasion).

## R27 — The Council redistributes mire-essence

When the Council convenes, the Council redistributes mire-essence across the
lantern-stations. Whenever the Council meets, the Council reallocates
mire-essence among the lantern-stations. Productive stations contribute
mire-essence to a central pool. Burdened stations draw mire-essence from the
central pool. The Keepers record the redistribution in the Watch ledgers.

## R28 — Summer hunting yields the autumn feather store

Sky-cats hunt often through summer. Whenever a sky-cat hunts through summer,
many feathers accumulate at the base of the cliff by autumn. Whenever a
sky-cat hunts in summer, the autumn feather store grows.

> Design note (mechanism): more hunting → more molting → more fallen feathers. ("Frequent hunting causes frequent molting" retired — nominalized subjects yield an episode, not a law.)

## R29 — Large feather stores enable safe Sunken-Cove tending

When the feather store at the Watch is large, each Keeper tends the Sunken
Cove lanterns safely in winter. The Council issues feather rations to the
Sunken-Cove station in winter. When the feather store is small, wraith risk
grows.

> Retired (v4): the possessive-store variant sentence — its slot failed in two wordings while the sibling passed three runs.

## R30 — Wraith activity prompts feather-ration requests

Whenever a wraith drains a lantern at the Sunken Cove, a station near the
Sunken Cove requests feather rations from the Council. Whenever wraith
sightings at the Sunken Cove rise, the stations ask the Council for feather
rations. The Council weighs the requests against the central feather store.
When a station reports a drained lantern, the Council prioritizes that
station.
