---
title: "CU-PERF — Car Customize Performance"
description: "Gap doc: tính năng tùy biến hiệu năng xe — core upgrades, CR calculations, test drive."
---

> OpenProject: #402. Subs: CORE #563, CR #564, DRIVE #565.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `cuPerf`).

## Tổng quan

🆕 từ 2026-06-23. CU-PERF định nghĩa luồng tùy biến hiệu năng xe riêng.

❌ **Trạng thái: gap.** CR calculation hiện tại nằm trong CU-ROOM (`UCarCustomizationManager::CalculatePerformanceStats`), nhưng không có UI tuning riêng hoặc phần hiệu năng.

## Thành phần đề xuất

| Component | Vai trò |
|---|---|
| UI Core Upgrades | Nâng cấp động cơ, lốp, suspension |
| UI CR Breakdown | Hiển thị chi tiết CR/stat |
| Performance Test Drive | Test drive để kiểm tra hiệu năng |

## Tham chiếu

- LD: `Docs/ld/CU-PERF_car_customize_performance.md`
- Cross-ref: CU-ROOM (customization code), DM-RACE (test drive tracks)
