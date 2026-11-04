# 02 – Thiết kế chi tiết – <JIRA-KEY>

> **Mục đích**: Design decisions & implementation plan. Chi tiết vừa đủ để AI code đúng lần đầu.
> 
> **Nguyên tắc viết**:
> - **Mục 1-7**: BẮT BUỘC chi tiết (ADR, API contract, DB schema, file mapping, verification)
> - **Mục 4 (Thay đổi theo service)**: Quan trọng nhất - AI dùng để implement

## 1. Bối cảnh & mục tiêu (tham chiếu 01-requirement.md)

## 2. Phương án kỹ thuật & Quyết định chọn (ADR)
| Vấn đề / Quyết định kỹ thuật | Các phương án cân nhắc | Ưu điểm | Nhược điểm | Phương án CHỌN & Lý do |
|---|---|---|---|---|
| VD: Chọn cơ chế cache | 1. In-memory / 2. Redis | ... | ... | Chọn Redis vì cross-service |

> Lưu ý: Mọi quyết định kỹ thuật chốt với dev/lead phải được ghi vào bảng trên và phản ánh chi tiết vào các mục giải pháp bên dưới (Mục 3, 5, 6, 7).

## 3. Giải pháp được chọn (luồng/sequence, mô tả ngắn)

## 4. Thay đổi theo service ⭐ **[AI implement từ đây]**
| Service | Module/File | Thay đổi (chi tiết) | Loại |
|---|---|---|---|
| service-a | path/to/File.java | Mô tả cụ thể: tạo class X với methods Y, Z. Fields: a, b, c. | Tạo mới |
| service-a | path/to/Config.properties | Thêm: key=value | Sửa |

> **CHÚ Ý**: Cột "Thay đổi" phải đủ chi tiết để AI implement mà không cần hỏi lại.

## 5. API contract (request/response/lỗi/versioning)
> Chi tiết: Endpoint, Request DTO fields, Response format, Error codes

## 6. Dữ liệu: migration, index, rollback
> Chi tiết: SQL schema, JPA Entity structure, Index strategy

## 7. Verification
- **Build**: Phải build thành công (compile sạch, no errors)
- **Expected**: BUILD SUCCESS, exit code 0


