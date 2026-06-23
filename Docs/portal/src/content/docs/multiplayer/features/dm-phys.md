---
title: DM-PHYS DriveMode-Physics
description: Thiết kế chi tiết — mô phỏng xe player/AI, suspension, movement component và cấu hình Blueprint cho xe. Không bao gồm camera, NOS hay ramp.
---

> Nguồn: `Docs/audit/DM-PHYS_drivemode_physics.md`, `Docs/c4/model.c4`, bằng chứng đọc nguồn (read-only) dưới `PrototypeRacing/Source`.
> View Structurizr: `DM_PHYS_Components`. OpenProject: #279.

## Tổng quan

DM-PHYS lo phần mô phỏng xe player/AI: vehicle actor, cập nhật wheel/suspension, movement component, các factory helper và cấu hình Blueprint cho xe. Bao gồm logic collision/wall-correction (OpenProject #284/#278 "Dev_Implement_Collision Debug").

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `dmPhys`).

## Phạm vi

DM-RACE giữ luật đua. SUP-AI giữ chính sách quyết định AI. CU-ROOM cấp dữ liệu customization. DM-CAM, DM-NOS, DM-RAMP là các feature tách biệt không thuộc DM-PHYS.

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `ASimulatePhysicsCar` | `SimpleCarPhysics/Private/PhysicsSimulateCar/SimulatePhysicsCar.cpp` | Vehicle pawn gameplay cốt lõi; Tick mỗi frame cập nhật suspension/wheel, đồng bộ animation và state hướng ra race. |
| `ASimulatePhysicsCarWithCustom` | `PrototypeRacing/Private/SimulatePhysicsCarWithCustom.cpp` | Lớp con áp dụng stats customization lên physics core. |
| `UCustomChaosWheeledVehicle` | `CustomChaosWheeledVehicle.cpp:12,28-33` | Override movement Chaos; audit báo cáo TickComponent bật nhưng thân rỗng. |
| `UCustomSuspensionComponent` | `SimpleCarPhysics/Private/.../CustomSuspensionComponent.cpp` | Suspension theo từng bánh; tick mỗi frame trên mỗi xe. |
| `UVehicleFactory` | `PrototypeRacing/Private/VehicleFactory.cpp` | Helper tạo/cấu hình xe theo chuẩn thống nhất. |
| `APIDControl` | `PrototypeRacing/Private/PIDControl.cpp` | Actor điều khiển PID; helper chạy theo tick cho autodrive. |
| Customisable car BPs | metadata/audit Blueprint | Thiết lập visual/component bên trên pawn C++. |

## Luồng xử lý

DM-RACE spawn và quản lý car actor. Tick của xe cập nhật physics/suspension. DM-RACE ghi rank/race state; SUP-AI gọi `AutoDrive`; DM-NOS gọi `BoostNitro`; DM-RAMP gọi `Jump`/`TriggerAllowFlying`; DM-CAM theo dõi xe qua `RegisterFollowTarget`. CU-ROOM cấp stats visual/performance.

## Điểm nóng hiệu năng

Tick rỗng ở movement component (`CustomChaosWheeledVehicle.cpp:12,28–33`) nhân với số xe trong race. Blueprint vehicle gọi `Parent: Tick` cộng dồn. `FMotionDebugProcessor` cần xác nhận đã bị strip ở shipping. Chi tiết tại `Docs/audit/DM-PHYS_drivemode_physics.md`.

## API công khai

Entry point ổn định: `ASimulatePhysicsCar` (vehicle pawn), `UCustomChaosWheeledVehicle` (movement), `UCustomSuspensionComponent` (suspension), `UVehicleFactory` (factory), `APIDControl` (PID). Cross-feature: DM-NOS dùng `BoostNitro`, DM-RAMP dùng `Jump`/`TriggerAllowFlying`/`bShouldApplyRampBoost`/`bIsRampBoostActive`, DM-CAM dùng `RegisterFollowTarget`.

## Phần chưa kiểm chứng

LD không liệt kê đầy đủ chữ ký mọi hàm. Đọc header nguồn trước khi tái triển khai hoặc thay đổi API. Wall-correction (#284/#278) cần kiểm tra thủ công trên track thật.

## Tham chiếu

- Audit: `Docs/audit/DM-PHYS_drivemode_physics.md`
- Structurizr: `DM_PHYS_Components`
- OpenProject: #279, #284, #278
