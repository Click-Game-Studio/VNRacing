# Multiplayer — Trạng thái Triển khai, Kiến trúc & Lộ trình

> **Phạm vi tài liệu**
> Tài liệu này tổng hợp trạng thái hiện tại của toàn bộ hệ thống Multiplayer của **PrototypeRacing** (UE5 client + Nakama backend + Edgegap dedicated server hosting), đối chiếu với yêu cầu nghiệp vụ mới trong `Docs/Multiplayer_New.md` (12 US Quick Match + 4 US Lobby Match), và đề xuất lộ trình triển khai phần còn lại kèm khối lượng cập nhật cho CI/CD build server (`Docs/RacingMobile.groovy`).
>
> **Ngày cập nhật**: 2026-06-23
> **Tác giả**: MiniMax-M3 (theo yêu cầu của user qua `/osf feat` + `/explore`)
> **Phương pháp**: MCP `codebase-retrieval` (port 6699) + `repo-vnracing` (P4V main) cho structural context; kết hợp đọc trực tiếp các file docs + UE source + Nakama Go runtime + Jenkins pipeline.

---

## 0. Tóm tắt điều hành (Executive Summary)

| Câu hỏi | Trả lời |
|---|---|
| Stack hiện tại có đáp ứng nổi 16 US mới không? | **Đáp ứng phần lõi Quick Match (step 1: MMR + matchmaking + dedicated server handoff).** Thiếu UX cảnh (Intro/Quick/Post-game/Art cutscene), matchmaking nâng cao (real ping, server-authoritative step 2, AI takeover, Lobby Match, win streak/revenge), economy (item reward) và Private/Lobby flow. |
| Đã làm được gì? | (1) Local Nakama + Postgres Docker stack; (2) Unreal Nakama client + Realtime + Matchmaker; (3) MMR profile + leaderboard qua Go RPC (`prototype_get_multiplayer_profile`, `prototype_update_mmr_result`); (4) Matchmaking Multiplayer_V6 với widening windows (`MMR ±500/±1000/±1500`, `CR ±3 mỗi 3s`), timeout 60s, ping placeholder; (5) Edgegap broker flow (Nakama Go runtime tạo handoff match + gọi Edgegap allocate + broadcast opcode 1); (6) LinuxServer Docker image publish script + local validation; (7) Waiting Room GameMode + join-token protection; (8) Matchmaking widget UI state machine đầy đủ (Ready/Searching/Allocating/Traveling/Error/TimedOut). |
| Còn thiếu gì? | (a) **UX scenes**: Intro scene, Quick scene, Post-game rank scene, Art cutscene/âm thanh/effect; (b) **Matchmaking nâng cao**: real ping (hiện đang là placeholder 50ms), matchmaking theo CR (chỉ có MMR ±500/1000/1500, chưa có CR widening windows trong query), AI takeover khi disconnect; (c) **Server-authoritative** (Step 2) — race result do dedicated server phê duyệt, không phải client tự submit; (d) **Lobby/Private Match** (4 US mới); (e) **Win streak / Revenge mark**; (f) **Item reward** (chỉ Cash đã được thiết kế); (g) **Tự động thắng khi toàn bộ đối thủ disconnect**; (h) **CI/CD LinuxServer/Docker build** chưa có trong `RacingMobile.groovy` (chỉ iOS + Android). |
| Build server cần sửa gì? | Thêm stage mới `LinuxServer Build` song song với iOS/Android, gọi `Build/Edgegap/publish_edgegap_server.sh` để package LinuxServer, build Docker image, push Edgegap registry, tạo Edgegap app version, đẩy `EDGEGAP_APP_VERSION` xuống Nakama runtime cho broker dùng. |

---

## 1. Stack hiện tại — Đánh giá đáp ứng

### 1.1 Bảng đánh giá nhanh

| Layer | Công nghệ / Module | Sẵn sàng cho Multiplayer_New.md? |
|---|---|---|
| UE5 Client | 5.x (engine GUID), `PrototypeRacing` module | ✅ Đủ cho client-side auth/matchmaking/UI |
| Nakama plugin | `Plugins/Nakama` 2.10.1 (HeroicLabs) | ✅ Realtime + Matchmaker + RPC đều có |
| Nakama Server | `PrototypeRacing/Server/Nakama` (Docker + Go runtime 3.39.0) | ✅ Matchmaker + Storage + Leaderboard + authoritative Match + Edgegap broker |
| Postgres | `postgres:16.8-alpine` trong compose | ✅ Storage cho profile/leaderboard |
| Dedicated Server | Edgegap-hosted LinuxServer container (UE5 Linux target) | ✅ Đã validate local package + Docker, handoff join token có, waiting room game mode có |
| Matchmaker logic | Unreal `UMatchServiceSubsystem` + Nakama matchmaker | ⚠️ **Chỉ match theo MMR widening** + `CurrentCarCR` (CR widening nhân 3 mỗi 3s đã code), **ping là placeholder** |
| MMR flow | Nakama Go runtime RPC `prototype_update_mmr_result` + leaderboard | ✅ Initial 300, ±30 win/loss/quit/disconnect |
| Edgegap publish | `PrototypeRacing/Build/Edgegap/publish_edgegap_server.sh` | ✅ CLI + Jenkins-friendly, đẩy app version, Docker image, registry |
| UI Widget | `UMultiplayerMatchmakingWidget` + `AMultiplayerClientLobbyUIHost` | ⚠️ Đủ state machine + Retry/Cancel/CR/MMR/PlayerSlots, **chưa có** Intro/Quick/Post-game scene, chưa có car preview, chưa có opponent car display thật |
| AI takeover khi disconnect | `ARaceTrackManager` có `AIManagerSubsystem` | ⚠️ Auto drive đã có ở single-player; **chưa wire** logic takeover khi multiplayer player drop |
| Disconnect/quit policy | Đã ràng buộc ở broker (cleanup grace 600s) + dedicated-server join token | ⚠️ **Chưa có** auto-win khi toàn bộ đối thủ rời trận |
| Lobby / Private Match | Chưa có | ❌ Toàn bộ 4 US Lobby Match chưa đụng |
| Item reward | Nakama storage có sẵn | ❌ Chỉ Cash (theo VNTour progression), chưa có item |
| Win streak / Revenge mark | Chưa có | ❌ Chưa thiết kế lẫn chưa code |
| CI/CD Mobile (iOS + Android) | `Docs/RacingMobile.groovy` | ✅ Đang chạy |
| CI/CD LinuxServer + Edgegap | **Không có** trong `RacingMobile.groovy` | ❌ Cần bổ sung stage mới |
| VibeUE | 4.0 (commit 1b3eb73) — đã xác thực | ✅ Hỗ trợ editor automation khi cần |

### 1.2 Kết luận

