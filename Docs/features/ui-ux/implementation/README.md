# UI/UX Implementation

**Breadcrumbs:** [Docs](../../../) > [Features](../../) > [UI/UX](../) > Implementation

---

## Source Code Locations

| Component | Header | Implementation |
|-----------|--------|----------------|
| UPrototypeRacingUI | `PrototypeRacing/PrototypeRacingUI.h` | `PrototypeRacing/PrototypeRacingUI.cpp` |
| UScriptTutorialWidget | `Public/TutorialSystem/ScriptTutorialWidget.h` | `Private/TutorialSystem/ScriptTutorialWidget.cpp` |
| UTooltipTutorialWidget | `Public/TutorialSystem/TooltipTutorialWidget.h` | `Private/TutorialSystem/TooltipTutorialWidget.cpp` |
| UOpponentInfoWidget | `Public/OpponentinfoWidget/OpponentInfoWidget.h` | `Private/OpponentinfoWidget/OpponentInfoWidget.cpp` |
| UOpponentInfoManager | `Public/OpponentinfoWidget/OpponentInfoManager.h` | `Private/OpponentinfoWidget/OpponentInfoManager.cpp` |

**Base Path:** `PrototypeRacing/Source/PrototypeRacing/`

---

## Key Classes

### UPrototypeRacingUI

Base HUD widget class that all racing UI widgets extend.

```cpp
UCLASS(abstract)
class PROTOTYPERACING_API UPrototypeRacingUI : public UUserWidget
{
    // Core update methods
    void UpdateSpeed(float NewSpeed);
    void UpdateGear(int32 NewGear);
    void UpdateNitrous(float NewNitrous);
    
    // Event binding
    void BindToRaceEvents(ARaceTrackManager* RaceManager);
    void BindToVehicleEvents(ASimulatePhysicsCar* Vehicle);
    void BindToFanServiceEvents(UFanServiceSubsystem* FanService);
    void UnbindAllEvents();
};
```

---

## Event Delegates

### Vehicle Events (BlueprintImplementableEvent)

| Delegate | Parameters | Purpose |
|----------|------------|---------|
| `OnSpeedUpdate` | `float NewSpeed` | Speed display update |
| `OnGearUpdate` | `int32 NewGear` | Gear indicator update |
| `OnNitrousUpdate` | `float NewNitrous` | NOS bar update |

### Race Events (BlueprintImplementableEvent)

| Delegate | Parameters | Purpose |
|----------|------------|---------|
| `OnRaceProgressUpdate` | `TArray<FPlayerRaceState>` | Full race state |
| `OnPlayerPositionUpdate` | `int32 Position, int32 TotalRacers` | Position display |
| `OnRaceTimerUpdate` | `FString FormattedTime` | Timer display |
| `OnLapChanged` | `int32 CurrentLap, int32 TotalLaps` | Lap counter |

### Skill & Fan Service Events

| Delegate | Parameters | Purpose |
|----------|------------|---------|
| `OnSkillActivated` | `ESkillType, float Points` | Skill popup trigger |
| `OnFanServiceProgressChanged` | `FFanServiceProgressData` | Mission progress |

---

## ESkillType Enum

```cpp
UENUM(BlueprintType)
enum class ESkillType : uint8 {
    PerfectDrift,      // Drift skill bonus
    AirborneBoost,     // Jump/air time bonus
    NearMiss,          // Close pass bonus
    CheckpointBonus,   // Checkpoint timing bonus
    SpeedDemon         // High speed bonus
};
```

**Location:** `PrototypeRacing/Source/PrototypeRacing/PrototypeRacingUI.h`

---

## Cached References

`UPrototypeRacingUI` maintains cached references for event binding:

```cpp
UPROPERTY(Transient, BlueprintReadOnly)
ARaceTrackManager* CachedRaceManager;

UPROPERTY(Transient, BlueprintReadOnly)
ASimulatePhysicsCar* CachedVehicle;

UPROPERTY(Transient, BlueprintReadOnly)
UFanServiceSubsystem* CachedFanService;
```

---

**Last Updated:** 2026-01-26

