# **So sánh các phương án multiplayer** 

# **cho project Racing**

Tài liệu này mô tả tổng quan kiến trúc, luồng hoạt động, và các thành phần chính của một hệ thống game online nhiều người chơi kiểu Racing. Giả định backend dùng **Nakama** và client/game server phát triển bằng **Unreal Engine**. Mục tiêu: cung cấp kiến trúc cơ bảnđể thiết kế hệ thống từ đăng nhập — tìm trận — chạy trận — kết thúc trận và tính MMR (Matchmaking Rating).

# **1\. Thành phần hệ thống:**

* **Client (Unreal Engine)**: giao diện người chơi, logic UI, sử dụng backend service với *Nakama*, kết nối tới game server xử lý predict/interpolation/lag compensation.  
* **Nakama server cluster**: authentication, matchmaker, storage (player profile, inventory), leaderboard, RPC, custom modules (Lua/Go) để xử lý logic server-side.  
* **Matchmaker service**: dùng matchmaker tích hợp sẵn của *Nakama* kết hợp logic custom.  
* **Game Servers (Unreal Dedicated Servers)**: chạy trạng thái trận đấu, tick simulation, authoritative state.  
* **Database / Persistent Storage**: PostgreSQL (Nakama) / log storage.  
* **Load balancer / Proxy**: đưa client tới game server instance phù hợp, sử dụng hệ thống tích hợp sẵn của *Edgegap*.  
* **Auth providers**: email/password, device ID, OAuth (Steam, Google, Apple), token exchange, liên lạc với *Nakama*.  
* **Monitoring, Observability, Analytics pipeline**: GameAnalytics.

# **2\. Luồng chính (High-level flow):**

1. Client khởi chạy → user chọn phương thức đăng nhập.  
2. Client gọi *Nakama* Auth RPC → nhận session token.  
3. Client gửi presence/online, yêu cầu tìm trận → player vào queue matchmaker.  
4. Matchmaker ghép đội → tạo match, chọn game server hoặc request một dedicated server.  
5. Match created → lobby (pre-match) để chỉnh sửa xe/ vào trạng thái ready.  
6. Khi ready → match game server bắt đầu, clients connect tới game server.  
7. Trận đấu chạy → game server authoritative.  
8. Khi kết thúc → game server ghi kết quả, replay, thông báo *Nakama* để cập nhật profile, leaderboard, MMR.  
9. *Nakama* cập nhật MMR & leaderboard, gửi notification cho client.  
10. Player xem xong thông báo, có thể quay lại bước 3 hoặc thoát game.

# **3\. Chi tiết từng bước:**

### **3.1 Đăng nhập & xác thực:**

**Phương thức**: Email/password, Device ID, Steam OAuth, Apple/Google.

**Flow mẫu (email)**:

* Client \-\> Nakama: `authenticate_email(email, password)` (RPC / HTTP)  
* Nakama: verify \-\> tạo `session token` JWT với expiry (ví dụ 1h) \-\> trả về client  
* Client lưu token (secure storage) và dùng token cho các kết nối realtime/RPC tiếp theo.

**Lưu ý**:

* Hỗ trợ refresh token hoặc silent reauth bằng device id.  
* Xác thực 2FA (nếu cần) thông qua external provider.  
* Đặt rate limits, IP throttling.

### **3.2 Quản lý session và token**

* Nakama cung cấp session JWT. Client gửi token khi open WebSocket/Realtime.  
* Session expiration \-\> client reauthenticate hoặc refresh.  
* Server-side: có store mapping `session_id -> player_id` để track presence.

### **3.3 Matchmaking**

**Quy trình**:

1. Client tạo room, gửi yêu cầu tìm trận kèm metadata: region, ping, MMR, game mode, password (private room).  
2. Matchmaker duy trì queues và pools phân theo region/mode.  
3. Khi đủ điều kiện (ví dụ 6 người cho standard match, khi chủ phòng yêu cầu bắt đầu) hoặc timeout, matchmaker gọi create\_match.  
4. Match creation chọn game server (existing warm server hoặc spin up new dedicated instance).

**Chiến lược ghép trận**:

* Strict MMR buckets / skill-based Elo/TrueSkill / custom room.  
* Điều chỉnh bằng queuing time (mở rộng range khi chờ lâu).  
* Pre-check ping & NAT type để giảm lag.

Sử dụng `Matchmaker` API của Nakama.

### **3.4 Lobby / Pre-match**

* Sau match created, clients tham gia a lobby, lobby tồn tại thời gian ngắn (30s) để chờ cho tới khi tất cả player đồng ý tham gia.  
* Khi tất cả player đều đồng ý tham gia, hoặc có player từ chối tham gia, lobby sẽ bị tiêu hủy. Nếu mọi player đều đồng ý tham gia, Nakama sẽ ghi nhận thông tin về khởi động một dedicated game server.  
* Nếu dùng Nakama Realtime: một `channel` lobby có thể handle presence & events.

