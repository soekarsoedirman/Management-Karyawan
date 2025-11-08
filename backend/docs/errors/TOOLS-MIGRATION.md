# 📦 Tools Migration - Backend Cleanup

## ✅ Perubahan Terbaru (November 8, 2025)

Semua diagnostic dan setup tools sudah dipindahkan ke folder khusus untuk membuat backend root lebih rapi dan terorganisir.

---

## 🎯 Tujuan Migration

**Masalah Sebelumnya:**
- 6 file tools di backend root (diagnose-sql.ps1, test-connection.js, setup-sql-login.sql, dll)
- Backend root tercampur antara source code dan diagnostic tools
- Sulit menemukan tools yang dibutuhkan
- Tidak ada dokumentasi lengkap untuk tools

**Solusi:**
- ✅ Semua tools dipindahkan ke `backend/docs/errors/tools/`
- ✅ Backend root cuma berisi source code & config
- ✅ Tools punya folder dan dokumentasi sendiri
- ✅ Path yang jelas dan konsisten

---

## 📂 Struktur Folder Tools

```
backend/docs/errors/tools/
├── README.md                  ← 📖 Dokumentasi lengkap semua tools
├── diagnose-sql.ps1          ← 🔍 Auto-diagnostic (PowerShell)
├── diagnose-sql.bat          ← 🔍 Auto-diagnostic (Batch)
├── test-connection.js        ← 🧪 Test koneksi database
├── setup-sql-login.sql       ← ⚙️ Setup user SQL Server
├── enable-sql-auth.ps1       ← ⚙️ Enable Mixed Auth
└── grant-create-db.sql       ← ⚙️ Grant CREATE DB permission
```

---

## 🔄 Migration Details

### File yang Dipindahkan:

| Old Path | New Path | Status |
|----------|----------|--------|
| `backend/diagnose-sql.ps1` | `backend/docs/errors/tools/diagnose-sql.ps1` | ✅ Moved |
| `backend/diagnose-sql.bat` | `backend/docs/errors/tools/diagnose-sql.bat` | ✅ Moved |
| `backend/test-connection.js` | `backend/docs/errors/tools/test-connection.js` | ✅ Moved |
| `backend/setup-sql-login.sql` | `backend/docs/errors/tools/setup-sql-login.sql` | ✅ Moved |
| `backend/enable-sql-auth.ps1` | `backend/docs/errors/tools/enable-sql-auth.ps1` | ✅ Moved |
| `backend/grant-create-db.sql` | `backend/docs/errors/tools/grant-create-db.sql` | ✅ Moved |

### Dokumentasi yang Diupdate:

| File | Update | Status |
|------|--------|--------|
| `backend/docs/errors/tools/README.md` | Created - Dokumentasi lengkap tools | ✅ New |
| `backend/docs/errors/README.md` | Updated paths ke tools folder | ✅ Updated |
| `backend/docs/errors/ERROR-P1001.md` | Updated command paths | ✅ Updated |
| `backend/docs/errors/ERROR-P1000.md` | Updated command paths | ✅ Updated |
| `backend/docs/errors/REORGANIZATION.md` | Added tools migration info | ✅ Updated |

---

## 📝 Cara Pakai Setelah Migration

### Before (Old Path):
```powershell
# ❌ Old way
cd backend
.\diagnose-sql.ps1
node test-connection.js
```

### After (New Path):
```powershell
# ✅ New way
cd backend/docs/errors/tools
.\diagnose-sql.ps1
node test-connection.js
```

### Recommended Workflow:
```powershell
# Navigate to tools folder once
cd backend/docs/errors/tools

# Run all tools from here
.\diagnose-sql.ps1          # Diagnostic
node test-connection.js     # Test connection
.\enable-sql-auth.ps1       # Enable Mixed Auth

# Setup user
sqlcmd -S localhost -E -i setup-sql-login.sql
```

---

## 🎉 Keuntungan Migration

### 1. **Backend Root Lebih Bersih** 
```
backend/
├── config/           ← Source code
├── controller/       ← Source code
├── middleware/       ← Source code
├── routes/           ← Source code
├── prisma/           ← Schema & migrations
├── index.js          ← Main entry point
└── package.json      ← Dependencies

# No more scattered tool files! 🎉
```

### 2. **Tools Lebih Terorganisir**
- Semua tools di satu folder: `backend/docs/errors/tools/`
- Dokumentasi lengkap: `tools/README.md`
- Mudah maintenance dan update

