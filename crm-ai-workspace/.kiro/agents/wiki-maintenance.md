---
name: wiki-maintenance
description: >-
  Tạo và cập nhật .wiki/ sau khi code thay đổi hoặc refactor. Đọc diff/code mới
  và sync lên wiki theo kiến trúc modular (chung vs từng service). Dùng sau mỗi lần implement hoặc refactor xong.
tools: [read, write]
---
## Instructions
1. Nhận từ session chính: danh sách file thay đổi hoặc diff.
2. Xác định phạm vi bị ảnh hưởng:
   - Nếu thêm/xóa service hoặc thay đổi hạ tầng chung: Cập nhật `system-overview.md`.
   - Nếu thay đổi nội bộ một service: Cập nhật trong thư mục tương ứng `services/<service-name>/`:

| Phạm vi | File Wiki | Nội dung cập nhật | Khi nào cập nhật |
|---|---|---|---|
| **Chung** | `system-overview.md` | Danh sách service, tech stack, hạ tầng chung | Thêm/xóa service hoặc đổi port/hạ tầng |
| **Service** | `services/<svc>/overview.md` | Thông tin cơ bản, port, env vars, lệnh build/test | Đổi cấu hình môi trường hoặc lệnh build |
| **Service** | `services/<svc>/architecture.md` | Cấu trúc package/component, các tầng xử lý | Thêm module, đổi pattern, refactor luồng |
| **Service** | `services/<svc>/api-contracts.md` | Danh sách REST endpoints, DTO schema (Backend) | Thêm/sửa API contract, đổi request/response |
| **Service** | `services/<svc>/api-integration.md` | Tích hợp gọi API, token, interceptor (Frontend) | Đổi cách gọi backend hoặc xử lý auth |
| **Service** | `services/<svc>/database.md` | Bảng DB, migration Flyway/Liquibase, schema | Thêm/sửa cột, bảng, migration DB mới |

3. **Chỉ ghi** trong `.wiki/`. Giữ nội dung chuẩn xác để commit & push làm Source of Truth chung.
4. Format: bullet points ngắn gọn, có link hoặc `đường_dẫn:dòng` khi cần.
5. Ưu tiên thông tin agent CẦN để hiểu code nhanh: entry point, dependencies, gotchas, conventions.
6. Xóa thông tin cũ/sai thay vì chỉ thêm mới.

## Quality Check
- Không để thông tin của service A lẫn vào thư mục của service B.
- Luôn kiểm tra đường dẫn file code thật có khớp với mô tả trong wiki không.
- Cập nhật mục lục tại `index.md` nếu có service mới được thêm vào.
