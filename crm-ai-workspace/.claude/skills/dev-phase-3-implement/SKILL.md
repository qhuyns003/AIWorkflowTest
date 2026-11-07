---
name: dev-phase-3-implement
description: >-
  Thực hiện code chi tiết và xác minh build sạch cho một subtask TX theo định hướng từ 02-design.md.
  Dùng khi người dùng nói "implement T1", "code subtask TX", "bắt đầu phase 3 TX".
  Không dùng để sửa đổi thiết kế kiến trúc hay thay đổi API contract (hãy dùng dev-phase-2-design).
---

# Dev Phase 3: Implementation

## 🎯 Single Responsibility
Hiện thực hóa subtask TX dựa trên định hướng giải pháp từ `02-design.md` và mã nguồn thực tế. Tự triển khai code chi tiết, build thành công (compile sạch, no errors).

## 📋 Checklist (7 items - BẮT BUỘC)

<phase_3_checklist>
  <instruction>BẮT BUỘC hoàn thành TẤT CẢ các mục trước khi trình bày tại Cổng G3-TX.</instruction>
  <checklist_items>
    <item id="1" required="true">Chỉ đọc tài liệu TX-&lt;slug&gt;/ (01-requirement.md + 02-design.md), KHÔNG đọc docs của subtask khác</item>
    <item id="2" required="true"> Checkout nhánh feature trong các submodules bị ảnh hưởng - tên nhánh sẽ trùng với tên nhánh của AI workflow đã checkout tại phase 0</item>
    <item id="3" required="true">Khảo sát mã nguồn thực tế tại các điểm chạm (Component / File Path trong Mục 5 của 02-design.md) để nắm conventions &amp; patterns</item>
    <item id="4" required="true">Tự triển khai code chi tiết theo luồng xử lý (Mục 4) và bảng Components to Modify (Mục 5) trong 02-design.md</item>
    <item id="5" required="true">Build thành công: compile sạch, không lỗi cú pháp/kiểu/packaging</item>
    <item id="6" required="true">Xác nhận: BUILD SUCCESS, exit code 0</item>
    <item id="7" required="true">Tự review diff so với tài liệu thiết kế và định hướng thay đổi</item>
  </checklist_items>
  <verification>
    <instruction>Trước khi trình bày tại G3-TX, xác nhận:</instruction>
    <questions>
      <question id="q1">Tôi chỉ đọc docs của TX thôi chứ (không đọc docs subtask khác)?</question>
      <question id="q2">Tôi đã khảo sát code hiện có và implement theo định hướng luồng (Mục 4) &amp; Components to Modify (Mục 5) chưa?</question>
      <question id="q3">Build đã hoàn thành thành công chưa (exit code 0)?</question>
      <question id="q4">Diff có khớp với định hướng không (tất cả components/files dự kiến đã được tạo/sửa)?</question>
      <question id="q5">Tôi có DỪNG LẠI ở đây để chờ dev duyệt trước khi sang subtask tiếp không?</question>
    </questions>
    <output_format>
**Checklist Phase 3-TX Hoàn thành: 7/7 mục**
- Mục #1 (Đọc docs TX): ✅ Xong - Chỉ tập trung vào TX-&lt;slug&gt;/
- Mục #2 (Checkout branch): ✅ Xong - [Tên branch trong submodule] 
- Mục #3 (Khảo sát code): ✅ Xong - Đã đọc các file liên quan tại repo
- Mục #4 (Code chi tiết): ✅ Xong - Đã implement theo luồng &amp; components định hướng
- Mục #5 (Build): ✅ Xong - Compile sạch, không lỗi
- Mục #6 (Xác nhận): ✅ Xong - BUILD SUCCESS, exit code 0
- Mục #7 (Review diff): ✅ Xong - Diff khớp với định hướng thiết kế

**Kết quả Tự Kiểm Tra:**
- Q1 (Context tập trung): ✅ Chỉ đọc docs TX
- Q2 (Khảo sát &amp; Code): ✅ Đã khảo sát code và implement theo định hướng
- Q3 (Build thành công): ✅ Exit code 0
- Q4 (Diff khớp định hướng): ✅ Tất cả components theo kế hoạch đã tạo/sửa
- Q5 (Dừng tại G3): ✅ ĐANG DỪNG - Chờ dev duyệt



**Tóm tắt Diff:**
[Hiển thị các files thay đổi và mô tả ngắn]

**Đề xuất Commit:**
[KEY] feat: TX - [mô tả]

⚠️ **ĐÃ DỪNG TẠI G3-TX** - Chờ xác nhận rõ ràng từ dev: "OK, tiếp tục T(X+1)"
    </output_format>
  </verification>
</phase_3_checklist>

## 📥 Input (Từ Phase 2)
- `TX-<slug>/01-requirement.md`: Requirement đã duyệt
- `TX-<slug>/02-design.md`: Design đã duyệt tại G2-TX

## 🔧 Quy Trình


### Bước 1: Look & Đọc Tài Liệu (Context Tập Trung)

**Checklist item #1:**
1. **Look**: Đọc `TX-<slug>/01-requirement.md`  và `TX-<slug>/02-design.md` .
   - Tuyệt đối không hỏi người dùng những thông tin đã có sẵn trong design doc hoặc code hiện có.
2. **❌ KHÔNG đọc:**
   - Docs của subtask khác (T(X-1), T(X+1))
   - Files không liên quan đến TX
   - Giữ context nhỏ gọn, tập trung vào nhiệm vụ hiện tại

### Bước 2: Khảo Sát Mã Nguồn Thực Tế (Touch Points)