### 3. **Path yang Konsisten**
- Error docs: `backend/docs/errors/`
- Tools: `backend/docs/errors/tools/`
- Clear separation of concerns

### 4. **Developer Experience Lebih Baik**
- Tools documentation dengan examples
- Quick start workflow
- Troubleshooting guides
- No confusion tentang file mana yang mana

---

## ✅ Checklist untuk Developer

### Jika Anda Pull Latest Changes:

- [ ] Pull latest code: `git pull origin fix`
- [ ] Update bookmark/shortcuts yang point ke old paths
- [ ] Test tools dengan path baru:
  ```powershell
  cd backend/docs/errors/tools
  .\diagnose-sql.ps1
  ```
- [ ] Baca dokumentasi tools: `backend/docs/errors/tools/README.md`
- [ ] Update scripts pribadi yang reference old paths

### Jika Ada Error:

1. **File not found:**
   ```
   ❌ Error: diagnose-sql.ps1 not found in backend/
   ✅ Solution: cd backend/docs/errors/tools
   ```

2. **Path references broken:**
   ```
   ❌ Old: backend/diagnose-sql.ps1
   ✅ New: backend/docs/errors/tools/diagnose-sql.ps1
   ```

3. **`.env` not found (diagnose-sql.ps1):**
   ```
   ✅ Script sudah auto-detect .env di backend/
   ✅ Atau run dari backend folder:
      cd backend
      docs/errors/tools/diagnose-sql.ps1
   ```

---

## 🔗 Quick Links

### Dokumentasi Tools
- **[Tools README](tools/README.md)** - Dokumentasi lengkap semua tools
- **[Error Index](README.md)** - Index semua error documentation
- **[Reorganization Summary](REORGANIZATION.md)** - Summary perubahan struktur

### Error Guides
- **[ERROR-P1001](ERROR-P1001.md)** - Can't reach database server
- **[ERROR-P1000](ERROR-P1000.md)** - Authentication failed

### Main Documentation
- **[SETUP.md](../../../SETUP.md)** - Initial setup guide
- **[TROUBLESHOOTING.md](../../../TROUBLESHOOTING.md)** - Troubleshooting guide
- **[QUICK-FIX.md](../../../QUICK-FIX.md)** - Quick fixes

---

## 🗑️ Cleanup Old Files

**DO NOT DELETE YET!**

Old files di backend root masih ada untuk backward compatibility:
- `backend/diagnose-sql.ps1`
- `backend/diagnose-sql.bat`
- `backend/test-connection.js`
- `backend/setup-sql-login.sql`
- `backend/enable-sql-auth.ps1`
- `backend/grant-create-db.sql`

**Timeline untuk Deletion:**
1. **Week 1-2:** Transition period - kedua path available
2. **Week 3:** Notify tim untuk update
3. **Week 4+:** Safe to delete old files

**Sebelum hapus, pastikan:**
- ✅ Semua tim sudah pull latest
- ✅ Semua scripts updated ke path baru
- ✅ No dependencies ke old paths
- ✅ CI/CD updated (jika ada)

---

## 💡 Tips

### Running Tools

**PowerShell Scripts (.ps1):**
```powershell
# Ensure execution policy allows
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Run from tools folder
cd backend/docs/errors/tools
.\diagnose-sql.ps1
```

**Node.js Scripts (.js):**
```powershell
# From tools folder
cd backend/docs/errors/tools
node test-connection.js

# Or from backend folder (script auto-detects .env)
cd backend
node docs/errors/tools/test-connection.js
```

**SQL Scripts (.sql):**
```powershell
# From tools folder
cd backend/docs/errors/tools
sqlcmd -S localhost -E -i setup-sql-login.sql
```

### Bookmarking

Untuk kemudahan, bookmark folder tools:
```powershell
# PowerShell alias
Set-Alias -Name tools -Value 'Set-Location backend\docs\errors\tools'

# Usage
tools  # cd to tools folder instantly
```

---

## 🆘 Need Help?

1. Check tools documentation: `backend/docs/errors/tools/README.md`
2. Check error guide: `backend/docs/errors/README.md`
3. Run diagnostic: `.\diagnose-sql.ps1` from tools folder
4. See TROUBLESHOOTING.md untuk detailed guides

---

**Migration Date:** November 8, 2025  
**Updated By:** Development Team  
**Purpose:** Backend cleanup & better organization
