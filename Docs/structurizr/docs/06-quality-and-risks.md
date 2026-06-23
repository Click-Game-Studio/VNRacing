# 06. Quality and Risks

## Quality goals

| Goal | Meaning |
|---|---|
| Mobile frame-time stability | No avoidable per-frame world scans, sorts, blocking asset loads or empty ticks on hot race paths. |
| Clear ownership | Race runtime stays level-bound; long-lived meta data stays in subsystems; SaveGame access goes through managers. |
| Source-grounded docs | Architecture names and contracts trace to source/audit evidence, not inferred design intent. |
| Reviewable diagrams | Feature component views remain split by feature instead of one unreadable mega-diagram. |
| Honest evidence gaps | Missing Blueprint/full backend authority coverage is documented explicitly. |

## P0/P1 hotspots from audit

| Area | Risk | Evidence |
|---|---|---|
| DM-RACE Race ranking | Per-frame `HandleUpdateRanking` recomputes and sorts ranking every Tick. | `Docs/audit/DM-RACE_basic_racing.md`; `RaceTrackManager.cpp:207`, `834-877`. |
| DM-RACE Client relay | `GetAllActorsOfClass` + O(n²) nested match per ranking update. | `Docs/audit/DM-RACE_basic_racing.md`; `RacingCarController.cpp:286-308`. |
| CU-ROOM Customization | Blocking `LoadSynchronous` for meshes/materials during car construction/preview. | `Docs/audit/CU-ROOM_customize_room.md`; `CarCustomizationManager.cpp:372,383,414,425,484,495,524,535`. |
| SUP-POOL Pooling | Unknown actor release can crash; acquire/release scan arrays linearly. | `Docs/audit/SUP-POOL_object_pooling.md`; `ActorObjectPoolSubsystem.cpp:8-59`. |
| DM-PHYS Vehicle tick | Empty ticks on movement/race components and heavy per-car Tick paths. | `Docs/audit/DM-PHYS_drivemode_physics.md`; `CustomChaosWheeledVehicle.cpp:12,28-33`, `RaceComponent.cpp:12,29-34`. |
| SUP-INV Item database | Cache is built but `GetItemDefinition` bypasses it and lacks null guard. | `Docs/audit/SUP-INV_inventory.md`; `ItemDatabase.cpp:36-44`. |
| SUP-SHOP Commerce | Mock provider only; no production provider/receipt verification authority. | `Docs/audit/SUP-SHOP_shop_iap.md`; `CommerceSubsystem.cpp:14-23,80-85`. |
| GM-MP Backend | Bidirectional coupling between Nakama and match services. | `Docs/audit/GM-MP_multiplayer.md`; `NakamaServiceSubsystem.cpp:8,90,157-162`. |
| CDN Content download | Widget open path uses world scan/static load/debug messages; controller static loads widget class. | `Docs/audit/CDN_content_download.md`; `ChunkDownloaderWidget.cpp:133-186`, `ChunkDownloaderController.cpp:21`. |
| SUP-PERF Significance | Actor/Niagara state branches use inconsistent state update idioms; operator[] access risk. | `Docs/audit/SUP-PERF_performance_pso.md`; `LiteSignificanceManager.cpp:58,77-82`. |

## Evidence gaps

- Blueprint graph coverage is partial. Audits verified selected gameplay/UI BPs, but not every WidgetBlueprint and Blueprint asset.
- Full server-authoritative multiplayer race flow is not evidenced in source; GM-MP should be treated as client/waiting-room plus target architecture.
- Commerce backend authority and native mobile provider wiring are not production-complete in source evidence.
