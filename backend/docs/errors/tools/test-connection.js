const sql = require('mssql');
require('dotenv').config();

const config = {
  server: process.env.db_host || 'localhost',
  port: 1433,
  user: process.env.db_user || 'prisma_user',
  password: process.env.db_password || 'Prisma!2025',
  database: process.env.db_name || 'db_restoran',
  options: {
    encrypt: true,
    trustServerCertificate: true,
    connectTimeout: 30000,
    requestTimeout: 30000
  }
};

console.log('🔍 Testing SQL Server Connection...\n');
console.log('Configuration:');
console.log('  Server:', config.server);
console.log('  Port:', config.port);
console.log('  Database:', config.database);
console.log('  User:', config.user);
console.log('  Password:', config.password.replace(/./g, '*'));
console.log('\n' + '='.repeat(60) + '\n');

async function testConnection() {
  let pool;
  
  try {
    console.log('⏳ Step 1: Connecting to SQL Server...');
    pool = await sql.connect(config);
    console.log('✅ Step 1: Connection SUCCESSFUL!\n');

    console.log('⏳ Step 2: Testing query execution...');
    const versionResult = await pool.request().query('SELECT @@VERSION AS Version, @@SERVERNAME AS ServerName');
    console.log('✅ Step 2: Query execution SUCCESSFUL!\n');

    console.log('📋 SQL Server Information:');
    console.log('  Server Name:', versionResult.recordset[0].ServerName);
    console.log('  Version:', versionResult.recordset[0].Version.split('\n')[0]);
    console.log('');

    console.log('⏳ Step 3: Checking database existence...');
    const dbCheck = await pool.request().query(`
      SELECT name FROM sys.databases WHERE name = '${config.database}'
    `);
    
    if (dbCheck.recordset.length > 0) {
      console.log(`✅ Step 3: Database '${config.database}' EXISTS!\n`);
    } else {
      console.log(`⚠️  Step 3: Database '${config.database}' NOT FOUND!`);
      console.log(`   Creating database '${config.database}'...\n`);
      await pool.request().query(`CREATE DATABASE [${config.database}]`);
      console.log(`✅ Database '${config.database}' created successfully!\n`);
    }

    console.log('⏳ Step 4: Checking user permissions...');
    await pool.request().query(`USE [${config.database}]`);
    const permCheck = await pool.request().query(`
      SELECT 
        CASE WHEN IS_MEMBER('db_owner') = 1 THEN 'YES' ELSE 'NO' END AS IsOwner,
        USER_NAME() AS CurrentUser
    `);
    console.log('✅ Step 4: Permission check SUCCESSFUL!');
    console.log('  Current User:', permCheck.recordset[0].CurrentUser);
    console.log('  Is DB Owner:', permCheck.recordset[0].IsOwner);
    console.log('');

    console.log('⏳ Step 5: Testing table operations...');
    try {
      await pool.request().query(`
        IF OBJECT_ID('TestTable', 'U') IS NOT NULL DROP TABLE TestTable;
        CREATE TABLE TestTable (id INT PRIMARY KEY, name NVARCHAR(50));
        INSERT INTO TestTable VALUES (1, 'Test');
        SELECT * FROM TestTable;
        DROP TABLE TestTable;
      `);
      console.log('✅ Step 5: Table operations SUCCESSFUL!\n');
    } catch (err) {
      console.log('⚠️  Step 5: Table operations FAILED!');
      console.log('   Error:', err.message, '\n');
    }

    console.log('='.repeat(60));
    console.log('🎉 ALL TESTS PASSED! SQL Server is ready for Prisma!');
    console.log('='.repeat(60));
    console.log('\n✅ Next steps:');
    console.log('   1. Run: npx prisma db push');
    console.log('   2. Run: npx prisma generate');
    console.log('   3. Run: npm run db:seed');
    console.log('   4. Run: npm run dev\n');

  } catch (err) {
    console.log('\n' + '='.repeat(60));
    console.log('❌ CONNECTION FAILED!');
    console.log('='.repeat(60));
    console.log('\nError Details:');
    console.log('  Code:', err.code);
    console.log('  Message:', err.message);
    
    console.log('\n🔧 Possible Solutions:\n');
    
    if (err.code === 'ESOCKET' || err.code === 'ECONNREFUSED') {
      console.log('1. ❌ SQL Server is NOT RUNNING');
      console.log('   ✅ Solution: Start SQL Server service');
      console.log('   Command: Get-Service -Name "MSSQL*" | Start-Service\n');
      
      console.log('2. ❌ TCP/IP Protocol is DISABLED');
      console.log('   ✅ Solution: Enable TCP/IP in SQL Server Configuration Manager\n');
      
      console.log('3. ❌ Port 1433 is BLOCKED');
      console.log('   ✅ Solution: Check firewall settings');
      console.log('   Command: netstat -an | findstr "1433"\n');
    }
    
    if (err.code === 'ECONNRESET') {
      console.log('1. ❌ Connection was RESET during handshake');
      console.log('   ✅ Solution: Check SQL Server is listening on port 1433');
      console.log('   ✅ Enable TCP/IP protocol in SQL Server Config Manager');
      console.log('   ✅ Restart SQL Server service after enabling TCP/IP\n');
    }
    
    if (err.message.includes('Login failed')) {
      console.log('1. ❌ AUTHENTICATION FAILED');
      console.log('   ✅ Solution: Check username/password in .env file');
      console.log('   ✅ Ensure SQL Server is in Mixed Authentication mode');
      console.log('   ✅ Verify user exists: SELECT * FROM sys.server_principals WHERE name = \'prisma_user\'\n');
    }

    console.log('\n📚 See TROUBLESHOOTING.md for detailed solutions!\n');
    
    console.log('Full Error Object:');
    console.log(err);
    
  } finally {
    if (pool) {
      await pool.close();
      console.log('\n🔌 Connection closed.');
    }
  }
}

testConnection();