> **Stack hiện tại ĐỦ sức đáp ứng** về mặt nền tảng (UE5 + Nakama + Edgegap + Postgres + Docker + Jenkins). Tất cả 16 US đều có khả năng triển khai trên cùng stack này mà **không cần thêm công nghệ mới**, chỉ thiếu:
> 1. **Phần UX/scene** cần GameDesign/Art cung cấp wireframe/asset (Intro/Quick/Post-game/Art cutscene).
> 2. **Code bổ sung** cho Lobby, win streak, revenge, AI takeover, real ping, server-authoritative race result (Step 2).
> 3. **CI/CD stage mới** trong `RacingMobile.groovy` để build LinuxServer + đẩy Edgegap.

---

## 2. Kiến trúc tổng thể Multiplayer (đã triển khai)

### 2.1 Sơ đồ triển khai (deployment architecture)

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                          MOBILE CLIENT (iOS / Android)                       │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │  PrototypeRacing (UE5)                                                │ │
│  │  ┌──────────────────────┐    ┌───────────────────────────────────────┐ │ │
│  │  │ UI / Widget Layer    │    │ BackendSubsystem / Online             │ │ │
│  │  │ - MultiplayerLobby   │◄──►│ - UNakamaServiceSubsystem             │ │ │
│  │  │ - MatchmakingWidget  │    │ - UMatchServiceSubsystem              │ │ │
│  │  │ - WaitingRoom? (TODO)│    │ - UHostedServerHandoffSubsystem       │ │ │
│  │  └──────────────────────┘    └───────────────────────────────────────┘ │ │
│  │           │                                   │                        │ │
│  │           ▼                                   ▼                        │ │
│  │  ┌─────────────────────────────────────────────────────────────────┐  │ │
│  │  │  Plugins/Nakama (UE5 SDK 2.10.1)                                │  │ │
│  │  │  - Auth (Device / Email / Development)                          │  │ │
│  │  │  - Realtime Client (WebSocket)                                  │  │ │
│  │  │  - Matchmaker Add/Remove                                        │  │ │
│  │  │  - Match Join + OpCode Data                                     │  │ │
│  │  │  - RPC (prototype_get_multiplayer_profile,                      │  │ │
│  │  │        prototype_update_mmr_result)                              │  │ │
│  │  └─────────────────────────────────────────────────────────────────┘  │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
└────────────┬──────────────────────────────────────────────────┬─────────────┘
             │ HTTPS (REST/RPC)                                 │ WSS (Realtime)
             ▼                                                  ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│             NAKAMA SERVER (Local Docker / Production-like broker)           │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │  PostgreSQL 16.8-alpine  ─►  Nakama 3.39.0  ─►  Go Runtime Plugin     │ │
│  │  ┌─────────────────────────┐   ┌─────────────────────────────────────┐ │ │
│  │  │ - Storage               │   │ prototype_get_multiplayer_profile  │ │ │
│  │  │   collection=prototype_ │   │   → get/init profile, MMR=300      │ │ │
│  │  │   racing_multiplayer     │   │                                     │ │ │
│  │  │   key=profile            │   │ prototype_update_mmr_result        │ │ │
│  │  │                         │   │   → result: win|loss|quit|disconn │ │ │
│  │  │ - Leaderboard           │   │     delta: ±30                     │ │ │
│  │  │   prototype_racing_mmr  │   │                                     │ │ │
│  │  │   sort=desc             │   │ RegisterMatch(prototype_edgegap_   │ │ │
│  │  │                         │   │   handoff) — authoritative match   │ │ │
│  │  │ - Matchmaker            │   │                                     │ │ │
│  │  │   query + string/       │   │ RegisterMatchmakerMatched(          │ │ │
│  │  │   numeric props         │   │   ...) → create handoff match     │ │ │
│  │  └─────────────────────────┘   └─────────────────────────────────────┘ │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
└────────────┬───────────────────────────────────────────────────────────────┘
             │ REST: POST /v2/deployments, GET /v1/status/<id>, DELETE /v1/stop/<id>
             ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                       EDGEGAP (Dedicated Server Hosting)                    │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │  App: VNRacing                                                       │ │
│  │  Version: vnracing-sontra-20260531-r3 (validated)                     │ │
│  │                                                                        │ │
│  │  ┌──────────────────────────────────────────────────────────────────┐  │ │
│  │  │ Docker container: PrototypeRacingServer                          │  │ │
│  │  │ - Boots into PR_BOOT_MAP = /Game/Maps/Multiplayer_WaitingRoom     │  │ │
│  │  │ - Env injected:                                                   │  │ │
│  │  │     PR_SERVER_JOIN_TOKEN (hidden)                                 │  │ │
│  │  │     PR_EXPECTED_PLAYERS=2                                         │  │ │
│  │  │     PR_TARGET_MAP=/Game/Maps/Map_Test/                            │  │ │
│  │  │                  RacingTest_NightLight_Features?RaceMode=2       │  │ │
│  │  │     PR_BOOT_MAP=/Game/Maps/Multiplayer_WaitingRoom                │  │ │
│  │  │     ARBITRIUM_PORT_GAMEPORT_INTERNAL=7777                         │  │ │
│  │  │     ARBITRIUM_DELETE_URL + ARBITRIUM_DELETE_TOKEN (auto-stop)     │  │ │
│  │  │ - GameMode: AMultiplayerWaitingRoomGameMode                       │  │ │
│  │  │   → Verify ?JoinToken=... in PreLogin                             │  │ │
│  │  │   → ServerTravel to PR_TARGET_MAP when joined=expected            │  │ │
│  │  └──────────────────────────────────────────────────────────────────┘  │ │
│  │                                                                        │ │
│  │  External gameport (UDP) — dynamic per deployment                       │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Chuỗi tương tác (sequence) — happy path đã validated

```text
Client                   Nakama Matchmaker        Nakama Handoff Match        Edgegap           Dedicated Server
  │                              │                          │                    │                       │
  │ AddMatchmaker(MMR,CR,Ping)   │                          │                    │                       │
  ├─────────────────────────────►│                          │                    │                       │
  │                              │ Matchmaker widens        │                    │                       │
  │ ◄═════ MatchmakerMatched ════│                          │                    │                       │
  │ JoinMatch(handoffMatchId)    │                          │                    │                       │
  ├──────────────────────────────┼─────────────────────────►│                    │                       │
  │                              │                          │ All joined         │                       │
  │                              │                          │ allocateEdgegap()  │                       │
  │                              │                          ├───────────────────►│                       │
  │                              │                          │                    │ Deploy container      │
  │                              │                          │ ◄═══ status.Running│                       │
  │                              │                          │                    │ Start game server     │
  │                              │                          │                    ├──────────────────────►│
  │                              │                          │                    │                       │ Boot PR_BOOT_MAP
  │ ◄══ OpCode 1 (host:port+tok) │                          │                    │                       │
  │ ClientTravel(host:port)      │                          │                    │                       │
  ├──────────────────────────────┼──────────────────────────┼────────────────────┼──────────────────────►│
  │                              │                          │                    │ ?JoinToken=<token>    │
  │                              │                          │                    │                       │ Validate join token
  │                              │                          │                    │                       │ Joined=N → ServerTravel
  │                              │                          │                    │                       │ ───► race map (PR_TARGET_MAP)
  │                                                                                                       │
  │ ... race finishes, client submits result ─────►  prototype_update_mmr_result ──► profile.MMR ±30       │
```

