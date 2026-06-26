---
title: "SH-DISP — Shop Display"
description: "Gap doc: màn hình shop trong game."
---

> OpenProject: #405. Epic: SHOP & IAP #366.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `shDisp`).

## Tổng quan

🆕 từ 2026-06-23. SH-DISP định nghĩa màn hình shop — danh mục sản phẩm (xe, cosmetics, currency packs, boosters).

❌ **Trạng thái: gap.** Code hiện tại có prototype shop UI (`WBP_Shop`, `WBP_Popup_Shopping`, `WBP_Card_DLC`) nhưng không có product data thực hay IAP integration.

## Thành phần đề xuất

| Component | Vai trò |
|---|---|
| Shop Screen (UMG) | Danh mục sản phẩm theo category |
| Product cards | Card hiển thị giá, thumbnail, mô tả |
| Product catalog | DataTable hoặc backend configuration |

## Tham chiếu

- LD: `Docs/ld/SH_shop_iap.md` (section SH-DISP)
- LD Epic: `Docs/ld/SH_shop_iap.md`
- Cross-ref: SUP-SHOP (existing code), SH-FLOW (purchase flow)
