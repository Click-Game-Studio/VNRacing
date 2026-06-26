# DM-PHYS — DriveMode-Physics

## Phạm vi
Mô phỏng xe người chơi + AI: vehicle actor, stats theo customization, cập nhật bánh xe/suspension. Không bao gồm camera chase (DM-CAM), NOS (DM-NOS), ramp (DM-RAMP), luật đua (DM-RACE). Bao gồm logic collision/wall-correction (#284/#278 "Dev_Implement_Collision Debug").

## Module/class C++ liên quan (file thật)
- `Source/SimpleCarPhysics/Private/PhysicsSimulateCar/SimulatePhysicsCar.cpp` — `ASimulatePhysicsCar` (pawn xe lõi, `PrimaryActorTick.bCanEverTick = true` tại ctor dòng 67).
- `Source/PrototypeRacing/Private/SimulatePhysicsCarWithCustom.cpp` — `ASimulatePhysicsCarWithCustom` (lớp con thêm customization).
- `Source/PrototypeRacing/Private/CustomChaosWheeledVehicle.cpp` — `UCustomChaosWheeledVehicle` (tick rỗng: dòng 12 bật tick, dòng 28–33 chỉ gọi `Super::`).
- `Source/SimpleCarPhysics/Private/PhysicsSimulateCar/CustomSuspensionComponent.cpp` — `UCustomSuspensionComponent`.
- `Source/PrototypeRacing/Private/VehicleFactory.cpp` — `UVehicleFactory`.
- `Source/PrototypeRacing/Private/PIDControl.cpp` — `APIDControl`.

## Blueprint liên quan (từ blueprint_index.json + verify VibeUE)
- `/Game/VehicleTemplate/Blueprints/lux_a/Customizable_Car/BP_Customizable_VF8` — VibeUE: 5 node, **có `Event Tick` nối `Parent: Tick`**.
- `BP_Customizable_MercedesBenz`, `BP_Customizable_VFLuxA` — cùng pattern (verify VibeUE: Event Tick → Parent: Tick).
- `/Game/VehicleTemplate/Blueprints/SportsCar/BP_SportsCar_Pawn` — VibeUE: 34 node, có `Event Tick`.

## Điểm nóng hiệu năng cụ thể
1. **Tick rỗng đăng ký thừa** — `UCustomChaosWheeledVehicle::UCustomChaosWheeledVehicle()` đặt `PrimaryComponentTick.bCanEverTick = true` (`CustomChaosWheeledVehicle.cpp:12`) nhưng `TickComponent` (dòng 28–33) chỉ gọi `Super::` rồi không làm gì. Mỗi xe có component này → UE vẫn lập lịch + gọi tick mỗi frame. Nhân với N xe.
2. **BP vehicle gọi `Parent: Tick`** — các BP_Customizable_* nối Event Tick thẳng vào Parent:Tick; nếu BP layer thêm logic tick thì cộng dồn.
3. **Collision debug path (#284/#278)** — `FMotionDebugProcessor` (`SimulatePhysicsCar.cpp:34–52`) là global debug input processor; nên bọc trong `#if !UE_BUILD_SHIPPING`.

## Nợ kỹ thuật cụ thể
- `FMotionDebugProcessor` global `GlobalMotionDebugger` ở scope file — cần gói trong `#if !UE_BUILD_SHIPPING`.
- Magic number: `CurrentRanking = 8` (dòng 71), `BrakeOnSteerDelaySeconds = 0.5f`, `NetUpdateFrequency = 100` (dòng 82–87) — nên đưa vào UPROPERTY có comment.
- `#include "DrawDebugHelpers.h"` + Niagara include trong file gameplay nóng (dòng 24–26) — xác nhận draw-debug đã bị strip ở shipping.

## Mức ưu tiên: **P1**
Lý do: tick rỗng component là cost cố định mỗi frame mỗi xe, scale theo grid size. Bỏ tick rỗng là quick-win an toàn. Collision debug path (#284/#278) cần xác nhận trước build shipping.

## Cần kiểm tra thủ công
- Logic tick bên trong BP_SportsCar_Pawn (34 node) — mở VibeUE đọc chuỗi exec từ Event Tick để xác nhận có vòng lặp/AllActors không.
- Xác nhận wall-correction impulse trong `ASimulatePhysicsCar` đã hoạt động đúng trên các track mới (#284).
