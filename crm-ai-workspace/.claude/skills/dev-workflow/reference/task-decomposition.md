# Quy tắc chia Subtask (Task Decomposition)

## 1. Nguyên tắc cốt lõi: Chia theo Nghiệp vụ / Yêu cầu (Feature-based)
- **Subtask được chia theo từng Đơn vị Nghiệp vụ hoặc Yêu cầu tính năng**, tuyệt đối **KHÔNG chia theo tầng kỹ thuật** (không tách DB riêng, API riêng, UI riêng).
- **Trọn vẹn End-to-End**: Một nghiệp vụ dù trải trên nhiều service (ví dụ: DB migration + Backend API + Frontend UI) thì **vẫn là 1 Subtask duy nhất**. Xong subtask là tính năng đó chạy được và kiểm chứng được đầu–cuối.
- **Ví dụ thực tế**:
  - *Ví dụ 1*: Cải tiến Webportal gồm 3 tính năng A, B, C ➜ Chia thành đúng **3 Subtask** (Subtask 1: Tính năng A end-to-end; Subtask 2: Tính năng B end-to-end; Subtask 3: Tính năng C end-to-end), **không xé nhỏ thêm**.
  - *Ví dụ 2*: Yêu cầu chỉnh sửa 3 API độc lập ➜ Chia thành đúng **3 Subtask** (mỗi API là 1 subtask hoàn chỉnh kèm test).

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

## 3. Theo dõi & Cập nhật Tiến độ
- Cập nhật trạng thái trong `03-tasks.md` (`todo` / `doing` / `done` / `blocked`).
- Sau khi dev duyệt G3: cập nhật tiến độ vào `state.md` (Phase 3 & Current Handover) để khi mở session mới có thể tiếp tục subtask tiếp theo ngay lập tức.