### **3.5 Kết nối tới Game Server (Unreal dedicated server)**

**Quy trình**:

1. Matchmaker trả về address của Dedicated Server \+ token tạm (connect token) cho các client.  
2. Client kết nối direct tới game server (UDP/TCP) với token xác thực.  
3. Game server validate token (qua Nakama RPC hoặc shared secret).  
4. Nếu valid \-\> server thêm player vào game server.

**Networking**:

* Control channel (reliable): TCP/QUIC cho lobby/messages.  
* Gameplay (updates): UDP/QUIC với snapshot/interpolation.  
* Sử dụng client-side prediction/ server reconciliation, etc.

### **3.6 Trong trận: đồng bộ, mạng, và quản lý trạng thái**

**Design patterns**:

* Authoritative server: tất cả quyết định gameplay quan trọng chạy trên dedicated server.  
* Snapshot-based updates: server gửi snapshots period (30–60 TPS).  
* Inputs replication: client gửi chỉ input/commands (không gửi vị trí tuyệt đối).  
* State reconciliation và anti-cheat checks server-side.

**Tick / snapshot cadence**: Ví dụ server tick 20–60 Hz, snapshot rate tối ưu theo độ trễ & băng thông.

**Handling disconnects**:

* Short loss \-\> bấm giờ reconnection window kèm ghost player logic.  
* Long disconnect \-\> AI chiếm quyền điều khiến tạm hoặc forfeit logic.

### **3.7 Kết thúc trận, ghi log & replay**

**Khi trận kết thúc**:

* Game server tổng hợp kết quả (ranking, time, objectives).  
* Server đẩy kết quả cho Nakama thông qua RPC: `match_result_submit(match_id, results)`.  
* Game server upload metadata (replay\_id, duration, players) lên Nakama.  
* Nakama lưu persistent stats (player profile, match history), cập nhật leaderboard.

**Eventual consistency**: đảm bảo những thay đổi MMR/leaderboard chỉ khi tất cả data cần thiết đã đến (chiến lược transaction-like: write-ahead log).

### **3.8 Tính toán MMR & cập nhật leaderboard**

**Thời điểm**: tính toán sau khi trận kết thúc và kết quả đã được xác nhận.

**Thu thập dữ liệu**: kết quả trận, mmr trước trận, ranking, time, skill metrics, report flags, etc.

**Thuật toán**:

* Có thể dùng Elo, Glicko-2, hoặc TrueSkill. Đa phần game lớn thường dùng biến thể TrueSkill/Elo với số điều chỉnh dựa trên room size.

**Flow cập nhật**:

1. Nakama nhận `match_result_submit` → validate → call `mmr_service.update(...)`.  
2. MMR service tính new MMR cho từng player.  
3. Lưu MMR mới vào Nakama storage / leaderboard API.  
4. Emit event `mmr_changed` cho client (đẩy thông tin xếp hạng thay đổi sau màn chơi).

![][image1]

# **4\. Một số lưu ý vận hành & scale**

* **Autoscaling game servers**: warm pool \+ scale up based on queue length.  
* **Nakama cluster**: scaled horizontally, stateful parts sử dụng PostgreSQL.  
* **Region routing**: dựa trên geolocation & latency.  
* **Chaos testing**: kiểm thử failover, reconnect.

# **5\. Phương án multiplayer in-game:**

Hiện tại project Racing có nhu cầu mở rộng ingame với chế độ multiplayer, nhưng hiện tại (08/10/2025) có một vấn đề tương đối lớn, đó là vấn đề kỹ thuật để thực hiện code multiplayer PvP. CÓ 2 phương án thường được dùng trong dòng racing:

1. Phương án ghost-player: về cơ bản, mỗi player sẽ đua trong 1 game server instance riêng của họ, và tất cả player còn lại sẽ được thay bởi AI. Phương án này tránh được việc phải giải quyết bài toán lag compensation cho multiplayer, chỉ phải giải quyết bài toán lag compensation cho một người chơi duy nhất. Thời gian hoàn thành ước tính 1-2 tháng.  
2. Phương án PvP: tất cả player sẽ được thi đấu trong 1 game server instance duy nhất, xử lí va chạm như game đua xe thông thường, phải xử lí bài toán lag compensation cho multiplayer. Thời gian hoàn thành ước tính 4 \- 6 tháng.

|  | Ghost Player | PvP |
| :---- | :---- | :---- |
| Đồng bộ | Người chơi chỉ chơi với AI, server sẽ chỉ làm nhiệm vụ giám sát anti-cheat. | Người chơi đua với nhau, có khả năng thực hiện các kỹ thuật cản trở/vượt mặt,... |
| Vật lý | Các player không ảnh hưởng tới nhau | Các player có ảnh hưởng tới nhau, gây thay đổi kết quả |
| Độ khó | Tương đối, thời gian hoàn thành 1-2 tháng | Rất khó, thời gian hoàn thành 4 \- 6 tháng |

[image1]: <!-- embedded image removed -->
