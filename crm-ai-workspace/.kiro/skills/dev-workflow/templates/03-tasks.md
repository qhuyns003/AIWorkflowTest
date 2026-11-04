# 03 – Subtask Checklist – <JIRA-KEY>

> **Mục đích**: Tracking tiến độ subtasks. Chi tiết implementation lấy từ `02-design.md` Section 4.
> 
> **Quy tắc**:
> - Chia theo Nghiệp vụ End-to-End, không theo layer
> - Subtask đủ lớn: 1-2 tasks (nhỏ), max 3-4 (lớn)
> - 1 subtask = 1 commit → dễ rollback
> - **G3 checkpoint**: Build sạch → Dev duyệt → Commit → Sang subtask kế

---

## Subtasks

| ID | Tên (Nghiệp vụ End-to-End) | Service | Phạm vi file | Dependency | AC | Build | Status | Commit |
|----|----------------------------|---------|-------------|------------|----|----|--------|--------|
| T1 | Setup Infrastructure | service-a | pom.xml, application.properties | - | - | `mvn package -DskipTests` | todo | - |
| T2 | [Feature End-to-End] | service-a | Entity, Repository, Service, Controller, Test | T1 | AC-1,2,3 | `mvn package` | todo | - |

> Status: `todo` / `doing` / `done` / `blocked`

---

## Ví dụ Chia Đúng

**✅ Skeleton project:**
- T1: Setup Infrastructure (Dependencies, config)
- T2: Feature End-to-End (Entity → Controller → Tests)

**✅ Module lớn:**
- T1: Infrastructure
- T2: CRUD APIs feature 1 (all together)
- T3: CRUD APIs feature 2 (all together)

**❌ SAI - Chia theo layer:**
- T1: Entity, T2: Service, T3: Controller (quá nhỏ)

---

> **Note**: AI implement từ `02-design.md`, không cần chi tiết trong file này. Sau mỗi task: build → diff → G3 duyệt.
