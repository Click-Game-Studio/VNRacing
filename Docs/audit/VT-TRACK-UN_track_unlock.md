# VT-TRACK-UN — Track Unlock

## Phạm vi
🆕 Sub Feature mới trong CSV 2026-06-23 (#425). Partial impl.

⚠️ **Partial:** Có `FTrackUnlockData.RequiredTopRank` (default=3) và `UProgressionSubsystem::UnlockNext` nhưng body của `UnlockNext` bị comment out. Có thể unlock không hoạt động hoặc xảy ra qua code path khác.

## Module/class C++ liên quan (file thật)
- `UProgressionSubsystem::UnlockNext` (ProgressionSubsystem.cpp:20) — stub, body commented out.
- `FTrackUnlockData.RequiredTopRank` (ProgressionData.h:801) — rank threshold default=3.
- `UProgressionSubsystem::HandleRecordRaceResult` — race result processing.

## Mức ưu tiên: **P1**
Rủi ro gameplay: unlock track có thể không hoạt động.
