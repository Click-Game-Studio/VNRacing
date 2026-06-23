workspace "VNRacing Architecture" "C4 model + arc42 docs + ADRs, keyed to the OpenProject 2026-06-15 product taxonomy (Epic > Feature). See Docs/traceability.md." {

    !identifiers hierarchical

    model {
        player = person "Mobile Player" "iOS / Android racer. Touch input, race + meta-game navigation."
        nakama = softwareSystem "Nakama" "Auth, session, realtime socket, matchmaking via Nakama UE SDK." "External"
        edgegap = softwareSystem "Edgegap / Dedicated Server" "PvP server hosting boundary; server-authoritative race flow is target/gap, not confirmed as complete in source." "External"
        gameAnalytics = softwareSystem "GameAnalytics" "Telemetry service. Observational only; game state does not depend on delivery." "External"
        appStore = softwareSystem "App Store / Play Billing" "IAP entitlement provider. Source currently wires mock provider; native providers are not production-complete." "External"
        cdn = softwareSystem "Content CDN" "Hosts pak/chunk files for on-demand download through ChunkDownloader." "External"
        backendEconomy = softwareSystem "Backend Economy Services" "Target source of truth for profile/economy/inventory/progression. Current client remains local/prototype-heavy." "External"

        client = softwareSystem "VNRacing UE5 Mobile Client" "Single-module PrototypeRacing UE5.6 client. Gameplay runtime, meta/economy, online client services, UI, local data, debug tooling." {
            ui = container "UI / UMG Layer" "UMG widgets + HUD. Reads subsystem state via delegates; Blueprint/WidgetBlueprint screens remain view/controller layer." "UMG / WidgetBlueprint" {
                bpCars = component "Customizable car BPs" "BP_Customizable_VF8 / MercedesBenz / VFLuxA*, BP_SportsCar_Pawn. Blueprint component setup over C++ pawn." "Blueprint"
                bpCustomize = component "Customize UI BPs" "WBP_UI491/493/496_CarCustomize, WBP_PerformanceStat and CarCustomize buttons. WBP_PerformanceStat Event Tick was verified as dead/unconnected." "Blueprint/UMG"
                bpShop = component "Shop UI BPs" "WBP_Shop, WBP_Popup_Shopping, WBP_Card_DLC, WBP_Card_BoosterBundles, WBP_Play_Rewards_WatchAds." "Blueprint/UMG"
                chunkDownloaderWidget = component "ChunkDownloaderWidget" "Patch progress UI; downloadable map open path contains GetAllActorsOfClass, StaticLoadClass and on-screen debug messages." "UserWidget"
                bpTutorial = component "Tutorial BPs" "WBP_ScriptTutorial, WBP_TooltipTutorial, BP_Trigger_PassCheckpoint_*. Script/tooltip BPs verified as event-driven." "Blueprint/UMG"
            }

            gameplay = container "Gameplay Runtime" "Race lifecycle, vehicle physics, AI, pooling. Level-bound GameMode / GameState / RaceTrackManager plus SimpleCarPhysics plugin." "UE5 Gameplay Framework" {
                simulatePhysicsCar = component "SimulatePhysicsCar" "Core player/AI vehicle actor. Per-frame Tick updates suspension/wheels, animation sync, race rank, network upstream." "Actor"
                customChaosWheeledVehicle = component "CustomChaosWheeledVehicle" "Chaos wheeled movement override. TickComponent is enabled but body is empty." "Movement Component"
                customSuspensionComponent = component "CustomSuspensionComponent" "Per-wheel suspension component; ticks every frame per car." "ActorComponent"
                vehicleFactory = component "VehicleFactory" "Standardized vehicle creation/configuration helper." "UObject"
                pidControl = component "PIDControl" "PID controller actor used by vehicle/assist logic; ticks." "Actor"
                followCarCamera = component "FollowCarCamera" "Chase camera actor. TickFunction and GetComponentByClass lookups on target." "Actor"

                raceTrackManager = component "RaceTrackManager" "Central race orchestrator: checkpoint/lap/ranking/timer lifecycle, AI setup, intro/outro, result hand-off. God-class hotspot." "Actor"
                racingCarGameMode = component "RacingCarGameMode" "Race-level authority. Spawns race manager and cars, handles player login/ready, PSO drone setup." "GameMode"
                raceGameState = component "RaceGameState" "Replicates car readiness and active car list across network." "GameState"
                racingCarController = component "RacingCarController" "Player controller. Relays race state to owning client by RPC; applies ranking to client-side cars." "PlayerController"
                raceCheckpoint = component "RaceCheckpoint" "Trigger volume. On vehicle overlap, notifies the race manager of checkpoint progress." "Actor"
                raceComponent = component "RaceComponent" "Attachable race helper component. Tick enabled but body empty; optimization candidate." "ActorComponent"
                raceFlowBPs = component "Race flow BPs" "BP_CheckPoint, BP_BoostCheckPoint, BP_DriftZone_Child, intro/outro sequences. Some checkpoint/drift BPs have Event Tick verified by audit." "Blueprint"

                aiManagerSubsystem = component "AIManagerSubsystem" "Round-robin AI scheduler; ticks at most one AI per frame. ConfigAiCarPerformance calls car stat calculation during registration." "GameInstance Subsystem"
                aiDecisionComponent = component "AIDecisionComponent" "Per-car AI driving decisions, racing-line and NOS interval checks; TickComponent per AI car." "ActorComponent"
                guideLineSubsystem = component "GuideLineSubsystem" "Lane/contender resolution and closest track mark lookup; initializes from world actors." "World/Game Subsystem"

                actorObjectPoolSubsystem = component "ActorObjectPoolSubsystem" "World-scoped reusable actor pool. Get/Release scan availability arrays; ReleaseActor lacks guard for unknown actor." "World Subsystem"
                poolObjectInterface = component "PoolObjectInterface" "Pool lifecycle contract: OnCreate, OnGetFromPool, OnReleaseToPool." "Interface"

                multiplayerWaitingRoomGameMode = component "MultiplayerWaitingRoomGameMode" "Join-token validation and waiting-room travel. Full server-authoritative race flow remains evidence gap." "GameMode"
            }

            meta = container "Meta / Economy Subsystems" "GameInstance subsystems for progression, customization, inventory, profile/wallet, rewards and commerce." "UE5 GameInstance Subsystems" {
                progressionCenterSubsystem = component "ProgressionCenterSubsystem" "Facade for VN Tour race setup, race completion, reward orchestration, analytics and travel." "GameInstance Subsystem"
                progressionSubsystem = component "ProgressionSubsystem" "VN Tour city/area/track hierarchy, unlock state, RecordRaceResult. Large god-object file." "GameInstance Subsystem"
                carRatingSubsystem = component "CarRatingSubsystem" "Car rating tables, performance gates and AI CR by city/difficulty." "GameInstance Subsystem"
                carCustomizationManager = component "CarCustomizationManager" "Visual/performance customization, CR calculation, save/load and asset resolution. Blocking synchronous asset loads hotspot." "GameInstance Subsystem"
                customizeCarSubsystem = component "CustomizeCarSubsystem" "Lighter mesh/material application by part name." "GameInstance Subsystem"
                carSaveGameManager = component "CarSaveGameManager" "Persists car configs, inventory, profile and progression save slots." "GameInstance Subsystem"
                carConfigurationJsonSerializer = component "CarConfigurationJsonSerializer" "Serialize car configuration to JSON for backend-sync preparation." "C++ Utility"
                inventoryManager = component "InventoryManager" "Item ownership, equip/favorite and mutation persistence. Backend-authority lock gate is present." "GameInstance Subsystem"
                itemDatabase = component "ItemDatabase" "Item definition database. Cache exists but GetItemDefinition bypasses it and calls DataTable FindRow directly." "UObject/Data Service"
                profileManagerSubsystem = component "ProfileManagerSubsystem" "Profile identity, wallet earn/spend, name filter, top-speed sampling timer." "GameInstance Subsystem"
                raceSessionSubsystem = component "RaceSessionSubsystem" "Fuel/session energy, recharge timers and current race/session data." "GameInstance Subsystem"
                snapshotAdapterSubsystem = component "SnapshotAdapterSubsystem" "Player snapshot load/save through Nakama RPC." "GameInstance Subsystem"
                rewardCenterSubsystem = component "RewardCenterSubsystem" "Reward token roll and result creation. Item icon LoadSynchronous appears on reward resolve path." "GameInstance Subsystem"
                achievementSubsystem = component "AchievementSubsystem" "Achievement progress update on race completion." "GameInstance Subsystem"
                fanServiceSubsystem = component "FanServiceSubsystem" "In-race drift/fly/speed challenges. Ticks every frame while active check is running." "GameInstance Subsystem"
                commerceSubsystem = component "CommerceSubsystem" "Store products and purchase orchestration. Mock provider is wired; Android/iOS providers and server receipt verification remain gaps." "GameInstance Subsystem"
                mockCommerceProvider = component "MockCommerceProvider" "Editor/dev stand-in commerce provider." "C++ Provider"
                tutorialManagerSubsystem = component "TutorialManagerSubsystem" "Tutorial state, tooltip pool, trigger dispatch and control lock/unlock." "GameInstance Subsystem"
                triggerCondition = component "TriggerCondition" "Tutorial condition base/subclasses, for example checkpoint-passed trigger." "UObject"
                carSettingSubsystem = component "CarSettingSubsystem" "Car/gameplay setting load, apply and save to CarSaveSetting." "GameInstance Subsystem"
                graphicsSettingsActor = component "GraphicsSettingsActor" "Applies graphics scalability settings." "Actor"
            }

            backendComm = container "Backend Communication" "Client-side gateway to Nakama auth/session/realtime/match orchestration and snapshot sync." "Nakama UE SDK" {
                nakamaServiceSubsystem = component "NakamaServiceSubsystem" "Client/session/realtime lifecycle and auth flows. Holds back-reference to match service." "GameInstance Subsystem"
                matchServiceSubsystem = component "MatchServiceSubsystem" "Matchmaking query build, ticket flow, matched/presence events and JSON payload parse." "GameInstance Subsystem"
                nakamaNetworkSubsystem = component "NakamaNetworkSubsystem" "Network-level Nakama plumbing." "GameInstance Subsystem"
                backendContractTypes = component "BackendContractTypes" "Shared backend request/response structs." "C++ Types"
                chunkDownloaderSubsystem = component "ChunkDownloaderSubsystem" "Patch lifecycle, chunk mount and retry guard." "GameInstance Subsystem"
                chunkDownloaderController = component "ChunkDownloaderController" "Patch widget spawn; audit reports synchronous widget class load." "Controller/UObject"
            }

            localData = container "Local Data / SaveGame" "DataTable registry through GameInstance and SaveGame slots. Local source of truth for offline/prototype flows." "DataTable / SaveGame" {
                racingCarGameInstance = component "RacingCarGameInstance" "Global DataTable registry for maps, progression, car rating, customization, profile, inventory, tutorial, AI and PSO flags." "GameInstance"
                racingSaveGame = component "RacingSaveGame / ProfileInventorySaveGame / ProgressionSaveGame" "SaveGame slots used by customization, inventory, profile, progression and session managers." "SaveGame"
                dataTables = component "DataTable registry" "Configured asset tables for cars, parts, rewards, profile, tutorial, AI, progression and track data." "DataTable Assets"
            }

            tooling = container "Debug / Tooling" "Debug modules, track-test batch simulation, performance instrumentation and PSO helpers. Not a shipping dependency." "Debug / Tooling" {
                debugToolsSubsystem = component "DebugToolsSubsystem" "Hosts DebugModule_* for camera, cheat, gameplay, overlay, progression, rendering, test maps, track logic, tutorial and vehicle." "GameInstance Subsystem"
                batchSimulationManager = component "BatchSimulationManager" "State-machine batch sim; tick dispatches by state and is cheap while idle." "UObject/Manager"
                mistakeDetector = component "MistakeDetector" "Per-frame TickComponent and boundary spline lookup with GetAllActorsOfClassWithTag in track-test tooling." "ActorComponent"
                raceDataCollector = component "RaceDataCollector" "Per-frame TickComponent data capture during test runs." "ActorComponent"
                performanceMonitorSubsystem = component "PerformanceMonitorSubsystem" "Runtime FPS/performance instrumentation." "GameInstance Subsystem"
                liteSignificanceManager = component "LiteSignificanceManager" "Timer-driven distance culling of actors/Niagara; Niagara state comparison is a logic-risk hotspot." "Subsystem/Manager"
                psoEffectManager = component "PSOEffectManager" "PSO warmup VFX spawn helper. Tick enabled but body empty." "Actor"
                restLevelManager = component "RestLevelManager" "Rest-level FPS-stability gate before travel; tracks frame times while checking." "Actor"
            }
        }

        player -> client "plays / touch input"
        client -> nakama "auth, session, realtime, matchmaking"
        client -> gameAnalytics "telemetry events"
        client -> appStore "IAP product query + purchase"
        client -> cdn "download pak/chunk content"
        client -> backendEconomy "profile/economy sync target"
        nakama -> edgegap "route / allocate server target"

        client.ui -> client.gameplay "start race, read race state"
        client.ui -> client.meta "customize, view progression, buy, inventory"
        client.ui -> client.backendComm "login, matchmaking"
        client.ui -> client.tooling "debug panels in dev builds"
        client.gameplay -> client.meta "race result -> progression/profile"
        client.gameplay -> client.localData "read race/track/AI config"
        client.meta -> client.localData "save/load configs, wallet, progression"
        client.meta -> client.backendComm "economy sync target"
        client.backendComm -> nakama "SDK calls"
        client.tooling -> client.gameplay "inspect / drive batch sim"

        client.gameplay.racingCarGameMode -> client.gameplay.raceTrackManager "spawns + starts"
        client.gameplay.racingCarGameMode -> client.gameplay.simulatePhysicsCar "SpawnPlayerCar"
        client.gameplay.racingCarGameMode -> client.gameplay.raceGameState "register ready cars"
        client.gameplay.raceCheckpoint -> client.gameplay.raceTrackManager "HandleVehicleDetectedAtCheckpoint"
        client.gameplay.raceTrackManager -> client.gameplay.simulatePhysicsCar "SetRaceRank, freeze, SignalRaceBegin"
        client.gameplay.raceTrackManager -> client.meta.progressionCenterSubsystem "HandleRaceCompleted"
        client.gameplay.raceTrackManager -> client.meta.carCustomizationManager "resolve AI visuals/stats"
        client.gameplay.raceTrackManager -> client.meta.profileManagerSubsystem "profile lookup"
        client.gameplay.raceTrackManager -> client.meta.carRatingSubsystem "AI car rating"
        client.gameplay.racingCarController -> client.gameplay.raceTrackManager "PlayerIsReady"
        client.gameplay.racingCarController -> client.gameplay.simulatePhysicsCar "apply ranking to cars"
        client.gameplay.simulatePhysicsCar -> client.gameplay.customSuspensionComponent "UpdateTick per wheel"
        client.gameplay.simulatePhysicsCar -> client.gameplay.customChaosWheeledVehicle "movement component"
        client.gameplay.simulatePhysicsCar -> client.gameplay.guideLineSubsystem "wall-correction distance"
        client.gameplay.followCarCamera -> client.gameplay.simulatePhysicsCar "follow target"
        client.gameplay.aiManagerSubsystem -> client.gameplay.simulatePhysicsCar "AutoDrive round-robin"
        client.gameplay.aiManagerSubsystem -> client.meta.carCustomizationManager "CalculatePerformanceStats for AI tuning"
        client.gameplay.aiDecisionComponent -> client.gameplay.guideLineSubsystem "lane queries"
        client.gameplay.raceTrackManager -> client.gameplay.aiDecisionComponent "ApplyAIDifficultyTuning"
        client.gameplay.raceTrackManager -> client.gameplay.actorObjectPoolSubsystem "acquire/release transient actors"
        client.meta.progressionCenterSubsystem -> client.meta.progressionSubsystem "RecordRaceResult, unlock"
        client.meta.progressionCenterSubsystem -> client.meta.carRatingSubsystem "IsPerformanceGatePassed"
        client.meta.progressionCenterSubsystem -> client.meta.rewardCenterSubsystem "reward calc"
        client.meta.progressionCenterSubsystem -> client.meta.achievementSubsystem "achievement progress"
        client.meta.progressionCenterSubsystem -> client.meta.raceSessionSubsystem "fuel spend"
        client.meta.progressionCenterSubsystem -> client.meta.profileManagerSubsystem "EarnCurrency"
        client.meta.progressionCenterSubsystem -> client.meta.carSaveGameManager "save progression"
        client.meta.progressionCenterSubsystem -> client.meta.fanServiceSubsystem "evaluate fan service"
        client.meta.carCustomizationManager -> client.meta.carRatingSubsystem "CR / stats"
        client.meta.carCustomizationManager -> client.meta.profileManagerSubsystem "HasEnoughCurrency / SpendCurrency"
        client.meta.carCustomizationManager -> client.meta.inventoryManager "required-item check on upgrade"
        client.meta.carCustomizationManager -> client.meta.carSaveGameManager "SaveCarConfiguration"
        client.meta.rewardCenterSubsystem -> client.meta.inventoryManager "grant item"
        client.meta.rewardCenterSubsystem -> client.meta.profileManagerSubsystem "grant currency"
        client.meta.inventoryManager -> client.meta.itemDatabase "GetItemDefinition"
        client.meta.inventoryManager -> client.meta.carSaveGameManager "save inventory"
        client.meta.profileManagerSubsystem -> client.meta.carSaveGameManager "save profile"
        client.meta.raceSessionSubsystem -> client.meta.carSaveGameManager "save fuel/session"
        client.meta.snapshotAdapterSubsystem -> client.backendComm.nakamaServiceSubsystem "RPC snapshot"
        client.meta.fanServiceSubsystem -> client.gameplay.simulatePhysicsCar "drift/fly/speed sampling"
        client.backendComm.matchServiceSubsystem -> client.backendComm.nakamaServiceSubsystem "realtime client + session"
        client.backendComm.nakamaServiceSubsystem -> client.meta.raceSessionSubsystem "session refs"
        client.backendComm.nakamaServiceSubsystem -> client.backendComm.matchServiceSubsystem "back-reference coupling"
        client.gameplay.multiplayerWaitingRoomGameMode -> client.backendComm.matchServiceSubsystem "join token from match data"
        client.backendComm.chunkDownloaderController -> client.ui.chunkDownloaderWidget "spawns patch widget"
        client.ui.chunkDownloaderWidget -> client.backendComm.chunkDownloaderSubsystem "progress + mount status"
        client.backendComm.chunkDownloaderController -> client.backendComm.chunkDownloaderSubsystem "RetryPatch / start"
        client.ui.chunkDownloaderWidget -> client.localData "open downloaded map"
        client.meta.tutorialManagerSubsystem -> client.meta.triggerCondition "evaluate conditions"
        client.gameplay.raceTrackManager -> client.meta.tutorialManagerSubsystem "TriggerOnCheckpointPassed"
        client.meta.progressionCenterSubsystem -> client.meta.tutorialManagerSubsystem "ShowTooltip out-of-fuel"
        client.tooling.debugToolsSubsystem -> client.meta.progressionCenterSubsystem "progression debug"
        client.tooling.batchSimulationManager -> client.gameplay.racingCarGameMode "drive batch race runs"
        client.tooling.mistakeDetector -> client.gameplay.simulatePhysicsCar "detect off-track mistakes"
        client.tooling.liteSignificanceManager -> client.gameplay.simulatePhysicsCar "distance-cull register"
        client.tooling.restLevelManager -> client.meta.progressionCenterSubsystem "TravelToCurrentRace when stable"
        client.gameplay.racingCarGameMode -> client.tooling.psoEffectManager "spawn PSO drone/effects"
        client.localData.racingCarGameInstance -> client.localData.dataTables "owns configured DataTable refs"
        client.meta.carSaveGameManager -> client.localData.racingSaveGame "read/write slots"
    }

    views {
        systemContext client "SystemContext" "Player, external systems and the VNRacing client boundary." {
            include *
            autolayout lr
        }

        container client "Containers" "Six runtime groupings inside the VNRacing client." {
            include *
            autolayout lr
        }

        component client.gameplay "AllFeature_Gameplay" "Gameplay container components across drive, race, AI, pooling and multiplayer waiting room." {
            include *
            autolayout lr
        }

        component client.meta "AllFeature_Meta" "Meta/economy subsystem components across progression, customization, inventory, profile, rewards, commerce, tutorial and settings." {
            include *
            autolayout lr
        }

        component client.backendComm "AllFeature_Backend" "Nakama/backend communication components." {
            include *
            autolayout lr
        }

        component client.tooling "AllFeature_Tooling" "Debug, track-test, performance and PSO components." {
            include *
            autolayout lr
        }

        component client.gameplay "DM_PHYS_Components" "DM-PHYS DriveMode - Physics (#279) components." {
            include client.gameplay.simulatePhysicsCar client.gameplay.customChaosWheeledVehicle client.gameplay.customSuspensionComponent client.gameplay.vehicleFactory client.gameplay.pidControl client.ui.bpCars client.gameplay.guideLineSubsystem
            autolayout lr
        }
        component client.gameplay "DM_RACE_Components" "DM-RACE Basic Racing (#324) components." {
            include client.gameplay.racingCarGameMode client.gameplay.raceTrackManager client.gameplay.raceGameState client.gameplay.racingCarController client.gameplay.raceCheckpoint client.gameplay.raceComponent client.gameplay.raceFlowBPs client.meta.progressionCenterSubsystem
            autolayout lr
        }
        component client.gameplay "DM_NOS_Components" "DM-NOS NOS (#334) components: nitro on pawn + boost checkpoint + AI NOS." {
            include client.gameplay.simulatePhysicsCar client.gameplay.aiDecisionComponent client.gameplay.raceFlowBPs
            autolayout lr
        }
        component client.gameplay "DM_RAMP_Components" "DM-RAMP RAMP (#335) components: ramp zone + jump on pawn." {
            include client.gameplay.simulatePhysicsCar client.gameplay.raceFlowBPs
            autolayout lr
        }
        component client.gameplay "DM_CAM_Components" "DM-CAM CAMERA (#336) components." {
            include client.gameplay.followCarCamera client.gameplay.simulatePhysicsCar
            autolayout lr
        }
        component client.meta "DM_SET_Components" "DM-SET SETTING (#338) components." {
            include client.meta.carSettingSubsystem client.meta.graphicsSettingsActor client.localData.racingSaveGame
            autolayout lr
        }
        component client.meta "VT_CITY_Components" "VT-CITY City Progression (#329) components: goals config/unlock/reward, car/map unlock." {
            include client.meta.progressionCenterSubsystem client.meta.progressionSubsystem client.meta.rewardCenterSubsystem client.meta.carRatingSubsystem client.meta.carSaveGameManager client.meta.profileManagerSubsystem
            autolayout lr
        }
        component client.meta "VT_TRACK_Components" "VT-TRACK Area-Track Unlock (#341) components: track selection + config (in ProgressionSubsystem)." {
            include client.meta.progressionSubsystem client.meta.progressionCenterSubsystem client.meta.carRatingSubsystem
            autolayout lr
        }
        component client.meta "VT_CARPROG_Components" "VT-CARPROG Car-Progression (#344) components." {
            include client.meta.carRatingSubsystem client.meta.carCustomizationManager client.meta.progressionSubsystem
            autolayout lr
        }
        component client.meta "VT_REWARD_Components" "VT-REWARD Reward (#345) components: token roll, LootCrate, achievements, fan service." {
            include client.meta.rewardCenterSubsystem client.meta.achievementSubsystem client.meta.fanServiceSubsystem client.meta.inventoryManager client.meta.profileManagerSubsystem client.gameplay.simulatePhysicsCar
            autolayout lr
        }
        component client.backendComm "GM_MP_Components" "GM-MP MULTIPLAYER (#273) components: Nakama + match + waiting room (server-auth race flow is gap)." {
            include client.backendComm.nakamaServiceSubsystem client.backendComm.matchServiceSubsystem client.backendComm.nakamaNetworkSubsystem client.backendComm.backendContractTypes client.meta.snapshotAdapterSubsystem client.gameplay.multiplayerWaitingRoomGameMode client.gameplay.racingCarGameMode
            autolayout lr
        }
        component client.meta "CU_ROOM_Components" "CU-ROOM Customize Room (#299) components." {
            include client.meta.carCustomizationManager client.meta.customizeCarSubsystem client.meta.carSaveGameManager client.meta.carConfigurationJsonSerializer client.ui.bpCustomize client.meta.carRatingSubsystem client.meta.inventoryManager client.meta.profileManagerSubsystem
            autolayout lr
        }
        component client.ui "CU_THEME_Components" "CU-THEME Theme Change (#400) components." {
            autolayout lr
        }
        component client.ui "CU_VIS_Components" "CU-VIS Car Customize Visual (#401) components — ❌ GAP (no code)." {
            autolayout lr
        }
        component client.ui "CU_PERF_Components" "CU-PERF Car Customize Performance (#402) components — ❌ GAP (no code)." {
            autolayout lr
        }
        component client.ui "CU_SEL_Components" "CU-SEL Car Selection (#403) components — ❌ GAP (no code)." {
            autolayout lr
        }
        component client.ui "SH_DISP_Components" "SH-DISP Shop Display (#405) components — ❌ GAP (no code)." {
            autolayout lr
        }
        component client.ui "SH_FLOW_Components" "SH-FLOW Purchase Flow (#455) components — ❌ GAP (no code)." {
            autolayout lr
        }
        component client.ui "CDN_Components" "CDN Content Download (#250) components." {
            include client.ui.chunkDownloaderWidget client.backendComm.chunkDownloaderSubsystem client.backendComm.chunkDownloaderController client.localData
            autolayout lr
        }
        component client.gameplay "SUP_AI_Components" "SUP-AI Racer AI (ngoài CSV) components." {
            include client.gameplay.aiManagerSubsystem client.gameplay.aiDecisionComponent client.gameplay.guideLineSubsystem client.gameplay.simulatePhysicsCar client.meta.carCustomizationManager
            autolayout lr
        }
        component client.gameplay "SUP_POOL_Components" "SUP-POOL Object Pooling (ngoài CSV) components." {
            include client.gameplay.actorObjectPoolSubsystem client.gameplay.poolObjectInterface client.gameplay.raceTrackManager
            autolayout lr
        }
        component client.meta "SUP_INV_Components" "SUP-INV Inventory (ngoài CSV) components." {
            include client.meta.inventoryManager client.meta.itemDatabase client.meta.carSaveGameManager client.meta.carCustomizationManager client.meta.rewardCenterSubsystem
            autolayout lr
        }
        component client.meta "SUP_PROF_Components" "SUP-PROF User Profile / Economy (ngoài CSV) components." {
            include client.meta.profileManagerSubsystem client.meta.raceSessionSubsystem client.meta.snapshotAdapterSubsystem client.meta.carSaveGameManager client.backendComm.nakamaServiceSubsystem
            autolayout lr
        }
        component client.meta "SUP_SHOP_Components" "SUP-SHOP Shop / IAP / Ads (ngoài CSV) components." {
            include client.meta.commerceSubsystem client.meta.mockCommerceProvider client.ui.bpShop client.meta.profileManagerSubsystem
            autolayout lr
        }
        component client.meta "SUP_TUT_Components" "SUP-TUT Tutorial / Onboarding (ngoài CSV) components." {
            include client.meta.tutorialManagerSubsystem client.meta.triggerCondition client.ui.bpTutorial client.gameplay.raceTrackManager client.meta.progressionCenterSubsystem
            autolayout lr
        }
        component client.tooling "SUP_DBG_Components" "SUP-DBG Debug & Track Test (ngoài CSV) components." {
            include client.tooling.debugToolsSubsystem client.tooling.batchSimulationManager client.tooling.mistakeDetector client.tooling.raceDataCollector client.gameplay.simulatePhysicsCar client.gameplay.racingCarGameMode
            autolayout lr
        }
        component client.tooling "SUP_PERF_Components" "SUP-PERF Performance & PSO (ngoài CSV) components." {
            include client.tooling.performanceMonitorSubsystem client.tooling.liteSignificanceManager client.tooling.psoEffectManager client.tooling.restLevelManager client.gameplay.simulatePhysicsCar client.meta.progressionCenterSubsystem
            autolayout lr
        }

        styles {
            element "Person" {
                shape person
            }
            element "External" {
                background "#999999"
                color "#ffffff"
            }
            element "Software System" {
                background "#1168bd"
                color "#ffffff"
            }
            element "Container" {
                background "#438dd5"
                color "#ffffff"
            }
            element "Component" {
                background "#85bbf0"
                color "#000000"
            }
        }
    }

    !docs docs
    !adrs adrs
}
