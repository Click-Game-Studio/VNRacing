# RACER A.I

*GDD Overview các hành vi của Racer A.I.*

## Change Log

- **First Version (20250809)**

- **Ver2 (20250813)**
  - Điều chỉnh lại mô tả các hành vi của A.I thông qua bốn kiểu hành động chính (Acceleration, Drift, Steer, NOS Use).

- **Ver3 (20250828)**
  - Thêm một số đặc điểm cho hành vi Rubberband của A.I

- **Ver4 (20251105)**
  - Chỉnh sửa cấu trúc văn bản.
  - Thêm mục định hướng lấy Data cho A.I.
  - Liệt kê 3 Profiles của A.I.
  - Chia các State cho Racer AI.
  - Liệt kê các yếu tố ảnh hưởng tới hành vi A.I
  - Liệt kê chức năng A.I có thể thực hiện

- **Ver5 (20251110)**
  - Chỉnh sửa cấu trúc văn bản.
  - Thêm phần định nghĩa cho Racing Line của A.I
  - Thêm tính năng A.I Follow Racing Lines.
    - Tính năng A.I Follow Racing Line Offset.
  - Chỉnh sửa khả năng dùng NOS của A.I theo các Racing Lines.
  - Thêm khả năng Overtake và Defence của A.I
  - Tích hợp Profiles của A.I theo các phần đã chỉnh sửa.
  - Bổ sung Generate tên tự động cho A.I theo Profiles.

---

# Gameplay Concepts

## Concepts

- A.I được dẫn đường bởi các Racing Lines đặt sẵn trong Track đua.
- Trong quá trình đua, A.I có thể đổi qua lại giữa các Racing Lines.
- A.I biết xử lý va chạm riêng biệt khi:
  - Va chạm với người chơi.
  - Va chạm với A.I khác.
  - Va chạm với môi trường.
- A.I có thể tự đưa ra quyết định dùng NOS, Overtake và Defence.
- Performance của A.I được xử lý linh hoạt thông qua cơ chế RubberBand.
- Các xử lý của A.I trong cuộc đua phụ thuộc vào Profile mà nó được gán khi vào trận:
  - Easy
  - Medium
  - Hard
- Tùy theo Profile mà tên của chúng sẽ được Generate tự động.

## Các Mechanics & Định nghĩa Liên quan cần phát triển

| Tên Mechanics | Phân loại |
|---|---|
| Dẫn đường bằng Racing Lines cho A.I. | Racer A.I |
| Các hành vi của A.I khi di chuyển trên Racing Line | Racer A.I |
| Normal Driving và Offset cho A.I di chuyển theo RacingLine | Racer A.I |
| A.I quyết định Overtake & Defence | Racer A.I |
| Độ khó của Track đua và A.I | Racer A.I |
| Generates tên theo độ khó của A.I | Racer A.I |
| A.I Rubberband | Racer A.I |

---

# Game Mechanics

## Dẫn đường bằng Racing Lines cho A.I.

- Trên Track đua có đặt sẵn các Racing Line.
- A.I sử dụng các Racing Lines được sắp đặt sẵn trong Track đua, kết hợp với các chỉ số Performance để tham gia cuộc đua với người chơi.
- Nguyên tắc đặt Racing Line: *(Đẩy phần này qua tài liệu Level Design khi xong.)*
  - Trong Track đua sẽ có khoảng 3 Racing Lines tùy theo tính chất và độ rộng trung bình của đường đua.
  - Lấy một Racing Line ở giữa làm chuẩn, gọi là **MainRacingLine**, đây là đường đua **tốt nhất có thể có trong Track.**
  - Tạo một Racing Line, gọi là **InsideRacingLine**, đây là đường đua khiến A.I luôn cố cua ở góc hẹp hơn so với **MainRacingLine**.
  - Tạo một Racing Line, gọi là **OutsideRacingLine**, đây là đường đua khiến A.I luôn cố cua ở góc rộng hơn so với **Main RacingLine**.

### Racing Line Layout Diagram

```mermaid
graph TB
    A["🏁 Track Đua"] --> B["3 Racing Lines"]
    B --> C["MainRacingLine<br/>Tốt nhất"]
    B --> D["InsideRacingLine<br/>Góc Hẹp"]
    B --> E["OutsideRacingLine<br/>Góc Rộng"]
    
    C -.->|Chuẩn| D
    C -.->|Chuẩn| E
    
    D -.->|So sánh| E
    
    style C fill:#ffdd00,stroke:#333
    style D fill:#87ceeb,stroke:#333
    style E fill:#90ee90,stroke:#333
```

*Ví dụ các Racing Line đặt trên đường*

---

## Các hành vi của A.I khi di chuyển trên Racing Line

