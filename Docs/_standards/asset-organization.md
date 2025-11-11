# Asset Organization Standards - PrototypeRacing

**Project**: VNRacing
**Document**: Asset Organization and Management Standards
**Version**: 1.0
**Date**: 2025-11-07
**Status**: Official Standard

## Overview

This document establishes standards for organizing, managing, and maintaining Unreal Engine assets in the PrototypeRacing project to ensure efficient workflows, optimal performance, and scalability.

---

## Content Folder Structure

### Standard Hierarchy

```
Content/
├── Blueprints/
│   ├── Characters/
│   │   ├── Player/
│   │   └── NPCs/
│   ├── Vehicles/
│   │   ├── Player/
│   │   ├── AI/
│   │   └── Components/
│   ├── GameModes/
│   │   ├── BP_RaceGameMode
│   │   └── BP_MultiplayerGameMode
│   ├── GameStates/
│   ├── PlayerControllers/
│   ├── PlayerStates/
│   ├── UI/
│   │   ├── Menus/
│   │   ├── HUD/
│   │   └── Widgets/
│   ├── Items/
│   └── Pickups/
├── Materials/
│   ├── Master/
│   │   ├── M_Master_Vehicle
│   │   ├── M_Master_Environment
│   │   └── M_Master_UI
│   ├── Instances/
│   │   ├── Vehicles/
│   │   ├── Environment/
│   │   └── VFX/
│   ├── Functions/
│   │   ├── MF_Weathering
│   │   ├── MF_ColorVariation
│   │   └── MF_DetailBlend
│   └── ParameterCollections/
│       └── MPC_GlobalParameters
├── Meshes/
│   ├── Vehicles/
│   │   ├── Chassis/
│   │   ├── Wheels/
│   │   ├── Spoilers/
│   │   └── Accessories/
│   ├── Environment/
│   │   ├── Buildings/
│   │   ├── Roads/
│   │   ├── Props/
│   │   └── Vegetation/
│   └── UI/
│       └── Icons/
├── Textures/
│   ├── Vehicles/
│   │   ├── Body/
│   │   ├── Wheels/
│   │   └── Decals/
│   ├── Environment/
│   │   ├── Buildings/
│   │   ├── Roads/
│   │   └── Terrain/
│   ├── UI/
│   │   ├── Icons/
│   │   ├── Backgrounds/
│   │   └── Buttons/
│   └── VFX/
│       ├── Particles/
│       └── Trails/
├── Animations/
│   ├── Vehicles/
│   │   ├── Sequences/
│   │   ├── Montages/
│   │   └── BlendSpaces/
│   └── Characters/
│       ├── Locomotion/
│       └── Actions/
├── VFX/
│   ├── Niagara/
│   │   ├── Systems/
│   │   │   ├── NS_ExhaustSmoke
│   │   │   ├── NS_NitroFlame
│   │   │   └── NS_TireSmoke
│   │   └── Emitters/
│   │       ├── NE_SparkParticles
│   │       └── NE_DustParticles
│   └── Materials/
│       ├── M_Particle_Smoke
│       └── M_Particle_Fire
├── Audio/
│   ├── Music/
│   │   ├── MainTheme/
│   │   ├── RaceMusic/
│   │   └── MenuMusic/
│   ├── SFX/
│   │   ├── Vehicles/
│   │   │   ├── Engine/
│   │   │   ├── Tires/
│   │   │   └── Collisions/
│   │   ├── UI/
│   │   └── Environment/
│   └── Voice/
│       └── Announcer/
├── UI/
│   ├── Widgets/
│   │   ├── WBP_MainMenu
│   │   ├── WBP_HUD
│   │   └── WBP_PauseMenu
│   ├── Textures/
│   │   ├── Icons/
│   │   ├── Backgrounds/
│   │   └── Buttons/
│   └── Fonts/
│       ├── Roboto/
│       └── Vietnamese/
├── Data/
│   ├── DataTables/
│   │   ├── DT_VehicleStats
│   │   ├── DT_TrackData
│   │   └── DT_Progression
│   ├── DataAssets/
│   │   ├── DA_VehicleConfig
│   │   └── DA_RaceSettings
│   └── Curves/
│       ├── Curve_AccelerationCurve
│       └── Curve_HandlingCurve
├── Maps/
│   ├── Levels/
│   │   ├── VNTour/
│   │   │   ├── L_Hanoi_Downtown
│   │   │   ├── L_HCMC_Highway
│   │   │   └── L_DaNang_Beach
│   │   └── TestMaps/
│   │       ├── L_VehicleTest
│   │       └── L_PerformanceTest
│   ├── Sublevels/
│   │   ├── Lighting/
│   │   ├── Audio/
│   │   └── Streaming/
│   └── Persistent/
│       └── L_Persistent_Main
└── Plugins/
    ├── SimpleCarPhysics/
    ├── Nakama/
    └── EdgegapIntegrationKit/
```

