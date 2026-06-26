# 04. Feature Catalog

> Keyed to the **OpenProject 2026-06-23** product taxonomy (Epic → Feature → Sub-Feature). Each feature carries its OpenProject id, the real code that implements it, and a **Status** flag exposing the plan↔code gap. Master sheet: [`Docs/traceability.md`](../../traceability.md). Old F01–F17 mapping: [`Docs/_legacy_F-map.md`](../../_legacy_F-map.md).

**Trạng thái:** ✅ impl · ⚠️ partial · ❌ gap (no code) · 🎨 content (level/asset) · 🔧 infra (devops).
**🆕:** New in 2026-06-23 contract.

## Epic: Customize (#298)

| Code | OP | Feature | Main components | Status | New | View | LD | Audit |
|---|---|---|---|---|---|---|---|---|
| CU-THEME | #400 | Theme Change (rooms: CU-ROOM #299, CU-MENU #320) | CarCustomizationManager (room), UI shell + level (menu) | 🎨 | 🆕 | `CU_THEME_Components` | [LD](../../ld/CU-THEME_theme_change.md) | — |
| CU-VIS | #401 | Car Customize Visual (subs: BODY #555, PAINT #556, PREV #557, CAM #558, TEST #559) | — (chưa có subsystem) | ❌ | 🆕 | `CU_VIS_Components` | [LD](../../ld/CU-VIS_car_customize_visual.md) | [Audit](../../audit/CU-VIS_car_customize_visual.md) |
| CU-PERF | #402 | Car Customize Performance (subs: CORE #563, CR #564, DRIVE #565) | — (chưa có subsystem; CR calc trong CU-ROOM) | ❌ | 🆕 | `CU_PERF_Components` | [LD](../../ld/CU-PERF_car_customize_performance.md) | [Audit](../../audit/CU-PERF_car_customize_performance.md) |
| CU-SEL | #403 | Car Selection | — (chưa có subsystem/UI) | ❌ | 🆕 | `CU_SEL_Components` | [LD](../../ld/CU-SEL_car_selection.md) | [Audit](../../audit/CU-SEL_car_selection.md) |

## Epic: Drive Mode (#151)

| Code | OP | Feature | Main components | Status | View | LD | Audit |
|---|---|---|---|---|---|---|---|
| DM-PHYS | #279 | DriveMode - Physics | SimulatePhysicsCar, CustomChaosWheeledVehicle, CustomSuspensionComponent, VehicleFactory, PIDControl, car BPs | ✅ | `DM_PHYS_Components` | [LD](../../ld/DM-PHYS_drivemode_physics.md) | [Audit](../../audit/DM-PHYS_drivemode_physics.md) |
| DM-RACE | #324 | Basic Racing | RaceTrackManager, RacingCarGameMode, RaceGameState, RacingCarController, RaceCheckpoint, RaceComponent | ✅ | `DM_RACE_Components` | [LD](../../ld/DM-RACE_basic_racing.md) | [Audit](../../audit/DM-RACE_basic_racing.md) |
| DM-NOS | #334 | NOS | SimulatePhysicsCar BoostNitro/Nitrous, BoostCheckPoint, AI NOS interval | ✅ | `DM_NOS_Components` | [LD](../../ld/DM-NOS_nos.md) | [Audit](../../audit/DM-NOS_nos.md) |
| DM-RAMP | #335 | RAMP | RampZone, Jump/RampBoost on pawn | ✅ | `DM_RAMP_Components` | [LD](../../ld/DM-RAMP_ramp.md) | [Audit](../../audit/DM-RAMP_ramp.md) |
| DM-CAM | #336 | CAMERA | FollowCarCamera | ✅ | `DM_CAM_Components` | [LD](../../ld/DM-CAM_camera.md) | [Audit](../../audit/DM-CAM_camera.md) |
| DM-SET | #338 | SETTING | CarSettingSubsystem, GraphicsSettingsActor | ✅ | `DM_SET_Components` | [LD](../../ld/DM-SET_setting.md) | [Audit](../../audit/DM-SET_setting.md) |

## Epic: VNTour (#183)

| Code | OP | Feature | Main components | Status | View | LD | Audit |
|---|---|---|---|---|---|---|---|
| VT-MAP | #168/#169 | VN Tour - Map Đua / Huế City | Level content + ProgressionData map/area/track tables | 🎨 | `vtMap` | [LD](../../ld/VT-MAP_vntour_map.md) | — |
| VT-CITY | #329 | City Progression (subs: GU #331, GC #333, GR #340, CU #337, MU #339, IU #386 🆕) | ProgressionCenterSubsystem, ProgressionSubsystem (CityGoals/Tier/Unlock), RewardCenterSubsystem | ✅ | `VT_CITY_Components` | [LD](../../ld/VT-CITY_city_progression.md) | [Audit](../../audit/VT-CITY_city_progression.md) |
| VT-TRACK | #341 | Area-Track Unlock (subs: SEL #342, CFG #343, RW #424 🆕, UN #425 🆕) | ProgressionSubsystem (UnlockNext, RecalculateTrackDifficulty) | ✅ | `VT_TRACK_Components` | [LD](../../ld/VT-TRACK_area_track_unlock.md) | [Audit](../../audit/VT-TRACK_area_track_unlock.md) |
| VT-CARPROG | #344 | Car-Progression | CarRatingSubsystem (CR by city) | ✅ | `VT_CARPROG_Components` | [LD](../../ld/VT-CARPROG_car_progression.md) | [Audit](../../audit/VT-CARPROG_car_progression.md) |
| VT-REWARD | #345 | Reward | RewardCenterSubsystem (LootCrate), AchievementSubsystem, FanServiceSubsystem | ✅ | `VT_REWARD_Components` | [LD](../../ld/VT-REWARD_reward.md) | [Audit](../../audit/VT-REWARD_reward.md) |

