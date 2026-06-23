# DM-NOS — NOS

## Phạm vi
Cơ chế nitro/boost: kích hoạt NOS của player và AI, quản lý gauge, checkpoint nạp lại NOS trên track, và logic AI quyết định khi nào dùng NOS. Physics impulse thực thi bởi DM-PHYS (`ASimulatePhysicsCar`). Hạ tầng AI thuộc SUP-AI.

## Module/class C++ liên quan (file thật)
- `Plugins/SimpleCarPhysics/Source/SimpleCarPhysics/Private/PhysicsSimulateCar/SimulatePhysicsCar.cpp:3350` — `ASimulatePhysicsCar::BoostNitro`: validate gauge, `NitroBoostCounter++`, `CurrentNitroForce += StandardNitroBoost`, `NitroBurnSpeed += 1/NitroBoostDuration`, `OnNitroStart(true)`, `bIsNitroActive = true`.
- `Source/PrototypeRacing/PhysicCarController.cpp:67` — `APhysicCarController::BoostNitrous`: gọi `On_BoostNitrous()` rồi `ResetNitrous()` (dòng 62 đặt `Nitrous = 0.f`).
- `Source/PrototypeRacing/PrototypeRacingPlayerController.cpp:97` — `APrototypeRacingPlayerController::BoostNitrous`: gọi `VehiclePawn->Boost(false)` rồi `ResetNitrous()` (dòng 92).
- `Source/PrototypeRacing/BoostCheckPoint.h:10` / `BoostCheckPoint.cpp` — `ABoostCheckPoint`: checkpoint nạp lại NOS trên track; `BeginPlay` (dòng 32) và `Tick` (dòng 39–41) hiện tại thân rỗng.
- `Plugins/SimpleCarPhysics/Source/SimpleCarPhysics/Private/PhysicsSimulateCar/AIDecisionComponent.cpp:50–87` — `UAIDecisionComponent::TickComponent`: tích lũy `NOSCheckInterval`, khi gauge đầy và vượt ngưỡng → kiểm tra `NOSUsageFrequency` → đặt `bShouldUseNOS = true`.
- `Plugins/SimpleCarPhysics/Source/SimpleCarPhysics/Private/PhysicsSimulateCar/SimulatePhysicsCar.cpp:2615` — `ASimulatePhysicsCar::AutoDrive`: đọc `AIDecisionComponent->bShouldUseNOS`; nếu đường thẳng + gauge đầy → gọi `BoostNitro()`, reset flag.

> **Lưu ý xác nhận:** `ABoostCheckPoint::OnOverlapBegin` (dòng 30–31 trong header) được khai báo nhưng body trong `.cpp` hiện tại rỗng (chỉ có `BeginPlay` và `Tick` rỗng được verify). Cần xác nhận logic refill gauge được bind trong Blueprint subclass hay chưa — chưa soi được chi tiết trong session này.

## Blueprint liên quan
- `BP_BoostCheckPoint` — 3 node, có `Event Tick` (verify VibeUE, giống BP_CheckPoint trong DM-RACE). Nên xóa Event Tick nếu thân rỗng.

## Điểm nóng hiệu năng cụ thể
1. **`ABoostCheckPoint::Tick` rỗng** (dòng 39–41): tick bật mặc định nhưng không làm gì — đặt `bCanEverTick = false` như pattern DM-RACE hotspot #3.
2. **`UAIDecisionComponent::TickComponent`** chạy mỗi frame cho tất cả xe AI: NOS check được gate bởi `NitroGauge ≈ 1.0` nên chi phí thấp khi gauge chưa đầy, nhưng vẫn là cost cố định nhân với số AI.

## Nợ kỹ thuật cụ thể
- `ABoostCheckPoint::BeginPlay` (dòng 32) rỗng — cần xác nhận overlap binding được wire ở Blueprint hay C++ subclass, không bị mất.
- Stacking NOS (`NitroBoostCounter` tối đa 2): logic guard ở `BoostNitro` (dòng 3350) kiểm tra `NitroBoostCounter == 2` để block activation thứ 3 — cần test edge case khi xe AI và player cùng kích hoạt cùng frame.

## Mức ưu tiên: **P2**
Lý do: không có hotspot per-frame nghiêm trọng. Quick-win là tắt tick rỗng của `ABoostCheckPoint`. Cần xác nhận overlap binding trước khi merge track mới.
