---
title: 04. Danh mục tính năng
description: Tính năng theo taxonomy OpenProject 2026-06-15 (Epic → Feature → Sub-Feature), kèm code thật và trạng thái.
---

Keyed theo **OpenProject 2026-06-15** (Epic → Feature → Sub-Feature). Mỗi tính năng có id OpenProject, code thật hiện thực, và **Trạng thái** phơi bày khoảng cách kế hoạch↔code. Bảng cái: `Docs/traceability.md`. Map cũ F01–F17: `Docs/_legacy_F-map.md`.

**Trạng thái:** ✅ impl · ⚠️ partial · ❌ gap (chưa có code) · 🎨 content (level/asset) · 🔧 infra (devops).

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
| VT-CITY | #329 | City Progression (subs: Goals Unlock #331, Goals Config #333, Goals Reward #340, Car Unlock #337, Map Scene Unlock #339) | ProgressionCenterSubsystem, ProgressionSubsystem (CityGoals/Tier/Unlock) | ✅ | [VT-CITY](/features/vt-city) |
| VT-TRACK | #341 | Area-Track Unlock (subs: Track Selection #342, Track config #343) | ProgressionSubsystem (UnlockNext, RecalculateTrackDifficulty) | ✅ | [VT-TRACK](/features/vt-track) |
| VT-CARPROG | #344 | Car-Progression | CarRatingSubsystem (CR theo city) | ✅ | [VT-CARPROG](/features/vt-carprog) |
| VT-REWARD | #345 | Reward | RewardCenterSubsystem (LootCrate), AchievementSubsystem, FanServiceSubsystem | ✅ | [VT-REWARD](/features/vt-reward) |

{/* CAT2 */}
## Epic: GAME MODE (#272)

| Code | OP | Tính năng | Component chính | TT | LD |
|---|---|---|---|---|---|
| GM-MP | #273 | MULTIPLAYER | NakamaServiceSubsystem, MatchServiceSubsystem, NakamaNetworkSubsystem, MultiplayerWaitingRoomGameMode | ⚠️ | [GM-MP](/features/gm-mp) |
| GM-DC | #274 | DAILY CHALLENGE | — (chưa có code) | ❌ | [GM-DC](/features/gm-dc) |

## Epic: CUSTOMIZE (#298)

| Code | OP | Tính năng | Component chính | TT | LD |
|---|---|---|---|---|---|
| CU-ROOM | #299 | Customize Room | CarCustomizationManager, CustomizeCarSubsystem, CarSaveGameManager, CarConfigurationJsonSerializer | ✅ | [CU-ROOM](/features/cu-room) |
| CU-MENU | #320 | Main menu_Level | UI shell + level content | 🎨 | [CU-MENU](/features/cu-menu) |

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
