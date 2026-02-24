-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: shinkansen.proxy.rlwy.net    Database: railway
-- ------------------------------------------------------
-- Server version	9.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `daily_goals`
--

DROP TABLE IF EXISTS `daily_goals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `daily_goals` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `goal_date` date NOT NULL,
  `target_cards` int NOT NULL DEFAULT '10',
  `completed_cards` int NOT NULL DEFAULT '0',
  `is_completed` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_goal_date` (`user_id`,`goal_date`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_goal_date` (`goal_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_goals`
--

LOCK TABLES `daily_goals` WRITE;
/*!40000 ALTER TABLE `daily_goals` DISABLE KEYS */;
/*!40000 ALTER TABLE `daily_goals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `learning_sessions`
--

DROP TABLE IF EXISTS `learning_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `learning_sessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_date` date NOT NULL,
  `learned_cards` int NOT NULL DEFAULT '0',
  `minutes_spent` int NOT NULL DEFAULT '0',
  `hsk_level` tinyint DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_session_date` (`user_id`,`session_date`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_session_date` (`session_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `learning_sessions`
--

LOCK TABLES `learning_sessions` WRITE;
/*!40000 ALTER TABLE `learning_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `learning_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `payment_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MMK',
  `payment_method` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `promo_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `referral_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','completed','failed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES ('900a8a91-31e1-4f20-994e-9f6ab55b2d93','test-user-001',18000.00,'MMK','card',NULL,NULL,'completed','2026-02-24 20:47:11'),('c110f6c9-a8b4-4cf6-9713-0cbd27d4d0a0','test-user-001',18000.00,'MMK','mpu',NULL,NULL,'completed','2026-02-24 20:47:18');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promo_code_usage`
--

DROP TABLE IF EXISTS `promo_code_usage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promo_code_usage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `promo_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount_amount` decimal(12,2) DEFAULT NULL,
  `order_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_promo_user` (`promo_code`,`user_id`),
  KEY `idx_promo_code` (`promo_code`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promo_code_usage`
--

LOCK TABLES `promo_code_usage` WRITE;
/*!40000 ALTER TABLE `promo_code_usage` DISABLE KEYS */;
/*!40000 ALTER TABLE `promo_code_usage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promo_codes`
--

DROP TABLE IF EXISTS `promo_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promo_codes` (
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount_percent` decimal(5,2) NOT NULL DEFAULT '10.00',
  `max_uses` int DEFAULT '100',
  `used_count` int NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promo_codes`
--

LOCK TABLES `promo_codes` WRITE;
/*!40000 ALTER TABLE `promo_codes` DISABLE KEYS */;
INSERT INTO `promo_codes` VALUES ('EARLY25',25.00,30,0,'2026-02-24 21:00:25','2025-03-31 23:59:59'),('EARLYBIRD',20.00,30,0,'2026-02-24 18:47:11','2025-06-30 23:59:59'),('FLASH10',10.00,100,0,'2026-02-24 21:00:25','2025-12-31 23:59:59'),('LAUNCH2024',15.00,50,0,'2026-02-24 18:47:11','2025-12-31 23:59:59'),('SAVE5',5.00,500,0,'2026-02-24 21:00:25','2025-12-31 23:59:59'),('SPECIAL20',20.00,50,0,'2026-02-24 21:00:25','2025-06-30 23:59:59'),('STUDENT10',10.00,100,0,'2026-02-24 18:47:11','2025-12-31 23:59:59'),('STUDENT15',15.00,200,0,'2026-02-24 21:00:25','2025-12-31 23:59:59');
/*!40000 ALTER TABLE `promo_codes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `referral_codes`
--

DROP TABLE IF EXISTS `referral_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `referral_codes` (
  `code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `max_uses` int DEFAULT '100',
  `used_count` int NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`code`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `referral_codes`
--

LOCK TABLES `referral_codes` WRITE;
/*!40000 ALTER TABLE `referral_codes` DISABLE KEYS */;
INSERT INTO `referral_codes` VALUES ('EARLYBIRD','test-user-001',1,30,0,'2026-02-24 21:00:26',NULL),('FLASH2024','admin-user-001',1,100,0,'2026-02-24 21:00:26',NULL),('STUDENT25','demo-user-001',1,50,0,'2026-02-24 21:00:26',NULL);
/*!40000 ALTER TABLE `referral_codes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `referrals`
--

DROP TABLE IF EXISTS `referrals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `referrals` (
  `id` int NOT NULL AUTO_INCREMENT,
  `referrer_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `referred_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `referral_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `commission_percent` decimal(5,2) NOT NULL DEFAULT '20.00',
  `commission_amount` decimal(12,2) DEFAULT NULL,
  `status` enum('pending','completed','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_referral` (`referrer_id`,`referred_id`),
  KEY `idx_referrer` (`referrer_id`),
  KEY `idx_referred` (`referred_id`),
  KEY `idx_referral_code` (`referral_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `referrals`
--

LOCK TABLES `referrals` WRITE;
/*!40000 ALTER TABLE `referrals` DISABLE KEYS */;
/*!40000 ALTER TABLE `referrals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_achievements`
--

DROP TABLE IF EXISTS `user_achievements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_achievements` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `achievement_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unlocked_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_achievement` (`user_id`,`achievement_key`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_achievements`
--

LOCK TABLES `user_achievements` WRITE;
/*!40000 ALTER TABLE `user_achievements` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_achievements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_saved_words`
--

DROP TABLE IF EXISTS `user_saved_words`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_saved_words` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vocab_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `saved_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_word` (`user_id`,`vocab_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_vocab_id` (`vocab_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_saved_words`
--

LOCK TABLES `user_saved_words` WRITE;
/*!40000 ALTER TABLE `user_saved_words` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_saved_words` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_settings`
--

DROP TABLE IF EXISTS `user_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_settings` (
  `user_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `app_language` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'english',
  `current_hsk_level` tinyint NOT NULL DEFAULT '1',
  `daily_goal_target` int NOT NULL DEFAULT '10',
  `is_shuffle_mode` tinyint(1) NOT NULL DEFAULT '0',
  `notification_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `reminder_time` time NOT NULL DEFAULT '09:00:00',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_settings`
--

LOCK TABLES `user_settings` WRITE;
/*!40000 ALTER TABLE `user_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_word_status`
--

DROP TABLE IF EXISTS `user_word_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_word_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vocab_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('learning','mastered','skipped') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'learning',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_word_status` (`user_id`,`vocab_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_word_status`
--

LOCK TABLES `user_word_status` WRITE;
/*!40000 ALTER TABLE `user_word_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_word_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '+95',
  `referral_code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `referred_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_paid` tinyint(1) NOT NULL DEFAULT '0',
  `promo_code_used` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `unique_email` (`email`),
  KEY `idx_referral_code` (`referral_code`),
  KEY `idx_referred_by` (`referred_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('admin-user-001','admin@gmail.com','$2a$10$RNmtcZRnv0cCqOTY2zdQYeLmzrVmJlDIHy/kzLXN5VoPhPSRIFnwe','Admin','User','123456789','+66','FLASH2024',NULL,0,NULL,NULL,'2026-02-24 18:54:24','2026-02-24 21:00:26'),('demo-user-001','demo@example.com','$2a$10$B59nw3dGtqMGxK0NdWzEXeUvx1LQoR0u1eiApYzTe3WzFhRA38Ziy','Demo','User','123456789','+66','STUDENT25',NULL,0,NULL,NULL,'2026-02-24 18:54:24','2026-02-24 21:00:26'),('test-user-001','test1@gmail.com','$2a$10$RNmtcZRnv0cCqOTY2zdQYeLmzrVmJlDIHy/kzLXN5VoPhPSRIFnwe','Test1','User','123456789','+66','EARLYBIRD',NULL,0,NULL,NULL,'2026-02-24 18:54:24','2026-02-24 21:00:27'),('test-user-002','test2@gmail.com','$2a$10$RNmtcZRnv0cCqOTY2zdQYeLmzrVmJlDIHy/kzLXN5VoPhPSRIFnwe','Test2','User','123456789','+66',NULL,NULL,0,NULL,NULL,'2026-02-24 18:54:24','2026-02-24 18:54:24');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vocabulary`
--

DROP TABLE IF EXISTS `vocabulary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vocabulary` (
  `vocab_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hsk_level` tinyint NOT NULL,
  `hanzi` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pinyin` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `meaning` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meaning_en` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meaning_my` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `example` text COLLATE utf8mb4_unicode_ci,
  `audio_asset` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` int NOT NULL,
  PRIMARY KEY (`vocab_id`),
  KEY `idx_hsk_level` (`hsk_level`),
  KEY `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vocabulary`
--

LOCK TABLES `vocabulary` WRITE;
/*!40000 ALTER TABLE `vocabulary` DISABLE KEYS */;
INSERT INTO `vocabulary` VALUES ('hsk1_001',1,'爱','ài','รัก','love','ချစ်သည်','我爱你。','audio/hsk1/爱.mp3',1),('hsk1_002',1,'八','bā','แปด','eight','ရှစ်','我有八个苹果。','audio/hsk1/八.mp3',2),('hsk1_003',1,'爸爸','bà ba','พ่อ','father','ဖခင်','这是我爸爸。','audio/hsk1/爸爸.mp3',3),('hsk1_004',1,'杯子','bēi zi','แก้ว','cup/glass','ဖန်ခွက်','请给我一个杯子。','audio/hsk1/杯子.mp3',4),('hsk1_005',1,'北京','běi jīng','ปักกิ่ง','Beijing','ပေကျင်း','我去北京。','audio/hsk1/北京.mp3',5),('hsk1_006',1,'本','běn','เล่ม (หนังสือ)','measure word for books','စာအုပ်','这本书很好。','audio/hsk1/本.mp3',6),('hsk1_007',1,'不','bù','ไม่','not/no','မဟုတ်','我不懂。','audio/hsk1/不.mp3',7),('hsk1_008',1,'菜','cài','อาหาร','dish/vegetable','ဟင်းလျာ','这个菜很好吃。','audio/hsk1/菜.mp3',8),('hsk1_009',1,'吃','chī','กิน','to eat','စားသည်','我想吃饭。','audio/hsk1/吃.mp3',9),('hsk1_010',1,'车','chē','รถ','car/vehicle','ကား','这是我的车。','audio/hsk1/车.mp3',10),('hsk1_011',1,'出租','chū zū','แท็กซี่','taxi','ဓာတ်ဆီ','坐出租去。','audio/hsk1/出租.mp3',11),('hsk1_012',1,'大','dà','ใหญ่','big/large','ကြီးသည်','这个房子很大。','audio/hsk1/大.mp3',12),('hsk1_013',1,'的','de','ของ','possessive particle','ရဲ့','这是我的书。','audio/hsk1/的.mp3',13),('hsk1_014',1,'点','diǎn','จุด/นาฬิกา','o\'clock/point','နာရီ/အချိန်','现在八点。','audio/hsk1/点.mp3',14),('hsk1_015',1,'电脑','diàn nǎo','คอมพิวเตอร์','computer','ကွန်ပျူတာ','我用电脑工作。','audio/hsk1/电脑.mp3',15),('hsk1_016',1,'都','dōu','ทั้งหมด','all/both','အားလုံး','我们都来了。','audio/hsk1/都.mp3',16),('hsk1_017',1,'读','dú','อ่าน','to read','ဖတ်သည်','我喜欢读书。','audio/hsk1/读.mp3',17),('hsk1_018',1,'多','duō','หลาย/มาก','many/much','များသည်','我有很多朋友。','audio/hsk1/多.mp3',18),('hsk1_019',1,'二','èr','สอง','two','နှစ်','我有两个哥哥。','audio/hsk1/二.mp3',19),('hsk1_020',1,'饭','fàn','ข้าว','meal/rice','ထမင်း','吃饭了吗？','audio/hsk1/饭.mp3',20);
/*!40000 ALTER TABLE `vocabulary` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-25  4:39:32
