DROP DATABASE contentbox;
CREATE DATABASE contentbox;

CREATE TABLE cb_author (
	firstName nvarchar(100) NOT NULL,
	lastName nvarchar(100) NOT NULL,
	email nvarchar(255) NOT NULL,
	username nvarchar(100) NOT NULL,
	password nvarchar(100) NOT NULL,
	isActive binary(1) DEFAULT (0x01) NOT NULL,
	lastLogin datetime2 DEFAULT (NULL),
	createdDate datetime2 NOT NULL,
	biography nvarchar(max),
	preferences nvarchar(max),
	modifiedDate datetime2 NOT NULL,
	isDeleted binary(1) DEFAULT (0x00) NOT NULL,
	isPasswordReset binary(1) DEFAULT (0x00) NOT NULL,
	is2FactorAuth binary(1) DEFAULT (0x00) NOT NULL,
	authorID nchar(36) NOT NULL,
	FK_roleID nchar(36) DEFAULT (NULL),
	PRIMARY KEY (authorID)
)
GO
CREATE TABLE cb_authorpermissiongroups (
	FK_permissionGroupID nchar(36) DEFAULT (NULL),
	FK_authorID nchar(36) DEFAULT (NULL)
)
GO
CREATE TABLE cb_authorpermissions (
	FK_permissionID nchar(36) DEFAULT (NULL),
	FK_authorID nchar(36) DEFAULT (NULL)
)
GO
CREATE TABLE cb_category (
	category nvarchar(200) NOT NULL,
	slug nvarchar(200) NOT NULL,
	createdDate datetime2 NOT NULL,
	modifiedDate datetime2 NOT NULL,
	isDeleted binary(1) DEFAULT (0x00) NOT NULL,
	categoryID nchar(36) NOT NULL,
	FK_siteID nvarchar(36) DEFAULT (N'') NOT NULL,
	PRIMARY KEY (categoryID)
)
GO
CREATE TABLE cb_comment (
	content nvarchar(max) NOT NULL,
	author nvarchar(100) NOT NULL,
	authorIP nvarchar(100) NOT NULL,
	authorEmail nvarchar(255) NOT NULL,
	authorURL nvarchar(255) DEFAULT (NULL),
	createdDate datetime2 NOT NULL,
	isApproved binary(1) DEFAULT (0x00) NOT NULL,
	modifiedDate datetime2 NOT NULL,
	isDeleted binary(1) DEFAULT (0x00) NOT NULL,
	commentID nchar(36) NOT NULL,
	FK_contentID nchar(36) DEFAULT (NULL),
	PRIMARY KEY (commentID)
)
GO
CREATE TABLE cb_commentsubscriptions (
	subscriptionID nchar(36) NOT NULL,
	FK_contentID nchar(36) DEFAULT (NULL),
	PRIMARY KEY (subscriptionID)
)
GO
CREATE TABLE cb_content (
	contentType nvarchar(255) NOT NULL,
	title nvarchar(200) NOT NULL,
	slug nvarchar(200) NOT NULL,
	createdDate datetime2 NOT NULL,
	publishedDate datetime2 DEFAULT (NULL),
	expireDate datetime2 DEFAULT (NULL),
	isPublished binary(1) DEFAULT (0x01) NOT NULL,
	allowComments binary(1) DEFAULT (0x01) NOT NULL,
	passwordProtection nvarchar(100) DEFAULT (NULL),
	HTMLKeywords nvarchar(160) DEFAULT (NULL),
	HTMLDescription nvarchar(160) DEFAULT (NULL),
	cache binary(1) DEFAULT (0x01) NOT NULL,
	cacheLayout binary(1) DEFAULT (0x01) NOT NULL,
	cacheTimeout int DEFAULT ((0)),
	cacheLastAccessTimeout int DEFAULT ((0)),
	markup nvarchar(100) DEFAULT (N'HTML') NOT NULL,
	showInSearch binary(1) DEFAULT (0x01) NOT NULL,
	featuredImage nvarchar(255) DEFAULT (NULL),
	featuredImageURL nvarchar(255) DEFAULT (NULL),
	modifiedDate datetime2 NOT NULL,
	isDeleted binary(1) DEFAULT (0x00) NOT NULL,
	HTMLTitle nvarchar(255) DEFAULT (NULL),
	contentID nchar(36) NOT NULL,
	FK_authorID nchar(36) DEFAULT (NULL),
	FK_parentID nchar(36) DEFAULT (NULL),
	FK_siteID nvarchar(36) DEFAULT (NULL),
	PRIMARY KEY (contentID)
)
GO
CREATE TABLE cb_contentcategories (
	FK_contentID nchar(36) DEFAULT (NULL),
	FK_categoryID nchar(36) DEFAULT (NULL)
)
GO
CREATE TABLE cb_contentstore (
	description nvarchar(max),
	"order" int DEFAULT ((0)),
	contentID nchar(36) NOT NULL,
	PRIMARY KEY (contentID)
)
GO
CREATE TABLE cb_contentversion (
	content nvarchar(max) NOT NULL,
	changelog nvarchar(max),
	version int NOT NULL,
	createdDate datetime2 NOT NULL,
	isActive binary(1) DEFAULT (0x01) NOT NULL,
	modifiedDate datetime2 NOT NULL,
	isDeleted binary(1) DEFAULT (0x00) NOT NULL,
	contentVersionID nchar(36) NOT NULL,
	FK_authorID nchar(36) DEFAULT (NULL),
	FK_contentID nchar(36) DEFAULT (NULL),
	PRIMARY KEY (contentVersionID)
)
GO
CREATE TABLE cb_customfield (
	"key" nvarchar(255) NOT NULL,
	value nvarchar(max) NOT NULL,
	createdDate datetime2 NOT NULL,
	modifiedDate datetime2 NOT NULL,
	isDeleted binary(1) DEFAULT (0x00) NOT NULL,
	customFieldID nchar(36) NOT NULL,
	FK_contentID nchar(36) DEFAULT (NULL),
	PRIMARY KEY (customFieldID)
)
GO
CREATE TABLE cb_entry (
	excerpt nvarchar(max),
	contentID nchar(36) NOT NULL,
	PRIMARY KEY (contentID)
)
GO
CREATE TABLE cb_grouppermissions (
	FK_permissionGroupID nchar(36) DEFAULT (NULL),
	FK_permissionID nchar(36) DEFAULT (NULL)
)
GO
CREATE TABLE cb_jwt (
	id nvarchar(36) NOT NULL,
	cacheKey nvarchar(255) NOT NULL,
	expiration datetime2 NOT NULL,
	issued datetime2 NOT NULL,
	token nvarchar(max) NOT NULL,
	subject nvarchar(255) NOT NULL,
	PRIMARY KEY (id)
)
GO
CREATE TABLE cb_loginattempts (
	value nvarchar(255) NOT NULL,
	attempts int NOT NULL,
	createdDate datetime2 NOT NULL,
	lastLoginSuccessIP nvarchar(100) DEFAULT (N''),
	modifiedDate datetime2 NOT NULL,
	isDeleted binary(1) DEFAULT (0x00) NOT NULL,
	loginAttemptsID nchar(36) NOT NULL,
	PRIMARY KEY (loginAttemptsID)
)
GO
CREATE TABLE cb_menu (
	title nvarchar(200) NOT NULL,
	slug nvarchar(200) NOT NULL,
	listType nvarchar(20) DEFAULT (NULL),
	createdDate datetime2 NOT NULL,
	menuClass nvarchar(160) DEFAULT (NULL),
	listClass nvarchar(160) DEFAULT (NULL),
	modifiedDate datetime2 NOT NULL,
	isDeleted binary(1) DEFAULT (0x00) NOT NULL,
	menuID nchar(36) NOT NULL,
	FK_siteID nvarchar(36) DEFAULT (NULL),
	PRIMARY KEY (menuID)
)
GO
CREATE TABLE cb_menuitem (
	menuType nvarchar(255) NOT NULL,
	title nvarchar(200) NOT NULL,
	label nvarchar(200) DEFAULT (NULL),
	data nvarchar(255) DEFAULT (NULL),
	active binary(1) DEFAULT (0x01) NOT NULL,
	mediaPath nvarchar(255) DEFAULT (NULL),
	contentSlug nvarchar(255) DEFAULT (NULL),
	menuSlug nvarchar(255) DEFAULT (NULL),
	url nvarchar(255) DEFAULT (NULL),
	js nvarchar(255) DEFAULT (NULL),
	itemClass nvarchar(200) DEFAULT (NULL),
	target nvarchar(255) DEFAULT (NULL),
	urlClass nvarchar(255) DEFAULT (NULL),
	createdDate datetime2 NOT NULL,
	modifiedDate datetime2 NOT NULL,
	isDeleted binary(1) DEFAULT (0x00) NOT NULL,
	menuItemID nchar(36) NOT NULL,
	FK_menuID nchar(36) DEFAULT (NULL),
	FK_parentID nchar(36) DEFAULT (NULL),
	PRIMARY KEY (menuItemID)
)
GO
CREATE TABLE cb_module (
	name nvarchar(255) NOT NULL,
	title nvarchar(255) DEFAULT (NULL),
	version nvarchar(255) DEFAULT (NULL),
	entryPoint nvarchar(255) DEFAULT (NULL),
	author nvarchar(255) DEFAULT (NULL),
	webURL nvarchar(max),
	forgeBoxSlug nvarchar(255) DEFAULT (NULL),
	description nvarchar(max),
	isActive binary(1) DEFAULT (0x00) NOT NULL,
	createdDate datetime2 NOT NULL,
	modifiedDate datetime2 NOT NULL,
	isDeleted binary(1) DEFAULT (0x00) NOT NULL,
	moduleType nvarchar(255) DEFAULT (N'core'),
	moduleID nchar(36) NOT NULL,
	PRIMARY KEY (moduleID)
)
GO
CREATE TABLE cb_page (
	layout nvarchar(200) DEFAULT (NULL),
	"order" int DEFAULT ((0)),
	showInMenu binary(1) DEFAULT (0x01) NOT NULL,
	excerpt nvarchar(max),
	SSLOnly binary(1) DEFAULT (0x00) NOT NULL,
	contentID nchar(36) NOT NULL,
	PRIMARY KEY (contentID)
)
GO
CREATE TABLE cb_permission (
	permission nvarchar(255) NOT NULL,
	description nvarchar(max),
	createdDate datetime2 NOT NULL,
	modifiedDate datetime2 NOT NULL,
	isDeleted binary(1) DEFAULT (0x00) NOT NULL,
	permissionID nchar(36) NOT NULL,
	PRIMARY KEY (permissionID)
)
GO
CREATE TABLE cb_permissiongroup (
	createdDate datetime2 NOT NULL,
	modifiedDate datetime2 NOT NULL,
	isDeleted binary(1) DEFAULT (0x00) NOT NULL,
	name nvarchar(255) NOT NULL,
	description nvarchar(max),
	permissionGroupID nchar(36) NOT NULL,
	PRIMARY KEY (permissionGroupID)
)
GO
CREATE TABLE cb_relatedcontent (
	FK_contentID nchar(36) DEFAULT (NULL),
	FK_relatedContentID nchar(36) DEFAULT (NULL)
)
GO
CREATE TABLE cb_role (
	role nvarchar(255) NOT NULL,
	description nvarchar(max),
	createdDate datetime2 NOT NULL,
	modifiedDate datetime2 NOT NULL,
	isDeleted binary(1) DEFAULT (0x00) NOT NULL,
	roleID nchar(36) NOT NULL,
	PRIMARY KEY (roleID)
)
GO
CREATE TABLE cb_rolepermissions (
	FK_permissionID nchar(36) DEFAULT (NULL),
	FK_roleID nchar(36) DEFAULT (NULL)
)
GO
CREATE TABLE cb_securityrule (
	whitelist nvarchar(255) DEFAULT (NULL),
	securelist nvarchar(255) NOT NULL,
	roles nvarchar(255) DEFAULT (NULL),
	permissions nvarchar(max),
	redirect nvarchar(max) NOT NULL,
	useSSL binary(1) DEFAULT (0x00) NOT NULL,
	"order" int DEFAULT ((0)) NOT NULL,
	"match" nvarchar(50) DEFAULT (NULL),
	createdDate datetime2 NOT NULL,
	modifiedDate datetime2 NOT NULL,
	isDeleted binary(1) DEFAULT (0x00) NOT NULL,
	message nvarchar(255) DEFAULT (NULL),
	messageType nvarchar(50) DEFAULT (N'info'),
	overrideEvent nvarchar(max) NOT NULL,
	action nvarchar(50) DEFAULT (N'redirect'),
	module nvarchar(max),
	ruleID nchar(36) NOT NULL,
	PRIMARY KEY (ruleID)
)
GO
CREATE TABLE cb_setting (
	name nvarchar(100) NOT NULL,
	value nvarchar(max) NOT NULL,
	isCore binary(1) DEFAULT (0x00) NOT NULL,
	createdDate datetime2 NOT NULL,
	modifiedDate datetime2 NOT NULL,
	isDeleted binary(1) DEFAULT (0x00) NOT NULL,
	settingID nchar(36) NOT NULL,
	FK_siteID nvarchar(36) DEFAULT (NULL),
	PRIMARY KEY (settingID)
)
GO
CREATE TABLE cb_site (
	siteID nvarchar(36) DEFAULT (N'') NOT NULL,
	createdDate datetime2 NOT NULL,
	modifiedDate datetime2 NOT NULL,
	isDeleted binary(1) DEFAULT (0x00) NOT NULL,
	name nvarchar(255) NOT NULL,
	slug nvarchar(255) NOT NULL,
	description nvarchar(max),
	domainRegex nvarchar(255) DEFAULT (NULL),
	keywords nvarchar(255) DEFAULT (NULL),
	tagline nvarchar(255) DEFAULT (NULL),
	homepage nvarchar(255) DEFAULT (NULL),
	isBlogEnabled binary(1) DEFAULT (0x01) NOT NULL,
	isSitemapEnabled binary(1) DEFAULT (0x01) NOT NULL,
	poweredByHeader binary(1) DEFAULT (0x01) NOT NULL,
	adminBar binary(1) DEFAULT (0x01) NOT NULL,
	isSSL binary(1) DEFAULT (0x00) NOT NULL,
	activeTheme nvarchar(255) DEFAULT (NULL),
	notificationEmails nvarchar(max),
	notifyOnEntries binary(1) DEFAULT (0x01) NOT NULL,
	notifyOnPages binary(1) DEFAULT (0x01) NOT NULL,
	notifyOnContentStore binary(1) DEFAULT (0x01) NOT NULL,
	domain nvarchar(255) DEFAULT (NULL),
	isActive binary(1) DEFAULT (0x01) NOT NULL,
	PRIMARY KEY (siteID)
)
GO
CREATE TABLE cb_stats (
	hits bigint DEFAULT (NULL),
	createdDate datetime2 NOT NULL,
	modifiedDate datetime2 NOT NULL,
	isDeleted binary(1) DEFAULT (0x00) NOT NULL,
	statsID nchar(36) NOT NULL,
	FK_contentID nchar(36) DEFAULT (NULL),
	PRIMARY KEY (statsID)
)
GO
CREATE TABLE cb_subscribers (
	subscriberEmail nvarchar(255) NOT NULL,
	subscriberToken nvarchar(255) NOT NULL,
	createdDate datetime2 NOT NULL,
	modifiedDate datetime2 NOT NULL,
	isDeleted binary(1) DEFAULT (0x00) NOT NULL,
	subscriberID nchar(36) NOT NULL,
	PRIMARY KEY (subscriberID)
)
GO
CREATE TABLE cb_subscriptions (
	subscriptionToken nvarchar(255) NOT NULL,
	type nvarchar(255) NOT NULL,
	createdDate datetime2 NOT NULL,
	modifiedDate datetime2 NOT NULL,
	isDeleted binary(1) DEFAULT (0x00) NOT NULL,
	subscriptionID nchar(36) NOT NULL,
	FK_subscriberID nchar(36) DEFAULT (NULL),
	PRIMARY KEY (subscriptionID)
)
GO
CREATE TABLE cfmigrations (
	name nvarchar(190) NOT NULL,
	migration_ran datetime2 NOT NULL,
	PRIMARY KEY (name)
)
GO
INSERT INTO cb_author(firstName, lastName, email, username, password, isActive, lastLogin, createdDate, biography, preferences, modifiedDate, isDeleted, isPasswordReset, is2FactorAuth, authorID, FK_roleID) VALUES (N'Luis', N'Majano', N'lmajano@gmail.com', N'lmajano', N'$2a$12$KU4n4ZQf3cd/ULCuvc8PIO9VrQKi7eKbcEuQaILTJ/sdcjXvT31YK', 0x01, '2021-02-18 17:54:10', '2013-07-11 11:06:39', N'', N'{"sidemenuCollapse":"yes","linkedin":"","sidebarState":"yes","markup":"HTML","website":"","editor":"ckeditor","twitter":"http://twitter.com/lmajano","facebook":"http://facebook.com/lmajano"}', '2021-02-18 17:54:10', 0x00, 0x00, 0x00, N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_author(firstName, lastName, email, username, password, isActive, lastLogin, createdDate, biography, preferences, modifiedDate, isDeleted, isPasswordReset, is2FactorAuth, authorID, FK_roleID) VALUES (N'Lui', N'Majano', N'lmajano@ortussolutions.com', N'luismajano', N'$2a$12$KU4n4ZQf3cd/ULCuvc8PIO9VrQKi7eKbcEuQaILTJ/sdcjXvT31YK', 0x01, '2015-07-29 14:38:46', '2013-07-11 11:07:23', N'', N'{"GOOGLE":"","EDITOR":"ckeditor","TWITTER":"http:\/\/twitter.com\/lmajano","FACEBOOK":"http:\/\/facebook.com\/lmajano"}', '2017-06-21 18:29:30', 0x00, 0x00, 0x00, N'77abdf9a-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_author(firstName, lastName, email, username, password, isActive, lastLogin, createdDate, biography, preferences, modifiedDate, isDeleted, isPasswordReset, is2FactorAuth, authorID, FK_roleID) VALUES (N'Tester', N'Majano', N'lmajano@testing.com', N'testermajano', N'$2a$12$FE058d9bj7Sv6tPmvZMaleC2x8.b.tRqVei5p/5XqPytSNpF5eCym', 0x01, '2017-07-06 12:13:14', '2013-07-11 11:07:23', N'', N'{"sidemenuCollapse":"no","google":"","sidebarState":"true","markup":"HTML","editor":"ckeditor","twitter":"http://twitter.com/lmajano","facebook":"http://facebook.com/lmajano"}', '2017-07-18 15:22:13', 0x00, 0x01, 0x01, N'77abe0a8-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_author(firstName, lastName, email, username, password, isActive, lastLogin, createdDate, biography, preferences, modifiedDate, isDeleted, isPasswordReset, is2FactorAuth, authorID, FK_roleID) VALUES (N'Joe', N'Joe', N'joejoe@joe.com', N'joejoe', N'$2a$12$.FrcqDLb3DNIK2TqJo0aQuwB3WSxAW0KmJUKKPaAQV7VoYwihDM1.', 0x01, '2017-07-06 11:38:28', '2017-07-06 11:30:59', N'', N'{"linkedin":"","markup":"HTML","website":"","editor":"ckeditor","twitter":"","facebook":""}', '2017-07-06 11:54:11', 0x00, 0x01, 0x01, N'77abe166-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_author(firstName, lastName, email, username, password, isActive, lastLogin, createdDate, biography, preferences, modifiedDate, isDeleted, isPasswordReset, is2FactorAuth, authorID, FK_roleID) VALUES (N'Jorge', N'Morelos', N'joremorelos@morelos.com', N'joremorelos@morelos.com', N'$2a$12$IBAYihdRG.Hj8fh/fztmi.MvFRn2lPxk4Thw1mnmbVzjoLnNCgzOe', 0x00, null, '2017-07-06 12:07:02', N'', N'{"linkedin":"","markup":"HTML","website":"","editor":"ckeditor","twitter":"","facebook":""}', '2017-07-19 17:01:18', 0x00, 0x01, 0x00, N'77abe206-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_authorpermissiongroups(FK_permissionGroupID, FK_authorID) VALUES (N'7850efee-a444-11eb-ab6f-0290cc502ae3', N'77abe166-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_authorpermissiongroups(FK_permissionGroupID, FK_authorID) VALUES (N'7850efee-a444-11eb-ab6f-0290cc502ae3', N'77abe206-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_authorpermissiongroups(FK_permissionGroupID, FK_authorID) VALUES (N'7850f138-a444-11eb-ab6f-0290cc502ae3', N'77abe206-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_authorpermissions(FK_permissionID, FK_authorID) VALUES (N'785d8182-a444-11eb-ab6f-0290cc502ae3', N'77abe0a8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_authorpermissions(FK_permissionID, FK_authorID) VALUES (N'785d8574-a444-11eb-ab6f-0290cc502ae3', N'77abe0a8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_authorpermissions(FK_permissionID, FK_authorID) VALUES (N'785d8420-a444-11eb-ab6f-0290cc502ae3', N'77abe0a8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_authorpermissions(FK_permissionID, FK_authorID) VALUES (N'785d83b2-a444-11eb-ab6f-0290cc502ae3', N'77abe0a8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_authorpermissions(FK_permissionID, FK_authorID) VALUES (N'785d8344-a444-11eb-ab6f-0290cc502ae3', N'77abe0a8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_authorpermissions(FK_permissionID, FK_authorID) VALUES (N'785d84fc-a444-11eb-ab6f-0290cc502ae3', N'77abe0a8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_category(category, slug, createdDate, modifiedDate, isDeleted, categoryID, FK_siteID) VALUES (N'ColdFusion', N'coldfusion', '2016-05-03 16:23:25', '2016-05-03 16:23:25', 0x00, N'786a9660-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_category(category, slug, createdDate, modifiedDate, isDeleted, categoryID, FK_siteID) VALUES (N'ContentBox', N'contentbox', '2016-05-03 16:23:25', '2016-05-03 16:23:25', 0x00, N'786a97f0-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_category(category, slug, createdDate, modifiedDate, isDeleted, categoryID, FK_siteID) VALUES (N'coldbox', N'coldbox', '2016-05-03 16:23:25', '2016-05-03 16:23:25', 0x00, N'786a98cc-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_comment(content, author, authorIP, authorEmail, authorURL, createdDate, isApproved, modifiedDate, isDeleted, commentID, FK_contentID) VALUES (N'Test', N'Luis', N'', N'lmajano@gmail.com', N'', '2015-08-04 16:17:43', 0x00, '2021-02-18 17:58:20', 0x00, N'77d99fac-a444-11eb-ab6f-0290cc502ae3', N'779cd234-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_comment(content, author, authorIP, authorEmail, authorURL, createdDate, isApproved, modifiedDate, isDeleted, commentID, FK_contentID) VALUES (N'test', N'Luis Majano', N'127.0.0.1', N'lmajano@gmail.com', N'', '2016-05-11 16:12:33', 0x01, '2016-05-11 16:12:33', 0x00, N'77d9a15a-a444-11eb-ab6f-0290cc502ae3', N'779cd18a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_comment(content, author, authorIP, authorEmail, authorURL, createdDate, isApproved, modifiedDate, isDeleted, commentID, FK_contentID) VALUES (N'test', N'Luis Majano', N'127.0.0.1', N'lmajano@ortussolutions.com', N'', '2016-05-12 12:34:17', 0x01, '2016-05-12 12:34:17', 0x00, N'77d9a240-a444-11eb-ab6f-0290cc502ae3', N'779cd18a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_comment(content, author, authorIP, authorEmail, authorURL, createdDate, isApproved, modifiedDate, isDeleted, commentID, FK_contentID) VALUES (N'My awesome comment', N'Luis Majano', N'127.0.0.1', N'lmajano@gmail.com', N'', '2016-11-28 15:35:51', 0x01, '2016-11-28 15:35:51', 0x00, N'77d9a2cc-a444-11eb-ab6f-0290cc502ae3', N'779cd234-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_comment(content, author, authorIP, authorEmail, authorURL, createdDate, isApproved, modifiedDate, isDeleted, commentID, FK_contentID) VALUES (N'Another test comment', N'Luis Majano', N'127.0.0.1', N'lmajano@gmail.com', N'', '2021-05-05 15:15:06', 0x01, '2021-05-05 15:15:06', 0x00, N'ff808081793cf2c801793e2b749b002a', N'779cd234-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_comment(content, author, authorIP, authorEmail, authorURL, createdDate, isApproved, modifiedDate, isDeleted, commentID, FK_contentID) VALUES (N'My comment is meant to test your limits', N'Joe Hacker', N'127.0.0.1', N'joe@hacker.com', N'', '2021-05-05 15:15:29', 0x00, '2021-05-05 15:15:42', 0x00, N'ff808081793cf2c801793e2bcd53002b', N'779cd234-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_commentsubscriptions(subscriptionID, FK_contentID) VALUES (N'77e37aae-a444-11eb-ab6f-0290cc502ae3', N'779cd18a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_commentsubscriptions(subscriptionID, FK_contentID) VALUES (N'77e37b80-a444-11eb-ab6f-0290cc502ae3', N'779cd18a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_commentsubscriptions(subscriptionID, FK_contentID) VALUES (N'77e3796e-a444-11eb-ab6f-0290cc502ae3', N'779cd234-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Entry', N'An awesome blog entry', N'an-awesome-blog-entry', '2013-07-12 09:53:01', '2013-07-20 16:05:46', null, 0x01, 0x01, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, null, null, '2016-05-03 16:23:25', 0x00, null, N'779cc2bc-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Entry', N'Another Test', N'another-test', '2013-07-12 09:53:31', '2013-07-20 16:39:53', null, 0x00, 0x01, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, null, null, '2016-05-03 16:23:25', 0x00, null, N'779cc4e2-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Entry', N'ContentBox Modular CMS at the South Florida CFUG', N'contentbox-modular-cms-at-the-south-florida-cfug', '2012-09-13 15:55:12', '2013-07-20 16:39:39', null, 0x01, 0x01, N'', N'', N'', 0x01, 0x01, 0, 0, N'html', 0x01, null, null, '2016-05-03 16:23:25', 0x00, null, N'779cc5e6-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Entry', N'Test with an excerpt', N'test-with-an-excerpt', '2013-07-15 17:56:10', '2013-07-20 16:39:39', null, 0x01, 0x01, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, null, null, '2016-05-03 16:23:25', 0x00, null, N'779cc6b8-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Entry', N'Updating an ORM entity', N'updating-an-orm-entity', '2013-07-19 18:45:08', '2013-07-20 16:39:39', null, 0x01, 0x01, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, null, null, '2016-05-03 16:23:25', 0x00, null, N'779cc76c-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Entry', N'Copy of Updating an ORM entity', N'copy-of-updating-an-orm-entity', '2013-07-20 16:10:43', '2013-07-20 16:39:39', null, 0x01, 0x01, N'', N'', N'', 0x01, 0x01, 0, 0, N'html', 0x01, null, null, '2016-05-03 16:23:25', 0x00, null, N'779cc820-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Entry', N'Copy of Another Test', N'copy-of-another-test', '2013-07-20 16:12:16', '2013-07-20 16:39:39', null, 0x01, 0x01, N'', N'', N'', 0x01, 0x01, 0, 0, N'html', 0x01, null, null, '2016-05-03 16:23:25', 0x00, null, N'779cc906-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Entry', N'Copy of Copy of Another Test', N'copy-of-copy-of-another-test', '2013-07-20 16:12:23', '2013-07-20 16:12:00', null, 0x00, 0x01, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, null, null, '2016-05-03 16:23:25', 0x00, null, N'779cc9ba-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Entry', N'Couchbase Infrastructure', N'couchbase-infrastructure', '2013-07-26 16:53:43', '2013-07-26 16:53:00', null, 0x01, 0x01, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, null, null, '2016-05-03 16:23:25', 0x00, null, N'779cca64-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Entry', N'Couchbase Details', N'couchbase-details', '2013-07-26 16:55:00', '2013-10-11 10:31:00', null, 0x01, 0x01, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, N'', N'', '2021-02-19 10:54:25', 0x00, N'', N'779ccb0e-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'ContentStore', N'First Content Store', N'first-content-store', '2013-08-12 11:59:12', '2013-08-12 12:02:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, null, null, '2016-05-03 16:23:25', 0x00, null, N'779ccbb8-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'ContentStore', N'My News', N'my-awesome-news', '2013-08-14 18:14:43', '2013-08-14 18:14:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, null, null, '2016-05-03 16:23:25', 0x00, null, N'779ccc62-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'ContentStore', N'blog-sidebar-top', N'blog-sidebar-top', '2013-08-22 20:42:37', '2013-08-22 20:42:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, null, null, '2016-05-03 16:23:25', 0x00, null, N'779ccd02-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'ContentStore', N'footer', N'foot', '2013-08-22 20:43:59', '2013-08-22 20:43:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, null, null, '2021-05-05 15:18:36', 0x00, null, N'779ccdac-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'ContentStore', N'support options', N'support-options-baby', '2013-08-22 20:45:19', '2013-08-22 20:45:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, null, null, '2016-05-03 16:23:25', 0x00, null, N'779cce56-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'ContentStore', N'FireFox Test', N'firefox-test', '2013-08-29 08:29:36', '2013-08-29 08:29:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, null, null, '2016-05-03 16:23:25', 0x00, null, N'779ccef6-a444-11eb-ab6f-0290cc502ae3', N'77abe0a8-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Entry', N'Couchbase Conference', N'couchbase-conference', '2013-09-13 16:54:52', '2013-09-13 16:54:00', null, 0x01, 0x01, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, null, null, '2016-05-03 16:23:25', 0x00, null, N'779ccfa0-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Entry', N'Disk Queues', N'disk-queues', '2013-09-13 16:55:05', '2013-09-13 16:54:00', null, 0x01, 0x01, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, null, null, '2016-05-03 16:23:25', 0x00, null, N'779cd040-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Entry', N'This is just awesome', N'this-is-just-awesome', '2013-10-15 16:48:56', '2013-10-15 16:48:00', null, 0x01, 0x01, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, null, null, '2016-05-03 16:23:25', 0x00, null, N'779cd0ea-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Entry', N'Closures cannot be declared outside of cfscript', N'closures-cannot-be-declared-outside-of-cfscript', '2013-11-11 11:53:03', '2013-11-11 11:52:00', null, 0x01, 0x01, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, null, null, '2016-05-03 16:23:25', 0x00, null, N'779cd18a-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Entry', N'Disk Queues', N'disk-queues-77caf', '2014-01-31 14:41:16', '2014-01-31 14:41:00', null, 0x01, 0x01, N'', N'these are nice keywords', N'Disk Queues are amazing and they rock SEO', 0x01, 0x01, 0, 0, N'HTML', 0x01, N'', N'', '2021-05-05 15:17:18', 0x00, N'Disk Queues are amazing', N'779cd234-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'support', N'support', '2013-07-20 15:38:47', '2013-07-20 15:38:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'html', 0x01, N'', N'', '2016-08-05 14:42:30', 0x00, null, N'779cd2de-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'ContentStore', N'Small Footer', N'foot/small-footer', '2014-09-26 16:00:44', '2014-09-26 16:00:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, null, null, '2016-05-03 16:23:25', 0x00, null, N'779cd388-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccdac-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'No Layout Test', N'no-layout-test', '2015-03-29 10:13:59', '2015-03-29 10:13:00', null, 0x01, 0x00, N'test', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, N'', N'', '2016-08-05 14:42:30', 0x00, null, N'779cd432-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'No Sidebar', N'email-test', '2015-09-16 10:33:56', '2015-09-16 10:33:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, null, null, '2016-08-05 14:42:30', 0x00, null, N'779cd4dc-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'ContentStore', N'Lucee 4.5.2.018', N'lucee-452018', '2016-01-14 11:44:58', '2016-01-14 11:42:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, N'', N'', '2016-05-03 16:23:25', 0x00, null, N'779cd57c-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'ContentStore', N'Another test', N'another-test-a161b', '2016-01-14 11:45:35', '2016-01-14 11:45:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, N'', N'', '2016-05-05 15:56:12', 0x00, null, N'779cd61c-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'parent page', N'parent-page', '2016-04-12 09:26:56', '2016-04-12 09:26:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, N'', N'', '2016-05-03 16:23:25', 0x00, null, N'779cd6c6-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'child 1', N'parent-page/child-1', '2016-04-12 09:27:06', '2016-04-12 09:27:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, N'', N'', '2016-05-03 16:23:25', 0x00, null, N'779cd766-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd6c6-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'node', N'node', '2016-04-12 13:18:51', '2016-04-12 13:18:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, N'', N'', '2016-08-05 14:42:30', 0x00, null, N'779cd806-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'child1', N'node/child1', '2016-04-12 13:19:04', '2016-04-12 13:18:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, N'', N'', '2016-05-03 16:23:25', 0x00, null, N'779cd8b0-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd806-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'child2', N'node/child2', '2016-04-12 13:19:10', '2016-04-12 13:19:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, N'', N'', '2016-05-03 16:23:25', 0x00, null, N'779cd950-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd806-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'Test Markdown', N'test-markdown', '2016-05-05 11:12:23', '2016-05-05 11:11:00', '2016-05-01 00:00:00', 0x00, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'Markdown', 0x00, N'', N'', '2016-08-05 14:42:24', 0x00, null, N'779cd9fa-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'products', N'products', '2016-05-18 11:35:32', '2017-06-13 17:08:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, N'', N'', '2017-06-13 17:08:36', 0x00, N'', N'779cdaa4-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'coldbox', N'products/coldbox', '2016-05-18 11:35:32', '2013-07-11 11:23:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, N'', N'', '2016-05-18 11:35:32', 0x00, null, N'779cdb4e-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdaa4-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'mini', N'products/coldbox/mini', '2016-05-18 11:35:32', '2015-09-22 10:53:23', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, N'', N'', '2016-05-18 11:35:32', 0x00, null, N'779cdbee-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdb4e-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'services', N'products/coldbox/services', '2016-05-18 11:35:32', '2015-09-22 10:53:23', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, N'', N'', '2016-05-18 11:35:32', 0x00, null, N'779cdc8e-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdb4e-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'servers', N'products/coldbox/services/servers', '2016-05-18 11:35:32', '2013-07-20 10:40:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, N'', N'', '2016-05-18 11:35:32', 0x00, null, N'779cdd38-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdc8e-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'More Servers', N'products/coldbox/services/more-servers', '2016-05-18 11:35:32', '2013-07-20 10:40:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, N'', N'', '2016-05-18 11:35:32', 0x00, null, N'779cddd8-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdc8e-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'support', N'products/coldbox/services/support', '2016-05-18 11:35:32', '2013-07-20 10:40:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, N'', N'', '2016-05-18 11:35:32', 0x00, null, N'779cde82-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdc8e-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'coldbox-new', N'products/coldbox-new', '2016-05-18 11:35:32', '2016-04-11 11:32:00', null, 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'html', 0x01, N'', N'', '2016-05-18 11:35:32', 0x00, null, N'779cdf22-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdaa4-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'mini', N'products/coldbox-new/mini', '2016-05-18 11:35:32', '2013-08-22 10:23:03', null, 0x00, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'html', 0x01, N'', N'', '2016-05-18 11:35:32', 0x00, null, N'779cdfc2-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdf22-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'services', N'products/coldbox-new/services', '2016-05-18 11:35:32', '2013-08-22 10:23:03', null, 0x00, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'html', 0x01, N'', N'', '2016-05-18 11:35:32', 0x00, null, N'779ce06c-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdf22-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'servers', N'products/coldbox-new/services/servers', '2016-05-18 11:35:32', '2013-08-22 10:23:03', null, 0x00, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'html', 0x01, N'', N'', '2016-05-18 11:35:32', 0x00, null, N'779ce10c-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ce06c-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'More Servers', N'products/coldbox-new/services/more-servers', '2016-05-18 11:35:32', '2013-08-22 10:23:04', null, 0x00, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'html', 0x01, N'', N'', '2016-05-18 11:35:32', 0x00, null, N'779ce1ac-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ce06c-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'Page', N'support', N'products/coldbox-new/services/support', '2016-05-18 11:35:32', '2013-08-22 10:23:04', null, 0x00, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'html', 0x01, N'', N'', '2016-05-18 11:35:32', 0x00, null, N'779ce256-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ce06c-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_content(contentType, title, slug, createdDate, publishedDate, expireDate, isPublished, allowComments, passwordProtection, HTMLKeywords, HTMLDescription, cache, cacheLayout, cacheTimeout, cacheLastAccessTimeout, markup, showInSearch, featuredImage, featuredImageURL, modifiedDate, isDeleted, HTMLTitle, contentID, FK_authorID, FK_parentID, FK_siteID) VALUES (N'ContentStore', N'My Expired Content Store', N'my-expired-content-store', '2018-03-20 09:48:13', '2018-03-20 09:47:00', '2018-02-01 00:00:00', 0x01, 0x00, N'', N'', N'', 0x01, 0x01, 0, 0, N'HTML', 0x01, N'', N'', '2018-03-20 09:48:13', 0x00, N'', N'779ce300-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', null, N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentcategories(FK_contentID, FK_categoryID) VALUES (N'779ccc62-a444-11eb-ab6f-0290cc502ae3', N'786a9660-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentcategories(FK_contentID, FK_categoryID) VALUES (N'779ccc62-a444-11eb-ab6f-0290cc502ae3', N'786a97f0-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentcategories(FK_contentID, FK_categoryID) VALUES (N'779cc4e2-a444-11eb-ab6f-0290cc502ae3', N'786a9660-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentcategories(FK_contentID, FK_categoryID) VALUES (N'779cc4e2-a444-11eb-ab6f-0290cc502ae3', N'786a97f0-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentcategories(FK_contentID, FK_categoryID) VALUES (N'779cc906-a444-11eb-ab6f-0290cc502ae3', N'786a9660-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentcategories(FK_contentID, FK_categoryID) VALUES (N'779cc906-a444-11eb-ab6f-0290cc502ae3', N'786a97f0-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentcategories(FK_contentID, FK_categoryID) VALUES (N'779cc9ba-a444-11eb-ab6f-0290cc502ae3', N'786a9660-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentcategories(FK_contentID, FK_categoryID) VALUES (N'779cc9ba-a444-11eb-ab6f-0290cc502ae3', N'786a97f0-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentcategories(FK_contentID, FK_categoryID) VALUES (N'779cd2de-a444-11eb-ab6f-0290cc502ae3', N'786a98cc-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentcategories(FK_contentID, FK_categoryID) VALUES (N'779cd234-a444-11eb-ab6f-0290cc502ae3', N'786a97f0-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentcategories(FK_contentID, FK_categoryID) VALUES (N'779cd234-a444-11eb-ab6f-0290cc502ae3', N'786a9660-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentcategories(FK_contentID, FK_categoryID) VALUES (N'779ccdac-a444-11eb-ab6f-0290cc502ae3', N'786a98cc-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentstore(description, "order", contentID) VALUES (N'My very first content', 0, N'779ccbb8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentstore(description, "order", contentID) VALUES (N'Most greatest news', 0, N'779ccc62-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentstore(description, "order", contentID) VALUES (N'', 0, N'779ccd02-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentstore(description, "order", contentID) VALUES (N'This is a reusable footer', 0, N'779ccdac-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentstore(description, "order", contentID) VALUES (N'support options', 0, N'779cce56-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentstore(description, "order", contentID) VALUES (N'Test', 0, N'779ccef6-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentstore(description, "order", contentID) VALUES (N'A small footer', 0, N'779cd388-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentstore(description, "order", contentID) VALUES (N'test', 0, N'779cd57c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentstore(description, "order", contentID) VALUES (N'asdf', 0, N'779cd61c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentstore(description, "order", contentID) VALUES (N'', 0, N'779ce300-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Test', 1, '2013-07-12 09:53:01', 0x01, '2016-05-03 16:23:25', 0x00, N'78076356-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc2bc-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2013-07-12 09:53:31', 0x00, '2016-05-03 16:23:25', 0x00, N'780764fa-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc4e2-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 2, '2013-07-12 09:53:40', 0x01, '2016-05-03 16:23:25', 0x00, N'780765c2-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc4e2-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'I am glad to go back to my adoptive home, Miami next week and present at the South Florida CFUG on <a href="http://gocontentbox.org">ContentBox Modular CMS</a> September 20th, 2012.  We will be showcasing our next ContentBox version 1.0.7 and have some great goodies for everybody.  <a href="http://www.gocontentbox.org/blog/south-florida-cfug-presentation">You can read all about the event here</a>.  Hope to see you there!', N'Imported content', 1, '2013-04-07 10:45:28', 0x01, '2016-05-03 16:23:25', 0x00, N'7807666c-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc5e6-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2013-07-15 17:56:10', 0x01, '2016-05-03 16:23:25', 0x00, N'780766ee-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc6b8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'quick save', 1, '2013-07-19 18:45:08', 0x00, '2016-05-03 16:23:25', 0x00, N'78076766-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc76c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'What up daugh!', 2, '2013-07-19 18:45:28', 0x01, '2016-05-03 16:23:25', 0x00, N'78076806-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc76c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Content Cloned!', 1, '2013-07-20 16:10:43', 0x01, '2016-05-03 16:23:25', 0x00, N'7807687e-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc820-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Content Cloned!', 1, '2013-07-20 16:12:16', 0x01, '2016-05-03 16:23:25', 0x00, N'7807691e-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc906-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Content Cloned!', 1, '2013-07-20 16:12:23', 0x00, '2016-05-03 16:23:25', 0x00, N'780769b4-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc9ba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'quick save', 2, '2013-07-26 12:58:21', 0x00, '2016-05-03 16:23:25', 0x00, N'78076a4a-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc9ba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'quick save', 3, '2013-07-26 12:59:43', 0x00, '2016-05-03 16:23:25', 0x00, N'78076ad6-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc9ba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 4, '2013-07-26 13:00:05', 0x00, '2016-05-03 16:23:25', 0x00, N'78076b62-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc9ba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 5, '2013-07-26 13:00:21', 0x00, '2016-05-03 16:23:25', 0x00, N'78076c2a-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc9ba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'quick save', 6, '2013-07-26 13:02:18', 0x00, '2016-05-03 16:23:25', 0x00, N'78076cca-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc9ba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>&nbsp;</p>

<p>&nbsp;</p>', N'quick save', 7, '2013-07-26 13:02:34', 0x00, '2016-05-03 16:23:25', 0x00, N'78076dec-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc9ba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>TESTT</p>

<p>&nbsp;</p>', N'quick save', 8, '2013-07-26 13:02:38', 0x00, '2016-05-03 16:23:25', 0x00, N'78076e82-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc9ba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>', N'quick save', 9, '2013-07-26 13:02:51', 0x00, '2016-05-03 16:23:25', 0x00, N'78076f18-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc9ba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>', N'Editor Change Quick Save', 10, '2013-07-26 13:03:02', 0x00, '2016-05-03 16:23:25', 0x00, N'78076fa4-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc9ba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>', N'quick save', 11, '2013-07-26 13:03:09', 0x00, '2016-05-03 16:23:25', 0x00, N'7807703a-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc9ba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'quick save', 12, '2013-07-26 13:04:31', 0x01, '2016-05-03 16:23:25', 0x00, N'780770bc-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cc9ba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2013-07-26 16:53:43', 0x01, '2016-05-03 16:23:25', 0x00, N'78077152-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cca64-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>{{{ContentStore slug=''contentbox''}}}</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2013-07-26 16:55:00', 0x00, '2016-05-03 16:23:25', 0x00, N'780771ca-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccb0e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'quick save', 1, '2013-08-12 11:59:12', 0x00, '2016-05-03 16:23:25', 0x00, N'78077260-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccbb8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 4, '2013-08-12 12:18:13', 0x00, '2016-05-03 16:23:25', 0x00, N'780772d8-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccbb8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 6, '2013-08-12 12:18:29', 0x00, '2016-05-03 16:23:25', 0x00, N'7807736e-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccbb8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p><widget category="" max="5" searchterm="" title="" titlelevel="2" widgetdisplayname="RecentEntries" widgetname="RecentEntries" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/list.png" style="margin-right:5px;" width="20" />RecentEntries : max = 5 | titleLevel = 2 | widgetUDF = rende</widgetinfobar></widget></p>', N'', 1, '2013-08-14 18:14:43', 0x00, '2016-05-03 16:23:25', 0x00, N'780773dc-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccc62-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p><widget category="" max="5" searchterm="" title="" titlelevel="2" widgetdisplayname="RecentEntries" widgetname="RecentEntries" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/list.png" style="margin-right:5px;" width="20" />RecentEntries : max = 5 | titleLevel = 2 | widgetUDF = rende</widgetinfobar></widget></p>', N'', 2, '2013-08-14 18:15:14', 0x01, '2016-05-03 16:23:25', 0x00, N'7807744a-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccc62-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Reverting to version 4', 7, '2013-08-21 13:43:59', 0x00, '2016-05-03 16:23:25', 0x00, N'780774ea-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccbb8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Reverting to version 5', 8, '2013-08-21 13:44:18', 0x00, '2016-05-03 16:23:25', 0x00, N'78077558-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccbb8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Reverting to version 6', 9, '2013-08-21 13:44:22', 0x00, '2016-05-03 16:23:25', 0x00, N'780775f8-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccbb8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Reverting to version 4', 10, '2013-08-21 18:15:46', 0x00, '2016-05-03 16:23:25', 0x00, N'78077666-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccbb8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Reverting to version 6', 11, '2013-08-21 18:16:55', 0x00, '2016-05-03 16:23:25', 0x00, N'780776f2-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccbb8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Reverting to version 9', 12, '2013-08-21 18:17:41', 0x00, '2016-05-03 16:23:25', 0x00, N'78077760-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccbb8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Reverting to version 8', 13, '2013-08-21 18:18:13', 0x00, '2016-05-03 16:23:25', 0x00, N'780777f6-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccbb8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Reverting to version 9', 14, '2013-08-21 18:18:29', 0x01, '2016-05-03 16:23:25', 0x00, N'78077864-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccbb8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Sidebar Top</p>', N'', 1, '2013-08-22 20:42:37', 0x01, '2016-05-03 16:23:25', 0x00, N'780778fa-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccd02-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2013-08-22 20:43:59', 0x00, '2021-05-05 15:18:17', 0x00, N'78077968-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccdac-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2013-08-22 20:45:19', 0x00, '2016-05-03 16:23:25', 0x00, N'78077a12-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cce56-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'Test

asdf

asdf', N'quick save', 1, '2013-08-29 08:29:36', 0x00, '2016-05-03 16:23:25', 0x00, N'78077a94-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccef6-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'Test

asdf

asdf', N'quick save', 2, '2013-08-29 08:30:10', 0x00, '2016-05-03 16:23:25', 0x00, N'78077af8-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccef6-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'Test

asdf

asdf', N'Editor Change Quick Save', 3, '2013-08-29 08:30:21', 0x00, '2016-05-03 16:23:25', 0x00, N'78077b5c-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccef6-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'lorem ipsum lorem', N'quick save', 4, '2013-08-29 08:31:17', 0x00, '2016-05-03 16:23:25', 0x00, N'78077bca-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccef6-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>{{{ContentStore slug=''contentbox''}}}</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'quick save', 2, '2013-08-29 08:32:16', 0x00, '2021-02-19 10:54:25', 0x00, N'78077c2e-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccb0e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>I am at the conference</p>', N'', 1, '2013-09-13 16:54:52', 0x01, '2016-05-03 16:23:25', 0x00, N'78077cce-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccfa0-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2013-09-13 16:55:05', 0x01, '2016-05-03 16:23:25', 0x00, N'78077d32-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd040-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>An awesome link</p>', N'', 1, '2013-10-15 16:48:56', 0x01, '2016-05-03 16:23:25', 0x00, N'78077daa-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd0ea-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 2, '2013-10-15 16:57:47', 0x00, '2016-05-03 16:23:25', 0x00, N'78077e0e-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cce56-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 3, '2013-10-15 16:57:56', 0x00, '2016-05-03 16:23:25', 0x00, N'78077eb8-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cce56-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 4, '2013-10-15 16:58:18', 0x00, '2016-05-03 16:23:25', 0x00, N'78077f58-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cce56-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 5, '2013-10-15 17:00:33', 0x00, '2016-05-03 16:23:25', 0x00, N'78077fee-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cce56-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 6, '2013-10-15 17:00:52', 0x00, '2016-05-03 16:23:25', 0x00, N'78078084-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cce56-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 7, '2013-10-15 17:03:19', 0x00, '2016-05-03 16:23:25', 0x00, N'7807811a-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cce56-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 8, '2013-10-15 17:03:34', 0x01, '2016-05-03 16:23:25', 0x00, N'780781c4-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cce56-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2013-11-11 11:53:03', 0x00, '2016-05-03 16:23:25', 0x00, N'7807825a-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd18a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 2, '2013-11-11 11:53:49', 0x01, '2016-05-03 16:23:25', 0x00, N'780782c8-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd18a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>This is a test.</p>', N'', 1, '2014-01-31 14:41:16', 0x00, '2021-05-05 15:14:43', 0x00, N'78078336-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd234-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>lorem ipsum lorem</p>', N'quick save', 5, '2014-02-05 14:31:57', 0x00, '2016-05-03 16:23:25', 0x00, N'7807839a-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccef6-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>lorem ipsum lorem</p>', N'', 6, '2014-07-01 16:44:54', 0x01, '2016-05-03 16:23:25', 0x00, N'780783fe-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccef6-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Support services</p>

<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 26, '2014-08-25 12:40:55', 0x00, '2016-05-03 16:23:25', 0x00, N'78078462-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd2de-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Support services</p>

<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 27, '2014-08-25 12:41:44', 0x00, '2016-05-03 16:23:25', 0x00, N'78078502-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd2de-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Support services</p>

<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 28, '2014-08-25 12:46:10', 0x00, '2016-05-03 16:23:25', 0x00, N'780785a2-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd2de-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Support services</p>

<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 29, '2014-08-25 12:46:29', 0x00, '2016-05-03 16:23:25', 0x00, N'78078638-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd2de-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Support services</p>

<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 30, '2014-08-25 12:46:59', 0x00, '2016-05-03 16:23:25', 0x00, N'780786ce-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd2de-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Support services</p>

<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 31, '2014-08-25 13:22:47', 0x00, '2016-05-03 16:23:25', 0x00, N'78078764-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd2de-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Support services</p>

<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 32, '2014-08-25 13:23:14', 0x00, '2016-05-03 16:23:25', 0x00, N'780787f0-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd2de-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Support services</p>

<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 33, '2014-08-25 13:23:55', 0x00, '2016-05-03 16:23:25', 0x00, N'78078886-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd2de-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2014-09-26 16:00:44', 0x00, '2016-05-03 16:23:25', 0x00, N'7807891c-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd388-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 2, '2014-09-26 16:25:23', 0x00, '2016-05-03 16:23:25', 0x00, N'7807898a-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd388-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 3, '2014-09-26 16:25:31', 0x00, '2016-05-03 16:23:25', 0x00, N'78078a20-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd388-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 4, '2014-09-26 16:25:53', 0x01, '2016-05-03 16:23:25', 0x00, N'78078a8e-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd388-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2015-03-29 10:13:59', 0x00, '2016-05-03 16:23:25', 0x00, N'78078b24-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd432-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>${rc:event}</p>

<p>${prc:cbox_incomingContextHash}</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'quick save', 2, '2015-04-01 11:17:19', 0x00, '2016-05-03 16:23:25', 0x00, N'78078bc4-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd432-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Reverting to version 1', 3, '2015-05-09 22:31:13', 0x00, '2016-05-03 16:23:25', 0x00, N'78078c5a-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd432-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 4, '2015-05-09 22:39:03', 0x00, '2016-05-18 11:50:02', 0x00, N'78078cfa-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd432-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2015-09-16 10:33:56', 0x00, '2016-05-03 16:23:25', 0x00, N'78078d9a-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd4dc-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 2, '2015-09-23 11:04:54', 0x01, '2016-05-03 16:23:25', 0x00, N'78078e30-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd4dc-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Test</p>', N'', 1, '2016-01-14 11:44:58', 0x00, '2016-05-03 16:23:25', 0x00, N'78078ed0-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd57c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Test</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 2, '2016-01-14 11:45:17', 0x01, '2016-05-03 16:23:25', 0x00, N'78078f48-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd57c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>asdf</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2016-01-14 11:45:35', 0x00, '2016-05-05 15:53:13', 0x00, N'78078fc0-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd61c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Support services</p>

<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 34, '2016-04-10 16:27:12', 0x00, '2016-05-03 16:23:25', 0x00, N'78079056-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd2de-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Support services</p>

<p><widget dropdown="false" emptymessage="Sorry, no related content was found." rendermethodselect="renderIt" title="" titlelevel="2" widgetdisplayname="Related Content" widgetname="RelatedContent" widgettype="Core" widgetudf="renderIt"><widgetinfobar contenteditable="false"><img align="left" contenteditable="false" height="20" src="/modules/contentbox-admin/includes/images/widgets/tag.png" style="margin-right:5px;" width="20" />Related Content : dropdown = false | emptyMessage = Sorry, no related content was found. | titleLevel = 2 | UDF = renderIt()</widgetinfobar></widget></p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 35, '2016-04-11 11:40:14', 0x01, '2016-05-03 16:23:25', 0x00, N'780790ce-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd2de-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2016-04-12 13:18:51', 0x00, '2016-05-03 16:23:25', 0x00, N'78079164-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd806-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 2, '2016-04-12 13:19:21', 0x01, '2016-05-03 16:23:25', 0x00, N'780791dc-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd806-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2016-04-12 13:19:04', 0x01, '2016-05-03 16:23:25', 0x00, N'78079268-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd8b0-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2016-04-12 13:19:10', 0x01, '2016-05-03 16:23:25', 0x00, N'780792e0-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd950-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>asdf</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'quick save', 2, '2016-05-05 15:53:13', 0x00, '2016-05-05 15:55:34', 0x00, N'7807938a-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd61c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>asdf</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'quick save', 3, '2016-05-05 15:55:34', 0x00, '2016-05-05 15:56:12', 0x00, N'7807942a-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd61c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'Because of God''s grace, this project exists. If you don''t like this, then don''t read it, its not for you.

>"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the
Holy Ghost which is given unto us. ." Romans 5:5

----

# Welcome to ContentBox
ContentBox is a modular content management engine based on the popular [ColdBox](www.coldbox.org) MVC framework.

## License
Apache License, Version 2.0.

## Versioning
ContentBox is maintained under the Semantic Versioning guidelines as much as possible.

Releases will be numbered with the following format:

```
<major>.<minor>.<patch>
```

And constructed with the following guidelines:

* Breaking backward compatibility bumps the major (and resets the minor and patch)
* New additions without breaking backward compatibility bumps the minor (and resets the patch)
* Bug fixes and misc changes bumps the patch

## Important Links

Source Code
- https://github.com/Ortus-Solutions/ContentBox

Continuous Integration
- http://jenkins.staging.ortussolutions.com/job/OS-ContentBox%20BE/

Bug Tracking/Agile Boards
- https://ortussolutions.atlassian.net/browse/CONTENTBOX

Documentation
- http://contentbox.ortusbooks.com

Blog
- http://www.ortussolutions.com/blog

## System Requirements
- Lucee 4.5+
- Railo 4+ (Deprecated)
- ColdFusion 10+

# ContentBox Installation

You can follow in-depth installation instructions here: http://contentbox.ortusbooks.com/content/installation/index.html or you can use [CommandBox](http://www.ortussolutions.com/products/commandbox) to quickly get up and running via the following commands:

**Stable Release**

```bash
mkdir mysite && cd mysite
# Install latest release
box install contentbox
box server start --rewritesEnable
```

**Bleeding Edge Release**

```bash
mkdir mysite && cd mysite
# Install latest release
box install contentbox-be
box server start --rewritesEnable
```

## Collaboration

If you want to develop and hack at the source, you will need to download [CommandBox](http://www.ortussolutions.com/products/commandbox) first.  Then in the root of this project, type `box install`.  This will download the necessary dependencies to develop and test ContentBox.  You can then go ahead and start an embedded server `box server start --rewritesEnable` and start hacking around and contributing.

### Test Suites
For running our test suites you will need 2 more steps, so please refer to the [Readme](tests/readme.md) in the tests folder.

### UI Development
If developing CSS and Javascript assets, please refer to the [Developer Guide](workbench/Developer.md) in the `workbench/Developer.md` folder.

---

###THE DAILY BREAD
 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12', N'', 4, '2016-05-05 15:56:11', 0x01, '2016-05-05 15:56:11', 0x00, N'78079560-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd61c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p># Test App This is my `cool` documentation {{{ContentStore slug=''firefox-test''}}} I want an image: ![ContentBoxIcon300.png](/index.cfm/__media/ContentBoxIcon300.png) This is an amazing coding styles</p>

<pre class="brush: coldfusion">
Code Fences Work</pre>', N'', 6, '2016-05-06 15:47:42', 0x00, '2016-05-06 16:12:27', 0x00, N'7807960a-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd9fa-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p># Test App This is my `cool` documentation {{{ContentStore slug=''firefox-test''}}} I want an image: ![ContentBoxIcon300.png](/index.cfm/__media/ContentBoxIcon300.png) This is an amazing coding styles</p>

<pre class="brush: coldfusion">
Code Fences Work
</pre>', N'quick save', 7, '2016-05-06 16:12:27', 0x00, '2016-05-06 16:16:02', 0x00, N'78079682-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd9fa-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p># Test App This is my `cool` documentation {{{ContentStore slug=''firefox-test''}}} I want an image: ![ContentBoxIcon300.png](/index.cfm/__media/ContentBoxIcon300.png) This is an amazing coding styles</p>

<pre class="brush: coldfusion">
Code Fences Work
</pre>', N'quick save', 8, '2016-05-06 16:16:02', 0x00, '2016-05-09 15:18:20', 0x00, N'780796f0-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd9fa-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p># Test App This is my `cool` documentation {{{ContentStore slug=''firefox-test''}}} I want an image: ![ContentBoxIcon300.png](/index.cfm/__media/ContentBoxIcon300.png) This is an amazing coding styles</p>

<pre class="brush: coldfusion">
Code Fences Work
</pre>', N'quick save', 9, '2016-05-09 15:18:20', 0x00, '2016-05-10 14:31:20', 0x00, N'7807975e-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd9fa-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p># Test App This is my `cool` documentation {{{ContentStore slug=''firefox-test''}}} I want an image: ![ContentBoxIcon300.png](/index.cfm/__media/ContentBoxIcon300.png) This is an amazing coding styles</p>

<pre class="brush: coldfusion">
Code Fences Work
</pre>', N'quick save', 10, '2016-05-10 14:31:20', 0x00, '2016-05-11 15:52:40', 0x00, N'780797f4-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd9fa-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p># Test App This is my `cool` documentation {{{ContentStore slug=''firefox-test''}}} I want an image: ![ContentBoxIcon300.png](/index.cfm/__media/ContentBoxIcon300.png) This is an amazing coding styles</p>

<pre class="brush: coldfusion">
Code Fences Work
</pre>', N'quick save', 11, '2016-05-11 15:52:40', 0x00, '2016-05-11 15:52:45', 0x00, N'78079858-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd9fa-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p># Test App This is my `cool` documentation {{{ContentStore slug=''firefox-test''}}} I want an image: ![ContentBoxIcon300.png](/index.cfm/__media/ContentBoxIcon300.png) This is an amazing coding styles</p>

<pre class="brush: coldfusion">
Code Fences Work
</pre>', N'quick save', 12, '2016-05-11 15:52:45', 0x00, '2016-05-18 11:42:34', 0x00, N'780798c6-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd9fa-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2016-05-18 11:35:32', 0x00, '2016-05-18 11:35:32', 0x00, N'7807992a-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdaa4-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p><img alt="" src="/index.cfm/__media/ContentBox_300.png" style="width: 300px; height: 284px;" /></p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p><img alt="" src="/index.cfm/__media/ContentBox_125.gif" style="width: 124px; height: 118px;" /></p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 2, '2016-05-18 11:35:32', 0x00, '2016-05-18 11:35:32', 0x00, N'780799d4-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdaa4-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p><img alt="" src="/__media/ContentBox_300.png" style="width: 300px; height: 284px;" /></p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p><img alt="" src="/__media/ContentBox_125.gif" style="width: 124px; height: 118px;" /></p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 3, '2016-05-18 11:35:32', 0x00, '2016-05-18 11:35:32', 0x00, N'78079a7e-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdaa4-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p><img alt="" src="/__media/ContentBox_300.png" style="width: 300px; height: 178px;" /></p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 4, '2016-05-18 11:35:32', 0x00, '2016-05-18 15:11:18', 0x00, N'78079b00-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdaa4-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2016-05-18 11:35:32', 0x01, '2016-05-18 11:35:32', 0x00, N'78079b96-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdb4e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2016-05-18 11:35:32', 0x01, '2016-05-18 11:35:32', 0x00, N'78079c0e-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdbee-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2016-05-18 11:35:32', 0x01, '2016-05-18 11:35:32', 0x00, N'78079cae-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdc8e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2016-05-18 11:35:32', 0x01, '2016-05-18 11:35:32', 0x00, N'78079d26-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdd38-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2016-05-18 11:35:32', 0x01, '2016-05-18 11:35:32', 0x00, N'78079dbc-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cddd8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Support services</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 1, '2016-05-18 11:35:32', 0x01, '2016-05-18 11:35:32', 0x00, N'78079e34-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cde82-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Content Cloned!', 1, '2016-05-18 11:35:32', 0x00, '2016-05-18 11:35:32', 0x00, N'78079eb6-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdf22-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<iframe width="560" height="315" src="https://www.youtube.com/embed/vdBHFxfZues" frameborder="0" allowfullscreen></iframe>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 2, '2016-05-18 11:35:32', 0x01, '2016-05-18 11:35:32', 0x00, N'78079f4c-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdf22-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Content Cloned!', 1, '2016-05-18 11:35:32', 0x01, '2016-05-18 11:35:32', 0x00, N'78079fc4-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdfc2-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Content Cloned!', 1, '2016-05-18 11:35:32', 0x01, '2016-05-18 11:35:32', 0x00, N'7807a064-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ce06c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Content Cloned!', 1, '2016-05-18 11:35:32', 0x01, '2016-05-18 11:35:32', 0x00, N'7807a0dc-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ce10c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Content Cloned!', 1, '2016-05-18 11:35:32', 0x01, '2016-05-18 11:35:32', 0x00, N'7807a172-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ce1ac-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Support services</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Content Cloned!', 1, '2016-05-18 11:35:32', 0x01, '2016-05-18 11:35:32', 0x00, N'7807a1f4-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ce256-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p># Test App This is my `cool` documentation {{{ContentStore slug=''firefox-test''}}} I want an image: ![ContentBoxIcon300.png](/index.cfm/__media/ContentBoxIcon300.png) This is an amazing coding styles</p>

<pre class="brush: coldfusion">
Code Fences Work
</pre>', N'', 13, '2016-05-18 11:42:34', 0x00, '2016-05-18 11:45:50', 0x00, N'7807a3c0-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd9fa-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p># Test App This is my `cool` documentation {{{ContentStore slug=''firefox-test''}}} I want an image: ![ContentBoxIcon300.png](/index.cfm/__media/ContentBoxIcon300.png) This is an amazing coding styles</p>

<pre class="brush: coldfusion">
Code Fences Work
</pre>', N'', 14, '2016-05-18 11:45:50', 0x00, '2016-06-14 13:46:47', 0x00, N'7807a4e2-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd9fa-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'My Products Rock', N'', 5, '2017-06-13 17:08:36', 0x01, '2017-06-13 17:08:36', 0x00, N'7807a5f0-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cdaa4-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'Expired content', 1, '2018-03-20 09:48:13', 0x01, '2018-03-20 09:48:13', 0x00, N'7807a898-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ce300-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>{{{ContentStore slug=''support-options-baby''}}}</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 3, '2021-02-19 10:54:25', 0x01, '2021-02-19 10:54:25', 0x00, N'7807aa28-a444-11eb-ab6f-0290cc502ae3', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccb0e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>This is a test.</p>', N'', 2, '2021-05-05 15:14:43', 0x00, '2021-05-05 15:17:18', 0x00, N'ff808081793cf2c801793e2b1c630029', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd234-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<h2><strong>This is a test.</strong></h2>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 3, '2021-05-05 15:17:18', 0x00, '2021-05-05 15:17:48', 0x00, N'ff808081793cf2c801793e2d7a7f002f', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd234-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<h2><strong>This is a test.</strong></h2>

<p><strong><img alt="" src="/__media/space-ninja200.png" style="width: 200px; height: 238px;" /></strong></p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 4, '2021-05-05 15:17:48', 0x01, '2021-05-05 15:17:48', 0x00, N'ff808081793cf2c801793e2ded9c0033', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779cd234-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'quick save', 2, '2021-05-05 15:18:17', 0x00, '2021-05-05 15:18:36', 0x00, N'ff808081793cf2c801793e2e609d0034', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccdac-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 3, '2021-05-05 15:18:35', 0x00, '2021-05-05 15:27:41', 0x00, N'ff808081793cf2c801793e2ea7a40035', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccdac-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_contentversion(content, changelog, version, createdDate, isActive, modifiedDate, isDeleted, contentVersionID, FK_authorID, FK_contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'', 4, '2021-05-05 15:27:41', 0x01, '2021-05-05 15:27:41', 0x00, N'ff808081793cf2c801793e36fab40036', N'77abddba-a444-11eb-ab6f-0290cc502ae3', N'779ccdac-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_customfield("key", value, createdDate, modifiedDate, isDeleted, customFieldID, FK_contentID) VALUES (N'age', N'30', '2016-05-03 16:23:25', '2016-05-03 16:23:25', 0x00, N'783ceee0-a444-11eb-ab6f-0290cc502ae3', N'779ccc62-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_customfield("key", value, createdDate, modifiedDate, isDeleted, customFieldID, FK_contentID) VALUES (N'subtitle', N'4', '2016-05-03 16:23:25', '2016-05-03 16:23:25', 0x00, N'783cf188-a444-11eb-ab6f-0290cc502ae3', N'779ccc62-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_customfield("key", value, createdDate, modifiedDate, isDeleted, customFieldID, FK_contentID) VALUES (N'premium', N'true', '2021-05-05 15:17:48', '2021-05-05 15:17:48', 0x00, N'ff808081793cf2c801793e2ded9a0030', N'779cd234-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_customfield("key", value, createdDate, modifiedDate, isDeleted, customFieldID, FK_contentID) VALUES (N'rows', N'3', '2021-05-05 15:17:48', '2021-05-05 15:17:48', 0x00, N'ff808081793cf2c801793e2ded9a0031', N'779cd234-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_customfield("key", value, createdDate, modifiedDate, isDeleted, customFieldID, FK_contentID) VALUES (N'name', N'luis majano', '2021-05-05 15:17:48', '2021-05-05 15:17:48', 0x00, N'ff808081793cf2c801793e2ded9a0032', N'779cd234-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_entry(excerpt, contentID) VALUES (N'', N'779cc2bc-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_entry(excerpt, contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'779cc4e2-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_entry(excerpt, contentID) VALUES (N'', N'779cc5e6-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_entry(excerpt, contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'779cc6b8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_entry(excerpt, contentID) VALUES (N'', N'779cc76c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_entry(excerpt, contentID) VALUES (N'', N'779cc820-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_entry(excerpt, contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'779cc906-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_entry(excerpt, contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>

<p>&nbsp;</p>', N'779cc9ba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_entry(excerpt, contentID) VALUES (N'', N'779cca64-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_entry(excerpt, contentID) VALUES (N'', N'779ccb0e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_entry(excerpt, contentID) VALUES (N'', N'779ccfa0-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_entry(excerpt, contentID) VALUES (N'', N'779cd040-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_entry(excerpt, contentID) VALUES (N'', N'779cd0ea-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_entry(excerpt, contentID) VALUES (N'<p>Excerpt Content TestsExcerpt Content TestsExcerpt Content Tests</p>', N'779cd18a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_entry(excerpt, contentID) VALUES (N'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.</p>

<p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>', N'779cd234-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_grouppermissions(FK_permissionGroupID, FK_permissionID) VALUES (N'7850efee-a444-11eb-ab6f-0290cc502ae3', N'785d78d6-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_grouppermissions(FK_permissionGroupID, FK_permissionID) VALUES (N'7850efee-a444-11eb-ab6f-0290cc502ae3', N'785d7e76-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_grouppermissions(FK_permissionGroupID, FK_permissionID) VALUES (N'7850efee-a444-11eb-ab6f-0290cc502ae3', N'785d7d2c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_grouppermissions(FK_permissionGroupID, FK_permissionID) VALUES (N'7850f138-a444-11eb-ab6f-0290cc502ae3', N'785d7eee-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_grouppermissions(FK_permissionGroupID, FK_permissionID) VALUES (N'7850f138-a444-11eb-ab6f-0290cc502ae3', N'785d73f4-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_jwt(id, cacheKey, expiration, issued, token, subject) VALUES (N'1ebb50e2-efa4-4bbd-864a-72346def3651', N'8ADE1B7A591DA4FD7379AA0946D1384E', '2021-04-29 17:23:59', '2021-04-29 16:23:59', N'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE2MTk3MzE0MzksImlzcyI6ImNvbnRlbnRib3giLCJzdWIiOiI3N2FiZGRiYS1hNDQ0LTExZWItYWI2Zi0wMjkwY2M1MDJhZTMiLCJleHAiOjE2MTk3MzUwMzksInNjb3BlIjoiIiwianRpIjoiOEFERTFCN0E1OTFEQTRGRDczNzlBQTA5NDZEMTM4NEUifQ.oRmwhuGuntWrM9BSmTYLVQ68_iZzpVXz3cDcGtW0i87t0JkOUDfiMLN8JhVPTVV-eRc0CfysrzARVnZ4b2eDQg', N'77abddba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_jwt(id, cacheKey, expiration, issued, token, subject) VALUES (N'1ff4e66c-403f-41e7-b2d4-bb1640a3de05', N'849FD8001C707D915B734D755AF083DD', '2021-05-04 11:11:12', '2021-05-04 10:11:12', N'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE2MjAxNDEwNzIsImlzcyI6ImNvbnRlbnRib3giLCJzdWIiOiI3N2FiZGRiYS1hNDQ0LTExZWItYWI2Zi0wMjkwY2M1MDJhZTMiLCJleHAiOjE2MjAxNDQ2NzIsInNjb3BlIjoiIiwianRpIjoiODQ5RkQ4MDAxQzcwN0Q5MTVCNzM0RDc1NUFGMDgzREQifQ.EiJ1FsDUgQO2uznASQ4yiAVXazzpOd2PK6emG1vqDYIrOJ28WYYVg1A09E7_pETS8NWygFhWOoD9QsdHDtNvww', N'77abddba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_jwt(id, cacheKey, expiration, issued, token, subject) VALUES (N'25b69c04-6a17-4c79-a60c-a92709366705', N'01FC44D07AE23A9F28A043399D6A07DB', '2021-04-29 17:38:20', '2021-04-29 16:38:20', N'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE2MTk3MzIzMDAsImlzcyI6ImNvbnRlbnRib3giLCJzdWIiOiI3N2FiZGRiYS1hNDQ0LTExZWItYWI2Zi0wMjkwY2M1MDJhZTMiLCJleHAiOjE2MTk3MzU5MDAsInNjb3BlIjoiIiwianRpIjoiMDFGQzQ0RDA3QUUyM0E5RjI4QTA0MzM5OUQ2QTA3REIifQ.aJ7EQdxuhJiHit_FsTbjQ9ORMVShm-eOGKg22QfkevB7Y0kiXeOzwLDLyHMdKTwvZVbYzdtuWXkcB_swnjcb6g', N'77abddba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_jwt(id, cacheKey, expiration, issued, token, subject) VALUES (N'5cb41db3-db5a-4aec-9f5e-86f1e2b99bfa', N'1740C9F4EEC10A8A3FF7A00212B8A439', '2021-04-29 16:29:22', '2021-04-29 15:29:22', N'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE2MTk3MjgxNjIsImlzcyI6ImNvbnRlbnRib3giLCJzdWIiOiI3N2FiZGRiYS1hNDQ0LTExZWItYWI2Zi0wMjkwY2M1MDJhZTMiLCJleHAiOjE2MTk3MzE3NjIsInNjb3BlIjoiIiwianRpIjoiMTc0MEM5RjRFRUMxMEE4QTNGRjdBMDAyMTJCOEE0MzkifQ._TTmPvKkuawaezG-XM1oEfJRLShshMg7BNfjvYnHtxLroJ1qGK1Fl8df926uAzz7ILWnoz1RvuGe0oqvA4PU1A', N'77abddba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_jwt(id, cacheKey, expiration, issued, token, subject) VALUES (N'6892921f-9314-4c64-8fdf-2b7a30d7d8eb', N'3DEFDA4BF756C0E5A5E92A38173DED3D', '2021-04-29 17:21:16', '2021-04-29 16:21:16', N'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE2MTk3MzEyNzYsImlzcyI6ImNvbnRlbnRib3giLCJzdWIiOiI3N2FiZGRiYS1hNDQ0LTExZWItYWI2Zi0wMjkwY2M1MDJhZTMiLCJleHAiOjE2MTk3MzQ4NzYsInNjb3BlIjoiIiwianRpIjoiM0RFRkRBNEJGNzU2QzBFNUE1RTkyQTM4MTczREVEM0QifQ.A87lrKAj0jasnHCqU5hAAoSWNeVOvVPX3zMTrXm-HkaIHCkixUfrBtKemOIn-7Rb8yptu8n64BkgV763YJc_Tw', N'77abddba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_jwt(id, cacheKey, expiration, issued, token, subject) VALUES (N'99d8051f-857b-4953-9519-5f46c82671fb', N'8B249134BB367E8A5F79EFBE15635988', '2021-05-05 13:10:51', '2021-05-05 12:10:51', N'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE2MjAyMzQ2NTEsImlzcyI6ImNvbnRlbnRib3giLCJzdWIiOiI3N2FiZGRiYS1hNDQ0LTExZWItYWI2Zi0wMjkwY2M1MDJhZTMiLCJleHAiOjE2MjAyMzgyNTEsInNjb3BlIjoiIiwianRpIjoiOEIyNDkxMzRCQjM2N0U4QTVGNzlFRkJFMTU2MzU5ODgifQ.YIhtGXdm5yoAYDAAyqHC2LybMy24fz57RkhPtCb6v5SIYSR3A8S5k8REi8YZiyWWaoX8hpu5SAP0xlmhDrm-Hw', N'77abddba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_jwt(id, cacheKey, expiration, issued, token, subject) VALUES (N'cc5edab6-e728-4ea7-b97b-62071ce88a2c', N'90E4D45D40E4F1CFE9666CAE5C8C3878', '2021-04-29 17:35:29', '2021-04-29 16:35:29', N'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE2MTk3MzIxMjksImlzcyI6ImNvbnRlbnRib3giLCJzdWIiOiI3N2FiZGRiYS1hNDQ0LTExZWItYWI2Zi0wMjkwY2M1MDJhZTMiLCJleHAiOjE2MTk3MzU3MjksInNjb3BlIjoiIiwianRpIjoiOTBFNEQ0NUQ0MEU0RjFDRkU5NjY2Q0FFNUM4QzM4NzgifQ.hus57KJZUzLvl80-QL6lYbFkcz4i0Hm6uUXIV8fbvOrlflE2_oVXjHvIK6gpKU2WpWbbSj8dKkHJ0KD18R1eig', N'77abddba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_jwt(id, cacheKey, expiration, issued, token, subject) VALUES (N'ec7b1544-1e81-43a4-8c0c-dc06b7633b90', N'353452B1542EECC5BDF74C0EF374CED3', '2021-04-29 17:47:51', '2021-04-29 16:47:51', N'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE2MTk3MzI4NzEsImlzcyI6ImNvbnRlbnRib3giLCJzdWIiOiI3N2FiZGRiYS1hNDQ0LTExZWItYWI2Zi0wMjkwY2M1MDJhZTMiLCJleHAiOjE2MTk3MzY0NzEsInNjb3BlIjoiIiwianRpIjoiMzUzNDUyQjE1NDJFRUNDNUJERjc0QzBFRjM3NENFRDMifQ.B_lb6D3GFBIIaNla5b_nEkhNz0xlT4ueJxmDjrG2ktHtS8JHp3JwdQ2pXGys1Ox-PHfLWubui3NO0uqGJjOC5A', N'77abddba-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_loginattempts(value, attempts, createdDate, lastLoginSuccessIP, modifiedDate, isDeleted, loginAttemptsID) VALUES (N'lmajano', 0, '2016-11-28 14:56:43', N'127.0.0.1', '2016-11-28 14:56:46', 0x00, N'7816ad2a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_loginattempts(value, attempts, createdDate, lastLoginSuccessIP, modifiedDate, isDeleted, loginAttemptsID) VALUES (N'testermajano', 0, '2017-06-21 16:07:26', N'127.0.0.1', '2017-06-21 17:37:42', 0x00, N'7816aeb0-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_loginattempts(value, attempts, createdDate, lastLoginSuccessIP, modifiedDate, isDeleted, loginAttemptsID) VALUES (N'joejoe@joe.com', 0, '2017-07-06 11:37:09', null, '2017-07-06 11:37:31', 0x00, N'7816af8c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_loginattempts(value, attempts, createdDate, lastLoginSuccessIP, modifiedDate, isDeleted, loginAttemptsID) VALUES (N'joejoe', 0, '2017-07-06 11:38:28', N'127.0.0.1', '2017-07-06 11:38:28', 0x00, N'7816b00e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_menu(title, slug, listType, createdDate, menuClass, listClass, modifiedDate, isDeleted, menuID, FK_siteID) VALUES (N'Main Menu', N'main-menu', N'ul', '2016-05-04 17:00:14', N'm5 p5', N'', '2021-05-05 15:29:13', 0x00, N'77cccd4a-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_menu(title, slug, listType, createdDate, menuClass, listClass, modifiedDate, isDeleted, menuID, FK_siteID) VALUES (N'test', N'test -e123c', N'ul', '2016-05-04 17:02:54', N'', N'', '2016-05-04 17:02:54', 0x00, N'77ccceb2-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_menuitem(menuType, title, label, data, active, mediaPath, contentSlug, menuSlug, url, js, itemClass, target, urlClass, createdDate, modifiedDate, isDeleted, menuItemID, FK_menuID, FK_parentID) VALUES (N'Free', N'', N'test', N'', 0x01, null, null, null, null, null, N'', null, null, '2021-05-05 15:30:12', '2021-05-05 15:30:12', 0x00, N'ff808081793cf2c801793e3947b6003b', N'77cccd4a-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_menuitem(menuType, title, label, data, active, mediaPath, contentSlug, menuSlug, url, js, itemClass, target, urlClass, createdDate, modifiedDate, isDeleted, menuItemID, FK_menuID, FK_parentID) VALUES (N'URL', N'', N'hello', N'', 0x01, null, null, null, N'http://www.ortussolutions.com', null, N'', N'_blank', N'test', '2021-05-05 15:30:12', '2021-05-05 15:30:12', 0x00, N'ff808081793cf2c801793e3947b6003c', N'77cccd4a-a444-11eb-ab6f-0290cc502ae3', N'ff808081793cf2c801793e3947b6003b')
GO
INSERT INTO cb_menuitem(menuType, title, label, data, active, mediaPath, contentSlug, menuSlug, url, js, itemClass, target, urlClass, createdDate, modifiedDate, isDeleted, menuItemID, FK_menuID, FK_parentID) VALUES (N'Content', N'', N'Disk Queues', N'', 0x01, null, N'disk-queues-77caf', null, null, null, N'', N'', N'', '2021-05-05 15:30:12', '2021-05-05 15:30:12', 0x00, N'ff808081793cf2c801793e3947b6003d', N'77cccd4a-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_menuitem(menuType, title, label, data, active, mediaPath, contentSlug, menuSlug, url, js, itemClass, target, urlClass, createdDate, modifiedDate, isDeleted, menuItemID, FK_menuID, FK_parentID) VALUES (N'Free', N'', N'Sites', N'', 0x01, null, null, null, null, null, N'', null, null, '2021-05-05 15:30:12', '2021-05-05 15:30:12', 0x00, N'ff808081793cf2c801793e3947b6003e', N'77cccd4a-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_menuitem(menuType, title, label, data, active, mediaPath, contentSlug, menuSlug, url, js, itemClass, target, urlClass, createdDate, modifiedDate, isDeleted, menuItemID, FK_menuID, FK_parentID) VALUES (N'URL', N'', N'ortus', N'', 0x01, null, null, null, N'https://ortussolutions.com', null, N'', N'_blank', N'', '2021-05-05 15:30:12', '2021-05-05 15:30:12', 0x00, N'ff808081793cf2c801793e3947b7003f', N'77cccd4a-a444-11eb-ab6f-0290cc502ae3', N'ff808081793cf2c801793e3947b6003e')
GO
INSERT INTO cb_menuitem(menuType, title, label, data, active, mediaPath, contentSlug, menuSlug, url, js, itemClass, target, urlClass, createdDate, modifiedDate, isDeleted, menuItemID, FK_menuID, FK_parentID) VALUES (N'URL', N'Products', N'Products', N'', 0x01, null, null, null, N'https://www.ortussolutions.com/products', null, N'', N'_blank', N'', '2021-05-05 15:30:12', '2021-05-05 15:30:12', 0x00, N'ff808081793cf2c801793e3947b70040', N'77cccd4a-a444-11eb-ab6f-0290cc502ae3', N'ff808081793cf2c801793e3947b7003f')
GO
INSERT INTO cb_module(name, title, version, entryPoint, author, webURL, forgeBoxSlug, description, isActive, createdDate, modifiedDate, isDeleted, moduleType, moduleID) VALUES (N'Hello', N'HelloContentBox', N'1.0', N'HelloContentBox', N'Ortus Solutions, Corp', N'http://www.ortussolutions.com', N'', N'This is an awesome hello world module', 0x00, '2016-07-15 12:09:34', '2016-07-15 12:09:34', 0x00, N'core', N'77b59b34-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'pages', 6, 0x01, N'', 0x00, N'779cd2de-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'-no-layout-', 3, 0x01, N'', 0x00, N'779cd432-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'pagesNoSidebar', 5, 0x01, N'', 0x00, N'779cd4dc-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'pages', 4, 0x01, N'', 0x00, N'779cd806-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'pages', 0, 0x01, N'', 0x00, N'779cd8b0-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'pages', 0, 0x01, N'', 0x00, N'779cd950-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'pages', 2, 0x00, N'', 0x00, N'779cd9fa-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'pages', 1, 0x01, N'', 0x00, N'779cdaa4-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'pages', 2, 0x01, N'', 0x00, N'779cdb4e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'pages', 1, 0x01, N'', 0x00, N'779cdbee-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'pages', 2, 0x01, N'', 0x00, N'779cdc8e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'pages', 6, 0x01, N'', 0x00, N'779cdd38-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'pages', 4, 0x01, N'', 0x00, N'779cddd8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'pages', 8, 0x01, N'', 0x00, N'779cde82-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'pages', 1, 0x01, N'', 0x00, N'779cdf22-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'pages', 0, 0x01, N'', 0x00, N'779cdfc2-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'pages', 0, 0x01, N'', 0x00, N'779ce06c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'pages', 0, 0x01, N'', 0x00, N'779ce10c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'pages', 0, 0x01, N'', 0x00, N'779ce1ac-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_page(layout, "order", showInMenu, excerpt, SSLOnly, contentID) VALUES (N'pages', 0, 0x01, N'', 0x00, N'779ce256-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'PAGES_ADMIN', N'Ability to manage content pages, default is view only', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d71f6-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'EDITORS_EDITOR_SELECTOR', N'Ability to change the editor to another registered online editor', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d734a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'WIDGET_ADMIN', N'Ability to manage widgets, default is view only', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d73f4-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'TOOLS_IMPORT', N'Ability to import data into ContentBox', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d7480-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'GLOBALHTML_ADMIN', N'Ability to manage the system''s global HTML content used on layouts', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d74f8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'PAGES_EDITOR', N'Ability to manage content pages but not publish pages', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d7570-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'SYSTEM_TAB', N'Access to the ContentBox System tools', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d761a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'SYSTEM_UPDATES', N'Ability to view and apply ContentBox updates', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d769c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'CONTENTBOX_ADMIN', N'Access to the enter the ContentBox administrator console', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d770a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'RELOAD_MODULES', N'Ability to reload modules', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d7782-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'MODULES_ADMIN', N'Ability to manage ContentBox Modules', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d77f0-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'COMMENTS_ADMIN', N'Ability to manage comments, default is view only', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d785e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'AUTHOR_ADMIN', N'Ability to manage authors, default is view only', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d78d6-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'PERMISSIONS_ADMIN', N'Ability to manage permissions, default is view only', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d7944-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'MEDIAMANAGER_ADMIN', N'Ability to manage the system''s media manager', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d79b2-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'SYSTEM_RAW_SETTINGS', N'Access to the ContentBox raw geek settings panel', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d7a20-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'CATEGORIES_ADMIN', N'Ability to manage categories, default is view only', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d7a8e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'EDITORS_DISPLAY_OPTIONS', N'Ability to view the content display options panel', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d7afc-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'EDITORS_HTML_ATTRIBUTES', N'Ability to view the content HTML attributes panel', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d7b6a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'FORGEBOX_ADMIN', N'Ability to manage ForgeBox installations and connectivity.', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d7be2-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'THEME_ADMIN', N'Ability to manage themes, default is view only', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d7c50-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'EDITORS_CATEGORIES', N'Ability to view the content categories panel', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d7cbe-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'EDITORS_MODIFIERS', N'Ability to view the content modifiers panel', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d7d2c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'ENTRIES_ADMIN', N'Ability to manage blog entries, default is view only', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d7d9a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'VERSIONS_ROLLBACK', N'Ability to rollback content versions', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d7e08-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'EDITORS_CACHING', N'Ability to view the content caching panel', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d7e76-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'ROLES_ADMIN', N'Ability to manage roles, default is view only', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d7eee-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'SYSTEM_SAVE_CONFIGURATION', N'Ability to update global configuration data', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d7f5c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'ENTRIES_EDITOR', N'Ability to manage blog entries but not publish entries', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d7fca-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'VERSIONS_DELETE', N'Ability to delete past content versions', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d8038-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'SECURITYRULES_ADMIN', N'Ability to manage the system''s security rules, default is view only', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d80a6-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'TOOLS_EXPORT', N'Ability to export data from ContentBox', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d8114-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'CONTENTSTORE_ADMIN', N'Ability to manage the content store, default is view only', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d8182-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'CONTENTSTORE_EDITOR', N'Ability to manage content store elements but not publish them', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d81f0-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'MEDIAMANAGER_LIBRARY_SWITCHER', N'Ability to switch media manager libraries for management', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d825e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'EDITORS_CUSTOM_FIELDS', N'Ability to manage custom fields in any content editors', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d82cc-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'GLOBAL_SEARCH', N'Ability to do global searches in the ContentBox Admin', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d8344-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'EDITORS_RELATED_CONTENT', N'Ability to view the related content panel', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d83b2-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'EDITORS_LINKED_CONTENT', N'Ability to view the linked content panel', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d8420-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'MENUS_ADMIN', N'Ability to manage the menu builder', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d848e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'SYSTEM_AUTH_LOGS', N'Access to the system auth logs', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d84fc-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'EDITORS_FEATURED_IMAGE', N'Ability to view the featured image panel', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'785d8574-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'EMAIL_TEMPLATE_ADMIN', N'Ability to admin and preview email templates', '2017-06-20 16:13:01', '2017-06-20 16:13:01', 0x00, N'785d85e2-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permission(permission, description, createdDate, modifiedDate, isDeleted, permissionID) VALUES (N'SITES_ADMIN', N'Ability to manage sites', '2020-09-09 17:16:59', '2020-09-09 17:16:59', 0x00, N'785d8650-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permissiongroup(createdDate, modifiedDate, isDeleted, name, description, permissionGroupID) VALUES ('2017-06-12 16:01:13', '2017-06-12 20:31:52', 0x00, N'Finance', N'Finance team permissions', N'7850efee-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_permissiongroup(createdDate, modifiedDate, isDeleted, name, description, permissionGroupID) VALUES ('2017-06-16 13:02:12', '2017-06-16 13:02:12', 0x00, N'Security', N'', N'7850f138-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_relatedcontent(FK_contentID, FK_relatedContentID) VALUES (N'779ccef6-a444-11eb-ab6f-0290cc502ae3', N'779ccbb8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_relatedcontent(FK_contentID, FK_relatedContentID) VALUES (N'779ccdac-a444-11eb-ab6f-0290cc502ae3', N'779cd4dc-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_relatedcontent(FK_contentID, FK_relatedContentID) VALUES (N'779ccdac-a444-11eb-ab6f-0290cc502ae3', N'779cd234-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_role(role, description, createdDate, modifiedDate, isDeleted, roleID) VALUES (N'Editor', N'A ContentBox editor', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_role(role, description, createdDate, modifiedDate, isDeleted, roleID) VALUES (N'Administrator', N'A ContentBox Administrator', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_role(role, description, createdDate, modifiedDate, isDeleted, roleID) VALUES (N'MegaAdmin', N'A ContentBox Mega Admin', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_role(role, description, createdDate, modifiedDate, isDeleted, roleID) VALUES (N'Test', N'Test', '2016-09-23 14:35:41', '2016-09-23 14:35:41', 0x00, N'77c2c796-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d78d6-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7a8e-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d785e-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d770a-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7e76-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7cbe-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7afc-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d734a-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7b6a-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7d2c-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7d9a-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7fca-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7be2-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d74f8-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7c50-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d79b2-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d77f0-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d71f6-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7570-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7944-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7782-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7eee-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d80a6-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7a20-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7f5c-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d761a-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d769c-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7480-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d8038-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7e08-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d73f4-a444-11eb-ab6f-0290cc502ae3', N'77c2c70a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d78d6-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7a8e-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d785e-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d770a-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d8182-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d81f0-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7e76-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7cbe-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d82cc-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7afc-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d734a-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d8574-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7b6a-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d8420-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7d2c-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d83b2-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7d9a-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7fca-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7be2-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d74f8-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d8344-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d79b2-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d825e-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d848e-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d77f0-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d71f6-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7570-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7944-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7782-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7eee-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d80a6-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d84fc-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7a20-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7f5c-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d761a-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d769c-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7c50-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d8114-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7480-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d8038-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7e08-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d73f4-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d85e2-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7a8e-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d785e-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d770a-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d81f0-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7e76-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7cbe-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d82cc-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7afc-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d734a-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7b6a-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d8420-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7d2c-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d83b2-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d85e2-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7fca-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d74f8-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d8344-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d79b2-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d848e-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7570-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7c50-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d7e08-a444-11eb-ab6f-0290cc502ae3', N'77c2c476-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_rolepermissions(FK_permissionID, FK_roleID) VALUES (N'785d8650-a444-11eb-ab6f-0290cc502ae3', N'77c2c62e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:modules\..*', N'', N'MODULES_ADMIN', N'cbadmin/security/login', 0x00, 1, N'event', '2017-07-06 12:14:21', '2017-07-06 12:14:21', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f0882a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:mediamanager\..*', N'', N'MEDIAMANAGER_ADMIN', N'cbadmin/security/login', 0x00, 1, N'event', '2017-07-06 12:14:21', '2017-07-06 12:14:21', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f08a00-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:versions\.(remove)', N'', N'VERSIONS_DELETE', N'cbadmin/security/login', 0x00, 1, N'event', '2017-07-06 12:14:21', '2017-07-06 12:14:21', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f08ad2-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:versions\.(rollback)', N'', N'VERSIONS_ROLLBACK', N'cbadmin/security/login', 0x00, 1, N'event', '2017-07-06 12:14:21', '2017-07-06 12:14:21', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f08b72-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:widgets\.(remove|upload|edit|save|create|doCreate)$', N'', N'WIDGET_ADMIN', N'cbadmin/security/login', 0x00, 2, N'event', '2017-07-06 12:14:21', '2017-07-06 12:14:21', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f08c4e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:tools\.(importer|doImport)', N'', N'TOOLS_IMPORT', N'cbadmin/security/login', 0x00, 3, N'event', '2017-07-06 12:14:21', '2017-07-06 12:14:21', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f08cee-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:(settings|permissions|roles|securityRules)\..*', N'', N'SYSTEM_TAB', N'cbadmin/security/login', 0x00, 4, N'event', '2017-07-06 12:14:22', '2017-07-06 12:14:22', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f08d84-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:settings\.save', N'', N'SYSTEM_SAVE_CONFIGURATION', N'cbadmin/security/login', 0x00, 5, N'event', '2017-07-06 12:14:22', '2017-07-06 12:14:22', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f08e10-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:settings\.(raw|saveRaw|flushCache|flushSingletons|mappingDump|viewCached|remove)', N'', N'SYSTEM_RAW_SETTINGS', N'cbadmin/security/login', 0x00, 6, N'event', '2017-07-06 12:14:22', '2017-07-06 12:14:22', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f08ea6-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:securityRules\.(remove|save|changeOrder|apply)', N'', N'SECURITYRULES_ADMIN', N'cbadmin/security/login', 0x00, 7, N'event', '2017-07-06 12:14:22', '2017-07-06 12:14:22', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f08f3c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:roles\.(remove|removePermission|save|savePermission)', N'', N'ROLES_ADMIN', N'cbadmin/security/login', 0x00, 8, N'event', '2017-07-06 12:14:22', '2017-07-06 12:14:22', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f08fc8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:permissions\.(remove|save)', N'', N'PERMISSIONS_ADMIN', N'cbadmin/security/login', 0x00, 9, N'event', '2017-07-06 12:14:22', '2017-07-06 12:14:22', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f09054-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:dashboard\.reload', N'', N'RELOAD_MODULES', N'cbadmin/security/login', 0x00, 10, N'event', '2017-07-06 12:14:22', '2017-07-06 12:14:22', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f090e0-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:pages\.(changeOrder|remove)', N'', N'PAGES_ADMIN', N'cbadmin/security/login', 0x00, 11, N'event', '2017-07-06 12:14:22', '2017-07-06 12:14:22', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f0916c-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:themes\.(remove|upload|rebuildRegistry|activate)', N'', N'THEME_ADMIN', N'cbadmin/security/login', 0x00, 12, N'event', '2017-07-06 12:14:22', '2017-07-06 12:14:22', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f091f8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:entries\.(quickPost|remove)', N'', N'ENTRIES_ADMIN', N'cbadmin/security/login', 0x00, 13, N'event', '2017-07-06 12:14:22', '2017-07-06 12:14:22', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f09284-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:contentStore\.(editor|remove|save)', N'', N'CONTENTSTORE_ADMIN', N'cbadmin/security/login', 0x00, 14, N'event', '2017-07-06 12:14:22', '2017-07-06 12:14:22', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f09310-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:comments\.(doStatusUpdate|editor|moderate|remove|save|saveSettings)', N'', N'COMMENTS_ADMIN', N'cbadmin/security/login', 0x00, 15, N'event', '2017-07-06 12:14:22', '2017-07-06 12:14:22', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f093a6-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:categories\.(remove|save)', N'', N'CATEGORIES_ADMIN', N'cbadmin/security/login', 0x00, 16, N'event', '2017-07-06 12:14:22', '2017-07-06 12:14:22', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f09432-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:authors\.(remove|removePermission|savePermission|doPasswordReset|new|doNew)', N'', N'AUTHOR_ADMIN', N'cbadmin/security/login', 0x00, 17, N'event', '2017-07-06 12:14:22', '2017-07-06 12:14:22', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f094be-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'^contentbox-admin:security\.', N'^contentbox-admin:.*', N'', N'CONTENTBOX_ADMIN', N'cbadmin/security/login', 0x00, 18, N'event', '2017-07-06 12:14:22', '2017-07-06 12:14:22', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f0954a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-filebrowser:.*', N'', N'MEDIAMANAGER_ADMIN', N'cbadmin/security/login', 0x00, 19, N'event', '2017-07-06 12:14:22', '2017-07-06 12:14:22', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f095d6-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:(authors|categories|permissions|roles|settings|pages|entries|contentStore|securityrules)\.importAll$', N'', N'TOOLS_IMPORT', N'cbadmin/security/login', 0x00, 20, N'event', '2017-07-06 12:14:22', '2017-07-06 12:14:22', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f09662-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_securityrule(whitelist, securelist, roles, permissions, redirect, useSSL, "order", "match", createdDate, modifiedDate, isDeleted, message, messageType, overrideEvent, action, module, ruleID) VALUES (N'', N'^contentbox-admin:(authors|categories|permissions|roles|settings|pages|entries|contentStore|securityrules)\.(export|exportAll)$', N'', N'TOOLS_EXPORT', N'cbadmin/security/login', 0x00, 20, N'event', '2017-07-06 12:14:22', '2017-07-06 12:14:22', 0x00, N'', N'info', N'', N'redirect', N'contentbox', N'77f096f8-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_security_login_blocker', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782d99fe-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_media_allowDelete', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782d9b84-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_security_login_signin_text', N'', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782d9d50-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_versions_max_history', N'', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782d9dd2-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_security_rate_limiter_duration', N'1', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782d9e36-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_rss_description', N'ContentBox RSS Feed', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782d9ea4-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_media_html5uploads_maxFiles', N'25', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782d9efe-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_site_mail_password', N'', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782d9f62-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_rss_cacheName', N'Template', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782d9fbc-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_editors_markup', N'HTML', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da020-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_content_cacheName', N'Template', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da07a-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_editors_ckeditor_toolbar', N'[
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
		{ "name": "insert",      "items" : [ "Image","Table","HorizontalRule","Smiley","SpecialChar","Iframe","InsertPre"] },
		{ "name": "contentbox",  "items" : [ "MediaEmbed","cbIpsumLorem","cbWidgets","cbContentStore","cbLinks","cbEntryLinks" ] }
		]', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da0de-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_security_rate_limiter_logging', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da156-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_site_settings_cache', N'template', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da1ba-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_versions_commit_mandatory', N'false', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da214-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_notify_page', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da26e-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_site_mail_username', N'', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da2d2-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_rss_webmaster', N'', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da368-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_rss_title', N'RSS Feed by ContentBox', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da3cc-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_media_acceptMimeTypes', N'', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da55c-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_notify_author', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da5b6-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_dashboard_welcome_title', N'Dashboard', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da61a-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_page_excerpts', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da66a-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_site_outgoingEmail', N'info@ortussolutions.com', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da6c4-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_dashboard_newsfeed', N'https://www.ortussolutions.com/blog/rss', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da728-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_media_createFolders', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da782-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_security_min_password_length', N'8', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da7dc-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_dashboard_newsfeed_count', N'5', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da836-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_rss_cachingTimeout', N'60', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da890-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_content_cachingTimeoutIdle', N'15', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da8ea-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_media_html5uploads_maxFileSize', N'100', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da944-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_salt', N'50C8A804FEFA3CC43AFF8E68F6FF4299E311786C6B0D5A8DC070044A3C59938B70218FFE71F5C8B8C544AD26FE0C21D2F7D582F53B8CF016350BCC98FEA8B102', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782da99e-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_site_mail_server', N'', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782daa02-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_media_quickViewWidth', N'400', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782daa5c-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_security_2factorAuth_trusted_days', N'30', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782daab6-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_rss_generator', N'ContentBox by Ortus Solutions', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dab10-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_content_bot_regex', N'Google|msnbot|Rambler|Yahoo|AbachoBOT|accoona|AcioRobot|ASPSeek|CocoCrawler|Dumbot|FAST-WebCrawler|GeonaBot|Gigabot|Lycos|MSRBOT|Scooter|AltaVista|IDBot|eStyle|Scrubby', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dab6a-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_editors_ckeditor_excerpt_toolbar', N'[
		{ "name": "document",    "items" : [ "Source","-","Maximize","ShowBlocks" ] },
		{ "name": "basicstyles", "items" : [ "Bold","Italic","Underline","Strike","Subscript","Superscript"] },
		{ "name": "paragraph",   "items" : [ "NumberedList","BulletedList","-","Outdent","Indent","CreateDiv"] },
		{ "name": "links",       "items" : [ "Link","Unlink","Anchor" ] },
		{ "name": "insert",      "items" : [ "Image","Flash","Table","HorizontalRule","Smiley","SpecialChar" ] },
		{ "name": "contentbox",  "items" : [ "MediaEmbed","cbIpsumLorem","cbWidgets","cbContentStore","cbLinks","cbEntryLinks" ] }
		]', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dabce-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_security_blocktime', N'5', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dad54-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_comments_moderation_expiration', N'30', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dadae-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_contentstore_caching', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dae12-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_gravatar_rating', N'PG', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dae62-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_site_maintenance_message', N'<h1>This site is down for maintenance.<br /> Please check back again soon.</h1>', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782daebc-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_admin_theme', N'contentbox-default', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782daf20-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_dashboard_recentcontentstore', N'5', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782daf7a-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_comments_moderation_blockedlist', N'', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dafd4-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_content_cachingTimeout', N'60', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db02e-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_security_login_signout_url', N'', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db088-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_site_mail_ssl', N'false', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db0e2-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_paging_bandgap', N'5', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db13c-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_rss_maxComments', N'10', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db196-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_security_rate_limiter', N'false', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db1fa-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_media_allowDownloads', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db254-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_content_caching', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db2ae-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_content_hit_ignore_bots', N'false', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db308-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_rss_copyright', N'Ortus Solutions, Corp (www.ortussolutions.com)', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db470-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_site_maintenance', N'false', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db4d4-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_comments_moderation', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db524-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_rss_cachingTimeoutIdle', N'15', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db57e-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_admin_ssl', N'false', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db5d8-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_paging_maxentries', N'10', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db632-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_dashboard_recentComments', N'5', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db68c-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_security_latest_logins', N'10', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db6e6-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_content_cachingHeader', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db740-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_search_adapter', N'contentbox.models.search.DBSearch', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db79a-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_notify_entry', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db7f4-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_site_mail_smtp', N'25', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db966-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_security_rate_limiter_message', N'<p>You are making too many requests too fast, please slow down and wait {duration} seconds</p>', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782db9c0-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_security_2factorAuth_force', N'false', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dba1a-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_paging_maxrows', N'20', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dba74-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_security_rate_limiter_count', N'4', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dbace-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_security_max_attempts', N'5', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dbb28-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_admin_quicksearch_max', N'5', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dbc9a-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_comments_whoisURL', N'http://whois.arin.net/ui/query.do?q', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dbcf4-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_security_2factorAuth_provider', N'email', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dbd4e-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_security_max_auth_logs', N'500', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dbde4-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_dashboard_recentPages', N'5', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dbe5c-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_comments_moderation_blacklist', N'', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dbfe2-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_editors_default', N'ckeditor', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dc05a-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_site_mail_tls', N'false', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dc0d2-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_media_provider', N'CFContentMediaProvider', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dc24e-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_gravatar_display', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dc2c6-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_editors_ckeditor_extraplugins', N'cbKeyBinding,cbWidgets,cbLinks,cbEntryLinks,cbContentStore,cbIpsumLorem,wsc,mediaembed,insertpre,justify,colorbutton,showblocks,find,div,smiley,specialchar,iframe', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dc44c-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_site_email', N'', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dc5dc-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_notify_contentstore', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dc762-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_paging_maxRSSComments', N'10', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dcb72-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_media_provider_caching', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dd16c-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_site_blog_entrypoint', N'blog', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dd284-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_media_allowUploads', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dd36a-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_dashboard_welcome_body', N'', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dd432-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_media_directoryRoot', N'/contentbox-custom/_content', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dd504-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_search_maxResults', N'20', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dd5cc-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_security_rate_limiter_bots_only', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dd694-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_content_uiexport', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dd766-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_entry_caching', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dd9aa-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_content_hit_count', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dda9a-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_comments_moderation_whitelist', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782ddb8a-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_rss_caching', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782ddc7a-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_security_rate_limiter_redirectURL', N'', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782ddd6a-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_dashboard_recentEntries', N'5', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dde5a-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_rss_maxEntries', N'10', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782ddf40-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_cbBootswatchTheme', N'green', 0x00, '2020-09-09 17:34:50', '2020-09-09 17:34:50', 0x00, N'782de03a-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_overrideHeaderColors', N'false', 0x00, '2020-09-09 17:34:50', '2020-09-09 17:34:50', 0x00, N'782de18e-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_overrideHeaderBGColor', N'', 0x00, '2020-09-09 17:34:50', '2020-09-09 17:34:50', 0x00, N'782de472-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_overrideHeaderTextColor', N'', 0x00, '2020-09-09 17:34:50', '2020-09-09 17:34:50', 0x00, N'782de5c6-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_cssStyleOverrides', N'', 0x00, '2020-09-09 17:34:50', '2020-09-09 17:34:50', 0x00, N'782de6de-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_headerLogo', N'', 0x00, '2020-09-09 17:34:50', '2020-09-09 17:34:50', 0x00, N'782de7ec-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_showSiteSearch', N'true', 0x00, '2020-09-09 17:34:50', '2020-09-09 17:34:50', 0x00, N'782de8f0-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_footerBox', N'', 0x00, '2020-09-09 17:34:50', '2020-09-09 17:34:50', 0x00, N'782de9f4-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderTitle', N'', 0x00, '2020-09-09 17:34:50', '2020-09-09 17:34:50', 0x00, N'782deaf8-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderText', N'', 0x00, '2020-09-09 17:34:50', '2020-09-09 17:34:50', 0x00, N'782debf2-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderLink', N'', 0x00, '2020-09-09 17:34:50', '2020-09-09 17:34:50', 0x00, N'782decf6-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderBtnText', N'', 0x00, '2020-09-09 17:34:50', '2020-09-09 17:34:50', 0x00, N'782dedfa-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderBtnStyle', N'primary', 0x00, '2020-09-09 17:34:50', '2020-09-09 17:34:50', 0x00, N'782deefe-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderBg', N'green', 0x00, '2020-09-09 17:34:50', '2020-09-09 17:34:50', 0x00, N'782df00c-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderImgBg', N'', 0x00, '2020-09-09 17:34:50', '2020-09-09 17:34:50', 0x00, N'782df156-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderBgPos', N'Top Center', 0x00, '2020-09-09 17:34:50', '2020-09-09 17:34:50', 0x00, N'782df264-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderBgPaddingTop', N'100px', 0x00, '2020-09-09 17:34:50', '2020-09-09 17:34:50', 0x00, N'782df35e-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderBgPaddingBottom', N'50px', 0x00, '2020-09-09 17:34:51', '2020-09-09 17:34:51', 0x00, N'782df462-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_rssDiscovery', N'true', 0x00, '2020-09-09 17:34:51', '2020-09-09 17:34:51', 0x00, N'782df570-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_showCategoriesBlogSide', N'true', 0x00, '2020-09-09 17:34:51', '2020-09-09 17:34:51', 0x00, N'782df674-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_showRecentEntriesBlogSide', N'true', 0x00, '2020-09-09 17:34:51', '2020-09-09 17:34:51', 0x00, N'782df778-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_showSiteUpdatesBlogSide', N'true', 0x00, '2020-09-09 17:34:51', '2020-09-09 17:34:51', 0x00, N'782df872-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_showEntryCommentsBlogSide', N'true', 0x00, '2020-09-09 17:34:51', '2020-09-09 17:34:51', 0x00, N'782df976-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_showArchivesBlogSide', N'true', 0x00, '2020-09-09 17:34:51', '2020-09-09 17:34:51', 0x00, N'782dfa7a-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_showEntriesSearchBlogSide', N'true', 0x00, '2020-09-09 17:34:51', '2020-09-09 17:34:51', 0x00, N'782dfb7e-a444-11eb-ab6f-0290cc502ae3', N'1c81d376-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_active', N'true', 0x01, '2020-09-09 17:34:49', '2020-09-09 17:34:49', 0x00, N'782dfc82-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_enc_key', N'guxDy6/lBXEyt3kOkKtl7A==', 0x00, '2020-09-09 17:38:19', '2020-09-09 17:38:19', 0x00, N'782dfd86-a444-11eb-ab6f-0290cc502ae3', null)
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_cbBootswatchTheme', N'green', 0x00, '2021-02-18 17:46:22', '2021-02-18 17:46:22', 0x00, N'782dfe8a-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_overrideHeaderColors', N'false', 0x00, '2021-02-18 17:46:22', '2021-02-18 17:46:22', 0x00, N'782dff8e-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_overrideHeaderBGColor', N'', 0x00, '2021-02-18 17:46:22', '2021-02-18 17:46:22', 0x00, N'782e0092-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_overrideHeaderTextColor', N'', 0x00, '2021-02-18 17:46:22', '2021-02-18 17:46:22', 0x00, N'782e0196-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_cssStyleOverrides', N'', 0x00, '2021-02-18 17:46:22', '2021-02-18 17:46:22', 0x00, N'782e029a-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_headerLogo', N'', 0x00, '2021-02-18 17:46:22', '2021-02-18 17:46:22', 0x00, N'782e0394-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_showSiteSearch', N'true', 0x00, '2021-02-18 17:46:22', '2021-02-18 17:46:22', 0x00, N'782e0498-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_footerBox', N'', 0x00, '2021-02-18 17:46:23', '2021-02-18 17:46:23', 0x00, N'782e059c-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderTitle', N'', 0x00, '2021-02-18 17:46:23', '2021-02-18 17:46:23', 0x00, N'782e0696-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderText', N'', 0x00, '2021-02-18 17:46:23', '2021-02-18 17:46:23', 0x00, N'782e0790-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderLink', N'', 0x00, '2021-02-18 17:46:23', '2021-02-18 17:46:23', 0x00, N'782e088a-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderBtnText', N'', 0x00, '2021-02-18 17:46:23', '2021-02-18 17:46:23', 0x00, N'782e098e-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderBtnStyle', N'primary', 0x00, '2021-02-18 17:46:23', '2021-02-18 17:46:23', 0x00, N'782e0a92-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderBg', N'green', 0x00, '2021-02-18 17:46:23', '2021-02-18 17:46:23', 0x00, N'782e0b00-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderImgBg', N'', 0x00, '2021-02-18 17:46:23', '2021-02-18 17:46:23', 0x00, N'782e0b64-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderBgPos', N'Top Center', 0x00, '2021-02-18 17:46:23', '2021-02-18 17:46:23', 0x00, N'782e0bc8-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderBgPaddingTop', N'100px', 0x00, '2021-02-18 17:46:23', '2021-02-18 17:46:23', 0x00, N'782e0c2c-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_hpHeaderBgPaddingBottom', N'50px', 0x00, '2021-02-18 17:46:23', '2021-02-18 17:46:23', 0x00, N'782e0c90-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_rssDiscovery', N'true', 0x00, '2021-02-18 17:46:23', '2021-02-18 17:46:23', 0x00, N'782e0cf4-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_showCategoriesBlogSide', N'true', 0x00, '2021-02-18 17:46:23', '2021-02-18 17:46:23', 0x00, N'782e0d58-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_showRecentEntriesBlogSide', N'true', 0x00, '2021-02-18 17:46:23', '2021-02-18 17:46:23', 0x00, N'782e0dbc-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_showSiteUpdatesBlogSide', N'true', 0x00, '2021-02-18 17:46:23', '2021-02-18 17:46:23', 0x00, N'782e0e20-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_showEntryCommentsBlogSide', N'true', 0x00, '2021-02-18 17:46:23', '2021-02-18 17:46:23', 0x00, N'782e0e84-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_showArchivesBlogSide', N'true', 0x00, '2021-02-18 17:46:23', '2021-02-18 17:46:23', 0x00, N'782e0ef2-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_setting(name, value, isCore, createdDate, modifiedDate, isDeleted, settingID, FK_siteID) VALUES (N'cb_theme_default_showEntriesSearchBlogSide', N'true', 0x00, '2021-02-18 17:46:23', '2021-02-18 17:46:23', 0x00, N'782e0f56-a444-11eb-ab6f-0290cc502ae3', N'1c81d574-a481-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_site(siteID, createdDate, modifiedDate, isDeleted, name, slug, description, domainRegex, keywords, tagline, homepage, isBlogEnabled, isSitemapEnabled, poweredByHeader, adminBar, isSSL, activeTheme, notificationEmails, notifyOnEntries, notifyOnPages, notifyOnContentStore, domain, isActive) VALUES (N'1c81d376-a481-11eb-ab6f-0290cc502ae3', '2020-09-09 17:16:59', '2021-02-18 18:15:53', 0x00, N'Default Site', N'default', N'My Awesome Site', N'127\.0\.0\.1', N'', N'My Awesome Site', N'support', 0x01, 0x01, 0x01, 0x01, 0x00, N'default', N'lmajano@gmail.com', 0x01, 0x01, 0x01, N'127.0.0.1', 0x01)
GO
INSERT INTO cb_site(siteID, createdDate, modifiedDate, isDeleted, name, slug, description, domainRegex, keywords, tagline, homepage, isBlogEnabled, isSitemapEnabled, poweredByHeader, adminBar, isSSL, activeTheme, notificationEmails, notifyOnEntries, notifyOnPages, notifyOnContentStore, domain, isActive) VALUES (N'1c81d574-a481-11eb-ab6f-0290cc502ae3', '2021-02-18 17:44:50', '2021-02-18 17:44:50', 0x00, N'Development Site', N'development', N'A development site', N'localhost', N'', N'', N'cbBlog', 0x01, 0x01, 0x01, 0x01, 0x00, N'default', N'', 0x01, 0x01, 0x01, N'localhost', 0x01)
GO
INSERT INTO cb_site(siteID, createdDate, modifiedDate, isDeleted, name, slug, description, domainRegex, keywords, tagline, homepage, isBlogEnabled, isSitemapEnabled, poweredByHeader, adminBar, isSSL, activeTheme, notificationEmails, notifyOnEntries, notifyOnPages, notifyOnContentStore, domain, isActive) VALUES (N'ff80808179100916017914e9c96a0039', '2021-04-27 14:58:56', '2021-04-27 15:58:24', 0x00, N'Test Disabled', N'test-disabled', N'test-disabled', N'google.com', N'', N'test-disabled', N'cbBlog', 0x01, 0x01, 0x01, 0x01, 0x00, N'default', N'', 0x01, 0x01, 0x01, N'google.com', 0x00)
GO
INSERT INTO cb_stats(hits, createdDate, modifiedDate, isDeleted, statsID, FK_contentID) VALUES (10, '2016-05-03 16:23:26', '2021-02-19 10:51:56', 0x00, N'78468572-a444-11eb-ab6f-0290cc502ae3', N'779cd8b0-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_stats(hits, createdDate, modifiedDate, isDeleted, statsID, FK_contentID) VALUES (3, '2016-05-03 16:23:26', '2021-02-19 10:51:59', 0x00, N'784686bc-a444-11eb-ab6f-0290cc502ae3', N'779cd950-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_stats(hits, createdDate, modifiedDate, isDeleted, statsID, FK_contentID) VALUES (5, '2016-05-03 16:23:26', '2021-02-19 10:52:00', 0x00, N'78468752-a444-11eb-ab6f-0290cc502ae3', N'779cd806-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_stats(hits, createdDate, modifiedDate, isDeleted, statsID, FK_contentID) VALUES (129, '2016-05-03 16:23:26', '2021-02-19 10:54:50', 0x00, N'784687fc-a444-11eb-ab6f-0290cc502ae3', N'779cd2de-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_stats(hits, createdDate, modifiedDate, isDeleted, statsID, FK_contentID) VALUES (4, '2016-05-03 16:23:26', '2021-02-19 10:52:03', 0x00, N'78468874-a444-11eb-ab6f-0290cc502ae3', N'779cd4dc-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_stats(hits, createdDate, modifiedDate, isDeleted, statsID, FK_contentID) VALUES (1, '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'784688d8-a444-11eb-ab6f-0290cc502ae3', N'779cd432-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_stats(hits, createdDate, modifiedDate, isDeleted, statsID, FK_contentID) VALUES (4, '2016-05-18 11:35:32', '2021-02-19 10:51:51', 0x00, N'78468946-a444-11eb-ab6f-0290cc502ae3', N'779cdb4e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_stats(hits, createdDate, modifiedDate, isDeleted, statsID, FK_contentID) VALUES (5, '2016-05-18 11:35:32', '2021-02-19 10:51:43', 0x00, N'784689b4-a444-11eb-ab6f-0290cc502ae3', N'779cdf22-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_stats(hits, createdDate, modifiedDate, isDeleted, statsID, FK_contentID) VALUES (1, '2016-05-18 11:48:04', '2016-05-18 11:48:04', 0x00, N'78468a18-a444-11eb-ab6f-0290cc502ae3', N'779cd9fa-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_stats(hits, createdDate, modifiedDate, isDeleted, statsID, FK_contentID) VALUES (10, '2016-08-05 11:41:28', '2021-02-19 10:53:28', 0x00, N'78468a7c-a444-11eb-ab6f-0290cc502ae3', N'779cd18a-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_stats(hits, createdDate, modifiedDate, isDeleted, statsID, FK_contentID) VALUES (33, '2016-11-28 14:56:53', '2021-05-05 20:15:29', 0x00, N'78468aea-a444-11eb-ab6f-0290cc502ae3', N'779cd234-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_stats(hits, createdDate, modifiedDate, isDeleted, statsID, FK_contentID) VALUES (1, '2021-02-19 10:53:24', '2021-02-19 10:53:24', 0x00, N'78468b4e-a444-11eb-ab6f-0290cc502ae3', N'779cd0ea-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_stats(hits, createdDate, modifiedDate, isDeleted, statsID, FK_contentID) VALUES (1, '2021-02-19 10:53:35', '2021-02-19 10:53:35', 0x00, N'78468bb2-a444-11eb-ab6f-0290cc502ae3', N'779ccb0e-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_subscribers(subscriberEmail, subscriberToken, createdDate, modifiedDate, isDeleted, subscriberID) VALUES (N'lmajano@ortussolutions.com', N'9160905AD002614B9A06E7A59F6F137F', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'78205bf4-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_subscribers(subscriberEmail, subscriberToken, createdDate, modifiedDate, isDeleted, subscriberID) VALUES (N'lmajano@gmail.com', N'28B937F6F2F970189DB7ED3C909DE922', '2016-05-03 16:23:26', '2016-05-03 16:23:26', 0x00, N'78205d52-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_subscriptions(subscriptionToken, type, createdDate, modifiedDate, isDeleted, subscriptionID, FK_subscriberID) VALUES (N'AD2669C5064D113531970A672B887743', N'Comment', '2015-08-04 16:17:43', '2016-05-03 16:23:25', 0x00, N'77e3796e-a444-11eb-ab6f-0290cc502ae3', N'78205d52-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_subscriptions(subscriptionToken, type, createdDate, modifiedDate, isDeleted, subscriptionID, FK_subscriberID) VALUES (N'E880B3507068855A1EA3D333021267B3', N'Comment', '2016-05-11 16:12:34', '2016-05-11 16:12:34', 0x00, N'77e37aae-a444-11eb-ab6f-0290cc502ae3', N'78205d52-a444-11eb-ab6f-0290cc502ae3')
GO
INSERT INTO cb_subscriptions(subscriptionToken, type, createdDate, modifiedDate, isDeleted, subscriptionID, FK_subscriberID) VALUES (N'CB8797B8A3C80D045D232DA79C9E6FD9', N'Comment', '2016-05-12 12:34:18', '2016-05-12 12:34:18', 0x00, N'77e37b80-a444-11eb-ab6f-0290cc502ae3', N'78205bf4-a444-11eb-ab6f-0290cc502ae3')
GO
ALTER TABLE cb_author
	ADD FOREIGN KEY (FK_roleID)
	REFERENCES cb_role (roleID)
GO


ALTER TABLE cb_authorpermissiongroups
	ADD FOREIGN KEY (FK_authorID)
	REFERENCES cb_author (authorID)
GO

ALTER TABLE cb_authorpermissiongroups
	ADD FOREIGN KEY (FK_permissionGroupID)
	REFERENCES cb_permissiongroup (permissionGroupID)
GO


ALTER TABLE cb_authorpermissions
	ADD FOREIGN KEY (FK_authorID)
	REFERENCES cb_author (authorID)
GO

ALTER TABLE cb_authorpermissions
	ADD FOREIGN KEY (FK_permissionID)
	REFERENCES cb_permission (permissionID)
GO


ALTER TABLE cb_category
	ADD FOREIGN KEY (FK_siteID)
	REFERENCES cb_site (siteID)
GO


ALTER TABLE cb_comment
	ADD FOREIGN KEY (FK_contentID)
	REFERENCES cb_content (contentID)
GO


ALTER TABLE cb_commentsubscriptions
	ADD FOREIGN KEY (FK_contentID)
	REFERENCES cb_content (contentID)
GO

ALTER TABLE cb_commentsubscriptions
	ADD FOREIGN KEY (subscriptionID)
	REFERENCES cb_subscriptions (subscriptionID)
GO


ALTER TABLE cb_content
	ADD FOREIGN KEY (FK_siteID)
	REFERENCES cb_site (siteID)
GO

ALTER TABLE cb_content
	ADD FOREIGN KEY (FK_authorID)
	REFERENCES cb_author (authorID)
GO

ALTER TABLE cb_content
	ADD FOREIGN KEY (FK_parentID)
	REFERENCES cb_content (contentID)
GO


ALTER TABLE cb_contentcategories
	ADD FOREIGN KEY (FK_categoryID)
	REFERENCES cb_category (categoryID)
GO

ALTER TABLE cb_contentcategories
	ADD FOREIGN KEY (FK_contentID)
	REFERENCES cb_content (contentID)
GO


ALTER TABLE cb_contentstore
	ADD FOREIGN KEY (contentID)
	REFERENCES cb_content (contentID)
GO


ALTER TABLE cb_contentversion
	ADD FOREIGN KEY (FK_authorID)
	REFERENCES cb_author (authorID)
GO

ALTER TABLE cb_contentversion
	ADD FOREIGN KEY (FK_contentID)
	REFERENCES cb_content (contentID)
GO


ALTER TABLE cb_customfield
	ADD FOREIGN KEY (FK_contentID)
	REFERENCES cb_content (contentID)
GO


ALTER TABLE cb_entry
	ADD FOREIGN KEY (contentID)
	REFERENCES cb_content (contentID)
GO


ALTER TABLE cb_grouppermissions
	ADD FOREIGN KEY (FK_permissionGroupID)
	REFERENCES cb_permissiongroup (permissionGroupID)
GO

ALTER TABLE cb_grouppermissions
	ADD FOREIGN KEY (FK_permissionID)
	REFERENCES cb_permission (permissionID)
GO


ALTER TABLE cb_menu
	ADD FOREIGN KEY (FK_siteID)
	REFERENCES cb_site (siteID)
GO


ALTER TABLE cb_menuitem
	ADD FOREIGN KEY (FK_menuID)
	REFERENCES cb_menu (menuID)
GO

ALTER TABLE cb_menuitem
	ADD FOREIGN KEY (FK_parentID)
	REFERENCES cb_menuitem (menuItemID)
GO


ALTER TABLE cb_page
	ADD FOREIGN KEY (contentID)
	REFERENCES cb_content (contentID)
GO


ALTER TABLE cb_relatedcontent
	ADD FOREIGN KEY (FK_contentID)
	REFERENCES cb_content (contentID)
GO

ALTER TABLE cb_relatedcontent
	ADD FOREIGN KEY (FK_relatedContentID)
	REFERENCES cb_content (contentID)
GO


ALTER TABLE cb_rolepermissions
	ADD FOREIGN KEY (FK_permissionID)
	REFERENCES cb_permission (permissionID)
GO

ALTER TABLE cb_rolepermissions
	ADD FOREIGN KEY (FK_roleID)
	REFERENCES cb_role (roleID)
GO


ALTER TABLE cb_setting
	ADD FOREIGN KEY (FK_siteID)
	REFERENCES cb_site (siteID)
GO


ALTER TABLE cb_stats
	ADD FOREIGN KEY (FK_contentID)
	REFERENCES cb_content (contentID)
GO


ALTER TABLE cb_subscriptions
	ADD FOREIGN KEY (FK_subscriberID)
	REFERENCES cb_subscribers (subscriberID)
GO
