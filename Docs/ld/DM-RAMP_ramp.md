# DM-RAMP — RAMP — Low-Level Design

> Source: `Docs/audit/DM-RAMP_ramp.md`, `Docs/c4/model.c4`, read-only source under `PrototypeRacing/Source`.
> Structurizr view: `DM_RAMP_Components`.
> OpenProject: #335.

## Feature summary and boundaries

DM-RAMP owns the ramp launch mechanic: the trigger zone actor placed in levels, the car-side impulse and boost application on entry, angular velocity damping on exit (high-platform variant), and the `EVehicleSkillType::RampBoost`/`HangTime` skill broadcast. Physics impulse (`ATP_AddImpulse`, `Jump`) is executed through DM-PHYS primitives. DM-NOS is a separate boost system; drift cancellation on ramp entry calls into the drift subsystem but is owned by DM-RAMP as a guard.

![DM-RAMP components](../structurizr/embed/DM_RAMP_Components)

# Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `ARampZone` | `PrototypeRacing/Public/RampZone.h:13` / `Private/RampZone.cpp:12` | Level-placed ramp actor. `PrimaryActorTick.bCanEverTick = false` (line 12, uses overlap events only). Owns `UBoxComponent* RampTrigger` + `UStaticMeshComponent* RampMeshComponent`. |
| `ARampZone::OnRampOverlapBegin` | `RampZone.cpp:51` | On car entry: cast to `ASimulatePhysicsCar`, cancel drift if drifting, call `TriggerAllowFlying()`. If not high-platform: set `bIsRampBoostActive`, `RampBoostTimeRemaining`, `RampAccelBoost = CalculateBoostMultiplier(Car)`, fire `OnRampBoost(true)`, broadcast `EVehicleSkillType::HangTime`. |
| `ARampZone::OnRampOverlapEnd` | `RampZone.cpp:95` | On car exit (high-platform only): damp angular velocity by 0.2×(X,Y) and 0.5×(Z) to stabilise landing. |
| `ARampZone::CalculateBoostMultiplier` | `RampZone.cpp:117` | Derives boost multiplier from `BoostForceCurve` and ramp geometry. |
| `ASimulatePhysicsCar::Jump` | `SimulatePhysicsCar.cpp:3341` | Applies upward impulse via `ATP_AddImpulse` if `!bInAir`. |
| `EVehicleSkillType` (RampBoost/HangTime) | `SimulatePhysicsCar.h:438–448` | Enum value broadcast via `OnVehicleSkillTriggered` delegate when ramp activates. |

Runtime flow:
```
[Car enters RampTrigger box] ARampZone::OnRampOverlapBegin (line 51)
   ├─ Cast<ASimulatePhysicsCar>(OtherActor)  — bail if not car
   ├─ if !Car->bShouldApplyRampBoost → return  (guard flag on car)
   ├─ if Car->IsDrifting() → Car->CancelDrift()
   ├─ Car->TriggerAllowFlying()
   ├─ [if !bIsHighPlatform]
   │    Car->bIsRampBoostActive = true
   │    Car->RampBoostTimeRemaining = Car->RampBoostDuration
   │    Car->RampAccelBoost = CalculateBoostMultiplier(Car)
   │    Car->OnRampBoost(true)
   │    Car->OnVehicleSkillTriggered.Broadcast(EVehicleSkillType::HangTime, ...)
   └─ [if bIsHighPlatform → return after TriggerAllowFlying]

[Car exits RampTrigger box] ARampZone::OnRampOverlapEnd (line 95)
   └─ [if bIsHighPlatform]
        damp angular velocity: X*0.2, Y*0.2, Z*0.5
```

Hotspots:
- `ARampZone` has `PrimaryActorTick.bCanEverTick = false` — good, no tick cost.
- `PrintString` call at line 53 of `OnRampOverlapBegin` is a debug log — should be wrapped in `#if !UE_BUILD_SHIPPING` or removed before release.
- `bShouldApplyRampBoost` guard (line 60) is the main gate; ensure it is correctly initialised on all car pawns (AI and player).

# Layer 2 — Contract surface

Key fields on `ARampZone`:
```cpp
float BoostForce = 800.f;          // UPROPERTY(EditAnywhere)
bool  bIsHighPlatform = false;     // changes behaviour on overlap end
bool  bShowTrajectoryPreview = false;
float PreviewSpeedKph = 145.f;
float PreviewBoostMult = 1.74f;    // auto-calculated, read-only
float PreviewRampAngle = 20.65f;   // auto-calculated, read-only
// RefreshTrajectoryPreview()  UFUNCTION(CallInEditor)
```

Key fields on `ASimulatePhysicsCar` (ramp-related):
```cpp
bool  bShouldApplyRampBoost;       // guard: car must opt-in
bool  bIsRampBoostActive;
float RampBoostTimeRemaining;
float RampBoostDuration;
float RampAccelBoost;
```

`EVehicleSkillType` enum (SimulatePhysicsCar.h:438–448):
```cpp
enum class EVehicleSkillType : uint8 {
    None, Pursuit, Drift, Airborne, RampBoost, HangTime, PickUpItem
};
```

Entry points:
- Level design: place `ARampZone` actor, configure `BoostForce` and `bIsHighPlatform` in editor.
- Runtime: `OnRampOverlapBegin`/`OnRampOverlapEnd` (auto-bound in `BeginPlay`).
- Car side: `ASimulatePhysicsCar::Jump(float amount)` for upward impulse (line 3341).

## Links

- Audit: `Docs/audit/DM-RAMP_ramp.md`
- Structurizr: `DM_RAMP_Components`
