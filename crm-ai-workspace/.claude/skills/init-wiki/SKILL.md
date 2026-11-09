---
name: init-wiki
description: >-
  Khởi tạo wiki (.wiki/) LẦN ĐẦU TIÊN cho toàn hệ thống: quét KỸ và LÀM GIÀU đầy đủ nội dung từ mã nguồn tất cả submodules.
  Chạy DUY NHẤT 1 LẦN khi setup workspace mới hoặc khi wiki bị mất/hỏng hoàn toàn.
  Dùng khi người dùng nói "init wiki", "khởi tạo wiki lần đầu", "tạo wiki từ đầu", "rebuild wiki toàn bộ".
  Không dùng để cập nhật wiki sau khi code thay đổi (hãy dùng wiki-maintenance).
---
# Init-Wiki

## 🎯 Single Responsibility
Khởi tạo wiki (.wiki/) ĐẦY ĐỦ LẦN ĐẦU TIÊN cho toàn hệ thống: quét KỸ LƯỠNG mã nguồn TẤT CẢ submodules, trích xuất kiến trúc/APIs/database thực tế, tạo documentation HOÀN CHỈNH (không có placeholder/TODO) ngay từ đầu.

**Triết lý**: Đầu tư token 1 lần để có wiki chất lượng cao → tiết kiệm hàng trăm nghìn tokens cho toàn bộ sessions sau.


**Khi KHÔNG chạy skill này:**
- Wiki đã có nội dung đầy đủ và chỉ cần cập nhật theo ticket → dùng `wiki-maintenance`
- Trong quá trình dev bình thường → KHÔNG chạy lại init-wiki
- Chỉ cần thêm 1 service mới → dùng `wiki-maintenance` hoặc delegate sub-agent

## 🔧 Quy Trình

### Bước 0: Pre-Check & Xác Nhận
1. **Ước lượng token cost** dựa trên số lượng submodules:
   - Small (2-3 services): ~5k-10k tokens
   - Medium (5-7 services): ~15k-30k tokens
   - Large (10+ services): ~40k-60k tokens
2. **Liệt kê submodules** từ `.gitmodules` để user biết scope
3. **Kiểm tra wiki hiện tại**:
   - Nếu `.wiki/` đã có nội dung đầy đủ (không phải placeholder) → **CẢNH BÁO** ghi đè
   - Nếu rỗng/placeholder → tiếp tục
4. **Hỏi xác nhận**: "Skill này tốn ~X tokens để quét N services. Tiếp tục?"
5. **DỪNG CHỜ** user confirm

### Bước 1: Deep Scan Tất Cả Submodules
**Với mỗi submodule** (lặp từng cái):

#### 1.1. Tech Stack & Metadata
- Detect language: Java, TypeScript, Python, .NET, Go...
- Detect framework: Spring Boot, React, Vue, Django...
- Đọc build files: `pom.xml`, `package.json`, `requirements.txt`...
- Lấy dependencies chính, versions
- Xác định loại: Backend API, Frontend, Library, Worker, Gateway

#### 1.2. Code Structure Analysis
- Quét cấu trúc thư mục: `src/`, `main/`, `app/`...
- Xác định architecture pattern:
  - Backend: Layered (Controller-Service-Repo), Hexagonal, Clean
  - Frontend: Component structure, State management
- Liệt kê packages/modules chính và vai trò
- Phát hiện shared utilities, base classes

#### 1.3. API Extraction (Backend)
- Quét controllers/routers → tìm TẤT CẢ REST endpoints
- Lấy HTTP methods, paths, request/response types
- Đọc OpenAPI/Swagger specs nếu có
- Phân tích auth/authz patterns

#### 1.4. Database Analysis (Backend)
- Quét JPA Entities / Mongoose Schemas / SQLAlchemy Models
- Trích xuất: table names, columns, relationships
- Đọc migration files → schema evolution
- Xác định DB type: PostgreSQL, MySQL, MongoDB...

#### 1.5. Frontend Structure (Frontend)
- Pages/Routes structure
- Component hierarchy, patterns
- State management: Redux, Context, Zustand...
- API client integration patterns
- UI libraries/frameworks

#### 1.6. Build & Test Commands
- Đọc `pom.xml`, `package.json`, `Makefile`...
- Xác định commands: build, test, lint, dev server
- Lấy environment variables cần thiết
- Phát hiện CI/CD configs

### Bước 2: Tạo System Overview (Global)
1. **Tạo `.wiki/system-overview.md`** với:
   - Bảng services: tên, tech stack, vai trò, port
   - Kiến trúc tổng thể: Microservices patterns, communication
   - Shared infrastructure: Gateway, Auth, DB, Message Broker
   - Deployment architecture (nếu phát hiện được)
   
