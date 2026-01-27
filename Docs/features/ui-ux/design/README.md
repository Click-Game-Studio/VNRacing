# UI/UX Design

**Breadcrumbs:** [Docs](../../../) > [Features](../../) > [UI/UX](../) > Design

---

## Widget Hierarchy

```
UUserWidget (Engine Base)
└── UPrototypeRacingUI (Base HUD Widget)
    ├── UScriptTutorialWidget (Interactive Tutorials)
    └── UTooltipTutorialWidget (Passive Tooltips)

UUserWidget (Engine Base)
└── UOpponentInfoWidget (World-Space Opponent Display)
```

## HUD Components

The main HUD (`UPrototypeRacingUI`) manages the following display elements:

| Component | Data Source | Update Trigger |
|-----------|-------------|----------------|
| Speed Display | `ASimulatePhysicsCar` | `OnSpeedUpdate` event |
| Gear Display | `ASimulatePhysicsCar` | `OnGearUpdate` event |
| NOS Bar | `ASimulatePhysicsCar` | `OnNitrousUpdate` event |
| Race Progress | `ARaceTrackManager` | `OnRaceProgressUpdate` event |
| Player Position | `ARaceTrackManager` | `OnPlayerPositionUpdate` event |
| Lap Counter | `ARaceTrackManager` | `OnLapChanged` event |
| Race Timer | `ARaceTrackManager` | `OnRaceTimerUpdate` event |
| Skill Popup | Skill System | `OnSkillActivated` event |
| Fan Service | `UFanServiceSubsystem` | `OnFanServiceProgressChanged` event |
| Opponent Info | `UOpponentInfoManager` | Distance-based visibility |

## Event Binding Pattern

All UI updates are event-driven (no tick-based updates for mobile performance):

```cpp
// In UPrototypeRacingUI::NativeConstruct()
void BindToRaceEvents(ARaceTrackManager* RaceManager);
void BindToVehicleEvents(ASimulatePhysicsCar* Vehicle);
void BindToFanServiceEvents(UFanServiceSubsystem* FanService);
```

### Event Flow

```
Game Systems Layer
├── ARaceTrackManager → OnRankingUpdate, OnLapCompleted, OnTimeUpdate
├── ASimulatePhysicsCar → OnDriftPointChanged, Speed/Gear/NOS updates
└── UFanServiceSubsystem → OnFanServiceProgressUpdated
        ↓
    Event Bus (Delegates)
        ↓
    HUD Layer (UPrototypeRacingUI)
        ↓
    Blueprint Events (OnSpeedUpdate, OnGearUpdate, etc.)
```

## Design Principles

1. **Event-Driven Architecture**: All UI updates triggered by events
2. **Component Composition**: Extend `UPrototypeRacingUI` with child widgets
3. **Object Pooling**: Skill popups and tooltips use pooled instances
4. **Separation of Concerns**: Game logic in C++, UI presentation in Blueprint
5. **Mobile-First Performance**: Distance-based updates, minimal draw calls

## Detailed Architecture

> **Note**: For comprehensive HUD architecture including widget hierarchies, 
> object pooling specifications, and implementation details, see:
> 
> **[Player Info HUD Architecture](../../progression-system/design/player-info-hud-architecture.md)**

---

**Last Updated:** 2026-01-26

