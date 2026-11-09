# 02 – Thiết Kế – <JIRA-KEY> – TX: <subtask-name>

> Định hướng giải pháp (WHAT) - Phase 3 sẽ implement (HOW).  
> Tham khảo tài liệu thiết kế mẫu hoàn chỉnh tại: [../reference/design-examples.md](../reference/design-examples.md)

<design_checklist>
  <items>
    <item id="1">✅ Đọc TX-&lt;slug&gt;/01-requirement.md (đã duyệt G1)</item>
    <item id="2">✅ Gọi agent impact-analysis</item>
    <item id="3">✅ Bảng ADR: mỗi quyết định có 2-3 phương án</item>
    <item id="4">✅ Luồng xử lý: đi qua đâu, gọi hàm nào</item>
    <item id="5">✅ Components to Modify: file path + định hướng</item>
    <item id="6">✅ Build command rõ ràng</item>
    <item id="7">✅ Gọi agent design-review trước G2</item>
  </items>
</design_checklist>

---

## 1. Bối Cảnh

**Requirement**: TX-&lt;slug&gt;/01-requirement.md (đã duyệt G1)  
**Mục tiêu**: [1 câu mô tả mục tiêu subtask]  
**Giá trị nghiệp vụ**: [Tại sao làm]

---

## 2. Quyết Định Kỹ Thuật (ADR)

| # | Quyết định | Phương án A | Phương án B | Chọn | Lý do |
|---|-----------|-------------|-------------|------|-------|
| 1 | [Tên quyết định] | [A] | [B] | ✅ A/B | [Ngắn gọn] |
| 2 | [Tên quyết định] | [A] | [B] | ✅ A/B | [Ngắn gọn] |

**Ví dụ các quyết định:**
- API endpoint: `/api/resource/search?q=X` vs `/api/resource/{id}`
- Xử lý: Đồng bộ vs Bất đồng bộ
- Tái sử dụng: Function có sẵn vs Tạo mới
- Response: Wrap trong object vs Trả trực tiếp

---

## 3. Luồng Xử Lý

**Trình tự:** [Mô tả các bước theo thứ tự]

**Ví dụ:**
1. Client → GET /api/customers/search?phone=X
2. Controller validate → gọi Service.searchByPhone()
3. Service normalize → validate → query Repository
4. Repository findByPhoneAndStatus() → trả Optional
5. Service map Entity→DTO → wrap ApiResponse → return

**Tương tác giữa components:**
- Controller ↔ Service: Truyền params, nhận DTO
- Service ↔ Repository: Query có filter
- Service ↔ Utils: Normalize/validate data

---

## 4. Hướng Dẫn Triển Khai (WHAT to Change)

| Layer | File Path | Định hướng thay đổi |
|-------|-----------|---------------------|
| Controller | src/.../CustomerController.java | Thêm endpoint GET /search, param: phone, return: ApiResponse&lt;CustomerDTO&gt; |
| Service | src/.../CustomerService.java | Thêm searchByPhone(), tái sử dụng PhoneUtils.normalize(), query repo |
| Repository | src/.../CustomerRepository.java | Thêm findByPhoneNumberAndStatus(), return Optional |
| Utility | src/.../PhoneUtils.java | Tái sử dụng normalize() và validate() có sẵn |
| DTO | src/.../CustomerDTO.java | Dùng có sẵn hoặc tạo mới: id, name, phone, email |

**Logic chính cần biết:**
- Chuẩn hóa phone: +84→0, bỏ khoảng trắng/gạch ngang
- Validation: regex ^0\d{9,10}$
- Lọc status: Chỉ query ACTIVE customers
- Xử lý trùng: Trả bản ghi mới nhất (created_at DESC)
- Error handling: Throw InvalidPhoneFormatException → 400

---

## 5. API Contract (nếu có)

### Endpoint: GET /api/customers/search

**Request:**
- Query param: `phone` (String, bắt buộc, format: 0xxxxxxxxx)

**Response 200 OK:**
```json
{"data": {"id": 1, "name": "...", "phone": "..."}, "message": "Tìm thấy"}
```

**Response 404:**
```json
{"data": null, "message": "Không tìm thấy với phone: X"}
```

**Response 400:**
```json
{"error": "INVALID_PHONE_FORMAT", "message": "Format không hợp lệ"}
```

---

## 6. Database Changes (nếu có)

**Bảng:** `customers`  
**Thay đổi:**
- Thêm cột: phone_number (VARCHAR 50), email (VARCHAR 255 UNIQUE), status (VARCHAR 50, default 'ACTIVE')
- Thêm index: (phone_number, status) để tối ưu search

**Migration:**
- Tool: Flyway
- File: V1__create_customers_table.sql
- Rollback: Drop index → Drop table

**Lý do:**
- Composite index: Cover WHERE clause (phone + status)
- Không UNIQUE phone: Nghiệp vụ cho phép trùng
- Status uppercase: Theo .wiki/database.md convention

---

## 7. Verification

**Lệnh build:**
```bash
cd src/service-a && mvn -q -DskipTests package
```

**Kết quả mong đợi:**
```
[INFO] BUILD SUCCESS
Exit code: 0
```

---

## 8. Design Review

**Agent:** design-review | **Ngày:** [YYYY-MM-DD]

| # | Vấn đề | Mức độ | Giải quyết | Status |
|---|--------|--------|------------|--------|
| 1 | [Mô tả] | High/Med/Low | [Cách sửa] | ✅ |

**Tóm tắt:** [X issues → Y fixed]
