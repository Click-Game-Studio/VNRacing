# **VNRacing**

**Tài Liệu Thiết Kế Car Customize**

Phiên bản: v2.0  |  Ngày: 23/04/2026

Team: Game Design  |  Dành cho: PO/ PM / Dev/ QA / Art

# 1. TỔNG QUAN

## **1.1. Concepts**

- Người chơi có hai lựa chọn khi Customize xe:
    - **Customize Performance:** Tinh chỉnh hiệu năng của xe bằng cách nâng cấp.
    - **Customize Visual:** Tinh chỉnh ngoại hình của xe bằng cách sưu tập các Visual Parts và gắn lên xe.

## 1.2. Mechanics và Định nghĩa liên quan cần phát triển

| # | Tên |  |
| --- | --- | --- |
| **1** | **Car Customize Visual** |  |
|  | 1.1 | Các hạng mục Customize Visual xe. |
|  | 1.2 | Hiển thị các mục Customize Visual |
|  | 1.3 | Chi phí khi Customize Visual xe. |
|  | 1.4 | Các Flow Customize Visual xe. |
|  | 1.5 | Truy cập và tương tác với giao diện Customize Visual |
|  | 1.6 | Cơ chế Camera khi Customize các hạng mục |
|  | 1.7 | Một số chức năng phụ khác trong Car Customize Visual |
|  | 1.8 | Lưu ý đối với hạng mục Customize Visual Body Material và Customize Visual Decals |
| **2** | **Car Customize Performance** |  |
|  | 1.1 | Global CR & Local CR |
|  | 1.2 | CR Archetypes của các xe. |
|  | 1.3 | Các hạng mục nâng cấp Performance của xe. |
|  | 1.4 | Yêu cầu khi nâng cấp Performance của xe. |
|  | 1.5 | Flow nâng cấp Performance xe. |
|  | 1.6 | Tính toán CR xe khi nâng cấp |
|  | 1.7 | Chi phí nâng cấp Performance xe. |
|  | 1.8 | Chế độ Test Drive |
|  | 1.9 | Xử lý một số trường hợp đặc biệt khi nâng cấp Performance xe. |

# 2. Mechanics và các định nghĩa liên quan cần phát triển

## 2.1. Customize Visual

### 2.1.1. Các hạng mục Customize Visual xe.

*Bảng tổng hợp các hạng mục  Customize Visual*

| # | **Hạng mục nâng cấp** | Slot nâng cấp | **Tổng số Part** |
| --- | --- | --- | --- |
| 1 | **Visual Part** | 6 | 18 |
| 2 | **Material** | 2 | 15 |
| 3 | **Decals** | 1 | 5 |
|  |  | 9 | 38 |
- Các Slot Customize Visual Part của xe gồm:
    - FrontBumper, RearBumper, Sideboard, Spoiler, Roof, Wheel.

![alt text](images/image-4.png)

*Customize Visual Parts*

- Các Slot Customize Material/Paint của xe gồm:
    - Body Material, Wheel Material.

![alt text](images/image-5.png)

*Customize Visual Body Materials*

![alt text](images/image-6.png)

*Customize Visual Wheel Materials*

- Các Slot Customize Decals của xe gồm:
    - Body Decals.

![alt text](images/image-7.png)

*Customize Visual Body Decals*

### 2.1.2. Hiển thị các mục Customize Visual

- Tất cả các tùy chọn Customize Visual có thể của một xe xuất hiện từ đầu trong Screen Customize Visual.
    - Ngoài các tùy chọn Visual mặc định của xe, tất cả các Part còn lại đều ở trạng thái Lock khi người chơi chưa có chúng trong Inventory.

![alt text](images/image-8.png)
*Tất cả các tùy chọn Customize Visual của xe xuất hiện từ đầu trong Screen Customize Visual.*

- Người chơi có thể chọn để Preview các tùy chọn bị Lock nhưng không thể mua hay Apply các tùy chọn đang bị Lock.

![alt text](images/image-9.png)

*Ví dụ: Tùy chọn màu Chameleon bị Locked nhưng vẫn có thể Preview.*

- Các tùy chọn Customize Visual chỉ hiện tên, giá và trạng thái được cập nhật ở Panel bên cạnh:

