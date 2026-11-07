# Ví Dụ: Session Flow Đầy Đủ

> **Tài liệu tham khảo (Level 3 Resource)**: Mô phỏng toàn bộ luồng hội thoại giữa Dev và Orchestrator qua 4 Phase.

**Ticket**: CRM-123 - Customer Search  
**Subtasks**: T1 (search by phone), T2 (search by email), T3 (search by name)

---

## Session Transcript

**Dev**: "Bắt đầu task CRM-123"

**Orchestrator**: 
```
Hiểu rồi. Tôi sẽ invoke Phase 0 để chia subtasks.
[disclose_context("dev-phase-0-decompose")]
```

**Phase 0 skill** trình bày:
```
**Checklist Phase 0 Hoàn thành: 8/8 mục**
- Mục #1 (Đọc BRD): ✅ Xong
- Mục #2 (Tra wiki): ✅ Xong
- Mục #3 (Quy tắc chia): ✅ Xong
- Mục #4 (Use-case end-to-end): ✅ Xong
- Mục #5 (Mục tiêu rõ ràng): ✅ Xong
- Mục #6 (Số lượng hợp lý): ✅ Xong
- Mục #7 (Nhánh feature): ✅ Xong
- Mục #8 (Cấu trúc thư mục): ✅ Xong

**Subtasks**:
| ID | Name | Business Value |
|----|------|----------------|
| T1 | Search by phone | User tìm KH bằng SĐT |
| T2 | Search by email | User tìm KH bằng email |

⚠️ **ĐÃ DỪNG tại G0** - Có đồng ý cách chia này không?
```

**Dev**: "OK, hợp lý"

**Orchestrator**:
```
Bắt đầu T1. Tôi sẽ invoke Phase 1 để phân tích requirement.
[disclose_context("dev-phase-1-requirements")]
```

**Phase 1 skill** trình bày:
```
**Checklist Phase 1-T1 Hoàn thành: 5/5 mục**
- Đã đọc Section 10 & loại bỏ toàn bộ từ khóa kỹ thuật
- Tóm tắt nghiệp vụ, AC, BR

**Câu hỏi nghiệp vụ**:
Q1. SĐT trùng lặp: Trả tất cả hay customer mới nhất?
- Phương án A: Trả tất cả (User tự chọn)
- Phương án B: Trả customer mới nhất (Đề xuất)

⚠️ **ĐÃ DỪNG tại G1-T1** - Nghiệp vụ có đúng không?
```

**Dev**: "OK, đúng nghiệp vụ"

**Orchestrator**:
```
Chuyển sang Phase 2 - thiết kế kỹ thuật cho T1.
[disclose_context("dev-phase-2-design")]
```

**Phase 2 skill** trình bày:
```
**Checklist Phase 2-T1 Hoàn thành: 7/7 mục**
- Đã gọi impact-analysis: Tìm thấy CustomerRepository pattern
- Đã gọi design-review: Không có blocker

**Bảng ADR**:
| # | Quyết định | Phương án A | Phương án B | Chọn |
| 1 | API endpoint | GET /customers/search?phone=X | GET /customers/{phone} | A |

**Luồng xử lý**: Client → Controller → CustomerService → CustomerRepository
**Components to Modify**: CustomerController.java, CustomerService.java

⚠️ **ĐÃ DỪNG tại G2-T1** - Thiết kế có ổn không?
```

**Dev**: "OK, thiết kế ổn"

**Orchestrator**:
```
Chuyển sang Phase 3 - implementation cho T1.
[disclose_context("dev-phase-3-implement")]
```

**Phase 3 skill** trình bày:
```
**Checklist Phase 3-T1 Hoàn thành: 7/7 mục**
- Đã khảo sát mã nguồn touch points
- Đã implement logic theo luồng và components định hướng

**Build Output**:
[INFO] Scanning for projects...
[INFO] BUILD SUCCESS
Exit code: 0

**Diff**: 4 files, 240 dòng thay đổi
- CustomerRepository.java
- CustomerService.java
- CustomerController.java
- CustomerDTO.java

⚠️ **ĐÃ DỪNG TẠI G3-T1** - Chờ xác nhận: "OK, tiếp tục T2"

💡 **Gợi ý tiết kiệm context**:
T1 vừa xong có diff 240 dòng + build log. Còn 2 subtasks (T2, T3) chưa làm.
Bạn có thể mở session mới cho T2 để context sạch và tiết kiệm token.
```

**Dev**: "OK, tiếp tục T2"

**Orchestrator**:
```
Bắt đầu T2. Tôi sẽ invoke Phase 1 cho T2.
[disclose_context("dev-phase-1-requirements")]
```

*(Lặp lại Phase 1→2→3 cho T2, rồi T3)*

**Dev**: "OK, hoàn tất" (sau G3-T3)

**Orchestrator**:
```
Tất cả subtasks đã xong. Chuyển sang Phase 4.

1. Code Review:
[invoke_sub_agent("code-review")]
→ Kết quả: APPROVED (không có lỗi)

2. Nghiệm thu: Bạn có duyệt toàn bộ ticket không?

3. 💡 Nhắc Jira: Nhớ chuyển trạng thái sang Done/QA + comment tóm tắt

4. Gợi ý: Chạy `update-workspace` để sync wiki và hoàn tất vòng đời
```

