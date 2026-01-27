# Data Flow Architecture - VNRacing

**Breadcrumbs:** Docs > Architecture > Data Flow

**Version:** 1.1.0 | **Date:** 2026-01-26

![Status: Development](https://img.shields.io/badge/Status-Development-blue)

---

## Table of Contents

1. [Overview](#overview)
2. [Subsystem Access Pattern](#1-subsystem-access-pattern)
   - [Global Subsystem Access](#global-subsystem-access)
   - [Subsystem Dependencies](#subsystem-dependencies)
3. [Car Customization Data Flow](#2-car-customization-data-flow)
   - [Configuration Update Flow](#configuration-update-flow)
   - [Performance Calculation Flow](#performance-calculation-flow)
   - [Upgrade Cost Formula](#upgrade-cost-formula)
4. [Progression Data Flow](#3-progression-data-flow)
   - [Race Setup Flow](#race-setup-flow)
   - [Race Completion Flow](#race-completion-flow)
   - [VN-Tour Data Hierarchy](#vn-tour-data-hierarchy)
5. [Profile & Inventory Data Flow](#4-profile--inventory-data-flow)
   - [Currency Flow](#currency-flow)
   - [Inventory Update Flow](#inventory-update-flow)
6. [Settings Data Flow](#5-settings-data-flow)
   - [Setting Update Flow](#setting-update-flow)
   - [Auto Graphic Detection Flow](#auto-graphic-detection-flow)
7. [Save/Load Data Flow](#6-saveload-data-flow)
   - [Centralized Save System](#centralized-save-system)
   - [Save Slot Mapping](#save-slot-mapping)
8. [Minimap Data Flow](#7-minimap-data-flow)
   - [Entity Registration Flow](#entity-registration-flow)
   - [Path Drawing Flow](#path-drawing-flow)
9. [Tutorial Data Flow](#8-tutorial-data-flow)
   - [Tutorial Trigger Flow](#tutorial-trigger-flow)
10. [AI Data Flow](#9-ai-data-flow)
    - [AI Spawning Flow](#ai-spawning-flow)
11. [Event-Driven Communication](#10-event-driven-communication)
    - [Key Delegates](#key-delegates)
    - [UI Binding Pattern](#ui-binding-pattern)
12. [Data Flow Best Practices](#data-flow-best-practices)
13. [Related Documentation](#related-documentation)

---

## Overview

This document describes the data flow patterns in VNRacing, synchronized with the actual source code. It covers game state management, player progression, customization, settings, and persistence.

---

## 1. Subsystem Access Pattern

### Global Subsystem Access

```cpp
// Access any GameInstanceSubsystem from anywhere
UCarCustomizationManager* CustomManager = GetGameInstance()->GetSubsystem<UCarCustomizationManager>();
UProgressionCenterSubsystem* ProgressionCenter = GetGameInstance()->GetSubsystem<UProgressionCenterSubsystem>();
UCarSettingSubsystem* SettingSubsystem = GetGameInstance()->GetSubsystem<UCarSettingSubsystem>();
UProfileManagerSubsystem* ProfileManager = GetGameInstance()->GetSubsystem<UProfileManagerSubsystem>();
```

### Subsystem Dependencies

```mermaid
graph TD
    subgraph "Customization"
        CCM[UCarCustomizationManager]
    end
    
    subgraph "Progression"
        PCS[UProgressionCenterSubsystem]
        PS[UProgressionSubsystem]
        FSS[UFanServiceSubsystem]
        AS[UAchievementSubsystem]
        CRS[UCarRatingSubsystem]
    end
    
    subgraph "Profile"
        PMS[UProfileManagerSubsystem]
        IM[UInventoryManager]
    end
    
    subgraph "Session"
        RSS[URaceSessionSubsystem]
    end
    
    subgraph "Save"
        CSGM[UCarSaveGameManager]
    end
    
    PCS --> PS
    PCS --> FSS
    PCS --> AS
    PCS --> CRS
    PCS --> RSS
    PCS --> CCM
    
    PS --> CSGM
    PS --> CRS
    PS --> CCM
    PS --> RSS
    PS --> FSS
    
    FSS --> PS
    FSS --> PCS
    
    CRS --> CCM
    
    RSS --> CSGM
    RSS --> PCS
    
    CCM --> CSGM
    PMS --> CSGM
    IM --> CSGM
```

**Legend:**
- **Boxes**: GameInstance Subsystems
- **Grouped Boxes**: Related subsystem categories
- **Arrows**: Direct dependencies (subsystem A depends on subsystem B)

---

## 2. Car Customization Data Flow

### Configuration Update Flow

```mermaid
sequenceDiagram
    participant UI as Garage UI
    participant CCM as UCarCustomizationManager
    participant VF as UVehicleFactory
    participant CC as ACustomizableCar
    participant CSGM as UCarSaveGameManager

    UI->>CCM: ApplyCarPart(Slot, PartID)
    CCM->>CCM: Update CarConfiguration
    CCM->>CCM: CalculatePerformanceStats()
    CCM-->>UI: OnCarConfigurationChanged
    
    UI->>CCM: GetCarMeshes(bIsPreview=true)
    CCM-->>UI: FCarMeshes
    UI->>CC: ConfigCar(BaseCarDef, CarConfig)
    CC->>CC: Update Visual
    
    UI->>CCM: SaveCarConfiguration()
    CCM->>CSGM: SaveCarConfig()
    CSGM-->>CCM: OnCarConfigurationSavedSuccess
```

**Legend:**
- **Solid Arrows (→)**: Synchronous function calls
- **Dashed Arrows (⇢)**: Asynchronous callbacks/events
- **Participants**: System components involved in the flow

### Performance Calculation Flow

```mermaid
graph TD
    Config[FCarConfiguration] --> Base[Get BasePerformanceStats<br/>from DT_BaseCars]
    Base --> Parts[Apply Part Modifiers<br/>from CustomParts]
    Parts --> Levels[Apply Level Upgrades<br/>from BasePerformanceStateLevel]
    Levels --> Stats[FPerformanceStats]
    Stats --> InGame[Convert to<br/>FInGamePerformanceStats]
    InGame --> Display[Display in UI<br/>Speed/Accel/Grips/Nitrous]
```

**Legend:**
- **Boxes**: Data structures or processing steps
- **Arrows**: Data transformation flow
- **Multi-line Boxes**: Processing steps with data sources

### Upgrade Cost Formula

```cpp
// From UCarCustomizationManager::GetCostForNextUpgradePerformance
float Cost = UpgradeBasePrice * FMath::Pow(UpgradeCarScaling, CarScaleNumber) 
           * FMath::Pow(NextLevel, UpgradeLevelScale);

// Default values:
// UpgradeBasePrice = 200
// UpgradeCarScaling = 1.5
// UpgradeLevelScale = 2
```

---

## 3. Progression Data Flow

### Race Setup Flow

```mermaid
sequenceDiagram
    participant UI as Race Selection UI
    participant PCS as UProgressionCenterSubsystem
    participant PS as UProgressionSubsystem
    participant RSS as URaceSessionSubsystem
    participant Level as Level Travel

    UI->>PCS: SetupRaceData(TrackId)
    PCS->>PS: GetTrackById(TrackId)
    PS-->>PCS: FTrackProgress
    PCS->>RSS: SetTrackId(TrackId)
    PCS->>RSS: RemoveFuel(1)
    
    alt Out of Fuel
        PCS-->>UI: EResultExec::OutOfFuel
    else Has Fuel
        PCS-->>UI: EResultExec::Success
        UI->>PCS: TravelToCurrentRace()
        PCS->>PS: GetLevelByTrackId(TrackId)
        PCS->>Level: UGameplayStatics::OpenLevel()
    end
```

**Legend:**
- **Solid Arrows (→)**: Synchronous function calls
- **Dashed Arrows (⇢)**: Return values/callbacks
- **Alt Box**: Conditional branching logic

### Race Completion Flow

```mermaid
sequenceDiagram
    participant RTM as ARaceTrackManager
    participant PCS as UProgressionCenterSubsystem
    participant PS as UProgressionSubsystem
    participant FSS as UFanServiceSubsystem
    participant RSS as URaceSessionSubsystem
    participant CSGM as UCarSaveGameManager

    RTM->>PCS: HandleRaceCompleted(EndRacePlayerData)
    PCS->>FSS: IsFanServiceCompleted()
    FSS-->>PCS: bool
    
    PCS->>PCS: Build FTrackProgressionState
    PCS->>PS: RecordRaceResult(TrackId, StateResult)
    PS->>PS: UpdateAfterRace()
    PS->>PS: HandleUnlockNextTrack()
    
    alt Track Unlocked
        PS-->>PCS: OnUnlockNextTrackSuccess
    end
    
    alt City Unlocked
        PS-->>PCS: OnUnlockNextCitySuccess
    end
    
    PCS->>PCS: HandleCalculateReward()
    PCS->>RSS: AddCoinToProfile(TotalCash)
    PCS-->>RTM: OnRewardCalculated(FPlayerRaceReward)
    
    PS->>CSGM: SaveProgressionData()
    RSS->>CSGM: SaveProfile()
```

**Legend:**
- **Solid Arrows (→)**: Synchronous function calls
- **Dashed Arrows (⇢)**: Return values/callbacks
- **Alt Box**: Conditional events (track/city unlocks)

### VN-Tour Data Hierarchy

```mermaid
graph TD
    VNT[FVNTourProgressionData] --> C1[FCityProgress - Hà Nội]
    VNT --> C2[FCityProgress - TP.HCM]
    VNT --> C3[FCityProgress - Đà Nẵng]
    VNT --> C4[FCityProgress - Huế]
    VNT --> C5[FCityProgress - Hội An]
    
    C1 --> A1[FAreaProgress - Area 1]
    C1 --> A2[FAreaProgress - Area 2]
    
    A1 --> T1[FTrackProgress - Track 1]
    A1 --> T2[FTrackProgress - Track 2]
    A1 --> T3[FTrackProgress - Track 3]
    
    T1 --> FS[FFanServiceData]
    T1 --> RH[TArray&lt;FTrackProgressionState&gt;<br/>Race History]
    T1 --> PM[FProgressMetadata<br/>Level Reference]
```

**Legend:**
- **Boxes**: Data structures in progression hierarchy
- **Arrows**: Containment relationship (parent contains child)
- **Top Level**: Campaign data
- **Middle Levels**: City and area groupings
- **Bottom Level**: Individual track data with mission/history

---

## 4. Profile & Inventory Data Flow

### Currency Flow

```mermaid
sequenceDiagram
    participant Race as Race Complete
    participant PCS as UProgressionCenterSubsystem
    participant RSS as URaceSessionSubsystem
    participant PMS as UProfileManagerSubsystem
    participant CSGM as UCarSaveGameManager

    Race->>PCS: HandleCalculateReward()
    PCS->>PCS: Calculate FPlayerRaceReward
    PCS->>RSS: AddCoinToProfile(TotalCash)
    RSS->>PMS: EarnCurrency(Amount, ECurrencyType::Cash)
    PMS->>PMS: Update PlayerCurrency
    PMS-->>UI: OnCurrencyChanged
    PMS->>CSGM: SaveAllProfileInventory()
```

**Legend:**
- **Solid Arrows (→)**: Synchronous function calls
- **Dashed Arrows (⇢)**: Event broadcasts to UI
- **Flow**: Race reward → Currency update → UI notification → Save

### Inventory Update Flow

```mermaid
sequenceDiagram
    participant Source as Reward/Shop
    participant IM as UInventoryManager
    participant IDB as UItemDatabase
    participant CSGM as UCarSaveGameManager
    participant UI as Inventory UI

    Source->>IM: AddItem(ItemID, Quantity, Source)
    IM->>IDB: GetItemDefinition(ItemID)
    IDB-->>IM: FItemDefinition
    IM->>IM: Check IsStackable()
    IM->>IM: Update InventoryItems
    IM-->>UI: OnItemAdded(ItemID, Amount, FInventoryItem)
    IM->>CSGM: SaveInventoryItemsToSaveGame()
```

**Legend:**
- **Solid Arrows (→)**: Synchronous function calls
- **Dashed Arrows (⇢)**: Return values and event broadcasts
- **Flow**: Item addition → Database lookup → Inventory update → UI notification → Save

---

## 5. Settings Data Flow

### Setting Update Flow

```mermaid
sequenceDiagram
    participant UI as Settings UI
    participant CSS as UCarSettingSubsystem
    participant GUS as UGameUserSettings
    participant PPV as APostProcessVolume
    participant CSGM as UCarSaveGameManager

    UI->>CSS: UpdateGraphicProfile(EGraphicDetails::High)
    CSS->>CSS: Update GraphicSetting
    CSS->>GUS: SetTextureQuality()
    CSS->>GUS: SetShadowQuality()
    CSS->>GUS: SetAntiAliasingQuality()
    CSS->>GUS: ApplySettings()
    CSS->>PPV: Update Bloom/MotionBlur
    CSS-->>UI: OnGraphicSettingsChanged
    CSS->>CSGM: SaveSetting()
```

**Legend:**
- **Solid Arrows (→)**: Synchronous function calls
- **Dashed Arrows (⇢)**: Event broadcasts
- **Flow**: UI input → Settings update → Engine settings → Post-process → Save

### Auto Graphic Detection Flow

```mermaid
sequenceDiagram
    participant CSS as UCarSettingSubsystem
    participant GUS as UGameUserSettings

    CSS->>GUS: RunHardwareBenchmark()
    GUS->>GUS: Analyze Hardware
    GUS-->>CSS: SuitableQuality
    CSS->>CSS: Map to EGraphicDetails
    CSS->>CSS: Set MotionBlur/Bloom based on level
    CSS->>GUS: ApplyHardwareBenchmarkResults()
```

**Legend:**
- **Solid Arrows (→)**: Synchronous function calls
- **Dashed Arrows (⇢)**: Return values
- **Flow**: Benchmark request → Hardware analysis → Quality mapping → Apply settings

---

## 6. Save/Load Data Flow

### Centralized Save System

```mermaid
graph TB
    subgraph "Subsystems"
        CCM[UCarCustomizationManager]
        PS[UProgressionSubsystem]
        AS[UAchievementSubsystem]
        CSS[UCarSettingSubsystem]
        PMS[UProfileManagerSubsystem]
        IM[UInventoryManager]
        RSS[URaceSessionSubsystem]
    end
    
    subgraph "Save Manager"
        CSGM[UCarSaveGameManager]
    end
    
    subgraph "SaveGame Classes"
        RSG[URacingSaveGame<br/>Car Config]
        PSG[UProgressionSaveGame<br/>Progression + Achievement]
        CSS_SG[UCarSaveSetting<br/>Settings]
        PISG[UProfileInventorySaveGame<br/>Profile + Inventory]
    end
    
    subgraph "Storage"
        Local[Local File System]
    end
    
    CCM -->|SaveCarConfig| CSGM
    PS -->|SaveProgressionData| CSGM
    AS -->|SaveAchievementData| CSGM
    CSS -->|SaveSetting| CSGM
    PMS -->|SaveAllProfileInventory| CSGM
    IM -->|SaveInventoryItems| CSGM
    RSS -->|SaveProfile| CSGM
    
    CSGM --> RSG
    CSGM --> PSG
    CSGM --> CSS_SG
    CSGM --> PISG
    
    RSG --> Local
    PSG --> Local
    CSS_SG --> Local
    PISG --> Local
```

**Legend:**
- **Boxes**: System components
- **Grouped Boxes**: Related component categories
- **Arrows with Labels**: Save operations with method names
- **Flow**: Subsystems → Save Manager → SaveGame Classes → File System

### Save Slot Mapping

| Subsystem | Save Name | SaveGame Class |
|-----------|-----------|----------------|
| UCarCustomizationManager | `CarConfig` | URacingSaveGame |
| UProgressionSubsystem | `ProgressionSystem` | UProgressionSaveGame |
| UAchievementSubsystem | `AchievementSystem` | UProgressionSaveGame |
| UCarSettingSubsystem | `GameSettings` | UCarSaveSetting |
| UProfileManagerSubsystem | `ProfileInventory` | UProfileInventorySaveGame |
| UInventoryManager | `ProfileInventory` | UProfileInventorySaveGame |
| URaceSessionSubsystem | `Profile`, `FuelTicks` | UProgressionSaveGame |

---

## 7. Minimap Data Flow

### Entity Registration Flow

```mermaid
sequenceDiagram
    participant Vehicle as ASimulatePhysicsCar
    participant MMS as UMinimapSubsystem
    participant Widget as Minimap Widget

    Vehicle->>MMS: RegisterMinimapEntitySimple(this, VehicleIcon)
    MMS->>MMS: Create Widget for Entity
    MMS->>MMS: Add to WidgetByEntities Map
    MMS-->>Widget: OnEntityAdded
    
    loop Every Tick
        MMS->>Vehicle: GetWorldLocation() via IMinimapEntityInterface
        Vehicle-->>MMS: FVector Location
        MMS->>Widget: Update Icon Position
    end
    
    Vehicle->>MMS: UnregisterMinimapEntity(this)
    MMS->>MMS: Remove from Map
    MMS-->>Widget: OnEntityRemoved
```

**Legend:**
- **Solid Arrows (→)**: Synchronous function calls
- **Dashed Arrows (⇢)**: Return values and events
- **Loop Box**: Continuous update cycle during gameplay

### Path Drawing Flow

```mermaid
sequenceDiagram
    participant Nav as Navigation System
    participant MMS as UMinimapSubsystem
    participant Widget as Minimap Widget

    Nav->>MMS: SetPathColor(FLinearColor::Yellow)
    Nav->>MMS: SetPathThickness(3.0f)
    Nav->>MMS: DrawPath(TArray<FVector> WorldPoints)
    MMS->>MMS: Store PathWorldPoints
    MMS-->>Widget: OnPathPointsChange
    Widget->>Widget: Render Path Line
```

**Legend:**
- **Solid Arrows (→)**: Synchronous function calls
- **Dashed Arrows (⇢)**: Event notifications
- **Flow**: Path configuration → Draw request → Store data → UI update

---

## 8. Tutorial Data Flow

### Tutorial Trigger Flow

```mermaid
sequenceDiagram
    participant Trigger as Tutorial Trigger
    participant TMS as UTutorialManagerSubsystem
    participant Widget as Tutorial Widget
    participant SG as UTutorialSaveGame

    Trigger->>TMS: StartTutorial(TutorialID)
    TMS->>TMS: Check IsTutorialCompleted()
    
    alt Not Completed
        TMS->>TMS: Create Widget (Script or Tooltip)
        TMS->>Widget: Show Tutorial
        Widget-->>TMS: OnTutorialStepCompleted
        TMS->>TMS: AdvanceStep()
        
        loop Until Complete
            Widget-->>TMS: OnTutorialStepCompleted
            TMS->>TMS: AdvanceStep()
        end
        
        TMS->>TMS: MarkTutorialCompleted()
        TMS->>SG: SaveTutorialProgress()
    end
```

**Legend:**
- **Solid Arrows (→)**: Synchronous function calls
- **Dashed Arrows (⇢)**: Event callbacks
- **Alt Box**: Conditional execution (only if not completed)
- **Loop Box**: Step progression until tutorial complete

---

## 9. AI Data Flow

### AI Spawning Flow

```mermaid
sequenceDiagram
    participant RTM as ARaceTrackManager
    participant AIM as UAIManagerSubsystem
    participant AIV as AI Vehicle

    RTM->>AIM: SpawnAIVehicles(Count, Difficulty)
    
    loop For Each AI
        AIM->>AIM: Select Vehicle Class
        AIM->>AIM: Configure Behavior (Aggressive/Defensive/Balanced)
        AIM->>AIV: Spawn at Start Position
        AIV->>AIV: Initialize Spline Following
    end
    
    AIM-->>RTM: OnAIVehiclesSpawned
```

**Legend:**
- **Solid Arrows (→)**: Synchronous function calls
- **Dashed Arrows (⇢)**: Completion callback
- **Loop Box**: Repeated spawning for each AI vehicle
- **Flow**: Race manager requests → AI manager spawns → Vehicles initialize

---

## 10. Event-Driven Communication

### Key Delegates

| Subsystem | Delegate | Purpose |
|-----------|----------|---------|
| UCarCustomizationManager | `OnCarConfigurationChanged` | Config updated |
| UCarCustomizationManager | `OnPerformanceStatUpgraded` | Upgrade success |
| UProgressionCenterSubsystem | `OnRewardCalculated` | Race reward ready |
| UProgressionCenterSubsystem | `OnUnlockNextTrackSuccess` | Track unlocked |
| UProgressionSubsystem | `OnProgressionUpdated` | Progression changed |
| UFanServiceSubsystem | `OnFanServiceProgressUpdate` | Mission progress |
| UProfileManagerSubsystem | `OnCurrencyChanged` | Currency updated |
| UInventoryManager | `OnItemAdded` | Item added |
| UCarSettingSubsystem | `OnGraphicSettingsChanged` | Graphics changed |
| URaceSessionSubsystem | `OnFuelChange` | Fuel updated |
| UMinimapSubsystem | `OnEntityAdded` | Entity registered |

### UI Binding Pattern

```cpp
// Widget binds to subsystem events
void UMyWidget::NativeConstruct()
{
    Super::NativeConstruct();
    
    if (UCarCustomizationManager* CCM = GetGameInstance()->GetSubsystem<UCarCustomizationManager>())
    {
        CCM->OnCarConfigurationChanged.AddDynamic(this, &UMyWidget::OnConfigChanged);
    }
}

void UMyWidget::NativeDestruct()
{
    if (UCarCustomizationManager* CCM = GetGameInstance()->GetSubsystem<UCarCustomizationManager>())
    {
        CCM->OnCarConfigurationChanged.RemoveDynamic(this, &UMyWidget::OnConfigChanged);
    }
    
    Super::NativeDestruct();
}
```

---

## Data Flow Best Practices

### 1. Unidirectional Data Flow
- Data flows from authoritative source (subsystem) to consumers (UI)
- Avoid circular dependencies
- Clear ownership of data

### 2. Event-Driven Updates
- Use Event Dispatchers for loose coupling
- Subsystems broadcast changes
- UI listens and updates

### 3. Centralized Persistence
- All save/load through `UCarSaveGameManager`
- Consistent save slot naming
- Validation on load

### 4. Interface Abstraction
- `ICarDataProvider`, `IProgressionDataProvider`, `ISettingDataProvider`
- Clean API contracts
- Testability

---

## Related Documentation

- [System Overview](./system-overview.md)
- [Integration Patterns](./integration-patterns.md)
- [Technology Stack](./technology-stack.md)