### 2.3 Tech stack & artifact versions

| Layer | Phiên bản / path | Trạng thái |
|---|---|---|
| Unreal Engine | 5.x (GUID trong `PrototypeRacing.uproject`) | ✅ Verified |
| Nakama plugin | 2.10.1 (`Plugins/Nakama/`) | ✅ Verified |
| Nakama server | 3.39.0 (Docker image pinned) | ✅ Verified |
| Postgres | 16.8-alpine | ✅ Verified |
| Go plugin builder | `heroiclabs/nakama-pluginbuilder:3.39.0` | ✅ Verified |
| UE5 Linux cross-compile toolchain | v25 (`C:\UnrealToolchains\v25_clang-18.1.0-rockylinux8`) | ✅ Verified |
| `LINUX_MULTIARCH_ROOT` env | Required for LinuxServer builds | ✅ Verified |
| Edgegap validated version | `vnracing-sontra-20260531-r3` | ✅ Live |
| Docker image (local validation) | `prototype-racing-server:local-validation` | ✅ Verified |
| Local archive path | `Saved/Edgegap/Validation/LinuxServer/` | ✅ Verified |
| Windows LinuxServer packaging flag combo | `-serverplatform=Linux`, `-package -pak -iostore -compressed -prereqs` | ✅ Verified |

### 2.4 Authority model (semi-authoritative MVP)

> HLD định nghĩa **semi-authoritative**: client gửi simulation state, dedicated server validate đơn giản và broadcast lại. Code hiện tại chưa có server-side race validation (Step 2).

| Subsystem | Offline | Online MVP (hiện tại) | Online production cần |
|---|---|---|---|
| Auth | n/a | Nakama (device/email/dev) | Nakama production endpoint |
| Realtime session | n/a | Nakama Realtime WS | Nakama Realtime WS |
| Matchmaking | n/a | Nakama matchmaker (decentralized) | Nakama matchmaker |
| Race start/end | Local RaceTrackManager | Local RaceTrackManager | **Dedicated server GameMode** |
| Race ranking/lap | Local RaceTrackManager | Local RaceTrackManager | **Server-authoritative checkpoint** |
| MMR submit | n/a | Client submit (`SubmitMultiplayerResult`) | **Dedicated server gọi RPC sau khi race end** |
| Reward grant | n/a | Server (Nakama) grant qua RPC | Server grant; **anti-cheat** |

---

## 3. Những gì đã triển khai được (đã đối chiếu source/docs)

### 3.1 Step 1 — Quick Match MVP: MMR + Reward ✅ DONE

#### 3.1.1 Profile & MMR persistence

- **Nakama Go runtime** (`PrototypeRacing/Server/Nakama/go-runtime/main.go`):
  - `prototype_get_multiplayer_profile`: trả về profile JSON, MMR mặc định `300`, leaderboard `prototype_racing_mmr`, cờ `localMvpOnly=true`.
  - `prototype_update_mmr_result`: nhận `{ "result": "win|loss|quit|disconnect" }`, áp dụng `±30` MMR, ghi profile (Nakama Storage collection `prototype_racing_multiplayer`), mirror sang leaderboard.
  - Module cũ bằng JavaScript (`modules/index.js`) đã được giữ làm reference nhưng **không còn mount** trong compose (đã chuyển sang Go runtime).
  - Đã validate trong Docker (`docker compose up`), Postgres + Nakama + Go plugin đều healthy.
- **Unreal client** (`UNakamaServiceSubsystem`):
  - `RequestMultiplayerProfile()` gọi RPC, broadcast `MultiplayerProfileReceived(MMR)`.
  - `SubmitMultiplayerResult(Result)` gọi RPC, broadcast `MultiplayerResultUpdated`.
  - Delegates + failure path đều đi qua `MultiplayerProfileError` / error logs.

#### 3.1.2 Matchmaking V6 — widening + timeout

- `UMatchServiceSubsystem` (`Private/BackendSubsystem/Online/MatchServiceSubsystem.cpp`):
  - Query xây dựng từ `BuildMatchMakingQuery`:
    - `+properties.MapId:<id>`
    - `+properties.MapName:<name>`
    - `+properties.RaceMode:<Circuit|...>`
    - `+properties.MatchMakingRanking:>=<mmr-window>` và `<=`
    - `+properties.CurrentCarCR:>...` và `<...` (CR widening)
    - `+properties.PingMs:<=<threshold>`
  - String/numeric properties gắn kèm: `MapName`, `RaceMode`, `PingSource=LocalTestPlaceholder|Measured`, `MapId`, `MatchMakingRanking`, `CurrentCarCR`, `PingMs`, `PingThresholdMs`.
  - Widening qua `OnMatchFindingTimeUpdate()` mỗi giây:
    - `MMR window`: `±500` (0-3s) → `±1000` (3-6s) → `±1500` (6s+).
    - `CR threshold`: `3 + (Elapsed/3)*3` → bắt đầu `<3`, mỗi 3s nới thêm 3.
    - Reissue ticket qua `RemoveMatchmaker` rồi `AddMatchmaker` (gating `bIsWideningMatchmakerTicket`, `bIsSubmittingWidenedMatchmakerTicket`).
  - Timeout 60s: `MatchmakingTimeLimit=60`, broadcast `OnMatchFindingTimeEnd`, cancel.
  - Validation: MMR>0, CR>0, ping threshold>0, ping<=threshold, min≥2, max≥min.
  - Ping hiện đang **placeholder 50ms** (`TryStartCommandLineMatchmaking` default) — đánh dấu `bUseLocalTestPingPlaceholder=true` để log cảnh báo.

#### 3.1.3 Edgegap broker flow

- **Nakama Go runtime** (`main.go`):
  - `RegisterMatchmakerMatched(entries)` → tạo authoritative match (`prototype_edgegap_handoff`) qua `nk.MatchCreate` với `allowedUsers` = danh sách matched user IDs.
  - Handoff match state machine: chỉ chấp nhận user trong `allowedUsers`, đợi `JoinedPresences ≥ ExpectedPlayers`, generate join token (32 byte base64-url), gọi Edgegap `POST /v2/deployments`, poll `GET /v1/status/<id>` cho tới khi `status.Running` (hoặc textual READY) + FQDN + `gameport.external`, broadcast opcode 1 với `{MatchId, PlayerCount, MaxPlayers, DedicatedServerHost, DedicatedServerPort, DedicatedServerConnectionURL, AllocationRequestID, EdgegapDeploymentID, JoinToken}`.
  - Cleanup best-effort qua `DELETE /v1/stop/<id>` khi match kết thúc / lỗi / không client nào rejoin trong `EDGEGAP_HANDOFF_CLEANUP_GRACE_SECONDS=600`.
  - Race map resolution: `raceMapByID` map `MapId → race map`. Hiện chỉ có `MapId 1 → /Game/Maps/Map_Test/RacingTest_NightLight_Features?RaceMode=2`.
  - Default broker version `vnracing-sontra-20260531-r3` (validated).
