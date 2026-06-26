# VNRacing — Traceability: OpenProject ↔ Kiến trúc Code ↔ Trạng thái

> **Nguồn chuẩn (contract):** `Docs/OpenProject_Work_packages_2026-06-23…re4snw.csv` (danh sách feature team chốt ngày 2026-06-23).
> **Nguồn sự thật triển khai:** source `PrototypeRacing/` (đối chiếu qua CodeGraph + context-engine).
> Tài liệu này là bảng cái: mỗi Feature/Sub-Feature trong CSV được neo vào code thật đang hiện thực nó, kèm **Trạng thái** phơi bày khoảng cách kế hoạch ↔ code. Danh sách "gap"/"partial" chính là đầu vào cho việc tái cấu trúc code.

## Quy ước

- **Mã sản phẩm (Code):** phân cấp theo Epic — `DM-*` Drive Mode, `VT-*` VNTour, `GM-*` Game Mode, `CU-*` Customize, `SH-*` Shop & IAP, `CDN`, `PC` Project Config. Sub-feature nối thêm hậu tố.
- **OP ID:** số work-package trong OpenProject (tra ngược CSV).
- **Trạng thái:**
  - ✅ **impl** — có code thật, hoạt động.
  - ⚠️ **partial** — có code nhưng chưa đủ so với mô tả feature (gap rõ ràng).
  - ❌ **gap** — feature trong CSV nhưng CHƯA có code → cần xây mới.
  - 🎨 **content** — là nội dung level/asset, không phải subsystem code.
  - 🔧 **infra** — devops/build, không phải runtime feature.
