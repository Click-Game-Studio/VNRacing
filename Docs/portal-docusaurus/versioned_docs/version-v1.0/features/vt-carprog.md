---
title: "VT-CARPROG — Car-Progression"
description: "Thiết kế chi tiết: Car Rating (CR) khởi đầu theo city, scale CR theo upgrade, CR AI theo city/độ khó và Dummy Car."
---

> Nguồn: `Docs/audit/VT-CARPROG_car_progression.md`, `Docs/c4/model.c4`. View Structurizr: `VT_CARPROG_Components`.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `vtCarProg`).

## Tổng quan

VT-CARPROG sở hữu hệ thống Car Rating (CR): CR khởi đầu được xác định bởi city index hiện tại của người chơi, CR tăng theo upgrade và CR của AI đối thủ được cấu hình theo city và mức độ khó. Bao gồm cả cơ chế Dummy Car — xe giữ chỗ trước khi xe thật được mở khóa.

## Phạm vi

VT-CARPROG được sử dụng bởi VT-TRACK (tính độ khó track) và CU-ROOM (gating chi phí nâng cấp). Nó **không** sở hữu UI nâng cấp hay inventory — thuộc CU-ROOM và SUP-INV.

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `UCarRatingSubsystem` | `CarRatingSubsystem.cpp` | Bảng CR, resolve CR khởi đầu, CR AI, cổng độ khó track. |
| `ResolveStartingCarRatingLevelByCityIndex` | `CarRatingSubsystem.cpp:212` | Trả `CityIndex * 3` — CR nền cho Dummy Car của city mới. |
| `ResolveCarRatingLevelByUpgradeIndex` | `CarRatingSubsystem.cpp:224` | Kết hợp CR khởi đầu + upgrade level → CR sống của xe. |
| `FCityAICarRating` | `CarRatingSubsystem.h:158` | DataTable row: `CityIndex`, `EasyCarRatingLevel`, `MediumCarRatingLevel`, `HardCarRatingLevel`. |
| `GetTrackDifficultyByPerformance` | `CarRatingSubsystem.cpp:189` | So sánh CR người chơi vs `PerformanceGates` (dải tolerance) → Easy/Medium/Hard. |

## Luồng xử lý

Khi unlock city mới: `ResolveStartingCarRatingLevelByCityIndex(newCityIndex)` xác định CR sàn cho Dummy Car. Khi nâng cấp xe: `UCarCustomizationManager::GetCarRating` gọi `ResolveCarRatingLevelByUpgradeIndex` → kết quả chạy vào `RecalculateTrackDifficulty` của VT-TRACK. AI: `ARacingCarGameMode` đọc `FCityAICarRating` theo city + difficulty trước khi bắt đầu đua.

## Điểm nóng hiệu năng

Công thức `CityIndex * 3` rất nhanh hiện tại. Nếu cần CR phi tuyến (tuning bởi designer) thì phải chuyển sang DataTable — ghi nhận để không bỏ qua khi balance tuning.

## API công khai

Entry point đã xác minh: `ResolveStartingCarRatingLevelByCityIndex(int32)`, `ResolveCarRatingLevelByUpgradeIndex(int32, int32)`, `GetTrackDifficultyByPerformance(int32, int32, float)`, `FCityAICarRating` DataTable (content-driven, không cần build để tune).

## Phần chưa kiểm chứng

Định nghĩa Dummy Car (entry nào trong `UCarConfiguration` / `ProgressionData` đóng vai Dummy) chưa xác nhận trong codegraph. Cần review DataTable và `EnsureGarageCarsFromProgression` trước khi thêm city mới.

## Tham chiếu

- Audit: `Docs/audit/VT-CARPROG_car_progression.md`
- LD: `Docs/ld/VT-CARPROG_car_progression.md`
- Structurizr: `VT_CARPROG_Components`
