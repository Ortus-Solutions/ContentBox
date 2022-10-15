/*
 Navicat SQL Server Data Transfer

 Source Server         : contentbox-mssql
 Source Server Type    : SQL Server
 Source Server Version : 14000800
 Source Host           : localhost:1433
 Source Catalog        : contentbox
 Source Schema         : dbo

 Target Server Type    : SQL Server
 Target Server Version : 14000800
 File Encoding         : 65001

 Date: 18/07/2017 15:09:38
*/


DROP DATABASE contentbox;
CREATE DATABASE contentbox;

-- ----------------------------
-- Table structure for cb_author
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_author]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_author]
GO

CREATE TABLE [dbo].[cb_author] (
  [authorID] int IDENTITY(1,1) NOT NULL,
  [createdDate] datetime NOT NULL,
  [modifiedDate] datetime NOT NULL,
  [isDeleted] bit DEFAULT ((0)) NOT NULL,
  [firstName] varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [lastName] varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [email] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [username] varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [password] varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [isActive] tinyint NOT NULL,
  [lastLogin] datetime NULL,
  [biography] text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [preferences] text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [isPasswordReset] bit DEFAULT ((0)) NOT NULL,
  [FK_roleID] int NOT NULL
)
GO

ALTER TABLE [dbo].[cb_author] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_author]
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[cb_author] ON
GO

INSERT INTO [dbo].[cb_author] ([authorID], [createdDate], [modifiedDate], [isDeleted], [firstName], [lastName], [email], [username], [password], [isActive], [lastLogin], [biography], [preferences], [isPasswordReset], [FK_roleID]) VALUES (N'1', N'2013-07-11 11:06:39.000', N'2017-07-18 14:45:49.733', N'0', N'Luis', N'Majano', N'lmajano@gmail.com', N'lmajano', N'$2a$12$KU4n4ZQf3cd/ULCuvc8PIO9VrQKi7eKbcEuQaILTJ/sdcjXvT31YK', N'1', N'2017-07-18 13:56:27.150', N'', N'{"editor":"simplemde"}', N'0', N'2')
GO

INSERT INTO [dbo].[cb_author] ([authorID], [createdDate], [modifiedDate], [isDeleted], [firstName], [lastName], [email], [username], [password], [isActive], [lastLogin], [biography], [preferences], [isPasswordReset], [FK_roleID]) VALUES (N'2', N'2013-07-11 11:07:23.000', N'2017-06-21 18:29:30.000', N'0', N'Lui', N'Majano', N'lmajano@ortussolutions.com', N'luismajano', N'$2a$12$KU4n4ZQf3cd/ULCuvc8PIO9VrQKi7eKbcEuQaILTJ/sdcjXvT31YK', N'1', N'2015-07-29 14:38:46.000', N'', N'{\"GOOGLE\":\"\",\"EDITOR\":\"ckeditor\",\"TWITTER\":\"http:\\/\\/twitter.com\\/lmajano\",\"FACEBOOK\":\"http:\\/\\/facebook.com\\/lmajano\"}', N'0', N'2')
GO

INSERT INTO [dbo].[cb_author] ([authorID], [createdDate], [modifiedDate], [isDeleted], [firstName], [lastName], [email], [username], [password], [isActive], [lastLogin], [biography], [preferences], [isPasswordReset], [FK_roleID]) VALUES (N'3', N'2013-07-11 11:07:23.000', N'2017-07-06 12:18:13.000', N'0', N'Tester', N'Majano', N'lmajano@testing.com', N'testermajano', N'$2a$12$FE058d9bj7Sv6tPmvZMaleC2x8.b.tRqVei5p/5XqPytSNpF5eCym', N'1', N'2017-07-06 12:13:14.000', N'', N'{\"sidemenuCollapse\":\"no\",\"google\":\"\",\"sidebarState\":\"true\",\"markup\":\"HTML\",\"editor\":\"ckeditor\",\"twitter\":\"http://twitter.com/lmajano\",\"facebook\":\"http://facebook.com/lmajano\"}', N'0', N'1')
GO

INSERT INTO [dbo].[cb_author] ([authorID], [createdDate], [modifiedDate], [isDeleted], [firstName], [lastName], [email], [username], [password], [isActive], [lastLogin], [biography], [preferences], [isPasswordReset], [FK_roleID]) VALUES (N'4', N'2017-07-06 11:30:59.000', N'2017-07-06 11:54:11.000', N'0', N'Joe', N'Joe', N'joejoe@joe.com', N'joejoe', N'$2a$12$.FrcqDLb3DNIK2TqJo0aQuwB3WSxAW0KmJUKKPaAQV7VoYwihDM1.', N'1', N'2017-07-06 11:38:28.000', N'', N'{\"linkedin\":\"\",\"markup\":\"HTML\",\"website\":\"\",\"editor\":\"ckeditor\",\"twitter\":\"\",\"facebook\":\"\"}', N'1', N'2')
GO

INSERT INTO [dbo].[cb_author] ([authorID], [createdDate], [modifiedDate], [isDeleted], [firstName], [lastName], [email], [username], [password], [isActive], [lastLogin], [biography], [preferences], [isPasswordReset], [FK_roleID]) VALUES (N'5', N'2017-07-06 12:07:02.000', N'2017-07-06 12:07:02.000', N'0', N'Jorge', N'Morelos', N'joremorelos@morelos.com', N'joremorelos@morelos.com', N'$2a$12$IBAYihdRG.Hj8fh/fztmi.MvFRn2lPxk4Thw1mnmbVzjoLnNCgzOe', N'1', NULL, N'', N'{\"linkedin\":\"\",\"markup\":\"HTML\",\"website\":\"\",\"editor\":\"ckeditor\",\"twitter\":\"\",\"facebook\":\"\"}', N'1', N'2')
GO

SET IDENTITY_INSERT [dbo].[cb_author] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_authorPermissionGroups
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_authorPermissionGroups]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_authorPermissionGroups]
GO

CREATE TABLE [dbo].[cb_authorPermissionGroups] (
  [FK_authorID] int NOT NULL,
  [FK_permissionGroupID] int NOT NULL
)
GO

ALTER TABLE [dbo].[cb_authorPermissionGroups] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_authorPermissionGroups]
-- ----------------------------
BEGIN TRANSACTION
GO

INSERT INTO [dbo].[cb_authorPermissionGroups]  VALUES (N'4', N'1')
GO

INSERT INTO [dbo].[cb_authorPermissionGroups]  VALUES (N'5', N'1')
GO

INSERT INTO [dbo].[cb_authorPermissionGroups]  VALUES (N'5', N'2')
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_authorPermissions
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_authorPermissions]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_authorPermissions]
GO

CREATE TABLE [dbo].[cb_authorPermissions] (
  [FK_authorID] int NOT NULL,
  [FK_permissionID] int NOT NULL
)
GO

ALTER TABLE [dbo].[cb_authorPermissions] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_authorPermissions]
-- ----------------------------
BEGIN TRANSACTION
GO

INSERT INTO [dbo].[cb_authorPermissions]  VALUES (N'3', N'36')
GO

INSERT INTO [dbo].[cb_authorPermissions]  VALUES (N'3', N'45')
GO

INSERT INTO [dbo].[cb_authorPermissions]  VALUES (N'3', N'42')
GO

INSERT INTO [dbo].[cb_authorPermissions]  VALUES (N'3', N'41')
GO

INSERT INTO [dbo].[cb_authorPermissions]  VALUES (N'3', N'40')
GO

INSERT INTO [dbo].[cb_authorPermissions]  VALUES (N'3', N'44')
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_category
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_category]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_category]
GO

CREATE TABLE [dbo].[cb_category] (
  [categoryID] int IDENTITY(1,1) NOT NULL,
  [createdDate] datetime NOT NULL,
  [modifiedDate] datetime NOT NULL,
  [isDeleted] bit DEFAULT ((0)) NOT NULL,
  [category] varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [slug] varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO

ALTER TABLE [dbo].[cb_category] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_category]
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[cb_category] ON
GO

INSERT INTO [dbo].[cb_category] ([categoryID], [createdDate], [modifiedDate], [isDeleted], [category], [slug]) VALUES (N'2', N'2016-05-03 16:23:25.000', N'2016-05-03 16:23:25.000', N'0', N'ColdFusion', N'coldfusion')
GO

INSERT INTO [dbo].[cb_category] ([categoryID], [createdDate], [modifiedDate], [isDeleted], [category], [slug]) VALUES (N'4', N'2016-05-03 16:23:25.000', N'2016-05-03 16:23:25.000', N'0', N'ContentBox', N'contentbox')
GO

INSERT INTO [dbo].[cb_category] ([categoryID], [createdDate], [modifiedDate], [isDeleted], [category], [slug]) VALUES (N'5', N'2016-05-03 16:23:25.000', N'2016-05-03 16:23:25.000', N'0', N'coldbox', N'coldbox')
GO

SET IDENTITY_INSERT [dbo].[cb_category] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_comment
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_comment]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_comment]
GO

CREATE TABLE [dbo].[cb_comment] (
  [commentID] int IDENTITY(1,1) NOT NULL,
  [createdDate] datetime NOT NULL,
  [modifiedDate] datetime NOT NULL,
  [isDeleted] bit DEFAULT ((0)) NOT NULL,
  [content] text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [author] varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [authorIP] varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [authorEmail] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [authorURL] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [isApproved] tinyint NOT NULL,
  [FK_contentID] int NOT NULL
)
GO

ALTER TABLE [dbo].[cb_comment] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_comment]
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[cb_comment] ON
GO

INSERT INTO [dbo].[cb_comment] ([commentID], [createdDate], [modifiedDate], [isDeleted], [content], [author], [authorIP], [authorEmail], [authorURL], [isApproved], [FK_contentID]) VALUES (N'9', N'2014-06-18 17:22:59.000', N'2017-06-13 17:10:42.000', N'0', N'Thsi is my gmail test', N'Luis Majano', N'127.0.0.1', N'lmajano@gmail.com', N'http://www.ortussolutions.com', N'0', N'142')
GO

INSERT INTO [dbo].[cb_comment] ([commentID], [createdDate], [modifiedDate], [isDeleted], [content], [author], [authorIP], [authorEmail], [authorURL], [isApproved], [FK_contentID]) VALUES (N'10', N'2014-10-23 13:21:38.000', N'2016-05-03 16:23:25.000', N'0', N'This is a test', N'Luis Majano', N'127.0.0.1', N'lmajano@ortussolutions.com', N'', N'1', N'141')
GO

INSERT INTO [dbo].[cb_comment] ([commentID], [createdDate], [modifiedDate], [isDeleted], [content], [author], [authorIP], [authorEmail], [authorURL], [isApproved], [FK_contentID]) VALUES (N'11', N'2015-08-04 16:17:43.000', N'2016-05-03 16:23:25.000', N'0', N'Test', N'Luis', N'', N'lmajano@gmail.com', N'', N'1', N'142')
GO

INSERT INTO [dbo].[cb_comment] ([commentID], [createdDate], [modifiedDate], [isDeleted], [content], [author], [authorIP], [authorEmail], [authorURL], [isApproved], [FK_contentID]) VALUES (N'12', N'2016-05-11 16:12:33.000', N'2016-05-11 16:12:33.000', N'0', N'test', N'Luis Majano', N'127.0.0.1', N'lmajano@gmail.com', N'', N'1', N'141')
GO

INSERT INTO [dbo].[cb_comment] ([commentID], [createdDate], [modifiedDate], [isDeleted], [content], [author], [authorIP], [authorEmail], [authorURL], [isApproved], [FK_contentID]) VALUES (N'13', N'2016-05-12 12:34:17.000', N'2016-05-12 12:34:17.000', N'0', N'test', N'Luis Majano', N'127.0.0.1', N'lmajano@ortussolutions.com', N'', N'1', N'141')
GO

INSERT INTO [dbo].[cb_comment] ([commentID], [createdDate], [modifiedDate], [isDeleted], [content], [author], [authorIP], [authorEmail], [authorURL], [isApproved], [FK_contentID]) VALUES (N'14', N'2016-11-28 15:35:51.000', N'2016-11-28 15:35:51.000', N'0', N'My awesome comment', N'Luis Majano', N'127.0.0.1', N'lmajano@gmail.com', N'', N'1', N'142')
GO

INSERT INTO [dbo].[cb_comment] ([commentID], [createdDate], [modifiedDate], [isDeleted], [content], [author], [authorIP], [authorEmail], [authorURL], [isApproved], [FK_contentID]) VALUES (N'15', N'2016-11-28 15:39:46.000', N'2016-11-28 15:39:46.000', N'0', N'non logged in user test', N'Pio', N'127.0.0.1', N'lmajano@gmail.com', N'', N'1', N'142')
GO

SET IDENTITY_INSERT [dbo].[cb_comment] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_commentSubscriptions
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_commentSubscriptions]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_commentSubscriptions]
GO

CREATE TABLE [dbo].[cb_commentSubscriptions] (
  [subscriptionID] int NOT NULL,
  [FK_contentID] int NOT NULL
)
GO

ALTER TABLE [dbo].[cb_commentSubscriptions] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_commentSubscriptions]
-- ----------------------------
BEGIN TRANSACTION
GO

INSERT INTO [dbo].[cb_commentSubscriptions]  VALUES (N'5', N'141')
GO

INSERT INTO [dbo].[cb_commentSubscriptions]  VALUES (N'6', N'141')
GO

INSERT INTO [dbo].[cb_commentSubscriptions]  VALUES (N'4', N'142')
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_content
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_content]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_content]
GO

CREATE TABLE [dbo].[cb_content] (
  [contentID] int IDENTITY(1,1) NOT NULL,
  [contentType] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [createdDate] datetime NOT NULL,
  [modifiedDate] datetime NOT NULL,
  [isDeleted] bit DEFAULT ((0)) NOT NULL,
  [title] varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [slug] varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [publishedDate] datetime NULL,
  [expireDate] datetime NULL,
  [isPublished] tinyint NOT NULL,
  [allowComments] tinyint NOT NULL,
  [passwordProtection] varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [HTMLKeywords] varchar(160) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [HTMLDescription] varchar(160) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [HTMLTitle] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [cache] tinyint NOT NULL,
  [cacheLayout] tinyint NOT NULL,
  [cacheTimeout] int NULL,
  [cacheLastAccessTimeout] int NULL,
  [markup] varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [showInSearch] tinyint NOT NULL,
  [featuredImage] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [featuredImageURL] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [FK_authorID] int NOT NULL,
  [FK_parentID] int NULL
)
GO

