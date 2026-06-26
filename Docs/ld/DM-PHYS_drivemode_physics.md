# DM-PHYS — DriveMode-Physics — Low-Level Design

> Source: `Docs/audit/DM-PHYS_drivemode_physics.md`, `Docs/c4/model.c4`, read-only source under `PrototypeRacing/Source`.
> Structurizr view: `DM_PHYS_Components`.
> OpenProject: #279.

## Feature summary and boundaries

DM-PHYS owns player/AI car simulation: vehicle actor, wheel/suspension update, movement component, vehicle factory helpers and Blueprint car configurations. It does NOT own the chase camera (DM-CAM), NOS boost (DM-NOS), ramp launch (DM-RAMP), or race rules (DM-RACE). AI decision policy belongs to SUP-AI. Customization data belongs to CU-ROOM.

Collision/wall-correction work (OpenProject #284/#278 "Dev_Implement_Collision Debug") is in-scope as an active hotspot: `FMotionDebugProcessor` and any wall-correction impulse logic live inside `ASimulatePhysicsCar`.

![DM-PHYS components](../structurizr/embed/DM_PHYS_Components)

# Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `ASimulatePhysicsCar` | `SimpleCarPhysics/Private/PhysicsSimulateCar/SimulatePhysicsCar.cpp` | Core gameplay vehicle pawn; `PrimaryActorTick.bCanEverTick = true` (ctor line 67); per-frame Tick updates suspension/wheels, animation sync, race-facing state, collision debug. |
| `ASimulatePhysicsCarWithCustom` | `PrototypeRacing/Private/SimulatePhysicsCarWithCustom.cpp` | Subclass adding customization stat application on top of the physics core. |
| `UCustomChaosWheeledVehicle` | `PrototypeRacing/Private/CustomChaosWheeledVehicle.cpp:12,28-33` | Chaos movement component override; `PrimaryComponentTick.bCanEverTick = true` (line 12) but `TickComponent` body (lines 28–33) only calls `Super::` — empty tick scheduled every frame per car. |
| `UCustomSuspensionComponent` | `SimpleCarPhysics/Private/PhysicsSimulateCar/CustomSuspensionComponent.cpp` | Per-wheel suspension; ticks every frame per car instance. |
| `UVehicleFactory` | `PrototypeRacing/Private/VehicleFactory.cpp` | Standardised vehicle creation and configuration helper. |
| `APIDControl` | `PrototypeRacing/Private/PIDControl.cpp` | PID controller actor; tick-driven steering helper used by autodrive. |
| Customisable car BPs | Blueprint metadata (audit) | Visual/component setup over C++ pawn: `BP_Customizable_VF8`, `BP_Customizable_MercedesBenz`, `BP_Customizable_VFLuxA`, `BP_SportsCar_Pawn`. |

Runtime flow: race/game mode (DM-RACE) spawns or owns car actors; vehicle Tick updates physics/suspension; DM-RACE writes rank/race state; SUP-AI calls autodrive/guide-line support for AI cars; CU-ROOM supplies visual/performance stats.

Hotspots: empty movement component tick (line 12/28–33), heavy per-car Tick paths in `ASimulatePhysicsCar`, Blueprint vehicles calling `Parent: Tick` (cost compounds), `FMotionDebugProcessor` global debug processor (collision debug path, #284/#278). See `Docs/audit/DM-PHYS_drivemode_physics.md`.

# Layer 2 — Contract surface (verified entry points)

Stable entry points: `ASimulatePhysicsCar` vehicle pawn, `UCustomChaosWheeledVehicle` movement component, `UCustomSuspensionComponent` suspension component, `UVehicleFactory` factory, `APIDControl` steering helper. Cross-feature consumers: DM-RACE sets rank/race lifecycle state, SUP-AI drives AI cars via `AutoDrive`, DM-NOS calls `BoostNitro`, DM-RAMP calls `Jump`/`TriggerAllowFlying`/`OnRampBoost`, DM-CAM follows the car via `RegisterFollowTarget`.

Evidence gap: this LD does not enumerate every vehicle function signature. Read the source headers before reimplementation or API changes.

## Links

- Audit: `Docs/audit/DM-PHYS_drivemode_physics.md`
- Structurizr: `DM_PHYS_Components`
- Collision/wall-correction: OpenProject #284, #278
