# DM-RAMP — RAMP

## Phạm vi
Cơ chế phóng xe qua ramp: trigger zone đặt trong level, áp dụng boost/impulse khi xe vào, damping angular velocity khi xe rời ramp (loại high-platform), broadcast skill event `EVehicleSkillType::HangTime`. Physics impulse thực thi bởi DM-PHYS. DM-NOS là hệ thống boost riêng biệt.

## Module/class C++ liên quan (file thật)
- `Source/PrototypeRacing/Public/RampZone.h:13` / `Source/PrototypeRacing/Private/RampZone.cpp:12` — `ARampZone`: actor đặt trong level; `PrimaryActorTick.bCanEverTick = false` (dòng 12, dùng overlap event). Sở hữu `UBoxComponent* RampTrigger` + `UStaticMeshComponent* RampMeshComponent`.
- `Source/PrototypeRacing/Private/RampZone.cpp:51` — `ARampZone::OnRampOverlapBegin`: cast sang `ASimulatePhysicsCar`, kiểm tra `bShouldApplyRampBoost`, cancel drift, gọi `TriggerAllowFlying()`, set `bIsRampBoostActive`, `RampBoostTimeRemaining`, `RampAccelBoost = CalculateBoostMultiplier(Car)`, fire `OnRampBoost(true)`, broadcast `EVehicleSkillType::HangTime`.
- `Source/PrototypeRacing/Private/RampZone.cpp:95` — `ARampZone::OnRampOverlapEnd`: chỉ với `bIsHighPlatform = true` — damp angular velocity (X×0.2, Y×0.2, Z×0.5) để ổn định khi hạ cánh.
- `Source/PrototypeRacing/Private/RampZone.cpp:117` — `ARampZone::CalculateBoostMultiplier`: tính boost multiplier từ `BoostForceCurve` và góc ramp.
- `Plugins/SimpleCarPhysics/Source/SimpleCarPhysics/Private/PhysicsSimulateCar/SimulatePhysicsCar.cpp:3341` — `ASimulatePhysicsCar::Jump(float amount)`: áp dụng impulse hướng lên qua `ATP_AddImpulse` nếu `!bInAir`.
- `Plugins/SimpleCarPhysics/Source/SimpleCarPhysics/Public/PhysicsSimulateCar/SimulatePhysicsCar.h:438–448` — `EVehicleSkillType` enum: `RampBoost` (dòng 445), `HangTime` (dòng 446) — broadcast qua `OnVehicleSkillTriggered`.

## Blueprint liên quan
- Chưa có blueprint riêng cho RampZone được verify. `ARampZone` dự kiến dùng trực tiếp trong level dưới dạng C++ actor với UPROPERTY config trong editor.

## Điểm nóng hiệu năng cụ thể
1. **`ARampZone` không có Tick** (`bCanEverTick = false`, dòng 12) — đúng pattern, không có chi phí per-frame.
2. **`PrintString` debug** tại `OnRampOverlapBegin` dòng 53 — cần bọc trong `#if !UE_BUILD_SHIPPING` hoặc xóa trước build release.

## Nợ kỹ thuật cụ thể
- `bShouldApplyRampBoost` (flag guard trên car, dòng 60) — cần xác nhận được khởi tạo đúng cho xe AI. Nếu flag thiếu mặc định `true` trên AI pawn thì ramp không tác dụng với AI.
- `TriggerAllowFlying()` được gọi cả cho `bIsHighPlatform = true` — xác nhận flying state được reset khi xe hạ cánh (chưa soi code reset trong session này).

> **Lưu ý xác nhận dòng:** các dòng trên là từ đọc source thực tế qua context engine. Số dòng trong RampZone.cpp (51, 95, 117) được verify trực tiếp. `ARampZone` ctor dòng 12 được verify. `Jump` dòng 3341 và `EVehicleSkillType` dòng 438–448 được verify.

## Mức ưu tiên: **P2**
Lý do: không có hotspot per-frame. Quick-win là xóa `PrintString` debug. Cần xác nhận `bShouldApplyRampBoost` và flying state reset trước khi deploy track có ramp mới.
