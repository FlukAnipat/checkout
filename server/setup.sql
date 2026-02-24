-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 24, 2026 at 09:03 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `shwe_flash_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `daily_goals`
--

CREATE TABLE `daily_goals` (
  `id` int(11) NOT NULL,
  `user_id` varchar(100) NOT NULL,
  `goal_date` date NOT NULL,
  `target_cards` int(11) NOT NULL DEFAULT 10,
  `completed_cards` int(11) NOT NULL DEFAULT 0,
  `is_completed` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `daily_goals`
--

INSERT INTO `daily_goals` (`id`, `user_id`, `goal_date`, `target_cards`, `completed_cards`, `is_completed`, `created_at`, `updated_at`) VALUES
(83, '932a6a9d-0583-4122-a8d4-8d1d7ebf35e1', '2026-02-24', 10, 8, 0, '2026-02-24 12:38:46', '2026-02-24 12:38:48');

-- --------------------------------------------------------

--
-- Table structure for table `learning_sessions`
--

CREATE TABLE `learning_sessions` (
  `id` int(11) NOT NULL,
  `user_id` varchar(100) NOT NULL,
  `session_date` date NOT NULL,
  `learned_cards` int(11) NOT NULL DEFAULT 0,
  `minutes_spent` int(11) NOT NULL DEFAULT 0,
  `hsk_level` tinyint(4) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` varchar(100) NOT NULL,
  `user_id` varchar(100) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` varchar(10) NOT NULL DEFAULT 'MMK',
  `payment_method` varchar(50) NOT NULL,
  `promo_code` varchar(50) DEFAULT NULL,
  `status` enum('pending','completed','failed') NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`payment_id`, `user_id`, `amount`, `currency`, `payment_method`, `promo_code`, `status`, `created_at`) VALUES
('3b69596a-58f8-4e48-a12f-6405d7e5b2d5', '932a6a9d-0583-4122-a8d4-8d1d7ebf35e1', 18000.00, 'MMK', 'kbzpay', NULL, 'completed', '2026-02-24 12:38:23'),
('a225f044-9b39-49be-967f-4cc933517011', '02a07451-4aca-4d95-a55e-be25414e1263', 16200.00, 'MMK', 'kbzpay', 'TOM2026', 'completed', '2026-02-24 02:52:57');

-- --------------------------------------------------------

--
-- Table structure for table `promo_codes`
--

CREATE TABLE `promo_codes` (
  `code` varchar(50) NOT NULL,
  `discount_percent` decimal(5,2) NOT NULL DEFAULT 10.00,
  `max_uses` int(11) DEFAULT 100,
  `used_count` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `promo_codes`
--

INSERT INTO `promo_codes` (`code`, `discount_percent`, `max_uses`, `used_count`, `created_at`, `expires_at`) VALUES
('EARLYBIRD', 20.00, 30, 0, '2026-02-24 01:30:59', '2025-06-30 23:59:59'),
('LAUNCH2024', 15.00, 50, 0, '2026-02-24 01:30:59', '2025-12-31 23:59:59'),
('STUDENT10', 10.00, 100, 0, '2026-02-24 01:30:59', '2025-12-31 23:59:59'),
('TOM2026', 10.00, 1, 1, '2026-02-24 01:30:59', '2026-12-31 23:59:59');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `country_code` varchar(10) NOT NULL DEFAULT '+95',
  `is_paid` tinyint(1) NOT NULL DEFAULT 0,
  `promo_code_used` varchar(50) DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `email`, `password`, `first_name`, `last_name`, `phone`, `country_code`, `is_paid`, `promo_code_used`, `paid_at`, `created_at`, `updated_at`) VALUES
('02a07451-4aca-4d95-a55e-be25414e1263', 'test@gmail.com', '$2a$10$B59nw3dGtqMGxK0NdWzEXeUvx1LQoR0u1eiApYzTe3WzFhRA38Ziy', 'Test', 'Admin', '123456789', '+66', 1, 'TOM2026', '2026-02-23 19:52:57', '2026-02-24 02:52:00', '2026-02-24 02:52:57'),
('815fd365-9623-4dee-9d10-d9ef2000dc62', 'admin@gmail.com', '$2a$10$A6iBaY9RJ6OvN6kjQjFZie0gxaBa17.4nCzls6JeJwz2tQEopOnKW', 'Fluk', 'Admin', '0656172990', '+66', 0, NULL, NULL, '2026-02-24 02:04:40', '2026-02-24 02:04:40'),
('932a6a9d-0583-4122-a8d4-8d1d7ebf35e1', 'tom@gmail.com', '$2a$10$eeDRaA5q1ZzLs2gNQ.vQQekIiChTi3YO.9I83lJNbv4g48AtFXYi2', 'Tom', 'Test', '123456789', '+66', 1, NULL, '2026-02-24 05:38:23', '2026-02-24 12:31:58', '2026-02-24 12:38:23');

-- --------------------------------------------------------

--
-- Table structure for table `user_achievements`
--

CREATE TABLE `user_achievements` (
  `id` int(11) NOT NULL,
  `user_id` varchar(100) NOT NULL,
  `achievement_key` varchar(50) NOT NULL,
  `unlocked_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_saved_words`
--

CREATE TABLE `user_saved_words` (
  `id` int(11) NOT NULL,
  `user_id` varchar(100) NOT NULL,
  `vocab_id` varchar(20) NOT NULL,
  `saved_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_saved_words`
--

INSERT INTO `user_saved_words` (`id`, `user_id`, `vocab_id`, `saved_at`) VALUES
(33, '932a6a9d-0583-4122-a8d4-8d1d7ebf35e1', 'hsk1_007', '2026-02-24 12:38:50'),
(35, '932a6a9d-0583-4122-a8d4-8d1d7ebf35e1', 'hsk1_009', '2026-02-24 12:38:50');

-- --------------------------------------------------------

--
-- Table structure for table `user_settings`
--

CREATE TABLE `user_settings` (
  `user_id` varchar(100) NOT NULL,
  `app_language` enum('english','burmese','englishAndBurmese') NOT NULL DEFAULT 'english',
  `current_hsk_level` tinyint(4) NOT NULL DEFAULT 1,
  `daily_goal_target` int(11) NOT NULL DEFAULT 10,
  `is_shuffle_mode` tinyint(1) NOT NULL DEFAULT 0,
  `notification_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `reminder_time` time DEFAULT '09:00:00',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_word_status`
--

CREATE TABLE `user_word_status` (
  `id` int(11) NOT NULL,
  `user_id` varchar(100) NOT NULL,
  `vocab_id` varchar(20) NOT NULL,
  `status` enum('skipped','mastered') NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_word_status`
--

INSERT INTO `user_word_status` (`id`, `user_id`, `vocab_id`, `status`, `updated_at`) VALUES
(369, '932a6a9d-0583-4122-a8d4-8d1d7ebf35e1', 'hsk1_001', 'mastered', '2026-02-24 12:38:46'),
(371, '932a6a9d-0583-4122-a8d4-8d1d7ebf35e1', 'hsk1_002', 'mastered', '2026-02-24 12:38:47'),
(376, '932a6a9d-0583-4122-a8d4-8d1d7ebf35e1', 'hsk1_009', 'skipped', '2026-02-24 12:38:52');

-- --------------------------------------------------------

--
-- Table structure for table `vocabulary`
--

CREATE TABLE `vocabulary` (
  `vocab_id` varchar(20) NOT NULL,
  `hsk_level` tinyint(4) NOT NULL,
  `hanzi` varchar(50) NOT NULL,
  `pinyin` varchar(100) NOT NULL,
  `meaning` varchar(255) NOT NULL DEFAULT '',
  `meaning_en` varchar(255) NOT NULL DEFAULT '',
  `meaning_my` varchar(255) NOT NULL DEFAULT '',
  `example` text DEFAULT NULL,
  `audio_asset` varchar(255) DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `vocabulary`
--

INSERT INTO `vocabulary` (`vocab_id`, `hsk_level`, `hanzi`, `pinyin`, `meaning`, `meaning_en`, `meaning_my`, `example`, `audio_asset`, `sort_order`) VALUES
('h2_001', 2, '帮助', 'bāng zhù', 'Help; Assist', 'to help; to assist', 'ကူညီသည်', '请帮助我学习汉语。(Please help me learn Chinese.)', 'assets/audio/hsk2/bangzhu.mp3', 1),
('h2_002', 2, '报纸', 'bào zhǐ', 'Newspaper', 'newspaper', 'သတင်းစာ', '他在看报纸。(He is reading a newspaper.)', 'assets/audio/hsk2/baozhi.mp3', 2),
('h2_003', 2, '比', 'bǐ', 'Comparison marker; Than', 'than; to compare', 'ထက် (နှိုင်းယှဉ်)', '你比我高。(You are taller than me.)', 'assets/audio/hsk2/bi.mp3', 3),
('h2_004', 2, '宾馆', 'bīn guǎn', 'Hotel', 'hotel', 'ဟိုတယ်', '我们住在那个宾馆。(We live in that hotel.)', 'assets/audio/hsk2/binguan.mp3', 4),
('h2_005', 2, '长', 'cháng', 'Long', 'long', 'ရှည်သည်', '这条路很长。(This road is very long.)', 'assets/audio/hsk2/chang.mp3', 5),
('h2_006', 2, '唱歌', 'chàng gē', 'Sing', 'to sing', 'သီချင်းဆိုသည်', '她喜欢唱歌。(She likes to sing.)', 'assets/audio/hsk2/changge.mp3', 6),
('h2_007', 2, '出', 'chū', 'Go out; Exit', 'to go out; to exit', 'ထွက်သည်', '他走出房间。(He walked out of the room.)', 'assets/audio/hsk2/chu.mp3', 7),
('h2_008', 2, '穿', 'chuān', 'Wear; Put on', 'to wear; to put on', 'ဝတ်သည်', '天冷了，多穿点衣服。(It\'s cold, put on more clothes.)', 'assets/audio/hsk2/chuan.mp3', 8),
('h2_009', 2, '次', 'cì', 'Time (occurrence)', 'time (occurrence)', 'ကြိမ်', '我去过一次中国。(I have been to China once.)', 'assets/audio/hsk2/ci.mp3', 9),
('h2_010', 2, '从', 'cóng', 'From', 'from', 'မှ', '从这里到那里很远。(It is far from here to there.)', 'assets/audio/hsk2/cong.mp3', 10),
('h2_011', 2, '错', 'cuò', 'Wrong; Mistake', 'wrong; mistake', 'မှား', '对不起，我错了。(Sorry, I was wrong.)', 'assets/audio/hsk2/cuo.mp3', 11),
('h2_012', 2, '打篮球', 'dǎ lán qiú', 'Play basketball', 'to play basketball', 'ဘတ်စကက်ဘော ကစားသည်', '周末我们去打篮球吧。(Let\'s play basketball this weekend.)', 'assets/audio/hsk2/dalanqiu.mp3', 12),
('h2_013', 2, '大家', 'dà jiā', 'Everyone; All', 'everyone; all', 'အားလုံး', '大家好！(Hello everyone!)', 'assets/audio/hsk2/dajia.mp3', 13),
('h2_014', 2, '到', 'dào', 'Arrive; To', 'to arrive; to', 'ရောက်သည်', '我到家了。(I have arrived home.)', 'assets/audio/hsk2/dao.mp3', 14),
('h2_015', 2, '等', 'děng', 'Wait', 'to wait', 'စောင့်သည်', '请等一下。(Please wait a moment.)', 'assets/audio/hsk2/deng.mp3', 15),
('h2_016', 2, '弟弟', 'dì di', 'Younger brother', 'younger brother', 'ညီ', '我有一个弟弟。(I have a younger brother.)', 'assets/audio/hsk2/didi.mp3', 16),
('h2_017', 2, '第一', 'dì yī', 'First', 'first', 'ပထမ', '这是我第一次来这里。(This is my first time here.)', 'assets/audio/hsk2/diyi.mp3', 17),
('h2_018', 2, '懂', 'dǒng', 'Understand', 'to understand', 'နားလည်သည်', '你听懂了吗？(Did you understand?)', 'assets/audio/hsk2/dong.mp3', 18),
('h2_019', 2, '对', 'duì', 'Right; Correct', 'right; correct', 'မှန်သည်', '你说的对。(What you said is correct.)', 'assets/audio/hsk2/dui.mp3', 19),
('h2_020', 2, '房间', 'fáng jiān', 'Room', 'room', 'အခန်း', '这个房间很大。(This room is very big.)', 'assets/audio/hsk2/fangjian.mp3', 20),
('h2_186', 2, '喜欢', 'xǐ huān', 'ชอบ', 'to like', 'ကြိုက်သည်', '我喜欢吃中国菜。', 'assets/audio/hsk2/xihuan.mp3', 21),
('h2_187', 2, '知道', 'zhī dào', 'รู้', 'to know', 'သိသည်', '我知道这个字。', 'assets/audio/hsk2/zhidao.mp3', 22),
('h2_188', 2, '时间', 'shí jiān', 'เวลา', 'time', 'အချိန်', '现在是什么时间？', 'assets/audio/hsk2/shijian.mp3', 23),
('h2_189', 2, '工作', 'gōng zuò', 'งาน', 'work; job', 'အလုပ်', '我在一家公司工作。', 'assets/audio/hsk2/gongzuo.mp3', 24),
('h2_190', 2, '学习', 'xué xí', 'เรียน', 'to study', 'လေ့လာသည်', '我学习中文三年了。', 'assets/audio/hsk2/xuexi.mp3', 25),
('h2_191', 2, '生活', 'shēng huó', 'ชีวิต', 'life', 'ဘဝ', '北京的生活很精彩。', 'assets/audio/hsk2/shenghuo.mp3', 26),
('h2_192', 2, '公司', 'gōng sī', 'บริษัท', 'company', 'ကုမ္ပဏီ', '我在一家大公司工作。', 'assets/audio/hsk2/gongsi.mp3', 27),
('h2_193', 2, '产品', 'chǎn pǐn', 'สินค้า', 'product', 'ကုန်ပစ္စည်း', '这个产品质量很好。', 'assets/audio/hsk2/chanpin.mp3', 28),
('h2_194', 2, '服务', 'fú wù', 'บริการ', 'service', 'ဝန်ဆောင်မှု', '客户服务很重要。', 'assets/audio/hsk2/fuwu.mp3', 29),
('h2_195', 2, '价格', 'jià gé', 'ราคา', 'price', 'စျေးနှုန်း', '这个价格很合理。', 'assets/audio/hsk2/jiage.mp3', 30),
('h2_196', 2, '市场', 'shì chǎng', 'ตลาด', 'market', 'ဈေး', '我们去市场买菜。', 'assets/audio/hsk2/shichang.mp3', 31),
('h2_197', 2, '客户', 'kè hù', 'ลูกค้า', 'customer; client', 'ဖောက်သည်', '客户很满意。', 'assets/audio/hsk2/kehu.mp3', 32),
('h2_198', 2, '项目', 'xiàng mù', 'โครงการ', 'project', 'ပရောဂျက်', '这个项目很重要。', 'assets/audio/hsk2/xiangmu.mp3', 33),
('h2_199', 2, '计划', 'jì huà', 'แผนการ', 'plan', 'အစီအစဉ်', '我们有一个新计划。', 'assets/audio/hsk2/jihua.mp3', 34),
('h2_200', 2, '报告', 'bào gào', 'รายงาน', 'report', 'အစီရင်ခံစာ', '请写一份报告。', 'assets/audio/hsk2/baogao.mp3', 35),
('h3_001', 3, '阿姨', 'ā yí', 'Aunt', 'aunt; auntie', 'အဒေါ်', '阿姨，您好！(Hello, Auntie!)', 'assets/audio/hsk3/ayi.mp3', 1),
('h3_002', 3, '啊', 'a', 'Particle (ah!)', 'ah; particle', 'အော်', '啊，多么漂亮的花！(Ah, what a beautiful flower!)', 'assets/audio/hsk3/a.mp3', 2),
('h3_003', 3, '矮', 'ǎi', 'Short (height)', 'short (height)', 'ပုသည်', '他个子很矮。(He is very short.)', 'assets/audio/hsk3/ai.mp3', 3),
('h3_004', 3, '爱好', 'ài hào', 'Hobby', 'hobby; interest', 'ဝါသနာ', '我的爱好是看书。(My hobby is reading books.)', 'assets/audio/hsk3/aihao.mp3', 4),
('h3_005', 3, '安静', 'ān jìng', 'Quiet', 'quiet; peaceful', 'တိတ်ဆိတ်သည်', '请安静。(Please be quiet.)', 'assets/audio/hsk3/anjing.mp3', 5),
('h3_006', 3, '把', 'bǎ', 'Disposal marker', 'disposal marker (grammar)', 'ကို (သဒ္ဒါ)', '请把门关上。(Please close the door.)', 'assets/audio/hsk3/ba.mp3', 6),
('h3_007', 3, '班', 'bān', 'Class', 'class; team', 'အတန်း', '我们在同一个班。(We are in the same class.)', 'assets/audio/hsk3/ban.mp3', 7),
('h3_008', 3, '搬', 'bān', 'To move (objects)', 'to move; to carry', 'ရွှေ့သည်', '请帮我搬一下桌子。(Please help me move the table.)', 'assets/audio/hsk3/ban.mp3', 8),
('h3_009', 3, '半', 'bàn', 'Half', 'half', 'တဝက်', '现在两点半。(It is half past two now.)', 'assets/audio/hsk3/ban.mp3', 9),
('h3_010', 3, '办法', 'bàn fǎ', 'Method; Way', 'method; way; solution', 'နည်းလမ်း', '这是一个好办法。(This is a good method.)', 'assets/audio/hsk3/banfa.mp3', 10),
('h3_011', 3, '办公室', 'bàn gōng shì', 'Office', 'office', 'ရုံးခန်း', '他在办公室工作。(He works in the office.)', 'assets/audio/hsk3/bangongshi.mp3', 11),
('h3_012', 3, '帮忙', 'bāng máng', 'To help', 'to help; to lend a hand', 'ကူညီသည်', '我需要你的帮忙。(I need your help.)', 'assets/audio/hsk3/bangmang.mp3', 12),
('h3_013', 3, '包', 'bāo', 'Bag', 'bag; package', 'အိတ်', '我的包在哪里？(Where is my bag?)', 'assets/audio/hsk3/bao.mp3', 13),
('h3_014', 3, '饱', 'bǎo', 'Full (eating)', 'full (from eating)', 'ဝသည်', '我吃饱了。(I am full.)', 'assets/audio/hsk3/bao.mp3', 14),
('h3_015', 3, '北方', 'běi fāng', 'North', 'north; northern region', 'မြောက်ဘက်', '他是北方人。(He is from the north.)', 'assets/audio/hsk3/beifang.mp3', 15),
('h3_016', 3, '被', 'bèi', 'Passive marker', 'passive marker (by)', 'ခံရသည် (သဒ္ဒါ)', '书被借走了。(The book was borrowed.)', 'assets/audio/hsk3/bei.mp3', 16),
('h3_017', 3, '鼻子', 'bí zi', 'Nose', 'nose', 'နှာခေါင်း', '他的鼻子很高。(His nose is high/tall.)', 'assets/audio/hsk3/bizi.mp3', 17),
('h3_018', 3, '比较', 'bǐ jiào', 'Compare; Relatively', 'to compare; relatively', 'နှိုင်းယှဉ်သည်', '今天比较冷。(It is relatively cold today.)', 'assets/audio/hsk3/bijiao.mp3', 18),
('h3_019', 3, '比赛', 'bǐ sài', 'Match; Competition', 'match; competition', 'ပြိုင်ပွဲ', '我们赢了比赛。(We won the match.)', 'assets/audio/hsk3/bisai.mp3', 19),
('h3_020', 3, '必须', 'bì xū', 'Must', 'must; have to', 'ရမည်', '我必须走了。(I must go now.)', 'assets/audio/hsk3/bixu.mp3', 20),
('h3_186', 3, '环境', 'huán jìng', 'สภาพแวดล้อม', 'environment', 'ပတ်ဝန်းကျင်', '保护环境很重要。', 'assets/audio/hsk3/huanjing.mp3', 21),
('h3_187', 3, '经济', 'jīng jì', 'เศรษฐกิจ', 'economy; economics', 'စီးပွားရေး', '经济发展很快。', 'assets/audio/hsk3/jingji.mp3', 22),
('h3_188', 3, '文化', 'wén huà', 'วัฒนธรรม', 'culture', 'ယဉ်ကျေးမှု', '中国文化很有意思。', 'assets/audio/hsk3/wenhua.mp3', 23),
('h3_189', 3, '社会', 'shè huì', 'สังคม', 'society', 'လူ့အဖွဲ့အစည်း', '社会在进步。', 'assets/audio/hsk3/shehui.mp3', 24),
('h3_190', 3, '技术', 'jì shù', 'เทคโนโลยี', 'technology; technique', 'နည်းပညာ', '现代技术改变了生活。', 'assets/audio/hsk3/jishu.mp3', 25),
('h3_191', 3, '教育', 'jiào yù', 'การศึกษา', 'education', 'ပညာရေး', '教育是国家的根本。', 'assets/audio/hsk3/jiaoyu.mp3', 26),
('h3_192', 3, '健康', 'jiàn kāng', 'สุขภาพ', 'health; healthy', 'ကျန်းမာရေး', '健康是最重要的。', 'assets/audio/hsk3/jiankang.mp3', 27),
('h3_193', 3, '交通', 'jiāo tōng', 'การจราจร', 'traffic; transportation', 'ယာဉ်သွားလာရေး', '北京的交通很方便。', 'assets/audio/hsk3/jiaotong.mp3', 28),
('h3_194', 3, '发展', 'fā zhǎn', 'การพัฒนา', 'development; to develop', 'ဖွံ့ဖြိုးရေး', '中国发展很快。', 'assets/audio/hsk3/fazhan.mp3', 29),
('h3_195', 3, '影响', 'yǐng xiǎng', 'ผลกระทบ', 'influence; to affect', 'သက်ရောက်မှု', '这个决定影响很大。', 'assets/audio/hsk3/yingxiang.mp3', 30),
('h3_196', 3, '提高', 'tí gāo', 'ปรับปรุง/เพิ่ม', 'to improve; to raise', 'မြှင့်တင်သည်', '我们需要提高质量。', 'assets/audio/hsk3/tigao.mp3', 31),
('h3_197', 3, '降低', 'jiàng dī', 'ลดลง', 'to reduce; to lower', 'လျှော့ချသည်', '成本降低了。', 'assets/audio/hsk3/jiangdi.mp3', 32),
('h3_198', 3, '增加', 'zēng jiā', 'เพิ่มขึ้น', 'to increase; to add', 'တိုးသည်', '收入增加了。', 'assets/audio/hsk3/zengjia.mp3', 33),
('h3_199', 3, '减少', 'jiǎn shǎo', 'ลดลง', 'to decrease; to reduce', 'လျော့သည်', '费用减少了。', 'assets/audio/hsk3/jianshao.mp3', 34),
('h3_200', 3, '改善', 'gǎi shàn', 'ปรับปรุง', 'to improve; to enhance', 'တိုးတက်စေသည်', '生活改善了。', 'assets/audio/hsk3/gaishan.mp3', 35),
('h3_201', 3, '解决', 'jiě jué', 'แก้ไข', 'to solve; to resolve', 'ဖြေရှင်းသည်', '我们需要解决这个问题。', 'assets/audio/hsk3/jiejue.mp3', 36),
('h3_202', 3, '面对', 'miàn duì', 'เผชิญหน้า', 'to face; to confront', 'ရင်ဆိုင်သည်', '我们要面对挑战。', 'assets/audio/hsk3/miandui.mp3', 37),
('h3_203', 3, '机会', 'jī huì', 'โอกาส', 'opportunity; chance', 'အခွင့်အရေး', '这是一个好机会。', 'assets/audio/hsk3/jihui.mp3', 38),
('h3_204', 3, '挑战', 'tiǎo zhàn', 'ความท้าทาย', 'challenge', 'စိန်ခေါ်မှု', '这是一个大挑战。', 'assets/audio/hsk3/tiaozhan.mp3', 39),
('h4_001', 4, '爱情', 'ài qíng', 'Love (romantic)', 'romantic love', 'အချစ်', '这就是爱情。(This is love.)', 'assets/audio/hsk4/aiqing.mp3', 1),
('h4_002', 4, '安排', 'ān pái', 'Arrange; Plan', 'to arrange; to plan', 'စီစဉ်သည်', '所有的事都安排好了。(Everything has been arranged.)', 'assets/audio/hsk4/anpai.mp3', 2),
('h4_003', 4, '安全', 'ān quán', 'Safe; Safety', 'safe; safety', 'လုံခြုံရေး', '注意安全。(Pay attention to safety.)', 'assets/audio/hsk4/anquan.mp3', 3),
('h4_004', 4, '按时', 'àn shí', 'On time', 'on time; punctually', 'အချိန်မှန်', '请按时完成作业。(Please finish homework on time.)', 'assets/audio/hsk4/anshi.mp3', 4),
('h4_005', 4, '按照', 'àn zhào', 'According to', 'according to', 'အလိုက်', '按照规定，你不能这样做。(According to the rules, you cannot do this.)', 'assets/audio/hsk4/anzhao.mp3', 5),
('h4_006', 4, '百分之', 'bǎi fēn zhī', 'Percent', 'percent', 'ရာခိုင်နှုန်း', '百分之百正确。(One hundred percent correct.)', 'assets/audio/hsk4/baifenzhi.mp3', 6),
('h4_007', 4, '棒', 'bàng', 'Excellent; Great', 'excellent; great', 'အရမ်းကောင်း', '你的汉语真棒！(Your Chinese is excellent!)', 'assets/audio/hsk4/bang.mp3', 7),
('h4_008', 4, '包子', 'bāo zi', 'Steamed bun', 'steamed bun', 'ပေါင်မုန့်ပေါင်း', '我早饭吃了两个包子。(I ate two steamed buns for breakfast.)', 'assets/audio/hsk4/baozi.mp3', 8),
('h4_009', 4, '保护', 'bǎo hù', 'Protect', 'to protect', 'ကာကွယ်သည်', '我们要保护环境。(We need to protect the environment.)', 'assets/audio/hsk4/baohu.mp3', 9),
('h4_010', 4, '保证', 'bǎo zhèng', 'Guarantee', 'to guarantee', 'အာမခံသည်', '我向你保证。(I guarantee it to you.)', 'assets/audio/hsk4/baozheng.mp3', 10),
('h4_011', 4, '抱', 'bào', 'Hug; Hold in arms', 'to hug; to hold', 'ဖက်သည်', '她抱着一只猫。(She is holding a cat.)', 'assets/audio/hsk4/bao.mp3', 11),
('h4_012', 4, '报名', 'bào míng', 'Sign up; Register', 'to sign up; to register', 'စာရင်းပေးသည်', '我想报名参加比赛。(I want to sign up for the competition.)', 'assets/audio/hsk4/baoming.mp3', 12),
('h4_013', 4, '抱歉', 'bào qiàn', 'Sorry; Apologetic', 'sorry; to apologize', 'တောင်းပန်ပါသည်', '非常抱歉。(I am very sorry.)', 'assets/audio/hsk4/baoqian.mp3', 13),
('h4_014', 4, '倍', 'bèi', 'Times (multiplier)', 'times; fold', 'ဆ', '这个是那个的两倍。(This is twice as much as that one.)', 'assets/audio/hsk4/bei.mp3', 14),
('h4_015', 4, '本来', 'běn lái', 'Originally', 'originally', 'မူလ', '我本来不知道这件事。(I originally didn\'t know about this matter.)', 'assets/audio/hsk4/benlai.mp3', 15),
('h4_016', 4, '笨', 'bèn', 'Stupid', 'stupid; foolish', 'လူမိုက်', '我不笨。(I am not stupid.)', 'assets/audio/hsk4/ben.mp3', 16),
('h4_017', 4, '比如', 'bǐ rú', 'For example', 'for example', 'ဥပမာ', '我有很多爱好，比如游泳。(I have many hobbies, for example swimming.)', 'assets/audio/hsk4/biru.mp3', 17),
('h4_018', 4, '毕业', 'bì yè', 'Graduate', 'to graduate', 'ဘွဲ့ရသည်', '他明年毕业。(He will graduate next year.)', 'assets/audio/hsk4/biye.mp3', 18),
('h4_019', 4, '遍', 'biàn', 'Time (all the way through)', 'time (measure word)', 'ကြိမ်', '请再说一遍。(Please say it one more time.)', 'assets/audio/hsk4/bian.mp3', 19),
('h4_020', 4, '标准', 'biāo zhǔn', 'Standard', 'standard', 'စံနှုန်း', '你的发音很标准。(Your pronunciation is very standard.)', 'assets/audio/hsk4/biaozhun.mp3', 20),
('h4_186', 4, '政策', 'zhèng cè', 'นโยบาย', 'policy', 'မူဝါဒ', '政府出台了新政策。', 'assets/audio/hsk4/zhengce.mp3', 21),
('h4_187', 4, '管理', 'guǎn lǐ', 'การจัดการ', 'management; to manage', 'စီမံခန့်ခွဲမှု', '公司管理很规范。', 'assets/audio/hsk4/guanli.mp3', 22),
('h4_188', 4, '质量', 'zhì liàng', 'คุณภาพ', 'quality', 'အရည်အသွေး', '这个产品质量很好。', 'assets/audio/hsk4/zhiliang.mp3', 23),
('h4_189', 4, '效率', 'xiào lǜ', 'ประสิทธิภาพ', 'efficiency', 'စွမ်းဆောင်ရည်', '工作效率提高了。', 'assets/audio/hsk4/xiaolv.mp3', 24),
('h4_190', 4, '投资', 'tóu zī', 'การลงทุน', 'investment; to invest', 'ရင်းနှီးမြှုပ်နှံမှု', '投资有风险。', 'assets/audio/hsk4/touzi.mp3', 25),
('h4_191', 4, '市场', 'shì chǎng', 'ตลาด', 'market', 'ဈေးကွက်', '市场竞争很激烈。', 'assets/audio/hsk4/shichang.mp3', 26),
('h4_192', 4, '服务', 'fú wù', 'บริการ', 'service', 'ဝန်ဆောင်မှု', '客户服务很重要。', 'assets/audio/hsk4/fuwu.mp3', 27),
('h4_193', 4, '系统', 'xì tǒng', 'ระบบ', 'system', 'စနစ်', '我们需要改进系统。', 'assets/audio/hsk4/xitong.mp3', 28),
('h4_194', 4, '分析', 'fēn xī', 'การวิเคราะห์', 'analysis; to analyze', 'ခွဲခြမ်းစိတ်ဖြာမှု', '数据分析很重要。', 'assets/audio/hsk4/fenxi.mp3', 29),
('h4_195', 4, '策略', 'cè lüè', 'กลยุทธ์', 'strategy', 'နည်းဗျူဟာ', '公司制定了新策略。', 'assets/audio/hsk4/celue.mp3', 30),
('h4_196', 4, '竞争', 'jìng zhēng', 'การแข่งขัน', 'competition', 'ယှဉ်ပြိုင်မှု', '市场竞争很激烈。', 'assets/audio/hsk4/jingzheng.mp3', 31),
('h4_197', 4, '合作', 'hé zuò', 'ความร่วมมือ', 'cooperation', 'ပူးပေါင်းဆောင်ရွက်မှု', '我们需要加强合作。', 'assets/audio/hsk4/hezuo.mp3', 32),
('h4_198', 4, '创新', 'chuàng xīn', 'นวัตกรรม', 'innovation', 'ဆန်းသစ်တီထွင်မှု', '创新推动发展。', 'assets/audio/hsk4/chuangxin.mp3', 33),
('h4_199', 4, '改革', 'gǎi gé', 'การปฏิรูป', 'reform', 'ပြုပြင်ပြောင်းလဲရေး', '改革带来变化。', 'assets/audio/hsk4/gaige.mp3', 34),
('h4_200', 4, '转型', 'zhuǎn xíng', 'การเปลี่ยนแปลง', 'transformation', 'အသွင်ပြောင်းမှု', '企业正在转型。', 'assets/audio/hsk4/zhuanxing.mp3', 35),
('h4_201', 4, '优化', 'yōu huà', 'การ优化', 'optimization', 'အကောင်းဆုံးဖြစ်အောင်ပြုလုပ်မှု', '我们需要优化流程。', 'assets/audio/hsk4/youhua.mp3', 36),
('h4_202', 4, '整合', 'zhěng hé', 'การรวมกัน', 'integration', 'ပေါင်းစည်းမှု', '整合资源很重要。', 'assets/audio/hsk4/zhenghe.mp3', 37),
('h4_203', 4, '协调', 'xié tiáo', 'การประสาน', 'coordination', 'ညှိနှိုင်းမှု', '各部门需要协调。', 'assets/audio/hsk4/xietiao.mp3', 38),
('h4_204', 4, '监督', 'jiān dū', 'การดูแล', 'supervision', 'ကြီးကြပ်မှု', '政府监督市场。', 'assets/audio/hsk4/jiandu.mp3', 39),
('h4_205', 4, '执行', 'zhí xíng', 'การดำเนินการ', 'execution; to execute', 'အကောင်အထည်ဖော်မှု', '严格执行规定。', 'assets/audio/hsk4/zhixing.mp3', 40),
('h4_206', 4, '评估', 'píng gū', 'การประเมิน', 'evaluation', 'အကဲဖြတ်မှု', '定期评估绩效。', 'assets/audio/hsk4/pinggu.mp3', 41),
('h4_207', 4, '预测', 'yù cè', 'การพยากรณ์', 'prediction; to predict', 'ခန့်မှန်းချက်', '预测市场趋势。', 'assets/audio/hsk4/yuce.mp3', 42),
('h5_001', 5, '唉', 'āi', 'Sigh', 'sigh; alas', 'သက်ပြင်းချသံ', '唉，真倒霉！(Sigh, such bad luck!)', 'assets/audio/hsk5/ai.mp3', 1),
('h5_002', 5, '爱护', 'ài hù', 'Cherish; Take care of', 'to cherish; to take care of', 'တန်ဖိုးထားသည်', '爱护公物。(Take care of public property.)', 'assets/audio/hsk5/aihu.mp3', 2),
('h5_003', 5, '爱惜', 'ài xī', 'Value; Cherish', 'to value; to cherish', 'မြတ်နိုးသည်', '我们要爱惜时间。(We must cherish time.)', 'assets/audio/hsk5/aixi.mp3', 3),
('h5_004', 5, '爱心', 'ài xīn', 'Compassion; Love', 'compassion; love', 'သနားကြင်နာမှု', '她很有爱心。(She is very compassionate.)', 'assets/audio/hsk5/aixin.mp3', 4),
('h5_005', 5, '安慰', 'ān wèi', 'Comfort; Console', 'to comfort; to console', 'နှစ်သိမ့်သည်', '请去安慰一下她。(Please go and comfort her.)', 'assets/audio/hsk5/anwei.mp3', 5),
('h5_006', 5, '安装', 'ān zhuāng', 'Install', 'to install', 'တပ်ဆင်သည်', '安装软件。(Install software.)', 'assets/audio/hsk5/anzhuang.mp3', 6),
('h5_007', 5, '岸', 'àn', 'Bank; Shore', 'bank; shore', 'ကမ်းခြေ', '船靠岸了。(The boat docked at the shore.)', 'assets/audio/hsk5/an.mp3', 7),
('h5_008', 5, '把握', 'bǎ wò', 'Grasp; Assurance', 'to grasp; confidence', 'ယုံကြည်မှု', '我有把握通过考试。(I am confident I will pass the exam.)', 'assets/audio/hsk5/bawo.mp3', 8),
('h5_009', 5, '摆', 'bǎi', 'Place; Put', 'to place; to put', 'ချထားသည်', '桌子上摆着花。(Flowers are placed on the table.)', 'assets/audio/hsk5/bai.mp3', 9),
('h5_010', 5, '班主任', 'bān zhǔ rèn', 'Homeroom teacher', 'homeroom teacher', 'အတန်းပိုင်ဆရာ', '他是我们的班主任。(He is our homeroom teacher.)', 'assets/audio/hsk5/banzhuren.mp3', 10),
('h5_011', 5, '办理', 'bàn lǐ', 'Handle; Conduct', 'to handle; to process', 'လုပ်ဆောင်သည်', '办理签证。(Process a visa.)', 'assets/audio/hsk5/banli.mp3', 11),
('h5_012', 5, '棒', 'bàng', 'Stick; Club', 'stick; club', 'တုတ်', '木棒。(Wooden stick.)', 'assets/audio/hsk5/bang.mp3', 12),
('h5_013', 5, '傍晚', 'bàng wǎn', 'Evening; Dusk', 'evening; dusk', 'နေဝင်ချိန်', '傍晚时分。(At dusk.)', 'assets/audio/hsk5/bangwan.mp3', 13),
('h5_014', 5, '包含', 'bāo hán', 'Contain; Include', 'to contain; to include', 'ပါဝင်သည်', '费用包含了早餐。(The price includes breakfast.)', 'assets/audio/hsk5/baohan.mp3', 14),
('h5_015', 5, '包裹', 'bāo guǒ', 'Package; Parcel', 'package; parcel', 'ပါဆယ်', '寄包裹。(Send a package.)', 'assets/audio/hsk5/baoguo.mp3', 15),
('h5_016', 5, '薄', 'báo', 'Thin', 'thin', 'ပါးသည်', '这张纸很薄。(This paper is very thin.)', 'assets/audio/hsk5/bao.mp3', 16),
('h5_017', 5, '宝贝', 'bǎo bèi', 'Treasure; Baby', 'treasure; baby', 'ရတနာ', '你是我的宝贝。(You are my treasure.)', 'assets/audio/hsk5/baobei.mp3', 17),
('h5_018', 5, '宝贵', 'bǎo guì', 'Valuable; Precious', 'valuable; precious', 'တန်ဖိုးကြီးသော', '宝贵的意见。(Valuable suggestions.)', 'assets/audio/hsk5/baogui.mp3', 18),
('h5_019', 5, '保持', 'bǎo chí', 'Maintain; Keep', 'to maintain; to keep', 'ထိန်းသိမ်းသည်', '保持安静。(Keep quiet.)', 'assets/audio/hsk5/baochi.mp3', 19),
('h5_020', 5, '保存', 'bǎo cún', 'Preserve; Save', 'to preserve; to save', 'သိမ်းဆည်းသည်', '保存文件。(Save the file.)', 'assets/audio/hsk5/baocun.mp3', 20),
('h5_186', 5, '理论', 'lǐ lùn', 'ทฤษฎี', 'theory', 'သီအိုရီ', '这个理论很有影响力。', 'assets/audio/hsk5/lilun.mp3', 21),
('h5_187', 5, '实践', 'shí jiàn', 'การปฏิบัติ', 'practice', 'အလေ့အကျင့်', '理论要与实践相结合。', 'assets/audio/hsk5/shijian.mp3', 22),
('h5_188', 5, '哲学', 'zhé xué', 'ปรัชญา', 'philosophy', 'ဒဿနိကဗေဒ', '哲学思考很有意思。', 'assets/audio/hsk5/zhexue.mp3', 23),
('h5_189', 5, '心理学', 'xīn lǐ xué', 'จิตวิทยา', 'psychology', 'စိတ်ပညာ', '心理学研究人类行为。', 'assets/audio/hsk5/xinlixue.mp3', 24),
('h5_190', 5, '社会学', 'shè huì xué', 'สังคมวิทยา', 'sociology', 'လူမှုဗေဒ', '社会学分析社会现象。', 'assets/audio/hsk5/shehuixue.mp3', 25),
('h5_191', 5, '人类学', 'rén lèi xué', 'มานุษยวิทยา', 'anthropology', 'မနုဿဗေဒ', '人类学研究人类文化。', 'assets/audio/hsk5/renleixue.mp3', 26),
('h5_192', 5, '历史学', 'lì shǐ xué', 'ประวัติศาสตร์', 'history', 'သမိုင်းပညာ', '历史学研究过去的事件。', 'assets/audio/hsk5/lishixue.mp3', 27),
('h5_193', 5, '地理学', 'dì lǐ xué', 'ภูมิศาสตร์', 'geography', 'ပထဝီဝင်', '地理学研究地球表面。', 'assets/audio/hsk5/dilixue.mp3', 28),
('h5_194', 5, '政治学', 'zhèng zhì xué', 'รัฐศาสตร์', 'political science', 'နိုင်ငံရေးသိပ္ပံ', '政治学研究政治制度。', 'assets/audio/hsk5/zhengzhixue.mp3', 29),
('h5_195', 5, '经济学', 'jīng jì xué', 'เศรษฐศาสตร์', 'economics', 'စီးပွားရေးပညာ', '经济学研究资源配置。', 'assets/audio/hsk5/jingjixue.mp3', 30),
('h5_196', 5, '文学', 'wén xué', 'วรรณกรรม', 'literature', 'စာပေ', '中国文学历史悠久。', 'assets/audio/hsk5/wenxue.mp3', 31),
('h5_197', 5, '艺术', 'yì shù', 'ศิลปะ', 'art', 'အနုပညာ', '艺术来源于生活。', 'assets/audio/hsk5/yishu.mp3', 32),
('h5_198', 5, '哲学', 'zhé xué', 'ปรัชญา', 'philosophy', 'ဒဿနိကဗေဒ', '哲学思考人生。', 'assets/audio/hsk5/zhexue2.mp3', 33),
('h5_199', 5, '心理学', 'xīn lǐ xué', 'จิตวิทยา', 'psychology', 'စိတ်ပညာ', '心理学研究行为。', 'assets/audio/hsk5/xinlixue2.mp3', 34),
('h5_200', 5, '社会学', 'shè huì xué', 'สังคมวิทยา', 'sociology', 'လူမှုဗေဒ', '社会学分析社会。', 'assets/audio/hsk5/shehuixue2.mp3', 35),
('h5_201', 5, '人类学', 'rén lèi xué', 'มานุษยวิทยา', 'anthropology', 'မနုဿဗေဒ', '人类学研究文化。', 'assets/audio/hsk5/renleixue2.mp3', 36),
('h5_202', 5, '历史学', 'lì shǐ xué', 'ประวัติศาสตร์', 'history', 'သမိုင်းပညာ', '历史学研究过去。', 'assets/audio/hsk5/lishixue2.mp3', 37),
('h5_203', 5, '地理学', 'dì lǐ xué', 'ภูมิศาสตร์', 'geography', 'ပထဝီဝင်', '地理学研究地球。', 'assets/audio/hsk5/dilixue2.mp3', 38),
('h5_204', 5, '政治学', 'zhèng zhì xué', 'รัฐศาสตร์', 'political science', 'နိုင်ငံရေးသိပ္ပံ', '政治学研究权力。', 'assets/audio/hsk5/zhengzhixue2.mp3', 39),
('h5_205', 5, '经济学', 'jīng jì xué', 'เศรษฐศาสตร์', 'economics', 'စီးပွားရေးပညာ', '经济学研究资源。', 'assets/audio/hsk5/jingjixue2.mp3', 40),
('h5_206', 5, '法学', 'fǎ xué', 'นิติศาสตร์', 'law', 'ဥပဒေပညာ', '法学研究法律。', 'assets/audio/hsk5/faxue.mp3', 41),
('h5_207', 5, '医学', 'yī xué', 'แพทยศาสตร์', 'medicine', 'ဆေးပညာ', '医学研究疾病。', 'assets/audio/hsk5/yixue.mp3', 42),
('h5_208', 5, '工程学', 'gōng chéng xué', 'วิศวกรรมศาสตร์', 'engineering', 'အင်ဂျင်နီယာပညာ', '工程学应用技术。', 'assets/audio/hsk5/gongchengxue.mp3', 43),
('h5_209', 5, '计算机科学', 'jì suàn jī kē xué', 'วิทยาการคอมพิวเตอร์', 'computer science', 'ကွန်ပျူတာသိပ္ပံ', '计算机科学研究算法。', 'assets/audio/hsk5/jisuanjikexue.mp3', 44),
('h5_210', 5, '环境科学', 'huán jìng kē xué', 'วิทยาศาสตร์สิ่งแวดล้อม', 'environmental science', 'ပတ်ဝန်းကျင်သိပ္ပံ', '环境科学研究污染。', 'assets/audio/hsk5/huanjingkexue.mp3', 45),
('h6_001', 6, '哎哟', 'āi yō', 'Ouch; Oh dear', 'ouch; oh dear', 'အို', '哎哟，好疼！(Ouch, it hurts!)', 'assets/audio/hsk6/aiyo.mp3', 1),
('h6_002', 6, '癌症', 'ái zhèng', 'Cancer', 'cancer', 'ကင်ဆာ', '治疗癌症。(Treat cancer.)', 'assets/audio/hsk6/aizheng.mp3', 2),
('h6_003', 6, '爱不释手', 'ài bù shì shǒu', 'Love something too much to part with it', 'can\'t put down; love dearly', 'လက်မချနိုင်အောင်ချစ်သည်', '我对这本书爱不释手。(I can\'t put this book down.)', 'assets/audio/hsk6/aibushishou.mp3', 3),
('h6_004', 6, '爱戴', 'ài dài', 'Love and esteem', 'love and esteem', 'ချစ်မြတ်နိုးသည်', '受人爱戴的领袖。(A beloved leader.)', 'assets/audio/hsk6/aidai.mp3', 4),
('h6_005', 6, '暧昧', 'ài mèi', 'Ambiguous; Dubious', 'ambiguous; dubious', 'မရှင်းမလင်း', '关系暧昧。(Ambiguous relationship.)', 'assets/audio/hsk6/aimei.mp3', 5),
('h6_006', 6, '安宁', 'ān níng', 'Peaceful; Tranquil', 'peaceful; tranquil', 'ငြိမ်းချမ်းသော', '内心安宁。(Inner peace.)', 'assets/audio/hsk6/anning.mp3', 6),
('h6_007', 6, '安详', 'ān xiáng', 'Serene', 'serene; composed', 'ငြိမ်သက်သော', '神态安详。(Serene expression.)', 'assets/audio/hsk6/anxiang.mp3', 7),
('h6_008', 6, '安置', 'ān zhì', 'Find a place for; Arrange', 'to settle; to arrange', 'နေရာချထားသည်', '安置难民。(Resettle refugees.)', 'assets/audio/hsk6/anzhi.mp3', 8),
('h6_009', 6, '按摩', 'àn mó', 'Massage', 'massage', 'အနှိပ်', '按摩背部。(Massage the back.)', 'assets/audio/hsk6/anmo.mp3', 9),
('h6_010', 6, '案件', 'àn jiàn', 'Legal case', 'legal case', 'တရားမှုအမှု', '审理案件。(Try a case.)', 'assets/audio/hsk6/anjian.mp3', 10),
('h6_011', 6, '案例', 'àn lì', 'Case study', 'case study', 'ဖြစ်ရပ်လေ့လာမှု', '典型的案例。(A typical case study.)', 'assets/audio/hsk6/anli.mp3', 11),
('h6_012', 6, '暗示', 'àn shì', 'Hint; Suggest', 'to hint; to suggest', 'အရိပ်အမြွက်ပြသည်', '他暗示我离开。(He hinted for me to leave.)', 'assets/audio/hsk6/anshi.mp3', 12),
('h6_013', 6, '昂贵', 'áng guì', 'Expensive; Costly', 'expensive; costly', 'စျေးကြီးသော', '价格昂贵。(The price is expensive.)', 'assets/audio/hsk6/anggui.mp3', 13),
('h6_014', 6, '凹凸', 'āo tū', 'Uneven; Bump', 'uneven; bumpy', 'ချိုင့်ဝှမ်း', '路面凹凸不平。(The road surface is uneven.)', 'assets/audio/hsk6/aotu.mp3', 14),
('h6_015', 6, '熬', 'áo', 'Endure; Boil', 'to endure; to boil', 'သည်းခံသည်', '熬夜。(Stay up late.)', 'assets/audio/hsk6/ao.mp3', 15),
('h6_016', 6, '奥秘', 'ào mì', 'Mystery', 'mystery; secret', 'လျှို့ဝှက်ချက်', '探索宇宙的奥秘。(Explore the mysteries of the universe.)', 'assets/audio/hsk6/aomi.mp3', 16),
('h6_017', 6, '巴不得', 'bā bu de', 'Eagerly look forward to', 'can\'t wait; eager to', 'စောင့်မနေနိုင်', '我巴不得马上回家。(I can\'t wait to go home immediately.)', 'assets/audio/hsk6/babude.mp3', 17),
('h6_018', 6, '巴结', 'bā jie', 'Fawn on; Curry favor', 'to fawn on; to flatter', 'အချော့မောင့်ပြောသည်', '巴结老板。(Curry favor with the boss.)', 'assets/audio/hsk6/bajie.mp3', 18),
('h6_019', 6, '扒', 'bā', 'Hold on to; Strip', 'to hold on; to strip', 'ကိုင်ဆွဲသည်', '扒开。(Push aside.)', 'assets/audio/hsk6/ba.mp3', 19),
('h6_020', 6, '疤', 'bā', 'Scar', 'scar', 'အမာရွတ်', '留下伤疤。(Leave a scar.)', 'assets/audio/hsk6/ba.mp3', 20),
('h6_186', 6, '量子计算', 'liàng zǐ jì suàn', 'ควอนตัมคอมพิวติ้ง', 'quantum computing', 'ကွမ်တမ်ကွန်ပျူတင်း', '量子计算将改变未来。', 'assets/audio/hsk6/liangzijisuan.mp3', 21),
('h6_187', 6, '基因编辑', 'jī yīn biān jí', 'การแก้ไขพันธุกรรม', 'gene editing', 'ဗီဇတည်းဖြတ်မှု', '基因编辑技术发展很快。', 'assets/audio/hsk6/jiyinbianji.mp3', 22),
('h6_188', 6, '纳米技术', 'nà mǐ jì shù', 'นาโนเทคโนโลยี', 'nanotechnology', 'နာနိုနည်းပညာ', '纳米技术应用广泛。', 'assets/audio/hsk6/namijishu.mp3', 23),
('h6_189', 6, '可再生能源', 'kě zài shēng néng yuán', 'พลังงานหมุนเวียน', 'renewable energy', 'ပြန်လည်ပြည့်ဖြိုးမြဲစွမ်းအင်', '可再生能源是未来趋势。', 'assets/audio/hsk6/kezaishengnengyuan.mp3', 24),
('h6_190', 6, '机器学习', 'jī qì xué xí', 'การเรียนรู้ของเครื่อง', 'machine learning', 'စက်သင်ယူမှု', '机器学习是AI的核心。', 'assets/audio/hsk6/jiqixuexi.mp3', 25),
('h6_191', 6, '深度学习', 'shēn dù xué xí', 'การเรียนรู้เชิงลึก', 'deep learning', 'နက်ရှိုင်းစွာသင်ယူမှု', '深度学习推动了AI发展。', 'assets/audio/hsk6/shenduxuexi.mp3', 26),
('h6_192', 6, '神经网络', 'shén jīng wǎng luò', 'โครงข่ายประสาทเทียม', 'neural network', 'အာရုံကြောကွန်ရက်', '神经网络模拟大脑工作。', 'assets/audio/hsk6/shenjingwangluo.mp3', 27),
('h6_193', 6, '自然语言处理', 'zì rán yǔ yán chǔ lǐ', 'การประมวลผลภาษาธรรมชาติ', 'natural language processing', 'သဘာဝဘာသာစကားလုပ်ဆောင်မှု', '自然语言处理让机器理解人类语言。', 'assets/audio/hsk6/ziranyuyanchuli.mp3', 28),
('h6_194', 6, '计算机视觉', 'jì suàn jī shì jué', 'การมองเห็นของคอมพิวเตอร์', 'computer vision', 'ကွန်ပျူတာမြင်ကွင်း', '计算机视觉让机器能看懂图像。', 'assets/audio/hsk6/jisuanjishijue.mp3', 29),
('h6_195', 6, '物联网', 'wù lián wǎng', 'อินเทอร์เน็ตของสรรพสิ่ง', 'Internet of Things (IoT)', 'အရာဝတ္ထုများ၏အင်တာနက်', '物联网连接万物。', 'assets/audio/hsk6/wulianwang.mp3', 30),
('h6_196', 6, '5G技术', '5G jì shù', 'เทคโนโลยี 5G', '5G technology', '5G နည်းပညာ', '5G技术带来更快速度。', 'assets/audio/hsk6/5Gjishu.mp3', 31),
('h6_197', 6, '自动驾驶', 'zì dòng jià shǐ', 'รถยนต์ขับเคลื่อนอัตโนมัติ', 'autonomous driving', 'ကိုယ်တိုင်မောင်းနှင်မှု', '自动驾驶技术日趋成熟。', 'assets/audio/hsk6/zidongjiashi.mp3', 32),
('h6_198', 6, '虚拟助手', 'xū nǐ zhù shǒu', 'ผู้ช่วยเสมือน', 'virtual assistant', 'ပကတိမဟုတ်သောအကူအညီ', '虚拟助手帮助日常生活。', 'assets/audio/hsk6/xunizhushou.mp3', 33),
('h6_199', 6, '增强现实', 'zēng qiáng xiàn shí', 'ความเป็นจริงเสริม', 'augmented reality (AR)', 'တိုးချဲ့ရသည့်လက်တွေ့', '增强现实技术改变体验方式。', 'assets/audio/hsk6/zengqiangxianshi.mp3', 34),
('h6_200', 6, '生物识别', 'shēng wù shí bié', 'การยืนยันตัวตนทางชีวภาพ', 'biometric identification', 'ဇီဝအသိအမှတ်ပြုခြင်း', '生物识别提高安全性。', 'assets/audio/hsk6/shengwushibie.mp3', 35),
('h6_201', 6, '量子计算', 'liàng zǐ jì suàn', 'ควอนตัมคอมพิวติ้ง', 'quantum computing', 'ကွမ်တမ်ကွန်ပျူတင်း', '量子计算改变计算方式。', 'assets/audio/hsk6/liangzijisuan2.mp3', 36),
('h6_202', 6, '基因编辑', 'jī yīn biān jí', 'การแก้ไขพันธุกรรม', 'gene editing', 'ဗီဇတည်းဖြတ်မှု', '基因编辑治疗疾病。', 'assets/audio/hsk6/jiyinbianji2.mp3', 37),
('h6_203', 6, '纳米技术', 'nà mǐ jì shù', 'นาโนเทคโนโลยี', 'nanotechnology', 'နာနိုနည်းပညာ', '纳米技术应用于医学。', 'assets/audio/hsk6/namijishu2.mp3', 38),
('h6_204', 6, '可再生能源', 'kě zài shēng néng yuán', 'พลังงานหมุนเวียน', 'renewable energy', 'ပြန်လည်ပြည့်ဖြိုးမြဲစွမ်းအင်', '可再生能源保护环境。', 'assets/audio/hsk6/kezaishengnengyuan2.mp3', 39),
('h6_205', 6, '机器学习', 'jī qì xué xí', 'การเรียนรู้ของเครื่อง', 'machine learning', 'စက်သင်ယူမှု', '机器学习优化决策。', 'assets/audio/hsk6/jiqixuexi2.mp3', 40),
('h6_206', 6, '深度学习', 'shēn dù xué xí', 'การเรียนรู้เชิงลึก', 'deep learning', 'နက်ရှိုင်းစွာသင်ယူမှု', '深度学习识别图像。', 'assets/audio/hsk6/shenduxuexi2.mp3', 41),
('h6_207', 6, '神经网络', 'shén jīng wǎng luò', 'โครงข่ายประสาทเทียม', 'neural network', 'အာရုံကြောကွန်ရက်', '神经网络模拟大脑。', 'assets/audio/hsk6/shenjingwangluo2.mp3', 42),
('h6_208', 6, '自然语言处理', 'zì rán yǔ yán chǔ lǐ', 'การประมวลผลภาษาธรรมชาติ', 'natural language processing', 'သဘာဝဘာသာစကားလုပ်ဆောင်မှု', '自然语言处理理解文本。', 'assets/audio/hsk6/ziranyuyanchuli2.mp3', 43),
('h6_209', 6, '计算机视觉', 'jì suàn jī shì jué', 'การมองเห็นของคอมพิวเตอร์', 'computer vision', 'ကွန်ပျူတာမြင်ကွင်း', '计算机视觉分析图像。', 'assets/audio/hsk6/jisuanjishijue2.mp3', 44),
('h6_210', 6, '物联网', 'wù lián wǎng', 'อินเทอร์เน็ตของสรรพสิ่ง', 'Internet of Things (IoT)', 'အရာဝတ္ထုများ၏အင်တာနက်', '物联网连接设备。', 'assets/audio/hsk6/wulianwang2.mp3', 45),
('h6_211', 6, '5G技术', '5G jì shù', 'เทคโนโลยี 5G', '5G technology', '5G နည်းပညာ', '5G技术支持高速通信。', 'assets/audio/hsk6/5Gjishu2.mp3', 46),
('h6_212', 6, '自动驾驶', 'zì dòng jià shǐ', 'รถยนต์ขับเคลื่อนอัตโนมัติ', 'autonomous driving', 'ကိုယ်တိုင်မောင်းနှင်မှု', '自动驾驶提高安全性。', 'assets/audio/hsk6/zidongjiashi2.mp3', 47),
('h6_213', 6, '虚拟助手', 'xū nǐ zhù shǒu', 'ผู้ช่วยเสมือน', 'virtual assistant', 'ပကတိမဟုတ်သောအကူအညီ', '虚拟助手回答问题。', 'assets/audio/hsk6/xunizhushou2.mp3', 48),
('h6_214', 6, '增强现实', 'zēng qiáng xiàn shí', 'ความเป็นจริงเสริม', 'augmented reality (AR)', 'တိုးချဲ့ရသည့်လက်တွေ့', '增强现实增强体验。', 'assets/audio/hsk6/zengqiangxianshi2.mp3', 49),
('h6_215', 6, '区块链', 'qū kuài liàn', 'บล็อกเชน', 'blockchain', 'ဘလော့ချိန်း', '区块链确保透明度。', 'assets/audio/hsk6/qukuailian2.mp3', 50),
('hsk1_001', 1, '爱', 'ài', 'ချစ်သည်', 'love', 'ချစ်သည်', '1. 我爱你。\nI love you.\nငါမင်းကိုချစ်တယ်။\n\n2. 妈妈爱我。\nMom loves me.\nအမေက ငါ့ကိုချစ်တယ်။\n\n3. 他爱看书。\nHe loves reading books.\nသူ စာဖတ်ရတာကို နှစ်သက်တယ်။', 'audio/hsk1/爱.mp3', 1),
('hsk1_002', 1, '爱好', 'ài hào', 'ဝါသနာ', 'hobby', 'ဝါသနာ', '1. 你的爱好是什么？\nWhat is your hobby?\nမင်းရဲ့ ဝါသနာက ဘာလဲ။\n\n2. 我的爱好是唱歌。\nMy hobby is singing.\nငါ့ရဲ့ ဝါသနာက သီချင်းဆိုခြင်း ဖြစ်တယ်။\n\n3. 他有很多爱好。\nHe has many hobbies.\nသူ့မှာ ဝါသနာတွေ အများကြီးရှိတယ်။', 'audio/hsk1/爱好.mp3', 2),
('hsk1_003', 1, '八', 'bā', 'ရှစ် (ဂဏန်း)', 'eight', 'ရှစ် (ဂဏန်း)', '1. 我有八本书。\nI have eight books.\nငါ့မှာ စာအုပ် ရှစ်အုပ်ရှိတယ်။\n\n2. 今天是八号。\nToday is the 8th.\nဒီနေ့က ၈ ရက်နေ့ ဖြစ်တယ်။\n\n3. 他八岁了。\nHe is eight years old.\nသူ အသက် ၈ နှစ် ရှိပြီ။', 'audio/hsk1/八.mp3', 3),
('hsk1_004', 1, '爸爸', 'bàba', 'အဖေ', 'dad', 'အဖေ', '1. 我爸爸是医生。\nMy dad is a doctor.\nငါ့အဖေက ဆရာဝန်တစ်ယောက် ဖြစ်တယ်။\n\n2. 爸爸，你去哪儿？\n\"Dad, where are you going?\"\nအဖေ၊ အဖေ ဘယ်သွားမလို့လဲ။\n\n3. 爸爸很忙。\nDad is very busy.\nအဖေက အရမ်းအလုပ်များတယ်။', 'audio/hsk1/爸爸.mp3', 4),
('hsk1_005', 1, '吧', 'ba', 'ပါ / လေ (အကြံပြုခြင်း)', '(particle indicating suggestion)', 'ပါ / လေ (အကြံပြုခြင်း)', '1. 我们走吧。\nLet\'s go.\nငါတို့ သွားကြစို့။\n\n2. 你是中国人吧？\n\"You are Chinese, right?\"\nမင်းက တရုတ်လူမျိုး ဟုတ်တယ်မလား။\n\n3. 快点吃吧。\nEat quickly.\nမြန်မြန် စားလိုက်ပါဦး။', 'audio/hsk1/吧.mp3', 5),
('hsk1_006', 1, '白', 'bái', 'အဖြူ', 'white', 'အဖြူ', '1. 我喜欢白色的衣服。\nI like white clothes.\nငါ အဖြူရောင် အဝတ်အစားတွေကို ကြိုက်တယ်။\n\n2. 这是一只白狗。\nThis is a white dog.\nဒါက ခွေးဖြူလေး တစ်ကောင် ဖြစ်တယ်။\n\n3. 头发白了。\nHair has turned white.\nဆံပင်တွေ ဖြူသွားပြီ။', 'audio/hsk1/白.mp3', 6),
('hsk1_007', 1, '白天', 'bái tiān', 'နေ့ဘက်', 'day / daytime', 'နေ့ဘက်', '1. 我在白天工作。\nI work during the day.\nငါ နေ့ဘက်မှာ အလုပ်လုပ်တယ်။\n\n2. 白天很热。\nIt is hot during the day.\nနေ့ဘက်မှာ အရမ်းပူတယ်။\n\n3. 我不喜欢白天睡觉。\nI don\'t like sleeping during the day.\nငါ နေ့ဘက် အိပ်ရတာ မကြိုက်ဘူး။', 'audio/hsk1/白天.mp3', 7),
('hsk1_008', 1, '百', 'bǎi', 'ရာ (ဂဏန်း)', 'hundred', 'ရာ (ဂဏန်း)', '1. 这本书一百块。\nThis book is 100 yuan.\nဒီစာအုပ်က ယွမ် ၁၀၀ ဖြစ်တယ်။\n\n2. 我们要走一百米。\nWe need to walk 100 meters.\nငါတို့ မီတာ ၁၀၀ လောက် လမ်းလျှောက်ရမယ်။\n\n3. 有一百个人。\nThere are 100 people.\nလူ ၁၀၀ ရှိတယ်။', 'audio/hsk1/百.mp3', 8),
('hsk1_009', 1, '班', 'bān', 'အတန်း', 'class', 'အတန်း', '1. 我在一班。\nI am in Class 1.\nငါက အတန်း (၁) မှာ တက်တယ်။\n\n2. 我也上班。\nI also go to work.\nငါလည်း အလုပ်ဆင်းတယ်။\n\n3. 我们班有二十个学生。\nOur class has 20 students.\nငါတို့အတန်းမှာ ကျောင်းသား ၂၀ ရှိတယ်။', 'audio/hsk1/班.mp3', 9),
('hsk1_010', 1, '半', 'bàn', 'တစ်ဝက်', 'half', 'တစ်ဝက်', '1. 现在两点半。\nIt is 2:30 now.\nအခု ၂ နာရီခွဲပြီ။\n\n2. 我要半个西瓜。\nI want half a watermelon.\nငါ ဖရဲသီး တစ်ဝက် လိုချင်တယ်။\n\n3. 半小时后见。\nSee you in half an hour.\nနာရီဝက်နေမှ တွေ့မယ်။', 'audio/hsk1/半.mp3', 10),
('hsk1_011', 1, '半年', 'bàn nián', 'နှစ်ဝက် / ခြောက်လ', 'half a year', 'နှစ်ဝက် / ခြောက်လ', '1. 我在中国住了半年。\nI lived in China for half a year.\nငါ တရုတ်ပြည်မှာ ခြောက်လ နေခဲ့တယ်။\n\n2. 这项工作需要半年。\nThis job takes half a year.\nဒီအလုပ်က ခြောက်လ ကြာမယ်။\n\n3. 还要半年才毕业。\nGraduation is still half a year away.\nကျောင်းပြီးဖို့ ခြောက်လ လိုသေးတယ်။', 'audio/hsk1/半年.mp3', 11),
('hsk1_012', 1, '半天', 'bàn tiān', 'နေ့တစ်ဝက် / အကြာကြီး', 'half day / a long time', 'နေ့တစ်ဝက် / အကြာကြီး', '1. 我等了半天。\nI waited for a long time (half a day).\nငါစောင့်နေတာ ကြာလှပြီ (နေ့တစ်ဝက်လောက်ရှိပြီ)။\n\n2. 我们玩了半天。\nWe played for half a day.\nငါတို့ နေ့တစ်ဝက်လောက် ကစားခဲ့ကြတယ်။\n\n3. 只剩下半天时间。\nThere is only half a day left.\nအချိန် နေ့တစ်ဝက်ပဲ ကျန်တော့တယ်။', 'audio/hsk1/半天.mp3', 12),
('hsk1_013', 1, '帮', 'bāng', 'ကူညီသည်', 'help', 'ကူညီသည်', '1. 请帮我一下。\nPlease help me a little.\nကျေးဇူးပြုပြီး ငါ့ကို နည်းနည်းလောက် ကူညီပါဦး။\n\n2. 我可以帮你吗？\nCan I help you?\nငါ မင်းကို ကူညီပေးရမလား။\n\n3. 谢谢你帮我。\nThank you for helping me.\nငါ့ကို ကူညီပေးလို့ ကျေးဇူးတင်ပါတယ်။', 'audio/hsk1/帮.mp3', 13),
('hsk1_014', 1, '帮忙', 'bāng máng', 'အကူအညီပေးသည်', 'help / do a favor', 'အကူအညီပေးသည်', '1. 我需要帮忙。\nI need help.\nငါ အကူအညီ လိုနေတယ်။\n\n2. 他经常帮忙别人。\nHe often helps others.\nသူက တခြားသူတွေကို အမြဲကူညီလေ့ရှိတယ်။\n\n3. 你能帮忙吗？\nCan you help?\nမင်း ကူညီပေးနိုင်မလား။', 'audio/hsk1/帮忙.mp3', 14),
('hsk1_015', 1, '包', 'bāo', 'အိတ် / ထုပ်ပိုးသည်', 'bag / package', 'အိတ် / ထုပ်ပိုးသည်', '1. 我的包在哪儿？\nWhere is my bag?\nငါ့အိတ် ဘယ်မှာလဲ။\n\n2. 这是一个大包。\nThis is a big bag.\nဒါက အိတ်ကြီးတစ်လုံး ဖြစ်တယ်။\n\n3. 我去买个包。\nI am going to buy a bag.\nငါ အိတ်တစ်လုံး သွားဝယ်မလို့။', 'audio/hsk1/包.mp3', 15),
('hsk1_016', 1, '包子', 'bāo zi', 'ပေါက်စီ', 'bun (steamed)', 'ပေါက်စီ', '1. 我想吃包子。\nI want to eat buns.\nငါ ပေါက်စီ စားချင်တယ်။\n\n2. 这个包子很好吃。\nThis bun is delicious.\nဒီပေါက်စီက အရမ်းစားကောင်းတယ်။\n\n3. 多少钱一个包子？\nHow much is one bun?\nပေါက်စီတစ်လုံး ဘယ်လောက်လဲ။', 'audio/hsk1/包子.mp3', 16),
('hsk1_017', 1, '杯', 'bēi', 'ခွက် (အရေအတွက်ပြစကားလုံး)', 'cup (measure word)', 'ခွက် (အရေအတွက်ပြစကားလုံး)', '1. 我要一杯水。\nI want a cup of water.\nငါ ရေတစ်ခွက် လိုချင်တယ်။\n\n2. 喝一杯茶吧。\nHave a cup of tea.\nလက်ဖက်ရည် တစ်ခွက်လောက် သောက်ပါဦး။\n\n3. 他喝了一杯牛奶。\nHe drank a cup of milk.\nသူ နွားနို့တစ်ခွက် သောက်ခဲ့တယ်။', 'audio/hsk1/杯.mp3', 17),
('hsk1_018', 1, '杯子', 'bēi zi', 'ခွက်', 'cup', 'ခွက်', '1. 这是一个新杯子。\nThis is a new cup.\nဒါက ခွက်အသစ်တစ်လုံး ဖြစ်တယ်။\n\n2. 杯子坏了。\nThe cup is broken.\nခွက်က ကွဲသွားပြီ။\n\n3. 你的杯子很漂亮。\nYour cup is very beautiful.\nမင်းရဲ့ခွက်က အရမ်းလှတယ်။', 'audio/hsk1/杯子.mp3', 18),
('hsk1_019', 1, '北边', 'běi biān', 'မြောက်ဘက်အခြမ်း', 'North side', 'မြောက်ဘက်အခြမ်း', '1. 学校在北边。\nThe school is on the north side.\nကျောင်းက မြောက်ဘက်အခြမ်းမှာ ရှိတယ်။\n\n2. 北边比较冷。\nIt is colder on the north side.\nမြောက်ဘက်အခြမ်းက ပိုအေးတယ်။\n\n3. 我去北边看看。\nI will go to the north side to have a look.\nငါ မြောက်ဘက်အခြမ်းကို သွားကြည့်လိုက်ဦးမယ်။', 'audio/hsk1/北边.mp3', 19),
('hsk1_020', 1, '北京', 'Běijīng', 'ပေကျင်းမြို့', 'Beijing', 'ပေကျင်းမြို့', '1. 我住在北京。\nI live in Beijing.\nငါ ပေကျင်းမှာ နေတယ်။\n\n2. 北京很大。\nBeijing is very big.\nပေကျင်းက အရမ်းကြီးတယ်။\n\n3. 你去过北京吗？\nHave you been to Beijing?\nမင်း ပေကျင်းကို ရောက်ဖူးလား။', 'audio/hsk1/北京.mp3', 20),
('hsk1_021', 1, '本', 'běn', 'အုပ် (စာအုပ်ရေတွက်ရာတွင်သုံးသည်)', '(measure word)', 'အုပ် (စာအုပ်ရေတွက်ရာတွင်သုံးသည်)', '1. 我有一本书。\nI have a book.\nငါ့မှာ စာအုပ်တစ်အုပ် ရှိတယ်။\n\n2. 这本词典很好。\nThis dictionary is very good.\nဒီအဘိဓာန်က အရမ်းကောင်းတယ်။\n\n3. 那本杂志是谁的？\nWhose magazine is that?\nဟို မဂ္ဂဇင်းက ဘယ်သူ့ဟာလဲ။', 'audio/hsk1/本.mp3', 21),
('hsk1_022', 1, '本子', 'běn zi', 'မှတ်စုစာအုပ်', 'notebook', 'မှတ်စုစာအုပ်', '1. 请把本子给我。\nPlease give me the notebook.\nကျေးဇူးပြုပြီး ငါ့ကို မှတ်စုစာအုပ် ပေးပါ။\n\n2. 我买了一个新本子。\nI bought a new notebook.\nငါ မှတ်စုစာအုပ်အသစ်တစ်အုပ် ဝယ်ခဲ့တယ်။\n\n3. 在本子上写名字。\nWrite your name on the notebook.\nမှတ်စုစာအုပ်ပေါ်မှာ နာမည်ရေးပါ။', 'audio/hsk1/本子.mp3', 22),
('hsk1_023', 1, '比', 'bǐ', 'ထက် (နှိုင်းယှဉ်ခြင်း)', '(comparison particle)', 'ထက် (နှိုင်းယှဉ်ခြင်း)', '1. 我比他高。\nI am taller than him.\nငါက သူ့ထက် အရပ်ရှည်တယ်။\n\n2. 今天比昨天热。\nToday is hotter than yesterday.\nဒီနေ့က မနေ့ကထက် ပူတယ်။\n\n3. 苹果比香蕉好吃。\nApples are more delicious than bananas.\nပန်းသီးက ငှက်ပျောသီးထက် ပိုစားကောင်းတယ်။', 'audio/hsk1/比.mp3', 23),
('hsk1_024', 1, '别', 'bié', 'မ...နဲ့ (တားမြစ်ခြင်း)', 'Don\'t', 'မ...နဲ့ (တားမြစ်ခြင်း)', '1. 别说话。\nDon\'t speak.\nစကားမပြောနဲ့။\n\n2. 别去那里。\nDon\'t go there.\nဟိုကို မသွားနဲ့။\n\n3. 别忘了带钱。\nDon\'t forget to bring money.\nပိုက်ဆံယူလာဖို့ မမေ့နဲ့။', 'audio/hsk1/别.mp3', 24),
('hsk1_025', 1, '别的', 'bié de', 'အခြား', 'other', 'အခြား', '1. 我想要别的。\nI want the other one.\nငါ တခြားဟာကို လိုချင်တယ်။\n\n2. 你有别的颜色吗？\nDo you have other colors?\nမင်းမှာ တခြားအရောင် ရှိလား။\n\n3. 别的人没来。\nOther people didn\'t come.\nတခြားလူတွေ မလာကြဘူး။', 'audio/hsk1/别的.mp3', 25),
('hsk1_026', 1, '别人', 'bié rén', 'သူများ / အခြားလူ', 'other people', 'သူများ / အခြားလူ', '1. 只有我们，没有别人。\n\"Only us, no other people.\"\nငါတို့ပဲ ရှိတယ်၊ တခြားလူ မရှိဘူး။\n\n2. 别告诉别人。\nDon\'t tell others.\nသူများကို သွားမပြောနဲ့။\n\n3. 要帮助别人。\nNeed to help others.\nသူများကို ကူညီရမယ်။', 'audio/hsk1/别人.mp3', 26),
('hsk1_027', 1, '病', 'bìng', 'ရောဂါ / နေမကောင်းဖြစ်သည်', 'illness / get sick', 'ရောဂါ / နေမကောင်းဖြစ်သည်', '1. 他病了。\nHe is sick.\nသူ နေမကောင်းဘူး။\n\n2. 这是什么病？\nWhat illness is this?\nဒါ ဘာရောဂါလဲ။\n\n3. 病得很重。\nSeriously ill.\nရောဂါ တော်တော်ဆိုးနေတယ်။', 'audio/hsk1/病.mp3', 27),
('hsk1_028', 1, '病人', 'bìng rén', 'လူနာ', 'patient', 'လူနာ', '1. 医生在看病人。\nThe doctor is seeing a patient.\nဆရာဝန် လူနာကြည့်နေတယ်။\n\n2. 医院里有很多病人。\nThere are many patients in the hospital.\nဆေးရုံမှာ လူနာတွေ အများကြီးရှိတယ်။\n\n3. 病人需要休息。\nThe patient needs rest.\nလူနာက အနားယူဖို့ လိုတယ်။', 'audio/hsk1/病人.mp3', 28),
('hsk1_029', 1, '不大', 'bú dà', 'သိပ်မကြီးဘူး / မကြီးမားသော', 'not big', 'သိပ်မကြီးဘူး / မကြီးမားသော', '1. 这个苹果不大。\nThis apple is not big.\nဒီပန်းသီးက သိပ်မကြီးဘူး။\n\n2. 雨下得不大。\nThe rain is not heavy.\nမိုး သိပ်မကြီးဘူး။\n\n3. 这里的变化不大。\nThe changes here are not big.\nဒီမှာ ပြောင်းလဲမှု သိပ်မကြီးဘူး။', 'audio/hsk1/不大.mp3', 29),
('hsk1_030', 1, '不对', 'bú duì', 'မမှန်ဘူး / မှားတယ်', 'wrong / incorrect', 'မမှန်ဘူး / မှားတယ်', '1. 这个答案不对。\nThis answer is incorrect.\nဒီအဖြေက မမှန်ဘူး။\n\n2. 你说得不对。\nWhat you said is wrong.\nမင်းပြောတာ မှားနေတယ်။\n\n3. 有点儿不对。\nSomething is a little wrong.\nတစ်ခုခုတော့ မှားနေပြီ။', 'audio/hsk1/不对.mp3', 30),
('hsk1_031', 1, '不客气', 'bú kè qì', 'ရပါတယ် / အားမနာပါနဲ့', 'You\'re welcome', 'ရပါတယ် / အားမနာပါနဲ့', '1. 谢谢你。不客气。\nThank you. You\'re welcome.\nကျေးဇူးတင်ပါတယ်။ ရပါတယ်ဗျာ။\n\n2. 大家别客气。\n\"Don\'t stand on ceremony, everyone.\"\nအားလုံးပဲ အားမနာကြပါနဲ့။\n\n3. 真是太客气了。\nYou are too polite.\nတကယ်ကို အားနာစရာကြီးပါ။', 'audio/hsk1/不客气.mp3', 31),
('hsk1_032', 1, '不用', 'bú yòng', 'မလိုဘူး', 'No need to', 'မလိုဘူး', '1. 不用谢。\nNo need to thank me.\nကျေးဇူးတင်ဖို့ မလိုပါဘူး။\n\n2. 不用担心。\nNo need to worry.\nစိတ်ပူစရာ မလိုဘူး။\n\n3. 不用麻烦了。\nNo need to bother.\nဒုက္ခရှာမနေပါနဲ့တော့ (ရပါတယ်)။', 'audio/hsk1/不用.mp3', 32),
('hsk1_033', 1, '不', 'bù', 'မ (ငြင်းပယ်ခြင်း)', 'No / Not', 'မ (ငြင်းပယ်ခြင်း)', '1. 我不去。\nI am not going.\nငါ မသွားဘူး။\n\n2. 这不是我的。\nThis is not mine.\nဒါ ငါ့ဟာ မဟုတ်ဘူး။\n\n3. 好不好？\nIs it good?\nကောင်းလား မကောင်းဘူးလား။', 'audio/hsk1/不.mp3', 33),
('hsk1_034', 1, '菜', 'cài', 'ဟင်း / ဟင်းသီးဟင်းရွက်', 'dish / vegetable', 'ဟင်း / ဟင်းသီးဟင်းရွက်', '1. 这是什么菜？\nWhat dish is this?\nဒါ ဘာဟင်းလဲ။\n\n2. 我去买菜。\nI am going to buy vegetables/groceries.\nငါ ဈေးသွားဝယ်မလို့။\n\n3. 中国菜很好吃。\nChinese food is delicious.\nတရုတ်ဟင်းက အရမ်းစားကောင်းတယ်။', 'audio/hsk1/菜.mp3', 34),
('hsk1_035', 1, '茶', 'chá', 'လက်ဖက်ရည် / ရေနွေးကြမ်း', 'tea', 'လက်ဖက်ရည် / ရေနွေးကြမ်း', '1. 请喝茶。\nPlease drink tea.\nလက်ဖက်ရည် သောက်ပါဦး။\n\n2. 我想买茶叶。\nI want to buy tea leaves.\nငါ လက်ဖက်ခြောက် ဝယ်ချင်တယ်။\n\n3. 这杯茶很热。\nThis cup of tea is very hot.\nဒီလက်ဖက်ရည်က အရမ်းပူတယ်။', 'audio/hsk1/茶.mp3', 35),
('hsk1_036', 1, '差', 'chà', 'ညံ့သည် / လိုသည် / ကွာခြားသည်', 'bad / short of / lack', 'ညံ့သည် / လိုသည် / ကွာခြားသည်', '1. 他的中文很差。\nHis Chinese is very poor.\nသူ့တရုတ်စကားက အရမ်းညံ့တယ်။\n\n2. 差五分就十点了。\nJust left five minutes to ten.\nနောက်၅မိနစ်ဆို၁၀နာရီထိုးပြီ\n\n3. 差不多。\nAlmost the same / About.\nသိပ်မကွာပါဘူး / တော်တော်များများတူတယ်။', 'audio/hsk1/差.mp3', 36),
('hsk1_037', 1, '常', 'cháng', 'မကြာခဏ', 'often', 'မကြာခဏ', '1. 我常去那里。\nI often go there.\nငါ ဟိုကို မကြာခဏ သွားတယ်။\n\n2. 他不常来。\nHe doesn\'t come often.\nသူ သိပ်မလာဘူး။\n\n3. 常联系。\nKeep in touch.\nအဆက်အသွယ် လုပ်နော်။', 'audio/hsk1/常.mp3', 37),
('hsk1_038', 1, '常常', 'cháng cháng', 'မကြာခဏ / အမြဲလိုလို', 'often', 'မကြာခဏ / အမြဲလိုလို', '1. 我常常看书。\nI often read books.\nငါ စာအမြဲလိုလို ဖတ်တယ်။\n\n2. 我们常常见面。\nWe meet often.\nငါတို့ မကြာခဏ တွေ့ကြတယ်။\n\n3. 他常常迟到。\nHe is often late.\nသူ မကြာခဏ နောက်ကျတယ်။', 'audio/hsk1/常常.mp3', 38),
('hsk1_039', 1, '唱', 'chàng', 'သီချင်းဆိုသည်', 'sing', 'သီချင်းဆိုသည်', '1. 他在唱什么？\nWhat is he singing?\nသူ ဘာသီချင်း ဆိုနေတာလဲ။\n\n2. 我也想唱。\nI want to sing too.\nငါလည်း သီချင်းဆိုချင်တယ်။\n\n3. 唱一首歌吧。\nSing a song.\nသီချင်းတစ်ပုဒ်လောက် ဆိုပါဦး။', 'audio/hsk1/唱.mp3', 39),
('hsk1_040', 1, '唱歌', 'chàng gē', 'သီချင်းဆိုသည်', 'sing', 'သီချင်းဆိုသည်', '1. 她喜欢唱歌。\nShe likes singing.\nသူမ သီချင်းဆိုရတာ ကြိုက်တယ်။\n\n2. 我们在唱歌。\nWe are singing.\nငါတို့ သီချင်းဆိုနေကြတယ်။\n\n3. 听他唱歌。\nListen to him sing.\nသူ သီချင်းဆိုတာ နားထောင်။', 'audio/hsk1/唱歌.mp3', 40),
('hsk1_041', 1, '车', 'chē', 'ကား', 'car', 'ကား', '1. 那是我的车。\nThat is my car.\nအဲဒါ ငါ့ကား။\n\n2. 车来了。\nThe car is coming.\nကားလာပြီ။\n\n3. 他在车里。\nHe is inside the car.\nသူက ကားထဲမှာ။', 'audio/hsk1/车.mp3', 41),
('hsk1_042', 1, '车票', 'chē piào', 'လက်မှတ် (ကား/ရထား)', 'ticket', 'လက်မှတ် (ကား/ရထား)', '1. 我要买车票。\nI want to buy a ticket.\nငါ လက်မှတ်ဝယ်ချင်တယ်။\n\n2. 车票多少钱？\nHow much is the ticket?\nလက်မှတ်က ဘယ်လောက်လဲ။\n\n3. 请给我看车票。\nPlease show me the ticket.\nကျေးဇူးပြုပြီး လက်မှတ်ပြပါ။', 'audio/hsk1/车票.mp3', 42),
('hsk1_043', 1, '车上', 'chē shàng', 'ကားပေါ်မှာ', 'in the car', 'ကားပေါ်မှာ', '1. 我在车上。\nI am in the car.\nငါ ကားပေါ်မှာ။\n\n2. 车上很多人。\nThere are many people in the car.\nကားပေါ်မှာ လူတွေအများကြီးပဲ။\n\n3. 别在车上吃东西。\nDon\'t eat in the car.\nကားပေါ်မှာ မုန့်မစားနဲ့။', 'audio/hsk1/车上.mp3', 43),
('hsk1_044', 1, '车站', 'chē zhàn', 'ဘူတာ / ကားဂိတ်', 'station', 'ဘူတာ / ကားဂိတ်', '1. 我在车站等你。\nI will wait for you at the station.\nငါ မင်းကို ဘူတာမှာ စောင့်နေမယ်။\n\n2. 去车站怎么走？\nHow do I go to the station?\nဘူတာကို ဘယ်လိုသွားရမလဲ။\n\n3. 这是一个大车站。\nThis is a big station.\nဒါက ဘူတာကြီးတစ်ခု ဖြစ်တယ်။', 'audio/hsk1/车站.mp3', 44),
('hsk1_045', 1, '吃', 'chī', 'စားသည်', 'eat', 'စားသည်', '1. 你吃什么？\nWhat do you eat?\nမင်း ဘာစားမလဲ။\n\n2. 我吃苹果。\nI eat an apple.\nငါ ပန်းသီးစားတယ်။\n\n3. 好吃吗？\nIs it delicious?\nစားလို့ကောင်းလား။', 'audio/hsk1/吃.mp3', 45),
('hsk1_046', 1, '吃饭', 'chī fàn', 'ထမင်းစားသည်', 'have a meal', 'ထမင်းစားသည်', '1. 我们去吃饭吧。\nLet\'s go have a meal.\nငါတို့ ထမင်းသွားစားကြစို့။\n\n2. 他在吃饭。\nHe is eating.\nသူ ထမင်းစားနေတယ်။\n\n3. 你吃饭了吗？\nHave you eaten yet?\nမင်း ထမင်းစားပြီးပြီလား။', 'audio/hsk1/吃饭.mp3', 46),
('hsk1_047', 1, '出', 'chū', 'ထွက်သည်', 'go out / come out', 'ထွက်သည်', '1. 他出去了。\nHe went out.\nသူ အပြင်ထွက်သွားပြီ။\n\n2. 太阳出来了。\nThe sun has come out.\nနေထွက်လာပြီ။\n\n3. 请出示护照。\nPlease show your passport.\nကျေးဇူးပြုပြီး နိုင်ငံကူးလက်မှတ် ပြပေးပါ။', 'audio/hsk1/出.mp3', 47),
('hsk1_048', 1, '出来', 'chū lái', 'ထွက်လာသည်', 'come out', 'ထွက်လာသည်', '1. 你出来一下。\nCome out for a moment.\nမင်း ခဏလောက် ထွက်လာပါဦး။\n\n2. 快点出来。\nCome out quickly.\nမြန်မြန် ထွက်လာခဲ့။\n\n3. 他没出来。\nHe didn\'t come out.\nသူ ထွက်မလာဘူး။', 'audio/hsk1/出来.mp3', 48),
('hsk1_049', 1, '出去', 'chū qù', 'ထွက်သွားသည်', 'go out', 'ထွက်သွားသည်', '1. 我想出去玩。\nI want to go out and play.\nငါ အပြင်သွားလည်ချင်တယ်။\n\n2. 大家出去了。\nEveryone has gone out.\nအားလုံး အပြင်ထွက်သွားကြပြီ။\n\n3. 别出去。\nDon\'t go out.\nအပြင်မထွက်နဲ့။', 'audio/hsk1/出去.mp3', 49),
('hsk1_050', 1, '穿', 'chuān', 'ဝတ်သည်', 'wear', 'ဝတ်သည်', '1. 穿衣服。\nPut on clothes.\nအဝတ်အစား ဝတ်ပါ။\n\n2. 他穿着红色的鞋。\nHe is wearing red shoes.\nသူ ဖိနပ်အနီ ဝတ်ထားတယ်။\n\n3. 多穿点儿。\nWear more (clothes).\nအဝတ် များများဝတ်နော်။', 'audio/hsk1/穿.mp3', 50),
('hsk1_051', 1, '床', 'chuáng', 'ကုတင်', 'bed', 'ကုတင်', '1. 这张床很大。\nThis bed is very big.\nဒီကုတင်က အရမ်းကြီးတယ်။\n\n2. 我在床上。\nI am in bed.\nငါ ကုတင်ပေါ်မှာ။\n\n3. 这是谁的床？\nWhose bed is this?\nဒါ ဘယ်သူ့ကုတင်လဲ။', 'audio/hsk1/床.mp3', 51),
('hsk1_052', 1, '次', 'cì', 'အကြိမ်', 'time (frequency)', 'အကြိမ်', '1. 我去过一次。\nI have been there once.\nငါ တစ်ခေါက် ရောက်ဖူးတယ်။\n\n2. 这是第一次。\nThis is the first time.\nဒါ ပထမဆုံးအကြိမ်ပဲ။\n\n3. 下次见。\nSee you next time.\nနောက်တစ်ခါမှ တွေ့မယ်။', 'audio/hsk1/次.mp3', 52),
('hsk1_053', 1, '从', 'cóng', 'မှ / ကနေ', 'from', 'မှ / ကနေ', '1. 从这里到那里。\nFrom here to there.\nဒီကနေ ဟိုအထိ။\n\n2. 你是从哪儿来的？\nWhere do you come from?\nမင်း ဘယ်ကလာတာလဲ။\n\n3. 从明天开始。\nStarting from tomorrow.\nမနက်ဖြန်က စပြီးတော့။', 'audio/hsk1/从.mp3', 53),
('hsk1_054', 1, '错', 'cuò', 'မှားသည်', 'wrong', 'မှားသည်', '1. 我错了。\nI was wrong.\nငါ မှားသွားတယ်။\n\n2. 没错。\nThat\'s right (Not wrong).\nမမှားပါဘူး (မှန်တယ်)။\n\n3. 你看错了。\nYou saw it wrong.\nမင်း မြင်တာ မှားနေပြီ။', 'audio/hsk1/错.mp3', 54),
('hsk1_055', 1, '打', 'dǎ', 'ရိုက်သည် / ကစားသည် / ဖုန်းခေါ်သည်', 'hit / play / call', 'ရိုက်သည် / ကစားသည် / ဖုန်းခေါ်သည်', '1. 别打人。\nDon\'t hit people.\nလူကို မရိုက်နဲ့။\n\n2. 我给他打电话。\nI call him.\nငါ သူ့ဆီ ဖုန်းဆက်လိုက်မယ်။\n\n3. 我们在打球。\nWe are playing ball.\nငါတို့ ဘောလုံးကစားနေကြတယ်။', 'audio/hsk1/打.mp3', 55),
('hsk1_056', 1, '打车', 'dǎ chē', 'တက္ကစီငှားစီးသည်', 'take a taxi', 'တက္ကစီငှားစီးသည်', '1. 我们打车去吧。\nLet\'s take a taxi.\nငါတို့ တက္ကစီငှားသွားကြစို့။\n\n2. 这里很难打车。\nIt is hard to get a taxi here.\nဒီမှာ တက္ကစီငှားရတာ ခက်တယ်။\n\n3. 你要打车吗？\nDo you want to take a taxi?\nမင်း တက္ကစီစီးမလား။', 'audio/hsk1/打车.mp3', 56),
('hsk1_057', 1, '打电话', 'dǎ diàn huà', 'ဖုန်းဆက်သည်', 'make a phone call', 'ဖုန်းဆက်သည်', '1. 他在打电话。\nHe is on the phone.\nသူ ဖုန်းပြောနေတယ်။\n\n2. 请给我打电话。\nPlease call me.\nကျေးဇူးပြုပြီး ငါ့ဆီ ဖုန်းဆက်ပါ။\n\n3. 我想打家里人的电话。\nI want to call home.\nငါ အိမ်ကလူကို ဖုန်းဆက်ချင်တယ်။', 'audio/hsk1/打电话.mp3', 57),
('hsk1_058', 1, '打开', 'dǎ kāi', 'ဖွင့်သည်', 'open / turn on', 'ဖွင့်သည်', '1. 打开书。\nOpen the book.\nစာအုပ်ဖွင့်ပါ။\n\n2. 打开门。\nOpen the door.\nတံခါးဖွင့်ပါ။\n\n3. 打开电脑。\nTurn on the computer.\nကွန်ပျူတာ ဖွင့်လိုက်ပါ။', 'audio/hsk1/打开.mp3', 58),
('hsk1_059', 1, '打球', 'dǎ qiú', 'ဘောလုံးကစားသည်', 'play ball', 'ဘောလုံးကစားသည်', '1. 我不喜欢打球。\nI don\'t like playing ball.\nငါ ဘောလုံးကစားရတာ မကြိုက်ဘူး။\n\n2. 周末去打球吗？\nGoing to play ball this weekend?\nစနေ၊ တနင်္ဂနွေမှာ ဘောလုံးသွားကစားမလား။\n\n3. 他在学校打球。\nHe is playing ball at school.\nသူ ကျောင်းမှာ ဘောလုံးကစားနေတယ်။', 'audio/hsk1/打球.mp3', 59),
('hsk1_060', 1, '大', 'dà', 'ကြီးသည် / ကြီးမားသော', 'big / large', 'ကြီးသည် / ကြီးမားသော', '1. 这个苹果很大。\nThis apple is very big.\nဒီပန်းသီးက အရမ်းကြီးတယ်။\n\n2. 雨太大了。\nThe rain is too heavy (big).\nမိုး အရမ်းကြီးတယ်။\n\n3. 你的房子很大。\nYour house is very big.\nမင်းရဲ့အိမ်က အရမ်းကြီးတယ်။', 'audio/hsk1/大.mp3', 60),
('hsk1_061', 1, '大学', 'dà xué', 'တက္ကသိုလ်', 'university', 'တက္ကသိုလ်', '1. 我在大学读书。\nI study at a university.\nငါ တက္ကသိုလ်မှာ စာသင်တယ်။\n\n2. 这是一所好大学。\nThis is a good university.\nဒါက တက္ကသိုလ်ကောင်းတစ်ခု ဖြစ်တယ်။\n\n3. 大学很大。\nThe university is very big.\nတက္ကသိုလ်က အရမ်းကြီးတယ်။', 'audio/hsk1/大学.mp3', 61),
('hsk1_062', 1, '大学生', 'dà xué shēng', 'တက္ကသိုလ်ကျောင်းသား', 'university student', 'တက္ကသိုလ်ကျောင်းသား', '1. 他是大学生。\nHe is a university student.\nသူက တက္ကသိုလ်ကျောင်းသား ဖြစ်တယ်။\n\n2. 有很多大学生。\nThere are many university students.\nတက္ကသိုလ်ကျောင်းသားတွေ အများကြီးရှိတယ်။\n\n3. 大学生很忙。\nUniversity students are busy.\nတက္ကသိုလ်ကျောင်းသားတွေ အလုပ်များတယ်။', 'audio/hsk1/大学生.mp3', 62),
('hsk1_063', 1, '到', 'dào', 'ရောက်သည် / သို့', 'arrive / reach / to', 'ရောက်သည် / သို့', '1. 我到了。\nI have arrived.\nငါ ရောက်ပြီ။\n\n2. 从这里到那里。\nFrom here to there.\nဒီကနေ ဟိုအထိ။\n\n3. 火车到站了。\nThe train has arrived at the station.\nရထား ဘူတာကို ဆိုက်ပြီ။', 'audio/hsk1/到.mp3', 63),
('hsk1_064', 1, '得到', 'dé dào', 'ရရှိသည်', 'get / obtain', 'ရရှိသည်', '1. 我也想得到。\nI also want to get it.\nငါလည်း ရချင်တယ်။\n\n2. 他得到了第一名。\nHe got first place.\nသူ ပထမဆု ရခဲ့တယ်။\n\n3. 你得到了什么？\nWhat did you get?\nမင်း ဘာရခဲ့သလဲ။', 'audio/hsk1/得到.mp3', 64),
('hsk1_065', 1, '地', 'de', '\"\"\"စွာ\"\" (ကြိယာဝိသေသန နောက်ဆက်တွဲ)\"', '(adverbial particle)', '\"\"\"စွာ\"\" (ကြိယာဝိသေသန နောက်ဆက်တွဲ)\"', '1. 慢慢地走。\nWalk slowly.\nဖြည်းဖြည်း သွားပါ။\n\n2. 高兴地说。\nSay happily.\nပျော်ပျော်ရွှင်ရွှင် ပြောတယ်။\n\n3. 认真地听。\nListen seriously/carefully.\nသေချာ အာရုံစိုက် နားထောင်ပါ။', 'audio/hsk1/地.mp3', 65),
('hsk1_066', 1, '的', 'de', '\"\"\"ရဲ့\"\" / \"\"သော\"\" (ပိုင်ဆိုင်မှုပြ စကားလုံး)\"', '(possessive particle)', '\"\"\"ရဲ့\"\" / \"\"သော\"\" (ပိုင်ဆိုင်မှုပြ စကားလုံး)\"', '1. 这是我的书。\nThis is my book.\nဒါ ငါ့ရဲ့စာအုပ်။\n\n2. 红色的车。\nRed car.\nအနီရောင် ကား။\n\n3. 漂亮的衣服。\nBeautiful clothes.\nလှပသော အဝတ်အစား။', 'audio/hsk1/的.mp3', 66),
('hsk1_067', 1, '等', 'děng', 'စောင့်သည်', 'wait', 'စောင့်သည်', '1. 请等一下。\nPlease wait a moment.\nခဏလောက် စောင့်ပါ။\n\n2. 我在等你。\nI am waiting for you.\nငါ မင်းကို စောင့်နေတယ်။\n\n3. 不要等我。\nDon\'t wait for me.\nငါ့ကို မစောင့်နဲ့။', 'audio/hsk1/等.mp3', 67),
('hsk1_068', 1, '地', 'dì', 'မြေကြီး', 'ground / earth', 'မြေကြီး', '1. 地很脏。\nThe ground is dirty.\nမြေကြီးက ညစ်ပတ်နေတယ်။\n\n2. 坐在地上。\nSit on the ground.\nမြေကြီးပေါ်မှာ ထိုင်တယ်။\n\n3. 扫地。\nSweep the floor/ground.\nတံမြက်စည်း လှည်းတယ်။', 'audio/hsk1/地.mp3', 68),
('hsk1_069', 1, '地点', 'dì diǎn', 'နေရာ', 'location / place', 'နေရာ', '1. 地点在哪里？\nWhere is the location?\nနေရာက ဘယ်မှာလဲ။\n\n2. 开会地点。\nMeeting location.\nအစည်းအဝေး ကျင်းပမည့်နေရာ။\n\n3. 这个地点很好。\nThis location is very good.\nဒီနေရာက အရမ်းကောင်းတယ်။', 'audio/hsk1/地点.mp3', 69);
INSERT INTO `vocabulary` (`vocab_id`, `hsk_level`, `hanzi`, `pinyin`, `meaning`, `meaning_en`, `meaning_my`, `example`, `audio_asset`, `sort_order`) VALUES
('hsk1_070', 1, '地方', 'dì fang', 'နေရာ / ဒေသ', 'place / local', 'နေရာ / ဒေသ', '1. 这是什么地方？\nWhat place is this?\nဒါ ဘာနေရာလဲ။\n\n2. 这个地方很漂亮。\nThis place is very beautiful.\nဒီနေရာက အရမ်းလှတယ်။\n\n3. 我们换个地方吧。\nLet\'s change to another place.\nငါတို့ နေရာပြောင်းကြစို့။', 'audio/hsk1/地方.mp3', 70),
('hsk1_071', 1, '地上', 'dì shàng', 'မြေကြီးပေါ်', 'on the ground', 'မြေကြီးပေါ်', '1. 地上有水。\nThere is water on the ground.\nမြေကြီးပေါ်မှာ ရေရှိတယ်။\n\n2. 别坐在地上。\nDon\'t sit on the ground.\nမြေကြီးပေါ် မထိုင်နဲ့။\n\n3. 东西掉在地上。\nSomething fell on the ground.\nပစ္စည်း မြေကြီးပေါ် ကျသွားတယ်။', 'audio/hsk1/地上.mp3', 71),
('hsk1_072', 1, '地图', 'dì tú', 'မြေပုံ', 'map', 'မြေပုံ', '1. 我看地图。\nI look at the map.\nငါ မြေပုံကြည့်တယ်။\n\n2. 这是中国地图。\nThis is a map of China.\nဒါက တရုတ်ပြည် မြေပုံဖြစ်တယ်။\n\n3. 地图在墙上。\nThe map is on the wall.\nမြေပုံက နံရံပေါ်မှာ ရှိတယ်။', 'audio/hsk1/地图.mp3', 72),
('hsk1_073', 1, '弟弟', 'dì di', 'မောင်လေး', 'younger brother', 'မောင်လေး', '1. 这是我弟弟。\nThis is my younger brother.\nဒါ ငါ့မောင်လေး။\n\n2. 弟弟几岁了？\nHow old is your younger brother?\nမောင်လေး အသက်ဘယ်လောက်ရှိပြီလဲ။\n\n3. 弟弟在玩儿。\nYounger brother is playing.\nမောင်လေး ကစားနေတယ်။', 'audio/hsk1/弟弟.mp3', 73),
('hsk1_074', 1, '第', 'dì', 'အ...မြောက် (ဂဏန်းစဉ်)', '(prefix for ordinal numbers)', 'အ...မြောက် (ဂဏန်းစဉ်)', '1. 第一名。\nFirst place.\nပထမဆု / ပထမအဆင့်။\n\n2. 第二天。\nThe second day.\nဒုတိယနေ့။\n\n3. 第一次。\nThe first time.\nပထမဆုံးအကြိမ်။', 'audio/hsk1/第.mp3', 74),
('hsk1_075', 1, '点', 'diǎn', 'နာရီ (အချိန်) / အစက် / နည်းနည်း', 'o\'clock / dot / a little', 'နာရီ (အချိန်) / အစက် / နည်းနည်း', '1. 现在几点？\nWhat time is it now?\nအခု ဘယ်နှနာရီလဲ။\n\n2. 五点半。\nFive thirty.\n၅ နာရီခွဲ။\n\n3. 吃一点儿。\nEat a little bit.\nနည်းနည်းလောက် စားပါ။', 'audio/hsk1/点.mp3', 75),
('hsk1_076', 1, '电', 'diàn', 'လျှပ်စစ် / မီး', 'electricity', 'လျှပ်စစ် / မီး', '1. 没有电了。\nThere is no electricity.\nမီးပျက်သွားပြီ / မီးမလာတော့ဘူး။\n\n2. 我想充电。\nI want to charge (electricity).\nငါ အားသွင်းချင်တယ်။\n\n3. 省电。\nSave electricity.\nမီးချွေတာတယ်။', 'audio/hsk1/电.mp3', 76),
('hsk1_077', 1, '电话', 'diàn huà', 'ဖုန်း', 'telephone / phone', 'ဖုန်း', '1. 你的电话号码是多少？\nWhat is your phone number?\nမင်းရဲ့ ဖုန်းနံပါတ် ဘယ်လောက်လဲ။\n\n2. 接电话。\nAnswer the phone.\nဖုန်းကိုင်လိုက်ပါ။\n\n3. 电话响了。\nThe phone is ringing.\nဖုန်းမြည်နေတယ်။', 'audio/hsk1/电话.mp3', 77),
('hsk1_078', 1, '电脑', 'diàn nǎo', 'ကွန်ပျူတာ', 'computer', 'ကွန်ပျူတာ', '1. 我有电脑。\nI have a computer.\nငါ့မှာ ကွန်ပျူတာ ရှိတယ်။\n\n2. 玩电脑游戏。\nPlay computer games.\nကွန်ပျူတာ ဂိမ်းကစားတယ်။\n\n3. 这台电脑很贵。\nThis computer is very expensive.\nဒီကွန်ပျူတာက အရမ်းဈေးကြီးတယ်။', 'audio/hsk1/电脑.mp3', 78),
('hsk1_079', 1, '电视', 'diàn shì', 'ရုပ်မြင်သံကြား / တီဗီ', 'television / TV', 'ရုပ်မြင်သံကြား / တီဗီ', '1. 我看电视。\nI watch TV.\nငါ တီဗီကြည့်တယ်။\n\n2. 电视在客厅。\nThe TV is in the living room.\nတီဗီက ဧည့်ခန်းမှာ ရှိတယ်။\n\n3. 这个电视很大。\nThis TV is very big.\nဒီတီဗီက အရမ်းကြီးတယ်။', 'audio/hsk1/电视.mp3', 79),
('hsk1_080', 1, '电视机', 'diàn shì jī', 'တီဗီစက်', 'TV set', 'တီဗီစက်', '1. 买了一台电视机。\nBought a TV set.\nတီဗီစက်တစ်လုံး ဝယ်ခဲ့တယ်။\n\n2. 这台电视机坏了。\nThis TV set is broken.\nဒီတီဗီစက်က ပျက်နေတယ်။\n\n3. 旧电视机。\nOld TV set.\nတီဗီစက်အဟောင်း။', 'audio/hsk1/电视机.mp3', 80),
('hsk1_081', 1, '电影', 'diàn yǐng', 'ရုပ်ရှင်', 'movie', 'ရုပ်ရှင်', '1. 我看电影。\nI watch a movie.\nငါ ရုပ်ရှင်ကြည့်တယ်။\n\n2. 电影很好看。\nThe movie is very good.\nရုပ်ရှင်က ကြည့်လို့အရမ်းကောင်းတယ်။\n\n3. 我们去看电影吧。\nLet\'s go watch a movie.\nငါတို့ ရုပ်ရှင်သွားကြည့်ကြစို့။', 'audio/hsk1/电影.mp3', 81),
('hsk1_082', 1, '电影院', 'diàn yǐng yuàn', 'ရုပ်ရှင်ရုံ', 'cinema / movie theater', 'ရုပ်ရှင်ရုံ', '1. 电影院在哪儿？\nWhere is the cinema?\nရုပ်ရှင်ရုံ ဘယ်မှာလဲ။\n\n2. 我们在电影院见面。\nWe meet at the cinema.\nငါတို့ ရုပ်ရှင်ရုံမှာ တွေ့ကြမယ်။\n\n3. 这家电影院很大。\nThis cinema is very big.\nဒီရုပ်ရှင်ရုံက အရမ်းကြီးတယ်။', 'audio/hsk1/电影院.mp3', 82),
('hsk1_083', 1, '东', 'dōng', 'အရှေ့ဘက်', 'east', 'အရှေ့ဘက်', '1. 太阳从东方升起。\nThe sun rises from the east.\nနေက အရှေ့ဘက်က ထွက်တယ်။\n\n2. 向东走。\nWalk towards the east.\nအရှေ့ဘက်ကို လျှောက်သွားပါ။\n\n3. 东边有什么？\nWhat is in the east?\nအရှေ့ဘက်မှာ ဘာရှိလဲ။', 'audio/hsk1/东.mp3', 83),
('hsk1_084', 1, '东西', 'dōng xi', 'ပစ္စည်း', 'thing / stuff', 'ပစ္စည်း', '1. 买东西。\nBuy things.\nပစ္စည်းဝယ်တယ်။\n\n2. 这是什么东西？\nWhat is this thing?\nဒါ ဘာပစ္စည်းလဲ။\n\n3. 吃东西。\nEat things (food).\nမုန့်စားတယ် / တစ်ခုခုစားတယ်။', 'audio/hsk1/东西.mp3', 84),
('hsk1_085', 1, '动', 'dòng', 'လှုပ်သည် / ရွေ့သည်', 'move', 'လှုပ်သည် / ရွေ့သည်', '1. 别动。\nDon\'t move.\nမလှုပ်နဲ့။\n\n2. 它在动。\nIt is moving.\nအဲဒါ လှုပ်နေတယ်။\n\n3. 手动了一下。\nThe hand moved a little.\nလက်က နည်းနည်း လှုပ်သွားတယ်။', 'audio/hsk1/动.mp3', 85),
('hsk1_086', 1, '动作', 'dòng zuò', 'လှုပ်ရှားမှု / အမူအရာ', 'action / movement', 'လှုပ်ရှားမှု / အမူအရာ', '1. 动作很快。\nThe movement is very fast.\nလှုပ်ရှားမှုက အရမ်းမြန်တယ်။\n\n2. 这动作很难。\nThis movement is very difficult.\nဒီလှုပ်ရှားမှုက အရမ်းခက်တယ်။\n\n3. 慢动作。\nSlow motion.\nအနှေးပြကွက်။', 'audio/hsk1/动作.mp3', 86),
('hsk1_087', 1, '都', 'dōu', 'အားလုံး / အကုန်လုံး', 'all / both', 'အားလုံး / အကုန်လုံး', '1. 我们都去了。\nWe all went.\nငါတို့အားလုံး သွားခဲ့ကြတယ်။\n\n2. 都要吗？\nDo you want all of them?\nအကုန်လုံး ယူမှာလား။\n\n3. 大家都来了。\nEveryone has come.\nအားလုံး ရောက်နေကြပြီ။', 'audio/hsk1/都.mp3', 87),
('hsk1_088', 1, '读', 'dú', 'ဖတ်သည်', 'read', 'ဖတ်သည်', '1. 读书。\nRead a book / Study.\nစာဖတ်တယ် / စာကျက်တယ်။\n\n2. 你会读这个字吗？\nCan you read this character?\nမင်း ဒီစာလုံးကို ဖတ်တတ်လား။\n\n3. 读给我听。\nRead it to me.\nငါ့ကို ဖတ်ပြပါ။', 'audio/hsk1/读.mp3', 88),
('hsk1_089', 1, '读书', 'dú shū', 'စာဖတ်သည် / ကျောင်းတက်သည်', 'read a book / study', 'စာဖတ်သည် / ကျောင်းတက်သည်', '1. 他喜欢读书。\nHe likes reading books.\nသူ စာဖတ်ရတာ ကြိုက်တယ်။\n\n2. 你在哪儿读书？\nWhere do you study?\nမင်း ဘယ်မှာ ကျောင်းတက်နေလဲ။\n\n3. 好好读书。\nStudy hard.\nစာကို ကောင်းကောင်းကြိုးစားပါ။', 'audio/hsk1/读书.mp3', 89),
('hsk1_090', 1, '对', 'duì', 'မှန်သည် / သို့ / အတွက်', 'right / correct / to / for', 'မှန်သည် / သို့ / အတွက်', '1. 你说的对。\nWhat you said is right.\nမင်းပြောတာ မှန်တယ်။\n\n2. 他对我不客气。\nHe is not polite to me.\nသူ ငါ့အပေါ် အားမနာဘူး။\n\n3. 这对身体好。\nThis is good for the body (health).\nဒါ ကျန်းမာရေးအတွက် ကောင်းတယ်။', 'audio/hsk1/对.mp3', 90),
('hsk1_091', 1, '对不起', 'duì bu qǐ', 'တောင်းပန်ပါတယ်', 'Sorry', 'တောင်းပန်ပါတယ်', '1. 对不起，我迟到了。\n\"Sorry, I am late.\"\nတောင်းပန်ပါတယ်၊ ငါ နောက်ကျသွားတယ်။\n\n2. 说对不起。\nSay sorry.\nတောင်းပန်ပါတယ်လို့ ပြောပါ။\n\n3. 真的对不起。\nI am really sorry.\nတကယ်ကို တောင်းပန်ပါတယ်။', 'audio/hsk1/对不起.mp3', 91),
('hsk1_092', 1, '多', 'duō', 'များသည်', 'many / much', 'များသည်', '1. 很多人。\nMany people.\nလူတွေ အများကြီးပဲ။\n\n2. 多吃点儿。\nEat more.\nများများစားပါ။\n\n3. 多少钱？\nHow much money?\nပိုက်ဆံ ဘယ်လောက်လဲ။', 'audio/hsk1/多.mp3', 92),
('hsk1_093', 1, '多少', 'duō shao', 'ဘယ်လောက် (အရေအတွက်)', 'how many / how much', 'ဘယ်လောက် (အရေအတွက်)', '1. 有多少人？\nHow many people are there?\nလူဘယ်နှယောက် ရှိလဲ။\n\n2. 这个多少钱？\nHow much is this?\nဒါ ဘယ်လောက်လဲ။\n\n3. 你知道多少？\nHow much do you know?\nမင်း ဘယ်လောက် သိလဲ။', 'audio/hsk1/多少.mp3', 93),
('hsk1_094', 1, '饿', 'è', 'ဗိုက်ဆာသည်', 'hungry', 'ဗိုက်ဆာသည်', '1. 我饿了。\nI am hungry.\nငါ ဗိုက်ဆာပြီ။\n\n2. 你不饿吗？\nAre you not hungry?\nမင်း ဗိုက်မဆာဘူးလား။\n\n3. 肚子很饿。\nStomach is very hungry.\nဗိုက် အရမ်းဆာနေတယ်။', 'audio/hsk1/饿.mp3', 94),
('hsk1_095', 1, '儿子', 'ér zi', 'သား (သားယောက်ျားလေး)', 'son', 'သား (သားယောက်ျားလေး)', '1. 他是我儿子。\nHe is my son.\nသူက ငါ့သားပါ\n\n2. 儿子三岁了。\nSon is three years old.\nသားလေး အသက် ၃ နှစ်ရှိပြီ။\n\n3. 带儿子去公园。\nTake son to the park.\nသားကို ပန်းခြံခေါ်သွားတယ်။', 'audio/hsk1/儿子.mp3', 95),
('hsk1_096', 1, '二', 'èr', 'နှစ် (ဂဏန်း)', 'two', 'နှစ် (ဂဏန်း)', '1. 二月。\nFebruary.\nဖေဖော်ဝါရီလ။\n\n2. 两个人。(liǎng)\nTwo people.\nလူ နှစ်ယောက်။\n\n3. 第二。\nSecond.\nဒုတိယ။', 'audio/hsk1/二.mp3', 96),
('hsk1_097', 1, '饭', 'fàn', 'ထမင်း', 'rice / meal', 'ထမင်း', '1. 吃了吗？\nHave you eaten?\nထမင်းစားပြီးပြီလား။\n\n2. 我不想吃饭。\nI don\'t want to eat rice/meal.\nငါ ထမင်းမစားချင်ဘူး။\n\n3. 做饭。\nCook rice/meal.\nထမင်းချက်တယ်။', 'audio/hsk1/饭.mp3', 97),
('hsk1_098', 1, '饭店', 'fàn diàn', 'စားသောက်ဆိုင် / ဟိုတယ်', 'restaurant / hotel', 'စားသောက်ဆိုင် / ဟိုတယ်', '1. 去饭店吃饭。\nGo to a restaurant to eat.\nစားသောက်ဆိုင်သွားပြီး ထမင်းစားတယ်။\n\n2. 这家饭店很有名。\nThis restaurant is very famous.\nဒီစားသောက်ဆိုင်က အရမ်းနာမည်ကြီးတယ်။\n\n3. 住在饭店。\nStay in a hotel.\nဟိုတယ်မှာ တည်းတယ်။', 'audio/hsk1/饭店.mp3', 98),
('hsk1_099', 1, '方便', 'fāng biàn', 'အဆင်ပြေသည်', 'convenient', 'အဆင်ပြေသည်', '1. 这儿交通很方便。\nThe transportation here is very convenient.\nဒီမှာ သွားလာရေး သိပ်အဆင်ပြေတယ်။\n\n2. 什么时候方便？\nWhen is it convenient?\nဘယ်အချိန် အဆင်ပြေမလဲ။\n\n3. 如果不方便就算了。\n\"If it\'s not convenient, forget it.\"\nအဆင်မပြေရင်လည်း ထားလိုက်ပါတော့။', 'audio/hsk1/方便.mp3', 99),
('hsk1_100', 1, '方便面', 'fāng biàn miàn', 'ခေါက်ဆွဲခြောက် (အသင့်စား)', 'instant noodles', 'ခေါက်ဆွဲခြောက် (အသင့်စား)', '1. 我经常吃方便面。\nI often eat instant noodles.\nငါ ခေါက်ဆွဲခြောက် ခဏခဏစားတယ်။\n\n2. 泡一碗方便面。\nMake a bowl of instant noodles.\nခေါက်ဆွဲခြောက် တစ်ပန်းကန်လောက် ပြုတ်စားမယ်။\n\n3. 少吃方便面。\nEat less instant noodles.\nခေါက်ဆွဲခြောက် လျှော့စားပါ။', 'audio/hsk1/方便面.mp3', 100),
('hsk1_101', 1, '房', 'fáng', 'အိမ် / အခန်း', 'house / room', 'အိမ် / အခန်း', '1. 买房。\nBuy a house.\nအိမ်ဝယ်တယ်။\n\n2. 房里没人。\nThere is no one in the room/house.\nအခန်းထဲမှာ လူမရှိဘူး။\n\n3. 这个房子很大。\nThis house is very big.\nဒီအိမ်အရမ်းကြီးတယ်။', 'audio/hsk1/房.mp3', 101),
('hsk1_102', 1, '房间', 'fáng jiān', 'အခန်း', 'room', 'အခန်း', '1. 这是我的房间。\nThis is my room.\nဒါ ငါ့အခန်း။\n\n2. 房间很干净。\nThe room is very clean.\nအခန်းက အရမ်းသန့်ရှင်းတယ်။\n\n3. 打扫房间。\nClean the room.\nအခန်းသန့်ရှင်းရေး လုပ်တယ်။', 'audio/hsk1/房间.mp3', 102),
('hsk1_103', 1, '房子', 'fáng zi', 'အိမ်', 'house / building', 'အိမ်', '1. 这房子太贵了。\nThis house is too expensive.\nဒီအိမ်က အရမ်းဈေးကြီးတယ်။\n\n2. 我想租房子。\nI want to rent a house.\nငါ အိမ်ငှားချင်တယ်။\n\n3. 新房子。\nNew house.\nအိမ်အသစ်။', 'audio/hsk1/房子.mp3', 103),
('hsk1_104', 1, '放', 'fàng', 'ထားသည် / လွှတ်သည်', 'put / place / set free', 'ထားသည် / လွှတ်သည်', '1. 把书放在桌子上。\nPut the book on the table.\nစာအုပ်ကို စားပွဲပေါ်တင်လိုက်ပါ။\n\n2. 放学了。\nSchool is over (released).\nကျောင်းဆင်းပြီ။\n\n3. 别放辣椒。\nDon\'t put chili.\nငရုတ်သီး မထည့်ပါနဲ့။', 'audio/hsk1/放.mp3', 104),
('hsk1_105', 1, '放假', 'fàng jià', 'ကျောင်းပိတ်သည် / အလုပ်ပိတ်သည်', 'have a holiday', 'ကျောင်းပိတ်သည် / အလုပ်ပိတ်သည်', '1. 明天放假。\nTomorrow is a holiday.\nမနက်ဖြန် ပိတ်ရက်။\n\n2. 我们放假了。\nWe are on holiday.\nငါတို့ ကျောင်းပိတ်ပြီ။\n\n3. 什么时候放假？\nWhen does the holiday start?\nဘယ်တော့ ပိတ်မှာလဲ။', 'audio/hsk1/放假.mp3', 105),
('hsk1_106', 1, '放学', 'fàng xué', 'ကျောင်းဆင်းသည်', 'finish school', 'ကျောင်းဆင်းသည်', '1. 几点放学？\nWhat time does school finish?\nဘယ်အချိန် ကျောင်းဆင်းလဲ။\n\n2. 放学后见。\nSee you after school.\nကျောင်းဆင်းမှ တွေ့မယ်။\n\n3. 我去接孩子放学。\nI am going to pick up the child from school.\nငါ ကလေး ကျောင်းကြိုသွားမလို့။', 'audio/hsk1/放学.mp3', 106),
('hsk1_107', 1, '飞', 'fēi', 'ပျံသည်', 'fly', 'ပျံသည်', '1. 鸟在飞。\nBirds are flying.\nငှက်တွေ ပျံနေတယ်။\n\n2. 飞往北京。\nFly to Beijing.\nပေကျင်းသို့ ပျံသန်းမယ်။\n\n3. 时间飞快。\nTime flies fast.\nအချိန်ကုန်တာ အရမ်းမြန်တယ်။', 'audio/hsk1/飞.mp3', 107),
('hsk1_108', 1, '飞机', 'fēi jī', 'လေယာဉ်ပျံ', 'airplane', 'လေယာဉ်ပျံ', '1. 坐飞机去。\nGo by airplane.\nလေယာဉ်နဲ့ သွားမယ်။\n\n2. 飞机晚点了。\nThe plane is delayed.\nလေယာဉ် နောက်ကျနေတယ်။\n\n3. 他在飞机上。\nHe is on the plane.\nသူ လေယာဉ်ပေါ်မှာ။', 'audio/hsk1/飞机.mp3', 108),
('hsk1_109', 1, '非常', 'fēi cháng', 'အလွန် / သိပ် / အရမ်း', 'very / extremely', 'အလွန် / သိပ် / အရမ်း', '1. 非常好。\nVery good.\nအရမ်းကောင်းတယ်။\n\n2. 我非常喜欢。\nI like it very much.\nငါ အရမ်းကြိုက်တယ်။\n\n3. 非常感谢。\nThank you very much.\nအရမ်း ကျေးဇူးတင်ပါတယ်။', 'audio/hsk1/非常.mp3', 109),
('hsk1_110', 1, '分', 'fēn', 'မိနစ် / ခွဲသည် / အမှတ်', 'minute / divide / point', 'မိနစ် / ခွဲသည် / အမှတ်', '1. 现在九点十分。\nIt is 9:10 now.\nအခု ၉ နာရီ ၁၀ မိနစ် ရှိပြီ။\n\n2. 把蛋糕分了。\nDivide the cake.\nကိတ်မုန့်ကို ခွဲလိုက်ပါ။\n\n3. 考了一百分。\nScored 100 points.\nအမှတ် ၁၀၀ ရခဲ့တယ်။', 'audio/hsk1/分.mp3', 110),
('hsk1_111', 1, '分钟', 'fēn zhōng', 'မိနစ်', 'minute (duration)', 'မိနစ်', '1. 等几分钟。\nWait a few minutes.\nမိနစ်နည်းနည်းလောက် စောင့်ပါ။\n\n2. 二十分钟。\nTwenty minutes.\nမိနစ် ၂၀။\n\n3. 还要五分钟。\nFive more minutes needed.\nနောက်ထပ် ၅ မိနစ် လိုသေးတယ်။', 'audio/hsk1/分钟.mp3', 111),
('hsk1_112', 1, '风', 'fēng', 'လေ', 'wind', 'လေ', '1. 今天风很大。\nThe wind is strong today.\nဒီနေ့ လေအရမ်းတိုက်တယ်။\n\n2. 刮风了。\nIt is windy.\nလေတိုက်နေတယ်။\n\n3. 没有风。\nThere is no wind.\nလေမတိုက်ဘူး။', 'audio/hsk1/风.mp3', 112),
('hsk1_113', 1, '干', 'gān / gàn', 'ခြောက်သွေ့သည် / လုပ်သည်', 'dry / to do', 'ခြောက်သွေ့သည် / လုပ်သည်', '1. 衣服干了。 (gān)\nThe clothes are dry.\nအဝတ်အစားတွေ ခြောက်ပြီ။\n\n2. 你要干什么？ (gàn)\nWhat do you want to do?\nမင်း ဘာလုပ်ချင်လို့လဲ။\n\n3. 好好干。 (gàn)\nDo a good job.\nအလုပ်ကို ကောင်းကောင်းလုပ်ပါ။', 'audio/hsk1/干.mp3', 113),
('hsk1_114', 1, '干净', 'gān jìng', 'သန့်ရှင်းသည်', 'clean', 'သန့်ရှင်းသည်', '1. 这水很干净。\nThis water is very clean.\nဒီရေက အရမ်းသန့်တယ်။\n\n2. 把手洗干净。\nWash your hands clean.\nလက်ကို ပြောင်အောင်ဆေးပါ။\n\n3. 不干净。\nNot clean.\nမသန့်ရှင်းဘူး။', 'audio/hsk1/干净.mp3', 114),
('hsk1_115', 1, '干什么', 'gàn shén me', 'ဘာလုပ်တာလဲ', 'what to do / why', 'ဘာလုပ်တာလဲ', '1. 你在干什么？\nWhat are you doing?\nမင်း ဘာလုပ်နေတာလဲ။\n\n2. 去那里干什么？\nWhat are you going there for?\nဟိုကို ဘာသွားလုပ်မှာလဲ။\n\n3. 你想干什么？\nWhat do you want to do?\nမင်း ဘာလုပ်ချင်တာလဲ။', 'audio/hsk1/干什么.mp3', 115),
('hsk1_116', 1, '高', 'gāo', 'မြင့်သည် / အရပ်ရှည်သည်', 'high / tall', 'မြင့်သည် / အရပ်ရှည်သည်', '1. 他很高。\nHe is very tall.\nသူ အရမ်းအရပ်ရှည်တယ်။\n\n2. 价格很高。\nThe price is very high.\nဈေးနှုန်းက အရမ်းမြင့်တယ်။\n\n3. 高兴。\nHappy (High spirit).\nပျော်ရွှင်တယ်။', 'audio/hsk1/高.mp3', 116),
('hsk1_117', 1, '高兴', 'gāo xìng', 'ပျော်သည် / ဝမ်းသာသည်', 'happy', 'ပျော်သည် / ဝမ်းသာသည်', '1. 很高兴认识你。\nNice to meet you.\nမင်းနဲ့တွေ့ရတာ ဝမ်းသာပါတယ်။\n\n2. 他看起来很高兴。\nHe looks very happy.\nကြည့်ရတာ သူပျော်နေပုံပဲ။\n\n3. 不高兴。\nNot happy / Upset.\nမပျော်ဘူး / စိတ်မကြည်ဘူး။', 'audio/hsk1/高兴.mp3', 117),
('hsk1_118', 1, '告诉', 'gào su', 'ပြောပြသည်', 'tell', 'ပြောပြသည်', '1. 请告诉我。\nPlease tell me.\nငါ့ကို ပြောပြပါ။\n\n2. 别告诉他。\nDon\'t tell him.\nသူ့ကို မပြောနဲ့။\n\n3. 我告诉你一个秘密。\nI will tell you a secret.\nငါ မင်းကို လျှို့ဝှက်ချက်တစ်ခု ပြောပြမယ်။', 'audio/hsk1/告诉.mp3', 118),
('hsk1_119', 1, '哥哥', 'gē ge', 'အစ်ကို', 'older brother', 'အစ်ကို', '1. 我有两个哥哥。\nI have two older brothers.\nငါ့မှာ အစ်ကို နှစ်ယောက်ရှိတယ်။\n\n2. 哥哥比我大两岁。\nMy older brother is two years older than me.\nအစ်ကိုက ငါ့ထက်၂နှစ် ကြီးတယ်။\n\n3. 那是你哥哥吗？\nIs that your older brother?\nအဲဒါ မင်းရဲ့ အစ်ကိုလား။', 'audio/hsk1/哥哥.mp3', 119),
('hsk1_120', 1, '个', 'gè', 'ခု / ယောက် (အရေအတွက်ပြ စကားလုံး)', '(measure word)', 'ခု / ယောက် (အရေအတွက်ပြ စကားလုံး)', '1. 一个苹果。\nOne apple.\nပန်းသီး တစ်လုံး။\n\n2. 三个人。\nThree people.\nလူ သုံးယောက်။\n\n3. 这个很好。\nThis one is very good.\nဒါ (ဒီတစ်ခု) အရမ်းကောင်းတယ်။', 'audio/hsk1/个.mp3', 120),
('hsk1_121', 1, '给', 'gěi', 'ပေးသည် / ဖို့', 'give / for', 'ပေးသည် / ဖို့', '1. 请给我一杯水。\nPlease give me a cup of water.\nကျေးဇူးပြုပြီး ငါ့ကို ရေတစ်ခွက် ပေးပါ။\n\n2. 我给你买的。\nI bought this for you.\nငါ ဒါ မင်းအတွက် ဝယ်လာတာ။\n\n3. 把书给他。\nGive the book to him.\nစာအုပ်ကို သူ့ဆီ ပေးလိုက်ပါ။', 'audio/hsk1/给.mp3', 121),
('hsk1_122', 1, '跟', 'gēn', 'နှင့် / လိုက်သည်', 'with / follow', 'နှင့် / လိုက်သည်', '1. 我跟你去。\nI will go with you.\nငါ မင်းနဲ့ လိုက်သွားမယ်။\n\n2. 跟我来。\nCome with me / Follow me.\nငါ့နောက် လိုက်ခဲ့။\n\n3. 他跟爸爸一样高。\nHe is as tall as his father.\nသူက သူ့အဖေနဲ့ အရပ်တူတူပဲ။', 'audio/hsk1/跟.mp3', 122),
('hsk1_123', 1, '工人', 'gōng rén', 'အလုပ်သမား', 'worker', 'အလုပ်သမား', '1. 他在工厂当工人。\nHe works as a worker in a factory.\nသူ စက်ရုံမှာ အလုပ်သမား လုပ်တယ်။\n\n2. 这里有很多工人。\nThere are many workers here.\nဒီမှာ အလုပ်သမားတွေ အများကြီးရှိတယ်။\n\n3. 工人很辛苦。\nWorkers work very hard.\nအလုပ်သမားတွေ အရမ်းပင်ပန်းတယ်။', 'audio/hsk1/工人.mp3', 123),
('hsk1_124', 1, '工作', 'gōng zuò', 'အလုပ် / အလုပ်လုပ်သည်', 'work / job', 'အလုပ် / အလုပ်လုပ်သည်', '1. 你在哪里工作？\nWhere do you work?\nမင်း ဘယ်မှာ အလုပ်လုပ်လဲ။\n\n2. 我有一份新工作。\nI have a new job.\nငါ့မှာ အလုပ်အသစ်တစ်ခု ရှိတယ်။\n\n3. 工作很忙。\nWork is busy.\nအလုပ်က များတယ်။', 'audio/hsk1/工作.mp3', 124),
('hsk1_125', 1, '公共汽车', 'gōng gòng qì chē', 'ဘတ်စ်ကား', 'bus', 'ဘတ်စ်ကား', '1. 坐公共汽车去。\nGo by bus.\nဘတ်စ်ကား စီးသွားမယ်။\n\n2. 公共汽车来了。\nThe bus is coming.\nဘတ်စ်ကား လာပြီ။\n\n3. 公共汽车站。\nBus station / Bus stop.\nဘတ်စ်ကား မှတ်တိုင်။', 'audio/hsk1/公共汽车.mp3', 125),
('hsk1_126', 1, '公斤', 'gōng jīn', 'ကီလိုဂရမ်', 'kilogram (kg)', 'ကီလိုဂရမ်', '1. 一公斤多少钱？\nHow much is one kilogram?\nတစ်ကီလို ဘယ်လောက်လဲ။\n\n2. 我要买两公斤。\nI want to buy two kilograms.\nငါ နှစ်ကီလို ဝယ်ချင်တယ်။\n\n3. 我的行李有二十公斤。\nMy luggage is 20 kilograms.\nငါ့အိတ်က ၂၀ ကီလို ရှိတယ်။', 'audio/hsk1/公斤.mp3', 126),
('hsk1_127', 1, '公里', 'gōng lǐ', 'ကီလိုမီတာ', 'kilometer (km)', 'ကီလိုမီတာ', '1. 这里离学校有五公里。\nHere is 5 kilometers away from the school.\nဒီနေရာက ကျောင်းနဲ့ ၅ ကီလိုမီတာ ဝေးတယ်။\n\n2. 每天跑三公里。\nRun 3 kilometers every day.\nနေ့တိုင်း ၃ ကီလိုမီတာ ပြေးတယ်။\n\n3. 一百公里。\n100 kilometers.\nကီလိုမီတာ ၁၀၀။', 'audio/hsk1/公里.mp3', 127),
('hsk1_128', 1, '公园', 'gōng yuán', 'ပန်းခြံ', 'park', 'ပန်းခြံ', '1. 我们去公园玩吧。\nLet\'s go play in the park.\nငါတို့ ပန်းခြံသွား လည်ကြစို့။\n\n2. 公园里有很多花。\nThere are many flowers in the park.\nပန်းခြံထဲမှာ ပန်းတွေ အများကြီး ရှိတယ်။\n\n3. 他在公园跑步。\nHe runs in the park.\nသူ ပန်းခြံထဲမှာ ပြေးနေတယ်။', 'audio/hsk1/公园.mp3', 128),
('hsk1_129', 1, '狗', 'gǒu', 'ခွေး', 'dog', 'ခွေး', '1. 我喜欢狗。\nI like dogs.\nငါ ခွေးကြိုက်တယ်။\n\n2. 这是一只小狗。\nThis is a small dog / puppy.\nဒါက ခွေးလေးတစ်ကောင် ဖြစ်တယ်။\n\n3. 小心狗。\nBeware of the dog.\nခွေး သတိထားပါ။', 'audio/hsk1/狗.mp3', 129),
('hsk1_130', 1, '够', 'gòu', 'လုံလောက်သည်', 'enough', 'လုံလောက်သည်', '1. 钱够吗？\nIs the money enough?\nပိုက်ဆံ လောက်ရဲ့လား။\n\n2. 够了，谢谢。\n\"That\'s enough, thank you.\"\nတော်ပါပြီ (လောက်ပါပြီ)၊ ကျေးဇူးပါ။\n\n3. 时间不够。\nNot enough time.\nအချိန် မလောက်ဘူး။', 'audio/hsk1/够.mp3', 130),
('hsk1_131', 1, '关', 'guān', 'ပိတ်သည်', 'close / turn off', 'ပိတ်သည်', '1. 关门。\nClose the door.\nတံခါး ပိတ်လိုက်ပါ။\n\n2. 请关灯。\nPlease turn off the light.\nကျေးဇူးပြုပြီး မီးပိတ်ပေးပါ။\n\n3. 手机关了。\nThe mobile phone is turned off.\nဖုန်းပိတ်ထားတယ်။', 'audio/hsk1/关.mp3', 131),
('hsk1_132', 1, '关上', 'guān shàng', 'ပိတ်လိုက်သည်', 'close', 'ပိတ်လိုက်သည်', '1. 把书关上。\nClose the book.\nစာအုပ် ပိတ်လိုက်ပါ။\n\n2. 把窗户关上。\nClose the window.\nပြတင်းပေါက် ပိတ်လိုက်ပါ။\n\n3. 门关上了。\nThe door is closed.\nတံခါး ပိတ်ထားတယ်။', 'audio/hsk1/关上.mp3', 132),
('hsk1_133', 1, '贵', 'guì', 'ဈေးကြီးသည် / မြင့်မြတ်သော', 'expensive / noble', 'ဈေးကြီးသည် / မြင့်မြတ်သော', '1. 太贵了。\nToo expensive.\nဈေးကြီးလွန်းတယ်။\n\n2. 便宜一点吧，太贵了。\n\"A little cheaper please, it is too expensive.\"\nဈေးနည်းနည်း လျှော့ပါဦး၊ စျေးအရမ်းကြီးတယ်။\n\n3. 您贵姓？\nWhat is your honorable surname?\nခင်ဗျား နာမည် (မျိုးရိုးနာမည်) ဘယ်လိုခေါ်လဲ။', 'audio/hsk1/贵.mp3', 133),
('hsk1_134', 1, '国', 'guó', 'နိုင်ငံ', 'country', 'နိုင်ငံ', '1. 哪国人？\nWhich country person?\nဘယ်နိုင်ငံသားလဲ။\n\n2. 出国。\nGo abroad.\nနိုင်ငံခြား သွားတယ်။\n\n3. 回国。\nReturn to one\'s country.\nကိုယ့်နိုင်ငံ ပြန်တယ်။', 'audio/hsk1/国.mp3', 134),
('hsk1_135', 1, '国家', 'guó jiā', 'နိုင်ငံ', 'country / nation', 'နိုင်ငံ', '1. 这是哪个国家？\nWhich country is this?\nဒါ ဘယ်နိုင်ငံလဲ။\n\n2. 爱自己的国家。\nLove one\'s own country.\nကိုယ့်နိုင်ငံကို ချစ်တယ်။\n\n3. 国家很大。\nThe country is very big.\nနိုင်ငံက အရမ်းကြီးတယ်။', 'audio/hsk1/国家.mp3', 135),
('hsk1_136', 1, '国外', 'guó wài', 'ပြည်ပ / နိုင်ငံခြား', 'abroad / overseas', 'ပြည်ပ / နိုင်ငံခြား', '1. 他在国外读书。\nHe studies abroad.\nသူ နိုင်ငံခြားမှာ ကျောင်းတက်နေတယ်။\n\n2. 我想去国外旅游。\nI want to travel abroad.\nငါ နိုင်ငံခြားခရီး သွားချင်တယ်။\n\n3. 来自国外。\nFrom abroad.\nနိုင်ငံခြားက လာတယ်။', 'audio/hsk1/国外.mp3', 136),
('hsk1_137', 1, '过', 'guò', 'ဖြတ်သန်းသည် / ဖူးသည် (အတွေ့အကြုံ)', 'pass / (particle indicating experience)', 'ဖြတ်သန်းသည် / ဖူးသည် (အတွေ့အကြုံ)', '2. 过去看看。\nGo over and have a look.\nဟိုဘက် သွားကြည့်လိုက်ပါ။\n\n3. 我去过中国。\nI have been to China.\nငါ တရုတ်ပြည် ရောက်ဖူးတယ်။', 'audio/hsk1/过.mp3', 137),
('hsk1_138', 1, '还', 'hái', 'သေးသည် / လည်း', 'still / yet / also', 'သေးသည် / လည်း', '1. 还没好。\nNot ready/done yet.\nမပြီးသေးဘူး။\n\n2. 还有吗？\nIs there any more?\nကျန်သေးလား / ရှိသေးလား။\n\n3. 我还想吃。\nI still want to eat.\nငါ စားချင်သေးတယ်။', 'audio/hsk1/还.mp3', 138),
('hsk1_139', 1, '还是', 'hái shi', 'သို့မဟုတ် / ဒါမှမဟုတ် (မေးခွန်း)', 'or / still', 'သို့မဟုတ် / ဒါမှမဟုတ် (မေးခွန်း)', '1. 你喝茶还是喝咖啡？\nDo you drink tea or coffee?\nမင်း လက်ဖက်ရည်သောက်မလား၊ ကော်ဖီသောက်မလား။\n\n2. 是他还是你？\nIs it him or you?\nသူလား၊ ဒါမှမဟုတ်မင်းလား။\n\n3. 还是去吧。\nHad better go.\nသွားတာ ပိုကောင်းမယ်။', 'audio/hsk1/还是.mp3', 139),
('hsk1_140', 1, '孩子', 'hái zi', 'ကလေး', 'child / children', 'ကလေး', '1. 我有两个孩子。\nI have two children.\nငါ့မှာ ကလေး နှစ်ယောက်ရှိတယ်။\n\n2. 孩子在睡觉。\nThe child is sleeping.\nကလေး အိပ်နေတယ်။\n\n3. 是个好孩子。\nHe is a good child.\nကလေးလိမ္မာလေး ဖြစ်တယ်။', 'audio/hsk1/孩子.mp3', 140),
('hsk1_141', 1, '汉语', 'hàn yǔ', 'တရုတ်စကား / တရုတ်စာ', 'Chinese language', 'တရုတ်စကား / တရုတ်စာ', '1. 我在学汉语。\nI am learning Chinese.\nငါ တရုတ်စာလေ့လာတယ်။\n\n2. 汉语很难。\nChinese is difficult.\nတရုတ်စာက ခက်တယ်။\n\n3. 你会说汉语吗？\nCan you speak Chinese?\nမင်း တရုတ်စကား ပြောတတ်လား။', 'audio/hsk1/汉语.mp3', 141),
('hsk1_142', 1, '汉字', 'hàn zì', 'တရုတ်စာလုံး', 'Chinese character', 'တရုတ်စာလုံး', '1. 我不认识这个汉字。\nI don\'t know this Chinese character.\nငါ ဒီတရုတ်စာလုံးကို မသိဘူး။\n\n2. 写汉字。\nWrite Chinese characters.\nတရုတ်စာလုံး ရေးတယ်။\n\n3. 汉字很有趣。\nChinese characters are very interesting.\nတရုတ်စာလုံးတွေက အရမ်းစိတ်ဝင်စားဖို့ကောင်းတယ်။', 'audio/hsk1/汉字.mp3', 142),
('hsk1_143', 1, '好', 'hǎo', 'ကောင်းသည်', 'good / well', 'ကောင်းသည်', '1. 你好。\nHello.\nမင်္ဂလာပါ။\n\n2. 好主意。\nGood idea.\nအကြံကောင်းပဲ။\n\n3. 身体好吗？\nIs your health good? (How are you?)\nနေကောင်းလား။', 'audio/hsk1/好.mp3', 143),
('hsk1_144', 1, '好吃', 'hǎo chī', 'စားကောင်းသည် / အရသာရှိသည်', 'delicious', 'စားကောင်းသည် / အရသာရှိသည်', '1. 这个很好吃。\nThis is very delicious.\nဒါ အရမ်းစားကောင်းတယ်။\n\n2. 妈妈做的饭好吃。\nThe food Mom cooks is delicious.\nအမေချက်တဲ့ ထမင်းက စားကောင်းတယ်။\n\n3. 有什么好吃的？\nIs there anything good to eat?\nစားစရာကောင်းတာ ဘာရှိလဲ။', 'audio/hsk1/好吃.mp3', 144),
('hsk1_145', 1, '好看', 'hǎo kàn', 'ကြည့်ကောင်းသည် / လှသည်', 'good-looking', 'ကြည့်ကောင်းသည် / လှသည်', '1. 这件衣服很好看。\nThis piece of clothing looks very good.\nဒီအဝတ်အစားက ကြည့်လို့အရမ်းကောင်းတယ်။\n\n2. 电影很好看。\nThe movie is very good.\nရုပ်ရှင်က ကြည့်လို့ကောင်းတယ်။\n\n3. 你也很好看。\nYou look good too.\nမင်းလည်း ကြည့်ကောင်းပါတယ်။ (မင်းလည်း လှပါတယ်)', 'audio/hsk1/好看.mp3', 145),
('hsk1_146', 1, '好听', 'hǎo tīng', 'နားထောင်ကောင်းသည်', 'pleasant to hear', 'နားထောင်ကောင်းသည်', '1. 这首歌很好听。\nThis song is very good.\nဒီသီချင်းက အရမ်းနားထောင်ကောင်းတယ်။\n\n2. 他的声音很好听。\nHis voice is very pleasant.\nသူ့အသံက နားထောင်လို့ကောင်းတယ်။\n\n3. 名字很好听。\nThe name sounds good.\nနာမည်က နားထောင်လို့ကောင်းတယ်။', 'audio/hsk1/好听.mp3', 146),
('hsk1_147', 1, '好玩', 'hǎo wán', 'ပျော်စရာကောင်းသည်', 'fun', 'ပျော်စရာကောင်းသည်', '1. 这里很好玩。\nThis place is very fun.\nဒီနေရာက အရမ်းပျော်ဖို့ကောင်းတယ်။\n\n2. 这个游戏好玩吗？\nIs this game fun?\nဒီဂိမ်းက ပျော်ဖို့ကောင်းလား။\n\n3. 真好玩。\nReally fun.\nတကယ် ပျော်ဖို့ကောင်းတယ်။', 'audio/hsk1/好玩.mp3', 147),
('hsk1_148', 1, '号', 'hào', 'ရက်စွဲ / နံပါတ်', 'number / date', 'ရက်စွဲ / နံပါတ်', '1. 今天是几号？\nWhat is the date today?\nဒီနေ့ ဘယ်နှရက်နေ့လဲ။\n\n2. 你的房间号是多少？\nWhat is your room number?\nမင်းရဲ့ အခန်းနံပါတ် ဘယ်လောက်လဲ။\n\n3. 五号。\nNumber 5 / The 5th.\nနံပါတ် ၅ / ၅ ရက်နေ့။', 'audio/hsk1/号.mp3', 148),
('hsk1_149', 1, '喝', 'hē', 'သောက်သည်', 'drink', 'သောက်သည်', '1. 我想喝水。\nI want to drink water.\nငါ ရေသောက်ချင်တယ်။\n\n2. 喝茶吗？\nDo you drink tea?\nလက်ဖက်ရည် သောက်မလား။\n\n3. 别喝太多。\nDon\'t drink too much.\nအရမ်းအများကြီး မသောက်နဲ့။', 'audio/hsk1/喝.mp3', 149),
('hsk1_150', 1, '和', 'hé', 'နှင့် / ပြီးတော့', 'and / with', 'နှင့် / ပြီးတော့', '1. 我和你。\nMe and you.\nငါနဲ့ မင်း။\n\n2. 爸爸和妈妈。\nDad and Mom.\nအဖေနဲ့ အမေ။\n\n3. 我想和你说话。\nI want to speak with you.\nငါ မင်းနဲ့ စကားပြောချင်တယ်။', 'audio/hsk1/和.mp3', 150),
('hsk1_151', 1, '很', 'hěn', 'သိပ် / အလွန် / အရမ်း', 'very', 'သိပ် / အလွန် / အရမ်း', '1. 很好。\nVery good.\nအရမ်းကောင်းတယ်။\n\n2. 很大。\nVery big.\nအရမ်းကြီးတယ်။\n\n3. 我很喜欢。\nI like it very much.\nငါ အရမ်းကြိုက်တယ်။', 'audio/hsk1/很.mp3', 151),
('hsk1_152', 1, '后', 'hòu', 'နောက် / ပြီးနောက် / အနောက်ဘက်', 'after / back / behind', 'နောက် / ပြီးနောက် / အနောက်ဘက်', '1. 三天后。\nAfter three days.\n၃ ရက် ကြာပြီးနောက်။\n\n2. 后来。\nAfterwards.\nနောက်ပိုင်းမှာ။\n\n3. 看后边。\nLook behind.\nအနောက်ကို ကြည့်လိုက်။', 'audio/hsk1/后.mp3', 152),
('hsk1_153', 1, '后天', 'hòu tiān', 'သဘက်ခါ (မနက်ဖြန်ခါတစ်ပတ်)', 'day after tomorrow', 'သဘက်ခါ (မနက်ဖြန်ခါတစ်ပတ်)', '1. 后天见。\nSee you the day after tomorrow.\nသဘက်ခါမှ တွေ့မယ်။\n\n2. 后天是我生日。\nThe day after tomorrow is my birthday.\nသဘက်ခါ ငါ့မွေးနေ့။\n\n3. 我后天去。\nI will go the day after tomorrow.\nငါ သဘက်ခါ သွားမယ်။', 'audio/hsk1/后天.mp3', 153),
('hsk1_154', 1, '花', 'huā', 'ပန်း / (ပိုက်ဆံ) သုံးသည်', 'flower / to spend', 'ပန်း / (ပိုက်ဆံ) သုံးသည်', '1. 这朵花很美。\nThis flower is beautiful.\nဒီပန်းပွင့်က အရမ်းလှတယ်။\n\n2. 红色的花。\nRed flower.\nပန်းအနီ။\n\n3. 花钱。\nSpend money.\nပိုက်ဆံသုံးတယ်။', 'audio/hsk1/花.mp3', 154),
('hsk1_155', 1, '话', 'huà', 'စကား', 'word / talk', 'စကား', '1. 我有话对你说。\nI have something to tell you.\nငါ မင်းကို ပြောစရာစကား ရှိတယ်။\n\n2. 听不懂他的话。\nCannot understand his words.\nသူပြောတဲ့စကားကို နားမလည်ဘူး။\n\n3. 说中文。\nSpeak Chinese.\nတရုတ်စကား ပြောပါ။', 'audio/hsk1/话.mp3', 155),
('hsk1_156', 1, '坏', 'huài', 'ဆိုးသည် / ပျက်သည်', 'bad / broken', 'ဆိုးသည် / ပျက်သည်', '1. 他是坏人。\nHe is a bad person.\nသူက လူဆိုး။\n\n2. 电脑坏了。\nThe computer is broken.\nကွန်ပျူတာ ပျက်သွားပြီ။\n\n3. 牛奶坏了。\nThe milk has gone bad.\nနွားနို့ သိုးသွားပြီ။', 'audio/hsk1/坏.mp3', 156),
('hsk1_157', 1, '回', 'huí', 'ပြန်သည်', 'return / go back', 'ပြန်သည်', '1. 回家。\nGo home.\nအိမ်ပြန်တယ်။\n\n2. 什么时候回来？\nWhen are you coming back?\nဘယ်တော့ ပြန်လာမှာလဲ။\n\n3. 我回学校。\nI return to school.\nငါ ကျောင်းပြန်မယ်။', 'audio/hsk1/回.mp3', 157),
('hsk1_158', 1, '回答', 'huí dá', 'ဖြေသည် / အဖြေ', 'answer', 'ဖြေသည် / အဖြေ', '1. 请回答问题。\nPlease answer the question.\nကျေးဇူးပြုပြီး မေးခွန်းကို ဖြေပေးပါ။\n\n2. 很难回答。\nHard to answer.\nဖြေရ ခက်တယ်။\n\n3. 他的回答是对的。\nHis answer is correct.\nသူ့အဖြေက မှန်တယ်။', 'audio/hsk1/回答.mp3', 158),
('hsk1_159', 1, '回来', 'huí lái', 'ပြန်လာသည်', 'come back', 'ပြန်လာသည်', '1. 他回来了。\nHe has come back.\nသူ ပြန်ရောက်လာပြီ။\n\n2. 快点回来。\nCome back quickly.\nမြန်မြန် ပြန်လာခဲ့။\n\n3. 爸爸还没回来。\nDad hasn\'t come back yet.\nအဖေ ပြန်မရောက်သေးဘူး။', 'audio/hsk1/回来.mp3', 159),
('hsk1_160', 1, '回去', 'huí qù', 'ပြန်သွားသည်', 'go back', 'ပြန်သွားသည်', '1. 我要回去了。\nI am going back.\nငါ ပြန်တော့မယ်။\n\n2. 你什么时候回去？\nWhen are you going back?\nမင်း ဘယ်တော့ ပြန်သွားမှာလဲ။\n\n3. 回去工作吧。\nGo back to work.\nအလုပ် ပြန်လုပ်ပါတော့။', 'audio/hsk1/回去.mp3', 160),
('hsk1_161', 1, '会', 'huì', 'တတ်သည် / လိမ့်မည် / အစည်းအဝေး', 'can / will / meeting', 'တတ်သည် / လိမ့်မည် / အစည်းအဝေး', '1. 我会说中文。\nI can speak Chinese.\nငါ တရုတ်စကား ပြောတတ်တယ်။\n\n2. 明天会下雨。\nIt will rain tomorrow.\nမနက်ဖြန် မိုးရွာလိမ့်မယ်။\n\n3. 我们在开会。\nWe are having a meeting.\nငါတို့ အစည်းအဝေး လုပ်နေကြတယ်။', 'audio/hsk1/会.mp3', 161),
('hsk1_162', 1, '火车', 'huǒ chē', 'မီးရထား', 'train', 'မီးရထား', '1. 我坐火车去北京。\nI go to Beijing by train.\nငါ ပေကျင်းကို မီးရထားနဲ့ သွားတယ်။\n\n2. 火车票。\nTrain ticket.\nမီးရထား လက်မှတ်။\n\n3. 火车很快。\nThe train is very fast.\nမီးရထားက အရမ်းမြန်တယ်။', 'audio/hsk1/火车.mp3', 162),
('hsk1_163', 1, '机场', 'jī chǎng', 'လေဆိပ်', 'airport', 'လေဆိပ်', '1. 我要去机场。\nI want to go to the airport.\nငါ လေဆိပ် သွားချင်တယ်။\n\n2. 机场很远。\nThe airport is very far.\nလေဆိပ်က အရမ်းဝေးတယ်။\n\n3. 我们在机场等你。\nWe will wait for you at the airport.\nငါတို့ မင်းကို လေဆိပ်မှာ စောင့်နေမယ်။', 'audio/hsk1/机场.mp3', 163),
('hsk1_164', 1, '机票', 'jī piào', 'လေယာဉ်လက်မှတ်', 'plane ticket', 'လေယာဉ်လက်မှတ်', '1. 买机票。\nBuy a plane ticket.\nလေယာဉ်လက်မှတ် ဝယ်တယ်။\n\n2. 机票很贵。\nPlane tickets are expensive.\nလေယာဉ်လက်မှတ်က ဈေးကြီးတယ်။\n\n3. 这是你的机票。\nThis is your plane ticket.\nဒါ မင်းရဲ့ လေယာဉ်လက်မှတ်။', 'audio/hsk1/机票.mp3', 164),
('hsk1_165', 1, '鸡蛋', 'jī dàn', 'ကြက်ဥ', 'egg', 'ကြက်ဥ', '1. 我吃了一个鸡蛋。\nI ate an egg.\nငါ ကြက်ဥတစ်လုံး စားခဲ့တယ်။\n\n2. 炒鸡蛋。\nScrambled eggs / Stir-fried eggs.\nကြက်ဥမွှေကြော်။\n\n3. 鸡蛋很好吃。\nEggs are delicious.\nကြက်ဥက စားလို့ကောင်းတယ်။', 'audio/hsk1/鸡蛋.mp3', 165),
('hsk1_166', 1, '几', 'jǐ', 'ဘယ်လောက် / ဘယ်နှ...', 'how many', 'ဘယ်လောက် / ဘယ်နှ...', '1. 你有几本书？\nHow many books do you have?\nမင်းမှာ စာအုပ် ဘယ်နှအုပ် ရှိလဲ။\n\n2. 现在几点了？\nWhat time is it now?\nအခု ဘယ်နှနာရီ ရှိပြီလဲ။\n\n3. 十几个人。\nTen something people (More than ten).\nလူ တစ်ဆယ်ကျော်လောက်။', 'audio/hsk1/几.mp3', 166),
('hsk1_167', 1, '记', 'jì', 'မှတ်သည် / ရေးမှတ်သည်', 'remember / write down', 'မှတ်သည် / ရေးမှတ်သည်', '1. 记下来。\nWrite it down.\nချရေးမှတ်ထားလိုက်ပါ။\n\n2. 日记。\nDiary.\nနေ့စဉ်မှတ်တမ်း။\n\n3. 你记错了吗？\nDid you remember it wrong?\nမင်း မှတ်ထားတာ မှားနေသလား။', 'audio/hsk1/记.mp3', 167),
('hsk1_168', 1, '记得', 'jì de', 'မှတ်မိသည်', 'remember', 'မှတ်မိသည်', '1. 我记得你。\nI remember you.\nငါ မင်းကို မှတ်မိတယ်။\n\n2. 你不记得了吗？\nDo you not remember?\nမင်း မမှတ်မိတော့ဘူးလား။\n\n3. 我记得是这里。\nI remember it is here.\nဒီနေရာလို့ ငါမှတ်မိတယ်။', 'audio/hsk1/记得.mp3', 168),
('hsk1_169', 1, '记住', 'jì zhù', 'အလွတ်မှတ်သည် / စွဲမှတ်ထားသည်', 'memorize / remember by heart', 'အလွတ်မှတ်သည် / စွဲမှတ်ထားသည်', '1. 请记住我的话。\nPlease remember my words.\nငါ့စကားကို မှတ်ထားပေးပါ။\n\n2. 记住了吗？\nHave you memorized it?\nမှတ်မိပြီလား။\n\n3. 要把生词记住。\nNeed to memorize new words.\nစကားလုံးအသစ်တွေကို မှတ်ထားရမယ်။', 'audio/hsk1/记住.mp3', 169),
('hsk1_170', 1, '家', 'jiā', 'အိမ် / မိသားစု', 'home / family', 'အိမ် / မိသားစု', '1. 我想回家。\nI want to go home.\nငါ အိမ်ပြန်ချင်တယ်။\n\n2. 我家在北京。\nMy home is in Beijing.\nငါ့အိမ်က ပေကျင်းမှာ။\n\n3. 大家。\nEveryone (Big family).\nအားလုံးပဲ။', 'audio/hsk1/家.mp3', 170),
('hsk1_171', 1, '家里', 'jiā lǐ', 'အိမ်ထဲမှာ / အိမ်မှာ', 'in the home', 'အိမ်ထဲမှာ / အိမ်မှာ', '1. 家里有人吗？\nIs there anyone at home?\nအိမ်မှာ လူရှိလား။\n\n2. 我在家里。\nI am at home.\nငါ အိမ်မှာ။\n\n3. 家里很乱。\nThe house is messy.\nအိမ်ထဲမှာ ရှုပ်ပွနေတယ်။', 'audio/hsk1/家里.mp3', 171),
('hsk1_172', 1, '家人', 'jiā rén', 'မိသားစုဝင်', 'family members', 'မိသားစုဝင်', '1. 我想念家人。\nI miss my family.\nငါ မိသားစုကို လွမ်းတယ်။\n\n2. 家人身体健康吗？\nFamily is healthy.\nမိသားစု ကျန်းမာကြရဲ့လား။\n\n3. 和家人一起吃饭。\nEat with family.\nမိသားစုနဲ့အတူ ထမင်းစားတယ်။', 'audio/hsk1/家人.mp3', 172),
('hsk1_173', 1, '间', 'jiān', 'ခန်း / အခန်းအရေအတွက်', '(measure word for rooms)', 'ခန်း / အခန်းအရေအတွက်', '1. 一间房间。\nOne room.\nအခန်း တစ်ခန်း။\n\n2. 这间房子很大。\nThis house/room is very big.\nဒီအခန်းက အရမ်းကြီးတယ်။\n\n3. 卫生间。\nRestroom / Bathroom.\nအိမ်သာ / ရေချိုးခန်း။', 'audio/hsk1/间.mp3', 173),
('hsk1_174', 1, '见', 'jiàn', 'တွေ့သည်', 'see / meet', 'တွေ့သည်', '1. 明天见。\nSee you tomorrow.\nမနက်ဖြန် တွေ့မယ်။\n\n2. 好久不见。\nLong time no see.\nမတွေ့ရတာ ကြာပြီ။\n\n3. 我想见他。\nI want to see him.\nငါ သူ့ကို တွေ့ချင်တယ်။', 'audio/hsk1/见.mp3', 174),
('hsk1_175', 1, '见面', 'jiàn miàn', 'တွေ့ဆုံသည်', 'meet', 'တွေ့ဆုံသည်', '1. 我们见面吧。\nLet\'s meet.\nငါတို့ တွေ့ကြစို့။\n\n2. 在哪儿见面？\nWhere shall we meet?\nဘယ်မှာ တွေ့ကြမလဲ။\n\n3. 第一次见面。\nMeeting for the first time.\nပထမဆုံးအကြိမ် တွေ့ဆုံခြင်း။', 'audio/hsk1/见面.mp3', 175),
('hsk1_176', 1, '教', 'jiāo', 'သင်သည်', 'teach', 'သင်သည်', '1. 他教中文。\nHe teaches Chinese.\nသူ တရုတ်စာ သင်တယ်။\n\n2. 请教我怎么做。\nPlease teach me how to do it.\nဒါဘယ်လိုလုပ်ရလဲ ငါ့ကို သင်ပေးပါ။\n\n3. 谁教你？\nWho teaches you?\nမင်းကို ဘယ်သူသင်ပေးတာလဲ။', 'audio/hsk1/教.mp3', 176),
('hsk1_177', 1, '叫', 'jiào', 'ခေါ်သည် / ဟုခေါ်သည်', 'call / be called', 'ခေါ်သည် / ဟုခေါ်သည်', '1. 你叫什么名字？\nWhat is your name?\nမင်းနာမည် ဘယ်လိုခေါ်လဲ။\n\n2. 我叫大卫。\nMy name is David.\nငါ့နာမည် ဒေးဗစ် ပါ။\n\n3. 他在叫你。\nHe is calling you.\nသူ မင်းကို ခေါ်နေတယ်။', 'audio/hsk1/叫.mp3', 177),
('hsk1_178', 1, '姐姐', 'jiě jie', 'အစ်မ', 'older sister', 'အစ်မ', '1. 我有一个姐姐。\nI have an older sister.\nငါ့မှာ အစ်မတစ်ယောက်ရှိတယ်။\n\n2. 姐姐很漂亮。\nOlder sister is beautiful.\nအစ်မက လှတယ်။\n\n3. 这是姐姐的书。\nThis is older sister\'s book.\nဒါ အစ်မရဲ့ စာအုပ်။', 'audio/hsk1/姐姐.mp3', 178),
('hsk1_179', 1, '介绍', 'jiè shào', 'မိတ်ဆက်သည်', 'introduce', 'မိတ်ဆက်သည်', '1. 请自我介绍一下。\nPlease introduce yourself.\nကိုယ့်ကိုယ်ကို မိတ်ဆက်ပေးပါ။\n\n2. 我给你介绍一个朋友。\nI will introduce a friend to you.\nငါ မင်းကို သူငယ်ချင်းတစ်ယောက်နဲ့ မိတ်ဆက်ပေးမယ်။\n\n3. 谢谢你的介绍。\nThank you for your introduction.\nမင်းရဲ့ မိတ်ဆက်ပေးမှုအတွက် ကျေးဇူးတင်ပါတယ်။', 'audio/hsk1/介绍.mp3', 179),
('hsk1_180', 1, '今年', 'jīn nián', 'ဒီနှစ်', 'this year', 'ဒီနှစ်', '1. 今年是2026年。\nThis year is 2026.\nဒီနှစ်က ၂၀၂၆ ခုနှစ် ဖြစ်တယ်။\n\n2. 今年很热。\nThis year is very hot.\nဒီနှစ် အရမ်းပူတယ်။\n\n3. 我今年十八岁。\nI am 18 years old this year.\nငါ ဒီနှစ် ၁၈ နှစ်ပြည့်ပြီ။', 'audio/hsk1/今年.mp3', 180),
('hsk1_181', 1, '今天', 'jīn tiān', 'ဒီနေ့', 'today', 'ဒီနေ့', '1. 今天是星期五。\nToday is Friday.\nဒီနေ့က သောကြာနေ့။\n\n2. 今天天气很好。\nThe weather is good today.\nဒီနေ့ ရာသီဥတု ကောင်းတယ်။\n\n3. 你今天忙吗？\nAre you busy today?\nမင်း ဒီနေ့ အလုပ်များလား။', 'audio/hsk1/今天.mp3', 181),
('hsk1_182', 1, '进', 'jìn', 'ဝင်သည်', 'enter', 'ဝင်သည်', '1. 请进。\nPlease come in.\nကျေးဇူးပြုပြီး ဝင်လာပါ။\n\n2. 不要进那个房间。\nDon\'t enter that room.\nဟိုအခန်းထဲ မဝင်နဲ့။\n\n3. 我们要进站了。\nWe are entering the station.\nငါတို့ ဘူတာထဲ ဝင်တော့မယ်။', 'audio/hsk1/进.mp3', 182),
('hsk1_183', 1, '进来', 'jìn lái', 'ဝင်လာသည်', 'come in', 'ဝင်လာသည်', '1. 你进来吧。\nYou come in.\nမင်း ဝင်လာခဲ့ပါ။\n\n2. 快点进来。\nCome in quickly.\nမြန်မြန် ဝင်လာခဲ့။\n\n3. 谁进来了？\nWho came in?\nဘယ်သူ ဝင်လာတာလဲ။', 'audio/hsk1/进来.mp3', 183),
('hsk1_184', 1, '进去', 'jìn qù', 'ဝင်သွားသည်', 'go in', 'ဝင်သွားသည်', '1. 我想进去看看。\nI want to go in and have a look.\nငါ ဝင်ကြည့်ချင်တယ်။\n\n2. 大家进去了。\nEveryone has gone in.\nအားလုံး ဝင်သွားကြပြီ။\n\n3. 别进去。\nDon\'t go in.\nမဝင်သွားနဲ့။', 'audio/hsk1/进去.mp3', 184),
('hsk1_185', 1, '九', 'jiǔ', 'ကိုး (ဂဏန်း)', 'nine', 'ကိုး (ဂဏန်း)', '1. 九个人。\nNine people.\nလူ ကိုးယောက်။\n\n2. 现在九点了。\nIt is nine o\'clock now.\nအခု ၉ နာရီ ရှိပြီ။\n\n3. 我有九块钱。\nI have nine yuan.\nငါ့မှာ ၉ ယွမ် ရှိတယ်။', 'audio/hsk1/九.mp3', 185),
('hsk1_186', 1, '就', 'jiù', 'ပဲ / ချက်ချင်း / တော့', 'just / then', 'ပဲ / ချက်ချင်း / တော့', '1. 我这就来。\nI am coming right away.\nငါ အခုလာပြီ။\n\n2. 那就是我。\nThat is just me.\nအဲဒါ ငါပါပဲ။\n\n3. 不喜欢就算了。\n\"If you don\'t like it, forget it.\"\nမကြိုက်ရင်လည်း ထားလိုက်ပါတော့။', 'audio/hsk1/就.mp3', 186),
('hsk1_187', 1, '觉得', 'jué de', 'ထင်သည် / ခံစားရသည်', 'feel / think', 'ထင်သည် / ခံစားရသည်', '1. 我觉得很冷。\nI feel very cold.\nငါ အရမ်းအေးတယ်လို့ ခံစားရတယ်။\n\n2. 你觉得怎么样？\nWhat do you think?\nမင်း ဘယ်လိုထင်လဲ။\n\n3. 我觉得他是对的。\nI think he is right.\nသူမှန်တယ်လို့ ငါထင်တယ်။', 'audio/hsk1/觉得.mp3', 187),
('hsk1_188', 1, '开', 'kāi', 'ဖွင့်သည် / မောင်းသည်', 'open / drive / start', 'ဖွင့်သည် / မောင်းသည်', '1. 开门。\nOpen the door.\nတံခါးဖွင့်ပါ။\n\n2. 开车。\nDrive a car.\nကားမောင်းတယ်။\n\n3. 开灯。\nTurn on the light.\nမီးဖွင့်ပါ။', 'audio/hsk1/开.mp3', 188),
('hsk1_189', 1, '开车', 'kāi chē', 'ကားမောင်းသည်', 'drive a car', 'ကားမောင်းသည်', '1. 你会开车吗？\nCan you drive?\nမင်း ကားမောင်းတတ်လား။\n\n2. 我开车去上班。\nI drive to work.\nငါ ရုံးကို ကားမောင်းသွားတယ်။\n\n3. 小心开车。\nDrive carefully.\nကားကို ဂရုစိုက်မောင်းနော်။', 'audio/hsk1/开车.mp3', 189),
('hsk1_190', 1, '开会', 'kāi huì', 'အစည်းအဝေးလုပ်သည်', 'have a meeting', 'အစည်းအဝေးလုပ်သည်', '1. 我们在开会。\nWe are having a meeting.\nငါတို့ အစည်းအဝေး လုပ်နေတယ်။\n\n2. 明天要开会。\nThere is a meeting tomorrow.\nမနက်ဖြန် အစည်းအဝေး ရှိတယ်။\n\n3. 开会时间到了。\nIt\'s time for the meeting.\nအစည်းအဝေးချိန် ရောက်ပြီ။', 'audio/hsk1/开会.mp3', 190),
('hsk1_191', 1, '开玩笑', 'kāi wán xiào', 'နောက်ပြောင်သည် / စနောက်သည်', 'joke', 'နောက်ပြောင်သည် / စနောက်သည်', '1. 我在开玩笑。\nI am joking.\nငါ စနေတာပါ။\n\n2. 别开玩笑。\nDon\'t joke.\nမနောက်ပါနဲ့။\n\n3. 他是开玩笑的。\nHe was joking.\nသူက စတာပါ။', 'audio/hsk1/开玩笑.mp3', 191),
('hsk1_192', 1, '看', 'kàn', 'ကြည့်သည် / ဖတ်သည်', 'look / watch / read', 'ကြည့်သည် / ဖတ်သည်', '1. 看书。\nRead a book.\nစာဖတ်တယ်။\n\n2. 看电视。\nWatch TV.\nတီဗီကြည့်တယ်။\n\n3. 看着我。\nLook at me.\nငါ့ကို ကြည့်။', 'audio/hsk1/看.mp3', 192),
('hsk1_193', 1, '看病', 'kàn bìng', 'ဆရာဝန်ပြသည်', 'see a doctor', 'ဆရာဝန်ပြသည်', '1. 我要去看病。\nI need to see a doctor.\nငါ ဆရာဝန် သွားပြရမယ်။\n\n2. 医生在看病。\nThe doctor is seeing patients.\nဆရာဝန် လူနာကြည့်နေတယ်။\n\n3. 去医院看病。\nGo to the hospital to see a doctor.\nဆေးရုံသွားပြတယ်။', 'audio/hsk1/看病.mp3', 193),
('hsk1_194', 1, '看见', 'kàn jiàn', 'မြင်သည် / တွေ့သည်', 'see / saw', 'မြင်သည် / တွေ့သည်', '1. 我看见你了。\nI saw you.\nငါ မင်းကို တွေ့ပြီ။\n\n2. 你看见我的书了吗？\nDid you see my book?\nမင်း ငါ့စာအုပ်ကို တွေ့လား။\n\n3. 没看见。\nDidn\'t see.\nမတွေ့ဘူး။', 'audio/hsk1/看见.mp3', 194),
('hsk1_195', 1, '考', 'kǎo', 'စာမေးပွဲဖြေသည်', 'test / exam', 'စာမေးပွဲဖြေသည်', '1. 你考得怎么样？\nHow did you do on the test?\nမင်း စာမေးပွဲ ဖြေနိုင်လား။\n\n2. 我要考HSK。\nI want to take the HSK test.\nငါ HSK ဖြေမယ်။\n\n3. 考了一百分。\nScored 100 points.\nအမှတ် ၁၀၀ ရတယ်။', 'audio/hsk1/考.mp3', 195),
('hsk1_196', 1, '考试', 'kǎo shì', 'စာမေးပွဲ', 'exam', 'စာမေးပွဲ', '1. 明天有考试。\nThere is an exam tomorrow.\nမနက်ဖြန် စာမေးပွဲ ရှိတယ်။\n\n2. 考试很难。\nThe exam is difficult.\nစာမေးပွဲက ခက်တယ်။\n\n3. 准备考试。\nPrepare for the exam.\nစာမေးပွဲအတွက် ပြင်ဆင်တယ်။', 'audio/hsk1/考试.mp3', 196),
('hsk1_197', 1, '渴', 'kě', 'ရေဆာသည်', 'thirsty', 'ရေဆာသည်', '1. 我渴了。\nI am thirsty.\nငါ ရေဆာပြီ။\n\n2. 你渴不渴？\nAre you thirsty?\nမင်း ရေဆာလား။\n\n3. 有点儿渴。\nA little thirsty.\nနည်းနည်း ရေဆာတယ်။', 'audio/hsk1/渴.mp3', 197),
('hsk1_198', 1, '课', 'kè', 'အတန်း / သင်ခန်းစာ', 'class / lesson', 'အတန်း / သင်ခန်းစာ', '1. 上课了。\nClass begins.\nအတန်းစပြီ။\n\n2. 今天没有课。\nThere is no class today.\nဒီနေ့ အတန်းမရှိဘူး။\n\n3. 汉语课。\nChinese class.\nတရုတ်စာ သင်တန်း။', 'audio/hsk1/课.mp3', 198),
('hsk1_199', 1, '课本', 'kè běn', 'ပြဋ္ဌာန်းစာအုပ် / ဖတ်စာအုပ်', 'textbook', 'ပြဋ္ဌာန်းစာအုပ် / ဖတ်စာအုပ်', '1. 看课本。\nRead the textbook.\nဖတ်စာအုပ်ကို ကြည့်ပါ။\n\n2. 打开课本。\nOpen the textbook.\nဖတ်စာအုပ်ကို ဖွင့်ပါ။\n\n3. 这是谁的课本？\nWhose textbook is this?\nဒါ ဘယ်သူ့ ဖတ်စာအုပ်လဲ။', 'audio/hsk1/课本.mp3', 199),
('hsk1_200', 1, '课文', 'kè wén', 'သင်ခန်းစာစာပိုဒ်', 'text (of a lesson)', 'သင်ခန်းစာစာပိုဒ်', '1. 读课文。\nRead the text.\nစာပိုဒ်ကို ဖတ်ပါ။\n\n2. 这篇课文很难。\nThis text is very difficult.\nဒီသင်ခန်းစာစာပိုဒ်က အရမ်းခက်တယ်။\n\n3. 背课文。\nRecite the text.\nစာပိုဒ်ကို အလွတ်ကျက်တယ်။', 'audio/hsk1/课文.mp3', 200),
('hsk1_201', 1, '口', 'kǒu', 'ပါးစပ် / ယောက် (မိသားစုဝင်ရေတွက်)', 'mouth / measure word for family members', 'ပါးစပ် / ယောက် (မိသားစုဝင်ရေတွက်)', '1. 张开口。\nOpen your mouth.\nပါးစပ် ဟပါ။\n\n2. 我家有三口人。\nMy family has three people.\nငါ့အိမ်မှာ လူသုံးယောက် ရှိတယ်။\n\n3. 门口。\nDoorway / Entrance.\nတံခါးပေါက်။', 'audio/hsk1/口.mp3', 201),
('hsk1_202', 1, '块', 'kuài', 'ခု (အဖတ်/အမြှောင့်) / ကျပ် (ယွမ်)', 'piece / Yuan (informal)', 'ခု (အဖတ်/အမြှောင့်) / ကျပ် (ယွမ်)', '1. 一块蛋糕。\nA piece of cake.\nကိတ်မုန့် တစ်ဖဲ့။\n\n2. 五块钱。\nFive Yuan.\nငါးယွမ် (ပိုက်ဆံ)။\n\n3. 这块石头很大。\nThis stone is very big.\nဒီကျောက်တုံးက အရမ်းကြီးတယ်။', 'audio/hsk1/块.mp3', 202),
('hsk1_203', 1, '快', 'kuài', 'မြန်သည်', 'fast / quick', 'မြန်သည်', '1. 跑得很快。\nRun very fast.\nအရမ်းမြန်မြန် ပြေးတယ်။\n\n2. 快点儿。\nHurry up / Be quick.\nမြန်မြန်လုပ်။\n\n3. 快到了。\nArriving soon (Fast arriving).\nရောက်တော့မယ်။', 'audio/hsk1/快.mp3', 203),
('hsk1_204', 1, '来', 'lái', 'လာသည်', 'come', 'လာသည်', '1. 你来吗？\nAre you coming?\nမင်း လာမလား။\n\n2. 过来。\nCome over here.\nဒီဘက် လာခဲ့။\n\n3. 他来了。\nHe has come.\nသူ လာပြီ။', 'audio/hsk1/来.mp3', 204),
('hsk1_205', 1, '来到', 'lái dào', 'ရောက်လာသည်', 'come to / arrive', 'ရောက်လာသည်', '1. 来到中国。\nCome to China.\nတရုတ်ပြည်ကို ရောက်လာတယ်။\n\n2. 欢迎来到北京。\nWelcome to Beijing.\nပေကျင်းမြို့မှ ကြိုဆိုပါတယ်။\n\n3. 他来到了学校。\nHe arrived at the school.\nသူ ကျောင်းကို ရောက်လာခဲ့တယ်။', 'audio/hsk1/来到.mp3', 205),
('hsk1_206', 1, '老', 'lǎo', 'အိုသည် / ဟောင်းသည်', 'old', 'အိုသည် / ဟောင်းသည်', '1. 他老了。\nHe is old.\nသူ အိုသွားပြီ။\n\n2. 老朋友。\nOld friend.\nမိတ်ဆွေဟောင်း။\n\n3. 这张照片很老。\nThis photo is very old.\nဒီဓာတ်ပုံက အရမ်းဟောင်းနေပြီ။', 'audio/hsk1/老.mp3', 206),
('hsk1_207', 1, '老人', 'lǎo rén', 'လူကြီး / သက်ကြီးရွယ်အို', 'old person / the elderly', 'လူကြီး / သက်ကြီးရွယ်အို', '1. 尊敬老人。\nRespect the elderly.\nလူကြီးတွေကို လေးစားပါ။\n\n2. 那个老人是谁？\nWho is that old person?\nဟို အဘိုးကြီး/အဘွားကြီး က ဘယ်သူလဲ။\n\n3. 老人需要照顾。\nThe elderly need care.\nသက်ကြီးရွယ်အိုတွေက ပြုစုစောင့်ရှောက်မှု လိုအပ်တယ်။', 'audio/hsk1/老人.mp3', 207),
('hsk1_208', 1, '老师', 'lǎo shī', 'ဆရာ / ဆရာမ', 'teacher', 'ဆရာ / ဆရာမ', '1. 老师好。\nHello teacher.\nမင်္ဂလာပါ ဆရာ/ဆရာမ။\n\n2. 她是我的汉语老师。\nShe is my Chinese teacher.\nသူမက ငါ့ရဲ့ တရုတ်စာဆရာမ ဖြစ်တယ်။\n\n3. 问老师。\nAsk the teacher.\nဆရာ့ကို မေးလိုက်ပါ။', 'audio/hsk1/老师.mp3', 208),
('hsk1_209', 1, '了', 'le', 'ပြီ (ပြီးစီးခြင်းပြ စကားလုံး)', '(particle indicating past/change)', 'ပြီ (ပြီးစီးခြင်းပြ စကားလုံး)', '1. 吃饭了。\nHave eaten.\nထမင်းစားပြီးပြီ။\n\n2. 下雨了。\nIt is raining (started raining).\nမိုးရွာနေပြီ။\n\n3. 我不去了。\nI am not going anymore.\nငါ မသွားတော့ဘူး။', 'audio/hsk1/了.mp3', 209),
('hsk1_210', 1, '累', 'lèi', 'မောသည် / ပင်ပန်းသည်', 'tired', 'မောသည် / ပင်ပန်းသည်', '1. 我很累。\nI am very tired.\nငါ အရမ်းပင်ပန်းတယ်။\n\n2. 你不累吗？\nAre you not tired?\nမင်း မပင်ပန်းဘူးလား။\n\n3. 累死了。\nExtremely tired (Tired to death).\nသေလောက်အောင် ပင်ပန်းတယ်။', 'audio/hsk1/累.mp3', 210),
('hsk1_211', 1, '冷', 'lěng', 'အေးသည်', 'cold', 'အေးသည်', '1. 今天很冷。\nIt is very cold today.\nဒီနေ့ အရမ်းအေးတယ်။\n\n2. 喝冷水。\nDrink cold water.\nရေအေး သောက်တယ်။\n\n3. 有点儿冷。\nA little bit cold.\nနည်းနည်း အေးတယ်။', 'audio/hsk1/冷.mp3', 211),
('hsk1_212', 1, '里', 'lǐ', 'ထဲမှာ', 'inside / in', 'ထဲမှာ', '1. 房间里。\nIn the room.\nအခန်းထဲမှာ။\n\n2. 包里有什么？\nWhat is in the bag?\nအိတ်ထဲမှာ ဘာရှိလဲ။\n\n3. 他在家里。\nHe is at home.\nသူ အိမ်ထဲမှာ ရှိတယ်။', 'audio/hsk1/里.mp3', 212),
('hsk1_213', 1, '两', 'liǎng', 'နှစ် (အရေအတွက်)', 'two (quantity)', 'နှစ် (အရေအတွက်)', '1. 两个人。\nTwo people.\nလူ နှစ်ယောက်။\n\n2. 两点钟。\nTwo o\'clock.\nနှစ်နာရီ။\n\n3. 我有两个苹果。\nI have two apples.\nငါ့မှာ ပန်းသီး နှစ်လုံး ရှိတယ်။', 'audio/hsk1/两.mp3', 213),
('hsk1_214', 1, '零', 'líng', 'သုည', 'zero', 'သုည', '1. 二零二六年。\nYear 2026.\n၂၀၂၆ ခုနှစ်။\n\n2. 零度。\nZero degrees.\nသုည ဒီဂရီ။\n\n3. 一百零一。\nOne hundred and one.\nတစ်ရာ့ တစ်။', 'audio/hsk1/零.mp3', 214),
('hsk1_215', 1, '六', 'liù', 'ခြောက် (ဂဏန်း)', 'six', 'ခြောက် (ဂဏန်း)', '1. 六个。\nSix items.\nခြောက်ခု။\n\n2. 星期六。\nSaturday.\nစနေနေ့။\n\n3. 六月。\nJune.\nဇွန်လ။', 'audio/hsk1/六.mp3', 215),
('hsk1_216', 1, '楼', 'lóu', 'တိုက် / အထပ်', 'building / floor', 'တိုက် / အထပ်', '1. 高楼。\nTall building.\nတိုက်မြင့်။\n\n2. 我在二楼。\nI am on the second floor.\nငါ ဒုတိယထပ်မှာ ရှိတယ်။\n\n3. 上楼。\nGo upstairs.\nအပေါ်ထပ် တက်တယ်။', 'audio/hsk1/楼.mp3', 216),
('hsk1_217', 1, '路', 'lù', 'လမ်း', 'road / way', 'လမ်း', '1. 这条路很长。\nThis road is very long.\nဒီလမ်းက အရမ်းရှည်တယ်။\n\n2. 我在路上。\nI am on the road (on my way).\nငါ လမ်းမှာ ရောက်နေပြီ။\n\n3. 我不认识路。\nI don\'t know the way.\nငါ လမ်းမသိဘူး။', 'audio/hsk1/路.mp3', 217),
('hsk1_218', 1, '路口', 'lù kǒu', 'လမ်းဆုံ', 'intersection / crossing', 'လမ်းဆုံ', '1. 在路口停下。\nStop at the intersection.\nလမ်းဆုံမှာ ရပ်လိုက်ပါ။\n\n2. 下一个路口左转。\nTurn left at the next intersection.\nနောက်လမ်းဆုံရောက်ရင် ဘယ်ကွေ့ပါ။\n\n3. 路口有人。\nThere are people at the intersection.\nလမ်းဆုံမှာ လူတွေ ရှိတယ်။', 'audio/hsk1/路口.mp3', 218),
('hsk1_219', 1, '路上', 'lù shang', 'လမ်းပေါ်တွင် / လမ်းခုလတ်တွင်', 'on the road / on the way', 'လမ်းပေါ်တွင် / လမ်းခုလတ်တွင်', '1. 路上小心。\nBe careful on the road.\nလမ်းခရီး ဂရုစိုက်ပါ။\n\n2. 我们在路上。\nWe are on the way.\nငါတို့ လမ်းမှာ လာနေတယ်။\n\n3. 路上车很多。\nThere are many cars on the road.\nလမ်းပေါ်မှာ ကားတွေ အများကြီးပဲ။', 'audio/hsk1/路上.mp3', 219),
('hsk1_220', 1, '妈妈', 'mā ma', 'အမေ', 'mom', 'အမေ', '1. 我爱妈妈。\nI love mom.\nငါ အမေ့ကို ချစ်တယ်။\n\n2. 妈妈在做饭。\nMom is cooking.\nအမေ ထမင်းချက်နေတယ်။\n\n3. 妈妈身体很好。\nMom is healthy.\nအမေ ကျန်းမာရေး ကောင်းတယ်။', 'audio/hsk1/妈妈.mp3', 220),
('hsk1_221', 1, '马路', 'mǎ lù', 'ကားလမ်းမ / လမ်းမကြီး', 'road / street', 'ကားလမ်းမ / လမ်းမကြီး', '1. 过马路要小心。\nBe careful when crossing the road.\nလမ်းကူးရင် သတိထားပါ။\n\n2. 马路很宽。\nThe road is very wide.\nလမ်းမကြီးက အရမ်းကျယ်တယ်။\n\n3. 马路对面。\nOpposite side of the road.\nလမ်းတစ်ဖက်ခြမ်း။', 'audio/hsk1/马路.mp3', 221),
('hsk1_222', 1, '马上', 'mǎ shàng', 'ချက်ချင်း', 'immediately / right away', 'ချက်ချင်း', '1. 我马上来。\nI am coming immediately.\nငါ အခုချက်ချင်း လာခဲ့မယ်။\n\n2. 马上就好。\nReady immediately / almost done.\nအခု ပြီးပါတော့မယ်။\n\n3. 请马上离开。\nPlease leave immediately.\nကျေးဇူးပြုပြီး ချက်ချင်း ထွက်သွားပေးပါ။', 'audio/hsk1/马上.mp3', 222),
('hsk1_223', 1, '吗', 'ma', 'လား (မေးခွန်း)', '(question particle)', 'လား (မေးခွန်း)', '1. 你好吗？\nHow are you?\nနေကောင်းလား။\n\n2. 这是你的吗？\nIs this yours?\nဒါ မင်းရဲ့ဟာလား။\n\n3. 你可以去吗？\nCan you go?\nမင်း သွားနိုင်လား။', 'audio/hsk1/吗.mp3', 223),
('hsk1_224', 1, '买', 'mǎi', 'ဝယ်သည်', 'buy', 'ဝယ်သည်', '1. 我要买水。\nI want to buy water.\nငါ ရေဝယ်ချင်တယ်။\n\n2. 买单。\nPay the bill / Check please.\nရှင်းမယ် (ဘေလ်ပေးမယ်)။\n\n3. 你买什么？\nWhat are you buying?\nမင်း ဘာဝယ်မှာလဲ။', 'audio/hsk1/买.mp3', 224),
('hsk1_225', 1, '卖', 'mài', 'ရောင်းသည်', 'sell', 'ရောင်းသည်', '1. 这里卖什么？\nWhat do they sell here?\nဒီမှာ ဘာရောင်းလဲ။\n\n2. 我不卖。\nI am not selling.\nငါ မရောင်းဘူး။\n\n3. 卖完了。\nSold out.\nရောင်းကုန်သွားပြီ။', 'audio/hsk1/卖.mp3', 225),
('hsk1_226', 1, '馒头', 'mán tou', 'ပေါက်စီအလွတ် / မန်ထို', 'steamed bun (plain)', 'ပေါက်စီအလွတ် / မန်ထို', '1. 我早饭吃馒头。\nI eat steamed buns for breakfast.\nငါ မနက်စာကို မန်ထိုစားတယ်။\n\n2. 一个馒头。\nOne steamed bun.\nမန်ထို တစ်လုံး။\n\n3. 馒头很好吃。\nSteamed buns are delicious.\nမန်ထိုက စားကောင်းတယ်။', 'audio/hsk1/馒头.mp3', 226),
('hsk1_227', 1, '慢', 'màn', 'နှေးသည် / ဖြည်းဖြည်း', 'slow', 'နှေးသည် / ဖြည်းဖြည်း', '1. 慢走。\nWalk slowly / Take care (when guest leaves).\nဖြည်းဖြည်းသွားပါ / ဂရုစိုက်ပြန်နော်။\n\n2. 太慢了。\nToo slow.\nအရမ်းနှေးတယ်။\n\n3. 请慢一点儿说。\nPlease speak a little slower.\nကျေးဇူးပြုပြီး ဖြည်းဖြည်းပြောပေးပါ။', 'audio/hsk1/慢.mp3', 227),
('hsk1_228', 1, '忙', 'máng', 'အလုပ်များသည်', 'busy', 'အလုပ်များသည်', '1. 你忙吗？\nAre you busy?\nမင်း အလုပ်များလား။\n\n2. 我很忙。\nI am very busy.\nငါ အလုပ်အရမ်းများတယ်။\n\n3. 忙工作。\nBusy with work.\nအလုပ်ရှုပ်နေတယ်။', 'audio/hsk1/忙.mp3', 228),
('hsk1_229', 1, '猫', 'māo', 'ကြောင်', 'cat', 'ကြောင်', '1. 我的猫。\nMy cat.\nငါ့ရဲ့ ကြောင်လေး။\n\n2. 那只猫很可爱。\nThat cat is very cute.\nဟိုကြောင်လေးက အရမ်းချစ်စရာကောင်းတယ်။\n\n3. 猫在睡觉。\nThe cat is sleeping.\nကြောင်လေး အိပ်နေတယ်။', 'audio/hsk1/猫.mp3', 229),
('hsk1_230', 1, '没', 'méi', 'မ...ဘူး / မရှိဘူး', 'not / have not', 'မ...ဘူး / မရှိဘူး', '1. 没去。\nDid not go.\nမသွားဘူး။\n\n2. 没人。\nNo people.\nလူမရှိဘူး။\n\n3. 没钱。\nNo money.\nပိုက်ဆံ မရှိဘူး။', 'audio/hsk1/没.mp3', 230),
('hsk1_231', 1, '没关系', 'méi guān xi', 'ကိစ္စမရှိပါဘူး / ရပါတယ်', 'It doesn\'t matter', 'ကိစ္စမရှိပါဘူး / ရပါတယ်', '1. 对不起。没关系。\nSorry. It doesn\'t matter.\nတောင်းပန်ပါတယ်။ ရပါတယ် (ကိစ္စမရှိပါဘူး)။\n\n2. 真的没关系。\nIt really doesn\'t matter.\nတကယ် ကိစ္စမရှိပါဘူး။\n\n3. 没关系，我不介意。\n\"It\'s okay, I don\'t mind.\"\nရပါတယ်၊ ငါစိတ်မထဲထားပါဘူး။', 'audio/hsk1/没关系.mp3', 231),
('hsk1_232', 1, '没什么', 'méi shén me', 'ဘာမှမဟုတ်ပါဘူး', 'nothing / it\'s nothing', 'ဘာမှမဟုတ်ပါဘူး', '1. 没什么大不了。\nIt\'s no big deal.\nကိစ္စသေးသေးလေးပါ။\n\n2. 怎么了？没什么。\nWhat\'s wrong? Nothing.\nဘာဖြစ်တာလဲ။ ဘာမှမဖြစ်ပါဘူး။\n\n3. 包里没什么。\nThere is nothing in the bag.\nအိတ်ထဲမှာ ဘာမှမရှိဘူး။', 'audio/hsk1/没什么.mp3', 232),
('hsk1_233', 1, '没事', 'méi shì', 'အဆင်ပြေပါတယ် / ဘာမှမဖြစ်ဘူး', 'alright / no problem', 'အဆင်ပြေပါတယ် / ဘာမှမဖြစ်ဘူး', '1. 你有事吗？没事。\nDo you have anything to do? No / I\'m fine.\nမင်း ကိစ္စရှိလား။ မရှိပါဘူး / အဆင်ပြေပါတယ်။\n\n2. 我没事。\nI am fine.\nငါ ဘာမှမဖြစ်ဘူး (နေကောင်းတယ်)။\n\n3. 没事了。\nIt\'s okay now / All done.\nပြီးသွားပြီ / အဆင်ပြေသွားပြီ။', 'audio/hsk1/没事.mp3', 233),
('hsk1_234', 1, '没有', 'méi yǒu', 'မရှိဘူး / မ...ခဲ့ဘူး', 'not have / did not', 'မရှိဘူး / မ...ခဲ့ဘူး', '1. 我没有时间。\nI don\'t have time.\nငါ့မှာ အချိန်မရှိဘူး။\n\n2. 这里没有水。\nThere is no water here.\nဒီမှာ ရေမရှိဘူး။\n\n3. 他没有来。\nHe did not come.\nသူ မလာဘူး။', 'audio/hsk1/没有.mp3', 234),
('hsk1_235', 1, '每', 'měi', 'တိုင်း / စီ', 'every', 'တိုင်း / စီ', '1. 每个人。\nEvery person.\nလူတိုင်း။\n\n2. 每本书。\nEvery book.\nစာအုပ်တိုင်း။\n\n3. 每五分钟。\nEvery five minutes.\nငါးမိနစ်တိုင်း။', 'audio/hsk1/每.mp3', 235),
('hsk1_236', 1, '每天', 'měi tiān', 'နေ့တိုင်း', 'every day', 'နေ့တိုင်း', '1. 我每天跑步。\nI run every day.\nငါ နေ့တိုင်း ပြေးတယ်။\n\n2. 每天好好学习。\nStudy hard every day.\nနေ့တိုင်း စာကြိုးစားပါ။\n\n3. 每天早上。\nEvery morning.\nမနက်တိုင်း။', 'audio/hsk1/每天.mp3', 236),
('hsk1_237', 1, '美', 'měi', 'လှပသည်', 'beautiful', 'လှပသည်', '1. 这里很美。\nThis place is very beautiful.\nဒီနေရာက အရမ်းလှတယ်။\n\n2. 这花真美。\nThis flower is really beautiful.\nဒီပန်းက တကယ်လှတယ်။\n\n3. 美好的生活。\nBeautiful life.\nလှပသော ဘဝ။', 'audio/hsk1/美.mp3', 237),
('hsk1_238', 1, '妹妹', 'mèi mei', 'ညီမလေး', 'younger sister', 'ညီမလေး', '1. 我妹妹五岁。\nMy younger sister is five years old.\nငါ့ညီမလေး အသက် ၅ နှစ်ရှိပြီ။\n\n2. 那是谁的妹妹？\nWhose younger sister is that?\nအဲဒါ ဘယ်သူ့ညီမလေးလဲ။\n\n3. 带妹妹去玩。\nTake younger sister to play.\nညီမလေးကို အလည်ခေါ်သွားတယ်။', 'audio/hsk1/妹妹.mp3', 238),
('hsk1_239', 1, '门', 'mén', 'တံခါး', 'door', 'တံခါး', '1. 开门。\nOpen the door.\nတံခါးဖွင့်ပါ။\n\n2. 关门。\nClose the door.\nတံခါးပိတ်ပါ။\n\n3. 门锁了。\nThe door is locked.\nတံခါးသော့ခတ်ထားတယ်။', 'audio/hsk1/门.mp3', 239),
('hsk1_240', 1, '门口', 'mén kǒu', 'တံခါးပေါက် / ဂိတ်ဝ', 'doorway / entrance / gate', 'တံခါးပေါက် / ဂိတ်ဝ', '1. 我在门口等你。\nI will wait for you at the entrance.\nငါ မင်းကို ဂိတ်ဝမှာ စောင့်နေမယ်။\n\n2. 把车停在门口。\nPark the car at the entrance.\nကားကို ဂိတ်ဝမှာ ရပ်ထားပါ။\n\n3. 门口站着一个人。\nA person is standing at the doorway.\nတံခါးပေါက်မှာ လူတစ်ယောက် ရပ်နေတယ်။', 'audio/hsk1/门口.mp3', 240),
('hsk1_241', 1, '门票', 'mén piào', 'ဝင်ခွင့်လက်မှတ်', 'entrance ticket', 'ဝင်ခွင့်လက်မှတ်', '1. 买门票。\nBuy an entrance ticket.\nဝင်ခွင့်လက်မှတ် ဝယ်တယ်။\n\n2. 门票多少钱？\nHow much is the entrance ticket?\nဝင်ခွင့်လက်မှတ် ဘယ်လောက်လဲ။\n\n3. 请出示门票。\nPlease show your entrance ticket.\nကျေးဇူးပြုပြီး ဝင်ခွင့်လက်မှတ် ပြပေးပါ။', 'audio/hsk1/门票.mp3', 241),
('hsk1_242', 1, '们', 'men', 'တို့ / များ (အများကိန်းနောက်ဆက်တွဲ)', '(plural suffix)', 'တို့ / များ (အများကိန်းနောက်ဆက်တွဲ)', '1. 我们\nWe / Us.\nငါတို့။\n\n2. 同学们\nClassmates / Students.\nကျောင်းသားများ။\n\n3. 老师们\nTeachers.\nဆရာ၊ ဆရာမများ။', 'audio/hsk1/们.mp3', 242),
('hsk1_243', 1, '米', 'mǐ', 'မီတာ / ဆန်', 'meter / rice (uncooked)', 'မီတာ / ဆန်', '1. 一百米。\nOne hundred meters.\nမီတာ ၁၀၀။\n\n2. 买一袋米。\nBuy a bag of rice.\nဆန်တစ်အိတ် ဝယ်တယ်။\n\n3. 五百米远。\n500 meters away.\nမီတာ ၅၀၀ ဝေးတယ်။', 'audio/hsk1/米.mp3', 243),
('hsk1_244', 1, '米饭', 'mǐ fàn', 'ထမင်း', 'cooked rice', 'ထမင်း', '1. 吃米饭。\nEat rice.\nထမင်းစားတယ်။\n\n2. 一碗米饭。\nA bowl of rice.\nထမင်းတစ်ပန်းကန်။\n\n3. 我也喜欢吃米饭。\nI also like to eat rice.\nငါလည်း ထမင်းစားရတာ ကြိုက်တယ်။', 'audio/hsk1/米饭.mp3', 244),
('hsk1_245', 1, '面包', 'miàn bāo', 'ပေါင်မုန့်', 'bread', 'ပေါင်မုန့်', '1. 吃面包。\nEat bread.\nပေါင်မုန့်စားတယ်။\n\n2. 买面包。\nBuy bread.\nပေါင်မုန့်ဝယ်တယ်။\n\n3. 这个面包很好吃。\nThis bread is delicious.\nဒီပေါင်မုန့်က အရမ်းစားကောင်းတယ်။', 'audio/hsk1/面包.mp3', 245);
INSERT INTO `vocabulary` (`vocab_id`, `hsk_level`, `hanzi`, `pinyin`, `meaning`, `meaning_en`, `meaning_my`, `example`, `audio_asset`, `sort_order`) VALUES
('hsk1_246', 1, '面条', 'miàn tiáo', 'ခေါက်ဆွဲ', 'noodles', 'ခေါက်ဆွဲ', '1. 我想吃面条。\nI want to eat noodles.\nငါ ခေါက်ဆွဲစားချင်တယ်။\n\n2. 煮面条。\nCook noodles.\nခေါက်ဆွဲပြုတ်တယ်။\n\n3. 牛肉面条。\nBeef noodles.\nအမဲသားခေါက်ဆွဲ။', 'audio/hsk1/面条.mp3', 246),
('hsk1_247', 1, '名字', 'míng zi', 'နာမည်', 'name', 'နာမည်', '1. 你的名字是什么？\nWhat is your name?\nမင်းနာမည် ဘယ်လိုခေါ်လဲ။\n\n2. 写名字。\nWrite name.\nနာမည် ရေးတယ်။\n\n3. 好听的名字。\nA nice-sounding name.\nနာမည်ကောင်းလေး (နားထောင်လို့ကောင်းတဲ့ နာမည်)။', 'audio/hsk1/名字.mp3', 247),
('hsk1_248', 1, '明白', 'míng bai', 'နားလည်သည်', 'understand', 'နားလည်သည်', '1. 你明白吗？\nDo you understand?\nမင်း နားလည်လား။\n\n2. 我不明白。\nI don\'t understand.\nငါ နားမလည်ဘူး။\n\n3. 明白了。\nUnderstood.\nနားလည်ပါပြီ။', 'audio/hsk1/明白.mp3', 248),
('hsk1_249', 1, '明年', 'míng nián', 'နောက်နှစ်', 'next year', 'နောက်နှစ်', '1. 明年见。\nSee you next year.\nနောက်နှစ်မှ တွေ့မယ်။\n\n2. 我明年去中国。\nI will go to China next year.\nငါ နောက်နှစ် တရုတ်ပြည်သွားမယ်။\n\n3. 明年我二十岁。\nNext year I will be 20 years old.\nနောက်နှစ် ငါ့အသက် ၂၀ ပြည့်မယ်။', 'audio/hsk1/明年.mp3', 249),
('hsk1_250', 1, '明天', 'míng tiān', 'မနက်ဖြန်', 'tomorrow', 'မနက်ဖြန်', '1. 明天星期几？\nWhat day is tomorrow?\nမနက်ဖြန် ဘာနေ့လဲ။\n\n2. 明天有雨。\nIt will rain tomorrow.\nမနက်ဖြန် မိုးရွာလိမ့်မယ်။\n\n3. 我们明天去。\nWe will go tomorrow.\nငါတို့ မနက်ဖြန် သွားကြမယ်။', 'audio/hsk1/明天.mp3', 250),
('hsk1_251', 1, '拿', 'ná', 'ယူသည် / ကိုင်သည်', 'take / hold', 'ယူသည် / ကိုင်သည်', '1. 拿一本书。\nTake a book.\nစာအုပ်တစ်အုပ် ယူလိုက်ပါ။\n\n2. 帮我拿一下。\nPlease hold this for me.\nဒါလေး ငါ့ကို ကူကိုင်ပေးပါဦး။\n\n3. 别拿我的东西。\nDon\'t take my things.\nငါ့ပစ္စည်းတွေ မယူနဲ့။', 'audio/hsk1/拿.mp3', 251),
('hsk1_252', 1, '哪', 'nǎ', 'ဘယ် (ရွေးချယ်ခြင်း)', 'which', 'ဘယ် (ရွေးချယ်ခြင်း)', '1. 哪个？\nWhich one?\nဘယ်တစ်ခုလဲ။\n\n2. 哪国人？\nWhich country person?\nဘယ်နိုင်ငံသားလဲ။\n\n3. 哪怕。\nEven if.\nဖြစ်နေရင်တောင်မှ။', 'audio/hsk1/哪.mp3', 252),
('hsk1_253', 1, '哪里', 'nǎ li', 'ဘယ်မှာ', 'where', 'ဘယ်မှာ', '1. 你去哪里？\nWhere are you going?\nမင်း ဘယ်သွားမလို့လဲ။\n\n2. 这是哪里？\nWhere is this?\nဒါ ဘယ်နေရာလဲ။\n\n3. 哪里哪里。\nYou flatter me (Polite denial of praise).\nမဟုတ်ပါဘူးဗျာ (ချီးကျူးခံရတဲ့အခါ ပြန်ပြောသည့် စကား)။', 'audio/hsk1/哪里.mp3', 253),
('hsk1_254', 1, '哪儿', 'nǎr', 'ဘယ်မှာ', 'where', 'ဘယ်မှာ', '1. 你在哪儿？\nWhere are you?\nမင်း ဘယ်မှာလဲ။\n\n2. 去哪儿？\nWhere are you going?\nဘယ်သွားမလို့လဲ။\n\n3. 他在哪儿工作？\nWhere does he work?\nသူ ဘယ်မှာ အလုပ်လုပ်လဲ။', 'audio/hsk1/哪儿.mp3', 254),
('hsk1_255', 1, '那', 'nà', 'ဟို / အဲဒါ', 'that', 'ဟို / အဲဒါ', '1. 那是什么？\nWhat is that?\nဟိုဟာ ဘာလဲ။\n\n2. 那个人。\nThat person.\nဟိုလူ။\n\n3. 那是我的。\nThat is mine.\nအဲဒါ ငါ့ဟာ။', 'audio/hsk1/那.mp3', 255),
('hsk1_256', 1, '那边', 'nà biān', 'ဟိုဘက် / ဟိုနား', 'over there / that side', 'ဟိုဘက် / ဟိုနား', '1. 看那边。\nLook over there.\nဟိုဘက်ကို ကြည့်လိုက်။\n\n2. 他在那边。\nHe is over there.\nသူ ဟိုဘက်မှာ။\n\n3. 去那边坐。\nGo sit over there.\nဟိုဘက်မှာ သွားထိုင်ပါ။', 'audio/hsk1/那边.mp3', 256),
('hsk1_257', 1, '那儿', 'nàr', 'ဟိုမှာ / ဟိုနေရာ', 'there', 'ဟိုမှာ / ဟိုနေရာ', '1. 那儿有很多人。\nThere are many people over there.\nဟိုမှာ လူတွေ အများကြီးရှိတယ်။\n\n2. 我的书在那儿。\nMy book is over there.\nငါ့စာအုပ် ဟိုမှာ ရှိတယ်။\n\n3. 你去那儿干什么？\nWhat are you going there for?\nမင်း ဟိုကို ဘာသွားလုပ်မှာလဲ။', 'audio/hsk1/那儿.mp3', 257),
('hsk1_258', 1, '那些', 'nà xiē', 'ဟိုဟာတွေ / အဲဒါတွေ', 'those', 'ဟိုဟာတွေ / အဲဒါတွေ', '1. 那些是什么？\nWhat are those?\nဟိုဟာတွေက ဘာတွေလဲ။\n\n2. 我不认识那些人。\nI don\'t know those people.\nငါ ဟိုလူတွေကို မသိဘူး။\n\n3. 那些书都是我的。\nThose books are all mine.\nဟိုစာအုပ်တွေအားလုံးက ငါ့ဟာတွေ။', 'audio/hsk1/那些.mp3', 258),
('hsk1_259', 1, '奶奶', 'nǎi nai', 'အဘွား', 'grandma (paternal)', 'အဘွား', '1. 那是我的奶奶。\nThat is my grandma.\nအဲဒါ ငါ့အဘွား။\n\n2. 奶奶身体很好。\nGrandma is very healthy.\nအဘွား ကျန်းမာရေး ကောင်းတယ်။\n\n3. 我去看奶奶。\nI am going to visit grandma.\nငါ အဘွားဆီ သွားလည်မလို့။', 'audio/hsk1/奶奶.mp3', 259),
('hsk1_260', 1, '男', 'nán', 'ယောက်ျား', 'male', 'ယောက်ျား', '1. 男厕所。\nMale restroom.\nအမျိုးသား အိမ်သာ။\n\n2. 他是男的。\nHe is male.\nသူက ယောက်ျားလေး။\n\n3. 男学生。\nMale student.\nကျောင်းသား။', 'audio/hsk1/男.mp3', 260),
('hsk1_261', 1, '男孩儿', 'nán hái r', 'ကောင်လေး', 'boy', 'ကောင်လေး', '1. 那个男孩儿很可爱。\nThat boy is very cute.\nဟိုကောင်လေးက အရမ်းချစ်စရာကောင်းတယ်။\n\n2. 有两个男孩儿。\nThere are two boys.\nကောင်လေး နှစ်ယောက် ရှိတယ်။\n\n3. 他是谁家的男孩儿？\nWhose boy is he?\nသူက ဘယ်သူ့အိမ်က ကောင်လေးလဲ။', 'audio/hsk1/男孩儿.mp3', 261),
('hsk1_262', 1, '男朋友', 'nán péng you', 'ရည်းစား (ကောင်လေး)', 'boyfriend', 'ရည်းစား (ကောင်လေး)', '1. 这是我的男朋友。\nThis is my boyfriend.\nဒါ ငါ့ကောင်လေး (ရည်းစား) ပါ။\n\n2. 你有男朋友吗？\nDo you have a boyfriend?\nမင်းမှာ ရည်းစားရှိလား။\n\n3. 男朋友对我很好。\nMy boyfriend treats me very well.\nကောင်လေးက ငါ့အပေါ် အရမ်းကောင်းတယ်။', 'audio/hsk1/男朋友.mp3', 262),
('hsk1_263', 1, '男人', 'nán rén', 'ယောက်ျား', 'man', 'ယောက်ျား', '1. 这里没有男人。\nThere are no men here.\nဒီမှာ ယောက်ျားတွေ မရှိဘူး။\n\n2. 一个男人走过来了。\nA man came over.\nယောက်ျားတစ်ယောက် လမ်းလျှောက်လာပြီ။\n\n3. 他是好男人。\nHe is a good man.\nသူက ယောက်ျားကောင်း တစ်ယောက်ပါ။', 'audio/hsk1/男人.mp3', 263),
('hsk1_264', 1, '南', 'nán', 'တောင်ဘက်', 'south', 'တောင်ဘက်', '1. 向南走。\nWalk towards the south.\nတောင်ဘက်ကို လျှောက်သွားပါ။\n\n2. 我在南方。\nI am in the south.\nငါ တောင်ဘက်ပိုင်းမှာ ရောက်နေတယ်။\n\n3. 学校在南边\nThe school is on the south side.\nကျောင်းက တောင်ဘက်အခြမ်းမှာ ရှိတယ်။', 'audio/hsk1/南.mp3', 264),
('hsk1_265', 1, '难', 'nán', 'ခက်သည်', 'difficult / hard', 'ခက်သည်', '1. 这个问题很难。\nThis problem is very difficult.\nဒီပြဿနာက အရမ်းခက်တယ်။\n\n2. 汉语不难。\nChinese is not difficult.\nတရုတ်စာ မခက်ပါဘူး။\n\n3. 太难了。\nToo difficult.\nအရမ်းခက်လွန်းတယ်။', 'audio/hsk1/难.mp3', 265),
('hsk1_266', 1, '呢', 'ne', 'ရော / လေ (အမေးစကားလုံး)', '(question particle)', 'ရော / လေ (အမေးစကားလုံး)', '1. 你呢？\nAnd you?\nမင်းရော။\n\n2. 书呢？\nWhere is the book?\nစာအုပ်ရော (ဘယ်မှာလဲ)။\n\n3. 他在哪儿呢？\nWhere is he?\nသူ ဘယ်မှာလဲ။', 'audio/hsk1/呢.mp3', 266),
('hsk1_267', 1, '能', 'néng', 'နိုင်သည် / တတ်သည်', 'can / be able to', 'နိုင်သည် / တတ်သည်', '1. 我能去吗？\nCan I go?\nငါ သွားလို့ရမလား။\n\n2. 你能不能帮我？\nCan you help me?\nမင်း ငါ့ကို ကူညီနိုင်မလား။\n\n3. 我不能吃辣。\nI cannot eat spicy food.\nငါ အစပ်မစားနိုင်ဘူး။', 'audio/hsk1/能.mp3', 267),
('hsk1_268', 1, '你', 'nǐ', 'မင်း / နင် / ခင်ဗျား', 'you', 'မင်း / နင် / ခင်ဗျား', '1. 你好。\nHello.\nမင်္ဂလာပါ။\n\n2. 我等你。\nI wait for you.\nငါ မင်းကို စောင့်နေတယ်။\n\n3. 是你的吗？\nIs it yours?\nဒါ မင်းရဲ့ဟာလား။', 'audio/hsk1/你.mp3', 268),
('hsk1_269', 1, '你们', 'nǐ men', 'မင်းတို့ / နင်တို့ / ခင်ဗျားတို့', 'you (plural)', 'မင်းတို့ / နင်တို့ / ခင်ဗျားတို့', '1. 你们好。\nHello everyone (You all).\nအားလုံးပဲ မင်္ဂလာပါ။\n\n2. 你们去哪儿？\nWhere are you guys going?\nမင်းတို့ ဘယ်သွားမလို့လဲ။\n\n3. 这是你们的吗？\nIs this yours (plural)?\nဒါ မင်းတို့ဟာလား။', 'audio/hsk1/你们.mp3', 269),
('hsk1_270', 1, '年', 'nián', 'နှစ်', 'year', 'နှစ်', '1. 一年有十二个月。\nA year has 12 months.\nတစ်နှစ်မှာ ၁၂ လ ရှိတယ်။\n\n2. 新年快乐。\nHappy New Year.\nနှစ်သစ်မှာ ပျော်ရွှင်ပါစေ။\n\n3. 这几年。\nThese past few years.\nဒီနှစ်ပိုင်းတွေမှာ။', 'audio/hsk1/年.mp3', 270),
('hsk1_271', 1, '鸟', 'niǎo', 'ငှက်', 'bird', 'ငှက်', '1. 那是一只鸟。\nThat is a bird.\nအဲဒါ ငှက်တစ်ကောင် ဖြစ်တယ်။\n\n2. 鸟在飞。\nBirds are flying.\nငှက်တွေ ပျံနေတယ်။\n\n3. 听鸟叫。\nListen to the birds singing.\nငှက်အော်သံ နားထောင်ကြည့်။', 'audio/hsk1/鸟.mp3', 271),
('hsk1_272', 1, '您', 'nín', 'ခင်ဗျား (ယဉ်ကျေးသောသုံးနှုန်း)', 'you (polite form)', 'ခင်ဗျား (ယဉ်ကျေးသောသုံးနှုန်း)', '1. 您好。\nHello (polite).\nမင်္ဂလာပါခင်ဗျာ။\n\n2. 您贵姓？\nWhat is your surname (polite)?\nခင်ဗျား နာမည် (မျိုးရိုးနာမည်) ဘယ်လိုခေါ်လဲ။\n\n3. 谢谢您。\nThank you (polite).\nကျေးဇူးတင်ပါတယ်ခင်ဗျာ။', 'audio/hsk1/您.mp3', 272),
('hsk1_273', 1, '牛', 'niú', 'နွား', 'cow / ox', 'နွား', '1. 那是牛。\nThat is a cow.\nအဲဒါ နွားပါ။\n\n2. 好多牛。\nMany cows.\nနွားတွေ အများကြီးပဲ။\n\n3. 我不吃牛肉。\nI don\'t eat beef.\nငါ အမဲသား မစားဘူး။', 'audio/hsk1/牛.mp3', 273),
('hsk1_274', 1, '牛奶', 'niú nǎi', 'နွားနို့', 'milk', 'နွားနို့', '1. 喝牛奶。\nDrink milk.\nနွားနို့ သောက်တယ်။\n\n2. 热牛奶。\nHot milk.\nနွားနို့ပူပူ။\n\n3. 买了一瓶牛奶。\nBought a bottle of milk.\nနွားနို့တစ်ပုလင်း ဝယ်ခဲ့တယ်။', 'audio/hsk1/牛奶.mp3', 274),
('hsk1_275', 1, '女', 'nǚ', 'မိန်းကလေး / အမျိုးသမီး', 'female', 'မိန်းကလေး / အမျိုးသမီး', '1. 她是女的。\nShe is female.\nသူမက မိန်းကလေး။\n\n2. 女厕所。\nFemale restroom.\nအမျိုးသမီး အိမ်သာ။\n\n3. 女儿。\nDaughter.\nသမီး (မိန်းကလေး)။', 'audio/hsk1/女.mp3', 275),
('hsk1_276', 1, '女儿', 'nǚ ér', 'သမီး (သမီးမိန်းကလေး)', 'daughter', 'သမီး (သမီးမိန်းကလေး)', '1. 这是我女儿。\nThis is my daughter.\nဒါ ငါ့သမီး။\n\n2. 女儿很乖。\nDaughter is very obedient/good.\nသမီးက အရမ်းလိမ္မာတယ်။\n\n3. 你有女儿吗？\nDo you have a daughter?\nမင်းမှာ သမီးရှိလား။', 'audio/hsk1/女儿.mp3', 276),
('hsk1_277', 1, '女孩儿', 'nǚ hái r', 'မိန်းကလေး / ကောင်မလေး', 'girl', 'မိန်းကလေး / ကောင်မလေး', '1. 那个女孩儿是谁？\nWho is that girl?\nဟိုကောင်မလေးက ဘယ်သူလဲ။\n\n2. 漂亮的女孩儿。\nBeautiful girl.\nလှပတဲ့ မိန်းကလေး။\n\n3. 她是我的女孩儿。\nShe is my girl (daughter/girlfriend - context dependent).\nသူက ငါ့ကောင်မလေး။', 'audio/hsk1/女孩儿.mp3', 277),
('hsk1_278', 1, '女朋友', 'nǚ péng you', 'ရည်းစား (ကောင်မလေး)', 'girlfriend', 'ရည်းစား (ကောင်မလေး)', '1. 他有女朋友了。\nHe has a girlfriend.\nသူ့မှာ ကောင်မလေး (ရည်းစား) ရှိတယ်။\n\n2. 她是我的女朋友。\nShe is my girlfriend.\nသူမက ငါ့ရည်းစားပါ။\n\n3. 给女朋友买礼物。\nBuy a gift for girlfriend.\nကောင်မလေးအတွက် လက်ဆောင်ဝယ်တယ်။', 'audio/hsk1/女朋友.mp3', 278),
('hsk1_279', 1, '女人', 'nǚ rén', 'အမျိုးသမီး / မိန်းမ', 'woman', 'အမျိုးသမီး / မိန်းမ', '1. 一个女人。\nA woman.\nအမျိုးသမီး တစ်ယောက်။\n\n2. 那个女人很美。\nThat woman is very beautiful.\nဟိုအမျိုးသမီးက အရမ်းလှတယ်။\n\n3. 聪明的女人。\nSmart woman.\nထက်မြက်တဲ့ အမျိုးသမီး။', 'audio/hsk1/女人.mp3', 279),
('hsk1_280', 1, '旁边', 'páng biān', 'ဘေးနား', 'side / beside', 'ဘေးနား', '1. 坐在我旁边。\nSit beside me.\nငါ့ဘေးနားမှာ ထိုင်ပါ။\n\n2. 学校旁边有商店。\nThere is a shop beside the school.\nကျောင်းဘေးနားမှာ ဆိုင်ရှိတယ်။\n\n3. 他在旁边。\nHe is at the side.\nသူ ဘေးနားမှာ ရှိတယ်။', 'audio/hsk1/旁边.mp3', 280),
('hsk1_281', 1, '跑', 'pǎo', 'ပြေးသည်', 'run', 'ပြေးသည်', '1. 跑得快。\nRun fast.\nမြန်မြန် ပြေးတယ်။\n\n2. 他在跑步。\nHe is running.\nသူ ပြေးနေတယ်။\n\n3. 别乱跑。\nDon\'t run around.\nလျှောက်မပြေးနဲ့။', 'audio/hsk1/跑.mp3', 281),
('hsk1_282', 1, '跑步', 'pǎo bù', 'အပြေး(လေ့ကျင့်ခန်း)', 'run / jog', 'အပြေး(လေ့ကျင့်ခန်း)', '1. 我喜欢跑步。\nI like running.\nငါပြေးရတာ ကြိုက်တယ်။\n\n2. 每天早上跑步。\nRun every morning.\nမနက်တိုင်း ပြေးတယ်။\n\n3. 去公园跑步。\nGo to the park to run.\nပန်းခြံသွားပြီး ပြေးတယ်။', 'audio/hsk1/跑步.mp3', 282),
('hsk1_283', 1, '朋友', 'péng you', 'သူငယ်ချင်း / မိတ်ဆွေ', 'friend', 'သူငယ်ချင်း / မိတ်ဆွေ', '1. 好朋友。\nGood friend.\nသူငယ်ချင်းကောင်း။\n\n2. 我们是朋友。\nWe are friends.\nငါတို့က သူငယ်ချင်းတွေပါ။\n\n3. 男朋友和女朋友。\nBoyfriend and girlfriend.\nကောင်လေးနဲ့ ကောင်မလေး (ရည်းစားတွေ)။', 'audio/hsk1/朋友.mp3', 283),
('hsk1_284', 1, '票', 'piào', 'လက်မှတ်', 'ticket', 'လက်မှတ်', '1. 一张票。\nOne ticket.\nလက်မှတ် တစ်စောင်။\n\n2. 买票。\nBuy a ticket.\nလက်မှတ် ဝယ်တယ်။\n\n3. 票卖完了。\nTickets are sold out.\nလက်မှတ်တွေ ရောင်းကုန်သွားပြီ။', 'audio/hsk1/票.mp3', 284),
('hsk1_285', 1, '七', 'qī', 'ခုနစ် (ဂဏန်း)', 'seven', 'ခုနစ် (ဂဏန်း)', '1. 七个。\nSeven items.\nခုနစ်ခု။\n\n2. 七月。\nJuly.\nဇူလိုင်လ။\n\n3. 七点钟。\nSeven o\'clock.\nခုနစ်နာရီ။', 'audio/hsk1/七.mp3', 285),
('hsk1_286', 1, '起', 'qǐ', 'ထသည် / စသည် / တက်သည်', 'get up / start / rise', 'ထသည် / စသည် / တက်သည်', '1. 起来。\nStand up / Get up.\nထပါ / ထလိုက်ပါ။\n\n2. 一起。\nTogether.\nအတူတူ။\n\n3. 起飞。\nTake off (airplane).\nလေယာဉ်ပျံတက်တယ်။', 'audio/hsk1/起.mp3', 286),
('hsk1_287', 1, '起床', 'qǐ chuáng', 'အိပ်ရာထသည်', 'get out of bed', 'အိပ်ရာထသည်', '1. 我早上六点起床。\nI get up at 6 in the morning.\nငါ မနက် ၆ နာရီ အိပ်ရာထတယ်။\n\n2. 快起床。\nGet up quickly.\nမြန်မြန် အိပ်ရာထ။\n\n3. 还没起床。\nHaven\'t got up yet.\nအိပ်ရာ မထသေးဘူး။', 'audio/hsk1/起床.mp3', 287),
('hsk1_288', 1, '起来', 'qǐ lái', 'ထသည် / ထလာသည်', 'stand up / get up', 'ထသည် / ထလာသည်', '1. 站起来。\nStand up.\nမတ်တတ်ရပ်ပါ။\n\n2. 看起来。\nLooks like.\nကြည့်ရတာတော့။\n\n3. 拿起来。\nPick it up.\nကောက်ယူလိုက်ပါ။', 'audio/hsk1/起来.mp3', 288),
('hsk1_289', 1, '汽车', 'qì chē', 'ကား', 'car / automobile', 'ကား', '1. 开汽车。\nDrive a car.\nကားမောင်းတယ်။\n\n2. 汽车站。\nBus station.\nကားဂိတ်။\n\n3. 这辆汽车很新。\nThis car is very new.\nဒီကားက အရမ်းသစ်တယ်။', 'audio/hsk1/汽车.mp3', 289),
('hsk1_290', 1, '前', 'qián', 'ရှေ့ / အရင်', 'front / before', 'ရှေ့ / အရင်', '1. 前边有人。\nThere is someone in front.\nအရှေ့မှာ လူရှိတယ်။\n\n2. 三天前。\nThree days ago.\nလွန်ခဲ့တဲ့ ၃ ရက်က။\n\n3. 以前。\nBefore.\nအရင်တုန်းက။', 'audio/hsk1/前.mp3', 290),
('hsk1_291', 1, '钱', 'qián', 'ပိုက်ဆံ', 'money', 'ပိုက်ဆံ', '1. 多少钱？\nHow much money?\nပိုက်ဆံ ဘယ်လောက်လဲ။\n\n2. 我没有钱。\nI don\'t have money.\nငါ့မှာ ပိုက်ဆံမရှိဘူး။\n\n3. 花钱。\nSpend money.\nပိုက်ဆံသုံးတယ်။', 'audio/hsk1/钱.mp3', 291),
('hsk1_292', 1, '钱包', 'qián bāo', 'ပိုက်ဆံအိတ်', 'wallet / purse', 'ပိုက်ဆံအိတ်', '1. 我的钱包丢了。\nMy wallet is lost.\nငါ့ပိုက်ဆံအိတ် ပျောက်သွားပြီ။\n\n2. 钱包里有钱。\nThere is money in the wallet.\nပိုက်ဆံအိတ်ထဲမှာ ပိုက်ဆံရှိတယ်။\n\n3. 买个新钱包。\nBuy a new wallet.\nပိုက်ဆံအိတ်အသစ် ဝယ်တယ်။', 'audio/hsk1/钱包.mp3', 292),
('hsk1_293', 1, '请', 'qǐng', 'ကျေးဇူးပြုပြီး / ဖိတ်သည်', 'please / invite', 'ကျေးဇူးပြုပြီး / ဖိတ်သည်', '1. 请坐。\nPlease sit down.\nကျေးဇူးပြုပြီး ထိုင်ပါ။\n\n2. 请问。\nMay I ask.\nတဆိတ်လောက် မေးပါရစေ။\n\n3. 我请你吃饭。\nI invite you to eat (I\'ll treat you).\nငါ မင်းကို ထမင်းကျွေးပါရစေ (ငါ ဒကာခံမယ်)။', 'audio/hsk1/请.mp3', 293),
('hsk1_294', 1, '请假', 'qǐng jià', 'ခွင့်တိုင်သည်', 'ask for leave', 'ခွင့်တိုင်သည်', '1. 我要请假。\nI want to ask for leave.\nငါ ခွင့်တိုင်ချင်တယ်။\n\n2. 请病假。\nAsk for sick leave.\nဆေးခွင့်တိုင်တယ်။\n\n3. 请一天假。\nAsk for one day leave.\nတစ်ရက် ခွင့်ယူတယ်။', 'audio/hsk1/请假.mp3', 294),
('hsk1_295', 1, '请进', 'qǐng jìn', 'ကျေးဇူးပြုပြီး ဝင်လာပါ', 'please come in', 'ကျေးဇူးပြုပြီး ဝင်လာပါ', '1. 快请进。\nPlease come in quickly.\nမြန်မြန် ဝင်လာပါ။\n\n2. 有人吗？请进。\nIs anyone there? Please come in.\nလူရှိလား။ ဝင်လာခဲ့ပါ။\n\n3. 老师请进。\n\"Teacher, please come in.\"\nဆရာ၊ ဝင်လာပါ။', 'audio/hsk1/请进.mp3', 295),
('hsk1_296', 1, '请问', 'qǐng wèn', 'တဆိတ်လောက် မေးပါရစေ / မေးစမ်းပါရစေ', 'may I ask', 'တဆိတ်လောက် မေးပါရစေ / မေးစမ်းပါရစေ', '1. 请问，洗手间在哪儿？\n\"May I ask, where is the restroom?\"\nတဆိတ်လောက် မေးပါရစေ၊ အိမ်သာ ဘယ်မှာလဲ။\n\n2. 请问，现在几点了？\n\"May I ask, what time is it now?\"\nတဆိတ်လောက်ဗျာ၊ အခု ဘယ်နှနာရီ ရှိပြီလဲ။\n\n3. 请问，你是李老师吗？\n\"May I ask, are you Teacher Li?\"\nတဆိတ်လောက်ပါ၊ ခင်ဗျားက ဆရာလီ လား။', 'audio/hsk1/请问.mp3', 296),
('hsk1_297', 1, '请坐', 'qǐng zuò', 'ကျေးဇူးပြုပြီး ထိုင်ပါ', 'please sit down', 'ကျေးဇူးပြုပြီး ထိုင်ပါ', '1. 大家请坐。\nEveryone please sit down.\nအားလုံး ထိုင်ကြပါ။\n\n2. 别客气，请坐。\n\"Don\'t be polite, please sit.\"\nအားမနာပါနဲ့၊ ထိုင်ပါ။\n\n3. 请坐下喝茶。\nPlease sit down and drink tea.\nထိုင်ပြီး လက်ဖက်ရည် သောက်ပါဦး။', 'audio/hsk1/请坐.mp3', 297),
('hsk1_298', 1, '球', 'qiú', 'ဘောလုံး', 'ball', 'ဘောလုံး', '1. 打球。\nPlay ball.\nဘောလုံး ကစားတယ်။\n\n2. 这是一个球。\nThis is a ball.\nဒါက ဘောလုံးတစ်လုံး ဖြစ်တယ်။\n\n3. 球在那儿。\nThe ball is over there.\nဘောလုံး ဟိုမှာ။', 'audio/hsk1/球.mp3', 298),
('hsk1_299', 1, '去', 'qù', 'သွားသည်', 'go', 'သွားသည်', '1. 我去学校。\nI go to school.\nငါ ကျောင်းသွားတယ်။\n\n2. 你去哪儿？\nWhere are you going?\nမင်း ဘယ်သွားမလို့လဲ။\n\n3. 我们一起去吧。\nLet\'s go together.\nငါတို့ အတူတူ သွားကြစို့။', 'audio/hsk1/去.mp3', 299),
('hsk1_300', 1, '去年', 'qù nián', 'မနှစ်က', 'last year', 'မနှစ်က', '1. 去年我在中国。\nLast year I was in China.\nမနှစ်က ငါတရုတ်ပြည်မှာနေတယ်။\n\n2. 他是去年来的。\nHe came last year.\nသူ မနှစ်က လာခဲ့တာ။\n\n3. 去年的照片。\nLast year\'s photo.\nမနှစ်က ဓာတ်ပုံ။', 'audio/hsk1/去年.mp3', 300),
('hsk1_301', 1, '热', 'rè', 'ပူသည်', 'hot', 'ပူသည်', '1. 今天很热。\nToday is very hot.\nဒီနေ့ အရမ်းပူတယ်။\n\n2. 我想喝热茶。\nI want to drink hot tea.\nငါ ရေနွေးကြမ်းပူပူ သောက်ချင်တယ်။\n\n3. 太热了。\nToo hot.\nအရမ်းပူလွန်းတယ်။', 'audio/hsk1/热.mp3', 301),
('hsk1_302', 1, '人', 'rén', 'လူ', 'person / people', 'လူ', '1. 很多人。\nMany people.\nလူတွေ အများကြီး။\n\n2. 你是哪里人？\nWhere are you from?\nမင်းက ဘယ်ကလဲ (ဘယ်ဒေသက လူလဲ)။\n\n3. 他是好人。\nHe is a good person.\nသူက လူကောင်းတစ်ယောက်ပါ။', 'audio/hsk1/人.mp3', 302),
('hsk1_303', 1, '认识', 'rèn shi', 'သိသည် / ခင်မင်သည်', 'know / recognize / meet', 'သိသည် / ခင်မင်သည်', '1. 很高兴认识你。\nNice to meet you.\nမင်းနဲ့ တွေ့ရတာ ဝမ်းသာပါတယ်။\n\n2. 我不认识他。\nI don\'t know him.\nငါ သူ့ကို မသိဘူး။\n\n3. 你认识这个字吗？\nDo you recognize this character?\nမင်း ဒီစာလုံးကို သိလား။', 'audio/hsk1/认识.mp3', 303),
('hsk1_304', 1, '认真', 'rèn zhēn', 'အလေးအနက်ထားသော / ကြိုးစားသော', 'serious / conscientious', 'အလေးအနက်ထားသော / ကြိုးစားသော', '1. 他学习很认真。\nHe studies very seriously.\nသူ စာကြိုးစားတယ်။\n\n2. 认真听讲。\nListen carefully.\nသေချာ အာရုံစိုက် နားထောင်ပါ။\n\n3. 你是认真的吗？\nAre you serious?\nမင်း အတည်ပြောနေတာလား။', 'audio/hsk1/认真.mp3', 304),
('hsk1_305', 1, '日', 'rì', 'နေ့ / နေ', 'day / sun', 'နေ့ / နေ', '1. 三日。\nThree days.\n၃ ရက်။\n\n2. 日记。\nDiary.\nနေ့စဉ်မှတ်တမ်း။\n\n3. 星期日。\nSunday.\nတနင်္ဂနွေနေ့။', 'audio/hsk1/日.mp3', 305),
('hsk1_306', 1, '日期', 'rì qī', 'ရက်စွဲ', 'date', 'ရက်စွဲ', '1. 今天是什么日期？\nWhat is the date today?\nဒီနေ့ ရက်စွဲ ဘယ်လောက်လဲ။\n\n2. 写下日期。\nWrite down the date.\nရက်စွဲ ရေးမှတ်ပါ။\n\n3. 考试日期。\nExam date.\nစာမေးပွဲ ရက်စွဲ။', 'audio/hsk1/日期.mp3', 306),
('hsk1_307', 1, '肉', 'ròu', 'အသား', 'meat', 'အသား', '1. 我爱吃肉。\nI love eating meat.\nငါ အသားစားရတာ ကြိုက်တယ်။\n\n2. 这是什么肉？\nWhat meat is this?\nဒါ ဘာအသားလဲ။\n\n3. 我不吃肉。\nI don\'t eat meat.\nငါ အသားမစားဘူး။', 'audio/hsk1/肉.mp3', 307),
('hsk1_308', 1, '三', 'sān', 'သုံး (ဂဏန်း)', 'three', 'သုံး (ဂဏန်း)', '1. 三个苹果。\nThree apples.\nပန်းသီး သုံးလုံး။\n\n2. 三点钟。\nThree o\'clock.\nသုံးနာရီ။\n\n3. 星期三。\nWednesday.\nဗုဒ္ဓဟူးနေ့။', 'audio/hsk1/三.mp3', 308),
('hsk1_309', 1, '山', 'shān', 'တောင်', 'mountain', 'တောင်', '1. 上山。\nGo up the mountain.\nတောင်တက်တယ်။\n\n2. 山很高。\nThe mountain is very high.\nတောင်က အရမ်းမြင့်တယ်။\n\n3. 山下。\nFoot of the mountain.\nတောင်အောက်။', 'audio/hsk1/山.mp3', 309),
('hsk1_310', 1, '商场', 'shāng chǎng', 'ကုန်တိုက်', 'shopping mall', 'ကုန်တိုက်', '1. 去商场买衣服。\nGo to the mall to buy clothes.\nအဝတ်အစားဝယ်ဖို့ ကုန်တိုက်သွားတယ်။\n\n2. 这个商场很大。\nThis mall is very big.\nဒီကုန်တိုက်က အရမ်းကြီးတယ်။\n\n3. 商场里人很多。\nThere are many people in the mall.\nကုန်တိုက်ထဲမှာ လူတွေ အများကြီးပဲ။', 'audio/hsk1/商场.mp3', 310),
('hsk1_311', 1, '商店', 'shāng diàn', 'ဆိုင်', 'shop / store', 'ဆိုင်', '1. 我去商店。\nI go to the shop.\nငါ ဆိုင်သွားတယ်။\n\n2. 商店关门了。\nThe shop is closed.\nဆိုင်ပိတ်သွားပြီ။\n\n3. 小商店。\nSmall shop.\nဆိုင်လေး။', 'audio/hsk1/商店.mp3', 311),
('hsk1_312', 1, '上', 'shàng', 'အပေါ် / တက်သည်', 'up / on / get on', 'အပေါ် / တက်သည်', '1. 上车。\nGet on the car.\nကားပေါ်တက်ပါ။\n\n2. 楼上。\nUpstairs.\nအပေါ်ထပ်။\n\n3. 去上学。\nGo to school.\nကျောင်းတက်တယ်။', 'audio/hsk1/上.mp3', 312),
('hsk1_313', 1, '上班', 'shàng bān', 'အလုပ်သွားသည် / အလုပ်ဆင်းသည်', 'go to work', 'အလုပ်သွားသည် / အလုပ်ဆင်းသည်', '1. 我八点上班。\nI start work at 8.\nငါ ၈ နာရီ အလုပ်ဆင်းတယ်။\n\n2. 他在上班。\nHe is at work.\nသူ အလုပ်လုပ်နေတယ်။\n\n3. 明天不上班。\nTomorrow I don\'t work.\nမနက်ဖြန် အလုပ်မဆင်းဘူး။', 'audio/hsk1/上班.mp3', 313),
('hsk1_314', 1, '上车', 'shàng chē', 'ကားပေါ်တက်သည်', 'get on (a vehicle)', 'ကားပေါ်တက်သည်', '1. 快上车。\nGet on the car quickly.\nကားပေါ် မြန်မြန်တက်ပါ။\n\n2. 先下后上。\n\"Get off first, then get on.\"\nဆင်းမယ့်သူ အရင်ဆင်းပြီးမှ တက်ပါ။\n\n3. 我不喜欢上车。\nI don\'t like getting on the car.\nငါ ကားပေါ်တက်ရတာ မကြိုက်ဘူး။', 'audio/hsk1/上车.mp3', 314),
('hsk1_315', 1, '上次', 'shàng cì', 'ပြီးခဲ့တဲ့တစ်ခေါက် / လွန်ခဲ့တဲ့အကြိမ်', 'last time', 'ပြီးခဲ့တဲ့တစ်ခေါက် / လွန်ခဲ့တဲ့အကြိမ်', '1. 上次我没来。\nI didn\'t come last time.\nပြီးခဲ့တဲ့တစ်ခေါက်တုန်းက ငါမလာခဲ့ဘူး။\n\n2. 这是上次买的。\nThis was bought last time.\nဒါ ပြီးခဲ့တဲ့တစ်ခေါက်က ဝယ်ခဲ့တာ။\n\n3. 上次很有趣。\nLast time was very interesting.\nပြီးခဲ့တဲ့တစ်ခေါက်တုန်းက အရမ်းစိတ်ဝင်စားဖို့ကောင်းတယ်။', 'audio/hsk1/上次.mp3', 315),
('hsk1_316', 1, '上课', 'shàng kè', 'အတန်းတက်သည် / စာသင်သည်', 'attend class / class begins', 'အတန်းတက်သည် / စာသင်သည်', '1. 我们要上课了。\nWe are about to start class.\nငါတို့ အတန်းစတော့မယ်။\n\n2. 我不喜欢上课。\nI don\'t like attending class.\nငါ အတန်းတက်ရတာ မကြိုက်ဘူး။\n\n3. 几点上课？\nWhat time does class start?\nဘယ်အချိန် အတန်းစမှာလဲ။', 'audio/hsk1/上课.mp3', 316),
('hsk1_317', 1, '上网', 'shàng wǎng', 'အင်တာနက်သုံးသည်', 'go online', 'အင်တာနက်သုံးသည်', '1. 我每天上网。\nI go online every day.\nငါ နေ့တိုင်း အင်တာနက်သုံးတယ်။\n\n2. 上网查一下。\nCheck online.\nအင်တာနက်မှာ ရှာကြည့်လိုက်ပါ။\n\n3. 别总是上网。\nDon\'t always be online.\nအမြဲတမ်း အင်တာနက်ပဲ သုံးမနေနဲ့။', 'audio/hsk1/上网.mp3', 317),
('hsk1_318', 1, '上午', 'shàng wǔ', 'မနက်ခင်း (နေ့လယ်မတိုင်ခင်)', 'morning', 'မနက်ခင်း (နေ့လယ်မတိုင်ခင်)', '1. 上午好。\nGood morning.\nမင်္ဂလာနံနက်ခင်းပါ။\n\n2. 今天上午我有事。\nI have something to do this morning.\nဒီနေ့မနက် ငါကိစ္စရှိတယ်။\n\n3. 上午八点。\n8 o\'clock in the morning.\nမနက် ၈ နာရီ။', 'audio/hsk1/上午.mp3', 318),
('hsk1_319', 1, '上学', 'shàng xué', 'ကျောင်းတက်သည် / ကျောင်းသွားသည်', 'go to school', 'ကျောင်းတက်သည် / ကျောင်းသွားသည်', '1. 孩子去上学了。\nThe child went to school.\nကလေး ကျောင်းသွားပြီ။\n\n2. 几岁上学？\nAt what age do you start school?\nဘယ်အရွယ်မှာ ကျောင်းစနေတာလဲ။\n\n3. 我不想上学。\nI don\'t want to go to school.\nငါ ကျောင်းမသွားချင်ဘူး။', 'audio/hsk1/上学.mp3', 319),
('hsk1_320', 1, '少', 'shǎo', 'နည်းသည်', 'few / little', 'နည်းသည်', '1. 人很少。\nThere are very few people.\nလူ အရမ်းနည်းတယ်။\n\n2. 少吃一点。\nEat a little less.\nနည်းနည်း လျှော့စားပါ။\n\n3. 多少？\nHow many / How much? (More or less).\nဘယ်လောက်လဲ။', 'audio/hsk1/少.mp3', 320),
('hsk1_321', 1, '谁', 'shéi', 'ဘယ်သူ', 'who', 'ဘယ်သူ', '1. 他是谁？\nWho is he?\nသူ ဘယ်သူလဲ။\n\n2. 谁来了？\nWho has come?\nဘယ်သူ လာတာလဲ။\n\n3. 这是谁的书？\nWhose book is this?\nဒါ ဘယ်သူ့စာအုပ်လဲ။', 'audio/hsk1/谁.mp3', 321),
('hsk1_322', 1, '身体', 'shēn tǐ', 'ခန္ဓာကိုယ် / ကျန်းမာရေး', 'body / health', 'ခန္ဓာကိုယ် / ကျန်းမာရေး', '1. 身体好吗？\nHow is your health?\nနေကောင်းလား / ကျန်းမာရေး ကောင်းလား။\n\n2. 注意身体。\nTake care of your health.\nကျန်းမာရေး ဂရုစိုက်ပါ။\n\n3. 这是我的身体。\nThis is my body.\nဒါ ငါ့ခန္ဓာကိုယ်။', 'audio/hsk1/身体.mp3', 322),
('hsk1_323', 1, '什么', 'shén me', 'ဘာ', 'what', 'ဘာ', '1. 这是什么？\nWhat is this?\nဒါ ဘာလဲ။\n\n2. 你说什么？\nWhat did you say?\nမင်း ဘာပြောလိုက်တာလဲ။\n\n3. 没什么。\nNothing.\nဘာမှ မဟုတ်ပါဘူး။', 'audio/hsk1/什么.mp3', 323),
('hsk1_324', 1, '生病', 'shēng bìng', 'နေမကောင်းဖြစ်သည်', 'get sick', 'နေမကောင်းဖြစ်သည်', '1. 他生病了。\nHe is sick.\nသူ နေမကောင်းဘူး။\n\n2. 别生病。\nDon\'t get sick.\nနေမကောင်း မဖြစ်စေနဲ့။\n\n3. 生病要去医院。\n\"If you are sick, go to the hospital.\"\nနေမကောင်းရင် ဆေးရုံသွားရမယ်။', 'audio/hsk1/生病.mp3', 324),
('hsk1_325', 1, '生气', 'shēng qì', 'စိတ်ဆိုးသည် / ဒေါသထွက်သည်', 'angry', 'စိတ်ဆိုးသည် / ဒေါသထွက်သည်', '1. 别生气。\nDon\'t be angry.\nစိတ်မဆိုးပါနဲ့။\n\n2. 他生气了。\nHe is angry.\nသူ စိတ်ဆိုးသွားပြီ။\n\n3. 你为什么生气？\nWhy are you angry?\nမင်း ဘာလို့ စိတ်ဆိုးတာလဲ။', 'audio/hsk1/生气.mp3', 325),
('hsk1_326', 1, '生日', 'shēng rì', 'မွေးနေ့', 'birthday', 'မွေးနေ့', '1. 祝你生日快乐。\nHappy birthday to you.\nမွေးနေ့မှာ ပျော်ရွှင်ပါစေ။\n\n2. 今天是我的生日。\nToday is my birthday.\nဒီနေ့ ငါ့မွေးနေ့။\n\n3. 生日礼物。\nBirthday gift.\nမွေးနေ့လက်ဆောင်။', 'audio/hsk1/生日.mp3', 326),
('hsk1_327', 1, '十', 'shí', 'တစ်ဆယ် (ဂဏန်း)', 'ten', 'တစ်ဆယ် (ဂဏန်း)', '1. 十个人。\nTen people.\nလူဆယ်ယောက်။\n\n2. 十点。\nTen o\'clock.\nဆယ်နာရီ။\n\n3. 五十。\nFifty.\nငါးဆယ်။', 'audio/hsk1/十.mp3', 327),
('hsk1_328', 1, '时候', 'shí hou', 'အချိန် / တုန်းက', 'time / moment', 'အချိန် / တုန်းက', '1. 什么时候？\nWhen?\nဘယ်အချိန်လဲ။\n\n2. 小时候。\nWhen I was young.\nငယ်ငယ်တုန်းက။\n\n3. 吃饭的时候。\nWhen eating.\nထမင်းစားနေတဲ့အချိန်။', 'audio/hsk1/时候.mp3', 328),
('hsk1_329', 1, '时间', 'shí jiān', 'အချိန်', 'time', 'အချိန်', '1. 没有时间了。\nNo time left.\nအချိန် မရှိတော့ဘူး။\n\n2. 时间很宝贵。\nTime is precious.\nအချိန်က တန်ဖိုးရှိတယ်။\n\n3. 你需要多少时间？\nHow much time do you need?\nမင်း အချိန်ဘယ်လောက် လိုမလဲ။', 'audio/hsk1/时间.mp3', 329),
('hsk1_330', 1, '事', 'shì', 'ကိစ္စ / အလုပ်', 'matter / thing / business', 'ကိစ္စ / အလုပ်', '1. 我有事。\nI have something to do.\nငါ့မှာကိစ္စ/အလုပ်ရှိတယ်။\n\n2. 什么事？\nWhat\'s the matter?\nဘာကိစ္စလဲ။\n\n3. 没事。\nNo problem / Nothing.\nကိစ္စမရှိပါဘူး။', 'audio/hsk1/事.mp3', 330),
('hsk1_331', 1, '试', 'shì', 'စမ်းကြည့်သည်', 'try', 'စမ်းကြည့်သည်', '1. 试一下。\nTry it.\nစမ်းကြည့်လိုက်ပါ။\n\n2. 这件衣服试一试。\nTry on this piece of clothing.\nဒီအဝတ်အစားကို ဝတ်ကြည့်လိုက်ပါ။\n\n3. 我没试过。\nI haven\'t tried it before.\nငါ မစမ်းဖူးဘူး။', 'audio/hsk1/试.mp3', 331),
('hsk1_332', 1, '是', 'shì', 'ဖြစ်သည် / ဟုတ်သည်', 'is / am / are / yes', 'ဖြစ်သည် / ဟုတ်သည်', '1. 我是中国人。\nI am Chinese.\nငါက တရုတ်လူမျိုး ဖြစ်တယ်။\n\n2. 这是我的书。\nThis is my book.\nဒါ ငါ့စာအုပ်။\n\n3. 是的。\nYes.\nဟုတ်ပါတယ်။', 'audio/hsk1/是.mp3', 332),
('hsk1_333', 1, '是不是', 'shì bu shì', 'ဟုတ်လား / ဟုတ်မဟုတ်', 'is it or not / yes or no', 'ဟုတ်လား / ဟုတ်မဟုတ်', '1. 你是不是累了？\nAre you tired?\nမင်း ပင်ပန်းနေပြီ မဟုတ်လား။\n\n2. 是不是真的？\nIs it true?\nတကယ် ဟုတ်ရဲ့လား။\n\n3. 这是你的，是不是？\n\"This is yours, right?\"\nဒါ မင်းရဲ့ဟာ ဟုတ်တယ်မလား။', 'audio/hsk1/是不是.mp3', 333),
('hsk1_334', 1, '书', 'shū', 'စာအုပ်', 'book', 'စာအုပ်', '1. 我看书。\nI read a book.\nငါ စာဖတ်တယ်။\n\n2. 这是一本新书。\nThis is a new book.\nဒါက စာအုပ်အသစ်တစ်အုပ် ဖြစ်တယ်။\n\n3. 书在桌子上。\nThe book is on the table.\nစာအုပ်က စားပွဲပေါ်မှာ ရှိတယ်။', 'audio/hsk1/书.mp3', 334),
('hsk1_335', 1, '书包', 'shū bāo', 'ကျောင်းလွယ်အိတ်', 'school bag', 'ကျောင်းလွယ်အိတ်', '1. 我的书包很重。\nMy school bag is heavy.\nငါ့ကျောင်းလွယ်အိတ်အရမ်းလေးတယ်။\n\n2. 书包里有什么？\nWhat is in the school bag?\nကျောင်းလွယ်အိတ်ထဲမှာ ဘာရှိလဲ။\n\n3. 买新书包。\nBuy a new school bag.\nကျောင်းလွယ်အိတ်အသစ် ဝယ်တယ်။', 'audio/hsk1/书包.mp3', 335),
('hsk1_336', 1, '书店', 'shū diàn', 'စာအုပ်ဆိုင်', 'bookstore', 'စာအုပ်ဆိုင်', '1. 我去书店。\nI go to the bookstore.\nငါ စာအုပ်ဆိုင် သွားတယ်။\n\n2. 书店很大。\nThe bookstore is very big.\nစာအုပ်ဆိုင်က အရမ်းကြီးတယ်။\n\n3. 这家书店有很多书。\nThis bookstore has many books.\nဒီစာအုပ်ဆိုင်မှာ စာအုပ်တွေ အများကြီးရှိတယ်။', 'audio/hsk1/书店.mp3', 336),
('hsk1_337', 1, '树', 'shù', 'သစ်ပင်', 'tree', 'သစ်ပင်', '1. 那是一棵树。\nThat is a tree.\nအဲဒါ သစ်ပင်တစ်ပင် ဖြစ်တယ်။\n\n2. 树上有一只鸟。\nThere is a bird on the tree.\nသစ်ပင်ပေါ်မှာ ငှက်တစ်ကောင် ရှိတယ်။\n\n3. 这棵树很高。\nThis tree is very tall.\nဒီသစ်ပင်က အရမ်းမြင့်တယ်။', 'audio/hsk1/树.mp3', 337),
('hsk1_338', 1, '水', 'shuǐ', 'ရေ', 'water', 'ရေ', '1. 我想喝水。\nI want to drink water.\nငါ ရေသောက်ချင်တယ်။\n\n2. 这里没有水。\nThere is no water here.\nဒီမှာ ရေမရှိဘူး။\n\n3. 一杯水。\nA cup of water.\nရေတစ်ခွက်။', 'audio/hsk1/水.mp3', 338),
('hsk1_339', 1, '水果', 'shuǐ guǒ', 'သစ်သီး', 'fruit', 'သစ်သီး', '1. 吃水果。\nEat fruit.\nသစ်သီးစားတယ်။\n\n2. 你喜欢什么水果？\nWhat fruit do you like?\nမင်း ဘာသစ်သီး ကြိုက်လဲ။\n\n3. 水果很新鲜。\nThe fruit is fresh.\nသစ်သီးက လတ်ဆတ်တယ်။', 'audio/hsk1/水果.mp3', 339),
('hsk1_340', 1, '睡', 'shuì', 'အိပ်သည်', 'sleep', 'အိပ်သည်', '1. 你想睡吗？\nDo you want to sleep?\nမင်း အိပ်ချင်လား။\n\n2. 太晚了，睡吧。\n\"It\'s too late, go to sleep.\"\nနောက်ကျနေပြီ၊ အိပ်တော့။\n\n3. 睡个好觉。\nHave a good sleep.\nအိပ်ရေးဝဝ အိပ်ပါ။', 'audio/hsk1/睡.mp3', 340),
('hsk1_341', 1, '睡觉', 'shuì jiào', 'အိပ်သည်', 'sleep', 'အိပ်သည်', '1. 他在睡觉。\nHe is sleeping.\nသူ အိပ်နေတယ်။\n\n2. 我要去睡觉了。\nI am going to sleep.\nငါ အိပ်တော့မယ်။\n\n3. 你几点睡觉？\nWhat time do you sleep?\nမင်း ဘယ်အချိန် အိပ်လဲ။', 'audio/hsk1/睡觉.mp3', 341),
('hsk1_342', 1, '说', 'shuō', 'ပြောသည်', 'speak / say', 'ပြောသည်', '1. 你说什么？\nWhat did you say?\nမင်း ဘာပြောလိုက်တာလဲ။\n\n2. 不要说。\nDon\'t say it.\nမပြောပါနဲ့။\n\n3. 听我说。\nListen to me.\nငါပြောတာ နားထောင်။', 'audio/hsk1/说.mp3', 342),
('hsk1_343', 1, '说话', 'shuō huà', 'စကားပြောသည်', 'talk / speak', 'စကားပြောသည်', '1. 别说话。\nDon\'t talk.\nစကားမပြောနဲ့။\n\n2. 他在和谁说话？\nWho is he talking to?\nသူ ဘယ်သူနဲ့ စကားပြောနေတာလဲ။\n\n3. 大声说话。\nSpeak loudly.\nကျယ်ကျယ် ပြောသည်။', 'audio/hsk1/说话.mp3', 343),
('hsk1_344', 1, '四', 'sì', 'လေး (ဂဏန်း)', 'four', 'လေး (ဂဏန်း)', '1. 四个。\nFour items.\nလေးခု။\n\n2. 四月。\nApril.\nဧပြီလ။\n\n3. 星期四。\nThursday.\nကြာသပတေးနေ့။', 'audio/hsk1/四.mp3', 344),
('hsk1_345', 1, '送', 'sòng', 'ပေးသည် / ပို့သည် / လိုက်ပို့သည်', 'give (as gift) / send', 'ပေးသည် / ပို့သည် / လိုက်ပို့သည်', '1. 送给你。\nGive it to you (as a gift).\nမင်းကို လက်ဆောင်ပေးတာ။\n\n2. 我去送你。\nI will see you off / take you there.\nငါ မင်းကို လိုက်ပို့မယ်။\n\n3. 送礼物。\nGive a gift.\nလက်ဆောင် ပေးတယ်။', 'audio/hsk1/送.mp3', 345),
('hsk1_346', 1, '岁', 'suì', 'နှစ် / အသက်', 'year / age', 'နှစ် / အသက်', '1. 你几岁？\nHow old are you?\nမင်း အသက်ဘယ်လောက်လဲ။\n\n2. 我二十岁。\nI am 20 years old.\nငါ့အသက် ၂၀ ပါ။\n\n3. 三岁的孩子。\nThree-year-old child.\n၃ နှစ်အရွယ် ကလေး။', 'audio/hsk1/岁.mp3', 346),
('hsk1_347', 1, '他', 'tā', 'သူ (ယောက်ျား)', 'he / him', 'သူ (ယောက်ျား)', '1. 他是谁？\nWho is he?\nသူ ဘယ်သူလဲ။\n\n2. 我不认识他。\nI don\'t know him.\nငါ သူ့ကို မသိဘူး။\n\n3. 他很高。\nHe is tall.\nသူ အရပ်ရှည်တယ်။', 'audio/hsk1/他.mp3', 347),
('hsk1_348', 1, '他们', 'tā men', 'သူတို့ (ယောက်ျား/အများ)', 'they (male/mixed)', 'သူတို့ (ယောက်ျား/အများ)', '1. 他们是学生。\nThey are students.\nသူတို့က ကျောင်းသားတွေ ဖြစ်တယ်။\n\n2. 他们在打球。\nThey are playing ball.\nသူတို့ ဘောလုံးကစားနေကြတယ်။\n\n3. 那是他们的书。\nThose are their books.\nအဲဒါ သူတို့ရဲ့ စာအုပ်တွေ။', 'audio/hsk1/他们.mp3', 348),
('hsk1_349', 1, '她', 'tā', 'သူ (မိန်းမ)', 'she / her', 'သူ (မိန်းမ)', '1. 她是我的老师。\nShe is my teacher.\nသူမက ငါ့ဆရာမ ဖြစ်တယ်။\n\n2. 她很漂亮。\nShe is beautiful.\nသူမက လှတယ်။\n\n3. 我喜欢她。\nI like her.\nငါ သူမကို သဘောကျတယ်။', 'audio/hsk1/她.mp3', 349),
('hsk1_350', 1, '她们', 'tā men', 'သူတို့ (မိန်းမ)', 'they (female)', 'သူတို့ (မိန်းမ)', '1. 她们去逛街。\nThey went shopping.\nသူတို့ ဈေးဝယ်ထွက်သွားကြတယ်။\n\n2. 她们是好朋友。\nThey are good friends.\nသူတို့က သူငယ်ချင်းကောင်းတွေပါ။\n\n3. 她们在唱歌。\nThey are singing.\nသူတို့ သီချင်းဆိုနေကြတယ်။', 'audio/hsk1/她们.mp3', 350),
('hsk1_351', 1, '太', 'tài', 'သိပ် / အရမ်း / လွန်း', 'too / very', 'သိပ် / အရမ်း / လွန်း', '1. 太好了。\nGreat / Too good.\nအရမ်းကောင်းတာပဲ။\n\n2. 太贵了。\nToo expensive.\nဈေးကြီးလွန်းတယ်။\n\n3. 不太好。\nNot very good.\nသိပ်မကောင်းဘူး။', 'audio/hsk1/太.mp3', 351),
('hsk1_352', 1, '天', 'tiān', 'နေ့ / မိုးကောင်းကင်', 'day / sky', 'နေ့ / မိုးကောင်းကင်', '1. 今天。\nToday.\nဒီနေ့။\n\n2. 天上。\nIn the sky.\nကောင်းကင်ပေါ်မှာ။\n\n3. 这几天。\nThese few days.\nဒီရက်ပိုင်း။', 'audio/hsk1/天.mp3', 352),
('hsk1_353', 1, '天气', 'tiān qì', 'ရာသီဥတု', 'weather', 'ရာသီဥတု', '1. 天气很好。\nThe weather is good.\nရာသီဥတု ကောင်းတယ်။\n\n2. 明天天气怎么样？\nHow is the weather tomorrow?\nမနက်ဖြန် ရာသီဥတု ဘယ်လိုလဲ။\n\n3. 天气很热。\nThe weather is hot.\nရာသီဥတု ပူတယ်။', 'audio/hsk1/天气.mp3', 353),
('hsk1_354', 1, '条', 'tiáo', 'thin things)\"', '\"(measure word for long', 'thin things)\"', '2. 一条鱼。\nA fish.\nငါးတစ်ကောင်။\n\n3. 这条裤子。\nThis pair of pants.\nဒီဘောင်းဘီရှည်။', 'audio/hsk1/条.mp3', 354),
('hsk1_355', 1, '跳舞', 'tiào wǔ', 'ကသည်', 'dance', 'ကသည်', '1. 她喜欢跳舞。\nShe likes dancing.\nသူမ ကရတာ ကြိုက်တယ်။\n\n2. 我们会跳舞。\nWe can dance.\nငါတို့ ကတတ်တယ်။\n\n3. 去跳舞吧。\nLet\'s go dance.\nကခုန်ကြရအောင်။', 'audio/hsk1/跳舞.mp3', 355),
('hsk1_356', 1, '听', 'tīng', 'နားထောင်သည်', 'listen', 'နားထောင်သည်', '1. 听音乐。\nListen to music.\nသီချင်းနားထောင်တယ်။\n\n2. 听我说。\nListen to me.\nငါပြောတာ နားထောင်။\n\n3. 好听。\nPleasant to hear.\nနားထောင်လို့ ကောင်းတယ်။', 'audio/hsk1/听.mp3', 356),
('hsk1_357', 1, '听到', 'tīng dào', 'ကြားသည်', 'hear', 'ကြားသည်', '1. 你听到了吗？\nDid you hear that?\nမင်း ကြားလိုက်လား။\n\n2. 我没听到。\nI didn\'t hear it.\nငါ မကြားလိုက်ဘူး။\n\n3. 听到声音。\nHeard a sound.\nအသံ ကြားလိုက်တယ်။', 'audio/hsk1/听到.mp3', 357),
('hsk1_358', 1, '听见', 'tīng jiàn', 'ကြားသည်', 'hear (perceive sound)', 'ကြားသည်', '1. 我听见有人说话。\nI hear someone talking.\nလူတစ်ယောက် စကားပြောနေတာ ငါကြားတယ်။\n\n2. 你能听见吗？\nCan you hear?\nမင်း ကြားရလား။\n\n3. 听不见。\nCannot hear.\nမကြားရဘူး။', 'audio/hsk1/听见.mp3', 358),
('hsk1_359', 1, '停', 'tíng', 'ရပ်သည်', 'stop', 'ရပ်သည်', '1. 停车。\nStop the car / Park the car.\nကားရပ်သည်။\n\n2. 雨停了。\nThe rain stopped.\nမိုးတိတ်သွားပြီ။\n\n3. 别停。\nDon\'t stop.\nမရပ်ပါနဲ့။', 'audio/hsk1/停.mp3', 359),
('hsk1_360', 1, '挺', 'tǐng', 'တော်တော် / အတော်လေး', 'very / quite', 'တော်တော် / အတော်လေး', '1. 挺好的。\nQuite good.\nတော်တော်လေး ကောင်းပါတယ်။\n\n2. 挺漂亮的。\nVery beautiful.\nတော်တော်လေး လှတယ်။\n\n3. 今天挺冷。\nToday is quite cold.\nဒီနေ့ တော်တော်အေးတယ်။', 'audio/hsk1/挺.mp3', 360),
('hsk1_361', 1, '同学', 'tóng xué', 'ကျောင်းနေဖက်သူငယ်ချင်း (အတန်းဖော်)', 'classmate', 'ကျောင်းနေဖက်သူငယ်ချင်း (အတန်းဖော်)', '1. 老同学。\nOld classmate.\nကျောင်းနေဖက် သူငယ်ချင်းဟောင်း။\n\n2. 我们是同学。\nWe are classmates.\nငါတို့က ကျောင်းနေဖက်တွေပါ။\n\n3. 男同学。\nMale classmate.\nကျောင်းသား (အတန်းဖော်)။', 'audio/hsk1/同学.mp3', 361),
('hsk1_362', 1, '同意', 'tóng yì', 'သဘောတူသည်', 'agree', 'သဘောတူသည်', '1. 我同意。\nI agree.\nငါ သဘောတူတယ်။\n\n2. 你同意吗？\nDo you agree?\nမင်း သဘောတူလား။\n\n3. 不同意。\nDisagree.\nသဘောမတူဘူး။', 'audio/hsk1/同意.mp3', 362),
('hsk1_363', 1, '头发', 'tóu fa', 'ဆံပင်', 'hair', 'ဆံပင်', '1. 长头发。\nLong hair.\nဆံပင်ရှည်။\n\n2. 剪头发。\nCut hair.\nဆံပင်ညှပ်တယ်။\n\n3. 头发很黑。\nHair is very black.\nဆံပင်က အရမ်းနက်တယ်။', 'audio/hsk1/头发.mp3', 363),
('hsk1_364', 1, '图片', 'tú piàn', 'ပုံ / ဓာတ်ပုံ', 'picture / image', 'ပုံ / ဓာတ်ပုံ', '1. 看图片。\nLook at the picture.\nပုံကို ကြည့်ပါ။\n\n2. 一张图片。\nA picture.\nပုံတစ်ပုံ။\n\n3. 漂亮的图片。\nBeautiful picture.\nလှပတဲ့ ပုံ။', 'audio/hsk1/图片.mp3', 364),
('hsk1_365', 1, '图书馆', 'tú shū guǎn', 'စာကြည့်တိုက်', 'library', 'စာကြည့်တိုက်', '1. 我去图书馆。\nI go to the library.\nငါ စာကြည့်တိုက် သွားတယ်။\n\n2. 图书馆里很安静。\nInside the library is very quiet.\nစာကြည့်တိုက်ထဲမှာ အရမ်းတိတ်ဆိတ်တယ်။\n\n3. 在图书馆看书。\nRead books in the library.\nစာကြည့်တိုက်မှာ စာဖတ်တယ်။', 'audio/hsk1/图书馆.mp3', 365),
('hsk1_366', 1, '推', 'tuī', 'တွန်းသည်', 'push', 'တွန်းသည်', '1. 推门。\nPush the door.\nတံခါးကို တွန်းပါ။\n\n2. 推车。\nPush the cart/car.\nလှည်း/ကားကို တွန်းတယ်။\n\n3. 别推我。\nDon\'t push me.\nငါ့ကို မတွန်းနဲ့။', 'audio/hsk1/推.mp3', 366),
('hsk1_367', 1, '腿', 'tuǐ', 'ခြေထောက် (ပေါင်)', 'leg', 'ခြေထောက် (ပေါင်)', '1. 我的腿很疼。\nMy leg hurts.\nငါ့ခြေထောက် နာနေတယ်။\n\n2. 长腿。\nLong legs.\nခြေတံရှည်။\n\n3. 大腿。\nThigh.\nပေါင်။', 'audio/hsk1/腿.mp3', 367),
('hsk1_368', 1, '外', 'wài', 'အပြင်', 'outside', 'အပြင်', '1. 门外。\nOutside the door.\nတံခါးအပြင်ဘက်။\n\n2. 外人。\nOutsider.\nအပြင်လူ။\n\n3. 外边很冷。\nIt is cold outside.\nအပြင်ဘက်မှာ အရမ်းအေးတယ်။', 'audio/hsk1/外.mp3', 368),
('hsk1_369', 1, '外国', 'wài guó', 'နိုင်ငံခြား', 'foreign country', 'နိုင်ငံခြား', '1. 外国人。\nForeigner.\nနိုင်ငံခြားသား။\n\n2. 去外国。\nGo abroad.\nနိုင်ငံခြား သွားတယ်။\n\n3. 外国朋友。\nForeign friend.\nနိုင်ငံခြားသား သူငယ်ချင်း။', 'audio/hsk1/外国.mp3', 369),
('hsk1_370', 1, '外语', 'wài yǔ', 'နိုင်ငံခြားဘာသာစကား', 'foreign language', 'နိုင်ငံခြားဘာသာစကား', '1. 学外语。\nLearn a foreign language.\nနိုင်ငံခြားဘာသာစကား သင်ယူတယ်။\n\n2. 你会什么外语？\nWhat foreign language can you speak?\nမင်း ဘာနိုင်ငံခြားဘာသာစကား တတ်လဲ။\n\n3. 外语很难。\nForeign languages are difficult.\nနိုင်ငံခြားဘာသာစကားက ခက်တယ်။', 'audio/hsk1/外语.mp3', 370),
('hsk1_371', 1, '玩', 'wán', 'ကစားသည် / လည်သည်', 'play / have fun', 'ကစားသည် / လည်သည်', '1. 去哪儿玩？\nWhere are you going for fun?\nဘယ်သွားလည်မှာလဲ။\n\n2. 好玩。\nFun.\nပျော်ဖို့ကောင်းတယ်။\n\n3. 玩游戏。\nPlay games.\nဂိမ်းဆော့တယ်။', 'audio/hsk1/玩.mp3', 371),
('hsk1_372', 1, '完', 'wán', 'ပြီးသည်', 'finish', 'ပြီးသည်', '1. 做完了。\nDone / Finished doing.\nလုပ်လို့ ပြီးသွားပြီ။\n\n2. 吃完饭。\nFinish eating.\nထမင်းစားပြီး။\n\n3. 没完没了。\nNever-ending\nပြီးကိုမပြီးနိုင်။', 'audio/hsk1/完.mp3', 372),
('hsk1_373', 1, '晚', 'wǎn', 'နောက်ကျသည် / ည', 'late / night', 'နောက်ကျသည် / ည', '1. 太晚了。\nIt is too late.\nအရမ်းနောက်ကျနေပြီ။\n\n2. 晚安。\nGood night.\nဂုတ်နိုက်ပါ\n\n3. 我不喜欢晚睡。\nI don\'t like sleeping late.\nငါ ညဉ့်နက်မှ အိပ်ရတာ မကြိုက်ဘူး။', 'audio/hsk1/晚.mp3', 373),
('hsk1_374', 1, '晚上', 'wǎn shang', 'ညနေ / ည', 'evening / night', 'ညနေ / ည', '1. 今天晚上。\nTonight.\nဒီနေ့ည။\n\n2. 晚上见。\nSee you in the evening.\nညမှ တွေ့မယ်။\n\n3. 晚上很冷。\nIt is cold at night.\nညဘက်ကျတော့ အေးတယ်။', 'audio/hsk1/晚上.mp3', 374),
('hsk1_375', 1, '碗', 'wǎn', 'ပန်းကန်လုံး', 'bowl', 'ပန်းကန်လုံး', '1. 一个碗。\nA bowl.\nပန်းကန်လုံး တစ်လုံး။\n\n2. 洗碗。\nWash the bowl.\nပန်းကန် ဆေးတယ်။\n\n3. 吃一碗饭。\nEat a bowl of rice.\nထမင်း တစ်ပန်းကန် စားတယ်။', 'audio/hsk1/碗.mp3', 375),
('hsk1_376', 1, '万', 'wàn', 'တစ်သောင်း', 'ten thousand', 'တစ်သောင်း', '1. 一万。\nTen thousand.\nတစ်သောင်း။\n\n2. 好多钱，有一万吧？\n\"So much money, is it ten thousand?\"\nပိုက်ဆံတွေ အများကြီးပဲ၊ တစ်သောင်းလောက်ရှိမယ်ထင်တယ်\n\n3. 万一。\nIn case / If by any chance.\nအကယ်၍ (မတော်တဆ)။', 'audio/hsk1/万.mp3', 376),
('hsk1_377', 1, '往', 'wǎng', 'ဆီသို့ / ဘက်သို့', 'towards / to', 'ဆီသို့ / ဘက်သို့', '1. 往左走。\nGo towards the left.\nဘယ်ဘက်ကို သွားပါ။\n\n2. 往哪儿走？\nWhich way to go?\nဘယ်ဘက်ကို သွားရမလဲ။\n\n3. 往前看。\nLook forward.\nအရှေ့ကို ကြည့်ပါ။', 'audio/hsk1/往.mp3', 377),
('hsk1_378', 1, '忘记', 'wàng jì', 'မေ့သည်', 'forget', 'မေ့သည်', '1. 别忘记。\nDon\'t forget.\nမမေ့ပါနဲ့။\n\n2. 我忘记了。\nI forgot.\nငါ မေ့သွားတယ်။\n\n3. 我忘记带钱了。\nI forgot to bring money.\nငါ ပိုက်ဆံယူလာဖို့ မေ့သွားတယ်။', 'audio/hsk1/忘记.mp3', 378),
('hsk1_379', 1, '喂', 'wéi / wèi', 'ဟလို / အစာကျွေးသည်', 'hello (on phone) / to feed', 'ဟလို / အစာကျွေးသည်', '1. 喂，你好。\n\"Hello, how are you?\"\nဟလို၊ မင်္ဂလာပါ။\n\n2. 喂，是谁？\n\"Hello, who is this?\"\nဟလို၊ ဘယ်သူလဲ။\n\n3. 喂狗。\nFeed the dog.\nခွေး အစာကျွေးတယ်။', 'audio/hsk1/喂.mp3', 379),
('hsk1_380', 1, '位', 'wèi', 'ဦး / ယောက် (ယဉ်ကျေးသောစကားလုံး)', '(polite measure word for people)', 'ဦး / ယောက် (ယဉ်ကျေးသောစကားလုံး)', '1. 一位老师。\nA teacher.\nဆရာ တစ်ဦး။\n\n2. 几位？\nHow many people? (Polite)\nလူ ဘယ်နှယောက်လဲခင်ဗျ။\n\n3. 这就是那位医生。\nThis is that doctor.\nဒါက ဟိုဆရာဝန်ကြီးပါ။', 'audio/hsk1/位.mp3', 380),
('hsk1_381', 1, '为什么', 'wèi shén me', 'ဘာကြောင့် / ဘာလို့', 'why', 'ဘာကြောင့် / ဘာလို့', '1. 为什么不去？\nWhy not go?\nဘာလို့ မသွားတာလဲ။\n\n2. 这是为什么？\nWhy is this?\nဒါ ဘာကြောင့်လဲ။\n\n3. 你为什么笑？\nWhy are you laughing?\nမင်း ဘာလို့ ရယ်နေတာလဲ။', 'audio/hsk1/为什么.mp3', 381),
('hsk1_382', 1, '问', 'wèn', 'မေးသည်', 'ask', 'မေးသည်', '1. 问老师。\nAsk the teacher.\nဆရာ့ကို မေးလိုက်ပါ။\n\n2. 我问你一个问题。\nI ask you a question.\nငါ မင်းကို မေးခွန်းတစ်ခု မေးမယ်။\n\n3. 不懂就问。\n\"If you don\'t understand, ask.\"\nနားမလည်ရင် မေးပါ။', 'audio/hsk1/问.mp3', 382),
('hsk1_383', 1, '问题', 'wèn tí', 'မေးခွန်း / ပြဿနာ', 'question / problem', 'မေးခွန်း / ပြဿနာ', '1. 没问题。\nNo problem.\nပြဿနာ မရှိပါဘူး။\n\n2. 回答问题。\nAnswer the question.\nမေးခွန်း ဖြေပါ။\n\n3. 这是大问题。\nThis is a big problem.\nဒါက ပြဿနာကြီးပဲ။', 'audio/hsk1/问题.mp3', 383),
('hsk1_384', 1, '我', 'wǒ', 'ကျွန်တော် / ကျွန်မ / ငါ', 'I / me', 'ကျွန်တော် / ကျွန်မ / ငါ', '1. 我是一个学生。\nI am a student.\nငါက ကျောင်းသားတစ်ယောက် ဖြစ်တယ်။\n\n2. 那是我的。\nThat is mine.\nအဲဒါ ငါ့ဟာ။\n\n3. 我不去。\nI am not going.\nငါ မသွားဘူး။', 'audio/hsk1/我.mp3', 384),
('hsk1_385', 1, '我们', 'wǒ men', 'ကျွန်တော်တို့ / ငါတို့', 'we / us', 'ကျွန်တော်တို့ / ငါတို့', '1. 我们回家吧。\nLet\'s go home.\nငါတို့ အိမ်ပြန်ကြရအောင်။\n\n2. 这是我们的学校。\nThis is our school.\nဒါ ငါတို့ကျောင်း။\n\n3. 我们都是中国人。\nWe are all Chinese.\nငါတို့အားလုံးက တရုတ်လူမျိုးတွေပါ။', 'audio/hsk1/我们.mp3', 385),
('hsk1_386', 1, '五', 'wǔ', 'ငါး (ဂဏန်း)', 'five', 'ငါး (ဂဏန်း)', '1. 五个。\nFive items.\nငါးခု။\n\n2. 五月。\nMay.\nမေလ။\n\n3. 五百。\nFive hundred.\nငါးရာ။', 'audio/hsk1/五.mp3', 386),
('hsk1_387', 1, '午饭', 'wǔ fàn', 'နေ့လယ်စာ', 'lunch', 'နေ့လယ်စာ', '1. 吃午饭。\nEat lunch.\nနေ့လယ်စာ စားတယ်။\n\n2. 午饭吃什么？\nWhat to eat for lunch?\nနေ့လယ်စာ ဘာစားမလဲ။\n\n3. 做午饭。\nMake lunch.\nနေ့လယ်စာ ချက်တယ်။', 'audio/hsk1/午饭.mp3', 387),
('hsk1_388', 1, '西', 'xī', 'အနောက် (အရပ်မျက်နှာ)', 'west', 'အနောက် (အရပ်မျက်နှာ)', '1. 往西走。\nGo west.\nအနောက်ဘက်ကို သွားပါ။\n\n2. 西边有山\nThere are mountains on the west side.\nအနောက်ဘက်မှာ တောင်တွေ ရှိတယ်။\n\n3. 他在西边。\nHe is on the west side.\nသူ အနောက်ဘက်မှာ ရှိတယ်။', 'audio/hsk1/西.mp3', 388),
('hsk1_389', 1, '西瓜', 'xī guā', 'ဖရဲသီး', 'watermelon', 'ဖရဲသီး', '1. 吃西瓜。\nEat watermelon.\nဖရဲသီး စားတယ်။\n\n2. 这西瓜很甜。\nThis watermelon is very sweet.\nဒီဖရဲသီးက အရမ်းချိုတယ်။\n\n3. 买一个西瓜。\nBuy a watermelon.\nဖရဲသီးတစ်လုံး ဝယ်တယ်။', 'audio/hsk1/西瓜.mp3', 389),
('hsk1_390', 1, '希望', 'xī wàng', 'မျှော်လင့်သည်', 'hope', 'မျှော်လင့်သည်', '1. 我希望你快乐。\nI hope you are happy.\nမင်း ပျော်ရွှင်ပါစေလို့ ငါမျှော်လင့်ပါတယ်။\n\n2. 有希望。\nThere is hope.\nမျှော်လင့်ချက် ရှိတယ်။\n\n3. 那是我的希望。\nThat is my hope.\nအဲဒါ ငါ့ရဲ့ မျှော်လင့်ချက်ပဲ။', 'audio/hsk1/希望.mp3', 390),
('hsk1_391', 1, '习惯', 'xí guàn', 'အကျင့် / အသားကျသည်', 'habit / be used to', 'အကျင့် / အသားကျသည်', '1. 好习惯。\nGood habit.\nအကျင့်ကောင်း။\n\n2. 我不习惯这里。\nI am not used to it here.\nငါ ဒီနေရာနဲ့ အသားမကျသေးဘူး။\n\n3. 这是我的习惯。\nThis is my habit.\nဒါ ငါ့အကျင့်ပါ။', 'audio/hsk1/习惯.mp3', 391),
('hsk1_392', 1, '洗', 'xǐ', 'ဆေးသည် / လျှော်သည်', 'wash', 'ဆေးသည် / လျှော်သည်', '1. 洗手。\nWash hands.\nလက်ဆေးတယ်။\n\n2. 洗衣服。\nWash clothes.\nအဝတ်လျှော်တယ်။\n\n3. 洗水果。\nWash fruit.\nသစ်သီးဆေးတယ်။', 'audio/hsk1/洗.mp3', 392),
('hsk1_393', 1, '洗手间', 'xǐ shǒu jiān', 'အိမ်သာ / သန့်စင်ခန်း', 'restroom / toilet', 'အိမ်သာ / သန့်စင်ခန်း', '1. 去洗手间。\nGo to the restroom.\nအိမ်သာ သွားတယ်။\n\n2. 洗手间在哪儿？\nWhere is the restroom?\nအိမ်သာ ဘယ်မှာလဲ။\n\n3. 我要上洗手间。\nI want to go to the restroom.\nငါ အိမ်သာတက်ချင်တယ်။', 'audio/hsk1/洗手间.mp3', 393),
('hsk1_394', 1, '洗澡', 'xǐ zǎo', 'ရေချိုးသည်', 'take a bath/shower', 'ရေချိုးသည်', '1. 我在洗澡。\nI am taking a shower.\nငါ ရေချိုးနေတယ်။\n\n2. 去洗澡。\nGo take a shower.\nရေသွားချိုး။\n\n3. 洗个澡。\nTake a bath.\nရေချိုးလိုက်တယ်။', 'audio/hsk1/洗澡.mp3', 394),
('hsk1_395', 1, '喜欢', 'xǐ huan', 'ကြိုက်သည် / နှစ်သက်သည်', 'like', 'ကြိုက်သည် / နှစ်သက်သည်', '1. 我喜欢你。\nI like you.\nငါ မင်းကို သဘောကျတယ်။\n\n2. 你喜欢吃什么？\nWhat do you like to eat?\nမင်း ဘာစားရတာ ကြိုက်လဲ။\n\n3. 最喜欢。\nLike the most / Favorite.\nအကြိုက်ဆုံး။', 'audio/hsk1/喜欢.mp3', 395),
('hsk1_396', 1, '下', 'xià', 'အောက် / ဆင်းသည် / ကျသည်', 'down / below / get off', 'အောက် / ဆင်းသည် / ကျသည်', '1. 下来。\nCome down.\nဆင်းလာခဲ့။\n\n2. 桌子下边。\nUnder the table.\nစားပွဲခုံ အောက်ဘက်။\n\n3. 往下边看。\nLook down.\nအောက်ဘက်ကို ကြည့်ပါ။', 'audio/hsk1/下.mp3', 396),
('hsk1_397', 1, '下班', 'xià bān', 'အလုပ်ဆင်းသည်', 'get off work', 'အလုပ်ဆင်းသည်', '1. 几点下班？\nWhat time do you get off work?\nဘယ်အချိန် အလုပ်ဆင်းမှာလဲ။\n\n2. 我要下班了。\nI am about to get off work.\nငါ အလုပ်ဆင်းတော့မယ်။\n\n3. 下班回家。\nGo home after work.\nအလုပ်ဆင်းပြီး အိမ်ပြန်တယ်။', 'audio/hsk1/下班.mp3', 397),
('hsk1_398', 1, '下车', 'xià chē', 'ကားပေါ်မှဆင်းသည်', 'get off (a vehicle)', 'ကားပေါ်မှဆင်းသည်', '1. 请下车。\nPlease get off the car.\nကျေးဇူးပြုပြီး ကားပေါ်က ဆင်းပေးပါ။\n\n2. 在这里下车。\nGet off here.\nဒီနားမှာ ဆင်းမယ်။\n\n3. 还没下车。\nHaven\'t got off yet.\nကားပေါ်က မဆင်းရသေးဘူး။', 'audio/hsk1/下车.mp3', 398),
('hsk1_399', 1, '下次', 'xià cì', 'နောက်တစ်ခါ / နောက်တစ်ကြိမ်', 'next time', 'နောက်တစ်ခါ / နောက်တစ်ကြိမ်', '1. 下次见。\nSee you next time.\nနောက်တစ်ခါမှ တွေ့မယ်။\n\n2. 下次吧。\nMaybe next time.\nနောက်တစ်ခေါက်မှပဲ လုပ်ကြတာပေါ့ (ငြင်းသည့်သဘော)။\n\n3. 还有下次。\nThere is still a next time.\nနောက်တစ်ခေါက် ရှိပါသေးတယ်။', 'audio/hsk1/下次.mp3', 399),
('hsk1_400', 1, '下课', 'xià kè', 'အတန်းပြီးသည် / ကျောင်းဆင်းသည်', 'class is over', 'အတန်းပြီးသည် / ကျောင်းဆင်းသည်', '1. 我们下课了。\nWe finished class.\nငါတို့ အတန်းပြီးပြီ။\n\n2. 下课休息。\nRest after class.\nအတန်းပြီးတော့ အနားယူတယ်။\n\n3. 什么时候下课？\nWhen does the class end?\nဘယ်အချိန် အတန်းပြီးမှာလဲ။', 'audio/hsk1/下课.mp3', 400),
('hsk1_401', 1, '下午', 'xià wǔ', 'နေ့လယ် (မွန်းလွဲပိုင်း)', 'afternoon', 'နေ့လယ် (မွန်းလွဲပိုင်း)', '1. 今天下午。\nThis afternoon.\nဒီနေ့ နေ့လယ်။\n\n2. 下午三点。\n3:00 PM\nနေ့လယ် ၃ နာရီ။\n\n3. 下午好。\nGood afternoon.\nမင်္ဂလာ နေ့လယ်ခင်းပါ။', 'audio/hsk1/下午.mp3', 401),
('hsk1_402', 1, '下雨', 'xià yǔ', 'မိုးရွာသည်', 'rain', 'မိုးရွာသည်', '1. 正在下雨。\nIt is raining.\nမိုးရွာနေတယ်။\n\n2. 明天会下雨。\nIt will rain tomorrow.\nမနက်ဖြန် မိုးရွာလိမ့်မယ်။\n\n3. 下大雨。\nRain heavily.\nမိုးသည်းထန်စွာ ရွာတယ်။', 'audio/hsk1/下雨.mp3', 402),
('hsk1_403', 1, '先', 'xiān', 'အရင် / ဦးစွာ', 'first', 'အရင် / ဦးစွာ', '1. 你先走。\nYou go first.\nမင်း အရင်သွား။\n\n2. 我先走了。\nI am leaving first.\nငါ အရင်ပြန်နှင့်တော့မယ်။\n\n3. 先做这个。\nDo this first.\nဒါ အရင်လုပ်ပါ။', 'audio/hsk1/先.mp3', 403),
('hsk1_404', 1, '先生', 'xiān sheng', 'ရှင် / မစ္စတာ / ခင်ပွန်း', 'Mr. / Sir / Husband', 'ရှင် / မစ္စတာ / ခင်ပွန်း', '1. 李先生。\nMr. Li.\nမစ္စတာ လီ (ဦးလီ)။\n\n2. 这位先生。\nThis gentleman.\nဒီ အမျိုးသား။\n\n3. 这位是我先生。\nThis is my husband.\nဒါက ငါ့ခင်ပွန်းပါ။', 'audio/hsk1/先生.mp3', 404),
('hsk1_405', 1, '现在', 'xiàn zài', 'အခု', 'now', 'အခု', '1. 现在几点？\nWhat time is it now?\nအခု ဘယ်နှနာရီ ရှိပြီလဲ။\n\n2. 我现在回家。\nI am going home now.\nငါ အခု အိမ်ပြန်တော့မယ်။\n\n3. 从现在开始。\nStart from now.\nအခုကစပြီး။', 'audio/hsk1/现在.mp3', 405),
('hsk1_406', 1, '香蕉', 'xiāng jiāo', 'ငှက်ပျောသီး', 'banana', 'ငှက်ပျောသီး', '1. 吃香蕉。\nEat a banana.\nငှက်ပျောသီး စားတယ်။\n\n2. 买香蕉。\nBuy bananas.\nငှက်ပျောသီး ဝယ်တယ်။\n\n3. 香蕉很甜。\nThe banana is sweet.\nငှက်ပျောသီးက ချိုတယ်။', 'audio/hsk1/香蕉.mp3', 406),
('hsk1_407', 1, '想', 'xiǎng', 'စဉ်းစားသည် / ချင်သည် / လွမ်းသည်', 'think / want / miss', 'စဉ်းစားသည် / ချင်သည် / လွမ်းသည်', '1. 我想去中国。\nI want to go to China.\nငါ တရုတ်ပြည် သွားချင်တယ်။\n\n2. 让我想想。\nLet me think.\nငါ စဉ်းစားပါရစေဦး။\n\n3. 我想你。\nI miss you.\nငါ မင်းကို လွမ်းတယ်။', 'audio/hsk1/想.mp3', 407),
('hsk1_408', 1, '小', 'xiǎo', 'သေးငယ်သော', 'small', 'သေးငယ်သော', '1. 太小了。\nToo small.\nအရမ်း သေးလွန်းတယ်။\n\n2. 小苹果。\nSmall apple.\nပန်းသီး အသေးလေး။\n\n3. 大和小。\nBig and small.\nကြီးတာနဲ့ သေးတာ။', 'audio/hsk1/小.mp3', 408),
('hsk1_409', 1, '小姐', 'xiǎo jiě', 'မိန်းကလေး / မ (အမျိုးသမီးကို ခေါ်သည့်အခါ)', 'Miss / young lady', 'မိန်းကလေး / မ (အမျိုးသမီးကို ခေါ်သည့်အခါ)', '1. 王小姐。\nMiss Wang.\nမ ဝမ်။\n\n2. 这位小姐。\nThis young lady.\nဒီ မိန်းကလေး။\n\n3. 小姐，你好。\n\"Hello, Miss.\"\nမင်္ဂလာပါ ခင်ဗျာ (မိန်းကလေးကို နှုတ်ဆက်ခြင်း)။', 'audio/hsk1/小姐.mp3', 409),
('hsk1_410', 1, '小时', 'xiǎo shí', 'နာရီ (ကြာချိန်)', 'hour', 'နာရီ (ကြာချိန်)', '1. 一个小时。\nOne hour.\nတစ်နာရီ။\n\n2. 两个小时。\nTwo hours.\nနှစ်နာရီ (ကြာချိန်)။\n\n3. 半个小时。\nHalf an hour.\nနာရီဝက်။', 'audio/hsk1/小时.mp3', 410),
('hsk1_411', 1, '小朋友', 'xiǎo péng yǒu', 'ကလေးလေး', 'child / kid', 'ကလေးလေး', '1. 可爱的小朋友。\nCute child.\nချစ်စရာကောင်းတဲ့ ကလေးလေး။\n\n2. 这里有很多小朋友。\nThere are many children here.\nဒီမှာ ကလေးတွေ အများကြီးရှိတယ်။\n\n3. 小朋友，你几岁？\n\"Little friend, how old are you?\"\nကလေးလေး၊ မင်း အသက်ဘယ်လောက်ရှိပြီလဲ။', 'audio/hsk1/小朋友.mp3', 411),
('hsk1_412', 1, '小学生', 'xiǎo xué shēng', 'မူလတန်းကျောင်းသား', 'primary school student', 'မူလတန်းကျောင်းသား', '1. 我是一个小学生。\nI am a primary school student.\nကျွန်တော်က မူလတန်းကျောင်းသား တစ်ယောက်ပါ။\n\n2. 小学生书包。\nPrimary school student\'s bag.\nမူလတန်းကျောင်းသား လွယ်အိတ်။\n\n3. 许多小学生。\nMany primary school students.\nမူလတန်းကျောင်းသား အများအပြား။', 'audio/hsk1/小学生.mp3', 412),
('hsk1_413', 1, '笑', 'xiào', 'ရယ်သည် / ပြုံးသည်', 'laugh / smile', 'ရယ်သည် / ပြုံးသည်', '1. 大笑。\nLaugh loudly.\nအကျယ်ကြီး ရယ်တယ်။\n\n2. 不要笑。\nDon\'t laugh.\nမရယ်ပါနဲ့။\n\n3. 他对我笑。\nHe smiled at me.\nသူ ငါ့ကို ပြုံးပြတယ်။', 'audio/hsk1/笑.mp3', 413),
('hsk1_414', 1, '写', 'xiě', 'ရေးသည်', 'write', 'ရေးသည်', '1. 写字。\nWrite characters/words.\nစာရေးတယ်။\n\n2. 写名字。\nWrite name.\nနာမည် ရေးတယ်။\n\n3. 你会写吗？\nCan you write it?\nမင်း ရေးတတ်လား။', 'audio/hsk1/写.mp3', 414),
('hsk1_415', 1, '谢谢', 'xiè xie', 'ကျေးဇူးတင်ပါတယ်', 'thank you', 'ကျေးဇူးတင်ပါတယ်', '1. 谢谢你。\nThank you.\nမင်းကို ကျေးဇူးတင်ပါတယ်။\n\n2. 谢谢你的帮助。\nThanks for your help.\nကူညီမှုအတွက်ကျေးဇူးပါ။\n\n3. 说谢谢。\nSay thank you.\nကျေးဇူးတင်တယ်လို့ ပြောပါ။', 'audio/hsk1/谢谢.mp3', 415),
('hsk1_416', 1, '新', 'xīn', 'သစ်သော / အသစ်', 'new', 'သစ်သော / အသစ်', '1. 新年。\nNew Year.\nနှစ်သစ်။\n\n2. 这是新的。\nThis is new.\nဒါ အသစ်ပါ။\n\n3. 买新衣服。\nBuy new clothes.\nအဝတ်အစားအသစ် ဝယ်တယ်။', 'audio/hsk1/新.mp3', 416),
('hsk1_417', 1, '新年', 'xīn nián', 'နှစ်သစ်ကူး', 'New Year', 'နှစ်သစ်ကူး', '1. 新年快乐。\nHappy New Year.\nနှစ်သစ်မှာ ပျော်ရွှင်ပါစေ။\n\n2. 过新年。\nCelebrate New Year.\nနှစ်သစ်ကူးပွဲ ကျင်းပတယ်။\n\n3. 新年好。\nHappy New Year (Greeting).\nမင်္ဂလာနှစ်သစ်ပါ။', 'audio/hsk1/新年.mp3', 417),
('hsk1_418', 1, '星期', 'xīng qī', 'ရက်သတ္တပတ် / အပတ်', 'week', 'ရက်သတ္တပတ် / အပတ်', '1. 一个星期。\nOne week.\nတစ်ပတ်။\n\n2. 星期几？\nWhat day of the week?\nအပတ်စဉ် ဘယ်နေ့လဲ။\n\n3. 上个星期。\nLast week.\nပြီးခဲ့တဲ့အပတ်။', 'audio/hsk1/星期.mp3', 418),
('hsk1_419', 1, '星期日', 'xīng qī rì', 'တနင်္ဂနွေနေ့', 'Sunday', 'တနင်္ဂနွေနေ့', '1. 今天是星期日。\nToday is Sunday.\nဒီနေ့က တနင်္ဂနွေနေ့ ဖြစ်တယ်။\n\n2. 星期日休息。\nRest on Sunday.\nတနင်္ဂနွေနေ့ နားတယ်။\n\n3. 每个星期日。\nEvery Sunday.\nတနင်္ဂနွေနေ့တိုင်း။', 'audio/hsk1/星期日.mp3', 419),
('hsk1_420', 1, '星期天', 'xīng qī tiān', 'တနင်္ဂနွေနေ့', 'Sunday (Informal)', 'တနင်္ဂနွေနေ့', '1. 星期天去玩。\nGo play on Sunday.\nတနင်္ဂနွေနေ့ အလည်သွားမယ်။\n\n2. 星期天见。\nSee you on Sunday.\nတနင်္ဂနွေနေ့မှ တွေ့မယ်။\n\n3. 这个星期天。\nThis Sunday.\nဒီ တနင်္ဂနွေနေ့။', 'audio/hsk1/星期天.mp3', 420),
('hsk1_421', 1, '行', 'xíng', 'ရပါတယ် / အဆင်ပြေပါတယ် / သွားသည်', 'okay / all right / walk', 'ရပါတယ် / အဆင်ပြေပါတယ် / သွားသည်', '1. 行不行？\nIs it okay?\nရလား / အဆင်ပြေလား။\n\n2. 行，没问题。\n\"Okay, no problem.\"\nရပါတယ်၊ ပြဿနာမရှိပါဘူး။\n\n3. 我不行。\nI can\'t do it / I\'m not okay.\nငါ မလုပ်နိုင်ဘူး / ငါ အဆင်မပြေဘူး။', 'audio/hsk1/行.mp3', 421),
('hsk1_422', 1, '休息', 'xiū xi', 'နားသည် / အနားယူသည်', 'rest', 'နားသည် / အနားယူသည်', '1. 好好休息。\nRest well.\nကောင်းကောင်း အနားယူပါ။\n\n2. 休息一下。\nRest a little bit.\nခဏလောက် နားလိုက်ပါ။\n\n3. 中午休息。\nRest at noon.\nနေ့လယ်ဘက် နားတယ်။', 'audio/hsk1/休息.mp3', 422),
('hsk1_423', 1, '学', 'xué', 'သင်သည် / လေ့လာသည်', 'learn / study', 'သင်သည် / လေ့လာသည်', '1. 学汉语。\nLearn Chinese.\nတရုတ်စာလေ့လာတယ်။\n\n2. 好好学。\nStudy hard.\nကြိုးကြိုးစားစား သင်ယူပါ။\n\n3. 你在学什么？\nWhat are you learning?\nမင်း ဘာသင်ယူနေတာလဲ။', 'audio/hsk1/学.mp3', 423),
('hsk1_424', 1, '学生', 'xué sheng', 'ကျောင်းသား', 'student', 'ကျောင်းသား', '1. 我是学生。\nI am a student.\nကျွန်တော်က ကျောင်းသားပါ။\n\n2. 好学生。\nGood student.\nကျောင်းသားကောင်း။\n\n3. 学生证。\nStudent ID card.\nကျောင်းသားကဒ်။', 'audio/hsk1/学生.mp3', 424),
('hsk1_425', 1, '学习', 'xué xí', 'စာလေ့လာသည် / သင်ယူသည်', 'study / learn', 'စာလေ့လာသည် / သင်ယူသည်', '1. 努力学习。\nStudy hard.\nကြိုးစားပမ်းစား စာလေ့လာပါ။\n\n2. 学习英语。\nStudy English.\nအင်္ဂလိပ်စာ လေ့လာတယ်။\n\n3. 爱学习。\nLove to learn.\nစာလေ့လာရတာ နှစ်သက်တယ်။', 'audio/hsk1/学习.mp3', 425),
('hsk1_426', 1, '学校', 'xué xiào', 'ကျောင်း', 'school', 'ကျောင်း', '1. 去学校。\nGo to school.\nကျောင်းသွားတယ်။\n\n2. 学校很大。\nThe school is big.\nကျောင်းက ကြီးတယ်။\n\n3. 我们在学校。\nWe are at school.\nငါတို့ ကျောင်းမှာ ရှိတယ်။', 'audio/hsk1/学校.mp3', 426),
('hsk1_427', 1, '学院', 'xué yuàn', 'ကောလိပ် / တက္ကသိုလ်ပရဝုဏ်', 'college / institute', 'ကောလိပ် / တက္ကသိုလ်ပရဝုဏ်', '1. 外语学院。\nForeign Language Institute.\nနိုင်ငံခြားဘာသာ တက္ကသိုလ်။\n\n2. 他在这个学院。\nHe is at this college.\nသူ ဒီကောလိပ်မှာ တက်နေတယ်။\n\n3. 商学院。\nBusiness School.\nစီးပွားရေး တက္ကသိုလ်။', 'audio/hsk1/学院.mp3', 427),
('hsk1_428', 1, '雪', 'xuě', 'နှင်း', 'snow', 'နှင်း', '1. 下雪了。\nIt\'s snowing.\nနှင်းကျနေပြီ။\n\n2. 白雪。\nWhite snow.\nနှင်းဖြူ။\n\n3. 玩雪。\nPlay in the snow.\nနှင်းဆော့တယ်။', 'audio/hsk1/雪.mp3', 428),
('hsk1_429', 1, '呀', 'ya', 'ဗျ / ရှင် (အာမေဋိတ်)', '(particle for surprise/emphasis)', 'ဗျ / ရှင် (အာမေဋိတ်)', '1. 是谁呀？\nWho is it?\nဘယ်သူလဲဟေ့။\n\n2. 好快呀！\nSo fast!\nမြန်လိုက်တာနော်။\n\n3. 对呀。\nThat\'s right.\nဟုတ်တာပေါ့။', 'audio/hsk1/呀.mp3', 429),
('hsk1_430', 1, '颜色', 'yán sè', 'အရောင်', 'color', 'အရောင်', '1. 什么颜色？\nWhat color?\nဘာအရောင်လဲ။\n\n2. 好看的颜色。\nNice color.\nလှပတဲ့ အရောင်။\n\n3. 我不喜欢这个颜色。\nI don\'t like this color.\nငါ ဒီအရောင်ကို မကြိုက်ဘူး။', 'audio/hsk1/颜色.mp3', 430),
('hsk1_431', 1, '眼睛', 'yǎn jing', 'မျက်လုံး', 'eye', 'မျက်လုံး', '1. 大眼睛。\nBig eyes.\nမျက်လုံးကြီးကြီး။\n\n2. 我的眼睛疼。\nMy eyes hurt.\nငါ့မျက်လုံး နာတယ်။\n\n3. 闭上眼睛。\nClose your eyes.\nမျက်လုံး မှိတ်လိုက်ပါ။', 'audio/hsk1/眼睛.mp3', 431);
INSERT INTO `vocabulary` (`vocab_id`, `hsk_level`, `hanzi`, `pinyin`, `meaning`, `meaning_en`, `meaning_my`, `example`, `audio_asset`, `sort_order`) VALUES
('hsk1_432', 1, '眼镜', 'yǎn jìng', 'မျက်မှန်', 'glasses', 'မျက်မှန်', '1. 戴眼镜。\nWear glasses.\nမျက်မှန် တပ်တယ်။\n\n2. 我的眼镜在哪儿？\nWhere are my glasses?\nငါ့မျက်မှန် ဘယ်မှာလဲ။\n\n3. 买一副眼镜。\nBuy a pair of glasses.\nမျက်မှန်တစ်လက် ဝယ်တယ်။', 'audio/hsk1/眼镜.mp3', 432),
('hsk1_433', 1, '羊肉', 'yáng ròu', 'ဆိတ်သား', 'mutton', 'ဆိတ်သား', '1. 我不吃羊肉。\nI don\'t eat mutton.\nငါ ဆိတ်သား မစားဘူး။\n\n2. 羊肉很好吃。\nMutton is delicious.\nဆိတ်သားက အရသာရှိတယ်။\n\n3. 买两斤羊肉。\nBuy one kilogram of mutton.\nဆိတ်သား တစ်ကီလို ဝယ်တယ်။', 'audio/hsk1/羊肉.mp3', 433),
('hsk1_434', 1, '药', 'yào', 'ဆေး', 'medicine', 'ဆေး', '1. 吃药。\nTake medicine.\nဆေးသောက်တယ်။\n\n2. 这是什么药？\nWhat medicine is this?\nဒါ ဘာဆေးလဲ။\n\n3. 药店。\nPharmacy / Drugstore.\nဆေးဆိုင်။', 'audio/hsk1/药.mp3', 434),
('hsk1_435', 1, '要', 'yào', 'လိုချင်သည် / လိုအပ်သည် / မည် (အနာဂတ်)', 'want / need / will', 'လိုချင်သည် / လိုအပ်သည် / မည် (အနာဂတ်)', '1. 我要喝水。\nI want to drink water.\nငါ ရေသောက်ချင်တယ်။\n\n2. 要下雨了。\nIt is going to rain.\nမိုးရွာတော့မယ်။\n\n3. 你要什么？\nWhat do you want?\nမင်း ဘာလိုချင်လဲ။', 'audio/hsk1/要.mp3', 435),
('hsk1_436', 1, '爷爷', 'yé ye', 'အဘိုး (အဖေဘက်မှ)', 'grandfather (paternal)', 'အဘိုး (အဖေဘက်မှ)', '1. 这是我爷爷。\nThis is my grandfather.\nဒါ ငါ့အဘိုးပါ။\n\n2. 爷爷七十岁了。\nGrandpa is 70 years old.\nအဘိုးက အသက် ၇၀ ရှိပြီ။\n\n3. 爷爷和奶奶。\nGrandpa and Grandma.\nအဘိုးနဲ့ အဘွား။', 'audio/hsk1/爷爷.mp3', 436),
('hsk1_437', 1, '也', 'yě', 'လည်း / လည်းပဲ', 'also / too', 'လည်း / လည်းပဲ', '1. 我也是。\nMe too.\nငါလည်း အတူတူပဲ။\n\n2. 他也去。\nHe is going too.\nသူလည်း သွားမယ်။\n\n3. 我也不知道。\nI don\'t know either.\nငါလည်း မသိဘူး။', 'audio/hsk1/也.mp3', 437),
('hsk1_438', 1, '一', 'yī', 'တစ် (ဂဏန်း)', 'one', 'တစ် (ဂဏန်း)', '1. 一个。\nOne item.\nတစ်ခု။\n\n2. 第一。\nFirst / Number one.\nပထမ။\n\n3. 这儿有一本书。\nThere is a book here.\nဒီမှာ စာအုပ်တစ်အုပ် ရှိတယ်။', 'audio/hsk1/一.mp3', 438),
('hsk1_439', 1, '衣服', 'yī fu', 'အဝတ်အစား', 'clothes', 'အဝတ်အစား', '1. 穿衣服。\nWear clothes.\nအဝတ် ဝတ်တယ်။\n\n2. 洗衣服。\nWash clothes.\nအဝတ် လျှော်တယ်။\n\n3. 这件衣服很漂亮。\nThese clothes are beautiful.\nဒီအဝတ်အစားက လှတယ်။', 'audio/hsk1/衣服.mp3', 439),
('hsk1_440', 1, '医生', 'yī shēng', 'ဆရာဝန်', 'doctor', 'ဆရာဝန်', '1. 去看医生。\nGo see a doctor.\nဆရာဝန် သွားပြတယ်။\n\n2. 他是医生。\nHe is a doctor.\nသူက ဆရာဝန် ဖြစ်တယ်။\n\n3. 听医生的话。\nListen to the doctor.\nဆရာဝန်စကား နားထောင်ပါ။', 'audio/hsk1/医生.mp3', 440),
('hsk1_441', 1, '医院', 'yī yuàn', 'ဆေးရုံ', 'hospital', 'ဆေးရုံ', '1. 去医院。\nGo to the hospital.\nဆေးရုံ သွားတယ်။\n\n2. 住医院。\nBe hospitalized.\nဆေးရုံ တက်တယ်။\n\n3. 医院很大。\nThe hospital is big.\nဆေးရုံက ကြီးတယ်။', 'audio/hsk1/医院.mp3', 441),
('hsk1_442', 1, '一定', 'yí dìng', 'သေချာပေါက် / မုချ', 'surely / certainly', 'သေချာပေါက် / မုချ', '1. 我一定去。\nI will definitely go.\nငါ သေချာပေါက် သွားမယ်။\n\n2. 不一定。\nNot necessarily.\nမသေချာဘူး (ဖြစ်ချင်မှဖြစ်မယ်)။\n\n3. 一定要小心。\nMust be careful.\nသေချာပေါက် ဂရုစိုက်ရမယ်။', 'audio/hsk1/一定.mp3', 442),
('hsk1_443', 1, '一共', 'yí gòng', 'စုစုပေါင်း', 'altogether / in total', 'စုစုပေါင်း', '1. 一共多少钱？\nHow much in total?\nစုစုပေါင်း ဘယ်လောက်လဲ။\n\n2. 一共三个人。\nThree people in total.\nစုစုပေါင်း လူ ၃ ယောက်။\n\n3. 一共十块。\nTen yuan in total.\nစုစုပေါင်း ၁၀ ယွမ်။', 'audio/hsk1/一共.mp3', 443),
('hsk1_444', 1, '一会儿', 'yí huì r', 'ခဏလောက် / ခဏနေ', 'a while / a moment', 'ခဏလောက် / ခဏနေ', '1. 等一会儿。\nWait a moment.\nခဏလောက် စောင့်ပါ။\n\n2. 我一会儿去。\nI will go in a while.\nငါ ခဏနေရင် သွားမယ်။\n\n3. 玩了一会儿。\nPlayed for a while.\nခဏလောက် ကစားခဲ့တယ်။', 'audio/hsk1/一会儿.mp3', 444),
('hsk1_445', 1, '一样', 'yí yàng', 'တူညီသည်', 'same', 'တူညီသည်', '1. 我们一样。\nWe are the same.\nငါတို့ အတူတူပဲ။\n\n2. 这跟那个一样。\nThis is the same as that.\nဒါက ဟိုဟာနဲ့ တူတူပဲ။\n\n3. 不太一样。\nNot exactly the same.\nသိပ်မတူဘူး။', 'audio/hsk1/一样.mp3', 445),
('hsk1_446', 1, '以后', 'yǐ hòu', 'နောက်မှ / ပြီးနောက် / နောင်တွင်', 'after / later / in the future', 'နောက်မှ / ပြီးနောက် / နောင်တွင်', '1. 吃饭以后。\nAfter eating.\nထမင်းစားပြီးနောက်။\n\n2. 以后再说。\nTalk about it later.\nနောက်မှ ပြောကြတာပေါ့။\n\n3. 三年以后。\nThree years later.\n၃ နှစ် ကြာပြီးနောက်။', 'audio/hsk1/以后.mp3', 446),
('hsk1_447', 1, '以前', 'yǐ qián', 'အရင်က / မတိုင်ခင်', 'before / ago', 'အရင်က / မတိုင်ခင်', '1. 以前我不认识他。\nI didn\'t know him before.\nအရင်က ငါသူ့ကို မသိဘူး။\n\n2. 三天以前。\nThree days ago.\nလွန်ခဲ့တဲ့ ၃ ရက်က။\n\n3. 很久以前。\nLong time ago.\nလွန်ခဲ့တဲ့ ကြာမြင့်တဲ့အချိန်က။', 'audio/hsk1/以前.mp3', 447),
('hsk1_448', 1, '以为', 'yǐ wéi', 'ထင်ခဲ့သည် (အထင်မှား)', 'think (mistakenly)', 'ထင်ခဲ့သည် (အထင်မှား)', '1. 我以为是你。\nI thought it was you (but it wasn\'t).\nငါက မင်းလို့ ထင်နေတာ။\n\n2. 你以为呢？\nWhat did you think?\nမင်းကရော ဘယ်လိုထင်လို့လဲ။\n\n3. 不要以为容易。\nDon\'t think it\'s easy.\nလွယ်တယ်လို့ မထင်လိုက်နဲ့။', 'audio/hsk1/以为.mp3', 448),
('hsk1_449', 1, '已经', 'yǐ jīng', 'ပြီးပြီ / နေပြီ', 'already', 'ပြီးပြီ / နေပြီ', '1. 已经走了。\nAlready left.\nထွက်သွားနှင့်ပြီ။\n\n2. 我已经吃饭了。\nI have already eaten.\nငါ ထမင်းစားပြီးပြီ။\n\n3. 天已经黑了。\nIt is already dark.\nမိုးချုပ်နေပြီ။', 'audio/hsk1/已经.mp3', 449),
('hsk1_450', 1, '椅子', 'yǐ zi', 'ကုလားထိုင်', 'chair', 'ကုလားထိုင်', '1. 一把椅子。\nA chair.\nကုလားထိုင် တစ်လုံး။\n\n2. 坐在椅子上。\nSit on the chair.\nကုလားထိုင်ပေါ်မှာ ထိုင်တယ်။\n\n3. 搬椅子。\nMove the chair.\nကုလားထိုင် ရွှေ့တယ်။', 'audio/hsk1/椅子.mp3', 450),
('hsk1_451', 1, '亿', 'yì', 'သန်းတစ်ရာ (ကုဋေတစ်ဆယ်)', 'one hundred million', 'သန်းတစ်ရာ (ကုဋေတစ်ဆယ်)', '1. 一亿人。\nOne hundred million people.\nလူသန်းတစ်ရာ။\n\n2. 好几亿。\nSeveral hundred million.\nသန်းရာချီ။\n\n3. 中国有十四亿人口。\nChina has a population of 1.4 billion.\nတရုတ်နိုင်ငံမှာ လူဦးရေ ၁.၄ ဘီလီယံ (သန်း ၁၄၀၀) ရှိတယ်။', 'audio/hsk1/亿.mp3', 451),
('hsk1_452', 1, '一般', 'yì bān', 'ပုံမှန် / သာမန် / သိပ်မကောင်းလှဘူး', 'general / ordinary / so-so', 'ပုံမှန် / သာမန် / သိပ်မကောင်းလှဘူး', '1. 我很一般。\nI am just average.\nငါက သာမန်ပါပဲ။\n\n2. 一般的书。\nOrdinary books.\nသာမန် စာအုပ်တွေ။\n\n3. 这儿的菜一般。\nThe food here is just so-so.\nဒီက ဟင်းတွေက သိပ်မကောင်းလှဘူး (သာမန်ပါပဲ)။', 'audio/hsk1/一般.mp3', 452),
('hsk1_453', 1, '一边', 'yì biān', 'တစ်ဖက် / ...ရင်း... (နှစ်မျိုးတစ်ပြိုင်နက်လုပ်ခြင်း)', 'one side / while doing', 'တစ်ဖက် / ...ရင်း... (နှစ်မျိုးတစ်ပြိုင်နက်လုပ်ခြင်း)', '1. 在左边，不在右边。\n\"On the left side, not on the right side.\"\nဘယ်ဘက်မှာ၊ ညာဘက်မှာ မဟုတ်ဘူး။\n\n2. 一边吃，一边说。\nEating while talking.\nစားရင်း ပြောရင်း။\n\n3. 一边走一边看。\nLooking while walking.\nလမ်းလျှောက်ရင်း ကြည့်ရင်း။', 'audio/hsk1/一边.mp3', 453),
('hsk1_454', 1, '一起', 'yì qǐ', 'အတူတူ', 'together', 'အတူတူ', '1. 我们一起去。\nWe go together.\nငါတို့ အတူတူ သွားမယ်။\n\n2. 在一起。\nBe together.\nအတူတူ ရှိနေတယ်။\n\n3. 大家一起唱。\nEveryone sing together.\nအားလုံး အတူတူ ဆိုကြမယ်။', 'audio/hsk1/一起.mp3', 454),
('hsk1_455', 1, '一直', 'yì zhí', 'တောက်လျှောက် / တည့်တည့် / တနေကုန်', 'continuously / straight', 'တောက်လျှောက် / တည့်တည့် / တနေကုန်', '1. 一直走。\nWalk straight.\nတည့်တည့် သွားပါ။\n\n2. 一直下雨。\nRaining continuously.\nမိုးတောက်လျှောက် ရွာနေတယ်။\n\n3. 我一直在这儿。\nI have been here all the time.\nငါ ဒီမှာပဲ တနေကုန် ရှိနေတာ။', 'audio/hsk1/一直.mp3', 455),
('hsk1_456', 1, '意见', 'yì jiàn', 'အမြင် / သဘောထား / အကြံပြုချက်', 'opinion / suggestion', 'အမြင် / သဘောထား / အကြံပြုချက်', '1. 你有什么意见？\nWhat is your opinion?\nမင်း ဘာသဘောထား ရှိလဲ (ဘာအကြံပြုချင်လဲ)။\n\n2. 听听大家的意见。\nListen to everyone\'s opinion.\nလူတိုင်းရဲ့ သဘောထားကို နားထောင်ကြည့်မယ်။\n\n3. 没意见。\nNo objection / No opinion.\nကန့်ကွက်စရာ မရှိပါဘူး။', 'audio/hsk1/意见.mp3', 456),
('hsk1_457', 1, '意思', 'yì si', 'အဓိပ္ပာယ် / စိတ်ဝင်စားစရာ', 'meaning / interest', 'အဓိပ္ပာယ် / စိတ်ဝင်စားစရာ', '1. 什么意思？\nWhat does it mean?\nဘာအဓိပ္ပာယ်လဲ။\n\n2. 有意思。\nInteresting.\nစိတ်ဝင်စားဖို့ ကောင်းတယ်။\n\n3. 不好意思。\nSorry / Excuse me (feeling embarrassed).\nအားနာပါတယ်။', 'audio/hsk1/意思.mp3', 457),
('hsk1_458', 1, '阴', 'yīn', 'မိုးအုံ့သည်', 'overcast / cloudy', 'မိုးအုံ့သည်', '1. 阴天。\nCloudy day / Overcast day.\nမိုးအုံ့တဲ့နေ့။\n\n2. 天阴了。\nThe sky has turned cloudy.\nမိုးအုံ့လာပြီ။\n\n3. 今天有些阴。\nIt is a bit overcast today.\nဒီနေ့ နည်းနည်း မိုးအုံ့နေတယ်။', 'audio/hsk1/阴.mp3', 458),
('hsk1_459', 1, '因为', 'yīn wèi', 'ဘာကြောင့်လဲဆိုတော့ / ...ကြောင့်', 'because', 'ဘာကြောင့်လဲဆိုတော့ / ...ကြောင့်', '1. 因为下雨，所以我不去。\n\"Because it\'s raining, I\'m not going.\"\nမိုးရွာနေလို့ ငါမသွားတော့ဘူး။\n\n2. 是因为你。\nIt is because of you.\nမင်းကြောင့်ပါ။\n\n3. 因为很忙。\nBecause I am very busy.\nအရမ်း အလုပ်များနေလို့ပါ။', 'audio/hsk1/因为.mp3', 459),
('hsk1_460', 1, '音乐', 'yīn yuè', 'ဂီတ / သီချင်း', 'music', 'ဂီတ / သီချင်း', '1. 听音乐。\nListen to music.\nသီချင်း နားထောင်တယ်။\n\n2. 音乐家。\nMusician.\nဂီတပညာရှင်။\n\n3. 好听的音乐。\nPleasant music.\nနားထောင်လို့ကောင်းတဲ့ သီချင်း။', 'audio/hsk1/音乐.mp3', 460),
('hsk1_461', 1, '银行', 'yín háng', 'ဘဏ်', 'bank', 'ဘဏ်', '1. 去银行取钱。\nGo to the bank to withdraw money.\nဘဏ်သွားပြီး ပိုက်ဆံထုတ်တယ်။\n\n2. 银行在哪儿？\nWhere is the bank?\nဘဏ် ဘယ်မှာလဲ။\n\n3. 这家银行很大。\nThis bank is very big.\nဒီဘဏ်က အရမ်းကြီးတယ်။', 'audio/hsk1/银行.mp3', 461),
('hsk1_462', 1, '应该', 'yīng gāi', 'သင့်သည် / ထင်သည်', 'should', 'သင့်သည် / ထင်သည်', '1. 你应该去。\nYou should go.\nမင်း သွားသင့်တယ်။\n\n2. 应该没问题。\nThere should be no problem.\nပြဿနာ မရှိလောက်ဘူးလို့ ထင်တယ်။\n\n3. 不应该这样做。\nShould not do it this way.\nဒီလို မလုပ်သင့်ဘူး။', 'audio/hsk1/应该.mp3', 462),
('hsk1_463', 1, '英语', 'yīng yǔ', 'အင်္ဂလိပ်စာ', 'English language', 'အင်္ဂလိပ်စာ', '1. 说英语。\nSpeak English.\nအင်္ဂလိပ်လို ပြောတယ်။\n\n2. 学英语。\nLearn English.\nအင်္ဂလိပ်စာ သင်ယူတယ်။\n\n3. 你会英语吗？\nCan you speak English?\nမင်း အင်္ဂလိပ်စကား တတ်လား။', 'audio/hsk1/英语.mp3', 463),
('hsk1_464', 1, '影响', 'yǐng xiǎng', 'လွှမ်းမိုးမှု / သက်ရောက်မှု', 'influence / affect', 'လွှမ်းမိုးမှု / သက်ရောက်မှု', '1. 不要影响我。\nDon\'t disturb/influence me.\nငါ့ကို လာမနှောင့်ယှက်ပါနဲ့ (ငါ့အပေါ် မသက်ရောက်ပါစေနဲ့)။\n\n2. 有很大影响。\nHave a big influence.\nလွှမ်းမိုးမှု အများကြီးရှိတယ်။\n\n3. 影响学习。\nAffect studies.\nစာလေ့လာမှုကို ထိခိုက်စေတယ်။', 'audio/hsk1/影响.mp3', 464),
('hsk1_465', 1, '用', 'yòng', 'သုံးသည်', 'use', 'သုံးသည်', '1. 不用。\nNo need.\nမလိုပါဘူး (သုံးစရာမလို)။\n\n2. 用手机。\nUse mobile phone.\nဖုန်း သုံးတယ်။\n\n3. 怎么用？\nHow to use?\nဘယ်လို သုံးရမလဲ။', 'audio/hsk1/用.mp3', 465),
('hsk1_466', 1, '游戏', 'yóu xì', 'ဂိမ်း / ကစားပွဲ', 'game', 'ဂိမ်း / ကစားပွဲ', '1. 玩游戏。\nPlay games.\nဂိမ်း ဆော့တယ်။\n\n2. 电脑游戏。\nComputer game.\nကွန်ပျူတာ ဂိမ်း။\n\n3. 这个游戏好玩。\nThis game is fun.\nဒီဂိမ်းက ပျော်ဖို့ကောင်းတယ်။', 'audio/hsk1/游戏.mp3', 466),
('hsk1_467', 1, '有名', 'yǒu míng', 'နာမည်ကြီးသော', 'famous', 'နာမည်ကြီးသော', '1. 很有名。\nVery famous.\nအရမ်း နာမည်ကြီးတယ်။\n\n2. 有名的人。\nFamous person.\nနာမည်ကြီးတဲ့သူ။\n\n3. 这儿很有名。\nThis place is very famous.\nဒီနေရာက အရမ်းနာမည်ကြီးတယ်။', 'audio/hsk1/有名.mp3', 467),
('hsk1_468', 1, '又', 'yòu', 'ထပ်ပြီး (ပြီးခဲ့သည့်အရာ)', 'again (usually past)', 'ထပ်ပြီး (ပြီးခဲ့သည့်အရာ)', '1. 他又来了。\nHe came again.\nသူ ထပ်လာပြန်ပြီ။\n\n2. 又下雨了。\nIt rained again.\nမိုးထပ်ရွာပြန်ပြီ။\n\n3. 又大又红。\nBig and red.\nကြီးလည်းကြီး နီလည်းနီတယ်။', 'audio/hsk1/又.mp3', 468),
('hsk1_469', 1, '右', 'yòu', 'ညာ (ဘက်)', 'right (direction)', 'ညာ (ဘက်)', '1. 往右走。\nGo right.\nညာဘက်ကို သွားပါ။\n\n2. 看右边。\nLook to the right.\nညာဘက်ကို ကြည့်ပါ။\n\n3. 右边那个人。\nThat person on the right.\nညာဘက်က ဟိုလူ။', 'audio/hsk1/右.mp3', 469),
('hsk1_470', 1, '鱼', 'yú', 'ငါး', 'fish', 'ငါး', '1. 一条鱼。\nA fish.\nငါးတစ်ကောင်။\n\n2. 吃鱼。\nEat fish.\nငါး စားတယ်။\n\n3. 水里有鱼。\nThere are fish in the water.\nရေထဲမှာ ငါးတွေ ရှိတယ်။', 'audio/hsk1/鱼.mp3', 470),
('hsk1_471', 1, '元', 'yuán', 'ယွမ် (တရုတ်ငွေကြေး)', 'Yuan (currency)', 'ယွမ် (တရုတ်ငွေကြေး)', '1. 一百元。\n100 Yuan.\nယွမ် ၁၀၀။\n\n2. 多少元？\nHow many Yuan?\nဘယ်နှယွမ်လဲ။\n\n3. 一元钱。\nOne Yuan.\nတစ်ယွမ်။', 'audio/hsk1/元.mp3', 471),
('hsk1_472', 1, '远', 'yuǎn', 'ဝေးသော', 'far', 'ဝေးသော', '1. 很远。\nVery far.\nအရမ်း ဝေးတယ်။\n\n2. 不远。\nNot far.\nမဝေးပါဘူး။\n\n3. 你家远吗？\nIs your home far?\nမင်းအိမ် ဝေးလား။', 'audio/hsk1/远.mp3', 472),
('hsk1_473', 1, '月', 'yuè', 'လ', 'month', 'လ', '1. 一个月。\nOne month.\nတစ်လ။\n\n2. 几月？\nWhich month?\nဘယ်လလဲ။\n\n3. 下个月。\nNext month.\nနောက်လ။', 'audio/hsk1/月.mp3', 473),
('hsk1_474', 1, '运动', 'yùn dòng', 'အားကစား / လေ့ကျင့်ခန်း', 'sports / exercise', 'အားကစား / လေ့ကျင့်ခန်း', '1. 做运动。\nDo exercise.\nလေ့ကျင့်ခန်း လုပ်တယ်။\n\n2. 我也喜欢运动。\nI also like sports.\nငါလည်း အားကစား ဝါသနာပါတယ်။\n\n3. 穿运动鞋。\nWear sports shoes.\nအားကစားဖိနပ် စီးတယ်။', 'audio/hsk1/运动.mp3', 474),
('hsk1_475', 1, '再', 'zài', 'ထပ်ပြီး / နောက်မှ', 'again', 'ထပ်ပြီး / နောက်မှ', '1. 再见。\nGoodbye (See you again).\nနှုတ်ဆက်ပါတယ် (နောက်မှတွေ့မယ်)။\n\n2. 再来一个。\nOne more please.\nနောက်ထပ် တစ်ခုလောက်။\n\n3. 再也不会。\nNever again.\nနောက်ထပ် ဘယ်တော့မှ (မလုပ်တော့ဘူး)။', 'audio/hsk1/再.mp3', 475),
('hsk1_476', 1, '再见', 'zài jiàn', 'နှုတ်ဆက်ပါတယ် / တာ့တာ', 'goodbye', 'နှုတ်ဆက်ပါတယ် / တာ့တာ', '1. 老师再见。\n\"Goodbye, teacher.\"\nဆရာ၊ နှုတ်ဆက်ပါတယ်ခင်ဗျာ။\n\n2. 大家再见。\nGoodbye everyone.\nအားလုံးပဲ တာ့တာနော်။\n\n3. 说了再见。\nSaid goodbye.\nနှုတ်ဆက်စကား ပြောခဲ့တယ်။', 'audio/hsk1/再见.mp3', 476),
('hsk1_477', 1, '在', 'zài', 'မှာ / ရှိသည်', 'at / in / on', 'မှာ / ရှိသည်', '1. 我在家。\nI am at home.\nငါ အိမ်မှာ ရှိတယ်။\n\n2. 书在桌子上。\nThe book is on the table.\nစာအုပ်က စားပွဲပေါ်မှာ ရှိတယ်။\n\n3. 他在哪儿？\nWhere is he?\nသူ ဘယ်မှာလဲ။', 'audio/hsk1/在.mp3', 477),
('hsk1_478', 1, '早', 'zǎo', 'စောသော', 'early', 'စောသော', '1. 很早。\nVery early.\nအရမ်း စောတယ်။\n\n2. 早去早回。\nGo early and return early.\nစောစောသွား စောစောပြန်။\n\n3. 你来早了。\nYou came early.\nမင်း လာတာ စောနေတယ်။', 'audio/hsk1/早.mp3', 478),
('hsk1_479', 1, '早上', 'zǎo shang', 'မနက်ခင်း', 'morning', 'မနက်ခင်း', '1. 早上好。\nGood morning.\nမင်္ဂလာ မနက်ခင်းပါ။\n\n2. 今天早上。\nThis morning.\nဒီနေ့ မနက်။\n\n3. 早上八点。\n8:00 AM\nမနက် ၈ နာရီ။', 'audio/hsk1/早上.mp3', 479),
('hsk1_480', 1, '怎么', 'zěn me', 'ဘယ်လို / ဘာဖြစ်လို့', 'how', 'ဘယ်လို / ဘာဖြစ်လို့', '1. 怎么走？\nHow to go (get there)?\nဘယ်လို သွားရမလဲ။\n\n2. 怎么做？\nHow to do?\nဘယ်လို လုပ်ရမလဲ။\n\n3. 你怎么了？\nWhat happened to you?\nမင်း ဘာဖြစ်တာလဲ။', 'audio/hsk1/怎么.mp3', 480),
('hsk1_481', 1, '怎么样', 'zěn me yàng', 'ဘယ်လိုလဲ', 'how about / how is it', 'ဘယ်လိုလဲ', '1. 这本书怎么样？\nHow is this book?\nဒီစာအုပ်က ဘယ်လိုလဲ (ကောင်းလား)။\n\n2. 最近怎么样？\nHow have you been recently?\nဒီရက်ပိုင်း အခြေအနေ ဘယ်လိုလဲ။\n\n3. 不怎么样。\nNot that great.\nသိပ်မကောင်းပါဘူး / သာမန်ပါပဲ။', 'audio/hsk1/怎么样.mp3', 481),
('hsk1_482', 1, '站', 'zhàn', 'ဘူတာ / မတ်တတ်ရပ်သည်', 'station / stand', 'ဘူတာ / မတ်တတ်ရပ်သည်', '1. 火车站。\nTrain station.\nဘူတာရုံ။\n\n2. 站起来。\nStand up.\nမတ်တတ် ရပ်လိုက်ပါ။\n\n3. 站在门外。\nStand outside the door.\nတံခါးအပြင်ဘက်မှာ ရပ်နေတယ်။', 'audio/hsk1/站.mp3', 482),
('hsk1_483', 1, '找', 'zhǎo', 'ရှာသည်', 'find / look for', 'ရှာသည်', '1. 找东西。\nLook for something.\nပစ္စည်း ရှာတယ်။\n\n2. 我在找你。\nI am looking for you.\nငါ မင်းကို ရှာနေတာ။\n\n3. 找到了。\nFound it.\nရှာတွေ့ပြီ။', 'audio/hsk1/找.mp3', 483),
('hsk1_484', 1, '这', 'zhè', 'ဒီ / ဒါ', 'this', 'ဒီ / ဒါ', '1. 这是什么？\nWhat is this?\nဒါ ဘာလဲ။\n\n2. 这个人。\nThis person.\nဒီလူ။\n\n3. 这儿。\nHere.\nဒီနေရာ။', 'audio/hsk1/这.mp3', 484),
('hsk1_485', 1, '真', 'zhēn', 'တကယ် / စစ်မှန်သော', 'really / real', 'တကယ် / စစ်မှန်သော', '1. 真的吗？\nReally?\nတကယ်လား။\n\n2. 真好。\nReally good.\nတကယ် ကောင်းတယ်။\n\n3. 真漂亮。\nReally beautiful.\nတကယ် လှတယ်။', 'audio/hsk1/真.mp3', 485),
('hsk1_486', 1, '正在', 'zhèng zài', 'နေသည် (လုပ်ဆောင်ဆဲ)', '(in the process of)', 'နေသည် (လုပ်ဆောင်ဆဲ)', '1. 正在吃饭。\nEating right now.\nထမင်း စားနေတယ်။\n\n2. 正在下雨。\nIt is raining right now.\nမိုးရွာနေတယ်။\n\n3. 我们在正在上课。\nWe are having class right now.\nငါတို့ အတန်းတက်နေတယ်။', 'audio/hsk1/正在.mp3', 486),
('hsk1_487', 1, '知道', 'zhī dào', 'သိသည်', 'know', 'သိသည်', '1. 我知道。\nI know.\nငါ သိတယ်။\n\n2. 不知道。\nDon\'t know.\nမသိဘူး။\n\n3. 你知道吗？\nDo you know?\nမင်း သိလား။', 'audio/hsk1/知道.mp3', 487),
('hsk1_488', 1, '中国', 'zhōng guó', 'တရုတ်ပြည်', 'China', 'တရုတ်ပြည်', '1. 中国人。\nChinese person.\nတရုတ်လူမျိုး။\n\n2. 去中国。\nGo to China.\nတရုတ်ပြည် သွားတယ်။\n\n3. 中国菜。\nChinese food.\nတရုတ်ဟင်း။', 'audio/hsk1/中国.mp3', 488),
('hsk1_489', 1, '中午', 'zhōng wǔ', 'နေ့လယ်', 'noon', 'နေ့လယ်', '1. 中午好。\nGood noon (Hello).\nမင်္ဂလာ နေ့လယ်ခင်းပါ။\n\n2. 中午休息。\nRest at noon.\nနေ့လယ်ဘက် နားတယ်။\n\n3. 中午十二点。\n12:00 Noon.\nနေ့လယ် ၁၂ နာရီ။', 'audio/hsk1/中午.mp3', 489),
('hsk1_490', 1, '住', 'zhù', 'နေထိုင်သည်', 'live / stay', 'နေထိုင်သည်', '1. 你住哪儿？\nWhere do you live?\nမင်း ဘယ်မှာ နေလဲ။\n\n2. 住在北京。\nLive in Beijing.\nပေကျင်းမှာ နေတယ်။\n\n3. 我想住这儿。\nI want to stay here.\nငါ ဒီမှာ နေချင်တယ်။', 'audio/hsk1/住.mp3', 490),
('hsk1_491', 1, '准备', 'zhǔn bèi', 'ပြင်ဆင်သည်', 'prepare / get ready', 'ပြင်ဆင်သည်', '1. 准备好了吗？\nAre you ready?\nအဆင်သင့် ဖြစ်ပြီလား။\n\n2. 我没准备。\nI am not prepared.\nငါ မပြင်ဆင်ရသေးဘူး။\n\n3. 准备吃饭。\nGet ready to eat.\nထမင်းစားဖို့ ပြင်တယ်။', 'audio/hsk1/准备.mp3', 491),
('hsk1_492', 1, '桌子', 'zhuō zi', 'စားပွဲခုံ', 'table / desk', 'စားပွဲခုံ', '1. 一张桌子。\nA table.\nစားပွဲခုံ တစ်ခုံ။\n\n2. 桌子上。\nOn the table.\nစားပွဲခုံပေါ်မှာ။\n\n3. 这是谁的桌子？\nWhose table is this?\nဒါ ဘယ်သူ့စားပွဲလဲ။', 'audio/hsk1/桌子.mp3', 492),
('hsk1_493', 1, '字', 'zì', 'စာလုံး', 'character / word', 'စာလုံး', '1. 汉字。\nChinese character.\nတရုတ်စာလုံး။\n\n2. 我不认识这个字。\nI don\'t know this character.\nငါ ဒီစာလုံးကို မသိဘူး။\n\n3. 写字。\nWrite characters.\nစာရေးတယ်။', 'audio/hsk1/字.mp3', 493),
('hsk1_494', 1, '走', 'zǒu', 'လမ်းလျှောက်သည် / သွားသည်', 'walk / go / leave', 'လမ်းလျှောက်သည် / သွားသည်', '1. 我们走吧。\nLet\'s go.\nငါတို့ သွားကြစို့။\n\n2. 走路去。\nGo by walking.\nလမ်းလျှောက်သွားတယ်။\n\n3. 他走了。\nHe left.\nသူ ထွက်သွားပြီ။', 'audio/hsk1/走.mp3', 494),
('hsk1_495', 1, '最', 'zuì', 'အ...ဆုံး (နှိုင်းယှဉ်ခြင်း)', 'most / -est', 'အ...ဆုံး (နှိုင်းယှဉ်ခြင်း)', '1. 最好。\nBest.\nအကောင်းဆုံး။\n\n2. 最喜欢。\nLike the most (Favorite).\nအကြိုက်ဆုံး။\n\n3. 我最爱吃苹果。\nI love eating apples the most.\nငါ ပန်းသီးစားရတာ အကြိုက်ဆုံးပဲ။', 'audio/hsk1/最.mp3', 495),
('hsk1_496', 1, '左', 'zuǒ', 'ဘယ် (ဘက်)', 'left (direction)', 'ဘယ် (ဘက်)', '1. 左手。\nLeft hand.\nဘယ်လက်။\n\n2. 左边那个人。\nThat person on the left.\nဘယ်ဘက်က ဟိုလူ။\n\n3. 他在我左边。\nHe is on my left.\nသူ ငါ့ဘယ်ဘက်မှာ ရှိတယ်။', 'audio/hsk1/左.mp3', 496),
('hsk1_497', 1, '坐', 'zuò', 'ထိုင်သည် / စီးသည် (ယာဉ်)', 'sit / take (transport)', 'ထိုင်သည် / စီးသည် (ယာဉ်)', '1. 请坐。\nPlease sit down.\nထိုင်ပါခင်ဗျာ။\n\n2. 坐公共汽车。\nTake a bus.\nဘတ်စ်ကား စီးတယ်။\n\n3. 坐下。\nSit down.\nထိုင်ချလိုက်ပါ။', 'audio/hsk1/坐.mp3', 497),
('hsk1_498', 1, '做', 'zuò', 'လုပ်သည်', 'do / make', 'လုပ်သည်', '1. 做饭。\nCook (Make food).\nထမင်းဟင်း ချက်တယ်။\n\n2. 你在做什么？\nWhat are you doing?\nမင်း ဘာလုပ်နေတာလဲ။\n\n3. 做朋友。\nBe friends.\nသူငယ်ချင်း လုပ်တယ်။', 'audio/hsk1/做.mp3', 498),
('hsk1_499', 1, '昨天', 'zuó tiān', 'မနေ့က', 'yesterday', 'မနေ့က', '1. 昨天上午。\nYesterday morning.\nမနေ့က မနက်။\n\n2. 昨天没来。\nDidn\'t come yesterday.\nမနေ့က မလာခဲ့ဘူး။\n\n3. 昨天是星期一。\nYesterday was Monday.\nမနေ့က တနင်္လာနေ့ ဖြစ်တယ်။', 'audio/hsk1/昨天.mp3', 499),
('hsk1_500', 1, '作业', 'zuò yè', 'အိမ်စာ', 'homework', 'အိမ်စာ', '1. 做作业。\nDo homework.\nအိမ်စာ လုပ်တယ်။\n\n2. 交作业。\nHand in homework.\nအိမ်စာ ထပ်တယ်။\n\n3. 作业很多。\nA lot of homework.\nအိမ်စာတွေ အများကြီးပဲ။', 'audio/hsk1/作业.mp3', 500),
('hsk7_001', 7, '全球化', 'quán qiú huà', 'โลกาภิวัตน์', 'globalization', 'ကမ္ဘာလုံးဆိုင်ရာဖြစ်ပေါ်မှု', '全球化对经济影响很大。', 'assets/audio/hsk7/quanqiuhua.mp3', 1),
('hsk7_002', 7, '可持续发展', 'kě chí xù fā zhǎn', 'การพัฒนาที่ยั่งยืน', 'sustainable development', 'ရေရှည်တည်တံ့သောဖွံ့ဖြိုးမှု', '可持续发展是我们的目标。', 'assets/audio/hsk7/kechixufazhan.mp3', 2),
('hsk7_003', 7, '人工智能', 'rén gōng zhì néng', 'ปัญญาประดิษฐ์', 'artificial intelligence (AI)', 'လူလုပ်ဉာဏ်ရည်', '人工智能改变了很多行业。', 'assets/audio/hsk7/rengongzhineng.mp3', 3),
('hsk7_004', 7, '创新', 'chuàng xīn', 'นวัตกรรม', 'innovation', 'ဆန်းသစ်တီထွင်မှု', '创新是企业发展的重要动力。', 'assets/audio/hsk7/chuangxin.mp3', 4),
('hsk7_005', 7, '数字化转型', 'shù zì huà zhuǎn xíng', 'การเปลี่ยนผ่านสู่ดิจิทัล', 'digital transformation', 'ဒစ်ဂျစ်တယ်အသွင်ပြောင်းမှု', '企业正在进行数字化转型。', 'assets/audio/hsk7/shuzihuazhuanxing.mp3', 5),
('hsk7_006', 7, '气候变化', 'qì hòu biàn huà', 'การเปลี่ยนแปลงสภาพภูมิอากาศ', 'climate change', 'ရာသီဥတုပြောင်းလဲမှု', '气候变化是全球性问题。', 'assets/audio/hsk7/qihoubianhua.mp3', 6),
('hsk7_007', 7, '供应链', 'gōng yìng liàn', 'ห่วงโซ่อุปทาน', 'supply chain', 'ထောက်ပံ့ရေးကွင်းဆက်', '供应链管理很重要。', 'assets/audio/hsk7/gongyinglian.mp3', 7),
('hsk7_008', 7, '电子商务', 'diàn zǐ shāng wù', 'พาณิชย์อิเล็กทรอนิกส์', 'e-commerce', 'အီလက်ထရောနစ်စီးပွားရေး', '电子商务发展很快。', 'assets/audio/hsk7/dianzishangwu.mp3', 8),
('hsk7_009', 7, '大数据', 'dà shù jù', 'ข้อมูลขนาดใหญ่', 'big data', 'ဒေတာကြီး', '大数据分析帮助决策。', 'assets/audio/hsk7/dashuju.mp3', 9),
('hsk7_010', 7, '云计算', 'yún jì suàn', 'คลาวด์คอมพิวติ้ง', 'cloud computing', 'တိမ်တိုက်ကွန်ပျူတင်း', '云计算提供了很多便利。', 'assets/audio/hsk7/yunjisuan.mp3', 10),
('hsk7_011', 7, '区块链', 'qū kuài liàn', 'บล็อกเชน', 'blockchain', 'ဘလော့ချိန်း', '区块链技术很有前景。', 'assets/audio/hsk7/qukuailian.mp3', 11),
('hsk7_012', 7, '虚拟现实', 'xū nǐ xiàn shí', 'ความเป็นจริงเสมือน', 'virtual reality (VR)', 'ပကတိမဟုတ်သောလက်တွေ့', '虚拟现实技术在游戏中的应用很广。', 'assets/audio/hsk7/xunixianshi.mp3', 12),
('hsk7_013', 7, '生物技术', 'shēng wù jì shù', 'เทคโนโลยีชีวภาพ', 'biotechnology', 'ဇီဝနည်းပညာ', '生物技术在医学领域很重要。', 'assets/audio/hsk7/shengwujishu.mp3', 13),
('hsk7_014', 7, '新能源', 'xīn néng yuán', 'พลังงานใหม่', 'new energy', 'စွမ်းအင်အသစ်', '新能源是未来的发展方向。', 'assets/audio/hsk7/xinnengyuan.mp3', 14),
('hsk7_015', 7, '智能制造', 'zhì néng zhì zào', 'การผลิตอัจฉริยะ', 'smart manufacturing', 'စမတ်ထုတ်လုပ်မှု', '智能制造提高了生产效率。', 'assets/audio/hsk7/zhinengzhizao.mp3', 15),
('hsk7_016', 7, '数字经济', 'shù zì jīng jì', 'เศรษฐกิจดิจิทัล', 'digital economy', 'ဒစ်ဂျစ်တယ်စီးပွားရေး', '数字经济成为新的增长点。', 'assets/audio/hsk7/shuzijingji.mp3', 16),
('hsk7_017', 7, '网络安全', 'wǎng luò ān quán', 'ความปลอดภัยเครือข่าย', 'cybersecurity', 'ဆိုက်ဘာလုံခြုံရေး', '网络安全很重要。', 'assets/audio/hsk7/wangluoanquan.mp3', 17),
('hsk7_018', 7, '大数据分析', 'dà shù jù fēn xī', 'การวิเคราะห์ข้อมูลขนาดใหญ่', 'big data analytics', 'ဒေတာကြီးခွဲခြမ်းစိတ်ဖြာမှု', '大数据分析帮助企业决策。', 'assets/audio/hsk7/dashujufenxi.mp3', 18),
('hsk7_019', 7, '机器翻译', 'jī qì fān yì', 'การแปลภาษาด้วยเครื่อง', 'machine translation', 'စက်ဘာသာပြန်', '机器翻译技术进步很快。', 'assets/audio/hsk7/jiqifanyi.mp3', 19),
('hsk7_020', 7, '量子通信', 'liàng zǐ tōng xìn', 'การสื่อสารควอนตัม', 'quantum communication', 'ကွမ်တမ်ဆက်သွယ်ရေး', '量子通信是未来通信技术。', 'assets/audio/hsk7/liangzitongxin.mp3', 20),
('hsk7_021', 7, '基因工程', 'jī yīn gōng chéng', 'วิศวกรรมพันธุกรรม', 'genetic engineering', 'ဗီဇအင်ဂျင်နီယာ', '基因工程在医学中有广泛应用。', 'assets/audio/hsk7/jiyingongcheng.mp3', 21),
('hsk7_022', 7, '纳米材料', 'nà mǐ cái liào', 'วัสดุนาโน', 'nanomaterials', 'နာနိုပစ္စည်းများ', '纳米材料具有特殊性能。', 'assets/audio/hsk7/namicailiao.mp3', 22),
('hsk7_023', 7, '智能城市', 'zhì néng chéng shì', 'เมืองอัจฉริยะ', 'smart city', 'စမတ်မြို့တော်', '智能城市提高生活质量。', 'assets/audio/hsk7/zhinengchengshi.mp3', 23),
('hsk7_024', 7, '绿色能源', 'lǜ sè néng yuán', 'พลังงานสีเขียว', 'green energy', 'အစိမ်းရောင်စွမ်းအင်', '绿色能源是可持续发展的关键。', 'assets/audio/hsk7/lvsenengyuan.mp3', 24),
('hsk7_025', 7, '碳中和技术', 'tàn zhōng hé jì shù', 'เทคโนโลยีความเป็นกลางคาร์บอน', 'carbon neutral technology', 'ကာဗွန်ချိန်ခွင်လျှာညီနည်းပညာ', '碳中和技术应对气候变化。', 'assets/audio/hsk7/tanzhonghejishu.mp3', 25),
('hsk7_026', 7, '边缘计算', 'biān yuán jì suàn', 'การคำนวณขอบ', 'edge computing', 'အစွန်းကွန်ပျူတင်း', '边缘计算减少延迟。', 'assets/audio/hsk7/bianyuanjisuan.mp3', 26),
('hsk7_027', 7, '元宇宙', 'yuán yǔ zhòu', 'เมตาเวิร์ส', 'metaverse', 'မက်တာဗာ့စ်', '元宇宙概念很热门。', 'assets/audio/hsk7/yuanyuzhou.mp3', 27),
('hsk7_028', 7, '脑机接口', 'nǎo jī jiē kǒu', 'ส่วนต่อประสานสมอง-คอมพิวเตอร์', 'brain-computer interface', 'ဦးနှောက်-ကွန်ပျူတာချိတ်ဆက်မှု', '脑机接口技术突破很大。', 'assets/audio/hsk7/naojijiekou.mp3', 28),
('hsk7_029', 7, '合成生物学', 'hé chéng shēng wù xué', 'ชีววิทยาสังเคราะห์', 'synthetic biology', 'ပေါင်းစပ်ဇီဝဗေဒ', '合成生物学开辟新领域。', 'assets/audio/hsk7/hechengshengwuxue.mp3', 29),
('hsk7_030', 7, '量子霸权', 'liàng zǐ bà quán', 'ควอนตัมซูพรีเมซี', 'quantum supremacy', 'ကွမ်တမ်လွှမ်းမိုးမှု', '量子霸权竞赛激烈。', 'assets/audio/hsk7/liangzibaquan.mp3', 30);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_daily_active_users`
-- (See below for the actual view)
--
CREATE TABLE `v_daily_active_users` (
`session_date` date
,`active_users` bigint(21)
,`total_cards` decimal(32,0)
,`total_minutes` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_user_learning_summary`
-- (See below for the actual view)
--
CREATE TABLE `v_user_learning_summary` (
`user_id` varchar(100)
,`email` varchar(255)
,`first_name` varchar(100)
,`last_name` varchar(100)
,`is_paid` tinyint(1)
,`total_cards_learned` decimal(32,0)
,`total_minutes` decimal(32,0)
,`total_study_days` bigint(21)
,`saved_words_count` bigint(21)
,`mastered_words_count` bigint(21)
,`skipped_words_count` bigint(21)
);

-- --------------------------------------------------------

--
-- Structure for view `v_daily_active_users`
--
DROP TABLE IF EXISTS `v_daily_active_users`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_daily_active_users`  AS SELECT `ls`.`session_date` AS `session_date`, count(distinct `ls`.`user_id`) AS `active_users`, sum(`ls`.`learned_cards`) AS `total_cards`, sum(`ls`.`minutes_spent`) AS `total_minutes` FROM `learning_sessions` AS `ls` GROUP BY `ls`.`session_date` ORDER BY `ls`.`session_date` DESC ;

-- --------------------------------------------------------

--
-- Structure for view `v_user_learning_summary`
--
DROP TABLE IF EXISTS `v_user_learning_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_user_learning_summary`  AS SELECT `u`.`user_id` AS `user_id`, `u`.`email` AS `email`, `u`.`first_name` AS `first_name`, `u`.`last_name` AS `last_name`, `u`.`is_paid` AS `is_paid`, coalesce(sum(`ls`.`learned_cards`),0) AS `total_cards_learned`, coalesce(sum(`ls`.`minutes_spent`),0) AS `total_minutes`, count(distinct `ls`.`session_date`) AS `total_study_days`, (select count(0) from `user_saved_words` `sw` where `sw`.`user_id` = `u`.`user_id`) AS `saved_words_count`, (select count(0) from `user_word_status` `ws` where `ws`.`user_id` = `u`.`user_id` and `ws`.`status` = 'mastered') AS `mastered_words_count`, (select count(0) from `user_word_status` `ws` where `ws`.`user_id` = `u`.`user_id` and `ws`.`status` = 'skipped') AS `skipped_words_count` FROM (`users` `u` left join `learning_sessions` `ls` on(`u`.`user_id` = `ls`.`user_id`)) GROUP BY `u`.`user_id` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `daily_goals`
--
ALTER TABLE `daily_goals`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_user_goal_date` (`user_id`,`goal_date`),
  ADD KEY `idx_goals_user` (`user_id`);

--
-- Indexes for table `learning_sessions`
--
ALTER TABLE `learning_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_user_session_date` (`user_id`,`session_date`),
  ADD KEY `idx_sessions_user` (`user_id`),
  ADD KEY `idx_sessions_date` (`session_date`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `idx_payments_user_id` (`user_id`);

--
-- Indexes for table `promo_codes`
--
ALTER TABLE `promo_codes`
  ADD PRIMARY KEY (`code`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_users_email` (`email`);

--
-- Indexes for table `user_achievements`
--
ALTER TABLE `user_achievements`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_user_achievement` (`user_id`,`achievement_key`),
  ADD KEY `idx_achievements_user` (`user_id`);

--
-- Indexes for table `user_saved_words`
--
ALTER TABLE `user_saved_words`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_user_saved` (`user_id`,`vocab_id`),
  ADD KEY `idx_saved_user` (`user_id`),
  ADD KEY `vocab_id` (`vocab_id`);

--
-- Indexes for table `user_settings`
--
ALTER TABLE `user_settings`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `user_word_status`
--
ALTER TABLE `user_word_status`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_user_word` (`user_id`,`vocab_id`),
  ADD KEY `idx_word_status_user` (`user_id`),
  ADD KEY `vocab_id` (`vocab_id`);

--
-- Indexes for table `vocabulary`
--
ALTER TABLE `vocabulary`
  ADD PRIMARY KEY (`vocab_id`),
  ADD KEY `idx_vocab_level` (`hsk_level`),
  ADD KEY `idx_vocab_hanzi` (`hanzi`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `daily_goals`
--
ALTER TABLE `daily_goals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- AUTO_INCREMENT for table `learning_sessions`
--
ALTER TABLE `learning_sessions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_achievements`
--
ALTER TABLE `user_achievements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_saved_words`
--
ALTER TABLE `user_saved_words`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `user_word_status`
--
ALTER TABLE `user_word_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=379;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `daily_goals`
--
ALTER TABLE `daily_goals`
  ADD CONSTRAINT `daily_goals_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `learning_sessions`
--
ALTER TABLE `learning_sessions`
  ADD CONSTRAINT `learning_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `user_achievements`
--
ALTER TABLE `user_achievements`
  ADD CONSTRAINT `user_achievements_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `user_saved_words`
--
ALTER TABLE `user_saved_words`
  ADD CONSTRAINT `user_saved_words_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_saved_words_ibfk_2` FOREIGN KEY (`vocab_id`) REFERENCES `vocabulary` (`vocab_id`) ON DELETE CASCADE;

--
-- Constraints for table `user_settings`
--
ALTER TABLE `user_settings`
  ADD CONSTRAINT `user_settings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `user_word_status`
--
ALTER TABLE `user_word_status`
  ADD CONSTRAINT `user_word_status_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_word_status_ibfk_2` FOREIGN KEY (`vocab_id`) REFERENCES `vocabulary` (`vocab_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
