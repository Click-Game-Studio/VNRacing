---
title: DM-NOS NOS
description: Thiết kế chi tiết — cơ chế nitro boost cho player và AI, checkpoint
  nạp lại NOS và logic AI quyết định khi dùng NOS.
slug: v1/features/dm-nos
---

> Nguồn: `Docs/audit/DM-NOS_nos.md`, `Docs/c4/model.c4`, bằng chứng đọc nguồn (read-only) dưới `PrototypeRacing/Source`.
> View Structurizr: `DM_NOS_Components`. OpenProject: #334.

## Tổng quan

DM-NOS lo cơ chế nitro: player bấm boost → xe tăng tốc bằng `BoostNitro`; AI đánh giá gauge + interval → tự kích hoạt NOS khi đường thẳng; `ABoostCheckPoint` trên track nạp lại gauge cho xe đi qua.

> Sơ đồ: xem trang [Architecture](/v1/architecture/) (view LikeC4 `dmNos`).

## Phạm vi

Physics impulse thực thi bởi DM-PHYS. Hạ tầng AI (SUP-AI) cung cấp `UAIDecisionComponent`. DM-RACE spawn checkpoint trên track. DM-NOS không sở hữu race lifecycle hay vehicle physics.

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `ASimulatePhysicsCar::BoostNitro` | `SimulatePhysicsCar.cpp:3350` | Kích hoạt NOS trên xe: validate gauge, thêm force, bắt đầu burn. |
| `APhysicCarController::BoostNitrous` | `PhysicCarController.cpp:67` | Entry point controller gốc: `On_BoostNitrous()` + `ResetNitrous()`. |
| `APrototypeRacingPlayerController::BoostNitrous` | `PrototypeRacingPlayerController.cpp:97` | Entry point player controller: `VehiclePawn->Boost(false)` + `ResetNitrous()`. |
| `ABoostCheckPoint` | `BoostCheckPoint.cpp` | Checkpoint nạp lại NOS trên track; kích hoạt qua overlap. |
| `UAIDecisionComponent` (NOS path) | `AIDecisionComponent.cpp:50–87` | Tích lũy `NOSCheckInterval`, kiểm tra `NOSUsageFrequency`, đặt `bShouldUseNOS`. |
| `ASimulatePhysicsCar::AutoDrive` | `SimulatePhysicsCar.cpp:2615` | Tiêu thụ `bShouldUseNOS` → gọi `BoostNitro()` khi đường thẳng. |

## Luồng xử lý

**Player:** Input → `BoostNitrous` → `BoostNitro` → validate gauge → thêm `CurrentNitroForce`, set `bIsNitroActive`.

**AI:** `UAIDecisionComponent::TickComponent` tích lũy interval khi gauge đầy → xác suất `NOSUsageFrequency` → `bShouldUseNOS = true` → `AutoDrive` kiểm tra đường thẳng → `BoostNitro()`.

**Nạp lại:** Xe đi qua `ABoostCheckPoint::OnOverlapBegin` → refill `NitroGauge`.

## Điểm nóng hiệu năng

* `ABoostCheckPoint::Tick` (dòng 39–41) thân rỗng, tick bật mặc định — đặt `bCanEverTick = false`.
* `UAIDecisionComponent::TickComponent` chạy mỗi frame cho mỗi AI; gate bởi `NitroGauge ≈ 1.0` nên chi phí thấp khi gauge chưa đầy.

## API công khai

* `ASimulatePhysicsCar::BoostNitro()` — kích hoạt NOS (gọi từ controller hoặc AutoDrive).
* `APrototypeRacingPlayerController::BoostNitrous()` — entry point player (line 97).
* `APhysicCarController::BoostNitrous()` — entry point controller gốc (line 67).
* Fields: `NitroGauge`, `NitroBoostCounter` (max stack 2), `bIsNitroActive`, `StandardNitroBoost`.

## Phần chưa kiểm chứng

`ABoostCheckPoint::OnOverlapBegin` khai báo trong header nhưng body `.cpp` hiện tại rỗng — cần xác nhận refill logic được wire trong Blueprint subclass. Chi tiết tại `Docs/audit/DM-NOS_nos.md`.

## Tham chiếu

* Audit: `Docs/audit/DM-NOS_nos.md`
* Structurizr: `DM_NOS_Components`
* OpenProject: #334