ALTER TABLE [dbo].[cb_content] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_content]
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[cb_content] ON
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'63', N'Entry', N'2013-07-12 09:53:01.000', N'2016-05-03 16:23:25.000', N'0', N'An awesome blog entry', N'an-awesome-blog-entry', N'2013-07-20 16:05:46.000', NULL, N'1', N'1', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'64', N'Entry', N'2013-07-12 09:53:31.000', N'2016-05-03 16:23:25.000', N'0', N'Another Test', N'another-test', N'2013-07-20 16:39:53.000', NULL, N'0', N'1', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'65', N'Entry', N'2012-09-13 15:55:12.000', N'2016-05-03 16:23:25.000', N'0', N'ContentBox Modular CMS at the South Florida CFUG', N'contentbox-modular-cms-at-the-south-florida-cfug', N'2013-07-20 16:39:39.000', NULL, N'1', N'1', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'html', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'67', N'Entry', N'2013-07-15 17:56:10.000', N'2016-05-03 16:23:25.000', N'0', N'Test with an excerpt', N'test-with-an-excerpt', N'2013-07-20 16:39:39.000', NULL, N'1', N'1', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'69', N'Entry', N'2013-07-19 18:45:08.000', N'2016-05-03 16:23:25.000', N'0', N'Updating an ORM entity', N'updating-an-orm-entity', N'2013-07-20 16:39:39.000', NULL, N'1', N'1', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'86', N'Entry', N'2013-07-20 16:10:43.000', N'2016-05-03 16:23:25.000', N'0', N'Copy of Updating an ORM entity', N'copy-of-updating-an-orm-entity', N'2013-07-20 16:39:39.000', NULL, N'1', N'1', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'html', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'87', N'Entry', N'2013-07-20 16:12:16.000', N'2016-05-03 16:23:25.000', N'0', N'Copy of Another Test', N'copy-of-another-test', N'2013-07-20 16:39:39.000', NULL, N'1', N'1', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'html', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'88', N'Entry', N'2013-07-20 16:12:23.000', N'2016-05-03 16:23:25.000', N'0', N'Copy of Copy of Another Test', N'copy-of-copy-of-another-test', N'2013-07-20 16:12:00.000', NULL, N'0', N'1', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'109', N'Entry', N'2013-07-26 16:53:43.000', N'2016-05-03 16:23:25.000', N'0', N'Couchbase Infrastructure', N'couchbase-infrastructure', N'2013-07-26 16:53:00.000', NULL, N'1', N'1', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'110', N'Entry', N'2013-07-26 16:55:00.000', N'2016-05-03 16:23:25.000', N'0', N'Couchbase Details', N'couchbase-details', N'2013-10-11 10:31:28.000', NULL, N'1', N'1', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'111', N'ContentStore', N'2013-08-12 11:59:12.000', N'2016-05-03 16:23:25.000', N'0', N'First Content Store', N'first-content-store', N'2013-08-12 12:02:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'114', N'ContentStore', N'2013-08-14 18:14:43.000', N'2016-05-03 16:23:25.000', N'0', N'My News', N'my-awesome-news', N'2013-08-14 18:14:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'122', N'ContentStore', N'2013-08-22 20:42:37.000', N'2016-05-03 16:23:25.000', N'0', N'blog-sidebar-top', N'blog-sidebar-top', N'2013-08-22 20:42:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'123', N'ContentStore', N'2013-08-22 20:43:59.000', N'2016-05-03 16:23:25.000', N'0', N'foot', N'foot', N'2013-08-22 20:43:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'124', N'ContentStore', N'2013-08-22 20:45:19.000', N'2016-05-03 16:23:25.000', N'0', N'support options', N'support-options-baby', N'2013-08-22 20:45:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'127', N'ContentStore', N'2013-08-29 08:29:36.000', N'2016-05-03 16:23:25.000', N'0', N'FireFox Test', N'firefox-test', N'2013-08-29 08:29:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'3', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'132', N'Entry', N'2013-09-13 16:54:52.000', N'2016-05-03 16:23:25.000', N'0', N'Couchbase Conference', N'couchbase-conference', N'2013-09-13 16:54:00.000', NULL, N'1', N'1', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'133', N'Entry', N'2013-09-13 16:55:05.000', N'2016-05-03 16:23:25.000', N'0', N'Disk Queues', N'disk-queues', N'2013-09-13 16:54:00.000', NULL, N'1', N'1', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'135', N'Entry', N'2013-10-15 16:48:56.000', N'2016-05-03 16:23:25.000', N'0', N'This is just awesome', N'this-is-just-awesome', N'2013-10-15 16:48:00.000', NULL, N'1', N'1', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'141', N'Entry', N'2013-11-11 11:53:03.000', N'2016-05-03 16:23:25.000', N'0', N'Closures cannot be declared outside of cfscript', N'closures-cannot-be-declared-outside-of-cfscript', N'2013-11-11 11:52:00.000', NULL, N'1', N'1', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'142', N'Entry', N'2014-01-31 14:41:16.000', N'2016-05-03 16:23:25.000', N'0', N'Disk Queues ', N'disk-queues-77CAF', N'2014-01-31 14:41:00.000', NULL, N'1', N'1', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'147', N'Page', N'2013-07-20 15:38:47.000', N'2016-08-05 14:42:30.000', N'0', N'support', N'support', N'2013-07-20 15:38:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'html', N'1', N'', N'', N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'159', N'ContentStore', N'2014-09-26 16:00:44.000', N'2016-05-03 16:23:25.000', N'0', N'Small Footer', N'foot/small-footer', N'2014-09-26 16:00:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'1', N'123')
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'160', N'Page', N'2015-03-29 10:13:59.000', N'2016-08-05 14:42:30.000', N'0', N'No Layout Test', N'no-layout-test', N'2015-03-29 10:13:00.000', NULL, N'1', N'0', N'test', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', N'', N'', N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'162', N'Page', N'2015-09-16 10:33:56.000', N'2016-08-05 14:42:30.000', N'0', N'No Sidebar', N'email-test', N'2015-09-16 10:33:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', NULL, NULL, N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'168', N'ContentStore', N'2016-01-14 11:44:58.000', N'2016-05-03 16:23:25.000', N'0', N'Lucee 4.5.2.018', N'lucee-452018', N'2016-01-14 11:42:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', N'', N'', N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'169', N'ContentStore', N'2016-01-14 11:45:35.000', N'2016-05-05 15:56:12.000', N'0', N'Another test', N'another-test-a161b', N'2016-01-14 11:45:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', N'', N'', N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'176', N'Page', N'2016-04-12 09:26:56.000', N'2016-05-03 16:23:25.000', N'0', N'parent page', N'parent-page', N'2016-04-12 09:26:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', N'', N'', N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'177', N'Page', N'2016-04-12 09:27:06.000', N'2016-05-03 16:23:25.000', N'0', N'child 1', N'parent-page/child-1', N'2016-04-12 09:27:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', N'', N'', N'1', N'176')
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'189', N'Page', N'2016-04-12 13:18:51.000', N'2016-08-05 14:42:30.000', N'0', N'node', N'node', N'2016-04-12 13:18:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', N'', N'', N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'190', N'Page', N'2016-04-12 13:19:04.000', N'2016-05-03 16:23:25.000', N'0', N'child1', N'node/child1', N'2016-04-12 13:18:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', N'', N'', N'1', N'189')
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'191', N'Page', N'2016-04-12 13:19:10.000', N'2016-05-03 16:23:25.000', N'0', N'child2', N'node/child2', N'2016-04-12 13:19:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', N'', N'', N'1', N'189')
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'192', N'Page', N'2016-05-05 11:12:23.000', N'2016-08-05 14:42:24.000', N'0', N'Test Markdown', N'test-markdown', N'2016-05-05 11:11:00.000', N'2016-05-01 00:00:00.000', N'0', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'Markdown', N'0', N'', N'', N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'206', N'Page', N'2016-05-18 11:35:32.000', N'2017-06-13 17:08:36.000', N'0', N'products', N'products', N'2017-06-13 17:08:00.000', NULL, N'1', N'0', N'', N'', N'', N'', N'1', N'1', N'0', N'0', N'HTML', N'1', N'', N'', N'1', NULL)
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'207', N'Page', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'coldbox', N'products/coldbox', N'2013-07-11 11:23:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', N'', N'', N'1', N'206')
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'208', N'Page', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'mini', N'products/coldbox/mini', N'2015-09-22 10:53:23.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', N'', N'', N'1', N'207')
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'209', N'Page', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'services', N'products/coldbox/services', N'2015-09-22 10:53:23.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', N'', N'', N'1', N'207')
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'210', N'Page', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'servers', N'products/coldbox/services/servers', N'2013-07-20 10:40:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', N'', N'', N'1', N'209')
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'211', N'Page', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'More Servers', N'products/coldbox/services/more-servers', N'2013-07-20 10:40:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', N'', N'', N'1', N'209')
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'212', N'Page', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'support', N'products/coldbox/services/support', N'2013-07-20 10:40:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'HTML', N'1', N'', N'', N'1', N'209')
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'213', N'Page', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'coldbox-new', N'products/coldbox-new', N'2016-04-11 11:32:00.000', NULL, N'1', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'html', N'1', N'', N'', N'1', N'206')
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'214', N'Page', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'mini', N'products/coldbox-new/mini', N'2013-08-22 10:23:03.000', NULL, N'0', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'html', N'1', N'', N'', N'1', N'213')
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'215', N'Page', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'services', N'products/coldbox-new/services', N'2013-08-22 10:23:03.000', NULL, N'0', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'html', N'1', N'', N'', N'1', N'213')
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'216', N'Page', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'servers', N'products/coldbox-new/services/servers', N'2013-08-22 10:23:03.000', NULL, N'0', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'html', N'1', N'', N'', N'1', N'215')
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'217', N'Page', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'More Servers', N'products/coldbox-new/services/more-servers', N'2013-08-22 10:23:04.000', NULL, N'0', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'html', N'1', N'', N'', N'1', N'215')
GO

INSERT INTO [dbo].[cb_content] ([contentID], [contentType], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [publishedDate], [expireDate], [isPublished], [allowComments], [passwordProtection], [HTMLKeywords], [HTMLDescription], [HTMLTitle], [cache], [cacheLayout], [cacheTimeout], [cacheLastAccessTimeout], [markup], [showInSearch], [featuredImage], [featuredImageURL], [FK_authorID], [FK_parentID]) VALUES (N'218', N'Page', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'support', N'products/coldbox-new/services/support', N'2013-08-22 10:23:04.000', NULL, N'0', N'0', N'', N'', N'', NULL, N'1', N'1', N'0', N'0', N'html', N'1', N'', N'', N'1', N'215')
GO

SET IDENTITY_INSERT [dbo].[cb_content] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_contentCategories
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_contentCategories]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_contentCategories]
GO

CREATE TABLE [dbo].[cb_contentCategories] (
  [FK_contentID] int NOT NULL,
  [FK_categoryID] int NOT NULL
)
GO

ALTER TABLE [dbo].[cb_contentCategories] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_contentCategories]
-- ----------------------------
BEGIN TRANSACTION
GO

INSERT INTO [dbo].[cb_contentCategories]  VALUES (N'114', N'2')
GO

INSERT INTO [dbo].[cb_contentCategories]  VALUES (N'114', N'4')
GO

INSERT INTO [dbo].[cb_contentCategories]  VALUES (N'64', N'2')
GO

INSERT INTO [dbo].[cb_contentCategories]  VALUES (N'64', N'4')
GO

INSERT INTO [dbo].[cb_contentCategories]  VALUES (N'87', N'2')
GO

INSERT INTO [dbo].[cb_contentCategories]  VALUES (N'87', N'4')
GO

INSERT INTO [dbo].[cb_contentCategories]  VALUES (N'88', N'2')
GO

INSERT INTO [dbo].[cb_contentCategories]  VALUES (N'88', N'4')
GO

INSERT INTO [dbo].[cb_contentCategories]  VALUES (N'147', N'5')
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_contentStore
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_contentStore]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_contentStore]
GO

CREATE TABLE [dbo].[cb_contentStore] (
  [contentID] int NOT NULL,
  [description] varchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [order] int DEFAULT ((0)) NULL
)
GO

ALTER TABLE [dbo].[cb_contentStore] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_contentStore]
-- ----------------------------
BEGIN TRANSACTION
GO

INSERT INTO [dbo].[cb_contentStore]  VALUES (N'111', N'My very first content', N'0')
GO

INSERT INTO [dbo].[cb_contentStore]  VALUES (N'114', N'Most greatest news', N'0')
GO

INSERT INTO [dbo].[cb_contentStore]  VALUES (N'122', N'', N'0')
GO

INSERT INTO [dbo].[cb_contentStore]  VALUES (N'123', N'footer', N'0')
GO

INSERT INTO [dbo].[cb_contentStore]  VALUES (N'124', N'support options', N'0')
GO

INSERT INTO [dbo].[cb_contentStore]  VALUES (N'127', N'Test', N'0')
GO

INSERT INTO [dbo].[cb_contentStore]  VALUES (N'159', N'A small footer', N'0')
GO

INSERT INTO [dbo].[cb_contentStore]  VALUES (N'168', N'test', N'0')
GO

INSERT INTO [dbo].[cb_contentStore]  VALUES (N'169', N'asdf', N'0')
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_contentVersion
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_contentVersion]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_contentVersion]
GO

CREATE TABLE [dbo].[cb_contentVersion] (
  [contentVersionID] int IDENTITY(1,1) NOT NULL,
  [createdDate] datetime NOT NULL,
  [modifiedDate] datetime NOT NULL,
  [isDeleted] bit DEFAULT ((0)) NOT NULL,
  [content] text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [changelog] text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [version] int NOT NULL,
  [isActive] tinyint NOT NULL,
  [FK_authorID] int NOT NULL,
  [FK_contentID] int NOT NULL
)
GO

