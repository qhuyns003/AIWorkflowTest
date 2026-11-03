# frontend – Overview

## 1. Thông tin cơ bản
- **Tên Service**: `frontend`
- **Mã nguồn**: `src/frontend/`
- **Vai trò**: Ứng dụng Web giao diện người dùng (Web Application / Dashboard).
- **Tech Stack**: React 18, TypeScript, Vite.
- **Port mặc định**: `3000` hoặc `5173` (local dev server)

## 2. Lệnh phát triển & Kiểm thử
| Mục đích | Lệnh chạy |
|---|---|
| Cài đặt dependencies | `npm ci` |
| Chạy môi trường dev | `npm run dev` |
| Build production bundle | `npm run build` |
| Chạy Unit Tests | `npm test` |
| Kiểm tra Linter | `npm run lint` |

## 3. Biến môi trường quan trọng (`.env`)
- `VITE_API_BASE_URL`: URL gốc trỏ tới API Gateway hoặc Backend (ví dụ: `http://localhost:8081`).
- `VITE_APP_ENV`: Môi trường ứng dụng (`development`, `staging`, `production`).
