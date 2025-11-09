# ERROR P1001 - Can't Reach Database Server

## 🔴 Error Message:
```
Error: P1001: Can't reach database server at localhost:1433

Please make sure your database server is running at localhost:1433.
```

---

## 📝 Apa Artinya?

Error ini artinya **Prisma tidak bisa connect ke SQL Server** di `localhost:1433`.

Ini bisa terjadi karena:
1. ❌ SQL Server service **tidak running**
2. ❌ SQL Server **tidak listen di port 1433**
3. ❌ TCP/IP protocol **tidak enabled**
4. ❌ Firewall **memblokir port 1433**
5. ❌ Connection string di `.env` **salah**

---

## ✅ SOLUSI LENGKAP

### Step 1: Jalankan Diagnostic Tool

```powershell
# Run as Administrator:
cd backend/docs/errors/tools
.\diagnose-sql.ps1
```

Tool ini akan **otomatis diagnose dan fix** beberapa masalah umum.

---

### Step 2: Manual Check - SQL Server Service

```powershell
# Cek status:
Get-Service -Name "MSSQL*"

# Jika STOPPED, start service:
Start-Service -Name "MSSQL$SQLEXPRESS"

# Atau untuk default instance:
Start-Service -Name "MSSQLSERVER"
```

**Manual via GUI:**
1. Tekan `Win + R` → ketik `services.msc`
2. Cari **SQL Server (SQLEXPRESS)**
3. Jika status = **Stopped**, klik kanan → **Start**
4. Set **Startup type** = **Automatic** agar auto-start saat PC nyala

---

### Step 3: Enable TCP/IP Protocol

**PENTING:** Ini adalah penyebab paling umum error P1001!

1. Buka **SQL Server Configuration Manager** 
   - Cari di Start Menu: "SQL Server Configuration Manager"
   - Atau jalankan: `SQLServerManager16.msc` (angka bisa beda tergantung versi)

2. Expand: **SQL Server Network Configuration**

3. Klik: **Protocols for SQLEXPRESS** (atau instance name Anda)

4. Klik kanan **TCP/IP** → **Properties**

5. Tab **Protocol**:
   - Set **Enabled** = **Yes**

6. Tab **IP Addresses**:
   - Scroll ke paling bawah ke section **IPALL**
   - **TCP Dynamic Ports**: *hapus semua, kosongkan*
   - **TCP Port**: ketik `1433`

7. Klik **OK**

8. **RESTART SQL Server Service:**
   ```powershell
   Restart-Service -Name "MSSQL$SQLEXPRESS" -Force
   ```

---

### Step 4: Verifikasi Port 1433 Listening

```powershell
# Cek apakah port 1433 listening:
netstat -an | findstr "1433"
```

**Expected output (harus ada):**
```
TCP    0.0.0.0:1433           0.0.0.0:0              LISTENING
TCP    [::]:1433              [::]:0                 LISTENING
```

**Jika tidak ada output:**
- TCP/IP belum di-enable (ulangi Step 3)
- Port 1433 belum di-set (cek IPALL di Step 3)
- SQL Server belum di-restart setelah config

---

### Step 5: Test TCP Connection

```powershell
# Test koneksi TCP ke port 1433:
Test-NetConnection -ComputerName localhost -Port 1433
```

**Expected output:**
```
TcpTestSucceeded : True
```

**Jika False:**
- SQL Server tidak listen di port 1433
- Firewall memblokir koneksi
- Service belum running

---

### Step 6: Allow Port 1433 di Firewall

```powershell
# Run as Administrator:
New-NetFirewallRule -DisplayName "SQL Server (TCP 1433)" `
                    -Direction Inbound `
                    -Protocol TCP `
                    -LocalPort 1433 `
                    -Action Allow
```

**Atau manual:**
1. Control Panel → Windows Defender Firewall → Advanced Settings
2. Inbound Rules → New Rule
3. Port → TCP → Specific local ports: `1433`
4. Allow the connection
5. Name: "SQL Server"

---

### Step 7: Verifikasi Connection String di .env

Buka `backend/.env`, pastikan format **PERSIS seperti ini**:

```env
DATABASE_URL="sqlserver://localhost:1433;database=db_restoran;user=prisma_user;password=Prisma!2025;encrypt=true;trustServerCertificate=true"
```

