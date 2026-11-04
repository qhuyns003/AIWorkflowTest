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

Nguyên tắc: **Explore → Plan → Implement → Verify**, tách khám phá/lập kế hoạch khỏi viết code. Mỗi subtask phải đi qua đầy đủ Phase 1 → 2 → 3 và duyệt G3 trước khi chuyển sang subtask tiếp theo.

**Kiến trúc tài liệu** (Subtask-centric):
```
docs/dev/<JIRA-KEY>/
├── 03-tasks.md         # Danh sách & tracking subtasks
├── T1-<slug>/
│   ├── 01-requirement.md  # Phase 1 của T1
│   └── 02-design.md       # Phase 2 của T1
├── T2-<slug>/
│   ├── 01-requirement.md  # Phase 1 của T2
│   └── 02-design.md       # Phase 2 của T2
└── T3-<slug>/
    ├── 01-requirement.md
    └── 02-design.md
```

**Workflow thực thi:**
```
T1: Phase 1 → G1 → Phase 2 → G2 → Phase 3 → G3 (DỪNG)
    ↓ Dev duyệt "OK"
T2: Phase 1 → G1 → Phase 2 → G2 → Phase 3 → G3 (DỪNG)
    ↓ Dev duyệt "OK"
T3: ...
```

Trạng thái workspace: `state.md` (đồng bộ sau mỗi cổng).

## Bước 0 – Đọc BRD & Chia Subtask (Nghiệp vụ)
**Mục tiêu**: Hiểu ticket tổng thể → Chia thành subtasks nghiệp vụ NGAY.

**📝 CHECKLIST TỰ KIỂM TRA TRƯỚC KHI TRÌNH BÀY G0:**
- [ ] Đã đọc BRD từ Jira (hoặc file/link được cung cấp)?
- [ ] Đã tra cứu `.wiki/` để hiểu kiến trúc hiện tại và pattern có sẵn?
- [ ] Đã đọc `reference/task-decomposition.md` để hiểu quy tắc chia subtask?
- [ ] Subtasks được chia theo **nghiệp vụ end-to-end** (KHÔNG phải theo layer kỹ thuật)?
- [ ] Mỗi subtask có **mục tiêu nghiệp vụ rõ ràng** (user story), không chỉ là "tạo Entity" hay "viết Controller"?
- [ ] Số lượng subtasks hợp lý (1-2 tasks cho ticket nhỏ, max 3-4 cho ticket lớn)?
- [ ] Mỗi subtask có thể **commit độc lập** và **rollback được**?
- [ ] Đã ghi rõ **dependency** giữa các subtasks (nếu có)?
- [ ] Đã tạo nhánh feature tại workspace root (chưa checkout submodule)?
- [ ] Đã tạo cấu trúc thư mục `docs/dev/<KEY>/` với `03-tasks.md` và các thư mục `TX-<slug>/` (empty)?

**Quy trình:**

1. **Lấy Jira key + link BRD**. Thiếu → hỏi.

2. **Checkout nhánh feature tại workspace root**: 
   - `git checkout -b feature/<KEY>-<mô-tả>` từ develop/main
   - Tạo cấu trúc docs trên nhánh feature này
   - ⚠️ **Chưa checkout submodule** (để Phase 3)

3. **Đọc BRD, phân tích AC**. Tra `.wiki/` nếu cần nắm luồng hiện tại.

4. **Chia subtasks theo NGHIỆP VỤ** (bắt buộc đọc `reference/task-decomposition.md`):
   - Mỗi subtask = 1 use case nghiệp vụ hoàn chỉnh (end-to-end: từ API → Service → DB)
   - **KHÔNG** chia theo layer (tránh: "T1: Entity + Repository", "T2: Service", "T3: Controller")
   - **CÓ** chia theo use case (tốt: "T1: Tìm kiếm khách hàng", "T2: Tạo khách hàng mới")
   - Ghi rõ dependency (T2 phụ thuộc T1 vì dùng chung Entity)

5. **Tạo cấu trúc thư mục**:
   ```
   docs/dev/<KEY>/
   ├── 03-tasks.md         # Bảng danh sách subtasks (theo template)
   ├── T1-<slug>/          # Thư mục subtask 1 (empty, chưa có 01/02-*.md)
   └── T2-<slug>/          # Thư mục subtask 2 (empty)
   ```

