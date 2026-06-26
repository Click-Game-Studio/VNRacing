# VT-TRACK-UN — Track Unlock — Low-Level Design

> Source: Context-engine verification. OpenProject: #425.

## Feature summary and boundaries

🆕 since 2026-06-23. VT-TRACK-UN defines Track Unlock mechanics — conditions and logic for unlocking new tracks within an area, separate from the existing area-unlock chain (VT-TRACK parent).

❌ **Gap: feature requested but partially implemented.** Work-package #425 defines track-level unlock rules. The existing `UProgressionSubsystem` has `UnlockNext` (stub — body commented out at `ProgressionSubsystem.cpp:20`) and `VNTourProgressionData.UnlockNextTrack` (which may or may not be functional). Track unlock is currently driven by `FTrackUnlockData.RequiredTopRank = 3` (default) — a track unlocks when the player finishes the previous track at rank <= 3.

Partial implementation:
- `FTrackUnlockData.RequiredTopRank` defines rank threshold for unlocking next track (default 3).
- `UProgressionSubsystem::UnlockNext` is called after race completion to advance track unlock.
- `UProgressionSubsystem::HandleRecordRaceResult` processes race results and triggers unlock checks.

What's missing:
- `UnlockNext` body is commented out in source — the actual unlock may happen elsewhere or be non-functional.
- No DataTable override for `RequiredTopRank` per track pair (default 3 for all tracks).
- `OnTrackUnlocked` delegate not found in codegraph — UI may not be reactive to track unlocks.

## Layer 1 — Implementation map

| Component | Source | Responsibility |
|---|---|---|
| `UProgressionSubsystem::UnlockNext` | `ProgressionSubsystem.cpp:20` | Stub — body commented out. |
| `FTrackUnlockData.RequiredTopRank` | `ProgressionData.h:801` | Default rank threshold for unlock. |
| `UProgressionSubsystem::HandleRecordRaceResult` | `ProgressionSubsystem.cpp` | Race result processing → unlock checks. |

## Known Issue

`UnlockNext` at `ProgressionSubsystem.cpp:20` has its body fully commented out:
```
// void UProgressionSubsystem::UnlockNext(int32 CurrentTrackID)
// {
//     VNTourProgressionData.UnlockNextTrack(CurrentTrackID);
// }
```
The unlock mechanism needs verification — track unlock may be happening through a different code path or may not function at all.

## Links

- Portal: `Docs/portal/src/content/docs/features/vt-track.md`
- Cross-ref: VT-TRACK (parent feature), VT-CITY (city progression)
