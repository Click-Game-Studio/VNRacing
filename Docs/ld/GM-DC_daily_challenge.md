# GM-DC — DAILY CHALLENGE — Low-Level Design

> Source: Context-engine verification (no implementation found). Structurizr view: `gmDc` (LikeC4).
> OpenProject: #274. Subs: #426 Challenge Unlock, #431 Challenge Config.

## Feature summary and boundaries

❌ **Gap: feature requested but unimplemented.** OpenProject #274 defines a Daily Challenge feature for VNRacing. A full search of the `PrototypeRacing/` codebase via CodeGraph and context-engine finds **no subsystem, no class, no data asset** implementing a daily mission pool, daily reset, or a daily challenge screen. This document records the gap and proposes what needs to be built.

### Clarification: FanServiceSubsystem is NOT reusable directly

`UFanServiceSubsystem` exists in the codebase and handles fan-point challenges **during an active race** (in-race only). It is not a daily mission pool subsystem: it has no concept of per-day assignment, calendar reset, or between-session persistence. It cannot be repurposed directly for GM-DC without significant redesign.

## Layer 1 — Implementation map

No implementation exists. The table below describes the components that **need to be built**.

| Component (proposed) | Responsibility |
|---|---|
| `UDailyChallengeSubsystem` | Daily mission pool: load pool from DataTable, assign N missions per day, persist assignment keyed to calendar date. |
| Daily reset mechanism | On session init or server tick, compare stored date to today; if different, refresh assigned missions and reset completion state. |
| Daily Challenge screen (UMG) | Display today's missions with progress bars, completion states and reward previews; navigable from main menu. |
| `FDailyChallengeConfig` (DataTable row) | Per-mission definition: description, goal type, target value, reward reference. |

## Layer 2 — Contract surface

No verified entry points exist. Proposed integration points:

- `UDailyChallengeSubsystem` should subscribe to `DM-RACE` race-result events (same delegate surface as `UProgressionCenterSubsystem`) to increment in-race metric goals.
- Daily reset should hook into game session initialisation (e.g., `UGameInstance::Init` or a dedicated date-check subsystem).
- Reward dispatch should delegate to `VT-REWARD` (`URewardCenterSubsystem`) for consistency with existing reward pipeline.

### GM-DC-UN Challenge Unlock (#426)

🆕 since 2026-06-23. Sub-feature of DAILY CHALLENGE.

❌ **Gap: not yet implemented.** Work-package #426 defines challenge unlock logic for Daily Challenge — e.g., unlock conditions based on player progression (city completion rank, VN Tour milestones). No subsystem or data asset found in `PrototypeRacing/` implementing challenge unlock conditions.

**Proposed approach:**
- Daily Challenge pool should have an `FChallengeDefinition` row with `UnlockCondition` field (enum or predicate).
- Unlock condition evaluated on Daily Challenge screen init: if condition met, challenge is visible and playable.
- If all challenges unlocked, show the standard pool; if some locked, show locked state with condition description.

### GM-DC-CFG Challenge Config (#431)

🆕 since 2026-06-23. Sub-feature of DAILY CHALLENGE.

❌ **Gap: not yet implemented.** Work-package #431 defines challenge configuration — e.g., adjustable parameters per daily challenge (goal targets, reward multipliers, time windows). No subsystem or data asset found in `PrototypeRacing/`.

**Proposed approach:**
- Extend `FDailyChallengeConfig` DataTable row with configuration fields (target value override, reward multiplier, active time window).
- Config loaded at session init and applied when assigning daily challenges.

## Links

- Portal: `Docs/portal/src/content/docs/features/gm-dc.md`
- Cross-ref: VT-REWARD (reward pipeline), DM-RACE (race-result events)
- No audit file — no code to audit.
