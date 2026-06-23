# 1. TỔNG QUAN

## **1.1. Concepts**

- PlayerStates là tập hợp các thuộc tính của người chơi trong quá trình chơi Game, PlayerState bao gồm 3 thành phần:
    - PlayerWallet.
    - PlayerInventory.
    - PlayerGarage.

## 1.2. Mechanics và Định nghĩa liên quan cần phát triển

| # | Mechanic/Định nghĩa. |  |
| --- | --- | --- |
| 1 | Player Wallet |  |
|  | 1.1 | Định nghĩa Player Wallet |
|  | 1.2 | Hiển thị trên UI |
|  | 1.4 | Update các thông tin của Wallet |
| 2 | Player Inventory |  |
|  | 2.1 | Định nghĩa Player Inventory |
|  | 2.2 | Các điểm truy cập vào Inventory |
|  | 2.3 | Hiển thị trên UI |
|  | 2.4 | Các trạng thái của Item Visual trong Inventory |
|  | 2.5 | Các trạng thái của các loại Items còn lại trong Inventory |
|  | 2.6 | Item Use trong Inventory |
| 3 | Player Garage |  |
|  | 3.1 | Định nghĩa Player Garage |
|  | 3.2 | Các chức năng trong Garage |
|  | 3.3 | Chức năng đổi Theme cho Garage & MainMenu |

# 2. Mechanics và định nghĩa liên quan cần phát triển

## 2.1. Player Wallet 💵

### 2.1.1. Định nghĩa Player Wallet

- Nơi chứa các Currency cần thiết cho các hoạt động mua bán In-Game.
    - Currency —> Cash, Click, Fuel. *(Link tới Document Currency, Items & Cars)*
- Mọi tính toán Earn/Spend của người chơi đều có phản ánh Update lên Wallet.

**Note: Wallet không phải Inventory, các Currency Item trong Inventory là dạng “chưa mở” → Chỉ chuyển vào giá trị của Wallet khi người chơi *‘Use’*.**

### 2.1.2. Hiển thị trên UI

- Số dư Wallet hiển thị  ở Header của các màn hình chính:

![alt text](images/image-26.png)

- Tùy theo Screen mà các yếu tố UI của Player Wallet hiển thị khác nhau, liệt kê chi tiết ở bảng dưới:

***Bảng liệt kê các yếu tố UI của Player Wallet trên các Screen khác nhau***

| # | **Màn hình** | **Hiển thị Cash** | Hiển thị Click | **Hiển thị Fuel** |
| --- | --- | --- | --- | --- |
| 1 | Home / Map | Có — icon + số dư | Có — icon + số dư | Có — icon + số dư / cap (VD: 38/50) |
| 2 | Inventory | Có — icon + số dư | Có — icon + số dư | Có — icon + số dư / cap (VD: 38/50) |
| 3 | Garage / Upgrade | Có — highlight khi không đủ tiền. | Có — highlight khi không đủ tiền | Có — icon + số dư / cap (VD: 38/50) |
| 4 | TrackSelected | Không | Không | Có — highlight đỏ nếu Fuel = 0 |
| 5 | Post-Race Result | Có nhưng chỉ hiển thị số tiền được cộng thêm. | Không | Không |

### 2.1.3. Update các thông tin của Wallet

- Tất cả các hoạt động Spend/Earn, cộng/trừ các Currency vào Wallet của người chơi cần kích hoạt Update thông tin và chạy hiệu ứng Update Spend/Earn tương ứng.

![alt text](images/image-27.png)

*Ví dụ Animation trừ tiền Cash khi Upgrade xe.*

## 2.2. Player Inventory 📦

### 2.2.1. Định nghĩa Player Inventory

- Nơi chứa các Item người chơi sỡ hữu In-Game.
- *Định nghĩa Item (Link tài liệu Item).*

### 2.2.2. Các điểm truy cập vào Inventory

- Có thể truy cập vào Inventory từ các Screen:
    - Main Screen
    - Game Mode Screen
    - VN Tour Map
    - Multiplayer Lobby
    - Daily Challenge Screen
    - Car Customize
    - Shop
    - Achievement
    - User Profile
