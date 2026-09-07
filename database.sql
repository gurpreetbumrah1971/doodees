-- Doodee's database schema + reference data (categories, menu, admin account).
-- Generated 2026-09-06 from the live menu. Import this into a fresh, empty
-- database via phpMyAdmin before pointing config.local.php at it.
--
-- Deliberately excludes customer/order/cashback data - a new database starts
-- with zero customers and zero orders.
--
-- Default admin login is admin / admin123 (see config.php ADMIN_DEFAULT_*).
-- Change the password immediately after your first login.

-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: spice_restaurant
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
-- Table structure for table `admin`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(191) NOT NULL,
  `password` varchar(191) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Admin_username_key` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cashbacktransaction`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cashbacktransaction` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customerId` int(11) NOT NULL,
  `orderId` int(11) DEFAULT NULL,
  `type` enum('EARNED','REDEEMED','ADJUSTED') NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `balanceAfter` decimal(10,2) NOT NULL,
  `note` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  PRIMARY KEY (`id`),
  KEY `cashback_orderId_idx` (`orderId`),
  KEY `CashbackTransaction_customerId_createdAt_idx` (`customerId`,`createdAt`),
  CONSTRAINT `CashbackTransaction_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `customer` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `CashbackTransaction_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `order` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `category`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `image` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Category_name_key` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `customer`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mobileNumber` varchar(191) NOT NULL,
  `name` varchar(191) DEFAULT NULL,
  `cashbackBalance` decimal(10,2) NOT NULL DEFAULT 0.00,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3),
  `referralCode` varchar(191) DEFAULT NULL,
  `birthday` datetime(3) DEFAULT NULL,
  `anniversary` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Customer_mobileNumber_key` (`mobileNumber`),
  UNIQUE KEY `Customer_referralCode_key` (`referralCode`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `customeraddress`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customeraddress` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customerId` int(11) NOT NULL,
  `label` varchar(191) NOT NULL,
  `address` text NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `CustomerAddress_customerId_idx` (`customerId`),
  CONSTRAINT `CustomerAddress_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `customer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `customerotp`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customerotp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mobileNumber` varchar(191) NOT NULL,
  `code` varchar(191) NOT NULL,
  `expiresAt` datetime(3) NOT NULL,
  `consumedAt` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `customerId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customerotp_customerId_idx` (`customerId`),
  KEY `CustomerOtp_mobileNumber_code_idx` (`mobileNumber`,`code`),
  CONSTRAINT `CustomerOtp_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `customer` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fooditem`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fooditem` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `image` varchar(191) DEFAULT NULL,
  `isVeg` tinyint(1) NOT NULL DEFAULT 1,
  `categoryId` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `isAvailable` tinyint(1) NOT NULL DEFAULT 1,
  `sortOrder` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `FoodItem_categoryId_fkey` (`categoryId`),
  CONSTRAINT `FoodItem_categoryId_fkey` FOREIGN KEY (`categoryId`) REFERENCES `category` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=297 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `orderNumber` varchar(191) NOT NULL,
  `customerName` varchar(191) NOT NULL,
  `mobileNumber` varchar(191) NOT NULL,
  `whatsappNumber` varchar(191) DEFAULT NULL,
  `email` varchar(191) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `tableNumber` varchar(191) DEFAULT NULL,
  `orderType` enum('DINE_IN','TAKEAWAY','DELIVERY') NOT NULL,
  `paymentMethod` enum('CASH','UPI','CARD') NOT NULL,
  `totalAmount` decimal(10,2) NOT NULL,
  `gstAmount` decimal(10,2) NOT NULL,
  `discountAmount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `grandTotal` decimal(10,2) NOT NULL,
  `status` enum('PENDING','PREPARING','COMPLETED','DELIVERED','CANCELLED') NOT NULL DEFAULT 'PENDING',
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `anniversary` datetime(3) DEFAULT NULL,
  `birthday` datetime(3) DEFAULT NULL,
  `confirmedAt` datetime(3) DEFAULT NULL,
  `preparationStartedAt` datetime(3) DEFAULT NULL,
  `preparationMinutes` int(11) DEFAULT NULL,
  `readyAt` datetime(3) DEFAULT NULL,
  `deliveredAt` datetime(3) DEFAULT NULL,
  `customerSessionToken` varchar(191) DEFAULT NULL,
  `customerSessionExpiresAt` datetime(3) DEFAULT NULL,
  `customerId` int(11) DEFAULT NULL,
  `cashbackRedeemed` decimal(10,2) NOT NULL DEFAULT 0.00,
  `cashbackEarned` decimal(10,2) NOT NULL DEFAULT 0.00,
  `referralCode` varchar(191) DEFAULT NULL,
  `referrerId` int(11) DEFAULT NULL,
  `referralDiscount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `whatsappMessageId` varchar(191) DEFAULT NULL,
  `whatsappStatus` varchar(191) DEFAULT NULL,
  `whatsappStatusAt` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Order_orderNumber_key` (`orderNumber`),
  KEY `Order_customerId_fkey` (`customerId`),
  KEY `Order_referrerId_fkey` (`referrerId`),
  CONSTRAINT `Order_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `customer` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Order_referrerId_fkey` FOREIGN KEY (`referrerId`) REFERENCES `customer` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orderitem`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orderitem` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `orderId` int(11) NOT NULL,
  `foodItemId` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unitPrice` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `OrderItem_orderId_fkey` (`orderId`),
  KEY `OrderItem_foodItemId_fkey` (`foodItemId`),
  CONSTRAINT `OrderItem_foodItemId_fkey` FOREIGN KEY (`foodItemId`) REFERENCES `fooditem` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `OrderItem_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `order` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-06 21:17:32