**PENTING:**
- ✅ Pakai `localhost:1433` (dengan **titik dua**)
- ❌ JANGAN pakai `localhost\SQLEXPRESS`
- ❌ JANGAN pakai `localhost,1433` di Prisma (koma hanya untuk sqlcmd)
- ✅ Password pakai tanda kutip jika ada special characters

---

### Step 8: Test Connection dengan Node.js

```powershell
cd backend/docs/errors/tools
node test-connection.js
```

**Expected output jika berhasil:**
```
✅ Step 1: Connection SUCCESSFUL!
✅ Step 2: Query execution SUCCESSFUL!
✅ Step 3: Database 'db_restoran' EXISTS!
✅ Step 4: Permission check SUCCESSFUL!
✅ Step 5: Table operations SUCCESSFUL!

🎉 ALL TESTS PASSED! SQL Server is ready for Prisma!
```

**Jika masih error**, baca output error dari script. Script akan kasih tahu masalah spesifiknya.

---

### Step 9: Jalankan Prisma DB Push

Setelah test-connection.js berhasil:

```powershell
npx prisma db push
```

Jika berhasil, lanjutkan:
```powershell
npx prisma generate
npm run db:seed
npm run dev
```

---

## 🆘 TROUBLESHOOTING LANJUTAN

### Jika masih error setelah semua step di atas:

1. **Restart komputer** (serius, ini sering solve masalah Windows)

2. **Cek Windows Event Viewer** untuk error SQL Server:
   ```powershell
   eventvwr.msc
   ```
   Lihat di: Windows Logs → Application → Filter for SQL Server

3. **Reinstall SQL Server** (last resort):
   - Uninstall SQL Server Express
   - Download versi terbaru
   - Install ulang
   - Jalankan setup script dari `SETUP.md`

4. **Gunakan Docker SQL Server** (alternatif):
   ```powershell
   docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=Prisma!2025Strong" `
              -p 1433:1433 --name sqlserver `
              -d mcr.microsoft.com/mssql/server:2022-latest
   ```
   
   Lalu ubah `.env`:
   ```env
   DATABASE_URL="sqlserver://localhost:1433;database=db_restoran;user=sa;password=Prisma!2025Strong;encrypt=true;trustServerCertificate=true"
   ```

---

## 📋 CHECKLIST - Cek Satu per Satu

Sebelum tanya bantuan, pastikan semua ini sudah dilakukan:

- [ ] SQL Server service **RUNNING** (cek di `services.msc`)
- [ ] TCP/IP protocol **ENABLED** (cek di SQL Server Configuration Manager)
- [ ] Port 1433 **LISTENING** (cek: `netstat -an | findstr "1433"`)
- [ ] TCP connection **SUCCESSFUL** (cek: `Test-NetConnection localhost -Port 1433`)
- [ ] Firewall **ALLOW** port 1433
- [ ] `.env` file format **CORRECT** (pakai `localhost:1433`, bukan `\SQLEXPRESS`)
- [ ] Database `db_restoran` **EXISTS**
- [ ] User `prisma_user` **EXISTS** dengan password yang benar
- [ ] `node test-connection.js` **BERHASIL**
- [ ] SQL Server **RESTARTED** setelah enable TCP/IP

Jika semua ✅ tapi masih error → lihat `../TROUBLESHOOTING.md` atau tanya tim.

---

## 💡 TIPS

- **Jalankan diagnostic script dulu** sebelum coba fix manual (`tools/diagnose-sql.ps1`)
- **Restart SQL Server** setelah setiap perubahan config
- **Restart terminal/VS Code** setelah ubah `.env`
- **Pakai port 1433 static**, jangan pakai instance name
- **Test dengan sqlcmd** untuk isolate masalah:
  ```powershell
  sqlcmd -S localhost,1433 -U prisma_user -P "Prisma!2025" -Q "SELECT @@VERSION"
  ```
- Jika sqlcmd berhasil tapi Prisma gagal → masalah di connection string `.env`
- Jika sqlcmd juga gagal → masalah di SQL Server configuration

---

**Referensi:**
- Prisma Error Codes: https://www.prisma.io/docs/reference/api-reference/error-reference
- SQL Server Configuration: https://learn.microsoft.com/en-us/sql/database-engine/configure-windows/
- [TROUBLESHOOTING.md](../TROUBLESHOOTING.md)
- [QUICK-FIX.md](../../../QUICK-FIX.md)
