# World Rules

Thirty load-bearing rules of the Lantern-Keepers' world, written in the
controlled language of `style_guide.md` (LAW register, v2 — revised against
the first parse-gate run): each rule is stated as a When-conditional,
restated as a Whenever-variant with a bounded verb variant, and completed by
generic / copular / negated-generic facts. The designed paraphrase families
are enumerated in `expected_consolidation_map.md`. Lines beginning with `>`
are design annotations and are not part of the parseable corpus; the
machine-facing parse input is `world_rules.json`.

## R1 — Lighting a lantern produces mist-light

When a lantern burns mire-essence, the lantern produces mist-light. Whenever
a lantern burns mire-essence, the lantern gives mist-light. Mist-light is a
pale silver flame. Ordinary oil does not produce mist-light.

## R2 — Mist-light attracts nightmoths

When a lantern shows mist-light at night, the mist-light attracts nightmoths.
Whenever a lantern shows mist-light at night, the mist-light draws
nightmoths. Nightmoths do not see ordinary firelight. When a night is cold,
nightmoths rarely fly.

## R3 — Nightmoths landing on lanterns leave silken threads

When a nightmoth lands on a lantern, the nightmoth leaves silken threads on
the lantern. Whenever a nightmoth rests on a lantern, the nightmoth sheds
silken threads onto the lantern. Every silken thread comes from the underside
of a nightmoth.

## R4 — Silken threads boiled in sea-water yield mire-essence

When a Keeper boils silken threads in sea-water, mire-essence forms in the
cauldron. Whenever a Keeper boils silken threads in sea-water, the cauldron
yields mire-essence. The Keepers take the sea-water from the Salt-bloom
Tide-pools. Fresh water does not yield mire-essence.

## R5 — Stored mire-essence feeds future lighting

When mire-essence forms in the cauldron, the Keepers store the mire-essence
in clay vessels. Whenever mire-essence forms in the cauldron, the Keepers
keep the mire-essence in clay vessels. Each Keeper draws stored mire-essence
when that Keeper tends a lantern. Stored mire-essence will feed lantern
lighting.

> Cycle A closes here: lantern → mist-light → moths → threads → mire-essence → lantern.

## R6 — A crowd of nightmoths brings sky-cats down

When a crowd of nightmoths gathers at a lantern-row, sky-cats descend from
the cliff-spires. Whenever a crowd of nightmoths settles on a lantern-row,
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

When a sky-cat hunts at a lantern-row, the nightmoths that survive the hunt
flee toward dim lanterns. Whenever a sky-cat hunts at a lantern-row, the
nightmoths that survive the hunt move to the Hollows. When a nightmoth flees
and reaches the Hollows, the lanterns at the Hollows gain silken threads.

## R9 — Sky-cats roost on the cliff-spires by day

Sky-cats roost on the cliff-spires during the day. Sky-cats do not enter the
village. The Keepers tolerate sky-cats.

## R10 — Sky-cats molt feathers to the cliff base

When a sky-cat molts, feathers fall to the cliff base. Whenever a sky-cat
molts, the sky-cat sheds feathers onto the cliff base. Apprentices collect
the fallen feathers in the morning. The Keepers store the collected feathers
in a bin at the Watch.

## R11 — Untended lanterns die before dawn

When a Keeper leaves a lantern untended overnight, the lantern dies before
dawn. When a lantern is untended through the night, the lantern goes out
before dawn. A Keeper refreshes the mire-essence and trims the wick during
the night.

## R12 — Dead lanterns at the Sunken Cove raise wraiths

When a lantern at the Sunken Cove dies before dawn, a wraith emerges from the
cove water. Whenever a lantern at the Sunken Cove goes out at night, a wraith
rises from the cove's water. Lanterns away from the Sunken Cove do not raise
wraiths. The Sunken Cove is the village's drowned graveyard.

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

When a Keeper scatters ground feathers around a lit lantern, the feathers
ward the lantern against wraiths. Whenever a Keeper spreads ground feathers
around a lit lantern, the feathers shield the lantern against wraiths.
Wraiths do not approach a warded lantern. Fresh ground feathers ward
lanterns. Stale ground feathers do not ward lanterns.

> Cycle C hinge: the regulator's byproduct (feathers) protects production in the wraith zone.

## R16 — Cold winds extinguish unprepared lanterns

Whenever a cold wind blows off the sea at night, that wind extinguishes
unprepared lanterns. When a cold wind strikes the Cliff Path at night,
unprepared lanterns go out. Lanterns in shielded coves stay safe from cold
winds.

## R17 — Salt-bloom in winter slows the burn