ALTER TABLE [dbo].[cb_contentVersion] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_contentVersion]
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[cb_contentVersion] ON
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'122', N'2013-07-12 09:53:01.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'Test', N'1', N'1', N'1', N'63')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'123', N'2013-07-12 09:53:31.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'0', N'1', N'64')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'124', N'2013-07-12 09:53:40.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'2', N'1', N'1', N'64')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'125', N'2013-04-07 10:45:28.000', N'2016-05-03 16:23:25.000', N'0', N'I am glad to go back to my adoptive home, Miami next week and present at the South Florida CFUG on <a href="http://gocontentbox.org">ContentBox Modular CMS</a> September 20th, 2012.  We will be showcasing our next ContentBox version 1.0.7 and have some great goodies for everybody.  <a href="http://www.gocontentbox.org/blog/south-florida-cfug-presentation">You can read all about the event here</a>.  Hope to see you there!', N'Imported content', N'1', N'1', N'1', N'65')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'133', N'2013-07-15 17:56:10.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'1', N'1', N'67')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'140', N'2013-07-19 18:45:08.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'quick save', N'1', N'0', N'1', N'69')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'141', N'2013-07-19 18:45:28.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'What up daugh!', N'2', N'1', N'1', N'69')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'158', N'2013-07-20 16:10:43.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'Content Cloned!', N'1', N'1', N'1', N'86')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'159', N'2013-07-20 16:12:16.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'Content Cloned!', N'1', N'1', N'1', N'87')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'160', N'2013-07-20 16:12:23.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'Content Cloned!', N'1', N'0', N'1', N'88')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'163', N'2013-07-26 12:58:21.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'quick save', N'2', N'0', N'1', N'88')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'164', N'2013-07-26 12:59:43.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'quick save', N'3', N'0', N'1', N'88')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'165', N'2013-07-26 13:00:05.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'4', N'0', N'1', N'88')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'166', N'2013-07-26 13:00:21.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'5', N'0', N'1', N'88')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'168', N'2013-07-26 13:02:18.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'quick save', N'6', N'0', N'1', N'88')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'169', N'2013-07-26 13:02:34.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'quick save', N'7', N'0', N'1', N'88')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'170', N'2013-07-26 13:02:38.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>TESTT</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'quick save', N'8', N'0', N'1', N'88')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'171', N'2013-07-26 13:02:51.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n', N'quick save', N'9', N'0', N'1', N'88')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'172', N'2013-07-26 13:03:02.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n', N'Editor Change Quick Save', N'10', N'0', N'1', N'88')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'173', N'2013-07-26 13:03:09.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n', N'quick save', N'11', N'0', N'1', N'88')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'174', N'2013-07-26 13:04:31.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'quick save', N'12', N'1', N'1', N'88')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'193', N'2013-07-26 16:53:43.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'1', N'1', N'109')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'194', N'2013-07-26 16:55:00.000', N'2016-05-03 16:23:25.000', N'0', N'<p>{{{ContentStore slug=''contentbox''}}}</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'0', N'1', N'110')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'195', N'2013-08-12 11:59:12.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'quick save', N'1', N'0', N'1', N'111')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'198', N'2013-08-12 12:18:13.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'4', N'0', N'1', N'111')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'200', N'2013-08-12 12:18:29.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'6', N'0', N'1', N'111')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'215', N'2013-08-14 18:14:43.000', N'2016-05-03 16:23:25.000', N'0', N'<p><widget category="" max="5" searchterm="" title="" titlelevel="2" widgetdisplayname="RecentEntries" widgetname="RecentEntries" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/list.png" style="margin-right:5px;" width="20" />RecentEntries : max = 5 | titleLevel = 2 | widgetUDF = rende</widgetinfobar></widget></p>\r\n', N'', N'1', N'0', N'1', N'114')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'216', N'2013-08-14 18:15:14.000', N'2016-05-03 16:23:25.000', N'0', N'<p><widget category="" max="5" searchterm="" title="" titlelevel="2" widgetdisplayname="RecentEntries" widgetname="RecentEntries" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/list.png" style="margin-right:5px;" width="20" />RecentEntries : max = 5 | titleLevel = 2 | widgetUDF = rende</widgetinfobar></widget></p>\r\n', N'', N'2', N'1', N'1', N'114')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'221', N'2013-08-21 13:43:59.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'Reverting to version 4', N'7', N'0', N'1', N'111')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'222', N'2013-08-21 13:44:18.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'Reverting to version 5', N'8', N'0', N'1', N'111')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'223', N'2013-08-21 13:44:22.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'Reverting to version 6', N'9', N'0', N'1', N'111')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'224', N'2013-08-21 18:15:46.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'Reverting to version 4', N'10', N'0', N'1', N'111')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'225', N'2013-08-21 18:16:55.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'Reverting to version 6', N'11', N'0', N'1', N'111')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'226', N'2013-08-21 18:17:41.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'Reverting to version 9', N'12', N'0', N'1', N'111')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'227', N'2013-08-21 18:18:13.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'Reverting to version 8', N'13', N'0', N'1', N'111')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'228', N'2013-08-21 18:18:29.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'Reverting to version 9', N'14', N'1', N'1', N'111')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'238', N'2013-08-22 20:42:37.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Sidebar Top</p>\r\n', N'', N'1', N'1', N'1', N'122')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'239', N'2013-08-22 20:43:59.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'1', N'1', N'123')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'240', N'2013-08-22 20:45:19.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'0', N'1', N'124')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'263', N'2013-08-29 08:29:36.000', N'2016-05-03 16:23:25.000', N'0', N'Test\r\n\r\nasdf\r\n\r\nasdf', N'quick save', N'1', N'0', N'1', N'127')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'264', N'2013-08-29 08:30:10.000', N'2016-05-03 16:23:25.000', N'0', N'Test\r\n\r\nasdf\r\n\r\nasdf', N'quick save', N'2', N'0', N'1', N'127')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'265', N'2013-08-29 08:30:21.000', N'2016-05-03 16:23:25.000', N'0', N'Test\r\n\r\nasdf\r\n\r\nasdf', N'Editor Change Quick Save', N'3', N'0', N'1', N'127')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'266', N'2013-08-29 08:31:17.000', N'2016-05-03 16:23:25.000', N'0', N'lorem ipsum lorem', N'quick save', N'4', N'0', N'1', N'127')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'267', N'2013-08-29 08:32:16.000', N'2016-05-03 16:23:25.000', N'0', N'<p>{{{ContentStore slug=''contentbox''}}}</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'quick save', N'2', N'1', N'1', N'110')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'272', N'2013-09-13 16:54:52.000', N'2016-05-03 16:23:25.000', N'0', N'<p>I am at the conference</p>\r\n', N'', N'1', N'1', N'1', N'132')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'273', N'2013-09-13 16:55:05.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'1', N'1', N'133')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'277', N'2013-10-15 16:48:56.000', N'2016-05-03 16:23:25.000', N'0', N'<p>An awesome link</p>\r\n', N'', N'1', N'1', N'1', N'135')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'278', N'2013-10-15 16:57:47.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'2', N'0', N'1', N'124')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'279', N'2013-10-15 16:57:56.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'3', N'0', N'1', N'124')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'280', N'2013-10-15 16:58:18.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'4', N'0', N'1', N'124')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'287', N'2013-10-15 17:00:33.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'5', N'0', N'1', N'124')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'288', N'2013-10-15 17:00:52.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'6', N'0', N'1', N'124')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'289', N'2013-10-15 17:03:19.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'7', N'0', N'1', N'124')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'290', N'2013-10-15 17:03:34.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'8', N'1', N'1', N'124')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'305', N'2013-11-11 11:53:03.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'0', N'1', N'141')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'306', N'2013-11-11 11:53:49.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'2', N'1', N'1', N'141')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'315', N'2014-01-31 14:41:16.000', N'2016-05-03 16:23:25.000', N'0', N'<p>This is a test.</p>\r\n', N'', N'1', N'1', N'1', N'142')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'326', N'2014-02-05 14:31:57.000', N'2016-05-03 16:23:25.000', N'0', N'<p>lorem ipsum lorem</p>\r\n', N'quick save', N'5', N'0', N'1', N'127')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'339', N'2014-07-01 16:44:54.000', N'2016-05-03 16:23:25.000', N'0', N'<p>lorem ipsum lorem</p>\r\n', N'', N'6', N'1', N'1', N'127')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'367', N'2014-08-25 12:40:55.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Support services</p>\r\n\r\n<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'26', N'0', N'1', N'147')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'368', N'2014-08-25 12:41:44.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Support services</p>\r\n\r\n<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'27', N'0', N'1', N'147')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'369', N'2014-08-25 12:46:10.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Support services</p>\r\n\r\n<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'28', N'0', N'1', N'147')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'370', N'2014-08-25 12:46:29.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Support services</p>\r\n\r\n<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'29', N'0', N'1', N'147')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'371', N'2014-08-25 12:46:59.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Support services</p>\r\n\r\n<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'30', N'0', N'1', N'147')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'372', N'2014-08-25 13:22:47.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Support services</p>\r\n\r\n<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'31', N'0', N'1', N'147')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'373', N'2014-08-25 13:23:14.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Support services</p>\r\n\r\n<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'32', N'0', N'1', N'147')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'374', N'2014-08-25 13:23:55.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Support services</p>\r\n\r\n<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'33', N'0', N'1', N'147')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'381', N'2014-09-26 16:00:44.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'0', N'1', N'159')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'382', N'2014-09-26 16:25:23.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'2', N'0', N'1', N'159')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'383', N'2014-09-26 16:25:31.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'3', N'0', N'1', N'159')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'384', N'2014-09-26 16:25:53.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'4', N'1', N'1', N'159')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'387', N'2015-03-29 10:13:59.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'0', N'1', N'160')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'390', N'2015-04-01 11:17:19.000', N'2016-05-03 16:23:25.000', N'0', N'<p>${rc:event}</p>\r\n\r\n<p>${prc:cbox_incomingContextHash}</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'quick save', N'2', N'0', N'1', N'160')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'391', N'2015-05-09 22:31:13.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'Reverting to version 1', N'3', N'0', N'1', N'160')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'392', N'2015-05-09 22:39:03.000', N'2016-05-18 11:50:02.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'4', N'0', N'1', N'160')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'395', N'2015-09-16 10:33:56.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'0', N'1', N'162')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'400', N'2015-09-23 11:04:54.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'2', N'1', N'1', N'162')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'413', N'2016-01-14 11:44:58.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Test</p>\r\n', N'', N'1', N'0', N'1', N'168')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'414', N'2016-01-14 11:45:17.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Test</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'2', N'1', N'1', N'168')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'415', N'2016-01-14 11:45:35.000', N'2016-05-05 15:53:13.000', N'0', N'<p>asdf</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'0', N'1', N'169')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'418', N'2016-04-10 16:27:12.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Support services</p>\r\n\r\n<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'34', N'0', N'1', N'147')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'419', N'2016-04-11 11:40:14.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Support services</p>\r\n\r\n<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'35', N'1', N'1', N'147')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'442', N'2016-04-12 13:18:51.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'0', N'1', N'189')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'443', N'2016-04-12 13:19:21.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'2', N'1', N'1', N'189')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'444', N'2016-04-12 13:19:04.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'1', N'1', N'190')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'445', N'2016-04-12 13:19:10.000', N'2016-05-03 16:23:25.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'1', N'1', N'191')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'448', N'2016-05-05 15:53:13.000', N'2016-05-05 15:55:34.000', N'0', N'<p>asdf</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'quick save', N'2', N'0', N'1', N'169')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'449', N'2016-05-05 15:55:34.000', N'2016-05-05 15:56:12.000', N'0', N'<p>asdf</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'quick save', N'3', N'0', N'1', N'169')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'450', N'2016-05-05 15:56:11.000', N'2016-05-05 15:56:11.000', N'0', N'Because of God''s grace, this project exists. If you don''t like this, then don''t read it, its not for you.\r\n\r\n>"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:\r\nBy whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.\r\nAnd not only so, but we glory in tribulations also: knowing that tribulation worketh patience;\r\nAnd patience, experience; and experience, hope:\r\nAnd hope maketh not ashamed; because the love of God is shed abroad in our hearts by the \r\nHoly Ghost which is given unto us. ." Romans 5:5\r\n\r\n----\r\n\r\n# Welcome to ContentBox\r\nContentBox is a modular content management engine based on the popular [ColdBox](www.coldbox.org) MVC framework.\r\n\r\n## License\r\nApache License, Version 2.0.\r\n\r\n## Versioning\r\nContentBox is maintained under the Semantic Versioning guidelines as much as possible.\r\n\r\nReleases will be numbered with the following format:\r\n\r\n```\r\n<major>.<minor>.<patch>\r\n```\r\n\r\nAnd constructed with the following guidelines:\r\n\r\n* Breaking backward compatibility bumps the major (and resets the minor and patch)\r\n* New additions without breaking backward compatibility bumps the minor (and resets the patch)\r\n* Bug fixes and misc changes bumps the patch\r\n\r\n## Important Links\r\n\r\nSource Code\r\n- https://github.com/Ortus-Solutions/ContentBox\r\n\r\nContinuous Integration\r\n- http://jenkins.staging.ortussolutions.com/job/OS-ContentBox%20BE/\r\n\r\nBug Tracking/Agile Boards\r\n- https://ortussolutions.atlassian.net/browse/CONTENTBOX\r\n\r\nDocumentation\r\n- http://contentbox.ortusbooks.com\r\n\r\nBlog\r\n- http://www.ortussolutions.com/blog\r\n\r\n## System Requirements\r\n- Lucee 4.5+\r\n- Railo 4+ (Deprecated)\r\n- ColdFusion 10+\r\n\r\n# ContentBox Installation\r\n\r\nYou can follow in-depth installation instructions here: http://contentbox.ortusbooks.com/content/installation/index.html or you can use [CommandBox](http://www.ortussolutions.com/products/commandbox) to quickly get up and running via the following commands:\r\n\r\n**Stable Release**\r\n\r\n```bash\r\nmkdir mysite && cd mysite\r\n# Install latest release\r\nbox install contentbox\r\nbox server start --rewritesEnable\r\n```\r\n\r\n**Bleeding Edge Release**\r\n\r\n```bash\r\nmkdir mysite && cd mysite\r\n# Install latest release\r\nbox install contentbox-be\r\nbox server start --rewritesEnable\r\n```\r\n\r\n## Collaboration\r\n\r\nIf you want to develop and hack at the source, you will need to download [CommandBox](http://www.ortussolutions.com/products/commandbox) first.  Then in the root of this project, type `box install`.  This will download the necessary dependencies to develop and test ContentBox.  You can then go ahead and start an embedded server `box server start --rewritesEnable` and start hacking around and contributing.  \r\n\r\n### Test Suites\r\nFor running our test suites you will need 2 more steps, so please refer to the [Readme](tests/readme.md) in the tests folder.\r\n\r\n### UI Development\r\nIf developing CSS and Javascript assets, please refer to the [Developer Guide](workbench/Developer.md) in the `workbench/Developer.md` folder.\r\n\r\n---\r\n \r\n###THE DAILY BREAD\r\n > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12', N'', N'4', N'1', N'1', N'169')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'454', N'2016-05-06 15:47:42.000', N'2016-05-06 16:12:27.000', N'0', N'<p># Test App This is my `cool` documentation {{{ContentStore slug=''firefox-test''}}} I want an image: ![ContentBoxIcon300.png](/index.cfm/__media/ContentBoxIcon300.png) This is an amazing coding styles</p>\r\n\r\n<pre class="brush: coldfusion">\r\nCode Fences Work</pre>\r\n', N'', N'6', N'0', N'1', N'192')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'455', N'2016-05-06 16:12:27.000', N'2016-05-06 16:16:02.000', N'0', N'<p># Test App This is my `cool` documentation {{{ContentStore slug=''firefox-test''}}} I want an image: ![ContentBoxIcon300.png](/index.cfm/__media/ContentBoxIcon300.png) This is an amazing coding styles</p>\r\n\r\n<pre class="brush: coldfusion">\r\nCode Fences Work\r\n</pre>\r\n', N'quick save', N'7', N'0', N'1', N'192')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'456', N'2016-05-06 16:16:02.000', N'2016-05-09 15:18:20.000', N'0', N'<p># Test App This is my `cool` documentation {{{ContentStore slug=''firefox-test''}}} I want an image: ![ContentBoxIcon300.png](/index.cfm/__media/ContentBoxIcon300.png) This is an amazing coding styles</p>\r\n\r\n<pre class="brush: coldfusion">\r\nCode Fences Work\r\n</pre>\r\n\r\n\r\n', N'quick save', N'8', N'0', N'1', N'192')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'457', N'2016-05-09 15:18:20.000', N'2016-05-10 14:31:20.000', N'0', N'<p># Test App This is my `cool` documentation {{{ContentStore slug=''firefox-test''}}} I want an image: ![ContentBoxIcon300.png](/index.cfm/__media/ContentBoxIcon300.png) This is an amazing coding styles</p>\r\n\r\n<pre class="brush: coldfusion">\r\nCode Fences Work\r\n</pre>\r\n\r\n\r\n', N'quick save', N'9', N'0', N'1', N'192')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'458', N'2016-05-10 14:31:20.000', N'2016-05-11 15:52:40.000', N'0', N'<p># Test App This is my `cool` documentation {{{ContentStore slug=''firefox-test''}}} I want an image: ![ContentBoxIcon300.png](/index.cfm/__media/ContentBoxIcon300.png) This is an amazing coding styles</p>\r\n\r\n<pre class="brush: coldfusion">\r\nCode Fences Work\r\n</pre>\r\n\r\n\r\n', N'quick save', N'10', N'0', N'1', N'192')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'459', N'2016-05-11 15:52:40.000', N'2016-05-11 15:52:45.000', N'0', N'<p># Test App This is my `cool` documentation {{{ContentStore slug=''firefox-test''}}} I want an image: ![ContentBoxIcon300.png](/index.cfm/__media/ContentBoxIcon300.png) This is an amazing coding styles</p>\r\n\r\n<pre class="brush: coldfusion">\r\nCode Fences Work\r\n</pre>\r\n\r\n\r\n', N'quick save', N'11', N'0', N'1', N'192')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'460', N'2016-05-11 15:52:45.000', N'2016-05-18 11:42:34.000', N'0', N'<p># Test App This is my `cool` documentation {{{ContentStore slug=''firefox-test''}}} I want an image: ![ContentBoxIcon300.png](/index.cfm/__media/ContentBoxIcon300.png) This is an amazing coding styles</p>\r\n\r\n<pre class="brush: coldfusion">\r\nCode Fences Work\r\n</pre>\r\n\r\n\r\n', N'quick save', N'12', N'0', N'1', N'192')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'478', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'0', N'1', N'206')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'479', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'<p><img alt="" src="/index.cfm/__media/ContentBox_300.png" style="width: 300px; height: 284px;" /></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p><img alt="" src="/index.cfm/__media/ContentBox_125.gif" style="width: 124px; height: 118px;" /></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'2', N'0', N'1', N'206')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'480', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'<p><img alt="" src="/__media/ContentBox_300.png" style="width: 300px; height: 284px;" /></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p><img alt="" src="/__media/ContentBox_125.gif" style="width: 124px; height: 118px;" /></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'3', N'0', N'1', N'206')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'481', N'2016-05-18 11:35:32.000', N'2016-05-18 15:11:18.000', N'0', N'<p><img alt="" src="/__media/ContentBox_300.png" style="width: 300px; height: 178px;" /></p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'4', N'0', N'1', N'206')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'482', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'1', N'1', N'207')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'483', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'1', N'1', N'208')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'484', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'1', N'1', N'209')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'485', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'1', N'1', N'210')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'486', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'1', N'1', N'211')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'487', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'<p>Support services</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'1', N'1', N'1', N'212')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'488', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'Content Cloned!', N'1', N'0', N'1', N'213')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'489', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<iframe width="560" height="315" src="https://www.youtube.com/embed/vdBHFxfZues" frameborder="0" allowfullscreen></iframe>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'', N'2', N'1', N'1', N'213')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'490', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'Content Cloned!', N'1', N'1', N'1', N'214')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'491', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'Content Cloned!', N'1', N'1', N'1', N'215')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'492', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'Content Cloned!', N'1', N'1', N'1', N'216')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'493', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'Content Cloned!', N'1', N'1', N'1', N'217')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'494', N'2016-05-18 11:35:32.000', N'2016-05-18 11:35:32.000', N'0', N'<p>Support services</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n', N'Content Cloned!', N'1', N'1', N'1', N'218')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'495', N'2016-05-18 11:42:34.000', N'2016-05-18 11:45:50.000', N'0', N'<p># Test App This is my `cool` documentation {{{ContentStore slug=''firefox-test''}}} I want an image: ![ContentBoxIcon300.png](/index.cfm/__media/ContentBoxIcon300.png) This is an amazing coding styles</p>\r\n\r\n<pre class="brush: coldfusion">\r\nCode Fences Work\r\n</pre>\r\n\r\n\r\n', N'', N'13', N'0', N'1', N'192')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'496', N'2016-05-18 11:45:50.000', N'2016-06-14 13:46:47.000', N'0', N'<p># Test App This is my `cool` documentation {{{ContentStore slug=''firefox-test''}}} I want an image: ![ContentBoxIcon300.png](/index.cfm/__media/ContentBoxIcon300.png) This is an amazing coding styles</p>\r\n\r\n<pre class="brush: coldfusion">\r\nCode Fences Work\r\n</pre>\r\n\r\n\r\n', N'', N'14', N'0', N'1', N'192')
GO

