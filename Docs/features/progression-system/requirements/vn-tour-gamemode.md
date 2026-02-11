# VN-TOUR GAME MODES

*GDD mô tả VN Tour GameMode*  
**Change Log:**

- First Version (20250806)  
- Updated (20250818)  
- Big Update (20250904)

1. # **GameMode Concepts** 

1. ## **Concepts**

- Người chơi được tham gia các cuộc đua diễn ra trên khắp Việt Nam.  
- Đồng hành với GameMode này là một cốt truyện đơn giản đủ để gắn kết các yếu tố trong Mode này lại với nhau.  
- Người chơi sở hữu một Avatar, có thể Customize được ngoại hình.  
- Người chơi tương tác trên Map của các Tỉnh/Thành phố để tham gia các cuộc đua.  
- Cấu trúc của các Map theo thứ tự từ cao nhất đến thấp nhất:  
  - Tỉnh/Thành phố (**City**)  
  - Khu vực/Trường đua (**Area**)  
  - Track đua (**Track**)  
- Trong một City có thể có từ 1-3 Area được mở sẵn để người chơi tham gia đua.  
- Người chơi có thể Unlock thêm Area nếu hoàn thành mục tiếp của các Area trước đó.  
- Area cuối cùng được mở sẽ luôn là Area của **Boss**.

![][image1]

2. ## **Các Mechanics và Định nghĩa liên quan cần phát triển**

