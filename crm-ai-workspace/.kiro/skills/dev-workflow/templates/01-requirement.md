# 01 – Phân tích yêu cầu – <JIRA-KEY>
**Nguồn BRD:** <link> · **Loại:** feature/bugfix/refactor · **Service liên quan:** ...

## 1. Tóm tắt (1-2 câu mô tả ngắn gọn về tính năng/bug này)

## 2. Actor 
- **Ai** sử dụng tính năng này? (Customer, Admin, System, ...)

## 3. Luồng nghiệp vụ
### Luồng chính (Happy Path)
1. Actor làm gì...
2. Hệ thống xử lý như thế nào...
3. Kết quả trả về...

### Luồng ngoại lệ (Alternative/Error Flow)
- Nếu... thì...
- Error case: ...

## 4. Quy tắc nghiệp vụ (Business Rules)
> Đánh số rõ ràng để dễ truy vết. Ví dụ: BR-1, BR-2...

- **BR-1**: [Mô tả rule cụ thể, có thể kiểm chứng]
- **BR-2**: ...

## 5. Dữ liệu vào/ra & Validation
### Input
- Field A: kiểu dữ liệu, required/optional, format, ví dụ
- Field B: ...

### Output
- Response format: ...
- Error codes: ...

### Validation Rules
- Field A: validate gì? (min/max length, regex, business rule nào?)
- ...

## 6. Phạm vi (Scope)
### ✅ In Scope
- Những gì **bắt buộc** phải làm trong ticket này

### ❌ Out of Scope
- Những gì **KHÔNG** làm (để tách ticket khác hoặc làm sau)

## 7. Hiện trạng (nếu có)
> Tham khảo từ `.wiki/` để biết hệ thống hiện tại đang như thế nào

- Hiện tại đang có gì liên quan?
- Phải chỉnh sửa/mở rộng gì?

## 8. Tiêu chí chấp nhận (Acceptance Criteria)
> Format: Given-When-Then, phải kiểm chứng được

- **AC-1**: Given [điều kiện đầu], When [hành động], Then [kết quả mong đợi]
- **AC-2**: ...

## 9. Giả định (Assumptions)
- Giả định gì về dữ liệu, môi trường, dependencies?
- Điều gì chưa rõ và cần xác nhận với PO/BA?

## 10. Câu hỏi & Quyết định nghiệp vụ

> **🚨 QUAN TRỌNG - Phase 1 = NGHIỆP VỤ ONLY:**
> - ✅ CHỈ HỎI: Business logic, validation rules (nghiệp vụ), edge cases, data meaning
> - ❌ KHÔNG HỎI: API path, HTTP method, response format, database choice, framework, code structure
> 
> **📖 Tham khảo**: Đọc `reference/question-bank.md` để biết phân biệt câu hỏi nghiệp vụ vs kỹ thuật
> 
> **Ví dụ câu hỏi NGHIỆP VỤ hợp lệ**:
> - ✅ "Số điện thoại có phân biệt định dạng quốc gia (với +84) vs nội địa (với 0) không?"
> - ✅ "Khách hàng inactive có được search không?"
> - ✅ "Nếu số điện thoại trùng lặp (nhiều records), trả về record nào?"
> 
> **Ví dụ câu hỏi KỸ THUẬT (defer to Phase 2)**:
> - ❌ "API endpoint path nên là `/api/customers/search?phone=xxx` hay `/api/customers/{phoneNumber}`?"
> - ❌ "Response format có wrapper object không?"
> - ❌ "Database dùng H2 in-memory hay file-based?"

| # | Vấn đề cần chốt | Quyết định | Lý do | Impact (cập nhật mục nào?) |
|---|-----------------|------------|-------|----------------------------|
| Q1 | [Câu hỏi nghiệp vụ chưa rõ?] | [Phương án đã chọn] | [1 câu lý do] | Cập nhật Mục 4 (BR-X) / Mục 6 (Scope) / Mục 8 (AC-X) |
| Q2 | ... | ... | ... | ... |

> ✅ **Sau khi chốt quyết định**: Cập nhật **NGAY** vào Mục 4 (thêm BR mới), Mục 6 (điều chỉnh scope), Mục 8 (sửa AC) để tài liệu là **Source of Truth**.
> 
> ⚠️ **Self-Review trước khi trình bày G1**: Đọc lại Section 10, loại bỏ mọi câu hỏi kỹ thuật (có từ khóa: API, endpoint, HTTP, database, format, framework).

