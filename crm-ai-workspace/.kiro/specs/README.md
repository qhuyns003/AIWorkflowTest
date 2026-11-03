# Kiro Specs & Workspace Integration

Thư mục này dành cho **Spec-Driven Development** của Kiro.

## Tương thích với Workspace Workflow
Trong workspace này, hồ sơ kỹ thuật cho từng ticket được chuẩn hóa theo cấu trúc 3 phase của Kiro:
- **Phase 1 (Requirements)**: `01-requirement.md` (tương đương `requirements.md`)
- **Phase 2 (Design)**: `02-design.md` (tương đương `design.md`)
- **Phase 3 (Tasks)**: `03-tasks.md` (tương đương `tasks.md`)

Tài liệu ticket chính thức được lưu trữ tại `docs/dev/<JIRA-KEY>/`. Nếu Kiro tạo spec trực tiếp qua lệnh `/spec`, bạn có thể lưu tại đây hoặc đồng bộ sang `docs/dev/<JIRA-KEY>/`.
