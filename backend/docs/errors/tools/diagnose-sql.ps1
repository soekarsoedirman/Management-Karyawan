# SQL Server Diagnostic & Auto-Fix Script
# Run this as Administrator

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "SQL SERVER DIAGNOSTIC & AUTO-FIX TOOL" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

$hasError = $false

# Check 1: SQL Server Service Status
Write-Host "[1/8] Checking SQL Server Services..." -ForegroundColor Yellow
$sqlServices = Get-Service -Name "MSSQL*" -ErrorAction SilentlyContinue

if ($sqlServices) {
    foreach ($service in $sqlServices) {
        $status = $service.Status
        $color = if ($status -eq "Running") { "Green" } else { "Red" }
        Write-Host "  - $($service.DisplayName): " -NoNewline
        Write-Host $status -ForegroundColor $color
        
        if ($status -ne "Running") {
            $hasError = $true
            Write-Host "    [FIX] Attempting to start service..." -ForegroundColor Yellow
            try {
                Start-Service $service.Name -ErrorAction Stop
                Write-Host "    ✅ Service started successfully!" -ForegroundColor Green
            } catch {
                Write-Host "    ❌ Failed to start: $_" -ForegroundColor Red
            }
        }
    }
} else {
    Write-Host "  ❌ No SQL Server services found! SQL Server might not be installed." -ForegroundColor Red
    $hasError = $true
}
Write-Host ""

# Check 2: Port 1433 Listening
Write-Host "[2/8] Checking if port 1433 is listening..." -ForegroundColor Yellow
$port1433 = netstat -an | Select-String "1433.*LISTENING"

if ($port1433) {
    Write-Host "  ✅ Port 1433 is LISTENING" -ForegroundColor Green
    $port1433 | ForEach-Object { Write-Host "    $_" -ForegroundColor Gray }
} else {
    Write-Host "  ❌ Port 1433 is NOT listening!" -ForegroundColor Red
    Write-Host "    This means SQL Server is not configured to listen on port 1433" -ForegroundColor Yellow
    Write-Host "    You need to enable TCP/IP and set static port 1433" -ForegroundColor Yellow
    $hasError = $true
}
Write-Host ""

# Check 3: Test TCP Connection
Write-Host "[3/8] Testing TCP connection to localhost:1433..." -ForegroundColor Yellow
try {
    $tcpTest = Test-NetConnection -ComputerName localhost -Port 1433 -WarningAction SilentlyContinue
    if ($tcpTest.TcpTestSucceeded) {
        Write-Host "  ✅ TCP connection successful!" -ForegroundColor Green
    } else {
        Write-Host "  ❌ TCP connection FAILED!" -ForegroundColor Red
        Write-Host "    SQL Server is not accepting connections on port 1433" -ForegroundColor Yellow
        $hasError = $true
    }
} catch {
    Write-Host "  ❌ Cannot test TCP connection: $_" -ForegroundColor Red
    $hasError = $true
}
Write-Host ""

# Check 4: Firewall Rules
Write-Host "[4/8] Checking Windows Firewall rules..." -ForegroundColor Yellow
$firewallRule = Get-NetFirewallRule -DisplayName "*SQL*" -ErrorAction SilentlyContinue | 
                Where-Object { $_.Enabled -eq $true }

