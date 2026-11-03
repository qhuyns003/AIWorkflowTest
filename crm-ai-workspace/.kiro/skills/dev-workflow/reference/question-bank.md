# Ngân hàng câu hỏi tham khảo (Question Bank - Reference Only)

> **Tài liệu tham khảo gợi ý góc nhìn, KHÔNG bắt buộc rập khuôn.**  
> AI không bị giới hạn số lượng câu hỏi hay phạm vi danh sách dưới đây. Mục tiêu tối thượng là **chủ động trao đổi, phát hiện và làm rõ mọi điểm còn mơ hồ, thiếu sót, mâu thuẫn hoặc có nguy cơ tiềm ẩn** trước khi bắt tay vào thiết kế và viết code.

---

## 1. Nguyên tắc đặt câu hỏi & trao đổi
- **Không giới hạn số lượng câu hỏi**: Hỏi đủ những gì cần làm rõ, không kiềm chế vì giới hạn số lượng.
- **Tập trung vào điểm mơ hồ & rủi ro tiềm ẩn**:
  - Nghiệp vụ chưa rõ biên (edge cases, dữ liệu biên, luồng ngoại lệ, dữ liệu cũ).
  - Mâu thuẫn giữa BRD và hiện trạng mã nguồn thực tế.
  - Nguy cơ breaking change với API hiện tại hoặc ảnh hưởng dịch vụ khác.
  - Rủi ro về concurrency (đồng thời), hiệu năng, bảo mật hoặc rollback DB.
- **Luôn kèm phương án đề xuất**: Đặt câu hỏi kèm theo 2–3 phương án xử lý khả thi, nêu rõ ưu/nhược và phương án AI khuyến nghị để người dùng duyệt nhanh.

---

## 2. Gợi ý các góc nhìn nghiệp vụ (Bước 1 – Cổng G1)
- **Mục tiêu & giá trị**: Vấn đề cần giải quyết là gì, ai hưởng lợi, tiêu chí thành công?
- **Actor & phân quyền**: Ai được thao tác (role/kênh)? Ai được xem/sửa/duyệt? Phân quyền theo chi nhánh/đơn vị?
- **Luồng nghiệp vụ**: Luồng chính, luồng ngoại lệ, điều kiện tiên quyết (pre-conditions), hậu điều kiện (post-conditions).
- **Quy tắc & công thức**: Điều kiện validate, hạn mức, làm tròn, đơn vị tiền tệ, múi giờ, xử lý ngày làm việc/ngày nghỉ.
- **Dữ liệu & trạng thái**: Bắt buộc hay tùy chọn? Giá trị mặc định? Xử lý dữ liệu lịch sử/dữ liệu cũ thế nào?
- **Edge cases & Rủi ro tiềm ẩn**: Rỗng/null, trùng lặp, vượt hạn mức, 2 người cùng sửa đồng thời, hủy/hoàn tác giữa chừng.
- **Tích hợp ngoài**: Hệ thống ngoài nào liên quan? Nếu hệ thống ngoài lỗi hoặc phản hồi chậm thì ứng xử thế nào?
- **Phạm vi In/Out**: Cái gì làm trong ticket này, cái gì dứt khoát không làm / để phase sau?

---

## 3. Gợi ý các góc nhìn kỹ thuật (Bước 2 – Cổng G2)
- **Kiến trúc & Vị trí logic**: Đặt logic ở service nào/tầng nào? Tái sử dụng thành phần nào đã có?
- **API Contract**: Thêm mới hay mở rộng endpoint cũ? Request/Response DTO, mã lỗi, tính tương thích ngược, idempotency.
- **Database**: Cột/bảng mới, migration Flyway/Liquibase, index tối ưu, khóa bản ghi (pessimistic/optimistic lock), kế hoạch rollback.
- **Giao tiếp & Đồng bộ**: REST trực tiếp hay Message Queue (Kafka/RabbitMQ)? Retry, timeout, circuit breaker.
- **Bảo mật & Tuân thủ**: Xác thực/phân quyền, che giấu dữ liệu nhạy cảm trong log (masking), kiểm tra injection.
- **Hiệu năng & Tải**: Truy vấn N+1, caching (Redis), phân trang, xử lý batch cho khối lượng dữ liệu lớn.

---

## 4. Mẫu trình bày câu hỏi đề xuất phương án
> **1. Câu hỏi nghiệp vụ/kỹ thuật cần làm rõ?**  
> - **(Đề xuất) Phương án A**: [Mô tả chi tiết giải pháp đề xuất] – *Lý do: [Nêu ưu điểm, tương thích kiến trúc hiện tại].*  
> - **Phương án B**: [Mô tả phương án thay thế] – *Đánh giá: [Ưu/nhược điểm].*  
> - **Phương án C**: Lựa chọn khác (mời người dùng cho ý kiến).
