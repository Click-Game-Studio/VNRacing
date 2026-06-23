---
title: "SUP-AI Racer AI"
description: "Thiết kế chi tiết: lập lịch AI, quyết định lái, racing line và hành vi NOS."
---

> Hệ thống nền (ngoài danh sách feature OpenProject 2026-06-15) — ứng viên refactor.

> Nguồn: `Docs/audit/SUP-AI_racer_ai.md`, `Docs/c4/model.c4`. View Structurizr: `SUP_AI_Components`.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `supAi`).

## Tổng quan

SUP-AI lo phần lập lịch AI và quyết định lái: khi nào các xe AI cập nhật, cách chúng chọn lane/NOS/racing-line, và cách chúng truy vấn dữ liệu guide-line.

## Phạm vi

DM-PHYS giữ vehicle physics. DM-RACE giữ race lifecycle và phần áp dụng độ khó. CU-ROOM/VT-CITY lo tính toán stats. SUP-AI không đụng các phần này.

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `UAIManagerSubsystem` | `AIManagerSubsystem.cpp:165-190,219-225` | Scheduler kiểu round-robin; mỗi frame chỉ cho nhiều nhất một xe AI tick. Lúc đăng ký xe AI, nó cấu hình performance và quét các scheduled tick để tìm trùng lặp. |
| `UAIDecisionComponent` | nguồn AI decision | Quyết định lái cho từng xe, kiểm tra racing-line và NOS. Audit đánh dấu TickComponent trên mỗi xe là điểm nóng. |
| `UGuideLineSubsystem` | nguồn guide-line | Phân giải lane/đối thủ; khởi tạo track mark gần nhất từ các actor trong world. |

## Luồng xử lý

DM-RACE tạo/cấu hình các xe AI và áp dụng tinh chỉnh độ khó. `UAIManagerSubsystem` lập lịch công việc `AutoDrive(dt)`. `UAIDecisionComponent` truy vấn `UGuideLineSubsystem` để lấy lane và state. Khi cần tinh chỉnh stats xe, SUP-AI gọi sang phần customization/tính stats của CU-ROOM.

## Điểm nóng hiệu năng

`ConfigAiCarPerformance` gọi `CalculatePerformanceStats`; `RegisterAICar` quét `AIScheduledTicks`; các decision component vẫn có thể tick trên mỗi xe. Xem audit để có tham chiếu nguồn chính xác.

## API công khai

Các entry point đã xác minh: đăng ký/lập lịch xe AI trong `UAIManagerSubsystem`, decision component trên mỗi xe `UAIDecisionComponent`, nhà cung cấp lane/truy vấn `UGuideLineSubsystem`, quan hệ với DM-RACE qua `ApplyAIDifficultyTuning`, và target `AutoDrive(dt)` trên xe DM-PHYS.

## Phần chưa kiểm chứng

Danh sách method public chính xác nên đọc từ header trước khi refactor. LD này chỉ ghi lại phạm vi phụ trách và ranh giới gọi ổn định.

## Tham chiếu

- Audit: `Docs/audit/SUP-AI_racer_ai.md`
- Structurizr: `SUP_AI_Components`
