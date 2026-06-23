---
title: CDN — Content Download
description: "Thiết kế chi tiết: tải pak/chunk theo nhu cầu, trạng thái mount và UI patch."
slug: v1/features/cdn
---

> Nguồn: `Docs/audit/CDN_content_download.md`, `Docs/c4/model.c4`. View Structurizr: `CDN_Components`.
> OpenProject: #250.

> Sơ đồ: xem trang [Architecture](/v1/architecture/) (view LikeC4 `cdnFeat`).

## Tổng quan

CDN lo vòng đời patch pak/chunk theo nhu cầu, trạng thái mount và UI patch/download. Phần hạ tầng (chia chunk, upload AWS, k6 load test) thuộc PC (#148 Project Config).

## Phạm vi

CDN không vận hành CDN infrastructure, quản lý AWS bucket hay tạo nội dung map.

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `UChunkDownloaderSubsystem` | `ChunkDownloaderSubsystem.cpp` | Vòng đời patch, mount chunk, guard retry và chống re-entrant. |
| `UChunkDownloaderController` | `ChunkDownloaderController.cpp:21` | Spawn widget patch; hiện load đồng bộ widget class. |
| `UChunkDownloaderWidget` | `ChunkDownloaderWidget.cpp:133-186` | UI tiến độ và luồng mở map tải về được. |

## Luồng xử lý

Controller spawn UI patch. Widget/subsystem khởi động hoặc retry patch. Subsystem tải/mount các chunk. Widget mở nội dung/map đã tải.

## Điểm nóng hiệu năng

Luồng mở widget dùng `GetAllActorsOfClass`, `StaticLoadClass` và `AddOnScreenDebugMessage`. Controller dùng `LoadSynchronous` cho widget class (`ChunkDownloaderController.cpp:21`). Debug message cần bọc `#if !UE_BUILD_SHIPPING` trước khi ship (`ChunkDownloaderWidget.cpp:180,185`).

## API công khai

Entry point đã xác minh: trạng thái start/retry/mount patch trên `UChunkDownloaderSubsystem`, spawn widget của controller, luồng tiến độ/mở-map của widget.

## Phần chưa kiểm chứng

Manifest/versioning CDN và chính sách packaging cho production nằm ngoài phạm vi nguồn đã xác minh trong LD này. Xem PC (#148) cho phần hạ tầng.

## Tham chiếu

* Audit: `Docs/audit/CDN_content_download.md`
* LD: `Docs/ld/CDN_content_download.md`
* Structurizr: `CDN_Components`
* Cross-ref: PC (#148) — chunk splitting, AWS upload, k6 load test
