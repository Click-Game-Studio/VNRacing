# VT-TRACK-RW — Track Rewards

## Phạm vi
🆕 Sub Feature mới trong CSV 2026-06-23 (#424). Partial impl.

⚠️ **Partial:** Có `URewardCenterSubsystem` xử lý generic reward, `UProgressionCenterSubsystem::HandleRaceCompleted` gọi reward pipeline sau race, và `FirstWinBonus` tracking. Chưa có track-specific reward table hay UI preview reward.

## Module/class C++ liên quan (file thật)
- `URewardCenterSubsystem` — reward token roll và grant.
- `UProgressionCenterSubsystem::HandleRaceCompleted` — post-race reward orchestration.
- `UProfileManagerSubsystem::EarnCurrency` — cash/coin addition.

## Mức ưu tiên: **P2**
Có base infrastructure; cần thêm track-specific data table và UI.