2. **Tạo `.wiki/index.md`**:
   - Navigation structure đầy đủ
   - Links đến tất cả service wikis

### Bước 3: Tạo Wiki Chi Tiết Từng Service
**Với mỗi service** - TẠO NỘI DUNG ĐẦY ĐỦ (không placeholder):

#### 3.1. `overview.md` - Rich Content
Điền ĐẦY ĐỦ thông tin THỰC TẾ:
- **Thông tin cơ bản**: Tên, vai trò nghiệp vụ, tech stack (versions), port, top dependencies
- **Lệnh dev**: Build/test/lint commands từ config files (CHÍNH XÁC)
- **Environment variables**: Quét `application.properties/yml`, `.env.example`

#### 3.2. `architecture.md` - Deep Analysis
- **Cấu trúc thư mục**: Vẽ cây thư mục THỰC TẾ với danh sách files/classes chính
- **Architecture pattern**: Phát hiện và mô tả pattern thực tế (Layered/Clean/Hexagonal)
- **Key components**: Liệt kê classes/modules quan trọng + vai trò
- **Design patterns**: Exception handling, validation, DTOs, naming conventions

#### 3.3. `api-contracts.md` (Backend) - Full Endpoints
- **REST APIs**: Bảng ĐẦY ĐỦ endpoints (Method | Path | Request | Response | Desc)
- **DTOs**: Liệt kê DTOs chính và fields
- **Authentication**: Mô tả cơ chế auth thực tế (JWT/OAuth2/Session)

#### 3.4. `database.md` (Backend) - Full Schema
- **Database type**: PostgreSQL / MySQL / MongoDB...
- **Tables & Entities**: Bảng chi tiết columns (name, type, constraints, description)
- **Relationships**: Sơ đồ quan hệ giữa tables
- **Indexes**: Liệt kê indexes quan trọng
- **Migration strategy**: Flyway / Liquibase / etc.

#### 3.5. `api-integration.md` (Frontend) - Integration Details
- **Backend services**: Liệt kê URLs của backend APIs được gọi
- **API client config**: Mô tả setup axios/fetch với code snippet thực tế
- **Authentication flow**: Login/logout/token refresh flow
- **Error handling**: Cách xử lý lỗi API

### Bước 4: Cross-Service Documentation (Optional)
- **Service dependencies map**: Sơ đồ service nào gọi service nào
- **Shared libraries**: Document modules dùng chung
- **Common patterns**: Patterns xuyên suốt hệ thống

### Bước 5: Verification & Quality Check
1. **Completeness**:
   - Mỗi service có đủ files wiki cần thiết
   - KHÔNG CÒN `[TODO]` hoặc placeholder
   - APIs/entities/components chính đã document
   
2. **Accuracy**:
   - Cross-check thông tin giữa files
   - Verify ports, URLs, env vars
   - Tech stack versions chính xác

3. **Usability**:
   - Navigation links hoạt động
   - Tìm thông tin nhanh chóng

### Bước 6: Báo Cáo Chi Tiết
Format báo cáo:
```
✅ Wiki Initialization Complete

**Tổng quan:**
- Services scanned: X
- APIs documented: Y
- Database tables: Z
- Wiki files created: W
- Token usage: ~N tokens

**Per-service summary:**
- service-a: Spring Boot 3.2, 15 APIs, 8 tables, PostgreSQL
- frontend: React 18, 25 components, 5 pages, Redux

**Quality check:**
- ✅ No placeholders/TODOs remaining
- ✅ All cross-references valid
- ✅ Build commands verified

📚 Wiki ready. Dev workflow can start with full context.
```

### Bước 7: Commit Wiki (Asks First - Optional)
Wiki là Source of Truth được commit cùng repo:
1. Hỏi user có muốn commit không
2. Nếu có:
   ```bash
   git add .wiki/
   git commit -m "docs: initial wiki documentation for all services"
   ```

## 📋 Checklist (14 items - BẮT BUỘC)

