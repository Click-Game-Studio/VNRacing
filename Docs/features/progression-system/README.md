---
phase: overview
title: Progression System Feature
description: Core player advancement mechanics for VNRacing
feature_id: progression-system
status: development
priority: critical
owner: Game Design Team
last_updated: 2026-01-26
---

# Progression System Feature

**Breadcrumbs:** [Docs](../../../) > [Features](../) > Progression System

**Feature ID**: `progression-system`
**Status**: 🔄 Development
**Priority**: Critical
**Owner**: Game Design Team
**Version**: 1.0.1
**Date**: 2026-01-26
**Source of Truth**: Source Code

---

## Implementation Status

### ✅ IMPLEMENTED
- **VN-Tour Campaign** - 5 cities hierarchy (Hà Nội, TP.HCM, Đà Nẵng, Huế, Hội An)
- **Track/City Unlock System** - RequiredTopRank = 3 (Top 3 finish unlocks next track)
- **Fan Service Missions** - 6 types (DriftMaster, CleanRacer, FlyCar, SpeedDemon, CertainExpectation, NoDrift)
- **Basic Achievement System** - 4 categories (VNTour, Racing, CarRating, FanService)
- **Fuel System** - MaxFuel = 5, RefillTime = 1800s (30 minutes per fuel)
- **Race Reward System** - Position-based rewards with Fan Service bonuses
- **Performance Gate** - Car rating requirements for track difficulty

### ⏳ PLANNED - NOT IMPLEMENTED
- **Player Level/XP System** - Documented Level 1-100, XPToNextLevel = 1000
- **Seasonal/Battle Pass System** - 100 tiers per season, free/premium tracks
- **Club System** - Up to 50 members, club challenges
- **Leaderboard System** - Global, regional, friend rankings
- **Offline Progression** - Idle rewards, offline race simulation
- **Multiple Currencies** - Gems, Fame Points, Seasonal Tokens (only Coins implemented)
- **Cloud Sync** - Cloud save with conflict resolution
- **Daily Login Bonuses** - Escalating rewards system

> **Last synced with source code: 2026-01-26**

---

## Overview

The Progression System provides the core player advancement mechanics for PrototypeRacing, featuring a unique **VN-Tour Campaign** that takes players through 5 iconic Vietnamese cities. Players earn coins, unlock tracks/cities, complete Fan Service missions, and progress through culturally-rich racing challenges.

### Key Capabilities (Implemented)

- **VN-Tour Campaign**: 5 cities (Hà Nội, TP.HCM, Đà Nẵng, Huế, Hội An) with hierarchical City → Area → Track structure
- **Track Unlock System**: Progressive track unlocking based on race ranking
- **City Unlock System**: Cup-based city unlocking (earn cups by completing areas)
- **Fan Service Missions**: In-race challenges (Drift Master, Clean Racer, Speed Demon, etc.)
- **Achievement System**: Category-based achievements with progress tracking
- **Performance Gate**: Car rating requirements for track difficulty
- **Fuel System**: Energy system with recharge mechanics
- **Reward System**: Position-based coin rewards with Fan Service bonuses

---

## Feature Structure

```
progression-system/
├── requirements/       # User stories, VN-Tour specs, progression mechanics
├── design/            # Architecture, data models, subsystem design
├── planning/          # Implementation roadmap, milestones
├── implementation/    # Code patterns, integration notes
└── testing/           # Progression testing, validation
```

---

## Quick Links

### Design (Source Code Synced)
- [Progression System Architecture](design/progression-system-architecture.md) - Core architecture, subsystems, data structures
- [Player Info HUD Architecture](design/player-info-hud-architecture.md) - HUD components for race info display

### Requirements
- [Data Structure Definitions](requirements/Data_Structure_Definitions.md) - Detailed struct definitions
- [VN-Tour Game Mode](requirements/vn-tour-gamemode.md) - Game mode specifications
- [Technical Implementation Specs](requirements/Technical_Implementation_Specs.md) - Technical details

---

## Core Architecture

### Subsystem Overview

| Subsystem | Purpose | File Location |
|-----------|---------|---------------|
| **UProgressionCenterSubsystem** | Central facade implementing `IProgressionDataProvider` | `BackendSubsystem/Progression/` |
| **UProgressionSubsystem** | VN-Tour data management, unlock logic | `BackendSubsystem/Progression/` |
| **UFanServiceSubsystem** | In-race mission tracking | `BackendSubsystem/Progression/` |
| **UAchievementSubsystem** | Achievement progress management | `BackendSubsystem/Progression/` |
| **UCarRatingSubsystem** | Performance gate calculation | `BackendSubsystem/Progression/` |
| **URaceSessionSubsystem** | Race session, player profile, fuel | `BackendSubsystem/` |

### Data Hierarchy

```
FVNTourProgressionData
├── TArray<FCityProgress>
│   ├── FLocationInfo (ID, Name, bIsUnlocked)
│   ├── FCityUnlockData (RequiredCupsToUnlock)
│   ├── CurrentCup
│   └── TArray<FAreaProgress>
│       ├── FLocationInfo
│       ├── FPerformanceGateRequirement
│       ├── bHasEarnedCup
│       └── TArray<FTrackProgress>
│           ├── FLocationInfo
│           ├── ETrackDifficulty
│           ├── FFanServiceData
│           ├── FRaceTime BestTime
│           ├── int BestRanking
│           ├── TArray<FTrackProgressionState> RaceHistory
│           └── FProgressMetadata (Level, RaceMode, Reward)
├── TotalRaces
└── TotalWin
```

---

## Unlock System

