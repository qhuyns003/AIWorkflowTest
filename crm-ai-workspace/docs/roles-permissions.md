# Phân quyền theo vai trò

| Thành phần | PO/BA | SIT | DEV |
|---|---|---|---|
| Source code `/src` | Không có quyền | Không có quyền | Full Access |
| Project Instructions `CLAUDE.md` | Read | Read | Read/Write |
| Knowledge Base `.wiki/` | Read | Read | Read/Write |
| Skills Workflow `.claude/skills/` | Read/Use | Read/Use | Read/Write/Use |
| Sub-agents `.claude/agents/` | Use | Use | Read/Use/Manage |

Chú giải: Full Access = đọc, ghi, sửa, xóa · Read/Write = đọc và ghi/sửa · Read/Use = đọc và sử dụng · Use = chỉ sử dụng · Không có quyền = không truy cập.

Mô tả role:
- **PO/BA**: Product Owner / Business Analyst. Tập trung nghiệp vụ, yêu cầu, thiết kế giải pháp. Không cần truy cập mã nguồn.
- **SIT**: System Integration Tester. Tập trung kiểm thử, tích hợp hệ thống. Không truy cập mã nguồn.
- **DEV**: Developer. Tập trung phát triển, code, triển khai. Cần toàn bộ thành phần dự án.

Mục tiêu: cung cấp đúng thông tin cho đúng người, đúng vai trò, đúng thời điểm, tối ưu hiệu quả làm việc với AI Agent.
