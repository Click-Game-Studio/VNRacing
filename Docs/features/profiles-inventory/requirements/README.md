---
phase: requirements
title: Profiles & Inventory Requirements
description: User stories và acceptance criteria cho hệ thống Profiles & Inventory (Offline MVP)
---

# Profiles & Inventory Requirements

**Feature ID**: `profiles-inventory`  
**Date**: 2025-12-15  
**Status**: Planning Complete  
**Scope**: Offline MVP (2-3 days, 3 devs)

---

## Scope Definition

### In Scope (MVP)
- ✅ Offline mode với Local Storage
- ✅ Player Profile: đặt tên, đổi avatar, xem stats
- ✅ Profanity filter cho tên người chơi
- ✅ Basic Inventory: hiển thị items đã sở hữu
- ✅ All items unlocked by default
- ✅ Stackable items default quantity: 999
- ✅ Race rewards integration (basic)
- ✅ Data structure compatible với Nakama (future)

### Out of Scope (Future)
- ❌ Online sync với Nakama
- ❌ VIP Status / Purchase
- ❌ Cross-platform economy
- ❌ Trading system
- ❌ Crafting/Disenchant

---

## User Stories

### Player Profile

| ID | User Story | Priority | MVP |
|----|------------|----------|-----|
| PI-US-001 | Là người chơi, tôi muốn đặt tên cho profile của mình | High | ✅ |
| PI-US-002 | Là người chơi, tôi muốn đổi avatar | High | ✅ |
| PI-US-003 | Là người chơi, tôi muốn xem stats đua xe | Medium | ✅ |
| PI-US-004 | Là người chơi, tôi muốn xem unlock info (Cars/Tracks/Cities) | Medium | ✅ |
| PI-US-005 | Là người chơi, tôi muốn copy PlayerID | Low | ✅ |

### Inventory

| ID | User Story | Priority | MVP |
|----|------------|----------|-----|
| PI-US-010 | Là người chơi, tôi muốn xem danh sách items đang sở hữu | High | ✅ |
| PI-US-011 | Là người chơi, tôi muốn lọc items theo loại (Tab) | High | ✅ |
| PI-US-012 | Là người chơi, tôi muốn xem chi tiết từng item | Medium | ✅ |
| PI-US-013 | Là người chơi, tôi muốn nhận rewards từ race vào inventory | High | ✅ |

---

## Acceptance Criteria

### AC-001: Đặt tên người chơi
- [ ] Hiển thị input field cho tên
- [ ] Validate độ dài tên (3-20 ký tự)
- [ ] **Profanity filter**: Lọc từ ngữ thô tục (Vietnamese + English)
- [ ] Hiển thị error message nếu tên không hợp lệ
- [ ] Lưu tên vào Local Storage
- [ ] Tên được hiển thị ở Panel Generals

### AC-002: Đổi Avatar
- [ ] Hiển thị danh sách avatars có sẵn
- [ ] Cho phép chọn avatar mới
- [ ] Lưu avatar selection vào Local Storage
- [ ] Avatar được hiển thị ở Panel Generals

### AC-003: Xem Stats
- [ ] Hiển thị OnlineTime (tổng giờ chơi)
- [ ] Hiển thị TopSpeed đã đạt được
- [ ] Hiển thị TotalRaceTime
- [ ] Hiển thị RaceResults (Total Races, Wins, WinRate)
- [ ] Stats được cập nhật sau mỗi race

### AC-010: Inventory Display
- [ ] Hiển thị tất cả items (all unlocked)
- [ ] Stackable items hiển thị quantity (default 999)
- [ ] Non-stackable items hiển thị riêng lẻ
- [ ] Items được phân loại theo Tab

### AC-011: Item Tabs
- [ ] Tab: Upgrade Parts (CCP)
- [ ] Tab: Visual Parts (CCV)
- [ ] Tab: Loot Crates (LC)
- [ ] Tab: Other Items
- [ ] Chuyển đổi giữa các tabs

### AC-013: Race Rewards
- [ ] Nhận items từ race completion
- [ ] Cộng quantity cho stackable items
- [ ] Thêm item mới cho non-stackable
- [ ] Hiển thị reward notification

---

## Profanity Filter Requirements

### Vietnamese Bad Words (Sample)
```
đụ, địt, lồn, cặc, buồi, đéo, đĩ, cave, chó, ngu, 
khốn, đần, nát, thằng chó, con đĩ, đồ ngu, ...
```

### English Bad Words (Sample)
```
fuck, shit, ass, bitch, damn, crap, dick, pussy, ...
```

### Filter Rules
- Case-insensitive matching
- Partial word matching (e.g., "fuck" matches "fucker")
- Leetspeak detection (e.g., "f*ck", "sh1t")
- Return error message: "Tên chứa từ ngữ không phù hợp"

---

## Data Structure (Nakama-Compatible)

### Player Profile
```cpp
USTRUCT(BlueprintType)
struct FPlayerProfileData
{
    GENERATED_BODY()

    // Unique ID (generated locally, sync to Nakama later)
    UPROPERTY()
    FString PlayerID;

    UPROPERTY()
    FString PlayerName;

    UPROPERTY()
    FString AvatarID;

    // Stats
    UPROPERTY()
    float OnlineTimeSeconds = 0.0f;

    UPROPERTY()
    float TopSpeed = 0.0f;

    UPROPERTY()
    float TotalRaceTimeSeconds = 0.0f;

    UPROPERTY()
    int32 TotalRaces = 0;

    UPROPERTY()
    int32 TotalWins = 0;

    // Unlock Info
    UPROPERTY()
    int32 CarsUnlocked = 0;

    UPROPERTY()
    int32 TracksUnlocked = 0;

    UPROPERTY()
    int32 CitiesUnlocked = 0;

    // Timestamps (for future sync)
    UPROPERTY()
    FDateTime CreatedAt;

    UPROPERTY()
    FDateTime LastModified;
};
```

### Inventory Item
```cpp
USTRUCT(BlueprintType)
struct FInventoryItem
{
    GENERATED_BODY()

    UPROPERTY()
    FString ItemID;

    UPROPERTY()
    EItemType ItemType; // CCV, CCP, LC, Other

    UPROPERTY()
    int32 Quantity = 1;

    UPROPERTY()
    bool bIsStackable = true;

    UPROPERTY()
    FDateTime AcquiredDate;

    UPROPERTY()
    FString AcquisitionSource; // "default", "race_reward", "shop"
};
```

---

## References

- [UserProfile_Inventory_V5.md](UserProfile_Inventory_V5.md) - Full GDD
- [Items_V5.md](Items_V5.md) - Items Definition
- [Design](../design/README.md)
- [Planning](../planning/README.md)
