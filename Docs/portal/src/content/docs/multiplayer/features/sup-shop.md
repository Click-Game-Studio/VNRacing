---
title: "SUP-SHOP Shop / IAP / Ads"
description: "Thiết kế chi tiết: sản phẩm cửa hàng, điều phối mua hàng và tích hợp UI shop/quảng cáo."
---

> Hệ thống nền (ngoài danh sách feature OpenProject 2026-06-15) — ứng viên refactor.

> Nguồn: `Docs/audit/SUP-SHOP_shop_iap.md`, `Docs/c4/model.c4`. View Structurizr: `SUP_SHOP_Components`.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `supShop`).

## Tổng quan

SUP-SHOP lo phần sản phẩm cửa hàng, điều phối mua hàng và ghép UI shop/quảng cáo.

## Phạm vi

Ví tiền thì SUP-PROF giữ. Còn quyền cấp entitlement ở mức production thì app store và backend nắm.

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `UCommerceSubsystem` | `CommerceSubsystem.cpp:14-23,80-85` | Điều phối sản phẩm và mua hàng qua lớp trừu tượng provider. |
| `FMockCommerceProvider` | nguồn commerce provider | Provider thay thế cho editor/dev, hiện đang được wire. |
| Shop UI BP | metadata Blueprint | Các widget shop, popup, DLC, booster và rewards/quảng cáo. |

## Luồng xử lý

UI gọi commerce subsystem, subsystem giao việc cho provider, provider trả kết quả rồi cập nhật entitlement/economy. Bằng chứng hiện tại mới chỉ cho thấy mock provider được đấu nối.

## Điểm nóng hiệu năng

Provider Android/iOS đang bị comment/chưa wire production và chưa có đường server verify receipt trong bằng chứng nguồn.

## API công khai

Entry point đã xác minh: điều phối sản phẩm/mua hàng của commerce subsystem và mock provider. Contract production phải bao gồm callback của native provider cùng việc backend verify receipt/entitlement trước khi tin vào reward hay tiền tệ.

## Phần chưa kiểm chứng

App Store / Play Billing thật và thẩm quyền backend là kiến trúc mục tiêu, chưa phải triển khai đã xác minh.

## Tham chiếu

- Audit: `Docs/audit/SUP-SHOP_shop_iap.md`
- Structurizr: `SUP_SHOP_Components`
