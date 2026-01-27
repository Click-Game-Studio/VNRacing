# Naming Conventions - VNRacing

**Project**: VNRacing - Mobile Racing Game  
**Document**: Naming Conventions Standard  
**Version**: 1.1.0
**Date**: 2026-01-26
**Status**: Official Standard - Aligned with Epic C++ Coding Standard

---

## Table of Contents

- [Overview](#overview)
- [Unreal Engine Asset Naming](#unreal-engine-asset-naming)
  - [Blueprint Classes](#blueprint-classes)
  - [Enumerations and Structures](#enumerations-and-structures)
  - [Materials and Textures](#materials-and-textures)
  - [Meshes](#meshes)
  - [Animations](#animations)
  - [Physics and Collision](#physics-and-collision)
  - [Particles and VFX](#particles-and-vfx)
  - [UI/UMG](#uiumg)
  - [Audio](#audio)
  - [Data Assets](#data-assets)
  - [Maps/Levels](#mapslevels)
  - [Enhanced Input System - UE5](#enhanced-input-system---ue5)
  - [Gameplay Ability System - Lyra Conventions](#gameplay-ability-system---lyra-conventions)
  - [Miscellaneous Assets](#miscellaneous-assets)
- [C++ Naming Conventions](#c-naming-conventions)
  - [Classes](#classes)
  - [Variables](#variables)
  - [Functions](#functions)
  - [Constants](#constants)
  - [Template Classes](#template-classes)
- [File and Folder Naming](#file-and-folder-naming)
- [Documentation Naming](#documentation-naming)
- [Vietnamese Cultural Elements](#vietnamese-cultural-elements)
- [Best Practices](#best-practices)
- [Compliance Checklist](#compliance-checklist)
- [Migration Notes (UE4 to UE5)](#migration-notes-ue4-to-ue5)
- [Conclusion](#conclusion)

---

## Overview

This document establishes standardized naming conventions for all assets, code, and documentation in the VNRacing project to ensure consistency, clarity, and maintainability across the entire codebase. Version 1.2 has been **fully standardized according to Epic Games C++ Coding Standard**.

---

## Unreal Engine Asset Naming

### Blueprint Classes

| Prefix | Asset Type | Example |
|--------|------------|---------|
| `BP_` | Blueprint Class | `BP_PlayerVehicle` |
| `BPI_` | Blueprint Interface | `BPI_Damageable` |
| `BPF_` | Blueprint Function Library | `BPF_MathHelpers` |
| `BPFL_` | Blueprint Function Library | `BPFL_GameplayUtilities` |
| `BPM_` | Blueprint Macro Library | `BPM_CommonMacros` |

### Enumerations and Structures

| Prefix | Asset Type | Example |
|--------|------------|---------|
| `E_` | Enumeration | `E_VehicleType` |
| `ES_` | Enum Struct | `ES_RaceMode` |
| `S_` | Structure | `S_VehicleStats` |
| `F_` | C++ Struct | `FVehicleConfiguration` |

### Materials and Textures

| Prefix | Asset Type | Example |
|--------|------------|---------|
| `M_` | Material | `M_VehicleBody` |
| `MI_` | Material Instance | `MI_VehicleBody_Red` |
| `MF_` | Material Function | `MF_Weathering` |
| `MPC_` | Material Parameter Collection | `MPC_GlobalParameters` |
| `T_` | Texture (Base) | `T_VehicleBody_D` |
| `T_[Name]_D` | Diffuse/Albedo Texture | `T_VehicleBody_D` |
| `T_[Name]_N` | Normal Map | `T_VehicleBody_N` |
| `T_[Name]_R` | Roughness Map | `T_VehicleBody_R` |
| `T_[Name]_M` | Metallic Map | `T_VehicleBody_M` |
| `T_[Name]_AO` | Ambient Occlusion | `T_VehicleBody_AO` |
| `T_[Name]_E` | Emissive Map | `T_VehicleBody_E` |
| `T_[Name]_H` | Height Map | `T_VehicleBody_H` |

### Meshes

| Prefix | Asset Type | Example |
|--------|------------|---------|
| `SM_` | Static Mesh | `SM_VehicleChassis` |
| `SK_` | Skeletal Mesh | `SK_Character` |
| `SKM_` | Skeletal Mesh (Alternative) | `SKM_PlayerCharacter` |

### Animations

| Prefix | Asset Type | Example |
|--------|------------|---------|
| `A_` | Animation Sequence | `A_VehicleDrift` |
| `AM_` | Animation Montage | `AM_VehicleCrash` |
| `ABP_` | Animation Blueprint | `ABP_Vehicle` |
| `ABS_` | Animation Blend Space | `ABS_VehicleMovement` |
| `AO_` | Aim Offset | `AO_VehicleSteering` |

### Physics and Collision

| Prefix | Asset Type | Example |
|--------|------------|---------|
| `PHYS_` | Physics Asset | `PHYS_Vehicle` |
| `PM_` | Physical Material | `PM_Asphalt` |

### Particles and VFX

| Prefix | Asset Type | Example |
|--------|------------|---------|
| `NS_` | Niagara System | `NS_ExhaustSmoke` |
| `NE_` | Niagara Emitter | `NE_SparkParticles` |
| `P_` | Particle System (Cascade) | `P_Explosion` |

### UI/UMG

| Prefix | Asset Type | Example |
|--------|------------|---------|
| `WBP_` | Widget Blueprint | `WBP_MainMenu` |
| `W_` | Widget (Alternative) | `W_HUD` |

### Audio

| Prefix | Asset Type | Example |
|--------|------------|---------|
| `A_` | Audio File | `A_EngineRev` |
| `SC_` | Sound Cue | `SC_EngineLoop` |
| `SW_` | Sound Wave | `SW_TireSqueal` |
| `SM_` | Sound Mix | `SM_GameplayMix` |
| `SC_` | Sound Class | `SC_SFX` |

### Data Assets

| Prefix | Asset Type | Example |
|--------|------------|---------|
| `DA_` | Data Asset | `DA_VehicleConfig` |
| `DT_` | Data Table | `DT_VehicleStats` |
| `CurveTable_` | Curve Table | `CurveTable_PerformanceCurves` |
| `Curve_` | Curve Float | `Curve_AccelerationCurve` |

### Maps/Levels

| Prefix | Asset Type | Example |
|--------|------------|---------|
| `L_` | Level/Map | `L_Hanoi_Downtown` |
| `HLOD_` | Hierarchical LOD | `HLOD_CityBlock` |

### Enhanced Input System - UE5

**Naming conventions for Enhanced Input System** - new standard from UE 5.1:

| Prefix | Asset Type | Example | Notes |
|--------|------------|---------|-------|
| `IA_` | Input Action | `IA_Move`, `IA_Jump`, `IA_Fire` | Core input actions |
| `IMC_` | Input Mapping Context | `IMC_Default`, `IMC_Vehicle`, `IMC_Menu` | Context-based mappings |
| `PMI_` | Player Mappable Input Config | `PMI_Keyboard`, `PMI_Gamepad`, `PMI_VR` | Per-device configs |
| `IM_` | Input Modifier | `IM_DeadZone`, `IM_Smooth`, `IM_Negate` | Pre-processors |
| `IT_` | Input Trigger | `IT_Hold`, `IT_Tap`, `IT_Pressed` | Trigger conditions |

**Enhanced Input Naming Examples**:
```
Input/
├── Actions/
│   ├── IA_Move
│   ├── IA_Look_Mouse
│   ├── IA_Look_Gamepad
│   ├── IA_Jump
│   ├── IA_Sprint
│   └── IA_Interact
├── MappingContexts/
│   ├── IMC_KBM_Default
│   ├── IMC_Controller_Default
│   ├── IMC_Vehicle_Driving
│   └── IMC_Menu
├── PlayerMappableConfigs/
│   ├── PMI_KeyboardMouse
│   ├── PMI_Gamepad
│   └── PMI_VR
└── CustomModifiers/
    ├── IM_CustomDeadZone
    └── IM_AccelerationCurve
```

### Gameplay Ability System - Lyra Conventions

If project uses **Gameplay Ability System** (GAS), apply naming conventions from Lyra Starter Game:

| Prefix | Asset Type | Example | Notes |
|--------|------------|---------|-------|
| `GA_` | Gameplay Ability | `GA_Jump`, `GA_Sprint`, `GA_MeleeAttack` | Ability classes |
| `GE_` | Gameplay Effect | `GE_Damage`, `GE_Heal`, `GE_SpeedBoost` | Effects/buffs |
| `GCN_` | Gameplay Cue Notify | `GCN_Impact`, `GCN_Explosion` | Visual/audio cues |
| `GCNL_` | Latent Gameplay Cue Notify | `GCNL_Projectile`, `GCNL_Trail` | Actor-based cues |
| `Phase_` | Game Phase Ability | `Phase_MainMenu`, `Phase_Gameplay` | Phase managers |
| `AbilitySet_` | Ability Set | `AbilitySet_Hero`, `AbilitySet_Enemy` | Ability collections |
| `InputData_` | Input Config | `InputData_Hero`, `InputData_Vehicle` | Lyra input configs |

### Miscellaneous Assets

| Prefix | Asset Type | Example |
|--------|------------|---------|
| `FX_` | Visual Effect | `FX_NitroBoost` |
| `PP_` | Post Process | `PP_RaceMode` |
| `LUT_` | Lookup Table | `LUT_ColorGrading` |
| `RT_` | Render Target | `RT_Minimap` |
| `MID_` | Material Instance Dynamic | `MID_VehicleBody_Runtime` |

---

## C++ Naming Conventions

### Classes

**Epic Standard Class Prefixes**:

```cpp
// A - Actor derived classes
class APlayerVehicle : public APawn { };
class ARaceGameMode : public AGameMode { };

// U - UObject derived classes (including Components)
class UCarCustomizationSubsystem : public UGameInstanceSubsystem { };
class UVehicleMovementComponent : public UActorComponent { };

// F - Structs (Plain Old Data)
struct FVehicleStats
{
    float MaxSpeed;
    float Acceleration;
};

// E - Enumerations
enum class EVehicleType : uint8
{
    Sedan,
    SUV,
    SportsCar
};

// I - Interfaces
class IVehicleInterface
{
public:
    virtual void StartEngine() = 0;
    virtual void StopEngine() = 0;
};

// S - Slate Widgets (Epic UI Framework)
class SMyCustomWidget : public SCompoundWidget
{
    // Slate widget implementation
};

// T - Template Classes (Epic Standard)
template<typename T>
class TMyContainer
{
    TArray<T> Items;
};

// Examples from Engine:
// TArray<T>, TMap<K,V>, TSet<T>, TObjectPtr<T>
```

**⚠️ Important**: Each class prefix has clear meaning about inheritance hierarchy.

### Variables

**Epic Guidelines - Project Adaptation**:

```cpp
class AMyVehicle : public APawn
{
public:
    // Public member variables: PascalCase
    float MaxSpeed;
    int32 CurrentGear;

    // Booleans: MUST have 'b' prefix (MANDATORY)
    bool bIsEngineRunning;
    bool bCanDrift;
    bool bHasNitro;

protected:
    // Protected variables: PascalCase (consistent with public)
    float EngineTemperature;

private:
    // Private variables: camelCase (Project Standard)
    // Note: Epic doesn't mandate strict style, but project chooses camelCase
    float currentSpeed;
    int32 engineRPM;
    float fuelLevel;

    // Pointers: Descriptive names (no Hungarian notation)
    UPROPERTY()
    TObjectPtr<UVehicleMovementComponent> MovementComponent;

    UPROPERTY()
    TObjectPtr<APlayerController> OwningController;
};
```

**⚠️ Project Decision**:
- **Public/Protected**: PascalCase
- **Private**: camelCase
- **Booleans**: ALWAYS use `b` prefix regardless of visibility
- Reason: Balance between Epic style and readability

### Functions

**Epic Standard**:

```cpp
// PascalCase for ALL functions
void CalculateSpeed();
void ApplyDamage(float DamageAmount);
float GetCurrentSpeed() const;

// Getters/Setters pattern
float GetMaxSpeed() const;
void SetMaxSpeed(float NewMaxSpeed);

int32 GetCurrentGear() const;
void SetCurrentGear(int32 NewGear);

// Boolean getters: Use 'Is', 'Has', 'Can', 'Should'
bool IsEngineRunning() const;
bool HasNitro() const;
bool CanDrift() const;
bool ShouldRespawn() const;

// Event handlers: Use 'On' prefix
void OnVehicleDamaged(float Damage);
void OnNitroActivated();

// Callback functions: Use 'Handle' or 'On'
void HandleTimerExpired();
void OnComponentHit(/* parameters */);
```

### Constants

**Epic Recommendation**: Choose one style and be consistent.

**Option 1: k prefix with constexpr (RECOMMENDED)**
```cpp
// ✅ PROJECT STANDARD: Use this style
constexpr float kMaxSpeed = 300.0f;
constexpr int32 kMaxGears = 6;
constexpr float kGravity = 9.81f;
constexpr int32 kMaxPlayers = 8;
```

**Option 2: UPPER_CASE with static const (Alternative)**
```cpp
// ⚠️ Alternative (not used in this project)
static const float MAX_SPEED = 300.0f;
static const int32 MAX_GEARS = 6;
```

**⚠️ PROJECT DECISION**: Use **Option 1** (k prefix + constexpr) for all constants to:
- Be consistent with modern C++ practices
- Be clear about scope and lifetime
- Align with Epic's newer code

### Template Classes

**Epic Standard T Prefix**:

```cpp
// Template classes use T prefix
template<typename T>
class TObjectPtr
{
    T* Ptr;
};

template<typename KeyType, typename ValueType>
class TMap
{
    // Implementation
};

// Custom template examples
template<typename T>
class TCircularBuffer
{
    TArray<T> Buffer;
    int32 Head;
    int32 Tail;
};

template<typename ItemType>
class TInventoryContainer
{
    TArray<ItemType> Items;
    int32 MaxCapacity;
};
```

**Engine Template Types to Know**:
- `TArray<T>` - Dynamic array
- `TMap<K, V>` - Key-value map
- `TSet<T>` - Unique set
- `TObjectPtr<T>` - UE5 object pointer
- `TSubclassOf<T>` - Class type reference
- `TSoftObjectPtr<T>` - Soft reference
- `TSharedPtr<T>` - Shared pointer
- `TWeakPtr<T>` - Weak pointer
- `TUniquePtr<T>` - Unique pointer

---

## File and Folder Naming

### Content Folder Structure

```
Content/
├── Blueprints/
│   ├── Vehicles/
│   │   ├── BP_PlayerVehicle
│   │   └── BP_AIVehicle
│   ├── GameModes/
│   │   ├── BP_RaceGameMode
│   │   └── BP_TimeTrialGameMode
│   └── UI/
│       ├── WBP_MainMenu
│       └── WBP_HUD
├── Materials/
│   ├── Vehicles/
│   │   ├── M_VehicleBody
│   │   └── MI_VehicleBody_Red
│   └── Environment/
│       ├── M_Road_Asphalt
│       └── M_Building_Concrete
├── Meshes/
│   ├── Vehicles/
│   │   ├── SM_VehicleChassis
│   │   └── SM_VehicleWheel
│   └── Environment/
│       ├── SM_Building_01
│       └── SM_Road_Straight
├── Textures/
│   ├── Vehicles/
│   │   ├── T_VehicleBody_D
│   │   ├── T_VehicleBody_N
│   │   └── T_VehicleBody_R
│   └── Environment/
│       ├── T_Road_Asphalt_D
│       └── T_Road_Asphalt_N
├── Audio/
│   ├── Music/
│   │   └── A_MainTheme
│   └── SFX/
│       ├── SC_EngineLoop
│       └── SW_TireSqueal
├── VFX/
│   ├── NS_ExhaustSmoke
│   └── NS_NitroFlame
├── Input/  (NEW - Enhanced Input System)
│   ├── Actions/
│   │   ├── IA_Move
│   │   ├── IA_Jump
│   │   └── IA_Fire
│   ├── MappingContexts/
│   │   ├── IMC_Default
│   │   ├── IMC_Vehicle
│   │   └── IMC_Menu
│   └── Modifiers/
│       └── IM_DeadZone
└── Maps/
    ├── L_Hanoi_Downtown
    ├── L_HCMC_Highway
    └── L_DaNang_Beach
```

### Source Code Folder Structure

```
Source/PrototypeRacing/
├── Public/
│   ├── Vehicles/
│   │   ├── PlayerVehicle.h
│   │   └── VehicleMovementComponent.h
│   ├── Subsystems/
│   │   ├── CarCustomizationSubsystem.h
│   │   └── ProgressionSubsystem.h
│   └── GameModes/
│       ├── RaceGameMode.h
│       └── RaceGameState.h
└── Private/
    ├── Vehicles/
    │   ├── PlayerVehicle.cpp
    │   └── VehicleMovementComponent.cpp
    ├── Subsystems/
    │   ├── CarCustomizationSubsystem.cpp
    │   └── ProgressionSubsystem.cpp
    └── GameModes/
        ├── RaceGameMode.cpp
        └── RaceGameState.cpp
```

---

## Documentation Naming

### File Names

- Use kebab-case for all documentation files
- Be descriptive and specific
- Include version or date if applicable

**Examples:**
- `vehicle-physics-design.md`
- `progression-system-requirements.md`
- `vn-tour-campaign-planning.md`
- `mobile-optimization-guide.md`

### Feature Documentation Structure

```
features/
├── racing-car-physics/
│   ├── requirements/
│   │   └── README.md
│   ├── design/
│   │   └── README.md
│   └── ...
├── progression-system/
│   ├── requirements/
│   │   ├── README.md
│   │   ├── vn-tour-campaign.md
│   │   └── player-levels.md
│   └── ...
```

---

## Vietnamese Cultural Elements

### VN-Tour Cities and Areas

Use official Vietnamese names with proper diacritics:

| City | English | Usage |
|------|---------|-------|
| Hà Nội | Hanoi | `L_Hanoi_Downtown` |
| Thành phố Hồ Chí Minh | Ho Chi Minh City | `L_HCMC_Highway` |
| Đà Nẵng | Da Nang | `L_DaNang_Beach` |
| Huế | Hue | `L_Hue_ImperialCity` |
| Hội An | Hoi An | `L_HoiAn_OldTown` |

### Cultural Asset Naming

```
T_Dragon_Vietnamese_D       // Vietnamese dragon texture
SM_Lotus_Flower            // Lotus flower mesh
M_Bamboo_Traditional       // Traditional bamboo material
NS_Lantern_Festival        // Festival lantern VFX
```

---

## Best Practices

### General Rules

1. **Be Descriptive**: Names should clearly indicate purpose
2. **Be Consistent**: Follow established patterns
3. **Avoid Abbreviations**: Unless standard (e.g., UI, VFX, AI)
4. **Use PascalCase**: For most asset names
5. **Use kebab-case**: For documentation files
6. **No Spaces**: Use underscores or PascalCase instead
7. **Alphanumeric + Underscore**: Only allowed characters

### Avoid

- ❌ `car1`, `car2`, `car3` (not descriptive)
- ❌ `MyAwesomeVehicle` (unprofessional)
- ❌ `temp_test_thing` (unclear purpose)
- ❌ `Vehicle Copy` (spaces not allowed)
- ❌ `VhclMvmnt` (unclear abbreviations)

### Prefer

- ✅ `BP_PlayerVehicle_Sedan`
- ✅ `SM_VehicleWheel_Front`
- ✅ `T_VehicleBody_Red_D`
- ✅ `NS_ExhaustSmoke_Heavy`
- ✅ `WBP_MainMenu_VNTour`
- ✅ `IA_Move` (Enhanced Input)
- ✅ `IMC_Default` (Enhanced Input)

---

## Compliance Checklist

Before creating or renaming assets, verify:

- [ ] Correct prefix for asset type (according to Epic standard)
- [ ] Descriptive and clear name
- [ ] Follows PascalCase convention (assets) or camelCase (private vars)
- [ ] No spaces or special characters
- [ ] Consistent with existing naming patterns
- [ ] Vietnamese cultural elements properly represented
- [ ] Documentation uses kebab-case
- [ ] File organized in correct folder
- [ ] Enhanced Input assets use IA_/IMC_/etc. prefixes (UE5)
- [ ] Template classes use T prefix
- [ ] Constants use k prefix with constexpr
- [ ] Booleans have b prefix

---

## Migration Notes (UE4 to UE5)

### New Naming Conventions in UE5

1. **Enhanced Input System**:
   - Old: Action/Axis Mappings in Project Settings
   - New: IA_, IMC_, PMI_ prefixed assets

2. **TObjectPtr Usage**:
   - No naming change, but type changed
   - `UComponent* Comp` → `TObjectPtr<UComponent> Comp`

3. **Lyra Conventions** (if using GAS):
   - GA_, GE_, GCN_ prefixes for Gameplay Abilities

---

## Conclusion

Naming conventions have been **fully standardized** according to:

- **Epic C++ Coding Standard**: Class prefixes, function naming
- **Unreal Engine 5 Best Practices**: Enhanced Input, TObjectPtr
- **Industry Standards**: Lyra project conventions (GAS)
- **Project Consistency**: Clear decisions on ambiguous cases

Adherence to these conventions is **mandatory** to ensure:
- **Team Collaboration**: Everyone understands asset purpose
- **Asset Management**: Easy to find and organize assets
- **Code Maintenance**: Clear and readable codebase
- **Scalability**: Project grows without naming chaos
- **Professionalism**: High-quality, production-ready project

