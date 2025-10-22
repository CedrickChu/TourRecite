-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: tourrecite
-- ------------------------------------------------------
-- Server version	8.0.34

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
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add tag',7,'add_tag'),(26,'Can change tag',7,'change_tag'),(27,'Can delete tag',7,'delete_tag'),(28,'Can view tag',7,'view_tag'),(29,'Can add post',8,'add_post'),(30,'Can change post',8,'change_post'),(31,'Can delete post',8,'delete_post'),(32,'Can view post',8,'view_post'),(33,'Can add rating',9,'add_rating'),(34,'Can change rating',9,'change_rating'),(35,'Can delete rating',9,'delete_rating'),(36,'Can view rating',9,'view_rating'),(37,'Can add user profile',10,'add_userprofile'),(38,'Can change user profile',10,'change_userprofile'),(39,'Can delete user profile',10,'delete_userprofile'),(40,'Can view user profile',10,'view_userprofile'),(41,'Can add association',11,'add_association'),(42,'Can change association',11,'change_association'),(43,'Can delete association',11,'delete_association'),(44,'Can view association',11,'view_association'),(45,'Can add code',12,'add_code'),(46,'Can change code',12,'change_code'),(47,'Can delete code',12,'delete_code'),(48,'Can view code',12,'view_code'),(49,'Can add nonce',13,'add_nonce'),(50,'Can change nonce',13,'change_nonce'),(51,'Can delete nonce',13,'delete_nonce'),(52,'Can view nonce',13,'view_nonce'),(53,'Can add user social auth',14,'add_usersocialauth'),(54,'Can change user social auth',14,'change_usersocialauth'),(55,'Can delete user social auth',14,'delete_usersocialauth'),(56,'Can view user social auth',14,'view_usersocialauth'),(57,'Can add partial',15,'add_partial'),(58,'Can change partial',15,'change_partial'),(59,'Can delete partial',15,'delete_partial'),(60,'Can view partial',15,'view_partial'),(61,'Can add collection',16,'add_collection'),(62,'Can change collection',16,'change_collection'),(63,'Can delete collection',16,'delete_collection'),(64,'Can view collection',16,'view_collection'),(65,'Can add review',17,'add_review'),(66,'Can change review',17,'change_review'),(67,'Can delete review',17,'delete_review'),(68,'Can view review',17,'view_review');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$1000000$ikb0dfJml0LJQyetsf3gui$qVnyO8eVFNv5UKvIKFaRYbJfZbAtl2BGCDXTVGNqazc=','2025-10-22 14:46:20.961754',1,'admin','','','admin@gmail.com',1,1,'2025-10-21 15:36:09.282541'),(2,'pbkdf2_sha256$1000000$XHnuXwi9dg4yZKMdWlHA3U$xbAUXe/MFaf1YHBPbsDvHBnNGqoilobmvzO0JwWVRNQ=','2025-10-22 15:45:12.051746',0,'cedrickchu123','','','',0,1,'2025-10-21 15:46:56.111018'),(3,'pbkdf2_sha256$1000000$9ou1Ppx87d7jthUAsjazGC$ftN5wtWo4TotP21+kFW4ENsPZWCtnFjCgeAsENVQBag=','2025-10-22 15:33:02.033696',0,'cedrickchu321','','','cedrickchu321@gmail.com',0,1,'2025-10-22 15:00:11.230681'),(4,'pbkdf2_sha256$1000000$55JKOL8lVSA8J21vdZ4HGx$mGCovERefA2wll8K30F5W9n/3j3x2WpF4XvBE5ajo5I=',NULL,0,'admin123','','','admin123@gmail.com',0,1,'2025-10-22 15:01:08.252833'),(5,'pbkdf2_sha256$1000000$iUwys0eqvdC8uG3MRwzLnr$0lag7JHKej3K8OZ3hqGDlzlgGmTjYyGcBSmdZED3GiI=',NULL,0,'adminadmin','','','adminadmin@gmail.com',0,1,'2025-10-22 15:04:57.376990');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2025-10-22 13:48:43.842568','24','Hidden Viewpoint',2,'[{\"changed\": {\"fields\": [\"Rating\"]}}]',8,1),(2,'2025-10-22 13:48:43.842568','23','Beautiful Beach',2,'[{\"changed\": {\"fields\": [\"Rating\"]}}]',8,1),(3,'2025-10-22 13:48:43.851019','22','Stunning seafood',2,'[{\"changed\": {\"fields\": [\"Rating\"]}}]',8,1),(4,'2025-10-22 13:48:43.851019','21','Delicious local delicacies',2,'[{\"changed\": {\"fields\": [\"Rating\"]}}]',8,1),(5,'2025-10-22 13:48:43.851019','20','Scenic local delicacies',2,'[{\"changed\": {\"fields\": [\"Rating\"]}}]',8,1),(6,'2025-10-22 13:48:43.855568','17','Amazing seafood',2,'[{\"changed\": {\"fields\": [\"Rating\"]}}]',8,1),(7,'2025-10-22 13:48:43.857653','16','Stunning River',2,'[{\"changed\": {\"fields\": [\"Rating\"]}}]',8,1),(8,'2025-10-22 13:48:43.858654','15','Popular tropical fruits',2,'[{\"changed\": {\"fields\": [\"Rating\"]}}]',8,1),(9,'2025-10-22 13:48:43.859654','14','Hidden tamilok',2,'[{\"changed\": {\"fields\": [\"Rating\"]}}]',8,1),(10,'2025-10-22 13:48:43.861379','13','Stunning Trail',2,'[{\"changed\": {\"fields\": [\"Rating\"]}}]',8,1),(11,'2025-10-22 13:48:43.863409','12','Popular tropical fruits',2,'[{\"changed\": {\"fields\": [\"Rating\"]}}]',8,1),(12,'2025-10-22 13:48:43.864409','11','Hidden grilled fish',2,'[{\"changed\": {\"fields\": [\"Rating\"]}}]',8,1),(13,'2025-10-22 13:48:43.865408','10','Scenic Beach',2,'[{\"changed\": {\"fields\": [\"Rating\"]}}]',8,1),(14,'2025-10-22 14:46:49.615288','24','Hidden Viewpoint',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',8,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(16,'projectapp','collection'),(8,'projectapp','post'),(9,'projectapp','rating'),(17,'projectapp','review'),(7,'projectapp','tag'),(10,'projectapp','userprofile'),(6,'sessions','session'),(11,'social_django','association'),(12,'social_django','code'),(13,'social_django','nonce'),(15,'social_django','partial'),(14,'social_django','usersocialauth');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-10-21 15:35:54.832947'),(2,'auth','0001_initial','2025-10-21 15:35:55.218732'),(3,'admin','0001_initial','2025-10-21 15:35:55.319559'),(4,'admin','0002_logentry_remove_auto_add','2025-10-21 15:35:55.322060'),(5,'admin','0003_logentry_add_action_flag_choices','2025-10-21 15:35:55.331793'),(6,'contenttypes','0002_remove_content_type_name','2025-10-21 15:35:55.392182'),(7,'auth','0002_alter_permission_name_max_length','2025-10-21 15:35:55.441594'),(8,'auth','0003_alter_user_email_max_length','2025-10-21 15:35:55.463783'),(9,'auth','0004_alter_user_username_opts','2025-10-21 15:35:55.470792'),(10,'auth','0005_alter_user_last_login_null','2025-10-21 15:35:55.516102'),(11,'auth','0006_require_contenttypes_0002','2025-10-21 15:35:55.521851'),(12,'auth','0007_alter_validators_add_error_messages','2025-10-21 15:35:55.522862'),(13,'auth','0008_alter_user_username_max_length','2025-10-21 15:35:55.596703'),(14,'auth','0009_alter_user_last_name_max_length','2025-10-21 15:35:55.657793'),(15,'auth','0010_alter_group_name_max_length','2025-10-21 15:35:55.672970'),(16,'auth','0011_update_proxy_permissions','2025-10-21 15:35:55.678975'),(17,'auth','0012_alter_user_first_name_max_length','2025-10-21 15:35:55.726991'),(18,'projectapp','0001_initial','2025-10-21 15:35:56.162604'),(19,'sessions','0001_initial','2025-10-21 15:35:56.193793'),(20,'default','0001_initial','2025-10-21 15:35:56.322013'),(21,'social_auth','0001_initial','2025-10-21 15:35:56.329556'),(22,'default','0002_add_related_name','2025-10-21 15:35:56.337127'),(23,'social_auth','0002_add_related_name','2025-10-21 15:35:56.337127'),(24,'default','0003_alter_email_max_length','2025-10-21 15:35:56.349834'),(25,'social_auth','0003_alter_email_max_length','2025-10-21 15:35:56.351774'),(26,'default','0004_auto_20160423_0400','2025-10-21 15:35:56.356936'),(27,'social_auth','0004_auto_20160423_0400','2025-10-21 15:35:56.362413'),(28,'social_auth','0005_auto_20160727_2333','2025-10-21 15:35:56.372660'),(29,'social_django','0006_partial','2025-10-21 15:35:56.397348'),(30,'social_django','0007_code_timestamp','2025-10-21 15:35:56.422819'),(31,'social_django','0008_partial_timestamp','2025-10-21 15:35:56.451999'),(32,'social_django','0009_auto_20191118_0520','2025-10-21 15:35:56.492954'),(33,'social_django','0010_uid_db_index','2025-10-21 15:35:56.511963'),(34,'social_django','0011_alter_id_fields','2025-10-21 15:35:56.723871'),(35,'social_django','0012_usersocialauth_extra_data_new','2025-10-21 15:35:56.811740'),(36,'social_django','0013_migrate_extra_data','2025-10-21 15:35:56.824407'),(37,'social_django','0014_remove_usersocialauth_extra_data','2025-10-21 15:35:56.848973'),(38,'social_django','0015_rename_extra_data_new_usersocialauth_extra_data','2025-10-21 15:35:56.873010'),(39,'social_django','0016_alter_usersocialauth_extra_data','2025-10-21 15:35:56.883229'),(40,'social_django','0017_usersocialauth_user_social_auth_uid_required','2025-10-21 15:35:56.934098'),(41,'social_django','0003_alter_email_max_length','2025-10-21 15:35:56.937597'),(42,'social_django','0005_auto_20160727_2333','2025-10-21 15:35:56.939599'),(43,'social_django','0004_auto_20160423_0400','2025-10-21 15:35:56.941215'),(44,'social_django','0002_add_related_name','2025-10-21 15:35:56.942747'),(45,'social_django','0001_initial','2025-10-21 15:35:56.943741'),(46,'projectapp','0002_userprofile_email','2025-10-21 15:57:53.169192'),(47,'projectapp','0003_collection','2025-10-22 11:08:33.914401'),(48,'projectapp','0004_post_rating','2025-10-22 13:46:41.484137'),(49,'projectapp','0005_alter_userprofile_email','2025-10-22 15:05:34.796781'),(50,'projectapp','0006_review','2025-10-22 15:46:47.340243'),(51,'projectapp','0007_alter_review_rating','2025-10-22 15:59:23.164514'),(52,'projectapp','0008_remove_review_rating','2025-10-22 16:03:52.314586');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('0aqlnk7mw3bglrvqntbaqytnb7qc1mmn','e30:1vBaMh:Ff0wT3-Y2r5x76H-ZKSYTZKK-BHFo8CG8hC6kD-UJQk','2025-11-05 15:03:03.187891'),('q69yz5e306ya8bmxuy8cskxp4hb8sopj','e30:1vBaOF:_OYZ9rvSJiblCWpSndHmkkobGbdAzSZG4JbohAF2qlY','2025-11-05 15:04:39.209826'),('raian50xjbo5nrrg5hbq8bgdusaxjiqv','.eJxVjDEOwjAMRe-SGUUljkvCyN4zRI5tSAGlUtNOiLtDpQ6w_vfef5lE61LS2nROo5izcebwu2Xih9YNyJ3qbbI81WUes90Uu9Nmh0n0edndv4NCrXxrRgbqGSWHTpiDRwceEQgjsA-9glBHgBkwaqYTBbjSUdUTZ3UxmvcH8Yo4ig:1vBb1U:VeVKysP_jbU6ppPMxkK-vl2hOrYxZ9SpECflnCDW5eg','2025-11-05 15:45:12.056262'),('tiflodwwo8j3nic02tljehekmg91rec3','e30:1vBaNq:aRZi_-dyyie9qM-duoNgn6QfBwQNTikGS9eAG79St1A','2025-11-05 15:04:14.733145'),('x5pq4tso03jmmw5t66jw7232onueojc2','e30:1vBYzW:O0jphR5uth_OLnwxTl9ClMfnRK98eYn0mShNL7uASCU','2025-11-05 13:35:02.067110');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projectapp_collection`
--

DROP TABLE IF EXISTS `projectapp_collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projectapp_collection` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` longtext,
  `created_at` datetime(6) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `projectapp_collection_user_id_name_3ec10a32_uniq` (`user_id`,`name`),
  CONSTRAINT `projectapp_collection_user_id_2423c140_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projectapp_collection`
--

LOCK TABLES `projectapp_collection` WRITE;
/*!40000 ALTER TABLE `projectapp_collection` DISABLE KEYS */;
INSERT INTO `projectapp_collection` VALUES (1,'My Travel List',NULL,'2025-10-22 11:16:38.458728',2),(2,'My Travel List',NULL,'2025-10-22 13:48:47.149822',1),(3,'My Travel List',NULL,'2025-10-22 15:08:21.462706',3);
/*!40000 ALTER TABLE `projectapp_collection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projectapp_collection_posts`
--

DROP TABLE IF EXISTS `projectapp_collection_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projectapp_collection_posts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `collection_id` bigint NOT NULL,
  `post_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `projectapp_collection_posts_collection_id_post_id_761dcf13_uniq` (`collection_id`,`post_id`),
  KEY `projectapp_collectio_post_id_e4f0111a_fk_projectap` (`post_id`),
  CONSTRAINT `projectapp_collectio_collection_id_585a9a7f_fk_projectap` FOREIGN KEY (`collection_id`) REFERENCES `projectapp_collection` (`id`),
  CONSTRAINT `projectapp_collectio_post_id_e4f0111a_fk_projectap` FOREIGN KEY (`post_id`) REFERENCES `projectapp_post` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projectapp_collection_posts`
--

LOCK TABLES `projectapp_collection_posts` WRITE;
/*!40000 ALTER TABLE `projectapp_collection_posts` DISABLE KEYS */;
INSERT INTO `projectapp_collection_posts` VALUES (27,1,9),(11,1,11),(25,1,14),(23,1,15),(22,1,16),(15,1,20),(14,1,21),(18,1,22),(32,1,23),(20,1,24),(31,2,24),(33,3,19),(34,3,20);
/*!40000 ALTER TABLE `projectapp_collection_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projectapp_post`
--

DROP TABLE IF EXISTS `projectapp_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projectapp_post` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `content` longtext NOT NULL,
  `category` varchar(20) NOT NULL,
  `image` varchar(100) DEFAULT NULL,
  `latitude` decimal(9,6) NOT NULL,
  `longitude` decimal(9,6) NOT NULL,
  `estimated_price` decimal(10,2) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` int NOT NULL,
  `rating` decimal(3,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `projectapp_post_user_id_8e4ed227_fk_auth_user_id` (`user_id`),
  CONSTRAINT `projectapp_post_user_id_8e4ed227_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projectapp_post`
--

LOCK TABLES `projectapp_post` WRITE;
/*!40000 ALTER TABLE `projectapp_post` DISABLE KEYS */;
INSERT INTO `projectapp_post` VALUES (1,'Scenic grilled fish','Try the hidden tropical fruits at local spots in Puerto Princesa.','food','',9.728781,118.743628,333.00,'2025-10-21 15:36:13.607737','2025-10-21 15:36:13.607737',1,0.00),(2,'Beautiful Garden','Experience the amazing trail in Puerto Princesa.','tourist','',9.737426,118.727633,370.00,'2025-10-21 15:38:18.513955','2025-10-21 15:38:18.513955',1,0.00),(3,'Popular tropical fruits','Try the amazing grilled fish at local spots in Puerto Princesa.','food','',9.726616,118.719555,638.00,'2025-10-21 15:38:36.137529','2025-10-21 15:38:36.137529',1,0.00),(4,'Popular River','Experience the scenic market in Puerto Princesa.','tourist','',9.743417,118.744821,427.00,'2025-10-21 15:38:57.119668','2025-10-21 15:38:57.119668',1,0.00),(5,'Amazing Cafe','Experience the scenic market in Puerto Princesa.','tourist','posts/placeholder_1.jpg',9.733185,118.740203,247.00,'2025-10-21 15:39:14.048877','2025-10-21 15:39:14.060982',1,0.00),(6,'Popular Viewpoint','Experience the scenic garden in Puerto Princesa.','tourist','posts/placeholder_2.jpg',9.739296,118.719672,123.00,'2025-10-21 15:39:14.064180','2025-10-21 15:39:14.070681',1,0.00),(7,'Stunning Garden','Experience the beautiful island in Puerto Princesa.','tourist','posts/placeholder_3.jpg',9.731328,118.718134,125.00,'2025-10-21 15:39:14.073081','2025-10-21 15:39:14.082054',1,0.00),(8,'Popular Market','Experience the hidden beach in Puerto Princesa.','tourist','posts/placeholder_4.jpg',9.724817,118.747491,430.00,'2025-10-21 15:39:14.085039','2025-10-21 15:39:14.092856',1,0.00),(9,'Beautiful River','Experience the delicious market in Puerto Princesa.','tourist','posts/placeholder_5.jpg',9.732618,118.748799,339.00,'2025-10-21 15:39:14.095859','2025-10-21 15:39:14.101692',1,0.00),(10,'Scenic Beach','Experience the scenic restaurant in Puerto Princesa.','tourist','posts/placeholder_6.jpg',9.759263,118.742826,131.00,'2025-10-21 15:39:14.105745','2025-10-22 13:48:43.864409',1,4.80),(11,'Hidden grilled fish','Try the delicious seafood at local spots in Puerto Princesa.','food','posts/placeholder_7.jpg',9.759701,118.750663,113.00,'2025-10-21 15:39:14.113861','2025-10-22 13:48:43.863409',1,4.70),(12,'Popular tropical fruits','Try the beautiful tropical fruits at local spots in Puerto Princesa.','food','posts/placeholder_8.jpg',9.724614,118.750905,652.00,'2025-10-21 15:39:14.125429','2025-10-22 13:48:43.862406',1,4.60),(13,'Stunning Trail','Experience the stunning market in Puerto Princesa.','tourist','posts/placeholder_9.jpg',9.750041,118.716087,303.00,'2025-10-21 15:39:14.134687','2025-10-22 13:48:43.859654',1,4.20),(14,'Hidden tamilok','Try the beautiful grilled fish at local spots in Puerto Princesa.','food','posts/placeholder_10.jpg',9.740986,118.724065,464.00,'2025-10-21 15:39:14.143539','2025-10-22 13:48:43.859654',1,4.10),(15,'Popular tropical fruits','Try the delicious tropical fruits at local spots in Puerto Princesa.','food','posts/placeholder_11.jpg',9.749144,118.720636,172.00,'2025-10-21 15:39:14.150763','2025-10-22 13:48:43.857653',1,3.30),(16,'Stunning River','Experience the scenic trail in Puerto Princesa.','tourist','posts/placeholder_12.jpg',9.748264,118.722243,273.00,'2025-10-21 15:39:14.159224','2025-10-22 13:48:43.856635',1,3.00),(17,'Amazing seafood','Try the stunning local delicacies at local spots in Puerto Princesa.','food','posts/placeholder_13.jpg',9.749845,118.726992,600.00,'2025-10-21 15:39:14.171402','2025-10-22 13:48:43.855135',1,2.00),(18,'Amazing Cafe','Experience the delicious park in Puerto Princesa.','tourist','posts/placeholder_14.jpg',9.749767,118.729411,406.00,'2025-10-21 15:39:14.178942','2025-10-21 15:39:14.186424',1,0.00),(19,'Scenic Beach','Experience the stunning museum in Puerto Princesa.','tourist','posts/placeholder_15.jpg',9.721469,118.735314,179.00,'2025-10-21 15:39:14.188961','2025-10-21 15:39:14.195808',1,0.00),(20,'Scenic local delicacies','Try the scenic tropical fruits at local spots in Puerto Princesa.','food','posts/placeholder_16.jpg',9.738197,118.740412,733.00,'2025-10-21 15:39:14.198872','2025-10-22 13:48:43.851019',1,4.00),(21,'Delicious local delicacies','Try the beautiful seafood at local spots in Puerto Princesa.','food','posts/placeholder_17.jpg',9.726555,118.742095,371.00,'2025-10-21 15:39:14.207105','2025-10-22 13:48:43.851019',1,4.00),(22,'Stunning seafood','Try the beautiful tamilok at local spots in Puerto Princesa.','food','posts/placeholder_18.jpg',9.743835,118.727690,241.00,'2025-10-21 15:39:14.214827','2025-10-22 13:48:43.842568',1,2.00),(23,'Beautiful Beach','Experience the popular cafe in Puerto Princesa.','tourist','posts/placeholder_19.jpg',9.747180,118.751859,59.00,'2025-10-21 15:39:14.225458','2025-10-22 13:48:43.842568',1,3.00),(24,'Hidden Viewpoint','Experience the stunning museum in Puerto Princesa.','tourist','posts/placeholder.png',9.722167,118.745789,295.00,'2025-10-21 15:39:14.236855','2025-10-22 14:46:49.612630',1,4.00);
/*!40000 ALTER TABLE `projectapp_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projectapp_post_tags`
--

DROP TABLE IF EXISTS `projectapp_post_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projectapp_post_tags` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint NOT NULL,
  `tag_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `projectapp_post_tags_post_id_tag_id_c6dd76dc_uniq` (`post_id`,`tag_id`),
  KEY `projectapp_post_tags_tag_id_47666ee6_fk_projectapp_tag_id` (`tag_id`),
  CONSTRAINT `projectapp_post_tags_post_id_6ab05c60_fk_projectapp_post_id` FOREIGN KEY (`post_id`) REFERENCES `projectapp_post` (`id`),
  CONSTRAINT `projectapp_post_tags_tag_id_47666ee6_fk_projectapp_tag_id` FOREIGN KEY (`tag_id`) REFERENCES `projectapp_tag` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projectapp_post_tags`
--

LOCK TABLES `projectapp_post_tags` WRITE;
/*!40000 ALTER TABLE `projectapp_post_tags` DISABLE KEYS */;
INSERT INTO `projectapp_post_tags` VALUES (1,1,72),(2,1,74),(3,2,24),(4,2,62),(5,3,40),(6,3,85),(8,4,7),(7,4,59),(9,5,48),(10,5,90),(12,6,63),(11,6,84),(14,7,44),(13,7,51),(15,7,69),(17,8,36),(16,8,81),(18,9,14),(19,10,27),(20,11,3),(21,11,78),(22,12,55),(23,12,63),(25,13,30),(24,13,44),(26,14,53),(27,14,62),(28,14,95),(30,15,12),(29,15,89),(32,16,1),(33,16,21),(31,16,64),(34,17,42),(35,18,56),(38,19,23),(36,19,42),(37,19,61),(40,20,62),(39,20,83),(41,21,25),(42,21,39),(43,21,63),(44,22,27),(47,23,52),(46,23,72),(45,23,80),(49,24,27),(48,24,33),(50,24,69);
/*!40000 ALTER TABLE `projectapp_post_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projectapp_rating`
--

DROP TABLE IF EXISTS `projectapp_rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projectapp_rating` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `value` int NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `post_id` bigint NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `projectapp_rating_post_id_ae54fb7d_fk_projectapp_post_id` (`post_id`),
  KEY `projectapp_rating_user_id_0ee3698a_fk_auth_user_id` (`user_id`),
  CONSTRAINT `projectapp_rating_post_id_ae54fb7d_fk_projectapp_post_id` FOREIGN KEY (`post_id`) REFERENCES `projectapp_post` (`id`),
  CONSTRAINT `projectapp_rating_user_id_0ee3698a_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projectapp_rating`
--

LOCK TABLES `projectapp_rating` WRITE;
/*!40000 ALTER TABLE `projectapp_rating` DISABLE KEYS */;
INSERT INTO `projectapp_rating` VALUES (1,4,'2025-10-22 14:46:20.961754',24,1);
/*!40000 ALTER TABLE `projectapp_rating` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projectapp_review`
--

DROP TABLE IF EXISTS `projectapp_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projectapp_review` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `comment` longtext NOT NULL,
  `image` varchar(100) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `post_id` bigint NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `projectapp_review_post_id_4a30488e_fk_projectapp_post_id` (`post_id`),
  KEY `projectapp_review_user_id_33850561_fk_auth_user_id` (`user_id`),
  CONSTRAINT `projectapp_review_post_id_4a30488e_fk_projectapp_post_id` FOREIGN KEY (`post_id`) REFERENCES `projectapp_post` (`id`),
  CONSTRAINT `projectapp_review_user_id_33850561_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projectapp_review`
--

LOCK TABLES `projectapp_review` WRITE;
/*!40000 ALTER TABLE `projectapp_review` DISABLE KEYS */;
/*!40000 ALTER TABLE `projectapp_review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projectapp_tag`
--

DROP TABLE IF EXISTS `projectapp_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projectapp_tag` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projectapp_tag`
--

LOCK TABLES `projectapp_tag` WRITE;
/*!40000 ALTER TABLE `projectapp_tag` DISABLE KEYS */;
INSERT INTO `projectapp_tag` VALUES (48,'Adventure'),(13,'Adventure Park'),(87,'Art Gallery'),(17,'Bakery'),(74,'Bakery Tour'),(26,'Bar'),(66,'Barbecue'),(1,'Beach'),(78,'Boat Tour'),(61,'Brewery'),(50,'Brunch'),(40,'Budget Travel'),(16,'Cafe'),(28,'Camping'),(60,'Cheese'),(59,'Chocolate'),(10,'Church'),(52,'Cocktail Bar'),(24,'Coffee'),(73,'Coffee Tasting'),(69,'Cooking Class'),(47,'Cultural'),(80,'Cultural Show'),(33,'Cycling'),(23,'Dessert'),(62,'Distillery'),(30,'Diving'),(84,'Eco Tourism'),(72,'Ethnic Cuisine'),(42,'Family Friendly'),(57,'Farm to Table'),(22,'Fast Food'),(37,'Festival'),(15,'Fine Dining'),(94,'Fishing'),(68,'Food Festival'),(46,'Food Tour'),(11,'Garden'),(58,'Gourmet'),(45,'Hidden Gems'),(27,'Hiking'),(7,'Historic Site'),(86,'Historical Walk'),(83,'Hot Air Balloon'),(53,'Ice Cream'),(3,'Island'),(85,'Island Hopping'),(55,'Juice Bar'),(93,'Kayaking'),(4,'Lake'),(18,'Local Cuisine'),(88,'Local Handicraft'),(56,'Local Market'),(41,'Luxury Travel'),(2,'Mountain'),(90,'Mountain Climbing'),(8,'Museum'),(81,'Music Festival'),(6,'National Park'),(38,'Nightlife'),(82,'Paragliding'),(44,'Pet Friendly'),(36,'Photography'),(96,'Photography Tour'),(75,'Restaurant Hop'),(35,'Road Trip'),(43,'Romantic'),(77,'Scenic Hike'),(19,'Seafood'),(64,'Seafood Market'),(39,'Shopping'),(34,'Sightseeing'),(32,'Skiing'),(54,'Smoothies'),(29,'Snorkeling'),(95,'Snorkeling Spots'),(14,'Street Food'),(67,'Street Snacks'),(76,'Sunset View'),(31,'Surfing'),(65,'Sushi'),(25,'Tea'),(63,'Tea House'),(9,'Temple'),(89,'Temple Festival'),(71,'Traditional Food'),(91,'Underground Caves'),(21,'Vegan'),(20,'Vegetarian'),(92,'Water Sports'),(5,'Waterfall'),(49,'Weekend Getaway'),(79,'Wildlife Safari'),(70,'Wine & Dine'),(51,'Wine Tasting'),(12,'Zoo');
/*!40000 ALTER TABLE `projectapp_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projectapp_userprofile`
--

DROP TABLE IF EXISTS `projectapp_userprofile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projectapp_userprofile` (
  `user_id` int NOT NULL,
  `first_name` varchar(150) DEFAULT NULL,
  `last_name` varchar(150) DEFAULT NULL,
  `about_me` longtext,
  `profile_image` varchar(100) DEFAULT NULL,
  `first_login` tinyint(1) NOT NULL,
  `email` varchar(254) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `projectapp_userprofile_user_id_af881818_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projectapp_userprofile`
--

LOCK TABLES `projectapp_userprofile` WRITE;
/*!40000 ALTER TABLE `projectapp_userprofile` DISABLE KEYS */;
INSERT INTO `projectapp_userprofile` VALUES (2,'John Cedrick','Chu',NULL,'profile_images/default.png',0,''),(3,'Cedrick','Chu',NULL,'',0,NULL);
/*!40000 ALTER TABLE `projectapp_userprofile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projectapp_userprofile_tags`
--

DROP TABLE IF EXISTS `projectapp_userprofile_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projectapp_userprofile_tags` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `userprofile_id` int NOT NULL,
  `tag_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `projectapp_userprofile_tags_userprofile_id_tag_id_854295ff_uniq` (`userprofile_id`,`tag_id`),
  KEY `projectapp_userprofile_tags_tag_id_a33e6790_fk_projectapp_tag_id` (`tag_id`),
  CONSTRAINT `projectapp_userprofi_userprofile_id_4b889312_fk_projectap` FOREIGN KEY (`userprofile_id`) REFERENCES `projectapp_userprofile` (`user_id`),
  CONSTRAINT `projectapp_userprofile_tags_tag_id_a33e6790_fk_projectapp_tag_id` FOREIGN KEY (`tag_id`) REFERENCES `projectapp_tag` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projectapp_userprofile_tags`
--

LOCK TABLES `projectapp_userprofile_tags` WRITE;
/*!40000 ALTER TABLE `projectapp_userprofile_tags` DISABLE KEYS */;
INSERT INTO `projectapp_userprofile_tags` VALUES (3,2,16),(5,2,28),(1,2,40),(2,2,47),(8,2,52),(9,2,68),(6,2,72),(7,2,73),(4,2,80),(10,3,3),(14,3,15),(16,3,24),(12,3,40),(13,3,42),(15,3,52),(11,3,68),(17,3,94);
/*!40000 ALTER TABLE `projectapp_userprofile_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `social_auth_association`
--

DROP TABLE IF EXISTS `social_auth_association`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `social_auth_association` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `server_url` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `secret` varchar(255) NOT NULL,
  `issued` int NOT NULL,
  `lifetime` int NOT NULL,
  `assoc_type` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `social_auth_association_server_url_handle_078befa2_uniq` (`server_url`,`handle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `social_auth_association`
--

LOCK TABLES `social_auth_association` WRITE;
/*!40000 ALTER TABLE `social_auth_association` DISABLE KEYS */;
/*!40000 ALTER TABLE `social_auth_association` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `social_auth_code`
--

DROP TABLE IF EXISTS `social_auth_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `social_auth_code` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `code` varchar(32) NOT NULL,
  `verified` tinyint(1) NOT NULL,
  `timestamp` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `social_auth_code_email_code_801b2d02_uniq` (`email`,`code`),
  KEY `social_auth_code_code_a2393167` (`code`),
  KEY `social_auth_code_timestamp_176b341f` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `social_auth_code`
--

LOCK TABLES `social_auth_code` WRITE;
/*!40000 ALTER TABLE `social_auth_code` DISABLE KEYS */;
/*!40000 ALTER TABLE `social_auth_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `social_auth_nonce`
--

DROP TABLE IF EXISTS `social_auth_nonce`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `social_auth_nonce` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `server_url` varchar(255) NOT NULL,
  `timestamp` int NOT NULL,
  `salt` varchar(65) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `social_auth_nonce_server_url_timestamp_salt_f6284463_uniq` (`server_url`,`timestamp`,`salt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `social_auth_nonce`
--

LOCK TABLES `social_auth_nonce` WRITE;
/*!40000 ALTER TABLE `social_auth_nonce` DISABLE KEYS */;
/*!40000 ALTER TABLE `social_auth_nonce` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `social_auth_partial`
--

DROP TABLE IF EXISTS `social_auth_partial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `social_auth_partial` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `token` varchar(32) NOT NULL,
  `next_step` smallint unsigned NOT NULL,
  `backend` varchar(32) NOT NULL,
  `timestamp` datetime(6) NOT NULL,
  `data` json NOT NULL DEFAULT (_utf8mb4'{}'),
  PRIMARY KEY (`id`),
  KEY `social_auth_partial_token_3017fea3` (`token`),
  KEY `social_auth_partial_timestamp_50f2119f` (`timestamp`),
  CONSTRAINT `social_auth_partial_chk_1` CHECK ((`next_step` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `social_auth_partial`
--

LOCK TABLES `social_auth_partial` WRITE;
/*!40000 ALTER TABLE `social_auth_partial` DISABLE KEYS */;
/*!40000 ALTER TABLE `social_auth_partial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `social_auth_usersocialauth`
--

DROP TABLE IF EXISTS `social_auth_usersocialauth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `social_auth_usersocialauth` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `provider` varchar(32) NOT NULL,
  `uid` varchar(255) NOT NULL,
  `user_id` int NOT NULL,
  `created` datetime(6) NOT NULL,
  `modified` datetime(6) NOT NULL,
  `extra_data` json NOT NULL DEFAULT (_utf8mb4'{}'),
  PRIMARY KEY (`id`),
  UNIQUE KEY `social_auth_usersocialauth_provider_uid_e6b5e668_uniq` (`provider`,`uid`),
  KEY `social_auth_usersocialauth_user_id_17d28448_fk_auth_user_id` (`user_id`),
  KEY `social_auth_usersocialauth_uid_796e51dc` (`uid`),
  CONSTRAINT `social_auth_usersocialauth_user_id_17d28448_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `user_social_auth_uid_required` CHECK ((`uid` <> _utf8mb4''))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `social_auth_usersocialauth`
--

LOCK TABLES `social_auth_usersocialauth` WRITE;
/*!40000 ALTER TABLE `social_auth_usersocialauth` DISABLE KEYS */;
/*!40000 ALTER TABLE `social_auth_usersocialauth` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-23  0:47:28
