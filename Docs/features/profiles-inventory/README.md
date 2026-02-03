---
phase: overview
title: Profiles & Inventory Feature
description: Player profile and inventory management system
feature_id: profiles-inventory
status: development
priority: high
owner: Backend Team
last_updated: 2026-01-26
---

# Profiles & Inventory Feature

**Breadcrumbs:** [Docs](../../../) > [Features](../) > Profiles & Inventory

**Feature ID**: `profiles-inventory`  
**Status**: 🔄 Development  
**Priority**: High  
**Owner**: Backend Team  
**Version**: 1.1.0
**Date**: 2026-01-26
**Source of Truth**: `PrototypeRacing/Source/PrototypeRacing/Private/InventorySystem/`

---

## Overview

Hệ thống Profiles & Inventory quản lý thông tin người chơi (profile, stats, currency) và hệ thống inventory (items, equipment). Đã được triển khai hoàn chỉnh với khả năng mở rộng cho Nakama sync.

### Implementation Status

| Component | Status | Location |
|-----------|--------|----------|
| ProfileManagerSubsystem | ✅ Done | `BackendSubsystem/ProfileManagerSubsystem.h` |
| InventoryManager | ✅ Done | `InventorySystem/InventoryManager.h` |
| ItemDatabase | ✅ Done | `InventorySystem/ItemDatabase.h` |
| ProfileInventorySaveGame | ✅ Done | `BackendSubsystem/ProfileInventorySaveGame.h` |
| Profanity Filter | ✅ Done | Built into ProfileManagerSubsystem |
| Currency System | ✅ Done | Built into ProfileManagerSubsystem |

---

## Core Components (từ Source Code)

### UProfileManagerSubsystem
**File**: `BackendSubsystem/ProfileManagerSubsystem.h`  
**Base**: `UGameInstanceSubsystem`

Quản lý:
- Player profile (name, avatar, VIP status)
- Stats (online time, top speed, race results)
- Currency (Cash, Coin)
- Unlock progress (Cars, Tracks, Cities)
- Name validation với profanity filter

### UInventoryManager
**File**: `InventorySystem/InventoryManager.h`  
**Base**: `UGameInstanceSubsystem`

Quản lý:
- Item storage (TMap<FString, FInventoryItem>)
- Add/Remove items
- Equipped/Favorite status
- Max 999 items per stack, 200 unique items

### UItemDatabase
**File**: `InventorySystem/ItemDatabase.h`  
**Base**: `UObject`

Quản lý:
- Item definitions từ DataTable
- Item lookup cache
- Item type/rarity queries

---

## Key Data Structures

### FPlayerProfileData
```cpp
struct FPlayerProfileData
{
    FText PlayerName;
    FName PlayerID;
    FName AvatarID;
    int32 PlayerLevel;
    FPlayerCurrency PlayerCurrency;
    EVIPStatus VIPStatus;
    
    // Stats
    float OnlineTime, TopSpeed, TotalRaceTime;
    int32 TotalRaces;
    float WinRate;
    int32 FirstPlaceCount, SecondPlaceCount, ThirdPlaceCount, OtherPlaceCount;
    
    // Unlock Progress
    FUnlockProgress UnlockedCarProgress, UnlockedTrackProgress, UnlockedCityProgress;
    
    // Economy
    int32 TotalCashEarned, TotalCashSpent;
};
```

### FInventoryItem
```cpp
struct FInventoryItem
{
    FString ItemID;
    int32 Quantity;
    FDateTime AcquiredDate;
    FString AcquisitionSource;
    bool bIsEquipped;
    bool bIsFavorite;
    int32 UsageCount;
};
```

### EItemType
```cpp
enum class EItemType : uint8
{
    CarVisual,        // CCV
    CarPerformance,   // CCP
    LootCrate,        // LC
    Ticket,
    Currency,
    Other
};
```

---

## Quick Links

### Design (Source of Truth)
- [TDD_ProfilesInventory.md](design/TDD_ProfilesInventory.md) - ⭐ Technical Design Document

### Requirements
- [Requirements README](requirements/README.md) - User stories
- [UserProfile_Inventory_V5.md](requirements/UserProfile_Inventory_V5.md) - Full GDD
- [Items_V5.md](requirements/Items_V5.md) - Items Definition

### Implementation
- [Implementation README](implementation/README.md) - Code guide

### Planning
- [Planning README](planning/README.md) - Task breakdown
- [ProfileInventory_Tasks.csv](planning/ProfileInventory_Tasks.csv) - Tasks CSV

---

## Dependencies

### Internal
- **CarCustomizationSystem**: Car unlock progress
- **ProgressionSystem**: Track/City unlock progress
- **CarSaveGameManager**: Save management

### External
- **DataTables**: Avatar, ForbiddenWords, ItemDefinitions

---

**Version**: 1.1.0
**Last Review**: 2026-01-26
