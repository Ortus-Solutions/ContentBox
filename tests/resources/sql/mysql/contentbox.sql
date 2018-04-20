# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: Localhost (MySQL 5.7.14)
# Database: contentbox
# Generation Time: 2018-03-20 14:49:07 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

USE `contentbox`;

# Dump of table cb_author
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_author`;

CREATE TABLE `cb_author` (
  `authorID` int(11) NOT NULL AUTO_INCREMENT,
  `firstName` varchar(100) NOT NULL,
  `lastName` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `isActive` bit(1) NOT NULL DEFAULT b'0',
  `lastLogin` datetime DEFAULT NULL,
  `createdDate` datetime NOT NULL,
  `biography` longtext,
  `preferences` longtext,
  `FK_roleID` int(11) NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `isPasswordReset` bit(1) NOT NULL DEFAULT b'0',
  `is2FactorAuth` bit(1) NOT NULL DEFAULT b'0',
  `APIToken` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`authorID`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `APIToken` (`APIToken`),
  KEY `FK6847396B9724FA40` (`FK_roleID`),
  KEY `idx_active` (`isActive`),
  KEY `idx_email` (`email`),
  KEY `idx_login` (`username`,`password`,`isActive`),
  KEY `idx_activeAuthor` (`isActive`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`),
  KEY `idx_passwordReset` (`isPasswordReset`),
  KEY `idx_apitoken` (`APIToken`),
  KEY `idx_2factorauth` (`is2FactorAuth`),
  CONSTRAINT `FK6847396B9724FA40` FOREIGN KEY (`FK_roleID`) REFERENCES `cb_role` (`roleID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_author` WRITE;
/*!40000 ALTER TABLE `cb_author` DISABLE KEYS */;

INSERT INTO `cb_author` (`authorID`, `firstName`, `lastName`, `email`, `username`, `password`, `isActive`, `lastLogin`, `createdDate`, `biography`, `preferences`, `FK_roleID`, `modifiedDate`, `isDeleted`, `isPasswordReset`, `is2FactorAuth`, `APIToken`)
VALUES
	(1,'Luis','Majano','lmajano@gmail.com','lmajano','$2a$12$KU4n4ZQf3cd/ULCuvc8PIO9VrQKi7eKbcEuQaILTJ/sdcjXvT31YK',b'1','2017-08-04 17:49:58','2013-07-11 11:06:39','','{\"sidemenuCollapse\":\"yes\",\"linkedin\":\"\",\"sidebarState\":\"yes\",\"markup\":\"HTML\",\"website\":\"\",\"editor\":\"ckeditor\",\"twitter\":\"http://twitter.com/lmajano\",\"facebook\":\"http://facebook.com/lmajano\"}',2,'2017-08-04 17:49:58',b'0',b'0',b'1','04AF40069044B3625811EF6C4399CC4DC3EBA390FB5F4CD25D16FA7B592C81189A8B29459CD5EDC021073D619BFEDC12EFA3F6A1395B89CE880B8D936CA88DF4'),
	(2,'Lui','Majano','lmajano@ortussolutions.com','luismajano','$2a$12$KU4n4ZQf3cd/ULCuvc8PIO9VrQKi7eKbcEuQaILTJ/sdcjXvT31YK',b'1','2015-07-29 14:38:46','2013-07-11 11:07:23','','{\"GOOGLE\":\"\",\"EDITOR\":\"ckeditor\",\"TWITTER\":\"http:\\/\\/twitter.com\\/lmajano\",\"FACEBOOK\":\"http:\\/\\/facebook.com\\/lmajano\"}',2,'2017-06-21 18:29:30',b'0',b'0',b'0','A2707287EC2849AC4BF63E3D75286B1BAD81A23726D62899694F66BBC497E4E9EA3895F22BF8B36F3165C2F4CC3197D5163F9BC172FEE39A45C93CE640970D9C'),
	(3,'Tester','Majano','lmajano@testing.com','testermajano','$2a$12$FE058d9bj7Sv6tPmvZMaleC2x8.b.tRqVei5p/5XqPytSNpF5eCym',b'1','2017-07-06 12:13:14','2013-07-11 11:07:23','','{\"sidemenuCollapse\":\"no\",\"google\":\"\",\"sidebarState\":\"true\",\"markup\":\"HTML\",\"editor\":\"ckeditor\",\"twitter\":\"http://twitter.com/lmajano\",\"facebook\":\"http://facebook.com/lmajano\"}',1,'2017-07-18 15:22:13',b'0',b'1',b'1','1DD3F7B17C26C3DD750ABD3DFDEE5E3404DF8B96028CD16FD741B2B6C45D501FE93EED010B94B8FF2A33CFCB8B9FCF7D7B492B8ECF24E61E70072848E34023CA'),
	(4,'Joe','Joe','joejoe@joe.com','joejoe','$2a$12$.FrcqDLb3DNIK2TqJo0aQuwB3WSxAW0KmJUKKPaAQV7VoYwihDM1.',b'1','2017-07-06 11:38:28','2017-07-06 11:30:59','','{\"linkedin\":\"\",\"markup\":\"HTML\",\"website\":\"\",\"editor\":\"ckeditor\",\"twitter\":\"\",\"facebook\":\"\"}',2,'2017-07-06 11:54:11',b'0',b'1',b'1','488AB7F5CEF6CBF977C8D21FD1AC973C9163E1AE5D1D37EF23A3371614619E1F7851AFB5C0AC9AD4BD3F99FD44208872BB3E64455C91A0C395DA5F0AEB0F3E4D'),
	(5,'Jorge','Morelos','joremorelos@morelos.com','joremorelos@morelos.com','$2a$12$IBAYihdRG.Hj8fh/fztmi.MvFRn2lPxk4Thw1mnmbVzjoLnNCgzOe',b'0',NULL,'2017-07-06 12:07:02','','{\"linkedin\":\"\",\"markup\":\"HTML\",\"website\":\"\",\"editor\":\"ckeditor\",\"twitter\":\"\",\"facebook\":\"\"}',2,'2017-07-19 17:01:18',b'0',b'1',b'0','0123971AF933E4406919693283CFB83C2494A3DC8F21565F84BEF4BD54F81916A9CE13F4C1F0745C5654CEB1CA28678C9B5AD92575F50459864C3EA3C6DA84EA');

/*!40000 ALTER TABLE `cb_author` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_authorPermissionGroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_authorPermissionGroups`;

CREATE TABLE `cb_authorPermissionGroups` (
  `FK_authorID` int(11) NOT NULL,
  `FK_permissionGroupID` int(11) NOT NULL,
  KEY `FK7443FC0EAA6AC0EA` (`FK_authorID`),
  KEY `FK7443FC0EF4497DC2` (`FK_permissionGroupID`),
  CONSTRAINT `FK7443FC0EAA6AC0EA` FOREIGN KEY (`FK_authorID`) REFERENCES `cb_author` (`authorID`),
  CONSTRAINT `FK7443FC0EF4497DC2` FOREIGN KEY (`FK_permissionGroupID`) REFERENCES `cb_permissionGroup` (`permissionGroupID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_authorPermissionGroups` WRITE;
/*!40000 ALTER TABLE `cb_authorPermissionGroups` DISABLE KEYS */;

INSERT INTO `cb_authorPermissionGroups` (`FK_authorID`, `FK_permissionGroupID`)
VALUES
	(4,1),
	(5,1),
	(5,2);

/*!40000 ALTER TABLE `cb_authorPermissionGroups` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_authorPermissions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_authorPermissions`;

CREATE TABLE `cb_authorPermissions` (
  `FK_authorID` int(11) NOT NULL,
  `FK_permissionID` int(11) NOT NULL,
  KEY `FKE167E219AA6AC0EA` (`FK_authorID`),
  KEY `FKE167E21937C1A3F2` (`FK_permissionID`),
  CONSTRAINT `FKE167E21937C1A3F2` FOREIGN KEY (`FK_permissionID`) REFERENCES `cb_permission` (`permissionID`),
  CONSTRAINT `FKE167E219AA6AC0EA` FOREIGN KEY (`FK_authorID`) REFERENCES `cb_author` (`authorID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_authorPermissions` WRITE;
/*!40000 ALTER TABLE `cb_authorPermissions` DISABLE KEYS */;

INSERT INTO `cb_authorPermissions` (`FK_authorID`, `FK_permissionID`)
VALUES
	(3,36),
	(3,45),
	(3,42),
	(3,41),
	(3,40),
	(3,44);

/*!40000 ALTER TABLE `cb_authorPermissions` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_category
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_category`;

CREATE TABLE `cb_category` (
  `categoryID` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(200) NOT NULL,
  `slug` varchar(200) NOT NULL,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`categoryID`),
  UNIQUE KEY `slug` (`slug`),
  KEY `idx_slug` (`slug`),
  KEY `idx_categorySlug` (`slug`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_category` WRITE;
/*!40000 ALTER TABLE `cb_category` DISABLE KEYS */;

INSERT INTO `cb_category` (`categoryID`, `category`, `slug`, `createdDate`, `modifiedDate`, `isDeleted`)
VALUES
	(2,'ColdFusion','coldfusion','2016-05-03 16:23:25','2016-05-03 16:23:25',b'0'),
	(4,'ContentBox','contentbox','2016-05-03 16:23:25','2016-05-03 16:23:25',b'0'),
	(5,'coldbox','coldbox','2016-05-03 16:23:25','2016-05-03 16:23:25',b'0');

/*!40000 ALTER TABLE `cb_category` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_comment
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_comment`;

CREATE TABLE `cb_comment` (
  `commentID` int(11) NOT NULL AUTO_INCREMENT,
  `content` longtext NOT NULL,
  `author` varchar(100) NOT NULL,
  `authorIP` varchar(100) NOT NULL,
  `authorEmail` varchar(255) NOT NULL,
  `authorURL` varchar(255) DEFAULT NULL,
  `createdDate` datetime NOT NULL,
  `isApproved` bit(1) NOT NULL DEFAULT b'0',
  `FK_contentID` int(11) NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`commentID`),
  KEY `FKFFCED27F91F58374` (`FK_contentID`),
  KEY `idx_approved` (`isApproved`),
  KEY `idx_contentComment` (`isApproved`,`FK_contentID`),
  KEY `idx_createdDate` (`createdDate`),
  KEY `idx_commentCreatedDate` (`createdDate`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`),
  CONSTRAINT `FKFFCED27F91F58374` FOREIGN KEY (`FK_contentID`) REFERENCES `cb_content` (`contentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_comment` WRITE;
/*!40000 ALTER TABLE `cb_comment` DISABLE KEYS */;

INSERT INTO `cb_comment` (`commentID`, `content`, `author`, `authorIP`, `authorEmail`, `authorURL`, `createdDate`, `isApproved`, `FK_contentID`, `modifiedDate`, `isDeleted`)
VALUES
	(9,'Thsi is my gmail test','Luis Majano','127.0.0.1','lmajano@gmail.com','http://www.ortussolutions.com','2014-06-18 17:22:59',b'0',142,'2017-06-13 17:10:42',b'0'),
	(10,'This is a test','Luis Majano','127.0.0.1','lmajano@ortussolutions.com','','2014-10-23 13:21:38',b'1',141,'2016-05-03 16:23:25',b'0'),
	(11,'Test','Luis','','lmajano@gmail.com','','2015-08-04 16:17:43',b'1',142,'2016-05-03 16:23:25',b'0'),
	(12,'test','Luis Majano','127.0.0.1','lmajano@gmail.com','','2016-05-11 16:12:33',b'1',141,'2016-05-11 16:12:33',b'0'),
	(13,'test','Luis Majano','127.0.0.1','lmajano@ortussolutions.com','','2016-05-12 12:34:17',b'1',141,'2016-05-12 12:34:17',b'0'),
	(14,'My awesome comment','Luis Majano','127.0.0.1','lmajano@gmail.com','','2016-11-28 15:35:51',b'1',142,'2016-11-28 15:35:51',b'0'),
	(15,'non logged in user test','Pio','127.0.0.1','lmajano@gmail.com','','2016-11-28 15:39:46',b'1',142,'2016-11-28 15:39:46',b'0');

/*!40000 ALTER TABLE `cb_comment` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_commentSubscriptions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_commentSubscriptions`;

CREATE TABLE `cb_commentSubscriptions` (
  `subscriptionID` int(11) NOT NULL,
  `FK_contentID` int(11) NOT NULL,
  PRIMARY KEY (`subscriptionID`),
  KEY `FK41716EB71D33B614` (`subscriptionID`),
  KEY `FK41716EB791F58374` (`FK_contentID`),
  KEY `idx_contentCommentSubscription` (`FK_contentID`),
  CONSTRAINT `FK41716EB71D33B614` FOREIGN KEY (`subscriptionID`) REFERENCES `cb_subscriptions` (`subscriptionID`),
  CONSTRAINT `FK41716EB791F58374` FOREIGN KEY (`FK_contentID`) REFERENCES `cb_content` (`contentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_commentSubscriptions` WRITE;
/*!40000 ALTER TABLE `cb_commentSubscriptions` DISABLE KEYS */;

INSERT INTO `cb_commentSubscriptions` (`subscriptionID`, `FK_contentID`)
VALUES
	(5,141),
	(6,141),
	(4,142);

/*!40000 ALTER TABLE `cb_commentSubscriptions` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_content
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_content`;

CREATE TABLE `cb_content` (
  `contentID` int(11) NOT NULL AUTO_INCREMENT,
  `contentType` varchar(255) NOT NULL,
  `title` varchar(200) NOT NULL,
  `slug` varchar(200) NOT NULL,
  `createdDate` datetime NOT NULL,
  `publishedDate` datetime DEFAULT NULL,
  `expireDate` datetime DEFAULT NULL,
  `isPublished` bit(1) NOT NULL DEFAULT b'1',
  `allowComments` bit(1) NOT NULL DEFAULT b'1',
  `passwordProtection` varchar(100) DEFAULT NULL,
  `HTMLKeywords` varchar(160) DEFAULT NULL,
  `HTMLDescription` varchar(160) DEFAULT NULL,
  `cache` bit(1) NOT NULL DEFAULT b'1',
  `cacheLayout` bit(1) NOT NULL DEFAULT b'1',
  `cacheTimeout` int(11) DEFAULT '0',
  `cacheLastAccessTimeout` int(11) DEFAULT '0',
  `markup` varchar(100) NOT NULL DEFAULT 'HTML',
  `FK_authorID` int(11) NOT NULL,
  `FK_parentID` int(11) DEFAULT NULL,
  `showInSearch` bit(1) NOT NULL DEFAULT b'1',
  `featuredImage` varchar(255) DEFAULT NULL,
  `featuredImageURL` varchar(255) DEFAULT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `HTMLTitle` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`contentID`),
  UNIQUE KEY `slug` (`slug`),
  KEY `FKFFE01899AA6AC0EA` (`FK_authorID`),
  KEY `FKFFE018996FDC2C99` (`FK_parentID`),
  KEY `idx_slug` (`slug`),
  KEY `idx_cachelayout` (`cacheLayout`),
  KEY `idx_discriminator` (`contentType`),
  KEY `idx_cachetimeout` (`cacheTimeout`),
  KEY `idx_cache` (`cache`),
  KEY `idx_publishedSlug` (`slug`,`isPublished`),
  KEY `idx_published` (`contentType`,`isPublished`,`passwordProtection`),
  KEY `idx_publishedDate` (`publishedDate`),
  KEY `idx_cachelastaccesstimeout` (`cacheLastAccessTimeout`),
  KEY `idx_createdDate` (`createdDate`),
  KEY `idx_expireDate` (`expireDate`),
  KEY `idx_search` (`title`,`isPublished`),
  KEY `idx_showInSearch` (`showInSearch`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`),
  CONSTRAINT `FKFFE018996FDC2C99` FOREIGN KEY (`FK_parentID`) REFERENCES `cb_content` (`contentID`),
  CONSTRAINT `FKFFE01899AA6AC0EA` FOREIGN KEY (`FK_authorID`) REFERENCES `cb_author` (`authorID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_content` WRITE;
/*!40000 ALTER TABLE `cb_content` DISABLE KEYS */;

INSERT INTO `cb_content` (`contentID`, `contentType`, `title`, `slug`, `createdDate`, `publishedDate`, `expireDate`, `isPublished`, `allowComments`, `passwordProtection`, `HTMLKeywords`, `HTMLDescription`, `cache`, `cacheLayout`, `cacheTimeout`, `cacheLastAccessTimeout`, `markup`, `FK_authorID`, `FK_parentID`, `showInSearch`, `featuredImage`, `featuredImageURL`, `modifiedDate`, `isDeleted`, `HTMLTitle`)
VALUES
	(63,'Entry','An awesome blog entry','an-awesome-blog-entry','2013-07-12 09:53:01','2013-07-20 16:05:46',NULL,b'1',b'1','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(64,'Entry','Another Test','another-test','2013-07-12 09:53:31','2013-07-20 16:39:53',NULL,b'0',b'1','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(65,'Entry','ContentBox Modular CMS at the South Florida CFUG','contentbox-modular-cms-at-the-south-florida-cfug','2012-09-13 15:55:12','2013-07-20 16:39:39',NULL,b'1',b'1','','','',b'1',b'1',0,0,'html',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(67,'Entry','Test with an excerpt','test-with-an-excerpt','2013-07-15 17:56:10','2013-07-20 16:39:39',NULL,b'1',b'1','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(69,'Entry','Updating an ORM entity','updating-an-orm-entity','2013-07-19 18:45:08','2013-07-20 16:39:39',NULL,b'1',b'1','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(86,'Entry','Copy of Updating an ORM entity','copy-of-updating-an-orm-entity','2013-07-20 16:10:43','2013-07-20 16:39:39',NULL,b'1',b'1','','','',b'1',b'1',0,0,'html',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(87,'Entry','Copy of Another Test','copy-of-another-test','2013-07-20 16:12:16','2013-07-20 16:39:39',NULL,b'1',b'1','','','',b'1',b'1',0,0,'html',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(88,'Entry','Copy of Copy of Another Test','copy-of-copy-of-another-test','2013-07-20 16:12:23','2013-07-20 16:12:00',NULL,b'0',b'1','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(109,'Entry','Couchbase Infrastructure','couchbase-infrastructure','2013-07-26 16:53:43','2013-07-26 16:53:00',NULL,b'1',b'1','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(110,'Entry','Couchbase Details','couchbase-details','2013-07-26 16:55:00','2013-10-11 10:31:28',NULL,b'1',b'1','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(111,'ContentStore','First Content Store','first-content-store','2013-08-12 11:59:12','2013-08-12 12:02:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(114,'ContentStore','My News','my-awesome-news','2013-08-14 18:14:43','2013-08-14 18:14:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(122,'ContentStore','blog-sidebar-top','blog-sidebar-top','2013-08-22 20:42:37','2013-08-22 20:42:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(123,'ContentStore','foot','foot','2013-08-22 20:43:59','2013-08-22 20:43:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(124,'ContentStore','support options','support-options-baby','2013-08-22 20:45:19','2013-08-22 20:45:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(127,'ContentStore','FireFox Test','firefox-test','2013-08-29 08:29:36','2013-08-29 08:29:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',3,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(132,'Entry','Couchbase Conference','couchbase-conference','2013-09-13 16:54:52','2013-09-13 16:54:00',NULL,b'1',b'1','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(133,'Entry','Disk Queues','disk-queues','2013-09-13 16:55:05','2013-09-13 16:54:00',NULL,b'1',b'1','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(135,'Entry','This is just awesome','this-is-just-awesome','2013-10-15 16:48:56','2013-10-15 16:48:00',NULL,b'1',b'1','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(141,'Entry','Closures cannot be declared outside of cfscript','closures-cannot-be-declared-outside-of-cfscript','2013-11-11 11:53:03','2013-11-11 11:52:00',NULL,b'1',b'1','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(142,'Entry','Disk Queues ','disk-queues-77CAF','2014-01-31 14:41:16','2014-01-31 14:41:00',NULL,b'1',b'1','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(147,'Page','support','support','2013-07-20 15:38:47','2013-07-20 15:38:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'html',1,NULL,b'1','','','2016-08-05 14:42:30',b'0',NULL),
	(159,'ContentStore','Small Footer','foot/small-footer','2014-09-26 16:00:44','2014-09-26 16:00:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,123,b'1',NULL,NULL,'2016-05-03 16:23:25',b'0',NULL),
	(160,'Page','No Layout Test','no-layout-test','2015-03-29 10:13:59','2015-03-29 10:13:00',NULL,b'1',b'0','test','','',b'1',b'1',0,0,'HTML',1,NULL,b'1','','','2016-08-05 14:42:30',b'0',NULL),
	(162,'Page','No Sidebar','email-test','2015-09-16 10:33:56','2015-09-16 10:33:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1',NULL,NULL,'2016-08-05 14:42:30',b'0',NULL),
	(168,'ContentStore','Lucee 4.5.2.018','lucee-452018','2016-01-14 11:44:58','2016-01-14 11:42:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1','','','2016-05-03 16:23:25',b'0',NULL),
	(169,'ContentStore','Another test','another-test-a161b','2016-01-14 11:45:35','2016-01-14 11:45:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1','','','2016-05-05 15:56:12',b'0',NULL),
	(176,'Page','parent page','parent-page','2016-04-12 09:26:56','2016-04-12 09:26:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1','','','2016-05-03 16:23:25',b'0',NULL),
	(177,'Page','child 1','parent-page/child-1','2016-04-12 09:27:06','2016-04-12 09:27:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,176,b'1','','','2016-05-03 16:23:25',b'0',NULL),
	(189,'Page','node','node','2016-04-12 13:18:51','2016-04-12 13:18:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1','','','2016-08-05 14:42:30',b'0',NULL),
	(190,'Page','child1','node/child1','2016-04-12 13:19:04','2016-04-12 13:18:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,189,b'1','','','2016-05-03 16:23:25',b'0',NULL),
	(191,'Page','child2','node/child2','2016-04-12 13:19:10','2016-04-12 13:19:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,189,b'1','','','2016-05-03 16:23:25',b'0',NULL),
	(192,'Page','Test Markdown','test-markdown','2016-05-05 11:12:23','2016-05-05 11:11:00','2016-05-01 00:00:00',b'0',b'0','','','',b'1',b'1',0,0,'Markdown',1,NULL,b'0','','','2016-08-05 14:42:24',b'0',NULL),
	(206,'Page','products','products','2016-05-18 11:35:32','2017-06-13 17:08:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1','','','2017-06-13 17:08:36',b'0',''),
	(207,'Page','coldbox','products/coldbox','2016-05-18 11:35:32','2013-07-11 11:23:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,206,b'1','','','2016-05-18 11:35:32',b'0',NULL),
	(208,'Page','mini','products/coldbox/mini','2016-05-18 11:35:32','2015-09-22 10:53:23',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,207,b'1','','','2016-05-18 11:35:32',b'0',NULL),
	(209,'Page','services','products/coldbox/services','2016-05-18 11:35:32','2015-09-22 10:53:23',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,207,b'1','','','2016-05-18 11:35:32',b'0',NULL),
	(210,'Page','servers','products/coldbox/services/servers','2016-05-18 11:35:32','2013-07-20 10:40:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,209,b'1','','','2016-05-18 11:35:32',b'0',NULL),
	(211,'Page','More Servers','products/coldbox/services/more-servers','2016-05-18 11:35:32','2013-07-20 10:40:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,209,b'1','','','2016-05-18 11:35:32',b'0',NULL),
	(212,'Page','support','products/coldbox/services/support','2016-05-18 11:35:32','2013-07-20 10:40:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,209,b'1','','','2016-05-18 11:35:32',b'0',NULL),
	(213,'Page','coldbox-new','products/coldbox-new','2016-05-18 11:35:32','2016-04-11 11:32:00',NULL,b'1',b'0','','','',b'1',b'1',0,0,'html',1,206,b'1','','','2016-05-18 11:35:32',b'0',NULL),
	(214,'Page','mini','products/coldbox-new/mini','2016-05-18 11:35:32','2013-08-22 10:23:03',NULL,b'0',b'0','','','',b'1',b'1',0,0,'html',1,213,b'1','','','2016-05-18 11:35:32',b'0',NULL),
	(215,'Page','services','products/coldbox-new/services','2016-05-18 11:35:32','2013-08-22 10:23:03',NULL,b'0',b'0','','','',b'1',b'1',0,0,'html',1,213,b'1','','','2016-05-18 11:35:32',b'0',NULL),
	(216,'Page','servers','products/coldbox-new/services/servers','2016-05-18 11:35:32','2013-08-22 10:23:03',NULL,b'0',b'0','','','',b'1',b'1',0,0,'html',1,215,b'1','','','2016-05-18 11:35:32',b'0',NULL),
	(217,'Page','More Servers','products/coldbox-new/services/more-servers','2016-05-18 11:35:32','2013-08-22 10:23:04',NULL,b'0',b'0','','','',b'1',b'1',0,0,'html',1,215,b'1','','','2016-05-18 11:35:32',b'0',NULL),
	(218,'Page','support','products/coldbox-new/services/support','2016-05-18 11:35:32','2013-08-22 10:23:04',NULL,b'0',b'0','','','',b'1',b'1',0,0,'html',1,215,b'1','','','2016-05-18 11:35:32',b'0',NULL),
	(219,'ContentStore','My Expired Content Store','my-expired-content-store','2018-03-20 09:48:13','2018-03-20 09:47:00','2018-02-01 00:00:00',b'1',b'0','','','',b'1',b'1',0,0,'HTML',1,NULL,b'1','','','2018-03-20 09:48:13',b'0','');

/*!40000 ALTER TABLE `cb_content` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_contentCategories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_contentCategories`;

CREATE TABLE `cb_contentCategories` (
  `FK_contentID` int(11) NOT NULL,
  `FK_categoryID` int(11) NOT NULL,
  KEY `FKD96A0F95F10ECD0` (`FK_categoryID`),
  KEY `FKD96A0F9591F58374` (`FK_contentID`),
  CONSTRAINT `FKD96A0F9591F58374` FOREIGN KEY (`FK_contentID`) REFERENCES `cb_content` (`contentID`),
  CONSTRAINT `FKD96A0F95F10ECD0` FOREIGN KEY (`FK_categoryID`) REFERENCES `cb_category` (`categoryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_contentCategories` WRITE;
/*!40000 ALTER TABLE `cb_contentCategories` DISABLE KEYS */;

INSERT INTO `cb_contentCategories` (`FK_contentID`, `FK_categoryID`)
VALUES
	(114,2),
	(114,4),
	(64,2),
	(64,4),
	(87,2),
	(87,4),
	(88,2),
	(88,4),
	(147,5);

/*!40000 ALTER TABLE `cb_contentCategories` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_contentStore
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_contentStore`;

CREATE TABLE `cb_contentStore` (
  `contentID` int(11) NOT NULL,
  `description` longtext,
  `order` int(11) DEFAULT '0',
  PRIMARY KEY (`contentID`),
  KEY `FKEA4C67C8C960893B` (`contentID`),
  CONSTRAINT `FKEA4C67C8C960893B` FOREIGN KEY (`contentID`) REFERENCES `cb_content` (`contentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_contentStore` WRITE;
/*!40000 ALTER TABLE `cb_contentStore` DISABLE KEYS */;

INSERT INTO `cb_contentStore` (`contentID`, `description`, `order`)
VALUES
	(111,'My very first content',0),
	(114,'Most greatest news',0),
	(122,'',0),
	(123,'footer',0),
	(124,'support options',0),
	(127,'Test',0),
	(159,'A small footer',0),
	(168,'test',0),
	(169,'asdf',0),
	(219,'',0);

/*!40000 ALTER TABLE `cb_contentStore` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_contentVersion
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_contentVersion`;

CREATE TABLE `cb_contentVersion` (
  `contentVersionID` int(11) NOT NULL AUTO_INCREMENT,
  `content` longtext NOT NULL,
  `changelog` longtext,
  `version` int(11) NOT NULL,
  `createdDate` datetime NOT NULL,
  `isActive` bit(1) NOT NULL DEFAULT b'0',
  `FK_authorID` int(11) NOT NULL,
  `FK_contentID` int(11) NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`contentVersionID`),
  KEY `FKE166DFFAA6AC0EA` (`FK_authorID`),
  KEY `FKE166DFF91F58374` (`FK_contentID`),
  KEY `idx_active` (`isActive`),
  KEY `idx_contentVersions` (`isActive`,`FK_contentID`),
  KEY `idx_version` (`version`),
  KEY `idx_createdDate` (`createdDate`),
  KEY `idx_versionCreatedDate` (`createdDate`),
  KEY `idx_activeContentVersion` (`isActive`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`),
  CONSTRAINT `FKE166DFF91F58374` FOREIGN KEY (`FK_contentID`) REFERENCES `cb_content` (`contentID`),
  CONSTRAINT `FKE166DFFAA6AC0EA` FOREIGN KEY (`FK_authorID`) REFERENCES `cb_author` (`authorID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_contentVersion` WRITE;
/*!40000 ALTER TABLE `cb_contentVersion` DISABLE KEYS */;

INSERT INTO `cb_contentVersion` (`contentVersionID`, `content`, `changelog`, `version`, `createdDate`, `isActive`, `FK_authorID`, `FK_contentID`, `modifiedDate`, `isDeleted`)
VALUES
	(122,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Test',1,'2013-07-12 09:53:01',b'1',1,63,'2016-05-03 16:23:25',b'0'),
	(123,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2013-07-12 09:53:31',b'0',1,64,'2016-05-03 16:23:25',b'0'),
	(124,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',2,'2013-07-12 09:53:40',b'1',1,64,'2016-05-03 16:23:25',b'0'),
	(125,'I am glad to go back to my adoptive home, Miami next week and present at the South Florida CFUG on <a href=\"http://gocontentbox.org\">ContentBox Modular CMS</a> September 20th, 2012.  We will be showcasing our next ContentBox version 1.0.7 and have some great goodies for everybody.  <a href=\"http://www.gocontentbox.org/blog/south-florida-cfug-presentation\">You can read all about the event here</a>.  Hope to see you there!','Imported content',1,'2013-04-07 10:45:28',b'1',1,65,'2016-05-03 16:23:25',b'0'),
	(133,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2013-07-15 17:56:10',b'1',1,67,'2016-05-03 16:23:25',b'0'),
	(140,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','quick save',1,'2013-07-19 18:45:08',b'0',1,69,'2016-05-03 16:23:25',b'0'),
	(141,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','What up daugh!',2,'2013-07-19 18:45:28',b'1',1,69,'2016-05-03 16:23:25',b'0'),
	(158,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Content Cloned!',1,'2013-07-20 16:10:43',b'1',1,86,'2016-05-03 16:23:25',b'0'),
	(159,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Content Cloned!',1,'2013-07-20 16:12:16',b'1',1,87,'2016-05-03 16:23:25',b'0'),
	(160,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Content Cloned!',1,'2013-07-20 16:12:23',b'0',1,88,'2016-05-03 16:23:25',b'0'),
	(163,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','quick save',2,'2013-07-26 12:58:21',b'0',1,88,'2016-05-03 16:23:25',b'0'),
	(164,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','quick save',3,'2013-07-26 12:59:43',b'0',1,88,'2016-05-03 16:23:25',b'0'),
	(165,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',4,'2013-07-26 13:00:05',b'0',1,88,'2016-05-03 16:23:25',b'0'),
	(166,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',5,'2013-07-26 13:00:21',b'0',1,88,'2016-05-03 16:23:25',b'0'),
	(168,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','quick save',6,'2013-07-26 13:02:18',b'0',1,88,'2016-05-03 16:23:25',b'0'),
	(169,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n','quick save',7,'2013-07-26 13:02:34',b'0',1,88,'2016-05-03 16:23:25',b'0'),
	(170,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>TESTT</p>\r\n\r\n<p>&nbsp;</p>\r\n','quick save',8,'2013-07-26 13:02:38',b'0',1,88,'2016-05-03 16:23:25',b'0'),
	(171,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n','quick save',9,'2013-07-26 13:02:51',b'0',1,88,'2016-05-03 16:23:25',b'0'),
	(172,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n','Editor Change Quick Save',10,'2013-07-26 13:03:02',b'0',1,88,'2016-05-03 16:23:25',b'0'),
	(173,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n','quick save',11,'2013-07-26 13:03:09',b'0',1,88,'2016-05-03 16:23:25',b'0'),
	(174,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','quick save',12,'2013-07-26 13:04:31',b'1',1,88,'2016-05-03 16:23:25',b'0'),
	(193,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2013-07-26 16:53:43',b'1',1,109,'2016-05-03 16:23:25',b'0'),
	(194,'<p>{{{ContentStore slug=\'contentbox\'}}}</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2013-07-26 16:55:00',b'0',1,110,'2016-05-03 16:23:25',b'0'),
	(195,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','quick save',1,'2013-08-12 11:59:12',b'0',1,111,'2016-05-03 16:23:25',b'0'),
	(198,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',4,'2013-08-12 12:18:13',b'0',1,111,'2016-05-03 16:23:25',b'0'),
	(200,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',6,'2013-08-12 12:18:29',b'0',1,111,'2016-05-03 16:23:25',b'0'),
	(215,'<p><widget category=\"\" max=\"5\" searchterm=\"\" title=\"\" titlelevel=\"2\" widgetdisplayname=\"RecentEntries\" widgetname=\"RecentEntries\" widgettype=\"Core\" widgetudf=\"renderIt\"><widgetinfobar contenteditable=\"false\"><img align=\"left\" contenteditable=\"false\" height=\"20\" src=\"/modules/contentbox-admin/includes/images/widgets/list.png\" style=\"margin-right:5px;\" width=\"20\" />RecentEntries : max = 5 | titleLevel = 2 | widgetUDF = rende</widgetinfobar></widget></p>\r\n','',1,'2013-08-14 18:14:43',b'0',1,114,'2016-05-03 16:23:25',b'0'),
	(216,'<p><widget category=\"\" max=\"5\" searchterm=\"\" title=\"\" titlelevel=\"2\" widgetdisplayname=\"RecentEntries\" widgetname=\"RecentEntries\" widgettype=\"Core\" widgetudf=\"renderIt\"><widgetinfobar contenteditable=\"false\"><img align=\"left\" contenteditable=\"false\" height=\"20\" src=\"/modules/contentbox-admin/includes/images/widgets/list.png\" style=\"margin-right:5px;\" width=\"20\" />RecentEntries : max = 5 | titleLevel = 2 | widgetUDF = rende</widgetinfobar></widget></p>\r\n','',2,'2013-08-14 18:15:14',b'1',1,114,'2016-05-03 16:23:25',b'0'),
	(221,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Reverting to version 4',7,'2013-08-21 13:43:59',b'0',1,111,'2016-05-03 16:23:25',b'0'),
	(222,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Reverting to version 5',8,'2013-08-21 13:44:18',b'0',1,111,'2016-05-03 16:23:25',b'0'),
	(223,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Reverting to version 6',9,'2013-08-21 13:44:22',b'0',1,111,'2016-05-03 16:23:25',b'0'),
	(224,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Reverting to version 4',10,'2013-08-21 18:15:46',b'0',1,111,'2016-05-03 16:23:25',b'0'),
	(225,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Reverting to version 6',11,'2013-08-21 18:16:55',b'0',1,111,'2016-05-03 16:23:25',b'0'),
	(226,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Reverting to version 9',12,'2013-08-21 18:17:41',b'0',1,111,'2016-05-03 16:23:25',b'0'),
	(227,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Reverting to version 8',13,'2013-08-21 18:18:13',b'0',1,111,'2016-05-03 16:23:25',b'0'),
	(228,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Reverting to version 9',14,'2013-08-21 18:18:29',b'1',1,111,'2016-05-03 16:23:25',b'0'),
	(238,'<p>Sidebar Top</p>\r\n','',1,'2013-08-22 20:42:37',b'1',1,122,'2016-05-03 16:23:25',b'0'),
	(239,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2013-08-22 20:43:59',b'1',1,123,'2016-05-03 16:23:25',b'0'),
	(240,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2013-08-22 20:45:19',b'0',1,124,'2016-05-03 16:23:25',b'0'),
	(263,'Test\r\n\r\nasdf\r\n\r\nasdf','quick save',1,'2013-08-29 08:29:36',b'0',1,127,'2016-05-03 16:23:25',b'0'),
	(264,'Test\r\n\r\nasdf\r\n\r\nasdf','quick save',2,'2013-08-29 08:30:10',b'0',1,127,'2016-05-03 16:23:25',b'0'),
	(265,'Test\r\n\r\nasdf\r\n\r\nasdf','Editor Change Quick Save',3,'2013-08-29 08:30:21',b'0',1,127,'2016-05-03 16:23:25',b'0'),
	(266,'lorem ipsum lorem','quick save',4,'2013-08-29 08:31:17',b'0',1,127,'2016-05-03 16:23:25',b'0'),
	(267,'<p>{{{ContentStore slug=\'contentbox\'}}}</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','quick save',2,'2013-08-29 08:32:16',b'1',1,110,'2016-05-03 16:23:25',b'0'),
	(272,'<p>I am at the conference</p>\r\n','',1,'2013-09-13 16:54:52',b'1',1,132,'2016-05-03 16:23:25',b'0'),
	(273,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2013-09-13 16:55:05',b'1',1,133,'2016-05-03 16:23:25',b'0'),
	(277,'<p>An awesome link</p>\r\n','',1,'2013-10-15 16:48:56',b'1',1,135,'2016-05-03 16:23:25',b'0'),
	(278,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',2,'2013-10-15 16:57:47',b'0',1,124,'2016-05-03 16:23:25',b'0'),
	(279,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',3,'2013-10-15 16:57:56',b'0',1,124,'2016-05-03 16:23:25',b'0'),
	(280,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',4,'2013-10-15 16:58:18',b'0',1,124,'2016-05-03 16:23:25',b'0'),
	(287,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',5,'2013-10-15 17:00:33',b'0',1,124,'2016-05-03 16:23:25',b'0'),
	(288,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',6,'2013-10-15 17:00:52',b'0',1,124,'2016-05-03 16:23:25',b'0'),
	(289,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',7,'2013-10-15 17:03:19',b'0',1,124,'2016-05-03 16:23:25',b'0'),
	(290,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',8,'2013-10-15 17:03:34',b'1',1,124,'2016-05-03 16:23:25',b'0'),
	(305,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2013-11-11 11:53:03',b'0',1,141,'2016-05-03 16:23:25',b'0'),
	(306,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',2,'2013-11-11 11:53:49',b'1',1,141,'2016-05-03 16:23:25',b'0'),
	(315,'<p>This is a test.</p>\r\n','',1,'2014-01-31 14:41:16',b'1',1,142,'2016-05-03 16:23:25',b'0'),
	(326,'<p>lorem ipsum lorem</p>\r\n','quick save',5,'2014-02-05 14:31:57',b'0',1,127,'2016-05-03 16:23:25',b'0'),
	(339,'<p>lorem ipsum lorem</p>\r\n','',6,'2014-07-01 16:44:54',b'1',1,127,'2016-05-03 16:23:25',b'0'),
	(367,'<p>Support services</p>\r\n\r\n<p><widget dropdown=\"false\" emptymessage=\"Sorry, no related content was found.\" rendermethodselect=\"renderIt\" title=\"\" titlelevel=\"2\" widgetdisplayname=\"Related Content\" widgetname=\"RelatedContent\" widgettype=\"Core\" widgetudf=\"renderIt\"><widgetinfobar contenteditable=\"false\"><img align=\"left\" contenteditable=\"false\" height=\"20\" src=\"/modules/contentbox-admin/includes/images/widgets/tag.png\" style=\"margin-right:5px;\" width=\"20\" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',26,'2014-08-25 12:40:55',b'0',1,147,'2016-05-03 16:23:25',b'0'),
	(368,'<p>Support services</p>\r\n\r\n<p><widget dropdown=\"false\" emptymessage=\"Sorry, no related content was found.\" rendermethodselect=\"renderIt\" title=\"\" titlelevel=\"2\" widgetdisplayname=\"Related Content\" widgetname=\"RelatedContent\" widgettype=\"Core\" widgetudf=\"renderIt\"><widgetinfobar contenteditable=\"false\"><img align=\"left\" contenteditable=\"false\" height=\"20\" src=\"/modules/contentbox-admin/includes/images/widgets/tag.png\" style=\"margin-right:5px;\" width=\"20\" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',27,'2014-08-25 12:41:44',b'0',1,147,'2016-05-03 16:23:25',b'0'),
	(369,'<p>Support services</p>\r\n\r\n<p><widget dropdown=\"false\" emptymessage=\"Sorry, no related content was found.\" rendermethodselect=\"renderIt\" title=\"\" titlelevel=\"2\" widgetdisplayname=\"Related Content\" widgetname=\"RelatedContent\" widgettype=\"Core\" widgetudf=\"renderIt\"><widgetinfobar contenteditable=\"false\"><img align=\"left\" contenteditable=\"false\" height=\"20\" src=\"/modules/contentbox-admin/includes/images/widgets/tag.png\" style=\"margin-right:5px;\" width=\"20\" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',28,'2014-08-25 12:46:10',b'0',1,147,'2016-05-03 16:23:25',b'0'),
	(370,'<p>Support services</p>\r\n\r\n<p><widget dropdown=\"false\" emptymessage=\"Sorry, no related content was found.\" rendermethodselect=\"renderIt\" title=\"\" titlelevel=\"2\" widgetdisplayname=\"Related Content\" widgetname=\"RelatedContent\" widgettype=\"Core\" widgetudf=\"renderIt\"><widgetinfobar contenteditable=\"false\"><img align=\"left\" contenteditable=\"false\" height=\"20\" src=\"/modules/contentbox-admin/includes/images/widgets/tag.png\" style=\"margin-right:5px;\" width=\"20\" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',29,'2014-08-25 12:46:29',b'0',1,147,'2016-05-03 16:23:25',b'0'),
	(371,'<p>Support services</p>\r\n\r\n<p><widget dropdown=\"false\" emptymessage=\"Sorry, no related content was found.\" rendermethodselect=\"renderIt\" title=\"\" titlelevel=\"2\" widgetdisplayname=\"Related Content\" widgetname=\"RelatedContent\" widgettype=\"Core\" widgetudf=\"renderIt\"><widgetinfobar contenteditable=\"false\"><img align=\"left\" contenteditable=\"false\" height=\"20\" src=\"/modules/contentbox-admin/includes/images/widgets/tag.png\" style=\"margin-right:5px;\" width=\"20\" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',30,'2014-08-25 12:46:59',b'0',1,147,'2016-05-03 16:23:25',b'0'),
	(372,'<p>Support services</p>\r\n\r\n<p><widget dropdown=\"false\" emptymessage=\"Sorry, no related content was found.\" rendermethodselect=\"renderIt\" title=\"\" titlelevel=\"2\" widgetdisplayname=\"Related Content\" widgetname=\"RelatedContent\" widgettype=\"Core\" widgetudf=\"renderIt\"><widgetinfobar contenteditable=\"false\"><img align=\"left\" contenteditable=\"false\" height=\"20\" src=\"/modules/contentbox-admin/includes/images/widgets/tag.png\" style=\"margin-right:5px;\" width=\"20\" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',31,'2014-08-25 13:22:47',b'0',1,147,'2016-05-03 16:23:25',b'0'),
	(373,'<p>Support services</p>\r\n\r\n<p><widget dropdown=\"false\" emptymessage=\"Sorry, no related content was found.\" rendermethodselect=\"renderIt\" title=\"\" titlelevel=\"2\" widgetdisplayname=\"Related Content\" widgetname=\"RelatedContent\" widgettype=\"Core\" widgetudf=\"renderIt\"><widgetinfobar contenteditable=\"false\"><img align=\"left\" contenteditable=\"false\" height=\"20\" src=\"/modules/contentbox-admin/includes/images/widgets/tag.png\" style=\"margin-right:5px;\" width=\"20\" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',32,'2014-08-25 13:23:14',b'0',1,147,'2016-05-03 16:23:25',b'0'),
	(374,'<p>Support services</p>\r\n\r\n<p><widget dropdown=\"false\" emptymessage=\"Sorry, no related content was found.\" rendermethodselect=\"renderIt\" title=\"\" titlelevel=\"2\" widgetdisplayname=\"Related Content\" widgetname=\"RelatedContent\" widgettype=\"Core\" widgetudf=\"renderIt\"><widgetinfobar contenteditable=\"false\"><img align=\"left\" contenteditable=\"false\" height=\"20\" src=\"/modules/contentbox-admin/includes/images/widgets/tag.png\" style=\"margin-right:5px;\" width=\"20\" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',33,'2014-08-25 13:23:55',b'0',1,147,'2016-05-03 16:23:25',b'0'),
	(381,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2014-09-26 16:00:44',b'0',1,159,'2016-05-03 16:23:25',b'0'),
	(382,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',2,'2014-09-26 16:25:23',b'0',1,159,'2016-05-03 16:23:25',b'0'),
	(383,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',3,'2014-09-26 16:25:31',b'0',1,159,'2016-05-03 16:23:25',b'0'),
	(384,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',4,'2014-09-26 16:25:53',b'1',1,159,'2016-05-03 16:23:25',b'0'),
	(387,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2015-03-29 10:13:59',b'0',1,160,'2016-05-03 16:23:25',b'0'),
	(390,'<p>${rc:event}</p>\r\n\r\n<p>${prc:cbox_incomingContextHash}</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','quick save',2,'2015-04-01 11:17:19',b'0',1,160,'2016-05-03 16:23:25',b'0'),
	(391,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Reverting to version 1',3,'2015-05-09 22:31:13',b'0',1,160,'2016-05-03 16:23:25',b'0'),
	(392,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',4,'2015-05-09 22:39:03',b'0',1,160,'2016-05-18 11:50:02',b'0'),
	(395,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2015-09-16 10:33:56',b'0',1,162,'2016-05-03 16:23:25',b'0'),
	(400,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',2,'2015-09-23 11:04:54',b'1',1,162,'2016-05-03 16:23:25',b'0'),
	(413,'<p>Test</p>\r\n','',1,'2016-01-14 11:44:58',b'0',1,168,'2016-05-03 16:23:25',b'0'),
	(414,'<p>Test</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',2,'2016-01-14 11:45:17',b'1',1,168,'2016-05-03 16:23:25',b'0'),
	(415,'<p>asdf</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2016-01-14 11:45:35',b'0',1,169,'2016-05-05 15:53:13',b'0'),
	(418,'<p>Support services</p>\r\n\r\n<p><widget dropdown=\"false\" emptymessage=\"Sorry, no related content was found.\" rendermethodselect=\"renderIt\" title=\"\" titlelevel=\"2\" widgetdisplayname=\"Related Content\" widgetname=\"RelatedContent\" widgettype=\"Core\" widgetudf=\"renderIt\"><widgetinfobar contenteditable=\"false\"><img align=\"left\" contenteditable=\"false\" height=\"20\" src=\"/modules/contentbox-admin/includes/images/widgets/tag.png\" style=\"margin-right:5px;\" width=\"20\" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',34,'2016-04-10 16:27:12',b'0',1,147,'2016-05-03 16:23:25',b'0'),
	(419,'<p>Support services</p>\r\n\r\n<p><widget dropdown=\"false\" emptymessage=\"Sorry, no related content was found.\" rendermethodselect=\"renderIt\" title=\"\" titlelevel=\"2\" widgetdisplayname=\"Related Content\" widgetname=\"RelatedContent\" widgettype=\"Core\" widgetudf=\"renderIt\"><widgetinfobar contenteditable=\"false\"><img align=\"left\" contenteditable=\"false\" height=\"20\" src=\"/modules/contentbox-admin/includes/images/widgets/tag.png\" style=\"margin-right:5px;\" width=\"20\" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',35,'2016-04-11 11:40:14',b'1',1,147,'2016-05-03 16:23:25',b'0'),
	(442,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2016-04-12 13:18:51',b'0',1,189,'2016-05-03 16:23:25',b'0'),
	(443,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',2,'2016-04-12 13:19:21',b'1',1,189,'2016-05-03 16:23:25',b'0'),
	(444,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2016-04-12 13:19:04',b'1',1,190,'2016-05-03 16:23:25',b'0'),
	(445,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2016-04-12 13:19:10',b'1',1,191,'2016-05-03 16:23:25',b'0'),
	(448,'<p>asdf</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','quick save',2,'2016-05-05 15:53:13',b'0',1,169,'2016-05-05 15:55:34',b'0'),
	(449,'<p>asdf</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','quick save',3,'2016-05-05 15:55:34',b'0',1,169,'2016-05-05 15:56:12',b'0'),
	(450,'Because of God\'s grace, this project exists. If you don\'t like this, then don\'t read it, its not for you.\r\n\r\n>\"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:\r\nBy whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.\r\nAnd not only so, but we glory in tribulations also: knowing that tribulation worketh patience;\r\nAnd patience, experience; and experience, hope:\r\nAnd hope maketh not ashamed; because the love of God is shed abroad in our hearts by the \r\nHoly Ghost which is given unto us. .\" Romans 5:5\r\n\r\n----\r\n\r\n# Welcome to ContentBox\r\nContentBox is a modular content management engine based on the popular [ColdBox](www.coldbox.org) MVC framework.\r\n\r\n## License\r\nApache License, Version 2.0.\r\n\r\n## Versioning\r\nContentBox is maintained under the Semantic Versioning guidelines as much as possible.\r\n\r\nReleases will be numbered with the following format:\r\n\r\n```\r\n<major>.<minor>.<patch>\r\n```\r\n\r\nAnd constructed with the following guidelines:\r\n\r\n* Breaking backward compatibility bumps the major (and resets the minor and patch)\r\n* New additions without breaking backward compatibility bumps the minor (and resets the patch)\r\n* Bug fixes and misc changes bumps the patch\r\n\r\n## Important Links\r\n\r\nSource Code\r\n- https://github.com/Ortus-Solutions/ContentBox\r\n\r\nContinuous Integration\r\n- http://jenkins.staging.ortussolutions.com/job/OS-ContentBox%20BE/\r\n\r\nBug Tracking/Agile Boards\r\n- https://ortussolutions.atlassian.net/browse/CONTENTBOX\r\n\r\nDocumentation\r\n- http://contentbox.ortusbooks.com\r\n\r\nBlog\r\n- http://www.ortussolutions.com/blog\r\n\r\n## System Requirements\r\n- Lucee 4.5+\r\n- Railo 4+ (Deprecated)\r\n- ColdFusion 10+\r\n\r\n# ContentBox Installation\r\n\r\nYou can follow in-depth installation instructions here: http://contentbox.ortusbooks.com/content/installation/index.html or you can use [CommandBox](http://www.ortussolutions.com/products/commandbox) to quickly get up and running via the following commands:\r\n\r\n**Stable Release**\r\n\r\n```bash\r\nmkdir mysite && cd mysite\r\n# Install latest release\r\nbox install contentbox\r\nbox server start --rewritesEnable\r\n```\r\n\r\n**Bleeding Edge Release**\r\n\r\n```bash\r\nmkdir mysite && cd mysite\r\n# Install latest release\r\nbox install contentbox-be\r\nbox server start --rewritesEnable\r\n```\r\n\r\n## Collaboration\r\n\r\nIf you want to develop and hack at the source, you will need to download [CommandBox](http://www.ortussolutions.com/products/commandbox) first.  Then in the root of this project, type `box install`.  This will download the necessary dependencies to develop and test ContentBox.  You can then go ahead and start an embedded server `box server start --rewritesEnable` and start hacking around and contributing.  \r\n\r\n### Test Suites\r\nFor running our test suites you will need 2 more steps, so please refer to the [Readme](tests/readme.md) in the tests folder.\r\n\r\n### UI Development\r\nIf developing CSS and Javascript assets, please refer to the [Developer Guide](workbench/Developer.md) in the `workbench/Developer.md` folder.\r\n\r\n---\r\n \r\n###THE DAILY BREAD\r\n > \"I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)\" Jn 14:1-12','',4,'2016-05-05 15:56:11',b'1',1,169,'2016-05-05 15:56:11',b'0'),
	(454,'<p># Test App This is my `cool` documentation {{{ContentStore slug=\'firefox-test\'}}} I want an image: ![ContentBox-Circle_32.png](/index.cfm/__media/ContentBox-Circle_32.png) This is an amazing coding styles</p>\r\n\r\n<pre class=\"brush: coldfusion\">\r\nCode Fences Work</pre>\r\n','',6,'2016-05-06 15:47:42',b'0',1,192,'2016-05-06 16:12:27',b'0'),
	(455,'<p># Test App This is my `cool` documentation {{{ContentStore slug=\'firefox-test\'}}} I want an image: ![ContentBox-Circle_32.png](/index.cfm/__media/ContentBox-Circle_32.png) This is an amazing coding styles</p>\r\n\r\n<pre class=\"brush: coldfusion\">\r\nCode Fences Work\r\n</pre>\r\n','quick save',7,'2016-05-06 16:12:27',b'0',1,192,'2016-05-06 16:16:02',b'0'),
	(456,'<p># Test App This is my `cool` documentation {{{ContentStore slug=\'firefox-test\'}}} I want an image: ![ContentBox-Circle_32.png](/index.cfm/__media/ContentBox-Circle_32.png) This is an amazing coding styles</p>\r\n\r\n<pre class=\"brush: coldfusion\">\r\nCode Fences Work\r\n</pre>\r\n\r\n\r\n','quick save',8,'2016-05-06 16:16:02',b'0',1,192,'2016-05-09 15:18:20',b'0'),
	(457,'<p># Test App This is my `cool` documentation {{{ContentStore slug=\'firefox-test\'}}} I want an image: ![ContentBox-Circle_32.png](/index.cfm/__media/ContentBox-Circle_32.png) This is an amazing coding styles</p>\r\n\r\n<pre class=\"brush: coldfusion\">\r\nCode Fences Work\r\n</pre>\r\n\r\n\r\n','quick save',9,'2016-05-09 15:18:20',b'0',1,192,'2016-05-10 14:31:20',b'0'),
	(458,'<p># Test App This is my `cool` documentation {{{ContentStore slug=\'firefox-test\'}}} I want an image: ![ContentBox-Circle_32.png](/index.cfm/__media/ContentBox-Circle_32.png) This is an amazing coding styles</p>\r\n\r\n<pre class=\"brush: coldfusion\">\r\nCode Fences Work\r\n</pre>\r\n\r\n\r\n','quick save',10,'2016-05-10 14:31:20',b'0',1,192,'2016-05-11 15:52:40',b'0'),
	(459,'<p># Test App This is my `cool` documentation {{{ContentStore slug=\'firefox-test\'}}} I want an image: ![ContentBox-Circle_32.png](/index.cfm/__media/ContentBox-Circle_32.png) This is an amazing coding styles</p>\r\n\r\n<pre class=\"brush: coldfusion\">\r\nCode Fences Work\r\n</pre>\r\n\r\n\r\n','quick save',11,'2016-05-11 15:52:40',b'0',1,192,'2016-05-11 15:52:45',b'0'),
	(460,'<p># Test App This is my `cool` documentation {{{ContentStore slug=\'firefox-test\'}}} I want an image: ![ContentBox-Circle_32.png](/index.cfm/__media/ContentBox-Circle_32.png) This is an amazing coding styles</p>\r\n\r\n<pre class=\"brush: coldfusion\">\r\nCode Fences Work\r\n</pre>\r\n\r\n\r\n','quick save',12,'2016-05-11 15:52:45',b'0',1,192,'2016-05-18 11:42:34',b'0'),
	(478,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2016-05-18 11:35:32',b'0',1,206,'2016-05-18 11:35:32',b'0'),
	(479,'<p><img alt=\"\" src=\"/index.cfm/__media/ContentBox_300.png\" style=\"width: 300px; height: 284px;\" /></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p><img alt=\"\" src=\"/index.cfm/__media/ContentBox_125.gif\" style=\"width: 124px; height: 118px;\" /></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',2,'2016-05-18 11:35:32',b'0',1,206,'2016-05-18 11:35:32',b'0'),
	(480,'<p><img alt=\"\" src=\"/__media/ContentBox_300.png\" style=\"width: 300px; height: 284px;\" /></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p><img alt=\"\" src=\"/__media/ContentBox_125.gif\" style=\"width: 124px; height: 118px;\" /></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',3,'2016-05-18 11:35:32',b'0',1,206,'2016-05-18 11:35:32',b'0'),
	(481,'<p><img alt=\"\" src=\"/__media/ContentBox_300.png\" style=\"width: 300px; height: 178px;\" /></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',4,'2016-05-18 11:35:32',b'0',1,206,'2016-05-18 15:11:18',b'0'),
	(482,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2016-05-18 11:35:32',b'1',1,207,'2016-05-18 11:35:32',b'0'),
	(483,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2016-05-18 11:35:32',b'1',1,208,'2016-05-18 11:35:32',b'0'),
	(484,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2016-05-18 11:35:32',b'1',1,209,'2016-05-18 11:35:32',b'0'),
	(485,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2016-05-18 11:35:32',b'1',1,210,'2016-05-18 11:35:32',b'0'),
	(486,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2016-05-18 11:35:32',b'1',1,211,'2016-05-18 11:35:32',b'0'),
	(487,'<p>Support services</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',1,'2016-05-18 11:35:32',b'1',1,212,'2016-05-18 11:35:32',b'0'),
	(488,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Content Cloned!',1,'2016-05-18 11:35:32',b'0',1,213,'2016-05-18 11:35:32',b'0'),
	(489,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/vdBHFxfZues\" frameborder=\"0\" allowfullscreen></iframe>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','',2,'2016-05-18 11:35:32',b'1',1,213,'2016-05-18 11:35:32',b'0'),
	(490,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Content Cloned!',1,'2016-05-18 11:35:32',b'1',1,214,'2016-05-18 11:35:32',b'0'),
	(491,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Content Cloned!',1,'2016-05-18 11:35:32',b'1',1,215,'2016-05-18 11:35:32',b'0'),
	(492,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Content Cloned!',1,'2016-05-18 11:35:32',b'1',1,216,'2016-05-18 11:35:32',b'0'),
	(493,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Content Cloned!',1,'2016-05-18 11:35:32',b'1',1,217,'2016-05-18 11:35:32',b'0'),
	(494,'<p>Support services</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Content Cloned!',1,'2016-05-18 11:35:32',b'1',1,218,'2016-05-18 11:35:32',b'0'),
	(495,'<p># Test App This is my `cool` documentation {{{ContentStore slug=\'firefox-test\'}}} I want an image: ![ContentBox-Circle_32.png](/index.cfm/__media/ContentBox-Circle_32.png) This is an amazing coding styles</p>\r\n\r\n<pre class=\"brush: coldfusion\">\r\nCode Fences Work\r\n</pre>\r\n\r\n\r\n','',13,'2016-05-18 11:42:34',b'0',1,192,'2016-05-18 11:45:50',b'0'),
	(496,'<p># Test App This is my `cool` documentation {{{ContentStore slug=\'firefox-test\'}}} I want an image: ![ContentBox-Circle_32.png](/index.cfm/__media/ContentBox-Circle_32.png) This is an amazing coding styles</p>\r\n\r\n<pre class=\"brush: coldfusion\">\r\nCode Fences Work\r\n</pre>\r\n\r\n\r\n','',14,'2016-05-18 11:45:50',b'0',1,192,'2016-06-14 13:46:47',b'0'),
	(497,'My Products Rock','',5,'2017-06-13 17:08:36',b'1',1,206,'2017-06-13 17:08:36',b'0'),
	(498,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n','Expired content',1,'2018-03-20 09:48:13',b'1',1,219,'2018-03-20 09:48:13',b'0');

/*!40000 ALTER TABLE `cb_contentVersion` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_customfield
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_customfield`;

CREATE TABLE `cb_customfield` (
  `customFieldID` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `value` longtext NOT NULL,
  `FK_contentID` int(11) DEFAULT NULL,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`customFieldID`),
  KEY `FK1844684991F58374` (`FK_contentID`),
  KEY `idx_contentCustomFields` (`FK_contentID`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`),
  CONSTRAINT `FK1844684991F58374` FOREIGN KEY (`FK_contentID`) REFERENCES `cb_content` (`contentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_customfield` WRITE;
/*!40000 ALTER TABLE `cb_customfield` DISABLE KEYS */;

INSERT INTO `cb_customfield` (`customFieldID`, `key`, `value`, `FK_contentID`, `createdDate`, `modifiedDate`, `isDeleted`)
VALUES
	(3,'age','30',114,'2016-05-03 16:23:25','2016-05-03 16:23:25',b'0'),
	(4,'subtitle','4',114,'2016-05-03 16:23:25','2016-05-03 16:23:25',b'0');

/*!40000 ALTER TABLE `cb_customfield` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_entry
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_entry`;

CREATE TABLE `cb_entry` (
  `contentID` int(11) NOT NULL,
  `excerpt` longtext,
  PRIMARY KEY (`contentID`),
  KEY `FK141674927FFF6A7` (`contentID`),
  CONSTRAINT `FK141674927FFF6A7` FOREIGN KEY (`contentID`) REFERENCES `cb_content` (`contentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_entry` WRITE;
/*!40000 ALTER TABLE `cb_entry` DISABLE KEYS */;

INSERT INTO `cb_entry` (`contentID`, `excerpt`)
VALUES
	(63,''),
	(64,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n'),
	(65,''),
	(67,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n'),
	(69,''),
	(86,''),
	(87,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n'),
	(88,'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n'),
	(109,''),
	(110,''),
	(132,''),
	(133,''),
	(135,''),
	(141,'<p>Excerpt Content TestsExcerpt Content TestsExcerpt Content Tests</p>\r\n'),
	(142,'');

/*!40000 ALTER TABLE `cb_entry` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_groupPermissions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_groupPermissions`;

CREATE TABLE `cb_groupPermissions` (
  `FK_permissionGroupID` int(11) NOT NULL,
  `FK_permissionID` int(11) NOT NULL,
  KEY `FK72ECB065F4497DC2` (`FK_permissionGroupID`),
  KEY `FK72ECB06537C1A3F2` (`FK_permissionID`),
  CONSTRAINT `FK72ECB06537C1A3F2` FOREIGN KEY (`FK_permissionID`) REFERENCES `cb_permission` (`permissionID`),
  CONSTRAINT `FK72ECB065F4497DC2` FOREIGN KEY (`FK_permissionGroupID`) REFERENCES `cb_permissionGroup` (`permissionGroupID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_groupPermissions` WRITE;
/*!40000 ALTER TABLE `cb_groupPermissions` DISABLE KEYS */;

INSERT INTO `cb_groupPermissions` (`FK_permissionGroupID`, `FK_permissionID`)
VALUES
	(1,14),
	(1,28),
	(1,25),
	(2,29),
	(2,3);

/*!40000 ALTER TABLE `cb_groupPermissions` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_loginAttempts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_loginAttempts`;

CREATE TABLE `cb_loginAttempts` (
  `loginAttemptsID` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) NOT NULL,
  `attempts` int(11) NOT NULL,
  `createdDate` datetime NOT NULL,
  `lastLoginSuccessIP` varchar(100) DEFAULT '',
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`loginAttemptsID`),
  KEY `idx_createdDate` (`createdDate`),
  KEY `idx_values` (`value`),
  KEY `idx_loginCreatedDate` (`createdDate`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_loginAttempts` WRITE;
/*!40000 ALTER TABLE `cb_loginAttempts` DISABLE KEYS */;

INSERT INTO `cb_loginAttempts` (`loginAttemptsID`, `value`, `attempts`, `createdDate`, `lastLoginSuccessIP`, `modifiedDate`, `isDeleted`)
VALUES
	(16,'lmajano',0,'2016-11-28 14:56:43','127.0.0.1','2016-11-28 14:56:46',b'0'),
	(17,'testermajano',0,'2017-06-21 16:07:26','127.0.0.1','2017-06-21 17:37:42',b'0'),
	(19,'joejoe@joe.com',0,'2017-07-06 11:37:09',NULL,'2017-07-06 11:37:31',b'0'),
	(20,'joejoe',0,'2017-07-06 11:38:28','127.0.0.1','2017-07-06 11:38:28',b'0');

/*!40000 ALTER TABLE `cb_loginAttempts` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_menu
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_menu`;

CREATE TABLE `cb_menu` (
  `menuID` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `slug` varchar(200) NOT NULL,
  `listType` varchar(20) DEFAULT NULL,
  `createdDate` datetime NOT NULL,
  `menuClass` varchar(160) DEFAULT NULL,
  `listClass` varchar(160) DEFAULT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`menuID`),
  UNIQUE KEY `slug` (`slug`),
  KEY `idx_menuslug` (`slug`),
  KEY `idx_menutitle` (`title`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_menu` WRITE;
/*!40000 ALTER TABLE `cb_menu` DISABLE KEYS */;

INSERT INTO `cb_menu` (`menuID`, `title`, `slug`, `listType`, `createdDate`, `menuClass`, `listClass`, `modifiedDate`, `isDeleted`)
VALUES
	(2,'Test','test','ul','2016-05-04 17:00:14','','','2016-05-04 17:20:11',b'0'),
	(3,'test','test -e123c','ul','2016-05-04 17:02:54','','','2016-05-04 17:02:54',b'0');

/*!40000 ALTER TABLE `cb_menu` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_menuItem
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_menuItem`;

CREATE TABLE `cb_menuItem` (
  `menuItemID` int(11) NOT NULL AUTO_INCREMENT,
  `menuType` varchar(255) NOT NULL,
  `title` varchar(200) NOT NULL,
  `label` varchar(200) DEFAULT NULL,
  `data` varchar(255) DEFAULT NULL,
  `active` bit(1) DEFAULT NULL,
  `FK_menuID` int(11) NOT NULL,
  `FK_parentID` int(11) DEFAULT NULL,
  `mediaPath` varchar(255) DEFAULT NULL,
  `contentSlug` varchar(255) DEFAULT NULL,
  `menuSlug` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `js` varchar(255) DEFAULT NULL,
  `itemClass` varchar(200) DEFAULT NULL,
  `target` varchar(255) DEFAULT NULL,
  `urlClass` varchar(255) DEFAULT NULL,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`menuItemID`),
  KEY `FKF9F1DCF2D3B42410` (`FK_parentID`),
  KEY `FKF9F1DCF28E0E8DD2` (`FK_menuID`),
  KEY `idx_menuitemtitle` (`title`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`),
  CONSTRAINT `FKF9F1DCF28E0E8DD2` FOREIGN KEY (`FK_menuID`) REFERENCES `cb_menu` (`menuID`),
  CONSTRAINT `FKF9F1DCF2D3B42410` FOREIGN KEY (`FK_parentID`) REFERENCES `cb_menuItem` (`menuItemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_menuItem` WRITE;
/*!40000 ALTER TABLE `cb_menuItem` DISABLE KEYS */;

INSERT INTO `cb_menuItem` (`menuItemID`, `menuType`, `title`, `label`, `data`, `active`, `FK_menuID`, `FK_parentID`, `mediaPath`, `contentSlug`, `menuSlug`, `url`, `js`, `itemClass`, `target`, `urlClass`, `createdDate`, `modifiedDate`, `isDeleted`)
VALUES
	(7,'Free','','test','',b'1',2,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,'2016-05-04 17:22:08','2016-05-04 17:22:08',b'0'),
	(8,'URL','','hello','',b'1',2,NULL,NULL,NULL,NULL,'http://www.ortussolutions.com',NULL,'','_blank','test','2016-05-04 17:22:08','2016-05-04 17:22:08',b'0');

/*!40000 ALTER TABLE `cb_menuItem` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_module
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_module`;

CREATE TABLE `cb_module` (
  `moduleID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  `entryPoint` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `webURL` longtext,
  `forgeBoxSlug` varchar(255) DEFAULT NULL,
  `description` longtext,
  `isActive` bit(1) NOT NULL DEFAULT b'0',
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `moduleType` varchar(255) DEFAULT 'core',
  PRIMARY KEY (`moduleID`),
  KEY `idx_active` (`isActive`),
  KEY `idx_entryPoint` (`entryPoint`),
  KEY `idx_moduleName` (`name`),
  KEY `idx_activeModule` (`isActive`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`),
  KEY `idx_moduleType` (`moduleType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_module` WRITE;
/*!40000 ALTER TABLE `cb_module` DISABLE KEYS */;

INSERT INTO `cb_module` (`moduleID`, `name`, `title`, `version`, `entryPoint`, `author`, `webURL`, `forgeBoxSlug`, `description`, `isActive`, `createdDate`, `modifiedDate`, `isDeleted`, `moduleType`)
VALUES
	(36,'Hello','HelloContentBox','1.0','HelloContentBox','Ortus Solutions, Corp','http://www.ortussolutions.com','','This is an awesome hello world module',b'0','2016-07-15 12:09:34','2016-07-15 12:09:34',b'0','core');

/*!40000 ALTER TABLE `cb_module` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_page
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_page`;

CREATE TABLE `cb_page` (
  `contentID` int(11) NOT NULL,
  `layout` varchar(200) DEFAULT NULL,
  `mobileLayout` varchar(200) DEFAULT NULL,
  `order` int(11) DEFAULT '0',
  `showInMenu` bit(1) NOT NULL DEFAULT b'1',
  `excerpt` longtext,
  `SSLOnly` bit(1) NOT NULL,
  PRIMARY KEY (`contentID`),
  KEY `FK21B2F26F9636A2E2` (`contentID`),
  KEY `idx_showInMenu` (`showInMenu`),
  KEY `idx_ssl` (`SSLOnly`),
  CONSTRAINT `FK21B2F26F9636A2E2` FOREIGN KEY (`contentID`) REFERENCES `cb_content` (`contentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_page` WRITE;
/*!40000 ALTER TABLE `cb_page` DISABLE KEYS */;

INSERT INTO `cb_page` (`contentID`, `layout`, `mobileLayout`, `order`, `showInMenu`, `excerpt`, `SSLOnly`)
VALUES
	(147,'pages','',6,b'1','',b'0'),
	(160,'-no-layout-','',3,b'1','',b'0'),
	(162,'pagesNoSidebar','',5,b'1','',b'0'),
	(189,'pages','',4,b'1','',b'0'),
	(190,'pages','',0,b'1','',b'0'),
	(191,'pages','',0,b'1','',b'0'),
	(192,'pages','',2,b'0','',b'0'),
	(206,'pages','',1,b'1','',b'0'),
	(207,'pages','',2,b'1','',b'0'),
	(208,'pages','',1,b'1','',b'0'),
	(209,'pages','',2,b'1','',b'0'),
	(210,'pages','',6,b'1','',b'0'),
	(211,'pages','',4,b'1','',b'0'),
	(212,'pages','',8,b'1','',b'0'),
	(213,'pages','',1,b'1','',b'0'),
	(214,'pages','',0,b'1','',b'0'),
	(215,'pages','',0,b'1','',b'0'),
	(216,'pages','',0,b'1','',b'0'),
	(217,'pages','',0,b'1','',b'0'),
	(218,'pages','',0,b'1','',b'0');

/*!40000 ALTER TABLE `cb_page` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_permission
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_permission`;

CREATE TABLE `cb_permission` (
  `permissionID` int(11) NOT NULL AUTO_INCREMENT,
  `permission` varchar(255) NOT NULL,
  `description` longtext,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`permissionID`),
  UNIQUE KEY `permission` (`permission`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_permission` WRITE;
/*!40000 ALTER TABLE `cb_permission` DISABLE KEYS */;

INSERT INTO `cb_permission` (`permissionID`, `permission`, `description`, `createdDate`, `modifiedDate`, `isDeleted`)
VALUES
	(1,'PAGES_ADMIN','Ability to manage content pages, default is view only','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(2,'EDITORS_EDITOR_SELECTOR','Ability to change the editor to another registered online editor','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(3,'WIDGET_ADMIN','Ability to manage widgets, default is view only','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(4,'TOOLS_IMPORT','Ability to import data into ContentBox','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(5,'GLOBALHTML_ADMIN','Ability to manage the system\'s global HTML content used on layouts','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(6,'PAGES_EDITOR','Ability to manage content pages but not publish pages','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(7,'SYSTEM_TAB','Access to the ContentBox System tools','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(9,'SYSTEM_UPDATES','Ability to view and apply ContentBox updates','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(10,'CONTENTBOX_ADMIN','Access to the enter the ContentBox administrator console','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(11,'RELOAD_MODULES','Ability to reload modules','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(12,'MODULES_ADMIN','Ability to manage ContentBox Modules','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(13,'COMMENTS_ADMIN','Ability to manage comments, default is view only','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(14,'AUTHOR_ADMIN','Ability to manage authors, default is view only','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(15,'PERMISSIONS_ADMIN','Ability to manage permissions, default is view only','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(16,'MEDIAMANAGER_ADMIN','Ability to manage the system\'s media manager','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(17,'SYSTEM_RAW_SETTINGS','Access to the ContentBox raw geek settings panel','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(18,'CATEGORIES_ADMIN','Ability to manage categories, default is view only','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(19,'EDITORS_DISPLAY_OPTIONS','Ability to view the content display options panel','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(20,'EDITORS_HTML_ATTRIBUTES','Ability to view the content HTML attributes panel','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(22,'FORGEBOX_ADMIN','Ability to manage ForgeBox installations and connectivity.','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(23,'THEME_ADMIN','Ability to manage themes, default is view only','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(24,'EDITORS_CATEGORIES','Ability to view the content categories panel','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(25,'EDITORS_MODIFIERS','Ability to view the content modifiers panel','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(26,'ENTRIES_ADMIN','Ability to manage blog entries, default is view only','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(27,'VERSIONS_ROLLBACK','Ability to rollback content versions','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(28,'EDITORS_CACHING','Ability to view the content caching panel','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(29,'ROLES_ADMIN','Ability to manage roles, default is view only','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(30,'SYSTEM_SAVE_CONFIGURATION','Ability to update global configuration data','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(31,'ENTRIES_EDITOR','Ability to manage blog entries but not publish entries','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(32,'VERSIONS_DELETE','Ability to delete past content versions','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(33,'SECURITYRULES_ADMIN','Ability to manage the system\'s security rules, default is view only','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(34,'TOOLS_EXPORT','Ability to export data from ContentBox','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(36,'CONTENTSTORE_ADMIN','Ability to manage the content store, default is view only','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(37,'CONTENTSTORE_EDITOR','Ability to manage content store elements but not publish them','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(38,'MEDIAMANAGER_LIBRARY_SWITCHER','Ability to switch media manager libraries for management','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(39,'EDITORS_CUSTOM_FIELDS','Ability to manage custom fields in any content editors','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(40,'GLOBAL_SEARCH','Ability to do global searches in the ContentBox Admin','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(41,'EDITORS_RELATED_CONTENT','Ability to view the related content panel','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(42,'EDITORS_LINKED_CONTENT','Ability to view the linked content panel','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(43,'MENUS_ADMIN','Ability to manage the menu builder','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(44,'SYSTEM_AUTH_LOGS','Access to the system auth logs','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(45,'EDITORS_FEATURED_IMAGE','Ability to view the featured image panel','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(46,'EMAIL_TEMPLATE_ADMIN','Ability to admin and preview email templates','2017-06-20 16:13:01','2017-06-20 16:13:01',b'0');

/*!40000 ALTER TABLE `cb_permission` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_permissionGroup
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_permissionGroup`;

CREATE TABLE `cb_permissionGroup` (
  `permissionGroupID` int(11) NOT NULL AUTO_INCREMENT,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `name` varchar(255) NOT NULL,
  `description` longtext,
  PRIMARY KEY (`permissionGroupID`),
  UNIQUE KEY `name` (`name`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_permissionGroup` WRITE;
/*!40000 ALTER TABLE `cb_permissionGroup` DISABLE KEYS */;

INSERT INTO `cb_permissionGroup` (`permissionGroupID`, `createdDate`, `modifiedDate`, `isDeleted`, `name`, `description`)
VALUES
	(1,'2017-06-12 16:01:13','2017-06-12 20:31:52',b'0','Finance','Finance team permissions'),
	(2,'2017-06-16 13:02:12','2017-06-16 13:02:12',b'0','Security','');

/*!40000 ALTER TABLE `cb_permissionGroup` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_relatedContent
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_relatedContent`;

CREATE TABLE `cb_relatedContent` (
  `FK_contentID` int(11) NOT NULL,
  `FK_relatedContentID` int(11) NOT NULL,
  KEY `FK9C2F71AEDF61AADD` (`FK_relatedContentID`),
  KEY `FK9C2F71AE91F58374` (`FK_contentID`),
  CONSTRAINT `FK9C2F71AE91F58374` FOREIGN KEY (`FK_contentID`) REFERENCES `cb_content` (`contentID`),
  CONSTRAINT `FK9C2F71AEDF61AADD` FOREIGN KEY (`FK_relatedContentID`) REFERENCES `cb_content` (`contentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_relatedContent` WRITE;
/*!40000 ALTER TABLE `cb_relatedContent` DISABLE KEYS */;

INSERT INTO `cb_relatedContent` (`FK_contentID`, `FK_relatedContentID`)
VALUES
	(127,111);

/*!40000 ALTER TABLE `cb_relatedContent` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_role
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_role`;

CREATE TABLE `cb_role` (
  `roleID` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(255) NOT NULL,
  `description` longtext,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`roleID`),
  UNIQUE KEY `role` (`role`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_role` WRITE;
/*!40000 ALTER TABLE `cb_role` DISABLE KEYS */;

INSERT INTO `cb_role` (`roleID`, `role`, `description`, `createdDate`, `modifiedDate`, `isDeleted`)
VALUES
	(1,'Editor','A ContentBox editor','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(2,'Administrator','A ContentBox Administrator','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(3,'MegaAdmin','A ContentBox Mega Admin','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(5,'Test','Test','2016-09-23 14:35:41','2016-09-23 14:35:41',b'0');

/*!40000 ALTER TABLE `cb_role` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_rolePermissions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_rolePermissions`;

CREATE TABLE `cb_rolePermissions` (
  `FK_roleID` int(11) NOT NULL,
  `FK_permissionID` int(11) NOT NULL,
  KEY `FKDCCC1A4E9724FA40` (`FK_roleID`),
  KEY `FKDCCC1A4E37C1A3F2` (`FK_permissionID`),
  CONSTRAINT `FKDCCC1A4E37C1A3F2` FOREIGN KEY (`FK_permissionID`) REFERENCES `cb_permission` (`permissionID`),
  CONSTRAINT `FKDCCC1A4E9724FA40` FOREIGN KEY (`FK_roleID`) REFERENCES `cb_role` (`roleID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_rolePermissions` WRITE;
/*!40000 ALTER TABLE `cb_rolePermissions` DISABLE KEYS */;

INSERT INTO `cb_rolePermissions` (`FK_roleID`, `FK_permissionID`)
VALUES
	(3,14),
	(3,18),
	(3,13),
	(3,10),
	(3,28),
	(3,24),
	(3,19),
	(3,2),
	(3,20),
	(3,25),
	(3,26),
	(3,31),
	(3,22),
	(3,5),
	(3,23),
	(3,16),
	(3,12),
	(3,1),
	(3,6),
	(3,15),
	(3,11),
	(3,29),
	(3,33),
	(3,17),
	(3,30),
	(3,7),
	(3,9),
	(3,4),
	(3,32),
	(3,27),
	(3,3),
	(2,14),
	(2,18),
	(2,13),
	(2,10),
	(2,36),
	(2,37),
	(2,28),
	(2,24),
	(2,39),
	(2,19),
	(2,2),
	(2,45),
	(2,20),
	(2,42),
	(2,25),
	(2,41),
	(2,26),
	(2,31),
	(2,22),
	(2,5),
	(2,40),
	(2,16),
	(2,38),
	(2,43),
	(2,12),
	(2,1),
	(2,6),
	(2,15),
	(2,11),
	(2,29),
	(2,33),
	(2,44),
	(2,17),
	(2,30),
	(2,7),
	(2,9),
	(2,23),
	(2,34),
	(2,4),
	(2,32),
	(2,27),
	(2,3),
	(2,46),
	(1,18),
	(1,13),
	(1,10),
	(1,37),
	(1,28),
	(1,24),
	(1,39),
	(1,19),
	(1,2),
	(1,20),
	(1,42),
	(1,25),
	(1,41),
	(1,46),
	(1,31),
	(1,5),
	(1,40),
	(1,16),
	(1,43),
	(1,6),
	(1,23),
	(1,27);

/*!40000 ALTER TABLE `cb_rolePermissions` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_securityRule
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_securityRule`;

CREATE TABLE `cb_securityRule` (
  `ruleID` int(11) NOT NULL AUTO_INCREMENT,
  `whitelist` varchar(255) DEFAULT NULL,
  `securelist` varchar(255) NOT NULL,
  `roles` varchar(255) DEFAULT NULL,
  `permissions` longtext,
  `redirect` longtext NOT NULL,
  `useSSL` bit(1) DEFAULT b'0',
  `order` int(11) NOT NULL DEFAULT '0',
  `match` varchar(50) DEFAULT NULL,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `message` varchar(255) DEFAULT NULL,
  `messageType` varchar(50) DEFAULT 'info',
  PRIMARY KEY (`ruleID`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_securityRule` WRITE;
/*!40000 ALTER TABLE `cb_securityRule` DISABLE KEYS */;

INSERT INTO `cb_securityRule` (`ruleID`, `whitelist`, `securelist`, `roles`, `permissions`, `redirect`, `useSSL`, `order`, `match`, `createdDate`, `modifiedDate`, `isDeleted`, `message`, `messageType`)
VALUES
	(26,'','^contentbox-admin:modules\\..*','','MODULES_ADMIN','cbadmin/security/login',b'0',1,'event','2017-07-06 12:14:21','2017-07-06 12:14:21',b'0','','info'),
	(27,'','^contentbox-admin:mediamanager\\..*','','MEDIAMANAGER_ADMIN','cbadmin/security/login',b'0',1,'event','2017-07-06 12:14:21','2017-07-06 12:14:21',b'0','','info'),
	(28,'','^contentbox-admin:versions\\.(remove)','','VERSIONS_DELETE','cbadmin/security/login',b'0',1,'event','2017-07-06 12:14:21','2017-07-06 12:14:21',b'0','','info'),
	(29,'','^contentbox-admin:versions\\.(rollback)','','VERSIONS_ROLLBACK','cbadmin/security/login',b'0',1,'event','2017-07-06 12:14:21','2017-07-06 12:14:21',b'0','','info'),
	(30,'','^contentbox-admin:widgets\\.(remove|upload|edit|save|create|doCreate)$','','WIDGET_ADMIN','cbadmin/security/login',b'0',2,'event','2017-07-06 12:14:21','2017-07-06 12:14:21',b'0','','info'),
	(31,'','^contentbox-admin:tools\\.(importer|doImport)','','TOOLS_IMPORT','cbadmin/security/login',b'0',3,'event','2017-07-06 12:14:21','2017-07-06 12:14:21',b'0','','info'),
	(32,'','^contentbox-admin:(settings|permissions|roles|securityRules)\\..*','','SYSTEM_TAB','cbadmin/security/login',b'0',4,'event','2017-07-06 12:14:22','2017-07-06 12:14:22',b'0','','info'),
	(33,'','^contentbox-admin:settings\\.save','','SYSTEM_SAVE_CONFIGURATION','cbadmin/security/login',b'0',5,'event','2017-07-06 12:14:22','2017-07-06 12:14:22',b'0','','info'),
	(34,'','^contentbox-admin:settings\\.(raw|saveRaw|flushCache|flushSingletons|mappingDump|viewCached|remove)','','SYSTEM_RAW_SETTINGS','cbadmin/security/login',b'0',6,'event','2017-07-06 12:14:22','2017-07-06 12:14:22',b'0','','info'),
	(35,'','^contentbox-admin:securityRules\\.(remove|save|changeOrder|apply)','','SECURITYRULES_ADMIN','cbadmin/security/login',b'0',7,'event','2017-07-06 12:14:22','2017-07-06 12:14:22',b'0','','info'),
	(36,'','^contentbox-admin:roles\\.(remove|removePermission|save|savePermission)','','ROLES_ADMIN','cbadmin/security/login',b'0',8,'event','2017-07-06 12:14:22','2017-07-06 12:14:22',b'0','','info'),
	(37,'','^contentbox-admin:permissions\\.(remove|save)','','PERMISSIONS_ADMIN','cbadmin/security/login',b'0',9,'event','2017-07-06 12:14:22','2017-07-06 12:14:22',b'0','','info'),
	(38,'','^contentbox-admin:dashboard\\.reload','','RELOAD_MODULES','cbadmin/security/login',b'0',10,'event','2017-07-06 12:14:22','2017-07-06 12:14:22',b'0','','info'),
	(39,'','^contentbox-admin:pages\\.(changeOrder|remove)','','PAGES_ADMIN','cbadmin/security/login',b'0',11,'event','2017-07-06 12:14:22','2017-07-06 12:14:22',b'0','','info'),
	(40,'','^contentbox-admin:themes\\.(remove|upload|rebuildRegistry|activate)','','THEME_ADMIN','cbadmin/security/login',b'0',12,'event','2017-07-06 12:14:22','2017-07-06 12:14:22',b'0','','info'),
	(41,'','^contentbox-admin:entries\\.(quickPost|remove)','','ENTRIES_ADMIN','cbadmin/security/login',b'0',13,'event','2017-07-06 12:14:22','2017-07-06 12:14:22',b'0','','info'),
	(42,'','^contentbox-admin:contentStore\\.(editor|remove|save)','','CONTENTSTORE_ADMIN','cbadmin/security/login',b'0',14,'event','2017-07-06 12:14:22','2017-07-06 12:14:22',b'0','','info'),
	(43,'','^contentbox-admin:comments\\.(doStatusUpdate|editor|moderate|remove|save|saveSettings)','','COMMENTS_ADMIN','cbadmin/security/login',b'0',15,'event','2017-07-06 12:14:22','2017-07-06 12:14:22',b'0','','info'),
	(44,'','^contentbox-admin:categories\\.(remove|save)','','CATEGORIES_ADMIN','cbadmin/security/login',b'0',16,'event','2017-07-06 12:14:22','2017-07-06 12:14:22',b'0','','info'),
	(45,'','^contentbox-admin:authors\\.(remove|removePermission|savePermission|doPasswordReset|new|doNew)','','AUTHOR_ADMIN','cbadmin/security/login',b'0',17,'event','2017-07-06 12:14:22','2017-07-06 12:14:22',b'0','','info'),
	(46,'^contentbox-admin:security\\.','^contentbox-admin:.*','','CONTENTBOX_ADMIN','cbadmin/security/login',b'0',18,'event','2017-07-06 12:14:22','2017-07-06 12:14:22',b'0','','info'),
	(47,'','^contentbox-filebrowser:.*','','MEDIAMANAGER_ADMIN','cbadmin/security/login',b'0',19,'event','2017-07-06 12:14:22','2017-07-06 12:14:22',b'0','','info'),
	(48,'','^contentbox-admin:(authors|categories|permissions|roles|settings|pages|entries|contentStore|securityrules)\\.importAll$','','TOOLS_IMPORT','cbadmin/security/login',b'0',20,'event','2017-07-06 12:14:22','2017-07-06 12:14:22',b'0','','info'),
	(49,'','^contentbox-admin:(authors|categories|permissions|roles|settings|pages|entries|contentStore|securityrules)\\.(export|exportAll)$','','TOOLS_EXPORT','cbadmin/security/login',b'0',20,'event','2017-07-06 12:14:22','2017-07-06 12:14:22',b'0','','info');

/*!40000 ALTER TABLE `cb_securityRule` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_setting
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_setting`;

CREATE TABLE `cb_setting` (
  `settingID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `value` longtext NOT NULL,
  `isCore` bit(1) NOT NULL DEFAULT b'0',
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`settingID`),
  KEY `idx_core` (`isCore`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_setting` WRITE;
/*!40000 ALTER TABLE `cb_setting` DISABLE KEYS */;

INSERT INTO `cb_setting` (`settingID`, `name`, `value`, `isCore`, `createdDate`, `modifiedDate`, `isDeleted`)
VALUES
	(1,'cb_comments_moderation_blockedlist','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(2,'cb_paging_maxrows','25',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(3,'cb_comments_captcha','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(4,'cb_site_name','ContentBox Site',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(5,'cb_comments_urltranslations','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(6,'cb_editors_ckeditor_extraplugins','cbWidgets,cbLinks,cbEntryLinks,cbContentStore,cbIpsumLorem,wsc,mediaembed,insertpre,cbKeyBinding,about',b'0','2016-05-03 16:23:26','2016-05-06 15:47:29',b'0'),
	(7,'cb_media_uploadify_customOptions','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(8,'cb_site_mail_server','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(9,'cb_dashboard_recentPages','10',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(10,'cb_html_preEntryDisplay','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(11,'cb_comments_enabled','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(12,'cb_site_mail_password','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(13,'cb_site_mail_ssl','false',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(14,'cb_site_ssl','false',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(15,'cb_html_beforeContent','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(16,'cb_dashboard_recentComments','10',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(17,'cb_versions_max_history','10',b'0','2016-05-03 16:23:26','2017-07-05 15:21:46',b'0'),
	(18,'cb_media_provider_caching','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(19,'cb_site_keywords','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(20,'cb_html_preIndexDisplay','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(21,'cb_content_cachingTimeout','60',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(22,'cb_comments_moderation','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(23,'cb_html_beforeHeadEnd','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(24,'cb_media_uploadify_sizeLimit','0',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(25,'cb_notify_entry','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(26,'cb_site_email','lmajano@gmail.com',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(27,'cb_site_maintenance_message','<h1>This site is down for maintenance.<br /> Please check back again soon.</h1>',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(28,'cb_media_acceptMimeTypes','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(29,'cb_comments_notifyemails','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(30,'cb_media_allowDownloads','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(31,'cb_html_postArchivesDisplay','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(32,'cb_comments_moderation_blacklist','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(33,'cb_salt','680D79D4A38FDBE8AF62014354B43AA54040B05B7EA74B3D7D1AE87C0C5A5DC2233A31C4067691B451A1AE7CEABB691D9432F073A0D242C1980642D855472769',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(34,'cb_admin_ssl','false',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(35,'cb_site_outgoingEmail','lmajano@gmail.com',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(36,'cb_media_uplodify_fileExt','*.*;',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(37,'cb_comments_moderation_whitelist','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(38,'cb_contentstore_caching','true',b'0','2016-05-03 16:23:26','2017-06-13 14:34:04',b'0'),
	(39,'cb_media_quickViewWidth','400',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(40,'cb_search_maxResults','20',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(41,'cb_notify_author','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(42,'cb_site_blog_entrypoint','blog',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(43,'cb_media_allowUploads','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(44,'cb_page_excerpts','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(45,'cb_html_preCommentForm','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(46,'cb_media_createFolders','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(47,'cb_site_mail_tls','false',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(48,'cb_media_html5uploads_maxFileSize','100',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(49,'cb_versions_commit_mandatory','false',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(50,'cb_comments_moderation_notify','false',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(51,'cb_site_tagline','My Awesome Site',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(52,'cb_site_mail_smtp','25',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(53,'cb_site_mail_username','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(54,'cb_comments_notify','false',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(55,'cb_rss_cachingTimeoutIdle','15',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(56,'cb_content_caching','true',b'0','2016-05-03 16:23:26','2017-06-13 14:34:04',b'0'),
	(57,'cb_search_adapter','contentbox.models.search.DBSearch',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(58,'cb_site_maintenance','false',b'0','2016-05-03 16:23:26','2016-08-05 11:46:13',b'0'),
	(59,'cb_html_afterSideBar','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(60,'cb_html_postCommentForm','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(61,'cb_rss_caching','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(62,'cb_paging_maxRSSComments','10',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(63,'cb_media_uplodify_fileDesc','All Files',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(64,'cb_site_description','My Awesome Site',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(65,'cb_paging_maxentries','10',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(66,'cb_html_postEntryDisplay','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(67,'cb_media_uploadify_allowMulti','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(68,'cb_html_afterBodyStart','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(69,'cb_html_afterFooter','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(70,'cb_site_theme','default',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(71,'cb_html_postIndexDisplay','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(72,'cb_gravatar_display','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(73,'cb_editors_ckeditor_excerpt_toolbar','[\r\n    { \"name\": \"document\",    \"items\" : [ \"Source\",\"ShowBlocks\" ] },\r\n    { \"name\": \"basicstyles\", \"items\" : [ \"Bold\",\"Italic\",\"Underline\",\"Strike\",\"Subscript\",\"Superscript\"] },\r\n    { \"name\": \"paragraph\",   \"items\" : [ \"NumberedList\",\"BulletedList\",\"-\",\"Outdent\",\"Indent\",\"CreateDiv\"] },\r\n    { \"name\": \"links\",       \"items\" : [ \"Link\",\"Unlink\",\"Anchor\" ] },\r\n    { \"name\": \"insert\",      \"items\" : [ \"Image\",\"Flash\",\"Table\",\"HorizontalRule\",\"Smiley\",\"SpecialChar\" ] },\r\n    { \"name\": \"contentbox\",  \"items\" : [ \"MediaEmbed\",\"cbIpsumLorem\",\"cbWidgets\",\"cbContentStore\",\"cbLinks\",\"cbEntryLinks\" ] }\r\n]',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(74,'cb_html_preArchivesDisplay','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(75,'cb_html_prePageDisplay','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(76,'cb_media_provider','CFContentMediaProvider',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(77,'cb_site_disable_blog','false',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(78,'cb_editors_markup','HTML',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(79,'cb_rss_maxEntries','10',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(80,'cb_site_homepage','support',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(81,'cb_editors_ckeditor_toolbar','[\r\n{ \"name\": \"document\",    \"items\" : [ \"Source\",\"-\",\"Maximize\",\"ShowBlocks\" ] },\r\n{ \"name\": \"clipboard\",   \"items\" : [ \"Cut\",\"Copy\",\"Paste\",\"PasteText\",\"PasteFromWord\",\"-\",\"Undo\",\"Redo\" ] },\r\n{ \"name\": \"editing\",     \"items\" : [ \"Find\",\"Replace\",\"SpellChecker\"] },\r\n{ \"name\": \"forms\",       \"items\" : [ \"Form\", \"Checkbox\", \"Radio\", \"TextField\", \"Textarea\", \"Select\", \"Button\",\"HiddenField\" ] },\r\n\"/\",\r\n{ \"name\": \"basicstyles\", \"items\" : [ \"Bold\",\"Italic\",\"Underline\",\"Strike\",\"Subscript\",\"Superscript\",\"-\",\"RemoveFormat\" ] },\r\n{ \"name\": \"paragraph\",   \"items\" : [ \"NumberedList\",\"BulletedList\",\"-\",\"Outdent\",\"Indent\",\"-\",\"Blockquote\",\"CreateDiv\",\"-\",\"JustifyLeft\",\"JustifyCenter\",\"JustifyRight\",\"JustifyBlock\",\"-\",\"BidiLtr\",\"BidiRtl\" ] },\r\n{ \"name\": \"links\",       \"items\" : [ \"Link\",\"Unlink\",\"Anchor\" ] },\r\n\"/\",\r\n{ \"name\": \"styles\",      \"items\" : [ \"Styles\",\"Format\" ] },\r\n{ \"name\": \"colors\",      \"items\" : [ \"TextColor\",\"BGColor\" ] },\r\n{ \"name\": \"insert\",      \"items\" : [ \"Image\",\"Flash\",\"Table\",\"HorizontalRule\",\"Smiley\",\"SpecialChar\",\"Iframe\",\"InsertPre\"] },\r\n{ \"name\": \"contentbox\",  \"items\" : [ \"MediaEmbed\",\"cbIpsumLorem\",\"cbWidgets\",\"cbContentStore\",\"cbLinks\",\"cbEntryLinks\" ] }\r\n]',b'0','2016-05-03 16:23:26','2016-05-06 15:47:29',b'0'),
	(82,'cb_comments_maxDisplayChars','500',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(83,'cb_rss_cachingTimeout','60',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(84,'cb_html_beforeSideBar','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(85,'cb_content_cacheName','TEMPLATE',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(86,'cb_dashboard_newsfeed_count','10',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(87,'cb_dashboard_newsfeed','http://www.ortussolutions.com/blog/rss',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(88,'cb_html_afterContent','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(89,'cb_rss_maxComments','10',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(90,'cb_media_directoryRoot','/contentbox-custom/_content',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(91,'cb_media_html5uploads_maxFiles','25',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(92,'cb_admin_quicksearch_max','10',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(93,'cb_media_allowDelete','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(94,'cb_dashboard_recentEntries','10',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(95,'cb_rss_cacheName','TEMPLATE',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(96,'cb_html_beforeBodyEnd','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(97,'cb_paging_bandgap','5',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(98,'cb_gravatar_rating','PG',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(99,'cb_notify_page','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(100,'cb_html_postPageDisplay','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(101,'cb_editors_default','ckeditor',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(102,'cb_content_cachingTimeoutIdle','15',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(103,'cb_comments_whoisURL','http://whois.arin.net/ui/query.do?q',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(104,'cb_entry_caching','true',b'0','2016-05-03 16:23:26','2017-06-13 14:34:04',b'0'),
	(105,'cb_active','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(106,'cb_layout_default_googleAnalyticsAPI','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(107,'cb_dashboard_recentContentStore','10',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(108,'cb_content_uiexport','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(109,'cbox-htmlcompressor','{\"REMOVEFORMATTRIBUTES\":false,\"RENDERCACHELASTACCESSTIMEOUT\":15,\"REMOVEMULTISPACES\":true,\"SIMPLEBOOLEANATTRIBUTES\":false,\"REMOVELINKATTRIBUTES\":false,\"REMOVESCRIPTATTRIBUTES\":false,\"RENDERCACHETIMEOUT\":60,\"RENDERCACHEPROVIDER\":\"template\",\"RENDERCACHING\":true,\"REMOVEHTTPSPROTOCOL\":false,\"PRESERVELINEBREAKS\":false,\"REMOVEJAVASCRIPTPROTOCOL\":false,\"REMOVESTYLEATTRIBUTES\":false,\"SIMPLEDOCTYPE\":false,\"REMOVECOMMENTS\":true,\"REMOVEQUOTES\":false,\"REMOVEINPUTATTRIBUTES\":false,\"REMOVEHTTPPROTOCOL\":false,\"COMPRESSCSS\":true,\"REMOVEINTERTAGSPACES\":false,\"RENDERCACHEPREFIX\":\"cbox-compressor\",\"RENDERCOMPRESSOR\":true,\"COMPRESSJAVASCRIPT\":true}',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(110,'cb_admin_theme','contentbox-default',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(116,'cb_notify_contentstore','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(117,'cb_comments_moderation_expiration','0',b'0','2016-05-03 16:23:26','2017-06-13 17:10:38',b'0'),
	(118,'cb_dashboard_welcome_title','Welcome To Your ContentBox Dashboard',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(119,'cb_dashboard_welcome_body','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(120,'cb_content_cachingHeader','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(121,'cb_site_poweredby','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(122,'jonathan','cool',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(123,'cb_enc_key','kcvHUKEWlMEmfZo5b5sRuA==',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(124,'cbox-htmlcompressor','{\"REMOVEFORMATTRIBUTES\":false,\"RENDERCACHELASTACCESSTIMEOUT\":15,\"REMOVEMULTISPACES\":true,\"SIMPLEBOOLEANATTRIBUTES\":false,\"REMOVELINKATTRIBUTES\":false,\"REMOVESCRIPTATTRIBUTES\":false,\"RENDERCACHETIMEOUT\":60,\"RENDERCACHEPROVIDER\":\"template\",\"RENDERCACHING\":true,\"REMOVEHTTPSPROTOCOL\":false,\"PRESERVELINEBREAKS\":false,\"REMOVEJAVASCRIPTPROTOCOL\":false,\"REMOVESTYLEATTRIBUTES\":false,\"SIMPLEDOCTYPE\":false,\"REMOVECOMMENTS\":true,\"REMOVEQUOTES\":false,\"REMOVEINPUTATTRIBUTES\":false,\"REMOVEHTTPPROTOCOL\":false,\"COMPRESSCSS\":true,\"REMOVEINTERTAGSPACES\":false,\"RENDERCACHEPREFIX\":\"cbox-compressor\",\"RENDERCOMPRESSOR\":true,\"COMPRESSJAVASCRIPT\":true}',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(125,'cb_rss_title','RSS Feed by ContentBox',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(126,'cb_rss_generator','ContentBox by Ortus Solutions',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(127,'cb_rss_copyright','Ortus Solutions, Corp (www.ortussolutions.com)',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(128,'cb_rss_description','ContentBox RSS Feed',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(129,'cb_rss_webmaster','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(130,'cb_content_hit_count','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(131,'cb_content_hit_ignore_bots','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(132,'cb_content_bot_regex','Google|msnbot|Rambler|Yahoo|AbachoBOT|accoona|AcioRobot|ASPSeek|CocoCrawler|Dumbot|FAST-WebCrawler|GeonaBot|Gigabot|Lycos|MSRBOT|Scooter|AltaVista|IDBot|eStyle|Scrubby',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(133,'cb_security_login_blocker','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(134,'cb_security_max_Attempts','5',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(135,'cb_security_blocktime','5',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(136,'cb_security_max_auth_logs','500',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(137,'cb_security_latest_logins','10',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(138,'cb_security_rate_limiter','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(139,'cb_security_rate_limiter_count','4',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(140,'cb_security_rate_limiter_duration','1',b'0','2016-05-03 16:23:26','2017-06-13 14:34:48',b'0'),
	(141,'cb_security_rate_limiter_bots_only','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(142,'cb_security_rate_limiter_message','<p>You are making too many requests too fast, please slow down and wait {duration} seconds</p>',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(158,'cb_theme_default_cbBootswatchTheme','green',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(159,'cb_theme_default_footerBox','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(160,'cb_theme_default_hpHeaderTitle','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(161,'cb_theme_default_hpHeaderText','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(162,'cb_theme_default_hpHeaderLink','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(163,'cb_theme_default_hpHeaderBg','World',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(164,'cb_theme_default_rssDiscovery','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(165,'cb_site_settings_cache','TEMPLATE',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(166,'cb_theme_default_showCategoriesBlogSide','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(167,'cb_theme_default_showRecentEntriesBlogSide','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(168,'cb_theme_default_showSiteUpdatesBlogSide','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(169,'cb_theme_default_showEntryCommentsBlogSide','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(170,'cb_theme_default_showArchivesBlogSide','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(171,'cb_theme_default_showEntriesSearchBlogSide','true',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(172,'cb_theme_default_headerLogo','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(173,'cb_theme_default_hpHeaderBtnText','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(174,'cb_theme_default_hpHeaderImgBg','',b'0','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(175,'cb_theme_default_showSiteSearch','true',b'0','2016-06-14 12:56:47','2016-06-14 12:56:47',b'0'),
	(176,'cb_theme_default_overrideHeaderColors','false',b'0','2017-06-13 11:52:39','2017-06-13 11:52:39',b'0'),
	(177,'cb_theme_default_overrideHeaderBGColor','',b'0','2017-06-13 11:52:39','2017-06-13 11:52:39',b'0'),
	(178,'cb_theme_default_overrideHeaderTextColor','',b'0','2017-06-13 11:52:39','2017-06-13 11:52:39',b'0'),
	(179,'cb_theme_default_cssStyleOverrides','',b'0','2017-06-13 11:52:39','2017-06-13 11:52:39',b'0'),
	(180,'cb_theme_default_hpHeaderBtnStyle','primary',b'0','2017-06-13 11:52:39','2017-06-13 11:52:39',b'0'),
	(181,'cb_theme_default_hpHeaderBgPos','Top Center',b'0','2017-06-13 11:52:39','2017-06-13 11:52:39',b'0'),
	(182,'cb_theme_default_hpHeaderBgPaddingTop','100px',b'0','2017-06-13 11:52:39','2017-06-13 11:52:39',b'0'),
	(183,'cb_theme_default_hpHeaderBgPaddingBottom','50px',b'0','2017-06-13 11:52:39','2017-06-13 11:52:39',b'0'),
	(184,'cb_site_sitemap','true',b'0','2017-06-13 14:32:33','2017-06-13 14:32:56',b'0'),
	(185,'cb_site_adminbar','true',b'1','2017-06-13 14:33:11','2017-06-13 14:33:11',b'0'),
	(186,'CB_SECURITY_RATE_LIMITER_LOGGING','true',b'1','2017-06-13 14:33:22','2017-06-13 14:33:22',b'0'),
	(187,'cb_security_rate_limiter_redirectURL','',b'1','2017-06-13 14:33:30','2017-06-13 14:33:30',b'0'),
	(188,'cb_security_min_password_length','8',b'1','2017-07-05 14:07:42','2017-07-05 14:40:56',b'0'),
	(189,'cb_security_2factorAuth_force','false',b'1','2017-07-20 11:43:43','2017-08-04 17:57:12',b'0'),
	(190,'cb_security_login_signout_url','',b'1','2017-07-20 11:49:47','2017-07-20 11:49:47',b'0'),
	(191,'cb_security_login_signin_text','',b'1','2017-07-20 13:48:21','2017-07-20 13:48:21',b'0'),
	(193,'cb_security_2factorAuth_provider','email',b'1','2017-07-31 15:59:15','2017-07-31 15:59:15',b'0'),
	(194,'cb_security_2factorAuth_trusted_days','30',b'1','2017-07-31 16:37:05','2017-07-31 16:37:05',b'0');

/*!40000 ALTER TABLE `cb_setting` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_stats
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_stats`;

CREATE TABLE `cb_stats` (
  `statsID` int(11) NOT NULL AUTO_INCREMENT,
  `hits` bigint(20) DEFAULT NULL,
  `FK_contentID` int(11) NOT NULL,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`statsID`),
  UNIQUE KEY `FK_contentID` (`FK_contentID`),
  KEY `FK14DE30BF91F58374` (`FK_contentID`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`),
  CONSTRAINT `FK14DE30BF91F58374` FOREIGN KEY (`FK_contentID`) REFERENCES `cb_content` (`contentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_stats` WRITE;
/*!40000 ALTER TABLE `cb_stats` DISABLE KEYS */;

INSERT INTO `cb_stats` (`statsID`, `hits`, `FK_contentID`, `createdDate`, `modifiedDate`, `isDeleted`)
VALUES
	(31,9,190,'2016-05-03 16:23:26','2016-12-02 19:42:07',b'0'),
	(32,2,191,'2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(33,4,189,'2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(35,118,147,'2016-05-03 16:23:26','2017-08-03 10:46:08',b'0'),
	(38,3,162,'2016-05-03 16:23:26','2016-12-02 19:42:05',b'0'),
	(39,1,160,'2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(43,3,207,'2016-05-18 11:35:32','2016-05-18 11:35:32',b'0'),
	(44,4,213,'2016-05-18 11:35:32','2017-07-18 15:21:37',b'0'),
	(45,1,192,'2016-05-18 11:48:04','2016-05-18 11:48:04',b'0'),
	(46,9,141,'2016-08-05 11:41:28','2016-08-05 11:52:22',b'0'),
	(47,29,142,'2016-11-28 14:56:53','2017-06-20 11:37:12',b'0');

/*!40000 ALTER TABLE `cb_stats` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_subscribers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_subscribers`;

CREATE TABLE `cb_subscribers` (
  `subscriberID` int(11) NOT NULL AUTO_INCREMENT,
  `subscriberEmail` varchar(255) NOT NULL,
  `subscriberToken` varchar(255) NOT NULL,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`subscriberID`),
  KEY `idx_createdDate` (`createdDate`),
  KEY `idx_subscriberEmail` (`subscriberEmail`),
  KEY `idx_subscriberCreatedDate` (`createdDate`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_subscribers` WRITE;
/*!40000 ALTER TABLE `cb_subscribers` DISABLE KEYS */;

INSERT INTO `cb_subscribers` (`subscriberID`, `subscriberEmail`, `subscriberToken`, `createdDate`, `modifiedDate`, `isDeleted`)
VALUES
	(1,'lmajano@ortussolutions.com','9160905AD002614B9A06E7A59F6F137F','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0'),
	(2,'lmajano@gmail.com','28B937F6F2F970189DB7ED3C909DE922','2016-05-03 16:23:26','2016-05-03 16:23:26',b'0');

/*!40000 ALTER TABLE `cb_subscribers` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cb_subscriptions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cb_subscriptions`;

CREATE TABLE `cb_subscriptions` (
  `subscriptionID` int(11) NOT NULL AUTO_INCREMENT,
  `subscriptionToken` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `createdDate` datetime NOT NULL,
  `FK_subscriberID` int(11) NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`subscriptionID`),
  KEY `FKE92A1716F2A66EE4` (`FK_subscriberID`),
  KEY `idx_subscriber` (`FK_subscriberID`),
  KEY `idx_createdDate` (`createdDate`),
  KEY `idx_subscriptionCreatedDate` (`createdDate`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`),
  CONSTRAINT `FKE92A1716F2A66EE4` FOREIGN KEY (`FK_subscriberID`) REFERENCES `cb_subscribers` (`subscriberID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cb_subscriptions` WRITE;
/*!40000 ALTER TABLE `cb_subscriptions` DISABLE KEYS */;

INSERT INTO `cb_subscriptions` (`subscriptionID`, `subscriptionToken`, `type`, `createdDate`, `FK_subscriberID`, `modifiedDate`, `isDeleted`)
VALUES
	(4,'AD2669C5064D113531970A672B887743','Comment','2015-08-04 16:17:43',2,'2016-05-03 16:23:25',b'0'),
	(5,'E880B3507068855A1EA3D333021267B3','Comment','2016-05-11 16:12:34',2,'2016-05-11 16:12:34',b'0'),
	(6,'CB8797B8A3C80D045D232DA79C9E6FD9','Comment','2016-05-12 12:34:18',1,'2016-05-12 12:34:18',b'0');

/*!40000 ALTER TABLE `cb_subscriptions` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
