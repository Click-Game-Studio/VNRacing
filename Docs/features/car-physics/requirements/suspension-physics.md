---
phase: requirements
title: Car Suspension Physics
description: GDD Overview of suspension physics and visual feedback
feature_id: car-physics
status: development
priority: high
last_updated: 2026-01-20
---

# Car Suspension Physics

**Feature ID**: `car-physics`  
**Status**: 🔄 Development  
**Version**: 1.0.0  
**Last Updated**: 2026-01-20

Cơ chế nhún của Suspension khi xe di chuyển trong Map đua.  
**Change Log:**

- First Version (20250811).  
1. **Gameplay Concepts** 

1. ## **Concepts**

- Khi xe chuyển hướng, phần Body của xe vì quán tính sẽ nghiêng hướng ngược lại so với hướng chuyển. Tương tự khi xe đi trên địa hình gồ ghề hay tiếp đất sau khi bay, Body của xe cũng sẽ có các phản ứng phù hợp.  
- Cơ chế này để giả lập bộ nhún Suspension giảm xóc ở 4 bánh xe, tạo cảm giác linh hoạt với tốc độ.  
- Cơ chế này chỉ áp dụng về mặc hình thức, ảnh hưởng tới Visual chứ không liên quan tới Physics của xe.  
2. **Các trường hợp khiến Body xe chuyển động theo Suspension**

Một số trường hợp cơ bản của cơ chế này:

- Xe rẽ qua phải hoặc qua trái.  
- Xe dừng lại đột ngột do va chạm hoặc do người chơi chủ động.  
- Xe đi trên địa hình gồ ghề.  
- Xe tiếp đất sau khi bay.

2. **Mechanic chi tiết các trường hợp**

1. ## **Xe rẽ qua phải hoặc qua trái:**

- Body xe nghiêng về hướng ngược lại so với hướng rẽ của xe.  
- Áp dụng với các tình huống khi xe chạy bình thường, khi xe Drift và khi xe sử dụng NOS.

![][image1]

- Cảm giác như hình Ref.

![][image2]![][image3]  
*Cảm giác nghiêng xe khi Steer bình thường*  
![][image4]  
*Cảm giác nghiêng xe khi Drift*

2. ## **Xe Dừng lại đột ngột do va chạm hoặc do người chơi chủ động.**

- Body xe hơi chúi về phía trước, phần đuôi xe hơi chổng lên.

3. ## **Xe đi trên địa hình gồ ghề**

- Các phần Suspension ở bốn bánh xe phản ứng độc lập dựa vào độ cao của mặt đường mà chúng tiếp xúc.  
- Cảm giác như hình Ref.

![][image5]  
*Cảm giác nghiêng xe khi chạy một chỗ ở địa hình gồ ghề*

4. ## **Xe tiếp đất sau khi bay**

- Các phần Suspension ở bốn bánh phản ứng độc lập dựa vào thứ tự tiếp đất và độ cao xe đạt được trước khi tiếp đất.  
- Cảm giác như hình Ref.

  ![][image6]![][image7]
