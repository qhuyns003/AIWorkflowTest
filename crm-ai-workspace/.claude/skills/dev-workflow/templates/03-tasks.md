# 03 – Subtask – <JIRA-KEY>
> Quy tắc: Chia theo từng Yêu cầu / Nghiệp vụ (End-to-End), không chia theo tầng kỹ thuật (DB/API/UI riêng).
> Kiểm chứng Cổng G3: Chỉ cần chạy lệnh build thực tế (compile sạch, exit code 0). Không yêu cầu viết hoặc chạy unit test. Bắt buộc dừng lại sau mỗi subtask để dev duyệt kết quả & diff trước khi sang subtask tiếp theo.

| ID | Tên Subtask (Nghiệp vụ / Yêu cầu) | Service liên quan | Phạm vi file chính | Phụ thuộc | Checkpoint? | AC phủ | Lệnh build kiểm chứng | Trạng thái |
|----|-----------------------------------|-------------------|--------------------|-----------|-------------|--------|-----------------------|-----------|
| T1 | Chức năng A: [Tên nghiệp vụ A] | service-a, frontend | Entity, DTO, Service, UI component | - | Có (DB) | AC-1 | `mvn -q -DskipTests package && npm run build` | todo |
| T2 | Chức năng B: [Tên nghiệp vụ B] | service-a | DTO, Service, Controller | T1 | Không | AC-2 | `mvn -q -DskipTests package` | todo |

Trạng thái: todo / doing / done / blocked · Commit: Ghi commit hash sau khi hoàn thành.
> Sau mỗi subtask hoàn thành (Cổng G3 được duyệt): Đổi trạng thái sang `done`, ghi commit hash, và đồng bộ ngay lên mục `2. Change Lifecycle Checklist`, `3. Current Handover` và `4. Session Audit Trail` trong `state.md`.
