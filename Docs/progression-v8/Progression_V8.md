# **VNRacing**

**Tài Liệu Thiết Kế Hệ Thống Progression**

PROGRESSION_CONCEPT_20260409

Phiên bản: v8.0  |  Ngày: 24/04/2026

Team: Game Design  |  Dành cho: PO/ PM / Dev/ QA / Art

## **I. FOUNDATION — Tham Số Cốt Lõi**

Đây là các con số nền tảng xác định quy mô của toàn bộ game — mọi hệ thống kinh tế, độ khó, và phần thưởng đều được tính toán ngược từ các tham số này. Thay đổi bất kỳ con số nào ở đây sẽ kéo theo điều chỉnh trên toàn bộ tài liệu thiết kế.

| **Tham Số** | **Giá Trị** |
| --- | --- |
| Tổng playtime mục tiêu | 300 phút |
| Thời gian mỗi race | 1.5 phút |
| Số thành phố | 5 Cities |
| Số track mỗi city | 15 Tracks |
| Tổng số track | 75 Tracks |
| Tổng số xe | 15 Cars |

Toàn bộ chiều dài hệ thống Progression của người chơi được thiết kế trong GameMode VnTour, một số yếu tố của bản của của GameMode này nằm trong các đề mục ở dưới:

### 1. Luật chơi trong GameMode VNTour:

