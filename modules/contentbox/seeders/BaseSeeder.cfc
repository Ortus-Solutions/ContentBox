abstract     component {

	// DI
	property name="packageService" inject="PackageService";
	property name="JSONService" inject="JSONService";
	property name="qb" inject="provider:QueryBuilder@qb";

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
		fileSystemUtil.createMapping( "mockdatacfc", "#getCWD()#testbox/system/modules/mockdatacfc" );
		// create mock data
		variables.mockData   = new mockdatacfc.models.MockData();
		// Bcrypt hash of the word "test"
		variables.bcryptTest = "$2a$12$FE2J7ZLWaI2rSqejAu/84uLy7qlSufQsDsSE1lNNKyA05GG30gr8C";
		variables.uuidLib    = createObject( "java", "java.util.UUID" );
		return this;
	}

	abstract function truncate( required table );
	abstract function keysOff();
	abstract function keysOn();

	function onDIComplete(){
		variables.cfmigrationsInfo = getCFMigrationsInfo();
		print.cyanLine( "Please wait, connecting to your database: #variables.cfmigrationsInfo.schema#" );
		var appSettings         = getApplicationSettings();
		var dataSources         = appSettings.datasources ?: {};
		dataSources[ "seeder" ] = variables.cfmigrationsInfo.connectionInfo

		// Update APP so we can use the datasource in our task
		application action="update" datasources=dataSources;
		application action="update" datasource="seeder";

		print.greenLine( "Connection success!" );
	}

	function getCFMigrationsInfo(){
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

	function run(){
		if ( !confirm( "This seeder will wipe out your entire data and replace it with mock data, are you sure?" ) ) {
			print.line().redLine( "Bye Bye!" );
			return;
		}

		try {
			transaction {
				keysOff();
				seedLoginAttempts();

				/******************** PERMISSIONS ********************/
				print.line().greenLine( "Generating user permissions..." );
				truncate( "cb_permission" );
				var aPerms = deserializeJSON( fileRead( "mockdata/permissions.json" ) ).each( ( thisRecord ) => thisRecord[ "permissionID" ] = uuidLib.randomUUID().toString() );
				qb.from( "cb_permission" ).insert( aPerms );
				print.cyanLine( "   ==> (#aPerms.len()#) User Permissions inserted" );


				/******************** PERMISSION GROUPS ***********************/
				print.line().greenLine( "Generating permission groups..." );
				truncate( "cb_permissionGroup" );
				var aPermissionGroups = [
					{
						"permissionGroupID" : uuidLib.randomUUID().toString(),
						"createdDate"       : "2017-06-12 16:01:13",
						"modifiedDate"      : "2017-06-12 20:31:52",
						"isDeleted"         : 0,
						"name"              : "Finance",
						"description"       : "Finance team permissions"
					},
					{
						"permissionGroupID" : uuidLib.randomUUID().toString(),
						"createdDate"       : "2017-06-16 13:02:12",
						"modifiedDate"      : "2017-06-16 13:02:12",
						"isDeleted"         : 0,
						"name"              : "Security",
						"description"       : ""
					}
				];
				qb.from( "cb_permissionGroup" ).insert( aPermissionGroups );
				print.cyanLine( "   ==> (#aPermissionGroups.len()#) Persmission Groups inserted" );


				/******************** LINK Permission GROUPS **********************/
				print.line().greenLine( "Linking permissions groups..." );
				truncate( "cb_groupPermissions" );
				var aGroupPermissions = [
					{
						"FK_permissionGroupID" : aPermissionGroups[ 1 ].permissionGroupID,
						"FK_permissionID"      : aPerms[ randRange( 1, aPerms.len() ) ].permissionID
					},
					{
						"FK_permissionGroupID" : aPermissionGroups[ 1 ].permissionGroupID,
						"FK_permissionID"      : aPerms[ randRange( 1, aPerms.len() ) ].permissionID
					},
					{
						"FK_permissionGroupID" : aPermissionGroups[ 1 ].permissionGroupID,
						"FK_permissionID"      : aPerms[ randRange( 1, aPerms.len() ) ].permissionID
					},
					{
						"FK_permissionGroupID" : aPermissionGroups[ 2 ].permissionGroupID,
						"FK_permissionID"      : aPerms[ randRange( 1, aPerms.len() ) ].permissionID
					},
					{
						"FK_permissionGroupID" : aPermissionGroups[ 2 ].permissionGroupID,
						"FK_permissionID"      : aPerms[ randRange( 1, aPerms.len() ) ].permissionID
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
				var aSites = deserializeJSON( fileRead( "mockdata/sites.json" ) );
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
							"settingID"    : uuidLib.randomUUID().toString(),
							"name"         : key,
							"value"        : value,
							"isCore"       : 0,
							"createdDate"  : "2020-09-09 17:34:50",
							"modifiedDate" : "2020-09-09 17:34:50",
							"isDeleted"    : 0,
							"FK_siteID"    : thisSite.siteID
						} );
					} );
					qb.from( "cb_setting" ).insert( aSettings );
					print.cyanLine( "   ==> (#aSettings.len()#) Settings inserted for site: #thisSite.name#" );
				} );


				/******************** CATEGORIES *****************************/
				print.line().greenLine( "Generating categories..." );
				truncate( "cb_category" );
				var aCategories = deserializeJSON( fileRead( "mockdata/categories.json" ) );
				qb.from( "cb_category" ).insert( aCategories );
				print.cyanLine( "   ==> (#aCategories.len()#) Categories inserted" );



				/******************** SECURITY RULES *************************/
				print.line().greenLine( "Generating security rules..." );
				truncate( "cb_securityRule" );
				var aSecurityRules = deserializeJSON( fileRead( "mockdata/securityRules.json" ) );
				qb.from( "cb_securityRule" ).insert( aSecurityRules );
				print.cyanLine( "   ==> (#aSecurityRules.len()#) Security Rules inserted" );


				/******************** AUTHORS ************************/
				print.line().greenLine( "Generating authors..." );
				truncate( "cb_author" );
				var aAuthors = deserializeJSON( fileRead( "mockdata/authors.json" ) );
				qb.from( "cb_author" ).insert( aAuthors );
				print.cyanLine( "   ==> (#aAuthors.len()#) Authors inserted" );


				/******************** AUTHOR PERMISSIONS *********************/
				print.line().greenLine( "Generating authors a-la-carte permissions..." );
				truncate( "cb_authorPermissions" );
				var testAuthor         = aAuthors.filter( ( thisAuthor ) => thisAuthor.username == "testermajano" )[ 1 ];
				var aAuthorPermissions = [];
				for ( var x = 1; x lte 4; x++ ) {
					aAuthorPermissions.append( {
						"FK_authorID"     : testAuthor.authorID,
						"FK_permissionID" : aPerms[ randRange( 1, aPerms.len() ) ].permissionID
					} );
				}
				qb.from( "cb_authorPermissions" ).insert( aAuthorPermissions );
				print.cyanLine( "   ==> (#aAuthorPermissions.len()#) Authors Permissions inserted" );


				/******************** AUTHOR PERMISSION GROUPS *********************/
				print.line().greenLine( "Generating authors permissions groups..." );
				truncate( "cb_authorPermissionGroups" );
				var testUser1               = aAuthors.filter( ( thisAuthor ) => thisAuthor.username == "joejoe" )[ 1 ];
				var testUser2               = aAuthors.filter( ( thisAuthor ) => thisAuthor.username == "joremorelos@morelos.com" )[ 1 ];
				var aAuthorPermissionGroups = [
					{
						"FK_authorID"          : testUser1.authorID,
						"FK_permissionGroupID" : aPermissionGroups[ 1 ].permissionGroupID
					},
					{
						"FK_authorID"          : testUser2.authorID,
						"FK_permissionGroupID" : aPermissionGroups[ 1 ].permissionGroupID
					},
					{
						"FK_authorID"          : testUser2.authorID,
						"FK_permissionGroupID" : aPermissionGroups[ 2 ].permissionGroupID
					}
				]
				qb.from( "cb_authorPermissionGroups" ).insert( aAuthorPermissionGroups );
				print.cyanLine( "   ==> (#aAuthorPermissionGroups.len()#) Authors Permission Groups inserted" );


				/******************** CONTENT ********************************/
				print.line().greenLine( "Generating content..." );
				truncate( "cb_content" );
				var aContent = deserializeJSON( fileRead( "mockdata/content.json" ) );
				qb.from( "cb_content" ).insert( aContent );
				print.cyanLine( "   ==> (#aContent.len()#) Content inserted" );

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
						"subscriptionID" : "F6B464C7-7E47-4991-A0B28121EFFB67F5",
						"FK_contentID"   : "0e35bbec-a441-11eb-ab6f-0290cc502141"
					},
					{
						"subscriptionID" : "F6B464C7-7E47-4991-A0B28121EFFB67F6",
						"FK_contentID"   : "0e35bbec-a441-11eb-ab6f-0290cc502141"
					},
					{
						"subscriptionID" : "F6B464C7-7E47-4991-A0B28121EFFB67F4",
						"FK_contentID"   : "0e35bbec-a441-11eb-ab6f-0290cc502142"
					}
				];

				qb.from( "cb_commentSubscriptions" ).insert( aCommentSubscriptions );
				print.cyanLine( "   ==> (#aCommentSubscriptions.len()#) Comment Subscriptions inserted" );

				/******************** CONTENT CATEGORIES *********************/
				print.line().greenLine( "Generating content categories..." );
				truncate( "cb_contentCategories" );

				var aContentCategories = [
					{
						"FK_contentID"  : "0e35bbec-a441-11eb-ab6f-0290cc502114",
						"FK_categoryID" : 2
					},
					{
						"FK_contentID"  : "0e35bbec-a441-11eb-ab6f-0290cc502114",
						"FK_categoryID" : 4
					},
					{
						"FK_contentID"  : "0e35bbec-a441-11eb-ab6f-0290cc502a64",
						"FK_categoryID" : "ff80808178fbc7620178fbc7f1180124"
					},
					{
						"FK_contentID"  : "0e35bbec-a441-11eb-ab6f-0290cc502a64",
						"FK_categoryID" : "ff80808178fbc7620178fbc7f1180126"
					},
					{
						"FK_contentID"  : "0e35bbec-a441-11eb-ab6f-0290cc502a87",
						"FK_categoryID" : "ff80808178fbc7620178fbc7f1180124"
					},
					{
						"FK_contentID"  : "0e35bbec-a441-11eb-ab6f-0290cc502a87",
						"FK_categoryID" : "ff80808178fbc7620178fbc7f1180126"
					},
					{
						"FK_contentID"  : "0e35bbec-a441-11eb-ab6f-0290cc502a88",
						"FK_categoryID" : "ff80808178fbc7620178fbc7f1180124"
					},
					{
						"FK_contentID"  : "0e35bbec-a441-11eb-ab6f-0290cc502a88",
						"FK_categoryID" : "ff80808178fbc7620178fbc7f1180126"
					},
					{
						"FK_contentID"  : "0e35bbec-a441-11eb-ab6f-0290cc502147",
						"FK_categoryID" : "ff80808178fbc7620178fbc7f1180125"
					}
				];

				qb.from( "cb_contentCategories" ).insert( aContentCategories );
				print.cyanLine( "   ==> (#aContentCategories.len()#) Content Categories inserted" );

				/******************** CONTENT STORE **************************/
				print.line().greenLine( "Generating content store..." );
				truncate( "cb_contentStore" );

				aContentStore = [
					{
						"contentID"   : "0e35bbec-a441-11eb-ab6f-0290cc502111",
						"description" : "My very first content",
						"order"       : 0
					},
					{
						"contentID"   : "0e35bbec-a441-11eb-ab6f-0290cc502114",
						"description" : "Most greatest news",
						"order"       : 0
					},
					{
						"contentID"   : "0e35bbec-a441-11eb-ab6f-0290cc502122",
						"description" : "",
						"order"       : 0
					},
					{
						"contentID"   : "0e35bbec-a441-11eb-ab6f-0290cc502123",
						"description" : "footer",
						"order"       : 0
					},
					{
						"contentID"   : "0e35bbec-a441-11eb-ab6f-0290cc502124",
						"description" : "support options",
						"order"       : 0
					},
					{
						"contentID"   : "0e35bbec-a441-11eb-ab6f-0290cc502127",
						"description" : "Test",
						"order"       : 0
					},
					{
						"contentID"   : "0e35bbec-a441-11eb-ab6f-0290cc502159",
						"description" : "A small footer",
						"order"       : 0
					},
					{
						"contentID"   : "0e35bbec-a441-11eb-ab6f-0290cc502168",
						"description" : "test",
						"order"       : 0
					},
					{
						"contentID"   : "0e35bbec-a441-11eb-ab6f-0290cc502169",
						"description" : "asdf",
						"order"       : 0
					},
					{
						"contentID"   : "0e35bbec-a441-11eb-ab6f-0290cc502219",
						"description" : "",
						"order"       : 0
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
						"customFieldID" : "3E0AB238-1783-4DD6-93518F0B67B9B5F3",
						"key"           : "age",
						"value"         : "30",
						"FK_contentID"  : "0e35bbec-a441-11eb-ab6f-0290cc502114",
						"createdDate"   : "2016-05-03 16:23:25",
						"modifiedDate"  : "2016-05-03 16:23:25",
						"isDeleted"     : 0
					},
					{
						"customFieldID" : "3E0AB238-1783-4DD6-93518F0B67B9B5F4",
						"key"           : "subtitle",
						"value"         : "4",
						"FK_contentID"  : "0e35bbec-a441-11eb-ab6f-0290cc502114",
						"createdDate"   : "2016-05-03 16:23:25",
						"modifiedDate"  : "2016-05-03 16:23:25",
						"isDeleted"     : 0
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
						"menuID"       : "69C9F53E-A13C-4D4C-A39641562E5EAE72",
						"title"        : "Test",
						"slug"         : "test",
						"listType"     : "ul",
						"createdDate"  : "2016-05-04 17:00:14",
						"menuClass"    : "",
						"listClass"    : "",
						"modifiedDate" : "2016-05-04 17:20:11",
						"isDeleted"    : 0,
						"FK_siteId"    : "ff80808178fbc7620178fbc7e5f400af"
					},
					{
						"menuID"       : "69C9F53E-A13C-4D4C-A39641562E5EAE73",
						"title"        : "test",
						"slug"         : "test -e123c",
						"listType"     : "ul",
						"createdDate"  : "2016-05-04 17:02:54",
						"menuClass"    : "",
						"listClass"    : "",
						"modifiedDate" : "2016-05-04 17:02:54",
						"isDeleted"    : 0,
						"FK_siteId"    : "ff80808178fbc7620178fbc7e5f400af"
					}
				];

				qb.from( "cb_menu" ).insert( aMenus );
				print.cyanLine( "   ==> (#aMenus.len()#) Menus inserted" );

				/******************** MENU ITEMS *****************************/
				print.line().greenLine( "Generating menu items..." );
				truncate( "cb_menuItem" );

				var aMenuItems = [
					{
						"menuItemID"   : "2508B7D0-F3B7-4395-BDFBD12BCBB8CE97",
						"menuType"     : "Free",
						"title"        : "",
						"label"        : "test",
						"data"         : "",
						"active"       : 1,
						"FK_menuID"    : "69C9F53E-A13C-4D4C-A39641562E5EAE73",
						"FK_parentID"  : { "value" : "", "null" : true },
						"mediaPath"    : { "value" : "", "null" : true },
						"contentSlug"  : { "value" : "", "null" : true },
						"menuSlug"     : { "value" : "", "null" : true },
						"url"          : { "value" : "", "null" : true },
						"js"           : { "value" : "", "null" : true },
						"itemClass"    : "",
						"target"       : { "value" : "", "null" : true },
						"urlClass"     : { "value" : "", "null" : true },
						"createdDate"  : "2016-05-04 17:22:08",
						"modifiedDate" : "2016-05-04 17:22:08",
						"isDeleted"    : 0
					},
					{
						"menuItemID"   : "2508B7D0-F3B7-4395-BDFBD12BCBB8CE98",
						"menuType"     : "URL",
						"title"        : "",
						"label"        : "hello",
						"data"         : "",
						"active"       : 1,
						"FK_menuID"    : "69C9F53E-A13C-4D4C-A39641562E5EAE73",
						"FK_parentID"  : { "value" : "", "null" : true },
						"mediaPath"    : { "value" : "", "null" : true },
						"contentSlug"  : { "value" : "", "null" : true },
						"menuSlug"     : { "value" : "", "null" : true },
						"url"          : "http://www.ortussolutions.com",
						"js"           : { "value" : "", "null" : true },
						"itemClass"    : "",
						"target"       : "_blank",
						"urlClass"     : "test",
						"createdDate"  : "2016-05-04 17:22:08",
						"modifiedDate" : "2016-05-04 17:22:08",
						"isDeleted"    : 0
					}
				];

				qb.from( "cb_menuItem" ).insert( aMenuItems );
				print.cyanLine( "   ==> (#aMenuItems.len()#) Menu Items inserted" );


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
						"FK_contentID"        : "0e35bbec-a441-11eb-ab6f-0290cc502127",
						"FK_relatedContentID" : "0e35bbec-a441-11eb-ab6f-0290cc502111"
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
			keysOn();
		}
	}

	function seedLoginAttempts(){
		/******************** LOGIN ATTEMPTS *************************/
		print.line().greenLine( "Generating login attempts..." );
		truncate( "cb_loginAttempts" );
		var aLoginAttempts = deserializeJSON( fileRead( "mockdata/loginAttempts.json" ) ).each( ( thisRecord ) => thisRecord[ "loginAttemptsID" ] = uuidLib.randomUUID().toString() );
		qb.from( "cb_loginAttempts" ).insert( aLoginAttempts );
		print.cyanLine( "   ==> (#aLoginAttempts.len()#) Login Attempts inserted" );
	}

}
