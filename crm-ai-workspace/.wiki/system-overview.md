# System Overview (Kiến trúc Tổng thể Toàn Hệ thống)

> Tài liệu dùng chung mô tả bức tranh toàn cảnh của hệ sinh thái microservices.

## 1. Danh sách các Microservices
| Service | Thư mục mã nguồn | Tech Stack | Vai trò / Nghiệp vụ chính | Wiki chi tiết |
|---|---|---|---|---|
| `service-a` | `src/service-a/` | Java 17, Spring Boot, Maven | Core Backend Service (API nghiệp vụ, xử lý dữ liệu lõi) | [Xem wiki](services/service-a/overview.md) |
| `frontend` | `src/frontend/` | React, TypeScript, Vite | Giao diện người dùng web (Web Portal / Dashboard quản trị & vận hành) | [Xem wiki](services/frontend/overview.md) |

## 2. Hạ tầng & Thành phần Dùng chung
- **API Gateway / Proxy**: Điều hướng traffic và xác thực tập trung trước khi chuyển tiếp vào các backend services.
- **Authentication / IAM**: JWT Bearer token / OAuth2. Token được client gửi qua header `Authorization: Bearer <token>`.
- **Database**: Mỗi service sở hữu database riêng biệt (Database-per-Service pattern).
- **Communication Protocol**:
  - Giao tiếp đồng bộ (Synchronous): RESTful API qua HTTP/JSON.
  - Giao tiếp bất đồng bộ (Asynchronous): Message Broker (Kafka / RabbitMQ) cho các sự kiện dữ liệu thay đổi.
