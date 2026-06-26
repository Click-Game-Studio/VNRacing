# SH-DISP — Shop Display

## Phạm vi
🆕 Feature mới trong SHOP & IAP Epic (#366). Chưa có code.

❌ **Gap:** Feature Shop Display (#405) chưa được implement. Code hiện tại có `WBP_Shop`, `WBP_Popup_Shopping`, `WBP_Card_DLC` (SUP-SHOP) nhưng là prototype/mock UI không có product data thực hay IAP integration.

## Module/class C++ liên quan (file thật)
Không có subsystem riêng. Có thể tái sử dụng:
- `UCommerceSubsystem` — purchase orchestration (mock provider).
- `WBP_Shop`, `WBP_Popup_Shopping` — prototype shop UI.

## Mức ưu tiên: **P1**
Shop UI tồn tại dưới dạng prototype; cần rework toàn bộ cho production.
