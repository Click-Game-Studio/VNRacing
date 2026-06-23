# DM-CAM — CAMERA

## Phạm vi
Chase camera cho xe player: `AFollowCarCamera` actor, `TickFunction` per-frame (lerp spring arm, FOV curve, turn offset, incline detection, airborne, bounce). Không bao gồm physics xe (DM-PHYS), UI HUD race (DM-RACE), hay cài đặt view-type (DM-SET).

## Module/class C++ liên quan (file thật)
- `Plugins/SimpleCarPhysics/Source/SimpleCarPhysics/Public/FollowCarCamera.h:67` / `Plugins/SimpleCarPhysics/Source/SimpleCarPhysics/Private/FollowCarCamera.cpp:13` — `AFollowCarCamera`: camera actor; `FollowCarCamera.cpp:16` bật tick; `TickFunction` (dòng 73+) làm nhiều phép lerp/InterpTo + đọc curve `GetFloatValue`. Cache `SpringComponent` tại dòng 28 (tốt).
- `FollowCarCamera.h:76` — `RegisterFollowTarget(ASimulatePhysicsCar*)`: `BlueprintCallable`; gắn camera vào xe target.
- `FollowCarCamera.h:79–85` — `AdjustDistance`, `AdjustFOV`, `AdjustRotationLag`: `BlueprintCallable`, tuning runtime.
- `FollowCarCamera.h:182–195` — Incline detection: `StartCountdownActiveIncline` (BlueprintCallable), `InclineTimerHandle`, `TimeToActivateIncline = 10f`.
- `FollowCarCamera.h:201–202` — `FAirborneCameraSettings AirborneCameraSettings`: config khi xe ở trên không, `bWasInAir` flag.
- `FollowCarCamera.h:173–176` — Bounce: `BounceStrength = 50f`, `BounceDamping = 4f`, `BounceFrequency = 10f`; runtime state `BounceOffsetZ`, `BounceVelocity`.
- `FollowCarCamera.h:204–215` — Pitch/Roll follow: `PitchFollowAlpha = 0.25f`, `RollFollowAlpha = 0.05f` (comment nguồn: "càng nhỏ càng ít lắc theo xe").

## Blueprint liên quan
- Camera được dùng trực tiếp từ C++ actor trong level; không có BP riêng được verify. `OnCameraShake` là `BlueprintImplementableEvent` — có thể có BP override.

## Điểm nóng hiệu năng cụ thể
1. **`AFollowCarCamera` tick mỗi frame** — `FollowCarCamera.cpp:16` bật tick; `TickFunction` (dòng 73+) làm nhiều phép lerp + đọc curve `GetFloatValue` mỗi frame. Cần cho camera mượt, chấp nhận được, nhưng là cost cố định. `SpringComponent` đã cache (dòng 28, tốt) — xác nhận không còn `GetComponentByClass` uncached trong tick path.
2. **Cộng dồn với BP xe** — nếu BP xe cũng kéo camera state thì tick cộng dồn với DM-PHYS.

## Nợ kỹ thuật cụ thể
- `PitchFollowAlpha` và `RollFollowAlpha` là UPROPERTY với default hardcode — đã expose ra editor, OK; nhưng cần kiểm tra các level dùng giá trị mặc định hay đã override riêng.
- `TimeToActivateIncline = 10f` hardcode trong header — xem xét đưa vào DataTable config nếu cần điều chỉnh theo track.

## Mức ưu tiên: **P1**
Lý do: tick camera là cost cố định mỗi frame. Không gây crash nhưng là chi phí "luôn chạy" trong race. Ưu tiên thấp hơn DM-PHYS vì camera chỉ có 1 instance (không nhân theo số xe), nhưng cần verify không còn lookup uncached.