- **Edgegap publish script** (`Build/Edgegap/publish_edgegap_server.sh`):
  - Load `Server/Nakama/broker-flow.env`, package LinuxServer qua UAT (`-server -serverplatform=Linux -serverconfig=Development -noclient`), build Docker image, login registry, push, gọi Edgegap v1 API `POST/PATCH /v1/app/<name>` và `POST/PATCH /v1/app/<name>/version/<version>`.
  - Generate `StartServer.sh` với join-token masking, SIGTERM forwarding, ARBITRIUM auto-stop.
  - `--register-only`, `--skip-package`, `--dry-run` đều có cho Jenkins flexibility.

#### 3.1.4 Dedicated server + waiting room

- `AMultiplayerWaitingRoomGameMode` (`Private/Multiplayer/MultiplayerWaitingRoomGameMode.cpp`):
  - Đọc `PR_SERVER_JOIN_TOKEN`, `PR_EXPECTED_PLAYERS`, `PR_TARGET_MAP` qua `FPlatformMisc::GetEnvironmentVariable`.
  - `PreLogin` reject client không có/không đúng `?JoinToken=...`.
  - `LogWaitingRoomState()` mỗi `PostLogin`/`Logout`.
  - `TryStartTravelToTargetMap()` khi `joined == expected`, gọi `World->ServerTravel(PR_TARGET_MAP)`.
- Edgegap runtime env (xem `StartServer.sh` và `EdgegapRuntime.defaults.env`) đảm bảo boot map là waiting room, target map được truyền qua env cho waiting room.

#### 3.1.5 Client UI

- `UMultiplayerMatchmakingWidget` — state machine đầy đủ: `Idle → LoadingProfile → Ready → Starting → Searching → Matched → JoiningNakamaMatch → MatchReady → AllocatingServer → ServerReady → Traveling → JoinedServer`, có nhánh `Error` và `TimedOut`. Widget hiển thị MMR, RANK, CR, timer mm:ss, player slots, có Cancel/Retry.
- `AMultiplayerClientLobbyUIHost` — actor spawn widget vào viewport khi load map `Multiplayer_ClientLobby`.
- Realtime-ready race đã fix (internal delegate → state update → broadcast public delegate).

### 3.2 Step 2 — Server-authoritative race ⚠️ PARTIAL (broker có; race validation chưa có)

| Concern | Trạng thái |
|---|---|
| Dedicated server nhận client qua `ClientTravel ?JoinToken=...` | ✅ Verified |
| Server-authoritative race start/end | ❌ Chưa có — vẫn dùng local `RaceTrackManager` |
| Server-authoritative checkpoint/lap/ranking | ❌ Chưa có |
| Server phê duyệt MMR result (thay vì client submit) | ❌ Chưa có — vẫn client submit qua RPC |
| Anti-cheat | ❌ Chưa có |
| Dedicated server → Nakama gọi `prototype_update_mmr_result` | ❌ Chưa có |
| Item reward | ❌ Chưa có |

### 3.3 OpenSpec archive trạng thái DONE

| OpenSpec archive | Trạng thái |
|---|---|
| `2026-05-30-add-local-nakama-multiplayer` | ✅ Archived — local Nakama backend + matchmaking V6 |
| `2026-05-30-migrate-nakama-runtime-to-go` | ✅ Archived — Go runtime thay cho JS |
| `2026-05-31-enable-nakama-edgegap-broker-flow` | ✅ Archived — broker flow + Edgegap publish |

---

## 4. Những gì còn sót lại (chưa triển khai)

### 4.1 Bảng US Quick Match + Lobby Match (từ `Docs/Multiplayer_New.md`)

#### I. QUICK MATCH

| US | Mô tả ngắn | Trạng thái | Mapping implementation |
|:--:|---|:--:|---|
| 1 | Quick match random, có MMR rank; test 4 player online match ngay | 🔶 partial | Matchmaker chạy; 2-player MVP đã validated. Còn thiếu: **match ≥4 player** (Nakama matchmaker có thể, nhưng `PR_EXPECTED_PLAYERS=2` đang hardcode trong broker). Cần làm `PR_EXPECTED_PLAYERS` configurable + test với ≥4 người. |
| 2 | Luồng UX ngắn và thuận tiện | 🔶 partial | Widget state machine đầy đủ + Retry/Cancel/Timer. Cần thiết kế UX thêm cho 4-scene flow (US 3/4/5). |
| 3 | Intro scene show xe + cảm giác nâng cấp | ⛔ not started | `Multiplayer_ClientLobby` map tồn tại nhưng chỉ spawn widget. Chưa có Intro scene với car preview + feel upgrade UX. |
| 4 | Quick scene post-game show thứ hạng + bảng xếp hạng | ⛔ not started | Chưa có Post-game UI riêng (chỉ MMR update broadcast). Cần thiết kế wireframe + build scene mới. |
| 5 | Art cutscene/âm thanh/effect từ match → race | ⛔ not started | Chưa có. Phụ thuộc GameDesign + Art. |
| 6 | Matchmaking theo CR chênh lệch không quá lớn | 🔶 partial | `BuildMatchMakingQuery` đã add `CurrentCarCR > min && < max` với CR threshold widening `3 + (Elapsed/3)*3`. **Chưa có** thêm validation cho 4-player scenario và test kịch bản 10 player theo US (4 player phù hợp range CR + 6 player còn lại phải match theo CR range khác). |
| 7 | Kết nối ổn định, không giật lag | ⛔ not started | **Real ping chưa có**. Đang dùng placeholder 50ms. Cần plugin đo ping (Edgegap region lookup / Nakama RTT ping / Unreal Net PING RPC) + Nakama matchmaker query filter `PingMs <= threshold` thật. |
| 8 | Tiếp tục đua cùng đối thủ ở trận mới (Final Scene + MMR cho phép register continue), giảm số người nếu player thoát | ⛔ not started | Chưa có post-race lobby/vote tiếp tục. Chưa có cơ chế "continue with fewer players". |
| 9 | Challenge người chơi cùng mình | ⛔ not started | (Cùng US Lobby Match 1-4) — chưa có. |
| 10 | Win streak / revenge mark | ⛔ not started | Chưa có schema lưu streak, chưa có logic tăng % match lại, chưa có mark UI. |
| 11 | Tự động thắng khi toàn bộ đối thủ disconnect | ⛔ not started | Chưa có logic detect all-opponents-disconnect trong dedicated server. |
| 12 | AI chạy giúp khi mất kết nối trong khoảng thời gian | ⛔ not started | `AIManagerSubsystem` có sẵn, `ARaceTrackManager` có `AutoDrive`; **chưa wire** logic "khi multiplayer player drop → spawn AI với CR = current car CR của player đó, difficulty=Easy". |

