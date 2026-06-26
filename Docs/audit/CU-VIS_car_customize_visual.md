# CU-VIS — Car Customize Visual

## Phạm vi
🆕 Feature mới trong CSV 2026-06-23. Chưa có code.

❌ **Gap:** Toàn bộ feature Car Customize Visual (gồm các sub-feature BODY #555, PAINT #556, PREV #557, CAM #558, TEST #559) chưa được implement. Không tìm thấy subsystem, class hay UI nào dành riêng cho visual-customization flow ngoài garage cơ bản qua CU-ROOM.

## Module/class C++ liên quan (file thật)
Không có subsystem riêng. Có thể tái sử dụng:
- `UCustomizeCarSubsystem` — ApplyPartMesh/Material theo tên part.
- `UCarCustomizationManager` — CalculatePerformanceStats.

## Mức ưu tiên: **P0 (khi implement)**
Feature mới — chưa có code. Cần xây mới complete feature.