![alt text](images/image-10.png)

*Các tùy chọn Customize Visual chỉ hiện tên, giá và trạng thái được cập nhật ở Panel bên cạnh.*

### 2.1.3. Chi phí khi Customize Visual xe.

- Với các Part đã được Unlock và chưa được Purchase:
    - Chi phí Cash = 20$ , chỉ cần trả lần đầu.
- Với các Part đã được Unlock và đã được Purchase:
    - Chi phí Cash = 0$.
- Với các Part chưa được Unlock.
    - Chỉ có thể chọn để Preview, **không thể Purchase.**

⇒ Chi tiết tham khảo tài liệu Progression, phần Earn/Spend.

### 2.1.4. Các Flow Customize Visual xe.

- Preview Part Visual:
    - Chọn Hạng mục —> Chọn Tùy chọn Customize —> Xe Update Preview của tùy chọn đó.
    - Nếu không bấm Apply hoặc Purchased —> Xe tự động Revert về lựa chọn trước đó khi thoát khỏi Screen Customize Visual.
- Purchase Part Visual:
    - Từ Preview —> Bấm Purchase —> Xác nhận mua hoàn thành —> Part Visual được Purchase và tự động Apply vào xe.
- Apply Part Visual:
    - Chọn Tùy chọn Customize —> Bấm Apply —> Xe Apply Part đó.

### 2.1.5. Truy cập và Tương tác với giao diện Customize Visual

- Vào chế độ Customize Visual từ Screen Garage:
    - Có thể bấm vào nút Visual trên giao diện hoặc bấm trực tiếp lên Model xe trên Screen.
    - Có thể bấm các dấu chấm trên xe để Customize Visual thẳng các Part đó.

![alt text](images/image-11.png)

*Có thể bấm vào xe hoặc bấm vào nút Visual để vào Screen Customize Visual*

- Lựa chọn các hạng mục Customize Visual: Khi đang ở trong Screen Customize Visual, chạm vào các hạng mục trên Screen UI hoặc ngay trên xe để bắt đầu Customize hạng mục đó.

![alt text](images/image-12.png)

*Các hạng mục Customize Visual trên Screen UI và ngay trên xe (Các chấm trắng)*

- Khi đang Customize một Part Visual cụ thể:
    - Khi đang Customize một Visual Part cụ thể hoặc Body Material, Decals, bấm nút Back sẽ quay về Screen Customize Visual tổng.
    - Trường hợp khi đang Customize Wheel Material, bấm nút Back sẽ quay trở về tùy chọn Part Wheel.

![alt text](images/image-13.png)

*Back về Screen Customize Visual tổng từ Screen Customize Visual Part cụ thể*

### 2.1.6. Cơ chế Camera khi Customize các hạng mục Visual

- Ở Screen Customize Visual tổng, người chơi có thể tự do Rotate Camera.
- Khi HideUI, người chơi có thể tự do Rotate Camera.
- Khi người chọn chọn Customize Visual các Part cụ thể, Camera sẽ Blend tới gần vị trí của Part đó.
    - Khi này người chơi sẽ không thể tự do Rotate Camera.
- Ở dưới là Danh sách liệt kê các góc Camera tham khảo tương ứng với từng bộ phận:
    - Camera Customize Visual tổng:
    
![alt text](images/image-14.png)
    - Camera FrontBumper:
    
![alt text](images/image-15.png)   
    - Camera RearBumper:
    
![alt text](images/image-16.png)  
    - Camera SideBoard:
    
![alt text](images/image-17.png) 
    - Camera Spoiler:
    
![alt text](images/image-18.png)  
    - Camera Roof:
    
![alt text](images/image-19.png)  
    - Camera Wheel:
    
![alt text](images/image-20.png)    
    - Camera MaterialBody: Camera tương tự Customize Visual Tổng.
    - Camera MaterialWheel: Camera tương tự Wheel.
    - Camera DecalBody: Camera tương tự Customize Visual Tổng.

### 2.1.7. Một số chức năng phụ khác trong Car Customize Visual

