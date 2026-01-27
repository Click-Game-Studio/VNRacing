---
phase: requirements
title: ME08 - Ramp & High Platform Racing
description: GDD Overview of ramp and airborne mechanics
feature_id: car-physics
status: development
priority: high
last_updated: 2026-01-20
---

# ME08: Ramp & High Platform Racing

**Feature ID**: `car-physics`  
**Status**: 🔄 Development  
**Version**: 1.0.0  
**Last Updated**: 2026-01-20

GDD Overview cơ chế sử dụng Ramp và nhảy xuống Vực trong VN Racing  
**Change Log:**

- **First Version 20250821**  
- **Ver2 20251103**  
  - Bổ sung mô tả cho lực đẩy của Ramp.

1. # **Gameplay Concepts**

1. ## **Concepts**

- Trong cuộc đua, người chơi sẽ tương tác với các bục Ramp, có tác dụng đẩy xe lên cao và tăng tốc.  
- Trong cuộc đua, người chơi sẽ gặp các khu vực có chênh lệch độ cao lớn và di chuyển từ platform có độ cao lớn hơn xuống độ cao thấp hơn.

2. # **Game Mechanics**

1. ## **ME08: Cảm giác khi sử dụng Ramp trong môi trường**

- Trên Track đua có đặt sẵn các Object Ramp, khi xe người chơi tương tác với các Object này sẽ tạo ra các hiệu ứng Boost tốc độ và đẩy xe bay lên khỏi mặt đất.  
- **Object Ramp:** Các Prop đặt trong Level, có dạng như trong hình dưới:

![][image1]  
***Góc của Ramp ≈25 độ, độ cao đỉnh 3m, chiều dài đáy 6m***

- Khi xe người chơi vào vùng tương tác với Object Ramp:  
  - Xe của người chơi sẽ được đẩy tới với một **lực cố định** khiến xe tăng tốc đột ngột và bay lên khỏi mặt đất, lực cố định này cần test thêm.  
  - **Lực đẩy cố định** của xe sẽ có hiệu ứng tương tự như khi dùng NOS nhưng thêm một lực đẩy xe **bay lên cao approximately 4-6 mét** trên không trung.
  - Camera của xe lúc này có hiệu ứng tương tự như khi dùng NOS rồi giữ nguyên hiệu ứng đó cho tới khi xe tiếp đất.  
  - Người chơi vẫn có thể điều khiển hướng bay của xe khi ở trên không như khi điều khiển xe dưới mặt đất nhưng với Steering tệ hơn approximately 50% so với dưới mặt đất.
  - Cảm giác tương tự như hình Ref dưới, xe không xoay vòng chỉ lấy cảm giác Boost lên, xe bay thấp hơn Ref một chút.

![][image2]

- Khi xe tiếp đất, cho phép xe nảy lên xuống theo Physics của Suspension thông thường.  
- Nếu xe bị lật ngang quá 45 độ hoặc lật úp hoàn toàn khi đang bay trong approximately 1s, Rotate xe lại theo đúng chiều để xe có thể tiếp đất, nếu Rotate chưa xong mà xe đã tiếp đất thì tự động kích hoạt chức năng Reset Car.
- Sơ đồ mô phỏng đường bay của xe khi sử dụng Ramp:

![][image3]

- Người chơi có thể sử dụng NOS trong khi bay trên không để tăng tốc độ như ở dưới đất.  
- Khi người chơi đang Drift và sử dụng Ramp, hiệu ứng bay trên Ramp cũng được kích hoạt như bình thường nhưng chức năng Drift sẽ bị Cancel(đồng thời mũi xe tự động quay về trạng thái cân bằng như khi Cancel Drift).

  