#### II. LOBBY MATCH

| US | Mô tả ngắn | Trạng thái | Mapping implementation |
|:--:|---|:--:|---|
| 1 | Lobby scene show xe đối thủ | ⛔ not started | Cần Lobby map riêng, hiển thị xe mỗi slot, replicated khi client mới vào. |
| 2 | Lobby mời friend | ⛔ not started | Chưa có friends list / invite flow. Cần làm rõ phạm vi (Steam Friend? Apple Game Center? Google Play Games? hay chỉ qua Nakama user ID?). |
| 3 | Lobby có Challenge tương tự Quick Match | ⛔ not started | Chưa có. Khi có Lobby map + friends invite, cần replay matchmaking logic với các player đã chọn. |
| 4 | Lobby cho phép chọn xe trong đó | ⛔ not started | Cần custom Garage UI cho Lobby. |

### 4.2 Tổng hợp theo nhóm implementation

| Nhóm | Hạng mục | Độ khó | Phụ thuộc |
|---|---|:--:|---|
| **Matchmaking nâng cao** | Real ping measurement + filter | Medium | UE Net subsystem / Nakama RTT ping RPC / Edgegap region lookup |
| | Test ≥4-player matchmaking, dynamic `PR_EXPECTED_PLAYERS` | Low-Medium | Docker stack + ≥4 dev accounts |
| | CR test scenario (10 player theo US 6) | Low | Matchmaking query đã đủ |
| **Disconnect / AI** | AI takeover khi player drop (Easy + CR match) | Medium-High | `AIManagerSubsystem` + multiplayer `RaceTrackManager` integration |
| | Auto-win khi all opponents disconnect | Medium | Dedicated server `RaceTrackManager` listen `Logout` |
| | Không cho rejoin session | Low | Đã có (test setup đã chỉ định) — verify bằng cách reject `?JoinToken` cũ |
| **UX/Art** | Intro Scene (US 3) | Medium-High | GameDesign wireframe + Art asset |
| | Post-game Quick Scene + Ranking (US 4) | Medium-High | GameDesign wireframe + Nakama leaderboard read API |
| | Cutscene/âm thanh/effect (US 5) | High | Art team |
| **Lobby / Private** | Lobby map + cars display | High | UE replication + Lobby server model (P2P hay dedicated?) |
| | Friend list + Invite | High | Quyết định nền tảng (Steam/Apple/Google/Nakama) |
| | Lobby Challenge mode | High | Matchmaking flow re-trigger với locked player set |
| | Lobby chọn xe | Medium | Custom Garage UI cho Lobby |
| **Progression & Reward** | Item reward cho win | Medium | Nakama storage + Economy subsystem |
| | Win streak tracking | Medium | Schema mới trong profile JSON + Nakama storage |
| | Revenge mark + boost % match | Medium | Matchmaker filter mới + profile schema |
| **Server-authoritative Step 2** | Race result từ dedicated server (không phải client) | High | UE dedicated server RPC bridge + GameMode authoritative |
| | Checkpoint/lap server-validate | High | Network physics interpolate model |
| | Anti-cheat cơ bản | High | Server validate simulation output |
| **CI/CD** | RacingMobile.groovy thêm stage LinuxServer + Edgegap publish | Medium | Local validation script đã có, cần wrap Jenkins stage |

---

## 5. Cập nhật CI/CD — `Docs/RacingMobile.groovy`

### 5.1 Tình trạng hiện tại của `RacingMobile.groovy`

Pipeline hiện tại (1809 dòng) chỉ build **iOS** + **Android** (song song). Có:

- Perforce checkout (`p4sync` với P4_CREDENTIAL_ID / P4_CREDENTIAL_ID_MAC).
- Build editor (iOS + Android) tuần tự / song song.
- Android: internal artifact → Nexus; Shipping AAB → Google Play (khi `ANDROID_MODE == upload_chplay`).
- iOS: package → xcarchive → TestFlight upload.
- Discord notifications.

**Chưa có stage nào** cho LinuxServer + Edgegap publish + Docker image push.

### 5.2 Phạm vi cập nhật cần làm

> **Mục tiêu**: thêm 1 stage mới `LinuxServer / Edgegap Publish` chạy **song song** với iOS và Android. Stage này dùng `Publish/Edgegap/publish_edgegap_server.sh` đã validate local.

#### 5.2.1 Tham số (parameters) cần bổ sung

```groovy
choice(
    name: 'LINUXSERVER_MODE',
    choices: ['skip', 'package', 'publish'],
    description: 'LinuxServer build mode. Default skip để giữ tương thích ngược.'
)
text(
    name: 'EDGEGAP_VERSION',
    defaultValue: '',
    description: 'Edgegap version tag. Để trống để tự sinh kiểu <app>-<yyyymmdd>-r<rev>.'
)
booleanParam(
    name: 'EDGEGAP_DRY_RUN',
    defaultValue: true,
    description: 'Nếu bật, chỉ validate plan + dry-run publish_edgegap_server.sh, không package/push thật.'
)
```

#### 5.2.2 Environment cần thêm

```groovy
LINUX_MULTIARCH_ROOT = "${env.LINUX_MULTIARCH_ROOT ?: 'C:\\UnrealToolchains\\v25_clang-18.1.0-rockylinux8'}"
EDGEGAP_API_TOKEN = credentials('edgegap-api-token-prototype-racing')
EDGEGAP_CONTAINER_REGISTRY_PROJECT = credentials('edgegap-registry-project')
EDGEGAP_PRIVATE_REGISTRY_USERNAME = credentials('edgegap-registry-username')
EDGEGAP_PRIVATE_REGISTRY_TOKEN = credentials('edgegap-registry-token')
EDGEGAP_CREDENTIAL_ID = 'edgegap_api_token_racing'
EDGEGAP_REGISTRY_CREDENTIAL_ID = 'edgegap_registry_racing'
UE5_LINUX_EXE = "${env.UE5_EXE_LINUX ?: ''}"  // optional override Linux UnrealEditor-Cmd
```

#### 5.2.3 Stage mới (parallel với Mobile Builds)

