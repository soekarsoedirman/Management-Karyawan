## API Reference (awal)

Base URL: `http://localhost:3000`

Catatan: Tambahkan endpoint baru di dokumen ini setiap menambah route di `backend/index.js` atau file route lain.

### GET /db/ping
- Purpose: Health check koneksi database.
- Method: `GET`
- Auth: none (lokal)

Response 200 (contoh):
```
{
  "ok": true,
  "db": "db_restoran",
  "server": "<SERVERNAME>",
  "instance": "SQLEXPRESS"
}
```

Response 500 (contoh):
```
{
  "ok": false,
  "error": "<pesan error>"
}
```

---

Cara menambahkan endpoint baru:
1. Tambahkan deskripsi endpoint, method, URL path.
2. Tuliskan contoh request (headers, body) dan contoh response sukses + error.
3. Update contoh cURL / Postman / REST client.
