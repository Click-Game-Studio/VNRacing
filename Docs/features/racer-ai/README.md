# Racer AI System

**Version:** 1.0.0 | **Date:** 2026-01-20 | **Status:** Development

![Status: Development](https://img.shields.io/badge/Status-Development-blue)

**Breadcrumbs:** [Docs](../../) > [Features](../) > Racer AI

**Feature ID**: `racer-ai`  
**Priority**: High  
**Owner**: AI Team

---

## Feature Structure

```
racer-ai/
├── requirements/       # AI specifications, difficulty profiles
├── design/            # AI architecture, behavior systems
├── planning/          # Implementation roadmap, task breakdown
├── implementation/    # AI code patterns, integration guide
└── testing/           # AI testing strategy, validation
```

**Source Code Location:** `Source/PrototypeRacing/Private/AISystem/`

**Plugin References:** `Plugins/SimpleCarPhysics/` (GuideLineSubsystem, SimulatePhysicsCar AI functions)

---

## Overview

The Racer AI system provides intelligent opponent behavior for racing gameplay. AI vehicles follow racing lines, adapt their performance through rubber banding, and compete with the player using configurable difficulty profiles.

## Implementation Status

| Component | Status | Notes |
|-----------|--------|-------|
| AIManagerSubsystem | ✅ Done | Central AI management |
| GuideLineSubsystem | ✅ Done | Lane-based navigation |
| PID Steering | ✅ Done | Built into SimulatePhysicsCar |
| Rubber Banding | ✅ Done | Distance-based performance scaling |
| Difficulty Profiles | ✅ Done | Easy/Medium/Hard with FAIDifficultyProfile |
| AI Name Generation | ✅ Done | DataTable-based per difficulty |
| AIDecisionComponent | ⏸️ In Progress | State machine for behaviors |
| Overtake/Defence | ⏸️ In Progress | Tactical maneuvers |

## Core Components

### UAIManagerSubsystem
- **Type**: `UGameInstanceSubsystem`
- **Location**: `Source/PrototypeRacing/Public/AISystem/AIManagerSubsystem.h`
- **Purpose**: Registers AI cars, configures performance based on player stats

### UGuideLineSubsystem
- **Type**: `UWorldSubsystem`
- **Location**: `Plugins/SimpleCarPhysics/Source/SimpleCarPhysics/Public/GuideLineSubsystem.h`
- **Purpose**: Manages 3 racing lines (Middle/Left/Right), tracks lane contenders

### ASimulatePhysicsCar AI Functions
- **Location**: `Plugins/SimpleCarPhysics/Source/SimpleCarPhysics/Public/PhysicsSimulateCar/SimulatePhysicsCar.h`
- **Key Properties**: `bIsAICar`, `bAutoDrive`, PID parameters, rubber band settings
- **Key Functions**: `AutoDrive()`, `CalculatePIDSteering()`, `ApplyRubberBandTuning()`

## Difficulty System

```
EAIDifficulty:
├── Easy (Rookie)   → 90% Performance, 20% Overtake, 40% Defence
├── Medium (Racer)  → 100% Performance, 50% Overtake, 70% Defence
└── Hard (Pro)      → 110% Performance, 80% Overtake, 90% Defence
```

## Rubber Banding

- **Activation Delay**: 10 seconds after race start
- **Distance Limits**: ±7000 units from player
- **Performance Scale**: 50% - 150% of base performance
- **Disabled When**: AI crashes (until speed > 100 km/h)

## Track Requirements

Each track requires 3 `ARoadGuide` actors:
1. **MiddleGuideActor** - Main racing line (optimal path)
2. **LeftGuideActor** - Inside racing line (tighter corners)
3. **RightGuideActor** - Outside racing line (wider corners)

## Related Documentation

- [Architecture](design/racer-ai-architecture.md) - Technical design and data models
- [Requirements](requirements/Racer_AI_V5.md) - GDD specifications
- [Implementation Guide](implementation/racer-ai-implementation-guide.md) - Code patterns
- [Planning](planning/racer-ai-implementation-plan.md) - Task breakdown

## Dependencies

- `SimpleCarPhysics` plugin
- `CarCustomizationManager` subsystem
- `RaceTrackManager` for difficulty distribution

---

**Last Updated:** 2026-01-20