- Chức năng Hide UI.
    - Người chơi bấm vào nút Hide UI trên Screen để dấu hết UI đi.
    - Không thể tương tác với bất kỳ yếu tố UI nào trong chế độ này ngoại trừ nút bấm ShowUI để hiện UI trở lại.
    - Người chơi có thể tự do xoay Camera trong Mode này.
        - Trường hợp đang Customize Visual Parts cụ thể, nếu bấm HideUI thì không thể xoay Camera tự do.

![alt text](images/image-21.png)

*Chức năng HideUI trên màn hình.*

- Xe nhấp nháy ở Screen Garage
    - Khi người chơi vào Screen Garage, xe sẽ nhấp nháy lên một vài lần để báo cho người chơi biết có thể bấm vào xe để hiện chức năng Customize Visual.
    
- Xe chạy hiệu ứng khi đổi Visual Parts.
    - Khi người chơi đổi Part Visual, Part Visual đó chạy hiệu ứng nhấp nháy một lần.

- Xe chạy hiệu ứng khi đổi Visual Materials & Decals.
    - Khi người chơi đổi Materials hoặc Decals, xe chạy hiệu ứng đổi Material của xe.

### 2.1.8. Lưu ý đối với hạng mục Customize Visual Body Material và Customize Visual Decals

- Customize Visual Body Material và Customize Visual Decals đều làm thay đổi Material gốc của xe.
    - Customize Visual Body Material làm thay đổi màu và vật liệu màu xe.
    - Customize Visual Decals làm thay đổi vật liệu màu xe và Decals dán lên xe.
    
- Người chơi chỉ có thể điều chỉnh Slot Customize Visual Body Materials hoặc Customize Visual Decals, không thể kết hợp cả 2 trong cùng một thời điểm.
    - **Ví dụ:**
        - Người chơi có thể chọn Material Red - Chameleon với màu đỏ, nhưng khi đổi sang Decals Stripes thì xe sẽ thay thế hoàn toàn màu của xe thành màu đi cùng với Decals Stripes.

## 2.2. Customize Performance

### 2.2.1. Global CR & Local CR

- CR là tập hợp một bộ chỉ số Raw Stat của xe, là thước đo đánh giá sức mạnh của xe.
    - Xe có CR cao hơn là xe có hiệu năng tốt hơn.
- Global CR và Local CR.
    - **Global CR** là CR tổng toàn Game, có giá trị từ 0 —> 18, dùng để so sánh trực tiếp giữa tất cả các xe.
    - **Local CR** là dải sức mạnh của một xe khi đặt trên Global CR, được giới hạn bởi **CR(minLocal)** và **CR(maxLocal)**.
        - CR(Local) luôn cố định: CR(minLocal) = 0, CR(maxLocal) = 6
        - Mỗi xe luôn có dải sức mạnh từ 0 —> 6, nhưng vị trí của dải này trên Global CR là khác nhau.
    - Ví dụ:
        - Xe A có:
            - Local CR: 0 → 6
            - Mapping lên Global: 3 —> 9
                
                ⇒ Xe A có thể mạnh  từ CR3 —> CR9
                
        - Xe B có:
            - Local CR: 0 → 6
            - Mapping lên Global: 6 —> 12
                
                ⇒ Xe B có thể mạnh  từ CR6 —> CR12
                

![alt text](images/image-22.png)

*Ví dụ về Global CR và Local CR:*

### 2.2.2. CR Archetypes của các xe. (Pending - Chưa thực hiện)

- Mỗi xe trong Game sẽ nằm trong loại ArcheType riêng:
    - **Speed Archetype:** Tốc độ tối đa cao.
    - **Grip Archetype:** Khả năng bám đường tốt.
    - **Acce Archetype:** Khả năng tăng tốc tốc.
- Tạm thời dùng 1 Archetype chung.

### 2.2.3. Các hạng mục nâng cấp Performance của xe.

- 4 hạng mục nâng cấp:
    - Speed, Acceleration, Grip & Nitro
- 6 cấp Level mỗi hạng mục
    - Lv0 → Lv6

![alt text](images/image-23.png)

*Bên phải: Các hạng mục nâng cấp; Bên trái: Level nâng cấp hiện tại.*

