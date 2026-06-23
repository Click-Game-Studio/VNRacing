---
title: 04. Danh mục tính năng
description: Tính năng theo taxonomy OpenProject 2026-06-23 (Epic → Feature → Sub-Feature), kèm code thật và trạng thái.
---

Keyed theo **OpenProject 2026-06-23** (Epic → Feature → Sub-Feature). Mỗi tính năng có id OpenProject, code thật hiện thực, và **Trạng thái** phơi bày khoảng cách kế hoạch↔code. Bảng cái: `Docs/traceability.md`. Map cũ F01–F17: `Docs/_legacy_F-map.md`.

**Trạng thái:** ✅ impl · ⚠️ partial · ❌ gap (chưa có code) · 🎨 content (level/asset) · 🔧 infra (devops).
**🆕:** Mới trong contract 2026-06-23.

## Epic: Customize (#298)

| Code | OP | Tính năng | Component chính | TT | 🆕 | LD |
|---|---|---|---|---|---|---|
| CU-THEME | #400 | Theme Change (rooms: CU-ROOM #299, CU-MENU #320) | CarCustomizationManager (room), UI shell + level (menu) | 🎨 | 🆕 | [CU-THEME](/features/cu-theme) |
| CU-VIS | #401 | Car Customize Visual (subs: BODY #555, PAINT #556, PREV #557, CAM #558, TEST #559) | — (chưa có subsystem) | ❌ | 🆕 | [CU-VIS](/features/cu-vis) |
| CU-PERF | #402 | Car Customize Performance (subs: CORE #563, CR #564, DRIVE #565) | — (chưa có subsystem; CR calc trong CU-ROOM) | ❌ | 🆕 | [CU-PERF](/features/cu-perf) |
| CU-SEL | #403 | Car Selection | — (chưa có subsystem/UI) | ❌ | 🆕 | [CU-SEL](/features/cu-sel) |

## Epic: Drive Mode (#151)

| Code | OP | Tính năng | Component chính | TT | LD |
|---|---|---|---|---|---|
| DM-PHYS | #279 | DriveMode - Physics | SimulatePhysicsCar, CustomChaosWheeledVehicle, CustomSuspensionComponent, VehicleFactory, PIDControl, car BPs | ✅ | [DM-PHYS](/features/dm-phys) |
| DM-RACE | #324 | Basic Racing | RaceTrackManager, RacingCarGameMode, RaceGameState, RacingCarController, RaceCheckpoint, RaceComponent | ✅ | [DM-RACE](/features/dm-race) |
| DM-NOS | #334 | NOS | SimulatePhysicsCar BoostNitro/Nitrous, BoostCheckPoint, AI NOS | ✅ | [DM-NOS](/features/dm-nos) |
| DM-RAMP | #335 | RAMP | RampZone, Jump/RampBoost | ✅ | [DM-RAMP](/features/dm-ramp) |
| DM-CAM | #336 | CAMERA | FollowCarCamera | ✅ | [DM-CAM](/features/dm-cam) |
| DM-SET | #338 | SETTING | CarSettingSubsystem, GraphicsSettingsActor | ✅ | [DM-SET](/features/dm-set) |

## Epic: VNTour (#183)

| Code | OP | Tính năng | Component chính | TT | LD |
|---|---|---|---|---|---|
| VT-MAP | #168/#169 | VN Tour - Map Đua / Huế City | Level content + ProgressionData tables | 🎨 | [VT-MAP](/features/vt-map) |
| VT-CITY | #329 | City Progression (subs: GU #331, GC #333, GR #340, CU #337, MU #339, IU #386 🆕) | ProgressionCenterSubsystem, ProgressionSubsystem (CityGoals/Tier/Unlock) | ✅ | [VT-CITY](/features/vt-city) |
| VT-TRACK | #341 | Area-Track Unlock (subs: SEL #342, CFG #343, RW #424 🆕, UN #425 🆕) | ProgressionSubsystem (UnlockNext, RecalculateTrackDifficulty) | ✅ | [VT-TRACK](/features/vt-track) |
| VT-CARPROG | #344 | Car-Progression | CarRatingSubsystem (CR theo city) | ✅ | [VT-CARPROG](/features/vt-carprog) |
| VT-REWARD | #345 | Reward | RewardCenterSubsystem (LootCrate), AchievementSubsystem, FanServiceSubsystem | ✅ | [VT-REWARD](/features/vt-reward) |

## Epic: GAME MODE (#272)

| Code | OP | Tính năng | Component chính | TT | LD |
|---|---|---|---|---|---|
| GM-MP | #273 | MULTIPLAYER (subs: MATCH #437 🆕, RACE #447 🆕, POST #448 🆕) | NakamaServiceSubsystem, MatchServiceSubsystem, NakamaNetworkSubsystem, MultiplayerWaitingRoomGameMode | ⚠️ | [GM-MP](/features/gm-mp) |
| GM-DC | #274 | DAILY CHALLENGE (subs: UN #426 🆕, CFG #431 🆕) | — (chưa có code) | ❌ | [GM-DC](/features/gm-dc) |

## Epic: SHOP & IAP (#366)

| Code | OP | Tính năng | Component chính | TT | 🆕 | LD |
|---|---|---|---|---|---|---|
| SH-DISP | #405 | Shop Display | — (chưa có subsystem) | ❌ | 🆕 | [SH-DISP](/features/sh-disp) |
| SH-FLOW | #455 | Purchase Flow | — (chưa có subsystem) | ❌ | 🆕 | [SH-FLOW](/features/sh-flow) |

## Top-level / Infra

| Code | OP | Tính năng | Component chính | TT | LD |
|---|---|---|---|---|---|
| CDN | #250 | CDN | ChunkDownloaderSubsystem, ChunkDownloaderController, ChunkDownloaderWidget | ✅ | [CDN](/features/cdn) |
| PC | #148 | Project Config | devops/build (k6, AWS chunk upload) | 🔧 | [PC](/features/pc) |

## Hệ thống nền (Support — code thật, ngoài CSV; ứng viên refactor)

| Code | Hệ thống | Component chính | LD |
|---|---|---|---|
| SUP-AI | Racer AI | AIManagerSubsystem, AIDecisionComponent, GuideLineSubsystem | [SUP-AI](/features/sup-ai) |
| SUP-POOL | Object Pooling | ActorObjectPoolSubsystem, PoolObjectInterface | [SUP-POOL](/features/sup-pool) |
| SUP-INV | Inventory | InventoryManager, ItemDatabase | [SUP-INV](/features/sup-inv) |
| SUP-PROF | User Profile / Economy | ProfileManagerSubsystem, RaceSessionSubsystem, SnapshotAdapterSubsystem | [SUP-PROF](/features/sup-prof) |
| SUP-SHOP | Shop / IAP / Ads | CommerceSubsystem, MockCommerceProvider | [SUP-SHOP](/features/sup-shop) |
| SUP-TUT | Tutorial / Onboarding | TutorialManagerSubsystem, TriggerCondition | [SUP-TUT](/features/sup-tut) |
| SUP-DBG | Debug & Track Test | DebugToolsSubsystem, BatchSimulationManager, MistakeDetector, RaceDataCollector | [SUP-DBG](/features/sup-dbg) |
| SUP-PERF | Performance & PSO | PerformanceMonitorSubsystem, LiteSignificanceManager, PSOEffectManager, RestLevelManager | [SUP-PERF](/features/sup-perf) |
