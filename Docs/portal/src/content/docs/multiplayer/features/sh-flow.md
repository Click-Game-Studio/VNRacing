---
title: "SH-FLOW — Purchase Flow"
description: "Gap doc: luồng mua hàng — từ xác nhận đến thanh toán và nhận thưởng."
---

> OpenProject: #455. Epic: SHOP & IAP #366.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `shFlow`).

## Tổng quan

🆕 từ 2026-06-23. SH-FLOW định nghĩa luồng mua hàng hoàn chỉnh.

❌ **Trạng thái: gap.** Code hiện tại chỉ có `FMockCommerceProvider` (editor/dev). Native Android/iOS providers bị comment. Không có server receipt verification.

## Thành phần đề xuất

| Component | Vai trò |
|---|---|
| Purchase confirmation dialog | Xác nhận mua hàng |
| Native IAP providers | Wire Apple/Google providers |
| Server receipt validation | Xác thực thanh toán server-side |
| Post-purchase grant | Nhận item qua InventoryManager |

## Tham chiếu

- LD: `Docs/ld/SH_shop_iap.md` (section SH-FLOW)
- LD Epic: `Docs/ld/SH_shop_iap.md`
- Cross-ref: SUP-SHOP (existing code)
