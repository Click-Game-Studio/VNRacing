---
title: "CU-SEL — Car Selection"
description: "Gap doc: màn hình chọn xe trước khi vào đua."
---

> OpenProject: #403.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `cuSel`).

## Tổng quan

🆕 từ 2026-06-23. CU-SEL định nghĩa màn hình chọn xe — grid/list xe sở hữu kèm stats, CR, preview.

❌ **Trạng thái: gap.** Game hiện tại không có multi-car selection UI. Player chỉ sở hữu một xe tại một thời điểm trong progression.

## Thành phần đề xuất

| Component | Vai trò |
|---|---|
| Car Selection Screen (UMG) | Grid/list xe sở hữu với stats thumbnail |
| `UCarSelectionSubsystem` | Quản lý xe đang chọn, sync với inventory |
| Stat comparison widget | So sánh stats giữa các xe |

## Tham chiếu

- LD: `Docs/ld/CU-SEL_car_selection.md`
- Cross-ref: CU-ROOM (car stats), VT-CITY-CU (car unlock)
