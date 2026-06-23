# VNRacing (PrototypeRacing) — Audit Tổng Hợp (theo taxonomy OpenProject 2026-06-15)

> Báo cáo audit kỹ thuật. Chỉ phân tích, KHÔNG sửa code trong đợt này.
> Keyed theo product taxonomy mới (Epic → Feature). Bảng cái: `Docs/traceability.md`; map cũ F01–F17: `Docs/_legacy_F-map.md`.
> Nguồn dữ liệu: đọc trực tiếp `Source/` C++, CodeGraph DB, `tooling/blueprint_index.json` (17,675 asset, metadata-only),
> và VibeUE live editor (đọc node graph Blueprint thật qua `BlueprintService`).
> Mọi điểm nóng dưới đây đều dẫn chiếu file/hàm/dòng thật. Những chỗ không truy cập được code đều ghi rõ.

## Cách đọc bảng
- **Loại**: C++ / BP (Blueprint) / Mixed.
- **Mức ưu tiên**:
  - **P0** — ảnh hưởng hiệu năng runtime mỗi frame trong race HOẶC rủi ro crash/tiền tệ; cần xử lý trước.
  - **P1** — chi phí đáng kể nhưng không mỗi-frame, hoặc nợ kiến trúc ảnh hưởng bảo trì/mở rộng.
  - **P2** — dọn dẹp, nhất quán hóa, rủi ro thấp.

## Bảng ưu tiên toàn project

| Feature | Điểm nóng nghiêm trọng nhất (file/hàm thật) | Ưu tiên | Loại |
|---|---|---|---|
| DM-RACE Basic Racing | `ARaceTrackManager::Tick` → `HandleUpdateRanking()` chạy mỗi frame: lặp toàn bộ xe + `GetPlayerRaceStates()` (`GenerateValueArray` + `Algo::Sort` O(n log n) + cấp phát `TArray` mới) mỗi frame (`RaceTrackManager.cpp:207,834-877`) | **P0** | C++ |
| DM-RACE Basic Racing | `ARacingCarController::HandleRankingUpdateCallToClient` gọi `GetAllActorsOfClass` + vòng lặp lồng O(n²) match xe MỖI lần ranking update (`RacingCarController.cpp:286-308`) | **P0** | C++ |
| CU-ROOM Customize Room | `UCarCustomizationManager::GetCarMeshes/GetCarMeshesByConfiguration` dùng `LoadSynchronous()` blocking cho mesh + material từng part (`CarCustomizationManager.cpp:372,383,414,425,484,495,524,535`) | **P0** | C++ |
| SUP-POOL Object Pooling | `UActorObjectPoolSubsystem::ReleaseActor` truy cập `ActorClassDict[ActorToRelease]` không `Contains` → crash nếu actor lạ; cả Get/Release đều quét tuyến tính `Availability` (`ActorObjectPoolSubsystem.cpp:45-59,8-43`) | **P0** | C++ |
| DM-PHYS DriveMode - Physics | `ASimulatePhysicsCar` Tick mỗi frame mỗi xe; `UCustomChaosWheeledVehicle` và `URaceComponent` bật `bCanEverTick=true` nhưng thân TickComponent rỗng → đăng ký tick lãng phí (`CustomChaosWheeledVehicle.cpp:12,28-33`, `RaceComponent.cpp:12,29-34`) | **P1** | Mixed |
| SUP-INV Inventory | `UItemDatabase::GetItemDefinition` bỏ qua `ItemCache` đã build, gọi thẳng `FindRow` + không null-check `ItemDefinitionsTable` (`ItemDatabase.cpp:36-44`) | **P1** | C++ |
| SUP-PERF Performance & PSO | `ULiteSignificanceManager::HandleTick` hai nhánh actor vs Niagara dùng hai idiom state khác nhau (`xor` gán trực tiếp vs `==` toggle) → dễ sai trạng thái; truy cập `ActiveStateChecker[Actor]` bằng `operator[]` (`LiteSignificanceManager.cpp:58,77-82`) | **P1** | C++ |
| SUP-SHOP Shop / IAP / Ads | Chỉ `FMockCommerceProvider` được wire; provider Android/iOS bị comment; KHÔNG có server verification receipt (`CommerceSubsystem.cpp:14-23,80-85`) | **P1** | C++ |
| SUP-AI Racer AI | `UAIManagerSubsystem::ConfigAiCarPerformance` gọi `CalculatePerformanceStats` (FindRow chain) mỗi lần register xe; `RegisterAICar` quét tuyến tính `AIScheduledTicks` chống trùng (`AIManagerSubsystem.cpp:165-190,219-225`) | **P1** | C++ |
| GM-MP MULTIPLAYER | Coupling hai chiều: `UNakamaServiceSubsystem` giữ ref `UMatchServiceSubsystem` và ngược lại (`NakamaServiceSubsystem.cpp:8,90,157-162`) | **P1** | C++ |
| CDN Content Download | `UChunkDownloaderWidget::OpenDownloadableMap` dùng `GetAllActorsOfClass` + `StaticLoadClass` blocking + `AddOnScreenDebugMessage` còn trong code (`ChunkDownloaderWidget.cpp:133-186`); `ChunkDownloaderController.cpp:21` `LoadSynchronous` widget class | **P1** | C++ |
| SUP-PROF User Profile / Economy | `ContainsBadWords` quét O(name × số_từ_cấm) mỗi lần đặt tên; top-speed sampling timer 5Hz (`ProfileManagerSubsystem.cpp:14-30,519`) | **P2** | C++ |
| VT-REWARD Reward | `URewardCenterSubsystem::CreateRewardResultFromItem` `LoadSynchronous` icon item khi resolve reward (`RewardCenterSubsystem.cpp:219`) | **P2** | C++ |
| SUP-DBG Debug & Track Test | `UMistakeDetector` TickComponent mỗi frame + `GetAllActorsOfClassWithTag` cho boundary spline (`MistakeDetector.cpp:113,126`); chỉ chạy trong chế độ test | **P2** | C++ |
| VT-CITY City Progression | `UProgressionSubsystem` file 2641 dòng (god-object); `UProgressionCenterSubsystem::...LoadSynchronous` ảnh icon (`ProgressionCenterSubsystem.cpp:489`) | **P2** | C++ |
| GM-MP MULTIPLAYER | Race flow server-authoritative CHƯA hiện thực; `AMultiplayerWaitingRoomGameMode` mới chỉ validate join-token + travel (`MultiplayerWaitingRoomGameMode.cpp`) | **P2 (gap)** | C++ |
| SUP-TUT Tutorial / Onboarding | `UTutorialManagerSubsystem` 674 dòng; BP tutorial (`WBP_ScriptTutorial`, `WBP_TooltipTutorial`) KHÔNG có Event Tick (event-driven — tốt, đã verify VibeUE) | **P2** | Mixed |
| DM-SET SETTING | `UCarSettingSubsystem` 344 dòng, load/apply/save thẳng — không thấy điểm nóng runtime | **P2** | C++ |

