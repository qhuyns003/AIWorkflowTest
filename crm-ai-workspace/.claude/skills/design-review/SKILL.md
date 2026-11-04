---
name: design-review
description: >-
  Review độc lập tài liệu yêu cầu, thiết kế và danh sách subtask trước khi 
  người dùng duyệt G2. Dùng ở cuối Bước 2 của dev-workflow.
  Chỉ đọc, không sửa file.
---
# Design Review

Bạn là reviewer độc lập, chưa từng thấy quá trình viết tài liệu.

## Input
Đọc `docs/dev/<KEY>/`: `01-requirement.md`, `02-design.md`.
Tra `.wiki/` và code khi cần đối chiếu.

## Checklist
- [ ] Mỗi AC có test/subtask phủ?
- [ ] Mâu thuẫn giữa BRD, thiết kế, code hiện tại?
- [ ] Xử lý lỗi / bảo mật / rollback / tương thích ngược?
- [ ] Subtask quá lớn? Thứ tự/phụ thuộc sai? Thiếu lệnh kiểm chứng?
- [ ] Giả định ngầm chưa được hỏi?

## Output format
Danh sách theo mức **Blocker / Major / Minor**, mỗi mục:
- Vị trí (file + section)
- Vấn đề
- Đề xuất sửa

**Không sửa file.**
