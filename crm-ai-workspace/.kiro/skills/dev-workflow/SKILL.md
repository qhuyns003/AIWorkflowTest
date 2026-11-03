---
name: dev-workflow
description: >-
  Workflow phát triển cho DEV theo 4 bước – phân tích BRD, thiết kế chi tiết 
  và chia subtask, implementation theo subtask, hoàn tất và chuyển trạng thái Jira.
  Với các cổng xác nhận nghiệp vụ (G1) và giải pháp (G2).
  KÍCH HOẠT (Triggers) khi nhận các prompt như:
  - "bắt đầu task <link/key>", "thực hiện task <link/key>", "làm task/ticket <key>"
  - "bắt đầu làm <link>", "triển khai ticket <key>", "implement task <link>"
  - hoặc khi role là DEV và nhận đầu bài mới, tính năng mới, bugfix, refactor.
---
# Dev-Workflow (Phase 3 – DEV)

## Triggers (Dấu hiệu & Câu lệnh kích hoạt)
Tự động kích hoạt skill này khi người dùng đưa ra các prompt như:
- `bắt đầu task <link/key>` hoặc `bắt đầu làm <link/key>`
- `thực hiện task <link/key>` hoặc `thực hiện ticket <key>`
- `làm task/ticket <key>` kèm link BRD hoặc mô tả yêu cầu
- `triển khai tính năng <tên tính năng>` hoặc `implement task <link>`
- `sửa bug/lỗi <key>` (khi vượt quá phạm vi của `quick-fix`)
- Slash command: `/dev-workflow`

Nguyên tắc: **Explore → Plan → Implement → Verify**, tách khám phá/lập kế hoạch khỏi viết code. Mỗi bước kết thúc bằng **cổng xác nhận**; chưa duyệt thì không sang bước sau.

Tài liệu ticket: `docs/dev/<JIRA-KEY>/` (không commit). Templates: `templates/`.
Trạng thái trung tâm toàn workspace: `state.md` (đồng bộ sau mỗi cổng).

## Bước 0 – Chuẩn bị (luôn làm trước)
1. Lấy Jira key + link BRD. Thiếu → hỏi.
2. Xác nhận role DEV, loại việc (feature/bugfix/refactor), service liên quan.
3. Checkout nhánh feature ở **từng submodule liên quan**. Chưa checkout → chưa sửa code.
4. Tạo `docs/dev/<KEY>/`: Thư mục lưu trữ bộ hồ sơ kỹ thuật ticket.
5. **Đồng bộ `state.md`**: Điền mục `1. Active Change` (Key, Branch, Services) và tick `[x] Phase 0: Workspace Init`.

Việc nhỏ mô tả trong 1 câu → hỏi người dùng có muốn dùng `quick-fix` không.
Task rõ scope, ≤1 service, không cần phân tích BRD sâu → đề xuất **Lite mode** (xem bên dưới).

---

## Bước 1 – Phân tích BRD → Cổng G1 (nghiệp vụ)
Mục tiêu: hiểu đúng *cái gì* và *vì sao*, chưa bàn *làm thế nào*.

1. Đọc BRD. Tra `.wiki/` để nắm luồng hiện tại.
2. Giao `impact-analysis` khảo sát code (sub-agent, chỉ nhận tóm tắt).
3. Soạn `01-requirement.md` (template): tóm tắt, actor, luồng, quy tắc, dữ liệu, phạm vi in/out, AC kiểm chứng được, giả định.
4. Lập danh sách điều chưa rõ, mâu thuẫn hoặc nguy cơ tiềm ẩn (tham khảo `reference/question-bank.md`, không giới hạn số lượng câu hỏi). Chủ động trao đổi đầy đủ với người dùng.

