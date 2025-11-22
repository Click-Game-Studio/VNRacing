---
phase: implementation
title: Tutorial System Implementation Guide
description: Code patterns, integration instructions, and development setup for tutorial system implementation
---

# Tutorial System Implementation Guide

## Development Setup

### Prerequisites
- **Unreal Engine**: 5.4+ (project currently using UE 5.4)
- **Required Plugins**: Enhanced Input System (already integrated)
- **Existing Systems Dependencies**:
  - `ARaceTrackManager` - Race event broadcasting
  - `UPrototypeRacingUI` - Base HUD widget class
  - `UCarSaveGameManager` - Save/load persistence
  - `UFanServiceSubsystem` - Progression tracking
  - `ASimulatePhysicsCar` - Vehicle physics and state

### Project Structure
```
PrototypeRacing/
├── Source/PrototypeRacing/
│   ├── Public/Tutorial/
│   │   ├── TutorialManagerSubsystem.h
│   │   ├── ScriptTutorialWidget.h
│   │   ├── TooltipTutorialWidget.h
│   │   └── TutorialTypes.h
│   └── Private/Tutorial/
│       ├── TutorialManagerSubsystem.cpp
│       ├── ScriptTutorialWidget.cpp
│       └── TooltipTutorialWidget.cpp
└── Content/UI/Tutorials/
    ├── WBP_ScriptTutorial.uasset
    ├── WBP_Tooltip.uasset
    ├── DT_TutorialSteps.uasset (Data Table)
    └── Materials/
        └── M_ScreenMask.uasset
```

### Configuration Steps
1. Add Tutorial module to `PrototypeRacing.Build.cs` dependencies (if creating separate module)
2. Create folder structure as shown above
3. Import Figma UI assets to `Content/UI/Tutorials/`
4. Create Data Table `DT_TutorialSteps` with row type `FTutorialStepData`

## Code Structure

### 1. TutorialTypes.h - Enums and Structs

```cpp
// TutorialTypes.h
#pragma once
#include "CoreMinimal.h"
#include "Engine/DataTable.h"
#include "TutorialTypes.generated.h"

UENUM(BlueprintType)
enum class ETutorialID : uint8
{
    None UMETA(DisplayName = "None"),
    BasicControls1 UMETA(DisplayName = "Basic Controls 1"),
    BasicControls2 UMETA(DisplayName = "Basic Controls 2"),
    VnTourMap UMETA(DisplayName = "VnTour Map Tutorial"),
    BasicCarUpgrade UMETA(DisplayName = "Basic Car Upgrade"),
    AdvancedCarUpgrade UMETA(DisplayName = "Advanced Car Upgrade"),
    BasicCarCustomize UMETA(DisplayName = "Basic Car Customize")
};

UENUM(BlueprintType)
enum class ETooltipType : uint8
{
    None UMETA(DisplayName = "None"),
    UpgradeAvailable UMETA(DisplayName = "New Car Upgrade Available"),
    OutOfFuel UMETA(DisplayName = "You Are Out Of Fuel"),
    NewShopItems UMETA(DisplayName = "New Items Available In Shop")
};

UENUM(BlueprintType)
enum class EControlType : uint8
{
    None UMETA(DisplayName = "None"),
    SteerLeft UMETA(DisplayName = "Steer Left"),
    SteerRight UMETA(DisplayName = "Steer Right"),
    Drift UMETA(DisplayName = "Drift"),
    NOS UMETA(DisplayName = "NOS/Boost"),
    Brake UMETA(DisplayName = "Brake")
};

USTRUCT(BlueprintType)
struct FTutorialStepData : public FTableRowBase
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FText PanelText;

    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    TSoftObjectPtr<UTexture2D> PanelImage;

    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    EControlType HighlightedControl = EControlType::None;

    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    float AutoDismissTime = 2.0f;

    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FString CompletionCondition; // For Blueprint logic
};

USTRUCT(BlueprintType)
struct FTutorialSaveData
{
    GENERATED_BODY()

    UPROPERTY(SaveGame)
    TArray<ETutorialID> CompletedTutorials;
};
```

### 2. UTutorialManagerSubsystem - Core Logic

```cpp
// TutorialManagerSubsystem.h
#pragma once
#include "CoreMinimal.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "TutorialTypes.h"
#include "TutorialManagerSubsystem.generated.h"

class UScriptTutorialWidget;
class UTooltipTutorialWidget;

UCLASS()
class PROTOTYPERACING_API UTutorialManagerSubsystem : public UGameInstanceSubsystem
{
    GENERATED_BODY()

public:
    virtual void Initialize(FSubsystemCollectionBase& Collection) override;
    virtual void Deinitialize() override;

    UFUNCTION(BlueprintCallable, Category = "Tutorial")
    void CheckAndTriggerTutorial(ETutorialID TutorialID);

    UFUNCTION(BlueprintPure, Category = "Tutorial")
    bool IsTutorialCompleted(ETutorialID TutorialID) const;

    UFUNCTION(BlueprintCallable, Category = "Tutorial")
    void MarkTutorialCompleted(ETutorialID TutorialID);

    UFUNCTION(BlueprintCallable, Category = "Tutorial")
    void ShowTooltip(ETooltipType TooltipType, FText Message);

    void SaveTutorialProgress();
    void LoadTutorialProgress();

    UFUNCTION(Exec)
    void ResetTutorials();

    UFUNCTION(Exec)
    void TriggerTutorial(FString TutorialName);

private:
    UPROPERTY()
    TMap<ETutorialID, bool> CompletedTutorials;

    UPROPERTY()
    TSet<ETooltipType> TooltipsShownThisSession;

    UPROPERTY()
    UScriptTutorialWidget* ActiveScriptTutorial;

    UPROPERTY()
    TArray<UTooltipTutorialWidget*> TooltipPool;

    UPROPERTY(EditDefaultsOnly, Category = "Tutorial")
    TSubclassOf<UScriptTutorialWidget> ScriptTutorialClass;

    UPROPERTY(EditDefaultsOnly, Category = "Tutorial")
    TSubclassOf<UTooltipTutorialWidget> TooltipClass;
};
```