6. **Viết `03-tasks.md`** (theo template `templates/03-tasks.md`):
   - Bảng subtasks với: ID, Tên (nghiệp vụ), Service, Phạm vi file, Dependency, AC, Build command, Status
   - Section "Giải thích cách chia" (mandatory) - giải thích tại sao chia như vậy, từng subtask deliver gì

7. **Self-Review**: Đọc lại checklist ở đầu Bước 0, đảm bảo tất cả đã ✅

8. **Đồng bộ `state.md`**: Tick `[x] Phase 0: Workspace Init`, ghi số subtasks (`0/N done`).

9. **💡 Gợi ý Jira**: Chuyển sang "In Progress" (không bắt buộc).

**Output Phase 0**:
- ✅ `03-tasks.md`: Bảng T1, T2, T3... với giải thích cách chia (chưa có docs chi tiết 01/02)
- ✅ Thư mục `TX-<slug>/`: Đã tạo, empty (chưa có 01-requirement.md, 02-design.md)
- ✅ **Nhánh feature**: Đã checkout tại workspace root, docs được tạo trên nhánh này
- ✅ **Submodules**: Chưa checkout (để Phase 3)

**Cổng G0**:
- Trình bày kết quả sau Phase 0:
  - Bảng subtasks (ID, tên, phạm vi, dependency)
  - Giải thích cách chia (tại sao chia theo use case này, mỗi subtask deliver gì)
  - Đề xuất thứ tự thực hiện (T1 → T2 → T3...)
- Hỏi dev: "Có đồng ý với cách chia subtask này không?"
- **DỪNG CHỜ XÁC NHẬN** - chỉ chuyển sang T1 Phase 1 khi dev approve G0
---

## Bước 1 → 2 → 3: Xử lý TỪNG Subtask Tuần tự (Phase 1 → 2 → 3)

**QUY TẮC VÀNG**: Mỗi subtask phải hoàn thành ĐẦY ĐỦ Phase 1 → 2 → 3 (và duyệt G3) trước khi chuyển sang subtask tiếp theo.

**CẤM**: 
- ❌ Làm tất cả Phase 1 trước, rồi mới làm Phase 2 cho tất cả
- ❌ Giao nhiều subtasks chạy song song cho sub-agents
- ❌ Tự động chuyển sang subtask tiếp theo mà không có sự duyệt rõ ràng của dev

---

### Vòng lặp TỪNG Subtask

**FOR EACH subtask TX in [T1, T2, ..., TN]:**

#### 📋 Phase 1-TX: Requirement Analysis cho subtask TX → Cổng G1-TX

**🚨 NGUYÊN TẮC VÀNG PHASE 1:**
- ✅ CHỈ HỎI VÀ PHÂN TÍCH: Business logic, validation rules, edge cases nghiệp vụ, data meaning
- ❌ TUYỆT ĐỐI KHÔNG HỎI: API path, HTTP method, response format, database choice, framework, library, code structure
- 🎯 Mục tiêu: Hiểu đúng **cái gì** (WHAT) và **vì sao** (WHY), chưa bàn **làm thế nào** (HOW)

**📝 CHECKLIST TỰ KIỂM TRA TRƯỚC KHI TRÌNH BÀY G1-TX:**
- [ ] Đọc lại Section 10 (Câu hỏi & Quyết định nghiệp vụ) trong `01-requirement.md`
- [ ] Kiểm tra: Có từ khóa kỹ thuật không? (API, endpoint, path, HTTP, JSON, REST, database, H2, PostgreSQL, format, wrapper, mode)
- [ ] Nếu có → XÓA câu hỏi đó, ghi chú "Defer to Phase 2"
- [ ] Chỉ giữ câu hỏi nghiệp vụ thuần túy
- [ ] Các phương án đề xuất tối thiểu là 2 nếu có đề xuất

**Quy trình:**

1. **Tạo `TX-<slug>/01-requirement.md`** (theo template `templates/01-requirement.md`):
   - Mục tiêu subtask (1-2 câu)
   - Phạm vi in/out
   - Business rules, business logic (nếu có)
   - Dữ liệu vào/ra

2. **Hỏi & làm rõ** (tham khảo `reference/question-bank.md`):
   - Edge cases cho subtask này
   - Validation rules cụ thể (nghiệp vụ, KHÔNG phải validation framework)
   - Business rules chưa rõ

3. **Self-Review**: Đọc lại Section 10, loại bỏ mọi câu hỏi kỹ thuật

