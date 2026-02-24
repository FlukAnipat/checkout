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
    const pool = mysql.createPool({
      host: process.env.DB_HOST || 'localhost',
      port: parseInt(process.env.DB_PORT || '3306'),
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || '',
      database: process.env.DB_NAME || 'railway',
      multipleStatements: true,
      connectTimeout: 30000,
    });

    console.log('Setup: Connecting to MySQL...');
    const conn = await pool.getConnection();
    console.log('Setup: Connected!');

    // Read SQL file
    const sqlPath = path.join(__dirname, '..', 'setup.sql');
    const sql = fs.readFileSync(sqlPath, 'utf8');

    console.log('Setup: Executing SQL...');
    await conn.query(sql);
    console.log('Setup: SQL executed!');

    // Verify tables
    const [tables] = await conn.query('SHOW TABLES');
    const tableNames = tables.map(t => Object.values(t)[0]);

    // Count rows
    const counts = {};
    for (const name of tableNames) {
      const [rows] = await conn.query(`SELECT COUNT(*) as c FROM \`${name}\``);
      counts[name] = rows[0].c;
    }

    conn.release();
    await pool.end();

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
