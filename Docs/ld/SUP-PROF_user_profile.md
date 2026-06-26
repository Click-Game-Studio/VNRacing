# SUP-PROF — User Profile / Economy (Hệ thống nền — ngoài CSV) — Low-Level Design

> Source: `Docs/audit/SUP-PROF_user_profile.md`, `Docs/c4/model.c4`. Structurizr view: `SUP_PROF_Components`.
> Ngoài danh sách feature OpenProject 2026-06-15 — hệ thống nền, ứng viên refactor.

## Feature summary and boundaries

SUP-PROF owns player identity, wallet currencies, profile stats, fuel/session energy and snapshot sync. It does not own reward rules, shop product catalog or progression topology.

![SUP-PROF components](../structurizr/embed/SUP_PROF_Components)

# Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `UProfileManagerSubsystem` | `ProfileManagerSubsystem.cpp:14-30,519` | Wallet earn/spend, name filter, top-speed sampling timer and profile data. |
| `URaceSessionSubsystem` | session source | Fuel/session energy, recharge timers and current race/session data. |
| `USnapshotAdapterSubsystem` | snapshot source | Player snapshot load/save via Nakama RPC. |

Runtime flow: UI/profile screens read profile; gameplay/progression spends or awards wallet/session resources; save manager persists local state; snapshot adapter can sync through Nakama.

Hotspots: name filter scans O(name × forbidden words); top-speed sampling timer runs at 5Hz.

# Layer 2 — Contract surface (verified entry points)

Verified entry points: wallet earn/spend checks, profile name validation, session fuel spend/recharge, snapshot load/save through Nakama RPC, save hand-off through `UCarSaveGameManager`.

Evidence gap: backend authority for profile/economy is target architecture; current source evidence remains local/prototype-heavy.

## Links

- Audit: `Docs/audit/SUP-PROF_user_profile.md`
- Structurizr: `SUP_PROF_Components`
