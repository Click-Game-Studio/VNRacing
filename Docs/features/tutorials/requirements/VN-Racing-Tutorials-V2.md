# VN-Racing-Tutorials-V2.md

---
## SCRIPTS TUTORIALS

Các Scripts Tutorial là loại hướng dẫn bắt buộc, người chơi phải thao tác đúng với yêu cầu trên màn hình (ví dụ: hoàn thành thao tác cho từng mechanics hoặc chức năng chính như điều khiển, drift, NOS...). Khi kích hoạt, game sẽ chuyển sang chế độ SlowMotion, highlight các control cần thao tác, đồng thời disable các vùng khác trên màn hình để tập trung hướng dẫn.

**Cơ chế hoạt động chính:**
- SlowMotion/làm chậm gameplay khi chạy tutorial
- Lock control, highlight và hiển thị panel thông tin
- Mask đen phần màn hình không cần thao tác, chỉ để lại vùng cần thực hiện
- Mỗi panel text tự động tắt sau khoảng 2 giây (hoặc theo điều kiện tương ứng)

### **Danh sách Scripts Tutorials & Steps**

#### 1. Basic Controls 1
- **Mục đích:** Hướng dẫn các control cơ bản của xe: ga tự động, rẽ trái/phải, drift.
- **Map:** Sơn Trà Sprint
- **Trigger:** Khi người chơi vào game, trận đua đầu tiên, hết đếm ngược. Script kích hoạt khi người chơi tiến gần khúc cua đầu tiên.

| Step | Panel Text | Điều kiện hoàn thành |
|------|-----------|---------------------|
| 1 | Car Accelerates Automatically | Tự động tắt sau 2s |
| 2 | Tap & Hold To Turn Car Left | Giữ nút rẽ trái 0.5s |
| 3 | Tap & Hold To Turn Car Right | Giữ nút rẽ phải 0.5s |
| 4 | Tap to Toggle Drift On | Tap nút Drift |
| 5 | Tap & Hold to Drift Car Left | Giữ Drift trái 1s |
| 6 | Tap & Hold to Drift Car Right | Giữ Drift phải 0.5s |
| 7 | Tap to Toggle Drift Off | Tap nút Drift |
| 8 | You can change Drift Setting in the Menu | Tự động tắt sau 2s |

- Kết thúc script: khi người chơi đã thực hiện hết thao tác hoặc đủ điều kiện.

