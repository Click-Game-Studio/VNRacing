---
title: ADR-0002 — Chế độ review kiến trúc (lịch sử)
description: Quyết định mang tính lịch sử về chế độ review Structurizr; portal
  LikeC4 đã thay thế.
slug: v1/decisions/0002-canonical-structurizr-review-mode
---

> Ngày: 2026-06-10 · Trạng thái: Đã chấp nhận (lịch sử — portal LikeC4 đã thay thế)

> **Lưu ý:** ADR này ghi lại quy trình review trước đây dựa trên Structurizr. Kể từ đó dự án đã chuẩn hóa sang LikeC4 làm mô hình sơ đồ duy nhất, render tương tác trong portal tĩnh này. Quyết định được giữ lại để truy vết lịch sử.

## Bối cảnh

Gói kiến trúc của VNRacing không chỉ gồm sơ đồ. Workspace đã nhập tài liệu theo phong cách arc42 và các quyết định kiến trúc. Người review cần xem cùng lúc các sơ đồ C4, danh mục tính năng, ghi chú chất lượng, các liên kết LD/audit và ADR để hiểu được bản đồ triển khai cùng các khoảng trống bằng chứng.

Bản xuất tĩnh của Structurizr hữu ích cho việc chia sẻ ảnh chụp sơ đồ, nhưng nó không giữ được trọn vẹn trải nghiệm review phong phú cho tài liệu và quyết định. Coi bản xuất tĩnh là chuẩn chính thức sẽ che đi nhật ký quyết định và phần chi tiết bám theo nguồn vốn dùng để giải thích các sơ đồ.

## Quyết định

Tại thời điểm đó, đường review chính thức cho bộ tài liệu này là Structurizr Lite, Structurizr Cloud hoặc một bản triển khai Structurizr on-prem.

Bản xuất tĩnh có thể được tạo ra như một ảnh chụp sơ đồ bổ trợ mà thôi. Nó không được mô tả như là gói tài liệu kiến trúc đầy đủ.

## Hệ quả

Tích cực:

* Người review thấy sơ đồ, tài liệu và ADR trong một workspace điều hướng được.
* Tài liệu có thể giữ các sơ đồ C4 gọn gàng trong khi dồn chi tiết vào các trang arc42/LD.
* Hạn chế đã biết của bản xuất tĩnh được nêu rõ ràng thay vì gây bất ngờ cho người review.

Tiêu cực / đánh đổi:

* Review cần một runtime Structurizr thay vì chỉ mở các file tĩnh. Đây chính là nhược điểm mà portal tĩnh LikeC4 hiện nay giải quyết: các sơ đồ giờ đã tương tác và hoàn toàn tĩnh, không cần runtime tại thời điểm xem.

## Tham chiếu

* Mô hình nguồn LikeC4: `Docs/c4/model.c4`, `Docs/c4/views.c4`
* Sơ đồ tương tác: [Architecture](/v1/architecture)
