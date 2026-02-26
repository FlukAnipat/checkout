-- Import HSK 1 vocabulary for Railway database
-- Run this in Railway MySQL console or via Railway CLI

-- Check current HSK 1 words count
SELECT 'Current HSK 1 words count:' as info;
SELECT COUNT(*) as count FROM vocabulary WHERE hsk_level = 1;

-- Import HSK 1 vocabulary (first 20 words with examples)
INSERT IGNORE INTO vocabulary (vocab_id, hsk_level, hanzi, pinyin, meaning, meaning_en, meaning_my, example, sort_order) VALUES
('hsk1_001', 1, '爱', 'ài', 'love', 'love', 'ချစ်သည်', '1. 我爱你。\n\n2. 妈妈爱我。\n\n3. 他爱看书。', 1),

('hsk1_002', 1, '爱好', 'ài hào', 'hobby', 'hobby', 'ဝါသနာ', '1. 你的爱好是什么？\n\n2. 我的爱好是唱歌。\n\n3. 他有很多爱好。', 2),

('hsk1_003', 1, '八', 'bā', 'eight', 'eight', 'ရှစ် (ဂဏန်း)', '1. 我有八本书。\n\n2. 今天是八号。\n\n3. 八点开会。', 3),

('hsk1_004', 1, '爸爸', 'bà ba', 'father', 'father', 'ဖခင်', '1. 这是我爸爸。\nThis is my father.\nဒါက င့်ဖခင်ပဲ။\n\n2. 爸爸在工作。\nDad is working.\nဖေဖေက လုပ်ငန်းလုပ်နေတယ်။\n\n3. 我爱爸爸。\nI love my dad.\nငါ ဖေဖေကိုချစ်တယ်။', 4),

('hsk1_005', 1, '杯子', 'bēi zi', 'cup/glass', 'cup', 'ဖန်ခွက်', '1. 请给我一个杯子。\nPlease give me a cup.\nကျွန်တော့်ကို ဖန်ခွက်တစ်ခုပေးပါ။\n\n2. 这个杯子很漂亮。\nThis cup is very beautiful.\nဒီဖန်ခွက်က အရမ်းလှတယ်။\n\n3. 杯子里有水。\nThere is water in the cup.\nဖန်ခွက်ထဲမှာ ရေရှိတယ်။', 5),

('hsk1_006', 1, '北京', 'běi jīng', 'Beijing', 'Beijing', 'ပေကျင်း', '1. 我想去北京。\nI want to go to Beijing.\nငါ ပေကျင်းကိုသွားချင်တယ်။\n\n2. 北京是中国的首都。\nBeijing is the capital of China.\nပေကျင်းက တရုတ်နိုင်ငံရဲ့ မြို့တော်ဖြစ်တယ်။\n\n3. 北京烤鸭很好吃。\nBeijing roast duck is delicious.\nပေကျင်းဝက်ဝံကောက်က အရမ်းဆိုးတယ်။', 6),

('hsk1_007', 1, '本', 'běn', 'this/measure word', 'this', 'ဒီ', '1. 这本书很有意思。\nThis book is very interesting.\nဒီစာအုပ်က အရမ်းစိတ်ဝင်စားဖို့ကောင်းတယ်။\n\n2. 我有三本书。\nI have three books.\nငါ့မှာ စာအုပ်သုံးအုပ်ရှိတယ်။\n\n3. 请看本页。\nPlease look at this page.\nဒီစာမျက်နှာကိုကြည့်ပါ။', 7),

('hsk1_008', 1, '不', 'bù', 'not/no', 'not', 'မဟုတ်/မ', '1. 我不饿。\nI am not hungry.\nငါ ဆာမဟုတ်ဘူး။\n\n2. 他不喜欢咖啡。\nHe doesn\'t like coffee.\nသူ ကော်ဖီမကြိုက်ဘူး။\n\n3. 今天不冷。\nIt\'s not cold today.\nဒီနေ့ မအေးဘူး။', 8),

('hsk1_009', 1, '茶', 'chá', 'tea', 'tea', 'လက်ဖက်', '1. 我想喝茶。\nI want to drink tea.\nငါ လက်ဖက်ရည်သောက်ချင်တယ်။\n\n2. 中国茶很有名。\nChinese tea is very famous.\nတရုတ်လက်ဖက်ရည်က အရမ်းနာမည်ကြီးတယ်။\n\n3. 请给我一杯茶。\nPlease give me a cup of tea.\nကျွန်တော့ကို လက်ဖက်ရည်ခွက်တစ်ခုပေးပါ။', 9),

('hsk1_010', 1, '吃', 'chī', 'eat', 'eat', 'စား', '1. 我吃饭。\nI eat rice/meal.\nငါထမင်းစားတယ်။\n\n2. 他吃饭了。\nHe has eaten.\nသူထမင်းစားပြီးပြီ။\n\n3. 我们一起吃饭吧。\nLet\'s eat together.\nငါတို့အတူထမင်းစားကြစို့။', 10),

('hsk1_011', 1, '出租车', 'chū zū chē', 'taxi', 'taxi', 'ဓာတ်ယာဉ်', '1. 我们坐出租车去。\nLet\'s go by taxi.\nငါတို့ ဓာတ်ယာဉ်စီးသွားကြစို့။\n\n2. 出租车在那里。\nThe taxi is over there.\nဓာတ်ယာဉ်က ဒီမှာပဲ။\n\n3. 请叫一辆出租车。\nPlease call a taxi.\nဓာတ်ယာဉ်တစ်စီးခေါ်ပါ။', 11),

