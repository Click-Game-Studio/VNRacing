---
phase: requirements
title: Technical Guide - Car Collision
description: Technical guidance for player vs AI car collision mechanics
feature_id: car-physics
status: development
last_updated: 2026-01-20
---

# Technical Guide: Car Collision Mechanics

**Feature ID**: `car-physics`  
**Status**: 🔄 Development  
**Version**: 1.0.0  
**Last Updated**: 2026-01-20

**Original Title**: Hướng dẫn kỹ thuật phương án làm giả va chạm của xe người chơi và xe do máy lái

# **1\. Mục tiêu:**

- Xe của người chơi cần phải va chạm với môi trường như bình thường, nhưng không bị xe AI hạn chế di chuyển nữa

# **2\. Cơ chế triển khai:**

- Bước 1:  
  Xe của player sẽ được phân ra làm 1 object channel khác với các xe của AI, đặt tên là “CarPriority”. Channel này sẽ tương tác với các channel khác tương tự như layer mặc định của xe thông thường, trừ việc nó sẽ không tương tác được với chính Channel WorldDynamic (là channel của các xe hiện tại). Kết thúc bước này thì xe của player vẫn phải tương tác được với môi trường và các vật thể khác trên đường, trừ xe do máy điều khiển.  
- Bước 2:  
  Tạo 1 actor có khối mesh với collider y hệt như xe của người chơi, ở channel WorldDynamic, chuyển nó về chế độ hidden ingame. Khối mesh này không được tự do di chuyển, mà sẽ di chuyển theo kiểu Kinematic (cho giả lập vật lý nhưng khóa toàn bộ constraint), với vị trí và góc xoay của nó được cập nhật mỗi Async Physics Tick để đồng bộ hóa y hệt với xe của người chơi. Kết thúc bước này, xe của player có cảm giác như nó sẽ luôn đẩy các xe của máy đi.  
- Bước 3:  
  Tạo 1 box collider bao phủ bên ngoài xe của player, khối collider này nên ở trên channel CarPriority và sẽ chỉ overlap với các xe AI khác nhằm phát hiện va chạm của xe player so với xe AI. Khi tìm thấy va chạm kiểu này, cho phần visual của xe người chơi lắc tương ứng theo va chạm (chia làm 6 trường hợp, bao gồm va chạm ở 4 góc, và 2 va chạm dọc thân xe khi lấn nhau). Kết thúc bước này, xe của player nên có cảm giác như nó thực sự bị các xe AI va chạm trúng.

# **3\. Sơ đồ:**

![][image1]