- Không thể truy cập vào Inventory từ các Screen
    - Settings
    - Các Screen thuộc DriveMode

https://www.figma.com/design/j0UmML9tgnH8EK792k9Mbb/VNRacing_UX?node-id=3767-6499&p=f&t=ez2amyNpVCtt7NvL-0

### 2.2.3. Hiển thị trên UI

#### 2.2.3.1. Cấu trúc Screen Inventory

![alt text](images/image-28.png)

***Bảng liệt kê các yếu tố UI của Screen Inventory:***

| **Vùng UI** | **Mô tả** |
| --- | --- |
| **Header Bar** | Tiêu đề "INVENTORY" sáng lên khi đang ở trong thùng đồ. |
| **Filter Tabs** | Tab lọc chiều dọc: 
Tất cả · Visual · Performance · Currency · LootCrates 
Tab được chọn có highlight. |
| **Sort Buttons** | Dropdown sắp xếp có 4 lựa chọn: 
Mới nhất · Loại · Rarity · Tên A-Z. 
Mặc định: Mới nhất. |
| **Action Buttons** | Các hành động liên quan tới Item, bao gồm:
  • Use: Kích hoạt hiệu ứng đặc biệt của Items.
  • Buy In Store: Nhảy qua Store tới gói IAP tương ứng. |
| **Item Grid** | Lưới item 4 cột (Portrait) hoặc 6 cột (Landscape). 
Mỗi ô hiển thị: Icon, Tên rút gọn, Rarity badge, Quantity Text, Lock icon (nếu Locked). |
| **Details Panel** | Bên phải. Hiển thị thông tin chi tiết của Item đang được chọn. 
Mặc định khi vào thùng đồ sẽ hiển thị Item đầu tiên trong Grid. |
| **Wallet Bar** | Thanh trên cùng: hiển thị Cash Balance, Fuel Balance & Click Balance |

#### 2.2.2.3. Item Details Panel

- Player Tap vào bất kỳ item nào trong lưới Inventory để mở Detail Panel.
- Mặc định khi Player vào Inventory thì Game sẽ luôn chọn Item đầu tiên trong thùng đồ để hiện Details.

### 2.2.4. Các trạng thái của Visual Items trong Inventory

- 
- Các Visuals Item có thuộc tính quantity luôn bằng 1 và chỉ có một phiên bản duy nhất trong thùng đồ.
- Visual Item tồn tại ở 3 trạng thái: Locked, Unlocked và Equipped và hiển thị khác nhau trong Inventory.

***Bảng liệt kê các trạng thái của Item Visual trong Inventory:***

| Trạng thái |  | Ý nghĩa và hiển thị |
| --- | --- | --- |
| Locked | Chưa được trao thưởng/mua. |   • Item không tồn tại trong Inventory. 
  • UI không hiển thị Item Card trong Inventory nhưng có hiển thị trong trạng thái Locked ở Screen Car Customize Visual. |
| Unlocked | Đã được trao thưởng/mua |   • Item hiện lên trong Inventory.
  • Hiện nút Customize —> Bấm vào dẫn tới Screen Customize Visual. |
| Equipped | Đã được trao thưởng/mua và đang được trang bị cho xe. |   • Item hiện lên trong Inventory.
  • Hiển bị Badge dấu Tick thể hiện trạng thái ‘*Đang dùng*’.  
  • Hiện nút Customize —> Bấm vào dẫn tới Screen Customize Visual. |
- Khi người chơi nhận được xe từ City mới, hệ thống tự động thêm tất cả các Item Visual mặc định đi theo các xe đó vào Inventory (Locked —> Unlocked)

![alt text](images/image-29.png)

*Các Item đang Selected, Đang Equipped và đã Unlocked trong Inventory*

### 2.2.5. Các trạng thái của các loại Items còn lại trong Inventory

