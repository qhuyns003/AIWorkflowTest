# frontend – API Integration

## 1. Cơ chế Gọi API (HTTP Client)
- Sử dụng `fetch` hoặc `axios` được đóng gói trong thư mục `src/services/apiClient.ts`.
- Tự động gắn Bearer Token từ authentication store vào header:
  ```typescript
  // Authorization: Bearer <accessToken>
  ```

## 2. Xử lý Lỗi & Interceptors
- **401 Unauthorized**: Tự động chuyển hướng về trang đăng nhập hoặc trigger refresh token.
- **403 Forbidden**: Hiển thị thông báo không đủ quyền truy cập.
- **500 Server Error**: Hiển thị Toast thông báo lỗi hệ thống thân thiện, log chi tiết lỗi vào console ở chế độ development.

## 3. Danh sách Service Clients
- `customerService.ts`: Các hàm `getCustomers()`, `getCustomerById(id)`, `createCustomer(data)`, `updateCustomer(id, data)`.
