# Quy tắc chia Subtask

## 1. Định nghĩa Subtask

**Subtask** là một **use case nghiệp vụ hoàn chỉnh** từ góc nhìn user, có thể:
- Kiểm chứng end-to-end (build/test pass)
- Commit độc lập và rollback được

**KHÔNG phải**: Tầng kỹ thuật riêng lẻ (Entity, Service, Controller, Test tách rời)

---

## 2. Nguyên tắc chia Subtask

### 2.1. Chia theo USE CASE, không chia theo Layer
- ✅ **Đúng**: "Khách hàng tạo đơn hàng" (user story hoàn chỉnh - full stack từ DB đến UI)
- ❌ **Sai**: "Setup Database", "Create API", "Write Tests" (chia theo layer kỹ thuật)
- Sau khi chia pahri hỏi ý kiến dev đồng ý cách chia hay không

**Câu hỏi kiểm tra**: _"User/Admin làm được việc GÌ sau khi subtask này xong?"_
- Nếu trả lời: "Chưa làm được gì, chỉ có DB/API/config" → **SAI**
- Phải trả lời được: "Khách tạo được đơn hàng mới" → **ĐÚNG**

### 2.2. Giới hạn số lượng: 1-4 subtasks
- **Nguyên tắc VÀNG**: Mọi task chỉ chia **1-4 subtasks**, càng ít càng tốt
- Nếu cần > 4 subtasks → nhóm lại theo nghiệp vụ hoặc tách ticket
- Lợi ích: Ít commit, dễ review, dễ rollback

---

## 3. Ví dụ

### ✅ Đúng: Chia theo nghiệp vụ

**Case 1: Quản lý Đơn hàng**
```
T1: Tạo & Xem đơn (Khách tạo đơn mới, xem chi tiết - full stack)
T2: Quản lý trạng thái (Cập nhật pending→confirmed→delivered, hủy đơn - full stack)
T3: Tìm kiếm đơn (Filter theo ngày/trạng thái/khách - full stack)
```

**Case 2: Tìm kiếm khách hàng (task đơn giản)**
```
T1: Call center nhập SĐT → hệ thống trả thông tin khách (full stack end-to-end)
```

### ❌ Sai: Chia theo layer kỹ thuật

```
❌ T1: Tạo Entity Order
❌ T2: Tạo Repository
❌ T3: Tạo Service
❌ T4: Tạo Controller
❌ T5: Viết Tests
→ Phải nhóm thành 1 subtask "Khách tạo đơn hàng"
```

---

## 4. Quy trình Thực thi

### 4.1. Thực thi tuần tự, bắt buộc duyệt từng subtask
1. Implement subtask end-to-end (test + code)
2. Chạy build/test, verify thành công
3. **Cổng G3**: Trình bày kết quả test + diff, **chờ dev duyệt**
4. Dev confirm "OK" → chuyển subtask tiếp theo

### 4.2. CẤM chạy song song
- Mỗi subtask cần dev duyệt tại G3 mới tiếp tục
- Không giao cho sub-agent chạy song song

---

## 5. Commit & Rollback

- **1 subtask = 1 commit**: `[JIRA-KEY] feat: <use case description>`
- **Rollback dễ dàng**: `git revert <commit-T2>` → chỉ rollback T2, giữ T1
- **Ưu điểm 1-4 subtasks**: Ít commit → dễ quản lý, dễ hiểu context, rollback rõ ràng

---

## 6. Theo dõi tiến độ

- Cập nhật `03-tasks.md`: `todo` / `doing` / `done` / `blocked`
- Sau G3: cập nhật `state.md` để session sau tiếp tục