**Figma:** [Link step & giao diện](https://www.figma.com/design/j0UmML9tgnH8EK792k9Mbb/VNRacing_UX?node-id=11578-2214&t=KKGgBWTa7GfX2OVb-4)

---

#### 2. Basic Controls 2
- **Mục đích:** Hướng dẫn các chức năng nâng cao: Drift Fill NOS, sử dụng NOS.
- **Map:** Sơn Trà Circuit
- **Trigger:** Trận đua thứ hai, hết đếm ngược, sau khi người chơi bắt đầu drift.

| Step | Panel Text | Điều kiện hoàn thành |
|------|-----------|---------------------|
| 1 | Drift Score fills up NOS Meter (game sẽ tự động làm đầy bình NOS) | Tự động tắt sau 2s |
| 2 | Tap NOS For Quick Speed Boost | Người chơi tap nút NOS |

- Kết thúc script: khi người chơi hoàn thành hai thao tác chính.

**Figma:** [Link step & giao diện](https://www.figma.com/design/j0UmML9tgnH8EK792k9Mbb/VNRacing_UX?node-id=11578-2213&t=KKGgBWTa7GfX2OVb-4)

---

#### 3. VnTourMap Tutorial
- **Mục đích:** Hướng dẫn thao tác cơ bản với bản đồ VN Tour.
- **Trigger:** Kích hoạt sau khi người chơi hoàn thành đua thứ nhất và tạo lập thành công UserProfile.

| Step | Panel Text | Điều kiện hoàn thành |
|------|-----------|---------------------|
| 1 | Welcome to VNTour | Tự động tắt sau 2s |
| 2 | This is the City Map | Tự động tắt sau 2s |
| 3 | Choose one Area to Race | Người chơi chọn Area Sơn Trà |
| 4 | Choose the Next Race | Người chơi chọn Track đua Circuit trong Area Sơn Trà |
| 5 | Let's Race | Người chơi bấm nút Race |

**Figma:** [Link step & giao diện](https://www.figma.com/design/j0UmML9tgnH8EK792k9Mbb/VNRacing_UX?node-id=13048-65623&t=RM5eMmoLCZ3M6F9p-4)

---

#### 4. Basic Car Upgrade
- **Mục đích:** (Pending cập nhật chi tiết step)
- **Trigger:** Khi có hạng mục xe đủ điều kiện nâng cấp performance.
- **Điều kiện hoàn thành:** Người chơi nâng cấp tất cả slot có thể nâng cấp.

---

#### 5. Advanced Car Upgrade
- Mục đích: Đang bổ sung (Pending).
---

#### 6. Basic Car Customize
- Mục đích: Đang bổ sung (Pending).
---

---
## ON-SCREEN TUTORIALS

Các On-Screen Tutorial (ToolTips/Pop-up Info) dùng để truyền đạt thông tin quan trọng (item mới, lỗi hệ thống, trạng thái xe...) tới người chơi mà không yêu cầu thao tác, tự động biến mất sau 10s hoặc khi điều kiện panel/kịch bản không còn hợp lệ.

**Cơ chế hoạt động chính:**
- Hiển thị pop-up tooltip tại vị trí thông tin, không cần thao tác của người chơi.
- Tự động biến mất sau khoảng thời gian hoặc khi người chơi/chuyển màn hình.
- Có thể được kích hoạt lại nhiều lần (kịch bản sự kiện lặp lại).
- Được thiết kế gọn nhẹ, không làm gián đoạn trải nghiệm chính.

### **Danh sách On-Screen Tutorials chính**
| Name | Mô tả | Trigger | Điều kiện hoàn thành |
|------|------|---------|---------------------|
| New Car Upgrade Available | Xe đủ điều kiện nâng cấp performance | Nếu bất kỳ hạng mục nào đủ điều kiện | Người chơi nâng cấp xong |
| You Are Out Of Fuel | Hết nhiên liệu | Khi hết fuel | Khi người chơi hoặc hệ thống refill lại fuel |
| New Items Available In Shop | Có item mới trong shop | Khi xuất hiện hoặc unlock item mới | Người chơi vào shop kiểm tra |

**Figma:** [Link UI tooltip](https://www.figma.com/design/j0UmML9tgnH8EK792k9Mbb/VNRacing_UX?node-id=11578-1571&t=KKGgBWTa7GfX2OVb-4)

---

## HƯỚNG DẪN THAM KHẢO & LUỒNG DEBUG

- Các script và tooltip đều có bản debug kiểm tra trạng thái chi tiết thao tác và tiến trình tutorials, có thể bổ sung vào bảng debug nội bộ để kiểm tra.
- Khi phát sinh các edge case (ví dụ: người chơi thực hiện thao tác sai hoặc fail quá nhiều lần), hệ thống hỗ trợ highlight lại control, nhắc nhở lại step còn thiếu. Trường hợp đặc biệt (ví dụ: fail liên tục hoặc mất kết nối), người chơi có thể được yêu cầu thoát game.

---

## LƯU Ý ĐỊNH DẠNG
- Định dạng các bảng step & scripts giữ nguyên như file VN-Racing-Tutorials-Fixed.md, bổ sung chi tiết để đồng bộ với tài liệu gốc và file Figma UI.
- Các phần "pending" sẽ bổ sung hoàn thiện sau.

---

## TÀI LIỆU THAM KHẢO

- Figma UX: [VNRacing_UX](https://www.figma.com/design/j0UmML9tgnH8EK792k9Mbb/VNRacing_UX?node-id=11578-2214&t=KKGgBWTa7GfX2OVb-4)
- VN-Racing-Tutorials-Fixed.md (tài liệu gốc)
- Đội ngũ Dev có thể xem thêm các flows, debug, và guideline ở bảng nội bộ
---

**Bản cập nhật này đảm bảo các phần Scripts và On-Screen Tutorials nhất quán, rõ ràng, chuẩn hoá, dễ triển khai cho dev/game designer. Bạn cần chi tiết thêm cho các phần Upgrade/Customize thì phản hồi thêm để được bổ sung chi tiết từng bước!**