When a Keeper adds salt-bloom to mire-essence in winter, that mire-essence
burns slowly. Whenever a Keeper mixes salt-bloom into mire-essence in winter,
that mire-essence burns slowly. Salt-bloomed lanterns resist cold winds.

## R18 — Salt-bloom is harvested at new moon

When a Keeper harvests salt-bloom at the new moon, that salt-bloom keeps its
potency. Whenever a Keeper gathers salt-bloom at the new moon, that
salt-bloom stays potent. When a Keeper gathers salt-bloom at the full moon,
that salt-bloom turns to chalky residue. When a Keeper gathers salt-bloom at
the half moon, that salt-bloom turns to chalky residue.

> Design note: the full moon and the half moon stand in for ALL non-new phases ("other moon phases" has no encodable form).

## R19 — Spring tides bloom salt-bloom in the tide-pools

When a spring tide fills the tide-pools, salt-bloom blooms in the tide-pools.
Whenever a spring tide fills the tide-pools, salt-bloom grows in the
tide-pools. Salt-bloom is a pale crystalline crust. Salt-bloom soon dissolves
into the seawater.

## R20 — Spring tides occur near new moon and full moon

Spring tides occur at new moon. Spring tides occur at full moon. The Keepers
time the salt-bloom harvest to the new-moon spring tide.

> Design note: "at" approximates the original "near" (no time slot carries the approximation).

## R21 — Wintergloss repels nightmoths

Whenever a lantern burns wintergloss, the wintergloss repels nightmoths from
that lantern. When a lantern burns wintergloss alongside mire-essence,
nightmoths avoid that lantern. The Keepers rarely burn wintergloss. The
Keepers sometimes burn wintergloss at the Stilllight Lantern.

## R22 — Cliff-spires shield the Northcove

When cliff-spires shield a cove from north winds, lanterns in that cove burn
stably through winter. When a cove is blocked from the north wind by
cliff-spires, the lanterns in that cove stay lit through winter. The
Northcove is a shielded cove in Aelmere. Northcove lanterns never go out in
cold winds.

> Design value (not corpus): the Northcove is Aelmere's ONLY shielded cove (a definite predicate nominal has no carrier).

## R23 — Keepers inherit lantern-stations

When a senior Keeper retires, an heir inherits that Keeper's lantern-station.
Whenever a senior Keeper dies, an heir inherits that Keeper's lantern-station.
A Keeper's family keeps that Keeper's inherited station. The Council must
approve any station transfer.

## R24 — Newcomers apprentice under a senior Keeper

Newcomers must apprentice. Each newcomer apprentices under a senior Keeper.
New apprentices do not tend a lantern alone. The Council permits an
apprentice to begin solo tending.

## R25 — Sustained solo tending completes apprenticeship

Every apprentice who completes many solo nights of tending is invested as a
Keeper by the Council. When an apprentice's lantern fails, that apprentice's
solo count resets. When an apprentice's lantern dims, that apprentice's solo
count resets.

> Design value (not corpus): "many solo nights" = thirty consecutive nights.

## R26 — The Council convenes at full moon

When the moon is full, the Council convenes at the Watch. Whenever the moon
is full, the Council meets at the Watch.

> Design note: outside full moons the Council meets only in declared emergency (the "rarely meets at other times" sentence retired — "at other times" names no encodable occasion).

## R27 — The Council redistributes mire-essence

When the Council convenes, the Council redistributes mire-essence across the
lantern-stations. Whenever the Council meets, the Council reallocates
mire-essence among the lantern-stations. Productive stations contribute
mire-essence to a central pool. Burdened stations draw mire-essence from the
central pool. The Keepers record the redistribution in the Watch ledgers.

## R28 — Summer hunting yields the autumn feather store

Sky-cats hunt often through summer. When a sky-cat hunts through summer, many
feathers accumulate at the cliff base by autumn. Whenever a sky-cat hunts in
summer, the autumn feather store grows.

> Design note (mechanism): more hunting → more molting → more fallen feathers. ("Frequent hunting causes frequent molting" retired — nominalized subjects yield an episode, not a law.)

## R29 — Large feather stores enable safe Sunken-Cove tending

When the feather store at the Watch is large, the Keepers tend the Sunken
Cove lanterns safely in winter. When the Watch's feather store is large,
winter tending at the Sunken Cove stays safe. The Council issues feather
rations to the Sunken-Cove station in winter. When the feather store is
small, wraith risk grows.

## R30 — Wraith activity prompts feather-ration requests

When wraith activity at the Sunken Cove increases, the neighboring stations
request feather rations from the Council. Whenever wraith sightings at the
Sunken Cove rise, the stations ask the Council for feather rations. The
Council weighs the requests against the central feather store. The Council
prioritizes stations with drained lanterns.
