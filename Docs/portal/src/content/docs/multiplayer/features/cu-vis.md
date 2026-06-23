---
title: "CU-VIS — Car Customize Visual"
description: "Gap doc: tính năng tùy biến hình ảnh xe — body parts, paint/decal, preview, camera, test drive."
---

> OpenProject: #401. Subs: BODY #555, PAINT #556, PREV #557, CAM #558, TEST #559.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `cuVis`).

## Tổng quan

🆕 từ 2026-06-23. CU-VIS định nghĩa luồng tùy biến hình ảnh xe riêng — tách biệt với CU-ROOM (garage hiện tại).

❌ **Trạng thái: gap.** Không tìm thấy subsystem nào dành riêng cho visual customization. `UCustomizeCarSubsystem` xử lý apply mesh/material theo tên part, nhưng không có UI tùy biến hình ảnh riêng.

## Thành phần đề xuất

| Component | Vai trò |
|---|---|
| UI Body Parts | Chọn và thay đổi body parts (bumper, spoiler, v.v.) |
| UI Paint & Decal | Chọn màu sơn, decal, material |
| UI Preview | Viewport xem trước xe đang tùy biến |
| Camera Controls | Orbit/zoom/rotate trong preview |
| Car Test Drive | Nút test drive từ màn customize |

## Tham chiếu

- LD: `Docs/ld/CU-VIS_car_customize_visual.md`
- Cross-ref: CU-ROOM (customization code), DM-CAM (camera)
