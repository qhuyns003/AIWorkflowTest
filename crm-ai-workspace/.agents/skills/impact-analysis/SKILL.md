---
name: impact-analysis
description: >-
  Khảo sát tác động của một yêu cầu lên các service/module/API/DB. 
  Dùng ở Bước 1-2 của dev-workflow và trước khi sửa code.
  Trả về tóm tắt ngắn để session chính không phải đọc lại nhiều file.
---
# Impact Analysis

Tra `.wiki/` trước, rồi đọc code liên quan. **Không sửa file.**

## Output format
Trả về bản tóm tắt ngắn gọn (tối đa 30 dòng):
1. **Luồng hiện tại** liên quan (file/hàm chính, `đường_dẫn:dòng`).
2. **Thành phần bị ảnh hưởng**: service, module, API, bảng DB, message, cấu hình.
3. **Pattern/tiện ích** có thể tái sử dụng.
4. **Rủi ro** và điểm chưa rõ cần hỏi người dùng.
5. **Test hiện có** nên chạy lại.

## Nguyên tắc
- Grep/search targeted, không đọc toàn bộ file.
- Chỉ đọc function signatures + logic cốt lõi, bỏ qua boilerplate.
- Kết quả gọn, dùng bảng khi có thể.