- Tương tự như Visual Items nhưng các Item còn lại không có trạng thái Equipped.
- Các Item còn lại có thể có Quantity > 1.
- Khác với Visual Item, các Item có thuộc tính **on_use_effect** và các Item Customize Performance sẽ biến mất khỏi Inventory khi có Quantity = 0.

### 2.2.6. Item Use trong Inventory

- Một số Item sẽ ***có thuộc tính on_use_effect*** (*Check bảng ITEM_MASTER*), khi bấm vào trong Inventory sẽ hiện ra thêm nút USE trong bảng Details.
- Bấm nút USE sẽ kích hoạt các hiệu ứng của Item đó.

![alt text](images/image-30.png)

Ví dụ một Item có thuộc tính *on_use_effect*

- Flow kích hoạt hiệu ứng của Item có thuộc tính on_use_effect:
    1. Player Tab vào Item trong Inventory —> Detail Panel được mở.
    2. Player bấm Use/Sử dụng trong Detail panel.
    3. Màn hình hiện thông báo kích hoạt hiệu ứng.
        1. Item Card trong Inventory biến mất nếu Quantity của nó trong Inventoy = 0. 
        2. Cập nhật các giá trị của Wallet nếu có ảnh hưởng.

## 2.3. Player Garage 👨🏻‍🔧

### 2.3.1. Định nghĩa Player Garage

- Garage là màn hình quản lý xe của người chơi, nó cũng là trung tâm kết nối giữa các chức năng:
    - Chọn xe trong Car Selection
    - Car Customizations.
    - Đổi Theme cho Garage và cho MainMenu.

### 2.3.2. Các chức năng trong Garage

#### 2.3.2.1. Car Selection

- Người chơi có thể đổi xe bằng cách bấm vào nút Switch trên Screen Garage:

![alt text](images/image-31.png)

- Danh sách Switch xe hiện tất cả các xe hiện có InGame, người chơi có thể Select các xe đó để xem Preview dù chưa sở hữu chúng.
- Khi thoát ra khỏi Screen này:
    - Nếu người chơi đã sở hữu xe đang Preview thì nó sẽ được chọn làm xe chính.
    - Nếu người chơi chưa sở hữu xe đang Preview thì hệ thống Revert lại lựa chọn hợp lệ gần nhất.

#### 2.3.2.2. Car Customization

- Người chơi đi tới Screen Car Customize Visual hoặc Performance.
- ***Link tới tài liệu Car Customize***

### 2.3.3. Chức năng đổi Theme cho Garage & Main Menu

#### 2.3.3.1. Định nghĩa chức năng đổi Theme

- Đổi Theme là chức năng thay đổi toàn bộ Visual Identity của Level Garage và MainMenu.
- Có thể thay đổi Theme thông qua tùy chọn ở Screen MainMenu và Screen Garage.
- Mỗi một Theme được định nghĩa là Item có thể Unlock/Mua được và xuất hiện trong Inventory.

![alt text](images/image-32.png)
*Tùy chọn đổi Theme ở Screen MainMenu*

![alt text](images/image-33.png)
*Tùy chọn đổi Theme ở Screen Garage*

#### 2.3.3.2. Luồng chức năng đổi Theme

- Luồng chức năng đổi Theme:
    1. Player kích hoạt Menu Switch Themes
    2. Player chọn Theme và xác nhận
    3. Trên Screen chạy Hiệu ứng chuyển đổi.
    4. Switch Theme thành công.

#### 2.3.3.3. Các yếu tố bị thay đổi khi đổi Theme

- Đổi BackgroundScene/Enviroment Art.
- *(Pending)* Đổi UI Frame, Border Style?
- *(Pending)* Đổi Ambient Sounds?

#### 2.3.3.4. Danh sách các Theme dự kiến

*(Pending)*

| Theme_ID | Tên | Note |
| --- | --- | --- |
| THM_DEF_0001 | Default VN Racing Theme |  |
| THM_MOD_0001 | Modern Theme |  |
|  |  |  |
|  |  |  |
|  |  |  |

---

*Mọi thắc mắc xin liên hệ Team Game Design.*