-- Reference data: admin account, categories, menu items

-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: spice_restaurant
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` (`id`, `username`, `password`, `createdAt`) VALUES (10,'admin','$2y$12$qkOmyQIZoTeix2PoXx1njONMyb2cDcYI50qTuwldr3GubCJ7R4COa','2026-08-23 13:00:14.578');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` (`id`, `name`, `image`, `createdAt`, `updatedAt`) VALUES (35,'Beverages','/food/iced-tea.png','2026-05-18 12:11:18.778','2026-08-19 13:19:19.979');
INSERT INTO `category` (`id`, `name`, `image`, `createdAt`, `updatedAt`) VALUES (38,'Egg Dishes','/food/generated/egg-omelet-realistic.png','2026-08-02 12:22:07.079','2026-08-19 13:19:20.000');
INSERT INTO `category` (`id`, `name`, `image`, `createdAt`, `updatedAt`) VALUES (43,'Burgers','/assets/logo.png','2026-09-05 14:05:51.000','2026-09-05 14:05:51.000');
INSERT INTO `category` (`id`, `name`, `image`, `createdAt`, `updatedAt`) VALUES (44,'Chicken Wings','/assets/logo.png','2026-09-05 15:10:37.000','2026-09-05 15:10:37.000');
INSERT INTO `category` (`id`, `name`, `image`, `createdAt`, `updatedAt`) VALUES (45,'Pies & Tarts','/assets/logo.png','2026-09-05 15:14:54.000','2026-09-05 15:14:54.000');
INSERT INTO `category` (`id`, `name`, `image`, `createdAt`, `updatedAt`) VALUES (46,'Puff Pastry Pies','/assets/logo.png','2026-09-05 15:18:18.000','2026-09-05 15:18:18.000');
INSERT INTO `category` (`id`, `name`, `image`, `createdAt`, `updatedAt`) VALUES (47,'Desserts','/assets/logo.png','2026-09-05 15:20:31.000','2026-09-05 15:20:31.000');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `fooditem`
--