- Tất cả 15 Tracks trong một City đã được Unlock sẵn, người chơi có thể chọn đua bất kỳ Track nào trong một City.
- Người chơi Unlock City mới bằng cách hoàn thành Goal mục tiêu của City hiện tại:
    - Goal mặc định là về nhất tất cả các Track.
    - Hệ thống Goal nâng cao sẽ được trình bày [trong muc X](https://www.notion.so/Progression-Concept_V8_Confirmed-34cd1a0054d2807dbeb6c9797a70b346?pvs=21).
- Mỗi Track có Tag độ khó kèm theo, phân theo các cấp Easy - Medium - Hard.
- Người chơi có thể nâng cấp xe để tăng tỉ lệ thắng, độ khó của A.I sẽ không Scale theo các nâng cấp của người chơi.
- Khi Unlock được City mới, người chơi sẽ được phần thưởng là 3 xe tương ứng với City đó.

### 2. Cấu trúc của Map VN Tour:

- Map VN Tour bao gồm 2 phần:
    - Phần Map Tổng của Area bao gồm Area và các Track đua nằm trong Area đó
        - Mỗi City có 5 Area, mỗi Area có 3 Track đua riêng, tổng cộng có 15 Track đua trên mỗi City.
    - Phần Goal mục tiêu của City, được thể hiện ở góc phải màn hình.

### 3. Độ khó của Track

- Các Track trong một City được chia làm 3 nhóm với 3 độ khó: **Easy, Medium ,Hard.**
- Số lượng Track Easy Medium Hard cố định trong một City lần lượt là 8, 4, 3.
- Tương ứng với mỗi độ khó của một City sẽ là một A.I với 2 đặc tính:
    - Bộ chỉ số xe A.I được rút từ một trong 19 bộ chỉ số có sẵn của City.
    - Bộ hành vi của A.I được quy định sẵn thông qua Preset.

## **II. PLAYTIME DISTRIBUTION**

Thay vì chia đều thời gian cho 5 thành phố thì Game phân bổ theo mục tiêu thành phố sau chiếm nhiều thời gian chơi hơn thành phố trước. 

Điều này tạo ra cảm giác game ngày càng "dày" và thử thách hơn khi tiến sâu.

![alt text](images/progression-image.png)

| **City** | **% Phân bổ** | **Playtime (phút)** | **Hệ số lặp X** | **Số lượt phải đua** |
| --- | --- | --- | --- | --- |
| City 1 | 7.5% | 22.5 | 1 | 15 |
| City 2 | 12% | 36 | 1.6 | 24 |
| City 3 | 17% | 51 | 2.27 | 35 |
| City 4 | 25% | 75 | 3.33 | 50 |
| City 5 | 38.5% | 115.5 | 5.14 | 78 |
| **Tổng** | **100%** | **300** | **AVG 2.67** | **202** |

*Note:  Hệ số lặp X cho biết trung bình mỗi track phải được chơi bao nhiêu lần để hoàn thành city. City 1 có X=1 (chơi 1 lần là đủ); City 5 có X=5.14 (player quay lại mỗi track hơn 5 lần).
Hệ số lặp X có AVG = 2.67, được tính bằng cách lấy 300 phút / 75 Tracks = 4 (phút/track) / 1.5 phút = 2.67 (lần đua/track).*

## **III. Car Rating và City CR Range**

CR (Car Rating) là chỉ số tổng hợp sức mạnh của xe — xe càng mạnh thì CR càng cao. 

- Mỗi một cấp CR đại diện cho một tập hợp các bộ chỉ số Raw Stats gồm 41 chỉ số vật lý của xe.
- CR được chia thành 19 cấp trong toàn Game từ CR0 —> CR18.
- CR tăng đều từ CR0 —> CR18.

Các xe được cấp mới ở các City có CR Range trải dài như dưới trong quá trình sử dụng và nâng cấp:

![alt text](images/progression-image-1.png)

Có thể thấy CR Range của các City gối đầu lên nhau, điều này có nghĩa người chơi có thể sử dụng xe từ một City và sử dụng ở các City sau nếu nâng cấp đầy đủ, đây là dụng ý của thiết kế.

*Bảng Mapping chỉ số khởi đầu của xe mới, được Unlock khi mở City mới:*

| City | CR khởi đầu của xe Unlock |
| --- | --- |
| 1 | CR0 |
| 2 | CR3 |
| 3 | CR6 |
| 4 | CR9 |
| 5 | CR12 |

## **IV. WINRATES CỦA NGƯỜI CHƠI THEO CITY**

WinRate (WR) là xác suất player về nhất trong một race — **đây là chỉ số thiết kế quan trọng nhất**, vì nó quyết định trực tiếp cảm giác chơi có "công bằng" hay không. Bảng dưới cho thấy WR giảm dần khi city và tier độ khó tăng lên, phản ánh game ngày càng thách thức hơn theo đúng thiết kế.

| City   | T(E) | RR(E) | WR(E) | T(M) | RR(M) | WR(M)    | T(H) | RR(H) | WR(H)    | Tổng lượt |
|--------|------|-------|-------|------|-------|----------|------|-------|----------|----------|
| City 1 | 15   | 0     | 0.90  | —    | —     | —        | —    | —     | —        | 15       |
| City 2 | 10   | 0.25  | 0.80  | 6    | 0.5   | 0.67     | 8    | 1.67  | 0.38     | 24       |
| City 3 | 13   | 0.62  | 0.62  | 12   | 2     | 0.50     | 10   | 2.34  | 0.30     | 35       |
| City 4 | 20   | 1.5   | 0.40  | 15   | 2.75  | 0.27     | 15   | 4     | 0.20     | 50       |
| City 5 | 30   | 2.75  | 0.27  | 25   | 5.25  | 0.16 (0.2) | 23 | 6.67 | 0.14 (0.2) | 78       |

**T = Số lần thắng cần đạt  |  RR = Số lần chơi lại trung bình  |  WR = WinRate mục tiêu**

City 1 có WinRates gần bằng 1 và tất cả các Track đều là Easy vì đây là City mở đầu, không cần thiết có các yếu tố độ khó làm cản trở người chơi.

### **Cơ chế Floor & Ceiling**

Để đảm bảo trải nghiệm không bao giờ trở nên quá dễ hoặc quá bất công, WinRate được giới hạn trong một khoảng cố định khi cân bằng:

| **Giới hạn** | **Giá trị** | **Ý nghĩa** |
| --- | --- | --- |
| **Floor (Sàn)** | 0.20 | Dù xe player yếu đến đâu, luôn có tối thiểu 20% cơ hội về nhất — tránh cảm giác tuyệt vọng. |
| **Ceiling (Trần)** | 0.90 | Dù xe player mạnh đến đâu, WR không vượt 90% — giữ lại chút rủi ro để mỗi race còn tính hấp dẫn. |

**WinRate thực tế = clamp(WR_tính_toán, 0.20, 0.90)**

Cơ chế Floor & Ceiling có nghĩa là dù tính toán WR(M) và WR(H) ở City 5 lần lượt là 0.16 và 0.14, ta vẫn sẽ luôn làm tròn con số đó lên 0.2.

### Cách tính WinRates

Trong một City, ta có cơ chế phân chia các Track thành các nhóm **Easy(E), Medium(M), Hard(H).** 

Thời gian Player dành cho các Track có thể xác định bằng cách phân phối tổng số lần chơi Target dành cho Player cho thành phố đó, từ đây có thể cân bằng số lượng Track E, M, H mỗi loại dựa trên số lần lặp lại các Track trong một nhóm.

Gọi tổng số lần chơi Target mà người chơi cần đạt được trong một City và các nhóm E, M, H là $T_{City(x)}$ , $T_{E(x)}$ , $T_{M(x)}$ , $T_{H(x)}$.

Số lượng Track E, M, H trong một City x lần lượt là $N_{City(x)}$ , $N_{E(x)}, N_{M(x)}, N_{H(x)}$.

Lấy ví dụ **City 2** trong các tính toán ở phần trước, ta có các dữ kiện:

- $N_{City(2)} =N_{E(2)} + N_{M(2)} + N_{H(2)} = 15(Tracks)$
    - $N_{E(2)} = 8(Tracks)$
    - $N_{M(2)} = 4(Tracks)$
    - $N_{H(2)} = 3(Tracks)$
    - Số lượng các Track mỗi loại Fix cứng cho tất cả các City.
    
- $T_{City2} = T_{E(2)} + T_{M(2)} + T_{H(2)} = 24(Lần)$
    - Phân phối 24 lần chơi cho 3 nhóm Track E, M , H theo các điều kiện dưới:
        - $\frac{T_E}{N_E} < \frac{T_M}{N_M} < \frac{T_H}{N_H}$
        - $\frac{T}{N} \ge 1$ hay $T \ge N$
    - Một tập hợp số T thỏa mãn điều kiện trên sẽ là:
        - $T_{E(2)} = 10 (Lần)$
        - $T_{M(2)} = 6(Lần)$
        - $T_{H(2)} = 8(Lần)$
    - Khi cân bằng thời gian chơi cho các Track, có thể tự do thay đổi các số T cho đúng ý đồ thiết kế.
    

Gọi tỉ lệ chơi lại của một nhóm Track E, M, H và City X lần lượt là: $RR_{E(x)}$, $RR_{M(x)}$, $RR_{H(x)}$, $RR_{City(x)}$

- Ta có mối liên hệ giữa T , N và RR sẽ là.
    - $T_{E(x)} = N_{E(x)} + N_{E(x)}*RR_{E(x)}$
        
        ⇒ $RR_{E(x)} = \frac{T_{E(x)} - N_{E(x)}}{N_{E(x)}}$
        
- Sử dụng các dữ kiện từ City 2 ở trên, ta tính được RR của 3 nhóm Track cùng các thông số khác:

| **Nhóm màn** | **Số màn (N)** | **Tổng lượt chơi (T)** | **Tỉ lệ chơi lại (RR)** |
| --- | --- | --- | --- |
| Easy | 8 | 10 | 0.25 |
| Medium | 4 | 6 | 0.5 |
| Hard | 3 | 8 | 1.67 |
|  | SUM = 15 | SUM = 24 |  |

Để kiểm soát tỉ lệ chơi lại, cần kiểm soát %WinRates của người chơi thông qua điều chỉnh A.I, có thể xác định %WinRate thông qua công thức:

$$
WR = \frac{Số Trận Thắng}{Tổng Số Trận Đua}
$$

Ở công thức này, Số trận thắng được tính bằng tổng số Track đua người chơi cần về nhất.

Trong một City, số Track đua người chơi cần về nhất được tính cố định là 15 Track, phân ra làm 8 Track Easy , 4 Track Medium và 3 Track Hard.

Tuỳ theo điều kiện thực tế, ta sẽ điều chỉnh số Track cần thắng.

**Ví dụ: Ta có thể tính WinRates của City 2, các Track Easy $WR_{E(2)}$ bằng công thức**

$$
WR_{E(2)} =\frac{8}{T_{E(2)}} = \frac {8}{10} = 0.8
$$

- Kết hợp các dữ kiện, ta có được bảng thông tin đầy đủ về Số lần chơi T, tỉ lệ chơi lại RR và %Winrate WR của City 2:

| **Nhóm màn** | **Số màn (N)** | **Tổng lượt chơi (T)** | **Tỉ lệ chơi lại (RR)** | Tỉ lệ thắng (WR) |
| --- | --- | --- | --- | --- |
| Easy | 8 | 10 | 0.25 | 0.8 |
| Medium | 4 | 6 | 0.5 | 0.67 |
| Hard | 3 | 8 | 1.67 | 0.375 |
|  | SUM = 15 | SUM = 24 |  |  |

### Bảng cân đối cho cả 5 City

| **City** | T(E) | RR(E) | WR(E) | T(M) | RR(M) | WR(M) | T(H) | RR(H) | WR(H) | **Tổng lượt đua (T)** |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **City 1** | 15 | 0 | 1 | 0 | 0 | 1 | 0 | 0 | 1 | 15 |
| **City 2** | 10 | 0.25 | 0.8 | 6 | 0.5 | 0.67 | 8 | 1.67 | 0.38 | **24** |
| **City 3** | 13 | 0.63 | 0.62 | 12 | 2 | 0.34 | 10 | 2.34 | 0.3 | 35 |
| **City 4** | 20 | 1.5 | 0.4 | 15 | 2.75 | 0.27 | 15 | 4 | 0.2 | 50 |
| **City 5** | 30 | 2.75 | 0.27 | 25 | 5.25 | 0.16 | 23 | 6.67 | 0.14 | 78 |

### Ý nghĩa của các con số RR và WR trong điều kiện thực tế:

Khi số liệu thực được trả về, nếu so sánh tỉ lệ RR thực và tỉ lệ RR giả thuyết có thể rút ra được nhưng thông tin sau:

- Người chơi có hoàn thành City trong giới hạn RR đề ra hay không? Nếu có tức là Design đang đi đúng hướng.
- Người chơi có tiếp tục tăng số RR lên sau khi đã hoàn thành mục tiêu trong City hay không? Nếu có tức là Design hấp dẫn với người chơi làm họ muốn chơi lại dù đã hoàn thành mục tiêu.
- Người chơi có hoàn thành City dưới tỉ lệ RR đề ra hay không? Nếu có tức là Design đang cân bằng chưa tốt làm Player phá đi Progression của Game.
- v.v

Với tỉ lệ WR, ta có thể rút ra được những thông tin sau:

- WR người dùng thấp hơn hẳn so với WR đã định —> Điều chỉnh A.I dễ hơn.
- WR người dùng cao hơn hẳn so với WR đã định —> Điều chỉnh A.I khó hơn.
- Kết hợp với tỉ lệ RR, nếu RR thấp hơn hẳn so với mục tiêu đề ra + WR thấp → Game quá khó và không đủ hấp dẫn với người chơi.
- v.v

## **V. AI và A.I Difficulty**

Độ khó của A.I trong một Track được xác định bằng tương quan CR xe người chơi đang sử dụng và CR gắn theo các Track Easy, Medium, Hard. 

Người chơi có thể thấy được độ khó của các Track khi đang chọn Track:

![alt text](images/progression-image-2.png)

Độ khó của Track sẽ được coi là tương đương với độ khó của A.I, được chia làm 2 phần:

- Sức mạnh thuần của xe A.I, được tính theo thang điểm CR.
- Khả năng kích hoạt các hành vi khác nhau trong khi đua.

### **Sức mạnh thuần của xe A.I được phân chia như sau trong mỗi City:**

![alt text](images/progression-image-3.png)

### A.I có các hành vi khác nhau hiện đang có In-Game:

- Chọn lựa Racing Line tối ưu hoặc 2 Racing Line hai bên.
- Quyết định OverTake hoặc Defence trong cuộc đua.
- Quyết định sử dụng NOS.
- Khả năng Rubberband.
- Reaction Delay.
- Brake sớm hay muộn.

### Đối với mỗi độ khó khác nhau, A.I sẽ kích hoạt các hành vi khác nhau trong khi đua, tạo khác biệt về mặt kỹ năng lớn:

*Bảng Mapping hành vi xe với A.I: (Chi tiết này sẽ chuyển qua tài liệu A.I)*

| Hành vi | Easy | Medium | Hard |
| --- | --- | --- | --- |
| Chọn lựa Racing Line tối ưu hoặc 2 Racing Line hai bên. | 5s check 1 lần, 55% cơ hội chọn đường tối ưu nếu không bị Block. | 5s check 1 lần, 65% cơ hội chọn đường tối ưu nếu không bị Block. | 5s check 1 lần, 75% cơ hội chọn đường tối ưu nếu không bị Block. |
| Quyết định OverTake hoặc Defence trong cuộc đua. | 50% cơ hội (A.I thụ động hơn) | 75% cơ hội (A.I cân bằng) | Mặc định (A.I Chủ động hơn) |
| Quyết định sử dụng NOS. | Khi NOS đầy, check 1s mỗi lần, 50% cơ hội kích hoạt. | Khi NOS đầy, check 1s mỗi lần, 75% cơ hội kích hoạt. | Luôn kích hoạt khi NOS đầy. |
| Khả năng Rubberband. | Có | Có | Có |
| Brake sớm hay muộn | Bình thường | Bình thường | Bình thường |
| Reaction Delay | Bình thường | Bình thường | Bình thường |

Trong giai đoạn sắp tới sẽ chỉ triển khai điều chỉnh 3 kỹ năng khác nhau dành cho A.I kết hợp với việc gán cấp độ CR cho A.I của mỗi thành phố. 

Các kỹ năng được triển khai là:

- Chọn lựa Racing Line tối ưu hoặc 2 Racing Line hai bên.
- Quyết định OverTake hoặc Defence trong cuộc đua.
- Quyết định sử dụng NOS.

### Một số bảng thông tin liên quan tới độ của A.I

*Bảng Mapping chỉ số CR xe với A.I, từ CR0 → CR18:*

| City | Easy | Medium | Hard |
| --- | --- | --- | --- |
| 1 | CR0 | CR1 | CR2 |
| 2 | CR3 | CR4 | CR5 |
| 3 | CR7 | CR9 | CR11 |
| 4 | CR10 | CR12 | CR14 |
| 5 | CR13 | CR15 | CR18 |

*Bảng Mapping độ khó với các Track đua hiện tại In-Game*

| Area | Track | Độ khó | WR |
| --- | --- | --- | --- |
| Sơn Trà | Sơn Trà Pass | Easy | 90% |
|  | Sơn Trà Circuit | Easy | 90% |
|  | Sơn Trà TimeAttack | Easy | 90% |
| Đà Nẵng DownTown | Downtown Sprint | Easy | 90% |
|  | Downtown Circuit | Easy | 90% |
|  | Downtown TimeAttack | Medium | 90% |
| Ngũ Hành Sơn | NHS Sprint | Easy | 90% |
|  | NHS Circuit | Medium | 90% |
|  | NHS TimeAttack | Hard | 90% |
| Hội An | Hội An Sprint | Easy | 90% |
|  | Hội An Circuit | Medium | 90% |
|  | Hội An TimeAttack | Hard | 90% |
| Đông Giang | Đông Giang Sprint | Easy | 90% |
|  | Đông Giang Circuit | Medium | 90% |
|  | Đông Giang TimeAttack | Hard | 90% |

Tất cả các City chưa có phân loại Area và Track rõ ràng, có thể Setup Debug một City ảo với chỉ cấu trúc tương tự như trên nhưng thay bằng các tên như Area#1, Track#1, v.v

## **VI. CAR PERFORMANCE DISTRIBUTION**

Sức mạnh xe tăng đều tuyến tính theo đồ thị tương tự như dưới:

![alt text](images/progression-image-4.png)

***Bảng  Full các bộ chỉ số từ CR0 → CR18:***

https://docs.google.com/spreadsheets/d/1WrIDkpVSNWITiHt1bge7HXtEYrDYEB4N/edit?gid=1551028689#gid=1551028689

## **VII. CASH & BẢNG TÍNH TOÁN EARN/SPEND (Chỉ từ Race Results)**

Cash là loại tài nguyên chính mà người chơi sử dụng để nâng cấp Performance và Visual của xe.

Phần thưởng Cash tối thiểu mà người chơi cần đạt được để vượt qua một City được phân bổ qua các nguồn khác nhau, đảm bảo việc người chơi trải nghiệm hết các Content đã được sản xuất chứ không chỉ tập trung vào việc tối ưu hóa thời gian chơi. 

Để tính được số tiền người chơi có thể Earn được thông qua các nguồn trong Game, cần tính được tổng số tiền cần thiết để nâng cấp qua một City, có 2 nguồn tiêu Cash trong Game gồm:

- Nâng cấp Performance của xe.
- Nâng cấp Visual của xe (Lắp đặt Part Visual).

### Nâng Cấp Performance

*Bảng chi phí nâng cấp Performance của xe, City 1:*

| **Level** | Chi phí nâng cấp 1 chỉ số | CP Nâng cấp cả 4 chỉ số | CP nâng cấp cộng dồn (Accumulated Cash) |
| --- | --- | --- | --- |
| Lv0 → Lv1 | $200 | $800 | $800 |
| Lv 1 → Lv2 | $400 | $1,600 | $2,400 |
| Lv2 → Lv3 (ĐK qua City mới) | $600 | $2,400 | $4,800 |
| Lv3 → Lv4 | $800 | $3,200 | $8,000 |
| Lv4 → Lv5 | $1,000 | $4,000 | $12,000 |
| lv5 → Lv6 | $1,200 | $4,800 | $16,800 |

Để vượt qua City mới, người chơi cần đạt được điều kiện nâng cấp hết tất cả chỉ số xe lên Lv3 (Tương ứng với CR3, điều kiện có thể thay đổi). 

Để nâng cấp hết tất cả chỉ số xe lên LV3 trong City 1, cần số lượng Cash nhất định khoảng **$4,800**

### Nâng cấp Visual

Mỗi Visual Part khi được Unlock sẽ cần bỏ ra một số tiền để gắn vào trong xe.

Người chơi chỉ cần trả tiền cho việc gắn Visual Part lên lần đầu.

*Bảng Tổng tiền nâng cấp Visual cho một xe:*

| **Hạng mục nâng cấp** | **Tổng số Part** | **Giá mỗi nâng cấp** | **Tổng số tiền nâng cấp Visual** |
| --- | --- | --- | --- |
| **Visual Part** | 18 | $50 | $900 |
| **Material** | 15 | $50 | $750 |
| **Decals** | 5 | $50 | $250 |
| **Sum** |  |  | $1,900 |

Ở City 1, tổng Spend của người chơi cả Performance + Visual =$4,800 + $1,900 = $6,700

### Spend Scaling theo City

Càng về các City sau, chi phí nâng cấp sẽ càng tăng theo số lần chơi thiết kế T(x):

**Công thức tính Scale:**

$$
ScaleIndex = \frac{T_{x}}{T_1} * CityIndex
$$

Trong đó ScaleIndex là hệ số nhân cần tính

Tỉ lệ T(x)/T(1) là tỉ lệ số lần chơi giữa City(x) và City(1).

CityIndex là thứ tự của thành phố

*Ví dụ:*

City 2 có T(2) = 24, CityIndex = 2 và T(1) = 15.

⇒ ScaleIndex(City2) = $\frac{24}{15}*2 = 3.2$

*Bảng Earn/Spend Scale theo City*

| **CityIndex** | **City** | **T** | **ScaleIndex** |
| --- | --- | --- | --- |
| 1 | City 1 | 15 | 1 |
| 2 | City 2 | 24 | 3.2 |
| 3 | City 3 | 35 | 7 |
| 4 | City 4 | 50 | 13.33333333 |
| 5 | City 5 | 78 | 26 |

*Bảng Chi phí nâng cấp theo City Scaling, chi tiết trong file [Excel **VNRacing_EconomyBalancer_V2**:](https://docs.google.com/spreadsheets/d/1v4kH9w7EC3lcQlSiGlJyZowZbMlNrvoGb5T44AXsGR8/edit?gid=1705421044#gid=1705421044)*

| **City** | **ScaleIndex** | Chi phí nâng cấp Base (Làm tròn Bội 25) | **Số Cash sẽ Spend.Yêu cầu qua màn tối thiểu (Nâng cấp 1 xe lên CR3)** |
| --- | --- | --- | --- |
| City 1 | 1 | $200 | $4,800 |
| City 2 | 3.2 | $650 | $15,600 |
| City 3 | 7 | $1,400 | $33,600 |
| City 4 | 13.33333333 | $2,675 | $64,200 |
| City 5 | 26 | $5,200 | $124,800 |

### Tổng tiền Player có thể Earn được và Bù đắp thâm hụt

- Trong điều kiện thực tế, người chơi có thể về đích ở vị trí bất kỳ từ 1 → 4+, số tiền người chơi có thể Earn được thông qua việc đua xe sẽ luôn nhỏ hơn hoặc bằng số tiền dự kiến.
- Dựa trên thâm hụt thực tế khi ra mắt Game, ta có thể điều chỉnh tổng số tiền người chơi có thể Earn được lên bằng với số % tương ứng thâm hụt.
- Trước mắt, để phòng tránh trường hợp thâm hụt xảy ra, ta sẽ cộng thêm 20% số tiền CashEarn của người chơi:

***Bảng tổng số Cash trao thưởng dự kiến:***

| **City** | **Số Cash sẽ Spend.Yêu cầu qua màn tối thiểu (Nâng cấp 1 xe lên CR3)** | **Số Cash sẽ được trao thưởng**  |
| --- | --- | --- |
| City 1 | $6,700 | $8,040 |
| City 2 | $17,500 | $21,000 |
| City 3 | $35,500 | $42,600 |
| City 4 | $66,100 | $79,320 |
| City 5 | $126,700 | $152,040 |

### Các nguồn mà Player có thể Earn được Cash

Các nguồn mà người chơi có thể lấy được Cash bao gồm:

- RaceCash: Lấy trực tiếp từ thành tích đua.
- FS Cash: Cash từ việc hoàn thành nhiệm vụ phụ trong khi đua.
- Others: Cash từ các nguồn khác (Tokens, Achievements, CityGoals, …)
- First Time Bonus + First WinBonus: Tiền thưởng thêm khi người chơi lần đầu thắng/về đích một Track.

*Bảng phân bố các nguồn Cash:*

| **CashEarnTotal** | **RaceCash** | **FanService Cash** | **Others** | First Time Bonus + First Win Bonus |
| --- | --- | --- | --- | --- |
| 100% | 60% | 10% | 30% | 50% Race Cash |

| **City** | **Số Cash sẽ được trao thưởng**  | **RaceCash** | **FanService Cash** | **Others** | First Time Bonus + First Winbonus | Cash phân phối cho các vị trí về đích (PPCash) |
| --- | --- | --- | --- | --- | --- | --- |
| City 1 | $8,040 | $4,824 | $804 | $2,412 | $2,412 | $2,412 |
| City 2 | $21,000 | $12,600 | $2,100 | $6,300 | $6,300 | $6,300 |
| City 3 | $42,600 | $25,560 | $4,260 | $12,780 | $12,780 | $12,780 |
| City 4 | $79,320 | $47,592 | $7,932 | $23,796 | $23,796 | $23,796 |
| City 5 | $152,040 | $91,224 | $15,204 | $45,612 | $45,612 | $45,612 |

*Note: RaceCash được chia ra làm 2 phần, phục vụ cho các phần thưởng FirstTimeBonus + First WinBonus*

### Earn theo thứ hạng về đích trong cuộc đua (1, 2, 3, 4+)

Từ Race Cash ở trên, ta tính được số tiền người chơi có thể nhận được khi về nhất trong City 1:

$$
RaceCash_{P1} = \frac{PPCash}{Tổng lượt đua(T)}
$$

⇒ $RaceCash_{P1} = \frac{2412}{15} = 161$ ($)

Giảm dần tiền thưởng cho các vị thứ sau với bậc giảm 20%:

|  | Vị thứ 1 | Vị thứ 2
(Tiền thưởng = 80%) | Vị thứ 3
(Tiền thưởng = 60%) | Vị thứ 4+
(Tiền thưởng = 40%) | First TimeBonus | First WinBonus |
| --- | --- | --- | --- | --- | --- | --- |
|  | $161 | $129 | $96 | $64 | $80 | $80 |

Làm tròn các phần thưởng Cash theo Bội 25, , ta có tiền thưởng người chơi có thể nhận được ở các vị trí 2, 3, 4:

|  | Vị thứ 1 | Vị thứ 2(Tiền thưởng = 80%) | Vị thứ 3(Tiền thưởng = 60%) | Vị thứ 4+(Tiền thưởng = 40%) | First TimeBonus | First WinBonus |
| --- | --- | --- | --- | --- | --- | --- |
|  | 175 | 150 | 100 | 75 | 100 | 100 |

***Số tiền trao thưởng cho người chơi ở mỗi City theo vị thứ đua (L:àm tròn lên theo Bội số 25):***

| **City** | T | **P1** | **P2** | **P3** | **P4+** | **DNF** | First TimeBonus | First WinBonus |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| City 1 | 15 | 175 | 150 | 100 | 75 | 0 | 100 | 100 |
| City 2 | 24 | 275 | 225 | 175 | 125 | 0 | 225 | 225 |
| City 3 | 35 | 375 | 300 | 225 | 150 | 0 | 450 | 450 |
| City 4 | 50 | 500 | 400 | 300 | 200 | 0 | 800 | 800 |
| City 5 | 78 | 600 | 475 | 375 | 250 | 0 | 1525 | 1525 |

### New Race Bonus - Cơ chế khuyến khích người chơi đua các Track mới liên tục

- Để khuyến khích người chơi thử Track mới liên tục, kết quả tính Rewards Cash ở cuối cuộc đua sẽ được thêm 2 hạng mục trao thưởng:
    - ***First Time Bonus:*** Trao thưởng khi người chơi về đích một Track lần đầu.
    - ***First Win Bonus:*** Trao thưởng khi người chơi chiến thắng một Track lần đầu.
- Cả hai hạng mục này **chỉ trao thưởng 1 lần cho một Track,** tức là trong một City người chơi có thể nhận mỗi hạng mục này 15 lần.

![alt text](images/progression-image-5.png)

*Ví dụ First Time Bonus & First Win Bonus*

***Bảng trao thưởng First Time Bonus & First Win Bonus theo từng City:***

| City | **First TimeBonus** | **First WinBonus** |
| --- | --- | --- |
| City 1 | 100 | 100 |
| City 2 | 225 | 225 |
| City 3 | 450 | 450 |
| City 4 | 800 | 800 |
| City 5 | 1525 | 1525 |

### **Race Farm Decay — Cơ chế ngăn người chơi Spawn một Track đua duy nhất (Tạm thời Hold, chưa làm)**

Để ngăn player chọn một track dễ và đua lặp đi lặp lại để tích lũy Cash nhanh, game áp dụng cơ chế Cash Decay theo Session . 

Mỗi khi player đua cùng một track liên tiếp trong cùng một phiên chơi, phần thưởng Cash sẽ giảm dần theo một hệ số nhân (multiplier). Multiplier này reset về mức ban đầu khi bắt đầu session mới vào ngày hôm sau (Reset 24h).

$DecayMult(finish, best) =$ 

- $1.0   nếu finish > best   (New Best)$
- $0.5   nếu finish = best   (Bằng Best)$
- $0.3   nếu finish < best   (Kém hơn Best)$

$ActualRaceCash = RaceCash(c) × DecayMult(finish, best)$

$ActualFanCash  = FanCash(c)  × DecayMult(finish, best)$

Cơ chế này có hai tác dụng song song: 

- Buộc player đổi track thường xuyên để duy trì earn rate tối ưu, và tự nhiên phân tán lượt chơi ra nhiều track.
- Player khám phá nhiều nội dung hơn mà không cần game phải hard-lock hay hiển thị cảnh báo.

### ***Bảng tổng kết***

| **City** | **Playtime (phút)** | TotalSpend  (Dự đoán tối thiểu) | TotalEarn (Dự đoán) | **Trung bình Cash nhận được mỗi phút chơi. (Earn Per Minutes)** |
| --- | --- | --- | --- | --- |
| City 1 | 22.5 | $11,960 | $14,352 | $638 |
| City 2 | 36 | $38,272 | $45,926 | $1,276 |
| City 3 | 51 | $83,720 | $100,464 | $1,970 |
| City 4 | 75 | $159,467 | $191,360 | $2,551 |
| City 5 | 115.5 | $310,960 | $373,152 | $3,231 |

## **VIII. CÁC KÊNH TRAO THƯỞNG**

Không phải mọi phần thưởng đều đến từ việc thắng race — game có 5 nguồn phần thưởng độc lập để đảm bảo player có nhiều lý do để chơi theo nhiều cách khác nhau.

| **STT** | **Kênh** | **Mô tả** | **RewardType** |
| --- | --- | --- | --- |
| 1 | Post-Race Rewards | Phần thưởng sau mỗi race | Cash + Items + Fan Service |
| 2 | Goal Rewards | Hoàn thành mục tiêu trong city | Cash + Items + Car Unlock |
| 3 | City Completion (All Goals) | [Hoàn thành 100% city](https://upload-os-bbs.hoyolab.com/upload/2022/09/22/212291323/2a9551b575d7868eb105f08d5c09b24b_7784089654434065463.png?x-oss-process=image%2Fresize%2Cs_1000%2Fauto-orient%2C0%2Finterlace%2C1%2Fformat%2Cwebp%2Fquality%2Cq_70) | Cash + Items + Car Unlock |
| 4 | Achievement | Mốc tiến trình cá nhân | Cash + Items + Car Unlock |
| 5 | Loot Crate | Mở thùng phần thưởng ngẫu nhiên | Cash + Items |

## **IX. CÁC LOẠI PHẦN THƯỞNG (RewardType)**

Các loại phần thưởng được lưu trữ ở hai nơi khác nhau trong hệ thống là Inventory và Wallet. 

Một trường hợp cần lưu ý là Cash và Fuel là giá trị số đơn giản trong Wallet, trong khi CurrencyItem là một "gói chưa mở" chỉ chuyển thành tiền khi player chủ động sử dụng trong Inventory.

| **RewardType** | **Mô tả** | **Lưu trữ tại** |
| --- | --- | --- |
| Currency (Cash) | Tiền mặt, cộng trực tiếp vào Wallet | PlayerState.Wallet.cash |
| Currency (Fuel) | Nhiên liệu, cộng trực tiếp vào Wallet | PlayerState.Wallet.fuel |
| Item (Performance) | Part nâng cấp xe | PlayerState.Inventory |
| Item (Visual) | Part trang trí xe, không tăng CR | PlayerState.Inventory |
| CurrencyItem | Item chuyển thành tiền khi player dùng | PlayerState.Inventory |
| Car | Xe mới unlock vào Garage | PlayerState.Garage |

## **X. CƠ CHẾ GOALS**

Goals là hệ thống nhiệm vụ cố định của mỗi city. Mục tiêu là dẫn dắt Player đi qua từng giai đoạn phát triển của city một cách tự nhiên, mà không cần hướng dẫn tường minh. Goal cuối cùng của mỗi city đồng thời là điều kiện mở khóa city tiếp theo.

Goals đồng thời cũng đóng vai trò là cơ chế thúc đẩy người chơi phải trải nghiệm hết Content của Game.

## **Cơ chế Random Goal Pool & Luồng tiến trình**

- Goal được phân ra làm 3 Tiers, có thể hoàn thành theo thứ tự hoặc không theo thứ tự.
- Tier 3 là mục tiêu quan trọng nhất để Unlock City mới, sẽ gắn chặt với điều kiện CR yêu cầu để qua City mới.
- Mỗi Tier không có một Goal cố định — Goal được rút ngẫu nhiên từ một pool gồm nhiều loại nhiệm vụ (Upgrade, Race, Explore, Collection...).
- Tại bất kỳ thời điểm nào, chỉ có đúng một Goal xuất hiện trong mỗi Tier.

**Note:  Mỗi lần chơi lại (hoặc mỗi player khác) sẽ có hành trình khác nhau qua cùng một city, tăng tính đa dạng mà không tăng khối lượng thiết kế.**

![alt text](images/progression-image-6.png)

## **Mapping 3 Tier Goals theo CR Range**

| Tier | CR Range (City) | Mục đích | Rewards | Goals |
|---|---|---|---|---|
| Tier 1 | LV.0 → LV.1 | Làm quen core loop, khám phá city. Chơi hết Track Easy, nâng cấp xe. | 20% Cash từ nguồn Others trong tổng City Reward (807$) + Random Common Visual Parts x3 | • Nâng cấp 3 lần cho 1 xe bất kỳ trong City.<br>• Thắng 3 Races trong city.<br>• Thắng toàn bộ các Track Easy<br>• Về nhất bằng 2 chiếc xe khác nhau trong cùng City. |
| Tier 2 | LV.1 → LV.2 | Đầu tư sâu hơn, gắn bó với city. Chơi hết Track Medium, nâng cấp xe. | 30% Cash từ nguồn Others trong tổng City Reward (1209$) + Random UnCommon Visual Parts x3 | • Nâng một xe bất kỳ lên CR2<br>• Thắng 12 Races trong city<br>• Hoàn thành tất cả tracks có độ khó Medium<br>• Nâng 2/3 xe trong city lên CR LV1+ |
| Tier 3 | LV.2 → LV.3 | Làm chủ city, mở cổng city mới. Chơi hết Track Hard. | 40% Cash từ nguồn Others trong tổng City Reward (1612$) + Random Rare Visual Parts x3 + Performance Part (ccp_import_all_0001) x4 + Unlock City mới | • Nâng cả 4 stats trên 1 xe lên Lv3 (Speed, Acce, Grips, NOS)<br>• Về nhất tất cả tracks Hard.<br>• Về nhất 100% tất cả tracks (E/M/H) |
|

## **Tại sao 3 options Tier 3 đều equivalent CR LV.3**

| **Condition** | **Tại sao = CR LV.3** |
| --- | --- |
| **Nâng cả 4 stats lên Lv.3** | Nâng cả 4 Stats lên Lv.3 thì CR = 3 |
| **Về nhất tất cả Hard** | Hard tracks được calibrate cần CR ~LV.2–3 để về nhất. Cần playtest verify. |
| **Về nhất 100% tracks** | Bao gồm tất cả Hard tracks + Easy + Medium. Nếu đã về nhất Hard thì CR chắc chắn ~LV.3. |

## Hiển thị tiến độ trên Screen với các Goals

- **Dạng Check Box:**

![alt text](images/progression-image-7.png)

- **Dạng Counter:**

![alt text](images/progression-image-8.png)

***Bảng Goals và hiển thị Progress tương ứng trên Screen:***

| Goals | Hiển thị |
| --- | --- |
| Nâng cấp 3 lần cho 1 xe bất kỳ trong City.
 | Checkbox  |
| Thắng 3 Races trong city. | Counter |
| Thắng toàn bộ các Track Easy | Counter |
| Về nhất bằng 2 chiếc xe khác nhau trong cùng City. | Counter |
| Nâng một xe bất kỳ lên CR2 | Checkbox |
| Thắng 12 Races trong city | Counter |
| Hoàn thành tất cả tracks có độ khó  Medium | Counter |
| Nâng 2/3 xe trong city lên CR LV.1+ | Counter |
| Nâng cả 4 stats trên 1 xe lên Lv3 (Speed, Acce, Grips, NOS) | Checkbox |
| Về nhất tất cả tracks Hard. | Counter |
| Về nhất 100% tất cả tracks (E/M/H) | Counter |

## **XI. HỆ THỐNG TRAO THƯỞNG VÀ TOKENS**

- Hệ thống trao thưởng của Game rút Item từ một Pool trao thưởng để tặng cho Player.
    - Ví dụ: Hoàn thành cuộc đua ở vị trí đầu tiên được thưởng 3 Items ngẫu nhiên, hoàn thành các Goals ở một City được thưởng 5 Items ngẫu nhiên.
- Pool trao thưởng là Unique cho mỗi City, đi liền với các xe mà người chơi Unlock được trong City đó.
- Mỗi lượt nhận Item thưởng được gọi là 1 Token thưởng.

![alt text](images/progression-image-9.png)

### **XI.1. Token là hệ thống Random — không đảm bảo tài nguyên nâng cấp**

- Token là hệ thống ngẫu nhiên, không có cam kết về kết quả cụ thể.
- Player có thể đua nhiều race và nhận toàn Visual Items, hoặc nhận Performance Items sớm hơn kỳ vọng.
- Đây là lý do hệ thống Goals đóng vai trò là kênh đảm bảo tài nguyên tối thiểu. Goals luôn trao đúng loại và đủ lượng Performance Parts cần thiết cho từng giai đoạn CR — bất kể player may mắn hay xui xẻo với Token Pool.
    - **Token Pool  -->  Random Visual/Perf/Currency  -->  Hiệu ứng kích thích khám phá, chơi tiếp.**
    - **Goals       -->  Performance Parts có kiểm soát  -->  Đảm bảo tiến trình tối thiểu cho người chơi.**

Cách kết hợp này phục vụ hai mục tiêu song song: 

- Kiểm soát nhịp độ tiến trình (player không thể rush CR chỉ bằng may mắn với Token)
- Hạ thấp rào cản cho người chơi mới (ai cũng đủ tài nguyên để chơi tiếp nếu hoàn thành Goals).

### **XI.2. Vai trò chính của Token — Visual Progression**

Token Random chủ yếu phục vụ hệ thống Visual của xe — với pool 141 Visual Items mỗi city, Token tạo ra vòng lặp khám phá liên tục: mỗi lần mở là một phần thưởng mới cho bộ sưu tập, khuyến khích player tiếp tục đua ngay cả khi CR đã đủ để tiến tới City tiếp theo. 

Đây là một trong những động lực giữ player ở lại trong một city.

## **XII. CÁC ITEMS TRONG POOL TRAO THƯỞNG TOKENS**

Khi Token được dùng để mở phần thưởng, các Item được cho ra theo tỉ lệ có kiểm soát. 

Visual Items chiếm tỉ lệ cao nhất vì đây là nội dung phong phú nhất và ít ảnh hưởng đến balance; Performance Items ít hơn để tránh player nâng cấp xe quá nhanh chỉ nhờ may mắn.

| **Type** | **Weight (Tỉ lệ rơi)** | Số lượng Item có thể Unlock trong 1 City | **Giải thích** |
| --- | --- | --- | --- |
| **Visual** | 50 | 138 | Pool lớn nhất (138 items/city), ưu tiên cosmetic progression |
| **Performance** | 35 | 35 | Pool nhỏ hơn (32 items/city), không guaranteed |
| **Currency** | 15 | 15 | Fallback ổn định, luôn có giá trị |
| **Tổng** | **100** | 191 |  |

**Bảng Item:**
https://docs.google.com/spreadsheets/d/1uq2kATX7q-OH0t-qpyCIlaAARKaOeLNz4ybDVNtzqJI/edit?gid=1621370858#gid=1621370858
