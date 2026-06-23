---
title: Portal Kiến trúc VNRacing
description: Sơ đồ C4 (render tĩnh tại build) cùng thiết kế chi tiết cho client game đua xe mobile VNRacing trên UE5.6. Bản spike Docusaurus có versioning native.
slug: /
---

# Portal Kiến trúc VNRacing

Tài liệu kiến trúc cho **client mobile VNRacing trên UE5.6**: 6 container, các
tính năng theo taxonomy OpenProject (DM / VT / GM / CU / CDN + hệ thống nền
Support), các class C++ và Blueprint thật, luồng liên tính năng và mức chi tiết
triển khai đủ để sửa code. Toàn site tìm kiếm full-text được.

:::info[Bản spike để so sánh stack]
Đây là phiên bản **Docusaurus** dựng trên nhánh `docs/versioned-c4-spike` để so
sánh với portal Astro/Starlight + LikeC4 hiện tại. Hai khác biệt chính:

- **Sơ đồ C4 render tĩnh tại build** (PNG xuất từ chính mô hình LikeC4) → hiện
  **tức thì**, không tải engine ~2.3 MB phía client như bản cũ.
- **Versioning native** (góc trên bên phải có dropdown phiên bản) → xem được
  kiến trúc và sơ đồ thay đổi thế nào qua từng bản phát hành.

Đánh đổi: mất tương tác click-vào-ô-để-nhảy-trang của LikeC4. Bù lại, mỗi sơ đồ
có sẵn link văn bản tới trang thiết kế chi tiết ngay bên dưới.
:::

## Dành cho ai

### Dev
Mở **[Kiến trúc](/architecture)**, tìm tính năng cần xử lý, mở trang Thiết kế
chi tiết (Low-Level Design) tương ứng: class, điểm nóng dạng file:dòng, contract API.

### UI / Art
Xem các **[sơ đồ kiến trúc](/architecture)** để nắm quan hệ và luồng giữa các
tính năng. Không cần đọc code.

### Mọi người
Dùng ô tìm kiếm để tìm full-text trên mọi trang. Sidebar liệt kê sẵn toàn bộ
tính năng và phần kiến trúc.

## Nội dung

- **[Kiến trúc (sơ đồ)](/architecture)** — mô hình C4: System Context, các
  Container, và một component view cho mỗi tính năng.
- **[Kiến trúc (arc42)](/architecture/introduction)** — phần viết: giới thiệu,
  System Context, sơ đồ Container, danh mục tính năng, sơ đồ Runtime, chất lượng
  và rủi ro, các quyết định.
- **[Tính năng (Thiết kế chi tiết)](/features/dm-race)** — các trang LD cho từng
  tính năng theo taxonomy OpenProject.
- **[Quyết định (ADR)](/decisions/0001-ranking-update-off-tick)** — các bản ghi
  quyết định kiến trúc.

:::note[Nguồn của sơ đồ]
Sơ đồ sinh từ mô hình **LikeC4** (`specification.c4` + `model.c4` + `views.c4`),
xuất PNG bằng `likec4 export png` tại bước build. Cùng một mô hình nguồn với
portal cũ — chỉ khác cách hiển thị (tĩnh thay vì engine phía client).
:::
