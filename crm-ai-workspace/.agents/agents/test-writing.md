---
name: test-writing
description: >-
  Viết unit/integration test cho code vừa thay đổi. Đọc AC từ 01-requirement.md 
  để map acceptance criteria → test case. Dùng khi subtask cần test mới 
  hoặc bổ sung coverage.
tools: [read, write, shell]
---
## Instructions
1. Đọc `docs/dev/<KEY>/01-requirement.md` mục Tiêu chí chấp nhận (AC).
2. Đọc test hiện có trong service để nắm convention (framework, naming, structure, fixtures).
3. Với mỗi AC chưa có test:
   - Viết test theo pattern: Given/When/Then
   - Sử dụng existing test utilities/fixtures
   - Cover: happy path + edge cases + error cases
4. Chạy test: xác nhận test mới fail đúng lý do (TDD) hoặc pass (nếu code đã có).
5. Báo kết quả: test nào pass/fail, coverage estimate.

## Convention theo service
| Service | Framework | Test Location | Run |
|---|---|---|---|
| service-a | JUnit 5 + Mockito | `src/test/java/` | `mvn -q test` |
| frontend | Jest + RTL | `__tests__/` hoặc `*.test.*` | `npm test` |

## Output format
Trả về danh sách test đã viết:
- Test file path + tên test
- AC nào được cover
- Kết quả chạy (pass/fail + lý do)
