# SUP-PROF — User Profile / Economy

## Phạm vi
Identity, ví (Cash/Coin), stats, fuel/session energy, snapshot sync.

## Module/class C++ liên quan (file thật)
- `Source/PrototypeRacing/Private/BackendSubsystem/ProfileManagerSubsystem.cpp` — `UProfileManagerSubsystem` (ví, lọc tên, top-speed sampling).
- `BackendSubsystem/RaceSessionSubsystem.cpp` — `URaceSessionSubsystem` (fuel, recharge timer).
- `BackendSubsystem/SnapshotAdapterSubsystem.cpp` — `USnapshotAdapterSubsystem` (snapshot RPC qua Nakama).

## Blueprint liên quan
- UI ví/profile (`/Game/UI`), không gameplay tick.

## Điểm nóng hiệu năng cụ thể (đã grep `ProfileManagerSubsystem`)
1. **Bad-word scan O(name × words)** — `ProfileManagerSubsystem.cpp:14-30` `ContainsBadWords`: lặp toàn bộ `ForbiddenWords`, mỗi từ gọi `CleanName.Contains(BadWord)` (dòng 24). Mỗi `Contains` là quét chuỗi → tổng O(len(name) × số_từ_cấm). Gọi khi đổi tên (`ProfileManagerSubsystem.cpp:519`). Không per-frame nên tác động thấp, nhưng nếu danh sách từ cấm lớn thì là điểm cần biết. Có normalize trước (`NormalizeBadWord`, dòng 55-) → thêm 1 lượt build chuỗi nữa.
2. **Top-speed sampling 5Hz**: `ProfileManagerSubsystem` chạy timer lấy mẫu tốc độ (`StartCheckTopSpeed`, gọi từ `RacingCarController.cpp:114` và `OnPossess`). Tần suất 5Hz (0.2s) — hợp lý, không phải hotspot nặng, nhưng là timer chạy suốt khi đua.
3. **`LoadSynchronous` avatar**: `ProfileManagerSubsystem.cpp:745` `GetCurrentSoftObjectAvatar().LoadSynchronous()` — blocking load ảnh avatar. Nếu gọi trong khi mở UI → hitch.

## Nợ kỹ thuật cụ thể
- `RaceSessionSubsystem` quản lý fuel bằng tick/timer (xem mô tả LLD) — cần xác nhận timer được clear khi rời session để tránh leak timer.
- Snapshot adapter phụ thuộc Nakama RPC: nếu offline/prototype thì luồng save phải có fallback local (cần xác nhận đường fallback).
- Ví (Cash/Coin) là source-of-truth local trong prototype; khi bật backend phải reconcile — hiện chưa authoritative (đúng theo design target, không phải nợ ngay).

## Audit Blueprint
Không có BP gameplay-tick thuộc feature. Không cần kiểm tra editor thủ công.

## Mức ưu tiên: **P2**
Lý do: các điểm nóng đều ngoài hot-loop per-frame (đổi tên, sampling 5Hz, load avatar lúc mở UI). Đáng ghi nhận nhưng tác động hiệu năng đua thực tế thấp.
