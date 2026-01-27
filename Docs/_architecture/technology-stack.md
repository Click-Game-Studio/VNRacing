# Technology Stack - VNRacing

**Breadcrumbs:** Docs > Architecture > Technology Stack

**Version:** 1.1.0 | **Date:** 2026-01-26

![Status: Development](https://img.shields.io/badge/Status-Development-blue)

---

## Table of Contents

1. [Overview](#overview)
2. [Core Engine](#core-engine)
   - [Unreal Engine 5.4+](#unreal-engine-54)
3. [Programming Languages](#programming-languages)
   - [C++](#c)
   - [Blueprint Visual Scripting](#blueprint-visual-scripting)
4. [Core Plugins](#core-plugins)
   - [SimpleCarPhysics](#1-simplecarphysics)
   - [Nakama](#2-nakama)
   - [EdgegapIntegrationKit](#3-edgegapintegrationkit)
   - [Minimap Plugin](#4-minimap-plugin-by-radoshaka)
   - [RTune](#5-rtune)
   - [Rive](#6-rive)
   - [AsyncTickPhysics](#7-asynctickphysics)
5. [Module Dependencies](#module-dependencies)
6. [Platform SDKs](#platform-sdks)
   - [Android](#android)
   - [iOS](#ios)
7. [Backend Services](#backend-services)
   - [Nakama Cloud](#nakama-cloud)
   - [Edgegap](#edgegap)
   - [Firebase](#firebase)
8. [Data Formats](#data-formats)
9. [Core Subsystems (Source Code)](#core-subsystems-source-code)
10. [Key Interfaces](#key-interfaces)
11. [Development Tools](#development-tools)
12. [Build Commands](#build-commands)
13. [Performance Targets](#performance-targets)
14. [Localization](#localization)
15. [Technology Stack Summary](#technology-stack-summary)
16. [Related Documentation](#related-documentation)

---

## Overview

This document provides a comprehensive overview of the technology stack used in the VNRacing project.

---

## Core Engine

### Unreal Engine 5.4+
**Version**: 5.4 or later  
**License**: Standard Unreal Engine License  
**Platform**: Windows (Development), Android/iOS (Target)

**Key Features Used**:
- Enhanced Input System
- UMG (Unreal Motion Graphics)
- Niagara VFX
- GameInstanceSubsystem Architecture
- Blueprint Visual Scripting
- C++ Programming
- Level Streaming
- Localization System

**Configuration**:
- Mobile Rendering Pipeline
- Forward Shading (mobile)
- Texture Streaming
- LOD System

---

## Programming Languages

### C++
**Version**: C++17 (UE5 standard)  
**Usage**: Core systems, performance-critical code, subsystems

**Key Areas**:
- GameInstanceSubsystem implementations
- Vehicle physics integration
- Data structures and interfaces
- Plugin integration

### Blueprint Visual Scripting
**Usage**: Gameplay logic, UI, rapid prototyping

**Key Areas**:
- Game Mode and Game State
- Player Controller logic
- UI Widgets
- Vehicle Blueprints
- Level scripting

---

## Core Plugins

### 1. SimpleCarPhysics
**Type**: Custom Vehicle Physics Plugin  
**Purpose**: Mobile-optimized vehicle physics

**Features**:
- Simplified suspension model
- Optimized tire physics
- Mobile-friendly calculations
- Replaces Chaos Vehicle for better performance

**Integration**:
```cpp
UPROPERTY(EditAnywhere, BlueprintReadWrite)
USimpleCarPhysicsComponent* PhysicsComponent;
```

### 2. Nakama
**Type**: Multiplayer Backend Service  
**Purpose**: Multiplayer, matchmaking, leaderboards, cloud save

**Features**:
- User authentication
- Matchmaking
- Leaderboards
- Cloud save/sync
- Social features (friends, chat)
- Real-time multiplayer

**Integration**:
```cpp
UNakamaClient* NakamaClient = UNakamaClient::CreateDefaultClient();
NakamaClient->AuthenticateDevice(DeviceID, ...);
```

### 3. EdgegapIntegrationKit
**Type**: Dedicated Server Deployment  
**Purpose**: Global server distribution, low-latency matchmaking

**Features**:
- Automatic server deployment
- Global edge locations
- Low-latency server selection
- Automatic scaling

### 4. Minimap Plugin (by Radoshaka)
**Type**: UI/Navigation Plugin  
**Purpose**: Real-time minimap rendering

**Features**:
- Dynamic minimap with rotation and zoom
- Actor following (center of minimap)
- Markers/icons with hide/show
- Multi-segment line drawing (path)
- World map capture tool

**Integration**:
```cpp
UMinimapSubsystem* MMS = GetWorld()->GetSubsystem<UMinimapSubsystem>();
MMS->SetLookActor(PlayerPawn);
MMS->RegisterMinimapEntitySimple(this, VehicleIcon);
```

### 5. RTune
**Type**: Vehicle Tuning Plugin  
**Purpose**: Vehicle customization and tuning

### 6. Rive
**Type**: Animation Plugin  
**Purpose**: Advanced UI animations

**Features**:
- Vector-based animations
- Lightweight and performant
- Interactive animations
- State machine support

### 7. AsyncTickPhysics
**Type**: Performance Optimization Plugin  
**Purpose**: Asynchronous physics updates

**Features**:
- Decouples physics from game thread
- Improved mobile performance
- Reduced frame time variance

---

## Module Dependencies

From `PrototypeRacing.Build.cs`:
```csharp
PublicDependencyModuleNames.AddRange(new string[] {
    "Core", "CoreUObject", "Engine", "InputCore", "EnhancedInput",
    "ChaosVehicles", "PhysicsCore", "SimpleCarPhysics", "AsyncTickPhysics",
    "LevelSequence", "MovieScene", "RenderCore", "RHI", "DeveloperSettings",
    "NakamaUnreal", "JsonUtilities", "Json", "Minimap"
});
```

---

## Platform SDKs

### Android
**Target SDK**: Android 12+ (API Level 31+)  
**Min SDK**: Android 8.0 (API Level 26)

**Services**:
- Google Play Services
- Google Play Games Services (leaderboards, achievements)
- Firebase Analytics
- Firebase Crashlytics
- In-App Purchases (Google Play Billing)

### iOS
**Target SDK**: iOS 14+  
**Min SDK**: iOS 13

**Services**:
- Game Center (leaderboards, achievements)
- Firebase Analytics
- Firebase Crashlytics
- In-App Purchases (StoreKit)

---

## Backend Services

### Nakama Cloud
**Purpose**: Multiplayer backend

**Features**:
- User authentication
- Matchmaking
- Leaderboards
- Cloud save
- Social features
- Real-time multiplayer

### Edgegap
**Purpose**: Dedicated server deployment

**Features**:
- Server deployment
- Low-latency routing
- Automatic scaling
- Server management

### Firebase
**Purpose**: Analytics, crash reporting, remote config

**Services**:
- Firebase Analytics
- Firebase Crashlytics
- Firebase Remote Config
- Firebase Cloud Messaging (push notifications)

---

## Data Formats

### Configuration
**Format**: JSON, INI, Data Tables (CSV)  
**Usage**: Game settings, vehicle stats, progression data

### Save Data
**Format**: Binary (UE SaveGame), JSON (Nakama cloud)

### Assets
**Meshes**: FBX, OBJ  
**Textures**: PNG, TGA, DDS  
**Audio**: WAV, OGG, MP3  
**Animations**: FBX

---

## Core Subsystems (Source Code)

| Subsystem | File Location | Purpose |
|-----------|---------------|---------|
| UCarCustomizationManager | `Public/CarCustomizationSystem/` | Car customization management |
| UVehicleFactory | `Public/` | Vehicle spawning |
| UCarSaveGameManager | `Public/CarCustomizationSystem/` | Save/Load management |
| UProgressionCenterSubsystem | `Public/BackendSubsystem/Progression/` | Progression facade |
| UProgressionSubsystem | `Public/BackendSubsystem/Progression/` | VN-Tour data |
| UFanServiceSubsystem | `Public/BackendSubsystem/Progression/` | Mission tracking |
| UAchievementSubsystem | `Public/BackendSubsystem/Progression/` | Achievements |
| UCarRatingSubsystem | `Public/BackendSubsystem/Progression/` | Performance gate |
| URaceSessionSubsystem | `Public/BackendSubsystem/` | Race session |
| UProfileManagerSubsystem | `Public/BackendSubsystem/` | Player profile |
| UInventoryManager | `Public/InventorySystem/` | Inventory management |
| UItemDatabase | `Public/InventorySystem/` | Item definitions |
| UCarSettingSubsystem | `Public/SettingSystem/` | Game settings |
| UAIManagerSubsystem | `Public/AISystem/` | AI management |
| UTutorialManagerSubsystem | `Public/TutorialSystem/` | Tutorial management |

---

## Key Interfaces

| Interface | Purpose |
|-----------|---------|
| ICarDataProvider | Car customization API |
| IProgressionDataProvider | Progression API |
| ISettingDataProvider | Settings API |
| IMinimapEntityInterface | Minimap entity registration |

---

## Development Tools

### Version Control
**System**: Git  
**LFS**: Git Large File Storage (for binary assets)

### IDE and Editors
**Primary IDE**: Visual Studio 2022 (C++)  
**Blueprint Editor**: Unreal Engine Editor  
**Text Editor**: Visual Studio Code (documentation, scripts)

### Build System
**Build Tool**: Unreal Build Tool (UBT)  
**Automation**: Unreal Automation Tool (UAT)

### Asset Creation
**3D Modeling**: Blender, Maya, 3ds Max  
**Texturing**: Substance Painter, Photoshop  
**Audio**: Audacity, FMOD

---

## Build Commands

```bash
# Editor build (Windows)
UnrealBuildTool.exe PrototypeRacing Win64 Development -Project="PrototypeRacing.uproject"

# Package Android
RunUAT.bat BuildCookRun -project="PrototypeRacing.uproject" -platform=Android -clientconfig=Shipping -cook -stage -package

# Package iOS
RunUAT.bat BuildCookRun -project="PrototypeRacing.uproject" -platform=iOS -clientconfig=Shipping -cook -stage -package
```

---

## Performance Targets

| Metric | Target |
|--------|--------|
| Frame Rate (High-End) | 60 FPS |
| Frame Rate (Low-End) | 30 FPS |
| Memory Budget | 2 GB |
| Loading Time (Initial) | 10 seconds |
| Loading Time (Level) | 5 seconds |
| Network Latency | 100ms |

---

## Localization

### Languages
**Primary**: English  
**Secondary**: Vietnamese  
**Additional**: Chinese, Japanese

### System
**Framework**: Unreal Localization System  
**Format**: PO files (Portable Object)

---

## Technology Stack Summary

| Category | Technology | Purpose |
|----------|-----------|---------|
| **Engine** | Unreal Engine 5.4+ | Game engine |
| **Languages** | C++, Blueprint | Programming |
| **Physics** | SimpleCarPhysics | Vehicle physics |
| **Multiplayer** | Nakama | Backend services |
| **Servers** | Edgegap | Dedicated servers |
| **UI** | UMG, Rive | User interface |
| **Minimap** | Minimap Plugin | Navigation |
| **Tuning** | RTune | Vehicle customization |
| **Physics Opt** | AsyncTickPhysics | Performance |
| **Analytics** | Firebase | Tracking and crashes |
| **Platforms** | Android, iOS | Target platforms |
| **Version Control** | Git + LFS | Source control |
| **IDE** | Visual Studio 2022 | Development |

---

## Related Documentation

- [System Overview](./system-overview.md)
- [Data Flow](./data-flow.md)
- [Integration Patterns](./integration-patterns.md)
- [Mobile Optimization](./mobile-optimization.md)
- [Performance Targets](./performance-targets.md)