INSERT INTO [dbo].[cb_contentVersion] ([contentVersionID], [createdDate], [modifiedDate], [isDeleted], [content], [changelog], [version], [isActive], [FK_authorID], [FK_contentID]) VALUES (N'497', N'2017-06-13 17:08:36.000', N'2017-06-13 17:08:36.000', N'0', N'My Products Rock', N'', N'5', N'1', N'1', N'206')
GO

SET IDENTITY_INSERT [dbo].[cb_contentVersion] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_customfield
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_customfield]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_customfield]
GO

CREATE TABLE [dbo].[cb_customfield] (
  [customFieldID] int IDENTITY(1,1) NOT NULL,
  [createdDate] datetime NOT NULL,
  [modifiedDate] datetime NOT NULL,
  [isDeleted] bit DEFAULT ((0)) NOT NULL,
  [key] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [value] text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [FK_contentID] int NULL
)
GO

ALTER TABLE [dbo].[cb_customfield] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_customfield]
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[cb_customfield] ON
GO

INSERT INTO [dbo].[cb_customfield] ([customFieldID], [createdDate], [modifiedDate], [isDeleted], [key], [value], [FK_contentID]) VALUES (N'3', N'2016-05-03 16:23:25.000', N'2016-05-03 16:23:25.000', N'0', N'age', N'30', N'114')
GO

INSERT INTO [dbo].[cb_customfield] ([customFieldID], [createdDate], [modifiedDate], [isDeleted], [key], [value], [FK_contentID]) VALUES (N'4', N'2016-05-03 16:23:25.000', N'2016-05-03 16:23:25.000', N'0', N'subtitle', N'4', N'114')
GO

SET IDENTITY_INSERT [dbo].[cb_customfield] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_entry
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_entry]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_entry]
GO

CREATE TABLE [dbo].[cb_entry] (
  [contentID] int NOT NULL,
  [excerpt] text COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

ALTER TABLE [dbo].[cb_entry] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_entry]
-- ----------------------------
BEGIN TRANSACTION
GO

INSERT INTO [dbo].[cb_entry]  VALUES (N'63', N'')
GO

INSERT INTO [dbo].[cb_entry]  VALUES (N'64', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n')
GO

INSERT INTO [dbo].[cb_entry]  VALUES (N'65', N'')
GO

INSERT INTO [dbo].[cb_entry]  VALUES (N'67', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n')
GO

INSERT INTO [dbo].[cb_entry]  VALUES (N'69', N'')
GO

INSERT INTO [dbo].[cb_entry]  VALUES (N'86', N'')
GO

INSERT INTO [dbo].[cb_entry]  VALUES (N'87', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n')
GO

INSERT INTO [dbo].[cb_entry]  VALUES (N'88', N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>\r\n\r\n<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>\r\n\r\n<p>&nbsp;</p>\r\n')
GO

INSERT INTO [dbo].[cb_entry]  VALUES (N'109', N'')
GO

INSERT INTO [dbo].[cb_entry]  VALUES (N'110', N'')
GO

INSERT INTO [dbo].[cb_entry]  VALUES (N'132', N'')
GO

INSERT INTO [dbo].[cb_entry]  VALUES (N'133', N'')
GO

INSERT INTO [dbo].[cb_entry]  VALUES (N'135', N'')
GO

INSERT INTO [dbo].[cb_entry]  VALUES (N'141', N'<p>Excerpt Content TestsExcerpt Content TestsExcerpt Content Tests</p>\r\n')
GO

INSERT INTO [dbo].[cb_entry]  VALUES (N'142', N'')
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_groupPermissions
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_groupPermissions]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_groupPermissions]
GO

CREATE TABLE [dbo].[cb_groupPermissions] (
  [FK_permissionGroupID] int NOT NULL,
  [FK_permissionID] int NOT NULL
)
GO

ALTER TABLE [dbo].[cb_groupPermissions] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_groupPermissions]
-- ----------------------------
BEGIN TRANSACTION
GO

INSERT INTO [dbo].[cb_groupPermissions]  VALUES (N'1', N'14')
GO

INSERT INTO [dbo].[cb_groupPermissions]  VALUES (N'1', N'28')
GO

INSERT INTO [dbo].[cb_groupPermissions]  VALUES (N'1', N'25')
GO

INSERT INTO [dbo].[cb_groupPermissions]  VALUES (N'2', N'29')
GO

INSERT INTO [dbo].[cb_groupPermissions]  VALUES (N'2', N'3')
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_loginAttempts
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_loginAttempts]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_loginAttempts]
GO

CREATE TABLE [dbo].[cb_loginAttempts] (
  [loginAttemptsID] int IDENTITY(1,1) NOT NULL,
  [createdDate] datetime NOT NULL,
  [modifiedDate] datetime NOT NULL,
  [isDeleted] bit DEFAULT ((0)) NOT NULL,
  [value] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [attempts] int NOT NULL,
  [lastLoginSuccessIP] varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

ALTER TABLE [dbo].[cb_loginAttempts] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_loginAttempts]
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[cb_loginAttempts] ON
GO

INSERT INTO [dbo].[cb_loginAttempts] ([loginAttemptsID], [createdDate], [modifiedDate], [isDeleted], [value], [attempts], [lastLoginSuccessIP]) VALUES (N'16', N'2016-11-28 14:56:43.000', N'2016-11-28 14:56:46.000', N'0', N'lmajano', N'0', N'127.0.0.1')
GO

INSERT INTO [dbo].[cb_loginAttempts] ([loginAttemptsID], [createdDate], [modifiedDate], [isDeleted], [value], [attempts], [lastLoginSuccessIP]) VALUES (N'17', N'2017-06-21 16:07:26.000', N'2017-06-21 17:37:42.000', N'0', N'testermajano', N'0', N'127.0.0.1')
GO

INSERT INTO [dbo].[cb_loginAttempts] ([loginAttemptsID], [createdDate], [modifiedDate], [isDeleted], [value], [attempts], [lastLoginSuccessIP]) VALUES (N'19', N'2017-07-06 11:37:09.000', N'2017-07-06 11:37:31.000', N'0', N'joejoe@joe.com', N'0', NULL)
GO

INSERT INTO [dbo].[cb_loginAttempts] ([loginAttemptsID], [createdDate], [modifiedDate], [isDeleted], [value], [attempts], [lastLoginSuccessIP]) VALUES (N'20', N'2017-07-06 11:38:28.000', N'2017-07-06 11:38:28.000', N'0', N'joejoe', N'0', N'127.0.0.1')
GO

SET IDENTITY_INSERT [dbo].[cb_loginAttempts] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_menu
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_menu]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_menu]
GO

CREATE TABLE [dbo].[cb_menu] (
  [menuID] int IDENTITY(1,1) NOT NULL,
  [createdDate] datetime NOT NULL,
  [modifiedDate] datetime NOT NULL,
  [isDeleted] bit DEFAULT ((0)) NOT NULL,
  [title] varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [slug] varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [menuClass] varchar(160) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [listClass] varchar(160) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [listType] varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

ALTER TABLE [dbo].[cb_menu] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_menu]
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[cb_menu] ON
GO

INSERT INTO [dbo].[cb_menu] ([menuID], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [menuClass], [listClass], [listType]) VALUES (N'2', N'2016-05-04 17:00:14.000', N'2016-05-04 17:20:11.000', N'0', N'Test', N'test', N'', N'', N'ul')
GO

INSERT INTO [dbo].[cb_menu] ([menuID], [createdDate], [modifiedDate], [isDeleted], [title], [slug], [menuClass], [listClass], [listType]) VALUES (N'3', N'2016-05-04 17:02:54.000', N'2016-05-04 17:02:54.000', N'0', N'test', N'test -e123c', N'', N'', N'ul')
GO

SET IDENTITY_INSERT [dbo].[cb_menu] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_menuItem
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_menuItem]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_menuItem]
GO

CREATE TABLE [dbo].[cb_menuItem] (
  [menuItemID] int IDENTITY(1,1) NOT NULL,
  [menuType] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [createdDate] datetime NOT NULL,
  [modifiedDate] datetime NOT NULL,
  [isDeleted] bit DEFAULT ((0)) NOT NULL,
  [title] varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [label] varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [itemClass] varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [data] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [active] tinyint NULL,
  [FK_menuID] int NOT NULL,
  [FK_parentID] int NULL,
  [mediaPath] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [target] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [urlClass] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [menuSlug] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [contentSlug] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [js] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [url] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

ALTER TABLE [dbo].[cb_menuItem] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_menuItem]
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[cb_menuItem] ON
GO

INSERT INTO [dbo].[cb_menuItem] ([menuItemID], [menuType], [createdDate], [modifiedDate], [isDeleted], [title], [label], [itemClass], [data], [active], [FK_menuID], [FK_parentID], [mediaPath], [target], [urlClass], [menuSlug], [contentSlug], [js], [url]) VALUES (N'7', N'Free', N'2016-05-04 17:22:08.000', N'2016-05-04 17:22:08.000', N'0', N'', N'test', N'', N'', N'1', N'2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[cb_menuItem] ([menuItemID], [menuType], [createdDate], [modifiedDate], [isDeleted], [title], [label], [itemClass], [data], [active], [FK_menuID], [FK_parentID], [mediaPath], [target], [urlClass], [menuSlug], [contentSlug], [js], [url]) VALUES (N'8', N'URL', N'2016-05-04 17:22:08.000', N'2016-05-04 17:22:08.000', N'0', N'', N'hello', N'', N'', N'1', N'2', NULL, NULL, N'_blank', N'test', NULL, NULL, NULL, N'http://www.ortussolutions.com')
GO

SET IDENTITY_INSERT [dbo].[cb_menuItem] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_module
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_module]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_module]
GO

CREATE TABLE [dbo].[cb_module] (
  [moduleID] int IDENTITY(1,1) NOT NULL,
  [createdDate] datetime NOT NULL,
  [modifiedDate] datetime NOT NULL,
  [isDeleted] bit DEFAULT ((0)) NOT NULL,
  [name] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [title] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [version] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [entryPoint] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [author] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [webURL] varchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [forgeBoxSlug] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [description] text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [isActive] tinyint NOT NULL
)
GO

ALTER TABLE [dbo].[cb_module] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_module]
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[cb_module] ON
GO

INSERT INTO [dbo].[cb_module] ([moduleID], [createdDate], [modifiedDate], [isDeleted], [name], [title], [version], [entryPoint], [author], [webURL], [forgeBoxSlug], [description], [isActive]) VALUES (N'36', N'2016-07-15 12:09:34.000', N'2016-07-15 12:09:34.000', N'0', N'Hello', N'HelloContentBox', N'1.0', N'HelloContentBox', N'Ortus Solutions, Corp', N'http://www.ortussolutions.com', N'', N'This is an awesome hello world module', N'0')
GO

SET IDENTITY_INSERT [dbo].[cb_module] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_page
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_page]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_page]
GO

CREATE TABLE [dbo].[cb_page] (
  [contentID] int NOT NULL,
  [layout] varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [order] int NULL,
  [showInMenu] tinyint NOT NULL,
  [excerpt] text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [SSLOnly] tinyint NOT NULL
)
GO

