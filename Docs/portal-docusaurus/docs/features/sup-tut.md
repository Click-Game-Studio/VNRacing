---
title: "SUP-TUT Tutorial / Onboarding"
description: "Thiết kế chi tiết: các bước tutorial theo kịch bản, pool tooltip, điều kiện trigger và khóa điều khiển."
---

> Hệ thống nền (ngoài danh sách feature OpenProject 2026-06-15) — ứng viên refactor.

> Nguồn: `Docs/audit/SUP-TUT_tutorial.md`, `Docs/c4/model.c4`. View Structurizr: `SUP_TUT_Components`.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `supTut`).

## Tổng quan

SUP-TUT lo trạng thái tutorial theo kịch bản, pool tooltip, các điều kiện trigger và việc khóa/mở điều khiển.

## Phạm vi

SUP-TUT phản ứng theo sự kiện gameplay/progression, nhưng không nắm trạng thái race (DM-RACE) hay progression (VT-CITY).

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `UTutorialManagerSubsystem` | audit ghi nhận file 674 dòng | Trạng thái tutorial, pool tooltip, điều phối trigger và khóa/mở điều khiển. |
| `UTriggerCondition` | nguồn trigger | Lớp gốc/lớp con như điều kiện checkpoint-passed. |
| Tutorial BPs | đã xác minh qua VibeUE/audit | `WBP_ScriptTutorial`, `WBP_TooltipTutorial`, các BP trigger checkpoint. |

## Luồng xử lý

DM-RACE/VT-CITY phát ra các sự kiện liên quan tutorial. Tutorial manager đánh giá điều kiện trigger, hiển thị tooltip/UI kịch bản và khóa/mở điều khiển khi cần.

## Điểm nóng hiệu năng

Các tutorial BP mà audit kiểm tra không có Event Tick hoạt động; rủi ro hiện tại nằm ở khả năng bảo trì/kích thước hơn là chi phí mỗi frame race.

## API công khai

Entry point đã xác minh: các API điều phối trigger/hiển thị tooltip/khóa điều khiển của tutorial manager, các lớp đánh giá `UTriggerCondition`, và bên tiêu thụ sự kiện gameplay/progression.

## Phần chưa kiểm chứng

Toàn bộ schema DataTable kịch bản và mọi Blueprint tutorial không được liệt kê đầy đủ ở đây.

## Tham chiếu

- Audit: `Docs/audit/SUP-TUT_tutorial.md`
- Structurizr: `SUP_TUT_Components`
