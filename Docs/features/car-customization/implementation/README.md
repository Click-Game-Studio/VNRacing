---
phase: implementation
title: Car Customization Implementation Guide
description: Step-by-step implementation guide for car customization system
feature_id: car-customization
status: development
last_updated: 2026-01-20
---

# Car Customization Implementation Guide

**Breadcrumbs:** [Docs](../../../../) > [Features](../../../) > [Car Customization](../) > Implementation

**Feature ID**: `car-customization`
**Status**: 🔄 Development
**Version**: 1.1.0
**Date**: 2026-01-26

---

## Overview

Hướng dẫn triển khai chi tiết hệ thống Car Customization, bao gồm code examples, best practices, và integration patterns.

---

## Implementation Steps

### Step 1: Create Core Data Structures

#### 1.1 Enumerations (CarCustomizationTypes.h)

```cpp
#pragma once

#include "CoreMinimal.h"
#include "CarCustomizationTypes.generated.h"

UENUM(BlueprintType)
enum class ECarPartSlot : uint8
{
    FrontBumper     UMETA(DisplayName = "Front Bumper"),
    RearBumper      UMETA(DisplayName = "Rear Bumper"),
    SideBoard       UMETA(DisplayName = "Side Board"),
    Spoiler         UMETA(DisplayName = "Spoiler"),
    Exhaust         UMETA(DisplayName = "Exhaust"),
    Wheels          UMETA(DisplayName = "Wheels")
};

UENUM(BlueprintType)
enum class ECarColorSlot : uint8
{
    Body            UMETA(DisplayName = "Body Color"),
    Wheels          UMETA(DisplayName = "Wheel Color"),
    Calipers        UMETA(DisplayName = "Caliper Color")
};

UENUM(BlueprintType)
enum class ECarPaintMaterialType : uint8
{
    Solid           UMETA(DisplayName = "Solid"),
    Matte           UMETA(DisplayName = "Matte"),
    Metallic        UMETA(DisplayName = "Metallic"),
    Foil            UMETA(DisplayName = "Foil"),
    CarbonFiber     UMETA(DisplayName = "Carbon Fiber")
};
```

#### 1.2 Core Structures (CarCustomizationStructs.h)

```cpp
#pragma once

#include "CoreMinimal.h"
#include "Engine/DataTable.h"
#include "CarCustomizationTypes.h"
#include "CarCustomizationStructs.generated.h"

USTRUCT(BlueprintType)
struct FPerformanceStats
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Performance")
    float Acceleration = 100.0f;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Performance")
    float Grip = 100.0f;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Performance")
    float Speed = 100.0f;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Performance")
    float Nitrous = 100.0f;

    FPerformanceStats operator+(const FPerformanceStats& Other) const
    {
        FPerformanceStats Result;
        Result.Acceleration = Acceleration + Other.Acceleration;
        Result.Grip = Grip + Other.Grip;
        Result.Speed = Speed + Other.Speed;
        Result.Nitrous = Nitrous + Other.Nitrous;
        return Result;
    }
};

USTRUCT(BlueprintType)
struct FPerformanceModifiers
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Modifiers")
    float AccelerationModifier = 0.0f;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Modifiers")
    float GripModifier = 0.0f;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Modifiers")
    float SpeedModifier = 0.0f;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Modifiers")
    float NitrousModifier = 0.0f;
};

USTRUCT(BlueprintType)
struct FColorInstanceInfo
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Color")
    FName ColorID;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Color")
    FLinearColor DirectColorValue = FLinearColor::White;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Color")
    ECarPaintMaterialType MaterialType = ECarPaintMaterialType::Solid;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Color")
    bool bUseDirectColor = false;
};

USTRUCT(BlueprintType)
struct FCarConfiguration
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Configuration")
    FName BaseCarID;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Configuration")
    FName AppliedStyleID;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Configuration")
    TMap<ECarPartSlot, FName> CustomParts;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Configuration")
    TMap<ECarColorSlot, FColorInstanceInfo> CustomColors;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Configuration")
    FName AppliedDecalID;
};
```

---

### Step 2: Create Data Table Definitions

#### 2.1 Part Definition (CarPartDefinition.h)

```cpp
USTRUCT(BlueprintType)
struct FCarPartDefinition : public FTableRowBase
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Part")
    FName PartID;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Part")
    FText DisplayName;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Part")
    TArray<ECarPartSlot> CompatibleSlots;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Part")
    TSoftObjectPtr<UStaticMesh> AssetReference;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Part")
    FPerformanceModifiers PerformanceModifiers;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Part")
    int32 Cost = 0;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Part")
    TArray<FName> Prerequisites;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Vietnamese")
    bool bIsVietnameseThemed = false;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Vietnamese")
    FString UnlockCity;
};
```

