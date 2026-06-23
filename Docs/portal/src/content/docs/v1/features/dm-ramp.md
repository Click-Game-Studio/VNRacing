---
title: DM-RAMP RAMP
description: Thiết kế chi tiết — cơ chế phóng xe qua ramp, trigger zone,
  boost/impulse trên entry và ổn định landing.
slug: v1/features/dm-ramp
---

> Nguồn: `Docs/audit/DM-RAMP_ramp.md`, `Docs/c4/model.c4`, bằng chứng đọc nguồn (read-only) dưới `PrototypeRacing/Source`.
> View Structurizr: `DM_RAMP_Components`. OpenProject: #335.

## Tổng quan

DM-RAMP lo cơ chế ramp: `ARampZone` đặt trong level phát hiện xe đi vào, áp dụng boost accel + cho phép xe bay (`TriggerAllowFlying`), broadcast skill event `EVehicleSkillType::HangTime`. Với ramp loại `bIsHighPlatform`, khi xe thoát ra sẽ damp angular velocity để ổn định hạ cánh.

> Sơ đồ: xem trang [Architecture](/v1/architecture/) (view LikeC4 `dmRamp`).

## Phạm vi

Physics impulse (`ATP_AddImpulse`, `Jump`) thực thi bởi DM-PHYS. DM-NOS là boost riêng. DM-RAMP không sở hữu race lifecycle hay vehicle physics.

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `ARampZone` | `RampZone.h:13` / `RampZone.cpp:12` | Actor đặt trong level; dùng overlap event (không Tick). Chứa `UBoxComponent* RampTrigger` + `UStaticMeshComponent*`. |
| `OnRampOverlapBegin` | `RampZone.cpp:51` | Phát hiện xe vào: cancel drift, `TriggerAllowFlying`, set boost params, broadcast `HangTime`. |
| `OnRampOverlapEnd` | `RampZone.cpp:95` | Xe rời ramp (high-platform): damp angular velocity X×0.2, Y×0.2, Z×0.5. |
| `CalculateBoostMultiplier` | `RampZone.cpp:117` | Tính boost multiplier từ curve + góc ramp. |
| `ASimulatePhysicsCar::Jump` | `SimulatePhysicsCar.cpp:3341` | Áp impulse hướng lên nếu `!bInAir`. |
| `EVehicleSkillType` | `SimulatePhysicsCar.h:438–448` | Enum: `RampBoost` (445), `HangTime` (446); broadcast qua `OnVehicleSkillTriggered`. |

## Luồng xử lý

```
Xe vào RampTrigger → OnRampOverlapBegin
  → kiểm tra bShouldApplyRampBoost + cancel drift
  → TriggerAllowFlying()
  → [!bIsHighPlatform] set bIsRampBoostActive, RampAccelBoost
     OnRampBoost(true), broadcast EVehicleSkillType::HangTime

Xe rời RampTrigger → OnRampOverlapEnd
  → [bIsHighPlatform] damp angular velocity → ổn định landing
```

## Điểm nóng hiệu năng

`ARampZone` không có Tick (`bCanEverTick = false`, line 12) — pattern đúng, không có chi phí per-frame. `PrintString` debug tại `OnRampOverlapBegin` dòng 53 cần xóa trước build release.

## API công khai

* `ARampZone`: `BoostForce` (EditAnywhere, default 800), `bIsHighPlatform` (bool), `RefreshTrajectoryPreview()` (CallInEditor).
* Car-side: `bShouldApplyRampBoost`, `bIsRampBoostActive`, `RampBoostTimeRemaining`, `RampBoostDuration`, `RampAccelBoost`.
* `ASimulatePhysicsCar::Jump(float amount)` — impulse hướng lên.
* `OnVehicleSkillTriggered` delegate broadcast `EVehicleSkillType::HangTime`.

## Phần chưa kiểm chứng

`bShouldApplyRampBoost` cần xác nhận được khởi tạo đúng cho xe AI. Flying state reset sau hạ cánh chưa được soi chi tiết. Chi tiết tại `Docs/audit/DM-RAMP_ramp.md`.

## Tham chiếu

* Audit: `Docs/audit/DM-RAMP_ramp.md`
* Structurizr: `DM_RAMP_Components`
* OpenProject: #335
