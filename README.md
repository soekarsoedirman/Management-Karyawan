# Management Karyawan

Aplikasi manajemen karyawan dengan backend Node.js (Express + SQL Server) dan mobile app Flutter.

## 🚀 Quick Start

**Untuk setup pertama kali setelah clone, baca:** [`SETUP.md`](SETUP.md)

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

# Frontend
cd frontend
flutter run         # Jalankan app
flutter build apk   # Build APK
```

## 🔑 Environment Variables

File: `backend/.env`

```properties
DATABASE_URL="sqlserver://localhost:1433;database=db_restoran;user=prisma_user;password=Prisma!2025;encrypt=true;trustServerCertificate=true"
SHADOW_DATABASE_URL=""
PORT=3000
```

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
