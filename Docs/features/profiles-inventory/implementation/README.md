---
phase: implementation
title: Profiles & Inventory Implementation
description: Code documentation và implementation guide
source_of_truth: PrototypeRacing/Source/PrototypeRacing/Public/
---

# Profiles & Inventory Implementation

**Feature ID**: `profiles-inventory`  
**Date**: 2026-01-26
**Status**: 🔄 Development

---

## Code Structure (Actual)

```
PrototypeRacing/Source/PrototypeRacing/
├── Public/
│   ├── BackendSubsystem/
│   │   ├── ProfileManagerSubsystem.h    # Core profile management
│   │   └── ProfileInventorySaveGame.h   # SaveGame class
│   └── InventorySystem/
│       ├── InventoryManager.h           # Inventory management
│       └── ItemDatabase.h               # Item definitions
└── Private/
    ├── BackendSubsystem/
    │   ├── ProfileManagerSubsystem.cpp
    │   └── ProfileInventorySaveGame.cpp
    └── InventorySystem/
        ├── InventoryManager.cpp
        └── ItemDatabase.cpp
```

---

## Quick Start

### 1. Setup Profile System

```cpp
// Trong GameInstance hoặc GameMode
UProfileManagerSubsystem* ProfileManager = GetGameInstance()->GetSubsystem<UProfileManagerSubsystem>();

// Setup với DataTables
ProfileManager->SetupProfileData(AvatarDataTable, ForbiddenWordDataTable);

// Init player ID
if (ProfileManager->GetProfileData().PlayerID.IsNone())
{
    ProfileManager->InitPlayerId(UProfileManagerSubsystem::GeneratePlayerId());
}
```

### 2. Update Player Name

```cpp
// Bind events
ProfileManager->OnPlayerNameUpdateSuccess.AddDynamic(this, &AMyClass::OnNameSuccess);
ProfileManager->OnPlayerNameUpdateFail.AddDynamic(this, &AMyClass::OnNameFail);

// Update
ProfileManager->UpdatePlayerName(FText::FromString(TEXT("NewName")));
```

### 3. Currency Management

```cpp
// Earn
ProfileManager->EarnCurrency(1000, ECurrencyType::Cash);

// Spend (returns false if not enough)
if (ProfileManager->SpendCurrency(500, ECurrencyType::Cash))
{
    // Success
}

// Check
int32 Balance = ProfileManager->GetCurrentCurrencyByType(ECurrencyType::Cash);
```

### 4. Inventory Management

```cpp
UInventoryManager* InventoryManager = GetGameInstance()->GetSubsystem<UInventoryManager>();

// Add item
InventoryManager->AddItem(TEXT("CCP_LV4_001"), 5, TEXT("race_reward"));

// Check
if (InventoryManager->HasItem(TEXT("CCP_LV4_001"), 3))
{
    // Has at least 3
}

// Remove
InventoryManager->RemoveItem(TEXT("CCP_LV4_001"), 2);

// Get by type
TArray<FInventoryItem> Items = InventoryManager->GetItemsByType(EItemType::CarPerformance);
```

### 5. Race Stats Update

```cpp
ProfileManager->AddTotalRaces(1);
ProfileManager->AddRaceRank(ERaceRank::FirstPlace);
ProfileManager->AddRaceTime(RaceTimeSeconds);
ProfileManager->UpdateTopSpeed(MaxSpeed);
```

---

## Key Events

### ProfileManagerSubsystem

| Event | Signature | When |
|-------|-----------|------|
| `OnProfileUpdated` | `FPlayerProfileData` | Profile changed |
| `OnPlayerNameUpdateSuccess` | `void` | Name update success |
| `OnPlayerNameUpdateFail` | `TArray<EUpdateFailReason>` | Name update failed |
| `OnCurrencyChanged` | `ECurrencyType, int32` | Currency changed |
| `OnNotEnoughCurrency` | `ECurrencyType, int32` | Not enough currency |

### InventoryManager

| Event | Signature | When |
|-------|-----------|------|
| `OnInventoryUpdated` | `void` | Inventory changed |
| `OnItemAdded` | `FString, int32, FInventoryItem` | Item added |
| `OnItemRemoved` | `FString, int32, FInventoryItem` | Item removed |

---

## Name Validation

### Validation Rules

| Rule | Constraint | Error |
|------|------------|-------|
| Length | 3-20 chars | `NameTooShort` / `NameTooLong` |
| Format | Alphanumeric + spaces | `NameContainsSpecialChar` |
| Profanity | No bad words | `ContainsForbiddenWord` |

### Profanity Filter

- Case-insensitive
- Leetspeak detection (a→4, e→3, i→1, o→0, s→5, t→7)
- Partial word matching
- Vietnamese + English bad words

---

## DataTables Required

### Avatar DataTable
- Row Struct: `FAvatarDefinition`
- Columns: `AvatarId`, `Avatar`

### Forbidden Words DataTable
- Row Struct: `FForbiddenWordDefinition`
- Columns: `Word`

### Item Definitions DataTable
- Row Struct: `FItemDefinition`
- Columns: `ItemID`, `DisplayName`, `Description`, `ItemType`, `Rarity`, `bIsStackable`, `Icon`, etc.

---

## Limits

| Limit | Value |
|-------|-------|
| Max Items per stack | 999 |
| Max Unique Items | 200 |
| Name length | 3-20 chars |

---

## References

- [TDD_ProfilesInventory.md](../design/TDD_ProfilesInventory.md) - Technical Design
- [Requirements](../requirements/README.md) - User stories
