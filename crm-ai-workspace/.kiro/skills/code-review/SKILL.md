---
name: code-review
description: >-
  Review code độc lập sau khi implement, theo hai tầng: đúng spec và chất lượng code.
  Dùng ở Bước 4 của dev-workflow. Chạy trong context riêng, không dựa vào 
  lý luận của lúc code.
---
# Code Review (2 tầng)

Chạy trong context riêng, không dùng context của lúc code.

## Tầng 1 – Đúng spec
So diff với `01-requirement.md` và `02-design.md`:
- Thiếu gì? Thừa gì? Lệch gì?

## Tầng 2 – Chất lượng code
| Aspect | Check |
|---|---|
| Convention | Theo coding style của service? |
| Xử lý lỗi | Catch đúng exception? Propagate đúng? |
| Bảo mật | Validate input? AuthZ? Log dữ liệu nhạy cảm? |
| Hiệu năng | N+1? Giao dịch? Index? |
| Test | Đủ + có ý nghĩa? Mock hợp lý? |
| Tương thích | Breaking change? Migration rollback? |

## Tools
Có thể chạy: `git diff`, build, test, lint.

## Output format
Danh sách theo **Blocker / Major / Minor**, mỗi mục:
- `đường_dẫn:dòng`
- Vấn đề
- Đề xuất sửa

**Không tự sửa code.**
