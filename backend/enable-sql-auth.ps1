# Enable SQL Server Authentication (Mixed Mode)
# Run as Administrator

$instanceName = "SQLEXPRESS"
$registryPath = "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQLServer"

Write-Host "Mengubah SQL Server ke Mixed Authentication Mode..." -ForegroundColor Yellow

# Set LoginMode to 2 (Mixed Mode: SQL + Windows)
Set-ItemProperty -Path $registryPath -Name "LoginMode" -Value 2

Write-Host "Registry updated. Restarting SQL Server service..." -ForegroundColor Yellow

# Restart SQL Server service
Restart-Service -Name "MSSQL`$$instanceName" -Force

Write-Host "SQL Server Authentication berhasil diaktifkan!" -ForegroundColor Green
Write-Host "Sekarang Prisma bisa connect dengan user/password." -ForegroundColor Green
