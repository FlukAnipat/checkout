// Node.js script to import HSK 1 vocabulary from CSV
// Run with: node scripts/import-hsk1.js

const fs = require('fs');
const path = require('path');
const mysql = require('mysql2/promise');

// Database configuration
const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'shwe_flash_db'
};

// CSV file path
const csvPath = path.join(__dirname, '../lib/data/HSK 1_Flash cards_(500).csv');

async function importHSK1() {
  let connection;
  
  try {
    // Connect to database
    connection = await mysql.createConnection(dbConfig);
    console.log('Connected to database');

    // Read CSV file
    const csvContent = fs.readFileSync(csvPath, 'utf8');
    const lines = csvContent.split('\n');
    
    console.log(`Found ${lines.length} lines in CSV file`);

    // Skip header line
    const dataLines = lines.slice(1);
    
    let currentWord = null;
    let exampleLines = [];
    let insertCount = 0;

    for (let i = 0; i < dataLines.length; i++) {
      const line = dataLines[i].trim();
      
      if (!line) continue;

      const columns = line.split(',').map(col => col.trim());
      
      // Check if this is a word line (has Chinese character in column 2)
      if (columns[1] && columns[1].match(/[\u4e00-\u9fff]/)) {
        // Insert previous word if exists
        if (currentWord) {
          await insertWord(connection, currentWord, exampleLines);
          insertCount++;
          if (insertCount % 10 === 0) {
            console.log(`Imported ${insertCount} words...`);
          }
        }
        
        // Start new word
        currentWord = {
          no: columns[0],
          chinese: columns[1],
          pinyin: columns[2],
          english: columns[3],
          burmese: columns[4]
        };
        exampleLines = [];
        
        // Check if there's an example in the same line
        if (columns[5]) {
          exampleLines.push(columns[5]);
        }
      } else if (currentWord && columns[5]) {
        // This is an example line for current word
        exampleLines.push(columns[5]);
      }
    }
    
    // Insert last word
    if (currentWord) {
      await insertWord(connection, currentWord, exampleLines);
      insertCount++;
    }

    console.log(`Successfully imported ${insertCount} HSK 1 words!`);
    
  } catch (error) {
    console.error('Error importing HSK 1 vocabulary:', error);
  } finally {
    if (connection) {
      await connection.end();
      console.log('Database connection closed');
    }
  }
}

async function insertWord(connection, word, exampleLines) {
  const vocabId = `hsk1_${String(word.no).padStart(3, '0')}`;
  const hskLevel = 1;
  const hanzi = word.chinese;
  const pinyin = word.pinyin;
  const meaning = word.english;
  const meaningEn = word.english;
  const meaningMy = word.burmese;
  const sortOrder = parseInt(word.no);
  
  // Format example sentences
  let example = '';
  if (exampleLines.length > 0) {
    example = exampleLines.join('\n').trim();
  }

  const sql = `
    INSERT INTO vocabulary 
    (vocab_id, hsk_level, hanzi, pinyin, meaning, meaning_en, meaning_my, example, sort_order) 
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ON DUPLICATE KEY UPDATE
    meaning = VALUES(meaning),
    meaning_en = VALUES(meaning_en),
    meaning_my = VALUES(meaning_my),
    example = VALUES(example)
  `;

  await connection.execute(sql, [
    vocabId, hskLevel, hanzi, pinyin, meaning, meaningEn, meaningMy, example, sortOrder
  ]);
}

// Run the import
if (require.main === module) {
  importHSK1();
}

module.exports = { importHSK1 };
