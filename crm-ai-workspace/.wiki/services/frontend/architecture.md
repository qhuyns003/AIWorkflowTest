# frontend – Architecture & Code Structure

## 1. Cấu trúc Thư mục mã nguồn
```
src/frontend/src/
├── components/       # Các UI Component dùng chung (Button, Modal, Table, FormInputs)
├── pages/            # Màn hình/Trang theo từng luồng nghiệp vụ (CustomerList, CustomerDetail...)
├── hooks/            # Custom React Hooks tái sử dụng
├── services/         # API Service Clients (gọi backend endpoints)
├── store/            # State Management (Zustand / Redux / Context)
├── types/            # TypeScript interfaces & types
└── utils/            # Helper functions, formatters (date, currency...)
```

## 2. Quy chuẩn thiết kế (Frontend Standards)
- **TypeScript**: Bắt buộc định nghĩa interface/type cho props và API responses. Không sử dụng kiểu `any`.
- **Component Tái sử dụng**: Tách biệt giữa Presentational Components (UI thuần túy) và Container/Page Components (kết nối dữ liệu).
- **Trạng thái UI**: Mọi màn hình tải dữ liệu từ API đều phải có hiển thị Loading Skeleton/Spinner và Error State khi gặp lỗi mạng.
