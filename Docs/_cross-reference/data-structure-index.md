# Data Structure Index - VNRacing

**Breadcrumbs:** [Docs](../README.md) > [Cross-Reference](./) > Data Structure Index

**Project**: VNRacing - Mobile Racing Game
**Document**: Comprehensive Data Structure Reference
**Version**: 1.0.1 | **Date**: 2026-01-26
**Status**: 🔄 Development

> **Last synced with source code: 2026-01-26**

## Overview

This document provides a comprehensive index of all major data structures (USTRUCT, UENUM, classes) used throughout the VNRacing project, organized by feature and purpose.

**Core Features Covered:**
- Car Physics
- Car Customization
- Progression System
- Profiles & Inventory
- Setting System
- Race Modes
- Multiplayer
- Shop System
- Racer AI
- Tutorial System
- Minimap System

## Table of Contents

1. [Core Game Structures](#1-core-game-structures)
2. [Progression Structures](#2-progression-structures)
3. [Customization Structures](#3-customization-structures)
4. [Shop Structures](#4-shop-structures)
5. [Multiplayer Structures](#5-multiplayer-structures)
6. [Settings Structures](#6-settings-structures)
7. [Save Game Structures](#7-save-game-structures)
8. [Analytics Structures](#8-analytics-structures)
9. [Enumerations](#9-enumerations-updated)
10. [Profiles & Inventory Structures](#10-profiles--inventory-structures)
11. [Racer AI Structures](#11-racer-ai-structures)
12. [Tutorial Structures](#12-tutorial-structures)
13. [Minimap Structures](#13-minimap-structures)
14. [Data Structure Best Practices](#data-structure-best-practices)
15. [Conclusion](#conclusion)

---

## 1. Core Game Structures

### FVehiclePhysicsConfig
```cpp
USTRUCT(BlueprintType)
struct FVehiclePhysicsConfig
{
    GENERATED_BODY()
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Physics")
    float MaxSpeed = 200.0f; // km/h
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Physics")
    float Acceleration = 10.0f;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Physics")
    float Braking = 15.0f;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Physics")
    float Handling = 1.0f;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Physics")
    float Mass = 1500.0f; // kg
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Physics")
    float Downforce = 0.5f;
};
```
**Used By**: Racing Car Physics, Car Customization
**File**: `Source/PrototypeRacing/Public/Vehicle/VehiclePhysicsConfig.h`

---

### FRaceResult
```cpp
USTRUCT(BlueprintType)
struct FRaceResult
{
    GENERATED_BODY()
    
    UPROPERTY(BlueprintReadOnly, Category = "Race")
    FString PlayerName;
    
    UPROPERTY(BlueprintReadOnly, Category = "Race")
    int32 Position;
    
    UPROPERTY(BlueprintReadOnly, Category = "Race")
    float CompletionTime;
    
    UPROPERTY(BlueprintReadOnly, Category = "Race")
    TArray<float> LapTimes;
    
    UPROPERTY(BlueprintReadOnly, Category = "Race")
    int32 XPEarned;
    
    UPROPERTY(BlueprintReadOnly, Category = "Race")
    int32 CurrencyEarned;
    
    UPROPERTY(BlueprintReadOnly, Category = "Race")
    bool bNewPersonalBest;
};
```
**Used By**: Race Modes, Progression System, UI/UX
**File**: `Source/PrototypeRacing/Public/Game/RaceResult.h`

---

### FCheckpointData
```cpp
USTRUCT(BlueprintType)
struct FCheckpointData
{
    GENERATED_BODY()
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Checkpoint")
    int32 CheckpointIndex;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Checkpoint")
    FVector Location;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Checkpoint")
    FRotator Rotation;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Checkpoint")
    float Width = 1000.0f;
    
    UPROPERTY(BlueprintReadOnly, Category = "Checkpoint")
    float TimeReached;
};
```
**Used By**: Race Modes, Anti-Cheat
**File**: `Source/PrototypeRacing/Public/Game/CheckpointData.h`

---

## 2. Progression Structures

### FPlayerProgression
```cpp
USTRUCT(BlueprintType)
struct FPlayerProgression
{
    GENERATED_BODY()
    
    UPROPERTY(BlueprintReadOnly, Category = "Progression")
    int32 PlayerLevel = 1;
    
    UPROPERTY(BlueprintReadOnly, Category = "Progression")
    int32 CurrentXP = 0;
    
    UPROPERTY(BlueprintReadOnly, Category = "Progression")
    TArray<FString> UnlockedContent;
    
    UPROPERTY(BlueprintReadOnly, Category = "Progression")
    TMap<FString, int32> Statistics;
    
    UPROPERTY(BlueprintReadOnly, Category = "Progression")
    FVNTourProgress VNTourProgress;
};
```
**Used By**: Progression System, UI/UX
**File**: `Source/PrototypeRacing/Public/Progression/PlayerProgression.h`

---

### FVNTourProgress
```cpp
USTRUCT(BlueprintType)
struct FVNTourProgress
{
    GENERATED_BODY()
    
    UPROPERTY(BlueprintReadOnly, Category = "VN Tour")
    TMap<FString, FCityProgress> CityProgress;
    
    UPROPERTY(BlueprintReadOnly, Category = "VN Tour")
    int32 TotalStarsEarned = 0;
    
    UPROPERTY(BlueprintReadOnly, Category = "VN Tour")
    bool bCampaignCompleted = false;
};

USTRUCT(BlueprintType)
struct FCityProgress
{
    GENERATED_BODY()
    
    UPROPERTY(BlueprintReadOnly, Category = "City")
    FString CityName;
    
    UPROPERTY(BlueprintReadOnly, Category = "City")
    TArray<FTrackProgress> Tracks;
    
    UPROPERTY(BlueprintReadOnly, Category = "City")
    int32 StarsEarned = 0;
    
    UPROPERTY(BlueprintReadOnly, Category = "City")
    bool bUnlocked = false;
};

USTRUCT(BlueprintType)
struct FTrackProgress
{
    GENERATED_BODY()
    
    UPROPERTY(BlueprintReadOnly, Category = "Track")
    FString TrackID;
    
    UPROPERTY(BlueprintReadOnly, Category = "Track")
    float BestTime = 0.0f;
    
    UPROPERTY(BlueprintReadOnly, Category = "Track")
    int32 StarsEarned = 0;
    
    UPROPERTY(BlueprintReadOnly, Category = "Track")
    bool bCompleted = false;
};
```
**Used By**: Progression System, Race Modes, UI/UX
**File**: `Source/PrototypeRacing/Public/Progression/VNTourProgress.h`

---

## 3. Customization Structures

### FCustomizationData
```cpp
USTRUCT(BlueprintType)
struct FCustomizationData
{
    GENERATED_BODY()
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Visual")
    FLinearColor PrimaryColor = FLinearColor::White;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Visual")
    FLinearColor SecondaryColor = FLinearColor::Black;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Visual")
    FString SpoilerID;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Visual")
    FString WheelID;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Visual")
    FString DecalID;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Performance")
    FString EngineUpgradeID;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Performance")
    FString SuspensionUpgradeID;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Performance")
    FString TireUpgradeID;
};
```
**Used By**: Car Customization, Multiplayer (visual sync)
**File**: `Source/PrototypeRacing/Public/Customization/CustomizationData.h`

---

### FCustomizationPart
```cpp
USTRUCT(BlueprintType)
struct FCustomizationPart
{
    GENERATED_BODY()
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Part")
    FString PartID;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Part")
    FString PartName;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Part")
    ECustomizationCategory Category;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Part")
    UStaticMesh* Mesh;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Part")
    int32 UnlockLevel = 1;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Part")
    int32 Price = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Part")
    FVehiclePhysicsModifier PhysicsModifier;
};

UENUM(BlueprintType)
enum class ECustomizationCategory : uint8
{
    Paint,
    Spoiler,
    Wheels,
    Decals,
    Engine,
    Suspension,
    Tires
};
```
**Used By**: Car Customization, Shop System
**File**: `Source/PrototypeRacing/Public/Customization/CustomizationPart.h`

---

## 4. Shop Structures

### FShopItem
```cpp
USTRUCT(BlueprintType)
struct FShopItem
{
    GENERATED_BODY()
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Shop")
    FString ItemID;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Shop")
    FString ItemName;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Shop")
    FString Description;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Shop")
    EShopItemType ItemType;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Shop")
    int32 Price;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Shop")
    ECurrency Currency;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Shop")
    UTexture2D* Icon;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Shop")
    bool bLimitedTime = false;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Shop")
    FDateTime ExpirationDate;
};

UENUM(BlueprintType)
enum class EShopItemType : uint8
{
    Vehicle,
    CustomizationPart,
    Currency,
    Consumable,
    Bundle
};

UENUM(BlueprintType)
enum class ECurrencyType : uint8
{
    Cash = 0,
    Coin = 1
};
```
**Used By**: Shop System, UI/UX, Profile System
**File**: `Source/VNTour/Public/Profile/ProfileManagerSubsystem.h`
**Note**: `Gems`, `SeasonalTokens`, `RealMoney` are planned but not yet implemented.
**Last synced with source code**: 2026-01-26

---

## 5. Multiplayer Structures

### FMatchmakingParams
```cpp
USTRUCT(BlueprintType)
struct FMatchmakingParams
{
    GENERATED_BODY()
    
    UPROPERTY(BlueprintReadWrite, Category = "Matchmaking")
    FString Mode = TEXT("time_trial");
    
    UPROPERTY(BlueprintReadWrite, Category = "Matchmaking")
    FString Region = TEXT("asia");
    
    UPROPERTY(BlueprintReadWrite, Category = "Matchmaking")
    int32 MinPlayers = 2;
    
    UPROPERTY(BlueprintReadWrite, Category = "Matchmaking")
    int32 MaxPlayers = 8;
    
    UPROPERTY(BlueprintReadWrite, Category = "Matchmaking")
    int32 SkillRating = 1000;
    
    UPROPERTY(BlueprintReadWrite, Category = "Matchmaking")
    int32 SkillRange = 200;
};
```
**Used By**: Multiplayer System
**File**: `Source/PrototypeRacing/Public/Multiplayer/MatchmakingParams.h`

---

### FServerInfo
```cpp
USTRUCT(BlueprintType)
struct FServerInfo
{
    GENERATED_BODY()
    
    UPROPERTY(BlueprintReadOnly, Category = "Server")
    FString ServerID;
    
    UPROPERTY(BlueprintReadOnly, Category = "Server")
    FString IP;
    
    UPROPERTY(BlueprintReadOnly, Category = "Server")
    int32 Port;
    
    UPROPERTY(BlueprintReadOnly, Category = "Server")
    FString Region;
    
    UPROPERTY(BlueprintReadOnly, Category = "Server")
    int32 CurrentPlayers;
    
    UPROPERTY(BlueprintReadOnly, Category = "Server")
    int32 MaxPlayers;
    
    UPROPERTY(BlueprintReadOnly, Category = "Server")
    float Latency;
};
```
**Used By**: Multiplayer System
**File**: `Source/PrototypeRacing/Public/Multiplayer/ServerInfo.h`

---

## 6. Settings Structures

### FGameSettings
```cpp
USTRUCT(BlueprintType)
struct FGameSettings
{
    GENERATED_BODY()
    
    // Graphics
    UPROPERTY(BlueprintReadWrite, Category = "Graphics")
    int32 QualityLevel = 2; // 0=Low, 1=Medium, 2=High, 3=Ultra
    
    UPROPERTY(BlueprintReadWrite, Category = "Graphics")
    int32 ResolutionScale = 100; // Percentage
    
    UPROPERTY(BlueprintReadWrite, Category = "Graphics")
    bool bVSync = false;
    
    UPROPERTY(BlueprintReadWrite, Category = "Graphics")
    int32 FrameRateLimit = 60;
    
    // Audio
    UPROPERTY(BlueprintReadWrite, Category = "Audio")
    float MasterVolume = 1.0f;
    
    UPROPERTY(BlueprintReadWrite, Category = "Audio")
    float MusicVolume = 0.7f;
    
    UPROPERTY(BlueprintReadWrite, Category = "Audio")
    float SFXVolume = 1.0f;
    
    // Controls
    UPROPERTY(BlueprintReadWrite, Category = "Controls")
    float SteeringSensitivity = 1.0f;
    
    UPROPERTY(BlueprintReadWrite, Category = "Controls")
    bool bTiltSteering = false;
    
    UPROPERTY(BlueprintReadWrite, Category = "Controls")
    bool bHapticFeedback = true;
    
    // Gameplay
    UPROPERTY(BlueprintReadWrite, Category = "Gameplay")
    FString Language = TEXT("en");
    
    UPROPERTY(BlueprintReadWrite, Category = "Gameplay")
    bool bShowHUD = true;
    
    UPROPERTY(BlueprintReadWrite, Category = "Gameplay")
    bool bShowMinimap = true;
    
    // Mobile
    UPROPERTY(BlueprintReadWrite, Category = "Mobile")
    bool bBatterySavingMode = false;
    
    UPROPERTY(BlueprintReadWrite, Category = "Mobile")
    bool bAdaptiveQuality = true;
};
```
**Used By**: Setting System, All Features
**File**: `Source/PrototypeRacing/Public/Settings/GameSettings.h`

---

## 7. Save Game Structures

### FSaveGameData
```cpp
USTRUCT(BlueprintType)
struct FSaveGameData
{
    GENERATED_BODY()
    
    UPROPERTY()
    FPlayerProgression Progression;
    
    UPROPERTY()
    TMap<FString, FCustomizationData> VehicleCustomizations;
    
    UPROPERTY()
    FGameSettings Settings;
    
    UPROPERTY()
    TMap<ECurrency, int32> Currency;
    
    UPROPERTY()
    FPlayerStatistics Statistics;
    
    UPROPERTY()
    TArray<FString> OwnedItems;
    
    UPROPERTY()
    FDateTime LastSaveTime;
    
    UPROPERTY()
    int32 SaveVersion = 1;
};
```
**Used By**: All Subsystems, Save/Load System
**File**: `Source/PrototypeRacing/Public/Save/SaveGameData.h`

---

## 8. Analytics Structures

### FAnalyticsEvent
```cpp
USTRUCT()
struct FAnalyticsEvent
{
    GENERATED_BODY()
    
    FString EventName;
    TMap<FString, FString> Parameters;
    FDateTime Timestamp;
    FString UserID;
};
```
**Used By**: Analytics Manager
**File**: `Source/PrototypeRacing/Public/Analytics/AnalyticsEvent.h`

---

## 9. Enumerations

### ERaceMode
```cpp
UENUM(BlueprintType)
enum class ERaceMode : uint8
{
    None = 0,
    Circuit = 1,
    Sprint = 2,
    TimeAttack = 3
};
```
**Used By**: Race Modes, Progression System, UI/UX
**File**: `Source/PrototypeRacing/Public/Progression/ProgressionData.h`
**Note**: Elimination, Drift, and VNTourCampaign are planned but not yet in enum.
**Last synced with source code**: 2026-01-26

### EGameState
```cpp
UENUM(BlueprintType)
enum class EGameState : uint8
{
    MainMenu,
    RaceSetup,
    Loading,
    Countdown,
    Racing,
    Paused,
    Results
};
```
**Used By**: Race Modes, UI/UX, Tutorial System

### EVehicleType
```cpp
UENUM(BlueprintType)
enum class EVehicleType : uint8
{
    Sedan,
    SUV,
    Sports,
    Supercar,
    Motorcycle
};
```
**Used By**: Car Physics, Car Customization, Profiles & Inventory

### EAchievementCategory
```cpp
UENUM(BlueprintType)
enum class EAchievementCategory : uint8
{
    None,
    VNTour,
    Racing,
    CarRating,
    FanService
};
```
**Used By**: Progression System, Achievements
**File**: `Source/VNTour/Public/Progression/ProgressionData.h`
**Last synced with source code**: 2026-01-26

### ECarRatingTier
```cpp
UENUM(BlueprintType)
enum class ECarRatingTier : uint8
{
    None,
    Bronze,
    Silver,
    Gold,
    Platinum,
    Master
};
```
**Used By**: Progression System, Car Rating
**File**: `Source/VNTour/Public/Progression/ProgressionData.h`
**Last synced with source code**: 2026-01-26

---

## 10. Profiles & Inventory Structures

### FPlayerProfile
```cpp
USTRUCT(BlueprintType)
struct FPlayerProfile
{
    GENERATED_BODY()
    
    UPROPERTY(BlueprintReadOnly, Category = "Profile")
    FString PlayerID;
    
    UPROPERTY(BlueprintReadWrite, Category = "Profile")
    FString DisplayName;
    
    UPROPERTY(BlueprintReadOnly, Category = "Profile")
    int32 AccountLevel;
    
    UPROPERTY(BlueprintReadOnly, Category = "Profile")
    FDateTime CreatedDate;
    
    UPROPERTY(BlueprintReadOnly, Category = "Profile")
    FDateTime LastLoginDate;
};
```
**Used By**: Profiles & Inventory, Multiplayer, UI/UX  
**File**: `Source/PrototypeRacing/Public/Profile/PlayerProfile.h`

### FInventoryItem
```cpp
USTRUCT(BlueprintType)
struct FInventoryItem
{
    GENERATED_BODY()
    
    UPROPERTY(BlueprintReadOnly, Category = "Inventory")
    FString ItemID;
    
    UPROPERTY(BlueprintReadOnly, Category = "Inventory")
    EItemType ItemType;
    
    UPROPERTY(BlueprintReadOnly, Category = "Inventory")
    int32 Quantity;
    
    UPROPERTY(BlueprintReadOnly, Category = "Inventory")
    FDateTime AcquiredDate;
    
    UPROPERTY(BlueprintReadOnly, Category = "Inventory")
    bool bIsEquipped;
};

UENUM(BlueprintType)
enum class EItemType : uint8
{
    Vehicle,
    CustomizationPart,
    Consumable,
    Currency
};
```
**Used By**: Profiles & Inventory, Shop System, Car Customization  
**File**: `Source/PrototypeRacing/Public/Inventory/InventoryItem.h`

---

## 11. Racer AI Structures

### FAIRacerConfig
```cpp
USTRUCT(BlueprintType)
struct FAIRacerConfig
{
    GENERATED_BODY()
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "AI")
    FString AIName;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "AI")
    EAIDifficulty Difficulty;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "AI")
    float SkillLevel = 0.5f; // 0.0 - 1.0
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "AI")
    float Aggression = 0.5f;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "AI")
    FVehiclePhysicsConfig VehicleConfig;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "AI")
    FCustomizationData Customization;
};

UENUM(BlueprintType)
enum class EAIDifficulty : uint8
{
    Easy,
    Medium,
    Hard,
    Expert
};
```
**Used By**: Racer AI, Race Modes, Progression System  
**File**: `Source/PrototypeRacing/Public/AI/AIRacerConfig.h`

### FAIBehaviorState
```cpp
USTRUCT(BlueprintType)
struct FAIBehaviorState
{
    GENERATED_BODY()
    
    UPROPERTY(BlueprintReadOnly, Category = "AI")
    EAIState CurrentState;
    
    UPROPERTY(BlueprintReadOnly, Category = "AI")
    int32 CurrentCheckpoint;
    
    UPROPERTY(BlueprintReadOnly, Category = "AI")
    float DistanceToNextCheckpoint;
    
    UPROPERTY(BlueprintReadOnly, Category = "AI")
    bool bIsOvertaking;
    
    UPROPERTY(BlueprintReadOnly, Category = "AI")
    AActor* TargetVehicle;
};

UENUM(BlueprintType)
enum class EAIState : uint8
{
    Racing,
    Overtaking,
    Defending,
    Recovering
};
```
**Used By**: Racer AI  
**File**: `Source/PrototypeRacing/Public/AI/AIBehaviorState.h`

---

## 12. Tutorial Structures

### FTutorialStep
```cpp
USTRUCT(BlueprintType)
struct FTutorialStep
{
    GENERATED_BODY()
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Tutorial")
    FString StepID;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Tutorial")
    FText Title;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Tutorial")
    FText Description;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Tutorial")
    ETutorialAction RequiredAction;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Tutorial")
    UTexture2D* Icon;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Tutorial")
    bool bSkippable;
};

UENUM(BlueprintType)
enum class ETutorialAction : uint8
{
    Accelerate,
    Brake,
    Steer,
    Drift,
    UseNitro,
    CompleteCheckpoint,
    FinishRace
};
```
**Used By**: Tutorial System, UI/UX, Progression System  
**File**: `Source/PrototypeRacing/Public/Tutorial/TutorialStep.h`

### FTutorialProgress
```cpp
USTRUCT(BlueprintType)
struct FTutorialProgress
{
    GENERATED_BODY()
    
    UPROPERTY(BlueprintReadOnly, Category = "Tutorial")
    TArray<FString> CompletedSteps;
    
    UPROPERTY(BlueprintReadOnly, Category = "Tutorial")
    FString CurrentStepID;
    
    UPROPERTY(BlueprintReadOnly, Category = "Tutorial")
    bool bTutorialCompleted;
    
    UPROPERTY(BlueprintReadOnly, Category = "Tutorial")
    bool bTutorialSkipped;
};
```
**Used By**: Tutorial System, Progression System  
**File**: `Source/PrototypeRacing/Public/Tutorial/TutorialProgress.h`

---

## 13. Minimap Structures

### FMinimapConfig
```cpp
USTRUCT(BlueprintType)
struct FMinimapConfig
{
    GENERATED_BODY()
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Minimap")
    float ZoomLevel = 1.0f;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Minimap")
    float RotationSpeed = 5.0f;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Minimap")
    bool bRotateWithPlayer = true;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Minimap")
    FVector2D Size = FVector2D(200.0f, 200.0f);
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Minimap")
    float UpdateFrequency = 0.1f; // Seconds
};
```
**Used By**: Minimap System, Setting System, UI/UX  
**File**: `Source/PrototypeRacing/Public/Minimap/MinimapConfig.h`

### FMinimapMarker
```cpp
USTRUCT(BlueprintType)
struct FMinimapMarker
{
    GENERATED_BODY()
    
    UPROPERTY(BlueprintReadWrite, Category = "Minimap")
    FVector WorldLocation;
    
    UPROPERTY(BlueprintReadWrite, Category = "Minimap")
    EMarkerType MarkerType;
    
    UPROPERTY(BlueprintReadWrite, Category = "Minimap")
    FLinearColor Color;
    
    UPROPERTY(BlueprintReadWrite, Category = "Minimap")
    UTexture2D* Icon;
    
    UPROPERTY(BlueprintReadWrite, Category = "Minimap")
    bool bVisible;
};

UENUM(BlueprintType)
enum class EMarkerType : uint8
{
    Player,
    Opponent,
    Checkpoint,
    Objective,
    Hazard
};
```
**Used By**: Minimap System, Race Modes, Multiplayer  
**File**: `Source/PrototypeRacing/Public/Minimap/MinimapMarker.h`

---

## 9. Enumerations (Updated)

### ERaceMode
```cpp
UENUM(BlueprintType)
enum class ERaceMode : uint8
{
    None = 0,
    Circuit = 1,
    Sprint = 2,
    TimeAttack = 3
};
```
**File**: `Source/PrototypeRacing/Public/Progression/ProgressionData.h`
**Note**: Elimination, Drift, and VNTourCampaign are planned but not yet in enum.
**Last synced with source code**: 2026-01-26

### EGameState
```cpp
UENUM(BlueprintType)
enum class EGameState : uint8
{
    MainMenu,
    RaceSetup,
    Loading,
    Countdown,
    Racing,
    Paused,
    Results
};
```

### EVehicleType
```cpp
UENUM(BlueprintType)
enum class EVehicleType : uint8
{
    Sedan,
    SUV,
    Sports,
    Supercar,
    Motorcycle
};
```

### EAchievementCategory
```cpp
UENUM(BlueprintType)
enum class EAchievementCategory : uint8
{
    None,
    VNTour,
    Racing,
    CarRating,
    FanService
};
```
**File**: `Source/VNTour/Public/Progression/ProgressionData.h`
**Last synced with source code**: 2026-01-26

### ECarRatingTier
```cpp
UENUM(BlueprintType)
enum class ECarRatingTier : uint8
{
    None,
    Bronze,
    Silver,
    Gold,
    Platinum,
    Master
};
```
**File**: `Source/VNTour/Public/Progression/ProgressionData.h`
**Last synced with source code**: 2026-01-26

---

## Data Structure Best Practices

### 1. Use USTRUCT for Data
- All data containers should be USTRUCT
- Mark with BlueprintType for Blueprint access
- Use UPROPERTY for serialization

### 2. Use UENUM for Categories
- Define enums for fixed categories
- Use BlueprintType for Blueprint access
- Prefer enum class over plain enum

### 3. Serialization
- All save game data must be UPROPERTY
- Use SaveGame specifier for save game classes
- Version your save data structures

### 4. Replication
- Mark replicated properties with Replicated
- Use RepNotify for client updates
- Minimize replicated data size

### 5. Documentation
- Document all public structures
- Explain units (km/h, kg, seconds)
- Provide usage examples

---

## Conclusion

This data structure index provides a comprehensive reference for all major data types in PrototypeRacing. Refer to this document when:
- Implementing new features
- Debugging data issues
- Planning data migrations
- Reviewing code
- Onboarding new developers

