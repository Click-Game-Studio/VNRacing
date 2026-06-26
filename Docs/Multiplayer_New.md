# BẢNG PHÂN TÍCH USER STORY (US) & NOTE – MULTIPLAYER

## I. QUICK MATCH (Trận đấu nhanh)

| STT | User Story (Yêu cầu người dùng) | Ghi chú / Yêu cầu kỹ thuật (Note) |
| :--- | :--- | :--- |
| **1** | Là player, tôi muốn có một trận đấu ngẫu nhiên với các đấu thủ bất kỳ, nhanh chóng match được trận. Mỗi trận thắng nhận được một hệ số rank trên bảng xếp hạng. | - US này chỉ cần làm được full luồng của Quick Match là được và có cơ chế để test việc matchmaking.<br>- Ví dụ: Có 4 player online và cùng match là phải match được ngay.<br>- US này ở mức basic (cơ bản), có thể QC hoàn thành từ đầu để có được phần Core của Multiplayer. |
| **2** | Luồng UX ngắn và thuận tiện nhất. | - Design nộp lại phần UX và bảo vệ design. |
| **3** | Là Player, tôi muốn có Intro Scene ngay khi tìm được trận đấu và vào trận, show được xe của tôi. Cảm giác các nâng cấp và độ xe là đáng giá. | - Chưa thấy có trong Design. |
| **4** | Là Player, tôi muốn có một Quick Scene ở post-game, show được thứ hạng ngay lập tức trên tổng bảng xếp hạng. | - Chưa thấy có trong Design. |
| **5** | Là Player, tôi muốn có phần Art từ lúc match được trận đấu đến lúc vào game phải tạo được không khí kích thích chiến đấu (Cutscene, Âm thanh, Effect). | - Chưa thấy có phần mô tả Art này trong Design. |
| **6** | Là Admin, tôi muốn các player kết nối với nhau phải có sức mạnh xe phù hợp (chỉ số CR), không được chênh lệch quá lớn, không được tạo cảm giác ức chế cho player. | - US này test bằng cách set sẵn các kịch bản.<br>- Ví dụ: Có 10 player tham gia thì có 4 player phù hợp range gần nhau thì phải match được đúng 4 player này. Đối với các player khác, khi chỉ số CR về gần với nhau thì cũng phải match đúng các player có CR gần nhau. |
| **7** | Là Player, tôi muốn các đối thủ phải có kết nối ổn định, không nên có hiện tượng giật lag, blink (giật/biến mất) khi đang đua. | - Xử lý latency (độ trễ) về mạng, kết nối và khoảng cách địa lý ở Back-end. |
| **8** | Là Player, tôi muốn tiếp tục đua với các đối thủ hiện tại ở một trận đấu mới, Final Scene + MMR cho phép đăng ký để tiếp tục. Khi có player thoát ra thì chế độ đua giảm về đúng số người để có thể tiếp tục, không cần phải đủ số người. | *(Trống)* |
| **9** | Là Player, tôi muốn Challenge (thách đấu) người chơi cùng với mình. | *(Trống)* |
| **10** | Là Player, tôi muốn đánh dấu những player thắng mình và trả thù trong lần đua tiếp theo. Cơ chế Win streak (Win strike) chỉ tồn tại khi 2 player có các trận chơi liên tiếp với nhau. | - Design cần nghiên cứu cơ chế mark (đánh dấu) lại đối thủ đã thắng mình để tăng % khả năng đua tiếp tục. *(Yêu cầu được highlight)* |
| **11** | Là Player, tôi muốn khi toàn bộ các đối thủ bị disconnect, tôi sẽ tự động thắng. | - Chưa có design thể hiện phần này hiển thị ra sao. |
| **12** | Là Player, tôi muốn khi tôi bị mất kết nối, trong một khoảng thời gian nhất định sẽ có AI chạy giúp để không lỡ mất một trận đấu. | - Chưa có mô tả trong design. |

---

## II. LOBBY MATCH (Trận đấu phòng chờ)

| STT | User Story (Yêu cầu người dùng) | Ghi chú / Yêu cầu kỹ thuật (Note) |
| :--- | :--- | :--- |
| **1** | Là player, tôi muốn Scene Lobby show được xe của các đối thủ. | *(Trống)* |
| **2** | Là player, tôi muốn Lobby mời được friend (bạn bè) của mình. | *(Trống)* |
| **3** | Là player, tôi muốn Lobby có chế độ Challenge tương tự như Quick Match để có thể play được Rank. | *(Trống)* |
| **4** | Là Player, tôi muốn chế độ Lobby cho phép lựa chọn xe để tham gia ngay bên trong. | *(Trống)* |