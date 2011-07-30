# ************************************************************
# Sequel Pro SQL dump
# Version 3348
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: Localhost (MySQL 5.1.48)
# Database: blogbox
# Generation Time: 2011-07-30 18:04:32 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table bb_author
# ------------------------------------------------------------

DROP TABLE IF EXISTS `bb_author`;

CREATE TABLE `bb_author` (
  `authorID` int(11) NOT NULL AUTO_INCREMENT,
  `firstName` varchar(100) NOT NULL,
  `lastName` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `userName` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `isActive` bit(1) NOT NULL,
  `lastLogin` datetime DEFAULT NULL,
  `createdDate` datetime NOT NULL,
  PRIMARY KEY (`authorID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

LOCK TABLES `bb_author` WRITE;
/*!40000 ALTER TABLE `bb_author` DISABLE KEYS */;

INSERT INTO `bb_author` (`authorID`, `firstName`, `lastName`, `email`, `userName`, `password`, `isActive`, `lastLogin`, `createdDate`)
VALUES
	(1,'Luis','Majano','lmajano@gmail.com','lmajano','EE60C08DE56FCDAC31D7A0D8F2C8ED1D550A3670DCF577F43F0A44AB7523ECE6',b'1','2011-07-30 09:21:14','2011-07-08 00:00:00'),
	(7,'BlogBox','Administrator','youremail@email.com','blogbox','4C8FAE24422D4D3BD85CE10EB3366B4CEB48E370CB7C03BBE5A684234C0E8ABA',b'1',NULL,'2011-07-30 10:48:37');

/*!40000 ALTER TABLE `bb_author` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table bb_category
# ------------------------------------------------------------

DROP TABLE IF EXISTS `bb_category`;

CREATE TABLE `bb_category` (
  `categoryID` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(200) NOT NULL,
  `slug` varchar(200) NOT NULL,
  PRIMARY KEY (`categoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

LOCK TABLES `bb_category` WRITE;
/*!40000 ALTER TABLE `bb_category` DISABLE KEYS */;

INSERT INTO `bb_category` (`categoryID`, `category`, `slug`)
VALUES
	(1,'General','general'),
	(2,'Adobe Air','adobe-air'),
	(6,'Software Engineering','software-engineering'),
	(7,'ColdFusion','coldfusion'),
	(8,'Functions','functions'),
	(9,'ColdBox','coldbox'),
	(10,'Flex','flex'),
	(11,'Geek','geek'),
	(12,'Databases','databases'),
	(13,'Railo','railo');

/*!40000 ALTER TABLE `bb_category` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table bb_comment
# ------------------------------------------------------------

DROP TABLE IF EXISTS `bb_comment`;

CREATE TABLE `bb_comment` (
  `commentID` int(11) NOT NULL AUTO_INCREMENT,
  `content` longtext NOT NULL,
  `author` varchar(100) NOT NULL,
  `authorIP` varchar(100) NOT NULL,
  `authorEmail` varchar(255) NOT NULL,
  `isApproved` bit(1) NOT NULL,
  `FK_entryID` int(11) DEFAULT NULL,
  `authorURL` varchar(255) DEFAULT NULL,
  `createdDate` datetime NOT NULL,
  PRIMARY KEY (`commentID`),
  KEY `FKB85616066ED93A5` (`FK_entryID`),
  CONSTRAINT `FKB85616066ED93A5` FOREIGN KEY (`FK_entryID`) REFERENCES `bb_entry` (`entryID`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

LOCK TABLES `bb_comment` WRITE;
/*!40000 ALTER TABLE `bb_comment` DISABLE KEYS */;

INSERT INTO `bb_comment` (`commentID`, `content`, `author`, `authorIP`, `authorEmail`, `isApproved`, `FK_entryID`, `authorURL`, `createdDate`)
VALUES
	(10,'THis is is a great post\n','Luis Majano','22.44.1.44','lmajano@gmail.com',b'1',5,NULL,'2011-07-17 17:40:22'),
	(11,'What a bunch of joke man\n','Jose Morning','22.44.1.44','info@coldbox.org',b'1',5,NULL,'2011-07-17 17:40:22'),
	(14,'Wow, this is really amazing','Luis Majano','127.0.0.1','lmajano@gmail.com',b'1',5,'www.luismajano.com/index.cfm','2011-07-30 09:30:17'),
	(15,'sendNotificationEmails sendNotificationEmails','Luis Majano','127.0.0.1','lmajano@gmail.com',b'0',5,'www.luismajano.com/index.cfm','2011-07-30 09:34:45'),
	(16,'commentcommentcommentcomment','Luis Majano','127.0.0.1','lmajano@gmail.com',b'1',5,'www.luismajano.com/index.cfm','2011-07-30 09:49:23'),
	(17,'commentcommentcommentcomment','Luis Majano','127.0.0.1','lmajano@gmail.com',b'1',5,'www.luismajano.com/index.cfm','2011-07-30 09:50:48'),
	(18,'Urna arcu magna rhoncus scelerisque. Hac scelerisque arcu phasellus! In! Placerat a, eros! Tortor porta <a href=\"http://www.luismajano.com\">http://www.luismajano.com</a> amet cursus, ut tortor. Diam magna penatibus ridiculus, quis dignissim, enim! Et ac urna! In mattis in, elit velit scelerisque tincidunt elementum odio? Nunc! Eu vut sed turpis, urna turpis ac porta, parturient montes. Est in porttitor, duis, phasellus scelerisque porttitor pellentesque dis sit. Odio? Vel, proin pulvinar integer augue, dictumst in dignissim duis lacus proin porta placerat sed. In, nisi nunc,<a href=\"http://www.luismajano.com\">http://www.luismajano.com</a>  pellentesque sagittis. Tristique in habitasse turpis tincidunt sagittis, eu diam. Scelerisque integer? Arcu mattis pellentesque mattis vel! Dictumst! Cum lundium lectus montes! Scelerisque, placerat enim sit, nec! Facilisis arcu porta penatibus tortor, platea in a aenean sit ultricies enim turpis, penatibus nunc.\n\n<a href=\"http://www.luismajano.com\">http://www.luismajano.com</a> ','Luis Majano','127.0.0.1','lmajano@gmail.com',b'1',5,'www.luismajano.com/index.cfm','2011-07-30 09:52:40'),
	(19,'<a href=\"http://cf9cboxdev.jfetmac/blogbox-shell/blog/what-a-beautiful-posting#comments\">http://cf9cboxdev.jfetmac/blogbox-shell/blog/what-a-beautiful-posting#comments</a> ','Luis Majano','127.0.0.1','lmajano@gmail.com',b'1',5,'www.luismajano.com/index.cfm','2011-07-30 09:55:25'),
	(20,'Urna arcu magna rhoncus scelerisque. Hac scelerisque arcu phasellus! In! Placerat a, eros! Tortor porta <a href=\"http://www.luismajano.com\">http://www.luismajano.com</a> amet cursus, ut tortor. Diam magna penatibus ridiculus, quis dignissim, enim! Et ac urna! In mattis in, elit velit scelerisque tincidunt elementum odio? Nunc! Eu vut sed turpis, urna turpis ac porta, parturient montes. Est in porttitor, duis, phasellus scelerisque porttitor pellentesque dis sit. Odio? Vel, proin pulvinar integer augue, dictumst in dignissim duis lacus proin porta placerat sed. In, nisi nunc,<a href=\"http://www.luismajano.com\">http://www.luismajano.com</a>  pellentesque sagittis. Tristique in habitasse turpis tincidunt sagittis, eu diam. Scelerisque integer? Arcu mattis pellentesque mattis vel! Dictumst! Cum lundium lectus montes! Scelerisque, placerat enim sit, nec! Facilisis arcu porta penatibus tortor, platea in a aenean sit ultricies enim turpis, penatibus nunc.\n\n<a href=\"http://www.luismajano.com\">http://www.luismajano.com</a> ','Luis Majano','127.0.0.1','lmajano@gmail.com',b'1',5,'www.luismajano.com/index.cfm','2011-07-30 10:07:03'),
	(21,'<a href=\"http://cf9cboxdev.jfetmac/blogbox-shell/blog/what-a-beautiful-posting#comment_20\">http://cf9cboxdev.jfetmac/blogbox-shell/blog/what-a-beautiful-posting#comment_20</a> ','Luis Majano','127.0.0.1','lmajano@gmail.com',b'1',5,'www.luismajano.com/index.cfm','2011-07-30 10:09:18'),
	(22,'<a href=\"http://cf9cboxdev.jfetmac/blogbox-shell/blog/what-a-beautiful-posting#comment_20\">http://cf9cboxdev.jfetmac/blogbox-shell/blog/what-a-beautiful-posting#comment_20</a> ','Luis Majano','127.0.0.1','lmajano@gmail.com',b'1',5,'www.luismajano.com/index.cfm','2011-07-30 10:10:32'),
	(23,'anyKeywordMatchanyKeywordMatch','Luis Majano','127.0.0.1','lmajano@gmail.com',b'0',5,'www.luismajano.com/index.cfm','2011-07-30 10:11:22');

/*!40000 ALTER TABLE `bb_comment` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table bb_entry
# ------------------------------------------------------------

DROP TABLE IF EXISTS `bb_entry`;

CREATE TABLE `bb_entry` (
  `entryID` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `slug` varchar(200) NOT NULL,
  `content` longtext NOT NULL,
  `excerpt` longtext,
  `createdDate` datetime NOT NULL,
  `publishedDate` datetime DEFAULT NULL,
  `isPublished` bit(1) NOT NULL,
  `allowComments` bit(1) NOT NULL,
  `passwordProtection` varchar(100) DEFAULT NULL,
  `HTMLKeywords` varchar(160) DEFAULT NULL,
  `HTMLDescription` varchar(160) DEFAULT NULL,
  `hits` bigint(20) DEFAULT '0',
  `FK_authorID` int(11) DEFAULT NULL,
  PRIMARY KEY (`entryID`),
  KEY `FKAC3547B34289940B` (`FK_authorID`),
  CONSTRAINT `FKAC3547B34289940B` FOREIGN KEY (`FK_authorID`) REFERENCES `bb_author` (`authorID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

LOCK TABLES `bb_entry` WRITE;
/*!40000 ALTER TABLE `bb_entry` DISABLE KEYS */;

INSERT INTO `bb_entry` (`entryID`, `title`, `slug`, `content`, `excerpt`, `createdDate`, `publishedDate`, `isPublished`, `allowComments`, `passwordProtection`, `HTMLKeywords`, `HTMLDescription`, `hits`, `FK_authorID`)
VALUES
	(5,'What a beautiful posting','what-a-beautiful-posting','<p>\r\n	&nbsp;</p>\r\n<div class=\"post-title\" style=\"margin-left: 2px; margin-bottom: 30px; \">\r\n	<div class=\"post-content\" style=\"clear: both; padding-top: 10px; \">\r\n		<p style=\"font: normal normal normal 12px/normal Arial, Helvetica, sans-serif; color: rgb(68, 68, 68); padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; line-height: 1.8em; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; \">\r\n			Nec et sit. Porttitor! Et? In risus quis ultricies augue dapibus? A? A nisi! Porta platea mid et, aliquam tincidunt in aliquet sed, rhoncus dolor, aenean purus tristique sed, integer scelerisque proin sociis nunc, lundium? Mid lectus rhoncus vel, rhoncus porttitor, urna sed turpis, elit, ut tincidunt, sed in elementum turpis turpis tortor? Purus, aliquet pid lorem tincidunt enim purus lundium enim lundium. Et elementum? Magna montes? Rhoncus turpis! Montes duis urna quis sed? Tortor a in dictumst cum mid, turpis a sed platea vel et tristique, augue nec, habitasse platea sociis aenean porta nec lectus purus, cursus placerat parturient! Tempor! Pid elementum placerat, lorem lundium, elementum hac proin et tincidunt. Porta mus eu dignissim et, nisi nascetur diam.</p>\r\n		<p style=\"font: normal normal normal 12px/normal Arial, Helvetica, sans-serif; color: rgb(68, 68, 68); padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; line-height: 1.8em; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; \">\r\n			Odio, ac sagittis ac egestas porta sagittis in sagittis ac ultrices sit cras tortor habitasse enim amet. Etiam tempor. Dictumst enim etiam enim. Facilisis risus? Nunc tempor mattis! Turpis? Ultricies dis, augue eros porta parturient pid sit facilisis dolor nunc natoque aenean porta elementum sed? A aenean arcu ac arcu sit nunc est proin sit arcu in! Placerat odio. Et eu non dictumst eu dolor sed pellentesque nec! Enim eros urna, augue diam, integer turpis elementum proin! Risus nec! Mauris vut in etiam phasellus pellentesque ut et? Platea eu natoque elit tortor sit placerat enim, turpis augue sociis, elementum, massa dapibus duis duis, nunc aliquam lorem habitasse! Aliquet mauris cras? In habitasse vut. Porta, ultricies proin? Est integer, elementum</p>\r\n	</div>\r\n</div>\r\n<p>\r\n	&nbsp;</p>\r\n','','2011-07-17 17:40:22','2011-07-17 00:00:00',b'1',b'1','','','',372,1),
	(6,'This is just sooooo amazing','luis-23-4','<p>\r\n	&nbsp;</p>\r\n<p>\r\n	&nbsp;</p>\r\n<div class=\"post-title\" style=\"margin-left: 2px; margin-bottom: 30px; \">\r\n	<div class=\"post-content\" style=\"clear: both; padding-top: 10px; \">\r\n		<p style=\"font: normal normal normal 12px/normal Arial, Helvetica, sans-serif; color: rgb(68, 68, 68); padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; line-height: 1.8em; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; \">\r\n			Nec et sit. Porttitor! Et? In risus quis ultricies augue dapibus? A? A nisi! Porta platea mid et, aliquam tincidunt in aliquet sed, rhoncus dolor, aenean purus tristique sed, integer scelerisque proin sociis nunc, lundium? Mid lectus rhoncus vel, rhoncus porttitor, urna sed turpis, elit, ut tincidunt, sed in elementum turpis turpis tortor? Purus, aliquet pid lorem tincidunt enim purus lundium enim lundium. Et elementum? Magna montes? Rhoncus turpis! Montes duis urna quis sed? Tortor a in dictumst cum mid, turpis a sed platea vel et tristique, augue nec, habitasse platea sociis aenean porta nec lectus purus, cursus placerat parturient! Tempor! Pid elementum placerat, lorem lundium, elementum hac proin et tincidunt. Porta mus eu dignissim et, nisi nascetur diam.</p>\r\n		<p style=\"font: normal normal normal 12px/normal Arial, Helvetica, sans-serif; color: rgb(68, 68, 68); padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; line-height: 1.8em; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; \">\r\n			Odio, ac sagittis ac egestas porta sagittis in sagittis ac ultrices sit cras tortor habitasse enim amet. Etiam tempor. Dictumst enim etiam enim. Facilisis risus? Nunc tempor mattis! Turpis? Ultricies dis, augue eros porta parturient pid sit facilisis dolor nunc natoque aenean porta elementum sed? A aenean arcu ac arcu sit nunc est proin sit arcu in! Placerat odio. Et eu non dictumst eu dolor sed pellentesque nec! Enim eros urna, augue diam, integer turpis elementum proin! Risus nec! Mauris vut in etiam phasellus pellentesque ut et? Platea eu natoque elit tortor sit placerat enim, turpis augue sociis, elementum, massa dapibus duis duis, nunc aliquam lorem habitasse! Aliquet mauris cras? In habitasse vut. Porta, ultricies proin? Est integer, elementum</p>\r\n		<div>\r\n			&nbsp;</div>\r\n		<div>\r\n			<div class=\"post-title\" style=\"margin-left: 2px; margin-bottom: 30px; \">\r\n				<div class=\"post-content\" style=\"clear: both; padding-top: 10px; \">\r\n					<p style=\"font: normal normal normal 12px/normal Arial, Helvetica, sans-serif; color: rgb(68, 68, 68); padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; line-height: 1.8em; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; \">\r\n						Nec et sit. Porttitor! Et? In risus quis ultricies augue dapibus? A? A nisi! Porta platea mid et, aliquam tincidunt in aliquet sed, rhoncus dolor, aenean purus tristique sed, integer scelerisque proin sociis nunc, lundium? Mid lectus rhoncus vel, rhoncus porttitor, urna sed turpis, elit, ut tincidunt, sed in elementum turpis turpis tortor? Purus, aliquet pid lorem tincidunt enim purus lundium enim lundium. Et elementum? Magna montes? Rhoncus turpis! Montes duis urna quis sed? Tortor a in dictumst cum mid, turpis a sed platea vel et tristique, augue nec, habitasse platea sociis aenean porta nec lectus purus, cursus placerat parturient! Tempor! Pid elementum placerat, lorem lundium, elementum hac proin et tincidunt. Porta mus eu dignissim et, nisi nascetur diam.</p>\r\n					<p style=\"font: normal normal normal 12px/normal Arial, Helvetica, sans-serif; color: rgb(68, 68, 68); padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; line-height: 1.8em; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; \">\r\n						Odio, ac sagittis ac egestas porta sagittis in sagittis ac ultrices sit cras tortor habitasse enim amet. Etiam tempor. Dictumst enim etiam enim. Facilisis risus? Nunc tempor mattis! Turpis? Ultricies dis, augue eros porta parturient pid sit facilisis dolor nunc natoque aenean porta elementum sed? A aenean arcu ac arcu sit nunc est proin sit arcu in! Placerat odio. Et eu non dictumst eu dolor sed pellentesque nec! Enim eros urna, augue diam, integer turpis elementum proin! Risus nec! Mauris vut in etiam phasellus pellentesque ut et? Platea eu natoque elit tortor sit placerat enim, turpis augue sociis, elementum, massa dapibus duis duis, nunc aliquam lorem habitasse! Aliquet mauris cras? In habitasse vut. Porta, ultricies proin? Est integer, elementum</p>\r\n					<div>\r\n						&nbsp;</div>\r\n					<div>\r\n						<div class=\"post-title\" style=\"margin-left: 2px; margin-bottom: 30px; \">\r\n							<div class=\"post-content\" style=\"clear: both; padding-top: 10px; \">\r\n								<p style=\"font: normal normal normal 12px/normal Arial, Helvetica, sans-serif; color: rgb(68, 68, 68); padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; line-height: 1.8em; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; \">\r\n									Nec et sit. Porttitor! Et? In risus quis ultricies augue dapibus? A? A nisi! Porta platea mid et, aliquam tincidunt in aliquet sed, rhoncus dolor, aenean purus tristique sed, integer scelerisque proin sociis nunc, lundium? Mid lectus rhoncus vel, rhoncus porttitor, urna sed turpis, elit, ut tincidunt, sed in elementum turpis turpis tortor? Purus, aliquet pid lorem tincidunt enim purus lundium enim lundium. Et elementum? Magna montes? Rhoncus turpis! Montes duis urna quis sed? Tortor a in dictumst cum mid, turpis a sed platea vel et tristique, augue nec, habitasse platea sociis aenean porta nec lectus purus, cursus placerat parturient! Tempor! Pid elementum placerat, lorem lundium, elementum hac proin et tincidunt. Porta mus eu dignissim et, nisi nascetur diam.</p>\r\n								<p style=\"font: normal normal normal 12px/normal Arial, Helvetica, sans-serif; color: rgb(68, 68, 68); padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; line-height: 1.8em; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; \">\r\n									Odio, ac sagittis ac egestas porta sagittis in sagittis ac ultrices sit cras tortor habitasse enim amet. Etiam tempor. Dictumst enim etiam enim. Facilisis risus? Nunc tempor mattis! Turpis? Ultricies dis, augue eros porta parturient pid sit facilisis dolor nunc natoque aenean porta elementum sed? A aenean arcu ac arcu sit nunc est proin sit arcu in! Placerat odio. Et eu non dictumst eu dolor sed pellentesque nec! Enim eros urna, augue diam, integer turpis elementum proin! Risus nec! Mauris vut in etiam phasellus pellentesque ut et? Platea eu natoque elit tortor sit placerat enim, turpis augue sociis, elementum, massa dapibus duis duis, nunc aliquam lorem habitasse! Aliquet mauris cras? In habitasse vut. Porta, ultricies proin? Est integer, elementum</p>\r\n								<div>\r\n									&nbsp;</div>\r\n								<div>\r\n									<div class=\"post-title\" style=\"margin-left: 2px; margin-bottom: 30px; \">\r\n										<div class=\"post-content\" style=\"clear: both; padding-top: 10px; \">\r\n											<p style=\"font: normal normal normal 12px/normal Arial, Helvetica, sans-serif; color: rgb(68, 68, 68); padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; line-height: 1.8em; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; \">\r\n												Nec et sit. Porttitor! Et? In risus quis ultricies augue dapibus? A? A nisi! Porta platea mid et, aliquam tincidunt in aliquet sed, rhoncus dolor, aenean purus tristique sed, integer scelerisque proin sociis nunc, lundium? Mid lectus rhoncus vel, rhoncus porttitor, urna sed turpis, elit, ut tincidunt, sed in elementum turpis turpis tortor? Purus, aliquet pid lorem tincidunt enim purus lundium enim lundium. Et elementum? Magna montes? Rhoncus turpis! Montes duis urna quis sed? Tortor a in dictumst cum mid, turpis a sed platea vel et tristique, augue nec, habitasse platea sociis aenean porta nec lectus purus, cursus placerat parturient! Tempor! Pid elementum placerat, lorem lundium, elementum hac proin et tincidunt. Porta mus eu dignissim et, nisi nascetur diam.</p>\r\n											<p style=\"font: normal normal normal 12px/normal Arial, Helvetica, sans-serif; color: rgb(68, 68, 68); padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; line-height: 1.8em; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; \">\r\n												Odio, ac sagittis ac egestas porta sagittis in sagittis ac ultrices sit cras tortor habitasse enim amet. Etiam tempor. Dictumst enim etiam enim. Facilisis risus? Nunc tempor mattis! Turpis? Ultricies dis, augue eros porta parturient pid sit facilisis dolor nunc natoque aenean porta elementum sed? A aenean arcu ac arcu sit nunc est proin sit arcu in! Placerat odio. Et eu non dictumst eu dolor sed pellentesque nec! Enim eros urna, augue diam, integer turpis elementum proin! Risus nec! Mauris vut in etiam phasellus pellentesque ut et? Platea eu natoque elit tortor sit placerat enim, turpis augue sociis, elementum, massa dapibus duis duis, nunc aliquam lorem habitasse! Aliquet mauris cras? In habitasse vut. Porta, ultricies proin? Est integer, elementum</p>\r\n											<div>\r\n												&nbsp;</div>\r\n										</div>\r\n									</div>\r\n								</div>\r\n							</div>\r\n						</div>\r\n					</div>\r\n				</div>\r\n			</div>\r\n		</div>\r\n	</div>\r\n</div>\r\n<p>\r\n	&nbsp;</p>\r\n','','2011-07-17 17:45:03','2011-07-17 00:00:00',b'1',b'1','','','',2,1),
	(7,'This is my very first entry dudes!','this-is-my-very-first-entry-dudes','<p>\r\n	&nbsp;</p>\r\n<p style=\"margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; background-position: initial initial; background-repeat: initial initial; \">\r\n	Turpis vut magnis dapibus ac, sed? Augue, scelerisque lundium enim diam enim tincidunt, in ut hac porta urna! Duis. Porta dapibus mattis etiam aenean, mid arcu adipiscing! Sit? Lacus ridiculus elementum a! Integer magnis nascetur, in! Tempor eu et arcu? Eu nascetur, mauris rhoncus enim pid nec integer a habitasse! Platea aenean, tempor, arcu, amet ac nec, a turpis aliquet dapibus et ut nisi lectus scelerisque. Ac tristique montes odio tristique penatibus, magna platea nunc. Tempor massa, dis? Augue rhoncus etiam purus lundium tincidunt tincidunt porta scelerisque dapibus mid etiam, placerat placerat. Natoque nisi a porttitor. Magna massa porttitor augue ultrices tristique integer natoque, arcu, vel auctor amet augue, pulvinar, rhoncus dis, porttitor turpis. Placerat enim arcu, magnis porta, risus.</p>\r\n<p style=\"margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; background-position: initial initial; background-repeat: initial initial; \">\r\n	Non amet ac nascetur, nascetur ultricies urna, elementum adipiscing pellentesque porttitor? Ut nisi aliquet. In! Amet aliquet augue odio, ut amet, proin tortor! Cum dictumst augue pid magna. Dictumst tristique amet sit habitasse ultrices, tincidunt, turpis dis sociis! Mid porta. Magna. Turpis hac aliquam turpis ridiculus amet ac porta magnis nec, odio ac, porttitor pid elit elementum nisi platea tristique ut mid odio, et tempor dolor rhoncus sit vel porta urna, sociis purus nisi massa dignissim aliquam. Aenean auctor? Mid et, pid facilisis sed ridiculus ac pellentesque vel pid! Tincidunt, tristique diam ac tristique eros, tincidunt urna pellentesque. Ridiculus diam nec, sit eros? Lacus. Et pid a tristique penatibus et odio a dapibus! Tristique sed duis ut non purus.</p>\r\n<p style=\"margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; background-position: initial initial; background-repeat: initial initial; \">\r\n	Nec et sit. Porttitor! Et? In risus quis ultricies augue dapibus? A? A nisi! Porta platea mid et, aliquam tincidunt in aliquet sed, rhoncus dolor, aenean purus tristique sed, integer scelerisque proin sociis nunc, lundium? Mid lectus rhoncus vel, rhoncus porttitor, urna sed turpis, elit, ut tincidunt, sed in elementum turpis turpis tortor? Purus, aliquet pid lorem tincidunt enim purus lundium enim lundium. Et elementum? Magna montes? Rhoncus turpis! Montes duis urna quis sed? Tortor a in dictumst cum mid, turpis a sed platea vel et tristique, augue nec, habitasse platea sociis aenean porta nec lectus purus, cursus placerat parturient! Tempor! Pid elementum placerat, lorem lundium, elementum hac proin et tincidunt. Porta mus eu dignissim et, nisi nascetur diam.</p>\r\n<p style=\"margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; background-position: initial initial; background-repeat: initial initial; \">\r\n	Odio, ac sagittis ac egestas porta sagittis in sagittis ac ultrices sit cras tortor habitasse enim amet. Etiam tempor. Dictumst enim etiam enim. Facilisis risus? Nunc tempor mattis! Turpis? Ultricies dis, augue eros porta parturient pid sit facilisis dolor nunc natoque aenean porta elementum sed? A aenean arcu ac arcu sit nunc est proin sit arcu in! Placerat odio. Et eu non dictumst eu dolor sed pellentesque nec! Enim eros urna, augue diam, integer turpis elementum proin! Risus nec! Mauris vut in etiam phasellus pellentesque ut et? Platea eu natoque elit tortor sit placerat enim, turpis augue sociis, elementum, massa dapibus duis duis, nunc aliquam lorem habitasse! Aliquet mauris cras? In habitasse vut. Porta, ultricies proin? Est integer, elementum.</p>\r\n','<p>\r\n	&nbsp;</p>\r\n<p style=\"margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; display: inline !important; \">\r\n	<b>Odio, ac sagittis ac egestas porta sagittis in sagittis ac ultrices sit cras tortor habitasse enim amet. Etiam tempor. Dictumst enim etiam enim. Facilisis risus? Nunc tempor mattis! Turpis? Ultricies dis, augue eros porta parturient pid sit facilisis dolor nunc natoque aenean porta elementum sed? A aenean arcu ac arcu sit nunc est proin sit arcu in! Placerat odio. Et eu non dictumst eu dolor sed pellentesque nec! Enim eros urna, augue diam, integer turpis elementum proin! Risus nec! Mauris vut in etiam phasellus pellentesque ut et? Platea eu natoque elit tortor sit placerat enim, turpis augue sociis, elementum, massa dapibus duis duis, nunc aliquam lorem habitasse! Aliquet mauris cras? In habitasse vut. Porta, ultricies proin? Est integer, elementum.</b></p>\r\n','2011-07-19 12:41:49','2011-07-19 00:00:00',b'1',b'1','','','',5,1),
	(8,'Test','test','<p>\r\n	&nbsp;</p>\r\n<p style=\"margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; background-position: initial initial; background-repeat: initial initial; \">\r\n	Turpis vut magnis dapibus ac, sed? Augue, scelerisque lundium enim diam enim tincidunt, in ut hac porta urna! Duis. Porta dapibus mattis etiam aenean, mid arcu adipiscing! Sit? Lacus ridiculus elementum a! Integer magnis nascetur, in! Tempor eu et arcu? Eu nascetur, mauris rhoncus enim pid nec integer a habitasse! Platea aenean, tempor, arcu, amet ac nec, a turpis aliquet dapibus et ut nisi lectus scelerisque. Ac tristique montes odio tristique penatibus, magna platea nunc. Tempor massa, dis? Augue rhoncus etiam purus lundium tincidunt tincidunt porta scelerisque dapibus mid etiam, placerat placerat. Natoque nisi a porttitor. Magna massa porttitor augue ultrices tristique integer natoque, arcu, vel auctor amet augue, pulvinar, rhoncus dis, porttitor turpis. Placerat enim arcu, magnis porta, risus.</p>\r\n<p style=\"margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; background-position: initial initial; background-repeat: initial initial; \">\r\n	Non amet ac nascetur, nascetur ultricies urna, elementum adipiscing pellentesque porttitor? Ut nisi aliquet. In! Amet aliquet augue odio, ut amet, proin tortor! Cum dictumst augue pid magna. Dictumst tristique amet sit habitasse ultrices, tincidunt, turpis dis sociis! Mid porta. Magna. Turpis hac aliquam turpis ridiculus amet ac porta magnis nec, odio ac, porttitor pid elit elementum nisi platea tristique ut mid odio, et tempor dolor rhoncus sit vel porta urna, sociis purus nisi massa dignissim aliquam. Aenean auctor? Mid et, pid facilisis sed ridiculus ac pellentesque vel pid! Tincidunt, tristique diam ac tristique eros, tincidunt urna pellentesque. Ridiculus diam nec, sit eros? Lacus. Et pid a tristique penatibus et odio a dapibus! Tristique sed duis ut non purus.</p>\r\n<p style=\"margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; background-position: initial initial; background-repeat: initial initial; \">\r\n	Nec et sit. Porttitor! Et? In risus quis ultricies augue dapibus? A? A nisi! Porta platea mid et, aliquam tincidunt in aliquet sed, rhoncus dolor, aenean purus tristique sed, integer scelerisque proin sociis nunc, lundium? Mid lectus rhoncus vel, rhoncus porttitor, urna sed turpis, elit, ut tincidunt, sed in elementum turpis turpis tortor? Purus, aliquet pid lorem tincidunt enim purus lundium enim lundium. Et elementum? Magna montes? Rhoncus turpis! Montes duis urna quis sed? Tortor a in dictumst cum mid, turpis a sed platea vel et tristique, augue nec, habitasse platea sociis aenean porta nec lectus purus, cursus placerat parturient! Tempor! Pid elementum placerat, lorem lundium, elementum hac proin et tincidunt. Porta mus eu dignissim et, nisi nascetur diam.</p>\r\n<p style=\"margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; background-position: initial initial; background-repeat: initial initial; \">\r\n	Odio, ac sagittis ac egestas porta sagittis in sagittis ac ultrices sit cras tortor habitasse enim amet. Etiam tempor. Dictumst enim etiam enim. Facilisis risus? Nunc tempor mattis! Turpis? Ultricies dis, augue eros porta parturient pid sit facilisis dolor nunc natoque aenean porta elementum sed? A aenean arcu ac arcu sit nunc est proin sit arcu in! Placerat odio. Et eu non dictumst eu dolor sed pellentesque nec! Enim eros urna, augue diam, integer turpis elementum proin! Risus nec! Mauris vut in etiam phasellus pellentesque ut et? Platea eu natoque elit tortor sit placerat enim, turpis augue sociis, elementum, massa dapibus duis duis, nunc aliquam lorem habitasse! Aliquet mauris cras? In habitasse vut. Porta, ultricies proin? Est integer, elementum.</p>\r\n','','2011-07-19 17:08:50','2011-07-19 00:00:00',b'1',b'1','','','',2,1),
	(9,'An awesome quick post','an-awesome-quick-post','<p>\r\n	&nbsp;</p>\r\n<p style=\"margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; background-position: initial initial; background-repeat: initial initial; \">\r\n	Aliquam mus placerat diam aliquet, integer. Platea, amet? Turpis aliquam, in, enim! Sociis! In, auctor, non porttitor nec, tempor integer cursus a magnis scelerisque vel non etiam integer! Penatibus egestas? Magna penatibus porttitor ridiculus? Sit rhoncus, dictumst odio porttitor ut ac montes, phasellus placerat non natoque ultricies natoque, porta nec eu, pellentesque quis et, tincidunt. Aliquam! Nec habitasse parturient duis, habitasse augue in magna, hac pulvinar, in mattis, sed pellentesque egestas habitasse? Nisi ridiculus magnis lectus, lorem velit egestas rhoncus placerat integer pellentesque dapibus? Ut montes urna ac. Vut pulvinar nec mauris a ut pulvinar nec? A eu, cursus cras, dictumst nascetur vel mauris augue, parturient scelerisque dictumst, habitasse vel dignissim elementum! Auctor! Hac elementum sit. Tortor lorem rhoncus ultrices.</p>\r\n<p style=\"margin-top: 0px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 13px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; background-position: initial initial; background-repeat: initial initial; \">\r\n	Rhoncus mus pellentesque, eros et! Turpis nec, scelerisque placerat nunc ut. Ridiculus sed dolor, turpis cum sagittis, placerat aliquam mauris hac urna duis, scelerisque porta, natoque nec sagittis sociis. Nunc, porttitor, mid platea porttitor augue, nec sed nunc risus! Vel vel a ac augue ut turpis porttitor! Mauris augue, sit integer vut vut massa augue rhoncus eu egestas nascetur. Sed mid duis et, diam dictumst, lectus et scelerisque lorem montes hac, vel ac, dictumst, turpis aenean adipiscing turpis velit habitasse et enim aliquet pellentesque est rhoncus montes, proin dapibus, duis tortor a mauris aliquam enim purus sit ac lacus. Et! Turpis, porttitor dolor. Dis est magna nec, augue proin lacus pid pulvinar vut. Cursus? Integer pulvinar? Ultrices, porta a.</p>\r\n','','2011-07-27 00:11:54','2011-07-27 00:00:00',b'1',b'1','','','',28,1),
	(10,'ColdBox Connection July/28 - Intro to ColdBox And Railo','coldbox-connection-july-28-intro-to-coldbox-and-railo','<p>\r\n	This week&#39;s ColdBox Connection will be our first hosted by a ColdBox Community Member! The ColdBox Team is stepping back give Ben Laube an opportunity to help remind us of the basics as he presents &quot;Introduction to ColdBox&quot;.&nbsp;</p>\r\n<p>\r\n	<strong>This meeting was rescheduled from last week as we had some technical difficulties!</strong></p>\r\n<p>\r\n	If you have been thinking about getting started with ColdBox and wanted to know the easiest way to get started this presentation is for you. Ben will start without any CFML engine installed and take us from Installation to Application in about twenty minutes. This presentation will focus on getting started with ColdBox 3.0 and Railo Express Edition.</p>\r\n<p>\r\n	Join us Thursday July 28th at 10AM PDT / 1PM EDT to learn how to get started with ColdBox. Connection information can be found here:&nbsp;<a href=\"http://www.coldbox.org/media/connection\">http://www.coldbox.org/media/connection</a></p>\r\n<p>\r\n	<img alt=\"Photo of Ben Laube\" height=\"233\" src=\"http://blog.coldbox.org/assets/content/images/event_30539381.jpeg\" style=\"margin: 10px;\" width=\"360\" /></p>\r\n','','2011-07-27 00:32:59','2011-07-27 00:00:00',b'1',b'0','','','',18,1);

/*!40000 ALTER TABLE `bb_entry` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table bb_entryCategories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `bb_entryCategories`;

CREATE TABLE `bb_entryCategories` (
  `FK_entryID` int(11) NOT NULL,
  `FK_categoryID` int(11) NOT NULL,
  KEY `FKFB8AA62F1AC77BB1` (`FK_categoryID`),
  KEY `FKFB8AA62F66ED93A5` (`FK_entryID`),
  CONSTRAINT `FKFB8AA62F66ED93A5` FOREIGN KEY (`FK_entryID`) REFERENCES `bb_entry` (`entryID`),
  CONSTRAINT `FKFB8AA62F1AC77BB1` FOREIGN KEY (`FK_categoryID`) REFERENCES `bb_category` (`categoryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `bb_entryCategories` WRITE;
/*!40000 ALTER TABLE `bb_entryCategories` DISABLE KEYS */;

INSERT INTO `bb_entryCategories` (`FK_entryID`, `FK_categoryID`)
VALUES
	(9,9),
	(9,2),
	(9,12),
	(9,7),
	(10,13),
	(10,9),
	(10,7),
	(7,6),
	(7,1),
	(7,13),
	(5,12),
	(5,7),
	(6,12),
	(6,7);

/*!40000 ALTER TABLE `bb_entryCategories` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table bb_setting
# ------------------------------------------------------------

DROP TABLE IF EXISTS `bb_setting`;

CREATE TABLE `bb_setting` (
  `settingID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `value` longtext NOT NULL,
  PRIMARY KEY (`settingID`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;

LOCK TABLES `bb_setting` WRITE;
/*!40000 ALTER TABLE `bb_setting` DISABLE KEYS */;

INSERT INTO `bb_setting` (`settingID`, `name`, `value`)
VALUES
	(3,'bb_site_name','BlogBox by ColdBox'),
	(4,'bb_site_email','myemail@email.com'),
	(5,'bb_site_tagline','A Sweet Blogging Platform'),
	(6,'bb_paging_maxrows','10'),
	(7,'bb_paging_bandgap','5'),
	(8,'bb_gravatar_display','true'),
	(9,'bb_gravatar_rating','PG'),
	(11,'bb_comments_whoisURL','http://whois.arin.net/ui/query.do?q'),
	(12,'bb_comments_maxDisplayChars','500'),
	(13,'bb_dashboard_recentEntries','5'),
	(14,'bb_dashboard_recentComments','5'),
	(15,'bb_comments_enabled','true'),
	(16,'bb_comments_urltranslations','true'),
	(17,'bb_comments_moderation','true'),
	(18,'bb_comments_moderation_whitelist','true'),
	(19,'bb_comments_notify','true'),
	(20,'bb_comments_moderation_notify','true'),
	(21,'bb_comments_notifyemails',''),
	(22,'bb_site_description','Welcome to the most awesome and sweetest blogging platform on planet earth!  Please feel to poke around and learn about BlogBox, a blogging platform powered by ColdBox.'),
	(23,'bb_comments_moderation_blacklist',''),
	(24,'bb_comments_moderation_blockedlist',''),
	(25,'bb_site_keywords','BlogBox,ColdBox Platform,Blogging Platform, Blog,Enterprise Blog,ColdFusion Blog,coldfusion,adobe,railo,flex,air,RESTful blog'),
	(26,'bb_notify_author','true'),
	(27,'bb_paging_maxentries','10'),
	(28,'bb_paging_maxRSSEntries','10'),
	(29,'bb_notify_entry','false'),
	(30,'bb_site_outgoingEmail','myemail@email.com'),
	(31,'bb_html_beforeHeadEnd',''),
	(32,'bb_html_afterBodyStart',''),
	(33,'bb_html_beforeBodyEnd',''),
	(34,'bb_html_beforeSideBar',''),
	(35,'bb_html_afterSideBar',''),
	(36,'bb_easter_videos','http://youtu.be/j4G1L8lV6LQ,http://youtu.be/lyl5DlrsU90,http://youtu.be/btPJPFnesV4,http://youtu.be/lSVnt3--Nnk,http://youtu.be/c1Wr3aHqBLA,http://youtu.be/Pxp6XSRmDMY, http://youtu.be/4DO8GsIYfhQ,http://youtu.be/pRpeEdMmmQ0,http://youtu.be/4jdvbuCXl0M'),
	(37,'bb_site_layout','default'),
	(38,'bb_comments_captcha','true');

/*!40000 ALTER TABLE `bb_setting` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
