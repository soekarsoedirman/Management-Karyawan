@echo off
echo ============================================================
echo SQL SERVER DIAGNOSTIC TOOL
echo ============================================================
echo.

echo [1/6] Checking SQL Server Services...
echo.
sc query "MSSQL$SQLEXPRESS" | findstr "STATE"
sc query "MSSQLServer" | findstr "STATE"
sc query "SQLBrowser" | findstr "STATE"
echo.

echo [2/6] Checking if port 1433 is listening...
echo.
netstat -an | findstr "1433"
echo.

echo [3/6] Checking SQL Server processes...
echo.
tasklist | findstr "sqlservr.exe"
echo.

echo [4/6] Checking firewall rules for port 1433...
echo.
netsh advfirewall firewall show rule name=all | findstr /C:"SQL Server" /C:"1433"
echo.

echo [5/6] Testing TCP connection to localhost:1433...
echo.
powershell -Command "Test-NetConnection -ComputerName localhost -Port 1433"
echo.

echo [6/6] Checking SQL Server Configuration Manager settings...
echo.
echo Please manually check:
echo   - SQL Server Configuration Manager
echo   - SQL Server Network Configuration
echo   - Protocols for SQLEXPRESS
echo   - TCP/IP should be ENABLED
echo   - IPALL section: TCP Port = 1433, Dynamic Ports = (empty)
echo.

echo ============================================================
echo DIAGNOSIS COMPLETE
echo ============================================================
echo.
echo Next Steps:
echo 1. If SQL Server service is STOPPED - run: net start "MSSQL$SQLEXPRESS"
echo 2. If port 1433 not listening - Enable TCP/IP and set port 1433
echo 3. If firewall blocking - run: netsh advfirewall firewall add rule name="SQL Server" dir=in action=allow protocol=TCP localport=1433
echo 4. After fixes, restart SQL Server: net stop "MSSQL$SQLEXPRESS" ^&^& net start "MSSQL$SQLEXPRESS"
echo.
pause
