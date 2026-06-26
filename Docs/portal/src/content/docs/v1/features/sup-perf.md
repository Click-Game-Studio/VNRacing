---
title: SUP-PERF Performance & PSO
description: "Thiết kế chi tiết: instrumentation hiệu năng runtime, significance
  culling và warmup PSO/shader."
slug: v1/features/sup-perf
---

> Hệ thống nền (ngoài danh sách feature OpenProject 2026-06-15) — ứng viên refactor.

> Nguồn: `Docs/audit/SUP-PERF_performance_pso.md`, `Docs/c4/model.c4`. View Structurizr: `SUP_PERF_Components`.

> Sơ đồ: xem trang [Architecture](/v1/architecture/) (view LikeC4 `supPerf`).

## Tổng quan

SUP-PERF là lớp hỗ trợ cross-cutting cho instrumentation hiệu năng runtime, culling theo khoảng cách/significance và warmup PSO/shader.

## Phạm vi

SUP-PERF quan sát và hỗ trợ gameplay, chứ không nắm trạng thái gameplay.

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `UPerformanceMonitorSubsystem` | nguồn performance monitor | Instrumentation FPS/hiệu năng runtime. |
| `ULiteSignificanceManager` | `LiteSignificanceManager.cpp:58,77-82` | Culling actor/Niagara theo khoảng cách, điều khiển bằng timer. |
| `APSOEffectManager` | nguồn PSO | Spawn VFX để warmup PSO; Tick bật nhưng thân rỗng. |
| `ARestLevelManager` | nguồn rest level | Cổng ổn định FPS trước khi travel; theo dõi frame time trong lúc kiểm tra. |

## Luồng xử lý

Gameplay đăng ký các actor liên quan với các helper significance/performance. Luồng PSO/rest-level warmup nội dung và travel khi ổn định. Monitor ghi nhận tình trạng runtime.

## Điểm nóng hiệu năng

`ULiteSignificanceManager` dùng idiom cập nhật trạng thái không nhất quán giữa actor và Niagara, kèm rủi ro truy cập bằng `operator[]`. PSO effect manager có Tick rỗng.

## API công khai

Entry point đã xác minh: performance monitor subsystem, đăng ký significance/xử lý timer, luồng spawn/warmup của PSO effect manager, cổng ổn định/travel của rest-level.

## Phần chưa kiểm chứng

Độ phủ PSO cuối cùng và việc kiểm chứng warmup shader theo từng nền tảng cần review trên thiết bị/profiling, không chỉ đọc nguồn.

## Tham chiếu

* Audit: `Docs/audit/SUP-PERF_performance_pso.md`
* Structurizr: `SUP_PERF_Components`
