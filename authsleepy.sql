-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: 127.0.0.1    Database: authsleepy
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `authsleepy`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `authsleepy` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `authsleepy`;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `hashed_password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `work` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `gender` enum('male','female') DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `weight` float DEFAULT NULL,
  `height` float DEFAULT NULL,
  `blood_pressure_systolic` int(11) DEFAULT NULL,
  `blood_pressure_diastolic` int(11) DEFAULT NULL,
  `daily_steps` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'user@example.com','$2b$12$MfhZ65j/aTONGBZCRH9S4uh3lOKqOgqFJArbMcRsqSXrhzglRDVmm','2024-07-07 17:24:42','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,'user1@example.com','$2b$12$viU2D8/SiaS6ZPIYrO8KOeHQwYpea7BawsJ1Rcaf6qui7l0gtmGEm','2024-07-07 18:51:19','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,'use21@example.com','$2b$12$4EruOZSXa6C.dByVH/JsUONw8zqkce0LEbVZYTX9lkYnBfAQkF5Ze','2024-07-07 18:54:06','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,'momo90@gmail.com','$2b$12$PKFh25N1scsXM3lKeZLRzeRUoSoK5vhgMmVZpDzLlIEQx9NlOJAXy','2024-07-08 04:38:34','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(5,'pasal','$2b$12$8l.1IdO6c188nAusgVlqoeoGfYI04l4whP2yK4r/hTXlS.4g11yVu','2024-07-08 04:55:01','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(8,'pasal@gmail.com','$2b$12$mIPmgth/JzgKDL.xC7zwdeYPudU.cMKNR61bb29jvdWfPo27lY/2a','2024-07-08 04:56:08','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9,'p','$2b$12$5EqnCduzVOngwRR7IUhvhOBMrs/oG5ub/21g1T10UNHvComk2/g1q','2024-07-08 05:00:20','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(10,'admin123@gmail.com','$2b$12$roKDOdI51MIS.Bq2DOLRKeAItPv9B7BSrgPTotVASK7D3ZHDZjKgq','2024-07-08 10:59:10','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(11,'p@gmail.com','$2b$12$x4nMx7xKuzVfJnTRlZ6niOA0jBm0fWcfcg6ax2DdWKaHAVAtpqhi6','2024-07-08 11:01:58','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(12,'o@gmail.com','$2b$12$Ve3yMYdaic4ufkdKwJMW/Ox3.aDfOfM6QRLqRVPGFLlcfx3lEtkmu','2024-07-08 11:56:48','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-24 16:36:23