- Khi người chơi nâng cấp tối đa một hạng mục (Lv6):
    - Text Lv6 sẽ đổi thành Max

### 2.2.4. Yêu cầu khi nâng cấp Performance của xe.

- Người chơi có thể xem được yêu cầu khi nâng cấp xe trên UI:
    - Từ 0 → 3: Cần có Cash.
    - Từ 4 →6: Cần có Cash + Performance Items.

![alt text](images/image-24.png)

*Yêu cầu nâng cấp xe trên UI (Góc dưới bên phải)*

### 2.2.5. Flow nâng cấp Performance xe.

- Chọn Mục nâng cấp → Đủ tiền → Xe nâng cấp → Update tính toán CR.

![alt text](images/image-25.png)

*Flow nâng cấp xe.*

### 2.2.6. Tính toán CR xe khi nâng cấp.

- Mỗi khi người chơi nâng cấp một trong 3 chỉ số (Speed, Acce, Grip), chỉ số CR của xe sẽ được Update. Riêng NITRO không Update chỉ số CR của xe.

- CR xe khi nâng cấp được tính toán dựa trên các công thức sau:
    - $CR_{raw}$ là tính toán CR sau khi áp dụng hệ số ảnh hưởng của từng chỉ số.
        - S, G, A là số nâng cấp của Speed, Grip , Acce - $S, G, A \in [0, 6]$
    - D là hệ số sai lệch giữa các chỉ số S, G, A.
        - $CR_{max} = 6$  (CR Local tối đa của xe)
        - $StatCR_{max}$ là số lớn nhất trong bộ số S, G, A.
    - $CR_{localFinal}$ là tính toán CR Local sau khi đã áp dụng hệ số sai lệch D.
    - $CR_{globalFinal}$ là tính toán CR sau cùng, hiện lên màn hình người chơi.
        - $CR_{base}$ là cấp độ thấp nhất trên dải CR của xe.
    
    $$
    CR_{raw} = 0.49\times S + 0.41 \times G + 0.1 \times A
    $$
    
    $$
    D = \frac{(StatCR_{max}-S)+(StatCR_{max}-G)+(StatCR_{max}-A)}{2\times CR_{max}}
    $$
    

$$
CR_{localFinal}= CR_{raw} \times e^{-0.3*D}
$$

$$
CR_{globalFinal} = CR{localFinal} + CR_{Base}
$$

- Một số ví dụ tính toán để tham khảo:

|  | Xe A | Xe B | Xe C | Xe A1 |
| --- | --- | --- | --- | --- |
| **Global CR Min** | 0 | 3 | 12 | 0 |
| **Global CR Max** | 6 | 9 | 18 | 6 |
| **Speed (Local)** | 5 | 5 | 5 | 5 |
| **Grip (Local)** | 3 | 3 | 3 | 3 |
| **Acce (Local)** | 2 | 2 | 2 | 3 |
| **MAX STAT** | 5 | 5 | 5 | 5 |
| **CR(Raw)** | 3.88 | 3.88 | 3.88 | 3.98 |
| **D** | 0.4166666667 | 0.4166666667 | 0.4166666667 | 0.3333333333 |
| **CR(FinalLocal)** | 3.424087982 | 3.424087982 | 3.424087982 | 3.601252924 |
| **CR(FinalGlobal)** | 3.424087982 | 6.424087982 | 15.42408798 | 3.601252924 |

### 2.2.7. Chi phí nâng cấp Performance xe

- Check văn bản Progression, phần Earn/Spend.

### 2.2.8. Chế độ Test Drive

- Trong Scren Customize Performance, người chơi có thể trực tiếp vào Track Test Drive với xe hiện tại.
- Trong Track Test Drive, người chơi sử dụng xe hiện tại để đua và có thể lấy các thông số Performance sau một cuộc đua để so sánh.
    - So sánh sẽ gồm 2 mục: Xe base và xe nâng cấp
    - Người chơi có thể chọn từ 1 → 5 vòng đua để đua Test.

### 2.2.9. Xử lý một số trường hợp đặc biệt khi nâng cấp Performance xe.

- none

---

***End of Documentation***

---

*Mọi thắc mắc xin liên hệ Team Game Design.*
