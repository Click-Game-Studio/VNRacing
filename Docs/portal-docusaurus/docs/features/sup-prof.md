---
title: "SUP-PROF User Profile / Economy"
description: "Thiết kế chi tiết: định danh, ví tiền, chỉ số, fuel/session energy và đồng bộ snapshot."
---

> Hệ thống nền (ngoài danh sách feature OpenProject 2026-06-15) — ứng viên refactor.

> Nguồn: `Docs/audit/SUP-PROF_user_profile.md`, `Docs/c4/model.c4`. View Structurizr: `SUP_PROF_Components`.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `supProf`).

## Tổng quan

SUP-PROF quản lý định danh người chơi, các loại tiền tệ trong ví, chỉ số profile, fuel/session energy và đồng bộ snapshot.

## Phạm vi

SUP-PROF không định nghĩa luật reward, không giữ catalog sản phẩm shop (SUP-SHOP) hay topology của progression (VT-CITY).

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `UProfileManagerSubsystem` | `ProfileManagerSubsystem.cpp:14-30,519` | Earn/spend ví, lọc tên, timer lấy mẫu top-speed và dữ liệu profile. |
| `URaceSessionSubsystem` | nguồn session | Fuel/session energy, timer hồi phục và dữ liệu race/session hiện tại. |
| `USnapshotAdapterSubsystem` | nguồn snapshot | Load/save snapshot người chơi qua Nakama RPC. |

## Luồng xử lý

Màn hình UI/profile đọc profile. Gameplay/progression chi tiêu hoặc cấp tài nguyên ví/session. Save manager lưu state local. Snapshot adapter có thể đồng bộ qua Nakama.

## Điểm nóng hiệu năng

Bộ lọc tên quét O(số ký tự tên × số từ cấm). Timer lấy mẫu top-speed chạy ở 5Hz.

## API công khai

Entry point đã xác minh: kiểm tra earn/spend ví, validate tên profile, spend/recharge fuel session, load/save snapshot qua Nakama RPC, và lưu trữ giao cho `UCarSaveGameManager`.

## Phần chưa kiểm chứng

Backend authority cho profile/economy mới là kiến trúc mục tiêu; bằng chứng nguồn hiện tại vẫn nghiêng nhiều về local/prototype.

## Tham chiếu

- Audit: `Docs/audit/SUP-PROF_user_profile.md`
- Structurizr: `SUP_PROF_Components`
