# Asset Organization Standards - VNRacing

**Project**: VNRacing - Mobile Racing Game
**Document**: Asset Organization and Management Standards
**Version**: 1.2 (Epic Standards Aligned)
**Date**: 2025-11-12
**Status**: Official Standard - Aligned with UE5 Best Practices

## Overview

This document establishes standards for organizing, managing, and maintaining Unreal Engine assets in the VNRacing project to ensure efficient workflows, optimal performance, and scalability. This version has been **standardized with Unreal Engine 5 features** and best practices from Epic Games.

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
├── Input/  (NEW - Enhanced Input System UE5)
│   ├── Actions/
│   │   ├── IA_Move
│   │   ├── IA_Look
│   │   ├── IA_Jump
│   │   └── IA_Sprint
│   ├── MappingContexts/
│   │   ├── IMC_Default
│   │   ├── IMC_Vehicle
│   │   ├── IMC_Menu
│   │   └── IMC_Debug
│   ├── PlayerMappableConfigs/
│   │   ├── PMI_Keyboard
│   │   ├── PMI_Gamepad
│   │   └── PMI_Touch
│   └── Modifiers/
│       ├── IM_DeadZone
│       ├── IM_Smooth
│       └── IM_ResponseCurve
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
- **IA_**: Input Action (NEW - UE5)
- **IMC_**: Input Mapping Context (NEW - UE5)

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

### Nanite - UE5 Feature

**Virtualized Geometry System** for high-poly static meshes:

**When to Enable Nanite**:
- ✅ Environment buildings
- ✅ Detailed props
- ✅ Hero assets (if poly count > 100k)
- ✅ Static meshes with high geometric detail

**When NOT to Use Nanite**:
- ❌ Skeletal meshes (not supported)
- ❌ Translucent materials
- ❌ Materials with World Position Offset
- ❌ Deforming meshes

**Setup**:
```
Static Mesh Editor → Details Panel → Nanite Settings
☑ Enable Nanite Support
```

**Benefits**:
- Automatic LOD generation
- Triangles on-demand streaming
- Massive poly counts without performance hit

---

## Unreal Engine 5 Rendering Features

### Lumen - Global Illumination

**Dynamic Global Illumination System** - default in UE5:

**Features**:
- Real-time indirect lighting
- Dynamic reflections
- No lightmap baking required
- Hardware Ray Tracing support (optional)

**Configuration**:
```
Project Settings → Engine → Rendering
☑ Lumen Global Illumination
☑ Lumen Reflections

Per-Platform Quality Settings:
- Desktop: High/Epic
- Console: Medium/High
- Mobile: Low/Disabled (use lightmaps)
```

**Best Practices**:
- Use Lumen Scene Detail settings to control quality
- Configure Final Gather Quality per platform
- Use Reflection Capture actors for specific areas
- Consider Software vs Hardware Ray Tracing

**Mobile Optimization**:
```
// Mobile platforms - disable Lumen
r.Lumen.Supported 0

// Use traditional baked lighting
r.MobileEnableLightmaps 1
```

### Nanite + Lumen Integration

**Optimal workflow** for UE5 projects:

1. Enable Nanite for environment static meshes
2. Enable Lumen for dynamic lighting
3. Use Hardware Lumen Ray Tracing (RTX GPUs)
4. Configure per-platform quality presets

**Performance Targets**:
- Desktop (RTX 3060+): Epic Quality
- Console (PS5/XSX): High Quality
- Mobile: Disable both, use traditional pipeline

---

## World Partition System - UE5

**Large Open World Management System** - replaces Level Streaming.

### Benefits

- ✅ **Better Memory Management**: Only loads what's needed
- ✅ **Multi-Developer Workflow**: Multiple developers work on same map
- ✅ **Smaller Commits**: One-file-per-actor system
- ✅ **Automatic Streaming**: Runtime loading/unloading
- ✅ **Data Layers**: Organized loading control

### Folder Structure with World Partition

```
Maps/
├── L_MainWorld.umap  (Persistent level - World Partition enabled)
└── _MainWorld/  (External actors folder - auto-generated)
    ├── 0/
    │   ├── Actor_A1B2C3D4.uasset
    │   ├── Actor_E5F6G7H8.uasset
    │   └── ...
    ├── 1/
    └── ...
```

**⚠️ Important**:
- `_MainWorld/` folder is auto-generated when World Partition is enabled
- Each actor is a separate .uasset file
- DO NOT edit files in Windows Explorer
- Always use UE Editor to modify

