# Compatibility Page: Runtime View

> Compatibility page only. This older DM-RACE (ex-F02) sample runtime page is not the canonical all-feature runtime view.
>
> Use the canonical page instead: [05. Runtime View](05-runtime-view.md).

## Legacy DM-RACE (ex-F02) Runtime View

> arc42 §6 Runtime View · DM-RACE race lifecycle. Source: [`Docs/ld/DM-RACE_basic_racing.md`](../../ld/DM-RACE_basic_racing.md) §1.3 and §2.5.

### Scenario: checkpoint pass to ranking update to result hand-off

1. **Checkpoint overlap** — `ARaceCheckpoint::NotifyActorBeginOverlap(OtherActor)` resolves the controlled vehicle, then fires `OnVehicleDetectedAtCheckpoint.Broadcast(Vehicle, Type, Index)`.

2. **Manager updates state** — `RaceTrackManager::HandleVehicleDetectedAtCheckpoint` (`RaceTrackManager.cpp:223`) updates the car's `FPlayerRaceState` (`NextExpectedCheckpoint`, `TotalCheckpointPassed`, `LapCount`). If `Type == Finish` and laps are complete, it calls `MarkFinished(Vehicle, Completed)`, then broadcasts `OnCheckpointPassed`.

3. **Ranking recompute** — `RaceTrackManager::HandleUpdateRanking` (`RaceTrackManager.cpp:834-877`) computes `DistanceToNextCheckpoint` per car, calls `GetPlayerRaceStates()` (`RaceTrackManager.cpp:583-630`, copy + `Algo::Sort`: Completed first, then time, lap, checkpoint, distance), assigns Ranking 1..n, then broadcasts `OnRankingUpdate`.
   - **Hotspot:** today this runs every frame from `Tick` (`RaceTrackManager.cpp:207-221`, call at line 210). See ADR-0001.

4. **Client relay** — `RacingCarController::HandleRankingUpdateCallToClient` (`RacingCarController.cpp:286-308`, Client/Unreliable RPC) forwards to UI (`OnEmitRankingUpdate`) and writes ranking onto each client-side car.
   - **Hotspot:** today this does `GetAllActorsOfClass(ASimulatePhysicsCar)` plus a nested loop — O(n^2) per update. See ADR-0001.

5. **Race end** — `CheckAllFinished()` to `EndRace()` broadcasts `OnRaceEnded`, which the Meta/Economy layer (Progression, VT-CITY) consumes via `HandleRaceCompleted` to compute rewards.

### Replication notes

- `ARaceGameState` replicates readiness + car list.
- `RaceTrackManager`: `SignalRaceBegin` is `NetMulticast, Reliable`; `bAllPlayersReadyForLoadingRelease` uses `ReplicatedUsing`.
- `RacingCarController`: `Handle*CallToClient` are `Client, Unreliable` (HUD state); `SignalReady` is `Server, Unreliable`.
