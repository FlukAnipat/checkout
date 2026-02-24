/**
 * Seed Script — Add test users to local JSON database
 * Run: node server/seed.js
 */

import bcrypt from 'bcryptjs';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const USERS_FILE = path.join(__dirname, 'data', 'users.json');

// Test users (same as Flutter app)
const testUsers = [
  {
    firstName: 'Admin',
    lastName: 'User',
    email: 'admin@gmail.com',
    phone: '123456789',
    countryCode: '+95',
    password: 'admin123',
  },
];

async function seed() {
  console.log('Seeding users...\n');

  const users = [];

  for (const u of testUsers) {
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(u.password, salt);

    users.push({
      userId: `user_${Date.now()}_${Math.random().toString(36).slice(2, 8)}`,
      firstName: u.firstName,
      lastName: u.lastName,
      email: u.email.toLowerCase().trim(),
      phone: u.phone,
      countryCode: u.countryCode,
      password: hashedPassword,
      isPaid: false,
      promoCodeUsed: null,
      paidAt: null,
      createdAt: new Date().toISOString(),
    });

    console.log(`  + ${u.email} / ${u.password}`);
  }

  fs.writeFileSync(USERS_FILE, JSON.stringify(users, null, 2), 'utf-8');
  console.log(`\nDone! ${users.length} user(s) saved to ${USERS_FILE}`);
}

seed().catch(console.error);
