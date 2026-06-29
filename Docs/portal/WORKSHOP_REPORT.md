# Báo cáo tổng hợp nội dung workshop

> Nguồn: nội dung trích xuất lại từ video record.

## 1. Tóm tắt chung

Hiện tại, nhóm đang gặp khó khăn trong việc quản lý tài liệu: tài liệu bị phân tán, quy trình review chưa rõ ràng, và tài liệu kiến trúc chưa được cập nhật kịp thời theo hệ thống.

Để giải quyết, nhóm sẽ triển khai một hệ thống tài liệu tập trung. Hệ thống này hỗ trợ tra cứu dễ hơn, tìm kiếm theo từ khóa, theo dõi lịch sử thay đổi, so sánh giữa các version và cập nhật sơ đồ kiến trúc theo quy trình rõ ràng hơn.

---

## 2. Các nội dung chính

### 2.1. Vấn đề quản lý tài liệu hiện tại

Nhóm xác định 3 vấn đề chính:

- Tài liệu đang rải rác ở nhiều nơi.
- Quy trình review tài liệu chưa rõ ràng.
- Tài liệu kiến trúc chưa được cập nhật kịp thời.

Việc này làm cho thành viên khó tìm đúng thông tin, khó biết bản nào là mới nhất, và khó theo dõi thay đổi giữa các giai đoạn.

### 2.2. Hệ thống tài liệu tập trung

Giải pháp được đề xuất là dùng một hệ thống tài liệu tập trung để tất cả thành viên có thể truy cập cùng một nguồn thông tin.

Hệ thống mới cần hỗ trợ:

- Tìm kiếm thông tin theo từ khóa.
- Theo dõi lịch sử và thay đổi tài liệu.
- So sánh giữa version cũ và version mới.
- Tương tác với các component/sơ đồ để dễ hiểu hệ thống hơn.

### 2.3. Cấu trúc tài liệu theo version

Tài liệu được phân chia rõ theo từng version để dễ quản lý:

- Version hiện tại để team sử dụng chính.
- Version lịch sử để tra cứu lại thông tin cũ.
- Version/stream mới để phục vụ tính năng hoặc hướng phát triển mới.

Cách tổ chức này giúp team quản lý tài liệu lịch sử tốt hơn và chuẩn bị nội dung preview trước khi triển khai chi tiết.

### 2.4. Cách cập nhật nội dung

Workshop có hướng dẫn cách cập nhật tài liệu trong hệ thống:

- Khai báo nội dung Markdown rõ ràng, gồm title và thông tin cần thiết cho team.
- Cấu hình đúng để tài liệu hiển thị trong portal.
- Liên kết đúng các file cần thiết vào dự án.
- Nếu cấu hình thiếu hoặc sai, nội dung có thể tồn tại trong repo nhưng không hiển thị cho người khác xem.

### 2.5. Cập nhật mô hình và sơ đồ C4

Một phần quan trọng là hiểu mô hình C4 để chỉnh sửa và cập nhật sơ đồ kiến trúc.

Nội dung chính gồm:

- Khai báo actor, system, relationship.
- Cập nhật cấu trúc sơ đồ khi kiến trúc thay đổi.
- Cần người thực hiện hiểu đúng mô hình để tránh mô tả sai hệ thống.
- Tài liệu tham khảo chính thức giúp team tự tra cứu khi cần cập nhật tiếp.

### 2.6. Build, deploy và kiểm tra local

Trước khi gửi người khác review, thành viên cần tự kiểm tra trên máy local.

Các điểm chính:

- Dùng terminal/CMD để chạy kiểm tra.
- Kiểm tra môi trường và dependencies đã đủ chưa.
- Chạy build để phát hiện lỗi sớm.
- Chỉ gửi review khi nội dung đã hoạt động đúng.
- GitHub Actions hỗ trợ tự động build/deploy để tiết kiệm thời gian cho team.

### 2.7. Ước lượng, trách nhiệm và phối hợp team

Tài liệu cũng được dùng để hỗ trợ quản lý công việc và phối hợp trong team.

Các điểm được nhắc tới:

- Khi ước lượng thời gian, nên cộng thêm khoảng 10–15% để giảm rủi ro trễ hạn.
- Cần ghi lại các trường hợp trễ để xác định nguyên nhân và cải thiện quy trình.
- Thành viên cần chủ động phản hồi và góp ý.
- Cần xác định rõ vai trò, trách nhiệm và phần việc của từng người.

### 2.8. Quản lý file và tránh xung đột

Nhóm cần cơ chế phối hợp khi nhiều người cùng cập nhật tài liệu.

Các ý chính:

- Nên liên lạc trước khi sửa file quan trọng.
- Tránh trùng lặp hoặc ghi đè thay đổi của nhau.
- Cần xác định ownership cho từng phần tài liệu hoặc tính năng.
- Có thể cân nhắc công cụ/cơ chế thông báo trạng thái file để tránh conflict.

### 2.9. Chuẩn bị cho giai đoạn tiếp theo

Cuối buổi, nhóm thảo luận về việc hoàn tất nội dung và chuẩn bị cho các bước tiếp theo.

Các việc cần chú ý:

- Hoàn thành nội dung cuối cùng để gửi cho người liên quan.
- Chuẩn bị training và hướng dẫn để team có thể tự vận hành.
- Có kế hoạch rõ ràng cho phần việc trong tuần tiếp theo.
- Lưu ý thêm các vấn đề về chi phí, pháp lý hoặc hỗ trợ bên ngoài nếu phát sinh.

---

## 3. Kết luận

Buổi workshop thống nhất nhu cầu cần một hệ thống tài liệu tập trung để giải quyết tình trạng tài liệu phân tán, khó review và khó cập nhật kiến trúc. Hệ thống mới giúp team dễ tìm kiếm, so sánh version, theo dõi thay đổi, cập nhật sơ đồ C4 và kiểm tra nội dung trước khi gửi review/deploy.

Trọng tâm tiếp theo là chuẩn hóa cách team sử dụng hệ thống này: cập nhật tài liệu đúng quy trình, kiểm tra local trước khi gửi, phân rõ trách nhiệm từng phần, và duy trì tài liệu chung để mọi thành viên có thể tiếp tục làm việc hiệu quả.
