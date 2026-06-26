---
title: "GM-DC — DAILY CHALLENGE"
description: "Gap doc: tính năng được yêu cầu nhưng chưa hiện thực — pool nhiệm vụ hằng ngày, reset theo ngày và màn hình daily challenge."
---

> OpenProject: #274.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `gmDc`).

## Tổng quan

❌ **Trạng thái: gap.** OpenProject #274 định nghĩa tính năng Daily Challenge cho VNRacing. Toàn bộ codebase `PrototypeRacing/` đã được kiểm tra qua CodeGraph và context-engine — **không tồn tại bất kỳ subsystem, class hay data asset nào** hiện thực pool nhiệm vụ hằng ngày, cơ chế reset theo ngày hay màn hình daily challenge.

## Làm rõ: FanServiceSubsystem KHÔNG tái dùng được trực tiếp

`UFanServiceSubsystem` có trong codebase nhưng chỉ xử lý thử thách điểm fan **trong lúc đua** (in-race only). Không có khái niệm giao nhiệm vụ theo ngày, reset lịch hay lưu trữ giữa các session. Không thể tái dùng trực tiếp cho GM-DC mà không thiết kế lại đáng kể.

## Phạm vi cần xây dựng

| Component (đề xuất) | Vai trò |
|---|---|
| `UDailyChallengeSubsystem` | Pool nhiệm vụ: load từ DataTable, giao N nhiệm vụ mỗi ngày, lưu gán nhiệm vụ theo ngày lịch. |
| Cơ chế reset hằng ngày | Khi khởi session, so sánh ngày lưu với ngày hiện tại; nếu khác thì làm mới nhiệm vụ và reset trạng thái hoàn thành. |
| Màn hình Daily Challenge (UMG) | Hiển thị nhiệm vụ hôm nay kèm thanh tiến trình, trạng thái hoàn thành và xem trước phần thưởng; truy cập từ main menu. |
| `FDailyChallengeConfig` (DataTable row) | Định nghĩa mỗi nhiệm vụ: mô tả, loại mục tiêu, giá trị đích, tham chiếu phần thưởng. |

## Tích hợp đề xuất

- `UDailyChallengeSubsystem` đăng ký nhận sự kiện kết quả đua từ DM-RACE (cùng delegate surface với `UProgressionCenterSubsystem`) để tăng tiến trình các nhiệm vụ in-race.
- Reset hằng ngày hook vào khởi tạo game session (`UGameInstance::Init` hoặc subsystem kiểm tra ngày riêng).
- Dispatch phần thưởng ủy quyền cho VT-REWARD (`URewardCenterSubsystem`) để thống nhất với pipeline thưởng hiện có.

## Phần chưa kiểm chứng

Toàn bộ feature chưa tồn tại trong code. Không có file audit — không có code để audit.

## Tham chiếu

- LD: `Docs/ld/GM-DC_daily_challenge.md`
- Cross-ref: VT-REWARD (pipeline thưởng), DM-RACE (sự kiện kết quả đua)
