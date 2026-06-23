---
title: DM-SET SETTING
description: Thiết kế chi tiết — cài đặt đồ họa, gameplay, điều khiển, âm thanh, ngôn ngữ; load/apply/save. Bao gồm steering-sensitivity pending (#353).
---

> Nguồn: `Docs/audit/DM-SET_setting.md`, `Docs/c4/model.c4`, bằng chứng đọc nguồn (read-only) dưới `PrototypeRacing/Source`.
> View Structurizr: `DM_SET_Components`. OpenProject: #338.

## Tổng quan

DM-SET lo phần load, apply và lưu cài đặt đồ họa/gameplay/điều khiển/âm thanh/ngôn ngữ. Steering-sensitivity (OpenProject #353) là pending: `FPlayerControl` hiện chỉ có `EControlType` + `EDriftMode`; chưa có field sensitivity.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `dmSet`).

## Phạm vi

DM-SET không đụng tới ví profile, progression, hay cài đặt cấp OS của nền tảng.

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `UCarSettingSubsystem` | `SettingSystem/CarSettingSubsystem.cpp` (344 dòng) | Load/apply/save tất cả setting vào `UCarSaveSetting`. |
| `UCarSaveSetting` | `SettingSystem/CarSaveSetting.h` | `USaveGame`: lưu volume, control, display, graphic, language. |
| `AGraphicsSettingsActor` | `SettingSystem/GraphicsSettingsActor.cpp` | Áp dụng scalability UE tại runtime; actor đặt trong level. |
| `USettingDataProvider` | `SettingSystem/SettingDataProvider.cpp` | Cung cấp data setting cho subsystem. |

## Luồng xử lý

```
Khởi động game / mở UI setting
   → UCarSettingSubsystem::Initialize (line 24) → load UCarSaveSetting

User thay đổi setting
   → WBP settings (event-driven) → gọi subsystem API → apply ngay
   → AGraphicsSettingsActor áp scalability (nếu là graphic setting)

User confirm / đóng UI
   → UCarSettingSubsystem::SaveSettings → ghi xuống SaveGame
```

## Điểm nóng hiệu năng

Không có hotspot per-frame. Apply scalability có thể gây hitch 1 frame khi đổi preset nặng — bình thường với UE. Cần xác nhận `SaveSettings` chỉ gọi khi confirm, không gọi mỗi lần kéo slider (tránh I/O thừa). Chi tiết tại `Docs/audit/DM-SET_setting.md`.

## API công khai

```cpp
// UCarSettingSubsystem
void Initialize(...);
void SaveSettings();
void CheckGraphicSettings();
UFUNCTION(BlueprintCallable) void LoadGraphicSettings();

// UCarSaveSetting
FPlayerControl   GetPlayerControl();     void SetPlayerControl(...);
FDisplaySettings GetDisplaySettings();  void SetDisplaySettings(ECameraView, ESpeedUnit);
FGraphicSetting  GetGraphicSetting();   void SetGraphicSettings(FGraphicSetting);
TArray<FVolumeConfig> GetVolumeConfigs(); void SetVolumeConfigs(...);
FLanguageSettings GetLanguageSettings(); void SetLanguageSetting(ELanguage);
```

Control types: `EControlType` — SteeringWheel, Button, TiltSteering, ZoneTouch.
Graphic: `EGraphicDetails` (Low/Balance/High/Ultra), `FrameRateLimit`, `TextureQuality`/`AntiAliasing`/`LightQuality`/`ShadowResolution` (0–4), `Bloom`, `MotionBlur`.
Volume types: `EVolumeType` — Generals, Engine, Music, SFX.

## Phần chưa kiểm chứng

Thời điểm gọi `SaveSettings` trong flow UI chưa soi chi tiết — cần xác nhận không gọi mỗi lần thay đổi nhỏ. Steering-sensitivity (#353) chưa có field trong code — cần implement. `SaveVersion` migration khi thêm field mới chưa kiểm tra. Chi tiết tại `Docs/audit/DM-SET_setting.md`.

## Tham chiếu

- Audit: `Docs/audit/DM-SET_setting.md`
- Structurizr: `DM_SET_Components`
- OpenProject: #338, #353 (Steering Sensitivity — pending)
