---
phase: requirements
title: Game Design Document - Car Customization
description: Comprehensive game design for car customization system
feature_id: car-customization
status: development
last_updated: 2026-01-20
---

# Game Design Document - Car Customization

**Feature ID**: `car-customization`
**Status**: 🔄 Development
**Version**: 1.1.0
**Last Updated**: 2026-01-26

## Tổng Quan

Hệ thống Tùy Chỉnh Xe cho phép người chơi sửa đổi xe của họ cả về mặt hình ảnh và chức năng, với tích hợp đặc biệt các chủ đề văn hóa Việt Nam thông qua hệ thống tiến độ VN-Tour. Hệ thống này cân bằng cá nhân hóa hình ảnh với tác động hiệu năng có ý nghĩa trong khi tôn vinh di sản văn hóa Việt Nam.

## Mục Tiêu Thiết Kế

### Mục Tiêu Chính
- **Tùy Chỉnh Hình Ảnh**: Cho phép người chơi sửa đổi diện mạo xe thông qua các bộ phận và màu sắc
- **Tích Hợp Hiệu Năng**: Lựa chọn tùy chỉnh ảnh hưởng đến đặc tính hiệu năng xe
- **Tôn Vinh Văn Hóa**: Tích hợp chủ đề và họa tiết văn hóa Việt Nam trong các tùy chọn tùy chỉnh
- **Tối Ưu Mobile**: Đảm bảo hiệu năng mượt mà trên thiết bị mobile với quản lý tài sản hiệu quả
- **Tích Hợp Tiến Độ**: Liên kết mở khóa tùy chỉnh với tiến độ chiến dịch VN-Tour

### Thành Phần Xe Có Thể Tùy Chỉnh

**Bộ Phận Hình Ảnh:**
- **Cản Trước** - Kiểu dáng phía trước xe
- **Cản Sau** - Kiểu dáng phía sau xe
- **Dè Ngang** - Kiểu dáng bên hông xe
- **Cánh Đuôi** - Cánh khí động học phía sau
- **Ống Xả** - Kiểu dáng hệ thống xả
- **Mâm Bánh Xe** - Thiết kế bánh xe và mâm

**Vùng Màu Sắc:**
- **Màu Thân Xe** - Màu chính của thân xe
- **Màu Mâm Xe** - Màu bánh xe và mâm
- **Màu Phanh ABS** - Màu caliper phanh

**Tác Động Hiệu Năng**: Khác với hệ thống chỉ có hình ảnh truyền thống, lựa chọn tùy chỉnh PrototypeRacing ảnh hưởng đến hiệu năng xe, tạo ra việc ra quyết định có ý nghĩa cho người chơi.

## Tích Hợp Văn Hóa Việt Nam

### Mở Khóa Tùy Chỉnh VN-Tour
Hệ thống tùy chỉnh được tích hợp sâu với chiến dịch VN-Tour, mở khóa các chủ đề văn hóa Việt Nam khi người chơi tiến bộ qua các thành phố khác nhau:

**Chủ Đề Miền Bắc Việt Nam:**
- **Hà Nội**: Họa tiết rồng hoàng gia, màu đỏ và vàng truyền thống, yếu tố kiến trúc hoàng gia
- **Vịnh Hạ Long**: Chủ đề xanh dương và xanh lá ven biển, kết cấu lấy cảm hứng từ đá vôi, thiết kế hàng hải

**Chủ Đề Miền Trung Việt Nam:**
- **Huế**: Tím và vàng hoàng gia, thiết kế di sản hoàng gia, họa tiết cung đình truyền thống
- **Đà Nẵng**: Chủ đề ven biển hiện đại, thiết kế lấy cảm hứng từ cầu, bảng màu xanh và trắng
- **Hội An**: Thẩm mỹ phố cổ, thiết kế lấy cảm hứng từ đèn lồng, màu vàng và đỏ truyền thống

**Chủ Đề Miền Nam Việt Nam:**
- **Thành phố Hồ Chí Minh**: Phong cách đô thị hiện đại, màu sắc đô thị sôi động, thiết kế lấy cảm hứng từ nhà chọc trời
- **Đồng bằng Sông Cửu Long**: Chủ đề sông nước và nông nghiệp, màu xanh lá và nâu tự nhiên, họa tiết nông thôn

### Hệ Thống Ý Nghĩa Văn Hóa
Mỗi vật phẩm tùy chỉnh theo chủ đề Việt Nam bao gồm bối cảnh và ý nghĩa văn hóa, giáo dục người chơi về di sản Việt Nam trong khi cung cấp các tùy chọn tùy chỉnh có ý nghĩa.