LOCK TABLES `fooditem` WRITE;
/*!40000 ALTER TABLE `fooditem` DISABLE KEYS */;
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (222,'Iced Tea','Chilled lemon infused iced tea.',69.00,'/food/iced-tea.png',1,35,'2026-05-18 12:11:18.784','2026-08-19 13:19:20.095',1,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (259,'Chicken Smash Burger (Single Patty)','Thin, crispy-edged chicken patty smashed on the grill.',159.00,'/assets/food/generated/chicken-smash-burger.webp',0,43,'2026-09-05 14:05:51.000','2026-09-05 14:05:51.000',1,1);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (260,'Chicken Cheese Burger','Thick, juicy chicken patty burger.',199.00,'/assets/food/generated/chicken-smash-burger.webp',0,43,'2026-09-05 14:05:51.000','2026-09-05 14:05:51.000',1,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (261,'Juicy Lucy Burger','Cheese-stuffed chicken patty burger, molten in the middle.',249.00,'/assets/food/generated/juicy-lucy-burger.webp',0,43,'2026-09-05 14:05:51.000','2026-09-05 14:05:51.000',1,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (262,'Grilled Chicken Burger','Grilled chicken breast burger.',249.00,'/assets/logo.png',0,43,'2026-09-05 14:05:51.000','2026-09-05 14:05:51.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (263,'Pulled Chicken Burger','Slow-cooked pulled chicken burger.',249.00,'/assets/logo.png',0,43,'2026-09-05 14:05:51.000','2026-09-05 14:05:51.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (264,'Grilled Paneer Burger','Spiced paneer tikka patty burger.',229.00,'/assets/logo.png',1,43,'2026-09-05 14:05:51.000','2026-09-05 14:05:51.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (265,'Eggs Benedict','Poached eggs on toast with hollandaise sauce.',129.00,'/assets/logo.png',0,38,'2026-09-05 15:07:20.000','2026-09-05 15:07:20.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (266,'Spanish Omelette','Omelette with onion, tomato, and bell pepper.',129.00,'/assets/logo.png',0,38,'2026-09-05 15:07:20.000','2026-09-05 15:07:20.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (267,'Souffle Omelette','Light, fluffy whipped-egg omelette.',129.00,'/assets/logo.png',0,38,'2026-09-05 15:07:20.000','2026-09-05 15:07:20.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (268,'OG Buffalo Sauce Chicken Wings','Classic buffalo sauce tossed chicken wings.',179.00,'/assets/food/generated/og-buffalo-sauce-wings.webp',0,44,'2026-09-05 15:10:37.000','2026-09-05 15:10:37.000',1,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (269,'Sticky BBQ Chicken Wings','Chicken wings glazed in sticky BBQ sauce.',179.00,'/assets/food/generated/sticky-bbq-wings.webp',0,44,'2026-09-05 15:10:37.000','2026-09-05 15:10:37.000',1,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (270,'Teriyaki Chicken Wings','Chicken wings glazed in teriyaki sauce.',179.00,'/assets/food/generated/teriyaki-chicken-wings.webp',0,44,'2026-09-05 15:10:37.000','2026-09-05 15:10:37.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (271,'Lemon Pepper Chicken Wings','Chicken wings tossed in lemon pepper seasoning.',179.00,'/assets/logo.png',0,44,'2026-09-05 15:10:37.000','2026-09-05 15:10:37.000',1,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (272,'Fried Chicken Wings','Classic crispy fried chicken wings.',179.00,'/assets/logo.png',0,44,'2026-09-05 15:10:37.000','2026-09-05 15:10:37.000',1,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (273,'Apple Pie','Classic baked apple pie.',99.00,'/assets/logo.png',1,45,'2026-09-05 15:14:54.000','2026-09-05 15:14:54.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (274,'Chocolate Coconut Pie','Chocolate pie with coconut filling.',99.00,'/assets/logo.png',1,45,'2026-09-05 15:14:54.000','2026-09-05 15:14:54.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (275,'Chocolate Toffee Pie','Chocolate pie with toffee filling.',99.00,'/assets/logo.png',1,45,'2026-09-05 15:14:54.000','2026-09-05 15:14:54.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (276,'Chocolate Biscoff Pie','Chocolate pie with Biscoff filling.',99.00,'/assets/logo.png',1,45,'2026-09-05 15:14:54.000','2026-09-05 15:14:54.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (277,'Cherry Pie','Classic baked cherry pie.',99.00,'/assets/food/generated/cherry-pie.webp',1,45,'2026-09-05 15:14:54.000','2026-09-05 15:14:54.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (278,'Strawberry Pie','Classic baked strawberry pie.',99.00,'/assets/logo.png',1,45,'2026-09-05 15:14:54.000','2026-09-05 15:14:54.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (279,'Sheperds Pie','Savory minced filling topped with mashed potato.',149.00,'/assets/logo.png',0,45,'2026-09-05 15:14:54.000','2026-09-05 15:14:54.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (280,'Lemon Tart','Tart with lemon curd filling.',99.00,'/assets/logo.png',1,45,'2026-09-05 15:14:54.000','2026-09-05 15:14:54.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (281,'Pineapple Tart','Tart with pineapple filling.',99.00,'/assets/logo.png',1,45,'2026-09-05 15:14:54.000','2026-09-05 15:14:54.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (282,'Chicken Mushroom Cheese Pie','Puff pastry pie with chicken, mushroom, and cheese filling.',149.00,'/assets/logo.png',0,46,'2026-09-05 15:18:18.000','2026-09-05 15:18:18.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (283,'Paneer Mushroom Cheese Pie','Puff pastry pie with paneer, mushroom, and cheese filling.',149.00,'/assets/logo.png',1,46,'2026-09-05 15:18:18.000','2026-09-05 15:18:18.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (284,'Chocolate Pie','Puff pastry pie with chocolate filling.',99.00,'/assets/logo.png',1,46,'2026-09-05 15:18:18.000','2026-09-05 15:18:18.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (285,'Tiramisu','Coffee-soaked layered Italian dessert.',129.00,'/assets/logo.png',1,47,'2026-09-05 15:20:31.000','2026-09-05 15:20:31.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (286,'Tres Leches','Sponge cake soaked in three kinds of milk.',129.00,'/assets/logo.png',1,47,'2026-09-05 15:20:31.000','2026-09-05 15:20:31.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (287,'Caramel Custard','Baked custard with caramel topping.',79.00,'/assets/food/generated/caramel-custard.webp',1,47,'2026-09-05 15:20:31.000','2026-09-05 15:20:31.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (288,'Mochi Icecream','Ice cream wrapped in soft mochi.',129.00,'/assets/logo.png',1,47,'2026-09-05 15:20:31.000','2026-09-05 15:20:31.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (289,'Glazed Doughnut','Classic glazed doughnut.',69.00,'/assets/food/generated/glazed-doughnut.webp',1,47,'2026-09-05 15:22:01.000','2026-09-05 15:22:01.000',1,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (290,'Chocolate Doughnut','Doughnut with chocolate glaze.',69.00,'/assets/food/generated/chocolate-doughnut.webp',1,47,'2026-09-05 15:22:01.000','2026-09-05 15:22:01.000',1,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (291,'Brownie','Fudgy chocolate brownie.',129.00,'/assets/food/generated/brownie.webp',1,47,'2026-09-05 15:22:01.000','2026-09-05 15:22:01.000',0,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (292,'Iced Latte','Chilled espresso with milk over ice.',129.00,'/assets/food/generated/iced-latte.webp',1,35,'2026-09-05 20:25:44.000','2026-09-05 20:25:44.000',1,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (293,'Chicken Smash Burger (Double Patty)','Thin, crispy-edged chicken patties smashed on the grill - two patties.',219.00,'/assets/food/generated/chicken-smash-burger.webp',0,43,'2026-09-06 15:31:22.000','2026-09-06 15:31:22.000',1,1);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (294,'Chicken Smash Burger (Triple Patty)','Thin, crispy-edged chicken patties smashed on the grill - three patties.',279.00,'/assets/food/generated/chicken-smash-burger.webp',0,43,'2026-09-06 15:31:22.000','2026-09-06 15:31:22.000',1,1);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (295,'Pancake','Fluffy pancakes served with syrup.',129.00,'/assets/food/generated/pancake.webp',1,47,'2026-09-06 18:16:38.000','2026-09-06 18:16:38.000',1,0);
INSERT INTO `fooditem` (`id`, `name`, `description`, `price`, `image`, `isVeg`, `categoryId`, `createdAt`, `updatedAt`, `isAvailable`, `sortOrder`) VALUES (296,'Waffle','Classic golden waffle.',129.00,'/assets/food/generated/waffle.webp',1,47,'2026-09-06 18:16:38.000','2026-09-06 18:16:38.000',1,0);
/*!40000 ALTER TABLE `fooditem` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-06 21:17:32
