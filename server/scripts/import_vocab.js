/**
 * Import vocabulary data from Dart files into MySQL database
 * Run: node scripts/import_vocab.js
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import mysql from 'mysql2/promise';
import dotenv from 'dotenv';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config({ path: path.join(__dirname, '..', '.env') });

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '3306'),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'shwe_flash_db',
  waitForConnections: true,
  connectionLimit: 5,
});

// Parse a Dart vocabulary file and extract word objects
function parseDartFile(filePath) {
  const content = fs.readFileSync(filePath, 'utf-8');
  const words = [];

  // Match each Vocabulary(...) block
  const vocabRegex = /Vocabulary\(\s*([\s\S]*?)\),?\s*(?=Vocabulary\(|];)/g;
  let match;

  while ((match = vocabRegex.exec(content)) !== null) {
    const block = match[1];
    const word = {};

    // Extract fields
    const idMatch = block.match(/id:\s*'([^']+)'/);
    const hskMatch = block.match(/hskLevel:\s*(\d+)/);
    const hanziMatch = block.match(/hanzi:\s*'([^']+)'/);
    const pinyinMatch = block.match(/pinyin:\s*'([^']+)'/);

    // meaning can be multi-line with single quotes
    const meaningMatch = block.match(/meaning:\s*'((?:[^'\\]|\\.)*)'/);
    const meaningEnMatch = block.match(/meaningEn:\s*'((?:[^'\\]|\\.)*)'/);
    const meaningMyMatch = block.match(/meaningMy:\s*'((?:[^'\\]|\\.)*)'/);

    // example can be very long with \n
    const exampleMatch = block.match(/example:\s*'((?:[^'\\]|\\[\s\S])*)'/);
    const audioMatch = block.match(/audioAsset:\s*'([^']+)'/);

    if (idMatch) word.id = idMatch[1];
    if (hanziMatch) word.hanzi = hanziMatch[1];
    if (pinyinMatch) word.pinyin = pinyinMatch[1];
    if (meaningMatch) word.meaning = meaningMatch[1].replace(/\\'/g, "'");
    if (meaningEnMatch) word.meaningEn = meaningEnMatch[1].replace(/\\'/g, "'");
    if (meaningMyMatch) word.meaningMy = meaningMyMatch[1].replace(/\\'/g, "'");
    if (exampleMatch) word.example = exampleMatch[1].replace(/\\n/g, '\n').replace(/\\'/g, "'");
    if (audioMatch) word.audioAsset = audioMatch[1];

    // Detect hskLevel from id if not explicitly set
    if (hskMatch) {
      word.hskLevel = parseInt(hskMatch[1]);
    } else if (word.id) {
      const levelFromId = word.id.match(/hsk(\d+)|h(\d+)/);
      if (levelFromId) word.hskLevel = parseInt(levelFromId[1] || levelFromId[2]);
    }

    if (word.id && word.hanzi) {
      words.push(word);
    }
  }

  return words;
}

async function importWords() {
  const dartDataDir = path.join(__dirname, '..', '..', '..', 'lib', 'data');

  const files = [
    { file: 'hsk1_words.dart', level: 1 },
    { file: 'hsk2_words.dart', level: 2 },
    { file: 'hsk3_words.dart', level: 3 },
    { file: 'hsk4_words.dart', level: 4 },
    { file: 'hsk5_words.dart', level: 5 },
    { file: 'hsk6_words.dart', level: 6 },
    { file: 'hsk7_words.dart', level: 7 },
  ];

  let totalImported = 0;

  for (const { file, level } of files) {
    const filePath = path.join(dartDataDir, file);
    if (!fs.existsSync(filePath)) {
      console.log(`⏭️  Skipping ${file} (not found)`);
      continue;
    }

    console.log(`📖 Parsing ${file}...`);
    const words = parseDartFile(filePath);

    if (words.length === 0) {
      console.log(`   ⚠️  No words found in ${file}`);
      continue;
    }

    console.log(`   Found ${words.length} words`);

    const sql = `INSERT INTO vocabulary 
      (vocab_id, hsk_level, hanzi, pinyin, meaning, meaning_en, meaning_my, example, audio_asset, sort_order) 
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON DUPLICATE KEY UPDATE 
        hanzi = VALUES(hanzi),
        pinyin = VALUES(pinyin),
        meaning = VALUES(meaning),
        meaning_en = VALUES(meaning_en),
        meaning_my = VALUES(meaning_my),
        example = VALUES(example),
        audio_asset = VALUES(audio_asset),
        sort_order = VALUES(sort_order)`;

    for (let i = 0; i < words.length; i++) {
      const w = words[i];
      try {
        await pool.execute(sql, [
          w.id,
          w.hskLevel || level,
          w.hanzi || '',
          w.pinyin || '',
          w.meaning || '',
          w.meaningEn || '',
          w.meaningMy || '',
          w.example || null,
          w.audioAsset || null,
          i + 1,
        ]);
        totalImported++;
      } catch (err) {
        console.error(`   ❌ Error importing ${w.id} (${w.hanzi}): ${err.message}`);
      }
    }

    console.log(`   ✅ Imported ${words.length} words for HSK ${level}`);
  }

  console.log(`\n🎉 Total: ${totalImported} words imported into MySQL!`);

  // Show stats
  const [stats] = await pool.execute(
    'SELECT hsk_level, COUNT(*) as count FROM vocabulary GROUP BY hsk_level ORDER BY hsk_level'
  );
  console.log('\n📊 Database vocabulary stats:');
  for (const s of stats) {
    console.log(`   HSK ${s.hsk_level}: ${s.count} words`);
  }

  await pool.end();
}

importWords().catch(err => {
  console.error('❌ Import failed:', err);
  process.exit(1);
});
