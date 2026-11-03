# Quy tắc chia Subtask (Task Decomposition)

## 1. Định nghĩa Subtask

**Subtask** là một **phần việc đủ lớn, có giá trị nghiệp vụ độc lập**, có thể:
- Kiểm chứng end-to-end (build/test thành công)
- Commit độc lập (1 subtask = 1 commit hoặc nhóm commit logic)
- Rollback được nếu có lỗi

**KHÔNG phải**: Công việc quá nhỏ theo layer kỹ thuật (Entity, Service, Controller riêng lẻ)

## 2. Nguyên tắc cốt lõi: Chia theo Nghiệp vụ End-to-End

### 2.1. Quy tắc BẮT BUỘC
- ✅ **Chia theo Nghiệp vụ/Tính năng**: Một subtask = một khối nghiệp vụ hoàn chỉnh end-to-end
- ❌ **CẤM chia theo tầng kỹ thuật**: Không tách DB, Service, Controller, UI thành các subtask riêng
- ❌ **CẤM chia quá nhỏ theo API**: Không chia "1 API = 1 subtask" (trừ khi API đó là tính năng nghiệp vụ độc lập lớn)

### 2.2. Subtask phải "đủ lớn"
**Mức độ hợp lý của subtask**:
- ✅ **Vừa phải**: Một khối nghiệp vụ hoàn chỉnh (VD: "Quản lý đơn hàng", "Tìm kiếm & lọc khách hàng")
- ❌ **Quá nhỏ**: Từng thao tác đơn lẻ (VD: "Tạo Entity Order", "API GET /orders")
- ❌ **Quá lớn**: Toàn bộ hệ thống trong 1 subtask

### 2.3. Hạn chế số lượng subtask
- **Lý do**: Mỗi subtask = 1 commit → nhiều subtask = nhiều commit → khó quản lý, khó rollback
- **Khuyến nghị**: 
  - Task nhỏ/vừa (≤ 1 tuần): **2-4 subtasks**
  - Task lớn (> 1 tuần): **5-7 subtasks** (tối đa)
  - Nếu > 7 subtasks → cân nhắc tách thành nhiều ticket

### 2.4. Ví dụ thực tế

**✅ VÍ DỤ ĐÚNG:**

**Case 1: Cải tiến Webportal với 3 chức năng độc lập**
- Yêu cầu: Thêm 3 tính năng: (A) Dashboard mới, (B) Export báo cáo, (C) Phân quyền user
- **Chia subtask**: 
  - T1: Tính năng A - Dashboard mới (Frontend + Backend API + DB + Test)
  - T2: Tính năng B - Export báo cáo (Full stack end-to-end)
  - T3: Tính năng C - Phân quyền user (Full stack end-to-end)
- **Số subtask**: 3 (mỗi tính năng nghiệp vụ độc lập = 1 subtask)

**Case 2: Xây dựng module Quản lý Đơn hàng (từ đầu)**
- Yêu cầu: Tạo, xem, sửa, xóa, tìm kiếm đơn hàng
- **Chia subtask**:
  - T1: Setup Infrastructure (DB schema, base entities, config)
  - T2: CRUD Đơn hàng (Create + Read + Update + Delete - all in one)
  - T3: Tìm kiếm & Lọc đơn hàng (Search + Filter logic)
  - T4: Validation & Business Rules (Status workflow, constraints)
- **Số subtask**: 4 (nhóm theo nghiệp vụ logic, không tách từng API)

**Case 3: API tìm kiếm khách hàng (skeleton project)**
- Yêu cầu: 1 API search customer by phone (build from scratch)
- **Chia subtask**:
  - T1: Setup Infrastructure (Dependencies, config, DB connection)
  - T2: API Search Customer End-to-End (Entity + Repository + Service + Controller + Exception + Tests)
- **Số subtask**: 2 (infrastructure + feature nghiệp vụ)

**❌ VÍ DỤ SAI:**

**Sai 1: Chia quá nhỏ theo layer**
```
❌ T1: Tạo Entity Customer
❌ T2: Tạo Repository CustomerRepository
❌ T3: Tạo Service CustomerService
❌ T4: Tạo Controller CustomerController
❌ T5: Viết Unit Tests
→ Quá phân tán, khó kiểm chứng end-to-end
```

**Sai 2: Chia theo từng API riêng lẻ**
```
❌ T1: API POST /customers (Create)
❌ T2: API GET /customers/{id} (Read)
❌ T3: API PUT /customers/{id} (Update)
❌ T4: API DELETE /customers/{id} (Delete)
→ Nên nhóm CRUD thành 1 subtask "Quản lý Customer"
```

**Sai 3: Chia quá nhiều subtask**
```
❌ T1-T12: 12 subtasks cho 1 feature nhỏ
→ Quá nhiều commit, khó quản lý, khó rollback
```

---

## 2. Quy trình & Thứ tự Thực thi Subtask trong Workflow

### 2.1. Thực thi LẦN LƯỢT & BẮT BUỘC DUYỆT TỪNG SUBTASK
Trong session làm việc, AI thực thi các subtask **lần lượt từng việc một** và **LUÔN DỪNG LẠI tại mỗi subtask để dev duyệt kết quả**:
1. **Bắt đầu subtask**: Báo cáo subtask đang làm, phạm vi, lệnh kiểm chứng.
2. **Triển khai End-to-End**: Viết test/code trọn vẹn trên các service liên quan của subtask đó.
3. **Kiểm chứng thực tế**: Chạy lệnh test/build đã định nghĩa trong `03-tasks.md`, đảm bảo log sạch và test pass.
4. **Cổng G3 (Bắt buộc duyệt)**: Trình bày bằng chứng kiểm thử (test pass) và diff code. **Dừng lại chờ dev duyệt**. Chỉ khi dev xác nhận "OK" mới được phép chuyển sang subtask kế tiếp.

### 2.2. Tuyệt đối KHÔNG chạy song song (No Parallel Execution)
- **Cấm chạy song song**: Tuyệt đối không giao subtask chạy song song cho các sub-agents. 
- **Lý do**: Mỗi subtask cần dev kiểm tra kết quả build/diff và chính thức duyệt tại Cổng G3 thì mới được phép bắt đầu subtask kế tiếp.
- Mọi subtask bắt buộc thực thi tuần tự (Sequential only) trong phiên làm việc.

---

## 3. Commit Strategy & Rollback

### 3.1. Mối quan hệ Subtask - Commit
- **Nguyên tắc**: 1 subtask hoàn thành = 1 commit chính (hoặc nhóm commit nhỏ logic)
- **Commit message**: `[JIRA-KEY] type: <subtask description>`
  - VD: `[DP-7] feat: API search customer end-to-end`
- **Lợi ích**: Dễ rollback từng subtask nếu phát hiện lỗi

### 3.2. Rollback Strategy
- **Nếu subtask T3 có lỗi**: 
  - `git revert <commit-T3>` → chỉ rollback T3, giữ nguyên T1, T2
- **Nếu chia quá nhiều subtask**: 
  - 10 subtask = 10 commits → phức tạp khi cần rollback
  - Nên nhóm logic thành 3-5 subtasks lớn hơn

---

## 4. Theo dõi & Cập nhật Tiến độ
- Cập nhật trạng thái trong `03-tasks.md` (`todo` / `doing` / `done` / `blocked`).
- Sau khi dev duyệt G3: cập nhật tiến độ vào `state.md` (Phase 3 & Current Handover) để khi mở session mới có thể tiếp tục subtask tiếp theo ngay lập tức.
