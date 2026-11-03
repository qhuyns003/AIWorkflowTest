---
inclusion: always
---
# AI Workspace – Core Rules

> Đọc đầu mỗi session. Chi tiết workflow và quy tắc chuyên sâu nằm trong skills (chỉ nạp khi cần).

## Tech Stack & Commands
| Service | Build | Test | Lint |
|---|---|---|---|
| service-a | `mvn -q -DskipTests package` | `mvn -q test` | `mvn -q checkstyle:check` |
| frontend | `npm ci && npm run build` | `npm test` | `npm run lint` |

Submodule: `git submodule update --init <path>` · `git -C src/<svc> checkout <branch> && git -C src/<svc> pull`

## Core Principles
1. **Wiki first**: Tra cứu `.wiki/` trước khi đọc mã nguồn `/src`. Nếu `.wiki/` trống/placeholder → bỏ qua, đọc code, sau đó cập nhật lại wiki. Khám phá rộng → giao sub-agent.
2. **Không đoán nghiệp vụ & giải pháp**: Gặp điểm chưa rõ → hỏi người dùng bằng câu hỏi đánh số cụ thể kèm phương án đề xuất. Nếu có nhiều cách hiểu → trình bày tất cả, không tự ý chọn.
3. **Explore → Plan → Implement → Verify**: Tuyệt đối không sửa code trước khi người dùng duyệt thiết kế tại Cổng G2.
4. **Simplicity first**: Code tối giản giải đúng bài toán. Không thêm tính năng ngoài yêu cầu, không tạo abstraction cho code dùng một lần, không xử lý lỗi cho kịch bản không thể xảy ra. Nếu viết 200 dòng mà có thể giải bằng 50 dòng → viết lại.
5. **Surgical changes**: Chỉ sửa đúng phần được yêu cầu. Không "cải tiến" code xung quanh, không refactor thứ chưa hỏng, không format lại file không liên quan. Nếu phát hiện dead code có sẵn → báo nhưng không tự xóa. Mọi dòng thay đổi phải truy vết được về yêu cầu của người dùng.
6. **Không tự commit/push.** Tuyệt đối không tự chạy git commit/push. Không bao giờ push `docs/ba`, `docs/dev`, `docs/sit`, `state.md`. Cho phép commit & push `.wiki/` vì đây là **Source of Truth** chung của hệ thống.
7. **Nhánh làm việc**: Mọi thay đổi mã nguồn phải ở nhánh `feature/<KEY>-<mô-tả>` hoặc `bugfix/...`, không sửa trực tiếp trên `develop` hay `master`.
8. **Bảo mật tối thượng**: Không đưa secret, token, API key, mật khẩu hoặc dữ liệu khách hàng thật vào code, log, wiki hay tài liệu.
9. **Tích hợp ngoài**: Jira, Confluence dùng CLI/MCP đã cấu hình; không tự gọi REST.
10. **Rule of 2**: Nếu sửa cùng một lỗi kiểm thử >2 lần thất bại → dừng lại, báo người dùng, đề xuất hướng tiếp cận khác.
11. **Chưa chạy verification → Không báo "xong"**: Luôn đưa bằng chứng kết quả build sạch thực tế.

## Confirmation Gates
| Cổng | Khi nào | Người dùng xác nhận |
|---|---|---|
| **G1 – Nghiệp vụ** | Sau phân tích yêu cầu | Hiểu đúng BRD, phạm vi (In/Out), edge case, Acceptance Criteria |
| **G2 – Giải pháp** | Sau khi thiết kế | Phương án kỹ thuật, API/DB schema, danh sách subtask kiểm chứng được |
| **G3 – Subtask** | Sau mỗi subtask hoàn thành | Kết quả build sạch & diff (bắt buộc dev duyệt mới sang subtask kế tiếp) |

**Giao thức trao đổi & hỏi**: Không giới hạn số lượng câu hỏi; chủ động trao đổi để làm rõ mọi điểm chưa rõ ràng, mâu thuẫn hoặc nguy cơ tiềm ẩn (question-bank chỉ mang tính tham khảo). Nhóm theo chủ đề, đánh số rõ ràng, nêu 2–3 phương án kèm phương án đề xuất và lý do. Ghi mọi quyết định trực tiếp vào `01-requirement.md` (nghiệp vụ) hoặc `02-design.md` (kỹ thuật), và đồng bộ trạng thái duyệt cổng vào `state.md`.

## Git Convention
- Nhánh: `feature/<JIRA-KEY>-<mô-tả>` (bugfix: `bugfix/...`) từ develop
- Commit: `[<KEY>] <type>: <mô tả>` (feat | fix | refactor | test | docs | chore)

