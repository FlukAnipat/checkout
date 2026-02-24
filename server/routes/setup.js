import express from 'express';
import mysql from 'mysql2/promise';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const router = express.Router();

// GET /api/setup - Create tables and import data (run once)
router.get('/', async (req, res) => {
  try {
    let connConfig;
    const dbUrl = process.env.DATABASE_URL;

    if (dbUrl && dbUrl.includes('mysql://')) {
      const url = new URL(dbUrl);
      connConfig = {
        host: url.hostname,
        port: parseInt(url.port) || 3306,
        user: url.username,
        password: url.password,
        database: url.pathname.substring(1),
        ssl: { rejectUnauthorized: false },
        multipleStatements: true
      };
    } else {
      connConfig = {
        host: process.env.DB_HOST || 'localhost',
        port: parseInt(process.env.DB_PORT || '3306'),
        user: process.env.DB_USER || 'root',
        password: process.env.DB_PASSWORD || '',
        database: process.env.DB_NAME || 'shwe_flash_db',
        ssl: { rejectUnauthorized: false },
        multipleStatements: true
      };
    }

    const conn = await mysql.createConnection(connConfig);

    console.log('Setup: Connected to MySQL!');

    // Read and execute MySQL SQL
    const sqlPath = path.join(__dirname, '..', 'setup-full.sql');
    const sql = fs.readFileSync(sqlPath, 'utf8');
    
    console.log('Setup: Creating schema and inserting data...');
    await conn.query(sql);
    console.log('Setup: Database setup completed!');

    // Verify tables
    const [tables] = await conn.query('SHOW TABLES');
    const tableNames = tables.map(t => Object.values(t)[0]);

    // Count rows
    const counts = {};
    for (const name of tableNames) {
      const [rows] = await conn.query(`SELECT COUNT(*) as c FROM \`${name}\``);
      counts[name] = parseInt(rows[0].c);
    }

    await conn.end();

    res.json({
      success: true,
      message: 'Database setup completed!',
      tables: counts,
    });
  } catch (err) {
    console.error('Setup error:', err.message);
    res.status(500).json({
      success: false,
      error: err.message,
    });
  }
});

export default router;