- Tùy theo tình hình thực tế trong cuộc đua, A.I có thể có các kỹ năng sau trong khi đua:
  - **Normal Driving**
  - **Né tránh Obstacle**
  - **Overtake**
  - **Defences**
  - **Sử dụng NOS**

- A.I sẽ tự động kiểm tra tuần tự các điều kiện kích hoạt của các kỹ năng, được biểu diễn trong cây sơ đồ ở dưới.

### Decision Tree của A.I

```mermaid
graph TD
    A["Global Cooldown<br/>Hết ?"] -->|Không| B["Normal Driving"]
    A -->|Có| C["Kiểm tra Điều kiện"]
    
    C --> D["Nhánh Trái<br/>Ưu tiên 1"]
    C --> E["Nhánh Phải<br/>Có thể kích hoạt"]
    
    D --> D1["Né tránh<br/>Obstacle"]
    D --> D2["Overtake"]
    D --> D3["Defences"]
    
    E --> E1["Sử dụng<br/>NOS"]
    
    D1 --> F{Thành công?}
    D2 --> F
    D3 --> F
    
    F -->|Có| G["Kích hoạt<br/>Kỹ năng"]
    F -->|Không| H["Kiểm tra tiếp"]
    
    E1 --> I{Có điều kiện?}
    I -->|Có| J["Kích hoạt NOS<br/>Đồng thời"]
    
    G --> K["Global Cooldown"]
    J --> K
    H --> B
    
    style A fill:#ff6b6b
    style B fill:#51cf66
    style K fill:#ff6b6b
```

**Giải thích cây sơ đồ lựa chọn:**

- Sơ đồ các lựa chọn của A.I gồm hai nhánh.
- Tới Node lựa chọn nào thì kiểm tra điều kiện của Node lựa chọn đó.
- Node **Normal Driving** luôn được kích hoạt theo mặc định, trừ khi có các Node ở nhánh bên trái được kích hoạt.
- A.I kiểm tra cùng lúc cả hai nhánh, số thứ tự và mũi tên là mức độ ưu tiên kiểm tra:
  - **Ví dụ 1**: Cùng một lúc có thể kiểm tra cả hai Node **Sử dụng NOS** và **Né tránh Obstacle**.
  - **Ví dụ 2**: Kiểm tra tuần tự từ Node **Né tránh Obstacle** → Node **Overtake** → Node **Defences**
- Nếu nhánh bên trái có điều kiện thỏa mãn thì lập tức kích hoạt lựa chọn, không cần kiểm tra các điều kiện sau.
- Nhánh bên phải và nhánh bên trái có thể kích hoạt đồng thời cùng lúc:
  - **Ví dụ**: Sử dụng NOS khi đang né Obstacle.
- Nhánh bên trái khi có Node được kích hoạt thành công sẽ phải đợi **Global Cooldown** chạy hết mới có thể tiếp tục kích hoạt lại.

---

## Normal Driving và Offset cho A.I di chuyển theo RacingLine

- Khi ở Mode Normal Driving, xe đi theo Main Racing Line.
- Để tránh tình trạng A.I chạy nối đuôi khi đi cùng một Racing Line, A.I sẽ cố tình điều chỉnh hướng chạy để hơi Offset ra khỏi Racing Line một chút.
- Gọi Khoảng cách Offset là **D**

**Công thức Offset:**

\[ D = \text{Random}[(-a) - a] \]

Với \(a = \frac{1}{2}\) (Khoảng cách từ RacingLine hiện tại tới RacingLine gần nhất).

- \(a\) dương thì xe Offset qua phải
- \(a\) âm thì xe Offset qua trái

- Chức năng **Offset** được kích hoạt tính toán lại từ đầu mỗi khi A.I đổi Racing Line.
- Chức năng **Offset** bị Disable khi A.I thực hiện các kỹ năng **Né tránh Obstacles**, **Overtake và Defences**.

---

## A.I quyết định Overtake & Defence

### Overtake

#### Tình huống kích hoạt:

- **Xe A** chạy hết **Cooldown Global**.
- **Xe A** kiểm tra trong khoảng 15 mét về phía trước, kiểm tra tốc độ xe gần nhất **(Xe B)**.
- Nếu **Xe A** có tốc độ hiện tại lớn hơn tốc độ hiện tại của xe **Xe B** thì **Xe A** kích hoạt tính xác suất kích hoạt.
- **Xe A** tính xác suất kích hoạt tùy theo độ khó của **A.I Profiles** được gắn cho nó:
  - Easy: 20% kích hoạt thành công.
  - Normal: 50% kích hoạt thành công.
  - Hard: 80% kích hoạt thành công.
- Nếu **Xe A** tính xác suất kích hoạt thành công thì kích hoạt hiệu ứng Overtake.

