import mysql from 'mysql2/promise';
import fs from 'fs';

const RAILWAY_MYSQL_URL = 'mysql://root:MBQUakmlHQwbWVNMrkNiJFIOBOqPVhy@shuttle.proxy.rlwy.net:58795/railway';

async function importSQL() {
  console.log('Connecting to Railway MySQL...');
  
  const connection = await mysql.createConnection({
    host: 'shuttle.proxy.rlwy.net',
    port: 58795,
    user: 'root',
    password: 'MBQUakmlHQwbWVNMrkNiJFIOBOqPVhy',
    database: 'railway',
    connectTimeout: 30000,
    multipleStatements: true,
    ssl: { rejectUnauthorized: false },
  });
  console.log('Connected!');

  const sql = fs.readFileSync('c:/xampp/htdocs/shwe_flash/sql/shwe_flash_db.sql', 'utf8');

  console.log('Executing SQL...');
  try {
    await connection.query(sql);
    console.log('SQL executed successfully!');
  } catch (err) {
    console.error('Error:', err.message);
  }

  const [tables] = await connection.query('SHOW TABLES');
  console.log('\nTables in database:');
  tables.forEach(t => console.log('  -', Object.values(t)[0]));

  await connection.end();
  console.log('Done!');
}

importSQL().catch(err => {
  console.error('Fatal error:', err.message);
  process.exit(1);
});
