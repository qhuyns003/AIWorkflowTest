# Ngân hàng câu hỏi tham khảo (Question Bank)

> **Mục tiêu**: Hướng dẫn đặt câu hỏi nghiệp vụ (Phase 1) đúng trọng tâm, tránh sa đà vào kỹ thuật (Phase 2).  
> **Nguyên tắc**: Hỏi **WHAT/WHY** (nghiệp vụ), cấm hỏi **HOW** (kỹ thuật). Luôn kèm 2 phương án + đề xuất.

---

## 1. Bảng Đối Chiếu: Nghiệp Vụ (Phase 1) vs Kỹ Thuật (Phase 2)

| Chủ đề | ❌ Cấm ở Phase 1 (Kỹ thuật - HOW) | ✅ Dùng ở Phase 1 (Nghiệp vụ - WHAT/WHY) | 📌 Chuyển sang Phase 2 |
|---|---|---|---|
| **Đầu vào** | Dùng endpoint `/search?phone=X` hay `/by-phone/{phone}`? Regex check ở đâu? | Có hỗ trợ đầu số quốc tế (`+84`) hay chỉ nội địa (`0`)? Cho phép nhập khoảng trắng không? | ADR Endpoint & vị trí đặt Validator |
| **Trùng lặp** | Query DB dùng `findTop` hay `findAll`? Trả List hay Object? | Nếu nhiều người trùng SĐT: hiển thị danh sách để chọn hay tự lấy bản ghi mới nhất? | ADR Luồng Deduplication & Response Contract |
| **Trạng thái** | Lọc `status = 'ACTIVE'` trong SQL WHERE hay Java Stream? | Khách hàng bị khóa (`LOCKED`) hoặc đã đóng (`CLOSED`) có được hiển thị khi tìm không? | DB Schema Index & JPA Query Filter |
| **Phân quyền** | Dùng `@PreAuthorize` hay kiểm tra SecurityContext? | Nhân viên cấp 1 có được thấy đủ SĐT/CCCD không, hay phải che (`091***678`)? | DTO Masking / Serializer |
| **Lỗi & UX** | Trả HTTP 404 hay 200 kèm `data: null`? | Khi không tìm thấy khách: chỉ báo lỗi dừng lại hay gợi ý nút "Tạo khách hàng mới"? | Error Contract & RFC 7807 Exception |
| **Đồng thời** | Dùng Optimistic Lock `@Version` hay Pessimistic Lock? | Hai nhân viên cùng sửa 1 khách: ghi đè người cuối hay cảnh báo xung đột? | ADR Concurrency Strategy |
| **Tích hợp** | Timeout WebClient mấy giây? Dùng Circuit Breaker nào? | Dịch vụ eKYC ngoài bị chậm/lỗi: dừng màn hình hay cho lưu tạm chờ duyệt sau? | ADR Fallback & Retry Strategy |
| **Hạn mức** | Cột DB lưu `BigDecimal` hay `Double`? | Hạn mức giao dịch tối đa/ngày là bao nhiêu? Có làm tròn tiền lẻ thập phân không? | DB Schema precision & Business Calculation |

---

## 2. Format Chuẩn & Ví Dụ Mẫu (Section 10)

### Format chuẩn (ngắn gọn, đủ ý)
```markdown
### Q[X]. [Tên vấn đề nghiệp vụ]
- **(Đề xuất) Phương án A**: [Giải pháp tối ưu UX/vận hành] — *Ưu: [...] · Nhược: [...]*
- **Phương án B**: [Giải pháp thay thế/đơn giản hóa] — *Ưu: [...] · Nhược: [...]*
→ **Đề xuất**: Chọn [A/B] vì [lý do nghiệp vụ].
→ **Ánh xạ**: Ghi vào `BR-[X]` (Business Rules) và `AC-[Y]` (Acceptance Criteria).
```

---

### Ví dụ 1: Chuẩn hóa dữ liệu đầu vào
```markdown
### Q1. Xử lý số điện thoại có tiền tố +84 hoặc khoảng trắng
- **(Đề xuất) Phương án A**: Tự động chuẩn hóa về `0xxxxxxxxx` trước khi tra cứu.
  *Ưu: Thân thiện người dùng, tiện copy-paste · Nhược: Cần thêm rule chuẩn hóa*.
- **Phương án B**: Bắt buộc nhập đúng 10 chữ số bắt đầu bằng 0, sai báo lỗi ngay.
  *Ưu: Hệ thống đơn giản · Nhược: Bất tiện cho nhân viên tổng đài*.
→ **Đề xuất**: Chọn A để tối ưu tốc độ thao tác của nhân viên.
→ **Ánh xạ**: Ghi vào `BR-1` (tự động chuẩn hóa) và `AC-1` (nhập +84 vẫn ra kết quả).
```

---

### Ví dụ 2: Xử lý dữ liệu trùng lặp (Edge Case)
```markdown
### Q2. Ứng xử khi nhiều khách hàng dùng chung 1 số điện thoại
- **(Đề xuất) Phương án A**: Trả về danh sách tất cả khách hàng trùng SĐT để nhân viên tự xác nhận với người gọi.
  *Ưu: Chính xác, không nhầm lẫn tài khoản · Nhược: UI/API cần hỗ trợ hiển thị dạng danh sách*.
- **Phương án B**: Chỉ trả về 1 khách hàng ACTIVE có cập nhật gần nhất.
  *Ưu: Giao diện gọn · Nhược: Rủi ro thao tác nhầm người*.
→ **Đề xuất**: Chọn A để đảm bảo an toàn định danh tài khoản.
→ **Ánh xạ**: Ghi vào `BR-2` (cho phép hiển thị danh sách trùng) và `AC-2`.
```

---

## 3. Checklist Tự Soi Nhanh Trước Cổng G1

Trước khi gửi câu hỏi cho dev tại G1, scan nhanh Section 10:
- [ ] **Chứa từ khóa kỹ thuật?** (`API`, `endpoint`, `HTTP`, `JSON`, `DB`, `table`, `class`, `method`, `Spring`) $\to$ **XÓA NGAY**, chuyển sang Phase 2.
- [ ] **Mỗi câu hỏi có tối thiểu 2 phương án?** $\to$ Bắt buộc có Phương án A (kèm đề xuất) và Phương án B.
- [ ] **Đã có ánh xạ?** $\to$ Mỗi quyết định phải truy vết được vào `BR-X`, `AC-Y` hoặc `Scope`.
