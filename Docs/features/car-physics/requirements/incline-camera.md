---
phase: requirements
title: ME05 - Incline & Decline Driving
description: GDD Overview of incline/decline gameplay concepts
feature_id: car-physics
status: development
priority: medium
last_updated: 2026-01-26
---

# ME05: Incline & Decline Driving

**Feature ID**: `car-physics`  
**Status**: 🔄 Development  
**Version**: 1.1.0
**Last Updated**: 2026-01-26

GDD Overview Gameplay khi xe lên xuống dốc trong VN Racing

**Change Log:**

- **First Version 20251021**  
- **Version 2 (20251103)**  
  - Thêm mô tả cho phần Boost sức mạnh khi lên xuống dốc.  
  


1. # **Gameplay Concepts**

1. ## **Concepts**

- Khi xe lên xuống dốc, cần một số cơ chế hỗ trợ để:  
  - Việc lên dốc dễ dàng hơn.  
  - Việc xuống dốc có tốc độ cao hơn.

2. # **Game Mechanics**

1. ## **ME05: Cảm giác xe khi lên xuống dốc.**

- Khi xe lên xuống dốc, Camera cần thay đổi linh hoạt với tình huống lên hoặc xuống dốc:  
  - Khi vào vùng lên/xuống dốc: Camera hơi phóng đại FOV ra một chút, di chuyển Camera (**Không phải Camera Boom**) lên trên một chút theo trục Z và lùi sau một chút theo trục X**(Phía trước).**

    \-\> Cảm giác Camera cao hơn bình thường, thấy được đường đi khi lên dốc.

    ![][image1]

- Khi rời khỏi vùng lên/xuống dốc, Camera của xe từ từ quay lại với các chỉ số như bình thường.

![][image2]

- Vì ảnh hưởng của cơ chế giả lập vật lý hiện tại của xe, khi xe lên dốc sẽ bị giảm tốc độ nếu gia tốc không đủ lớn, ta cần một cơ chế để hỗ trợ xe khi lên dốc để cuộc đua được liền mạch ngay cả khi lên dốc hoặc xuống dốc:  
  - **Khi xe ở trong vùng lên dốc,** xe được cộng Bonus chỉ số **Acceleration lên thành 130%** so với chỉ số hiện tại của xe.  
  - **Khi xe rời khỏi vùng lên dốc,** chỉ số **Acceleration của xe trở lại 100%** như bình thường.

- Khi xuống dốc thì cơ chế giả lập vật lý hiện tại cho phép xe tăng tốc nhanh hơn khi xuống dốc, ta cũng cần một cơ chế hỗ trợ xe khi xuống dốc để điều khiển cảm giác xuống dốc của xe, khiến nó trở nên nguy hiểm hơn:  
  - **Khi xe ở trong vùng xuống dốc**, xe được cộng Bonus chỉ số **Acceleration lên thành 110%** so với chỉ số hiện tại của xe.  
  - **Khi xe rời khỏi vùng xuống dốc,** chỉ số **Acceleration của xe trở lại 100%** như bình thường.

    

- Ngoài việc tăng Acceleration khi lên xuống dốc, các chỉ số còn lại của xe vẫn giữ nguyên như bình thường.