### Setup World Partition

**Create New World Partition Level**:
```
File → New Level → Open World
// Or
File → New Level → Empty Open World
```

**Convert Existing Level**:
```
Tools → Convert Level... → World Partition
```

**Configure World Settings**:
```
Window → World Settings

World Partition Setup:
☑ Enable Streaming
☑ Enable One File Per Actor
☑ Enable Spatial Hash

Runtime Settings:
- Grid Size: 12800 (depends on project scale)
- Loading Range: 25600
- Enable Server Streaming: ☑ (multiplayer)
```

### World Partition Editor

**Manage and visualize partitions**:

```
Window → World Partition → World Partition Editor

Features:
- Load/Unload specific regions
- Visualize actor distribution
- Monitor memory usage
- Configure streaming priorities
```

**Workflow**:
1. Open World Partition Editor
2. Enable "Show Actors" to visualize
3. Zoom in/out to inspect regions
4. Right-click regions:
   - Load Selected Regions
   - Unload Selected Regions
   - Focus on Selection

### Data Layers

**Organized loading control** - replaces UE4 Layers:

```
Window → World Partition → Data Layers

Use Cases:
- TimeOfDay_Morning (only load in morning)
- TimeOfDay_Night (only load at night)
- Debug_Helpers (only load in editor)
- Cinematic_Props (only load in cutscenes)
```

**Example Setup**:
```cpp
// C++ - Load/Unload Data Layers at runtime
UDataLayerSubsystem* DataLayerSubsystem =
    UWorld::GetSubsystem<UDataLayerSubsystem>(GetWorld());

// Load layer
DataLayerSubsystem->SetDataLayerRuntimeState(
    DataLayerAsset,
    EDataLayerRuntimeState::Activated
);

// Unload layer
DataLayerSubsystem->SetDataLayerRuntimeState(
    DataLayerAsset,
    EDataLayerRuntimeState::Unloaded
);
```

### HLODs (Hierarchical Level of Detail)

**Automatic generation** for distant objects:

```
World Settings → World Partition → HLOD

Settings:
☑ Enable HLOD System
- HLOD Layer: HLOD0, HLOD1, HLOD2
- Cell Size: Auto
- Loading Range: 50000
```

**Benefits**:
- Reduced draw calls for distant objects
- Automatic mesh combining
- Better performance for large worlds

### World Partition Best Practices

**1. Grid Configuration**:
```
Recommended Grid Sizes:
- Small maps (< 4km²): 6400 units
- Medium maps (4-16km²): 12800 units
- Large maps (> 16km²): 25600 units
```

**2. Actor Placement**:
- Group related actors together
- Consider loading boundaries
- Avoid actors spanning multiple cells

**3. Streaming Distance**:
```
Actor Properties → World Partition
- Grid Placement: Location-based
- Runtime Grid: Default
- Data Layer Assignment: (optional)
```

**4. Performance Monitoring**:
```
Console Commands:
wp.Runtime.ToggleDrawRuntimeHash2D  // Visualize grid
wp.Runtime.RuntimeSpatialHashCellSize  // Check cell size
Stat WorldPartition  // Performance stats
```

---

## Enhanced Input Organization

**UE5 Input System** folder structure:

```
Input/
├── Actions/
│   ├── Character/
│   │   ├── IA_Move
│   │   ├── IA_Look
│   │   ├── IA_Jump
│   │   └── IA_Sprint
│   ├── Vehicle/
│   │   ├── IA_Accelerate
│   │   ├── IA_Brake
│   │   ├── IA_Steer
│   │   └── IA_Handbrake
│   └── UI/
│       ├── IA_Navigate
│       ├── IA_Confirm
│       └── IA_Cancel
├── MappingContexts/
│   ├── IMC_Default
│   ├── IMC_Vehicle_Driving
│   ├── IMC_Vehicle_Menu
│   └── IMC_Debug
├── PlayerMappableConfigs/
│   ├── PMI_Keyboard_Default
│   ├── PMI_Gamepad_Default
│   └── PMI_Mobile_Touch
└── CustomModifiers/
    ├── IM_DeadZone_Custom
    ├── IM_AccelerationCurve
    └── IM_SmoothInput
```

**Naming Conventions** (from naming-conventions.md):
- Input Actions: `IA_[Action]`
- Input Mapping Contexts: `IMC_[Context]`
- Player Mappable Configs: `PMI_[Device]_[Variant]`
- Input Modifiers: `IM_[Modifier]`

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

