# VT-TRACK — Area-Track Unlock — Low-Level Design

> Source: `Docs/audit/VT-TRACK_area_track_unlock.md`, `Docs/c4/model.c4`. Structurizr view: `VT_TRACK_Components`.
> OpenProject: #341.

## Feature summary and boundaries

VT-TRACK owns the area/track unlock progression within an unlocked city, the track-selection flow (UI → race setup), and the track difficulty recalculation triggered by car-rating changes. It shares `UProgressionSubsystem` with VT-CITY; the boundary is that VT-CITY owns city-level unlock and goal assignment, while VT-TRACK owns everything at the area/track level below that.

Track unlock is gated by **vị thứ** (race finishing rank): `FTrackUnlockData.RequiredTopRank` (default `3`, defined at `ProgressionData.h:801`). A player must finish at or above that rank to unlock the next track.

![VT-TRACK components](../structurizr/embed/VT_TRACK_Components)

## Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `UProgressionSubsystem` | `ProgressionSubsystem.cpp` | Owns `VNTourProgressionData`; area/track unlock state. |
| `UnlockNext(int32 CurrentTrackID)` | `ProgressionSubsystem.cpp:20` | Stub that wraps `VNTourProgressionData.UnlockNextTrack` (body commented out; implementation pending or moved). |
| `FTrackUnlockData` | `ProgressionData.h:801` | Struct holding `RequiredTopRank`; used to check vị thứ unlock condition. |
| `RecalculateTrackDifficulty` | `ProgressionSubsystem.cpp:2127` | Iterates all city/area/track nodes; recomputes `FTrackProgress.Difficulty` via `UCarRatingSubsystem::GetTrackDifficultyByPerformance`; broadcasts `OnTrackDifficultyRecalculated`; saves progression. |
| `OnTrackDifficultyRecalculated` | delegate (broadcast at `ProgressionSubsystem.cpp:2133`) | UI subscribes to refresh difficulty badges on the track-select screen. |
| `UCarRatingSubsystem::GetTrackDifficultyByPerformance` | `CarRatingSubsystem.cpp:189` | Returns `ETrackDifficulty` (Easy/Medium/Hard) by comparing player CR against track `PerformanceGates` with tolerance band. |

Runtime flow (Track Selection, #342): UI selects a track node → `UProgressionCenterSubsystem::SetupRaceData` reads `FTrackProgress.LocationInfo` → DM-RACE loads the level. On race finish: result compared against `FTrackUnlockData.RequiredTopRank`; if passed, `UnlockNext` is called to open the next track.

Runtime flow (Track Config, #343): any car upgrade triggers `RecalculateTrackDifficulty` → all track difficulty badges refresh via `OnTrackDifficultyRecalculated` delegate.

Hotspot: `RecalculateTrackDifficulty` performs a triple nested loop over all cities/areas/tracks and one `GetTrackDifficultyByPerformance` call per track. Not per-frame (triggered on car upgrade), but will grow with content volume.

Note: `UnlockNext` body is currently a commented-out stub (`ProgressionSubsystem.cpp:20–22`). The actual unlock chain may be handled elsewhere (e.g. directly in `VNTourProgressionData.UnlockNextTrack`). **Verify before next sprint.**

## Layer 2 — Contract surface

### Track Selection (#342)

- `UProgressionCenterSubsystem::SetupRaceData` — entry point for UI → race launch; reads selected track's `LocationInfo`.
- `FTrackUnlockData.RequiredTopRank` — vị thứ threshold; DataTable-driven, no code change needed to tune.

### Track Config (#343)

- `RecalculateTrackDifficulty(EPerformanceStatType, int32 NewLevel, bool bUpgrade)` — called on car-rating change.
- `OnTrackDifficultyRecalculated` (multicast delegate) — UI refresh hook.
- `ETrackDifficulty` enum: `Easy`, `Medium`, `Hard`.

### VT-TRACK-RW Track Rewards (#424)

🆕 since 2026-06-23. Sub-feature of Area-Track Unlock.

❌ **Gap: not fully implemented.** Work-package #424 defines track-level rewards — first-win bonus, rank-based payout, completion rewards. The existing `URewardCenterSubsystem` handles generic reward calculation and `UProgressionCenterSubsystem::HandleRaceCompleted` triggers post-race reward processing. However, there is no dedicated track-specific reward table or first-win bonus system separate from general cash reward scaling.

**Partial implementation:**
- `UProgressionCenterSubsystem::HandleRaceCompleted` delegates to `URewardCenterSubsystem` for cash rewards based on race rank.
- Standard cash payout scales by track difficulty and player rank.
- What's missing: track-specific reward table, UI reward preview, per-track first-win bonus tracking.

### VT-TRACK-UN Track Unlock (#425)

🆕 since 2026-06-23. Sub-feature of Area-Track Unlock.

⚠️ **Partial: implementation at risk.** Work-package #425 defines track-level unlock rules. The existing `FTrackUnlockData.RequiredTopRank` (default=3) defines the rank threshold, and `UProgressionSubsystem::UnlockNext` is called after race completion. However, `UnlockNext` body is a commented-out stub (`ProgressionSubsystem.cpp:20`). The actual unlock may happen through `VNTourProgressionData.UnlockNextTrack` directly or may be non-functional.

**Known issue:** The stub body at `ProgressionSubsystem.cpp:20-22` must be verified before next sprint.

## Links

- Audit: `Docs/audit/VT-TRACK_area_track_unlock.md`
- Structurizr: `VT_TRACK_Components`
- Portal: `Docs/portal/src/content/docs/features/vt-track.md`
- Related: VT-CITY (city unlock layer above), VT-CARPROG (CR source for difficulty calc)
