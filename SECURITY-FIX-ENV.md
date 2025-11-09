# 🔐 SECURITY FIX - Remove .env from Git History

## ⚠️ MASALAH

File `.env` yang berisi **credentials sensitif** sudah di-push ke GitHub!

**Risiko:**
- Database credentials exposed (username, password)
- Anyone bisa akses database kamu
- Security vulnerability

**Yang ada di .env:**
```
DATABASE_URL="sqlserver://localhost:1433;database=db_restoran;user=prisma_user;password=Prisma!2025;..."
db_host=localhost
db_user=prisma_user
db_password=Prisma!2025
db_name=db_restoran
JWT_SECRET=your-secret-key-here
```

---

## ✅ SOLUSI LENGKAP

### Step 1: Remove .env from Git (Keep Local File)

```powershell
cd C:\Projek\AndroidFreaky\01-SbdlPakeMysql

# Remove .env from git tracking, tapi file tetap ada di local
git rm --cached backend/.env

# Commit removal
git add .
git commit -m "chore: remove .env from git tracking (security fix)"

# Push to GitHub
git push origin fix
```

**Hasil:** `.env` tidak akan di-track git lagi, tapi file masih ada di komputer kamu.

---

### Step 2: Create .env.example (Template for Team)

Buat file `.env.example` yang **TIDAK berisi credentials** asli:

**File: `backend/.env.example`**
```env
# Database Configuration
DATABASE_URL="sqlserver://localhost:1433;database=db_restoran;user=YOUR_DB_USER;password=YOUR_DB_PASSWORD;encrypt=true;trustServerCertificate=true;connectTimeout=30000;requestTimeout=30000"

# Database Credentials (untuk test-connection.js)
db_host=localhost
db_user=YOUR_DB_USER
db_password=YOUR_DB_PASSWORD
db_name=db_restoran
db_port=1433

# JWT Secret (ganti dengan string random)
JWT_SECRET=your-secret-key-here-change-this-in-production

# Server Configuration
PORT=3000
NODE_ENV=development
```

```powershell
# Commit .env.example
git add backend/.env.example
git commit -m "docs: add .env.example template for setup"
git push origin fix
```

**Benefit:** Team member bisa copy `.env.example` → `.env` dan isi credentials mereka sendiri.

---

### Step 3: Verify .gitignore

Pastikan `.env` ada di `.gitignore`:

**File: `backend/.gitignore`**
```ignore
node_modules
.env
/generated/prisma
```

✅ Sudah ada! Good!

---

### Step 4: Change All Credentials (PENTING!)

Karena credentials sudah exposed di GitHub, **GANTI SEMUA CREDENTIALS**:

#### A. Ganti Password SQL User

```sql
-- Run di SSMS (Windows Authentication)
USE master;
GO

ALTER LOGIN prisma_user WITH PASSWORD = 'NewSecurePassword!2025';
GO
```

#### B. Update .env (Local)

```env
DATABASE_URL="sqlserver://localhost:1433;database=db_restoran;user=prisma_user;password=NewSecurePassword!2025;..."
db_password=NewSecurePassword!2025
```

#### C. Generate New JWT Secret

```powershell
# Generate random JWT secret
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

Copy output ke `.env`:
```env
JWT_SECRET=<hasil-dari-command-di-atas>
```

---

### Step 5: Update README/SETUP.md

Add instruction untuk setup .env:

**In SETUP.md:**
```markdown
### 4. Configure Environment Variables

Copy `.env.example` ke `.env`:
```powershell
cd backend
copy .env.example .env
```

Edit `.env` dan isi dengan credentials kamu:
- `db_user` - SQL Server username
- `db_password` - SQL Server password
- `JWT_SECRET` - Generate dengan: `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"`
```

---

## 🔄 OPTIONAL: Remove from Git History Completely

Jika mau **hapus .env dari seluruh git history** (recommended untuk production):

### Method 1: Using git filter-repo (Recommended)

```powershell
# Install git-filter-repo
pip install git-filter-repo

# Backup dulu!
cd C:\Projek\AndroidFreaky\01-SbdlPakeMysql
git clone . ../Management-Karyawan-backup

# Remove .env from all history
git filter-repo --path backend/.env --invert-paths

# Force push (⚠️ WARNING: Rewrites history!)
git push origin fix --force
```

### Method 2: Using BFG Repo-Cleaner

```powershell
# Download BFG: https://rtyley.github.io/bfg-repo-cleaner/

# Run BFG
java -jar bfg.jar --delete-files .env

# Cleanup
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Force push
git push origin fix --force
```

### Method 3: Manual (Simple, No Tools Needed)

```powershell
# Remove from git tracking
git rm --cached backend/.env

# Add to gitignore (already done)
# Commit
git add .
git commit -m "chore: remove .env from tracking"

# Push
git push origin fix

# Note: File masih ada di old commits, tapi tidak di-track lagi
```

---

## ⚠️ IMPORTANT NOTES

### If Using Method 1 or 2 (Rewrite History):

**WARNING:** Force push akan **rewrite git history**!

**Before force push, tell your team:**
1. Commit & push semua changes mereka
2. Setelah kamu force push, mereka harus:
   ```powershell
   git fetch origin
   git reset --hard origin/fix
   ```

**Jangan force push jika:**
- Ada team member yang belum push changes
- Repository sudah public dengan banyak forks
- Ada CI/CD yang depend on specific commits

### If Using Method 3 (Simple):

- ✅ Safe, tidak rewrite history
- ✅ Team tidak perlu reset
- ❌ `.env` masih ada di old commits (tapi tidak di-track lagi)
- ❌ Orang masih bisa lihat credentials di commit history

**Recommendation:** 
- **Private repo dengan small team:** Method 3 + ganti credentials
- **Public repo atau production:** Method 1/2 (rewrite history)

---

## 📋 CHECKLIST

### Immediate Actions (Do This Now):
- [ ] `git rm --cached backend/.env`
- [ ] Commit dan push
- [ ] Create `backend/.env.example`
- [ ] Commit dan push .env.example
- [ ] **GANTI PASSWORD SQL USER** (paling penting!)
- [ ] Update `.env` local dengan password baru
- [ ] **GANTI JWT_SECRET** 
- [ ] Test aplikasi masih jalan

### Optional (Recommended for Production):
- [ ] Remove .env from git history (Method 1 or 2)
- [ ] Force push (coordinate with team first!)
- [ ] Tell team to `git reset --hard origin/fix`

### Documentation:
- [ ] Update SETUP.md dengan instruksi .env setup
- [ ] Add security note di README.md
- [ ] Document .env.example usage

---

## 📖 Commands Summary

**Quick Fix (Recommended for Now):**
```powershell
cd C:\Projek\AndroidFreaky\01-SbdlPakeMysql

# 1. Remove from tracking
git rm --cached backend/.env

# 2. Create .env.example
# (lihat template di atas)

# 3. Commit
git add .
git commit -m "chore: remove .env from git, add .env.example template"

# 4. Push
git push origin fix

# 5. Change SQL password (run in SSMS)
ALTER LOGIN prisma_user WITH PASSWORD = 'NewPassword!2025';

# 6. Update local .env
# Edit backend/.env dengan password baru
```

---

## 🔗 Related Documentation

- **Git Security:** https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository
- **BFG Repo-Cleaner:** https://rtyley.github.io/bfg-repo-cleaner/
- **git-filter-repo:** https://github.com/newren/git-filter-repo

---

**Created:** November 9, 2025  
**Priority:** 🔴 HIGH - Security Issue  
**Status:** Actionable - Follow steps immediately
