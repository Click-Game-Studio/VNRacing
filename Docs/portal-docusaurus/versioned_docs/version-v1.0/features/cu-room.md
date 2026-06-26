---
title: "CU-ROOM — Customize Room"
description: "Thiết kế chi tiết: tùy biến hình ảnh/hiệu năng, tính CR, lưu/tải và phân giải asset trong Customize Room."
---

> Nguồn: `Docs/audit/CU-ROOM_customize_room.md`, `Docs/c4/model.c4`. View Structurizr: `CU_ROOM_Components`.
> OpenProject: #299.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `cuRoom`).

## Tổng quan

CU-ROOM lo phần tùy biến hình ảnh và hiệu năng, lưu trữ cấu hình xe, tính CR/stat và phân giải asset trong Customize Room.

**Lưu ý:** "Car Unlock thưởng sau khi mở City" thuộc **VT-CITY** (#337 VT-CITY-CU), không phải CU-ROOM.

## Phạm vi

CU-ROOM trừ tiền từ profile và đọc item từ inventory, nhưng không nắm wallet profile hay định nghĩa item trong database.

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `UCarCustomizationManager` | `CarCustomizationManager.cpp:372,383,414,425,484,495,524,535,1983,1997` | Subsystem tùy biến chính (2078 dòng); lo hình ảnh/hiệu năng, tính CR, lưu/tải và tra cứu asset. |
| `UCustomizeCarSubsystem` | `CustomizeCarSubsystem.cpp` | Áp dụng mesh/material nhẹ hơn theo tên part. |
| `UCarSaveGameManager` | `CarSaveGameManager.cpp` | Lưu cấu hình xe, inventory, profile và các slot progression. |
| `CarConfigurationJsonSerializer` | `CarConfigurationJsonSerializer.cpp` | Serialize JSON để chuẩn bị backend-sync. |
| `UCustomizableCar` / `UCarDataProvider` | `CustomizableCar.cpp`, `CarDataProvider.cpp` | Trạng thái tùy biến per-car và helper tra cứu data. |
| Customize UI BPs | `WBP_PerformanceStat`, WBP_UI491/493/496 (`/Game/CarCustomize/UI`) | Widget UI garage/tùy biến. |

## Luồng xử lý

UI chọn part/style/material. Customization manager kiểm tra profile/inventory khi cần, phân giải DataTable/asset (≥30 lần `FindRow` trong file), áp dụng stat hình ảnh/hiệu năng, tính lại CR và lưu cấu hình.

## Điểm nóng hiệu năng

Nhiều lời gọi `LoadSynchronous()` cho đường dẫn mesh/material (`CarCustomizationManager.cpp:372,383,414,425,484,495,524,535,1983,1997`) chặn game thread khi mở garage và khi setup xe AI (`UAIManagerSubsystem::ConfigAiCarPerformance` → N xe = N lần). Event Tick của `WBP_PerformanceStat` đã xác minh là dead/không kết nối.

## API công khai

Entry point đã xác minh: tra cứu mesh/config xe, `CalculatePerformanceStats`, lưu/tải qua `UCarSaveGameManager`, kiểm tra chi tiêu từ profile, kiểm tra item bắt buộc từ inventory và serialize JSON cho backend sync.

## Phần chưa kiểm chứng

Chữ ký hàm chính xác và toàn bộ struct row DataTable nên đọc từ header trước khi tái triển khai.

## Tham chiếu

- Audit: `Docs/audit/CU-ROOM_customize_room.md`
- LD: `Docs/ld/CU-ROOM_customize_room.md`
- Structurizr: `CU_ROOM_Components`
- Cross-ref: VT-CITY (Car Unlock #337 — thuộc VT-CITY, không phải CU-ROOM)