```groovy
stage('LinuxServer / Edgegap Publish') {
    when {
        expression { return params.LINUXSERVER_MODE != 'skip' }
    }
    agent { label 'linux_builder' }   // agent mới, cần label linux
    environment {
        PROJECT_PATH = "${WORKSPACE}/${PROJECT_NAME}/${PROJECT_NAME}.uproject"
        EDGEGAP_BROKER_ENV_FILE = "${WORKSPACE}/${PROJECT_NAME}/Server/Nakama/broker-flow.env"
    }
    stages {
        stage('LinuxServer: Validate Prerequisites') {
            steps {
                script {
                    sh '''
                        set -eu
                        [ -n "${LINUX_MULTIARCH_ROOT:-}" ] || { echo "LINUX_MULTIARCH_ROOT is required"; exit 1; }
                        [ -d "${LINUX_MULTIARCH_ROOT}" ] || { echo "LINUX_MULTIARCH_ROOT path not found"; exit 1; }
                        [ -f "${EDGEGAP_BROKER_ENV_FILE}" ] || { echo "broker-flow.env missing"; exit 1; }
                        command -v docker >/dev/null 2>&1 || { echo "docker is required"; exit 1; }
                        command -v curl >/dev/null 2>&1 || { echo "curl is required"; exit 1; }
                    '''
                }
            }
        }
        stage('LinuxServer: Resolve Edgegap Version') {
            steps {
                script {
                    def resolvedVersion = params.EDGEGAP_VERSION?.trim()
                    if (!resolvedVersion) {
                        // Auto-generate vnracing-<yyyymmdd>-r<P4 changelist>
                        def dateTag = new Date().format('yyyyMMdd')
                        resolvedVersion = "vnracing-${dateTag}-r${P4_CHANGELIST}"
                    }
                    env.EDGEGAP_RESOLVED_VERSION = resolvedVersion
                    echo "Edgegap version: ${env.EDGEGAP_RESOLVED_VERSION}"
                }
            }
        }
        stage('LinuxServer: Publish') {
            steps {
                script {
                    def scriptPath = "${WORKSPACE}/${PROJECT_NAME}/Build/Edgegap/publish_edgegap_server.sh"
                    def dryRunFlag = params.EDGEGAP_DRY_RUN ? '--dry-run' : ''
                    def modeArgs = params.LINUXSERVER_MODE == 'package'
                        ? '--skip-package'
                        : (params.LINUXSERVER_MODE == 'publish' ? '--skip-package' : '')

                    sh """
                        set -eu
                        export LINUX_MULTIARCH_ROOT='${LINUX_MULTIARCH_ROOT}'
                        export UE5_RUNUAT="\${LINUX_MULTIARCH_ROOT}/Engine/Build/BatchFiles/RunUAT.sh"
                        export UE5_EXE="\${LINUX_MULTIARCH_ROOT}/Engine/Binaries/Linux/UnrealEditor-Cmd"
                        bash '${scriptPath}' \\
                            --version '${env.EDGEGAP_RESOLVED_VERSION}' \\
                            --project '${PROJECT_PATH}' \\
                            --stage-dir '${WORKSPACE}/Saved/Edgegap/LinuxServer' \\
                            --env-file '${EDGEGAP_BROKER_ENV_FILE}' \\
                            ${dryRunFlag} \\
                            ${modeArgs}
                    """
                }
            }
        }
        stage('LinuxServer: Notify') {
            steps {
                script {
                    def platformResults = [
                        linuxServer: [
                            version: env.EDGEGAP_RESOLVED_VERSION,
                            edgegapApp: 'VNRacing',
                            publishMode: params.LINUXSERVER_MODE,
                            dryRun: params.EDGEGAP_DRY_RUN
                        ]
                    ]
                    sendBuildSuccessNotification(platformResults)
                }
            }
        }
    }
    post {
        always {
            script {
                sh 'docker system prune -f --filter "until=24h" || true'
            }
        }
    }
}
```

#### 5.2.4 Helper function mới cần thêm

```groovy
def buildDisplayVersion(String marketingVersion, String changelistNumber, String streamName) {
    return "${marketingVersion}+cl${changelistNumber}.${normalizeStreamForVersion(streamName)}"
}

def resolveLinuxServerMode() {
    return params.LINUXSERVER_MODE?.trim() ?: 'skip'
}

def validateLinuxServerPrerequisites() {
    sh '''
        set -eu
        [ -n "${LINUX_MULTIARCH_ROOT:-}" ] || { echo "LINUX_MULTIARCH_ROOT unset"; exit 1; }
        [ -d "${LINUX_MULTIARCH_ROOT}" ] || { echo "LINUX_MULTIARCH_ROOT dir missing"; exit 1; }
        command -v docker >/dev/null || { echo "docker not installed"; exit 1; }
    '''
}
```

#### 5.2.5 Update `sendBuildSuccessNotification` để hiển thị LinuxServer

```groovy
// Trong post.success (hoặc method sendBuildSuccessNotification)
def platformInfo = []
// ... Android info (giữ nguyên) ...
// ... iOS info (giữ nguyên) ...
if (platformResults.linuxServer) {
    platformInfo.add("""
**🐧 LinuxServer**
- Edgegap Version: `${platformResults.linuxServer.version}`
- Edgegap App: `${platformResults.linuxServer.edgegapApp}`
- Mode: `${platformResults.linuxServer.publishMode}`
- Dry Run: `${platformResults.linuxServer.dryRun ? 'yes' : 'no'}`
    """.trim())
}
```

#### 5.2.6 Post-build cập nhật `resolveBuildMetadata`

```groovy
def resolveBuildMetadata() {
    // ... existing ...
    return [
        // ... existing fields ...
        linuxServerMode: params.LINUXSERVER_MODE ?: 'skip',
        linuxServerVersion: env.EDGEGAP_RESOLVED_VERSION ?: 'N/A'
    ]
}
```

### 5.3 Checklist CI/CD

- [ ] Thêm Jenkins credential: `edgegap-api-token-prototype-racing`, `edgegap-registry-project`, `edgegap-registry-username`, `edgegap-registry-token`.
- [ ] Tạo agent label `linux_builder` (Linux host có UE5 toolchain, Docker, network tới Edgegap registry).
- [ ] Mount/bind mount `Server/Nakama/broker-flow.env` từ secret store (KHÔNG commit file này — đã ghi rõ trong `LOCAL_DEVELOPMENT.md`).
- [ ] Test `--dry-run` trước (không push image).
- [ ] Test `--skip-package` khi đã có LinuxServer archived sẵn.
- [ ] Test full publish lên staging app trước khi áp production Edgegap app `VNRacing`.
- [ ] Verify LinuxServer boot vào `Multiplayer_WaitingRoom` thật (bằng 2-client smoke).
- [ ] Verify Nakama runtime đọc được `EDGEGAP_APP_VERSION` mới (qua `docker-compose` env hoặc Kubernetes secret).

---

## 6. Lộ trình triển khai đề xuất (Roadmap)

### 6.1 Phase 0 — CI/CD LinuxServer build (1 sprint)

> Mục tiêu: production-ready pipeline build + publish Edgegap version. Sau phase này, mỗi build có thể đẩy 1 Edgegap app version immutable.

- Implement stage LinuxServer như mục 5.
- Auto-generate Edgegap version theo `<app>-<yyyymmdd>-r<P4_CL>`.
- Validate với `--dry-run` 1 lần, sau đó 1 lần publish thật với staging Edgegap app.
- Cập nhật Nakama runtime env (`EDGEGAP_APP_VERSION`) trong compose/k8s secret để broker dùng version mới.

### 6.2 Phase 1 — Server-authoritative race validation (2-3 sprints)

