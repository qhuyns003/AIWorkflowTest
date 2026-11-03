---
name: quick-fix
description: >-
  Fast-track cho thay đổi nhỏ: typo, config, message, log, rename, style fix.
  Bỏ qua Bước 1-2 của dev-workflow. Dùng khi task mô tả trong 1 câu,
  ≤3 file, ≤50 dòng, và không đụng logic nghiệp vụ/DB schema/API contract.
---
# Quick-Fix Workflow

Workflow rút gọn cho thay đổi nhỏ. **Không dùng** khi đụng DB schema, API contract, hoặc business logic.

## Điều kiện áp dụng (tất cả phải đúng)
- [ ] Thay đổi ≤ 3 file, ≤ 50 dòng
- [ ] Không đụng DB schema, API contract, business logic
- [ ] Người dùng xác nhận đây là task nhỏ
- [ ] Có thể mô tả trong 1 câu

## Steps
1. **Xác nhận scope** với người dùng: mô tả thay đổi, file ảnh hưởng.
2. **Checkout** đúng nhánh feature/bugfix ở submodule liên quan.
3. **Implement**: sửa code + chạy test/lint liên quan.
4. **Verify**: chạy build + test, đọc kết quả thật.
5. **Đề xuất commit** `[KEY] fix/chore: <mô tả>`, chờ xác nhận.
6. Cập nhật `state.md` nếu cần.

## Escalation
Nếu trong quá trình sửa phát hiện scope lớn hơn dự kiến → dừng, báo người dùng, chuyển sang `dev-workflow`.
