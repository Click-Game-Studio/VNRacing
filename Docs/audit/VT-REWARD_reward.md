# VT-REWARD — Reward

## Phạm vi
Roll reward token, phân phối loot crate (Common/UnCommon/Rare theo OP #230/#293), cập nhật tiến độ achievement, thử thách fan-service trong đua, và cấp phần thưởng khi hoàn thành city goal.

## Module/class C++ liên quan (file thật)
- `Source/PrototypeRacing/Private/BackendSubsystem/RewardCenterSubsystem.cpp` — `URewardCenterSubsystem`:
  - `GrantGoalCompletionRewards(FName CityID, int32 CityIndex, ECityGoalTier GoalTier)` (dòng 678): tính item reward (`CalculateGoalItemReward`) + cash reward (`CalculateGoalCashReward`); gọi `DistributeRewards` + `GrantCashReward`; broadcast `OnGoalItemRewardCalculated` / `OnGoalCashRewardCalculated`.
  - `CalculateGoalItemReward` (dòng 518): resolve LootCrate tier (Common/UnCommon/Rare) theo city + goal tier → `FRewardBatchResult`.
  - `DistributeRewards(TArray<FRewardResult>)` (dòng 647): dispatch item sang SUP-INV, currency sang SUP-PROF.
  - `CalculateGoalCashReward` (dòng 624): tính tiền mặt theo city index và goal tier.
  - `GrantCashReward` (dòng 592): gửi tiền sang SUP-PROF.
  - Điểm nóng dòng 219: `Result.ItemIcon = ItemDefinition.Icon.LoadSynchronous()` — load texture đồng bộ khi tạo kết quả reward.
  - Dòng 124, 202, 670: `FindRow` trong vòng lọc candidate reward pool.
- `Source/PrototypeRacing/Private/BackendSubsystem/Progression/AchievementSubsystem.cpp` — `UAchievementSubsystem`: cập nhật counter achievement khi hoàn thành đua, gọi từ `UProgressionCenterSubsystem`.
- `Source/PrototypeRacing/Private/BackendSubsystem/Progression/FanServiceSubsystem.cpp` — `UFanServiceSubsystem`:
  - `bShouldCheckProgress = true` (dòng 75): cờ bật check.
  - `AddFanService(TrackId)` (dòng 98–102): gọi `ProgressionSubsystem->GetTrackById(TrackId)` — **không null-check con trỏ trả về** → crash nếu TrackId sai.
  - `HandleCompleteFanService` (dòng 104–113): truy cập `FanServices[0]` — index cứng, giả định luôn có phần tử đầu.
  - Cơ chế lấy mẫu xe (drift/in-air/speed) chưa xác nhận rõ tần suất sau dòng 120 — **cần đọc thêm**.
- `Source/PrototypeRacing/Private/BackendSubsystem/Progression/ProgressionSubsystem.cpp`:
  - `GrantRewardsForCompletedGoal` (dòng 1336): gọi `RewardCenterSubsystem::GrantGoalCompletionRewards` — entry point chính từ VT-CITY.

## Blueprint liên quan
- WBP reward popup, fan-service UI (`/Game/UI`): đăng ký `OnGoalItemRewardCalculated`, `OnGoalCashRewardCalculated`, `OnItemRewardGranted`. Không có Blueprint gameplay-tick.

## Điểm nóng hiệu năng cụ thể
1. **`RewardCenterSubsystem.cpp:219` và `ProgressionCenterSubsystem.cpp:489` — `LoadSynchronous` icon**: blocking load texture ngay khi tính reward → hitch ở màn hình kết quả đua (thời điểm nhạy cảm nhất: outro sequence + progression compute chạy đồng thời). Ưu tiên migrate sang async load.
2. **`FindRow` lặp trong filter reward pool** — dòng 124, 202, 670: O(candidates) lookup DataTable mỗi lần roll. Không per-frame, tác động trung bình; cần cache kết quả nếu pool lớn.
3. **Fan-service sampling tần suất chưa rõ** — sau dòng 120: nếu là tick per-frame trong `SimulatePhysicsCar` sẽ là chi phí liên tục trong đua. **Cần xác minh** trước khi ship tính năng fan-service.

## Nợ kỹ thuật cụ thể
- `AddFanService` (dòng 98–102): không null-check `TrackProgress` trả về từ `GetTrackById` → potential crash.
- `HandleCompleteFanService` (dòng 104–113): index cứng `FanServices[0]` — có check `IsEmpty()` nhưng giả định luôn xử lý phần tử đầu, không đúng nếu có nhiều fan-service đồng thời.
- `LoadSynchronous` icon rải rác — cần thay bằng `FStreamableManager::RequestAsyncLoad`.
- Reward + achievement + fan-service đều móc vào `ProgressionCenterSubsystem` facade → facade phình to theo từng tính năng mới.

## Mức ưu tiên: **P1**
Lý do: `LoadSynchronous` gây hitch rõ ràng tại thời điểm kết thúc đua (P1). Null-check thiếu trong `AddFanService` là crash risk (P1). Fan-service sampling cần xác minh tần suất trước khi bật tính năng.

## Cần kiểm tra thủ công
- Hoàn thành đua và nhận reward: đo hitch tại màn kết quả, xác nhận item/cash nhận đúng.
- Hoàn thành goal Tier1/Tier2/Tier3: xác nhận LootCrate tier đúng theo OP #230/#293.
- Fan-service challenge drift/fly/speed trong đua: xác nhận check trigger và kết quả nhận đúng. Đo CPU nếu sampling per-frame.
- `AddFanService` với TrackId không tồn tại: xác nhận không crash (sau khi thêm null-check).
