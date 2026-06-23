---
title: 05. Sơ đồ Runtime
description: Các kịch bản runtime chính — vòng đời race, vòng lặp customization,
  backend/multiplayer, hỗ trợ hiệu năng.
slug: v1/architecture/runtime-view
---

Các component view được nhắc dưới đây đều tương tác được trên trang [Kiến trúc](/v1/architecture) (F02, F06, F11, F17).

## Kịch bản A: Vòng đời race

1. `RacingCarGameMode` tạo/khởi tạo `RaceTrackManager`, xe player và xe AI.
2. Sự kiện overlap của `RaceCheckpoint` đẩy dữ liệu vào `RaceTrackManager::HandleVehicleDetectedAtCheckpoint`.
3. `RaceTrackManager` cập nhật trạng thái từng xe, ranking và việc hoàn thành race.
4. `RacingCarController` chuyển tiếp race state về HUD/xe phía client.
5. Khi race kết thúc, `RaceTrackManager` broadcast kết quả cho `ProgressionCenterSubsystem`.

Điểm nóng then chốt: ranking hiện bắt nguồn từ Tick mỗi frame và thực hiện tính lại distance + copy/sort + broadcast. ADR-0001 ghi nhận hướng đã thống nhất là chuyển cập nhật ranking ra khỏi Tick.

## Kịch bản B: Vòng lặp customization / profile / progression

1. UI gọi `CarCustomizationManager` để preview/áp dụng các part hình thức và hiệu năng.
2. Customization kiểm tra ví và item bắt buộc qua `ProfileManagerSubsystem` và `InventoryManager`.
3. `CarRatingSubsystem` tính CR/ảnh hưởng chỉ số.
4. `CarSaveGameManager` lưu cấu hình.
5. Sau mỗi race, `ProgressionCenterSubsystem` ghi nhận kết quả, trao reward, cập nhật achievement và tiền tệ profile.

Điểm nóng then chốt: các lần load asset đồng bộ (blocking) trong customization và việc resolve icon reward có thể gây giật (hitch) game thread trên mobile.

## Kịch bản C: Backend / multiplayer / content

1. `NakamaServiceSubsystem` quản lý vòng đời client/session/realtime.
2. `MatchServiceSubsystem` dựng query matchmaking và tiêu thụ các sự kiện matched/presence.
3. `SnapshotAdapterSubsystem` dùng Nakama RPC để đồng bộ snapshot profile.
4. `MultiplayerWaitingRoomGameMode` kiểm tra join token và travel vào path waiting room/race.
5. Content download dùng ChunkDownloader và UI patch; luồng content đầy đủ nên tránh các lần load blocking và debug message trong bản shipping.

Phần chưa kiểm chứng: nguồn xác nhận các dịch vụ online phía client và việc kiểm tra waiting room, nhưng chưa xác nhận một server-authoritative race authority hoàn chỉnh.

## Kịch bản D: Hỗ trợ hiệu năng và debug

* `PerformanceMonitorSubsystem` đo đạc hiệu năng runtime.
* `LiteSignificanceManager` định kỳ cull các actor/Niagara đã đăng ký theo khoảng cách.
* `PSOEffectManager` và `RestLevelManager` hỗ trợ warmup shader/PSO và travel ổn định.
* `DebugToolsSubsystem`, `BatchSimulationManager`, `MistakeDetector` và `RaceDataCollector` hỗ trợ các luồng track-test và chẩn đoán.

Các hệ thống này phải giữ vai trò ranh giới hỗ trợ/tooling, không trở thành phụ thuộc ẩn trong bản shipping.
