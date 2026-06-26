# VT-REWARD — Reward — Low-Level Design

> Source: `Docs/audit/VT-REWARD_reward.md`, `Docs/c4/model.c4`. Structurizr view: `VT_REWARD_Components`.
> OpenProject: #345.

## Feature summary and boundaries

VT-REWARD owns reward token/result calculation, loot crate distribution (Common / UnCommon / Rare per OP #230/#293), achievement progress updates and fan-service in-race challenge checks. Inventory and profile subsystems (SUP-INV, SUP-PROF) own actual item and currency storage; VT-REWARD only calculates and dispatches.

VT-REWARD is called by VT-CITY (goal completion and city-unlock rewards) and by the DM-RACE race-completion path via `UProgressionCenterSubsystem`.

![VT-REWARD components](../structurizr/embed/VT_REWARD_Components)

## Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `URewardCenterSubsystem` | `RewardCenterSubsystem.cpp:219` | Roll loot, resolve item rewards, grant cash rewards, distribute to collaborators. |
| `GrantGoalCompletionRewards` | `RewardCenterSubsystem.cpp:678` | Calculates item reward batch + cash reward for a completed city goal; broadcasts `OnGoalItemRewardCalculated` and `OnGoalCashRewardCalculated`; calls `DistributeRewards` and `GrantCashReward`. |
| `CalculateGoalItemReward` | `RewardCenterSubsystem.cpp:518` | Resolves LootCrate tier (Common/UnCommon/Rare) for the given city + goal tier; returns `FRewardBatchResult`. |
| `DistributeRewards` | `RewardCenterSubsystem.cpp:647` | Dispatches `TArray<FRewardResult>` to SUP-INV (items) and SUP-PROF (currency). |
| `UAchievementSubsystem` | `AchievementSubsystem.cpp` | Updates achievement progress counters on race completion. |
| `UFanServiceSubsystem` | `FanServiceSubsystem.cpp` | Drift/fly/speed in-race challenge checks; activates on `bShouldCheckProgress=true` (`FanServiceSubsystem.cpp:75`). |

Runtime flow: `UProgressionCenterSubsystem::HandleRaceCompleted` → reward centre roll → achievements update → fan-service check result evaluated. For goal rewards specifically: `ProgressionSubsystem::GrantRewardsForCompletedGoal` → `GrantGoalCompletionRewards(CityID, CityIndex, GoalTier)`.

Hotspots:
1. `RewardCenterSubsystem.cpp:219` and `ProgressionCenterSubsystem.cpp:489` — `LoadSynchronous` on item/icon soft-refs at reward-result creation time; blocks game thread at the end-of-race screen (high-sensitivity moment with outro sequence already running).
2. `RewardCenterSubsystem.cpp:124`, `:202`, `:670` — `FindRow` inside reward-pool filter loop; O(candidates) DataTable lookups per roll. Not per-frame; medium impact.
3. `UFanServiceSubsystem` — samples car state while `bShouldCheckProgress` is true. Sampling mechanism (timer vs. tick) not fully confirmed beyond `FanServiceSubsystem.cpp:120`; **verify frequency** before shipping fan-service challenges.

## Layer 2 — Contract surface

- `GrantGoalCompletionRewards(FName CityID, int32 CityIndex, ECityGoalTier GoalTier)` — primary entry from VT-CITY.
- `OnGoalItemRewardCalculated` (delegate) — UI subscribes for reward popup.
- `OnGoalCashRewardCalculated` (delegate) — UI subscribes for cash reward display.
- `OnItemRewardGranted` (delegate) — inventory/profile confirmation hook.
- Achievement entry point: `UAchievementSubsystem` update called from `UProgressionCenterSubsystem` post-race path.
- Fan-service entry: `AddFanService(TrackId)` / `HandleCompleteFanService` — called from race actor during active in-race challenge.

Evidence gap: full reward table schema, exact LootCrate tier mapping per OP #230/#293 and complete achievement event list should be verified from `RewardCenterSubsystem.h` DataTable headers before any reimplementation.

## Links

- Audit: `Docs/audit/VT-REWARD_reward.md`
- Structurizr: `VT_REWARD_Components`
- Portal: `Docs/portal/src/content/docs/features/vt-reward.md`
- Related: VT-CITY (goal/city-unlock reward calls), SUP-INV (item storage), SUP-PROF (currency storage), DM-RACE (race completion trigger)
