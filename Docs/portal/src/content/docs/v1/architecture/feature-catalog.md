---
title: 04. Danh mục tính năng
description: Tính năng theo taxonomy OpenProject 2026-06-15 (Epic → Feature →
  Sub-Feature), kèm code thật và trạng thái.
slug: v1/architecture/feature-catalog
---

Keyed theo **OpenProject 2026-06-15** (Epic → Feature → Sub-Feature). Mỗi tính năng có id OpenProject, code thật hiện thực, và **Trạng thái** phơi bày khoảng cách kế hoạch↔code. Bảng cái: `Docs/traceability.md`. Map cũ F01–F17: `Docs/_legacy_F-map.md`.

**Trạng thái:** ✅ impl · ⚠️ partial · ❌ gap (chưa có code) · 🎨 content (level/asset) · 🔧 infra (devops).

## Epic: Drive Mode (#151)

| Code | OP | Tính năng | Component chính | TT | LD |
|---|---|---|---|---|---|
| DM-PHYS | #279 | DriveMode - Physics | SimulatePhysicsCar, CustomChaosWheeledVehicle, CustomSuspensionComponent, VehicleFactory, PIDControl, car BPs | ✅ | [DM-PHYS](/v1/features/dm-phys) |
| DM-RACE | #324 | Basic Racing | RaceTrackManager, RacingCarGameMode, RaceGameState, RacingCarController, RaceCheckpoint, RaceComponent | ✅ | [DM-RACE](/v1/features/dm-race) |
| DM-NOS | #334 | NOS | SimulatePhysicsCar BoostNitro/Nitrous, BoostCheckPoint, AI NOS | ✅ | [DM-NOS](/v1/features/dm-nos) |
| DM-RAMP | #335 | RAMP | RampZone, Jump/RampBoost | ✅ | [DM-RAMP](/v1/features/dm-ramp) |
| DM-CAM | #336 | CAMERA | FollowCarCamera | ✅ | [DM-CAM](/v1/features/dm-cam) |
| DM-SET | #338 | SETTING | CarSettingSubsystem, GraphicsSettingsActor | ✅ | [DM-SET](/v1/features/dm-set) |

## Epic: VNTour (#183)

| Code | OP | Tính năng | Component chính | TT | LD |
|---|---|---|---|---|---|
| VT-MAP | #168/#169 | VN Tour - Map Đua / Huế City | Level content + ProgressionData tables | 🎨 | [VT-MAP](/v1/features/vt-map) |
| VT-CITY | #329 | City Progression (subs: Goals Unlock #331, Goals Config #333, Goals Reward #340, Car Unlock #337, Map Scene Unlock #339) | ProgressionCenterSubsystem, ProgressionSubsystem (CityGoals/Tier/Unlock) | ✅ | [VT-CITY](/v1/features/vt-city) |
| VT-TRACK | #341 | Area-Track Unlock (subs: Track Selection #342, Track config #343) | ProgressionSubsystem (UnlockNext, RecalculateTrackDifficulty) | ✅ | [VT-TRACK](/v1/features/vt-track) |
| VT-CARPROG | #344 | Car-Progression | CarRatingSubsystem (CR theo city) | ✅ | [VT-CARPROG](/v1/features/vt-carprog) |
| VT-REWARD | #345 | Reward | RewardCenterSubsystem (LootCrate), AchievementSubsystem, FanServiceSubsystem | ✅ | [VT-REWARD](/v1/features/vt-reward) |

## Epic: GAME MODE (#272)

| Code | OP | Tính năng | Component chính | TT | LD |
|---|---|---|---|---|---|
| GM-MP | #273 | MULTIPLAYER | NakamaServiceSubsystem, MatchServiceSubsystem, NakamaNetworkSubsystem, MultiplayerWaitingRoomGameMode | ⚠️ | [GM-MP](/v1/features/gm-mp) |
| GM-DC | #274 | DAILY CHALLENGE | — (chưa có code) | ❌ | [GM-DC](/v1/features/gm-dc) |

## Epic: CUSTOMIZE (#298)

| Code | OP | Tính năng | Component chính | TT | LD |
|---|---|---|---|---|---|
| CU-ROOM | #299 | Customize Room | CarCustomizationManager, CustomizeCarSubsystem, CarSaveGameManager, CarConfigurationJsonSerializer | ✅ | [CU-ROOM](/v1/features/cu-room) |
| CU-MENU | #320 | Main menu\_Level | UI shell + level content | 🎨 | [CU-MENU](/v1/features/cu-menu) |

## Top-level / Infra

| Code | OP | Tính năng | Component chính | TT | LD |
|---|---|---|---|---|---|
| CDN | #250 | CDN | ChunkDownloaderSubsystem, ChunkDownloaderController, ChunkDownloaderWidget | ✅ | [CDN](/v1/features/cdn) |
| PC | #148 | Project Config | devops/build (k6, AWS chunk upload) | 🔧 | [PC](/v1/features/pc) |

## Hệ thống nền (Support — code thật, ngoài CSV; ứng viên refactor)

| Code | Hệ thống | Component chính | LD |
|---|---|---|---|
| SUP-AI | Racer AI | AIManagerSubsystem, AIDecisionComponent, GuideLineSubsystem | [SUP-AI](/v1/features/sup-ai) |
| SUP-POOL | Object Pooling | ActorObjectPoolSubsystem, PoolObjectInterface | [SUP-POOL](/v1/features/sup-pool) |
| SUP-INV | Inventory | InventoryManager, ItemDatabase | [SUP-INV](/v1/features/sup-inv) |
| SUP-PROF | User Profile / Economy | ProfileManagerSubsystem, RaceSessionSubsystem, SnapshotAdapterSubsystem | [SUP-PROF](/v1/features/sup-prof) |
| SUP-SHOP | Shop / IAP / Ads | CommerceSubsystem, MockCommerceProvider | [SUP-SHOP](/v1/features/sup-shop) |
| SUP-TUT | Tutorial / Onboarding | TutorialManagerSubsystem, TriggerCondition | [SUP-TUT](/v1/features/sup-tut) |
| SUP-DBG | Debug & Track Test | DebugToolsSubsystem, BatchSimulationManager, MistakeDetector, RaceDataCollector | [SUP-DBG](/v1/features/sup-dbg) |
| SUP-PERF | Performance & PSO | PerformanceMonitorSubsystem, LiteSignificanceManager, PSOEffectManager, RestLevelManager | [SUP-PERF](/v1/features/sup-perf) |
