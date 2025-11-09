-- Grant CREATE DATABASE permission untuk Prisma Migrate
-- Jalankan di SSMS dengan Windows Authentication atau login sa

USE master;
GO

-- Beri role dbcreator agar user bisa create database (untuk shadow DB)
ALTER SERVER ROLE dbcreator ADD MEMBER prisma_user;
GO

PRINT 'prisma_user sekarang bisa CREATE DATABASE untuk shadow DB';
PRINT 'Jalankan: npx prisma migrate dev --name init';
