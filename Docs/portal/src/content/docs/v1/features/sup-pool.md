---
title: SUP-POOL Object Pooling
description: "Thiết kế chi tiết: pool actor tái sử dụng phạm vi world cho VNRacing."
slug: v1/features/sup-pool
---

> Hệ thống nền (ngoài danh sách feature OpenProject 2026-06-15) — ứng viên refactor.

> Nguồn: `Docs/audit/SUP-POOL_object_pooling.md`, `Docs/c4/model.c4`. View Structurizr: `SUP_POOL_Components`.

> Sơ đồ: xem trang [Architecture](/v1/architecture/) (view LikeC4 `supPool`).

## Tổng quan

SUP-POOL cung cấp một pool actor tái sử dụng theo phạm vi world cùng một contract dạng interface cho các actor nằm trong pool. Đây là tính năng hỗ trợ để các spawner gameplay dùng chung.

## Phạm vi

SUP-POOL không giữ luật đua hay hành vi riêng của từng actor.

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `UActorObjectPoolSubsystem` | `ActorObjectPoolSubsystem.cpp:8-59` | Lấy ra và trả actor về pool; theo dõi các mảng availability và dictionary theo actor-class. |
| `IPoolObjectInterface` | nguồn pool interface | Các callback vòng đời cho actor nằm trong pool. |

## Luồng xử lý

Bên gọi xin pool một actor. Pool trả về một instance đang rảnh, hoặc tạo và kích hoạt instance mới. Xong việc thì bên gọi trả actor về pool. Các callback vòng đời báo cho actor biết lúc nào create/get/release.

## Điểm nóng hiệu năng

Audit ghi nhận việc quét tuyến tính mỗi lần lấy/trả actor, và `ReleaseActor` truy cập `ActorClassDict[ActorToRelease]` mà không guard, dễ crash khi gặp actor lạ không thuộc pool.

## API công khai

Contract đã xác minh: `GetActor`/`ReleaseActor` trên `UActorObjectPoolSubsystem`, và các callback interface `OnCreate`, `OnGetFromPool`, `OnReleaseToPool` trên `IPoolObjectInterface`.

Nguyên tắc khi triển khai lại: release phải idempotent/có guard cho actor lạ, và việc tra cứu availability của pool nên tránh quét O(n) trên các đường nóng.

## Tham chiếu

* Audit: `Docs/audit/SUP-POOL_object_pooling.md`
* Structurizr: `SUP_POOL_Components`