> Mục tiêu: thay thế client-submit MMR bằng dedicated-server-submit MMR. Ngăn chặn gian lận cơ bản.

- Dedicated server `RaceTrackManager` nhận `Login/Logout` + kết quả cuối race từ mỗi client.
- Sau khi race kết thúc, dedicated server gọi Nakama RPC `prototype_update_mmr_result` (thông qua internal admin token hoặc service account mới).
- Client không còn được submit trực tiếp; RPC vẫn tồn tại cho local MVP test.
- Validate race result: vị trí cuối, thời gian, lap count phải khớp giữa các client.

### 6.3 Phase 2 — UX Scenes (1-2 sprints, phụ thuộc Art)

> Mục tiêu: hoàn thiện US 3/4/5.

- GameDesign wireframe Intro/Quick/Post-game scene.
- Art asset: car preview, cutscene, sound, VFX.
- Build scenes mới (Blueprint hoặc C++ widget).
- Hook vào matchmaker state machine (e.g. sau `Matched` → Intro scene → bấm Ready → race).

### 6.4 Phase 3 — Lobby/Private Match (3-4 sprints)

> Mục tiêu: hoàn thiện 4 US Lobby Match + Challenge tương tự Quick Match.

- Quyết định nền tảng friends list (Steam Friend / Apple Game Center / Google Play Games / custom Nakama storage).
- Lobby map + UI replication.
- Invite flow (deep link / platform invite + invite code).
- Challenge mode: cho phép host chọn map/mode, lock player set, replay matchmaking với player set cố định.

### 6.5 Phase 4 — Disconnect / AI takeover / Auto-win (1-2 sprints)

> Mục tiêu: US 11, US 12.

- Dedicated server detect `Logout` của 1 player; sau N giây không reconnect → spawn AI Easy với CR match.
- Khi tất cả opponents disconnect → race end với auto-win cho player còn lại.
- Verify: không cho reconnect (đã có sẵn qua join token, chỉ cần policy rõ).

### 6.6 Phase 5 — Progression nâng cao (1-2 sprints)

> Mục tiểu: Win streak / Revenge / Item reward.

- Profile schema mới: `WinStreak`, `RevengeCandidates`, `LastBeatenBy`.
- Matchmaker filter mới: ưu tiên revenge candidate hoặc tránh cùng streak.
- Item reward: thêm bảng reward theo placement, áp dụng qua `UInventoryManager` + Nakama storage.

### 6.7 Phase 6 — Real ping + matchmaking nâng cao (1 sprint)

> Mục tiêu: US 7, US 6 hoàn chỉnh.

- Plugin ping measurement (Edgegap region lookup qua `https://api.edgegap.com/v1/regions` + Nakama realtime ping RPC).
- Matchmaking query dùng ping thật thay placeholder.
- Test scenario 10 player theo US 6.

### 6.8 Phase 7 — Post-race continue + Lobby vote (1 sprint)

> Mục tiêu: US 8.

- Sau race end, hiển thị vote UI (Vote on Pool Map / Random / Replay / Exit).
- Nếu vote thắng "Continue with current opponents" → ServerTravel về WaitingRoom + giảm `PR_EXPECTED_PLAYERS` nếu có player drop.

---

## 7. Rủi ro & giảm thiểu

| Rủi ro | Ảnh hưởng | Giảm thiểu |
|---|---|---|
| Edgegap API rate limit khi match nhiều | Deploy chậm, fail | Dùng Nakama matchmaker pooling + Edgegap caching `force_cache=true` |
| Join token leak | Player join trận không mong muốn | Token 32 byte random, single-use, có TTL grace 600s |
| Race result gian lận | MMR sai, anti-fair | Phase 1 server-authoritative bắt buộc |
| Multiplayer scene asset chưa sẵn | Block US 3/4/5 | Phối hợp sớm với Art team |
| Real ping measurement sai (VPN/proxy) | Match kém | Kết hợp Edgegap region + Nakama RTT + fallback |
| CI/CD LinuxServer chậm | Tăng thời gian build | Cache Docker layer + dùng `EDGEGAP_FORCE_CACHE=true` |
| Edgegap app version cũ chưa được cleanup | Tốn storage | Đặt retention policy 30 ngày cho app version cũ |
| Nakama Go runtime plugin bị rebuild mỗi lần | Image build chậm | Cache Docker build stage plugin builder |

---

## 8. File inventory — đã đối chiếu qua codebase-retrieval

### 8.1 Backend / Nakama

- `PrototypeRacing/Server/Nakama/docker-compose.yml` — pinned Nakama 3.39.0 + Postgres 16.8-alpine, env wiring cho broker.
- `PrototypeRacing/Server/Nakama/Dockerfile` — Go plugin build pipeline.
- `PrototypeRacing/Server/Nakama/config/local.yml` — runtime config + non-secret placeholders.
- `PrototypeRacing/Server/Nakama/go-runtime/main.go` — RPCs + Edgegap broker + matchmaker matched hook.
- `PrototypeRacing/Server/Nakama/modules/index.js` — JS reference (đã superseded bởi Go runtime).
- `PrototypeRacing/Server/Nakama/LOCAL_DEVELOPMENT.md` — local dev guide.
- `PrototypeRacing/Server/Nakama/broker-flow.env` (gitignored) — local Edgegap credentials.
- `PrototypeRacing/Server/Nakama/broker-flow.env.sample` — template.

### 8.2 Unreal — Online subsystems

- `PrototypeRacing/Source/PrototypeRacing/Public/BackendSubsystem/Online/NakamaServiceSubsystem.h`
- `PrototypeRacing/Source/PrototypeRacing/Private/BackendSubsystem/Online/NakamaServiceSubsystem.cpp` — auth, realtime, profile RPC, submit MMR.
- `PrototypeRacing/Source/PrototypeRacing/Public/BackendSubsystem/Online/MatchServiceSubsystem.h`
- `PrototypeRacing/Source/PrototypeRacing/Private/BackendSubsystem/Online/MatchServiceSubsystem.cpp` — matchmaking query + widening + cancel/timeout.
- `PrototypeRacing/Source/PrototypeRacing/Public/BackendSubsystem/Online/NakamaServiceSettings.h`
- `PrototypeRacing/Source/PrototypeRacing/Public/BackendSubsystem/Online/BackendContractTypes.h`

### 8.3 Unreal — Multiplayer dedicated server

- `PrototypeRacing/Source/PrototypeRacing/Public/Multiplayer/MultiplayerWaitingRoomGameMode.h`
- `PrototypeRacing/Source/PrototypeRacing/Private/Multiplayer/MultiplayerWaitingRoomGameMode.cpp` — PreLogin join-token, expected players, ServerTravel.

### 8.4 Unreal — Multiplayer UI

