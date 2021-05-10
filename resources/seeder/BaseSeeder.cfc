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
		fileSystemUtil.createMapping(
			"mockdatacfc",
			"#getCWD()#testbox/system/modules/mockdatacfc"
		);
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
				keysOff();

				seedLoginAttempts();
				seedPermissions();
				seedRoles();
				seedRolePermissions();
				seedSites();
				seedCategories();
				seedSecurityRules();
				seedAuthors();
				seedContent();
				seedComments();
				seedCommentSubscriptions();
				seedContentCategories();
				seedContentStore();
				seedContentVersions();
				seedCustomFields();
				seedEntries();
				seedMenu();
				seedMenuItems();
				seedPages();
				seedRelatedContent();
				seedStats();
				seedSubscribers();
				seedSubscriptions();
			}
			// End transaction
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

	function seedPermissions(){
		/******************** PERMISSIONS ****************************/
		print.line().greenLine( "Generating user permissions..." );
		truncate( "cb_permission" );

		variables.aPerms = deserializeJSON( fileRead( "mockdata/permissions.json" ) )/* .each( ( thisRecord ) => thisRecord[ "permissionID" ] = uuidLib.randomUUID().toString() ) */;

		qb.from( "cb_permission" ).insert( variables.aPerms );
		print.cyanLine( "   ==> (#variables.aPerms.len()#) User Permissions inserted" );

		/******************** PERMISSION GROUPS **********************/
		print.line().greenLine( "Generating permission groups..." );
		truncate( "cb_permissionGroup" );

		variables.aPermissionGroups = [
			{
				"createdDate": "2017-06-12 16:01:13",
				"modifiedDate": "2017-06-12 20:31:52",
				"isDeleted": 0,
				"name": "Finance",
				"description": "Finance team permissions",
				"permissionGroupID": "7850efee-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"createdDate": "2017-06-16 13:02:12",
				"modifiedDate": "2017-06-16 13:02:12",
				"isDeleted": 0,
				"name": "Security",
				"description": "",
				"permissionGroupID": "7850f138-a444-11eb-ab6f-0290cc502ae3"
			}
		];

		qb.from( "cb_permissionGroup" ).insert( variables.aPermissionGroups );
		print.cyanLine( "   ==> (#variables.aPermissionGroups.len()#) Persmission Groups inserted" );

		/******************** LINK Permission GROUPS *****************/
		print.line().greenLine( "Linking permissions groups..." );
		truncate( "cb_groupPermissions" );

		var aGroupPermissions = [
			{
				"FK_permissionGroupID" : variables.aPermissionGroups[ 1 ].permissionGroupID,
				"FK_permissionID"      : variables.aPerms[ randRange( 1, variables.aPerms.len() ) ].permissionID
			},
			{
				"FK_permissionGroupID" : variables.aPermissionGroups[ 1 ].permissionGroupID,
				"FK_permissionID"      : variables.aPerms[ randRange( 1, variables.aPerms.len() ) ].permissionID
			},
			{
				"FK_permissionGroupID" : variables.aPermissionGroups[ 1 ].permissionGroupID,
				"FK_permissionID"      : variables.aPerms[ randRange( 1, variables.aPerms.len() ) ].permissionID
			},
			{
				"FK_permissionGroupID" : variables.aPermissionGroups[ 2 ].permissionGroupID,
				"FK_permissionID"      : variables.aPerms[ randRange( 1, variables.aPerms.len() ) ].permissionID
			},
			{
				"FK_permissionGroupID" : variables.aPermissionGroups[ 2 ].permissionGroupID,
				"FK_permissionID"      : variables.aPerms[ randRange( 1, variables.aPerms.len() ) ].permissionID
			}
		];

		qb.from( "cb_groupPermissions" ).insert( aGroupPermissions );
		print.cyanLine( "   ==> (#aGroupPermissions.len()#) Group Permissions inserted" );
	}

	function seedRoles(){
		/******************** ROLES **********************************/
		print.line().greenLine( "Generating roles..." );
		truncate( "cb_role" );

		var aRoles = deserializeJSON( fileRead( "mockdata/roles.json" ) );

		qb.from( "cb_role" ).insert( aRoles );
		print.cyanLine( "   ==> (#aRoles.len()#) Roles inserted" );
	}

	function seedRolePermissions(){
		/******************** ROLE PERMISSIONS ***********************/
		print.line().greenLine( "Generating role permissions..." );
		truncate( "cb_rolePermissions" );

		var aRolePermission = deserializeJSON( fileRead( "mockdata/rolePermissions.json" ) );

		qb.from( "cb_rolePermissions" ).insert( aRolePermission );
		print.cyanLine( "   ==> (#aRolePermission.len()#) Role Permissions inserted" );
	}

	function seedSites(){
		/******************** SITES **********************************/
		print.line().greenLine( "Generating sites..." );
		truncate( "cb_site" );

		var aSites = deserializeJSON( fileRead( "mockdata/sites.json" ) );

		qb.from( "cb_site" ).insert( aSites );
		print.cyanLine( "   ==> (#aSites.len()#) Sites inserted" );

		/******************** SITE SETTINGS **************************/
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
			print.cyanLine(
				"   ==> (#aSettings.len()#) Settings inserted for site: #thisSite.name#"
			);
		} );
	}

	function seedCategories(){
		/******************** CATEGORIES *****************************/
		print.line().greenLine( "Generating categories..." );
		truncate( "cb_category" );

		var aCategories = deserializeJSON( fileRead( "mockdata/categories.json" ) );

		qb.from( "cb_category" ).insert( aCategories );
		print.cyanLine( "   ==> (#aCategories.len()#) Categories inserted" );
	}

	function seedSecurityRules(){
		/******************** SECURITY RULES *************************/
		print.line().greenLine( "Generating security rules..." );
		truncate( "cb_securityRule" );

		var aSecurityRules = deserializeJSON( fileRead( "mockdata/securityRules.json" ) );

		qb.from( "cb_securityRule" ).insert( aSecurityRules );
		print.cyanLine( "   ==> (#aSecurityRules.len()#) Security Rules inserted" );
	}

	function seedAuthors(){
		/******************** AUTHORS ************************/
		print.line().greenLine( "Generating authors..." );
		truncate( "cb_author" );

		var aAuthors = deserializeJSON( fileRead( "mockdata/authors.json" ) );

		qb.from( "cb_author" ).insert( aAuthors );
		print.cyanLine( "   ==> (#aAuthors.len()#) Authors inserted" );

		/******************** AUTHOR PERMISSIONS *********************/
		print.line().greenLine( "Generating authors a-la-carte permissions..." );
		truncate( "cb_authorPermissions" );

		var aAuthorPermissions = [
			{
				"FK_permissionID": "785d8182-a444-11eb-ab6f-0290cc502ae3",
				"FK_authorID": "77abe0a8-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"FK_permissionID": "785d8574-a444-11eb-ab6f-0290cc502ae3",
				"FK_authorID": "77abe0a8-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"FK_permissionID": "785d8420-a444-11eb-ab6f-0290cc502ae3",
				"FK_authorID": "77abe0a8-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"FK_permissionID": "785d83b2-a444-11eb-ab6f-0290cc502ae3",
				"FK_authorID": "77abe0a8-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"FK_permissionID": "785d8344-a444-11eb-ab6f-0290cc502ae3",
				"FK_authorID": "77abe0a8-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"FK_permissionID": "785d84fc-a444-11eb-ab6f-0290cc502ae3",
				"FK_authorID": "77abe0a8-a444-11eb-ab6f-0290cc502ae3"
			}
		];

		qb.from( "cb_authorPermissions" ).insert( aAuthorPermissions );
		print.cyanLine( "   ==> (#aAuthorPermissions.len()#) Authors Permissions inserted" );

		/******************** AUTHOR PERMISSION GROUPS ***************/
		print.line().greenLine( "Generating authors permissions groups..." );
		truncate( "cb_authorPermissionGroups" );

		var testUser1 = aAuthors.filter( ( thisAuthor ) => thisAuthor.username == "joejoe" )[ 1 ];
		var testUser2 = aAuthors.filter( ( thisAuthor ) => thisAuthor.username == "joremorelos@morelos.com" )[ 1 ];

		var aAuthorPermissionGroups = [
			{
				"FK_authorID"          : testUser1.authorID,
				"FK_permissionGroupID" : variables.aPermissionGroups[ 1 ].permissionGroupID
			},
			{
				"FK_authorID"          : testUser2.authorID,
				"FK_permissionGroupID" : variables.aPermissionGroups[ 1 ].permissionGroupID
			},
			{
				"FK_authorID"          : testUser2.authorID,
				"FK_permissionGroupID" : variables.aPermissionGroups[ 2 ].permissionGroupID
			}
		];

		qb.from( "cb_authorPermissionGroups" ).insert( aAuthorPermissionGroups );
		print.cyanLine(
			"   ==> (#aAuthorPermissionGroups.len()#) Authors Permission Groups inserted"
		);
	}

	function seedContent(){
		/******************** CONTENT ********************************/
		print.line().greenLine( "Generating content..." );
		truncate( "cb_content" );

		var aContent = deserializeJSON( fileRead( "mockdata/content.json" ) );

		qb.from( "cb_content" ).insert( aContent );
		print.cyanLine( "   ==> (#aContent.len()#) Content inserted" );
	}

	function seedComments(){
		/******************** COMMENTS *******************************/
		print.line().greenLine( "Generating comments..." );
		truncate( "cb_comment" );

		var aComments = deserializeJSON( fileRead( "mockdata/comments.json" ) );

		qb.from( "cb_comment" ).insert( aComments );
		print.cyanLine( "   ==> (#aComments.len()#) Comments inserted" );
	}

	function seedCommentSubscriptions(){
		/********************* COMMENT SUBSCRIPTIONS ****************/
		print.line().greenLine( "Generating comment subscriptions..." );
		truncate( "cb_commentSubscriptions" );

		var aCommentSubscriptions = [
			{
				"subscriptionID": "77e37aae-a444-11eb-ab6f-0290cc502ae3",
				"FK_contentID": "779cd18a-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"subscriptionID": "77e37b80-a444-11eb-ab6f-0290cc502ae3",
				"FK_contentID": "779cd18a-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"subscriptionID": "77e3796e-a444-11eb-ab6f-0290cc502ae3",
				"FK_contentID": "779cd234-a444-11eb-ab6f-0290cc502ae3"
			}
		];

		qb.from( "cb_commentSubscriptions" ).insert( aCommentSubscriptions );
		print.cyanLine( "   ==> (#aCommentSubscriptions.len()#) Comment Subscriptions inserted" );
	}

	function seedContentCategories(){
		/******************** CONTENT CATEGORIES *********************/
		print.line().greenLine( "Generating content categories..." );
		truncate( "cb_contentCategories" );

		var aContentCategories = deserializeJSON( fileRead( "mockdata/contentCategories.json" ) );

		qb.from( "cb_contentCategories" ).insert( aContentCategories );
		print.cyanLine( "   ==> (#aContentCategories.len()#) Content Categories inserted" );
	}

	function seedContentStore(){
		/******************** CONTENT STORE **************************/
		print.line().greenLine( "Generating content store..." );
		truncate( "cb_contentStore" );

		var aContentStore = deserializeJSON( fileRead( "mockdata/contentStore.json" ) );

		qb.from( "cb_contentStore" ).insert( aContentStore );
		print.cyanLine( "   ==> (#aContentStore.len()#) Content Store inserted" );
	}

	function seedContentVersions(){
		/******************** CONTENT VERSIONS ***********************/
		print.line().greenLine( "Generating content versions..." );
		truncate( "cb_contentVersion" );

		var aContentVersions = deserializeJSON( fileRead( "mockdata/contentVersions.json" ) );

		qb.from( "cb_contentVersion" ).insert( aContentVersions );
		print.cyanLine( "   ==> (#aContentVersions.len()#) Content versions inserted" );
	}

	function seedCustomFields(){
		/******************** CUSTOM FIELDS **************************/
		print.line().greenLine( "Generating custom field..." );
		truncate( "cb_customfield" );

		var aCustomFields = deserializeJSON( fileRead( "mockdata/customFields.json" ) );

		qb.from( "cb_customfield" ).insert( aCustomFields );
		print.cyanLine( "   ==> (#aCustomFields.len()#) Custom Fields inserted" );
	}

	function seedEntries(){
		/******************** ENTRIES ********************************/
		print.line().greenLine( "Generating entries..." );
		truncate( "cb_entry" );

		var aEntries = deserializeJSON( fileRead( "mockdata/entries.json" ) );

		qb.from( "cb_entry" ).insert( aEntries );
		print.cyanLine( "   ==> (#aEntries.len()#) Entries inserted" );
	}

	function seedMenu(){
		/******************** MENU ***********************************/
		print.line().greenLine( "Generating menus..." );
		truncate( "cb_menu" );

		var aMenus = [
			{
				"title": "Main Menu",
				"slug": "main-menu",
				"listType": "ul",
				"createdDate": "2016-05-04 17:00:14",
				"menuClass": "m5 p5",
				"listClass": "",
				"modifiedDate": "2021-05-05 15:29:13",
				"isDeleted": 0,
				"menuID": "77cccd4a-a444-11eb-ab6f-0290cc502ae3",
				"FK_siteID": "1c81d376-a481-11eb-ab6f-0290cc502ae3"
			},
			{
				"title": "test",
				"slug": "test -e123c",
				"listType": "ul",
				"createdDate": "2016-05-04 17:02:54",
				"menuClass": "",
				"listClass": "",
				"modifiedDate": "2016-05-04 17:02:54",
				"isDeleted": 0,
				"menuID": "77ccceb2-a444-11eb-ab6f-0290cc502ae3",
				"FK_siteID": "1c81d376-a481-11eb-ab6f-0290cc502ae3"
			}
		];

		qb.from( "cb_menu" ).insert( aMenus );
		print.cyanLine( "   ==> (#aMenus.len()#) Menus inserted" );
	}

	function seedMenuItems(){
		/******************** MENU ITEMS *****************************/
		print.line().greenLine( "Generating menu items..." );
		truncate( "cb_menuItem" );

		var aMenuItems = deserializeJSON( fileRead( "mockdata/menuItems.json" ) );

		qb.from( "cb_menuItem" ).insert( aMenuItems );
		print.cyanLine( "   ==> (#aMenuItems.len()#) Menu Items inserted" );
	}

	function seedPages(){
		/******************** PAGES **********************************/
		print.line().greenLine( "Generating pages..." );
		truncate( "cb_page" );

		var aPages = deserializeJSON( fileRead( "mockdata/pages.json" ) );

		qb.from( "cb_page" ).insert( aPages );
		print.cyanLine( "   ==> (#aPages.len()#) Pages inserted" );
	}

	function seedRelatedContent(){
		/******************** RELATED CONTENT ************************/
		print.line().greenLine( "Generating related content..." );
		truncate( "cb_relatedContent" );

		var aRelatedContent = [
			{
				"FK_contentID": "779ccef6-a444-11eb-ab6f-0290cc502ae3",
				"FK_relatedContentID": "779ccbb8-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"FK_contentID": "779ccdac-a444-11eb-ab6f-0290cc502ae3",
				"FK_relatedContentID": "779cd4dc-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"FK_contentID": "779ccdac-a444-11eb-ab6f-0290cc502ae3",
				"FK_relatedContentID": "779cd234-a444-11eb-ab6f-0290cc502ae3"
			}
		];

		qb.from( "cb_relatedContent" ).insert( aRelatedContent );
		print.cyanLine( "   ==> (#aRelatedContent.len()#) Related Content inserted" );
	}

	function seedStats(){
		/******************** STATS **********************************/
		print.line().greenLine( "Generating stats..." );
		truncate( "cb_stats" );

		var aStats = deserializeJSON( fileRead( "mockdata/stats.json" ) );

		qb.from( "cb_stats" ).insert( aStats );
		print.cyanLine( "   ==> (#aStats.len()#) Stats inserted" );
	}

	function seedSubscribers(){
		/******************** SUBSCRIBERS **********************************/
		print.line().greenLine( "Generating subscribers..." );
		truncate( "cb_subscribers" );

		var aSubscribers = deserializeJSON( fileRead( "mockdata/subscribers.json" ) );

		qb.from( "cb_subscribers" ).insert( aSubscribers );
		print.cyanLine( "   ==> (#aSubscribers.len()#) Subscribers inserted" );
	}

	function seedSubscriptions(){
		/******************** SUBSCRIPTIONS **********************************/
		print.line().greenLine( "Generating subscriptions..." );
		truncate( "cb_subscriptions" );

		var aSubscriptions = deserializeJSON( fileRead( "mockdata/subscriptions.json" ) );

		qb.from( "cb_subscriptions" ).insert( aSubscriptions );
		print.cyanLine( "   ==> (#aSubscriptions.len()#) Subscriptions inserted" );
	}

}
