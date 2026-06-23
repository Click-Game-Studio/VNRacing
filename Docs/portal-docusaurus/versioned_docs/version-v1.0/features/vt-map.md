---
title: "VT-MAP — VN Tour-Map Đua / Huế City"
description: "Tài liệu nội dung: bản đồ đua VN Tour, ba địa điểm Huế City (Đại Nội, Quốc Học, Hồ Thuỷ Tiên) và schema DataTable tương ứng."
---

> Nguồn: `Docs/traceability.md` — mục VT-MAP. OpenProject: #168 / #169.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `vtMap`).

## Tổng quan

VT-MAP là **tính năng nội dung** (content), không phải subsystem runtime. Nó bao gồm geometry level art và các dòng DataTable biểu diễn ba địa điểm đua Huế City: Đại Nội, Quốc Học và Hồ Thuỷ Tiên. Sở hữu thuộc nhóm Level/2D/3D; code kiến trúc chỉ cung cấp schema DataTable mà nội dung phải tuân theo.

## Phạm vi

VT-MAP **không** sở hữu logic mở khóa (→ VT-CITY), độ khó track (→ VT-TRACK) hay cổng CR xe (→ VT-CARPROG). Nó cung cấp *dữ liệu* mà các tính năng kia đọc.

## Thành phần

| Loại asset | Quy ước đường dẫn | Vai trò |
|---|---|---|
| `FMapDataRow` | DataTable `ProgressionData` | Entry bản đồ cấp cao; `UProgressionSubsystem` tra bằng key `"ProgressionData"` |
| `FAreaDataRow` | Con của map row | Entry area Huế City (Đại Nội / Quốc Học / Hồ Thuỷ Tiên) |
| `FTrackDataRow` | Con của area row | Metadata per-track: `PerformanceGates`, `LocationInfo`, điều kiện mở khóa |
| Level asset (`.umap`) | `/Game/Levels/HueCity/` (quy ước) | Geometry có thể chơi; streamed bởi Unreal level streaming |
| Texture minimap / icon | `/Game/UI/Icons/` (quy ước) | Soft-object ref trong DataTable row; load bởi `UProgressionCenterSubsystem` |

## Điểm nóng hiệu năng

`ProgressionCenterSubsystem.cpp:489` gọi `LoadSynchronous` trên soft-ref icon city/track. Thêm nhiều area mới làm tăng số lần blocking load khi mở màn VN Tour. Cần migrate sang async load.

## Ràng buộc schema

Nhóm content cần điền:
- `FMapDataRow.ID` — key integer khớp với unlock chain.
- `FAreaDataRow` cho từng địa điểm Huế City.
- `FTrackDataRow.PerformanceGates` — ngưỡng CR dùng bởi `UCarRatingSubsystem`.
- `FTrackUnlockData.RequiredTopRank` (mặc định `3`) — vị thứ cần đạt để mở track tiếp theo.

Thay đổi schema `FMapDataRow` / `FAreaDataRow` / `FTrackDataRow` cần phối hợp với chủ sở hữu VT-CITY và VT-TRACK.

## Trạng thái

🎨 **content** — theo dõi tiến độ ở OpenProject (#168/#169), không ở tài liệu kiến trúc.

## Tham chiếu

- Traceability: `Docs/traceability.md`
- LD: `Docs/ld/VT-MAP_vntour_map.md`
