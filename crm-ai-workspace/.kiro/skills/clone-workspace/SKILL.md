---
name: clone-workspace
description: >-
  Khởi tạo hoặc làm mới dev workspace: kéo và verify tất cả submodules, kiểm tra wiki và khởi tạo state.md.
  Dùng khi người dùng nói "khởi tạo workspace", "clone workspace", "setup workspace", "kéo code mới".
  Không dùng khi triển khai code cho một ticket cụ thể (hãy dùng dev-workflow).
---
# Clone-Workspace (Phase 1 – DEV)

1. **Tự động clone tất cả submodules + Verify**: 
   - Đọc `.gitmodules` để lấy danh sách tất cả submodules
   - Chạy `git submodule update --init --recursive` để kéo tất cả về
   - **Với mỗi submodule** (lặp từng cái một):
     - Checkout về **branch đã ghim trong `.gitmodules`** rồi pull mới nhất
     - **VERIFY NGAY sau mỗi submodule** (bắt buộc - TẤT CẢ phải PASS):
       1. **Git metadata check**:
          - `git -C <submodule-path> status` → kiểm tra không ở detached HEAD
          - `git -C <submodule-path> log -1 --oneline` → kiểm tra có commit (không rỗng)
          - `git -C <submodule-path> branch --show-current` → xác nhận đúng branch
       2. **Working directory check** (🔴 QUAN TRỌNG):
          - `git -C <submodule-path> status --porcelain` → phải trả về rỗng (working tree clean)
          - Nếu có output (unstaged/staged changes) → **FAIL**
          - Đặc biệt: Nếu có "D" (deleted) → submodule có vấn đề nghiêm trọng
       3. **Source files check** (🔴 QUAN TRỌNG):
          - List files trong submodule: `ls <submodule-path>/src` hoặc `ls <submodule-path>/*.xml`
          - Phải có **ít nhất 1 file source** (pom.xml, package.json, *.java, *.ts...)
          - Nếu chỉ có .git → **FAIL** (submodule rỗng)
       4. **Build file check**:
          - Java: phải có `pom.xml` hoặc `build.gradle`
          - Node: phải có `package.json`
          - Nếu không có → **WARN** (có thể là submodule đặc biệt như docs)
     - **Nếu verify fail** bất kỳ check nào:
       - **DỪNG NGAY**, không tiếp tục submodule khác
       - Báo lỗi chi tiết: submodule nào, fail ở check nào, output cụ thể
       - Đề xuất fix: 
         - Nếu deleted files: `cd src/<submodule> && git reset --hard HEAD`
         - Nếu empty: Kiểm tra remote repo có code không
         - Nếu detached: `git checkout <branch> && git pull`
2. **Kiểm tra `.wiki/`**: Vì `.wiki/` là Source of Truth chung đã được commit/push cùng repo workspace, chỉ kiểm tra thư mục tồn tại. **Tuyệt đối KHÔNG đọc quét mã nguồn để sinh mới hay làm giàu wiki** ở bước này vì gây lãng phí token nghiêm trọng. Việc cập nhật wiki chỉ được thực hiện có chủ đích ở bước kết thúc ticket (`update-workspace`) dựa trên diff thay đổi.
3. Kiểm tra CLI/MCP (Jira, Confluence) sẵn sàng; nếu thiếu, hướng dẫn init/auth.
4. Khởi tạo `state.md` ở workspace root theo mô hình Single-Change: điền Epic/Key, đánh dấu `[x] Phase 0: Workspace Init`, khởi tạo `Current Handover` và dòng Session đầu tiên trong `Session Audit Trail`.
5. Báo cáo: **tất cả services** đã kéo, branch/commit hash của từng service, trạng thái CLI/MCP và `state.md`. **Checkpoint** trước bước tiếp.

---

## 🛡️ Guard
- alone: đọc .gitmodules, cập nhật submodules, kiểm tra status, khởi tạo state.md.
- asks first: bất kỳ thao tác git reset --hard hoặc ghi đè file có thay đổi chưa lưu.
- never: tự ý push lên remote; đọc quét mã nguồn để sinh wiki ở bước này.