- [ ] Correct naming convention (per Epic standard)
- [ ] Organized in correct folder
- [ ] LODs configured (if applicable)
- [ ] Nanite enabled for high-poly meshes (UE5)
- [ ] Textures compressed correctly
- [ ] Materials use instances (not unique materials)
- [ ] No missing references
- [ ] No redirectors
- [ ] Collision configured (static meshes)
- [ ] Physics asset configured (skeletal meshes)
- [ ] Mobile optimization applied
- [ ] World Partition external actors committed (if applicable)

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

Use level streaming (legacy) or World Partition (UE5) for large worlds:

**Legacy Level Streaming**:
```
L_Persistent_Main
  ├─ L_Hanoi_Downtown_Lighting (Always Loaded)
  ├─ L_Hanoi_Downtown_Audio (Always Loaded)
  ├─ L_Hanoi_Downtown_Section1 (Distance Streaming)
  ├─ L_Hanoi_Downtown_Section2 (Distance Streaming)
  └─ L_Hanoi_Downtown_Section3 (Distance Streaming)
```

**World Partition** (Recommended UE5):
- Automatic streaming based on player position
- Configure grid size and loading range
- Use Data Layers for conditional loading

### Texture Groups

Configure texture groups for mobile:
- Project Settings → Engine → Rendering → Texture Groups
- Set max resolution per group for mobile platforms

### Draw Call Reduction

- Merge static meshes where possible
- Use Instanced Static Mesh Component
- Use Hierarchical Instanced Static Mesh (HISM) for foliage
- Enable Nanite for supported assets (UE5)

---

## Version Control Best Practices

### File Organization

- Keep related assets together
- Use consistent folder structure
- Avoid deep nesting (max 4-5 levels)

### World Partition with Source Control

**One-File-Per-Actor Benefits**:
- ✅ Smaller commits (only changed actors)
- ✅ Faster syncs
- ✅ No map file locking
- ✅ Multiple developers on same map

**Commit Workflow**:
```
1. Make changes in World Partition level
2. Save (saves individual actor files)
3. Source control shows:
   - Modified: _LevelName/Actor_XYZ.uasset
   - Modified: _LevelName/Actor_ABC.uasset
   (NOT the entire .umap file)
4. Commit with meaningful message
```

**Best Practices**:
- Commit actor files separately from level file
- Use descriptive commit messages
- Don't manually edit external actor files
- Pull before starting work to avoid conflicts

### Asset Locking (Perforce)

Lock binary assets before editing:
- Static Meshes
- Skeletal Meshes
- Textures
- Audio files
- World Partition level file (rarely changes)

### Commit Guidelines

- Commit related assets together
- Use descriptive commit messages
- Don't commit work-in-progress assets to main branch
- Use branches for experimental work
- Tag stable milestones

---

## Performance Monitoring

### Console Commands

```
// World Partition
wp.Runtime.ToggleDrawRuntimeHash2D    // Grid visualization
wp.Runtime.ShowRuntimeSpatialHashCells // Cell visualization
Stat WorldPartition                    // Performance stats

// General Performance
Stat FPS                 // Frame rate
Stat Unit               // Frame time breakdown
Stat SceneRendering     // Rendering stats
Stat GPU                // GPU profiling

// Memory
Stat Memory             // Memory usage
Stat Streaming          // Streaming stats

// Lumen (UE5)
r.Lumen.Visualize.Mode 1  // Lumen visualization
Stat Lumen                // Lumen stats
```

---

## Deprecated Assets

### Archive Process

1. Create `Content/Deprecated/` folder
2. Move deprecated assets to dated subfolder:
   ```
   Content/Deprecated/
   └── 2025-11-12/
       ├── BP_OldVehicle
       └── M_OldMaterial
   ```
3. Document reason for deprecation
4. Remove after 1 month if no issues

---

## Conclusion

Asset organization has been **standardized with UE5 features** to ensure:

- **Efficiency**: Easy to find and manage assets
- **UE5 Ready**: World Partition, Nanite, Lumen, Enhanced Input
- **Performance**: Optimized for mobile platforms
- **Scalability**: Project can grow without chaos
- **Collaboration**: Multi-developer workflow with World Partition
- **Quality**: Professional, production-ready assets

Adherence to these standards is **mandatory** for all PrototypeRacing assets.

