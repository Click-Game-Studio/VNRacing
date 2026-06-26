---
title: "GM-MP — MULTIPLAYER"
description: "Thiết kế chi tiết: client Nakama, matchmaking, waiting room và ranh giới race online mục tiêu."
---

> Nguồn: `Docs/audit/GM-MP_multiplayer.md`, `Docs/c4/model.c4`. View Structurizr: `GM_MP_Components`.
> OpenProject: #273.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `gmMp`).

## Tổng quan

GM-MP hợp nhất F11 (Backend/Nakama) và F12 (Multiplayer Race) thành một feature. GM-MP lo các service auth/session/realtime/match phía client của Nakama, các kiểu contract backend dùng chung và game mode waiting-room để xác thực join-token rồi travel vào level đua online.

⚠️ **Trạng thái: partial.** Waiting-room và xác thực join-token đã hiện thực. **Race flow server-authoritative CHƯA implement** — đây là gap lớn nhất của Game Mode epic.

## Phạm vi

GM-MP là lớp giao tiếp phía client kết hợp với waiting-room shell. GM-MP không vận hành server economy, không thực thi race server-authoritative.

## Thành phần

| Component | Nguồn | Vai trò |
|---|---|---|
| `UNakamaServiceSubsystem` | `NakamaServiceSubsystem.cpp:8,90,157-162` | Vòng đời client/session/realtime và auth; giữ tham chiếu ngược về match-service. |
| `UMatchServiceSubsystem` | `MatchServiceSubsystem.cpp` | Query/ticket matchmaking, xử lý sự kiện matched/presence và parse JSON payload. |
| `UNakamaNetworkSubsystem` | `NakamaNetworkSubsystem.cpp` | Tầng network plumbing của Nakama. |
| `BackendContractTypes` | header contract | Các struct request/response backend dùng chung. |
| `AMultiplayerWaitingRoomGameMode` | `MultiplayerWaitingRoomGameMode.cpp` (324 dòng) | Xác thực join-token và travel vào waiting room. |

## Luồng xử lý

Thiết lập auth/session đi qua `UNakamaServiceSubsystem`. `UMatchServiceSubsystem` dùng state realtime/session để phát ticket matchmaking và xử lý presence/matched. Matchmaking hoàn tất → cung cấp join token. `AMultiplayerWaitingRoomGameMode` xác thực token và travel client vào level multiplayer.

## Điểm nóng hiệu năng

Không có per-frame hotspot ở tầng gateway. Coupling 2 chiều giữa `UNakamaServiceSubsystem` và `UMatchServiceSubsystem` (`NakamaServiceSubsystem.cpp:8,90,157,162`) khiến test cô lập khó và tăng rủi ro vòng lặp init. `NetUpdateFrequency=100 Hz/xe` (`SimulatePhysicsCar.cpp:82-87`) chưa gây vấn đề khi đua AI offline nhưng sẽ tiêu tốn băng thông lớn khi bật PvP thật.

## Gap — Race server-authoritative

Server-side race authority (server clamp/relay, anti-cheat, kết quả có thẩm quyền) **chưa có**. Hiện client tự sim. Đây là gap P0 khi bật PvP.

## API công khai

Entry point đã xác minh: vòng đời auth/session/realtime (`UNakamaServiceSubsystem`), ticket/query matchmaking và sự kiện presence/matched (`UMatchServiceSubsystem`), contract types backend, xác thực/travel join-token (`AMultiplayerWaitingRoomGameMode`).

## Phần chưa kiểm chứng

Xác thực physics/kết quả đua có thẩm quyền, giao thức snapshot dedicated server và thẩm quyền anti-cheat đòi hỏi rà soát trong editor/nguồn vượt ngoài bằng chứng hiện có.

## Tham chiếu

- Audit: `Docs/audit/GM-MP_multiplayer.md`
- LD: `Docs/ld/GM-MP_multiplayer.md`
- Structurizr: `GM_MP_Components`
- Gộp từ: `audit/F11_backend_nakama.md` + `audit/F12_multiplayer.md`