1. **Đọc bảng "Components to Modify"** trong `02-design.md` Mục 5.
2. **Mở và đọc các file liên quan** tại `src/<service>`:
   - Xem cấu trúc class hiện tại, imports, annotations.
   - Hiểu cách inject dependency (Spring `@Autowired`, Lombok `@RequiredArgsConstructor`,...).
   - Hiểu cách đặt tên, cách code method, exception handling, DTO mapping đang dùng trong dự án.

### Bước 3: Triển Khai Code Chi Tiết (Implementation)


1. **Bám sát Luồng xử lý** (Mục 4 của `02-design.md`): Đi qua Controller → Service → Repository theo đúng trình tự.
2. **Tuân thủ Contracts & Schema**:
   - API Contract (Mục 6): đúng path, method, request/response body, error status.
   - DB Schema (Mục 7): đúng tên bảng, kiểu dữ liệu cột, index, migration.
3. **Tự viết code hoàn chỉnh**:
   - Viết method body, business logic, validation, error handling.
   - Không tạo abstraction thừa, không xử lý lỗi cho kịch bản không thể xảy ra (Simplicity first).
   - Chỉ sửa đúng file và phạm vi cần thiết (Surgical changes).

### Bước 4: Build & Verify (Deterministic Scripted Check)

1. **Chạy script kiểm tra build & context health** (Layer 05 - Deterministic):
   ```powershell
   powershell -ExecutionPolicy Bypass -File "scripts/verify-subtask.ps1" -ServicePath "src/<service>"
   ```
   *(Script sẽ tự phát hiện lệnh build Maven/NPM, đo lường exit code, đếm số dòng diff thực tế và trả về compact JSON).*

2. **Kiểm tra output JSON từ script**:
   - ✅ `"status": "SUCCESS"`
   - ✅ `"exit_code": 0`
   - ✅ `"diff_lines"`: số dòng thay đổi thực tế
   - 💡 Nếu `"suggest_new_session": true` (diff > 200 dòng): chuẩn bị câu nhắc gợi ý dev đổi session sau G3.

3. **Nếu build fail**:
   - Đọc trường `"error_snippet"` từ kết quả JSON (không in raw log dài).
   - Sửa lỗi và chạy lại script kiểm tra.
   - Nếu fail **2 lần** → DỪNG NGAY, báo dev kèm error snippet (Rule of 2). Cấm thử lại vòng thứ 3.

### Bước 5: Review Diff

1. Xem diff:
   ```bash
   git diff
   ```

2. **Tự kiểm tra**:
   - ✅ Tất cả components/files trong bảng "Components to Modify" đã được tạo/sửa
   - ✅ Logic code khớp với Luồng xử lý và API contracts
   - ✅ Không có file thay đổi ngoài dự kiến
   - ✅ Không có debug code, commented code, TODO

3. **Tóm tắt diff** (cho G3 presentation):
   - File nào được tạo/sửa
   - Mỗi file thay đổi gì (ngắn gọn)

### Bước 6: Chuẩn Bị Commit Message

**Format**: `[KEY] type: TX - <mô tả>`
- **Types**: `feat` | `fix` | `refactor` | `test` | `docs` | `chore`
- **Ví dụ**: `[CRM-123] feat: T1 - search customer by phone number`

**Lưu ý**: Chỉ **đề xuất**, CHƯA commit (dev sẽ commit sau khi duyệt)

## 📤 Output

**Deliverables:**
- ✅ **Code changes**: Files đã tạo/sửa theo thiết kế
- ✅ **Build success**: Exit code 0, no errors
- ✅ **Diff summary**: Tóm tắt thay đổi
- ✅ **Commit message**: Đề xuất format chuẩn

**Chưa làm:**
- ❌ Commit code (dev sẽ làm sau G3)
- ❌ Viết unit tests (không yêu cầu ở Phase 3)
- ❌ Run tests (chỉ cần compile sạch)

## 🚦 Cổng G3: Exit Condition (HARD STOP)

**Trình bày tại G3-TX theo format trong `<output_format>` XML tag ở trên (section Checklist).**
⚠️ **Hard stop notice**: "ĐÃ DỪNG TẠI G3-TX - Chờ dev duyệt"

**TUYỆT ĐỐI KHÔNG:**
- ❌ Tự động chuyển sang subtask tiếp theo
- ❌ Tự commit code
- ❌ Bắt đầu Phase 1 của T(X+1)

---


## 🔄 Cập Nhật State (Sau khi dev duyệt)

Dev nói "OK" → Cập nhật:
1. **03-tasks.md**:
   - Tick ✅ TX status = `done`
   - Ghi commit hash (sau khi dev commit)
2. **state.md**:
   - Update progress: `K/N subtasks done`
   - Current Handover: `Next: T(X+1) Phase 1`

## 🎬 Next Step

**Nếu còn subtask**: Dev nói "OK, tiếp tục T(X+1)" → Dev invoke `dev-phase-1-requirements` cho T(X+1)

**Nếu hết subtask**: Dev nói "OK, hoàn tất" → Sang Bước 4 (Code Review) trong orchestrator

---

## 📚 Tài Liệu Tham Khảo
> Xem mẫu log build success/failure chi tiết và cách xử lý tại: [../dev-workflow/reference/build-examples.md](../dev-workflow/reference/build-examples.md)

---

## 🛡️ Guard
- alone: đọc requirement/design, khảo sát code, sửa/tạo file trong scope TX, chạy lệnh build/test.
- asks first: sửa file ngoài scope `Components to Modify`, thay đổi contract/schema ngoài thiết kế.
- never: tự ý git commit/push; tự chuyển sang subtask tiếp theo khi chưa được duyệt tại G3; bypass lỗi build.
