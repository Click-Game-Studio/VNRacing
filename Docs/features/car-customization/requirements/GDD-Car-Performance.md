---
phase: requirements
title: Game Design Document - Car Performance
description: Comprehensive game design for car performance metrics and classification
feature_id: car-customization
status: development
last_updated: 2026-01-20
---

# Game Design Document - Car Performance

**Feature ID**: `car-customization`
**Status**: 🔄 Development
**Version**: 1.1.0
**Last Updated**: 2026-01-26

**Change Log:**

- First Version (2025/07/10).  
- Updated (2025/08/20).  
  - Update lại các chỉ số chính.  
  - Update lại các loại xe theo chỉ số chính.


1. # **Gameplay Concepts**

1. ## **Concepts**

- Có 4 chỉ số chính để đại diện cho các chỉ số liên quan tới xe:  
  - **Acceleration**: Khả năng tăng tốc; Cao hơn là tăng tốc nhanh hơn.  
  - **Grip**: Khả năng bám đường; Cao hơn là bám đường tốt hơn, giảm ít tốc độ hơn khi rẽ và Drift.  
  - **Speed**: Tốc độ tối đa xe có thể đạt được; Cao hơn thì trần tốc độ tối đa lớn hơn.  
  - **Nitrous**: Trần tốc độ xe khi sử dụng Nitrous, cao hơn là trần lớn hơn.  
- Chỉ số đánh giá dựa theo cấp độ, được hiển thị trên giao diện người chơi với cấp 1 là cấp thấp nhất và cấp 5 là cấp cao nhất:  
  ![][image1]  
- Trong quá trình chơi có thể chọn các gói nâng cấp xe để tinh chỉnh hiệu năng chiếc xe lại theo đúng ý muốn.  
- Các loại xe khác nhau sẽ có các bộ chỉ số ban đầu khác nhau, tạo nên lợi thế ở các loại đường đua khác nhau, chi tiết trong các phần dưới.  
  


2. ## **Các Mechanics & Định nghĩa cần được phát triển**

|  | Tên Mechanics và Định nghĩa |  |
| :---- | :---- | :---- |
|  | Chỉ số cơ bản và chỉ số gốc của xe |  |
|  | Phân loại xe theo chỉ số |  |
|  | Quan hệ giữa chỉ số xe và đường đua |  |
|  | Cơ chế nâng cấp chỉ số cho xe |  |

2. **Định nghĩa chi tiết**

1. ## **Chỉ số cơ bản và chỉ số gốc của xe**

- Các chỉ số cơ bản mà người dùng thấy được bao gồm:  
  - Acceleration  
  - Grip  
  - Speed  
  - Nitrous  
- Các chỉ số cơ bản trên sẽ điều chỉnh các chỉ số chi tiết thực tế của xe, chi tiết phân loại ở bảng dưới:  
  [VN Racing - Car Physics Profiles](https://docs.google.com/spreadsheets/d/1TTunRhGmgEHM4KgGzEGK4sCtw5-nZz0R7o2kAEpbau4/edit?gid=0#gid=0)  
- ***Đợi hoàn thành bảng chỉ số mới***

2. ## **Phân loại xe theo chỉ số**

- Dựa theo các chỉ số cơ bản, phân chia Performance của xe theo ba dạng:  
  - Dạng tăng tốc nhanh, Nitrous mạnh: Thích hợp cho các đường đua hẹp và tranh chấp.  
  - Dạng Cua & Drift tốt, tăng tốc nhanh: Thích hợp cho các đường có nhiều khúc cua.  
  - Dạng cân bằng với chỉ số Top Speed và Acce cao: Phù hợp với đại đa số các đường đua.  
- Bảng chỉ số cân bằng ban đầu có thể dùng để Test:

| ProfileName | Possible Combinations | Top Speed | Acceleration | Grip | Nitrous |
| :---- | :---- | ----- | ----- | ----- | ----- |
| The Rocket | High Acce & Nitrous, bad Grip | **1** | 2 | **1** | 2 |
| The Snake | Good Grip & Speed, bad Nitrous & Acce | **1** | 2 | 2 | **1** |
| **The Rook (Base Car)** | Balance, bad Nitrous & Trip | 2 | 2 | **1** | **1** |

- Một số Demo thực tế các loại xe theo bảng cân bằng chỉ số

|  | Straight Road | Cua góc rộng | Cua góc hẹp | Drift góc rộng | Drift góc hẹp | Tăng tốc bằng Nitrous | Full Race | Time FullRace |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| **The Rocket** |  |  |  |  |  |  |  |  |
| **The Snake** |  |  |  |  |  |  |  |  |
| **The Rook** |  |  |  |  |  |  |  |  |

3. ## **Quan hệ giữa chỉ số xe và đường đua (Race Track)**

- Gắn với các loại xe là các thể loại **Race Tracks** phù hợp nhất với các xe đó, người chơi có thể chiến thắng bất kỳ Race Track nào với chiếc xe yêu thích của mình nếu đủ kiến thức về đường đua và kỹ năng điều khiển.

4. ## **Cơ chế nâng cấp chỉ số cho xe**

- 

[image1]: <!-- embedded image removed -->
