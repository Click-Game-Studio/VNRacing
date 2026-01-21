# Architecture Documentation - VNRacing

**Breadcrumbs:** Docs > Architecture

**Version:** 1.0.0 | **Date:** 2026-01-20

![Status: Development](https://img.shields.io/badge/Status-Development-blue)

---

## Table of Contents

1. [Overview](#overview)
2. [Architecture Documents](#architecture-documents)
   - [System Overview](#1-system-overview)
   - [Technology Stack](#2-technology-stack)
   - [Data Flow](#3-data-flow)
   - [Integration Patterns](#4-integration-patterns)
   - [Mobile Optimization](#5-mobile-optimization)
   - [Performance Targets](#6-performance-targets)
   - [Security Architecture](#7-security-architecture)
3. [Core Subsystems](#core-subsystems)
4. [Design Patterns Used](#design-patterns-used)
5. [Feature Documentation](#feature-documentation)
6. [Source Code Reference](#source-code-reference)
7. [Related Documentation](#related-documentation)
8. [Document History](#document-history)

---

## Overview

This directory contains comprehensive architecture documentation for the VNRacing project, synchronized with the actual source code in `PrototypeRacing/Source/PrototypeRacing/`. It covers system high-level design, data flow, integration patterns, and platform-specific optimizations.

---

## Architecture Documents

### 1. System Overview
**File**: `system-overview.md`

High-level system architecture covering:
- Core subsystems (UGameInstanceSubsystem pattern)
- Component relationships and dependencies
- Interface patterns (ICarDataProvider, IProgressionDataProvider, etc.)
- Plugin integration (SimpleCarPhysics, Minimap, Nakama)
- System layers (Presentation, Business Logic, Data, Infrastructure)

### 2. Technology Stack
**File**: `technology-stack.md`

Complete technology stack documentation:
- Unreal Engine 5.4+ configuration
- Core plugins (SimpleCarPhysics, Nakama, Edgegap, Minimap, etc.)
- Module dependencies from Build.cs
- Platform SDKs (Android, iOS)
- Development tools and build commands

### 3. Data Flow
**File**: `data-flow.md`

Data flow patterns and diagrams:
- Subsystem access patterns
- Car customization data flow
- Progression data flow (VN-Tour)
- Profile and inventory data flow
- Settings data flow
- Save/Load data flow
- Event-driven communication

### 4. Integration Patterns
**File**: `integration-patterns.md`

Plugin and subsystem integration patterns:
- UGameInstanceSubsystem pattern
- Interface-based design (ICarDataProvider, etc.)
- Facade pattern (UProgressionCenterSubsystem)
- Factory pattern (UVehicleFactory)
- Event-driven communication
- Plugin integration (SimpleCarPhysics, Minimap)
- DataTable integration
- Save system integration

### 5. Mobile Optimization
**File**: `mobile-optimization.md`

Mobile-specific architecture decisions:
- Distance-based update system
- Object pooling architecture
- Adaptive quality settings
- Memory management strategies
- Battery optimization patterns
- Touch input architecture

### 6. Performance Targets
**File**: `performance-targets.md`

Performance budgets and targets:
- Frame rate targets (60 FPS mobile)
- Memory budgets (Android/iOS)
- Draw call limits
- Network latency targets
- Loading time targets
- Battery consumption targets

### 7. Security Architecture
**File**: `security-architecture.md`

Security patterns and practices:
- Client-server validation
- Anti-cheat architecture
- Data encryption
- Secure communication (Nakama)
- User data protection

---

## Core Subsystems

| Subsystem | Purpose | Interface |
|-----------|---------|-----------|
| UCarCustomizationManager | Car customization management | ICarDataProvider |
| UProgressionCenterSubsystem | Progression facade | IProgressionDataProvider |
| UProgressionSubsystem | VN-Tour data management | - |
| UFanServiceSubsystem | In-race mission tracking | - |
| UAchievementSubsystem | Achievement management | - |
| UCarRatingSubsystem | Performance gate calculation | - |
| URaceSessionSubsystem | Race session management | - |
| UProfileManagerSubsystem | Player profile management | - |
| UInventoryManager | Inventory management | - |
| UCarSettingSubsystem | Game settings | ISettingDataProvider |
| UAIManagerSubsystem | AI vehicle management | - |
| UTutorialManagerSubsystem | Tutorial management | - |
| UMinimapSubsystem | Minimap rendering (Plugin) | - |

---

## Design Patterns Used

### 1. Subsystem Pattern
- UGameInstanceSubsystem for global services
- Automatic lifecycle management
- Dependency injection via subsystem access

### 2. Interface Pattern
- ICarDataProvider - Car customization API
- IProgressionDataProvider - Progression API
- ISettingDataProvider - Settings API
- IMinimapEntityInterface - Minimap entity registration

### 3. Facade Pattern
- UProgressionCenterSubsystem - Central access for progression subsystems

### 4. Factory Pattern
- UVehicleFactory - Vehicle spawning

### 5. Observer Pattern
- Event Dispatchers for UI updates
- Delegate-based communication

---

## Feature Documentation

| Feature | Design Doc | Status |
|---------|------------|--------|
| Car Customization | [design/README.md](../features/car-customization/design/README.md) | Production |
| Progression System | [design/progression-system-architecture.md](../features/progression-system/design/progression-system-architecture.md) | Production |
| Profiles and Inventory | [design/README.md](../features/profiles-inventory/design/README.md) | Production |
| Setting System | [design/setting-system-architecture.md](../features/setting-system/design/setting-system-architecture.md) | Production |
| Minimap System | [design/README.md](../features/minimap-system/design/README.md) | Production |
| Racer AI | [design/racer-ai-architecture.md](../features/racer-ai/design/racer-ai-architecture.md) | Production |
| Tutorials | [design/tutorials-architecture.md](../features/tutorials/design/tutorials-architecture.md) | Production |

---

## Source Code Reference

```
PrototypeRacing/Source/PrototypeRacing/
├── Public/
│   ├── CarCustomizationSystem/
│   │   ├── CarCustomizationManager.h
│   │   ├── CarDataProvider.h
│   │   ├── CarSaveGameManager.h
│   │   ├── CustomizableCar.h
│   │   ├── LevelReflectionSystem.h
│   │   └── RacingSaveGame.h
│   ├── VehicleFactory.h
│   ├── BackendSubsystem/
│   │   ├── Progression/
│   │   │   ├── ProgressionCenterSubsystem.h
│   │   │   ├── ProgressionSubsystem.h
│   │   │   ├── FanServiceSubsystem.h
│   │   │   ├── AchievementSubsystem.h
│   │   │   └── CarRatingSubsystem.h
│   │   ├── ProfileManagerSubsystem.h
│   │   └── RaceSessionSubsystem.h
│   ├── InventorySystem/
│   │   ├── InventoryManager.h
│   │   └── ItemDatabase.h
│   ├── SettingSystem/
│   │   ├── CarSettingSubsystem.h
│   │   └── SettingDataProvider.h
│   ├── ProgressionSystem/
│   │   ├── ProgressionDataProvider.h
│   │   ├── ProgressionSaveGame.h
│   │   └── TrackAnimationSaveGame.h
│   ├── RaceMode/
│   │   ├── RaceCheckpoint.h
│   │   ├── RaceComponent.h
│   │   └── RaceTrackManager.h
│   ├── AISystem/
│   │   └── AIManagerSubsystem.h
│   └── TutorialSystem/
│       ├── TutorialManagerSubsystem.h
│       ├── ScriptTutorialWidget.h
│       ├── TooltipTutorialWidget.h
│       └── TutorialSaveGame.h
└── Private/
    └── [Implementation files]
```

---

## Related Documentation

- **Standards**: `../_standards/`
- **Cross-References**: `../_cross-reference/`
- **Templates**: `../_templates/`

---

## Document History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-20 | Initial architecture documentation synced with source code |
