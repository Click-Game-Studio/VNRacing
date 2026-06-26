# 05. Runtime View

## Scenario A: Race lifecycle

![DM-RACE components](embed:DM_RACE_Components)

1. `RacingCarGameMode` creates/initializes `RaceTrackManager`, player car and AI cars.
2. `RaceCheckpoint` overlap events feed `RaceTrackManager::HandleVehicleDetectedAtCheckpoint`.
3. `RaceTrackManager` updates per-car state, ranking and race completion.
4. `RacingCarController` relays race state to HUD/client-side cars.
5. At race end, `RaceTrackManager` broadcasts result to `ProgressionCenterSubsystem`.

Key hotspot: ranking currently originates from per-frame Tick and performs distance recompute + copy/sort + broadcast. ADR-0001 records the accepted direction to move ranking updates off Tick.

## Scenario B: Customization / profile / progression loop

![CU-ROOM components](embed:CU_ROOM_Components)

1. UI calls `CarCustomizationManager` to preview/apply visual and performance parts.
2. Customization checks wallet and required items through `ProfileManagerSubsystem` and `InventoryManager`.
3. `CarRatingSubsystem` calculates CR/stat effects.
4. `CarSaveGameManager` persists configuration.
5. After races, `ProgressionCenterSubsystem` records result, awards rewards, updates achievements and profile currency.

Key hotspot: blocking synchronous asset loads in customization and reward icon resolution can hitch the mobile game thread.

## Scenario C: Backend / multiplayer / content

![GM-MP components](embed:GM_MP_Components)

1. `NakamaServiceSubsystem` owns client/session/realtime lifecycle.
2. `MatchServiceSubsystem` builds matchmaking queries and consumes matched/presence events.
3. `SnapshotAdapterSubsystem` uses Nakama RPCs for profile snapshot sync.
4. `MultiplayerWaitingRoomGameMode` validates join tokens and travels into waiting room/race path.
5. Content download uses ChunkDownloader and patch UI; full content flow should avoid blocking loads and debug messages in shipping.

Evidence gap: source confirms client-side online services and waiting-room validation, but not a completed server-authoritative race authority.

## Scenario D: Performance and debug support

![SUP-PERF components](embed:SUP_PERF_Components)

- `PerformanceMonitorSubsystem` instruments runtime performance.
- `LiteSignificanceManager` periodically culls registered actors/Niagara by distance.
- `PSOEffectManager` and `RestLevelManager` support shader/PSO warmup and stable travel.
- `DebugToolsSubsystem`, `BatchSimulationManager`, `MistakeDetector` and `RaceDataCollector` support track-test and diagnosis flows.

These systems must remain support/tooling boundaries, not hidden shipping dependencies.
