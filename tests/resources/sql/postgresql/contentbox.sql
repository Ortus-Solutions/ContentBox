/*
 Navicat Premium Data Transfer

 Source Server         : contentbox-docker-postgresql
 Source Server Type    : PostgreSQL
 Source Server Version : 120006
 Source Host           : localhost:5432
 Source Catalog        : contentbox
 Source Schema         : contentbox

 Target Server Type    : PostgreSQL
 Target Server Version : 120006
 File Encoding         : 65001

 Date: 04/06/2021 15:35:41
*/


-- ----------------------------
-- Table structure for cb_author
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_author";
CREATE TABLE "contentbox"."cb_author" (
  "authorid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createddate" timestamp(6) NOT NULL,
  "modifieddate" timestamp(6) NOT NULL,
  "isdeleted" bool NOT NULL DEFAULT false,
  "firstname" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "lastname" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "email" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "username" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "password" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "isactive" bool NOT NULL,
  "lastlogin" timestamp(6),
  "biography" text COLLATE "pg_catalog"."default",
  "preferences" text COLLATE "pg_catalog"."default",
  "ispasswordreset" bool NOT NULL DEFAULT false,
  "is2factorauth" bool NOT NULL DEFAULT false,
  "fk_roleid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "contentbox"."cb_author" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_author
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_authorpermissiongroups
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_authorpermissiongroups";
CREATE TABLE "contentbox"."cb_authorpermissiongroups" (
  "fk_permissiongroupid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "fk_authorid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "contentbox"."cb_authorpermissiongroups" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_authorpermissiongroups
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_authorpermissions
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_authorpermissions";
CREATE TABLE "contentbox"."cb_authorpermissions" (
  "fk_authorid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "fk_permissionid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "contentbox"."cb_authorpermissions" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_authorpermissions
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_category
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_category";
CREATE TABLE "contentbox"."cb_category" (
  "categoryid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createddate" timestamp(6) NOT NULL,
  "modifieddate" timestamp(6) NOT NULL,
  "isdeleted" bool NOT NULL DEFAULT false,
  "category" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "slug" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "fk_siteid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "contentbox"."cb_category" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_category
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_comment
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_comment";
CREATE TABLE "contentbox"."cb_comment" (
  "commentid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createddate" timestamp(6) NOT NULL,
  "modifieddate" timestamp(6) NOT NULL,
  "isdeleted" bool NOT NULL DEFAULT false,
  "content" text COLLATE "pg_catalog"."default" NOT NULL,
  "author" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "authorip" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "authoremail" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "authorurl" varchar(255) COLLATE "pg_catalog"."default",
  "isapproved" bool NOT NULL DEFAULT false,
  "fk_contentid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "contentbox"."cb_comment" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_comment
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_commentsubscriptions
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_commentsubscriptions";
CREATE TABLE "contentbox"."cb_commentsubscriptions" (
  "subscriptionid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "fk_contentid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "contentbox"."cb_commentsubscriptions" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_commentsubscriptions
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_content
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_content";
CREATE TABLE "contentbox"."cb_content" (
  "contentid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "contenttype" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createddate" timestamp(6) NOT NULL,
  "modifieddate" timestamp(6) NOT NULL,
  "isdeleted" bool NOT NULL DEFAULT false,
  "title" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "slug" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "publisheddate" timestamp(6),
  "expiredate" timestamp(6),
  "ispublished" bool NOT NULL DEFAULT true,
  "allowcomments" bool NOT NULL DEFAULT true,
  "passwordprotection" varchar(100) COLLATE "pg_catalog"."default",
  "htmlkeywords" varchar(160) COLLATE "pg_catalog"."default",
  "htmldescription" varchar(160) COLLATE "pg_catalog"."default",
  "htmltitle" varchar(255) COLLATE "pg_catalog"."default",
  "cache" bool NOT NULL DEFAULT true,
  "cachelayout" bool NOT NULL DEFAULT true,
  "cachetimeout" int4,
  "cachelastaccesstimeout" int4,
  "markup" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "showinsearch" bool NOT NULL DEFAULT true,
  "featuredimage" varchar(255) COLLATE "pg_catalog"."default",
  "featuredimageurl" varchar(255) COLLATE "pg_catalog"."default",
  "fk_authorid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "fk_siteid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "fk_parentid" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "contentbox"."cb_content" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_content
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_contentcategories
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_contentcategories";
CREATE TABLE "contentbox"."cb_contentcategories" (
  "fk_contentid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "fk_categoryid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "contentbox"."cb_contentcategories" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_contentcategories
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_contentstore
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_contentstore";
CREATE TABLE "contentbox"."cb_contentstore" (
  "contentid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "description" varchar(500) COLLATE "pg_catalog"."default",
  "order" int4 DEFAULT 0
)
;
ALTER TABLE "contentbox"."cb_contentstore" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_contentstore
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_contentversion
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_contentversion";
CREATE TABLE "contentbox"."cb_contentversion" (
  "contentversionid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createddate" timestamp(6) NOT NULL,
  "modifieddate" timestamp(6) NOT NULL,
  "isdeleted" bool NOT NULL DEFAULT false,
  "content" text COLLATE "pg_catalog"."default" NOT NULL,
  "changelog" text COLLATE "pg_catalog"."default",
  "version" int4 NOT NULL,
  "isactive" bool NOT NULL DEFAULT false,
  "fk_authorid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "fk_contentid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "contentbox"."cb_contentversion" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_contentversion
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_customfield
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_customfield";
CREATE TABLE "contentbox"."cb_customfield" (
  "customfieldid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createddate" timestamp(6) NOT NULL,
  "modifieddate" timestamp(6) NOT NULL,
  "isdeleted" bool NOT NULL DEFAULT false,
  "key" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "value" text COLLATE "pg_catalog"."default" NOT NULL,
  "fk_contentid" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "contentbox"."cb_customfield" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_customfield
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_entry
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_entry";
CREATE TABLE "contentbox"."cb_entry" (
  "contentid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "excerpt" text COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "contentbox"."cb_entry" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_entry
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_grouppermissions
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_grouppermissions";
CREATE TABLE "contentbox"."cb_grouppermissions" (
  "fk_permissiongroupid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "fk_permissionid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "contentbox"."cb_grouppermissions" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_grouppermissions
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_loginattempts
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_loginattempts";
CREATE TABLE "contentbox"."cb_loginattempts" (
  "loginattemptsid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createddate" timestamp(6) NOT NULL,
  "modifieddate" timestamp(6) NOT NULL,
  "isdeleted" bool NOT NULL DEFAULT false,
  "value" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "attempts" int4 NOT NULL,
  "lastloginsuccessip" varchar(100) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "contentbox"."cb_loginattempts" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_loginattempts
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_menu
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_menu";
CREATE TABLE "contentbox"."cb_menu" (
  "menuid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createddate" timestamp(6) NOT NULL,
  "modifieddate" timestamp(6) NOT NULL,
  "isdeleted" bool NOT NULL DEFAULT false,
  "title" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "slug" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "menuclass" varchar(160) COLLATE "pg_catalog"."default",
  "listclass" varchar(160) COLLATE "pg_catalog"."default",
  "listtype" varchar(20) COLLATE "pg_catalog"."default",
  "fk_siteid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "contentbox"."cb_menu" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_menu
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_menuitem
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_menuitem";
CREATE TABLE "contentbox"."cb_menuitem" (
  "menuitemid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "menutype" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createddate" timestamp(6) NOT NULL,
  "modifieddate" timestamp(6) NOT NULL,
  "isdeleted" bool NOT NULL DEFAULT false,
  "title" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "label" varchar(200) COLLATE "pg_catalog"."default",
  "itemclass" varchar(200) COLLATE "pg_catalog"."default",
  "data" varchar(255) COLLATE "pg_catalog"."default",
  "active" bool DEFAULT true,
  "fk_menuid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "fk_parentid" varchar(255) COLLATE "pg_catalog"."default",
  "mediapath" varchar(255) COLLATE "pg_catalog"."default",
  "target" varchar(255) COLLATE "pg_catalog"."default",
  "urlclass" varchar(255) COLLATE "pg_catalog"."default",
  "menuslug" varchar(255) COLLATE "pg_catalog"."default",
  "contentslug" varchar(255) COLLATE "pg_catalog"."default",
  "js" varchar(255) COLLATE "pg_catalog"."default",
  "url" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "contentbox"."cb_menuitem" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_menuitem
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_module
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_module";
CREATE TABLE "contentbox"."cb_module" (
  "moduleid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createddate" timestamp(6) NOT NULL,
  "modifieddate" timestamp(6) NOT NULL,
  "isdeleted" bool NOT NULL DEFAULT false,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "title" varchar(255) COLLATE "pg_catalog"."default",
  "version" varchar(255) COLLATE "pg_catalog"."default",
  "entrypoint" varchar(255) COLLATE "pg_catalog"."default",
  "author" varchar(255) COLLATE "pg_catalog"."default",
  "weburl" varchar(500) COLLATE "pg_catalog"."default",
  "forgeboxslug" varchar(255) COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "isactive" bool NOT NULL DEFAULT false,
  "moduletype" varchar(255) COLLATE "pg_catalog"."default" DEFAULT 'unknown'::character varying
)
;
ALTER TABLE "contentbox"."cb_module" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_module
-- ----------------------------
BEGIN;
INSERT INTO "contentbox"."cb_module" VALUES ('ff80808179d7a8250179d7af3fb70157', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'Hello', 'HelloContentBox', '', 'HelloContentBox', 'Ortus Solutions, Corp', 'https://www.ortussolutions.com', '', 'This is an awesome hello world module', 'f', 'core');
COMMIT;

-- ----------------------------
-- Table structure for cb_page
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_page";
CREATE TABLE "contentbox"."cb_page" (
  "contentid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "layout" varchar(200) COLLATE "pg_catalog"."default",
  "order" int4,
  "showinmenu" bool NOT NULL DEFAULT true,
  "excerpt" text COLLATE "pg_catalog"."default",
  "sslonly" bool NOT NULL DEFAULT false
)
;
ALTER TABLE "contentbox"."cb_page" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_page
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_permission
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_permission";
CREATE TABLE "contentbox"."cb_permission" (
  "permissionid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createddate" timestamp(6) NOT NULL,
  "modifieddate" timestamp(6) NOT NULL,
  "isdeleted" bool NOT NULL DEFAULT false,
  "permission" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "description" varchar(500) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "contentbox"."cb_permission" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_permission
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_permissiongroup
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_permissiongroup";
CREATE TABLE "contentbox"."cb_permissiongroup" (
  "permissiongroupid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createddate" timestamp(6) NOT NULL,
  "modifieddate" timestamp(6) NOT NULL,
  "isdeleted" bool NOT NULL DEFAULT false,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "description" varchar(500) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "contentbox"."cb_permissiongroup" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_permissiongroup
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_relatedcontent
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_relatedcontent";
CREATE TABLE "contentbox"."cb_relatedcontent" (
  "fk_contentid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "fk_relatedcontentid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "contentbox"."cb_relatedcontent" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_relatedcontent
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_role
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_role";
CREATE TABLE "contentbox"."cb_role" (
  "roleid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createddate" timestamp(6) NOT NULL,
  "modifieddate" timestamp(6) NOT NULL,
  "isdeleted" bool NOT NULL DEFAULT false,
  "role" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "description" varchar(500) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "contentbox"."cb_role" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_role
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_rolepermissions
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_rolepermissions";
CREATE TABLE "contentbox"."cb_rolepermissions" (
  "fk_roleid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "fk_permissionid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "contentbox"."cb_rolepermissions" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_rolepermissions
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_securityrule
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_securityrule";
CREATE TABLE "contentbox"."cb_securityrule" (
  "ruleid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createddate" timestamp(6) NOT NULL,
  "modifieddate" timestamp(6) NOT NULL,
  "isdeleted" bool NOT NULL DEFAULT false,
  "whitelist" varchar(255) COLLATE "pg_catalog"."default",
  "securelist" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "match" varchar(50) COLLATE "pg_catalog"."default" DEFAULT 'event'::character varying,
  "roles" varchar(255) COLLATE "pg_catalog"."default",
  "permissions" varchar(500) COLLATE "pg_catalog"."default",
  "redirect" varchar(500) COLLATE "pg_catalog"."default",
  "overrideevent" varchar(500) COLLATE "pg_catalog"."default",
  "usessl" bool DEFAULT false,
  "action" varchar(50) COLLATE "pg_catalog"."default" DEFAULT 'redirect'::character varying,
  "module" varchar(500) COLLATE "pg_catalog"."default",
  "order" int4 NOT NULL,
  "message" varchar(255) COLLATE "pg_catalog"."default",
  "messagetype" varchar(50) COLLATE "pg_catalog"."default" DEFAULT 'info'::character varying
)
;
ALTER TABLE "contentbox"."cb_securityrule" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_securityrule
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_setting
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_setting";
CREATE TABLE "contentbox"."cb_setting" (
  "settingid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createddate" timestamp(6) NOT NULL,
  "modifieddate" timestamp(6) NOT NULL,
  "isdeleted" bool NOT NULL DEFAULT false,
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "value" text COLLATE "pg_catalog"."default" NOT NULL,
  "iscore" bool NOT NULL DEFAULT false,
  "fk_siteid" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "contentbox"."cb_setting" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_setting
-- ----------------------------
BEGIN;
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3cda00f5', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_security_login_blocker', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3cdd00f6', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_media_allowDelete', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3ce100f7', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_security_login_signin_text', '', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3ce400f8', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_versions_max_history', '', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3ce800f9', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_security_rate_limiter_duration', '1', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3ceb00fa', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_rss_description', 'ContentBox RSS Feed', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3cee00fb', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_media_html5uploads_maxFiles', '25', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3cf100fc', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_site_mail_password', '', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3cf500fd', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_rss_cacheName', 'Template', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3cf900fe', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_editors_markup', 'HTML', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3cfd00ff', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_content_cacheName', 'Template', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d000100', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_editors_ckeditor_toolbar', '[
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
		]', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d050101', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_security_rate_limiter_logging', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d080102', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_site_settings_cache', 'template', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d0c0103', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_versions_commit_mandatory', 'false', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d100104', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_notify_page', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d140105', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_site_mail_username', '', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d180106', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_rss_webmaster', '', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d1b0107', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_rss_title', 'RSS Feed by ContentBox', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d1f0108', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_media_acceptMimeTypes', '', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d220109', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_notify_author', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d26010a', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_dashboard_welcome_title', 'Dashboard', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d29010b', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_page_excerpts', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d2d010c', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_site_outgoingEmail', '', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d30010d', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_dashboard_newsfeed', 'https://www.ortussolutions.com/blog/rss', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d33010e', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_media_createFolders', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d37010f', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_security_min_password_length', '8', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d3a0110', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_dashboard_newsfeed_count', '5', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d3d0111', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_rss_cachingTimeout', '60', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d410112', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_content_cachingTimeoutIdle', '15', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d450113', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_media_html5uploads_maxFileSize', '100', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d490114', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_salt', '293EFDF475FF2E5B267D34554D34488C84368C61C2B6A37168E42F131D205F0BD2A094D09ED80835BDE20379A299C67C65DB131DD0B1F04B155C39E56DC189EC', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d4c0115', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_site_mail_server', '', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d500116', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_media_quickViewWidth', '400', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d530117', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_security_2factorAuth_trusted_days', '30', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d560118', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_rss_generator', 'ContentBox by Ortus Solutions', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d5a0119', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_content_bot_regex', 'Google|msnbot|Rambler|Yahoo|AbachoBOT|accoona|AcioRobot|ASPSeek|CocoCrawler|Dumbot|FAST-WebCrawler|GeonaBot|Gigabot|Lycos|MSRBOT|Scooter|AltaVista|IDBot|eStyle|Scrubby', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d5e011a', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_editors_ckeditor_excerpt_toolbar', '[
		{ "name": "document",    "items" : [ "Source","-","Maximize","ShowBlocks" ] },
		{ "name": "basicstyles", "items" : [ "Bold","Italic","Underline","Strike","Subscript","Superscript"] },
		{ "name": "paragraph",   "items" : [ "NumberedList","BulletedList","-","Outdent","Indent","CreateDiv"] },
		{ "name": "links",       "items" : [ "Link","Unlink","Anchor" ] },
		{ "name": "insert",      "items" : [ "Image","Flash","Table","HorizontalRule","Smiley","SpecialChar" ] },
		{ "name": "contentbox",  "items" : [ "MediaEmbed","cbIpsumLorem","cbWidgets","cbContentStore","cbLinks","cbEntryLinks" ] }
		]', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d61011b', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_security_blocktime', '5', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d65011c', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_contentstore_caching', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d69011d', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_gravatar_rating', 'PG', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d6c011e', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_site_maintenance_message', '<h1>This site is down for maintenance.<br /> Please check back again soon.</h1>', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d70011f', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_admin_theme', 'contentbox-default', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d730120', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_dashboard_recentcontentstore', '5', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d770121', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_content_cachingTimeout', '60', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d7b0122', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_security_login_signout_url', '', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d7e0123', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_site_mail_ssl', 'false', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d820124', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_paging_bandgap', '5', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d850125', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_rss_maxComments', '10', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d890126', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_security_rate_limiter', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d8d0127', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_media_allowDownloads', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d900128', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_content_caching', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d940129', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_content_hit_ignore_bots', 'false', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d97012a', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_rss_copyright', 'Ortus Solutions, Corp (www.ortussolutions.com)', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d9b012b', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_site_maintenance', 'false', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3d9f012c', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_rss_cachingTimeoutIdle', '15', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3da2012d', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_admin_ssl', 'false', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3da6012e', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_paging_maxentries', '10', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3da9012f', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_dashboard_recentComments', '5', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3dad0130', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_security_latest_logins', '10', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3db00131', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_content_cachingHeader', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3db40132', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_search_adapter', 'contentbox.models.search.DBSearch', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3db80133', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_security_password_reset_expiration', '60', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3dbc0134', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_notify_entry', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3dbf0135', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_site_mail_smtp', '25', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3dc20136', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_security_rate_limiter_message', '<p>You are making too many requests too fast, please slow down and wait {duration} seconds</p>', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3dc60137', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_security_2factorAuth_force', 'false', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3dc90138', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_paging_maxrows', '20', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3dcd0139', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_security_rate_limiter_count', '4', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3dd1013a', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_security_max_attempts', '5', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3dd5013b', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_admin_quicksearch_max', '5', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3dd8013c', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_comments_whoisURL', 'http://whois.arin.net/ui/query.do?q', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3ddc013d', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_security_2factorAuth_provider', 'email', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3de0013e', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_security_max_auth_logs', '500', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3de4013f', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_dashboard_recentPages', '5', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3de70140', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_editors_default', 'ckeditor', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3deb0141', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_site_mail_tls', 'false', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3def0142', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_version', '@version.number@+@build.number@', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3df20143', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_media_provider', 'CFContentMediaProvider', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3df60144', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_gravatar_display', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3dfa0145', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_editors_ckeditor_extraplugins', 'cbKeyBinding,cbWidgets,cbLinks,cbEntryLinks,cbContentStore,cbIpsumLorem,wsc,mediaembed,insertpre,justify,colorbutton,showblocks,find,div,smiley,specialchar,iframe', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3dfe0146', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_site_email', '', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3e010147', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_notify_contentstore', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3e050148', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_paging_maxRSSComments', '10', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3e080149', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_media_provider_caching', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3e0b014a', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_site_blog_entrypoint', 'blog', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3e0f014b', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_media_allowUploads', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3e13014c', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_dashboard_welcome_body', '', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3e17014d', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_media_directoryRoot', '/contentbox-custom/_content', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3e1b014e', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_search_maxResults', '20', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3e1f014f', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_security_rate_limiter_bots_only', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3e230150', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_content_uiexport', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3e270151', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_entry_caching', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3e2a0152', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_content_hit_count', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3e2e0153', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_rss_caching', 'true', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3e320154', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_security_rate_limiter_redirectURL', '', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3e360155', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_dashboard_recentEntries', '5', 't', NULL);
INSERT INTO "contentbox"."cb_setting" VALUES ('ff80808179d7a8250179d7af3e390156', '2021-06-04 10:40:57', '2021-06-04 10:40:57', 'f', 'cb_rss_maxEntries', '10', 't', NULL);
COMMIT;

-- ----------------------------
-- Table structure for cb_site
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_site";
CREATE TABLE "contentbox"."cb_site" (
  "siteid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createddate" timestamp(6) NOT NULL,
  "modifieddate" timestamp(6) NOT NULL,
  "isdeleted" bool NOT NULL DEFAULT false,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "slug" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "description" varchar(500) COLLATE "pg_catalog"."default",
  "keywords" varchar(255) COLLATE "pg_catalog"."default",
  "domain" varchar(255) COLLATE "pg_catalog"."default",
  "domainregex" varchar(255) COLLATE "pg_catalog"."default",
  "tagline" varchar(255) COLLATE "pg_catalog"."default",
  "homepage" varchar(255) COLLATE "pg_catalog"."default",
  "isblogenabled" bool NOT NULL DEFAULT true,
  "issitemapenabled" bool NOT NULL DEFAULT true,
  "poweredbyheader" bool NOT NULL DEFAULT true,
  "adminbar" bool NOT NULL DEFAULT true,
  "isssl" bool NOT NULL DEFAULT false,
  "isactive" bool NOT NULL DEFAULT true,
  "activetheme" varchar(255) COLLATE "pg_catalog"."default",
  "notificationemails" varchar(500) COLLATE "pg_catalog"."default",
  "notifyonentries" bool NOT NULL DEFAULT true,
  "notifyonpages" bool NOT NULL DEFAULT true,
  "notifyoncontentstore" bool NOT NULL DEFAULT true
)
;
ALTER TABLE "contentbox"."cb_site" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_site
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_stats
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_stats";
CREATE TABLE "contentbox"."cb_stats" (
  "statsid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createddate" timestamp(6) NOT NULL,
  "modifieddate" timestamp(6) NOT NULL,
  "isdeleted" bool NOT NULL DEFAULT false,
  "hits" int8,
  "fk_contentid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "contentbox"."cb_stats" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_stats
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_subscribers
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_subscribers";
CREATE TABLE "contentbox"."cb_subscribers" (
  "subscriberid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createddate" timestamp(6) NOT NULL,
  "modifieddate" timestamp(6) NOT NULL,
  "isdeleted" bool NOT NULL DEFAULT false,
  "subscriberemail" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "subscribertoken" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "contentbox"."cb_subscribers" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_subscribers
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for cb_subscriptions
-- ----------------------------
DROP TABLE IF EXISTS "contentbox"."cb_subscriptions";
CREATE TABLE "contentbox"."cb_subscriptions" (
  "subscriptionid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createddate" timestamp(6) NOT NULL,
  "modifieddate" timestamp(6) NOT NULL,
  "isdeleted" bool NOT NULL DEFAULT false,
  "subscriptiontoken" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "type" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "fk_subscriberid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "contentbox"."cb_subscriptions" OWNER TO "contentbox";

-- ----------------------------
-- Records of cb_subscriptions
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Indexes structure for table cb_author
-- ----------------------------
CREATE INDEX "idx_2factorauth" ON "contentbox"."cb_author" USING btree (
  "is2factorauth" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE INDEX "idx_activeauthor" ON "contentbox"."cb_author" USING btree (
  "isactive" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE INDEX "idx_email" ON "contentbox"."cb_author" USING btree (
  "email" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_login" ON "contentbox"."cb_author" USING btree (
  "username" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "password" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "isactive" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE INDEX "idx_passwordreset" ON "contentbox"."cb_author" USING btree (
  "ispasswordreset" "pg_catalog"."bool_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table cb_author
-- ----------------------------
ALTER TABLE "contentbox"."cb_author" ADD CONSTRAINT "cb_author_username_key" UNIQUE ("username");

-- ----------------------------
-- Primary Key structure for table cb_author
-- ----------------------------
ALTER TABLE "contentbox"."cb_author" ADD CONSTRAINT "cb_author_pkey" PRIMARY KEY ("authorid");

-- ----------------------------
-- Indexes structure for table cb_category
-- ----------------------------
CREATE INDEX "idx_categoryname" ON "contentbox"."cb_category" USING btree (
  "category" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_categoryslug" ON "contentbox"."cb_category" USING btree (
  "slug" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table cb_category
-- ----------------------------
ALTER TABLE "contentbox"."cb_category" ADD CONSTRAINT "cb_category_pkey" PRIMARY KEY ("categoryid");

-- ----------------------------
-- Indexes structure for table cb_comment
-- ----------------------------
CREATE INDEX "idx_approved" ON "contentbox"."cb_comment" USING btree (
  "isapproved" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE INDEX "idx_contentcomment" ON "contentbox"."cb_comment" USING btree (
  "isapproved" "pg_catalog"."bool_ops" ASC NULLS LAST,
  "fk_contentid" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table cb_comment
-- ----------------------------
ALTER TABLE "contentbox"."cb_comment" ADD CONSTRAINT "cb_comment_pkey" PRIMARY KEY ("commentid");

-- ----------------------------
-- Indexes structure for table cb_commentsubscriptions
-- ----------------------------
CREATE INDEX "idx_contentcommentsubscription" ON "contentbox"."cb_commentsubscriptions" USING btree (
  "fk_contentid" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table cb_commentsubscriptions
-- ----------------------------
ALTER TABLE "contentbox"."cb_commentsubscriptions" ADD CONSTRAINT "cb_commentsubscriptions_pkey" PRIMARY KEY ("subscriptionid");

-- ----------------------------
-- Indexes structure for table cb_content
-- ----------------------------
CREATE INDEX "idx_cache" ON "contentbox"."cb_content" USING btree (
  "cache" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE INDEX "idx_cachelastaccesstimeout" ON "contentbox"."cb_content" USING btree (
  "cachelastaccesstimeout" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_cachelayout" ON "contentbox"."cb_content" USING btree (
  "cachelayout" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE INDEX "idx_cachetimeout" ON "contentbox"."cb_content" USING btree (
  "cachetimeout" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_discriminator" ON "contentbox"."cb_content" USING btree (
  "contenttype" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_expiredate" ON "contentbox"."cb_content" USING btree (
  "expiredate" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "idx_published" ON "contentbox"."cb_content" USING btree (
  "contenttype" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "ispublished" "pg_catalog"."bool_ops" ASC NULLS LAST,
  "passwordprotection" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_publisheddate" ON "contentbox"."cb_content" USING btree (
  "publisheddate" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "idx_publishedslug" ON "contentbox"."cb_content" USING btree (
  "slug" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "ispublished" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE INDEX "idx_search" ON "contentbox"."cb_content" USING btree (
  "title" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "ispublished" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE INDEX "idx_showinsearch" ON "contentbox"."cb_content" USING btree (
  "showinsearch" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE INDEX "idx_slug" ON "contentbox"."cb_content" USING btree (
  "slug" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table cb_content
-- ----------------------------
ALTER TABLE "contentbox"."cb_content" ADD CONSTRAINT "cb_content_pkey" PRIMARY KEY ("contentid");

-- ----------------------------
-- Primary Key structure for table cb_contentstore
-- ----------------------------
ALTER TABLE "contentbox"."cb_contentstore" ADD CONSTRAINT "cb_contentstore_pkey" PRIMARY KEY ("contentid");

-- ----------------------------
-- Indexes structure for table cb_contentversion
-- ----------------------------
CREATE INDEX "idx_activecontentversion" ON "contentbox"."cb_contentversion" USING btree (
  "isactive" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE INDEX "idx_contentversions" ON "contentbox"."cb_contentversion" USING btree (
  "isactive" "pg_catalog"."bool_ops" ASC NULLS LAST,
  "fk_contentid" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_version" ON "contentbox"."cb_contentversion" USING btree (
  "version" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table cb_contentversion
-- ----------------------------
ALTER TABLE "contentbox"."cb_contentversion" ADD CONSTRAINT "cb_contentversion_pkey" PRIMARY KEY ("contentversionid");

-- ----------------------------
-- Indexes structure for table cb_customfield
-- ----------------------------
CREATE INDEX "idx_contentcustomfields" ON "contentbox"."cb_customfield" USING btree (
  "fk_contentid" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table cb_customfield
-- ----------------------------
ALTER TABLE "contentbox"."cb_customfield" ADD CONSTRAINT "cb_customfield_pkey" PRIMARY KEY ("customfieldid");

-- ----------------------------
-- Primary Key structure for table cb_entry
-- ----------------------------
ALTER TABLE "contentbox"."cb_entry" ADD CONSTRAINT "cb_entry_pkey" PRIMARY KEY ("contentid");

-- ----------------------------
-- Indexes structure for table cb_loginattempts
-- ----------------------------
CREATE INDEX "idx_values" ON "contentbox"."cb_loginattempts" USING btree (
  "value" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table cb_loginattempts
-- ----------------------------
ALTER TABLE "contentbox"."cb_loginattempts" ADD CONSTRAINT "cb_loginattempts_pkey" PRIMARY KEY ("loginattemptsid");

-- ----------------------------
-- Indexes structure for table cb_menu
-- ----------------------------
CREATE INDEX "idx_menuslug" ON "contentbox"."cb_menu" USING btree (
  "slug" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_menutitle" ON "contentbox"."cb_menu" USING btree (
  "title" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table cb_menu
-- ----------------------------
ALTER TABLE "contentbox"."cb_menu" ADD CONSTRAINT "cb_menu_pkey" PRIMARY KEY ("menuid");

-- ----------------------------
-- Indexes structure for table cb_menuitem
-- ----------------------------
CREATE INDEX "idx_basemenuitem_createdate" ON "contentbox"."cb_menuitem" USING btree (
  "createddate" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "idx_basemenuitem_deleted" ON "contentbox"."cb_menuitem" USING btree (
  "isdeleted" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE INDEX "idx_basemenuitem_modifieddate" ON "contentbox"."cb_menuitem" USING btree (
  "modifieddate" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "idx_menuitemtitle" ON "contentbox"."cb_menuitem" USING btree (
  "title" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table cb_menuitem
-- ----------------------------
ALTER TABLE "contentbox"."cb_menuitem" ADD CONSTRAINT "cb_menuitem_pkey" PRIMARY KEY ("menuitemid");

-- ----------------------------
-- Indexes structure for table cb_module
-- ----------------------------
CREATE INDEX "idx_activemodule" ON "contentbox"."cb_module" USING btree (
  "isactive" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE INDEX "idx_entrypoint" ON "contentbox"."cb_module" USING btree (
  "entrypoint" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_modulename" ON "contentbox"."cb_module" USING btree (
  "name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_moduletype" ON "contentbox"."cb_module" USING btree (
  "moduletype" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table cb_module
-- ----------------------------
ALTER TABLE "contentbox"."cb_module" ADD CONSTRAINT "cb_module_pkey" PRIMARY KEY ("moduleid");

-- ----------------------------
-- Indexes structure for table cb_page
-- ----------------------------
CREATE INDEX "idx_showinmenu" ON "contentbox"."cb_page" USING btree (
  "showinmenu" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE INDEX "idx_ssl" ON "contentbox"."cb_page" USING btree (
  "sslonly" "pg_catalog"."bool_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table cb_page
-- ----------------------------
ALTER TABLE "contentbox"."cb_page" ADD CONSTRAINT "cb_page_pkey" PRIMARY KEY ("contentid");

-- ----------------------------
-- Indexes structure for table cb_permission
-- ----------------------------
CREATE INDEX "idx_permissionname" ON "contentbox"."cb_permission" USING btree (
  "permission" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table cb_permission
-- ----------------------------
ALTER TABLE "contentbox"."cb_permission" ADD CONSTRAINT "cb_permission_permission_key" UNIQUE ("permission");

-- ----------------------------
-- Primary Key structure for table cb_permission
-- ----------------------------
ALTER TABLE "contentbox"."cb_permission" ADD CONSTRAINT "cb_permission_pkey" PRIMARY KEY ("permissionid");

-- ----------------------------
-- Indexes structure for table cb_permissiongroup
-- ----------------------------
CREATE INDEX "idx_permissiongroupname" ON "contentbox"."cb_permissiongroup" USING btree (
  "name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table cb_permissiongroup
-- ----------------------------
ALTER TABLE "contentbox"."cb_permissiongroup" ADD CONSTRAINT "cb_permissiongroup_name_key" UNIQUE ("name");

-- ----------------------------
-- Primary Key structure for table cb_permissiongroup
-- ----------------------------
ALTER TABLE "contentbox"."cb_permissiongroup" ADD CONSTRAINT "cb_permissiongroup_pkey" PRIMARY KEY ("permissiongroupid");

-- ----------------------------
-- Indexes structure for table cb_role
-- ----------------------------
CREATE INDEX "idx_rolename" ON "contentbox"."cb_role" USING btree (
  "role" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table cb_role
-- ----------------------------
ALTER TABLE "contentbox"."cb_role" ADD CONSTRAINT "cb_role_role_key" UNIQUE ("role");

-- ----------------------------
-- Primary Key structure for table cb_role
-- ----------------------------
ALTER TABLE "contentbox"."cb_role" ADD CONSTRAINT "cb_role_pkey" PRIMARY KEY ("roleid");

-- ----------------------------
-- Primary Key structure for table cb_securityrule
-- ----------------------------
ALTER TABLE "contentbox"."cb_securityrule" ADD CONSTRAINT "cb_securityrule_pkey" PRIMARY KEY ("ruleid");

-- ----------------------------
-- Indexes structure for table cb_setting
-- ----------------------------
CREATE INDEX "idx_core" ON "contentbox"."cb_setting" USING btree (
  "iscore" "pg_catalog"."bool_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table cb_setting
-- ----------------------------
ALTER TABLE "contentbox"."cb_setting" ADD CONSTRAINT "cb_setting_pkey" PRIMARY KEY ("settingid");

-- ----------------------------
-- Indexes structure for table cb_site
-- ----------------------------
CREATE INDEX "idx_siteslug" ON "contentbox"."cb_site" USING btree (
  "slug" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table cb_site
-- ----------------------------
ALTER TABLE "contentbox"."cb_site" ADD CONSTRAINT "cb_site_slug_key" UNIQUE ("slug");

-- ----------------------------
-- Primary Key structure for table cb_site
-- ----------------------------
ALTER TABLE "contentbox"."cb_site" ADD CONSTRAINT "cb_site_pkey" PRIMARY KEY ("siteid");

-- ----------------------------
-- Uniques structure for table cb_stats
-- ----------------------------
ALTER TABLE "contentbox"."cb_stats" ADD CONSTRAINT "cb_stats_fk_contentid_key" UNIQUE ("fk_contentid");

-- ----------------------------
-- Primary Key structure for table cb_stats
-- ----------------------------
ALTER TABLE "contentbox"."cb_stats" ADD CONSTRAINT "cb_stats_pkey" PRIMARY KEY ("statsid");

-- ----------------------------
-- Indexes structure for table cb_subscribers
-- ----------------------------
CREATE INDEX "idx_subscriberemail" ON "contentbox"."cb_subscribers" USING btree (
  "subscriberemail" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table cb_subscribers
-- ----------------------------
ALTER TABLE "contentbox"."cb_subscribers" ADD CONSTRAINT "cb_subscribers_pkey" PRIMARY KEY ("subscriberid");

-- ----------------------------
-- Indexes structure for table cb_subscriptions
-- ----------------------------
CREATE INDEX "idx_subscriber" ON "contentbox"."cb_subscriptions" USING btree (
  "fk_subscriberid" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table cb_subscriptions
-- ----------------------------
ALTER TABLE "contentbox"."cb_subscriptions" ADD CONSTRAINT "cb_subscriptions_pkey" PRIMARY KEY ("subscriptionid");

-- ----------------------------
-- Foreign Keys structure for table cb_author
-- ----------------------------
ALTER TABLE "contentbox"."cb_author" ADD CONSTRAINT "fk6847396b9724fa40" FOREIGN KEY ("fk_roleid") REFERENCES "contentbox"."cb_role" ("roleid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_authorpermissiongroups
-- ----------------------------
ALTER TABLE "contentbox"."cb_authorpermissiongroups" ADD CONSTRAINT "fk7443fc0eaa6ac0ea" FOREIGN KEY ("fk_authorid") REFERENCES "contentbox"."cb_author" ("authorid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "contentbox"."cb_authorpermissiongroups" ADD CONSTRAINT "fk7443fc0ef4497dc2" FOREIGN KEY ("fk_permissiongroupid") REFERENCES "contentbox"."cb_permissiongroup" ("permissiongroupid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_authorpermissions
-- ----------------------------
ALTER TABLE "contentbox"."cb_authorpermissions" ADD CONSTRAINT "fke167e21937c1a3f2" FOREIGN KEY ("fk_permissionid") REFERENCES "contentbox"."cb_permission" ("permissionid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "contentbox"."cb_authorpermissions" ADD CONSTRAINT "fke167e219aa6ac0ea" FOREIGN KEY ("fk_authorid") REFERENCES "contentbox"."cb_author" ("authorid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_category
-- ----------------------------
ALTER TABLE "contentbox"."cb_category" ADD CONSTRAINT "fk20f65cde988947a2" FOREIGN KEY ("fk_siteid") REFERENCES "contentbox"."cb_site" ("siteid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_comment
-- ----------------------------
ALTER TABLE "contentbox"."cb_comment" ADD CONSTRAINT "fkffced27f91f58374" FOREIGN KEY ("fk_contentid") REFERENCES "contentbox"."cb_content" ("contentid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_commentsubscriptions
-- ----------------------------
ALTER TABLE "contentbox"."cb_commentsubscriptions" ADD CONSTRAINT "fk41716eb71d33b614" FOREIGN KEY ("subscriptionid") REFERENCES "contentbox"."cb_subscriptions" ("subscriptionid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "contentbox"."cb_commentsubscriptions" ADD CONSTRAINT "fk41716eb791f58374" FOREIGN KEY ("fk_contentid") REFERENCES "contentbox"."cb_content" ("contentid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_content
-- ----------------------------
ALTER TABLE "contentbox"."cb_content" ADD CONSTRAINT "fkffe018996fdc2c99" FOREIGN KEY ("fk_parentid") REFERENCES "contentbox"."cb_content" ("contentid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "contentbox"."cb_content" ADD CONSTRAINT "fkffe01899988947a2" FOREIGN KEY ("fk_siteid") REFERENCES "contentbox"."cb_site" ("siteid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "contentbox"."cb_content" ADD CONSTRAINT "fkffe01899aa6ac0ea" FOREIGN KEY ("fk_authorid") REFERENCES "contentbox"."cb_author" ("authorid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_contentcategories
-- ----------------------------
ALTER TABLE "contentbox"."cb_contentcategories" ADD CONSTRAINT "fkd96a0f9591f58374" FOREIGN KEY ("fk_contentid") REFERENCES "contentbox"."cb_content" ("contentid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "contentbox"."cb_contentcategories" ADD CONSTRAINT "fkd96a0f95f10ecd0" FOREIGN KEY ("fk_categoryid") REFERENCES "contentbox"."cb_category" ("categoryid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_contentstore
-- ----------------------------
ALTER TABLE "contentbox"."cb_contentstore" ADD CONSTRAINT "fkea4c67c8c960893b" FOREIGN KEY ("contentid") REFERENCES "contentbox"."cb_content" ("contentid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_contentversion
-- ----------------------------
ALTER TABLE "contentbox"."cb_contentversion" ADD CONSTRAINT "fke166dff91f58374" FOREIGN KEY ("fk_contentid") REFERENCES "contentbox"."cb_content" ("contentid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "contentbox"."cb_contentversion" ADD CONSTRAINT "fke166dffaa6ac0ea" FOREIGN KEY ("fk_authorid") REFERENCES "contentbox"."cb_author" ("authorid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_customfield
-- ----------------------------
ALTER TABLE "contentbox"."cb_customfield" ADD CONSTRAINT "fk1844684991f58374" FOREIGN KEY ("fk_contentid") REFERENCES "contentbox"."cb_content" ("contentid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_entry
-- ----------------------------
ALTER TABLE "contentbox"."cb_entry" ADD CONSTRAINT "fk141674927fff6a7" FOREIGN KEY ("contentid") REFERENCES "contentbox"."cb_content" ("contentid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_grouppermissions
-- ----------------------------
ALTER TABLE "contentbox"."cb_grouppermissions" ADD CONSTRAINT "fk72ecb06537c1a3f2" FOREIGN KEY ("fk_permissionid") REFERENCES "contentbox"."cb_permission" ("permissionid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "contentbox"."cb_grouppermissions" ADD CONSTRAINT "fk72ecb065f4497dc2" FOREIGN KEY ("fk_permissiongroupid") REFERENCES "contentbox"."cb_permissiongroup" ("permissiongroupid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_menu
-- ----------------------------
ALTER TABLE "contentbox"."cb_menu" ADD CONSTRAINT "fk21b1a53f988947a2" FOREIGN KEY ("fk_siteid") REFERENCES "contentbox"."cb_site" ("siteid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_menuitem
-- ----------------------------
ALTER TABLE "contentbox"."cb_menuitem" ADD CONSTRAINT "fkf9f1dcf28e0e8dd2" FOREIGN KEY ("fk_menuid") REFERENCES "contentbox"."cb_menu" ("menuid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "contentbox"."cb_menuitem" ADD CONSTRAINT "fkf9f1dcf2d3b42410" FOREIGN KEY ("fk_parentid") REFERENCES "contentbox"."cb_menuitem" ("menuitemid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_page
-- ----------------------------
ALTER TABLE "contentbox"."cb_page" ADD CONSTRAINT "fk21b2f26f9636a2e2" FOREIGN KEY ("contentid") REFERENCES "contentbox"."cb_content" ("contentid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_relatedcontent
-- ----------------------------
ALTER TABLE "contentbox"."cb_relatedcontent" ADD CONSTRAINT "fk9c2f71ae91f58374" FOREIGN KEY ("fk_contentid") REFERENCES "contentbox"."cb_content" ("contentid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "contentbox"."cb_relatedcontent" ADD CONSTRAINT "fk9c2f71aedf61aadd" FOREIGN KEY ("fk_relatedcontentid") REFERENCES "contentbox"."cb_content" ("contentid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_rolepermissions
-- ----------------------------
ALTER TABLE "contentbox"."cb_rolepermissions" ADD CONSTRAINT "fkdccc1a4e37c1a3f2" FOREIGN KEY ("fk_permissionid") REFERENCES "contentbox"."cb_permission" ("permissionid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "contentbox"."cb_rolepermissions" ADD CONSTRAINT "fkdccc1a4e9724fa40" FOREIGN KEY ("fk_roleid") REFERENCES "contentbox"."cb_role" ("roleid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_setting
-- ----------------------------
ALTER TABLE "contentbox"."cb_setting" ADD CONSTRAINT "fk3d87f270988947a2" FOREIGN KEY ("fk_siteid") REFERENCES "contentbox"."cb_site" ("siteid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_stats
-- ----------------------------
ALTER TABLE "contentbox"."cb_stats" ADD CONSTRAINT "fk14de30bf91f58374" FOREIGN KEY ("fk_contentid") REFERENCES "contentbox"."cb_content" ("contentid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cb_subscriptions
-- ----------------------------
ALTER TABLE "contentbox"."cb_subscriptions" ADD CONSTRAINT "fke92a1716f2a66ee4" FOREIGN KEY ("fk_subscriberid") REFERENCES "contentbox"."cb_subscribers" ("subscriberid") ON DELETE NO ACTION ON UPDATE NO ACTION;
