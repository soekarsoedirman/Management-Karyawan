# Management Karyawan

Aplikasi manajemen karyawan dengan backend Node.js (Express + SQL Server) dan mobile app Flutter.

## 🚀 Quick Start

**Untuk setup pertama kali setelah clone, baca:** [`SETUP.md`](SETUP.md)

**⚠️ Mengalami error saat setup?**
- **📁 Lihat folder error documentation:** [`backend/docs/errors/`](backend/docs/errors/) - Semua error dan solusinya
- Error `P1001: Can't reach database server`? → [`backend/docs/errors/ERROR-P1001.md`](backend/docs/errors/ERROR-P1001.md) atau jalankan `backend\diagnose-sql.ps1`
- Error `P1000: Authentication failed`? → [`backend/docs/errors/ERROR-P1000.md`](backend/docs/errors/ERROR-P1000.md)
- Error lainnya atau troubleshooting lengkap? → [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md)
- Test koneksi SQL Server: `node backend/test-connection.js`
- Auto-diagnose masalah: `backend\diagnose-sql.ps1` (run as Administrator)

## 📁 Struktur Project

```
.
├── backend/              # Node.js + Express API
│   ├── docs/            # Dokumentasi API
│   ├── prisma/          # Prisma schema & migrations
│   ├── config/          # Konfigurasi (Prisma client, dll)
│   ├── controller/      # Business logic
│   ├── routes/          # API routes
│   └── index.js         # Entry point
├── frontend/            # Flutter mobile app
│   └── lib/            # Flutter source code
├── Sbdl/               # SQL database project
└── script.sql          # Initial database setup
```

## 🛠️ Tech Stack

**Backend:**
- Node.js + Express
- Prisma ORM
- SQL Server (MSSQL)
- Windows Authentication / SQL Auth

**Frontend:**
- Flutter (Dart)
- HTTP client
- Material Design 3

## 📚 Dokumentasi

- **Setup Guide:** [`SETUP.md`](SETUP.md) — Panduan instalasi lengkap
- **API Reference:** [`backend/docs/API.md`](backend/docs/API.md)
- **Field Rules:** [`backend/docs/SHIFT.md`](backend/docs/SHIFT.md)
- **Contributing:** [`backend/docs/CONTRIBUTING.md`](backend/docs/CONTRIBUTING.md)
- **Changelog:** [`backend/docs/CHANGELOG.md`](backend/docs/CHANGELOG.md)

## ⚡ NPM Scripts

```bash
# Backend
cd backend
npm start           # Jalankan server production
npm run dev         # Jalankan dengan nodemon (auto-reload)
npm run studio      # Buka Prisma Studio (database GUI)
npm run db:push     # Sync schema ke DB (dev)
npm run db:migrate  # Buat migration (production)
npm run db:generate # Generate Prisma Client

# Test koneksi DB (troubleshooting)
node test-db.js

# Frontend
cd frontend
flutter run         # Jalankan app
flutter build apk   # Build APK
```

## 🔑 Environment Variables

File: `backend/.env`

```properties
db_auth=sql
db_host=localhost
db_name=db_restoran
db_user=prisma_user
db_password=Prisma!2025
db_trust_server_certificate=true
PORT=3000

DATABASE_URL="sqlserver://localhost:1433;database=db_restoran;user=prisma_user;password=Prisma!2025;encrypt=true;trustServerCertificate=true"
SHADOW_DATABASE_URL=""
JWT_SECRET="kata_mamah_aku_sigma08953214371987"
```

**Catatan:**
- Gunakan SQL Authentication (bukan Windows Auth)
- Port 1433 (jangan tambahkan `instanceName` ke config)
- `SHADOW_DATABASE_URL=""` untuk disable shadow DB (dev lokal)

## 🗄️ Database Schema

**Models:**
- **Role** — Admin, Cashier, Employee
- **User** — Karyawan dengan role
- **Jadwal** — Shift kerja
- **Absensi** — Clock in/out
- **Gaji** — Gaji pokok + bonus/potongan
- **LaporanPemasukan** — Laporan per shift

Lihat detail: [`backend/prisma/schema.prisma`](backend/prisma/schema.prisma)

## ⚠️ Catatan Penting

1. **Field `shift` hanya valid:** `"pagi"`, `"siang"`, `"malam"` (lihat [`backend/docs/SHIFT.md`](backend/docs/SHIFT.md))
2. **Password harus di-hash** (gunakan bcrypt)
3. **Update dokumentasi** setiap perubahan API (wajib!)
4. **SQL Server config:**
   - Pakai SQL Authentication (user/password)
   - Port 1433 (JANGAN tambahkan `instanceName` ke sqlConfig)
   - Pastikan Mixed Auth mode aktif
5. **Prisma Client:** Jalankan `npx prisma generate` setelah clone atau update schema

## 🤝 Contributing

Baca: [`backend/docs/CONTRIBUTING.md`](backend/docs/CONTRIBUTING.md)

**Checklist setiap PR:**
- [ ] Update `backend/docs/API.md` jika ada perubahan endpoint
- [ ] Update `backend/docs/CHANGELOG.md`
- [ ] Test endpoint dengan Postman/Thunder Client
- [ ] Jalankan `npm run studio` untuk verifikasi data

## 📄 License

[Isi license jika ada]

## 👥 Team

- **Owner:** Bar-innutshell
- **Contributors:** [List contributors]

---

**Need help?** Read [`SETUP.md`](SETUP.md) or check [`backend/docs/`](backend/docs/)
