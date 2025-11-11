# Naming Conventions - PrototypeRacing

**Project**: VN Racing Game

**Document**: Naming Conventions Standard

**Version**: 1.0

**Date**: 2025-11-07

**Status**: Official Standard

## Overview

This document establishes standardized naming conventions for all assets, code, and documentation in the PrototypeRacing project to ensure consistency, clarity, and maintainability across the entire codebase.

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

### Miscellaneous

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

```cpp
// Prefix with A for Actors
class APlayerVehicle : public APawn { };

// Prefix with U for UObjects and Components
class UCarCustomizationSubsystem : public UGameInstanceSubsystem { };
class UVehicleMovementComponent : public UActorComponent { };

// Prefix with F for structs
struct FVehicleStats
{
    float MaxSpeed;
    float Acceleration;
};

// Prefix with E for enums
enum class EVehicleType : uint8
{
    Sedan,
    SUV,
    SportsCar
};

// Prefix with I for interfaces
class IVehicleInterface
{
    virtual void StartEngine() = 0;
};
```

### Variables

```cpp
// Public variables: PascalCase
public:
    float MaxSpeed;
    int32 CurrentGear;
    
// Private variables: camelCase
private:
    float currentSpeed;
    int32 engineRPM;
    
// Booleans: Prefix with 'b'
bool bIsEngineRunning;
bool bCanDrift;

// Pointers: No special prefix (use descriptive names)
UVehicleMovementComponent* MovementComponent;
APlayerController* OwningController;
```

### Functions

```cpp
// PascalCase for all functions
void CalculateSpeed();
void ApplyDamage(float DamageAmount);
float GetCurrentSpeed() const;

// Getters/Setters
float GetMaxSpeed() const;
void SetMaxSpeed(float NewMaxSpeed);

// Boolean getters: Use 'Is', 'Has', 'Can'
bool IsEngineRunning() const;
bool HasNitro() const;
bool CanDrift() const;
```

### Constants

```cpp
// Use UPPER_CASE or prefix with 'k'
static const float MAX_SPEED = 300.0f;
static const int32 kMaxGears = 6;

// Or use constexpr
constexpr float kGravity = 9.81f;
```

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

---

## Compliance Checklist

Before creating or renaming assets, verify:

- [ ] Correct prefix for asset type
- [ ] Descriptive and clear name
- [ ] Follows PascalCase convention
- [ ] No spaces or special characters
- [ ] Consistent with existing naming patterns
- [ ] Vietnamese cultural elements properly represented
- [ ] Documentation uses kebab-case
- [ ] File organized in correct folder

---

## Conclusion

Consistent naming conventions are critical for:
- **Team Collaboration**: Everyone understands asset purpose
- **Asset Management**: Easy to find and organize assets
- **Code Maintenance**: Clear and readable codebase
- **Scalability**: Project grows without naming chaos
- **Professionalism**: High-quality, production-ready project

Adherence to these naming conventions is mandatory for all PrototypeRacing project assets and code.