---

### Step 3: Implement Customization Subsystem

#### 3.1 Header (CarCustomizationSubsystem.h)

```cpp
#pragma once

#include "CoreMinimal.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "CarCustomizationStructs.h"
#include "CarCustomizationSubsystem.generated.h"

DECLARE_DYNAMIC_MULTICAST_DELEGATE_TwoParams(FOnConfigurationChanged, const FString&, VehicleID, const FCarConfiguration&, NewConfig);

UCLASS()
class PROTOTYPERACING_API UCarCustomizationSubsystem : public UGameInstanceSubsystem
{
    GENERATED_BODY()

public:
    virtual void Initialize(FSubsystemCollectionBase& Collection) override;
    virtual void Deinitialize() override;

    // Part Management
    UFUNCTION(BlueprintCallable, Category = "Customization")
    bool SetPart(const FString& VehicleID, ECarPartSlot Slot, FName PartID);

    UFUNCTION(BlueprintPure, Category = "Customization")
    FName GetCurrentPart(const FString& VehicleID, ECarPartSlot Slot) const;

    // Color Management
    UFUNCTION(BlueprintCallable, Category = "Customization")
    bool SetColor(const FString& VehicleID, ECarColorSlot Slot, const FColorInstanceInfo& ColorInfo);

    // Style Management
    UFUNCTION(BlueprintCallable, Category = "Customization")
    bool ApplyStyle(const FString& VehicleID, FName StyleID);

    // Performance
    UFUNCTION(BlueprintPure, Category = "Customization")
    FPerformanceStats GetCalculatedPerformance(const FString& VehicleID) const;

    // Configuration
    UFUNCTION(BlueprintPure, Category = "Customization")
    FCarConfiguration GetConfiguration(const FString& VehicleID) const;

    // Unlock Status
    UFUNCTION(BlueprintPure, Category = "Customization")
    bool IsPartUnlocked(FName PartID) const;

    UFUNCTION(BlueprintCallable, Category = "Customization")
    void UnlockPart(FName PartID);

    // Events
    UPROPERTY(BlueprintAssignable, Category = "Customization")
    FOnConfigurationChanged OnConfigurationChanged;

private:
    UPROPERTY()
    TMap<FString, FCarConfiguration> ActiveConfigurations;

    UPROPERTY()
    TSet<FName> UnlockedParts;

    UPROPERTY()
    UDataTable* PartsDataTable;

    UPROPERTY()
    UDataTable* ColorsDataTable;

    UPROPERTY()
    UDataTable* StylesDataTable;

    UPROPERTY()
    UDataTable* BaseCarsDataTable;

    FPerformanceStats CalculatePerformance(const FCarConfiguration& Config) const;
    void LoadDataTables();
    void SaveToSaveGame();
    void LoadFromSaveGame();
};
```

#### 3.2 Implementation (CarCustomizationSubsystem.cpp)

```cpp
#include "CarCustomizationSubsystem.h"
#include "Engine/DataTable.h"
#include "Kismet/GameplayStatics.h"

void UCarCustomizationSubsystem::Initialize(FSubsystemCollectionBase& Collection)
{
    Super::Initialize(Collection);
    LoadDataTables();
    LoadFromSaveGame();
}

void UCarCustomizationSubsystem::Deinitialize()
{
    SaveToSaveGame();
    Super::Deinitialize();
}

bool UCarCustomizationSubsystem::SetPart(const FString& VehicleID, ECarPartSlot Slot, FName PartID)
{
    if (!IsPartUnlocked(PartID))
    {
        return false;
    }

    FCarConfiguration& Config = ActiveConfigurations.FindOrAdd(VehicleID);
    Config.CustomParts.Add(Slot, PartID);
    
    OnConfigurationChanged.Broadcast(VehicleID, Config);
    return true;
}

FName UCarCustomizationSubsystem::GetCurrentPart(const FString& VehicleID, ECarPartSlot Slot) const
{
    if (const FCarConfiguration* Config = ActiveConfigurations.Find(VehicleID))
    {
        if (const FName* PartID = Config->CustomParts.Find(Slot))
        {
            return *PartID;
        }
    }
    return NAME_None;
}

bool UCarCustomizationSubsystem::SetColor(const FString& VehicleID, ECarColorSlot Slot, const FColorInstanceInfo& ColorInfo)
{
    FCarConfiguration& Config = ActiveConfigurations.FindOrAdd(VehicleID);
    Config.CustomColors.Add(Slot, ColorInfo);
    
    OnConfigurationChanged.Broadcast(VehicleID, Config);
    return true;
}

FPerformanceStats UCarCustomizationSubsystem::GetCalculatedPerformance(const FString& VehicleID) const
{
    if (const FCarConfiguration* Config = ActiveConfigurations.Find(VehicleID))
    {
        return CalculatePerformance(*Config);
    }
    return FPerformanceStats();
}

FPerformanceStats UCarCustomizationSubsystem::CalculatePerformance(const FCarConfiguration& Config) const
{
    FPerformanceStats Result;
    
    // Get base stats from DT_BaseCars
    // ... implementation
    
    // Add modifiers from each part
    for (const auto& PartPair : Config.CustomParts)
    {
        if (PartsDataTable)
        {
            if (FCarPartDefinition* PartDef = PartsDataTable->FindRow<FCarPartDefinition>(PartPair.Value, TEXT("")))
            {
                Result.Acceleration += PartDef->PerformanceModifiers.AccelerationModifier;
                Result.Grip += PartDef->PerformanceModifiers.GripModifier;
                Result.Speed += PartDef->PerformanceModifiers.SpeedModifier;
                Result.Nitrous += PartDef->PerformanceModifiers.NitrousModifier;
            }
        }
    }
    
    return Result;
}

bool UCarCustomizationSubsystem::IsPartUnlocked(FName PartID) const
{
    return UnlockedParts.Contains(PartID);
}

void UCarCustomizationSubsystem::UnlockPart(FName PartID)
{
    UnlockedParts.Add(PartID);
}
```

