import express from 'express';
import pg from 'pg';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const router = express.Router();

// GET /api/setup - Create tables and import data (run once)
router.get('/', async (req, res) => {
  try {
    const pool = new pg.Pool({
      host: process.env.DB_HOST,
      port: parseInt(process.env.DB_PORT),
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      ssl: {
        rejectUnauthorized: false
      }
    });

    console.log('Setup: Connecting to PostgreSQL...');
    const conn = await pool.connect();
    console.log('Setup: Connected!');

    // Read and execute PostgreSQL SQL
    const sqlPath = path.join(__dirname, '..', 'setup-postgres.sql');
    const sql = fs.readFileSync(sqlPath, 'utf8');
    
    console.log('Setup: Creating schema and inserting data...');
    await conn.query(sql);
    console.log('Setup: Database setup completed!');

    // Verify tables
    const { rows: tables } = await conn.query('SELECT table_name FROM information_schema.tables WHERE table_schema = \'public\'');
    const tableNames = tables.map(t => t.table_name);

    // Count rows
    const counts = {};
    for (const name of tableNames) {
      const { rows } = await conn.query(`SELECT COUNT(*) as c FROM "${name}"`);
      counts[name] = parseInt(rows[0].c);
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