---

## Asset Naming Standards

### Prefix System

Follow the naming conventions defined in `naming-conventions.md`:

- **BP_**: Blueprint Class
- **M_**: Material
- **MI_**: Material Instance
- **T_**: Texture
- **SM_**: Static Mesh
- **SK_**: Skeletal Mesh
- **A_**: Animation
- **NS_**: Niagara System
- **WBP_**: Widget Blueprint
- **DT_**: Data Table
- **DA_**: Data Asset

### Texture Suffix System

- **_D**: Diffuse/Albedo
- **_N**: Normal Map
- **_R**: Roughness
- **_M**: Metallic
- **_AO**: Ambient Occlusion
- **_E**: Emissive
- **_H**: Height Map

**Example**: `T_VehicleBody_Red_D`, `T_VehicleBody_Red_N`, `T_VehicleBody_Red_R`

---

## Asset Management Best Practices

### Master Materials

Create master materials for each major category:

```
M_Master_Vehicle
  ├─ MI_Vehicle_Sedan_Red
  ├─ MI_Vehicle_Sedan_Blue
  ├─ MI_Vehicle_SUV_Black
  └─ MI_Vehicle_SportsCar_Yellow

M_Master_Environment
  ├─ MI_Building_Concrete
  ├─ MI_Road_Asphalt
  └─ MI_Terrain_Grass

M_Master_UI
  ├─ MI_Button_Primary
  ├─ MI_Button_Secondary
  └─ MI_Background_Menu
```

**Benefits**:
- Consistent look across assets
- Easy to make global changes
- Better performance (material instances are cheaper)
- Simplified workflow

### Material Parameter Collections

Use Material Parameter Collections for global parameters:

```cpp
MPC_GlobalParameters
  ├─ TimeOfDay (Scalar)
  ├─ WeatherIntensity (Scalar)
  ├─ GlobalTint (Vector)
  └─ WindDirection (Vector)
```

### Texture Atlases

Combine small textures into atlases for UI and particles:

```
T_UI_Icons_Atlas (2048x2048)
  ├─ Speed Icon (256x256)
  ├─ Nitro Icon (256x256)
  ├─ Health Icon (256x256)
  └─ ... (up to 64 icons)
```

**Benefits**:
- Reduced draw calls
- Better memory usage
- Faster loading times

---

## LOD (Level of Detail) Standards

### Static Meshes

Configure LODs for all static meshes:

| LOD Level | Distance | Triangle Reduction |
|-----------|----------|-------------------|
| LOD 0 | 0-1000 units | 0% (Full detail) |
| LOD 1 | 1000-3000 units | 50% |
| LOD 2 | 3000-6000 units | 75% |
| LOD 3 | 6000+ units | 90% |

### Skeletal Meshes

Configure LODs for skeletal meshes:

| LOD Level | Distance | Bone Reduction |
|-----------|----------|----------------|
| LOD 0 | 0-500 units | 0% (All bones) |
| LOD 1 | 500-2000 units | 25% |
| LOD 2 | 2000+ units | 50% |

### Nanite (UE5)

Enable Nanite for high-poly static meshes:
- Environment buildings
- Detailed props
- Hero vehicles (if poly count > 100k)