## Cơ Chế và Hệ Thống Cốt Lõi

### Danh Mục Tùy Chỉnh

| Danh mục | Mô tả | Tích hợp Văn hóa |
|----------|-------------------|---------------------|
| **Gói Phong Cách** | Biến đổi bộ kit thân xe hoàn chỉnh | Gói phong cách vùng miền Việt Nam mở khóa qua VN-Tour |
| **Bộ Phận Riêng Lẻ** | Sửa đổi thành phần đơn lẻ | Họa tiết và thiết kế truyền thống Việt Nam |
| **Hệ Thống Màu Sắc** | Tùy chỉnh sơn và chất liệu | Bảng màu truyền thống Việt Nam |
| **Decal Văn Hóa** | Yếu tố trang trí theo chủ đề Việt Nam | Biểu tượng vùng miền, mẫu truyền thống |
| **Điều Chỉnh Hiệu Năng** | Sửa đổi chức năng ảnh hưởng gameplay | Bonus văn hóa cho bản build theo chủ đề Việt Nam |

### Detailed Component Specifications

| Hạng mục | Mô tả | Lý do lựa chọn |
| :---- | :---- | :---- |
| **Style** | Thay đổi Full Body kit theo một bộ Body đã được định nghĩa sẵn từ trước. | Lựa chọn thay đổi nhanh cho người dùng, rất tiện dụng để thấy được thay đổi tức thì trên Visual xe.  Các bộ phận thay đổi của Style này bao gồm các bộ được liệt kê ở dưới. |
| Front Bumper | Thay dè trước.   | Thêm lựa chọn cho người chơi. |
| Side Board | Thay dè ngang. | Thêm lựa chọn cho người chơi. |
| Rear Bumper | Thay dè sau. | Thêm lựa chọn cho người chơi. |
| Spoiler | Thay cánh đuôi. | Thêm lựa chọn cho người chơi. |
| Exhaust | Thay bộ ống xả. | Thêm lựa chọn cho người chơi. |
| Wheel | Thay mâm bánh xe | Thêm lựa chọn cho người chơi. |
| **Body Color** | Thay màu cho toàn bộ phần Body của xe ngoại trừ phần mâm, phanh ABS và Decal. | Nhanh và tiện lợi. |
| **Wheel Color** | Thay màu cho phần Mâm xe. | Thêm lựa chọn cho người chơi. |
| **Caliper Color** | Thay màu cho phần phanh ABS của xe. | Thêm lựa chọn cho người chơi. |
| **Decal(Chưa biết)** | Thay đổi Decal trên xe. | Thêm lựa chọn cho người chơi. |

> **⚠️ Implementation Status Note (Last synced: 2026-01-26)**
> - **Exhaust** (Part Slot): ⏳ Planned - Not Yet Implemented (not in ECarPartSlot enum)
> - **Hood** (Part Slot): ⏳ Planned - Not Yet Implemented (not in ECarPartSlot enum)
> - **Caliper Color** (Color Slot): ⏳ Planned - Not Yet Implemented (commented out in ECarColorSlot enum)

2.  **Hệ thống Style Mẫu cho xe và Slot Custom cho người chơi**
- Style Mẫu là một bộ Part đã được độ sẵn, thường là một bộ Parts nhìn đẹp nhất đối với các xe đó.  
- Một xe sẽ có 1-3 bộ Style mẫu cho người chơi chọn lựa.  
- Người chơi có thể chọn một hoặc vài Parts khác so với Style mẫu để 

![][image1]

- Khi Chọn một cái Style nó sẽ hiện thay đổi Style trên cái xe  
- Nếu Style đó là Style đã bấm nút Confirm thì sẽ hiện mấy cái nút part trên xe để điều chỉnh  
- Nếu Style đó chưa được Confirm thì sẽ không hiện mấy cái nút Part trên xe để điều chỉnh  
- Nếu Style đó chưa được mua thì bấm nút đó sẽ xác nhận mua và Confirm luôn Style đó  
- Sau khi confirm một Style thì có thể tinh chỉnh các Part tùy ý  
- Nếu chọn Confirm một Style khác thì tất cả thay đổi trên Style trước đó sẽ bị Reset về bộ phận của Style được Confirm (Tức là không có lưu mấy cái lựa chọn Custom của người chơi).

3.  **Tương tác với giao diện Customize 2D**  
4.  **Tương tác với giao diện Customize 3D**  
5.  **Cơ chế giỏ hàng tự động khi Customize xe**

[image1]: <!-- embedded image removed -->
