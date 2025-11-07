# Panduan Field SHIFT

Untuk sementara `shift` disimpan sebagai string di database.

Nilai yang DIIZINKAN (HARUS divalidasi di backend):
- `pagi`
- `siang`
- `malam`

Rekomendasi implementasi:

- Backend validation (Node/Express example):

```js
const allowed = new Set(["pagi","siang","malam"]);
if (!allowed.has(req.body.shift)) {
  return res.status(400).json({ error: 'shift harus salah satu dari: pagi, siang, malam' });
}
// simpan ke DB
```

- Database constraint (SQL Server):

```sql
ALTER TABLE dbo.<NamaTabel>
ADD CONSTRAINT CK_<NamaTabel>_Shift
CHECK (shift IN ('pagi','siang','malam'));
```

Tips:
- Gunakan tipe kolom `NVARCHAR(10)` atau `VARCHAR(10)`.
- Simpan nilai dalam huruf kecil konsisten (`pagi`, bukan `PAGI`) agar validasi mudah.
- Jika nanti ingin membuat lookup table, buat tabel `ShiftType(id, name)` dan gunakan foreign key.
