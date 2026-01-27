---
phase: requirements
title: ME07 - Car Collision Mechanic
description: GDD Overview of car-to-car collision mechanics
feature_id: car-physics
status: development
priority: high
last_updated: 2026-01-20
---

# ME07: Car Collision Mechanic

**Feature ID**: `car-physics`  
**Status**: 🔄 Development  
**Version**: 1.0.0  
**Last Updated**: 2026-01-20

GDD Overview cơ chế va chạm với xe khác trong VN Racing  
**Change Log:**

- **First Version 20250821**

1. # **Gameplay Concepts**

1. ## **Concepts**

- Trong cuộc đua, người chơi sẽ va chạm với các xe khác.  
- Cơ chế Physics cần đảm bảo hỗ trợ tối đa cho người chơi, tránh cho cuộc đua bị gián đoạn.  
- Cơ chế Physics cần ưu tiên hỗ trợ người chơi trong các cuộc tranh chấp với đối thủ AI.


2. # **Game Mechanics**

1. ## **ME07: Cảm giác va chạm với các xe khác.**

- Physics của xe khi va chạm với các xe khác cũng mang hướng Arcade, nhằm tạo cho người chơi cảm giác chiếc xe có thể vượt qua bất kỳ chướng ngại nào. Khi tranh chấp tay đôi để giành đường, xe của người chơi sẽ luôn có lợi thế.
- Xe của người chơi có **chỉ số “cân nặng” cao hơn** hẳn so với các xe AI, khiến cho khi va chạm xe người chơi có thể đẩy các xe AI ra khỏi đường nếu muốn.
  - Cân nặng này cũng ngăn không cho xe AI thực hiện các hành động đẩy người chơi ra khỏi đường đua mà chỉ có thể chặn không cho người chơi rẽ.
  - Xe của AI vẫn có thể gây ra các tác động nhất định tới xe của người chơi, tuy nhiên không đáng kể.
- Cảm giác tương tự như Ref:

![][image1]

