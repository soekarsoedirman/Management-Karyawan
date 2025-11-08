# 🛠️ SQL Server Troubleshooting Tools

Folder ini berisi semua tool dan script untuk mendiagnosa dan memperbaiki masalah SQL Server.

---

## 📂 Daftar Tools

### 🔍 Diagnostic Tools

#### 1. **diagnose-sql.ps1** (PowerShell - Recommended)
Auto-diagnostic tool dengan kemampuan auto-fix.

**Cara Pakai:**
```powershell
# Jalankan sebagai Administrator
cd backend/docs/errors/tools
.\diagnose-sql.ps1
```

**Fitur:**
- ✅ Auto-check 8 area: service status, port, TCP connection, firewall, processes, Node.js test, .env validation, SQL Browser
- ✅ Auto-fix: Start services, create firewall rules
- ✅ Detailed error reporting dengan solusi
- ✅ Color-coded output untuk mudah dibaca

**Kapan Pakai:**
- Error P1001 (Can't reach database server)
- Error ECONNRESET
- Sebelum setup project baru
- Troubleshooting koneksi SQL Server

---

#### 2. **diagnose-sql.bat** (Batch - Non-Admin)
Diagnostic tool versi batch (tidak perlu Administrator).

**Cara Pakai:**
```cmd
cd backend\docs\errors\tools
diagnose-sql.bat
```

**Fitur:**
- ✅ Manual diagnosis 6 area
- ✅ Tidak perlu admin rights
- ✅ Rekomendasi fix di akhir

**Kapan Pakai:**
- Tidak punya akses Administrator
- Quick check tanpa auto-fix
- Environment production

---

#### 3. **fix-eperm.ps1** ⚡ NEW - Quick Fix EPERM
Auto-fix script khusus untuk EPERM error (file lock).

**Cara Pakai:**
```powershell
# Jalankan sebagai Administrator
cd backend/docs/errors/tools
.\fix-eperm.ps1
```

**Yang Dilakukan:**
1. ✅ Stop semua Node.js processes
2. ✅ Delete `.prisma` folder di `node_modules`
3. ✅ Generate Prisma Client ulang
4. ✅ Test dengan `prisma db push`

**Kapan Pakai:**
- Error EPERM saat `npx prisma generate`
- File `query_engine-windows.dll.node` locked
- Server masih jalan di background

**See Full Guide:** [ERROR-EPERM.md](../ERROR-EPERM.md)

---

### 🔧 Setup Scripts

#### 4. **setup-sql-login.sql**
Script lengkap untuk setup user SQL Server untuk Prisma.

**Cara Pakai:**
```bash
# Option 1: Via SSMS (SQL Server Management Studio)
# 1. Buka SSMS
# 2. Connect dengan Windows Authentication
# 3. Open file setup-sql-login.sql
# 4. Execute (F5)

# Option 2: Via sqlcmd
sqlcmd -S localhost -E -i setup-sql-login.sql
```

**Yang Dilakukan Script:**
1. ✅ Buat login `prisma_user` dengan password `Prisma!2025`
2. ✅ Grant role `dbcreator` (untuk migrations & shadow DB)
3. ✅ Buat database `db_restoran`
4. ✅ Buat user `prisma_user` di database
5. ✅ Grant role `db_owner` untuk full access

**Kapan Pakai:**
- Error P1000 (Authentication failed)
- Setup project pertama kali
- User SQL Server belum dibuat

---

#### 4. **grant-create-db.sql**
Script khusus untuk grant CREATE DATABASE permission.

**Cara Pakai:**
```bash
sqlcmd -S localhost -E -i grant-create-db.sql
```

**Yang Dilakukan:**
- ✅ Grant role `dbcreator` ke `prisma_user`
- ✅ Diperlukan untuk Prisma Migrate (shadow DB)

**Kapan Pakai:**
- Error saat `prisma migrate dev`
- Permission denied untuk create database
- Shadow database tidak bisa dibuat

---

#### 5. **enable-sql-auth.ps1**
Auto-enable Mixed Authentication Mode via Registry.

**Cara Pakai:**
```powershell
# Jalankan sebagai Administrator
cd backend/docs/errors/tools
.\enable-sql-auth.ps1
```

**Yang Dilakukan:**
1. ✅ Set registry LoginMode = 2 (Mixed Mode)
2. ✅ Auto-restart SQL Server service
3. ✅ Aktifkan SQL Authentication

**Kapan Pakai:**
- Error P1000: Login failed for user 'prisma_user'
- SQL Server hanya Windows Auth
- Perlu enable SQL Authentication

---

### 🧪 Testing Tools

#### 6. **test-connection.js**
Comprehensive connection test untuk SQL Server dengan Node.js.

**Cara Pakai:**
```bash
# From backend folder
cd backend
node docs/errors/tools/test-connection.js

# Or from tools folder
cd backend/docs/errors/tools
node test-connection.js
```

**Yang Ditest:**
1. ✅ Connection ke SQL Server
2. ✅ Query execution
3. ✅ Database existence
4. ✅ User permissions (db_owner check)
5. ✅ Table operations (CREATE, INSERT, SELECT, DROP)

**Output:**
- ✅ Detailed step-by-step test results
- ✅ Error diagnosis dengan solusi
- ✅ Next steps setelah sukses

**Kapan Pakai:**
- Setelah setup user SQL Server
- Verify koneksi sebelum prisma db push
- Troubleshooting error koneksi
- Test setelah fix error

---

## 🚀 Quick Start Workflow

### 1️⃣ First Time Setup
```powershell
# Step 1: Enable Mixed Authentication
.\enable-sql-auth.ps1

# Step 2: Setup SQL user
sqlcmd -S localhost -E -i setup-sql-login.sql

# Step 3: Test connection
node test-connection.js

# Step 4: Run Prisma
cd ../../..  # back to backend folder
npx prisma db push
```

### 2️⃣ Troubleshooting P1001 (Can't reach database)
```powershell
# Auto-diagnose & fix
.\diagnose-sql.ps1

# Test connection
node test-connection.js
```

### 3️⃣ Troubleshooting P1000 (Authentication failed)
```powershell
# Enable Mixed Auth
.\enable-sql-auth.ps1

# Setup user
sqlcmd -S localhost -E -i setup-sql-login.sql

# Test
node test-connection.js
```

### 4️⃣ Permission Issues (Can't create database)
```sql
-- Run this script
sqlcmd -S localhost -E -i grant-create-db.sql
```

---

## 📋 Checklist Troubleshooting

### Sebelum Pakai Tools:
- [ ] SQL Server sudah terinstall
- [ ] SQL Server service running
- [ ] File `.env` sudah dibuat di `backend/`
- [ ] Node.js sudah terinstall

### Setelah Pakai Tools:
- [ ] Service SQL Server RUNNING
- [ ] Port 1433 LISTENING
- [ ] TCP connection SUCCESS
- [ ] Firewall rule CREATED
- [ ] User `prisma_user` EXISTS
- [ ] Database `db_restoran` EXISTS
- [ ] Connection test PASSED
- [ ] `npx prisma db push` SUCCESS

---

## 🔗 Related Documentation

- **Error Guides:**
  - [ERROR-P1001.md](../ERROR-P1001.md) - Can't reach database server
  - [ERROR-P1000.md](../ERROR-P1000.md) - Authentication failed
  - [Error Index](../README.md) - All errors & solutions

- **Main Docs:**
  - [SETUP.md](../../../../SETUP.md) - Initial setup guide
  - [TROUBLESHOOTING.md](../../../../TROUBLESHOOTING.md) - Comprehensive troubleshooting
  - [QUICK-FIX.md](../../../../QUICK-FIX.md) - Quick fixes

---

## 💡 Tips & Best Practices

### Running Scripts
```powershell
# PowerShell scripts (.ps1) - Run as Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\script-name.ps1

# Batch scripts (.bat) - No admin needed
script-name.bat

# SQL scripts (.sql) - Use sqlcmd or SSMS
sqlcmd -S localhost -E -i script-name.sql

# JavaScript (.js) - Use Node.js
node script-name.js
```

### Path References
Semua script sudah dikonfigurasi untuk mencari `.env` di `backend/` folder relatif ke lokasi script.

**From tools folder:**
```powershell
cd backend/docs/errors/tools

# PowerShell scripts akan auto-detect backend/.env
.\diagnose-sql.ps1

# Node.js needs explicit path or run from backend
cd ../../..  # back to backend
node docs/errors/tools/test-connection.js
```

### Common Issues

**1. "Execution Policy" Error (PowerShell)**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**2. "Access Denied" (Registry/Service)**
```powershell
# Run PowerShell as Administrator
# Right-click PowerShell > Run as Administrator
```

**3. "sqlcmd not found"**
```powershell
# Install SQL Server Command Line Tools
# Or use SSMS (SQL Server Management Studio)
```

**4. ".env not found" (test-connection.js)**
```bash
# Make sure you have .env in backend/ folder
# Or run from backend folder:
cd backend
node docs/errors/tools/test-connection.js
```

---

## 📞 Need Help?

1. **Check Error Documentation:**
   - [Error Index](../README.md)
   - [P1001 Guide](../ERROR-P1001.md)
   - [P1000 Guide](../ERROR-P1000.md)

2. **Run Diagnostic Tool:**
   ```powershell
   .\diagnose-sql.ps1
   ```

3. **Check TROUBLESHOOTING.md:**
   - [Complete Troubleshooting Guide](../../../../TROUBLESHOOTING.md)

4. **Check Project Setup:**
   - [SETUP.md](../../../../SETUP.md)

---

**Last Updated:** November 8, 2025  
**Maintained By:** Development Team
