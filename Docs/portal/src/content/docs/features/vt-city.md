---
title: "VT-CITY — City Progression"
description: "Thiết kế chi tiết: hệ thống tiến trình city, pool mục tiêu theo tier, mở khóa city tiếp theo, car unlock và map scene unlock."
---

> Nguồn: `Docs/audit/VT-CITY_city_progression.md`, `Docs/c4/model.c4`. View Structurizr: `VT_CITY_Components`.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `vtCity`).

## Tổng quan

VT-CITY sở hữu toàn bộ hệ thống city-goals và chuỗi unlock city trong VN Tour. Nó quản lý phân cấp city/area/track, giao pool mục tiêu cho city mới, theo dõi hoàn thành mục tiêu theo tier, mở khóa city tiếp theo và điều phối phần thưởng. VT-CITY cũng bao gồm Car Unlock (#337) và Map Scene Unlock (#339).

## Phạm vi

VT-CITY lấy kết quả đua từ DM-RACE rồi phối hợp với VT-REWARD để tính phần thưởng. Quy tắc mở khóa track nằm ở VT-TRACK; cổng CR xe nằm ở VT-CARPROG.

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `UProgressionCenterSubsystem` | `ProgressionCenterSubsystem.cpp:94` | Facade nhận kết quả đua, khởi động chuỗi kiểm tra goal. |
| `UProgressionSubsystem` | file 2641 dòng | Dữ liệu VN Tour, trạng thái goal pool và unlock chain. |
| `SetupCityGoalPoolTable` | `ProgressionSubsystem.cpp:2150` | Parse DataTable `CityGoalPool` → `GoalsByTier` (Tier1/Tier2/Tier3). |
| `BuildAssignedGoalsForNewCity` | `ProgressionSubsystem.cpp:2192` | Chọn ngẫu nhiên 1 goal mỗi tier, trả 3 `FCityAssignedGoalState`. |
| `CheckCityGoalsAndUnlockNextCity` | `ProgressionSubsystem.cpp:1352` | Kiểm tra điều kiện, gọi `HandleUnlockNextCity` nếu đủ. |
| `HandleUnlockNextCity` | `ProgressionSubsystem.cpp:1299` | Mở city tiếp theo, grant rewards, assign goals, broadcast `OnCityUnlocked`. |
| `GrantRewardsForCompletedGoal` | `ProgressionSubsystem.cpp:1336` | Gọi `URewardCenterSubsystem::GrantGoalCompletionRewards`. |
| `EnsureGarageCarsFromProgression` | `ProgressionDebugManager.cpp:476/2163` | Car Unlock (#337): đồng bộ garage sau unlock city. |
| `JumpToCity` / `UnlockAllLocations` | `ProgressionDebugManager.cpp:1681/2097`; `ProgressionSubsystem.cpp:2109` | Map Scene Unlock (#339): debug — nhảy city hoặc mở tất cả địa điểm. |

## Luồng xử lý

DM-RACE gọi `HandleRaceCompleted` → `HandleRecordRaceResult` → `ProcessCurrentCityGoals` → `CheckCityGoalsAndUnlockNextCity`. Khi unlock: `HandleUnlockNextCity` → grant rewards + assign goals mới + `OnCityUnlocked.Broadcast`. UI đăng ký `OnCityUnlocked` để trigger introduce-scene.

## Điểm nóng hiệu năng

`ProgressionCenterSubsystem.cpp:489` có `LoadSynchronous` icon city/track — block game thread khi mở màn VN Tour. `UProgressionSubsystem` là god-object 2641 dòng; magic string DataTable key `"ProgressionData"` tại dòng 1813.

## API công khai

Entry point đã xác minh: `SetupCityGoalPoolTable`, `BuildAssignedGoalsForNewCity`, `CheckCityGoalsAndUnlockNextCity`, `HandleUnlockNextCity`, `GrantRewardsForCompletedGoal`, `OnCityUnlocked` delegate, debug `JumpToCity` / `UnlockAllLocations`.

## Sub-tính năng

- **Goals Unlock (#331)** — `CheckCityGoalsAndUnlockNextCity` + `HandleUnlockNextCity`.
- **Goals Config (#333)** — `SetupCityGoalPoolTable` + `BuildAssignedGoalsForNewCity` + `ECityGoalTier`.
- **Goals Reward (#340)** — `GrantRewardsForCompletedGoal` → `RewardCenterSubsystem::GrantGoalCompletionRewards`.
- **Car Unlock (#337)** — `EnsureGarageCarsFromProgression` sau city unlock.
- **Map Scene Unlock (#339)** — `OnCityUnlocked` trigger + debug tools.

## Tham chiếu

- Audit: `Docs/audit/VT-CITY_city_progression.md`
- LD: `Docs/ld/VT-CITY_city_progression.md`
- Structurizr: `VT_CITY_Components`
