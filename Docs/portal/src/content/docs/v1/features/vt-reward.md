---
title: VT-REWARD — Reward
description: "Thiết kế chi tiết: roll reward token, loot crate
  (Common/UnCommon/Rare), achievement, thử thách fan-service trong đua và phần
  thưởng hoàn thành city goal."
slug: v1/features/vt-reward
---

> Nguồn: `Docs/audit/VT-REWARD_reward.md`, `Docs/c4/model.c4`. View Structurizr: `VT_REWARD_Components`.

> Sơ đồ: xem trang [Architecture](/v1/architecture/) (view LikeC4 `vtReward`).

## Tổng quan

VT-REWARD sở hữu việc tính reward token/kết quả, phân phối loot crate (Common / UnCommon / Rare theo OP #230/#293), cập nhật tiến độ achievement và kiểm tra thử thách fan-service trong đua. SUP-INV và SUP-PROF mới là nơi lưu item và tiền tệ thật sự; VT-REWARD chỉ tính toán và dispatch.

## Phạm vi

VT-REWARD được gọi bởi VT-CITY (hoàn thành goal và unlock city) và bởi luồng kết thúc đua DM-RACE thông qua `UProgressionCenterSubsystem`.

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `URewardCenterSubsystem` | `RewardCenterSubsystem.cpp:219` | Roll loot, resolve item reward, cấp cash reward, dispatch sang collaborator. |
| `GrantGoalCompletionRewards` | `RewardCenterSubsystem.cpp:678` | Tính item + cash reward cho goal hoàn thành; broadcast delegates UI. |
| `CalculateGoalItemReward` | `RewardCenterSubsystem.cpp:518` | Resolve LootCrate tier theo city + goal tier → `FRewardBatchResult`. |
| `DistributeRewards` | `RewardCenterSubsystem.cpp:647` | Dispatch item sang SUP-INV, currency sang SUP-PROF. |
| `UAchievementSubsystem` | `AchievementSubsystem.cpp` | Cập nhật counter achievement khi hoàn thành đua. |
| `UFanServiceSubsystem` | `FanServiceSubsystem.cpp:75` | Drift/fly/speed in-race challenge check. |

## Luồng xử lý

`UProgressionCenterSubsystem::HandleRaceCompleted` → reward centre roll → cập nhật achievement → đánh giá kết quả fan-service. Cho goal reward cụ thể: `ProgressionSubsystem::GrantRewardsForCompletedGoal` → `GrantGoalCompletionRewards(CityID, CityIndex, GoalTier)`.

## Điểm nóng hiệu năng

`RewardCenterSubsystem.cpp:219` và `ProgressionCenterSubsystem.cpp:489` có `LoadSynchronous` icon — block game thread tại màn kết quả đua (thời điểm nhạy cảm nhất: outro + progression compute chạy cùng lúc). `FindRow` trong filter reward pool (dòng 124/202/670) là O(candidates) per roll. Fan-service sampling tần suất chưa xác nhận sau dòng 120 — cần kiểm tra trước khi ship.

## API công khai

Entry point đã xác minh: `GrantGoalCompletionRewards(FName, int32, ECityGoalTier)`, `OnGoalItemRewardCalculated` (delegate), `OnGoalCashRewardCalculated` (delegate), `OnItemRewardGranted` (delegate), `UAchievementSubsystem` update post-race, `AddFanService(TrackId)` / `HandleCompleteFanService`.

## Phần chưa kiểm chứng

Schema đầy đủ bảng reward, mapping LootCrate tier theo OP #230/#293 và danh sách event achievement chính xác cần đọc từ `RewardCenterSubsystem.h` DataTable headers trước khi reimplementation. Tần suất fan-service sampling cần xác minh (xem audit).

## Tham chiếu

* Audit: `Docs/audit/VT-REWARD_reward.md`
* LD: `Docs/ld/VT-REWARD_reward.md`
* Structurizr: `VT_REWARD_Components`
