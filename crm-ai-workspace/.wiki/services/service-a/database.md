# service-a – Database Schema

## 1. Công nghệ & Migration
- **Database Engine**: PostgreSQL / MySQL
- **Migration Tool**: Flyway (thư mục: `src/service-a/src/main/resources/db/migration/`)
- **Naming Convention**:
  - Tên bảng: Chữ thường số nhiều, nối dấu gạch dưới (snake_case), ví dụ: `customers`, `customer_addresses`.
  - Khóa chính: `id` (BIGINT hoặc UUID).
  - Khóa ngoại: `<tên_thực_thể>_id`, ví dụ: `customer_id`.

## 2. Bảng dữ liệu chính
### Bảng `customers`
| Cột | Kiểu dữ liệu | Ràng buộc | Ý nghĩa |
|---|---|---|---|
| `id` | BIGSERIAL | PRIMARY KEY | Định danh khách hàng |
| `full_name` | VARCHAR(255) | NOT NULL | Họ và tên |
| `email` | VARCHAR(255) | UNIQUE, NOT NULL | Địa chỉ email |
| `phone_number` | VARCHAR(50) | NOT NULL | Số điện thoại |
| `date_of_birth` | DATE | NULL | Ngày sinh |
| `status` | VARCHAR(50) | DEFAULT 'ACTIVE' | Trạng thái (ACTIVE, INACTIVE) |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Thời điểm tạo |
| `updated_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Thời điểm sửa đổi cuối |