**Cổng G1**: Trình bày bản hiểu, hỏi và làm rõ mọi điểm nghi vấn nghiệp vụ. Lặp đến hết Open question. Ra khi người dùng xác nhận "đúng nghiệp vụ".
- **Cập nhật quyết định vào `01-requirement.md`**: Ghi câu hỏi & quyết định vào Mục 10, đồng thời cập nhật ngay các thay đổi tương ứng vào Mục 4 (Rules), Mục 6 (Scope), Mục 8 (AC). Tuyệt đối không để lệch pha giữa quyết định chốt và nội dung đặc tả.
- **Đồng bộ `state.md`**: Đánh dấu `[x] Phase 1: Phân tích & G1 Gate`, cập nhật `Current Handover` sang thiết kế kỹ thuật.

---

## Bước 2 – Thiết kế & chia subtask → Cổng G2 (giải pháp)
Mục tiêu: có kế hoạch đủ chi tiết để code một lần đúng.

1. **Khảo sát kỹ thuật**: pattern có sẵn, API/DB/message, convention, test hiện có. Tái sử dụng trước.
2. **Đề xuất phương án**: mỗi quyết định lớn → 2-3 phương án + ưu/nhược + đề xuất kèm lý do. Ghi trực tiếp vào bảng Mục 2 trong `02-design.md`.
3. Soạn `02-design.md` (template): giải pháp, luồng/sequence, thay đổi theo service, API contract, DB migration+rollback, xử lý lỗi, bảo mật, hiệu năng, tương thích ngược, kế hoạch test, rủi ro.
4. **Chia subtask** theo `reference/task-decomposition.md`:
   - **QUY TẮC QUAN TRỌNG**:
     - Chia theo Nghiệp vụ/Tính năng End-to-End (KHÔNG chia theo layer kỹ thuật)
     - Subtask phải "đủ lớn" - một khối nghiệp vụ hoàn chỉnh
     - Hạn chế số lượng: 2-4 subtasks (task nhỏ), 5-7 subtasks (task lớn)
     - 1 subtask = 1 commit → dễ rollback nếu có lỗi
   - Xem ví dụ chi tiết trong `reference/task-decomposition.md`
   - Soạn `03-tasks.md` với bảng subtask rõ ràng
5. **Review độc lập**: giao `design-review` đọc `01`+`02`+`03` và chỉ ra lỗ hổng.

**Cổng G2**: Trao đổi các câu kỹ thuật chưa chốt hoặc rủi ro tiềm ẩn kèm phương án đề xuất. Trình bày thiết kế + bảng subtask. Ra khi người dùng duyệt.
- **Cập nhật quyết định vào `02-design.md`**: Ghi rõ phương án đã chọn & lý do vào Mục 2, và hoàn thiện các mục giải pháp kỹ thuật (Mục 3, 5, 6, 7) theo đúng quyết định đã chốt. Cập nhật lại `03-tasks.md` nếu có thay đổi subtask.
- **Đồng bộ `state.md`**: Đánh dấu `[x] Phase 2: Thiết kế & G2 Gate`, cập nhật tổng số subtasks (`0/N done`) ở Phase 3, cập nhật `Current Handover` chỉ rõ Subtask T1 cần làm trước.
- **Đề xuất tối ưu Session (Gợi ý, dev quyết định)**: Chủ động gợi ý dev: *"Đã chốt xong thiết kế & tasks. Bạn có thể mở Session mới và gõ `tiếp tục subtask T1` để bắt đầu code với context sạch và tiết kiệm token."* (Nếu dev muốn tiếp tục phiên hiện tại, AI tiếp tục làm việc bình thường).

---

## Bước 3 – Implementation → Cổng G3 (Bắt buộc duyệt từng subtask)
Mục tiêu: implement đúng thiết kế theo từng đơn vị nghiệp vụ, luôn build thử thành công (compile sạch, không lỗi cú pháp, types hoặc packaging). Không yêu cầu viết unit test hay chạy testcase phức tạp ở bước này.
Quy tắc cốt lõi: **Luôn dừng lại sau mỗi subtask để dev duyệt kết quả mới được chuyển sang subtask kế tiếp.**

