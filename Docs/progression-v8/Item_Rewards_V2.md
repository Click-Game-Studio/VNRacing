# **VNRacing**

**Tài Liệu Thiết Kế Item Rewards**

Phiên bản: v2.0  |  Ngày: 11/05/2026

Team: Game Design  |  Dành cho: PO/ PM / Dev/ QA / Art

# 1. TỔNG QUAN

## **1.1. Concepts**

- Game có 2 hình thức trao thưởng Item:
    - Trao thưởng theo kịch bản cố định
    - Trao thưởng ngẫu nhiên theo xác xuất khi người dùng kích hoạt các sự kiện như về đích, mở hòm may mắn, hoàn thành Achievements.

## **1.2. Các Mechanics và định nghĩa liên quan cần phát triển**

| # | **Tên** |  |
| --- | --- | --- |
| **1** | **Trao thưởng theo kịch bản cố định** |  |
| 2 | **Trao thưởng ngẫu nhiên theo xác xuất** |  |
|  | 2.1 | **Cơ chế Random Item Rewards** |
|  | 2.2 | **Cơ chế đền bù khi Tokens bốc trúng đồ Visual đã có trong Inventory** |

# **2. Các Mechanics và định nghĩa liên quan cần phát triển**

## **2.1 Trao thưởng theo kịch bản cố định**

- Người chơi nhận thưởng theo kịch bản cố định, tham khảo tài liệu Goals. ‣

## **2.2 Trao thưởng ngẫu nhiên theo xác xuất**

![alt text](images/image.png)

- Mỗi lần kích hoạt sự kiện trao thưởng, người chơi sẽ có từ **1-3 cơ hội mở quà** (**từ đây về sau gọi là Tokens**) tùy vào các yếu tố:
    - Kết quả vị thứ của người chơi cuối mỗi cuộc đua.
        - Về nhất: 3 Tokens, Về nhì: 2 Tokens, Về ba: 1 Token, Còn lại: Không có Tokens.
    - Loại Loot Crates mà người chơi mở.
        - LC Common: 1 Tokens, LC Uncommon: 2 Tokens, LC Rare: 3 Tokens
- Các Item Customize Visual chỉ có thể có [**1 đơn vị (Không Stack)**](https://docs.google.com/document/d/12qtXcSKGL34tVIIhh_921Wh_ZD6tMrBN5ARn-xFGURM/edit?tab=t.p8j960r5f78w#heading=h.xu6im3x1491y) trong thùng đồ nên nếu Tokens ra lặp thì sẽ được thay bằng Cash với độ Rarity tương đương.

### **2.2.1. Cơ chế Random Item Rewards**

- Quá trình Random ra phần thưởng cuối cùng bắt buộc phải thông qua 3 cửa trước khi hiện Reward ra cho người chơi:

![alt text](images/image-1.png)
- **Giải thích Random Reward Flow:**
1. Mỗi **Reward Type** được gán một dãy giá trị tương ứng với tỉ lệ xuất hiện của Item đó khi Random:
- **Ví dụ:**  Item Visual Type: [0-40], Item Performance Type:[41-70] , Item LC Type [71-100]

*Bảng xác suất xuất hiện các Item như sau:*

| Item | Xác suất |
| --- | --- |
| Visual | 40% |
| Performance | 30% |
| Loot Crate | 30% |
1. Khi Random, **Generate** ra một con số bất kỳ từ **[0-100]**, nếu con số Random nằm trong khoảng của **Reward Type** nào thì **Reward Type** đó sẽ được chọn.

![alt text](images/image-2.png)

1. Tiếp theo, khi chọn lựa độ Rarity, mỗi loại Reward sẽ có mức độ Rarity khác nhau nhưng vẫn sẽ được phân chia theo dãy giá trị:
- Ví dụ: Item Visual Common: [0-70], Item Visual UnCommon: [71-90], Item Visual Rare [91-100]

*Bảng xác suất của Item Rarity như sau:*

| Item | Xác suất |
| --- | --- |
| Common | 70% |
| UnCommon | 20% |
| Rare | 10% |

![alt text](images/image-3.png)

1. Cuối cùng, khi đã lựa chọn **Reward Type** và **Reward Rarity**, ta tìm trong Danh sách Reward (**Reward Pool của City**) các Reward thỏa mãn điều kiện: **Reward Type + Reward Rarity** và chọn Random một Reward. Danh sách [Item trong Reward Pool ở bảng này.](https://docs.google.com/spreadsheets/d/1uq2kATX7q-OH0t-qpyCIlaAARKaOeLNz4ybDVNtzqJI/edit?gid=913865542#gid=913865542&range=A3:L3) 
- Ví dụ: Visual + Common + Random Pool —> Visual Common Front Bumper Vin Fast.
- **Cơ chế Random Item trong Rewards Pool như sau:**
    
    
    | **Item** | **Times_Pick** | **Base_Weight** | Effective_Weight | **P (% Cơ hội)** |
    | --- | --- | --- | --- | --- |
    | **Item Visual A** | 0 | 0.5 | 0.5 | 33% |
    | **Item Visual B** | 1 | 1 | 0.5 | 33% |
    | **Item Visual C** | 1 | 1 | 0.5 | 33% |
    | **Total Weight** |  | 2.5 | 1.5 |  |

### **2.2.2. Cơ chế đền bù khi Tokens bốc trúng đồ Visual đã có trong Inventory**

- Vì các Item Visual chỉ có thể có 1 đơn vị (Không Stack) trong thùng đồ, khi Pull trúng chính xác Item Visual nào đó đã có trong thùng đồ  thì sẽ được bù trừ bằng Cash với độ Rarity tương đương, cụ thể trong bảng dưới:

| --- | --- |

### **2.2.3. Trường hợp Duplicate Item Reward trong cùng 1 Batch**

- Nếu xảy ra Duplicate Item Rewards trong cùng một Batch, ví dụ:
    - Token 1: Front Bumper Common
    - Token 2: Front Bumper Common
    - Token 3: Rear Bumper Rare
- Thì tự động Reroll lại một lần cho Token tiếp theo bị trùng, nếu lần Reroll vẫn ra Item trùng thì mới Convert thành Cash.
- Người chơi không thấy xử lý Duplicate này trên màn hình, hệ thống tự xử lý và đưa ra kết quả cuối cùng.
