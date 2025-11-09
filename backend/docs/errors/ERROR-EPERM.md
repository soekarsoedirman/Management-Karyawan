# ERROR EPERM - Operation Not Permitted

## 🔴 Error Message:
```
EPERM: operation not permitted, rename '...\node_modules\.prisma\client\query_engine-windows.dll.node.tmp...' -> '...\node_modules\.prisma\client\query_engine-windows.dll.node'
```

---

## 📝 Apa Artinya?

Error **EPERM (Error PERMission)** ini terjadi saat Prisma mencoba:
1. Generate Prisma Client (`npx prisma generate`)
2. Update query engine file (`query_engine-windows.dll.node`)

**Penyebab:**
- ❌ File `query_engine-windows.dll.node` sedang **dipakai oleh process lain**
- ❌ Biasanya: **Server Node.js masih running** (`npm run dev`)
- ❌ Atau: **VS Code terminal** masih hold file
- ❌ Atau: **Antivirus/Windows Defender** scanning file

---

## ✅ SOLUSI LENGKAP

### 🎯 SOLUSI 1: Stop Server & Clean (RECOMMENDED)

**Step-by-step:**

#### 1. Stop Semua Server Node.js
```powershell
# Check running Node.js processes
Get-Process node

# Kill semua Node.js processes
Get-Process node | Stop-Process -Force
```

**Atau manual:**
- Tekan **`Ctrl+C`** di terminal yang running server
- Close semua terminal VS Code
- Restart VS Code jika perlu

#### 2. Hapus Folder `.prisma`
```powershell
cd backend

# Hapus folder .prisma di node_modules
Remove-Item -Recurse -Force node_modules\.prisma

# Atau hapus seluruh node_modules (lebih bersih)
Remove-Item -Recurse -Force node_modules
npm install
```

#### 3. Generate Ulang
```powershell
npx prisma generate
```

#### 4. Verify
```powershell
# Should succeed now
npx prisma db push
```

---

### 🎯 SOLUSI 2: Quick Fix (Restart VS Code)

Kadang cukup restart VS Code untuk release file lock:

1. **Close all terminals** di VS Code
2. **Close VS Code** completely (File → Exit)
3. **Open VS Code** again
4. **Run prisma generate**:
   ```powershell
   cd backend
   npx prisma generate
   ```

---

### 🎯 SOLUSI 3: Manual Process Kill

Jika server masih jalan di background:

#### Windows:
```powershell
# List semua Node.js processes dengan port
netstat -ano | findstr :3000

# Kill by PID (ganti 1234 dengan PID yang muncul)
taskkill /PID 1234 /F

# Atau kill semua Node.js
taskkill /IM node.exe /F
```

Setelah kill process:
```powershell
npx prisma generate
```

---

### 🎯 SOLUSI 4: Check Antivirus/Windows Defender

**Windows Defender mungkin scan file Prisma:**

#### Option A: Temporarily Disable Windows Defender Real-time Protection
1. Windows Security → Virus & threat protection
2. Manage settings
3. Turn OFF Real-time protection (temporary)
4. Run `npx prisma generate`
5. Turn ON Real-time protection again

#### Option B: Add Exclusion
1. Windows Security → Virus & threat protection
2. Manage settings → Exclusions
3. Add exclusion → Folder
4. Add: `node_modules\.prisma`
5. Run `npx prisma generate`

---

### 🎯 SOLUSI 5: Nuclear Option (Complete Clean)

Jika semua solusi di atas gagal:

```powershell
cd backend

# 1. Stop semua Node.js
Get-Process node | Stop-Process -Force

# 2. Hapus node_modules & lock files
Remove-Item -Recurse -Force node_modules
Remove-Item package-lock.json

# 3. Clear npm cache
npm cache clean --force

# 4. Reinstall
npm install

# 5. Generate Prisma
npx prisma generate

# 6. Push schema
npx prisma db push
```

---

## 🔄 Workflow yang Benar

### ❌ SALAH (Ini yang bikin error):
```powershell
# Server masih running
npm run dev

# Di terminal lain, generate Prisma → ERROR!
npx prisma generate
```

