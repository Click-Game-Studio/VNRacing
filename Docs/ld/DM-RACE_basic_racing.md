# DM-RACE — Basic Racing — Low-Level Design

> Source: `Docs/audit/DM-RACE_basic_racing.md`, `Docs/c4/model.c4`, read-only source under `PrototypeRacing/Source`.
> Structurizr view: `DM_RACE_Components`.
> OpenProject: #324.

## Feature summary and boundaries

DM-RACE owns the full race lifecycle: spawn cars + AI, countdown intro, start race, per-frame checkpoint/lap/ranking/timer tracking, end race and handoff results to VT-CITY. The central actor is `ARaceTrackManager` — a level-bound orchestrator that coordinates all race logic. NOS boost is owned by DM-NOS; vehicle physics by DM-PHYS; AI decision policy by SUP-AI; camera by DM-CAM.

![DM-RACE components](../structurizr/embed/DM_RACE_Components)

# Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `ARaceTrackManager` | `PrototypeRacing/Private/RaceMode/RaceTrackManager.cpp` (1869 lines) | Central race orchestrator; Tick every frame; owns ranking, checkpoint state, AI setup, intro/outro sequence. |
| `ARacingCarGameMode` | `PrototypeRacing/Private/RacingCarGameMode.cpp` | Spawns race manager + cars; handles player login/ready. |
| `ARaceGameState` | `PrototypeRacing/Private/RaceGameState.cpp` | Replicates car count + player readiness list. |
| `ARacingCarController` | `PrototypeRacing/Private/RacingCarController.cpp` (365 lines) | Player controller; RPC race state to client HUD. |
| `ARaceCheckpoint` | `PrototypeRacing/Private/RaceMode/RaceCheckpoint.cpp` | Trigger overlap → notifies manager. |
| `URaceComponent` | `PrototypeRacing/Private/RaceMode/RaceComponent.cpp` (34 lines) | Tick enabled with empty body — hotspot #3. |
| `ABoostCheckPoint` | `PrototypeRacing/BoostCheckPoint.cpp` | Time-bonus checkpoint; Tick body empty (lines 39–41). |

Race lifecycle flow:
```
ARacingCarGameMode
   ├─ spawn ARaceTrackManager
   ├─ spawn player car + SetupAICar(PlayerStarts)
   └─ register ready cars → ARaceGameState

ARaceTrackManager::BeginPlay (line 134)
   └─ GetAllActorsOfClass(ARaceCheckpoint) → AllCheckpoints  (once, OK)

[Intro] → OnStartGameAfterIntroFinish → StartRace → SignalRaceBegin (NetMulticast)

[Each frame] ARaceTrackManager::Tick (line 207)
   └─ HandleUpdateRanking()  ← HOTSPOT #1 (line 210, unconditional)

[Car hits checkpoint] ARaceCheckpoint::NotifyActorBeginOverlap
   └─ OnVehicleDetectedAtCheckpoint.Broadcast
        └─ ARaceTrackManager::HandleVehicleDetectedAtCheckpoint (line 223)
             └─ update lap/checkpoint, MarkFinished when at finish line

[Ranking changes] OnRankingUpdate.Broadcast
   └─ ARacingCarController::HandleRankingUpdateCallToClient (RPC) ← HOTSPOT #2

[End] EndRace → OnRaceEnded.Broadcast → VT-CITY HandleRaceCompleted
```

### Hotspot #1 — P0: `Tick → HandleUpdateRanking()` every frame
`RaceTrackManager.cpp:207–221` calls `HandleUpdateRanking()` unconditionally at line 210. Inside `HandleUpdateRanking()` (lines 834–877):
- Loop over all `ManagerPlayerInfo` computing `FVector::DistSquared` per car (lines 836–864).
- `GetPlayerRaceStates()` (line 865, defined lines 583–630): `GenerateValueArray` full copy + `Algo::Sort` O(n log n) + loop assigning `Ranking`.
- Loop again calling `Vehicle->SetRaceRank` (lines 866–874) + `OnRankingUpdate.Broadcast` (line 875).
- Line 876: `const float CurrentMoment = GetWorld()->GetTimeSeconds();` computed but never used — dead code.

Fix: `UpdateInterval = 0.3f` and `UpdateCheckpointTimerHandle` already exist in the header (line 641). Move `HandleUpdateRanking` from Tick to a timer at 3–10 Hz. Remove dead code line 876. Disable `PrimaryActorTick` if Tick has no other work.

### Hotspot #2 — P0: `HandleRankingUpdateCallToClient` — GetAllActorsOfClass + O(n²)
`RacingCarController.cpp:286–308`: every ranking update calls `UGameplayStatics::GetAllActorsOfClass(... ASimulatePhysicsCar ...)` (line 291) then a nested loop `for State : PlayerRaceState { for Actor : AllCars {...} }` (lines 293–307) — O(n²) + world scan cost each time. `FPlayerRaceState::Vehicle` pointer is already available; replace with `State.Vehicle->CurrentRanking = State.Ranking` — O(n), eliminates `GetAllActorsOfClass`.

