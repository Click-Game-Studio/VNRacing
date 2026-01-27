---
phase: requirements
title: ME06 - Environment Collision Mechanic
description: GDD Overview of environment collision mechanics
feature_id: car-physics
status: development
priority: medium
last_updated: 2026-01-20
---

# ME06: Environment Collision Mechanic

**Feature ID**: `car-physics`  
**Status**: 🔄 Development  
**Version**: 1.0.0  
**Last Updated**: 2026-01-20

GDD Overview cơ chế va chạm với môi trường trong VN Racing  
**Change Log:**

- **First Version 20250821**  
- **Ver2 20251104**  
  - Thêm thông tin so sánh theo yêu cầu của Dev.

1. # **Gameplay Concepts**

1. ## **Concepts**

- Trong cuộc đua, người chơi sẽ va chạm với môi trường và các vật cản.  
- Cơ chế Physics cần đảm bảo hỗ trợ tối đa cho người chơi, tránh cho cuộc đua bị gián đoạn.


2. # **Game Mechanics**

1. ## **ME06: Cảm giác va chạm với môi trường.**

- Physics va chạm của xe sẽ mang hướng Arcade, với mục đích giữ cho nhịp đua ổn định, hạn chế sự mất kiểm soát của người chơi khi va chạm với các yếu tố môi trường thường thấy như tường, barrier trong cuộc đua.  
- Khi xe của người chơi va chạm với tường bao quanh track đua sẽ tự động điều chỉnh hướng mũi xe theo hướng của Racing Line, giảm một chút tốc độ và cho phép người chơi tiếp tục đua mà không bị gián đoạn.   
  - Cảm giác này sẽ giống như việc xe bị nảy qua trái hoặc phải một góc có lợi cho người chơi khi va chạm chứ không phải là đâm vào tường rồi bị bật lại về sau rồi sau rồi bị nảy qua trái hoặc phải.  
  - Cảm giác tương tự như Ref:

![][image1]

- Một số so sánh giữa hệ thống va chạm hiện tại của xe với yêu cầu chỉnh sửa:

| In-Game | Hiện tại | Mong muốn |
| :---- | :---- | :---- |
| ![][image2] | Khi va chạm, xe mất xấp xỉ 1s để tự quay đầu trở lại hướng đua. Góc quay lại hơi lớn, lệch hẳn xe qua một bên. | Khi va chạm, xe lập tức quay đầu lại hướng đua. **Giảm góc quay lại khoảng còn ½.** Có một khoảng Interpolate nhỏ giữa lúc va chạm và lúc điều chỉnh để không có cảm giác xe bị giật. |
| ![][image3] | Khi góc va chạm lớn hơn, xe không tự quay lại mà bị dính luôn vào tường. | Khi va chạm, xe lập tức trở lại hướng đua. Có một khoảng Interpolate nhỏ giữa lúc va chạm và lúc điều chỉnh để không có cảm giác xe bị giật.  |
| ![][image4] | Đôi khi ở góc va chạm nhỏ, nếu người chơi không chủ động rẽ qua thì xe cũng bị mắc kẹt tại rào chắn. | Khi va chạm, xe lập tức trở lại hướng đua. Có một khoảng Interpolate nhỏ giữa lúc va chạm và lúc điều chỉnh để không có cảm giác xe bị giật.  |




