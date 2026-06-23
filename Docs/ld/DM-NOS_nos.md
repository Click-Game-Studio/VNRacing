# DM-NOS — NOS — Low-Level Design

> Source: `Docs/audit/DM-NOS_nos.md`, `Docs/c4/model.c4`, read-only source under `PrototypeRacing/Source`.
> Structurizr view: `DM_NOS_Components`.
> OpenProject: #334.

## Feature summary and boundaries

DM-NOS owns the nitro/boost mechanic: player and AI activation of the NOS boost force, gauge management, the on-track refill checkpoint, and AI decision logic for when to trigger NOS. Physics impulse application is delegated to DM-PHYS (`ASimulatePhysicsCar`). Race rules belong to DM-RACE. AI decision infrastructure belongs to SUP-AI.

![DM-NOS components](../structurizr/embed/DM_NOS_Components)

# Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `ASimulatePhysicsCar::BoostNitro` | `SimpleCarPhysics/Private/PhysicsSimulateCar/SimulatePhysicsCar.cpp:3350` | Core NOS activation on the car: validates gauge state, increments `NitroBoostCounter`, adds `StandardNitroBoost` force, starts burn timer, sets `bIsNitroActive`. |
| `APhysicCarController::BoostNitrous` | `PrototypeRacing/PhysicCarController.cpp:67` | Controller entry point: calls `On_BoostNitrous()` then `ResetNitrous()` (line 62 resets `Nitrous = 0.f`). |
| `APrototypeRacingPlayerController::BoostNitrous` | `PrototypeRacing/PrototypeRacingPlayerController.cpp:97` | Player controller entry: calls `VehiclePawn->Boost(false)` then `ResetNitrous()` (line 92). |
| `ABoostCheckPoint` | `PrototypeRacing/BoostCheckPoint.h:10` / `BoostCheckPoint.cpp` | On-track NOS refill trigger actor; `UBoxComponent` overlap `OnOverlapBegin`; `BeginPlay` (line 32) and `Tick` (line 39) are currently empty bodies. |
| `UAIDecisionComponent` (NOS path) | `SimpleCarPhysics/.../AIDecisionComponent.cpp:50–87` | `TickComponent` accumulates `NOSCheckInterval`; when gauge is full and interval elapsed, sets `bShouldUseNOS = true` based on `AIDifficultyProfile.NOSUsageFrequency`. |
| `ASimulatePhysicsCar::AutoDrive` | `SimulatePhysicsCar.cpp:2615` | Reads `AIDecisionComponent->bShouldUseNOS`; if straight line + gauge full → calls `BoostNitro()`, resets flag. |

Runtime flow:
```
[Player input] → APrototypeRacingPlayerController::BoostNitrous (line 97)
   └─ VehiclePawn->Boost(false) → ASimulatePhysicsCar::BoostNitro (line 3350)
        └─ validate NitroGauge, increment NitroBoostCounter
           add CurrentNitroForce += StandardNitroBoost
           NitroBurnSpeed += 1/NitroBoostDuration
           OnNitroStart(true), bIsNitroActive = true

[AI path] UAIDecisionComponent::TickComponent (line 50)
   └─ if NitroGauge ≈ 1.0 → NOSCheckInterval += DeltaTime
      if NOSCheckInterval >= AIDifficultyProfile.NOSCheckInterval
         → probability check NOSUsageFrequency → bShouldUseNOS = true
   └─ ASimulatePhysicsCar::AutoDrive (line 2615)
        if bShouldUseNOS && straight line → BoostNitro(), bShouldUseNOS = false

[Refill] ABoostCheckPoint::OnOverlapBegin
   └─ refill NitroGauge on overlapping ASimulatePhysicsCar
```

Hotspots:
- `ABoostCheckPoint::Tick` (line 39–41) is an empty body with tick enabled — should set `bCanEverTick = false` (same pattern as DM-RACE hotspot #3).
- `UAIDecisionComponent::TickComponent` runs every frame for all AI cars; NOS interval check is gated by gauge level which limits work when gauge is not full.
- `ABoostCheckPoint::BeginPlay` (line 32) is empty — confirm the overlap binding is wired in a subclass or Blueprint.

# Layer 2 — Contract surface

Key fields on `ASimulatePhysicsCar` (NOS-related):
```cpp
float NitroGauge;            // 0..1; full = 1.0
float CurrentNitroForce;
float StandardNitroBoost;    // base force per activation
float NitroBoostDuration;
float NitroBurnSpeed;
int32 NitroBoostCounter;     // 0/1/2 stacking
bool  bIsNitroActive;
```

Key fields on `UAIDecisionComponent` (NOS-related):
```cpp
float NOSCheckInterval;                       // accumulated DeltaTime
bool  bShouldUseNOS;                          // flag consumed by AutoDrive
// from FAIDifficultyProfile:
float AIDifficultyProfile.NOSCheckInterval;   // interval threshold
float AIDifficultyProfile.NOSUsageFrequency;  // probability [0..1]
```

Entry points:
- Player: `APrototypeRacingPlayerController::BoostNitrous` (line 97) or `APhysicCarController::BoostNitrous` (line 67).
- AI: `UAIDecisionComponent::TickComponent` sets flag → `ASimulatePhysicsCar::AutoDrive` fires.
- Refill: `ABoostCheckPoint::OnOverlapBegin`.

## Links

- Audit: `Docs/audit/DM-NOS_nos.md`
- Structurizr: `DM_NOS_Components`
