import bcrypt from 'bcryptjs';

// ยืนยัน hash ที่ใช้ใน Railway
const password = 'admin123';

// Hash ที่ admin@gmail.com ใช้อยู่ใน Railway (LOGIN ได้)
const knownHash = '$2a$10$RNmtcZRnv0cCqOTY2zdQYeLmzrVmJlDIHy/kzLXN5VoPhPSRIFnwe';

console.log('=== Verify Known Hash ===');
const match = await bcrypt.compare(password, knownHash);
console.log(`admin123 vs knownHash: ${match ? '✅ MATCH' : '❌ NO MATCH'}`);

// Generate fresh hash
console.log('\n=== Generate Fresh Hash ===');
const freshHash = await bcrypt.hash(password, 10);
console.log(`Fresh hash for admin123: ${freshHash}`);

const freshMatch = await bcrypt.compare(password, freshHash);
console.log(`Verify fresh hash: ${freshMatch ? '✅ MATCH' : '❌ NO MATCH'}`);

// Output SQL-ready
console.log('\n=== SQL Ready (use this hash for ALL users) ===');
console.log(`'${freshHash}'`);
