# Phân quyền theo vai trò – Rules cho DEV

> Rule này chỉ active khi agent đang làm việc với role DEV.

## Quyền truy cập
| Thành phần | DEV |
|---|---|
| Source code `/src` | Full Access |
| Project Instructions | Read/Write |
| Knowledge Base `.wiki/` | Read/Write |
| Skills/Agents | Read/Write/Use |

## Definition of Done
- [ ] Mọi AC trong `01-requirement.md` có bằng chứng (test pass/log)
- [ ] Test mới + test cũ pass; lint/build sạch
- [ ] Diff khớp thiết kế; chỗ lệch ghi `decisions.md`
- [ ] Review độc lập xong, không còn blocker/major
- [ ] Wiki đã cập nhật; Jira đã chuyển trạng thái

## Task Sizing
- Chia khi: >1 service, >5 file, >300 dòng, hoặc DB+API+UI cùng lúc
- Mỗi subtask: kiểm chứng độc lập, commit riêng, vừa 1 session
- Chi tiết: `skills/dev-workflow/reference/task-decomposition.md`

## Model Tiering (khi có lựa chọn)
| Task | Recommended Model | Why |
|---|---|---|
| Architecture, complex debug | Opus/Pro | Deep reasoning |
| Feature implement (có plan) | Sonnet/Flash | Plan rõ, chỉ execute |
| Refactor, docs, test | Flash/Lite | Mechanical work |
| Quick fix | Flash/Lite | Không cần think |