## Context Health & Tiết kiệm Token
- 1 ticket = 1 session. Task dài → cập nhật `state.md` (mục Handover) và checklist `docs/dev/<KEY>/03-tasks.md` để session sau tiếp tục ngay mà không cần nhắc lại context.
- **Chủ động đề xuất đổi session (Chỉ gợi ý, dev quyết định)**: Để tránh lãng phí token khi context phình to, AI chủ động đề xuất người dùng mở session mới tại 2 thời điểm vàng:
  1. *Ngay sau khi duyệt Cổng G2*: Khi đã chốt tài liệu 02, 03 và đồng bộ `state.md` ➔ Đề xuất mở session mới để code Bước 3 với context sạch.
  2. *Sau subtask nặng*: Khi vừa hoàn thành subtask có log build hoặc diff dài ➔ Đề xuất mở session mới cho subtask kế tiếp.
  *Lưu ý*: AI chỉ đưa ra lời khuyên; nếu dev muốn tiếp tục trong session hiện tại, AI tiếp tục làm việc bình thường.
- **Sổ tay trạng thái**: Đọc `state.md` ở đầu session để nắm ngay ngữ cảnh mà không cần quét lại code.
- **Đọc code tiết kiệm**: Dùng grep/search tìm kiếm trước, chỉ đọc line range cần thiết. Output build/test dài → chỉ đọc phần lỗi.

## Workspace Layout
```
src/<service>/     Mã nguồn microservices (Git submodules)
.wiki/             Knowledge Base (Source of Truth, được push) – tra cứu trước khi đọc code
docs/dev/<KEY>/    Hồ sơ kỹ thuật ticket (01-requirement, 02-design, 03-tasks)
state.md           Trạng thái workspace liên phiên – đọc đầu session
```

## Model Tiering (Lựa chọn Model Tối Ưu)
Khi có nhiều model khả dụng, chọn model phù hợp với độ phức tạp của task để tối ưu chi phí và tốc độ:

| Loại Task | Model Khuyến Nghị | Effort | Lý Do |
|---|---|---|---|
| Architecture design, complex debugging, high-stakes decisions | **Opus / o1-Pro** | 🔴 High | Cần reasoning sâu, nhiều bước suy luận, quyết định quan trọng |
| Feature implementation (đã có plan rõ ràng) | **Sonnet / Flash** | 🟡 Medium | Plan đã có, chỉ cần execute theo thiết kế, ít decision |
| Refactoring, viết docs, viết test | **Flash / Lite** | 🟢 Low | Mechanical work, pattern lặp lại, ít creative thinking |
| Quick fix (typo, config, log message) | **Flash / Lite** | 🟢 Low | Task đơn giản, 1-2 file, không cần reasoning |
| Code review, impact analysis | **Sonnet / Pro** | 🟡 Medium | Cần đọc hiểu nhiều file, phân tích tác động, đánh giá risk |
| Deep research, unfamiliar codebase exploration | **Opus / Sonnet** | 🔴 High | Cần khám phá, hiểu context, mapping dependencies |
| Bug investigation (unclear root cause) | **Sonnet / Pro** | 🟡 Medium | Cần trace flow, reproduce, hypothesis testing |
| Routine maintenance (update dependencies, format) | **Flash / Lite** | 🟢 Low | Thao tác đơn giản, theo checklist, ít risk |

**Nguyên tắc:**
- **Opus/Pro** (🔴 High Effort): Dành cho giai đoạn **Explore & Plan** (Bước 1-2 của dev-workflow), yêu cầu nhiều reasoning, decision-making phức tạp, hoặc có high-stakes impact
- **Sonnet/Flash** (🟡 Medium Effort): Dành cho giai đoạn **Implement** (Bước 3) khi đã có thiết kế chi tiết, hoặc task cần đọc hiểu nhiều file nhưng decision đơn giản
- **Flash/Lite** (🟢 Low Effort): Dành cho task mechanical, repetitive work, không có decision-making phức tạp, risk thấp

**Ước lượng Effort:**
- 🔴 **High**: Phức tạp logic, nhiều bất định, cần exploratory thinking, quyết định có tác động lớn
- 🟡 **Medium**: Logic vừa phải, có sẵn pattern/plan, cần đọc hiểu context nhưng decision rõ ràng
- 🟢 **Low**: Repetitive, mechanical, theo checklist/template, minimal decision-making

## Workflow Router
| Nhiệm vụ / Prompt kích hoạt | Skill kích hoạt | Hồ sơ tài liệu yêu cầu |
|---|---|---|
| Typo, config, message (≤3 files, no logic) | `quick-fix` | Không cần tạo docs |
| Logic change rõ, ≤1 service (Lite mode) | `dev-workflow` | `02-design.md` gọn + `03-tasks.md` |
| "bắt đầu task <link>", "thực hiện task <link>", "làm ticket <key>" (Full mode) | `dev-workflow` | Đủ bộ `01` → `03` |
| Khởi tạo / Refresh workspace (DEV) | `clone-workspace` | Đồng bộ submodule & init state |
| Kết thúc ticket, sync state (DEV) | `update-workspace` | Cập nhật wiki & ghi nhận state.md |
| Phân tích nghiệp vụ (PO / BA) | `po-workflow`, `ba-workflow` | `docs/ba/` |
| Kiểm thử hệ thống (SIT / QA) | `sit-workflow` | `docs/sit/` |
