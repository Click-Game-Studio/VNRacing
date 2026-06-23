# DM-SET — SETTING

## Phạm vi
Cài đặt đồ họa/gameplay/điều khiển/âm thanh/ngôn ngữ: load, apply và lưu. Không bao gồm ví profile, progression, hay cài đặt cấp OS. Steering-sensitivity (#353) là pending trong phạm vi này.

## Module/class C++ liên quan (file thật)
- `Source/PrototypeRacing/Private/SettingSystem/CarSettingSubsystem.cpp` — `UCarSettingSubsystem` (344 dòng): `Initialize` (dòng 24, tạo default VolumeConfig), `SaveSettings`, `CheckGraphicSettings`, `LoadGraphicSettings` (BlueprintCallable).
- `Source/PrototypeRacing/Public/SettingSystem/CarSaveSetting.h` — `UCarSaveSetting` (`USaveGame`): lưu `FVolumeConfig[]`, `FPlayerControl`, `FDisplaySettings`, `FGraphicSetting`, `FLanguageSettings`.
- `Source/PrototypeRacing/Private/SettingSystem/SettingDataProvider.cpp` — `USettingDataProvider`: cung cấp data cho subsystem.
- `Source/PrototypeRacing/Private/SettingSystem/GraphicsSettingsActor.cpp` — `AGraphicsSettingsActor`: áp scalability UE tại runtime; actor đặt trong level.

## Blueprint liên quan
- `WBP settings` (`/Game/UI`): event-driven (đổi slider → apply), không tick. Gọi subsystem BPAPI.

## Điểm nóng hiệu năng cụ thể
- Không có hotspot per-frame. Apply scalability (`AGraphicsSettingsActor`) có thể gây hitch 1 frame khi đổi preset đồ họa nặng — bình thường với UE scalability.
- **Cần xác nhận:** `SaveSettings` chỉ gọi khi user confirm (không gọi mỗi lần kéo slider) — nếu gọi mỗi thay đổi nhỏ thì là I/O thừa. Chưa soi chi tiết thời điểm gọi `SaveSettings` trong flow UI.

## Nợ kỹ thuật cụ thể
- `AGraphicsSettingsActor` là actor đặt trong level — cần tồn tại ở mọi level để áp setting; cân nhắc chuyển sang subsystem thuần.
- **Steering-sensitivity (#353):** `FPlayerControl` hiện chỉ có `EControlType` + `EDriftMode`; chưa có field `SteeringSensitivity` (float). Cần thêm field + expose qua `UCarSettingSubsystem` + update `UCarSaveSetting` accessor.
- Setting lưu theo `UCarSaveSetting` (per-game, không per-car) — xác nhận schema SaveVersion đủ xử lý migration khi thêm field mới (#353).

## Mức ưu tiên: **P2**
Lý do: không hotspot runtime. Cần xác nhận tần suất `SaveSettings` để tránh I/O thừa. #353 steering-sensitivity là P1 (feature pending, cần implement).
