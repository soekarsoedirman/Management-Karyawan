# Backend Documentation

Lokasi: `backend/`

Dokumentasi ini berisi API reference, aturan khusus (mis. field shift), panduan kontribusi, dan changelog untuk server Node + SQL Server.

File penting di folder ini:
- `API.md` — Kontrak endpoint dan contoh request/response.
- `SHIFT.md` — Penjelasan tentang cara menyimpan dan memvalidasi field `shift` (nilai yang diizinkan: `pagi`, `siang`, `malam`).
- `CONTRIBUTING.md` — Proses kontribusi dan kewajiban memperbarui dokumentasi setiap perubahan.
- `CHANGELOG.md` — Riwayat perubahan.

Catatan singkat:
- Field `shift` disimpan sebagai string di database. Backend wajib memvalidasi nilainya sebelum menyimpan.
- SELALU update dokumentasi setiap ada perubahan API agar frontend mudah integrasi.

## Quick Start

1. **Install dependencies:**
   ```bash
   cd backend
   npm install
   ```

2. **Setup SQL Server:**
   - Jalankan `backend/setup-sql-login.sql` di SSMS untuk membuat login `prisma_user`.
   - Aktifkan Mixed Authentication mode (SQL + Windows Auth):
     - SSMS > klik kanan server > Properties > Security > pilih "SQL Server and Windows Authentication mode"
     - Restart SQL Server service di services.msc

3. **Konfigurasi `.env`:**
   ```properties
   DATABASE_URL="sqlserver://localhost:1433;database=db_restoran;user=prisma_user;password=Prisma!2025;encrypt=true;trustServerCertificate=true"
   SHADOW_DATABASE_URL=""
   PORT=3000
   ```

4. **Sinkronkan database schema:**
   ```bash
   npx prisma db push
   ```
   (Gunakan `npx prisma migrate dev --name init` jika user punya permission CREATE DATABASE)

5. **Jalankan server:**
   ```bash
   node index.js
   ```
   Akses: http://localhost:3000/db/ping