ALTER TABLE [dbo].[cb_page] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_page]
-- ----------------------------
BEGIN TRANSACTION
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'147', N'pages', N'', N'6', N'1', N'', N'0')
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'160', N'-no-layout-', N'', N'3', N'1', N'', N'0')
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'162', N'pagesNoSidebar', N'', N'5', N'1', N'', N'0')
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'189', N'pages', N'', N'4', N'1', N'', N'0')
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'190', N'pages', N'', N'0', N'1', N'', N'0')
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'191', N'pages', N'', N'0', N'1', N'', N'0')
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'192', N'pages', N'', N'2', N'0', N'', N'0')
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'206', N'pages', N'', N'1', N'1', N'', N'0')
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'207', N'pages', N'', N'2', N'1', N'', N'0')
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'208', N'pages', N'', N'1', N'1', N'', N'0')
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'209', N'pages', N'', N'2', N'1', N'', N'0')
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'210', N'pages', N'', N'6', N'1', N'', N'0')
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'211', N'pages', N'', N'4', N'1', N'', N'0')
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'212', N'pages', N'', N'8', N'1', N'', N'0')
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'213', N'pages', N'', N'1', N'1', N'', N'0')
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'214', N'pages', N'', N'0', N'1', N'', N'0')
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'215', N'pages', N'', N'0', N'1', N'', N'0')
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'216', N'pages', N'', N'0', N'1', N'', N'0')
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'217', N'pages', N'', N'0', N'1', N'', N'0')
GO

INSERT INTO [dbo].[cb_page]  VALUES (N'218', N'pages', N'', N'0', N'1', N'', N'0')
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_permission
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_permission]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_permission]
GO

CREATE TABLE [dbo].[cb_permission] (
  [permissionID] int IDENTITY(1,1) NOT NULL,
  [createdDate] datetime NOT NULL,
  [modifiedDate] datetime NOT NULL,
  [isDeleted] bit DEFAULT ((0)) NOT NULL,
  [permission] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [description] varchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

ALTER TABLE [dbo].[cb_permission] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_permission]
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[cb_permission] ON
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'1', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'PAGES_ADMIN', N'Ability to manage content pages, default is view only')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'2', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'EDITORS_EDITOR_SELECTOR', N'Ability to change the editor to another registered online editor')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'3', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'WIDGET_ADMIN', N'Ability to manage widgets, default is view only')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'4', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'TOOLS_IMPORT', N'Ability to import data into ContentBox')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'5', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'GLOBALHTML_ADMIN', N'Ability to manage the system''s global HTML content used on layouts')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'6', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'PAGES_EDITOR', N'Ability to manage content pages but not publish pages')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'7', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'SYSTEM_TAB', N'Access to the ContentBox System tools')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'9', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'SYSTEM_UPDATES', N'Ability to view and apply ContentBox updates')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'10', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'CONTENTBOX_ADMIN', N'Access to the enter the ContentBox administrator console')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'11', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'RELOAD_MODULES', N'Ability to reload modules')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'12', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'MODULES_ADMIN', N'Ability to manage ContentBox Modules')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'13', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'COMMENTS_ADMIN', N'Ability to manage comments, default is view only')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'14', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'AUTHOR_ADMIN', N'Ability to manage authors, default is view only')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'15', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'PERMISSIONS_ADMIN', N'Ability to manage permissions, default is view only')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'16', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'MEDIAMANAGER_ADMIN', N'Ability to manage the system''s media manager')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'17', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'SYSTEM_RAW_SETTINGS', N'Access to the ContentBox raw geek settings panel')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'18', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'CATEGORIES_ADMIN', N'Ability to manage categories, default is view only')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'19', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'EDITORS_DISPLAY_OPTIONS', N'Ability to view the content display options panel')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'20', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'EDITORS_HTML_ATTRIBUTES', N'Ability to view the content HTML attributes panel')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'22', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'FORGEBOX_ADMIN', N'Ability to manage ForgeBox installations and connectivity.')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'23', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'THEME_ADMIN', N'Ability to manage themes, default is view only')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'24', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'EDITORS_CATEGORIES', N'Ability to view the content categories panel')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'25', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'EDITORS_MODIFIERS', N'Ability to view the content modifiers panel')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'26', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'ENTRIES_ADMIN', N'Ability to manage blog entries, default is view only')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'27', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'VERSIONS_ROLLBACK', N'Ability to rollback content versions')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'28', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'EDITORS_CACHING', N'Ability to view the content caching panel')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'29', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'ROLES_ADMIN', N'Ability to manage roles, default is view only')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'30', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'SYSTEM_SAVE_CONFIGURATION', N'Ability to update global configuration data')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'31', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'ENTRIES_EDITOR', N'Ability to manage blog entries but not publish entries')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'32', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'VERSIONS_DELETE', N'Ability to delete past content versions')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'33', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'SECURITYRULES_ADMIN', N'Ability to manage the system''s security rules, default is view only')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'34', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'TOOLS_EXPORT', N'Ability to export data from ContentBox')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'36', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'CONTENTSTORE_ADMIN', N'Ability to manage the content store, default is view only')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'37', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'CONTENTSTORE_EDITOR', N'Ability to manage content store elements but not publish them')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'38', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'MEDIAMANAGER_LIBRARY_SWITCHER', N'Ability to switch media manager libraries for management')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'39', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'EDITORS_CUSTOM_FIELDS', N'Ability to manage custom fields in any content editors')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'40', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'GLOBAL_SEARCH', N'Ability to do global searches in the ContentBox Admin')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'41', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'EDITORS_RELATED_CONTENT', N'Ability to view the related content panel')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'42', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'EDITORS_LINKED_CONTENT', N'Ability to view the linked content panel')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'43', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'MENUS_ADMIN', N'Ability to manage the menu builder')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'44', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'SYSTEM_AUTH_LOGS', N'Access to the system auth logs')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'45', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'EDITORS_FEATURED_IMAGE', N'Ability to view the featured image panel')
GO

INSERT INTO [dbo].[cb_permission] ([permissionID], [createdDate], [modifiedDate], [isDeleted], [permission], [description]) VALUES (N'46', N'2017-06-20 16:13:01.000', N'2017-06-20 16:13:01.000', N'0', N'EMAIL_TEMPLATE_ADMIN', N'Ability to admin and preview email templates')
GO

SET IDENTITY_INSERT [dbo].[cb_permission] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_permissionGroup
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_permissionGroup]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_permissionGroup]
GO

CREATE TABLE [dbo].[cb_permissionGroup] (
  [permissionGroupID] int IDENTITY(1,1) NOT NULL,
  [createdDate] datetime NOT NULL,
  [modifiedDate] datetime NOT NULL,
  [isDeleted] bit DEFAULT ((0)) NOT NULL,
  [name] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [description] varchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

ALTER TABLE [dbo].[cb_permissionGroup] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_permissionGroup]
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[cb_permissionGroup] ON
GO

INSERT INTO [dbo].[cb_permissionGroup] ([permissionGroupID], [createdDate], [modifiedDate], [isDeleted], [name], [description]) VALUES (N'1', N'2017-06-12 16:01:13.000', N'2017-06-12 20:31:52.000', N'0', N'Finance', N'Finance team permissions')
GO

INSERT INTO [dbo].[cb_permissionGroup] ([permissionGroupID], [createdDate], [modifiedDate], [isDeleted], [name], [description]) VALUES (N'2', N'2017-06-16 13:02:12.000', N'2017-06-16 13:02:12.000', N'0', N'Security', N'')
GO

SET IDENTITY_INSERT [dbo].[cb_permissionGroup] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_relatedContent
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_relatedContent]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_relatedContent]
GO

CREATE TABLE [dbo].[cb_relatedContent] (
  [FK_contentID] int NOT NULL,
  [FK_relatedContentID] int NOT NULL
)
GO

ALTER TABLE [dbo].[cb_relatedContent] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Table structure for cb_role
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_role]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_role]
GO

CREATE TABLE [dbo].[cb_role] (
  [roleID] int IDENTITY(1,1) NOT NULL,
  [createdDate] datetime NOT NULL,
  [modifiedDate] datetime NOT NULL,
  [isDeleted] bit DEFAULT ((0)) NOT NULL,
  [role] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [description] varchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

ALTER TABLE [dbo].[cb_role] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_role]
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[cb_role] ON
GO

INSERT INTO [dbo].[cb_role] ([roleID], [createdDate], [modifiedDate], [isDeleted], [role], [description]) VALUES (N'1', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'Editor', N'A ContentBox editor')
GO

INSERT INTO [dbo].[cb_role] ([roleID], [createdDate], [modifiedDate], [isDeleted], [role], [description]) VALUES (N'2', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'Administrator', N'A ContentBox Administrator')
GO

INSERT INTO [dbo].[cb_role] ([roleID], [createdDate], [modifiedDate], [isDeleted], [role], [description]) VALUES (N'3', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'MegaAdmin', N'A ContentBox Mega Admin')
GO

INSERT INTO [dbo].[cb_role] ([roleID], [createdDate], [modifiedDate], [isDeleted], [role], [description]) VALUES (N'5', N'2016-09-23 14:35:41.000', N'2016-09-23 14:35:41.000', N'0', N'Test', N'Test')
GO

SET IDENTITY_INSERT [dbo].[cb_role] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_rolePermissions
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_rolePermissions]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_rolePermissions]
GO

CREATE TABLE [dbo].[cb_rolePermissions] (
  [FK_roleID] int NOT NULL,
  [FK_permissionID] int NOT NULL
)
GO

ALTER TABLE [dbo].[cb_rolePermissions] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_rolePermissions]
-- ----------------------------
BEGIN TRANSACTION
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'14')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'18')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'13')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'10')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'28')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'24')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'19')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'2')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'20')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'25')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'26')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'31')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'22')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'5')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'23')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'16')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'12')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'1')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'6')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'15')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'11')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'29')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'33')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'17')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'30')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'7')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'9')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'4')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'32')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'27')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'3', N'3')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'14')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'18')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'13')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'10')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'36')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'37')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'28')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'24')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'39')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'19')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'2')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'45')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'20')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'42')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'25')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'41')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'26')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'31')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'22')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'5')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'40')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'16')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'38')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'43')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'12')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'1')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'6')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'15')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'11')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'29')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'33')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'44')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'17')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'30')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'7')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'9')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'23')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'34')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'4')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'32')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'27')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'3')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'2', N'46')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'18')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'13')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'10')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'37')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'28')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'24')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'39')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'19')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'2')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'20')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'42')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'25')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'41')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'46')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'31')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'5')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'40')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'16')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'43')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'6')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'23')
GO

INSERT INTO [dbo].[cb_rolePermissions]  VALUES (N'1', N'27')
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_securityRule
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_securityRule]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_securityRule]
GO

CREATE TABLE [dbo].[cb_securityRule] (
  [ruleID] int IDENTITY(1,1) NOT NULL,
  [createdDate] datetime NOT NULL,
  [modifiedDate] datetime NOT NULL,
  [isDeleted] bit DEFAULT ((0)) NOT NULL,
  [whitelist] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [securelist] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [roles] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [permissions] varchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [redirect] varchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [useSSL] tinyint NULL,
  [order] int NOT NULL,
  [match] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [message] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [messageType] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT ('info') NULL
)
GO

ALTER TABLE [dbo].[cb_securityRule] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_securityRule]
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[cb_securityRule] ON
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'26', N'2017-07-06 12:14:21.000', N'2017-07-06 12:14:21.000', N'0', N'', N'^contentbox-admin:modules\\..*', N'', N'MODULES_ADMIN', N'cbadmin/security/login', N'0', N'1', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'27', N'2017-07-06 12:14:21.000', N'2017-07-06 12:14:21.000', N'0', N'', N'^contentbox-admin:mediamanager\\..*', N'', N'MEDIAMANAGER_ADMIN', N'cbadmin/security/login', N'0', N'1', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'28', N'2017-07-06 12:14:21.000', N'2017-07-06 12:14:21.000', N'0', N'', N'^contentbox-admin:versions\\.(remove)', N'', N'VERSIONS_DELETE', N'cbadmin/security/login', N'0', N'1', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'29', N'2017-07-06 12:14:21.000', N'2017-07-06 12:14:21.000', N'0', N'', N'^contentbox-admin:versions\\.(rollback)', N'', N'VERSIONS_ROLLBACK', N'cbadmin/security/login', N'0', N'1', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'30', N'2017-07-06 12:14:21.000', N'2017-07-06 12:14:21.000', N'0', N'', N'^contentbox-admin:widgets\\.(remove|upload|edit|save|create|doCreate)$', N'', N'WIDGET_ADMIN', N'cbadmin/security/login', N'0', N'2', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'31', N'2017-07-06 12:14:21.000', N'2017-07-06 12:14:21.000', N'0', N'', N'^contentbox-admin:tools\\.(importer|doImport)', N'', N'TOOLS_IMPORT', N'cbadmin/security/login', N'0', N'3', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'32', N'2017-07-06 12:14:22.000', N'2017-07-06 12:14:22.000', N'0', N'', N'^contentbox-admin:(settings|permissions|roles|securityRules)\\..*', N'', N'SYSTEM_TAB', N'cbadmin/security/login', N'0', N'4', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'33', N'2017-07-06 12:14:22.000', N'2017-07-06 12:14:22.000', N'0', N'', N'^contentbox-admin:settings\\.save', N'', N'SYSTEM_SAVE_CONFIGURATION', N'cbadmin/security/login', N'0', N'5', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'34', N'2017-07-06 12:14:22.000', N'2017-07-06 12:14:22.000', N'0', N'', N'^contentbox-admin:settings\\.(raw|saveRaw|flushCache|flushSingletons|mappingDump|viewCached|remove)', N'', N'SYSTEM_RAW_SETTINGS', N'cbadmin/security/login', N'0', N'6', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'35', N'2017-07-06 12:14:22.000', N'2017-07-06 12:14:22.000', N'0', N'', N'^contentbox-admin:securityRules\\.(remove|save|changeOrder|apply)', N'', N'SECURITYRULES_ADMIN', N'cbadmin/security/login', N'0', N'7', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'36', N'2017-07-06 12:14:22.000', N'2017-07-06 12:14:22.000', N'0', N'', N'^contentbox-admin:roles\\.(remove|removePermission|save|savePermission)', N'', N'ROLES_ADMIN', N'cbadmin/security/login', N'0', N'8', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'37', N'2017-07-06 12:14:22.000', N'2017-07-06 12:14:22.000', N'0', N'', N'^contentbox-admin:permissions\\.(remove|save)', N'', N'PERMISSIONS_ADMIN', N'cbadmin/security/login', N'0', N'9', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'38', N'2017-07-06 12:14:22.000', N'2017-07-06 12:14:22.000', N'0', N'', N'^contentbox-admin:dashboard\\.reload', N'', N'RELOAD_MODULES', N'cbadmin/security/login', N'0', N'10', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'39', N'2017-07-06 12:14:22.000', N'2017-07-06 12:14:22.000', N'0', N'', N'^contentbox-admin:pages\\.(changeOrder|remove)', N'', N'PAGES_ADMIN', N'cbadmin/security/login', N'0', N'11', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'40', N'2017-07-06 12:14:22.000', N'2017-07-06 12:14:22.000', N'0', N'', N'^contentbox-admin:themes\\.(remove|upload|rebuildRegistry|activate)', N'', N'THEME_ADMIN', N'cbadmin/security/login', N'0', N'12', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'41', N'2017-07-06 12:14:22.000', N'2017-07-06 12:14:22.000', N'0', N'', N'^contentbox-admin:entries\\.(quickPost|remove)', N'', N'ENTRIES_ADMIN', N'cbadmin/security/login', N'0', N'13', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'42', N'2017-07-06 12:14:22.000', N'2017-07-06 12:14:22.000', N'0', N'', N'^contentbox-admin:contentStore\\.(editor|remove|save)', N'', N'CONTENTSTORE_ADMIN', N'cbadmin/security/login', N'0', N'14', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'43', N'2017-07-06 12:14:22.000', N'2017-07-06 12:14:22.000', N'0', N'', N'^contentbox-admin:comments\\.(doStatusUpdate|editor|moderate|remove|save|saveSettings)', N'', N'COMMENTS_ADMIN', N'cbadmin/security/login', N'0', N'15', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'44', N'2017-07-06 12:14:22.000', N'2017-07-06 12:14:22.000', N'0', N'', N'^contentbox-admin:categories\\.(remove|save)', N'', N'CATEGORIES_ADMIN', N'cbadmin/security/login', N'0', N'16', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'45', N'2017-07-06 12:14:22.000', N'2017-07-06 12:14:22.000', N'0', N'', N'^contentbox-admin:authors\\.(remove|removePermission|savePermission|doPasswordReset|new|doNew)', N'', N'AUTHOR_ADMIN', N'cbadmin/security/login', N'0', N'17', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'46', N'2017-07-06 12:14:22.000', N'2017-07-06 12:14:22.000', N'0', N'^contentbox-admin:security\\.', N'^contentbox-admin:.*', N'', N'CONTENTBOX_ADMIN', N'cbadmin/security/login', N'0', N'18', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'47', N'2017-07-06 12:14:22.000', N'2017-07-06 12:14:22.000', N'0', N'', N'^contentbox-filebrowser:.*', N'', N'MEDIAMANAGER_ADMIN', N'cbadmin/security/login', N'0', N'19', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'48', N'2017-07-06 12:14:22.000', N'2017-07-06 12:14:22.000', N'0', N'', N'^contentbox-admin:(authors|categories|permissions|roles|settings|pages|entries|contentStore|securityrules)\\.importAll$', N'', N'TOOLS_IMPORT', N'cbadmin/security/login', N'0', N'20', N'event', N'', N'info')
GO

