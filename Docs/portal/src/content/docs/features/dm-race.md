---
title: DM-RACE Basic Racing
description: Thiết kế chi tiết — vòng đời race, checkpoint, ranking, timer, intro/outro và bàn giao kết quả.
---

> Nguồn: `Docs/audit/DM-RACE_basic_racing.md`, `Docs/c4/model.c4`, bằng chứng đọc nguồn (read-only) dưới `PrototypeRacing/Source`.
> View Structurizr: `DM_RACE_Components`. OpenProject: #324.

## Tổng quan

DM-RACE lo toàn bộ vòng đời một cuộc đua: từ lúc spawn xe + AI, đếm ngược intro, bắt đầu đua, theo dõi checkpoint/lap/ranking/thời gian mỗi frame, tới kết thúc và bàn giao kết quả cho VT-CITY.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `dmRace`).

## Phạm vi

DM-PHYS giữ physics xe. SUP-AI giữ chính sách quyết định AI. DM-NOS giữ boost nitro. DM-CAM giữ camera. VT-CITY tiêu thụ kết quả race qua `HandleRaceCompleted`.

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `ARaceTrackManager` | `RaceMode/RaceTrackManager.cpp` (1869 dòng) | Orchestrator trung tâm; Tick mỗi frame; ranking, checkpoint, AI setup, sequence. |
| `ARacingCarGameMode` | `RacingCarGameMode.cpp` | Spawn race manager + xe; xử lý login/ready player. |
| `ARaceGameState` | `RaceGameState.cpp` | Replicate số xe + readiness. |
| `ARacingCarController` | `RacingCarController.cpp` (365 dòng) | Player controller; RPC race state xuống client HUD. |
| `ARaceCheckpoint` | `RaceMode/RaceCheckpoint.cpp` | Trigger overlap → báo manager. |
| `URaceComponent` | `RaceMode/RaceComponent.cpp` (34 dòng) | Tick rỗng — xem điểm nóng. |
| `ABoostCheckPoint` | `BoostCheckPoint.cpp` | Checkpoint cộng thời gian; Tick rỗng. |

## Luồng xử lý

```
ARacingCarGameMode → spawn ARaceTrackManager + xe + AI
ARaceTrackManager::BeginPlay → GetAllActorsOfClass(ARaceCheckpoint)  [1 lần]
[Intro] → StartRace → SignalRaceBegin (NetMulticast)
[Mỗi frame] Tick → HandleUpdateRanking()  ⚠ hotspot P0
[Xe chạm checkpoint] → HandleVehicleDetectedAtCheckpoint → cập nhật lap/checkpoint
[Kết thúc] EndRace → OnRaceEnded → VT-CITY HandleRaceCompleted
```

## Điểm nóng hiệu năng

- **P0:** `HandleUpdateRanking()` gọi vô điều kiện mỗi frame (`RaceTrackManager.cpp:207–221`): copy+sort O(n log n) + broadcast mỗi 60Hz. Giải pháp: timer ~5–10 Hz (cơ chế đã có sẵn ở header dòng 641).
- **P0:** `HandleRankingUpdateCallToClient` (`RacingCarController.cpp:286–308`): `GetAllActorsOfClass` + vòng lồng O(n²) mỗi update. `State.Vehicle` đã có — không cần quét world.
- **P1:** `URaceComponent` tick rỗng (`RaceComponent.cpp:12`). Đặt `bCanEverTick = false`.
- **P1:** BP checkpoint có `Event Tick` (BP_CheckPoint, BP_BoostCheckPoint, BP_DriftZone_Child) — nên thuần event-driven.

Chi tiết file:dòng tại `Docs/audit/DM-RACE_basic_racing.md`.

## API công khai

Entry point: `StartRace()`, `EndRace()`, `SignalRaceBegin()` (NetMulticast), `HandleUpdateRanking()`, `GetPlayerRaceStates()`, `GetActiveCars()`. Delegate BlueprintAssignable: `OnCheckpointPassed`, `OnRankingUpdate`, `OnPlayerFinishedRace`, `OnRaceEnded`, `OnLapCompleted`, `OnTimeAttackUpdate`.

## Phần chưa kiểm chứng

LD không liệt kê toàn bộ hàm của `ARaceTrackManager` (1869 dòng, god-class). Đọc source trước khi tách/refactor. BP checkpoint cần kiểm tra editor để xác nhận Tick có thân hay không.

## Tham chiếu

- Audit: `Docs/audit/DM-RACE_basic_racing.md`
- Structurizr: `DM_RACE_Components`
- OpenProject: #324
