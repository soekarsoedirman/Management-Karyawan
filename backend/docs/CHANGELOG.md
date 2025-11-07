# Changelog

All notable changes to this backend will be documented in this file.

## [Unreleased]
- Dokumentasi awal ditambahkan.

## [0.1.0] - 2025-11-07
### Added
- Initial documentation files: `API.md`, `SHIFT.md`, `CONTRIBUTING.md`, `CHANGELOG.md`, `README.md` in `backend/docs`.
- Setup script `setup-sql-login.sql` untuk membuat SQL login `prisma_user`.
- Script `enable-sql-auth.ps1` untuk mengaktifkan Mixed Authentication mode.
- Prisma schema dengan model: Role, User, Jadwal, Absensi, Gaji, LaporanPemasukan.

### Changed
- Field `shift` di model `LaporanPemasukan` menggunakan string (bukan enum) dengan validasi: "pagi", "siang", "malam".
- `.env` menggunakan SQL Authentication (bukan Windows Auth) untuk kompatibilitas Prisma.
- Shadow database disabled (`SHADOW_DATABASE_URL=""`) untuk dev lokal tanpa permission CREATE DATABASE.

