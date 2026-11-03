# 03 – Subtask – <JIRA-KEY>

> **Quy tắc chia subtask**:
> - Chia theo Nghiệp vụ/Tính năng End-to-End (KHÔNG chia theo tầng kỹ thuật)
> - Subtask phải "đủ lớn" - một khối nghiệp vụ hoàn chỉnh
> - Hạn chế số lượng: 2-4 subtasks (task nhỏ), tối đa 5-7 subtasks (task lớn)
> - 1 subtask = 1 commit chính → dễ rollback nếu có lỗi
> 
> **Kiểm chứng Cổng G3**: 
> - Chạy lệnh build thực tế (compile sạch, exit code 0)
> - Bắt buộc dừng lại sau mỗi subtask để dev duyệt kết quả & diff
> - Chỉ khi dev duyệt mới được chuyển sang subtask tiếp theo

---

## Danh sách Subtask

| ID | Tên Subtask (Nghiệp vụ End-to-End) | Service | Mô tả scope | Phụ thuộc | Checkpoint? | AC phủ | Lệnh build | Trạng thái | Commit |
|----|-------------------------------------|---------|-------------|-----------|-------------|--------|------------|-----------|--------|
| T1 | [Tên nghiệp vụ A] | service-a, frontend | Full stack: Entity + Service + API + UI + Test | - | Có | AC-1, AC-2 | `mvn package && npm build` | todo | - |
| T2 | [Tên nghiệp vụ B] | service-a | Backend end-to-end: Entity + Service + Controller + Test | T1 | Có | AC-3 | `mvn package` | todo | - |

**Trạng thái**: `todo` / `doing` / `done` / `blocked`  
**Commit**: Ghi commit hash sau khi dev duyệt G3

---

## VÍ DỤ CÁCH CHIA ĐÚNG

### ✅ Ví dụ 1: API Search Customer (Skeleton Project)
| ID | Tên Subtask | Service | Mô tả |
|----|-------------|---------|-------|
| T1 | Setup Infrastructure | customer | Dependencies, config, DB connection |
| T2 | API Search Customer End-to-End | customer | Entity + Repository + Service + Controller + Exception + Tests |

### ✅ Ví dụ 2: Module Quản lý Đơn hàng
| ID | Tên Subtask | Service | Mô tả |
|----|-------------|---------|-------|
| T1 | Setup Infrastructure | order | DB schema, base entities, config |
| T2 | CRUD Đơn hàng | order | Create + Read + Update + Delete (all APIs together) |
| T3 | Tìm kiếm & Lọc đơn hàng | order | Search + Filter logic |
| T4 | Validation & Business Rules | order | Status workflow, constraints |

### ❌ KHÔNG chia như thế này:
```
❌ T1: Tạo Entity
❌ T2: Tạo Service  
❌ T3: Tạo Controller
❌ T4: API GET /customers
❌ T5: API POST /customers
❌ T6: API PUT /customers
(Quá nhỏ, chia theo layer/API riêng lẻ)
```

---

> **Sau mỗi subtask hoàn thành (G3 duyệt)**: 
> - Đổi trạng thái → `done`, ghi commit hash
> - Đồng bộ lên `state.md`: Phase 3 progress, Current Handover, Session Audit Trail