#### Hiệu ứng khi kích hoạt (Kéo dài trong **3 giây**):

- **Xe A** kiểm tra các Racing Line và lọc ra Racing Line không có **Xe B**.
- **Xe A** di chuyển qua Racing Line gần nhất không có **Xe B**.
- **Xe A** được tạm thời Boost tốc độ lên khoảng 120% Acceleration hiện tại.

#### Kết quả tình huống:

- Nếu **Xe A** vượt qua được **Xe B** thì Overtake thành công.
- Nếu **Xe A** bị va chạm trong lúc đang Overtake thì vẫn tiếp tục giữ nguyên hiệu ứng kích hoạt cho tới khi hết thời gian kích hoạt.
- Nếu **Xe A** không thể vượt qua **Xe B** khi hiệu ứng kích hoạt kết thúc thì kích hoạt lại hiệu ứng đối với **Xe A** nhưng giảm thời gian kích hoạt xuống còn **2 giây**. Nếu Xe A vẫn không thể vượt được Xe B sau khi kích hoạt lại hiệu ứng thì kết thúc **Overtake**.

#### Hiệu ứng khi kết thúc kích hoạt:

- Hiệu ứng Boost tốc độ giảm dần về bình thường trong vòng 2 giây.
- Kết thúc hiệu ứng.
- Chạy **CoolDown Global** trong khoảng từ **[3 - 5]** giây.

### Defences

#### Tình huống kích hoạt:

- **Xe A** chạy hết **Cooldown Global**.
- **Xe A** kiểm tra trong khoảng 15 mét về phía sau, kiểm tra tốc độ xe gần nhất **(Xe B)**.
- Nếu **Xe A** có tốc độ hiện tại nhỏ hơn tốc độ hiện tại của xe **Xe B** thì **Xe A** kích hoạt tính xác suất kích hoạt.
- **Xe A** tính xác suất kích hoạt tùy theo độ khó của **A.I Profiles** được gắn cho nó:
  - Easy: 40% kích hoạt thành công.
  - Normal: 70% kích hoạt thành công.
  - Hard: 90% kích hoạt thành công.
- Nếu **Xe A** tính xác suất kích hoạt thành công thì kích hoạt hiệu ứng Defences.

#### Hiệu ứng khi kích hoạt (Kéo dài trong **3 giây**):

- **Xe A** kiểm tra các Racing Line và lọc ra Racing Line có **Xe B**.
- **Xe A** di chuyển qua Racing Line có **Xe B**.

#### Kết quả tình huống:

- Nếu **Xe A** va chạm với **Xe B** thì Defence thành công, kết thúc kích hoạt.
- Nếu **Xe A** bị va chạm trong lúc đang Defences thì vẫn tiếp tục giữ nguyên hiệu ứng kích hoạt cho tới khi hết thời gian kích hoạt.

#### Hiệu ứng khi kết thúc kích hoạt:

- Kết thúc hiệu ứng.
- Chạy **CoolDown Global** trong khoảng từ **[3 - 5]** giây.

---

## Độ khó của Track đua và A.I

- Có ba loại độ khó của Track đua:
  - Easy (Dễ nhất)
  - Medium
  - Hard (Khó nhất)

- Có ba loại độ khó của A.I:
  - Rookie (Dễ nhất)
  - Racer
  - Pro (Khó nhất)

- Độ khó của Track đua quyết định các yếu tố:
  - Có bao nhiêu A.I ở độ khó cao được thêm vào trận đấu.

- Độ khó của A.I quyết định:
  - Scale chỉ số Performance của A.I đối với người chơi.
  - Tính xác suất thực hiện các kỹ năng trong lúc đua.

### Bảng phân chia độ khó của A.I trong Track

| Độ khó của Track | Số lượng A.I Rookie | Số lượng A.I Racer | Số lượng A.I Pro |
|---|---|---|---|
| **Easy** | 80% | 20% | 0% |
| **Medium** | 50% | 25% | 25% |
| **Hard** | 0% | 50% | 50% |

### Bảng Scale Performance của xe A.I theo người chơi

| Độ khó của A.I | Performance Scale Factor |
|---|---|
| **Easy** | 90% |
| **Medium** | 100% |
| **Hard** | 110% |

---

## Generates tên theo độ khó của A.I

- Tùy theo độ khó của A.I, tên hiển thị của các A.I trong cuộc đua có thể khác nhau.
- Chọn một cái tên bất kỳ theo độ khó mỗi khi vào trận