### Hotspot #3 — P1: `URaceComponent` empty tick
`RaceComponent.cpp:12` sets `PrimaryComponentTick.bCanEverTick = true`; `TickComponent` (lines 29–34) body is empty. Set `bCanEverTick = false` or remove the component if unused.

### Hotspot #4 — P1: Blueprint checkpoint Event Tick
`BP_CheckPoint` / `BP_BoostCheckPoint` (3 nodes each, have `Event Tick`), `BP_DriftZone_Child` (12 nodes, `Event Tick` + `Parent: Tick`). Checkpoints should be pure event-driven; number per track multiplies the cost. BP audit-only: remove `Event Tick` in editor if body is empty.

# Layer 2 — Contract surface

## Enum
```cpp
// RaceCheckpoint.h
enum class ECheckPointType : uint8 { None=0, Progress=1, Finish=2 };
// RaceTrackManager.h
enum class ERaceModeState : uint8 { None=0, Waiting=1, Running=2, End=3 };
enum class EIntroSequenceType : uint8 { None, LevelIntro, LevelOutro, Car };
// ERaceState (None/Waiting/Racing/Completed/NotCompleted) — per-player, in SimulatePhysicsCar.
// ERaceMode (Sprint/TimeAttack/…) — external; determines race rules.
```

## Key structs
```cpp
struct FPlayerRaceState {
    ASimulatePhysicsCar* Vehicle = nullptr;
    FString  PlayerName;
    FText    CarName;
    FName    AvatarId;
    int32    LapCount = 1;
    int32    NextExpectedCheckpoint = 0;
    int32    TotalCheckpointPassed = 0;
    float    TotalRaceCompletionTime = 0.f;
    ERaceState RaceState = ERaceState::None;
    FRaceTime  RaceTime;
    int32    Ranking = 0;
    float    DistanceToNextCheckpoint = 0;
    FName    CarTypeId;
    bool     bIsAI = false;
    FAIDifficultyProfile AIDifficultyProfile;
};

struct FRaceInfo {
    int32     TotalLap = 1;
    ERaceMode RaceMode = ERaceMode::Sprint;
    float     AttackTimeDuration = 30.f;
    float     TimeBonus = 0.f;
    int32     CurrentNumberPlayers = 0;
    ETrackDifficulty TrackDifficulty = ETrackDifficulty::Easy;
    static FRaceInfo MakeRaceInfo(ERaceMode, int32 InCurrentPlayers);
};
```

## Delegates (ARaceTrackManager, BlueprintAssignable)

| Delegate | Payload | When fired |
|---|---|---|
| `OnCheckpointPassed` | `const TArray<FPlayerRaceState>&` | Car passes checkpoint |
| `OnRankingUpdate` | `const TArray<FPlayerRaceState>&` | After each ranking calc |
| `OnPlayerStartRace` | `const TArray<FPlayerRaceState>&` | Race begins |
| `OnPlayerFinishedRace` | `const TArray<FPlayerRaceState>&` | One car finishes |
| `OnRaceEnded` | `const TArray<FPlayerRaceState>&` | Race fully ended |
| `OnLapCompleted` | `(const ASimulatePhysicsCar*, const int&)` | Lap complete |
| `OnTimeAttackUpdate` | `const FRaceTime&` | Timer tick |
| `OnTimeUp` | `const TArray<FPlayerRaceState>&` | Time expired |
| `OnRaceInfoUpdate` | `const FRaceInfo&` | RaceInfo changed |
| `OnAIStateChange` | `(const FName&, const EAIDecisionState&)` | AI state change |

## Public API — ARaceTrackManager
```cpp
void StartRace();
void EndRace();
void SignalRaceBegin();                          // NetMulticast, Reliable
void HandleVehicleDetectedAtCheckpoint(ASimulatePhysicsCar*, ECheckPointType, int32);
void HandleUpdateRanking();                       // ⚠ currently called every frame
TArray<FPlayerRaceState> GetPlayerRaceStates();
FPlayerRaceState* GetPlayerRaceState(const ASimulatePhysicsCar*);
float CalculateRaceProgress(ASimulatePhysicsCar*);
TArray<ASimulatePhysicsCar*> GetActiveCars() const;
void InitializePlayerRaceState(ASimulatePhysicsCar*, const bool& bIsAICar=false, ...);
void SetupAICar(const TArray<APlayerStart*>& PlayerStarts);
```

## Replication
- `ARaceGameState`: replicates readiness + car list.
- `ARaceTrackManager`: `bAllPlayersReadyForLoadingRelease` (ReplicatedUsing), `bIsOnlineMap` (Replicated). `SignalRaceBegin` = `NetMulticast, Reliable`.
- `ARacingCarController`: `Handle*CallToClient` = `Client, Unreliable`; `SignalReady` = `Server, Unreliable`. `VehicleId` ReplicatedUsing `OnRep_VehicleId`.

## Links

- Audit: `Docs/audit/DM-RACE_basic_racing.md`
- Structurizr: `DM_RACE_Components`