- `PrototypeRacing/Source/PrototypeRacing/Public/UI/Multiplayer/MultiplayerMatchmakingWidget.h`
- `PrototypeRacing/Source/PrototypeRacing/Private/UI/Multiplayer/MultiplayerMatchmakingWidget.cpp` — state machine + UI text + retry.
- `PrototypeRacing/Source/PrototypeRacing/Public/UI/Multiplayer/MultiplayerClientLobbyUIHost.h`
- `PrototypeRacing/Source/PrototypeRacing/Private/UI/Multiplayer/MultiplayerClientLobbyUIHost.cpp` — spawn widget.

### 8.5 Unreal — Maps + Config

- `PrototypeRacing/Content/Maps/Multiplayer_ClientLobby.umap` — client lobby.
- `PrototypeRacing/Content/Maps/Multiplayer_WaitingRoom.umap` — dedicated server boot map.
- `PrototypeRacing/Content/Maps/Map_Test/RacingTest_NightLight_Features.umap` — race map.
- `PrototypeRacing/Config/DefaultGame.ini` — cooked server/client maps config.

### 8.6 Edgegap publish

- `PrototypeRacing/Build/Edgegap/publish_edgegap_server.sh` — CLI + Jenkins publish.
- `PrototypeRacing/Build/Edgegap/p4_checkout_broker_flow.sh` — minimal P4 helper.
- `PrototypeRacing/Build/Edgegap/validate_broker_flow.sh` — local validation.

### 8.7 Docs

- `Docs/VNRacing_HLD.md` — HLD (mục 7-8 liên quan backend + multiplayer).
- `Docs/VNRacing_LLD.md` — LLD (mục 11 — `UNakamaServiceSubsystem`, `UMatchServiceSubsystem`).
- `Docs/Multiplayer_V6_AI_Readable.md` + `.json` — thiết kế gốc Multiplayer V6.
- `Docs/Multiplayer_Edgegap_Runbook_Validated.md` — runbook đã validated.
- `Docs/Multiplayer_New.md` — yêu cầu nghiệp vụ mới (12 US Quick + 4 US Lobby).
- `Docs/VibeUE_Guide.md` — workflow VibeUE MCP.
- `Docs/RacingMobile.groovy` — Jenkins CI/CD pipeline.

### 8.8 OpenSpec archive

- `openspec/changes/archive/2026-05-30-add-local-nakama-multiplayer/` — proposal + design + tasks (đã done).
- `openspec/changes/archive/2026-05-30-migrate-nakama-runtime-to-go/` — JS → Go migration.
- `openspec/changes/archive/2026-05-31-enable-nakama-edgegap-broker-flow/` — broker + Edgegap publish.
- `openspec/specs/nakama-client-connection/spec.md` — spec maintained.

---

## 9. Câu hỏi cần user quyết định trước khi bắt đầu Phase tiếp theo

> Trước khi code tiếp, cần user confirm các quyết định sau. Mỗi câu kèm option đề xuất ★ (recommended).

### 9.1 Phạm vi Phase tiếp theo

A. **★ CI/CD LinuxServer build** (Phase 0) — thêm stage mới vào `RacingMobile.groovy`, validate Edgegap publish tự động. Nền tảng cho mọi phase sau.
B. **Server-authoritative race** (Phase 1) — chuyển MMR submit từ client sang dedicated server. Ngăn gian lận.
C. **UX Scenes (US 3/4/5)** — phụ thuộc GameDesign + Art wireframe.

### 9.2 Nền tảng Friend List cho Lobby Match (US Lobby 2)

A. **★ Custom Nakama friends** — tự build bằng Nakama storage, độc lập platform. Tốn effort nhưng chạy được cả iOS + Android.
B. Apple Game Center (iOS) + Google Play Games (Android) — phụ thuộc platform, không cross-platform.
C. Steam Friends — chỉ phù hợp khi có Steam release.
D. Khác (user chỉ định).

### 9.3 Real ping measurement (US 7)

A. **★ Edgegap region lookup + Nakama realtime ping** — trung bình ~80-120ms, chính xác vừa đủ.
B. UE Net PING RPC — cần dedicated server đáp, tăng network overhead.
C. Kết hợp cả 2 — chính xác nhất, tốn effort.

### 9.4 Server-authoritative Step 2 priority

A. **★ Triển khai ngay Phase 1** (sau CI/CD) — quan trọng cho production fairness.
B. Triển khai sau khi Lobby xong — ưu tiên UX trước.
C. Deferred — vẫn dùng client-submit trong production.

### 9.5 Edgegap app version policy

A. **★ Auto-version mỗi build** (`<app>-<yyyymmdd>-r<P4_CL>`) — đơn giản, mỗi build immutable.
B. Manual version + tag theo release — phải người nhập.
C. Reuse version hiện tại — không khuyến nghị.

---

## 10. Phụ lục

### 10.1 Glossary

| Thuật ngữ | Định nghĩa |
|---|---|
| MMR | MatchMaking Rating — chỉ số rank của player, ban đầu 300, ±30/trận |
| CR | Car Rating — chỉ số sức mạnh xe hiện tại (tính từ upgrade) |
| Handoff match | Authoritative match trung gian giữa matchmaker và dedicated server; broadcast opcode 1 với connection info |
| Broker | Nakama Go runtime plugin thực hiện Edgegap allocate + broadcast |
| Join token | 32-byte random base64-url, single-use, dùng để chứng minh client là matched player |
| Waiting Room | Dedicated server map boot đầu tiên, đợi đủ số player rồi ServerTravel |
| Ping placeholder | Giá trị ping giả định (50ms) — chỉ dùng cho local MVP test |
| Server-authoritative | Dedicated server quyết định race outcome, client chỉ gửi state |

### 10.2 Tham chiếu edge

- Multiplayer_New.md US Quick #6: "có 10 player tham gia thì có 4 player phù hợp range gần nhau thì phải match được đúng 4 player này" → matchmaker query hiện đang dùng `MatchMakingRanking` (MMR) range; cần test với `CurrentCarCR` range nữa.
- Multiplayer_V6: MMR ban đầu 300, ±30 cho mỗi win/loss/quit/disconnect — đã đúng trong Go runtime.
- Edgegap validated version: `vnracing-sontra-20260531-r3`.
- Default race map: `/Game/Maps/Map_Test/RacingTest_NightLight_Features?RaceMode=2` (MapId=1).

### 10.3 Công cụ đã dùng để biên soạn tài liệu

- `mcp__codebase-retrieval__codebase-retrieval` (port 6699) — semantic search workspace.
- `mcp__repo-vnracing__codebase-retrieval` — semantic search P4V main (reference only).
- `mcp__codebase-retrieval__file-retrieval` (×4) — focused snippets cho UE source.
- `Bash` (ls) — liệt kê file.
- `Read` — đọc docs + UE source + Docker + Jenkins pipeline.

> Tài liệu này chỉ là bản tổng hợp trạng thái, **không chứa code hay spec**. Khi user duyệt Phase nào, sẽ tạo OpenSpec change riêng (`/osf proposal`) cho Phase đó trước khi `/osf apply` implement.
