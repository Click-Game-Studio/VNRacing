# 03. Container View

![Containers](embed:Containers)

## Six canonical containers

| Container | Role | Main features |
|---|---|---|
| UI / UMG Layer | Widgets, HUD and Blueprint screens. Reads subsystem state via delegates and calls feature APIs. | DM-PHYS car BPs, CU-ROOM customize UI, SUP-SHOP shop UI, CDN patch UI, SUP-TUT tutorial UI. |
| Gameplay Runtime | Level-bound gameplay: vehicle physics, race lifecycle, AI, pooling and multiplayer waiting-room entry. | DM-PHYS, DM-RACE, DM-NOS, DM-RAMP, DM-CAM, SUP-AI, SUP-POOL, GM-MP (waiting room). |
| Meta / Economy Subsystems | Long-lived GameInstance subsystems for VN Tour, customization, inventory, profile, rewards, commerce, tutorial and settings. | VT-CITY, VT-TRACK, VT-CARPROG, VT-REWARD, CU-ROOM, DM-SET, SUP-INV, SUP-PROF, SUP-SHOP, SUP-TUT. |
| Backend Communication | Nakama client/session/realtime/match services and shared backend contract types. | GM-MP (Nakama/match) plus snapshot for SUP-PROF and join-token for waiting room. |
| Local Data / SaveGame | GameInstance DataTable registry and SaveGame slots. Local source of truth for offline/prototype flows. | Cross-cutting support for VT-*/CU-ROOM/SUP-INV/SUP-PROF/SUP-SHOP/SUP-TUT/DM-SET and race setup data. |
| Debug / Tooling | Debug modules, track-test batch simulation, runtime performance monitor, significance and PSO helpers. | SUP-DBG, SUP-PERF. |

## Component overview diagrams

![Gameplay components](embed:AllFeature_Gameplay)

![Meta/economy components](embed:AllFeature_Meta)

![Backend components](embed:AllFeature_Backend)

![Tooling components](embed:AllFeature_Tooling)
