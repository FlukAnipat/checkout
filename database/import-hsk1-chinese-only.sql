-- Import HSK 1 vocabulary for Railway database
-- Examples contain ONLY Chinese sentences (no English/Myanmar)

-- Check current HSK 1 words count
SELECT 'Current HSK 1 words count:' as info;
SELECT COUNT(*) as count FROM vocabulary WHERE hsk_level = 1;

-- Import HSK 1 vocabulary (first 20 words with Chinese-only examples)
INSERT IGNORE INTO vocabulary (vocab_id, hsk_level, hanzi, pinyin, meaning, meaning_en, meaning_my, example, sort_order) VALUES
('hsk1_001', 1, '爱', 'ài', 'love', 'love', 'ချစ်သည်', '1. 我爱你。\n\n2. 妈妈爱我。\n\n3. 他爱看书。', 1),

('hsk1_002', 1, '爱好', 'ài hào', 'hobby', 'hobby', 'ဝါသနာ', '1. 你的爱好是什么？\n\n2. 我的爱好是唱歌。\n\n3. 他有很多爱好。', 2),

('hsk1_003', 1, '八', 'bā', 'eight', 'eight', 'ရှစ် (ဂဏန်း)', '1. 我有八本书。\n\n2. 今天是八号。\n\n3. 八点开会。', 3),

('hsk1_004', 1, '爸爸', 'bà ba', 'father', 'father', 'ဖခင်', '1. 这是我爸爸。\n\n2. 爸爸在工作。\n\n3. 我爱爸爸。', 4),

('hsk1_005', 1, '杯子', 'bēi zi', 'cup/glass', 'cup', 'ဖန်ခွက်', '1. 请给我一个杯子。\n\n2. 这个杯子很漂亮。\n\n3. 杯子里有水。', 5),

('hsk1_006', 1, '北京', 'běi jīng', 'Beijing', 'Beijing', 'ပေကျင်း', '1. 我想去北京。\n\n2. 北京是中国的首都。\n\n3. 北京烤鸭很好吃。', 6),

('hsk1_007', 1, '本', 'běn', 'this/measure word', 'this', 'ဒီ', '1. 这本书很有意思。\n\n2. 我有三本书。\n\n3. 请看本页。', 7),

('hsk1_008', 1, '不', 'bù', 'not/no', 'not', 'မဟုတ်/မ', '1. 我不饿。\n\n2. 他不喜欢咖啡。\n\n3. 今天不冷。', 8),

('hsk1_009', 1, '茶', 'chá', 'tea', 'tea', 'လက်ဖက်', '1. 我想喝茶。\n\n2. 中国茶很有名。\n\n3. 请给我一杯茶。', 9),

('hsk1_010', 1, '吃', 'chī', 'eat', 'eat', 'စား', '1. 我吃饭。\n\n2. 他吃饭了。\n\n3. 我们一起吃饭吧。', 10),

('hsk1_011', 1, '出租车', 'chū zū chē', 'taxi', 'taxi', 'ဓာတ်ယာဉ်', '1. 我们坐出租车去。\n\n2. 出租车在那里。\n\n3. 请叫一辆出租车。', 11),

('hsk1_012', 1, '穿', 'chuān', 'wear', 'wear', 'ဝတ်', '1. 我穿红色的衣服。\n\n2. 天气冷，多穿衣服。\n\n3. 他喜欢穿牛仔裤。', 12),

('hsk1_013', 1, '船', 'chuán', 'boat/ship', 'boat', 'လှေ', '1. 那是一艘大船。\n\n2. 我们坐船去旅行。\n\n3. 船在水上走。', 13),

('hsk1_014', 1, '春天', 'chūn tiān', 'spring', 'spring', 'နွေဦး', '1. 春天很美。\n\n2. 春天花开。\n\n3. 我喜欢春天。', 14),

('hsk1_015', 1, '次', 'cì', 'times/measure word', 'time', 'အကြိမ်', '1. 我去过一次。\n\n2. 一天三次。\n\n3. 这是第一次。', 15),

('hsk1_016', 1, '从', 'cóng', 'from', 'from', 'မှ', '1. 我从中国来。\n\n2. 从这里走。\n\n3. 他从八点工作。', 16),

('hsk1_017', 1, '打电话', 'dǎ diàn huà', 'make phone call', 'make phone call', 'ဖုန်းခေါ်', '1. 我给妈妈打电话。\n\n2. 请打电话给我。\n\n3. 他在打电话。', 17),

('hsk1_018', 1, '大', 'dà', 'big/large', 'big', 'ကြီး', '1. 这间房子很大。\n\n2. 他有一个大书包。\n\n3. 北京是个大城市。', 18),

('hsk1_019', 1, '的', 'de', 'possessive particle', 'of', 'ရဲ့', '1. 这是我的书。\n\n2. 他是我的朋友。\n\n3. 中国的首都是北京。', 19),

('hsk1_020', 1, '地', 'dì', 'ground/earth', 'earth', 'မြေ', '1. 地很干净。\n\n2. 请坐在地上。\n\n3. 地上有水。', 20);

-- Show results
SELECT 'Import completed!' as message;
SELECT COUNT(*) as total_hsk1_words FROM vocabulary WHERE hsk_level = 1;

-- Show sample data
SELECT 'Sample HSK 1 words (Chinese-only examples):' as info;
SELECT vocab_id, hanzi, pinyin, meaning_en, example 
FROM vocabulary WHERE hsk_level = 1 ORDER BY sort_order LIMIT 5;
