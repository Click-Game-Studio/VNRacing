# GM-MP — MULTIPLAYER — Low-Level Design

> Source: `Docs/audit/GM-MP_multiplayer.md`, `Docs/c4/model.c4`.
> Structurizr view: `GM_MP_Components`.
> OpenProject: #273.

## Feature summary and boundaries

GM-MP consolidates the former F11 (Backend/Nakama) and F12 (Multiplayer Race) into one feature. It owns client-side Nakama auth/session/realtime/match services, shared backend request/response contract types, and the waiting-room game mode that validates join tokens and travels into the multiplayer race level.

GM-MP is a client communication layer plus a waiting-room shell. It is **not** the authoritative economy server, nor does it implement a server-authoritative race flow — that gap is documented explicitly below.

![GM-MP components](../structurizr/embed/GM_MP_Components)

## Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `UNakamaServiceSubsystem` | `NakamaServiceSubsystem.cpp:8,90,157-162` | Client/session/realtime lifecycle and auth flows; holds match-service back-reference. |
| `UMatchServiceSubsystem` | `MatchServiceSubsystem.cpp` | Matchmaking query/ticket, matched/presence event handling and JSON payload parse. |
| `UNakamaNetworkSubsystem` | `NakamaNetworkSubsystem.cpp` | Network-level Nakama plumbing. |
| `BackendContractTypes` | contract headers | Shared backend request/response structs. |
| `AMultiplayerWaitingRoomGameMode` | `MultiplayerWaitingRoomGameMode.cpp` (~324 lines) | Join-token validation and waiting-room travel. |

Runtime flow: auth/session setup goes through `UNakamaServiceSubsystem`; `UMatchServiceSubsystem` uses realtime/session state to issue a matchmaking ticket and handle presence/matched events; matchmaking completes and supplies a join token; `AMultiplayerWaitingRoomGameMode` validates the token and travels the client into the multiplayer level.

Hotspot: bidirectional coupling between `UNakamaServiceSubsystem` (`NakamaServiceSubsystem.cpp:8` includes `MatchServiceSubsystem.h`; `:90` calls `SetupMatchEventRealtime`; `:157-162` caches `UMatchServiceSubsystem` pointer) and `UMatchServiceSubsystem` (holds reverse reference) — makes isolated testing difficult and risks init-order cycles.

⚠️ **Gap — server-authoritative race flow NOT implemented.** `AMultiplayerWaitingRoomGameMode` handles waiting-room and join-token validation only. Server-side race state authority (server clamp/relay, anti-cheat, authoritative result validation) does not exist. The current physics replication path (`ASimulatePhysicsCar` with `NetUpdateFrequency=100` at `SimulatePhysicsCar.cpp:82-87`) is client-simulated. At 100 Hz × N cars the bandwidth cost is unsustainable for real PvP. This is the largest open gap in the Game Mode epic.

## Layer 2 — Contract surface

Verified entry points:
- `UNakamaServiceSubsystem` — auth/session/realtime lifecycle, snapshot RPC adapter consumer.
- `UMatchServiceSubsystem` — matchmaking ticket/query, presence/matched events, JSON payload parse.
- `UNakamaNetworkSubsystem` — Nakama network plumbing.
- `BackendContractTypes` — shared request/response structs.
- `AMultiplayerWaitingRoomGameMode` — join-token validate/travel.

Evidence gaps: authoritative physics/race-result validation, dedicated-server snapshot protocol, anti-cheat authority all require editor/source work beyond current evidence. Server-authoritative race architecture is target only — do not assume implemented.

### GM-MP-MATCH Ghép Trận (#437)

🆕 since 2026-06-23. Sub-feature of MULTIPLAYER.

❌ **Gap: not yet implemented.** Work-package #437 defines matchmaking/ghép trận flow — the process of finding opponents, forming a race lobby, and transitioning to the race level. Current code has `UMatchServiceSubsystem` for matchmaking tickets and `AMultiplayerWaitingRoomGameMode` for the waiting room, but the full match flow (ticket → matched → lobby ready → race travel) is incomplete. The waiting-room handles join-token validation and travel, but the match-formation UX and state-machine are not verified.

**Proposed approach:**
- Extend `UMatchServiceSubsystem` with a match-state machine (Idle → Searching → Matched → LobbyReady → Travelling → Race).
- Wire lobby-ready handshake: all players in the match confirm readiness before travel.
- Add UI state for matchmaking search (searching animation, cancel matchmaking).

### GM-MP-RACE Vào Trận - Trong Trận (#447)

🆕 since 2026-06-23. Sub-feature of MULTIPLAYER.

❌ **Gap: not yet implemented.** Work-package #447 defines the in-race multiplayer experience — entering the race, real-time multiplayer race state, opponent car replication. Current code has `ASimulatePhysicsCar` with client-side simulation and `NetUpdateFrequency=100` for replication, but there is no server-authoritative race flow. The existing `AMultiplayerWaitingRoomGameMode` does not provide authoritative race state.

**Proposed approach:**
- Server-authoritative race state management (`ARaceGameState` extended for multiplayer authority).
- Client-side input prediction + reconciliation (or authoritative server clamp).
- Anti-cheat measurement: position, speed, checkpoint timestamps validated server-side.

### GM-MP-POST Sau trận (#448)

🆕 since 2026-06-23. Sub-feature of MULTIPLAYER.

❌ **Gap: not yet implemented.** Work-package #448 defines the post-race multiplayer experience — result screen, rewards, stats comparison, and return flow. Current single-player post-race flow goes through `ARaceTrackManager::HandleRaceCompleted` → `UProgressionCenterSubsystem::HandleRaceCompleted`. Multiplayer results would need a different flow (or re-use with multiplayer-aware branching).

**Proposed approach:**
- Multiplayer result aggregation: collect final positions and stats from server-authoritative state.
- Result screen showing all players' times/ranks/stats.
- Return flow: from result screen back to match lobby or main menu.

## Links

- Audit: `Docs/audit/GM-MP_multiplayer.md`
- Structurizr: `GM_MP_Components`
- Portal: `Docs/portal/src/content/docs/features/gm-mp.md`
- Merges: former `ld/F11_backend_nakama.md` + `ld/F12_multiplayer.md`