4. **Ghi quyết định** vào `01-requirement.md` của subtask TX.

**Cổng G1-TX**:
- Trình bày bản hiểu requirement của subtask TX
- Hỏi & làm rõ mọi điểm nghi vấn
- Ra khi người dùng xác nhận "đúng nghiệp vụ cho subtask TX"
- **Đồng bộ `state.md`**: Tick `[x] TX Phase 1: Requirement done`

**⚠️ CHỜ DEV XÁC NHẬN G1-TX trước khi tiếp tục Phase 2-TX**

---

#### 🎨 Phase 2-TX: Design cho subtask TX → Cổng G2-TX
Mục tiêu: có kế hoạch đủ chi tiết để code một lần đúng.
1. **Đọc lại `TX-<slug>/01-requirement.md`**: Nắm chắc requirement đã chốt ở G1-TX.

2. **Khảo sát kỹ thuật cho subtask TX**:
   - Giao `impact-analysis` khảo sát code liên quan đến subtask TX
   - Review pattern, convention, test hiện có
   - Tái sử dụng code/pattern có sẵn

3. **Tạo `TX-<slug>/02-design.md`** (copy template `templates/02-design.md`):
   - **Effort Level & Model**: Đánh giá độ phức tạp (🔴 High / 🟡 Medium / 🟢 Low)
   - **Technical Decisions**: Đề xuất 2-3 phương án cho mỗi quyết định lớn
   - **Implementation Plan**: Các bước triển khai chi tiết
   - **Files to Create/Modify**: Danh sách file cần tạo/sửa
   - **API Contracts**: Request/Response schemas (nếu có)
   - **DB Changes**: Migration + Rollback (nếu có)
   - **Verification**: Build thành công

4. **Hỏi & trao đổi**: Các điểm kỹ thuật chưa chắc chắn, trade-offs.

5. **Review độc lập**: 
   - Sau khi hoàn thành thiết kế subtask TX và trước khi dev duyệt G2-TX
   - Giao `design-review` agent đọc `TX-<slug>/01-requirement.md` và `TX-<slug>/02-design.md` 
   - Kiểm tra: thiết kế đúng requirement, đầy đủ, không mâu thuẫn với subtasks trước (nếu có)
   - Trình bày tóm tắt kết quả review cùng với thiết kế tại G2-TX

**Cổng G2-TX**:
- Trình bày thiết kế cho subtask TX + kết quả design review
- Trao đổi quyết định kỹ thuật chưa chốt
- Ra khi người dùng duyệt thiết kế
- **Cập nhật quyết định vào `TX-<slug>/02-design.md`**: Ghi rõ phương án đã chọn & lý do
- **Đồng bộ `state.md`**: Tick `[x] TX Phase 2: Design done`

**⚠️ CHỜ DEV XÁC NHẬN G2-TX trước khi tiếp tục Phase 3-TX**

---

#### 💻 Phase 3-TX: Implementation cho subtask TX → Cổng G3-TX
Mục tiêu: implement đúng thiết kế theo từng đơn vị nghiệp vụ, luôn build thử thành công (compile sạch, không lỗi cú pháp, types hoặc packaging). Không yêu cầu viết unit test hay chạy testcase phức tạp ở bước này.

**Chuẩn bị (chỉ làm 1 lần trước subtask đầu tiên T1):**
1. **Checkout nhánh feature ở submodules liên quan**: `feature/<KEY>-<mô-tả>`
   - Chưa checkout → chưa được code
   - Đảm bảo branch từ develop/main
   - tên branch tạo pahri giống tên branch được tạo ở phase 0 của AI workflow repo

**Triển khai TX:**

1. **Đọc docs của TX** (focused context):
   - `TX-<slug>/01-requirement.md` (~0.5k tokens)
   - `TX-<slug>/02-design.md` (~1k tokens)
   - **KHÔNG đọc** docs của subtask khác

2. **Implement theo design**:
   - Đọc Section "Implementation Plan" trong `TX-<slug>/02-design.md`
   - Tạo/sửa files theo bảng "Files to Create/Modify"
   - Code trọn vẹn logic nghiệp vụ end-to-end

3. **Build & verify**:
   - Build thành công (compile sạch, no errors)
   - Đảm bảo: BUILD SUCCESS, exit code 0

4. **Tự review diff** so với design.

5. **Đề xuất commit**: `[KEY] type: TX - <description>` (chỉ commit khi dev đồng ý)

