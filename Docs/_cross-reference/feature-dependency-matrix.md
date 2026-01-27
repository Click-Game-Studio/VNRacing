# Feature Dependency Matrix - VNRacing

**Breadcrumbs:** [Docs](../README.md) > [Cross-Reference](./) > Feature Dependency Matrix

**Project**: VNRacing - Mobile Racing Game  
**Document**: Feature Dependencies and Relationships  
**Version**: 1.1.0 | **Date**: 2026-01-26
**Status**: 🔄 Development

## Overview

This document provides a comprehensive matrix of feature dependencies, showing which features depend on which other features, and the nature of those dependencies.

## Table of Contents

1. [Feature Dependency Matrix](#1-feature-dependency-matrix)
2. [Detailed Dependency Descriptions](#2-detailed-dependency-descriptions)
   - [Racing Car Physics](#racing-car-physics)
   - [Progression System](#progression-system)
   - [Car Customization](#car-customization)
   - [Setting System](#setting-system)
   - [Shop System](#shop-system)
   - [Race Modes](#race-modes)
   - [Multiplayer](#multiplayer)
   - [UI/UX System](#uiux-system)
   - [Mobile Optimization](#mobile-optimization)
   - [Profiles & Inventory System](#profiles--inventory-system)
   - [Racer AI System](#racer-ai-system)
   - [Tutorial System](#tutorial-system)
   - [Minimap System](#minimap-system)
3. [Dependency Levels](#3-dependency-levels)
4. [Critical Paths](#4-critical-paths)
5. [Circular Dependency Prevention](#5-circular-dependency-prevention)
6. [Subsystem Dependencies](#6-subsystem-dependencies)
7. [Plugin Dependencies](#7-plugin-dependencies)
8. [Data Flow Dependencies](#8-data-flow-dependencies)
9. [Build Dependencies](#9-build-dependencies)
10. [Testing Dependencies](#10-testing-dependencies)
11. [Dependency Management Best Practices](#dependency-management-best-practices)
12. [Conclusion](#conclusion)

---

## 1. Feature Dependency Matrix

### Visual Matrix

| Feature | Racing Physics | Progression | Customization | Settings | Shop | Race Modes | Multiplayer | UI/UX | Minimap | Mobile Opt |
|---------|---------------|-------------|---------------|----------|------|------------|-------------|-------|---------|------------|
| **Racing Physics** | - | ✓ | ✓ | ✓ | - | ✓ | ✓ | ✓ | ✓ | ✓ |
| **Progression** | ✓ | - | ✓ | - | ✓ | ✓ | ✓ | ✓ | - | - |
| **Customization** | ✓ | ✓ | - | - | ✓ | - | ✓ | ✓ | - | - |
| **Settings** | ✓ | - | - | - | - | - | - | ✓ | ✓ | ✓ |
| **Shop** | - | ✓ | ✓ | - | - | - | - | ✓ | - | - |
| **Race Modes** | ✓ | ✓ | - | - | - | - | ✓ | ✓ | ✓ | - |
| **Multiplayer** | ✓ | ✓ | ✓ | ✓ | - | ✓ | - | ✓ | ✓ | ✓ |
| **UI/UX** | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | - | ✓ | ✓ |
| **Minimap** | ✓ | - | - | ✓ | - | ✓ | ✓ | ✓ | - | ✓ |
| **Mobile Opt** | ✓ | - | - | ✓ | - | - | ✓ | ✓ | ✓ | - |

**Legend**:
- ✓ = Depends on
- \- = No dependency

---

## 2. Detailed Dependency Descriptions

### Racing Car Physics

**Depends On**:
- **Settings**: Quality settings, control sensitivity
- **Mobile Optimization**: Distance-based updates, performance budgets
- **UI/UX**: HUD display, input handling

**Depended On By**:
- **Progression**: XP awarded based on race performance
- **Customization**: Physics affected by vehicle modifications
- **Race Modes**: Core gameplay mechanic
- **Multiplayer**: Synchronized physics across clients
- **UI/UX**: Speed, lap time, position display

**Dependency Type**: Core Foundation

---

### Progression System

**Depends On**:
- **Racing Physics**: Race completion, performance metrics
- **Customization**: Unlocked content
- **Shop**: Currency earned
- **Race Modes**: XP sources
- **Multiplayer**: Online race rewards

**Depended On By**:
- **Customization**: Content unlock requirements
- **Shop**: Currency availability
- **Race Modes**: Level-gated content
- **Multiplayer**: Matchmaking rating
- **UI/UX**: Level, XP, unlocks display

**Dependency Type**: Core System

---

### Car Customization

**Depends On**:
- **Racing Physics**: Performance modifications
- **Progression**: Unlock requirements
- **Shop**: Purchase customization items

**Depended On By**:
- **Racing Physics**: Modified vehicle stats
- **Multiplayer**: Visual customization sync
- **UI/UX**: Garage interface

**Dependency Type**: Feature Enhancement

---

### Setting System

**Depends On**:
- **UI/UX**: Settings menu interface

**Depended On By**:
- **Racing Physics**: Control sensitivity, physics quality
- **Mobile Optimization**: Quality settings, battery mode
- **Multiplayer**: Network settings
- **UI/UX**: Display settings, language

**Dependency Type**: Configuration Layer

---

### Shop System

**Depends On**:
- **Progression**: Currency availability
- **Customization**: Items to purchase

**Depended On By**:
- **Progression**: Currency spending
- **Customization**: Item acquisition
- **UI/UX**: Shop interface

**Dependency Type**: Monetization Feature

---

### Race Modes

**Depends On**:
- **Racing Physics**: Core gameplay
- **Progression**: Level requirements, rewards

**Depended On By**:
- **Progression**: XP and currency sources
- **Multiplayer**: Online race modes
- **UI/UX**: Mode selection interface

**Dependency Type**: Gameplay Variety

---

### Multiplayer

**Depends On**:
- **Racing Physics**: Synchronized gameplay
- **Progression**: Player ratings, rewards
- **Customization**: Visual sync
- **Settings**: Network configuration
- **Race Modes**: Online modes
- **Mobile Optimization**: Network optimization

**Depended On By**:
- **Progression**: Online rewards
- **UI/UX**: Matchmaking, lobby interfaces

**Dependency Type**: Online Feature

---

### UI/UX System

**Depends On**:
- **Racing Physics**: HUD data
- **Progression**: Level, XP display
- **Customization**: Garage interface
- **Settings**: Settings menu
- **Shop**: Shop interface
- **Race Modes**: Mode selection
- **Multiplayer**: Matchmaking UI
- **Mobile Optimization**: Touch controls, widget pooling

**Depended On By**:
- All features require UI representation

**Dependency Type**: Presentation Layer

---

### Mobile Optimization

**Depends On**:
- **Racing Physics**: Performance optimization
- **Settings**: Quality configuration
- **Multiplayer**: Network optimization
- **UI/UX**: Widget pooling, touch input

**Depended On By**:
- **Racing Physics**: Distance-based updates
- **UI/UX**: Performance constraints

**Dependency Type**: Cross-Cutting Concern

---

### Profiles & Inventory System

**Depends On**:
- **Progression**: Player data, unlocked content
- **Customization**: Owned customization items
- **Shop**: Purchased items

**Depended On By**:
- **Progression**: Profile data storage
- **Customization**: Item ownership validation
- **Shop**: Inventory management
- **UI/UX**: Profile display, inventory interface

**Dependency Type**: Data Management System

---

### Racer AI System

**Depends On**:
- **Racing Physics**: AI vehicle control
- **Race Modes**: AI behavior per mode
- **Settings**: AI difficulty settings

**Depended On By**:
- **Race Modes**: AI opponents in single-player
- **Progression**: AI difficulty scaling
- **UI/UX**: AI position display

**Dependency Type**: Gameplay Feature

---

### Tutorial System

**Depends On**:
- **Racing Physics**: Tutorial race mechanics
- **UI/UX**: Tutorial UI overlays
- **Progression**: Tutorial completion tracking

**Depended On By**:
- **Progression**: First-time user experience
- **UI/UX**: Tutorial prompts and guidance
- **Race Modes**: Tutorial race mode

**Dependency Type**: Onboarding Feature

---

### Minimap System

**Depends On**:
- **Racing Physics**: Vehicle positions
- **Settings**: Minimap display settings
- **Mobile Optimization**: Performance constraints
- **UI/UX**: Minimap widget integration

**Depended On By**:
- **Race Modes**: Track navigation
- **Multiplayer**: Opponent positions
- **UI/UX**: HUD integration

**Dependency Type**: UI Enhancement

---

## 3. Dependency Levels

### Level 0: Foundation
- **Settings System**: No dependencies on other features
- **Mobile Optimization**: Minimal dependencies

### Level 1: Core Systems
- **Racing Car Physics**: Depends on Settings, Mobile Opt
- **UI/UX System**: Depends on Settings, Mobile Opt

### Level 2: Gameplay Features
- **Progression System**: Depends on Racing Physics, UI/UX
- **Profiles & Inventory**: Depends on Progression
- **Customization**: Depends on Racing Physics, Progression, Profiles & Inventory
- **Race Modes**: Depends on Racing Physics, Progression
- **Racer AI**: Depends on Racing Physics, Race Modes, Settings
- **Minimap System**: Depends on Racing Physics, UI/UX, Settings, Mobile Opt
- **Tutorial System**: Depends on Racing Physics, UI/UX, Progression

### Level 3: Advanced Features
- **Shop System**: Depends on Progression, Customization, Profiles & Inventory, UI/UX
- **Multiplayer**: Depends on Racing Physics, Progression, Customization, Settings, Race Modes, Minimap

---

## 4. Critical Paths

### Minimum Viable Product (MVP)
1. Settings System
2. Mobile Optimization
3. Racing Car Physics
4. UI/UX System
5. Tutorial System
6. Minimap System
7. Race Modes (Time Trial only)
8. Racer AI (Basic)

### Full Single-Player Experience
1. MVP features
2. Progression System
3. Profiles & Inventory System
4. Car Customization
5. Shop System
6. Race Modes (all modes)
7. Racer AI (Advanced)

### Full Multiplayer Experience
1. Full Single-Player features
2. Multiplayer System

---

## 5. Circular Dependency Prevention

### Identified Potential Circular Dependencies

**Racing Physics ↔ Customization**:
- **Issue**: Physics affects customization, customization affects physics
- **Solution**: Use event-driven updates. Customization modifies vehicle config, physics reads config on initialization

**Progression ↔ Shop**:
- **Issue**: Progression provides currency, shop spends currency
- **Solution**: Progression owns currency data, shop requests transactions through progression subsystem

**UI/UX ↔ All Features**:
- **Issue**: UI depends on all features, all features need UI
- **Solution**: Use event dispatchers. Features broadcast events, UI listens and updates

**Minimap ↔ Racing Physics**:
- **Issue**: Minimap needs vehicle positions, racing physics provides positions
- **Solution**: Minimap subscribes to position update events, uses distance-based culling for performance

---

## 6. Subsystem Dependencies

### UGameInstanceSubsystem Dependencies

```cpp
// Initialization order matters
void UGameInstance::Init()
{
    Super::Init();
    
    // Level 0: Foundation
    USettingSubsystem* Settings = GetSubsystem<USettingSubsystem>();
    Settings->Initialize();
    
    // Level 1: Core
    UCarCustomizationSubsystem* Customization = GetSubsystem<UCarCustomizationSubsystem>();
    Customization->Initialize();
    
    // Level 2: Gameplay
    UProgressionSubsystem* Progression = GetSubsystem<UProgressionSubsystem>();
    Progression->Initialize();
    
    UProfileInventorySubsystem* ProfileInventory = GetSubsystem<UProfileInventorySubsystem>();
    ProfileInventory->Initialize();
    
    UTutorialSubsystem* Tutorial = GetSubsystem<UTutorialSubsystem>();
    Tutorial->Initialize();
    
    UShopSubsystem* Shop = GetSubsystem<UShopSubsystem>();
    Shop->Initialize();
    
    // Level 3: Advanced
    UMatchmakingSubsystem* Matchmaking = GetSubsystem<UMatchmakingSubsystem>();
    Matchmaking->Initialize();
}
```

---

## 7. Plugin Dependencies

### SimpleCarPhysics Plugin
- **Used By**: Racing Car Physics
- **Depends On**: None
- **Type**: Core Gameplay

### Nakama Plugin
- **Used By**: Multiplayer, Progression (cloud sync)
- **Depends On**: None
- **Type**: Backend Service

### Edgegap Plugin
- **Used By**: Multiplayer
- **Depends On**: Nakama (for matchmaking)
- **Type**: Server Hosting

### Minimap Plugin
- **Used By**: UI/UX, Racing Physics
- **Depends On**: None
- **Type**: UI Enhancement

### RTune Plugin
- **Used By**: Car Customization, Racing Physics
- **Depends On**: None
- **Type**: Vehicle Tuning

### Rive Plugin
- **Used By**: UI/UX
- **Depends On**: None
- **Type**: UI Animation

### AsyncTickPhysics Plugin
- **Used By**: Racing Physics, Mobile Optimization
- **Depends On**: None
- **Type**: Performance Optimization

---

## 8. Data Flow Dependencies

### Save Game Data Flow
```
Progression → Save Game ← Customization
                ↓
            Settings
                ↓
            Shop (Currency)
```

### Network Data Flow
```
Multiplayer → Nakama → Edgegap
    ↓
Racing Physics (Replication)
    ↓
Customization (Visual Sync)
```

### UI Data Flow
```
All Features → Event Dispatchers → UI Widgets
```

---

## 9. Build Dependencies

### Module Dependencies

**PrototypeRacing (Primary Module)**:
- Depends on: UMG, Slate, SlateCore, OnlineSubsystem, OnlineSubsystemUtils

**SimpleCarPhysics**:
- Depends on: PhysicsCore, Chaos

**Nakama**:
- Depends on: HTTP, Json, JsonUtilities

**Edgegap**:
- Depends on: HTTP, Json

---

## 10. Testing Dependencies

### Unit Test Dependencies
- Each feature can be tested independently
- Mock subsystems for isolated testing

### Integration Test Dependencies
- **Racing Physics + Customization**: Test performance modifications
- **Progression + Shop**: Test currency transactions
- **Multiplayer + Racing Physics**: Test network synchronization

### End-to-End Test Dependencies
- All features required for full gameplay test

---

## Dependency Management Best Practices

### 1. Minimize Dependencies
- Keep features as independent as possible
- Use interfaces for loose coupling

### 2. Clear Dependency Direction
- Higher-level features depend on lower-level features
- Avoid circular dependencies

### 3. Event-Driven Communication
- Use Event Dispatchers for cross-feature communication
- Avoid direct function calls across features

### 4. Subsystem Pattern
- Use UGameInstanceSubsystem for global access
- Initialize in correct order

### 5. Interface-Based Design
- Define interfaces for feature contracts
- Implement interfaces in concrete classes

---

## Conclusion

Understanding feature dependencies is critical for:
- **Development Planning**: Build features in correct order
- **Testing Strategy**: Test dependencies before dependents
- **Refactoring**: Understand impact of changes
- **Team Coordination**: Avoid conflicts and blockers

Refer to this matrix when planning feature development, refactoring, or debugging cross-feature issues.

