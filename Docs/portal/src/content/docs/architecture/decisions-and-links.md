---
title: 07. Quyết định và Liên kết
description: Danh mục ADR và liên kết tới các tài liệu nguồn của kiến trúc VNRacing.
---

## Danh mục ADR

- [ADR-0001](/decisions/0001-ranking-update-off-tick): Chuyển cập nhật ranking ra khỏi Tick mỗi frame và bỏ phần quét world phía client.
- [ADR-0002](/decisions/0002-canonical-structurizr-review-mode): Chế độ review kiến trúc chuẩn (mang tính lịch sử — portal LikeC4 này đã thay thế).

## Ghi chú về mô hình sơ đồ

LikeC4 là mô hình sơ đồ duy nhất cho dự án này. Các sơ đồ tương tác trên trang [Kiến trúc](/architecture) sinh ra từ `model.c4`, `specification.c4` và `views.c4`. Quy trình Structurizr DSL trước đây đã ngừng dùng; ADR-0002 chỉ được giữ lại để tham chiếu lịch sử.

## Liên kết nguồn

Các tài liệu sau nằm trong repository, bên ngoài portal này, và được tham chiếu để truy vết:

- High-level design: `Docs/VNRacing_HLD.md`
- Low-level design: `Docs/VNRacing_LLD.md`
- Audit của từng feature: `Docs/audit/00_SUMMARY.md` và các audit theo mã feature mới (DM-*/VT-*/GM-*/CU-*/CDN/SUP-*) — xem `Docs/traceability.md`
- Mô hình nguồn LikeC4: `Docs/c4/model.c4`