## Top 5 cần xử lý trước (P0)
1. **DM-RACE — vòng cập nhật ranking mỗi frame** (`HandleUpdateRanking` + sort + cấp phát mảng). Đây là cost cố định mỗi frame trong mọi cuộc đua, scale theo số xe.
2. **DM-RACE — `GetAllActorsOfClass` + O(n²) trong callback ranking client** (`HandleRankingUpdateCallToClient`). Gọi lại theo tần suất ranking update.
3. **CU-ROOM — `LoadSynchronous` mesh/material khi dựng xe**. Blocking game thread khi vào garage/spawn xe; hitch rõ trên mobile.
4. **SUP-POOL — Object pool thiếu null-guard + quét tuyến tính**. Rủi ro crash + chi phí O(n) mỗi acquire/release.
5. **DM-PHYS — Tick rỗng đăng ký thừa trên component vehicle**. Nhân với số xe → tick overhead vô ích mỗi frame.

## Khoảng cách kế hoạch ↔ code (ngoài audit hiệu năng)
- **GM-DC Daily Challenge (#274)** — ❌ chưa có code; cần xây mới (xem `Docs/ld/GM-DC_daily_challenge.md`).
- **GM-MP server-authoritative race** — ⚠️ gap lớn nhất của Game Mode.
- **Hệ thống nền SUP-*** — 8 hệ thống có code nhưng ngoài CSV; ứng viên refactor.

## Ghi chú độ phủ & giới hạn
- **C++**: đọc trực tiếp, dẫn chiếu dòng chính xác cho mọi feature.
- **Blueprint**: `blueprint_index.json` chỉ là metadata (name/path/class), KHÔNG có node graph. Audit tick BP được làm qua VibeUE live editor cho các BP gameplay/UI trọng yếu (đã verify: BP_Customizable_*, BP_CheckPoint, BP_BoostCheckPoint, BP_DriftZone_Child, BP_SportsCar_Pawn, WBP_PerformanceStat, WBP_ScriptTutorial, WBP_TooltipTutorial). 235 WidgetBlueprint + 384 Blueprint còn lại CHƯA quét hết — cần mở rộng quét VibeUE theo từng feature nếu muốn phủ toàn bộ.
- **Phát hiện sửa lại model**: `WBP_PerformanceStat` CÓ node `Event Tick` nhưng node này KHÔNG nối exec đi đâu (dead node) — không phải hotspot như mô tả trong C4 model ban đầu. Đã ghi đúng trong `CU-ROOM`.
- Mọi feature có code đều có dẫn chiếu thật. Các feature `content`/`infra`/`gap` (VT-MAP, CU-MENU, PC, GM-DC) không có audit hiệu năng vì không phải subsystem runtime.