| EASY A.I | MEDIUM A.I | HARD A.I |
|---|---|---|
| Phuoc Razor | Marcus Steel | Rafael Wraith |
| Liam Dash | Lena Rogue | Naomi Lynx |
| Jake Sparks | Darius Fang | Phu Viper |
| Ava Frost | Ivy Surge | Aya Ignis |
| Ryan Jet | Noah Vector | Victor Razor |
| Ella Blaze | Kira Volt | Son Cyclone |
| Leo Flash | Ethan Comet | Damien Reaper |
| Nora Loop | Camila Torque | Lucia Vector |
| Evan Glide | Jaden Phantom | Owen Thunder |
| Sophie Boost | Tara Axis | Hana Zephyr |

---

## Cơ chế tự động cân bằng độ khó - Rubber Banding

- Cơ chế Tự động cân bằng (**Rubber Banding**) cho phép các AI Racers giữ được khoảng cách so với người chơi, khiến cuộc đua có cảm giác thú vị và cân bằng hơn.
- Cơ chế này được kích hoạt thông qua khoảng cách từ mỗi A.I tới người chơi, về cơ bản có các điểm sau:
  - Càng bị người chơi bỏ xa thì Performance xe và Skill của Racer A.I sẽ càng tăng.
  - Càng bỏ xa người chơi thì Performance xe và Skill của Racer A.I sẽ càng giảm.
  - Nếu nằm trong khoảng cách gần với xe của người chơi thì hiệu ứng **RubberBand** sẽ bị ngắt.

### Biểu đồ Rubber Banding - Khoảng cách và Performance

```mermaid
graph LR
    A["Player<br/>Vị trí"] -->|Khoảng cách| B["A.I Được Bỏ Xa"]
    A -->|Khoảng cách| C["A.I Gần"]
    
    B --> B1["Performance ⬆️<br/>Skill ⬆️<br/>RubberBand Kích hoạt"]
    C --> C1["Performance ⬇️<br/>Skill ⬇️<br/>RubberBand Ngắt"]
    
    D["Khoảng cách Ngang Nhau<br/>Khoảng cách Gần"] -->|→| E["RubberBand Ngắt"]
    
    style B1 fill:#ff6b6b,stroke:#333
    style C1 fill:#51cf66,stroke:#333
    style E fill:#ffd43b,stroke:#333
```

- Biểu đồ ở dưới thể hiện mối quan hệ khoảng cách và cơ chế kích hoạt **Rubber Banding**

---

## Các trường hợp đặc biệt khi áp dụng cân bằng độ khó - Rubber Banding

### Các trường hợp Disable tạm **Rubber Banding**:

- Để đảm bảo các xe được phân tán đều và không bị dính chùm khi bắt đầu cuộc đua, cơ chế Rubber Banding sẽ bị tạm thời ngắt trong khoảng 10s đầu tiên, điều này sẽ đảm bảo cho các xe A.I có thể sử dụng tính chất vị trí và sức mạnh của mình để phân định rõ khoảng cách với các xe khác trong đoàn.

- Xe A.I đang bỏ xa người chơi bị tông hay va chạm khiến xe bị Crash, lúc này cần Disable **Rubber Banding** tạm cho tới khi xe có thể đạt tới vận tốc an toàn (~100km/h) mới bắt đầu áp dụng **Rubber Banding**.

- Một vài trường hợp khác sẽ bổ sung sau...

### Các trường hợp đặc biệt khác:

- Khi bị người chơi bỏ xa khoảng 7000 Units, xe A.I sẽ được liên tục Boost tốc độ cho tới khi đạt được khoảng cách 7000 Units so với người chơi.

### Flowchart Rubber Banding Logic

```mermaid
flowchart TD
    A["Race Bắt Đầu"] --> B["Thời gian = 0s<br/>RubberBand = Disable"]
    
    B --> C{Thời gian > 10s?}
    C -->|Không| D["Maintain<br/>Initial Distance"]
    C -->|Có| E{A.I bị Crash?}
    
    E -->|Có| F["Vận tốc A.I<br/>= 0"]
    F --> G["Disable RubberBand"]
    G --> H{Vận tốc A.I<br/>> 100km/h?}
    H -->|Không| I["Boost tốc độ"]
    H -->|Có| J["Enable RubberBand"]
    
    E -->|Không| K{Khoảng cách<br/>A.I đến Player?}
    K -->|> 7000 Units| L["Khoảng cách = Bị bỏ xa"]
    L --> M["Performance ⬆️<br/>Boost tốc độ"]
    
    K -->|< 7000 Units| N["RubberBand<br/>Hoạt động bình thường"]
    
    K -->|Gần| O["RubberBand = Disable"]
    
    J --> N
    M --> N
    N --> K
    
    style B fill:#ff6b6b
    style J fill:#51cf66
    style G fill:#ffd43b
```

---

*Document: RACER A.I - Game Design Document*

*Last Updated: 2025-11-10*

*Version: 5*
