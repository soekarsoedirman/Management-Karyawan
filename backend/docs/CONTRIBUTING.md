# Contributing & Documentation Policy

Penting: setiap perubahan pada backend yang menambah, mengubah, atau menghapus endpoint harus disertai pembaruan dokumentasi.

Checklist minimal setiap PR/commit yang mengubah API:
- [ ] Update `docs/API.md` (endpoint baru atau perubahan kontrak request/response).
- [ ] Jika menyentuh field `shift`, update `docs/SHIFT.md` jika diperlukan.
- [ ] Tambahkan catatan singkat di `docs/CHANGELOG.md`.
- [ ] Sertakan contoh request/response (curl atau Postman collection) bila memungkinkan.

Proses:
1. Lakukan perubahan di branch terpisah.
2. Update docs di folder `backend/docs`.
3. Buat PR dengan deskripsi perubahan dan link ke dokumen yang diperbarui.

Tujuan: menjaga agar frontend dan integrator selalu punya kontrak API yang jelas.
