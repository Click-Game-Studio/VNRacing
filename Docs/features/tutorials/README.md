# Tutorial System

**Version:** 1.0.0 | **Date:** 2026-01-20 | **Status:** Development

![Status: Development](https://img.shields.io/badge/Status-Development-blue)

**Breadcrumbs:** [Docs](../../) > [Features](../) > Tutorials

**Feature ID**: `tutorials`  
**Priority**: High  
**Owner**: UX Team

---

## Feature Structure

```
tutorials/
├── requirements/       # User stories, tutorial specifications
├── design/            # Tutorial architecture, widget design
├── planning/          # Implementation roadmap
├── implementation/    # Tutorial system code patterns
└── testing/           # Tutorial testing procedures
```

**Source Code Location:** `Source/PrototypeRacing/Private/TutorialSystem/`

---

## Overview

The Tutorial System provides interactive onboarding for new players and contextual tooltips for game state changes. It uses slow motion, control locking, and screen masking to guide players through racing controls and game features.

## Implementation Status

| Component | Status | Notes |
|-----------|--------|-------|
| UTutorialManagerSubsystem | ✅ Done | Central tutorial management |
| UScriptTutorialWidget | ✅ Done | Interactive step-by-step tutorials |
| UTooltipTutorialWidget | ✅ Done | Passive tooltips with auto-dismiss |
| UTutorialSaveGame | ✅ Done | Persistence via UCarSaveGameManager |
| TriggerCondition System | ✅ Done | Flexible step completion triggers |
| Control Locking | ✅ Done | Lock/unlock specific controls |
| Object Pooling | ✅ Done | 3 tooltip widgets pooled |

## Tutorial Types

### Script Tutorials (Interactive)
| ID | Name | Steps | Trigger |
|----|------|-------|---------|
| BasicControls1 | Basic Controls 1 | 8 | First race, first curve |
| BasicControls2 | Basic Controls 2 | 2 | Second race, first drift |
| VnTourMap | VN Tour Map | 5 | After first race + profile |
| BasicCarUpgrade | Basic Car Upgrade | TBD | Upgrade available |
| AdvancedCarUpgrade | Advanced Car Upgrade | TBD | Pending |
| BasicCarCustomize | Basic Car Customize | TBD | Pending |

### Tooltips (Passive)
| Type | Message | Auto-Dismiss |
|------|---------|--------------|
| UpgradeAvailable | New Car Upgrade Available | 10s |
| OutOfFuel | You Are Out Of Fuel | 10s |
| NewShopItems | New Items Available In Shop | 10s |
| NewCityUnblock | New City Unlocked | 10s |
| NewItemRecieved | New Item Received | 10s |
| NewAchievement | New Achievement | 10s |

## Core Components

### UTutorialManagerSubsystem
- **Type**: `UGameInstanceSubsystem`
- **Location**: `Source/PrototypeRacing/Public/TutorialSystem/TutorialManagerSubsystem.h`
- **Purpose**: Central manager for tutorial state, triggers, and widget pooling

### UScriptTutorialWidget
- **Type**: `UPrototypeRacingUI`
- **Location**: `Source/PrototypeRacing/Public/TutorialSystem/ScriptTutorialWidget.h`
- **Purpose**: Interactive tutorials with slow motion and control locking

### UTooltipTutorialWidget
- **Type**: `UPrototypeRacingUI`
- **Location**: `Source/PrototypeRacing/Public/TutorialSystem/TooltipTutorialWidget.h`
- **Purpose**: Passive tooltips with auto-dismiss and object pooling

## Key Features

- **Slow Motion**: Time dilation (0.3x) during script tutorials
- **Control Locking**: Lock all controls except highlighted one
- **Screen Masking**: Black overlay on non-interactive areas
- **Auto-Dismiss**: Panels close after configured duration
- **Object Pooling**: 3 tooltip widgets pre-created
- **Event-Driven**: No tick-based updates (mobile performance)
- **Trigger Conditions**: Flexible step completion via UTriggerCondition

## Control Types

```cpp
ERacingControlType:
├── SteerLeft, SteerRight
├── Drift, NOS, NosBar, Brake
├── Speed, Menu, Fuel
├── CityMap, Area, Track, Next
└── Customize, Shop
```

## Related Documentation

- [Architecture](design/tutorials-architecture.md) - Technical design synced with source code
- [Requirements](requirements/README.md) - User stories and acceptance criteria
- [Original Spec](requirements/VN-Racing-Tutorials-V2.md) - Vietnamese specification
- [Planning](planning/README.md) - Implementation plan

## Dependencies

- `UCarSaveGameManager` - Save/load tutorial progress
- `ARaceTrackManager` - Race event triggers
- `UPrototypeRacingUI` - Base widget class

---

**Last Updated:** 2026-01-20