## Implementation Notes

### Pattern 1: Event-Driven Updates (No Tick)
**Requirement**: Zero Tick-based updates for mobile performance

**Implementation**:
- Use `FTimerHandle` for auto-dismiss timers
- Use Event Dispatchers from `ARaceTrackManager` for race events
- Use Blueprint events for UI updates

**Example**:
```cpp
// ❌ BAD - Don't use Tick
void UScriptTutorialWidget::NativeTick(const FGeometry& MyGeometry, float InDeltaTime)
{
    // Never implement this!
}

// ✅ GOOD - Use Timer
void UScriptTutorialWidget::StartAutoDismissTimer(float Duration)
{
    GetWorld()->GetTimerManager().SetTimer(
        AutoDismissTimerHandle,
        this,
        &UScriptTutorialWidget::AdvanceToNextStep,
        Duration,
        false
    );
}
```

### Pattern 2: Simple State Management
**Requirement**: No complex state machines, just boolean flags

**Implementation**:
```cpp
// ✅ Simple boolean map - easy to understand and debug
TMap<ETutorialID, bool> CompletedTutorials;

bool UTutorialManagerSubsystem::IsTutorialCompleted(ETutorialID TutorialID) const
{
    const bool* bCompleted = CompletedTutorials.Find(TutorialID);
    return bCompleted ? *bCompleted : false;
}
```

### Pattern 3: Reuse Existing Systems
**Requirement**: Leverage existing `UPrototypeRacingUI` and `ARaceTrackManager`

**Implementation**:
```cpp
// Extend existing base class
class UScriptTutorialWidget : public UPrototypeRacingUI
{
    // Inherit all existing HUD functionality
};

// Hook into existing events
void AMyRaceTrackManager::OnRaceStart()
{
    Super::OnRaceStart();
    
    if (UTutorialManagerSubsystem* TutorialMgr = GetGameInstance()->GetSubsystem<UTutorialManagerSubsystem>())
    {
        TutorialMgr->CheckAndTriggerTutorial(ETutorialID::BasicControls1);
    }
}
```

## Integration Points

### 1. ARaceTrackManager Integration
**Location**: `RaceTrackManager.cpp`

**Hook Points**:
- `OnRaceStart()` - Trigger Basic Controls 1 on first race
- `OnCheckpointPassed()` - Detect first curve approach
- `OnRaceCompleted()` - Trigger VnTourMap after first race

### 2. ASimulatePhysicsCar Integration
**Location**: `SimulatePhysicsCar.cpp`

**Hook Points**:
- `OnDriftStarted()` - Trigger Basic Controls 2 on first drift
- `OnFuelDepleted()` - Show "Out of Fuel" tooltip

### 3. UFanServiceSubsystem Integration
**Location**: `FanServiceSubsystem.cpp`

**Hook Points**:
- `OnUpgradeAvailable()` - Show "Upgrade Available" tooltip
- `OnShopItemUnlocked()` - Show "New Shop Items" tooltip

### 4. Save System Integration
**Location**: Existing save game class

**Changes**:
- Add `FTutorialSaveData TutorialData` property
- Call `UTutorialManagerSubsystem::SaveTutorialProgress()` on save
- Call `UTutorialManagerSubsystem::LoadTutorialProgress()` on load

## Best Practices

1. **Keep It Simple**: No abstractions, interfaces, or design patterns unless absolutely necessary
2. **Event-Driven**: Never use Tick, always use timers and event dispatchers
3. **Reuse Existing Code**: Extend `UPrototypeRacingUI`, use existing save system patterns
4. **Blueprint-Friendly**: Expose all necessary functions with `UFUNCTION(BlueprintCallable)`
5. **Mobile Performance**: Profile early, optimize widget complexity, use object pooling for tooltips
6. **Localization**: Use `FText` for all user-facing strings, create string tables
7. **Debug Tools**: Implement console commands for testing (`ResetTutorials`, `TriggerTutorial`)

## Common Pitfalls to Avoid

❌ **Don't**: Create abstract base classes or interfaces
✅ **Do**: Use simple inheritance from `UPrototypeRacingUI`

❌ **Don't**: Implement complex state machines
✅ **Do**: Use simple boolean flags in a `TMap`

❌ **Don't**: Use Tick for updates
✅ **Do**: Use `FTimerHandle` and event dispatchers

❌ **Don't**: Create new save system
✅ **Do**: Extend existing `UCarSaveGameManager` pattern

❌ **Don't**: Hardcode tutorial text
✅ **Do**: Use `FText` and string tables for localization

