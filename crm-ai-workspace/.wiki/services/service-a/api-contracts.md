# service-a – API Contracts

## 1. Danh sách Endpoints chính
| Phương thức | URI Endpoint | Mô tả | Quyền / Scope |
|---|---|---|---|
| `GET` | `/api/v1/customers` | Lấy danh sách khách hàng (hỗ trợ phân trang & tìm kiếm) | `USER`, `ADMIN` |
| `GET` | `/api/v1/customers/{id}` | Lấy chi tiết thông tin một khách hàng | `USER`, `ADMIN` |
| `POST` | `/api/v1/customers` | Tạo mới hồ sơ khách hàng | `ADMIN` |
| `PUT` | `/api/v1/customers/{id}` | Cập nhật thông tin khách hàng | `USER`, `ADMIN` |
| `DELETE`| `/api/v1/customers/{id}` | Xóa / Deactivate khách hàng | `ADMIN` |

## 2. Hợp đồng dữ liệu (Sample Schemas)
### Request: CreateCustomerRequestDTO
```json
{
  "fullName": "Nguyen Van A",
  "email": "a.nguyen@example.com",
  "phoneNumber": "0912345678",
  "dateOfBirth": "1990-05-15"
}
```

### Response: CustomerResponseDTO
```json
{
  "id": "1001",
  "fullName": "Nguyen Van A",
  "email": "a.nguyen@example.com",
  "phoneNumber": "0912345678",
  "dateOfBirth": "1990-05-15",
  "status": "ACTIVE",
  "createdAt": "2026-11-01T10:00:00Z"
}
```
