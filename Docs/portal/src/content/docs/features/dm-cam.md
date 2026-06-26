---
title: DM-CAM CAMERA
description: Thiết kế chi tiết — chase camera cho xe player, spring arm, FOV curve, incline detection, airborne và bounce simulation.
---

> Nguồn: `Docs/audit/DM-CAM_camera.md`, `Docs/c4/model.c4`, bằng chứng đọc nguồn (read-only) dưới `PrototypeRacing/Source`.
> View Structurizr: `DM_CAM_Components`. OpenProject: #336.

## Tổng quan

DM-CAM lo hệ thống chase camera cho xe player. `AFollowCarCamera` tick mỗi frame để làm mượt spring arm, FOV theo tốc độ, turn offset, incline detection và bounce simulation khi xe nhảy/hạ cánh.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `dmCam`).

## Phạm vi

Physics xe thuộc DM-PHYS. UI HUD race thuộc DM-RACE. Cài đặt loại view (Default/Third-person) thuộc DM-SET (`ECameraView`). DM-CAM không sở hữu các phần này.

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `AFollowCarCamera` | `FollowCarCamera.h:67` / `FollowCarCamera.cpp:13` | Chase camera actor; tick mỗi frame; caches `SpringComponent`. |
| `TickFunction` | `FollowCarCamera.cpp:73+` | Lerp arm length + FOV theo curve tốc độ, turn offset, incline, airborne, bounce. |
| `RegisterFollowTarget` | `FollowCarCamera.h:76` | BlueprintCallable; gắn camera vào `ASimulatePhysicsCar` target. |
| `AdjustDistance / AdjustFOV / AdjustRotationLag` | `FollowCarCamera.h:79–85` | BlueprintCallable; tuning runtime (snap hoặc interpolate). |
| Incline detection | `FollowCarCamera.h:182–195` | Timer `TimeToActivateIncline = 10f`; `StartCountdownActiveIncline` (BlueprintCallable). |
| `FAirborneCameraSettings` | `FollowCarCamera.h:201–202` | Config camera khi xe trên không, `bWasInAir` flag. |
| Bounce simulation | `FollowCarCamera.h:173–176` | `BounceStrength/Damping/Frequency`; runtime `BounceOffsetZ/Velocity`. |

## Luồng xử lý

```
BeginPlay → cache SpringComponent
RegisterFollowTarget(Car) → lưu Target + SimulatePhysicsCar
[Mỗi frame] Tick → TickFunction
  → đọc CameraDistanceBaseOnSpeed curve → TargetArmLength
  → đọc CameraFOVBaseOnSpeed curve → TargetFOV
  → InterpTo arm length, InterpTo FOV
  → tính turn offset (delta rotation + smoothing)
  → áp incline/airborne/bounce adjustments
```

## Điểm nóng hiệu năng

Tick camera mỗi frame với nhiều `InterpTo` + curve `GetFloatValue` — chi phí cố định nhưng chỉ có 1 camera instance (không nhân theo số xe). `SpringComponent` đã cache (dòng 28). Xác nhận không còn `GetComponentByClass` uncached trong tick path. Chi tiết tại `Docs/audit/DM-CAM_camera.md`.

## API công khai

```cpp
void RegisterFollowTarget(ASimulatePhysicsCar*);   // BlueprintCallable
void AdjustDistance(float, bool bSnap);
void AdjustFOV(float, bool bSnap);
void AdjustRotationLag(float LagPercent, bool bSnap);
void OnCameraShake();                              // BlueprintImplementableEvent
void StartCountdownActiveIncline();               // BlueprintCallable
```

Config key: `CameraDistanceBaseOnSpeed`, `CameraFOVBaseOnSpeed` (UCurveFloat); `MinCameraFOV=55`, `MaxCameraFOV=105`; `PitchFollowAlpha=0.25`, `RollFollowAlpha=0.05`.

## Phần chưa kiểm chứng

`OnCameraShake` là BlueprintImplementableEvent — có thể có BP override chưa được verify. Giá trị `TimeToActivateIncline` per-level chưa kiểm tra. Chi tiết tại `Docs/audit/DM-CAM_camera.md`.

## Tham chiếu

- Audit: `Docs/audit/DM-CAM_camera.md`
- Structurizr: `DM_CAM_Components`
- OpenProject: #336
