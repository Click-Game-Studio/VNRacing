# 1. Move ranking update off the per-frame Tick and remove the client-side world scan

Date: 2026-06-09

## Status

Proposed

## Context

`RaceTrackManager` is the central race orchestrator and ticks every frame. Its
`Tick` (`RaceTrackManager.cpp:207-221`) calls `HandleUpdateRanking()`
unconditionally at line 210. Inside `HandleUpdateRanking()`
(`RaceTrackManager.cpp:834-877`) the following work runs on every frame:

- A loop over all of `ManagerPlayerInfo` computing `FVector::DistSquared` per car
  (lines 836-864).
- A call to `GetPlayerRaceStates()` (line 865), which itself
  (`RaceTrackManager.cpp:583-630`) does `GenerateValueArray` (a full copy),
  an `Algo::Sort` with a five-branch comparator (**O(n log n)**), then a loop to
  assign `Ranking`.
- A second loop over the sorted array calling `Vehicle->SetRaceRank`
  (lines 866-874) and `OnRankingUpdate.Broadcast` (line 875).
- Line 876 computes `const float CurrentMoment = GetWorld()->GetTimeSeconds();`
  whose result is never used — **dead code**.

The `OnRankingUpdate` broadcast reaches
`RacingCarController::HandleRankingUpdateCallToClient`
(`RacingCarController.cpp:286-308`), which calls
`UGameplayStatics::GetAllActorsOfClass(... ASimulatePhysicsCar ...)` (line 291)
and then runs a **nested loop** `for State : PlayerRaceState { for Actor :
AllCars { ... } }` (lines 293-307) to match each state back to its car —
**O(n^2)** plus a full-world actor scan on every ranking update.

Ranking changes slowly relative to a 60Hz frame. Running a distance recompute,
a copy + O(n log n) sort, a broadcast, and a downstream world scan + O(n^2) match
on every frame is the worst "runs at 60Hz but does not need to" pattern in the
project, and it sits directly on the main gameplay loop where it costs FPS.

The header already exposes the levers for a timer-driven approach:
`UpdateInterval = 0.3f` (`RaceTrackManager.h:641`) and `UpdateCheckpointTimerHandle`.
The state struct `FPlayerRaceState` already holds `Vehicle` (a pointer), so the
controller does not need to rediscover cars via a world scan.

## Decision

1. Drive `HandleUpdateRanking()` from a repeating timer (~5-10Hz, using the
   existing `UpdateInterval` / `UpdateCheckpointTimerHandle`) instead of calling
   it from `Tick`. If `Tick` has no remaining per-frame work, disable
   `PrimaryActorTick` on `RaceTrackManager`.
2. Remove the dead `CurrentMoment` line at `RaceTrackManager.cpp:876`.
3. In `HandleRankingUpdateCallToClient`, drop the `GetAllActorsOfClass` call and
   the nested match loop. Assign directly through the already-present pointer:
   `State.Vehicle->CurrentRanking = State.Ranking`, giving **O(n)**.

## Consequences

**Positive**

- Removes a per-frame copy + O(n log n) sort + broadcast from the main race loop.
- Removes a per-update full-world actor scan and O(n^2) match on the client.
- Deletes dead code and reduces the work attributable to the `RaceTrackManager`
  god class.

**Negative / trade-offs**

- Ranking now updates at the timer cadence (~5-10Hz) rather than per frame; HUD
  rank changes may lag by up to one timer interval. Acceptable because ranking
  is a slow-changing value and the prior 60Hz cadence was not perceptible.
- Requires confirming no other per-frame consumer depends on `Tick` calling
  `HandleUpdateRanking` as a side effect before disabling `PrimaryActorTick`.

## References

- Audit: `Docs/audit/DM-RACE_basic_racing.md` (hotspots #1, #2)
- LD: `Docs/ld/DM-RACE_basic_racing.md` §1.4, §2.4, §2.5