INSERT INTO [dbo].[cb_securityRule] ([ruleID], [createdDate], [modifiedDate], [isDeleted], [whitelist], [securelist], [roles], [permissions], [redirect], [useSSL], [order], [match], [message], [messageType]) VALUES (N'49', N'2017-07-06 12:14:22.000', N'2017-07-06 12:14:22.000', N'0', N'', N'^contentbox-admin:(authors|categories|permissions|roles|settings|pages|entries|contentStore|securityrules)\\.(export|exportAll)$', N'', N'TOOLS_EXPORT', N'cbadmin/security/login', N'0', N'20', N'event', N'', N'info')
GO

SET IDENTITY_INSERT [dbo].[cb_securityRule] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_setting
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_setting]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_setting]
GO

CREATE TABLE [dbo].[cb_setting] (
  [settingID] int IDENTITY(1,1) NOT NULL,
  [createdDate] datetime NOT NULL,
  [modifiedDate] datetime NOT NULL,
  [isDeleted] bit DEFAULT ((0)) NOT NULL,
  [name] varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [value] text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [isCore] tinyint DEFAULT ((0)) NOT NULL
)
GO

ALTER TABLE [dbo].[cb_setting] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_setting]
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[cb_setting] ON
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'1', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_comments_moderation_blockedlist', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'2', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_paging_maxrows', N'25', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'3', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_comments_captcha', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'4', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_name', N'ContentBox Site', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'5', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_comments_urltranslations', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'6', N'2016-05-03 16:23:26.000', N'2016-05-06 15:47:29.000', N'0', N'cb_editors_ckeditor_extraplugins', N'cbWidgets,cbLinks,cbEntryLinks,cbContentStore,cbIpsumLorem,wsc,mediaembed,insertpre,cbKeyBinding,about', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'7', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_media_uploadify_customOptions', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'8', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_mail_server', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'9', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_dashboard_recentPages', N'10', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'10', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_html_preEntryDisplay', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'11', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_comments_enabled', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'12', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_mail_password', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'13', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_mail_ssl', N'false', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'14', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_ssl', N'false', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'15', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_html_beforeContent', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'16', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_dashboard_recentComments', N'10', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'17', N'2016-05-03 16:23:26.000', N'2017-07-05 15:21:46.000', N'0', N'cb_versions_max_history', N'10', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'18', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_media_provider_caching', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'19', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_keywords', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'20', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_html_preIndexDisplay', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'21', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_content_cachingTimeout', N'60', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'22', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_comments_moderation', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'23', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_html_beforeHeadEnd', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'24', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_media_uploadify_sizeLimit', N'0', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'25', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_notify_entry', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'26', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_email', N'lmajano@gmail.com', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'27', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_maintenance_message', N'<h1>This site is down for maintenance.<br /> Please check back again soon.</h1>', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'28', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_media_acceptMimeTypes', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'29', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_comments_notifyemails', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'30', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_media_allowDownloads', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'31', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_html_postArchivesDisplay', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'32', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_comments_moderation_blacklist', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'33', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_salt', N'680D79D4A38FDBE8AF62014354B43AA54040B05B7EA74B3D7D1AE87C0C5A5DC2233A31C4067691B451A1AE7CEABB691D9432F073A0D242C1980642D855472769', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'34', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_admin_ssl', N'false', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'35', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_outgoingEmail', N'lmajano@gmail.com', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'36', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_media_uplodify_fileExt', N'*.*;', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'37', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_comments_moderation_whitelist', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'38', N'2016-05-03 16:23:26.000', N'2017-06-13 14:34:04.000', N'0', N'cb_contentstore_caching', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'39', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_media_quickViewWidth', N'400', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'40', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_search_maxResults', N'20', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'41', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_notify_author', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'42', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_blog_entrypoint', N'blog', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'43', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_media_allowUploads', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'44', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_page_excerpts', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'45', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_html_preCommentForm', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'46', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_media_createFolders', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'47', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_mail_tls', N'false', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'48', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_media_html5uploads_maxFileSize', N'100', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'49', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_versions_commit_mandatory', N'false', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'50', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_comments_moderation_notify', N'false', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'51', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_tagline', N'My Awesome Site', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'52', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_mail_smtp', N'25', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'53', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_mail_username', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'54', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_comments_notify', N'false', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'55', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_rss_cachingTimeoutIdle', N'15', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'56', N'2016-05-03 16:23:26.000', N'2017-06-13 14:34:04.000', N'0', N'cb_content_caching', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'57', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_search_adapter', N'contentbox.models.search.DBSearch', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'58', N'2016-05-03 16:23:26.000', N'2016-08-05 11:46:13.000', N'0', N'cb_site_maintenance', N'false', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'59', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_html_afterSideBar', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'60', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_html_postCommentForm', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'61', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_rss_caching', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'62', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_paging_maxRSSComments', N'10', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'63', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_media_uplodify_fileDesc', N'All Files', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'64', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_description', N'My Awesome Site', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'65', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_paging_maxentries', N'10', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'66', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_html_postEntryDisplay', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'67', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_media_uploadify_allowMulti', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'68', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_html_afterBodyStart', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'69', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_html_afterFooter', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'70', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_theme', N'default', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'71', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_html_postIndexDisplay', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'72', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_gravatar_display', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'73', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_editors_ckeditor_excerpt_toolbar', N'[
    { "name": "document",    "items" : [ "Source","ShowBlocks" ] },
    { "name": "basicstyles", "items" : [ "Bold","Italic","Underline","Strike","Subscript","Superscript"] },
    { "name": "paragraph",   "items" : [ "NumberedList","BulletedList","-","Outdent","Indent","CreateDiv"] },
    { "name": "links",       "items" : [ "Link","Unlink","Anchor" ] },
    { "name": "insert",      "items" : [ "Image","Flash","Table","HorizontalRule","Smiley","SpecialChar" ] },
    { "name": "contentbox",  "items" : [ "MediaEmbed","cbIpsumLorem","cbWidgets","cbContentStore","cbLinks","cbEntryLinks" ] }
]', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'74', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_html_preArchivesDisplay', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'75', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_html_prePageDisplay', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'76', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_media_provider', N'CFContentMediaProvider', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'77', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_disable_blog', N'false', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'78', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_editors_markup', N'HTML', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'79', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_rss_maxEntries', N'10', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'80', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_homepage', N'support', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'81', N'2016-05-03 16:23:26.000', N'2016-05-06 15:47:29.000', N'0', N'cb_editors_ckeditor_toolbar', N'[
{ "name": "document",    "items" : [ "Source","-","Maximize","ShowBlocks" ] },
{ "name": "clipboard",   "items" : [ "Cut","Copy","Paste","PasteText","PasteFromWord","-","Undo","Redo" ] },
{ "name": "editing",     "items" : [ "Find","Replace","SpellChecker"] },
{ "name": "forms",       "items" : [ "Form", "Checkbox", "Radio", "TextField", "Textarea", "Select", "Button","HiddenField" ] },
"/",
{ "name": "basicstyles", "items" : [ "Bold","Italic","Underline","Strike","Subscript","Superscript","-","RemoveFormat" ] },
{ "name": "paragraph",   "items" : [ "NumberedList","BulletedList","-","Outdent","Indent","-","Blockquote","CreateDiv","-","JustifyLeft","JustifyCenter","JustifyRight","JustifyBlock","-","BidiLtr","BidiRtl" ] },
{ "name": "links",       "items" : [ "Link","Unlink","Anchor" ] },
"/",
{ "name": "styles",      "items" : [ "Styles","Format" ] },
{ "name": "colors",      "items" : [ "TextColor","BGColor" ] },
{ "name": "insert",      "items" : [ "Image","Flash","Table","HorizontalRule","Smiley","SpecialChar","Iframe","InsertPre"] },
{ "name": "contentbox",  "items" : [ "MediaEmbed","cbIpsumLorem","cbWidgets","cbContentStore","cbLinks","cbEntryLinks" ] }
]', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'82', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_comments_maxDisplayChars', N'500', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'83', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_rss_cachingTimeout', N'60', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'84', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_html_beforeSideBar', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'85', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_content_cacheName', N'TEMPLATE', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'86', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_dashboard_newsfeed_count', N'10', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'87', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_dashboard_newsfeed', N'http://www.ortussolutions.com/blog/rss', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'88', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_html_afterContent', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'89', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_rss_maxComments', N'10', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'90', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_media_directoryRoot', N'/contentbox-custom/_content', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'91', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_media_html5uploads_maxFiles', N'25', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'92', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_admin_quicksearch_max', N'10', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'93', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_media_allowDelete', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'94', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_dashboard_recentEntries', N'10', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'95', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_rss_cacheName', N'TEMPLATE', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'96', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_html_beforeBodyEnd', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'97', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_paging_bandgap', N'5', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'98', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_gravatar_rating', N'PG', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'99', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_notify_page', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'100', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_html_postPageDisplay', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'101', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_editors_default', N'ckeditor', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'102', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_content_cachingTimeoutIdle', N'15', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'103', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_comments_whoisURL', N'http://whois.arin.net/ui/query.do?q', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'104', N'2016-05-03 16:23:26.000', N'2017-06-13 14:34:04.000', N'0', N'cb_entry_caching', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'105', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_active', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'106', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_layout_default_googleAnalyticsAPI', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'107', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_dashboard_recentContentStore', N'10', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'108', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_content_uiexport', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'109', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cbox-htmlcompressor', N'{\"REMOVEFORMATTRIBUTES\":false,\"RENDERCACHELASTACCESSTIMEOUT\":15,\"REMOVEMULTISPACES\":true,\"SIMPLEBOOLEANATTRIBUTES\":false,\"REMOVELINKATTRIBUTES\":false,\"REMOVESCRIPTATTRIBUTES\":false,\"RENDERCACHETIMEOUT\":60,\"RENDERCACHEPROVIDER\":\"template\",\"RENDERCACHING\":true,\"REMOVEHTTPSPROTOCOL\":false,\"PRESERVELINEBREAKS\":false,\"REMOVEJAVASCRIPTPROTOCOL\":false,\"REMOVESTYLEATTRIBUTES\":false,\"SIMPLEDOCTYPE\":false,\"REMOVECOMMENTS\":true,\"REMOVEQUOTES\":false,\"REMOVEINPUTATTRIBUTES\":false,\"REMOVEHTTPPROTOCOL\":false,\"COMPRESSCSS\":true,\"REMOVEINTERTAGSPACES\":false,\"RENDERCACHEPREFIX\":\"cbox-compressor\",\"RENDERCOMPRESSOR\":true,\"COMPRESSJAVASCRIPT\":true}', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'110', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_admin_theme', N'contentbox-default', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'116', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_notify_contentstore', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'117', N'2016-05-03 16:23:26.000', N'2017-06-13 17:10:38.000', N'0', N'cb_comments_moderation_expiration', N'0', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'118', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_dashboard_welcome_title', N'Welcome To Your ContentBox Dashboard', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'119', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_dashboard_welcome_body', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'120', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_content_cachingHeader', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'121', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_poweredby', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'122', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'jonathan', N'cool', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'123', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_enc_key', N'kcvHUKEWlMEmfZo5b5sRuA==', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'124', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cbox-htmlcompressor', N'{\"REMOVEFORMATTRIBUTES\":false,\"RENDERCACHELASTACCESSTIMEOUT\":15,\"REMOVEMULTISPACES\":true,\"SIMPLEBOOLEANATTRIBUTES\":false,\"REMOVELINKATTRIBUTES\":false,\"REMOVESCRIPTATTRIBUTES\":false,\"RENDERCACHETIMEOUT\":60,\"RENDERCACHEPROVIDER\":\"template\",\"RENDERCACHING\":true,\"REMOVEHTTPSPROTOCOL\":false,\"PRESERVELINEBREAKS\":false,\"REMOVEJAVASCRIPTPROTOCOL\":false,\"REMOVESTYLEATTRIBUTES\":false,\"SIMPLEDOCTYPE\":false,\"REMOVECOMMENTS\":true,\"REMOVEQUOTES\":false,\"REMOVEINPUTATTRIBUTES\":false,\"REMOVEHTTPPROTOCOL\":false,\"COMPRESSCSS\":true,\"REMOVEINTERTAGSPACES\":false,\"RENDERCACHEPREFIX\":\"cbox-compressor\",\"RENDERCOMPRESSOR\":true,\"COMPRESSJAVASCRIPT\":true}', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'125', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_rss_title', N'RSS Feed by ContentBox', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'126', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_rss_generator', N'ContentBox by Ortus Solutions', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'127', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_rss_copyright', N'Ortus Solutions, Corp (www.ortussolutions.com)', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'128', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_rss_description', N'ContentBox RSS Feed', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'129', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_rss_webmaster', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'130', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_content_hit_count', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'131', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_content_hit_ignore_bots', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'132', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_content_bot_regex', N'Google|msnbot|Rambler|Yahoo|AbachoBOT|accoona|AcioRobot|ASPSeek|CocoCrawler|Dumbot|FAST-WebCrawler|GeonaBot|Gigabot|Lycos|MSRBOT|Scooter|AltaVista|IDBot|eStyle|Scrubby', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'133', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_security_login_blocker', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'134', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_security_max_Attempts', N'5', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'135', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_security_blocktime', N'5', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'136', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_security_max_auth_logs', N'500', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'137', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_security_latest_logins', N'10', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'138', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_security_rate_limiter', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'139', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_security_rate_limiter_count', N'4', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'140', N'2016-05-03 16:23:26.000', N'2017-06-13 14:34:48.000', N'0', N'cb_security_rate_limiter_duration', N'1', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'141', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_security_rate_limiter_bots_only', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'142', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_security_rate_limiter_message', N'<p>You are making too many requests too fast, please slow down and wait {duration} seconds</p>', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'158', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_theme_default_cbBootswatchTheme', N'green', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'159', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_theme_default_footerBox', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'160', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_theme_default_hpHeaderTitle', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'161', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_theme_default_hpHeaderText', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'162', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_theme_default_hpHeaderLink', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'163', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_theme_default_hpHeaderBg', N'World', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'164', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_theme_default_rssDiscovery', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'165', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_site_settings_cache', N'TEMPLATE', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'166', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_theme_default_showCategoriesBlogSide', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'167', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_theme_default_showRecentEntriesBlogSide', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'168', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_theme_default_showSiteUpdatesBlogSide', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'169', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_theme_default_showEntryCommentsBlogSide', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'170', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_theme_default_showArchivesBlogSide', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'171', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_theme_default_showEntriesSearchBlogSide', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'172', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_theme_default_headerLogo', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'173', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_theme_default_hpHeaderBtnText', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'174', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'cb_theme_default_hpHeaderImgBg', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'175', N'2016-06-14 12:56:47.000', N'2016-06-14 12:56:47.000', N'0', N'cb_theme_default_showSiteSearch', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'176', N'2017-06-13 11:52:39.000', N'2017-06-13 11:52:39.000', N'0', N'cb_theme_default_overrideHeaderColors', N'false', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'177', N'2017-06-13 11:52:39.000', N'2017-06-13 11:52:39.000', N'0', N'cb_theme_default_overrideHeaderBGColor', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'178', N'2017-06-13 11:52:39.000', N'2017-06-13 11:52:39.000', N'0', N'cb_theme_default_overrideHeaderTextColor', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'179', N'2017-06-13 11:52:39.000', N'2017-06-13 11:52:39.000', N'0', N'cb_theme_default_cssStyleOverrides', N'', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'180', N'2017-06-13 11:52:39.000', N'2017-06-13 11:52:39.000', N'0', N'cb_theme_default_hpHeaderBtnStyle', N'primary', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'181', N'2017-06-13 11:52:39.000', N'2017-06-13 11:52:39.000', N'0', N'cb_theme_default_hpHeaderBgPos', N'Top Center', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'182', N'2017-06-13 11:52:39.000', N'2017-06-13 11:52:39.000', N'0', N'cb_theme_default_hpHeaderBgPaddingTop', N'100px', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'183', N'2017-06-13 11:52:39.000', N'2017-06-13 11:52:39.000', N'0', N'cb_theme_default_hpHeaderBgPaddingBottom', N'50px', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'184', N'2017-06-13 14:32:33.000', N'2017-06-13 14:32:56.000', N'0', N'cb_site_sitemap', N'true', N'0')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'185', N'2017-06-13 14:33:11.000', N'2017-06-13 14:33:11.000', N'0', N'cb_site_adminbar', N'true', N'1')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'186', N'2017-06-13 14:33:22.000', N'2017-06-13 14:33:22.000', N'0', N'CB_SECURITY_RATE_LIMITER_LOGGING', N'true', N'1')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'187', N'2017-06-13 14:33:30.000', N'2017-06-13 14:33:30.000', N'0', N'cb_security_rate_limiter_redirectURL', N'', N'1')
GO

