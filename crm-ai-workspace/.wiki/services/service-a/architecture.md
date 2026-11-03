# service-a – Architecture & Code Structure

## 1. Cấu trúc Thư mục & Package
```
src/service-a/src/main/java/com/app/servicea/
├── controller/       # REST Controllers, định nghĩa HTTP Endpoints & Swagger/OpenAPI
├── service/          # Business Logic Interfaces & Service Implementations
│   └── impl/
├── repository/       # Spring Data JPA Repositories truy xuất Database
├── model/
│   ├── entity/       # JPA Entities ánh xạ với bảng Database
│   └── dto/          # Request & Response Data Transfer Objects
├── config/           # Cấu hình Spring (Security, WebMvc, Swagger, Database)
└── exception/        # Custom Exceptions & Global Exception Handler (@ControllerAdvice)
```

## 2. Quy chuẩn thiết kế (Architectural Rules)
- **Controller**: Chỉ tiếp nhận request, validate DTO đầu vào, gọi Service và trả về DTO. Tuyệt đối không viết logic nghiệp vụ trong Controller.
- **Service**: Nơi tập trung toàn bộ business logic và điều phối transaction (`@Transactional`).
- **Entity & DTO**: Không bao giờ trả Entity trực tiếp ra ngoài Controller; bắt buộc map sang DTO.
- **Exceptions**: Mọi exception được bắt và xử lý tập trung tại `GlobalExceptionHandler`.
