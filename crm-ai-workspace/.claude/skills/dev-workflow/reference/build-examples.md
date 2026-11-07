# Ví Dụ: Build & Verify Output (Java & Node)

> **Tài liệu tham khảo (Level 3 Resource)**: Mẫu log build success và failure cho Phase 3 Verification.

---

## 1. Java (Maven)

### ✅ ĐÚNG: Build Success (Exit code 0)
```bash
$ cd src/service-a
$ mvn -q -DskipTests package

[INFO] Scanning for projects...
[INFO] Building customer-service 1.0.0
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- maven-compiler-plugin:3.8.1:compile (default-compile) @ customer-service ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 15 source files to target/classes
[INFO] 
[INFO] --- maven-jar-plugin:3.2.0:jar (default-jar) @ customer-service ---
[INFO] Building jar: target/customer-service-1.0.0.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 3.456 s
[INFO] Finished at: 2026-11-05T10:30:15+07:00
[INFO] ------------------------------------------------------------------------

Exit code: 0
```

### ❌ SAI: Compilation Error (Exit code != 0)
```bash
$ mvn -q -DskipTests package

[ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.8.1:compile
[ERROR] /src/main/java/CustomerService.java:[25,10] cannot find symbol
[ERROR]   symbol:   method findByPhone(java.lang.String)
[ERROR]   location: variable repository of type CustomerRepository

Exit code: 1
```
**Hành động**: Đọc error log thật → Xác định class/method thiếu → Sửa code → Build lại (tối đa 2 lượt sửa trước khi dừng báo dev theo Rule of 2).

---

## 2. Frontend (Node / npm)

### ✅ ĐÚNG: Build Success
```bash
$ cd src/frontend
$ npm run build

> frontend@1.0.0 build
> next build

   ▲ Next.js 14.1.0
   - Environments: .env.production

   Creating an optimized production build ...
 ✓ Compiled successfully
 ✓ Linting and checking validity of types
 ✓ Collecting page data
 ✓ Generating static pages (5/5)
 ✓ Finalizing page optimization

Route (app)                              Size     First Load JS
┌ ○ /                                    5.2 kB         85.1 kB
└ ○ /customers                           7.4 kB         87.3 kB
+ First Load JS shared by all            79.9 kB

Exit code: 0
```