INSERT INTO [dbo].[cb_setting] ([settingID], [createdDate], [modifiedDate], [isDeleted], [name], [value], [isCore]) VALUES (N'188', N'2017-07-05 14:07:42.000', N'2017-07-05 14:40:56.000', N'0', N'cb_security_min_password_length', N'8', N'1')
GO

SET IDENTITY_INSERT [dbo].[cb_setting] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_stats
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_stats]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_stats]
GO

CREATE TABLE [dbo].[cb_stats] (
  [statsID] int IDENTITY(1,1) NOT NULL,
  [createdDate] datetime NOT NULL,
  [modifiedDate] datetime NOT NULL,
  [isDeleted] bit DEFAULT ((0)) NOT NULL,
  [hits] numeric(19) NULL,
  [FK_contentID] int NOT NULL
)
GO

ALTER TABLE [dbo].[cb_stats] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_stats]
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[cb_stats] ON
GO

INSERT INTO [dbo].[cb_stats] ([statsID], [createdDate], [modifiedDate], [isDeleted], [hits], [FK_contentID]) VALUES (N'1', N'2017-07-18 13:56:32.000', N'2017-07-18 14:53:33.000', N'0', N'4', N'147')
GO

INSERT INTO [dbo].[cb_stats] ([statsID], [createdDate], [modifiedDate], [isDeleted], [hits], [FK_contentID]) VALUES (N'2', N'2017-07-18 14:51:59.000', N'2017-07-18 14:51:59.000', N'0', N'1', N'135')
GO

SET IDENTITY_INSERT [dbo].[cb_stats] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_subscribers
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_subscribers]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_subscribers]
GO

CREATE TABLE [dbo].[cb_subscribers] (
  [subscriberID] int IDENTITY(1,1) NOT NULL,
  [createdDate] datetime NOT NULL,
  [modifiedDate] datetime NOT NULL,
  [isDeleted] bit DEFAULT ((0)) NOT NULL,
  [subscriberEmail] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [subscriberToken] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO

ALTER TABLE [dbo].[cb_subscribers] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_subscribers]
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[cb_subscribers] ON
GO

INSERT INTO [dbo].[cb_subscribers] ([subscriberID], [createdDate], [modifiedDate], [isDeleted], [subscriberEmail], [subscriberToken]) VALUES (N'1', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'lmajano@ortussolutions.com', N'9160905AD002614B9A06E7A59F6F137F')
GO

INSERT INTO [dbo].[cb_subscribers] ([subscriberID], [createdDate], [modifiedDate], [isDeleted], [subscriberEmail], [subscriberToken]) VALUES (N'2', N'2016-05-03 16:23:26.000', N'2016-05-03 16:23:26.000', N'0', N'lmajano@gmail.com', N'28B937F6F2F970189DB7ED3C909DE922')
GO

SET IDENTITY_INSERT [dbo].[cb_subscribers] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for cb_subscriptions
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[cb_subscriptions]') AND type IN ('U'))
	DROP TABLE [dbo].[cb_subscriptions]
GO

CREATE TABLE [dbo].[cb_subscriptions] (
  [subscriptionID] int IDENTITY(1,1) NOT NULL,
  [createdDate] datetime NOT NULL,
  [modifiedDate] datetime NOT NULL,
  [isDeleted] bit DEFAULT ((0)) NOT NULL,
  [subscriptionToken] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [type] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [FK_subscriberID] int NOT NULL
)
GO

ALTER TABLE [dbo].[cb_subscriptions] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of [cb_subscriptions]
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[cb_subscriptions] ON
GO

INSERT INTO [dbo].[cb_subscriptions] ([subscriptionID], [createdDate], [modifiedDate], [isDeleted], [subscriptionToken], [type], [FK_subscriberID]) VALUES (N'4', N'2015-08-04 16:17:43.000', N'2016-05-03 16:23:25.000', N'0', N'AD2669C5064D113531970A672B887743', N'Comment', N'2')
GO

INSERT INTO [dbo].[cb_subscriptions] ([subscriptionID], [createdDate], [modifiedDate], [isDeleted], [subscriptionToken], [type], [FK_subscriberID]) VALUES (N'5', N'2016-05-11 16:12:34.000', N'2016-05-11 16:12:34.000', N'0', N'E880B3507068855A1EA3D333021267B3', N'Comment', N'2')
GO

INSERT INTO [dbo].[cb_subscriptions] ([subscriptionID], [createdDate], [modifiedDate], [isDeleted], [subscriptionToken], [type], [FK_subscriberID]) VALUES (N'6', N'2016-05-12 12:34:18.000', N'2016-05-12 12:34:18.000', N'0', N'CB8797B8A3C80D045D232DA79C9E6FD9', N'Comment', N'1')
GO

SET IDENTITY_INSERT [dbo].[cb_subscriptions] OFF
GO

COMMIT
GO


-- ----------------------------
-- Indexes structure for table cb_author
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_login]
ON [dbo].[cb_author] (
  [username] ASC,
  [password] ASC,
  [isActive] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_createDate]