- **🆕:** Feature/Sub-Feature mới thêm vào CSV 2026-06-23, không có trong CSV 2026-06-15.
- **Map cũ (F##):** mã F01–F17 của bộ tài liệu trước (xem `Docs/_legacy_F-map.md`).

## Bảng cái — Feature → Code → Trạng thái

> Mỗi Feature (loại `Feature` trong CSV) có một dòng. Sub Feature được liệt kê trong cột "Sub Features" của Feature cha. Thứ tự sắp xếp: theo Epic rồi theo Mã alphabetically.

| Mã | OP ID | Tên Feature | Epic | 🆕 | Sub Features | Code thật | TT | Map cũ | LD |
|---|---|---|---|---|---|---|---|---|---|
| CDN | #250 | CDN | (top-level) | | | ChunkDownloaderSubsystem, ChunkDownloaderController, ChunkDownloaderWidget | ✅ | F13 | `ld/CDN_content_download.md` |
| PC | #148 | Project Config | (top-level) | | | devops/build (k6 load test, AWS chunk upload) — ngoài client runtime | 🔧 | — | `ld/PC_project_config.md` |
| CU-THEME | #400 | Theme Change | CUSTOMIZE | 🆕 | CU-ROOM (#299, Customize Room_Theme Change, ✅), CU-MENU (#320, Main menu_Theme Change, 🎨) | Subsystems: CarCustomizationManager (room), UI shell + level (menu) | 🎨 | — | `ld/CU-THEME_theme_change.md` |
| CU-VIS | #401 | Car Customize Visual | CUSTOMIZE | 🆕 | CU-VIS-BODY (#555, Customize Body Parts, ❌), CU-VIS-PAINT (#556, Customize Paints & Decals, ❌), CU-VIS-PREV (#557, Customize Preview, ❌), CU-VIS-CAM (#558, Camera Functions, ❌), CU-VIS-TEST (#559, Car Test, ❌) | — (chưa có subsystem; Customize Room hiện tại chỉ có garage/customize UI) | ❌ | — | `ld/CU-VIS_car_customize_visual.md` |
| CU-PERF | #402 | Car Customize Performance | CUSTOMIZE | 🆕 | CU-PERF-CORE (#563, Core Upgrades, ❌), CU-PERF-CR (#564, Car CR Calculations, ❌), CU-PERF-DRIVE (#565, Performance Test Drive, ❌) | — (chưa có subsystem; CR calculation nằm trong CarCustomizationManager nhưng chưa có UI/tuning riêng) | ❌ | — | `ld/CU-PERF_car_customize_performance.md` |
| CU-SEL | #403 | Car Selection | CUSTOMIZE | 🆕 | | — (chưa có subsystem/UI) | ❌ | — | `ld/CU-SEL_car_selection.md` |
| DM-PHYS | #279 | DriveMode - Physics | Drive Mode | | | SimulatePhysicsCar, CustomChaosWheeledVehicle, CustomSuspensionComponent, VehicleFactory, PIDControl, car BPs | ✅ | F01 | `ld/DM-PHYS_drivemode_physics.md` |
| DM-RACE | #324 | Basic Racing | Drive Mode | | DM-RACE-MINIMAP (#371, Minimap, ❌ 🆕) | RaceTrackManager, RacingCarGameMode, RaceGameState, RacingCarController, RaceCheckpoint, RaceComponent | ✅ | F02 | `ld/DM-RACE_basic_racing.md` |
| DM-NOS | #334 | NOS | Drive Mode | | | SimulatePhysicsCar::BoostNitro, BoostCheckPoint, AI NOS | ✅ | F01/F03 | `ld/DM-NOS_nos.md` |
| DM-RAMP | #335 | RAMP | Drive Mode | | | RampZone, Jump/RampBoost on pawn | ✅ | F01 | `ld/DM-RAMP_ramp.md` |
| DM-CAM | #336 | CAMERA | Drive Mode | | | FollowCarCamera | ✅ | F01 | `ld/DM-CAM_camera.md` |
| DM-SET | #338 | SETTING | Drive Mode | | | CarSettingSubsystem, GraphicsSettingsActor | ✅ | F15 | `ld/DM-SET_setting.md` |
| GM-MP | #273 | MULTIPLAYER | GAME MODE | | GM-MP-MATCH (#437, Ghép Trận, ❌ 🆕), GM-MP-RACE (#447, Vào Trận - Trong Trận, ❌ 🆕), GM-MP-POST (#448, Sau trận, ❌ 🆕) | NakamaServiceSubsystem, MatchServiceSubsystem, NakamaNetworkSubsystem, MultiplayerWaitingRoomGameMode | ⚠️ | F11+F12 | `ld/GM-MP_multiplayer.md` |
| GM-DC | #274 | DAILY CHALLENGE | GAME MODE | | GM-DC-UN (#426, Challenge Unlock, ❌ 🆕), GM-DC-CFG (#431, Challenge Config, ❌ 🆕) | — (chưa có subsystem; FanServiceSubsystem chỉ là challenge trong-race) | ❌ | — | `ld/GM-DC_daily_challenge.md` |
| SH-DISP | #405 | Shop Display | SHOP & IAP | 🆕 | | — (chưa có subsystem; UI BPs: WBP_Shop, WBP_Popup_Shopping, WBP_Card_DLC) | ❌ | — | `ld/SH_shop_iap.md` |
| SH-FLOW | #455 | Purchase Flow | SHOP & IAP | 🆕 | | — (chưa có subsystem; Dùng: UCommerceSubsystem, FMockCommerceProvider) | ❌ | — | `ld/SH_shop_iap.md` |
| VT-MAP | #168/#169 | VN Tour - Map Đua / Huế City | VNTour | | | Level content (Đại Nội/Quốc Học/Hồ Thuỷ Tiên) + ProgressionData map/area/track tables | 🎨 | — | `ld/VT-MAP_vntour_map.md` |
| VT-CITY | #329 | City Progression | VNTour | | VT-CITY-GU (#331, Goals Unlock, ✅), VT-CITY-GC (#333, Goals Config, ✅), VT-CITY-GR (#340, Goals Reward, ✅ 🔄), VT-CITY-CU (#337, Car Unlock, ✅), VT-CITY-MU (#339, Map Scene Unlock, ✅), VT-CITY-IU (#386, Item Unlock, ❌ 🆕) | ProgressionCenterSubsystem, ProgressionSubsystem (CityGoals/Tier/Unlock), RewardCenterSubsystem | ✅ | F05 | `ld/VT-CITY_city_progression.md` |
| VT-TRACK | #341 | Area-Track Unlock | VNTour | | VT-TRACK-SEL (#342, Track Selection, ✅), VT-TRACK-CFG (#343, Track Config, ✅), VT-TRACK-RW (#424, Track Rewards, ❌ 🆕), VT-TRACK-UN (#425, Track Unlock, ❌ 🆕) | ProgressionSubsystem (UnlockNext, RecalculateTrackDifficulty) | ✅ | F05 | `ld/VT-TRACK_area_track_unlock.md` |
| VT-CARPROG | #344 | Car-Progression | VNTour | | | CarRatingSubsystem (CR by city) | ✅ | F05/F06 | `ld/VT-CARPROG_car_progression.md` |
| VT-REWARD | #345 | Reward | VNTour | | | RewardCenterSubsystem (LootCrate), AchievementSubsystem, FanServiceSubsystem | ✅ | F09 | `ld/VT-REWARD_reward.md` |

> **🔄 Ghi chú:** VT-CITY-GR (#340 Goals Reward) được liệt kê ở CSV 2026-06-15 nhưng không xuất hiện trong CSV 2026-06-23 — có thể đã được gộp vào luồng trao thưởng chính. Code thật (`GrantRewardsForCompletedGoal`) vẫn tồn tại, nên giữ trong bảng để không mất độ phủ.

## Hệ thống nền (Support) — code thật, KHÔNG có feature tương ứng trong CSV

Các subsystem này đang chạy thật trong code nhưng không được liệt kê là feature sản phẩm trong CSV (hạ tầng/cross-cutting). **Giữ lại trong tài liệu** để không mất độ phủ codebase, và đây là nhóm **ứng viên refactor** rõ nhất (code có nhưng không nằm trong contract sản phẩm).

| Mã | Hệ thống nền | Code thật | Map cũ |
|---|---|---|---|
| SUP-AI | Racer AI | `UAIManagerSubsystem`, `UAIDecisionComponent`, `UGuideLineSubsystem` | F03 |
| SUP-POOL | Object Pooling | `UActorObjectPoolSubsystem`, `IPoolObjectInterface` | F04 |
| SUP-INV | Inventory | `UInventoryManager`, `UItemDatabase` | F07 |
| SUP-PROF | User Profile / Economy | `UProfileManagerSubsystem`, `URaceSessionSubsystem`, `USnapshotAdapterSubsystem` | F08 |
| SUP-SHOP | Shop / IAP / Ads | `UCommerceSubsystem`, `FMockCommerceProvider` | F10 |
| SUP-TUT | Tutorial / Onboarding | `UTutorialManagerSubsystem`, `UTriggerCondition` | F14 |
| SUP-DBG | Debug & Track Test | `UDebugToolsSubsystem`, `UBatchSimulationManager`, `UMistakeDetector`, `URaceDataCollector` | F16 |
| SUP-PERF | Performance & PSO | `UPerformanceMonitorSubsystem`, `ULiteSignificanceManager`, `APSOEffectManager`, `ARestLevelManager` | F17 |

## Khoảng cách kế hoạch ↔ code (đầu vào refactor)

1. **GM-DC Daily Challenge (#274)** — ❌ chưa có code. Cần subsystem nhiệm vụ hằng ngày riêng (pool nhiệm vụ + reset theo ngày + UI). `FanServiceSubsystem` không tái dùng trực tiếp được (chỉ challenge trong-race).
2. **GM-DC-UN Challenge Unlock (#426), GM-DC-CFG Challenge Config (#431)** — ❌ sub-features của Daily Challenge, chưa có code.
3. **GM-MP Multiplayer (#273)** — ⚠️ mới có waiting-room + join-token validate; **race flow server-authoritative chưa hiện thực** (`AMultiplayerWaitingRoomGameMode`). Đây là gap lớn nhất của Game Mode.
4. **GM-MP-MATCH (#437), GM-MP-RACE (#447), GM-MP-POST (#448)** — ❌ sub-features của Multiplayer, chưa có code tương ứng.
5. **CU-VIS (#401) và các sub-feature** — ❌ chưa có subsystem tùy biến hình ảnh riêng; hiện tại chỉ có garage cơ bản qua CU-ROOM.
6. **CU-PERF (#402) và các sub-feature** — ❌ chưa có UI/tuning riêng cho hiệu năng; CR calculation đang nằm trong CU-ROOM.
7. **CU-SEL (#403) Car Selection** — ❌ chưa có subsystem/UI chọn xe.
8. **SH-DISP (#405) Shop Display** — ❌ chưa có code.
9. **SH-FLOW (#455) Purchase Flow** — ❌ chưa có code.
10. **DM-RACE-MINIMAP (#371)** — ❌ chưa có code minimap trong-race.
11. **VT-CITY-IU (#386) Item Unlock** — ❌ chưa có code.
12. **VT-TRACK-RW (#424) Track Rewards, VT-TRACK-UN (#425) Track Unlock** — ❌ chưa có code tương ứng.
13. **Support subsystems (SUP-*)** — 8 hệ thống có code nhưng ngoài contract. Cần quyết: giữ, gộp vào feature nào, hay tách module khi refactor.
14. **VT-MAP / CU-MENU** — là content/level, không phải code; theo dõi tiến độ ở OpenProject (Level/2D/3D team), không phải ở tài liệu kiến trúc.

