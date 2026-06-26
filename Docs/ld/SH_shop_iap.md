# SH — SHOP & IAP — Low-Level Design

> Source: Context-engine verification. OpenProject: #366 (Epic).
> Subs: SH-DISP #405 (Shop Display), SH-FLOW #455 (Purchase Flow).

## Feature summary and boundaries

🆕 since 2026-06-23. SH is a new Epic-level feature covering the Shop & IAP (in-app purchase) experience. It replaces the former SUP-SHOP (Support — Shop / IAP / Ads) which existed as a support subsystem outside the product CSV. The two main features under this epic are Shop Display (#405) and Purchase Flow (#455).

Note: The existing `UCommerceSubsystem` and `FMockCommerceProvider` in codebase are support infrastructure (SUP-SHOP). SH-DISP and SH-FLOW represent the **product-facing** shop features that are missing from the current implementation.

### SH-DISP Shop Display (#405)

🆕 since 2026-06-23. Feature under SHOP & IAP Epic.

❌ **Gap: not yet implemented.** Work-package #405 defines the shop display — the in-game store screen showing products (cars, cosmetics, currency packs, boosters) organized into categories. The existing code has `UCommerceSubsystem` for purchase orchestration and `WBP_Shop` / `WBP_Popup_Shopping` / `WBP_Card_DLC` Blueprints for shop UI, but these are prototype/mock implementations without real product data or IAP integration.

**Proposed approach:**
- Shop screen with product categories (cars, visual items, currency, boosters).
- Product cards showing price (premium currency / real money), thumbnail, description.
- Read product catalog from DataTable or backend configuration.
- Integrate with `UCommerceSubsystem` for purchase initiation.

### SH-FLOW Purchase Flow (#455)

🆕 since 2026-06-23. Feature under SHOP & IAP Epic.

❌ **Gap: not yet implemented.** Work-package #455 defines the purchase flow — from tapping "Buy" to confirmation, payment processing, and reward delivery. The existing mock provider (`FMockCommerceProvider`) handles purchase in editor/dev mode only; native iOS/Android providers (`FAppleCommerceProvider`, `FAndroidCommerceProvider`) are commented out in `CommerceSubsystem.cpp:80-85`.

**Proposed approach:**
- Purchase confirmation dialog showing item, price, and "Confirm" / "Cancel".
- IAP provider selection: wire native Apple/Google providers for production, keep mock for dev.
- Server receipt validation (currently absent — `#backend-target`).
- Post-purchase: grant item through `UInventoryManager`, refresh wallet through `UProfileManagerSubsystem`.

## Layer 1 — Implementation map

The existing SUP-SHOP code provides the backend for shop/purchase:

| Component | Source | Responsibility |
|---|---|---|
| `UCommerceSubsystem` | `CommerceSubsystem.cpp` | Purchase orchestration (mock provider wired; native providers stubbed). |
| `FMockCommerceProvider` | `CommerceSubsystem.cpp:14-23` | Editor/dev stand-in provider. |
| Shop UI BPs | `WBP_Shop`, WBP_Popup_Shopping, WBP_Card_DLC, WBP_Card_BoosterBundles, WBP_Play_Rewards_WatchAds` | Prototype shop UI widgets. |

## Links

- Portal: `Docs/portal/src/content/docs/features/sh-disp.md` and `sh-flow.md`
- Cross-ref: SUP-SHOP (existing code), CDN (content delivery), VT-REWARD (reward pipeline)
