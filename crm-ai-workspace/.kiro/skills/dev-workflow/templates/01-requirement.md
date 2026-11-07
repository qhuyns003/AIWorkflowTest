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

<section_10_guidelines>
  <phase_1_golden_rule>
    <title>Phase 1 = NGHIỆP VỤ ONLY</title>
    <allowed>
      - ✅ Business logic questions
      - ✅ Validation rules (what to validate, not which library)
      - ✅ Edge cases (business scenarios)
      - ✅ Data meaning (what field represents in business)
    </allowed>
    <forbidden>
      - ❌ API path, HTTP method, response format
      - ❌ Database choice, framework, code structure
      - ❌ Technical implementation details
    </forbidden>
  </phase_1_golden_rule>
  
  <reference>
    Read reference/question-bank.md for examples distinguishing business vs technical questions
  </reference>
  
  <examples>
    <business_questions_valid>
      - ✅ "Số điện thoại có phân biệt định dạng quốc gia (với +84) vs nội địa (với 0) không?"
      - ✅ "Khách hàng inactive có được search không?"
      - ✅ "Nếu số điện thoại trùng lặp (nhiều records), trả về record nào?"
    </business_questions_valid>
    
    <technical_questions_defer_to_phase2>
      - ❌ "API endpoint path nên là /api/customers/search?phone=xxx hay /api/customers/{phoneNumber}?"
      - ❌ "Response format có wrapper object không?"
      - ❌ "Database dùng H2 in-memory hay file-based?"
    </technical_questions_defer_to_phase2>
  </examples>
  
  <self_review_checklist>
    <instruction>BEFORE presenting at G1, you MUST:</instruction>
    <items>
      <item>1. Search this section for keywords: API, endpoint, HTTP, database, format, framework, library</item>
      <item>2. If ANY keyword found → DELETE that question, note "Defer to Phase 2"</item>
      <item>3. Verify ALL remaining questions are business-focused</item>
      <item>4. Ensure each question has 2+ alternatives with pros/cons</item>
    </items>
  </self_review_checklist>
</section_10_guidelines>

### Questions Table

| # | Vấn đề cần chốt | Phương án | Đề xuất & Lý do | Impact (cập nhật mục nào?) |
|---|-----------------|-----------|-----------------|----------------------------|
| Q1 | [Câu hỏi nghiệp vụ chưa rõ?] | A: [Option A]<br>B: [Option B] | Đề xuất: [A/B]<br>Lý do: [1-2 câu] | Cập nhật Mục 4 (BR-X) / Mục 6 (Scope) / Mục 8 (AC-X) |
| Q2 | ... | A: ...<br>B: ... | Đề xuất: ...<br>Lý do: ... | ... |

### Decisions Made (After G1 Discussion)

| # | Vấn đề | Quyết định đã chốt | Lý do | Đã cập nhật |
|---|--------|-------------------|-------|-------------|
| Q1 | [Issue] | [Chosen option] | [Rationale] | ✅ Mục 4 (BR-3), Mục 8 (AC-2) |
| Q2 | ... | ... | ... | ✅ Mục ... |

<post_g1_instruction>
  After G1 approval and decisions made:
  1. Fill "Decisions Made" table above
  2. Update relevant sections immediately:
     - Business rule → Add to Section 4 (BR-X)
     - Scope change → Update Section 6
     - Acceptance criteria → Update Section 8 (AC-X)
  3. This document becomes the Source of Truth - keep it synchronized
</post_g1_instruction>

