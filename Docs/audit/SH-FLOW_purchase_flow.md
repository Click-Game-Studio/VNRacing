# SH-FLOW — Purchase Flow

## Phạm vi
🆕 Feature mới trong SHOP & IAP Epic (#366). Chưa có code.

❌ **Gap:** Feature Purchase Flow (#455) chưa được implement. Code hiện tại có `FMockCommerceProvider` (editor/dev only); provider Android/iOS bị comment; không có server receipt verification.

## Module/class C++ liên quan (file thật)
- `UCommerceSubsystem` (CommerceSubsystem.cpp:14-23,80-85) — purchase orchestration, chỉ mock provider được wire.
- `FMockCommerceProvider` — editor/dev stand-in.
- Android/iOS providers bị comment (`CommerceSubsystem.cpp:80-85`).

## Mức ưu tiên: **P1**
Thiếu native IAP providers + server verification; mock chỉ dùng cho dev.