('hsk1_012', 1, '穿', 'chuān', 'wear', 'wear', 'ဝတ်', '1. 我穿红色的衣服。\nI wear red clothes.\nငါ အနီရောင်ဝတ်တယ်။\n\n2. 天气冷，多穿衣服。\nIt\'s cold, wear more clothes.\nရာသီဥတုအေးတယ်၊ အဝတ်ပိုဝတ်ပါ။\n\n3. 他喜欢穿牛仔裤。\nHe likes to wear jeans.\nသူ ဂျင်းပန်းဝတ်ခြင်းကို နှစ်သက်တယ်။', 12),

('hsk1_013', 1, '船', 'chuán', 'boat/ship', 'boat', 'လှေ', '1. 那是一艘大船。\nThat is a big boat.\nဒါက လှေကြီးတစ်စင်းပဲ။\n\n2. 我们坐船去旅行。\nWe travel by boat.\nငါတို့ လှေစီးခရီးသွားကြတယ်။\n\n3. 船在水上走。\nThe boat moves on water.\nလှေက ရေပေါ်မှာသွားတယ်။', 13),

('hsk1_014', 1, '春天', 'chūn tiān', 'spring', 'spring', 'နွေဦး', '1. 春天很美。\nSpring is very beautiful.\nနွေဦးရာသီက အရမ်းလှတယ်။\n\n2. 春天花开。\nFlowers bloom in spring.\nနွေဦးရာသီမှာ ပန်းပွင့်ကြတယ်။\n\n3. 我喜欢春天。\nI like spring.\nငါ နွေဦးရာသီကို နှစ်သက်တယ်။', 14),

('hsk1_015', 1, '次', 'cì', 'times/measure word', 'time', 'အကြိမ်', '1. 我去过一次。\nI have been there once.\nငါ တစ်ခေါက်သွားဖူးတယ်။\n\n2. 一天三次。\nThree times a day.\nတစ်နေ့ကို သုံးကြိမ်။\n\n3. 这是第一次。\nThis is the first time.\nဒါက ပထမအကြိမ်ပဲ။', 15),

('hsk1_016', 1, '从', 'cóng', 'from', 'from', 'မှ', '1. 我从中国来。\nI come from China.\nငါ တရုတ်မှာကလာတယ်။\n\n2. 从这里走。\nGo from here.\nဒီနေရာမှာသွားပါ။\n\n3. 他从八点工作。\nHe works from 8 o\'clock.\nသူ ရှစ်နာရီမှာ အလုပ်လုပ်တယ်။', 16),

('hsk1_017', 1, '打电话', 'dǎ diàn huà', 'make phone call', 'make phone call', 'ဖုန်းခေါ်', '1. 我给妈妈打电话。\nI call my mom.\nငါ အမေကိုဖုန်းခေါ်တယ်။\n\n2. 请打电话给我。\nPlease call me.\nကျွန်တော့ကို ဖုန်းခေါ်ပါ။\n\n3. 他在打电话。\nHe is making a phone call.\nသူ ဖုန်းခေါ်နေတယ်။', 17),

('hsk1_018', 1, '大', 'dà', 'big/large', 'big', 'ကြီး', '1. 这间房子很大。\nThis house is very big.\nဒီအိမ်က အရမ်းကြီးတယ်။\n\n2. 他有一个大书包。\nHe has a big schoolbag.\nသူ့မှာ အိတ်ကြီးတစ်လုံးရှိတယ်။\n\n3. 北京是个大城市。\nBeijing is a big city.\nပေကျင်းက မြို့ကြီးတစ်မြို့ဖြစ်တယ်။', 18),

('hsk1_019', 1, '的', 'de', 'possessive particle', 'of', 'ရဲ့', '1. 这是我的书。\nThis is my book.\nဒါက င့်စာအုပ်ပဲ။\n\n2. 他是我的朋友。\nHe is my friend.\nသူက င့်သူငယ်ချင်းပဲ။\n\n3. 中国的首都是北京。\nChina\'s capital is Beijing.\nတရုတ်နိုင်ငံရဲ့ မြို့တော်က ပေကျင်းပဲ။', 19),

('hsk1_020', 1, '地', 'dì', 'ground/earth', 'earth', 'မြေ', '1. 地很干净。\nThe ground is very clean.\nကပ်ရေးက အရမ်းသပ်ရပ်တယ်။\n\n2. 请坐在地上。\nPlease sit on the ground.\nကပ်ရေးပေါ်မှာထိုင်ပါ။\n\n3. 地上有水。\nThere is water on the ground.\nကပ်ရေးပေါ်မှာ ရေရှိတယ်။', 20);

-- Show results
SELECT 'Import completed!' as message;
SELECT COUNT(*) as total_hsk1_words FROM vocabulary WHERE hsk_level = 1;

-- Show sample data
SELECT 'Sample HSK 1 words:' as info;
SELECT vocab_id, hanzi, pinyin, meaning_en, LEFT(example, 50) as preview_example 
FROM vocabulary WHERE hsk_level = 1 ORDER BY sort_order LIMIT 5;
