# DM-SET — SETTING — Low-Level Design

> Source: `Docs/audit/DM-SET_setting.md`, `Docs/c4/model.c4`, read-only source under `PrototypeRacing/Source`.
> Structurizr view: `DM_SET_Components`.
> OpenProject: #338.

## Feature summary and boundaries

DM-SET owns graphics, gameplay and control setting load, apply and persistence. It does not own the profile wallet, progression state, or platform-level OS settings. Steering-sensitivity tuning (OpenProject #353) is in-scope: the `EControlType` / `FPlayerControl` struct in `CarSaveSetting` is the current container for control settings; a dedicated sensitivity field is pending (#353).

![DM-SET components](../structurizr/embed/DM_SET_Components)

# Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `UCarSettingSubsystem` | `PrototypeRacing/Private/SettingSystem/CarSettingSubsystem.cpp` (344 lines) | Load/apply/save all settings to `UCarSaveSetting`. Owns `Initialize` (creates default volume configs), `SaveSettings`, `CheckGraphicSettings`, `LoadGraphicSettings`. |
| `UCarSaveSetting` | `PrototypeRacing/Public/SettingSystem/CarSaveSetting.h` | `USaveGame` subclass. Stores: `FVolumeConfig[]`, `FPlayerControl`, `FDisplaySettings`, `FGraphicSetting`, `FLanguageSettings`. |
| `AGraphicsSettingsActor` | `PrototypeRacing/Private/SettingSystem/GraphicsSettingsActor.cpp` | Applies UE scalability settings at runtime. Level-placed actor — a DM-SET debt item (see below). |
| `USettingDataProvider` | `PrototypeRacing/Private/SettingSystem/SettingDataProvider.cpp` | Supplies setting data to the subsystem. |

Key data structs in `CarSaveSetting.h`:
```cpp
enum class EControlType : uint8 {
    SteeringWheel, Button, TiltSteering, ZoneTouch
};
enum class EDriftMode : uint8 { Toggle, ... };
struct FPlayerControl { EControlType ControlType; EDriftMode DriftMode; };

struct FDisplaySettings { ECameraView ViewType; ESpeedUnit SpeedUnit; };

struct FGraphicSetting {
    EGraphicDetails GraphicProfile;   // Low/Balance/High/Ultra
    float FrameRateLimit;             // default 60.f
    int TextureQuality;               // 0–4
    bool Bloom, MotionBlur;
    int AntiAliasing, LightQuality, ShadowResolution;  // 0–4
};
struct FLanguageSettings { ELanguage CurrentLanguage; };
struct FVolumeConfig { EVolumeType Type; float Volume; };
// EVolumeType: Generals, Engine, Music, SFX
```

Runtime flow:
```
Game startup / UI open
   └─ UCarSettingSubsystem::Initialize (line 24)
        └─ CreateDefaultVolumeConfigs() → load or create UCarSaveSetting

User changes setting
   └─ UI (WBP settings) → call subsystem BPAPI → apply immediately
        └─ UCarSettingSubsystem::CheckGraphicSettings / LoadGraphicSettings
             └─ AGraphicsSettingsActor applies UE scalability

User confirms / closes settings UI
   └─ UCarSettingSubsystem::SaveSettings → write to SaveGame
```

Hotspots: No per-frame runtime hotspot. Apply scalability (`AGraphicsSettingsActor`) may cause a 1-frame hitch when switching heavy graphics presets — expected UE behaviour, acceptable. Confirm `SaveSettings` is called only on explicit confirm, not on every slider change.

# Layer 2 — Contract surface

```cpp
// UCarSettingSubsystem (UGameInstanceSubsystem)
virtual void Initialize(FSubsystemCollectionBase&) override;
virtual void SaveSettings() override;
virtual void CheckGraphicSettings() override;
UFUNCTION(BlueprintCallable) void LoadGraphicSettings();

// UCarSaveSetting accessors
TArray<FVolumeConfig> GetVolumeConfigs();  void SetVolumeConfigs(...);
FPlayerControl  GetPlayerControl();        void SetPlayerControl(...);
FDisplaySettings GetDisplaySettings();    void SetDisplaySettings(ECameraView, ESpeedUnit);
FGraphicSetting  GetGraphicSetting();     void SetGraphicSettings(FGraphicSetting);
FLanguageSettings GetLanguageSettings();  void SetLanguageSetting(ELanguage);
int32 GetSaveVersion() const;             void SetSaveVersion(int32);
```

Pending (OpenProject #353 — Steering Sensitivity): a `SteeringSensitivity` float field (or similar) should be added to `FPlayerControl` (or a new `FControlSetting` struct) and exposed via `UCarSettingSubsystem`. Until #353 is implemented, sensitivity is not persisted.

## Links

- Audit: `Docs/audit/DM-SET_setting.md`
- Structurizr: `DM_SET_Components`
- Steering sensitivity: OpenProject #353
