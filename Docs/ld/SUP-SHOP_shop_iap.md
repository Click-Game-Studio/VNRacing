# SUP-SHOP — Shop / IAP / Ads (Hệ thống nền — ngoài CSV) — Low-Level Design

> Source: `Docs/audit/SUP-SHOP_shop_iap.md`, `Docs/c4/model.c4`. Structurizr view: `SUP_SHOP_Components`.
> Ngoài danh sách feature OpenProject 2026-06-15 — hệ thống nền, ứng viên refactor.

## Feature summary and boundaries

SUP-SHOP owns store products, purchase orchestration and shop/ad UI integration. SUP-PROF owns wallet state; app stores/backends own production entitlement authority.

![SUP-SHOP components](../structurizr/embed/SUP_SHOP_Components)

# Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `UCommerceSubsystem` | `CommerceSubsystem.cpp:14-23,80-85` | Product and purchase orchestration through provider abstraction. |
| `FMockCommerceProvider` | commerce provider source | Editor/dev stand-in provider currently wired. |
| Shop UI BPs | Blueprint metadata | Shop, popup, DLC, booster and rewards/ad widgets. |

Runtime flow: UI invokes commerce subsystem, subsystem delegates to provider, result should update entitlement/economy. Current evidence shows mock provider wiring only.

Hotspot/gap: Android/iOS providers are commented/not production-wired and there is no server receipt verification path in source evidence.

# Layer 2 — Contract surface (verified entry points)

Verified entry points: commerce subsystem product/purchase orchestration and mock provider. Production contract must include native provider callbacks plus backend receipt/entitlement verification before trusting rewards or currency.

Evidence gap: real App Store / Play Billing and backend authority are target architecture, not verified implementation.

## Links

- Audit: `Docs/audit/SUP-SHOP_shop_iap.md`
- Structurizr: `SUP_SHOP_Components`
