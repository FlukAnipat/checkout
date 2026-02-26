# Railway Database Setup for HSK 1 Vocabulary

## 🚀 How to Import HSK 1 Data to Railway

### Method 1: Railway Console (Recommended)

1. **Go to Railway Dashboard**
   - Login to [railway.app](https://railway.app)
   - Select your project
   - Go to the MySQL service

2. **Open MySQL Console**
   - Click on your MySQL service
   - Click "Console" tab
   - You'll see a MySQL command prompt

3. **Run the Import Script**
   ```sql
   -- Copy and paste this entire script into the console:
   
   SOURCE https://raw.githubusercontent.com/FlukAnipat/checkout/master/database/import-hsk1-railway.sql;
   
   -- Or copy the content from import-hsk1-railway.sql file directly
   ```

### Method 2: Railway CLI

1. **Install Railway CLI**
   ```bash
   npm install -g @railway/cli
   railway login
   ```

2. **Connect to your project**
   ```bash
   railway project select
   ```

3. **Run SQL script**
   ```bash
   # Copy the SQL content and save to temp file
   curl -o temp.sql https://raw.githubusercontent.com/FlukAnipat/checkout/master/database/import-hsk1-railway.sql
   
   # Execute the script
   railway variables get DATABASE_URL  # Get your database URL
   mysql -h [HOST] -u [USERNAME] -p[PASSWORD] [DATABASE] < temp.sql
   ```

### Method 3: Using MySQL Client

1. **Get Railway Database Credentials**
   ```bash
   railway variables
   ```

2. **Connect with MySQL client**
   ```bash
   mysql -h [HOST] -u [USERNAME] -p[PASSWORD] [DATABASE]
   ```

3. **Run the script**
   ```sql
   SOURCE database/import-hsk1-railway.sql;
   ```

## 📊 What Gets Imported

- **20 HSK 1 vocabulary words**
- **Complete data**: Hanzi, Pinyin, English, Myanmar meanings
- **3 example sentences per word** (Chinese + English + Myanmar)
- **Audio-ready**: All words support TTS pronunciation

## 🎯 After Import

1. **Test the web app**
   - Go to: `https://hsk-shwe-flash.vercel.app`
   - Login with test account
   - Navigate to HSK Level 1
   - Test flashcards with audio

2. **Verify data**
   ```sql
   -- Check count
   SELECT COUNT(*) FROM vocabulary WHERE hsk_level = 1;
   
   -- Check examples
   SELECT hanzi, LEFT(example, 100) as preview 
   FROM vocabulary WHERE hsk_level = 1 LIMIT 5;
   ```

## 🔧 Troubleshooting

### If you get "INSERT IGNORE" errors:
- The words already exist
- Use `DELETE FROM vocabulary WHERE hsk_level = 1;` first

### If connection fails:
- Check Railway service is running
- Verify database credentials
- Make sure you're using the correct database name

### If audio doesn't work:
- Check browser supports SpeechSynthesis
- Test with Chrome/Firefox
- Make sure example data has Chinese characters

## 📱 Testing Features

After import, test these features:

1. **Dashboard Search**: Search for "爱" or "北京"
2. **HSK Level 1**: Browse vocabulary with audio buttons
3. **Flashcards**: Flip cards to see examples with audio
4. **Saved Words**: Save words and listen to pronunciation
5. **Guest Mode**: Test 20-word limit for free users

## 🚀 Next Steps

1. Import more HSK levels (2-6) using similar scripts
2. Add more example sentences if needed
3. Update audio quality with professional recordings
4. Add more language support

## 📞 Support

If you need help:
- Check Railway documentation: https://docs.railway.app
- Test the live app: https://hsk-shwe-flash.vercel.app
- Review the import script: `database/import-hsk1-railway.sql`
