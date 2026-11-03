---
name: update-workspace
description: >-
  Kết thúc đầu bài – cập nhật wiki, commit source code, sync state.
  Dùng khi dev/review/test xong và cần đồng bộ workspace.
---
# Update-Workspace (Phase 5 – DEV)
1. Giao `wiki-maintenance` cập nhật `.wiki/` theo các thay đổi code đã hoàn thành.
2. Hiển thị `git status` và diff của từng submodule cho người dùng xác nhận.
3. Commit code ở từng submodule (khi người dùng đồng ý).
4. **Commit & Push `.wiki/`** lên repository của workspace vì `.wiki/` là **Source of Truth** chung của hệ thống.
5. **Không commit / không push**: `docs/ba`, `docs/dev`, `docs/sit`, `state.md`.
6. Chỉ push code submodule khi người dùng yêu cầu.
7. Cập nhật `state.md`: đánh dấu `[x] Phase 6: Update Wiki & Finish` trong Lifecycle Checklist, chuyển `Overall Progress: 100% (Hoàn thành)`, ghi nhận phiên kết thúc vào `Session Audit Trail`, xóa trạng thái dở dang ở `Current Handover`.
