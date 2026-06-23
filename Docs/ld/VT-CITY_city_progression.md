# VT-CITY — City Progression — Low-Level Design

> Source: `Docs/audit/VT-CITY_city_progression.md`, `Docs/c4/model.c4`. Structurizr view: `VT_CITY_Components`.
> OpenProject: #329.

## Feature summary and boundaries

VT-CITY owns the full city-goals system and city unlock chain inside VN Tour. It manages the `city/area/track` hierarchy initialisation, assigns goal pools to newly-unlocked cities, tracks goal completion per tier, unlocks the next city in the chain and fires rewards for completed goals. It also owns **Car Unlock** (#337) — the moment a city unlock grants a new garage car — and **Map Scene Unlock** (#339) — the introduce-scene and debug jump utilities.

VT-CITY consumes DM-RACE race results (via `UProgressionCenterSubsystem::HandleRaceCompleted`) and delegates reward calculation to VT-REWARD (`URewardCenterSubsystem`). Track-level unlock rules live in VT-TRACK; car-rating gates live in VT-CARPROG.

![VT-CITY components](../structurizr/embed/VT_CITY_Components)

## Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `UProgressionCenterSubsystem` | `ProgressionCenterSubsystem.cpp:94` `HandleRecordRaceResult` | Facade: receives race result, drives goal checks and city unlock sequence. |
| `UProgressionSubsystem` | `ProgressionSubsystem.cpp` (~2641 lines) | VN Tour data model; city/area/track state, goal pool, unlock chain. |
| `SetupCityGoalPoolTable` | `ProgressionSubsystem.cpp:2150` | Parses `CityGoalPool` DataTable into `GoalsByTier` map (`ECityGoalTier → TArray<FCityGoal>`). |
| `BuildAssignedGoalsForNewCity` | `ProgressionSubsystem.cpp:2192` | Selects one random goal per tier (Tier1/Tier2/Tier3) and returns 3 `FCityAssignedGoalState` entries. |
| `CheckCityGoalsAndUnlockNextCity` | `ProgressionSubsystem.cpp:1352` | Checks if current city goals are all complete; calls `HandleUnlockNextCity` if so. |
| `HandleUnlockNextCity` | `ProgressionSubsystem.cpp:1299` | Calls `VNTourProgressionData.UnlockNextCity`, grants city-unlock rewards, assigns goals to new city, broadcasts `OnCityUnlocked`. |
| `GrantRewardsForCompletedGoal` | `ProgressionSubsystem.cpp:1336` | Delegates to `URewardCenterSubsystem::GrantGoalCompletionRewards` with city ID, city index and goal tier. |
| `EnsureGarageCarsFromProgression` | `ProgressionDebugManager.cpp:476` / `2163` | Car Unlock (#337): syncs garage with cars earned from progression state. |
| `JumpToCity` / `UnlockAllLocations` | `ProgressionDebugManager.cpp:1681` / `2097`; `ProgressionSubsystem.cpp:2109` | Map Scene Unlock (#339): debug utilities to jump the player to a city or unlock all locations instantly. |

Runtime flow: DM-RACE calls `HandleRaceCompleted` → `HandleRecordRaceResult` → `ProcessCurrentCityGoals` → `CheckCityGoalsAndUnlockNextCity`. On unlock: `HandleUnlockNextCity` → `GrantRewardsForUnlockedCity` + `AssignGoalsToCityUnlockData` + `OnCityUnlocked.Broadcast`.

Hotspots:
- `ProgressionCenterSubsystem.cpp:489` — `LoadSynchronous` on city/track icons; blocks game thread each time the VN Tour screen opens.
- `UProgressionSubsystem` god-object (2641 lines): mixes data ownership with orchestration; high maintenance risk.
- `ProgressionSubsystem.cpp:1813` — magic string `"ProgressionData"` key for DataTable lookup.

## Layer 2 — Contract surface

### Goals Unlock (#331) / Goals Config (#333)

- `SetupCityGoalPoolTable(UDataTable*)` — called at subsystem init; populates `GoalsByTier`.
- `ECityGoalTier` values: `Tier1`, `Tier2`, `Tier3`.
- `BuildAssignedGoalsForNewCity(TArray<FCityAssignedGoalState>&)` — produces exactly 3 goals (one per tier); returns `false` if pool is empty for any tier.
- `GetRandomGoalByTier(ECityGoalTier, FCityGoal&)` (`ProgressionSubsystem.cpp:2179`) — random selection from tier bucket.
- `AssignGoalsToCityUnlockData(FCityUnlockData&)` (`ProgressionSubsystem.cpp:2222`) — writes assigned goals into city unlock record.

### Goals Reward (#340)

- `GrantRewardsForCompletedGoal(FCityAssignedGoalState, FCityProgress)` → `RewardCenterSubsystem::GrantGoalCompletionRewards(FName CityID, int32 CityIndex, ECityGoalTier)`.
- Reward center broadcasts `OnGoalItemRewardCalculated` and `OnGoalCashRewardCalculated`; UI listens to these delegates.

### Car Unlock (#337)

- `EnsureGarageCarsFromProgression` — verifies garage contains all cars earned so far; called after city unlock and on save load.

### Map Scene Unlock (#339)

- `OnCityUnlocked` delegate (broadcast from `HandleUnlockNextCity`) — UI subscribes for introduce-scene trigger.
- Debug: `JumpToCity(int32)`, `UnlockAllLocations()`.

### Item Unlock (#386)

🆕 since 2026-06-23. Sub-feature of City Progression.

❌ **Gap: not yet implemented.** Work-package #386 defines item unlock as part of city progression — granting specific items (visual parts, consumables, currency) as milestone rewards when unlocking new cities. `UProgressionSubsystem` currently handles city/area/track unlock and goal rewards, but there is no item-unlock milestone system.

**Proposed approach:**
- Extend `FCityUnlockData` with an item grant list.
- In `HandleUnlockNextCity`, after unlocking the city, iterate the item grant list and call `UInventoryManager::AddItem`.

## Links

- Audit: `Docs/audit/VT-CITY_city_progression.md`
- Structurizr: `VT_CITY_Components`
- Portal: `Docs/portal/src/content/docs/features/vt-city.md`
- Related: VT-TRACK (track unlock), VT-CARPROG (CR gate), VT-REWARD (reward centre)
