---
title: 01. Giới thiệu
description: Mục đích và quy tắc tài liệu của portal kiến trúc VNRacing.
---

## Mục đích

Portal này là trung tâm kiến trúc chính thức của VNRacing / PrototypeRacing. Nó kết hợp sơ đồ C4, tài liệu theo phong cách arc42, các ADR, liên kết audit bám sát source và các ghi chú thiết kế chi tiết (Low-Level Design) gọn nhẹ cho từng tính năng.

Đợt triển khai này keyed theo taxonomy OpenProject 2026-06-15 (Epic → Feature). Đầu vào gồm `Docs/traceability.md`, `Docs/audit`, `Docs/c4/model.c4`, `Docs/ld/DM-RACE_basic_racing.md`, `Docs/VNRacing_HLD.md`, `Docs/VNRacing_LLD.md` và bằng chứng source chỉ-đọc dưới `PrototypeRacing/Source`.

## Quy tắc tài liệu

1. Bằng chứng từ source thắng tài liệu cũ hơn khi tên class, quyền sở hữu hay hành vi runtime mâu thuẫn nhau.
2. Tên component hiển thị bỏ các tiền tố Unreal như `A`, `U`, `F`, `E`, `I`, `T` và `BP_` cho dễ đọc. Kiểu UE được giữ lại trong phần technology, mô tả và ánh xạ source.
3. Sơ đồ C4 đóng vai trò bản đồ/điều hướng. Tài liệu LD và audit mới mang chi tiết triển khai.
4. Hành vi Blueprint chỉ được khẳng định ở nơi có bằng chứng audit hoặc metadata đã sẵn có. Việc review rộng hơn đồ thị Blueprint vẫn còn là phần chưa kiểm chứng (evidence gap).
5. Các thư mục generated/build/package không phải là nguồn tài liệu.
6. Đợt triển khai này chỉ thay đổi tài liệu/tooling; nó không sửa code game hay tài sản Blueprint.

## Sơ đồ chính

Sơ đồ System Context và sơ đồ Container đều tương tác. Mở trang [Kiến trúc (sơ đồ tương tác)](/architecture) để pan/zoom và bấm vào ô component bất kỳ để nhảy thẳng tới Thiết kế chi tiết của tính năng đó.
