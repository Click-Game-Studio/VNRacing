# PLAYER INFO

GDD mô tả Screen của người chơi khi đang đua  
**Change Log:**

- First Version (20251028).  
-   
1. **Concepts** 

1. ## **Concepts**

- Khi đua, các yếu tố trên **HUD** của người chơi sẽ Update các thông tin liên quan tới cuộc đua.

2. ## **Liệt kê các Entities (Hud Components)**

- Các Entities thay đổi thông tin trên màn hình trong khi đua:  
  - Thông tin chung:  
    - Tốc độ hiện tại.  
    - Vị trí hiện tại  
    - Số Lap đua.  
  - Thời gian của cuộc đua.  
  - MiniMap.  
  - Button chức năng:  
    - AutoDrive Button  
  - Thông tin kỹ năng & nhiệm vụ FS:  
    - Thanh tiến trình nhiệm vụ FS.  
    - PopUp kỹ năng đua và điểm số.  
  - Thông tin đối thủ  
    - Vị thứ đua và tên trên đầu các xe.  
- [Link Figma cập nhật thiết kế và Anim,FX.](https://www.figma.com/design/j0UmML9tgnH8EK792k9Mbb/VNRacing_UX?node-id=11644-29825&t=95FOAJElf5gMcMmi-4)

![][image1]

2. **Chi tiết các Entities**

1. ## **Thông tin chung**

1. **Hiển thị các thông số:**  
   - Tốc độ di chuyển hiện tại của xe (KM/H hoặc MPH).  
   - Lap đua hiện tại/Tổng số lượng Lap đua.  
   - Vị thứ hiện tại trong cuộc đua/Tổng số lượng tay đua.  
     - Nếu chỉ có một tay đua trong cuộc đua là người chơi thì không hiện số này lên *(Hiện tại chỉ có Time Attack*).

2. **Các trường hợp hiển thị khác:**  
   - Trong RaceMode Sprint:  
     - Lap đua hiện tại \-\> Số % quãng đường còn lại của cuộc đua.  
   - Trong RaceMode TimeAttack:  
     - Lap đua hiện tại \-\>  Số % quãng đường còn lại của cuộc đua (Sử dụng Racing Line).  
     - Vị thứ hiện tại trong cuộc đua \-\> Thời gian đếm ngược còn lại của cuộc đua (Khác với thời gian đếm tới thường thấy trong Sprint & Circuit.).

![][image2]

3. **Animation & Effect**  
- Khi hoàn thành một Lap, có Animation & FX thay đổi số đếm. (Ví dụ từ Lap 1 \-\> Lap 2).  
- Khi vị trí thay đổi, có Animation & FX thay đổi số đếm (Ví dụ từ Position 3 \-\> Position 2).  
- Khi ở chế độ đua Sprint, có Animation và & FX thay đổi khi đi tới các mốc quãng đường 25%, 50%, 75%, 100%.  
- Khi ở chế độ đua Time Attack, đổi màu Text thành đỏ, cho hiệu ứng nhấp nháy và phình to thu nhỏ khi Thời gian đếm ngược chỉ còn xấp xỉ 15s.
- Khi được tăng Thời gian đếm ngược, có Animation & FX thay đổi. (Ví dụ Thời gian đếm ngược tăng từ 15:20.20 \-\> 30:20.20)

4. **Animation & Effect REF**

**![][image3]![][image4]**

2. ## **Thời gian của cuộc đua**

1. **Hiển thị thông số**  
- Thời gian đếm từ khi cuộc đua bắt đầu tới hiện tại, đơn vị: **Phút:Giây:Mili Giây**  
2. **Các trường hợp hiển thị khác**  
- Không xuất hiện trong Mode đua Time Attack.

![][image5]

3. ## **MiniMap**

- [Check văn bản GDD của MiniMap.](?tab=t.bricz5hs84sa)

4. ## **Button chức năng**

1. **Hiển thị thông số**  
- Cho phép Toggle giữa chế độ AutoDrive hoặc không.

**![][image6]**

5. ## **Thông tin kỹ năng & nhiệm vụ FS**

1. **Hiển thị thông số**  
- Tiến trình hiện tại của nhiệm vụ FS  
  - Có hai dạng, thanh Progress và dạng CheckBox, mỗi dạng có 2 trường hợp In Progress & Failed.  
- Popup Kỹ năng đua & điểm số: Hiển thị thưởng của kỹ năng làm tăng thanh NOS.  
  - Bình thường sẽ ở trạng thái ẩn, chỉ khi người chơi kích hoạt [kỹ năng đua](?tab=t.k9kb5d6llqwv#heading=h.tdrcxwehydps) thì mới chạy Anim xuất hiện.  
  - Người chơi có thể kích hoạt cùng lúc [nhiều Kỹ năng](?tab=t.k9kb5d6llqwv#heading=h.tdrcxwehydps) nên có thể xuất hiện cùng lúc nhiều hàng.  
  - Sau khi xuất hiện trên màn hình một thời gian, trong vòng 3s, nếu kỹ năng được sử dụng thì tiếp tục cộng dồn số điểm, nếu không được sử dụng thì chạy Animation biến mất.


![][image7]

2. **Animation & FX**  
- Thanh tiến trình nhiệm vụ FS:  
  - Khi đang tiến hành nhiệm vụ dạng Progressbar, có Animation & FX của thanh Progressbar.  
  - Khi hoàn thành nhiệm vụ dạng Progressbar, có Animation & FX của thanh Progressbar.  
  - Khi không hoàn thành nhiệm vụ dạng Progressbar, có Animation & FX của thanh Progressbar.  
  - Khi hoàn thành nhiệm vụ dạng CheckBox, có Animation & FX của Checkbox.   
  - Khi không hoàn thành nhiệm vụ dạng CheckBox, có Animation & FX của Checkbox.   
- Popup Kỹ năng đua & Điểm số:  
  - Khi Popup xuất hiện, có Animation và FX của panel này.  
  - Khi Popup biến mất, có Animation và FX của panel này.

3. **Animation & Effect REF**

![][image8]![][image9]

6. ## **Thông tin đối thủ**

1. **Hiển thị thông số**  
- Thông tin đối thủ:
  - Hiện vị thứ trong cuộc đua khi cách xa người chơi xấp xỉ 10m trở lên.
  - Hiện tên khi ở gần người chơi xấp xỉ 5m.
  - Biến mất khi cách xa người chơi xấp xỉ 20m.

2. **Animation & FX**  
- Khi chuyển đổi trạng thái giữa tên và vị thứ, có Animation và FX chuyển đổi.  
- Khi chuyển đổi trạng thái giữa vị thứ và biến mất, có Animation và FX chuyển đổi.

3. **Animation & FX REF**

![][image10]

3. **Danh sách các Events**

|  |  |  |
| :---- | :---- | :---- |
|  |  |  |
|  |  |  |
