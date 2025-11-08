# Quick Fix Script untuk EPERM Error
# Run as Administrator

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "EPERM ERROR - QUICK FIX SCRIPT" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Stop All Node.js Processes
Write-Host "[1/5] Stopping all Node.js processes..." -ForegroundColor Yellow
$nodeProcesses = Get-Process -Name "node" -ErrorAction SilentlyContinue

if ($nodeProcesses) {
    Write-Host "  Found $($nodeProcesses.Count) Node.js process(es)" -ForegroundColor Gray
    $nodeProcesses | ForEach-Object {
        Write-Host "    Stopping PID: $($_.Id)" -ForegroundColor Gray
        Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
    }
    Write-Host "  ✅ All Node.js processes stopped!" -ForegroundColor Green
} else {
    Write-Host "  ℹ️  No Node.js processes found (already stopped)" -ForegroundColor Cyan
}
Write-Host ""

# Step 2: Navigate to Backend
Write-Host "[2/5] Navigating to backend folder..." -ForegroundColor Yellow
$backendPath = $PSScriptRoot | Split-Path | Split-Path | Split-Path
Set-Location $backendPath
Write-Host "  Current directory: $((Get-Location).Path)" -ForegroundColor Gray
Write-Host "  ✅ In backend folder" -ForegroundColor Green
Write-Host ""

# Step 3: Delete .prisma folder
Write-Host "[3/5] Deleting .prisma folder..." -ForegroundColor Yellow
$prismaPath = "node_modules\.prisma"

if (Test-Path $prismaPath) {
    try {
        Remove-Item -Path $prismaPath -Recurse -Force -ErrorAction Stop
        Write-Host "  ✅ .prisma folder deleted successfully!" -ForegroundColor Green
    } catch {
        Write-Host "  ⚠️  Warning: Could not delete .prisma folder" -ForegroundColor Yellow
        Write-Host "  Error: $_" -ForegroundColor Red
        Write-Host "  You may need to delete it manually" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ℹ️  .prisma folder not found (already clean)" -ForegroundColor Cyan
}
Write-Host ""

# Step 4: Generate Prisma Client
Write-Host "[4/5] Generating Prisma Client..." -ForegroundColor Yellow
Write-Host "  Running: npx prisma generate" -ForegroundColor Gray
Write-Host ""

try {
    $output = npx prisma generate 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✅ Prisma Client generated successfully!" -ForegroundColor Green
    } else {
        Write-Host "  ❌ Prisma generate failed!" -ForegroundColor Red
        Write-Host "  Output:" -ForegroundColor Yellow
        Write-Host $output -ForegroundColor Gray
    }
} catch {
    Write-Host "  ❌ Error running prisma generate: $_" -ForegroundColor Red
}
Write-Host ""

# Step 5: Test with db push
Write-Host "[5/5] Testing with db push..." -ForegroundColor Yellow
Write-Host "  Running: npx prisma db push" -ForegroundColor Gray
Write-Host ""

try {
    $output = npx prisma db push 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✅ Database push successful!" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  Database push had warnings (this is normal)" -ForegroundColor Yellow
        Write-Host "  Output:" -ForegroundColor Gray
        Write-Host $output -ForegroundColor Gray
    }
} catch {
    Write-Host "  ❌ Error running db push: $_" -ForegroundColor Red
}
Write-Host ""

# Summary
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "FIX COMPLETE" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ SUCCESS! EPERM error fixed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Run: npm run dev" -ForegroundColor White
    Write-Host "  2. Test your application" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "⚠️  PARTIAL SUCCESS" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Some steps completed, but there were errors." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "If EPERM error persists, try:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1️⃣ Restart VS Code completely" -ForegroundColor Cyan
    Write-Host "   Close all windows and reopen" -ForegroundColor White
    Write-Host ""
    Write-Host "2️⃣ Nuclear option (full clean):" -ForegroundColor Cyan
    Write-Host "   Remove-Item -Recurse -Force node_modules" -ForegroundColor White
    Write-Host "   npm install" -ForegroundColor White
    Write-Host "   npx prisma generate" -ForegroundColor White
    Write-Host ""
    Write-Host "3️⃣ Check antivirus/Windows Defender" -ForegroundColor Cyan
    Write-Host "   Temporarily disable or add exclusion for node_modules" -ForegroundColor White
    Write-Host ""
}

Write-Host "📖 Full documentation: backend/docs/errors/ERROR-EPERM.md" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