### Track Unlock Logic
```cpp
// From FTrackProgress::CanUnlockNext()
bool CanUnlockNext() const {
    return GetLastRace()->AchievedRank <= RequiredUnlockData.RequiredTopRank;
}
// Default: RequiredTopRank = 3 (Top 3 finish unlocks next track)
```

### City Unlock Logic
```cpp
// From FCityProgress::CanUnlockNextCity()
bool CanUnlockNextCity() const {
    return CurrentCup >= CityUnlockData.RequiredCupsToUnlock;
}
// Cups earned by completing all tracks in an area with 1st place
```

### Area Cup Logic
```cpp
// From FAreaProgress::CanReceiveCup()
bool CanReceiveCup() {
    for (FTrackProgress TrackProgress : Tracks) {
        if (TrackProgress.BestRanking != 1) return false;
    }
    return true;
}
```

---

## Fan Service Missions

### Mission Types

| Type | Description | Check Method |
|------|-------------|--------------|
| **DriftMaster** | Drift for extended time | Continuous drift tracking |
| **CleanRacer** | Complete without collisions | Collision detection |
| **FlyCar** | Accumulate airborne time | Ground contact check |
| **SpeedDemon** | Maintain high speed | Speed threshold |
| **CertainExpectation** | Achieve specific ranking | Final position check |
| **NoDrift** | Complete without drifting | Drift state monitoring |

### Mission Flow
```cpp
// Start mission tracking
UFanServiceSubsystem::StartProgressCheck(EFanServiceTypeCheck Type);

// During race - progress updates broadcast
OnFanServiceProgressUpdate.Broadcast(FFanServiceProgressData);

// End race - check completion
bool IsFanServiceCompleted();
```

---

## Fuel System

### Configuration
```cpp
// From URaceSessionSubsystem
UPROPERTY()
FFuelTicks FuelTicks;  // MaxFuel = 5, CurrentFuel = 5

UPROPERTY()
int FuelRefillTime = 1800;  // 30 minutes per fuel
```

### Events
```cpp
UPROPERTY(BlueprintCallable, BlueprintAssignable)
FOnFuelChange OnFuelChange;

UPROPERTY(BlueprintCallable, BlueprintAssignable)
FOnFuelRechargeTimeUpdated OnFuelRechargeTimeUpdated;

UPROPERTY(BlueprintCallable, BlueprintAssignable)
FOnFuelRechargeTimeEnd OnFuelRechargeTimeEnd;
```

---

## Reward System

### Race Reward Calculation
```cpp
// Position-based rewards calculated in UProgressionSubsystem
void CalculateRaceReward(
    const float& InBonus,      // Bonus multiplier
    const int32& TrackId,      // Current track
    const int32& InRanking,    // Finish position
    FPlayerRaceReward& OutPlayerRaceReward
);

// Reward structure
struct FPlayerRaceReward {
    int32 PositionCash;     // Based on finish position
    int32 FanServiceCash;   // Bonus for completing mission
    int32 WatchAdsCash;     // Optional ad reward
    int TotalCash;          // Sum of all rewards
};
```

---

## Save System

### Save Slots
| Data | Save Name | Subsystem |
|------|-----------|-----------|
| VN-Tour Progress | `ProgressionSystem` | UProgressionSubsystem |
| Achievements | `AchievementSystem` | UAchievementSubsystem |
| Player Profile | `Profile` | URaceSessionSubsystem |
| Fuel State | `FuelTicks` | URaceSessionSubsystem |

### Save Game Class
```cpp
// UProgressionSaveGame stores all progression data
class UProgressionSaveGame : public USaveGame {
    FVNTourProgressionData TourProgressionData;
    FAchievementData AchievementData;
    FPlayerProfile PlayerProfile;
    FFuelTicks FuelTicks;
};
```

---

## Dependencies

### Internal Dependencies
- **Car Customization**: `UCarCustomizationManager` for performance stats
- **Profiles & Inventory**: `UProfileManagerSubsystem` for player data
- **Race Mode**: `ARaceTrackManager` for race events

### External Dependencies
- **UCarSaveGameManager**: Save/Load operations
- **DataTables**: City/Area/Track/Map definitions

---

## Performance Targets

| Metric | Target | Status |
|--------|--------|--------|
| **Save Time** | <500ms | ✅ |
| **Load Time** | <1s | ✅ |
| **Memory Usage** | <100 KB | ✅ |

---

## Related Features

- [Racing Car Physics](../racing-car-physics/README.md) - Race mechanics
- [Car Customization](../car-customization/README.md) - Performance stats for rating
- [Profiles & Inventory](../profiles-inventory/README.md) - Player data management

---

## Source Code References

| Component | File Path |
|-----------|-----------|
| ProgressionCenterSubsystem | `Public/BackendSubsystem/Progression/ProgressionCenterSubsystem.h` |
| ProgressionSubsystem | `Public/BackendSubsystem/Progression/ProgressionSubsystem.h` |
| FanServiceSubsystem | `Public/BackendSubsystem/Progression/FanServiceSubsystem.h` |
| AchievementSubsystem | `Public/BackendSubsystem/Progression/AchievementSubsystem.h` |
| CarRatingSubsystem | `Public/BackendSubsystem/Progression/CarRatingSubsystem.h` |
| RaceSessionSubsystem | `Public/BackendSubsystem/RaceSessionSubsystem.h` |
| ProgressionData | `Public/ProgressionSystem/DataStructures/ProgressionData.h` |
| ProgressionSaveGame | `Public/ProgressionSystem/ProgressionSaveGame.h` |
| IProgressionDataProvider | `Public/ProgressionSystem/ProgressionDataProvider.h` |

---

**Last Review**: 2026-01-26
**Next Review**: 2026-02-26
**Version**: 1.0.1