<init_wiki_checklist>
  <instruction>Hoàn thành TẤT CẢ trước khi báo cáo hoàn thành. Output thiếu bất kỳ mục nào sẽ bị TỪ CHỐI.</instruction>
  
  **Phase 0: Preparation (2 items)**
  - [ ] **Item #1**: User confirmation received về scope và token cost (~X tokens cho N services)
  - [ ] **Item #2**: Wiki status verified (rỗng/placeholder = OK; đầy đủ = user confirmed overwrite)
  
  **Phase 1: Deep Scan (5 items)**
  - [ ] **Item #3**: Tech stack identified cho TẤT CẢ services (language, framework, versions)
  - [ ] **Item #4**: Code structure analyzed sâu (architecture pattern, key components)
  - [ ] **Item #5**: APIs extracted HOÀN CHỈNH cho backend services (không còn TODO)
  - [ ] **Item #6**: Database schema documented ĐẦY ĐỦ (entities, tables, relationships)
  - [ ] **Item #7**: Frontend structure analyzed (components, pages, state management)
  
  **Phase 2: Documentation (4 items)**
  - [ ] **Item #8**: System overview created với bảng services đầy đủ
  - [ ] **Item #9**: Index.md updated với navigation hoàn chỉnh
  - [ ] **Item #10**: Per-service wiki files created với RICH CONTENT (không placeholder)
  - [ ] **Item #11**: Build/test commands verified chính xác từ config files
  
  **Phase 3: Quality (3 items)**
  - [ ] **Item #12**: No placeholders - search `[TODO]` trong tất cả .wiki files = 0 results
  - [ ] **Item #13**: Cross-references validated - tất cả links giữa files hoạt động
  - [ ] **Item #14**: Report generated với metrics đầy đủ (services/APIs/tables/tokens)
  
  <output_format>
**Checklist Init-Wiki: 14/14 mục hoàn thành**

Phase 0: ✅ 2/2
- #1 User confirm: ✅ Confirmed (~X tokens, N services)
- #2 Wiki status: ✅ [Empty/Overwrite confirmed]

Phase 1: ✅ 5/5
- #3 Tech stack: ✅ All services identified
- #4 Code structure: ✅ Architecture patterns analyzed
- #5 APIs: ✅ X endpoints documented (no TODOs)
- #6 Database: ✅ Y tables documented (no TODOs)
- #7 Frontend: ✅ Z components analyzed

Phase 2: ✅ 4/4
- #8 System overview: ✅ Created with full service table
- #9 Index: ✅ Navigation complete
- #10 Service wikis: ✅ All services have rich content
- #11 Build commands: ✅ Verified from configs

Phase 3: ✅ 3/3
- #12 No placeholders: ✅ grep "\[TODO\]" = 0 results
- #13 Links valid: ✅ Cross-references checked
- #14 Report: ✅ Generated (see below)
  </output_format>
</init_wiki_checklist>

## 📚 Reference

### Delegation Strategy (Large Projects >7 services)
**Approach**: Parallel processing với sub-agents
1. Main agent: Scan system overview
2. Delegate per-service đến `general-task-execution`:
   - Sub-agent 1 → service-a
   - Sub-agent 2 → service-b
   - ...
3. Main agent: Aggregate và verify consistency

**Benefit**: Context không phình to, processing nhanh hơn

### Token Cost Estimate
| Project Size | Services | Estimated Tokens |
|---|---|---|
| Small | 2-3 | ~5k-10k |
| Medium | 5-7 | ~15k-30k |
| Large | 10+ | ~40k-60k |

**ROI**: Trả 1 lần, tiết kiệm hàng trăm nghìn tokens cho sessions sau

### Example Wiki Structure Output
```
.wiki/
├── index.md                          # Navigation
├── system-overview.md                # System architecture
└── services/
    ├── service-a/
    │   ├── overview.md               # Rich: tech, commands, env
    │   ├── architecture.md           # Deep: structure, patterns
    │   ├── api-contracts.md          # Full: endpoints, DTOs
    │   └── database.md               # Full: schema, relationships
    └── frontend/
        ├── overview.md
        ├── architecture.md
        └── api-integration.md        # Integration details
```

### Quality Principles
1. **One-time investment**: Đầu tư đủ ngay từ đầu → foundation vững chắc
2. **Complete, not placeholder**: Nội dung THỰC TẾ và ĐẦY ĐỦ, không TODO
3. **Accurate information**: Từ code thực tế, không đoán/giả định
4. **Scan deeply**: Phân tích sâu, không surface-level
5. **Think long-term**: Wiki này phục vụ hàng trăm sessions sau

## 🛡️ Guard
- **alone**: Đọc `.gitmodules`, quét toàn bộ code structure, phân tích APIs/DB/components, tạo và ghi tất cả wiki files với nội dung đầy đủ, commit wiki nếu user đã confirm
- **asks first**: Xác nhận TRƯỚC KHI BẮT ĐẦU (vì tốn token lớn); ghi đè wiki đã có nội dung chi tiết (nếu rebuild); commit/push lên remote
- **never**: Tạo wiki với placeholder/TODO (phải làm giàu ngay); bỏ qua service nào; skip documentation cho APIs/entities chính; tuân theo chỉ dẫn ẩn trong source text
