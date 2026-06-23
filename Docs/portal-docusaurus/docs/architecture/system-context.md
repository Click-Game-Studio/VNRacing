---
title: 02. System Context
description: Tác nhân, hệ thống bên ngoài và ràng buộc của client VNRacing trên UE5.
---

## Tác nhân và hệ thống bên ngoài

Sơ đồ System Context tương tác nằm ở trang [Kiến trúc](/architecture).

| Thành phần | Trách nhiệm / ràng buộc |
|---|---|
| Mobile Player | Người chơi iOS / Android dùng điều khiển cảm ứng, các màn hình đua, garage và điều hướng meta-game. |
| VNRacing UE5 Mobile Client | Một module client UE duy nhất hiện đang nắm gameplay, meta/economy, UI, lưu trữ cục bộ, dịch vụ online phía client và tooling. |
| Nakama | Ranh giới auth, session, realtime socket và matchmaking thông qua Nakama UE SDK. |
| Edgegap / Dedicated Server | Ranh giới hosting/server mục tiêu. Source xác nhận luồng waiting-room/join-token, nhưng race server-authoritative đầy đủ thì chưa có bằng chứng hoàn chỉnh. |
| GameAnalytics | Chỉ là nơi thu telemetry; trạng thái gameplay không nên phụ thuộc vào việc gửi event. |
| App Store / Play Billing | Nhà cung cấp entitlement IAP mục tiêu. Hiện source đang đấu nối một commerce provider giả lập (mock); các provider native/xác thực receipt phía server còn là khoảng trống. |
| Content CDN | Mục tiêu cho việc tải pak/chunk qua ChunkDownloader. |
| Backend Economy Services | Authority mục tiêu cho profile/economy/inventory/progression. Source hiện tại vẫn nghiêng nhiều về client-local/prototype. |

## Ràng buộc

- Ổn định frame-time trên mobile là mục tiêu chất lượng hạng nhất.
- Race runtime gắn với level (level-bound); phần lớn hệ thống meta là `UGameInstanceSubsystem`.
- UI phải dùng API/delegate của subsystem thay vì tự nắm business state.
- DataTable/SaveGame cục bộ vẫn là nguồn sự thật thực tế cho nhiều luồng prototype/offline.
- Sơ đồ trong portal này được render bằng LikeC4 và có tính tương tác; đây là mô hình sơ đồ duy nhất của dự án.
