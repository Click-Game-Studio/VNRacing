---
title: ADR-0001 — Chuyển cập nhật ranking ra khỏi Tick mỗi frame
description: Chuyển cập nhật ranking của cuộc đua ra khỏi Tick mỗi frame và bỏ
  phần quét world phía client.
slug: v1/decisions/0001-ranking-update-off-tick
---

> Ngày: 2026-06-09 · Trạng thái: Đề xuất

## Bối cảnh

`RaceTrackManager` là orchestrator trung tâm của cuộc đua và tick mỗi frame. Hàm
`Tick` của nó (`RaceTrackManager.cpp:207-221`) gọi `HandleUpdateRanking()`
vô điều kiện ở dòng 210. Bên trong `HandleUpdateRanking()`
(`RaceTrackManager.cpp:834-877`), các công việc sau chạy trên mỗi frame:

* Một vòng lặp qua toàn bộ `ManagerPlayerInfo` tính `FVector::DistSquared` cho mỗi
  xe (dòng 836-864).
* Một lời gọi `GetPlayerRaceStates()` (dòng 865) — hàm này
  (`RaceTrackManager.cpp:583-630`) thực hiện `GenerateValueArray` (copy toàn bộ),
  một `Algo::Sort` với comparator 5 nhánh (**O(n log n)**), rồi một vòng lặp để
  gán `Ranking`.
* Một vòng lặp thứ hai qua mảng đã sort gọi `Vehicle->SetRaceRank`
  (dòng 866-874) và `OnRankingUpdate.Broadcast` (dòng 875).
* Dòng 876 tính `const float CurrentMoment = GetWorld()->GetTimeSeconds();`
  nhưng kết quả không bao giờ được dùng — **dead code**.

Broadcast `OnRankingUpdate` lan tới
`RacingCarController::HandleRankingUpdateCallToClient`
(`RacingCarController.cpp:286-308`), hàm này gọi
`UGameplayStatics::GetAllActorsOfClass(... ASimulatePhysicsCar ...)` (dòng 291)
rồi chạy một **vòng lồng** `for State : PlayerRaceState { for Actor :
AllCars { ... } }` (dòng 293-307) để khớp mỗi state về đúng xe của nó —
**O(n^2)** cộng với một lần quét toàn bộ actor trong world trên mỗi lần cập nhật ranking.

Ranking thay đổi chậm so với một frame 60Hz. Chạy lại phép tính distance, một
lần copy + sort O(n log n), một lần broadcast, cộng với quét world + khớp O(n^2)
ở phía dưới trên mỗi frame là mẫu "chạy ở 60Hz nhưng không cần" tệ nhất trong
dự án, và nó nằm thẳng trên main gameplay loop, nơi nó ngốn FPS.

Header đã sẵn có những đòn bẩy cho hướng tiếp cận dùng timer:
`UpdateInterval = 0.3f` (`RaceTrackManager.h:641`) và `UpdateCheckpointTimerHandle`.
Struct trạng thái `FPlayerRaceState` đã giữ sẵn `Vehicle` (một con trỏ), nên
controller không cần tìm lại xe qua việc quét world.

## Quyết định

1. Điều khiển `HandleUpdateRanking()` bằng một timer lặp (~5-10Hz, dùng
   `UpdateInterval` / `UpdateCheckpointTimerHandle` sẵn có) thay vì gọi nó từ
   `Tick`. Nếu `Tick` không còn việc gì cần làm mỗi frame, tắt
   `PrimaryActorTick` trên `RaceTrackManager`.
2. Bỏ dòng dead code `CurrentMoment` tại `RaceTrackManager.cpp:876`.
3. Trong `HandleRankingUpdateCallToClient`, bỏ lời gọi `GetAllActorsOfClass` và
   vòng lồng khớp. Gán thẳng qua con trỏ đã sẵn có:
   `State.Vehicle->CurrentRanking = State.Ranking`, đạt **O(n)**.

## Hệ quả

**Tích cực**

* Loại bỏ một lần copy + sort O(n log n) + broadcast mỗi frame khỏi main race loop.
* Loại bỏ một lần quét toàn bộ actor trong world và khớp O(n^2) phía client trên mỗi lần cập nhật.
* Xóa dead code và giảm khối lượng công việc thuộc về god class `RaceTrackManager`.

**Tiêu cực / đánh đổi**

* Ranking giờ cập nhật theo nhịp timer (~5-10Hz) thay vì mỗi frame; thay đổi rank
  trên HUD có thể trễ tối đa một chu kỳ timer. Chấp nhận được vì ranking là giá
  trị thay đổi chậm và nhịp 60Hz trước đây vốn không thể cảm nhận được.
* Cần xác nhận không có consumer mỗi frame nào khác phụ thuộc vào việc `Tick` gọi
  `HandleUpdateRanking` như một tác dụng phụ trước khi tắt `PrimaryActorTick`.

## Tham chiếu

* Audit: `Docs/audit/DM-RACE_basic_racing.md` (điểm nóng #1, #2)
* LD: [DM-RACE Basic Racing](/v1/features/dm-race) §1.4, §2.4, §2.5