---

## Texture Optimization

### Compression Settings

| Texture Type | Compression | sRGB | Mip Maps |
|--------------|-------------|------|----------|
| Diffuse/Albedo | BC1 (DXT1) | Yes | Yes |
| Normal Map | BC5 (DXT5) | No | Yes |
| Roughness | BC4 (DXT1) | No | Yes |
| Metallic | BC4 (DXT1) | No | Yes |
| UI Textures | BC7 | Yes | No |
| VFX Textures | BC3 (DXT5) | Yes | Yes |

### Resolution Guidelines

| Asset Type | Max Resolution | Mobile Resolution |
|------------|---------------|-------------------|
| Hero Vehicle | 2048x2048 | 1024x1024 |
| Environment | 2048x2048 | 1024x1024 |
| Props | 1024x1024 | 512x512 |
| UI | 1024x1024 | 512x512 |
| VFX | 512x512 | 256x256 |

### Texture Streaming

Enable texture streaming for large textures:
- Project Settings → Engine → Rendering → Texture Streaming
- Set appropriate streaming pool size (mobile: 512MB, PC: 2GB)

---

## Asset Validation

### Pre-Commit Checklist

Before committing assets, verify:

- [ ] Correct naming convention
- [ ] Organized in correct folder
- [ ] LODs configured (if applicable)
- [ ] Textures compressed correctly
- [ ] Materials use instances (not unique materials)
- [ ] No missing references
- [ ] No redirectors
- [ ] Collision configured (static meshes)
- [ ] Physics asset configured (skeletal meshes)
- [ ] Mobile optimization applied

### Asset Audit Tools

Use Unreal Engine's built-in tools:

1. **Reference Viewer**: Right-click asset → Reference Viewer
   - Check dependencies
   - Identify circular references
   - Find unused assets

2. **Size Map**: Window → Statistics → Size Map
   - Identify large assets
   - Optimize memory usage

3. **Asset Audit**: Window → Developer Tools → Asset Audit
   - Find assets with issues
   - Validate naming conventions

---

## Mobile Optimization

### Asset Streaming

Use level streaming for large worlds:

```
L_Persistent_Main
  ├─ L_Hanoi_Downtown_Lighting (Always Loaded)
  ├─ L_Hanoi_Downtown_Audio (Always Loaded)
  ├─ L_Hanoi_Downtown_Section1 (Distance Streaming)
  ├─ L_Hanoi_Downtown_Section2 (Distance Streaming)
  └─ L_Hanoi_Downtown_Section3 (Distance Streaming)
```

### Texture Groups

Configure texture groups for mobile:
- Project Settings → Engine → Rendering → Texture Groups
- Set max resolution per group for mobile platforms

### Draw Call Reduction

- Merge static meshes where possible
- Use Instanced Static Mesh Component
- Use Hierarchical Instanced Static Mesh (HISM) for foliage

---

## Version Control Best Practices

### File Organization

- Keep related assets together
- Use consistent folder structure
- Avoid deep nesting (max 4-5 levels)

### Asset Locking (Perforce)

Lock binary assets before editing:
- Static Meshes
- Skeletal Meshes
- Textures
- Audio files

### Commit Guidelines

- Commit related assets together
- Use descriptive commit messages
- Don't commit work-in-progress assets to main branch
- Use branches for experimental work

---

## Deprecated Assets

### Archive Process

1. Create `Content/Deprecated/` folder
2. Move deprecated assets to dated subfolder:
   ```
   Content/Deprecated/
   └── 2025-11-07/
       ├── BP_OldVehicle
       └── M_OldMaterial
   ```
3. Document reason for deprecation
4. Remove after 1 month if no issues

---

## Conclusion

Proper asset organization ensures:
- **Efficiency**: Easy to find and manage assets
- **Performance**: Optimized for mobile platforms
- **Scalability**: Project can grow without chaos
- **Collaboration**: Team members can work together effectively
- **Quality**: Professional, production-ready assets

Adherence to these standards is mandatory for all PrototypeRacing assets.

