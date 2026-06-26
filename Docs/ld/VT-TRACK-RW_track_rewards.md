# VT-TRACK-RW — Track Rewards — Low-Level Design

> Source: Context-engine verification. OpenProject: #424.

## Feature summary and boundaries

🆕 since 2026-06-23. VT-TRACK-RW defines Track Rewards — rewards specific to completing a track at a certain rank or under certain conditions (first-win bonus, rank-based payout, completion rewards).

❌ **Gap: feature requested but partially implemented.** Work-package #424 defines track-level rewards. The existing `URewardCenterSubsystem` handles generic reward calculation and `UProgressionCenterSubsystem::HandleRaceCompleted` triggers post-race reward processing. However, there is no dedicated **track-specific** reward table or first-win bonus system separate from the general cash reward scaling.

Partial implementation:
- `UProgressionCenterSubsystem::HandleRaceCompleted` → delegates to `URewardCenterSubsystem` for cash/item rewards based on race rank.
- `HandleRaceCompleted` has `FirstWinBonus` logic for first-time completion of a track (per `ProgressionCenterSubsystem.cpp`).
- Standard cash payout scales by track difficulty and player rank via `EarnCurrency` in `UProfileManagerSubsystem`.

What's missing:
- No track-specific reward table (reward multipliers, bonus items per track).
- No UI for track reward preview before entering a race.
- First-win bonus is not separately tracked per-track; only first-completion tracking exists.

## Layer 1 — Implementation map

| Component | Source | Responsibility |
|---|---|---|
| `URewardCenterSubsystem` | `RewardCenterSubsystem.cpp` | Reward token roll, cash/item grant. |
| `UProgressionCenterSubsystem::HandleRaceCompleted` | `ProgressionCenterSubsystem.cpp:94` | Post-race orchestration including reward dispatch. |
| `UProfileManagerSubsystem::EarnCurrency` | `ProfileManagerSubsystem.cpp` | Cash/coin addition to player wallet. |

## Links

- Portal: `Docs/portal/src/content/docs/features/vt-track.md`
- Cross-ref: VT-REWARD (reward pipeline), DM-RACE (race results)
