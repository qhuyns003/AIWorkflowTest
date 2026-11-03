# 02 – Thiết kế chi tiết – <JIRA-KEY>
## 1. Bối cảnh & mục tiêu (tham chiếu 01-requirement.md)
## 2. Phương án kỹ thuật & Quyết định chọn (ADR)
| Vấn đề / Quyết định kỹ thuật | Các phương án cân nhắc | Ưu điểm | Nhược điểm | Phương án CHỌN & Lý do |
|---|---|---|---|---|
| VD: Chọn cơ chế cache | 1. In-memory / 2. Redis | ... | ... | Chọn Redis vì cross-service |

> Lưu ý: Mọi quyết định kỹ thuật chốt với dev/lead phải được ghi vào bảng trên và phản ánh chi tiết vào các mục giải pháp bên dưới (Mục 3, 5, 6, 7).
## 3. Giải pháp được chọn (luồng/sequence, mô tả ngắn)
## 4. Thay đổi theo service
| Service | Module/File | Thay đổi |
|---|---|---|
## 5. API contract (request/response/lỗi/versioning)
## 6. Dữ liệu: migration, index, rollback
## 7. Xử lý lỗi, retry, timeout, idempotency
## 8. Bảo mật & quyền
## 9. Hiệu năng & giới hạn
## 10. Logging / audit / monitoring
## 11. Tương thích ngược, cấu hình, thứ tự deploy, rollback
## 12. Kế hoạch test (mỗi AC ↔ test nào, mức nào)
## 13. Rủi ro & giảm thiểu
## 14. Danh sách subtask → 03-tasks.md
