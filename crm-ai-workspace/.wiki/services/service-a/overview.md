# service-a – Overview

## 1. Thông tin cơ bản
- **Tên Service**: `service-a`
- **Mã nguồn**: `src/service-a/`
- **Vai trò**: Microservice xử lý nghiệp vụ lõi (Backend Service) – xử lý logic nghiệp vụ, quản lý dữ liệu và giao dịch.
- **Tech Stack**: Java 17, Spring Boot, Spring Data JPA, Maven.
- **Port mặc định**: `8081` (local)

## 2. Lệnh phát triển & Kiểm thử
| Mục đích | Lệnh chạy |
|---|---|
| Build (bỏ qua test) | `mvn -q -DskipTests package` |
| Chạy toàn bộ Unit & Integration Tests | `mvn -q test` |
| Chạy 1 test cụ thể | `mvn -q test -Dtest=<TestClass>` |
| Kiểm tra chuẩn coding (Checkstyle) | `mvn -q checkstyle:check` |

## 3. Biến môi trường quan trọng (Environment Variables)
- `SERVER_PORT`: Port lắng nghe của service (mặc định: 8081).
- `SPRING_DATASOURCE_URL`: JDBC URL kết nối database.
- `SPRING_DATASOURCE_USERNAME`: Tên tài khoản database.
- `JWT_SECRET`: Khóa bí mật dùng để xác thực token.
