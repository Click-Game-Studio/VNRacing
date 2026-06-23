# VT-CITY-IU — Item Unlock

## Phạm vi
🆕 Sub Feature mới trong CSV 2026-06-23 (#386). Chưa có code.

❌ **Gap:** Item unlock theo city progression chưa được implement. `UProgressionSubsystem` hiện tại không có milestone item unlock.

## Module/class C++ liên quan (file thật)
Không có subsystem riêng. Có thể tái sử dụng:
- `UProgressionSubsystem::HandleUnlockNextCity` — hook để thêm item grant.
- `UInventoryManager::AddItem` — inventory grant.

## Mức ưu tiên: **P2**
Feature mới — cần mở rộng progression unlock chain.