ON [dbo].[cb_author] (
  [createdDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_modifiedDate]
ON [dbo].[cb_author] (
  [modifiedDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_activeAuthor]
ON [dbo].[cb_author] (
  [isActive] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_passwordReset]
ON [dbo].[cb_author] (
  [isPasswordReset] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_email]
ON [dbo].[cb_author] (
  [email] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_deleted]
ON [dbo].[cb_author] (
  [isDeleted] ASC
)
GO


-- ----------------------------
-- Uniques structure for table cb_author
-- ----------------------------
ALTER TABLE [dbo].[cb_author] ADD CONSTRAINT [UQ__cb_autho__F3DBC572B8B4E5E6] UNIQUE NONCLUSTERED ([username] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table cb_author
-- ----------------------------
ALTER TABLE [dbo].[cb_author] ADD CONSTRAINT [PK__cb_autho__8E2731D9ADD2571C] PRIMARY KEY CLUSTERED ([authorID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Indexes structure for table cb_category
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_createDate]
ON [dbo].[cb_category] (
  [createdDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_modifiedDate]
ON [dbo].[cb_category] (
  [modifiedDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_deleted]
ON [dbo].[cb_category] (
  [isDeleted] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_categorySlug]
ON [dbo].[cb_category] (
  [slug] ASC
)
GO


-- ----------------------------
-- Uniques structure for table cb_category
-- ----------------------------
ALTER TABLE [dbo].[cb_category] ADD CONSTRAINT [UQ__cb_categ__32DD1E4C04F4D297] UNIQUE NONCLUSTERED ([slug] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table cb_category
-- ----------------------------
ALTER TABLE [dbo].[cb_category] ADD CONSTRAINT [PK__cb_categ__23CAF1F8C1940345] PRIMARY KEY CLUSTERED ([categoryID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Indexes structure for table cb_comment
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_createDate]
ON [dbo].[cb_comment] (
  [createdDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_approved]
ON [dbo].[cb_comment] (
  [isApproved] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_modifiedDate]
ON [dbo].[cb_comment] (
  [modifiedDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_contentComment]
ON [dbo].[cb_comment] (
  [isApproved] ASC,
  [FK_contentID] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_deleted]
ON [dbo].[cb_comment] (
  [isDeleted] ASC
)
GO


-- ----------------------------
-- Primary Key structure for table cb_comment
-- ----------------------------
ALTER TABLE [dbo].[cb_comment] ADD CONSTRAINT [PK__cb_comme__CDDE91BDB42E1FC0] PRIMARY KEY CLUSTERED ([commentID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Indexes structure for table cb_commentSubscriptions
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_contentCommentSubscription]
ON [dbo].[cb_commentSubscriptions] (
  [FK_contentID] ASC
)
GO


-- ----------------------------
-- Primary Key structure for table cb_commentSubscriptions
-- ----------------------------
ALTER TABLE [dbo].[cb_commentSubscriptions] ADD CONSTRAINT [PK__cb_comme__4A0F55C7E8C52728] PRIMARY KEY CLUSTERED ([subscriptionID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Indexes structure for table cb_content
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_cachelastaccesstimeout]
ON [dbo].[cb_content] (
  [cacheLastAccessTimeout] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_publishedSlug]
ON [dbo].[cb_content] (
  [slug] ASC,
  [isPublished] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_slug]
ON [dbo].[cb_content] (
  [slug] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_expireDate]
ON [dbo].[cb_content] (
  [expireDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_publishedDate]
ON [dbo].[cb_content] (
  [publishedDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_cache]
ON [dbo].[cb_content] (
  [cache] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_published]
ON [dbo].[cb_content] (
  [contentType] ASC,
  [isPublished] ASC,
  [passwordProtection] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_cachetimeout]
ON [dbo].[cb_content] (
  [cacheTimeout] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_createDate]
ON [dbo].[cb_content] (
  [createdDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_showInSearch]
ON [dbo].[cb_content] (
  [showInSearch] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_cachelayout]
ON [dbo].[cb_content] (
  [cacheLayout] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_modifiedDate]
ON [dbo].[cb_content] (
  [modifiedDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_search]
ON [dbo].[cb_content] (
  [title] ASC,
  [isPublished] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_discriminator]
ON [dbo].[cb_content] (
  [contentType] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_deleted]
ON [dbo].[cb_content] (
  [isDeleted] ASC
)
GO


-- ----------------------------
-- Uniques structure for table cb_content
-- ----------------------------
ALTER TABLE [dbo].[cb_content] ADD CONSTRAINT [UQ__cb_conte__32DD1E4CD839CB97] UNIQUE NONCLUSTERED ([slug] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table cb_content
-- ----------------------------
ALTER TABLE [dbo].[cb_content] ADD CONSTRAINT [PK__cb_conte__0BDC8739945C196A] PRIMARY KEY CLUSTERED ([contentID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table cb_contentStore
-- ----------------------------
ALTER TABLE [dbo].[cb_contentStore] ADD CONSTRAINT [PK__cb_conte__0BDC8739DB50412F] PRIMARY KEY CLUSTERED ([contentID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Indexes structure for table cb_contentVersion
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_version]
ON [dbo].[cb_contentVersion] (
  [version] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_createDate]
ON [dbo].[cb_contentVersion] (
  [createdDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_modifiedDate]
ON [dbo].[cb_contentVersion] (
  [modifiedDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_contentVersions]
ON [dbo].[cb_contentVersion] (
  [isActive] ASC,
  [FK_contentID] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_deleted]
ON [dbo].[cb_contentVersion] (
  [isDeleted] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_activeContentVersion]
ON [dbo].[cb_contentVersion] (
  [isActive] ASC
)
GO


-- ----------------------------
-- Primary Key structure for table cb_contentVersion
-- ----------------------------
ALTER TABLE [dbo].[cb_contentVersion] ADD CONSTRAINT [PK__cb_conte__3CDF037BA7005CC4] PRIMARY KEY CLUSTERED ([contentVersionID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Indexes structure for table cb_customfield
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_createDate]
ON [dbo].[cb_customfield] (
  [createdDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_contentCustomFields]
ON [dbo].[cb_customfield] (
  [FK_contentID] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_modifiedDate]
ON [dbo].[cb_customfield] (
  [modifiedDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_deleted]
ON [dbo].[cb_customfield] (
  [isDeleted] ASC
)
GO


-- ----------------------------
-- Primary Key structure for table cb_customfield
-- ----------------------------
ALTER TABLE [dbo].[cb_customfield] ADD CONSTRAINT [PK__cb_custo__1204C101D5F0A717] PRIMARY KEY CLUSTERED ([customFieldID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table cb_entry
-- ----------------------------
ALTER TABLE [dbo].[cb_entry] ADD CONSTRAINT [PK__cb_entry__0BDC8739DF749516] PRIMARY KEY CLUSTERED ([contentID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Indexes structure for table cb_loginAttempts
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_createDate]
ON [dbo].[cb_loginAttempts] (
  [createdDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_modifiedDate]
ON [dbo].[cb_loginAttempts] (
  [modifiedDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_values]
ON [dbo].[cb_loginAttempts] (
  [value] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_deleted]
ON [dbo].[cb_loginAttempts] (
  [isDeleted] ASC
)
GO


-- ----------------------------
-- Primary Key structure for table cb_loginAttempts
-- ----------------------------
ALTER TABLE [dbo].[cb_loginAttempts] ADD CONSTRAINT [PK__cb_login__2DABEC8B3CE81F66] PRIMARY KEY CLUSTERED ([loginAttemptsID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Indexes structure for table cb_menu
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_createDate]
ON [dbo].[cb_menu] (
  [createdDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_modifiedDate]
ON [dbo].[cb_menu] (
  [modifiedDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_menuslug]
ON [dbo].[cb_menu] (
  [slug] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_deleted]
ON [dbo].[cb_menu] (
  [isDeleted] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_menutitle]
ON [dbo].[cb_menu] (
  [title] ASC
)
GO


-- ----------------------------
-- Uniques structure for table cb_menu
-- ----------------------------
ALTER TABLE [dbo].[cb_menu] ADD CONSTRAINT [UQ__cb_menu__32DD1E4C3551F986] UNIQUE NONCLUSTERED ([slug] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table cb_menu
-- ----------------------------
ALTER TABLE [dbo].[cb_menu] ADD CONSTRAINT [PK__cb_menu__3B407E94CBDFA278] PRIMARY KEY CLUSTERED ([menuID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Indexes structure for table cb_menuItem
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_createDate]
ON [dbo].[cb_menuItem] (
  [createdDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_menuitemtitle]
ON [dbo].[cb_menuItem] (
  [title] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_modifiedDate]
ON [dbo].[cb_menuItem] (
  [modifiedDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_deleted]
ON [dbo].[cb_menuItem] (
  [isDeleted] ASC
)
GO


-- ----------------------------
-- Primary Key structure for table cb_menuItem
-- ----------------------------
ALTER TABLE [dbo].[cb_menuItem] ADD CONSTRAINT [PK__cb_menuI__682A1008C8F1B29C] PRIMARY KEY CLUSTERED ([menuItemID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Indexes structure for table cb_module
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_moduleName]
ON [dbo].[cb_module] (
  [name] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_createDate]
ON [dbo].[cb_module] (
  [createdDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_modifiedDate]
ON [dbo].[cb_module] (
  [modifiedDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_deleted]
ON [dbo].[cb_module] (
  [isDeleted] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_activeModule]
ON [dbo].[cb_module] (
  [isActive] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_entryPoint]
ON [dbo].[cb_module] (
  [entryPoint] ASC
)
GO


-- ----------------------------
-- Primary Key structure for table cb_module
-- ----------------------------
ALTER TABLE [dbo].[cb_module] ADD CONSTRAINT [PK__cb_modul__8EEC8E3797A7A023] PRIMARY KEY CLUSTERED ([moduleID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Indexes structure for table cb_page
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_ssl]
ON [dbo].[cb_page] (
  [SSLOnly] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_showInMenu]
ON [dbo].[cb_page] (
  [showInMenu] ASC
)
GO


-- ----------------------------
-- Primary Key structure for table cb_page
-- ----------------------------
ALTER TABLE [dbo].[cb_page] ADD CONSTRAINT [PK__cb_page__0BDC87398D076AC0] PRIMARY KEY CLUSTERED ([contentID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Indexes structure for table cb_permission
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_createDate]
ON [dbo].[cb_permission] (
  [createdDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_modifiedDate]
ON [dbo].[cb_permission] (
  [modifiedDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_deleted]
ON [dbo].[cb_permission] (
  [isDeleted] ASC
)
GO


-- ----------------------------
-- Uniques structure for table cb_permission
-- ----------------------------
ALTER TABLE [dbo].[cb_permission] ADD CONSTRAINT [UQ__cb_permi__2038359BD5B8A1FA] UNIQUE NONCLUSTERED ([permission] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table cb_permission
-- ----------------------------
ALTER TABLE [dbo].[cb_permission] ADD CONSTRAINT [PK__cb_permi__D821317C9F84E341] PRIMARY KEY CLUSTERED ([permissionID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Indexes structure for table cb_permissionGroup
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_createDate]
ON [dbo].[cb_permissionGroup] (
  [createdDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_modifiedDate]
ON [dbo].[cb_permissionGroup] (
  [modifiedDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_deleted]
ON [dbo].[cb_permissionGroup] (
  [isDeleted] ASC
)
GO


-- ----------------------------
-- Uniques structure for table cb_permissionGroup
-- ----------------------------
ALTER TABLE [dbo].[cb_permissionGroup] ADD CONSTRAINT [UQ__cb_permi__72E12F1B9673C008] UNIQUE NONCLUSTERED ([name] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table cb_permissionGroup
-- ----------------------------
ALTER TABLE [dbo].[cb_permissionGroup] ADD CONSTRAINT [PK__cb_permi__DAE909206AF82044] PRIMARY KEY CLUSTERED ([permissionGroupID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Indexes structure for table cb_role
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_createDate]
ON [dbo].[cb_role] (
  [createdDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_modifiedDate]
ON [dbo].[cb_role] (
  [modifiedDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_deleted]
ON [dbo].[cb_role] (
  [isDeleted] ASC
)
GO


-- ----------------------------
-- Uniques structure for table cb_role
-- ----------------------------
ALTER TABLE [dbo].[cb_role] ADD CONSTRAINT [UQ__cb_role__863D2148FCC4191F] UNIQUE NONCLUSTERED ([role] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table cb_role
-- ----------------------------
ALTER TABLE [dbo].[cb_role] ADD CONSTRAINT [PK__cb_role__CD98460A9FE6E28A] PRIMARY KEY CLUSTERED ([roleID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Indexes structure for table cb_securityRule
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_createDate]
ON [dbo].[cb_securityRule] (
  [createdDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_modifiedDate]
ON [dbo].[cb_securityRule] (
  [modifiedDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_deleted]
ON [dbo].[cb_securityRule] (
  [isDeleted] ASC
)
GO


-- ----------------------------
-- Primary Key structure for table cb_securityRule
-- ----------------------------
ALTER TABLE [dbo].[cb_securityRule] ADD CONSTRAINT [PK__cb_secur__121C0641C55C7BD9] PRIMARY KEY CLUSTERED ([ruleID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Indexes structure for table cb_setting
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_createDate]
ON [dbo].[cb_setting] (
  [createdDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_modifiedDate]
ON [dbo].[cb_setting] (
  [modifiedDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_core]
ON [dbo].[cb_setting] (
  [isCore] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_deleted]
ON [dbo].[cb_setting] (
  [isDeleted] ASC
)
GO


-- ----------------------------
-- Primary Key structure for table cb_setting
-- ----------------------------
ALTER TABLE [dbo].[cb_setting] ADD CONSTRAINT [PK__cb_setti__097EE21C0C595154] PRIMARY KEY CLUSTERED ([settingID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Indexes structure for table cb_stats
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_createDate]
ON [dbo].[cb_stats] (
  [createdDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_modifiedDate]
ON [dbo].[cb_stats] (
  [modifiedDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_deleted]
ON [dbo].[cb_stats] (
  [isDeleted] ASC
)
GO


-- ----------------------------
-- Uniques structure for table cb_stats
-- ----------------------------
ALTER TABLE [dbo].[cb_stats] ADD CONSTRAINT [UQ__cb_stats__39B41B2811E40FB3] UNIQUE NONCLUSTERED ([FK_contentID] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table cb_stats
-- ----------------------------
ALTER TABLE [dbo].[cb_stats] ADD CONSTRAINT [PK__cb_stats__516391FC1A8825DA] PRIMARY KEY CLUSTERED ([statsID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Indexes structure for table cb_subscribers
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_createDate]
ON [dbo].[cb_subscribers] (
  [createdDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_modifiedDate]
ON [dbo].[cb_subscribers] (
  [modifiedDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_subscriberEmail]
ON [dbo].[cb_subscribers] (
  [subscriberEmail] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_deleted]
ON [dbo].[cb_subscribers] (
  [isDeleted] ASC
)
GO


-- ----------------------------
-- Primary Key structure for table cb_subscribers
-- ----------------------------
ALTER TABLE [dbo].[cb_subscribers] ADD CONSTRAINT [PK__cb_subsc__B167CE46BE817CE8] PRIMARY KEY CLUSTERED ([subscriberID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Indexes structure for table cb_subscriptions
-- ----------------------------
CREATE NONCLUSTERED INDEX [idx_createDate]
ON [dbo].[cb_subscriptions] (
  [createdDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_modifiedDate]
ON [dbo].[cb_subscriptions] (
  [modifiedDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_deleted]
ON [dbo].[cb_subscriptions] (
  [isDeleted] ASC
)
GO

CREATE NONCLUSTERED INDEX [idx_subscriber]
ON [dbo].[cb_subscriptions] (
  [FK_subscriberID] ASC
)
GO


-- ----------------------------
-- Primary Key structure for table cb_subscriptions
-- ----------------------------
ALTER TABLE [dbo].[cb_subscriptions] ADD CONSTRAINT [PK__cb_subsc__4A0F55C75CAE9DA5] PRIMARY KEY CLUSTERED ([subscriptionID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


-- ----------------------------
-- Foreign Keys structure for table cb_author
-- ----------------------------
ALTER TABLE [dbo].[cb_author] ADD CONSTRAINT [FK6847396B9724FA40] FOREIGN KEY ([FK_roleID]) REFERENCES [cb_role] ([roleID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table cb_authorPermissionGroups
-- ----------------------------
ALTER TABLE [dbo].[cb_authorPermissionGroups] ADD CONSTRAINT [FK7443FC0EAA6AC0EA] FOREIGN KEY ([FK_authorID]) REFERENCES [cb_author] ([authorID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[cb_authorPermissionGroups] ADD CONSTRAINT [FK7443FC0EF4497DC2] FOREIGN KEY ([FK_permissionGroupID]) REFERENCES [cb_permissionGroup] ([permissionGroupID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table cb_authorPermissions
-- ----------------------------
ALTER TABLE [dbo].[cb_authorPermissions] ADD CONSTRAINT [FKE167E219AA6AC0EA] FOREIGN KEY ([FK_authorID]) REFERENCES [cb_author] ([authorID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[cb_authorPermissions] ADD CONSTRAINT [FKE167E21937C1A3F2] FOREIGN KEY ([FK_permissionID]) REFERENCES [cb_permission] ([permissionID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table cb_comment
-- ----------------------------
ALTER TABLE [dbo].[cb_comment] ADD CONSTRAINT [FKFFCED27F91F58374] FOREIGN KEY ([FK_contentID]) REFERENCES [cb_content] ([contentID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table cb_commentSubscriptions
-- ----------------------------
ALTER TABLE [dbo].[cb_commentSubscriptions] ADD CONSTRAINT [FK41716EB791F58374] FOREIGN KEY ([FK_contentID]) REFERENCES [cb_content] ([contentID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[cb_commentSubscriptions] ADD CONSTRAINT [FK41716EB71D33B614] FOREIGN KEY ([subscriptionID]) REFERENCES [cb_subscriptions] ([subscriptionID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table cb_content
-- ----------------------------
ALTER TABLE [dbo].[cb_content] ADD CONSTRAINT [FKFFE01899AA6AC0EA] FOREIGN KEY ([FK_authorID]) REFERENCES [cb_author] ([authorID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[cb_content] ADD CONSTRAINT [FKFFE018996FDC2C99] FOREIGN KEY ([FK_parentID]) REFERENCES [cb_content] ([contentID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table cb_contentCategories
-- ----------------------------
ALTER TABLE [dbo].[cb_contentCategories] ADD CONSTRAINT [FKD96A0F9591F58374] FOREIGN KEY ([FK_contentID]) REFERENCES [cb_content] ([contentID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[cb_contentCategories] ADD CONSTRAINT [FKD96A0F95F10ECD0] FOREIGN KEY ([FK_categoryID]) REFERENCES [cb_category] ([categoryID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table cb_contentStore
-- ----------------------------
ALTER TABLE [dbo].[cb_contentStore] ADD CONSTRAINT [FKEA4C67C8C960893B] FOREIGN KEY ([contentID]) REFERENCES [cb_content] ([contentID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table cb_contentVersion
-- ----------------------------
ALTER TABLE [dbo].[cb_contentVersion] ADD CONSTRAINT [FKE166DFFAA6AC0EA] FOREIGN KEY ([FK_authorID]) REFERENCES [cb_author] ([authorID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[cb_contentVersion] ADD CONSTRAINT [FKE166DFF91F58374] FOREIGN KEY ([FK_contentID]) REFERENCES [cb_content] ([contentID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table cb_customfield
-- ----------------------------
ALTER TABLE [dbo].[cb_customfield] ADD CONSTRAINT [FK1844684991F58374] FOREIGN KEY ([FK_contentID]) REFERENCES [cb_content] ([contentID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table cb_entry
-- ----------------------------
ALTER TABLE [dbo].[cb_entry] ADD CONSTRAINT [FK141674927FFF6A7] FOREIGN KEY ([contentID]) REFERENCES [cb_content] ([contentID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table cb_groupPermissions
-- ----------------------------
ALTER TABLE [dbo].[cb_groupPermissions] ADD CONSTRAINT [FK72ECB065F4497DC2] FOREIGN KEY ([FK_permissionGroupID]) REFERENCES [cb_permissionGroup] ([permissionGroupID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[cb_groupPermissions] ADD CONSTRAINT [FK72ECB06537C1A3F2] FOREIGN KEY ([FK_permissionID]) REFERENCES [cb_permission] ([permissionID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table cb_menuItem
-- ----------------------------
ALTER TABLE [dbo].[cb_menuItem] ADD CONSTRAINT [FKF9F1DCF28E0E8DD2] FOREIGN KEY ([FK_menuID]) REFERENCES [cb_menu] ([menuID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[cb_menuItem] ADD CONSTRAINT [FKF9F1DCF2D3B42410] FOREIGN KEY ([FK_parentID]) REFERENCES [cb_menuItem] ([menuItemID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table cb_page
-- ----------------------------
ALTER TABLE [dbo].[cb_page] ADD CONSTRAINT [FK21B2F26F9636A2E2] FOREIGN KEY ([contentID]) REFERENCES [cb_content] ([contentID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table cb_relatedContent
-- ----------------------------
ALTER TABLE [dbo].[cb_relatedContent] ADD CONSTRAINT [FK9C2F71AE91F58374] FOREIGN KEY ([FK_contentID]) REFERENCES [cb_content] ([contentID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[cb_relatedContent] ADD CONSTRAINT [FK9C2F71AEDF61AADD] FOREIGN KEY ([FK_relatedContentID]) REFERENCES [cb_content] ([contentID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table cb_rolePermissions
-- ----------------------------
ALTER TABLE [dbo].[cb_rolePermissions] ADD CONSTRAINT [FKDCCC1A4E9724FA40] FOREIGN KEY ([FK_roleID]) REFERENCES [cb_role] ([roleID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[cb_rolePermissions] ADD CONSTRAINT [FKDCCC1A4E37C1A3F2] FOREIGN KEY ([FK_permissionID]) REFERENCES [cb_permission] ([permissionID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table cb_stats
-- ----------------------------
ALTER TABLE [dbo].[cb_stats] ADD CONSTRAINT [FK14DE30BF91F58374] FOREIGN KEY ([FK_contentID]) REFERENCES [cb_content] ([contentID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table cb_subscriptions
-- ----------------------------
ALTER TABLE [dbo].[cb_subscriptions] ADD CONSTRAINT [FKE92A1716F2A66EE4] FOREIGN KEY ([FK_subscriberID]) REFERENCES [cb_subscribers] ([subscriberID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO
