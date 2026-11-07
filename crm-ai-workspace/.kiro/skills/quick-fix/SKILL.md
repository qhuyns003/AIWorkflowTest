---
name: quick-fix
description: >-
  Fast-track sửa trực tiếp các thay đổi nhỏ (≤3 file, ≤50 dòng) như typo, config, log, message, rename.
  Dùng khi người dùng nói "sửa typo", "đổi config", "thêm log này", "quick fix".
  Không dùng khi thay đổi logic nghiệp vụ, API contract hay database schema (hãy dùng dev-workflow).
---
# Quick-Fix Workflow

Workflow rút gọn cho thay đổi nhỏ. **Không dùng** khi đụng DB schema, API contract, hoặc business logic.

## Điều kiện áp dụng (tất cả phải đúng)
- [ ] Thay đổi ≤ 3 file, ≤ 50 dòng
- [ ] Không đụng DB schema, API contract, business logic
- [ ] Người dùng xác nhận đây là task nhỏ
- [ ] Có thể mô tả trong 1 câu

## Steps
1. **Look & Xác nhận scope**: Đọc file cần sửa (không hỏi lại thứ đã rõ trong code). Mô tả thay đổi và file ảnh hưởng.
2. **Checkout**: Đúng nhánh feature/bugfix ở submodule liên quan.
3. **Implement**: Sửa code + chạy test/lint liên quan.
4. **Verify**: Chạy build + test, đọc kết quả thật (exit code 0).
5. **Đề xuất commit**: `[KEY] fix/chore: <mô tả>`, chờ xác nhận.
6. Cập nhật `state.md` nếu cần.

## Escalation
Nếu trong quá trình sửa phát hiện scope lớn hơn dự kiến → dừng, báo người dùng, chuyển sang `dev-workflow`.

## 🛡️ Guard
- alone: đọc file, sửa trực tiếp ≤3 files, chạy test/build/lint tại chỗ.
- asks first: bất kỳ thay đổi nào vượt quá 3 files hoặc >50 dòng; chuyển sang dev-workflow.
- never: sửa logic nghiệp vụ, sửa DB schema/API contract; tự git commit/push.


