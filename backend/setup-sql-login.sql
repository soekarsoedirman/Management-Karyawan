-- Setup SQL Login untuk Prisma
-- Jalankan di SSMS dengan Windows Authentication

USE master;
GO

-- 1. Buat login SQL Server (ganti password sesuai kebutuhan)
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'prisma_user')
BEGIN
    CREATE LOGIN prisma_user WITH PASSWORD = 'Prisma!2025';
END
GO

-- 2. Buat user di database db_restoran
USE db_restoran;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'prisma_user')
BEGIN
    CREATE USER prisma_user FOR LOGIN prisma_user;
END
GO

-- 3. Beri akses penuh untuk migrasi (db_owner agar bisa CREATE TABLE, ALTER, dll)
ALTER ROLE db_owner ADD MEMBER prisma_user;
GO

PRINT 'Login prisma_user berhasil dibuat dengan password: Prisma!2025';
PRINT 'User sudah ditambahkan ke database db_restoran dengan role db_owner';
