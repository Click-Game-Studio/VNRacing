# **Tài liệu timeline breakdown** 

# **cho bản demo multiplayer của project Racing**

# **1/ Yêu cầu cơ bản:**

Xây dựng chức năng multiplayer dưới dạng demo cho project Racing với các yêu cầu cơ bản sau:

- Cho phép ghép trận multiplayer 4 người.  
- Trên cùng một Server.  
- Không cho phép người chơi va chạm với nhau.

Để đảm bảo không gặp tình trạng overscope, mọi yêu cầu kỹ thuật khác sẽ bị loại bỏ trong bản demo này, bao gồm nhưng không giới hạn trong các tính năng sau:

- Tạo private room  
- Mời bạn bè tham gia cùng mình  
- Server kiểm soát tính hợp lệ của cuộc đua  
- Tính điểm xếp hạng  
- Ghép đôi dựa trên xếp hạng

# **2/ Lộ trình xây dựng demo:**

Lộ trình xây dựng bản demo có thể chạy được in-game bao gồm các hạng mục sau:  
2.1 \- UI multiplayer:

* Thời gian: 3 ngày  
* Các màn hình chính:  
  * Màn hình chọn chế độ multiplayer (private room không có chức năng). Sau khi chọn multiplayer sẽ được đưa thẳng sang màn hình Queue.   
  * Màn hình Queue, thể hiện đang đợi ghép trận. Khi được ghép trận sẽ chuyển sang màn hình đã ghép trận. Không có customize / ready state.  
  * Màn hình đã ghép trận, đợi cho tới khi game server data được gửi tới thì tiến vào màn chơi.  
* Phụ thuộc vào task: 2.2 (phần lấy data từ Nakama về để thể hiện trong UI, phần này sẽ được delay tới khi thực hiện mục 2.5, trong thời gian đó dùng timer hay timeline để fake data)

2.2 \- Chức năng tạo queue và ghép trận trên Nakama:

* Thời gian: 7 ngày  
* Chức năng ghép trận và quản lí trận cơ bản:  
  * Cho phép ghép trận cơ bản, nhận lệnh ghép trận cho 4 người.  
  * Gửi thông báo ghép trận thành công cho các client đã ghép được trận. Loại bỏ 4 người chơi khỏi queue. Khóa tất cả các player này khỏi việc tạo queue mới. Bắt đầu spin up server game instance.  
  * Khi game server được spin up thành công thì gửi game server data cho các client đã được ghép trận, đồng thời lưu trữ match data (gồm match ID và player list). Chỉ cần gửi cho game server về thông tin server Nakama và match ID cơ bản để thông báo kết thúc trận trong tương lai. Không cần trao đổi bất cứ thông tin gì khác cho game server, ví dụ như Authorize data…  
  * Khi game server thông báo kết thúc trận, mở khóa queue cho các player trong trận vừa rồi.

2.3 \- Chức năng multiplayer trên Unreal:

* Thời gian: 5 ngày  
* Tạo các chức năng multiplayer cơ bản như sau:  
  * Gửi control data lên server  
  * Replicate vị trí của simulated client only. Vị trí của owning client sẽ được client-authorized.  
  * Tắt toàn bộ collision của tất cả các simulated client. Chỉ giữ lại collision để thực hiện các hiệu ứng như tia lửa khi va chạm.  
  * Thay vì replicate vị trí của owning client, thì replicated thông tin về vị trí rồi vẽ debug dưới dạng box cơ bản.

2.4 \- Đăng ký dịch vụ Edgegap và config:

* Thời gian: 2 ngày  
* Đăng ký chức năng và tải bản game server lên kho lưu trữ của Edgegap.

2.5 \- Ghép nối, kiểm tra lần cuối: 3 ngày

# **3/ Tổng kết:**

Tổng thời gian thực hiện: 10 ngày  
Chức năng của bản demo sẽ được thể hiện trên bản build với các giới hạn như đã đề cập ở phần 1\.

