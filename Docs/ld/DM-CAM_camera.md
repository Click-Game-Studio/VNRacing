# DM-CAM — CAMERA — Low-Level Design

> Source: `Docs/audit/DM-CAM_camera.md`, `Docs/c4/model.c4`, read-only source under `PrototypeRacing/Source`.
> Structurizr view: `DM_CAM_Components`.
> OpenProject: #336.

## Feature summary and boundaries

DM-CAM owns the chase camera system for the player car: `AFollowCarCamera` actor, its per-frame `TickFunction` (spring arm lerp, FOV curve, turn offset, incline detection, airborne adjustment, bounce simulation), and all camera configuration properties. Vehicle physics belong to DM-PHYS. Race UI HUD belongs to DM-RACE. Camera distance/FOV display settings (which view type is active) belong to DM-SET.

![DM-CAM components](../structurizr/embed/DM_CAM_Components)

# Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `AFollowCarCamera` | `SimpleCarPhysics/Public/FollowCarCamera.h:67` / `Private/FollowCarCamera.cpp:13` | Chase camera actor. Tick every frame via `TickFunction`. Caches `USpringArmComponent* SpringComponent`. |
| `TickFunction(float DeltaTime)` | `FollowCarCamera.cpp:73+` | Per-frame: lerp spring arm length (`InterpTo`), lerp FOV (`InterpTo`), read `CameraDistanceBaseOnSpeed->GetFloatValue`, read `CameraFOVBaseOnSpeed->GetFloatValue`, compute turn offset, apply incline/airborne/bounce adjustments. |
| `RepeatTickSimulate` | `FollowCarCamera.cpp` | Timer-based simulate tick (via `SimulateHandle`). |
| `RegisterFollowTarget` | `FollowCarCamera.h:76` | `BlueprintCallable`; binds the camera to a target `ASimulatePhysicsCar`. Sets `Target` and `SimulatePhysicsCar` pointers. |
| `AdjustDistance / AdjustFOV / AdjustRotationLag` | `FollowCarCamera.h:79–85` | `BlueprintCallable` runtime tuning: spring arm length, FOV, rotation lag. Snap or interpolate. |
| Incline detection | `FollowCarCamera.h:182–195` + `StartCountdownActiveIncline` | Timer-based (`InclineTimerHandle`, `TimeToActivateIncline = 10f`) → `ActiveIncline()`. Adjusts `CurrentInclineZ/X` and `InclineLocation`. |
| Airborne settings | `FollowCarCamera.h:201–202`, `AirborneCameraSettings` | Struct controlling camera behaviour when car is in air. `bWasInAir` flag tracks state. |
| Bounce simulation | `FollowCarCamera.h:173–176` | `BounceStrength = 50f`, `BounceDamping = 4f`, `BounceFrequency = 10f`; runtime state `BounceOffsetZ`, `BounceVelocity`. |

Runtime flow:
```
BeginPlay → cache SpringComponent (line 28 pattern)
RegisterFollowTarget(Car) → store Target + SimulatePhysicsCar pointers

[Each frame] Tick → TickFunction(DeltaTime)
   ├─ read CameraDistanceBaseOnSpeed curve → TargetArmLength
   ├─ read CameraFOVBaseOnSpeed curve → TargetFOV
   ├─ FMath::FInterpTo SpringComponent arm length → TargetArmLength
   ├─ FMath::FInterpTo camera FOV → TargetFOV
   ├─ compute turn offset (rotation delta + TurnOffsetSmoothing)
   ├─ incline detection adjustments (CurrentInclineZ/X)
   ├─ airborne adjustments (CurrentAirborneZ/X/PitchOffset)
   └─ bounce simulation (BounceOffsetZ, BounceVelocity)

[Rotation] Pitch follow alpha = 0.25f, Roll follow alpha = 0.05f
           (comments in Vietnamese in source: "càng nhỏ càng ít lắc theo xe")
```

Hotspots:
- `AFollowCarCamera` ticks every frame — `FollowCarCamera.cpp` line 16 enables tick. `TickFunction` (line 73+) performs multiple `InterpTo` + curve `GetFloatValue` calls + `GetComponentByClass` lookups. Necessary for smooth camera; `SpringComponent` is cached (good); confirm no un-cached `GetComponentByClass` remains in the tick path.
- `PitchFollowAlpha = 0.25f` and `RollFollowAlpha = 0.05f` are hardcoded UPROPERTY defaults — exposed to editor, configurable per-level.

# Layer 2 — Contract surface

Key public API:
```cpp
void RegisterFollowTarget(ASimulatePhysicsCar* TargetToFollow);  // BlueprintCallable
void AdjustDistance(float NewDistance, bool bSnap);              // BlueprintCallable
void AdjustFOV(float NewFOV, bool bSnap);                        // BlueprintCallable
void AdjustRotationLag(float LagPercent, bool bSnap);            // BlueprintCallable
void OnCameraShake();                                             // BlueprintImplementableEvent
void StartCountdownActiveIncline();                               // BlueprintCallable
```

Key config properties (EditAnywhere):
```cpp
float DistanceFollowDecay = 8.0f;
float RotationLagDecay = 2.0f;
float MinCameraSpringLength = -250.f;
float MaxCameraSpringLength = 250.f;
float MinCameraFOV = 55.f;
float MaxCameraFOV = 105.f;
float TopSpeedForCameraLag = 3000.f;
UCurveFloat* CameraDistanceBaseOnSpeed;
UCurveFloat* CameraFOVBaseOnSpeed;
float BounceStrength = 50.f;
float BounceDamping = 4.f;
float BounceFrequency = 10.f;
float TimeToActivateIncline = 10.f;
float PitchFollowAlpha = 0.25f;
float RollFollowAlpha = 0.05f;
```

## Links

- Audit: `Docs/audit/DM-CAM_camera.md`
- Structurizr: `DM_CAM_Components`
