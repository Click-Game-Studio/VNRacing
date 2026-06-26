---
title: "SUP-DBG Debug & Track Test"
description: "Thiết kế chi tiết: module debug, batch simulation AI/track, phát hiện lỗi và xuất dữ liệu."
---

> Hệ thống nền (ngoài danh sách feature OpenProject 2026-06-15) — ứng viên refactor.

> Nguồn: `Docs/audit/SUP-DBG_debug_tracktest.md`, `Docs/c4/model.c4`. View Structurizr: `SUP_DBG_Components`.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `supDbg`).

## Tổng quan

SUP-DBG gom các module debug, batch simulation, phát hiện lỗi track-test và thu thập dữ liệu đua.

## Phạm vi

Nó phải nằm gọn trong ranh giới hỗ trợ phát triển/test, không được biến thành phụ thuộc ẩn trong bản shipping.

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `UDebugToolsSubsystem` | nguồn debug | Chứa các DebugModule_* cho camera, cheat, gameplay, overlay, progression, rendering, test map, track logic, tutorial và vehicle. |
| `UBatchSimulationManager` | nguồn batch | Batch simulation AI/track theo state-machine; rẻ khi idle. |
| `UMistakeDetector` | `MistakeDetector.cpp:113,126` | Phát hiện lỗi mỗi frame và tra cứu spline biên ở chế độ test. |
| `URaceDataCollector` | nguồn collector | Thu thập dữ liệu mỗi frame trong các lượt chạy test. |

## Luồng xử lý

Debug subsystem expose các module. Batch simulation điều khiển các lượt chạy race/test. Mistake detector và data collector lấy mẫu trạng thái xe/track trong các phiên test đang hoạt động.

## Điểm nóng hiệu năng

Mistake detector tick và dùng `GetAllActorsOfClassWithTag`; chỉ chấp nhận được khi cô lập trong các luồng test/debug.

## API công khai

Entry point đã xác minh: đăng ký/chứa module debug, state machine của batch simulation, lấy mẫu của mistake detector, đường thu thập/xuất của race data collector.

## Phần chưa kiểm chứng

Nên kiểm tra chính sách loại trừ khỏi bản shipping trong cấu hình build trước khi release.

## Tham chiếu

- Audit: `Docs/audit/SUP-DBG_debug_tracktest.md`
- Structurizr: `SUP_DBG_Components`
