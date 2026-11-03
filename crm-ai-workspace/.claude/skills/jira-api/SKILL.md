---
name: jira-api
description: >-
  Tra cứu và cập nhật ticket Jira qua REST API chính thức của Atlassian bằng script PowerShell cục bộ (Zero-Install).
  KÍCH HOẠT khi người dùng yêu cầu: đọc ticket Jira, lấy mô tả/AC của task, chuyển trạng thái Jira,
  hoặc comment báo cáo tiến độ lên ticket.
---
# Jira API Skill (REST API Wrapper)

Tương tác với hệ thống Jira thông qua script an toàn [scripts/jira.ps1] (dùng lệnh `Invoke-RestMethod` có sẵn của Windows, không cần cài đặt thêm phần mềm).

## 1. Triggers (Dấu hiệu kích hoạt)
Tự động sử dụng skill này khi:
- Người dùng cung cấp Jira key và yêu cầu đọc nội dung (ví dụ: *"lấy thông tin ticket CRM-102"*, *"đọc yêu cầu từ Jira"*).
- Ở Bước 1 của `dev-workflow`: Cần lấy Description và Acceptance Criteria (AC) từ Jira để soạn tài liệu yêu cầu.
- Ở Bước 4 của `dev-workflow`: Cần cập nhật trạng thái Jira sang `Ready for Review` / `Done` và comment tóm tắt kết quả.

---

## 2. Các lệnh thực thi qua terminal

Tất cả các lệnh đều chạy trực tiếp từ thư mục gốc của workspace:

### 2.1. Đọc thông tin Ticket (Read)
Lấy tóm tắt, trạng thái, người phụ trách, mô tả và danh sách subtask:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\jira.ps1 get <JIRA-KEY>
```
*Ghi chú*: Kết quả trả về đã được lọc gọn gàng (chỉ lấy các trường nghiệp vụ quan trọng), giúp tiết kiệm hơn 90% lượng token so với việc tải toàn bộ JSON thô từ Jira.

### 2.2. Kiểm tra các trạng thái có thể chuyển (Transitions)
Xem danh sách các trạng thái hợp lệ của ticket hiện tại:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\jira.ps1 transitions <JIRA-KEY>
```

### 2.3. Đổi trạng thái Ticket (Move / Transition)
Chuyển ticket sang trạng thái mới (ví dụ: "In Progress", "Resolved", "Done"):
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\jira.ps1 transition <JIRA-KEY> "In Progress"
```
> [!IMPORTANT]
> Luôn xác nhận với người dùng trước khi thực hiện chuyển trạng thái ticket.

### 2.4. Thêm Comment báo cáo tiến độ (Comment)
Gửi ghi chú tiến độ hoặc tóm tắt các commit/diff:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\jira.ps1 comment <JIRA-KEY> "Đã hoàn thành implement subtask T1 theo design."
```
> [!IMPORTANT]
> Luôn xác nhận nội dung comment với người dùng trước khi gửi lên Jira.

---

## 3. Xử lý khi gặp lỗi cấu hình
Nếu chạy script gặp thông báo: `[ERROR] Chưa cấu hình thông tin Jira!`:
1. Nhắc người dùng copy file mẫu `.env.jira.example` thành `.env.jira` tại thư mục gốc.
2. Hướng dẫn người dùng điền URL và Token cá nhân (PAT đối với Jira On-Premise hoặc API Token đối với Jira Cloud).
3. Đảm bảo với người dùng rằng `.env.jira` đã nằm trong `.gitignore` nên tuyệt đối an toàn.