## Epic: GAME MODE (#272)

| Code | OP | Feature | Main components | Status | New | View | LD | Audit |
|---|---|---|---|---|---|---|---|---|
| GM-MP | #273 | MULTIPLAYER (subs: MATCH #437 🆕, RACE #447 🆕, POST #448 🆕) | NakamaServiceSubsystem, MatchServiceSubsystem, NakamaNetworkSubsystem, MultiplayerWaitingRoomGameMode | ⚠️ | | `GM_MP_Components` | [LD](../../ld/GM-MP_multiplayer.md) | [Audit](../../audit/GM-MP_multiplayer.md) |
| GM-DC | #274 | DAILY CHALLENGE (subs: UN #426 🆕, CFG #431 🆕) | — (chưa có code) | ❌ | | `gmDc` | [LD](../../ld/GM-DC_daily_challenge.md) | — |

## Epic: SHOP & IAP (#366)

| Code | OP | Feature | Main components | Status | New | View | LD | Audit |
|---|---|---|---|---|---|---|---|---|
| SH-DISP | #405 | Shop Display | — (chưa có subsystem) | ❌ | 🆕 | `SH_DISP_Components` | [LD](../../ld/SH_shop_iap.md) | [Audit](../../audit/SH-DISP_shop_display.md) |
| SH-FLOW | #455 | Purchase Flow | — (chưa có subsystem) | ❌ | 🆕 | `SH_FLOW_Components` | [LD](../../ld/SH_shop_iap.md) | [Audit](../../audit/SH-FLOW_purchase_flow.md) |

## Top-level / Infra

| Code | OP | Feature | Main components | Status | View | LD | Audit |
|---|---|---|---|---|---|---|---|
| CDN | #250 | CDN | ChunkDownloaderSubsystem, ChunkDownloaderController, ChunkDownloaderWidget | ✅ | `CDN_Components` | [LD](../../ld/CDN_content_download.md) | [Audit](../../audit/CDN_content_download.md) |
| PC | #148 | Project Config | devops/build (k6, AWS chunk upload) | 🔧 | — | [LD](../../ld/PC_project_config.md) | — |

## Hệ thống nền (Support — code thật, ngoài CSV; ứng viên refactor)

| Code | Hệ thống | Main components | View | LD | Audit |
|---|---|---|---|---|---|
| SUP-AI | Racer AI | AIManagerSubsystem, AIDecisionComponent, GuideLineSubsystem | `SUP_AI_Components` | [LD](../../ld/SUP-AI_racer_ai.md) | [Audit](../../audit/SUP-AI_racer_ai.md) |
| SUP-POOL | Object Pooling | ActorObjectPoolSubsystem, PoolObjectInterface | `SUP_POOL_Components` | [LD](../../ld/SUP-POOL_object_pooling.md) | [Audit](../../audit/SUP-POOL_object_pooling.md) |
| SUP-INV | Inventory | InventoryManager, ItemDatabase | `SUP_INV_Components` | [LD](../../ld/SUP-INV_inventory.md) | [Audit](../../audit/SUP-INV_inventory.md) |
| SUP-PROF | User Profile / Economy | ProfileManagerSubsystem, RaceSessionSubsystem, SnapshotAdapterSubsystem | `SUP_PROF_Components` | [LD](../../ld/SUP-PROF_user_profile.md) | [Audit](../../audit/SUP-PROF_user_profile.md) |
| SUP-SHOP | Shop / IAP / Ads | CommerceSubsystem, MockCommerceProvider | `SUP_SHOP_Components` | [LD](../../ld/SUP-SHOP_shop_iap.md) | [Audit](../../audit/SUP-SHOP_shop_iap.md) |
| SUP-TUT | Tutorial / Onboarding | TutorialManagerSubsystem, TriggerCondition | `SUP_TUT_Components` | [LD](../../ld/SUP-TUT_tutorial.md) | [Audit](../../audit/SUP-TUT_tutorial.md) |
| SUP-DBG | Debug & Track Test | DebugToolsSubsystem, BatchSimulationManager, MistakeDetector, RaceDataCollector | `SUP_DBG_Components` | [LD](../../ld/SUP-DBG_debug_tracktest.md) | [Audit](../../audit/SUP-DBG_debug_tracktest.md) |
| SUP-PERF | Performance & PSO | PerformanceMonitorSubsystem, LiteSignificanceManager, PSOEffectManager, RestLevelManager | `SUP_PERF_Components` | [LD](../../ld/SUP-PERF_performance_pso.md) | [Audit](../../audit/SUP-PERF_performance_pso.md) |

Sample feature diagrams:

![DM-RACE](embed:DM_RACE_Components)

![CU-ROOM](embed:CU_ROOM_Components)

![SUP-PERF](embed:SUP_PERF_Components)
