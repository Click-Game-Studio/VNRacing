---
phase: overview
title: Setting System Feature
description: Game configuration management for VNRacing
feature_id: setting-system
status: development
priority: high
owner: Engineering Team
last_updated: 2026-01-20
---

# Setting System Feature

**Breadcrumbs:** [Docs](../../../) > [Features](../) > Setting System

**Feature ID**: `setting-system`  
**Status**: 🔄 Development  
**Version**: 1.0.0  
**Date**: 2026-01-20  
**Source of Truth**: `PrototypeRacing/Source/PrototypeRacing/Private/SettingSystem/`

---

## Overview

The Setting System provides comprehensive game configuration management for VNRacing, with mobile-first design and adaptive quality settings. It manages graphics, audio, controls, display, and language settings.

### Implementation Status

| Component | Status | Notes |
|-----------|--------|-------|
| UCarSettingSubsystem | ✅ Done | Central setting management |
| ISettingDataProvider | ✅ Done | Interface abstraction |
| Volume Settings | ✅ Done | 4 types (General, Engine, Music, SFX) |
| Control Settings | ✅ Done | Steering type + Drift mode |
| Display Settings | ✅ Done | Camera view + Speed unit |
| Graphic Settings | ✅ Done | Full profile system |
| Language Settings | ✅ Done | 4 languages |
| Auto Detection | ✅ Done | Hardware benchmark |
| Quality Warnings | ✅ Done | Over-spec alerts |

### Key Capabilities

- **Graphics Settings**: Quality presets (Performance/Balance/High/Ultra/Custom), FPS limit, texture/shadow/AA quality
- **Audio Settings**: General, Engine, Music, SFX volumes (0-100%)
- **Control Settings**: Steering type (Button/Wheel/Tilt), Drift mode (Toggle/Press)
- **Display Settings**: Camera view (Default/Far/Near), Speed unit (Kph/Mph)
- **Language Settings**: English, Vietnamese, Chinese, Japanese
- **Auto Detection**: Hardware benchmark for optimal defaults

---

## Core Components

### UCarSettingSubsystem

**Type**: `UGameInstanceSubsystem` implementing `ISettingDataProvider`  
**Location**: `Source/PrototypeRacing/Public/SettingSystem/CarSettingSubsystem.h`

```cpp
// Key methods
TArray<FVolumeConfig> GetVolumeConfigs();
FPlayerControl GetPlayerControl();
FDisplaySettings GetDisplaySettings();
FGraphicSetting GetGraphicSettings();
FLanguageSettings GetLanguageSetting();

void UpdateVolumeConfig(FVolumeConfig NewVolumeConfig);
void UpdateDrivingType(EControlType NewControlType);
void UpdateBrakeType(EDriftMode NewDriftMode);
void UpdateCameraView(ECameraView CameraView);
void UpdateSpeedUnit(ESpeedUnit SpeedUnit);
void UpdateGraphicProfile(EGraphicDetails GraphicDetails);
void UpdateFrameRateLimit(float FrameRateLimit);
void UpdateTextures(int TexturesQuality);
void UpdateBloom(bool bIsOn);
void UpdateMotionBlur(bool bIsOn);
void UpdateAntiAliasing(int AntiAliasing);
void UpdateLightQuality(int LightQuality);
void UpdateShadowResolutions(int ShadowResolutions);
void UpdateLanguage(ELanguage NewLanguage);
void SaveSettings();
void AutoUpdateGraphic();
void CheckGraphicSettings();
```

### Events

| Event | Signature |
|-------|-----------|
| `OnGraphicSettingsChanged` | `FGraphicSetting` |
| `SettingWarnings` | `TArray<FString>` |

---

## Setting Categories

### 1. Volume Settings

| Type | Default | Range |
|------|---------|-------|
| GENERALS | 1.0 | 0.0 - 1.0 |
| Engine | 1.0 | 0.0 - 1.0 |
| Music | 1.0 | 0.0 - 1.0 |
| SFX | 1.0 | 0.0 - 1.0 |

### 2. Control Settings

| Setting | Options | Default |
|---------|---------|---------|
| ControlType | SteeringWheel, Button, TiltSteering | Button |
| DriftMode | Toggle, Press | Toggle |

### 3. Display Settings

| Setting | Options | Default |
|---------|---------|---------|
| ViewType | Default, Far, Near | Default |
| SpeedUnit | Kph, Mph | Kph |

### 4. Graphic Settings

| Setting | Options/Range | Default |
|---------|---------------|---------|
| GraphicProfile | Performance, Balance, High, Ultra, Custom | Balance |
| FrameRateLimit | 30.0, 60.0 | 60.0 |
| TextureQuality | 0-4 (Low to Ultra) | 1 |
| Bloom | true/false | true |
| MotionBlur | true/false | true |
| AntiAliasing | 0-4 | 1 |
| LightQuality | 0-4 | 1 |
| ShadowResolution | 0-4 | 1 |

### 5. Language Settings

| Language | Enum Value |
|----------|------------|
| English | 0 |
| Vietnamese | 1 |
| Chinese | 2 |
| Japanese | 3 |

---

## Quick Links

### Design
- [Setting System Architecture](design/setting-system-architecture.md) - Technical design synced with source code (includes planned extensions)

### Requirements
- [GDD Setting](requirements/GDD_Setting.md) - Setting system specification

---

## Dependencies

### Internal
- **UCarSaveGameManager**: Save/load settings
- **UGameUserSettings**: Engine graphics settings

### External
- **APostProcessVolume**: Bloom and motion blur effects

---

## Source Files

| File | Location |
|------|----------|
| CarSettingSubsystem.h/cpp | `SettingSystem/` |
| SettingDataProvider.h | `SettingSystem/` |
| CarSaveSetting.h | `SettingSystem/` |

---

*Synced with source code on 2026-01-20*

