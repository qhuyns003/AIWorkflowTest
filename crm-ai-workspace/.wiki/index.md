# AI Knowledge Base (.wiki)

> **Local Knowledge Base** hỗ trợ AI Agent và Developer nắm bắt kiến trúc hệ thống nhanh chóng mà không cần scan toàn bộ mã nguồn.

---

## 🌐 1. Tài liệu Kiến trúc Chung (Global)
- [system-overview.md](system-overview.md): Kiến trúc tổng thể hệ thống, danh sách service, tech stack, hạ tầng dùng chung (Gateway, Auth, Message Broker, Ports).

---

## 📦 2. Kiến trúc & Hiểu Code theo Từng Service (Per-Service Knowledge)

Mỗi service có một thư mục tri thức riêng biệt, giúp AI chỉ nạp đúng ngữ cảnh của service đang xử lý để tiết kiệm token tối đa:

### 🔹 Backend Service: `service-a`
- [services/service-a/overview.md](services/service-a/overview.md): Mục đích, tech stack (Java/Spring Boot), biến môi trường, lệnh build/test.
- [services/service-a/architecture.md](services/service-a/architecture.md): Cấu trúc phân tầng (Controller, Service, Repository, DTO) và luồng xử lý chính.
- [services/service-a/api-contracts.md](services/service-a/api-contracts.md): Danh sách REST APIs và hợp đồng dữ liệu.
- [services/service-a/database.md](services/service-a/database.md): Mô hình thực thể, bảng dữ liệu và quy tắc migration.

### 🔹 Frontend Service: `frontend`
- [services/frontend/overview.md](services/frontend/overview.md): Mục đích, tech stack (React/Vite/TS), định tuyến, biến môi trường.
- [services/frontend/architecture.md](services/frontend/architecture.md): Cấu trúc Components, Pages, Hooks và quản lý State.
- [services/frontend/api-integration.md](services/frontend/api-integration.md): Cách tích hợp gọi API backend, authentication token và xử lý lỗi.

---

> **Lưu ý**: Wiki được khởi tạo bởi skill `clone-workspace` và tự động cập nhật bởi `wiki-maintenance` (hoặc `update-workspace`) sau mỗi lần hoàn thành ticket.
