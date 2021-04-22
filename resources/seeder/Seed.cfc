/**
 * Task that seeds my database with test data
 */
component {

	property name="packageService" inject="PackageService";
	property name="JSONService"    inject="JSONService";
	property name="qb"             inject="provider:QueryBuilder@qb";

	// Site Defaults
	this.SITE_DEFAULTS = {
		// Global HTML: Panel Section
		"cb_html_beforeHeadEnd"              : "",
		"cb_html_afterBodyStart"             : "",
		"cb_html_beforeBodyEnd"              : "",
		"cb_html_beforeContent"              : "",
		"cb_html_afterContent"               : "",
		"cb_html_beforeSideBar"              : "",
		"cb_html_afterSideBar"               : "",
		"cb_html_afterFooter"                : "",
		"cb_html_preEntryDisplay"            : "",
		"cb_html_postEntryDisplay"           : "",
		"cb_html_preIndexDisplay"            : "",
		"cb_html_postIndexDisplay"           : "",
		"cb_html_preArchivesDisplay"         : "",
		"cb_html_postArchivesDisplay"        : "",
		"cb_html_preCommentForm"             : "",
		"cb_html_postCommentForm"            : "",
		"cb_html_prePageDisplay"             : "",
		"cb_html_postPageDisplay"            : "",
		// Site Comment Settings
		"cb_comments_enabled"                : "true",
		"cb_comments_maxDisplayChars"        : "500",
		"cb_comments_notify"                 : "true",
		"cb_comments_moderation_notify"      : "true",
		"cb_comments_notifyemails"           : "",
		"cb_comments_moderation"             : "true",
		"cb_comments_moderation_whitelist"   : "true",
		"cb_comments_moderation_blacklist"   : "",
		"cb_comments_moderation_blockedlist" : "",
		"cb_comments_moderation_expiration"  : "30"
	};

	function init(){
		// Create mockDataCFC mapping: Must be in `modules` folder.
		fileSystemUtil.createMapping(
			"mockdatacfc",
			"#getCWD()#testbox/system/modules/mockdatacfc"
		);
		// create mock data
		variables.mockData   = new mockdatacfc.models.MockData();
		// Bcrypt hash of the word "test"
		variables.bcryptTest = "$2a$12$FE2J7ZLWaI2rSqejAu/84uLy7qlSufQsDsSE1lNNKyA05GG30gr8C";
		variables.uuidLib = createobject("java", "java.util.UUID");
		return this;
	}

	function onDIComplete(){
		variables.cfmigrationsInfo = getCFMigrationsInfo();
		print.cyanLine(
			"Please wait, connecting to your database: #variables.cfmigrationsInfo.schema#"
		);
		var appSettings         = getApplicationSettings();
		var dataSources         = appSettings.datasources ?: {};
		dataSources[ "seeder" ] = variables.cfmigrationsInfo.connectionInfo

		// Update APP so we can use the datasource in our task
		application action="update" datasources=dataSources;
		application action="update" datasource="seeder";

		print.greenLine( "Connection success!" );
	}

	function run(){
		if (
			!confirm(
				"This seeder will wipe out your entire data and replace it with mock data, are you sure?"
			)
		) {
			print.line().redLine( "Bye Bye!" );
			return;
		}

		try {
			transaction {
				queryExecute( "SET FOREIGN_KEY_CHECKS=0;" );



				/******************** LOGIN ATTEMPTS *************************/
				print.line().greenLine( "Generating login attempts..." );
				truncate( "cb_loginAttempts" );
				var aLoginAttempts = deserializeJSON( fileRead( "mockdata/loginAttempts.json" ) )
					.each( ( thisRecord ) => thisRecord[ "loginAttemptsID" ] = uuidLib.randomUUID().toString() );
				qb.from( "cb_loginAttempts" ).insert( aLoginAttempts );
				print.cyanLine( "   ==> (#aLoginAttempts.len()#) Login Attempts inserted" );

				/******************** PERMISSIONS ********************/
				print.line().greenLine( "Generating user permissions..." );
				truncate( "cb_permission" );
				var aPerms = deserializeJSON( fileRead( "mockdata/permissions.json" ) )
					.each( ( thisRecord ) => thisRecord[ "permissionID" ] = uuidLib.randomUUID().toString() );
				qb.from( "cb_permission" ).insert( aPerms );
				print.cyanLine( "   ==> (#aPerms.len()#) User Permissions inserted" );


				/******************** PERMISSION GROUPS ***********************/
				print.line().greenLine( "Generating permission groups..." );
				truncate( "cb_permissionGroup" );
				var aPermissionGroups = [
					{
						"permissionGroupID": uuidLib.randomUUID().toString(),
						"createdDate": "2017-06-12 16:01:13",
						"modifiedDate": "2017-06-12 20:31:52",
						"isDeleted": 0,
						"name": "Finance",
						"description": "Finance team permissions"
					},
					{
						"permissionGroupID": uuidLib.randomUUID().toString(),
						"createdDate": "2017-06-16 13:02:12",
						"modifiedDate": "2017-06-16 13:02:12",
						"isDeleted": 0,
						"name": "Security",
						"description": ""
					}
				];
				qb.from( "cb_permissionGroup" ).insert( aPermissionGroups );
				print.cyanLine( "   ==> (#aPermissionGroups.len()#) Persmission Groups inserted" );


				/******************** PERMISSIONS GROUPS **********************/
				print.line().greenLine( "Linking permissions groups..." );
				truncate( "cb_groupPermissions" );
				var aGroupPermissions = [
					{
						"FK_permissionGroupID":  aPermissionGroups[1].permissionGroupID,
						"FK_permissionID": aPerms[ randRange( 1, aPerms.len() ) ].permissionID
					},
					{
						"FK_permissionGroupID": aPermissionGroups[1].permissionGroupID,
						"FK_permissionID": aPerms[ randRange( 1, aPerms.len() ) ].permissionID
					},
					{
						"FK_permissionGroupID": aPermissionGroups[1].permissionGroupID,
						"FK_permissionID": aPerms[ randRange( 1, aPerms.len() ) ].permissionID
					},
					{
						"FK_permissionGroupID": aPermissionGroups[2].permissionGroupID,
						"FK_permissionID": aPerms[ randRange( 1, aPerms.len() ) ].permissionID
					},
					{
						"FK_permissionGroupID": aPermissionGroups[2].permissionGroupID,
						"FK_permissionID": aPerms[ randRange( 1, aPerms.len() ) ].permissionID
					}
				];

				qb.from( "cb_groupPermissions" ).insert( aGroupPermissions );
				print.cyanLine( "   ==> (#aGroupPermissions.len()#) Group Permissions inserted" );



				/******************** ROLES **********************************/
				print.line().greenLine( "Generating roles..." );
				truncate( "cb_role" );
				var aRoles = deserializeJSON( fileRead( "mockdata/roles.json" ) );
				qb.from( "cb_role" ).insert( aRoles );
				print.cyanLine( "   ==> (#aRoles.len()#) Roles inserted" );



				/******************** ROLE PERMISSIONS ***********************/
				print.line().greenLine( "Generating role permissions..." );
				truncate( "cb_rolePermissions" );
				var aRolePermission = deserializeJSON( fileRead( "mockdata/rolePermissions.json" ) );
				qb.from( "cb_rolePermissions" ).insert( aRolePermission );
				print.cyanLine( "   ==> (#aRolePermission.len()#) Role Permissions inserted" );


				/******************** SITES **********************************/
				print.line().greenLine( "Generating sites..." );
				truncate( "cb_site" );
				var aSites = deserializeJSON( fileRead( "mockdata/sites.json" ) )
					.each( ( thisRecord ) => thisRecord[ "siteID" ] = uuidLib.randomUUID().toString() );
				qb.from( "cb_site" ).insert( aSites );
				print.cyanLine( "   ==> (#aSites.len()#) Sites inserted" );

				/******************** SITE SETTINGS *******************************/
				print.line().greenLine( "Generating settings..." );
				truncate( "cb_setting" );

				// Global Settings
				var aSettings = deserializeJSON( fileRead( "mockdata/settings.json" ) );
				qb.from( "cb_setting" ).insert( aSettings );
				print.cyanLine( "   ==> (#aSettings.len()#) Global Settings inserted" );
				// Site Settings
				aSites.each( ( thisSite ) => {
					var aSettings = [];
					this.SITE_DEFAULTS.each( ( key, value ) => {
						aSettings.append( {
							"settingID" : uuidLib.randomUUID().toString(),
							"name" : key,
							"value" : value,
							"isCore" : 0,
							"createdDate": "2020-09-09 17:34:50",
							"modifiedDate": "2020-09-09 17:34:50",
							"isDeleted" : 0,
							"FK_siteID" : thisSite.siteID
						} );
					} );
					qb.from( "cb_setting" ).insert( aSettings );
					print.cyanLine( "   ==> (#aSettings.len()#) Settings inserted for site: #thisSite.name#" );
				} );

				return;

				/******************** CATEGORIES *****************************/
				print.line().greenLine( "Generating categories..." );
				truncate( "cb_category" );
				var aCategories = deserializeJSON( fileRead( "mockdata/categories.json" ) )
					.each( ( thisRecord ) => {
						thisRecord[ "categoryID" ] = uuidLib.randomUUID().toString();
						thisRecord[ "FK_siteID" ] = aSites[ 1 ].siteID;
					} );
				qb.from( "cb_category" ).insert( aCategories );
				print.cyanLine( "   ==> (#aCategories.len()#) Categories inserted" );


				/******************** SECURITY RULES *************************/
				print.line().greenLine( "Generating security rules..." );
				truncate( "cb_securityRule" );
				var aSecurityRules = deserializeJSON( fileRead( "mockdata/securityRules.json" ) )
					.each( ( thisRecord ) => thisRecord[ "ruleID" ] = uuidLib.randomUUID().toString() );
				qb.from( "cb_securityRule" ).insert( aSecurityRules );
				print.cyanLine( "   ==> (#aSecurityRules.len()#) Security Rules inserted" );


				/******************** COMMENTS *******************************/
				print.line().greenLine( "Generating comments..." );
				truncate( "cb_comment" );
				var aComments = deserializeJSON( fileRead( "mockdata/comments.json" ) );
				qb.from( "cb_comment" ).insert( aComments );
				print.cyanLine( "   ==> (#aComments.len()#) Comments inserted" );

				/********************* COMMENTS SUBSCRIPTIONS ****************/
				print.line().greenLine( "Generating comment subscriptions..." );
				truncate( "cb_commentSubscriptions" );

				var aCommentSubscriptions = [
					{
						"subscriptionID": 5,
						"FK_contentID": 141
					},
					{
						"subscriptionID": 6,
						"FK_contentID": 141
					},
					{
						"subscriptionID": 4,
						"FK_contentID": 142
					},
				];

				qb.from( "cb_commentSubscriptions" ).insert( aCommentSubscriptions );
				print.cyanLine( "   ==> (#aCommentSubscriptions.len()#) Comment Subscriptions inserted" );

				/******************** AUTHORS ************************/
				print.line().greenLine( "Generating authors..." );
				truncate( "cb_author" );
				var aAuthors = deserializeJSON( fileRead( "mockdata/authors.json" ) )
					.each( ( thisRecord ) => thisRecord[ "authorID" ] = uuidLib.randomUUID().toString() );
				qb.from( "cb_author" ).insert( aAuthors );
				print.cyanLine( "   ==> (#aAuthors.len()#) Authors inserted" );

				/******************** AUTHOR PERMISSIONS *********************/
				print.line().greenLine( "Generating authors permissions..." );
				truncate( "cb_authorPermissions" );

				var aAuthorPermissions = [
					{
						"FK_authorID": 3,
						"FK_permissionID": 36
					},
					{
						"FK_authorID": 3,
						"FK_permissionID": 45
					},
					{
						"FK_authorID": 3,
						"FK_permissionID": 42
					},
					{
						"FK_authorID": 3,
						"FK_permissionID": 41
					},
					{
						"FK_authorID": 3,
						"FK_permissionID": 40
					},
					{
						"FK_authorID": 3,
						"FK_permissionID": 44
					}
				];

				qb.from( "cb_authorPermissions" ).insert( aAuthorPermissions );
				print.cyanLine( "   ==> (#aAuthorPermissions.len()#) Authors Permissions inserted" );

				/******************** CONTENT ********************************/
				print.line().greenLine( "Generating content..." );
				truncate( "cb_content" );
				var aContent = deserializeJSON( fileRead( "mockdata/content.json" ) );
				qb.from( "cb_content" ).insert( aContent );
				print.cyanLine( "   ==> (#aContent.len()#) Content inserted" );

				/******************** CONTENT CATEGORIES *********************/
				print.line().greenLine( "Generating content categories..." );
				truncate( "cb_contentCategories" );

				var aContentCategories = [
					{
						"FK_contentID": 114,
						"FK_categoryID": 2
					},
					{
						"FK_contentID": 114,
						"FK_categoryID": 4
					},
					{
						"FK_contentID": 64,
						"FK_categoryID": 2
					},
					{
						"FK_contentID": 64,
						"FK_categoryID": 4
					},
					{
						"FK_contentID": 87,
						"FK_categoryID": 2
					},
					{
						"FK_contentID": 87,
						"FK_categoryID": 4
					},
					{
						"FK_contentID": 88,
						"FK_categoryID": 2
					},
					{
						"FK_contentID": 88,
						"FK_categoryID": 4
					},
					{
						"FK_contentID": 147,
						"FK_categoryID": 5
					}
				];

				qb.from( "cb_contentCategories" ).insert( aContentCategories );
				print.cyanLine( "   ==> (#aContentCategories.len()#) Content Categories inserted" );

				/******************** CONTENT STORE **************************/
				print.line().greenLine( "Generating content store..." );
				truncate( "cb_contentStore" );

				aContentStore = [
					{
						"contentID": 111,
						"description": "My very first content",
						"order": 0
					},
					{
						"contentID": 114,
						"description": "Most greatest news",
						"order": 0
					},
					{
						"contentID": 122,
						"description": "",
						"order": 0
					},
					{
						"contentID": 123,
						"description": "footer",
						"order": 0
					},
					{
						"contentID": 124,
						"description": "support options",
						"order": 0
					},
					{
						"contentID": 127,
						"description": "Test",
						"order": 0
					},
					{
						"contentID": 159,
						"description": "A small footer",
						"order": 0
					},
					{
						"contentID": 168,
						"description": "test",
						"order": 0
					},
					{
						"contentID": 169,
						"description": "asdf",
						"order": 0
					},
					{
						"contentID": 219,
						"description": "",
						"order": 0
					}
				];

				qb.from( "cb_contentStore" ).insert( aContentStore );
				print.cyanLine( "   ==> (#aContentStore.len()#) Content Store inserted" );

				/******************** CONTENT VERSIONS ***********************/
				print.line().greenLine( "Generating content versions..." );
				truncate( "cb_contentVersion" );

				var aContentVersions = deserializeJSON( fileRead( "mockdata/contentVersions.json" ) );

				qb.from( "cb_contentVersion" ).insert( aContentVersions );
				print.cyanLine( "   ==> (#aContentVersions.len()#) Content versions inserted" );

				/******************** CUSTOM FIELD ***************************/
				print.line().greenLine( "Generating custom field..." );
				truncate( "cb_customfield" );

				var aCustomFields = [
					{
						"customFieldID": 3,
						"key": "age",
						"value": '30',
						"FK_contentID": 114,
						"createdDate": "2016-05-03 16:23:25",
						"modifiedDate": "2016-05-03 16:23:25",
						"isDeleted": 0
					},
					{
						"customFieldID": 4,
						"key": "subtitle",
						"value": '4',
						"FK_contentID": 114,
						"createdDate": "2016-05-03 16:23:25",
						"modifiedDate": "2016-05-03 16:23:25",
						"isDeleted": 0
					}
				];

				qb.from( "cb_customfield" ).insert( aCustomFields );
				print.cyanLine( "   ==> (#aCustomFields.len()#) Custom Fields inserted" );

				/******************** ENTRIES ********************************/
				print.line().greenLine( "Generating entries..." );
				truncate( "cb_entry" );

				var aEntries = deserializeJSON( fileRead( "mockdata/entries.json" ) );

				qb.from( "cb_entry" ).insert( aEntries );
				print.cyanLine( "   ==> (#aEntries.len()#) Entries inserted" );



				/******************** MENU ***********************************/
				print.line().greenLine( "Generating menus..." );
				truncate( "cb_menu" );

				var aMenus = [
					{
						"menuID": 2,
						"title": "Test",
						"slug": "test",
						"listType": "ul",
						"createdDate": "2016-05-04 17:00:14",
						"menuClass": "",
						"listClass": "",
						"modifiedDate": "2016-05-04 17:20:11",
						"isDeleted": 0,
						"FK_siteId": 1
					},
					{
						"menuID": 3,
						"title": "test",
						"slug": "test -e123c",
						"listType": "ul",
						"createdDate": "2016-05-04 17:02:54",
						"menuClass": "",
						"listClass": "",
						"modifiedDate": "2016-05-04 17:02:54",
						"isDeleted": 0,
						"FK_siteId": 1
					}
				];

				qb.from( "cb_menu" ).insert( aMenus );
				print.cyanLine( "   ==> (#aMenus.len()#) Menus inserted" );

				/******************** MENU ITEMS *****************************/
				print.line().greenLine( "Generating menu items..." );
				truncate( "cb_menuItem" );

				var aMenuItems = [
					{
						"menuItemID": 7,
						"menuType": "Free",
						"title": "",
						"label": "test",
						"data": "",
						"active": 1,
						"FK_menuID": 2,
						"FK_parentID": { "value": "", "null": true },
						"mediaPath": { "value": "", "null": true },
						"contentSlug": { "value": "", "null": true },
						"menuSlug": { "value": "", "null": true },
						"url": { "value": "", "null": true },
						"js": { "value": "", "null": true },
						"itemClass": "",
						"target": { "value": "", "null": true },
						"urlClass": { "value": "", "null": true },
						"createdDate": "2016-05-04 17:22:08",
						"modifiedDate": "2016-05-04 17:22:08",
						"isDeleted": 0
					},
					{
						"menuItemID": 8,
						"menuType": "URL",
						"title": "",
						"label": "hello",
						"data": "",
						"active": 1,
						"FK_menuID": 2,
						"FK_parentID": { "value": "", "null": true },
						"mediaPath": { "value": "", "null": true },
						"contentSlug": { "value": "", "null": true },
						"menuSlug": { "value": "", "null": true },
						"url": "http://www.ortussolutions.com",
						"js": { "value": "", "null": true },
						"itemClass": "",
						"target": "_blank",
						"urlClass": "test",
						"createdDate": "2016-05-04 17:22:08",
						"modifiedDate": "2016-05-04 17:22:08",
						"isDeleted": 0
					}
				];

				qb.from( "cb_menuItem" ).insert( aMenuItems );
				print.cyanLine( "   ==> (#aMenuItems.len()#) Menu Items inserted" );

				/******************** MODULES *********************************/
				print.line().greenLine( "Generating modules..." );
				truncate( "cb_module" );

				var aModules = [
					{
						"moduleID": 36,
						"name": "Hello",
						"title": "HelloContentBox",
						"version": "1.0",
						"entryPoint": "HelloContentBox",
						"author": "Ortus Solutions, Corp",
						"webURL": "http://www.ortussolutions.com",
						"forgeBoxSlug": "",
						"description": "This is an awesome hello world module",
						"isActive": 0,
						"createdDate": "2016-07-15 12:09:34",
						"modifiedDate": "2016-07-15 12:09:34",
						"isDeleted": 0,
						"moduleType": "core"
					}
				];

				qb.from( "cb_module" ).insert( aModules );
				print.cyanLine( "   ==> (#aModules.len()#) Modules inserted" );

				/******************** PAGES **********************************/
				print.line().greenLine( "Generating pages..." );
				truncate( "cb_page" );

				var aPages = deserializeJSON( fileRead( "mockdata/pages.json" ) );

				qb.from( "cb_page" ).insert( aPages );
				print.cyanLine( "   ==> (#aPages.len()#) Pages inserted" );

				/******************** RELATED CONTENT ************************/
				print.line().greenLine( "Generating related content..." );
				truncate( "cb_relatedContent" );

				var aRelatedContent = [
					{
						"FK_contentID": 127,
						"FK_relatedContentID": 111
					}
				];

				qb.from( "cb_relatedContent" ).insert( aRelatedContent );
				print.cyanLine( "   ==> (#aRelatedContent.len()#) Related Content inserted" );


				/******************** STATS **********************************/
				print.line().greenLine( "Generating stats..." );
				truncate( "cb_stats" );

				var aStats = deserializeJSON( fileRead( "mockdata/stats.json" ) );

				qb.from( "cb_stats" ).insert( aStats );
				print.cyanLine( "   ==> (#aStats.len()#) Stats inserted" );

				/******************** SUBSCRIBERS **********************************/
				print.line().greenLine( "Generating subscribers..." );
				truncate( "cb_subscribers" );

				var aSubscribers = deserializeJSON( fileRead( "mockdata/subscribers.json" ) );

				qb.from( "cb_subscribers" ).insert( aSubscribers );
				print.cyanLine( "   ==> (#aSubscribers.len()#) Subscribers inserted" );

				/******************** SUBSCRIPTIONS **********************************/
				print.line().greenLine( "Generating subscriptions..." );
				truncate( "cb_subscriptions" );

				var aSubscriptions = deserializeJSON( fileRead( "mockdata/subscriptions.json" ) );

				qb.from( "cb_subscriptions" ).insert( aSubscriptions );
				print.cyanLine( "   ==> (#aSubscriptions.len()#) Subscriptions inserted" );

				/*****************************************************/
			}
			// end transaction
		} catch ( any e ) {
			rethrow;
		} finally {
			queryExecute( "SET FOREIGN_KEY_CHECKS=1;" );
		}


		return;
	}

	/************************* PRIVATE METHODS ************************************/

	private function getCFMigrationsInfo(){
		var directory = getCWD();
		// Check and see if box.json exists
		if ( !packageService.isPackage( directory ) ) {
			return error( "File [#packageService.getDescriptorPath( directory )#] does not exist." );
		}

		var boxJSON = packageService.readPackageDescriptor( directory );

		if ( !JSONService.check( boxJSON, "cfmigrations" ) ) {
			return error(
				"There is no `cfmigrations` key in your box.json. Please create one with the necessary values. See https://github.com/elpete/commandbox-migrations"
			);
		}

		return JSONService.show( boxJSON, "cfmigrations" );
	}

	private function truncate( required table ){
		queryExecute( "truncate #arguments.table#" );
	}

}