### ✅ BENAR:
```powershell
# 1. Stop server dulu
Ctrl+C  # Stop npm run dev

# 2. Generate Prisma
npx prisma generate

# 3. Push schema
npx prisma db push

# 4. Baru start server
npm run dev
```

---

## 🛡️ PREVENTION (Cara Hindari Error Ini)

### 1. **Always Stop Server Before Prisma Commands**
```powershell
# Stop server
Ctrl+C

# Jalankan Prisma commands
npx prisma generate
npx prisma db push
npx prisma migrate dev

# Start server lagi
npm run dev
```

### 2. **Use Separate Terminals**
- **Terminal 1:** Running server (`npm run dev`)
- **Terminal 2:** Prisma commands (stop server dulu!)

### 3. **Close Terminals Properly**
Jangan force-close terminal saat server running:
- ❌ Close terminal window (X button) → Server tetap jalan di background
- ✅ Stop server dulu (`Ctrl+C`), baru close terminal

### 4. **Restart VS Code Regularly**
Jika sering develop, restart VS Code setiap beberapa jam untuk clear file locks.

---

## 📋 CHECKLIST TROUBLESHOOTING

Coba langkah-langkah ini secara berurutan:

- [ ] **Stop server** (`Ctrl+C` di terminal yang running `npm run dev`)
- [ ] **Close all terminals** di VS Code
- [ ] **Check Node.js processes:** `Get-Process node`
- [ ] **Kill Node.js if exists:** `Get-Process node | Stop-Process -Force`
- [ ] **Delete `.prisma` folder:** `Remove-Item -Recurse -Force node_modules\.prisma`
- [ ] **Run prisma generate:** `npx prisma generate`
- [ ] **Test:** `npx prisma db push`

Jika masih error:

- [ ] **Restart VS Code** (Close completely, reopen)
- [ ] **Try again:** `npx prisma generate`

Jika masih error:

- [ ] **Check Windows Defender** (disable temporarily atau add exclusion)
- [ ] **Nuclear option:** Delete `node_modules`, reinstall, generate

---

## 💡 TIPS

### Quick Command untuk Stop All Node
Buat shortcut PowerShell:

```powershell
# Add to PowerShell profile
function Stop-AllNode {
    Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force
    Write-Host "All Node.js processes stopped!" -ForegroundColor Green
}

# Usage:
Stop-AllNode
npx prisma generate
```

### Visual Studio Code Settings
Tambahkan di `.vscode/settings.json`:

```json
{
  "files.exclude": {
    "**/node_modules/.prisma": true
  }
}
```

Supaya VS Code tidak watch file di `.prisma` folder.

---

## 🔗 Related Errors

### Error: "Schema drift detected"
Setelah fix EPERM, mungkin kamu perlu:

```powershell
# Reset database
npx prisma migrate reset

# Atau force push
npx prisma db push --force-reset
```

Lihat: [Drift Detection Guide](#) (jika ada)

### Error: "Cannot find module .prisma/client"
```powershell
# Generate ulang
npx prisma generate
```

---

## 🆘 Masih Error?

### Scenario: Error tetap muncul setelah semua solusi

**Possible causes:**
1. **File permissions:** Folder `node_modules` read-only
   ```powershell
   # Fix permissions
   icacls node_modules /reset /T
   ```

2. **Drive full:** Check disk space
   ```powershell
   Get-PSDrive C
   ```

3. **Corrupted npm cache:**
   ```powershell
   npm cache clean --force
   npm cache verify
   ```

4. **OneDrive/Google Drive sync:** Jika project di cloud sync folder
   - Move project keluar dari synced folder
   - Or exclude `node_modules` from sync

---

## 📖 Summary untuk Teman Kamu

**Quick Fix untuk EPERM:**

```powershell
# 1. Stop server
Ctrl+C

# 2. Kill all Node.js
Get-Process node | Stop-Process -Force

# 3. Delete .prisma folder
cd backend
Remove-Item -Recurse -Force node_modules\.prisma

# 4. Generate ulang
npx prisma generate

# 5. Push schema
npx prisma db push

# 6. Start server
npm run dev
```

**Jika masih error:** Restart VS Code, try again!

---

**Last Updated:** November 8, 2025  
**Error Type:** File Lock / Permission  
**Severity:** Medium - Easy to fix  
**Common Cause:** Server still running
