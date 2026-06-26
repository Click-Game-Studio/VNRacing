# CU-PERF — Car Customize Performance

## Phạm vi
🆕 Feature mới trong CSV 2026-06-23. Chưa có code.

❌ **Gap:** Toàn bộ feature Car Customize Performance (gồm các sub-feature CORE #563, CR #564, DRIVE #565) chưa được implement. CR calculation hiện tại nằm trong CU-ROOM (`UCarCustomizationManager::CalculatePerformanceStats`), nhưng không có UI tuning riêng.

## Module/class C++ liên quan (file thật)
Không có subsystem riêng. Có thể tái sử dụng:
- `UCarCustomizationManager::CalculatePerformanceStats` — CR/stat calculation.
- `UCarRatingSubsystem` — CR tables và performance gates.

## Mức ưu tiên: **P0 (khi implement)**
Feature mới — chưa có code. Cần xây mới complete feature.
