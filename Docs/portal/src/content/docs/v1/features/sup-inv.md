---
title: SUP-INV Inventory
description: "Thiết kế chi tiết: quản lý item sở hữu, equip/favorite, tra cứu
  định nghĩa item và lưu trữ."
slug: v1/features/sup-inv
---

> Hệ thống nền (ngoài danh sách feature OpenProject 2026-06-15) — ứng viên refactor.

> Nguồn: `Docs/audit/SUP-INV_inventory.md`, `Docs/c4/model.c4`. View Structurizr: `SUP_INV_Components`.

> Sơ đồ: xem trang [Architecture](/v1/architecture/) (view LikeC4 `supInv`).

## Tổng quan

SUP-INV lo phần item người chơi giữ, equip/favorite và tra cứu định nghĩa item; việc lưu trữ thì giao cho module lưu game.

## Phạm vi

Rewards cấp item qua inventory (VT-REWARD), còn customization thì hỏi inventory xem người chơi đã có item bắt buộc hay chưa (CU-ROOM).

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `UInventoryManager` | nguồn inventory manager | Trạng thái add/remove/equip/favorite item; cổng khóa backend-authority; lưu khi có thay đổi. |
| `UItemDatabase` | `ItemDatabase.cpp:36-44` | Database định nghĩa item dựa trên DataTable/cache. |

## Luồng xử lý

Reward/customization/UI gọi inventory manager. Manager phân giải định nghĩa item, đổi trạng thái giữ/equip và lưu qua save manager.

## Điểm nóng hiệu năng

Audit báo cáo `UItemDatabase::GetItemDefinition` bỏ qua `ItemCache`, gọi thẳng `FindRow` và thiếu null-check trên `ItemDefinitionsTable`.

## API công khai

Entry point đã xác minh: các API add/remove/equip/favorite item trên `UInventoryManager`, tra cứu định nghĩa item qua `UItemDatabase::GetItemDefinition`, lưu xuống qua `UCarSaveGameManager`.

## Phần chưa kiểm chứng

Schema row item đầy đủ và danh sách event/delegate khi thay đổi nên đọc từ header trước khi sửa API.

## Tham chiếu

* Audit: `Docs/audit/SUP-INV_inventory.md`
* Structurizr: `SUP_INV_Components`