if ($firewallRule) {
    Write-Host "  ✅ SQL Server firewall rules found:" -ForegroundColor Green
    $firewallRule | ForEach-Object { 
        Write-Host "    - $($_.DisplayName) [$($_.Direction)]" -ForegroundColor Gray 
    }
} else {
    Write-Host "  ⚠️  No SQL Server firewall rules found" -ForegroundColor Yellow
    Write-Host "    [FIX] Creating firewall rule for port 1433..." -ForegroundColor Yellow
    try {
        New-NetFirewallRule -DisplayName "SQL Server (TCP 1433)" `
                            -Direction Inbound `
                            -Protocol TCP `
                            -LocalPort 1433 `
                            -Action Allow `
                            -ErrorAction Stop | Out-Null
        Write-Host "    ✅ Firewall rule created!" -ForegroundColor Green
    } catch {
        Write-Host "    ❌ Failed to create firewall rule: $_" -ForegroundColor Red
        Write-Host "    Please run this script as Administrator" -ForegroundColor Yellow
    }
}
Write-Host ""

# Check 5: SQL Server Processes
Write-Host "[5/8] Checking SQL Server processes..." -ForegroundColor Yellow
$sqlProcess = Get-Process -Name "sqlservr" -ErrorAction SilentlyContinue

if ($sqlProcess) {
    Write-Host "  ✅ SQL Server process is running (PID: $($sqlProcess.Id))" -ForegroundColor Green
} else {
    Write-Host "  ❌ SQL Server process (sqlservr.exe) is NOT running!" -ForegroundColor Red
    $hasError = $true
}
Write-Host ""

# Check 6: Test Database Connection with Node.js script
Write-Host "[6/8] Testing database connection with Node.js..." -ForegroundColor Yellow
$testConnectionPath = Join-Path $PSScriptRoot "test-connection.js"
if (Test-Path $testConnectionPath) {
    Write-Host "  Running test-connection.js..." -ForegroundColor Gray
    Write-Host ""
    node $testConnectionPath
} else {
    Write-Host "  ⚠️  test-connection.js not found in tools directory" -ForegroundColor Yellow
}
Write-Host ""

# Check 7: Environment Variables
Write-Host "[7/8] Checking .env file..." -ForegroundColor Yellow
$envPath = Join-Path (Split-Path (Split-Path (Split-Path $PSScriptRoot))) ".env"
if (Test-Path $envPath) {
    $envContent = Get-Content $envPath | Select-String "DATABASE_URL"
    if ($envContent) {
        Write-Host "  ✅ DATABASE_URL found in .env" -ForegroundColor Green
        Write-Host "    $envContent" -ForegroundColor Gray
        
        if ($envContent -match "localhost.*1433") {
            Write-Host "    ✅ Using port 1433" -ForegroundColor Green
        } elseif ($envContent -match "SQLEXPRESS") {
            Write-Host "    ⚠️  WARNING: Using instance name 'SQLEXPRESS'" -ForegroundColor Yellow
            Write-Host "    ⚠️  Consider changing to: localhost:1433" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  ❌ DATABASE_URL not found in .env" -ForegroundColor Red
        $hasError = $true
    }
} else {
    Write-Host "  ❌ .env file not found!" -ForegroundColor Red
    $hasError = $true
}
Write-Host ""

# Check 8: SQL Server Browser (optional)
Write-Host "[8/8] Checking SQL Server Browser..." -ForegroundColor Yellow
$browserService = Get-Service -Name "SQLBrowser" -ErrorAction SilentlyContinue

if ($browserService) {
    $status = $browserService.Status
    $color = if ($status -eq "Running") { "Green" } else { "Yellow" }
    Write-Host "  SQL Browser Service: " -NoNewline
    Write-Host $status -ForegroundColor $color
    
    if ($status -ne "Running") {
        Write-Host "    ℹ️  NOTE: SQL Browser is not needed when using port 1433" -ForegroundColor Cyan
    }
} else {
    Write-Host "  ℹ️  SQL Browser service not found (not needed for port 1433)" -ForegroundColor Cyan
}
Write-Host ""

# Summary
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "DIAGNOSIS SUMMARY" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

if (-not $hasError) {
    Write-Host "✅ ALL CHECKS PASSED!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your SQL Server appears to be configured correctly." -ForegroundColor Green
    Write-Host "If Prisma still fails, try:" -ForegroundColor Yellow
    Write-Host "  1. npx prisma db push" -ForegroundColor White
    Write-Host "  2. Check for typos in .env file" -ForegroundColor White
    Write-Host "  3. Restart VS Code / Terminal" -ForegroundColor White
} else {
    Write-Host "❌ ISSUES DETECTED!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Common fixes:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1️⃣ If SQL Server service is stopped:" -ForegroundColor Cyan
    Write-Host "   Get-Service -Name 'MSSQL*' | Start-Service" -ForegroundColor White
    Write-Host ""
    Write-Host "2️⃣ If port 1433 not listening:" -ForegroundColor Cyan
    Write-Host "   - Open SQL Server Configuration Manager" -ForegroundColor White
    Write-Host "   - Expand: SQL Server Network Configuration" -ForegroundColor White
    Write-Host "   - Click: Protocols for SQLEXPRESS" -ForegroundColor White
    Write-Host "   - Double-click: TCP/IP -> Enable" -ForegroundColor White
    Write-Host "   - Tab IP Addresses -> IPALL section:" -ForegroundColor White
    Write-Host "     * TCP Dynamic Ports: (leave empty)" -ForegroundColor White
    Write-Host "     * TCP Port: 1433" -ForegroundColor White
    Write-Host "   - Restart SQL Server: Restart-Service 'MSSQL`$SQLEXPRESS'" -ForegroundColor White
    Write-Host ""
    Write-Host "3️⃣ If firewall blocking:" -ForegroundColor Cyan
    Write-Host "   Already attempted to create firewall rule above" -ForegroundColor White
    Write-Host ""
    Write-Host "4️⃣ After making changes:" -ForegroundColor Cyan
    Write-Host "   Restart-Service 'MSSQL`$SQLEXPRESS' -Force" -ForegroundColor White
    Write-Host ""
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
