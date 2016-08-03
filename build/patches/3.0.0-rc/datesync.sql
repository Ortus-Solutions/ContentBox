UPDATE cb_author
SET modifiedDate = CURRENT_TIMESTAMP;

UPDATE cb_comment
SET modifiedDate = CURRENT_TIMESTAMP;

UPDATE cb_loginAttempts
SET modifiedDate = CURRENT_TIMESTAMP;

UPDATE cb_menu
SET modifiedDate = CURRENT_TIMESTAMP;

UPDATE cb_content
SET modifiedDate = CURRENT_TIMESTAMP;

UPDATE cb_contentVersion
SET modifiedDate = CURRENT_TIMESTAMP;

UPDATE cb_subscriptions
SET modifiedDate = CURRENT_TIMESTAMP;

UPDATE cb_category
SET modifiedDate = CURRENT_TIMESTAMP,
	createdDate = CURRENT_TIMESTAMP;
	
UPDATE cb_customfield
SET modifiedDate = CURRENT_TIMESTAMP,
	createdDate = CURRENT_TIMESTAMP;

UPDATE cb_menuItem
SET modifiedDate = CURRENT_TIMESTAMP,
	createdDate = CURRENT_TIMESTAMP;
	
UPDATE cb_module
SET modifiedDate = CURRENT_TIMESTAMP,
	createdDate = CURRENT_TIMESTAMP;
	
UPDATE cb_permission
SET modifiedDate = CURRENT_TIMESTAMP,
	createdDate = CURRENT_TIMESTAMP;
	
UPDATE cb_role
SET modifiedDate = CURRENT_TIMESTAMP,
	createdDate = CURRENT_TIMESTAMP;

UPDATE cb_securityRule
SET modifiedDate = CURRENT_TIMESTAMP,
	createdDate = CURRENT_TIMESTAMP;
	
UPDATE cb_setting
SET modifiedDate = CURRENT_TIMESTAMP,
	createdDate = CURRENT_TIMESTAMP;
	
UPDATE cb_stats
SET modifiedDate = CURRENT_TIMESTAMP,
	createdDate = CURRENT_TIMESTAMP;
	
UPDATE cb_subscribers
SET modifiedDate = CURRENT_TIMESTAMP,
	createdDate = CURRENT_TIMESTAMP;