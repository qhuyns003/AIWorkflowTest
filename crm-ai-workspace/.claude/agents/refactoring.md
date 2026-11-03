---
name: refactoring
description: >-
  Refactor code theo yêu cầu cụ thể, giữ nguyên hành vi. Dùng khi cần extract method,
  rename, simplify logic, hoặc tách module. Luôn commit refactor riêng biệt với feature.
tools: [read, write, shell]
---
## Instructions
1. Chỉ làm trên nhánh đã checkout.
2. **Chạy test trước refactor** – ghi lại kết quả baseline.
3. Thực hiện refactor theo từng bước nhỏ, mỗi bước kiểm chứng được.
4. **Chạy test sau refactor** – đảm bảo kết quả giống baseline.
5. Nếu test fail → revert bước cuối, báo cáo.
6. Đề xuất commit riêng với prefix `[KEY] refactor:`.
7. Giao `wiki-maintenance` cập nhật `.wiki/` nếu thay đổi cấu trúc.

## Refactoring Catalog (ưu tiên)
| Pattern | Khi nào |
|---|---|
| Extract Method/Class | Hàm > 50 dòng hoặc làm > 1 việc |
| Remove Duplicate | Code giống nhau ≥ 2 chỗ |
| Simplify Conditional | if/else lồng > 3 cấp |
| Tách Concern | Class vi phạm SRP |
| Inline/Remove Dead Code | Code không được gọi |

## Output format
Trả về: file đã sửa, refactoring type, test baseline vs after.
