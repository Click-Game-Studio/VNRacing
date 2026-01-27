# VNRacing - Technology Stack

## Engine & Languages
- **Unreal Engine 5.4+** with Mobile Rendering Pipeline
- **C++17** for core systems and performance-critical code
- **Blueprint** for gameplay logic, UI, rapid prototyping

## Key Plugins
| Plugin | Purpose |
|--------|---------|
| SimpleCarPhysics | Mobile-optimized vehicle physics (replaces Chaos Vehicle) |
| Nakama | Multiplayer backend (auth, matchmaking, leaderboards, cloud save) |
| EdgegapIntegrationKit | Dedicated server deployment |
| Rive | Vector-based UI animations |
| Minimap | Real-time minimap rendering |
| AsyncTickPhysics | Async physics for better mobile performance |
| RTune | Vehicle tuning/customization |
| NiagaraUIRenderer | Niagara particles in UI |

## Module Dependencies
```csharp
// From PrototypeRacing.Build.cs
Core, CoreUObject, Engine, InputCore, EnhancedInput, ChaosVehicles, PhysicsCore,
SimpleCarPhysics, AsyncTickPhysics, LevelSequence, MovieScene, RenderCore,
RHI, DeveloperSettings, NakamaUnreal, JsonUtilities, Json, Minimap
```

## Backend Services
- **Nakama Cloud**: Authentication, matchmaking, cloud save, social features
- **Edgegap**: Global dedicated server orchestration
- **Firebase**: Analytics, crashlytics, remote config

## Target Platforms
- **Android**: API 26+ (Android 8.0), target API 31+ (Android 12)
- **iOS**: iOS 13+, target iOS 14+

## Build Commands
```bash
# Editor build (Windows)
UnrealBuildTool.exe PrototypeRacing Win64 Development -Project="PrototypeRacing.uproject"

# Package Android
RunUAT.bat BuildCookRun -project="PrototypeRacing.uproject" -platform=Android -clientconfig=Shipping -cook -stage -package

# Package iOS
RunUAT.bat BuildCookRun -project="PrototypeRacing.uproject" -platform=iOS -clientconfig=Shipping -cook -stage -package
```

## Data Formats
- **Config**: JSON, INI, Data Tables (CSV)
- **Save Data**: UE SaveGame (binary), Nakama cloud (JSON)
- **Assets**: FBX (meshes), PNG/TGA (textures), WAV/OGG (audio)
