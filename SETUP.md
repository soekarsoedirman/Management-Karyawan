# Setup Guide — First Time Installation

Panduan lengkap untuk menjalankan project ini dari awal (setelah clone dari GitHub).

---

## 📋 Prerequisites

Pastikan sudah terinstall:
- **Node.js** (v18 atau lebih baru) — [Download](https://nodejs.org/)
- **SQL Server Express** (atau edisi lain) — [Download](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
- **SQL Server Management Studio (SSMS)** — [Download](https://aka.ms/ssmsfullsetup)
- **Git** — [Download](https://git-scm.com/)
- **Flutter SDK** (untuk mobile app) — [Download](https://flutter.dev/docs/get-started/install)

---

## 🚀 Langkah-langkah Setup

### 1. Clone Repository

```powershell
git clone https://github.com/Bar-innutshell/Management-Karyawan.git
cd Management-Karyawan
```

---

### 2. Setup SQL Server

#### A. Aktifkan SQL Server Authentication (Mixed Mode)

**Via SSMS (cara termudah):**
1. Buka SSMS
2. Connect ke server: `.\SQLEXPRESS` (Windows Authentication)
3. Klik kanan server di Object Explorer → **Properties**
4. Pilih **Security** → ubah ke **"SQL Server and Windows Authentication mode"**
5. Klik **OK**
6. Restart SQL Server service:
   - Buka `services.msc`
   - Cari **SQL Server (SQLEXPRESS)**
   - Klik kanan → **Restart**

**Via PowerShell (sebagai Administrator):**
```powershell
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQLServer" -Name "LoginMode" -Value 2
Restart-Service -Name "MSSQL`$SQLEXPRESS" -Force
```

#### B. Buat Database dan Login SQL

Jalankan script setup:
```powershell
# Buat database db_restoran
sqlcmd -S .\SQLEXPRESS -E -i "script.sql"

# Buat login prisma_user
sqlcmd -S .\SQLEXPRESS -E -i "backend\setup-sql-login.sql"

# Beri permission CREATE DATABASE (untuk Prisma migrate)
sqlcmd -S .\SQLEXPRESS -E -i "backend\grant-create-db.sql"
```

Atau jalankan manual di SSMS:
1. File → Open → File...
2. Pilih `script.sql` → Execute (F5)
3. Pilih `backend\setup-sql-login.sql` → Execute (F5)
4. Pilih `backend\grant-create-db.sql` → Execute (F5)

#### C. Verifikasi Koneksi

Test login SQL:
```powershell
sqlcmd -S localhost,1433 -U prisma_user -P "Prisma!2025" -Q "SELECT DB_NAME()"
```

Jika berhasil, akan muncul nama database.

---

### 3. Setup Backend (Node.js + Express)

```powershell
cd backend
npm install
```

#### Konfigurasi Environment

File `.env` sudah ada, pastikan isinya:
```properties
db_auth=sql
db_host=localhost
db_instance=SQLEXPRESS
db_name=db_restoran
db_user=prisma_user
db_password=Prisma!2025
db_trust_server_certificate=true
PORT=3000

DATABASE_URL="sqlserver://localhost:1433;database=db_restoran;user=prisma_user;password=Prisma!2025;encrypt=true;trustServerCertificate=true"
SHADOW_DATABASE_URL=""
```

#### Sinkronkan Database Schema

**Opsi A — Pakai `db push` (untuk dev lokal, lebih cepat):**
```powershell
npx prisma db push
```

**Opsi B — Pakai `migrate` (untuk production/team, buat migration history):**
```powershell
npx prisma migrate dev --name init
```

#### Generate Prisma Client

```powershell
npx prisma generate
```

#### Test Koneksi Database

```powershell
node index.js
```

Buka browser: http://localhost:3000/db/ping

Response sukses:
```json
{
  "ok": true,
  "db": "db_restoran",
  "server": "NAMA-PC\\SQLEXPRESS",
  "instance": "SQLEXPRESS"
}
```

---

### 4. Setup Frontend (Flutter)

```powershell
cd ..\frontend
flutter pub get
```

#### Konfigurasi API Endpoint

Edit `lib/services/api.dart` (atau file serupa):
```dart
// Untuk emulator Android
static const String baseUrl = 'http://10.0.2.2:3000';

// Untuk device fisik (ganti dengan IP PC kamu)
// static const String baseUrl = 'http://192.168.1.10:3000';
```

#### Jalankan Flutter App

**Android Emulator:**
```powershell
flutter run
```

**Device Fisik (pastikan di jaringan yang sama):**
1. Cek IP PC kamu:
   ```powershell
   ipconfig
   # Cari IPv4 Address (contoh: 192.168.1.10)
   ```
2. Update `baseUrl` di Flutter
3. Pastikan firewall allow port 3000:
   ```powershell
   netsh advfirewall firewall add rule name="Node API" dir=in action=allow protocol=TCP localport=3000
   ```
4. Jalankan:
   ```powershell
   flutter run
   ```

---

## 🔧 Troubleshooting

### Error: "Can't reach database server"
- Pastikan SQL Server service running: `services.msc` → SQL Server (SQLEXPRESS)
- Pastikan TCP/IP enabled di SQL Server Configuration Manager
- Test koneksi: `sqlcmd -S localhost,1433 -U prisma_user -P "Prisma!2025"`

### Error: "Authentication failed"
- Jalankan ulang `backend\setup-sql-login.sql`
- Pastikan Mixed Authentication mode aktif

### Error: "Shadow database permission denied"
- Jalankan `backend\grant-create-db.sql`
- Atau pakai `npx prisma db push` (tidak butuh shadow DB)

### Error: "Connection refused" dari Flutter
- Pastikan backend running (`node index.js`)
- Untuk emulator, pakai `http://10.0.2.2:3000`
- Untuk device fisik, pakai IP PC (contoh: `http://192.168.1.10:3000`)
- Cek firewall allow port 3000

---

## 📚 Dokumentasi Tambahan

- **API Reference:** `backend/docs/API.md`
- **Field Shift Rules:** `backend/docs/SHIFT.md`
- **Contributing Guide:** `backend/docs/CONTRIBUTING.md`
- **Changelog:** `backend/docs/CHANGELOG.md`

---

## 🛠️ Development Workflow

### Jalankan Backend (mode development)
```powershell
cd backend
npm run dev  # jika ada nodemon
# atau
node index.js
```

### Lihat Database via Prisma Studio
```powershell
cd backend
npx prisma studio
```
Buka: http://localhost:5555

### Jalankan Flutter (hot reload)
```powershell
cd frontend
flutter run
```

---

## 📝 Catatan Penting

1. **Field `shift` hanya boleh:** `"pagi"`, `"siang"`, `"malam"` (lihat `backend/docs/SHIFT.md`)
2. **Password di DB harus di-hash** (gunakan bcrypt, jangan simpan plain text)
3. **Setiap perubahan API wajib update dokumentasi** di `backend/docs/API.md`
4. **Untuk production:** 
   - Ganti password `prisma_user`
   - Aktifkan SSL/TLS (`encrypt=true`)
   - Pakai `prisma migrate deploy` (bukan `db push`)

---

## 🆘 Butuh Bantuan?

- Baca dokumentasi: `backend/docs/README.md`
- Check issues di GitHub
- Contact: [maintainer email/contact]

---

**Good luck! 🚀**