**Cổng G3-TX (BẮT BUỘC DỪNG)**:
- Trình bày: Build result + Diff code
- **DỪNG CHỜ DEV DUYỆT**
- **TUYỆT ĐỐI KHÔNG** tự động chuyển sang subtask tiếp theo

**Đồng bộ sau G3-TX duyệt**:
- `03-tasks.md`: Tick ✅ TX done, ghi commit hash
- `state.md`: Update progress (`K/N done`), Current Handover → "Next: T(X+1)"

**⚠️ CHỜ DEV XÁC NHẬN G3-TX và CHỈ THỊ RÕ RÀNG "tiếp tục T(X+1)" trước khi bắt đầu subtask tiếp theo**

**💡 Checkpoint Gợi ý Session:**
- **Thời điểm**: Sau G3-TX khi subtask vừa xong có:
  - Diff dài (>200 dòng changes)
  - Hoặc log build/test lớn (>100 dòng output)
  - Và còn ít nhất 1 subtask tiếp theo chưa làm
- **Lý do**: Context đã phình to với code changes + test logs, nhưng subtask tiếp theo lại cần load tài liệu P1-P2 mới
- **Gợi ý**: *"TX vừa xong có diff/log khá dài. Bạn có thể mở session mới cho T(X+1) để context sạch và tiết kiệm token."*
- **Nếu dev muốn tiếp**: Không bắt buộc, tiếp tục session hiện tại bình thường

---

**END FOR** (Quay lại đầu vòng lặp cho subtask tiếp theo)

---

### 🔄 Lưu ý Quan trọng về Thứ tự Thực thi

**✅ ĐÚNG - Ví dụ với 3 subtasks:**
```
T1: Phase 1 → G1 (chờ duyệt) → Phase 2 → G2 (chờ duyệt) → Phase 3 → G3 (DỪNG)
     ↓ Dev: "OK, tiếp tục T2"
T2: Phase 1 → G1 (chờ duyệt) → Phase 2 → G2 (chờ duyệt) → Phase 3 → G3 (DỪNG)
     ↓ Dev: "OK, tiếp tục T3"
T3: Phase 1 → G1 (chờ duyệt) → Phase 2 → G2 (chờ duyệt) → Phase 3 → G3 (DỪNG)
     ↓ Dev: "OK, hoàn tất"
```

**❌ SAI - KHÔNG được làm:**
```
❌ T1-Phase1, T2-Phase1, T3-Phase1 → T1-Phase2, T2-Phase2, T3-Phase2 → ...
❌ Giao T1, T2, T3 cho sub-agents chạy song song
❌ Tự động chuyển T1 → T2 mà không có xác nhận của dev
```

**Dừng ngay khi**: 
- Thiết kế có điểm chưa rõ
- Scope thay đổi trong quá trình code
- Build lỗi lặp > 2 lần (Rule of 2)

---

## Bước 4 – Hoàn tất
1. **Review 2 tầng** (giao agent `code-review`): đúng spec + chất lượng code. Trình bày ngắn gọn kết quả review.
2. Hỏi người dùng xác nhận nghiệm thu.
3. **💡 Gợi ý Jira (bắt buộc nhắc)**: Nhắc dev chuyển trạng thái Jira sang trạng thái tiếp theo (thường là **"Done"**, **"QA"**, hoặc **"Ready for QA"** tùy workflow) + comment tóm tắt công việc đã làm (qua CLI/MCP hoặc thủ công).
4. **Đồng bộ `state.md`**: Đánh dấu `[x] Phase 4: Code Review độc lập`.
5. Gợi ý người dùng chạy `update-workspace` để hoàn tất toàn bộ vòng đời (Phase 6).

---

## Cascade Validation
Khi requirement/design của subtask TX thay đổi sau khi đã duyệt:
1. **Sửa `01-requirement.md` (Phase 1-TX)**: 
   - Phải revalidate `02-design.md` (Phase 2-TX)
   - Nếu đã code (Phase 3-TX done), check xem code có còn match với requirement mới không
2. **Sửa `02-design.md` (Phase 2-TX)**:
   - Check code đã implement (Phase 3-TX) có còn đúng với design mới không
   - Refactor nếu cần thiết
3. **Trình bày impact analysis**: Những thay đổi nào cần làm, ảnh hưởng đến subtasks khác không
4. **Chờ dev confirm** trước khi tiếp tục

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