**Vòng lặp mỗi subtask:**
1. Báo ngắn: đang làm subtask nào, phạm vi nghiệp vụ/service, lệnh build kiểm chứng.
2. **Triển khai code**: Code trực tiếp theo `02-design.md`, hoàn thiện trọn vẹn logic nghiệp vụ của subtask (không cần viết test case).
3. **Kiểm chứng bằng build thử**: Chạy lệnh build thật trong `03-tasks.md` (Backend: `mvn -q -DskipTests package`, Frontend: `npm run build`). Đọc log đảm bảo build thành công, exit code 0, không có lỗi biên dịch.
4. Tự xem diff code so với thiết kế `02-design.md`.
5. Đề xuất commit `[KEY] type: ...` (chỉ commit khi dev đồng ý).
6. **Cổng G3 (Bắt buộc dừng)**: Trình bày kết quả build thành công và diff code. **Dừng lại chờ dev duyệt**.
7. **Đồng bộ sau khi dev duyệt G3**:
   - Trong `03-tasks.md`: Chuyển trạng thái subtask sang `done`, ghi commit hash.
   - Trong `state.md`: Cập nhật tiến độ Phase 3 (`K/N done`), cập nhật `Current Handover` (việc cần làm tiếp theo ở subtask kế tiếp), ghi nhận vào `Session Audit Trail`.
   - **Gợi ý đổi session nếu subtask nặng**: Nếu subtask vừa xong có diff dài hoặc log build lớn, gợi ý dev có thể mở session mới cho subtask tiếp theo (dev quyết định).

**Dừng ngay khi**: Thiết kế có điểm chưa rõ, cần thêm scope, hoặc build lỗi lặp > 2 lần.

---

## Bước 4 – Hoàn tất
1. **Review 2 tầng** (giao agent `code-review`): đúng spec + chất lượng code. Trình bày ngắn gọn kết quả review.
2. Hỏi người dùng xác nhận nghiệm thu.
3. **Jira**: chuyển trạng thái + comment tóm tắt (qua CLI/MCP).
4. **Đồng bộ `state.md`**: Đánh dấu `[x] Phase 4: Code Review độc lập`.
5. Gợi ý người dùng chạy `update-workspace` để hoàn tất toàn bộ vòng đời (Phase 6).

---

## Khi thất bại
- Build lỗi không rõ → dừng, đọc log thật, báo giả thuyết. Không sửa bừa.
- Phạm vi phình → tách ticket mới, hỏi người dùng.
- Context dài → cập nhật `state.md` và `03-tasks.md`, đề xuất session mới.

## Session Handoff Protocol
Khi session kết thúc hoặc context dài:
1. Đảm bảo `03-tasks.md` đã phản ánh đúng trạng thái task (`done` / `doing` / `todo`) và commit hash tương ứng.
2. Cập nhật `state.md` ở root:
   - Mục `3. Current Handover`: Ghi rõ dừng tại đâu, việc cần làm ngay ở phiên sau, resume point.
   - Mục `4. Session Audit Trail`: Thêm 1 dòng ghi nhận phiên hiện tại (Session #, Ngày, Role, Công việc đã xong, Commit hash).
3. Session mới chỉ cần đọc: `AGENTS.md` (tự động) + `state.md` + `03-tasks.md` → đủ tiếp tục ngay mà không mất mát thông tin.

---

## Lite Mode (cho task trung bình)
Dùng khi: scope rõ ràng, ≤1 service, đụng logic nhưng không cần phân tích BRD sâu.
Người dùng phải đồng ý dùng Lite mode.

**Khác biệt so với Full mode:**
| Aspect | Full | Lite |
|---|---|---|
| Bước 1 (BRD analysis) | Soạn `01-requirement.md` đầy đủ | Tóm tắt 5-10 dòng trong `02-design.md` |
| Bước 2 (Design) | `02-design.md` + `03-tasks.md` + design-review | `02-design.md` gọn, 1 subtask, bỏ design-review |
| Gates | G1 + G2 + G3 | G2 only (gộp scope + design) |
| Docs | 01 + 02 + 03 | 02 + 03 |
| Bước 4 (Review) | 2-layer review | code-review 1 tầng |
