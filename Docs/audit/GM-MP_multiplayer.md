# GM-MP — MULTIPLAYER

## Phạm vi
Client Nakama auth/session/realtime + match orchestration + waiting-room game mode. Gộp F11 (Backend/Nakama) và F12 (Multiplayer Race).

## Module/class C++ liên quan (file thật)
- `Source/PrototypeRacing/Private/BackendSubsystem/Online/NakamaServiceSubsystem.cpp` — `UNakamaServiceSubsystem`: vòng đời client/session/realtime, auth.
  - Dòng 8: `#include "MatchServiceSubsystem.h"` (coupling 2 chiều).
  - Dòng 90: gọi `MatchServiceSubsystem->SetupMatchEventRealtime()`.
  - Dòng 157: `InitializeDependency<UMatchServiceSubsystem>()`.
  - Dòng 162: cache con trỏ `MatchServiceSubsystem`.
- `Source/PrototypeRacing/Private/BackendSubsystem/Online/MatchServiceSubsystem.cpp` — `UMatchServiceSubsystem`: matchmaking ticket/query, xử lý sự kiện matched/presence, parse JSON payload; giữ ref ngược về Nakama.
- `Source/PrototypeRacing/Private/BackendSubsystem/Online/NakamaNetworkSubsystem.cpp` — `UNakamaNetworkSubsystem`: plumbing network Nakama.
- `BackendContractTypes.cpp` — struct request/response dùng chung.
- `Source/PrototypeRacing/Private/Multiplayer/MultiplayerWaitingRoomGameMode.cpp` — `AMultiplayerWaitingRoomGameMode` (324 dòng): validate join token, travel vào waiting room.

## Blueprint liên quan
- WBP login/matchmaking (`/Game/UI`) — theo delegate, không tick gameplay.
- BP phòng chờ multiplayer + WBP waiting room (`/Game`) — theo state, không tick nặng.

## Điểm nóng hiệu năng cụ thể
Không có per-frame hotspot ở tầng client gateway và waiting-room. Chi phí chính là I/O mạng async (SDK Nakama). Tuy nhiên:
- **`NetUpdateFrequency=100` Hz mỗi xe** (`SimulatePhysicsCar.cpp:82-87`) — rất cao cho mobile multiplayer; với N xe PvP sẽ tiêu tốn băng thông lớn. Hiện đua chủ yếu offline-vs-AI nên chưa lộ.

## Nợ kỹ thuật cụ thể
1. **Coupling 2 chiều Nakama ↔ Match** — `NakamaServiceSubsystem.cpp:8,90,157,162`: hai subsystem ôm con trỏ lẫn nhau → khó test cô lập, dễ vòng lặp khởi tạo.
2. **Race flow server-authoritative CHƯA implement** — `AMultiplayerWaitingRoomGameMode` chỉ lo phòng chờ + join token. Logic đua server-authoritative (server clamp/relay, anti-cheat, kết quả có thẩm quyền) chưa có. Client tự sim (`ASimulatePhysicsCar` replicate `NetUpdateFrequency=100`, `SimulatePhysicsCar.cpp:82-87`). Rủi ro gian lận/desync khi bật PvP thật. Đây là gap lớn nhất của Game Mode.
3. **Parse JSON payload thủ công trong MatchService** — cần kiểm tra xử lý lỗi khi payload sai định dạng.
4. **Cache con trỏ subsystem qua `GetSubsystem`** (`NakamaServiceSubsystem.cpp:161-162`) — cần null-check trước mỗi lần dùng nếu thứ tự init chưa đảm bảo.

## Audit Blueprint
- Không có BP gameplay-tick ở tầng Nakama/Match.
- WBP phòng chờ multiplayer: cần kiểm tra thủ công trong editor nếu sau này bật PvP thật.

## Mức ưu tiên: **P2** (hiện tại) / **P0 khi bật PvP thật**
Lý do: chưa phải đường chạy chính (game thiên về đua AI offline). Khi bật multiplayer thật thì thiếu server-authority + `NetUpdateFrequency=100 Hz/xe` sẽ thành vấn đề lớn. Coupling 2 chiều là nợ kiến trúc cần dọn để dễ bảo trì/test.
