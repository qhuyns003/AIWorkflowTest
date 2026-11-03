---
name: clone-workspace
description: >-
  Build/refresh dev workspace cho một đầu bài hoặc epic. Dùng khi bắt đầu 
  công việc mới, kéo code các submodule về đúng branch và khởi tạo state.
---
# Clone-Workspace (Phase 1 – DEV)
1. Hỏi người dùng: epic/đầu bài, danh sách service liên quan, branch cần dùng.
2. `git submodule update --init` cho các submodule liên quan; checkout đúng branch rồi pull mới nhất.
3. **Kiểm tra `.wiki/`**: Vì `.wiki/` là Source of Truth chung đã được commit/push cùng repo workspace, chỉ kiểm tra thư mục tồn tại. **Tuyệt đối KHÔNG đọc quét mã nguồn để sinh mới hay làm giàu wiki** ở bước này vì gây lãng phí token nghiêm trọng. Việc cập nhật wiki chỉ được thực hiện có chủ đích ở bước kết thúc ticket (`update-workspace`) dựa trên diff thay đổi.
4. Kiểm tra CLI/MCP (Jira, Confluence) sẵn sàng; nếu thiếu, hướng dẫn init/auth.
5. Khởi tạo `state.md` ở workspace root theo mô hình Single-Change: điền Epic/Key, branch, services, đánh dấu `[x] Phase 0: Workspace Init`, khởi tạo `Current Handover` và dòng Session đầu tiên trong `Session Audit Trail`.
6. Báo cáo: service đã kéo, branch/commit, trạng thái CLI/MCP và `state.md`. **Checkpoint** trước bước tiếp.