---

### Step 4: Asset Loading System

#### 4.1 Async Asset Loading

```cpp
void UCarPreviewWidget::LoadPartAsync(ECarPartSlot Slot, FName PartID)
{
    if (!PartsDataTable) return;
    
    FCarPartDefinition* PartDef = PartsDataTable->FindRow<FCarPartDefinition>(PartID, TEXT(""));
    if (!PartDef) return;
    
    // Use StreamableManager for async loading
    FStreamableManager& StreamableManager = UAssetManager::GetStreamableManager();
    
    StreamableManager.RequestAsyncLoad(
        PartDef->AssetReference.ToSoftObjectPath(),
        FStreamableDelegate::CreateUObject(this, &UCarPreviewWidget::OnPartLoaded, Slot, PartID)
    );
}

void UCarPreviewWidget::OnPartLoaded(ECarPartSlot Slot, FName PartID)
{
    FCarPartDefinition* PartDef = PartsDataTable->FindRow<FCarPartDefinition>(PartID, TEXT(""));
    if (!PartDef) return;
    
    UStaticMesh* LoadedMesh = PartDef->AssetReference.Get();
    if (LoadedMesh)
    {
        ApplyPartMesh(Slot, LoadedMesh);
    }
}
```

---

### Step 5: Material System

#### 5.1 Dynamic Material Instance

```cpp
void UCarPreviewWidget::ApplyColor(ECarColorSlot Slot, const FColorInstanceInfo& ColorInfo)
{
    UMaterialInstanceDynamic* DMI = GetOrCreateDMI(Slot);
    if (!DMI) return;
    
    FLinearColor Color = ColorInfo.bUseDirectColor 
        ? ColorInfo.DirectColorValue 
        : GetColorFromDataTable(ColorInfo.ColorID);
    
    DMI->SetVectorParameterValue(TEXT("BaseColor"), Color);
    
    // Set material type parameters
    switch (ColorInfo.MaterialType)
    {
        case ECarPaintMaterialType::Metallic:
            DMI->SetScalarParameterValue(TEXT("Metallic"), 1.0f);
            DMI->SetScalarParameterValue(TEXT("Roughness"), 0.3f);
            break;
        case ECarPaintMaterialType::Matte:
            DMI->SetScalarParameterValue(TEXT("Metallic"), 0.0f);
            DMI->SetScalarParameterValue(TEXT("Roughness"), 0.8f);
            break;
        // ... other types
    }
}
```

---

## Best Practices

### Mobile Optimization
1. Always use `TSoftObjectPtr` for asset references
2. Implement async loading for all assets
3. Use compressed textures
4. Limit simultaneous material instances

### Memory Management
1. Unload unused assets when switching vehicles
2. Pool material instances when possible
3. Use LODs for preview models

### Error Handling
1. Validate all Data Table lookups
2. Handle missing assets gracefully
3. Provide fallback defaults

---

## Testing Checklist

- [ ] All part slots functional
- [ ] All color slots functional
- [ ] Style packages apply correctly
- [ ] Performance calculation accurate
- [ ] Save/Load works
- [ ] Async loading works without frame drops
- [ ] Memory usage within limits

---

## References

- [Requirements](../requirements/README.md)
- [Design](../design/README.md)
- [Planning](../planning/README.md)
- [Testing](../testing/README.md)
