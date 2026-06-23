---
title: VT-TRACK — Area-Track Unlock
description: "Thiết kế chi tiết: mở khóa area/track theo vị thứ, chọn track để
  đua, tính lại độ khó track khi CR xe thay đổi."
slug: v1/features/vt-track
---

> Nguồn: `Docs/audit/VT-TRACK_area_track_unlock.md`, `Docs/c4/model.c4`. View Structurizr: `VT_TRACK_Components`.

> Sơ đồ: xem trang [Architecture](/v1/architecture/) (view LikeC4 `vtTrack`).

## Tổng quan

VT-TRACK sở hữu việc mở khóa area/track trong city đã mở, luồng chọn track (UI → setup đua) và tính lại độ khó track khi CR xe thay đổi. Ranh giới với VT-CITY: VT-CITY lo cấp city trở lên; VT-TRACK lo cấp area/track trở xuống.

## Phạm vi

Unlock track gắn với **vị thứ** (finishing rank): `FTrackUnlockData.RequiredTopRank` (mặc định `3`). Người chơi phải về đích ở vị thứ đó hoặc cao hơn để mở track tiếp theo.

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `UProgressionSubsystem` | `ProgressionSubsystem.cpp` | Sở hữu `VNTourProgressionData`; trạng thái mở khóa area/track. |
| `UnlockNext(int32)` | `ProgressionSubsystem.cpp:20` | Mở track tiếp theo (hiện là stub — cần xác minh). |
| `FTrackUnlockData` | `ProgressionData.h:801` | Struct chứa `RequiredTopRank`; điều kiện vị thứ để unlock. |
| `RecalculateTrackDifficulty` | `ProgressionSubsystem.cpp:2127` | Tính lại `ETrackDifficulty` toàn bộ track; broadcast `OnTrackDifficultyRecalculated`. |
| `UCarRatingSubsystem::GetTrackDifficultyByPerformance` | `CarRatingSubsystem.cpp:189` | So sánh CR người chơi với `PerformanceGates` track → Easy/Medium/Hard. |

## Luồng xử lý

**Track Selection (#342):** UI chọn track → `UProgressionCenterSubsystem::SetupRaceData` đọc `LocationInfo` → DM-RACE tải level. Sau đua: kết quả so với `RequiredTopRank`; nếu đạt gọi `UnlockNext`.

**Track Config (#343):** nâng cấp xe → `RecalculateTrackDifficulty` tính lại toàn bộ → `OnTrackDifficultyRecalculated` → UI refresh badge Easy/Medium/Hard.

## Điểm nóng hiệu năng

`RecalculateTrackDifficulty` duyệt 3 tầng city/area/track; không per-frame nhưng tăng tuyến tính theo lượng content. Cần profiling khi VN Tour có nhiều city hơn.

## API công khai

Entry point đã xác minh: `RecalculateTrackDifficulty`, `OnTrackDifficultyRecalculated` (delegate), `FTrackUnlockData.RequiredTopRank`, `SetupRaceData` (qua VT-CITY facade). `UnlockNext` là stub — cần xác minh trước sprint tới.

## Phần chưa kiểm chứng

`UnlockNext` body bị comment out tại dòng 20. Unlock track thực tế có thể đang đi qua `VNTourProgressionData.UnlockNextTrack` hoặc chưa implement đầy đủ. Cần review trước khi ra mắt Huế City.

## Tham chiếu

* Audit: `Docs/audit/VT-TRACK_area_track_unlock.md`
* LD: `Docs/ld/VT-TRACK_area_track_unlock.md`
* Structurizr: `VT_TRACK_Components`
