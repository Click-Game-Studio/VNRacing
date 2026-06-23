# 02. System Context

## Actors and external systems

![System context](embed:SystemContext)

| Element | Responsibility / constraint |
|---|---|
| Mobile Player | iOS / Android player using touch input, race screens, garage and meta-game navigation. |
| VNRacing UE5 Mobile Client | Single UE client module that currently owns gameplay, meta/economy, UI, local persistence, online client services and tooling. |
| Nakama | Auth, session, realtime socket and matchmaking boundary through the Nakama UE SDK. |
| Edgegap / Dedicated Server | Target hosting/server boundary. Source confirms waiting-room/join-token flow, but full server-authoritative race is not complete evidence. |
| GameAnalytics | Telemetry sink only; gameplay state should not depend on event delivery. |
| App Store / Play Billing | Target IAP entitlement provider. Source currently wires a mock commerce provider; native providers/server receipt verification are gaps. |
| Content CDN | Target for pak/chunk download through ChunkDownloader. |
| Backend Economy Services | Target profile/economy/inventory/progression authority. Current source is still client-local/prototype-heavy. |

## Constraints

- Mobile frame-time stability is a first-class quality goal.
- Race runtime is level-bound; most meta systems are `UGameInstanceSubsystem`s.
- UI must use subsystem APIs/delegates rather than owning business state.
- Local DataTable/SaveGame remains the practical source of truth for many prototype/offline flows.
- Static Structurizr export is a diagram snapshot only; rich docs and ADRs must be reviewed through Structurizr Lite/Cloud/on-prem.