| Tên Mechanics | Link To Design Document |
| :---- | :---- |
| Cấu trúc của Map VNTour, tương tác và điều hướng. | [RacingGame\_20250317](https://docs.google.com/document/d/12qtXcSKGL34tVIIhh_921Wh_ZD6tMrBN5ARn-xFGURM/edit?tab=t.dn2rf2ds576u#heading=h.8za9wkqpbmd3) |
| Unlock Track đua, Area và Map mới. **Track/Map Expansion** | [RacingGame\_20250317](https://docs.google.com/document/d/12qtXcSKGL34tVIIhh_921Wh_ZD6tMrBN5ARn-xFGURM/edit?tab=t.dn2rf2ds576u#heading=h.dluqluk0rtd5) |
| Cơ chế **Car Rating (CR)** và **Performance Rating Gate**. | [RacingGame\_20250317](https://docs.google.com/document/d/12qtXcSKGL34tVIIhh_921Wh_ZD6tMrBN5ARn-xFGURM/edit?tab=t.dn2rf2ds576u#heading=h.329kqs440r9x) |
| Cơ chế **Race Track Ladder Base Progression.** | [RacingGame\_20250317](https://docs.google.com/document/d/12qtXcSKGL34tVIIhh_921Wh_ZD6tMrBN5ARn-xFGURM/edit?tab=t.dn2rf2ds576u#heading=h.evzkrnhzuneg) |
| Cơ chế **Fan Service** trong lúc đua. | [RacingGame\_20250317](https://docs.google.com/document/d/12qtXcSKGL34tVIIhh_921Wh_ZD6tMrBN5ARn-xFGURM/edit?tab=t.dn2rf2ds576u#heading=h.agj5xwoyxnir) |
| Cơ chế **Monetization**. | [RacingGame\_20250317](https://docs.google.com/document/d/12qtXcSKGL34tVIIhh_921Wh_ZD6tMrBN5ARn-xFGURM/edit?tab=t.dn2rf2ds576u#heading=h.xgk22dx2ri1h) |

2. # **GameMode Mechanics**

1. ## **Cấu trúc của Map VNTour, tương tác và điều hướng người dùng**

1. ### Cấu trúc của Map VN Tour

![][image2]  
![][image3]![][image4]

- Danh sách các đối tượng trên Map VN Tour:

| Map tổng \- City | Nơi chứa các Area người dùng có thể tương tác để vào đua và Unlock. |
| :---- | :---- |
| **Area** | Các khu vực đua hoặc trường đua, nơi tập hợp các Track đua mà người chơi có thể tham gia. |
| **Track** | Các Track đua nằm trong Area. |

- Link Map đua Đà Nẵng: [VN Racing - Car Physics Profiles](https://docs.google.com/spreadsheets/d/1TTunRhGmgEHM4KgGzEGK4sCtw5-nZz0R7o2kAEpbau4/edit?gid=771269843#gid=771269843&range=A2:G2)

2. ### Tương tác và điều hướng người dùng

- Chạm trên Map để chọn **Trường đua** trên Map.  
  (Bổ sung UI Frame)  
- Kéo vuốt theo phương ngang trên Map hoặc chạm vào nút chuyển trên màn hình để chuyển đổi giữa các **Tỉnh/Thành phố**.  
  (Bổ sung UI Frame)  
- Chọn Map của Tỉnh/Thành phố muốn đua qua thanh điều hướng bên phải.  
  (Bổ sung UI Frame)  
- Chọn Trường đua muốn tham gia và chọn Track muốn đua.  
  (Bổ sung UI Frame)

![][image5]

2. ## **Unlock Track đua, Area và Map mới.**

- Một số điều kiện ban đầu của một **Area**:  
  - Môt **Area** có 3 Track đua.  
  - Chỉ có **Track** đua đầu tiên là được mở.  
- Để Unlock Track đua tiếp theo trong Area, người dùng cần về đích ít nhất trong Top 3 Track đua trước đó.  
  - Độ khó các Track đua trong Area sẽ tăng dần.  
- Để Unlock Area tiếp theo, người dùng cần về đích ít nhất trong Top 3 trong tất cả 3 Track ở Area trước đó.  
- Để Unlock Thành phố mới, người dùng cần Unlock dành chiến thắng trong Area cuối cùng với Boss.  
- Phía dưới là sơ đồ các Area và Track đua trong Map:

**![][image6]**  
***Sơ đồ Unlock trong VnTour Map***

- Hiển thị các Area trong Map, trạng thái Lock và Unlock:


**![][image7]![][image8]**

3. ## **Cơ chế Car Rating (CR)**

- Car Rating (CR) là xếp hạng Performance của xe mà người chơi đang sử dụng.  
- Người chơi tăng CR bằng cách sử dụng các xe có Performance tốt hơn và nâng cấp xe.  
- Một số Track đua sẽ yêu cầu người chơi có xe có CR đáp ứng được điểm số tối thiểu, nếu không đáp ứng sẽ không cho phép đua, cơ chế này gọi là **Car Rating Gate**.

![][image9]

4. ## **Cơ chế Race Track Ladder Base Progression.**

- Khi hoàn thành một Track ở vị trí đầu tiên, người chơi có thể đua lại Track đua đó với độ khó lớn hơn.  
- Một Track sẽ có 3 độ khó: **Novice**, **Pro** & **Racer**.  
- Độ khó càng cao thì phần thưởng trả về càng lớn.  
- Độ khó **Pro** và **Racer** sẽ đảm bảo trả về cho người chơi các thưởng đặc biệt như các Part Customize đặc biệt, tiền Premium hoặc các phiên bản xe xịn (Đổi một chút Skin của xe có sẵn, thêm Decals).

![][image10]

## 

5. ## **Cơ chế Fan Service trong lúc đua**

   ![][image11]  
     
   - Khi bắt đầu cuộc đua, người chơi sẽ được giao một nhiệm vụ ngẫu nhiên gọi là nhiệm vụ **Fan Service.**  
   - Nhiệm vụ **Fan Service** sẽ Random trong một Pool nhiệm vụ có sẵn, yêu cầu người chơi hoàn thành trong thời gian tham gia cuộc đua, mỗi lần tham gia đua người chơi sẽ được giao một nhiệm vụ ngẫu nhiên hoặc được chỉ định trước tùy vào đường đua.  
   - Nhiệm vụ **Fan Service** sẽ tặng cho người chơi các phần thưởng thêm nếu hoàn thành.  
   - Người chơi chỉ có thể được giao và hoàn thành 1 nhiệm vụ **Fan Service** cho mỗi Track đua.  
   - Dưới đây là bảng nhiệm vụ mẫu:

| Tên nhiệm vụ | Cách thức hoàn thành | Loại |
| :---- | :---- | :---- |
| Drift Master | Đạt tổng thời gian trong Mode Drift là 6s. | Drift |
| Clean Racer | Không bị dính va chạm nào trong vòng 10s. | Collision |
| Fly Car | Bay trên không trong vòng 3s. | HangTime |
| Speed Demon | Đạt vận tốc tối đa 210 Km/h | Max Speed |
| Certain Expectation | Đạt và giữ vị trí thứ 3\. | Performance. |
| No Drift | Không Drift trong suốt cuộc đua. | Performance. |

6. ## **Cơ chế Monetization.**

- 

[image1]: <!-- embedded image removed -->

[image2]: <!-- embedded image removed -->

[image3]: <!-- embedded image removed -->

[image4]: <!-- embedded image removed -->

[image5]: <!-- embedded image removed -->

[image6]: <!-- embedded image removed -->

[image7]: <!-- embedded image removed -->

[image8]: <!-- embedded image removed -->

[image9]: <!-- embedded image removed -->

[image10]: <!-- embedded image removed -->

[image11]: <!-- embedded image removed -->
