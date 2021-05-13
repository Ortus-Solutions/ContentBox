/**
 * Task that seeds my database with test data
 */
component extends="BaseSeeder"{

	function init(){
		super.init();
		return this;
	}

	function keysOn(){
		queryExecute( "ALTER TABLE cb_loginAttempts ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_permission ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_permissionGroup ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_groupPermissions ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_role ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_rolePermissions ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_site ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_setting ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_category ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_securityRule ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_author ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_authorPermissions ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_authorPermissionGroups ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_content ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_comment ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_commentSubscriptions ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_contentCategories ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_comment ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_contentStore ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_contentVersion ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_customfield ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_entry ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_menu ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_menuItem ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_page ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_relatedContent ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_stats ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_subscribers ENABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_subscriptions ENABLE TRIGGER ALL;" );
	}

	function KeysOff(){
		queryExecute( "ALTER TABLE cb_loginAttempts DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_permission DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_permissionGroup DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_groupPermissions DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_role DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_rolePermissions DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_site DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_setting DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_category DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_securityRule DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_author DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_authorPermissions DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_authorPermissionGroups DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_content DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_comment DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_commentSubscriptions DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_contentCategories DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_comment DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_contentStore DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_contentVersion DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_customfield DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_entry DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_menu DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_menuItem DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_page DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_relatedContent DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_stats DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_subscribers DISABLE TRIGGER ALL;" );
		queryExecute( "ALTER TABLE cb_subscriptions DISABLE TRIGGER ALL;" );
	}

	function truncate( required table ){
		queryExecute( "truncate #arguments.table# CASCADE" );
	}

	function seedLoginAttempts(){
		/******************** LOGIN ATTEMPTS *************************/
		print.line().greenLine( "Generating login attempts..." );
		truncate( "cb_loginattempts" );

		var aLoginAttempts = deserializeJSON( fileRead( "mockdata/loginAttempts.json" ) ).each( ( thisRecord ) => thisRecord[ "loginAttemptsID" ] = uuidLib.randomUUID().toString() );

		qb.from( "cb_loginattempts" ).insert( aLoginAttempts );
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
		truncate( "cb_permissiongroup" );

		variables.aPermissionGroups = [
			{
				"createddate": "2017-06-12 16:01:13",
				"modifieddate": "2017-06-12 20:31:52",
				"isdeleted": { "value" : 0, "cfsqltype" : "bit" },
				"name": "Finance",
				"description": "Finance team permissions",
				"permissiongroupid": "7850efee-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"createddate": "2017-06-16 13:02:12",
				"modifieddate": "2017-06-16 13:02:12",
				"isdeleted": { "value" : 0, "cfsqltype" : "bit" },
				"name": "Security",
				"description": "",
				"permissiongroupid": "7850f138-a444-11eb-ab6f-0290cc502ae3"
			}
		];

		qb.from( "cb_permissiongroup" ).insert( variables.aPermissionGroups );
		print.cyanLine( "   ==> (#variables.aPermissionGroups.len()#) Persmission Groups inserted" );

		/******************** LINK Permission GROUPS *****************/
		print.line().greenLine( "Linking permissions groups..." );
		truncate( "cb_grouppermissions" );

		var aGroupPermissions = [
			{
				"fk_permissiongroupid" : variables.aPermissionGroups[ 1 ].permissionGroupID,
				"fk_permissionid"      : variables.aPerms[ randRange( 1, variables.aPerms.len() ) ].permissionID
			},
			{
				"fk_permissiongroupid" : variables.aPermissionGroups[ 1 ].permissionGroupID,
				"fk_permissionid"      : variables.aPerms[ randRange( 1, variables.aPerms.len() ) ].permissionID
			},
			{
				"fk_permissiongroupid" : variables.aPermissionGroups[ 1 ].permissionGroupID,
				"fk_permissionid"      : variables.aPerms[ randRange( 1, variables.aPerms.len() ) ].permissionID
			},
			{
				"fk_permissiongroupid" : variables.aPermissionGroups[ 2 ].permissionGroupID,
				"fk_permissionid"      : variables.aPerms[ randRange( 1, variables.aPerms.len() ) ].permissionID
			},
			{
				"fk_permissiongroupid" : variables.aPermissionGroups[ 2 ].permissionGroupID,
				"fk_permissionid"      : variables.aPerms[ randRange( 1, variables.aPerms.len() ) ].permissionID
			}
		];

		qb.from( "cb_grouppermissions" ).insert( aGroupPermissions );
		print.cyanLine( "   ==> (#aGroupPermissions.len()#) Group Permissions inserted" );
	}

	function seedRolePermissions(){
		/******************** ROLE PERMISSIONS ***********************/
		print.line().greenLine( "Generating role permissions..." );
		truncate( "cb_rolepermissions" );

		var aRolePermission = deserializeJSON( fileRead( "mockdata/rolePermissions.json" ) );

		qb.from( "cb_rolepermissions" ).insert( aRolePermission );
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
					"settingid"    : uuidLib.randomUUID().toString(),
					"name"         : key,
					"value"        : value,
					"iscore"       : { "value" : 0, "cfsqltype" : "bit" },
					"createddate"  : "2020-09-09 17:34:50",
					"modifieddate" : "2020-09-09 17:34:50",
					"isdeleted"    : { "value" : 0, "cfsqltype" : "bit" },
					"fk_siteid"    : thisSite.siteID
				} );
			} );

			qb.from( "cb_setting" ).insert( aSettings );
			print.cyanLine(
				"   ==> (#aSettings.len()#) Settings inserted for site: #thisSite.name#"
			);
		} );
	}

	function seedSecurityRules(){
		/******************** SECURITY RULES *************************/
		print.line().greenLine( "Generating security rules..." );
		truncate( "cb_securityrule" );

		var aSecurityRules = deserializeJSON( fileRead( "mockdata/securityRules.json" ) );

		qb.from( "cb_securityrule" ).insert( aSecurityRules );
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
		truncate( "cb_authorpermissions" );

		var aAuthorPermissions = [
			{
				"fk_permissionid": "785d8182-a444-11eb-ab6f-0290cc502ae3",
				"fk_authorid": "77abe0a8-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"fk_permissionid": "785d8574-a444-11eb-ab6f-0290cc502ae3",
				"fk_authorid": "77abe0a8-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"fk_permissionid": "785d8420-a444-11eb-ab6f-0290cc502ae3",
				"fk_authorid": "77abe0a8-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"fk_permissionid": "785d83b2-a444-11eb-ab6f-0290cc502ae3",
				"fk_authorid": "77abe0a8-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"fk_permissionid": "785d8344-a444-11eb-ab6f-0290cc502ae3",
				"fk_authorid": "77abe0a8-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"fk_permissionid": "785d84fc-a444-11eb-ab6f-0290cc502ae3",
				"fk_authorid": "77abe0a8-a444-11eb-ab6f-0290cc502ae3"
			}
		];

		qb.from( "cb_authorpermissions" ).insert( aAuthorPermissions );
		print.cyanLine( "   ==> (#aAuthorPermissions.len()#) Authors Permissions inserted" );

		/******************** AUTHOR PERMISSION GROUPS ***************/
		print.line().greenLine( "Generating authors permissions groups..." );
		truncate( "cb_authorpermissiongroups" );

		var testUser1 = aAuthors.filter( ( thisAuthor ) => thisAuthor.username == "joejoe" )[ 1 ];
		var testUser2 = aAuthors.filter( ( thisAuthor ) => thisAuthor.username == "joremorelos@morelos.com" )[ 1 ];

		var aAuthorPermissionGroups = [
			{
				"fk_authorid"          : testUser1.authorID,
				"fk_permissiongroupid" : variables.aPermissionGroups[ 1 ].permissionGroupID
			},
			{
				"fk_authorid"          : testUser2.authorID,
				"fk_permissiongroupid" : variables.aPermissionGroups[ 1 ].permissionGroupID
			},
			{
				"fk_authorid"          : testUser2.authorID,
				"fk_permissiongroupid" : variables.aPermissionGroups[ 2 ].permissionGroupID
			}
		];

		qb.from( "cb_authorpermissiongroups" ).insert( aAuthorPermissionGroups );
		print.cyanLine(
			"   ==> (#aAuthorPermissionGroups.len()#) Authors Permission Groups inserted"
		);
	}

	function seedCommentSubscriptions(){
		/********************* COMMENT SUBSCRIPTIONS ****************/
		print.line().greenLine( "Generating comment subscriptions..." );
		truncate( "cb_commentsubscriptions" );

		var aCommentSubscriptions = [
			{
				"subscriptionid": "77e37aae-a444-11eb-ab6f-0290cc502ae3",
				"fk_contentid": "779cd18a-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"subscriptionid": "77e37b80-a444-11eb-ab6f-0290cc502ae3",
				"fk_contentid": "779cd18a-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"subscriptionid": "77e3796e-a444-11eb-ab6f-0290cc502ae3",
				"fk_contentid": "779cd234-a444-11eb-ab6f-0290cc502ae3"
			}
		];

		qb.from( "cb_commentsubscriptions" ).insert( aCommentSubscriptions );
		print.cyanLine( "   ==> (#aCommentSubscriptions.len()#) Comment Subscriptions inserted" );
	}

	function seedContentCategories(){
		/******************** CONTENT CATEGORIES *********************/
		print.line().greenLine( "Generating content categories..." );
		truncate( "cb_contentcategories" );

		var aContentCategories = deserializeJSON( fileRead( "mockdata/contentCategories.json" ) );

		qb.from( "cb_contentcategories" ).insert( aContentCategories );
		print.cyanLine( "   ==> (#aContentCategories.len()#) Content Categories inserted" );
	}

	function seedContentStore(){
		/******************** CONTENT STORE **************************/
		print.line().greenLine( "Generating content store..." );
		truncate( "cb_contentstore" );

		var aContentStore = deserializeJSON( fileRead( "mockdata/contentStore.json" ) );

		qb.from( "cb_contentstore" ).insert( aContentStore );
		print.cyanLine( "   ==> (#aContentStore.len()#) Content Store inserted" );
	}

	function seedContentVersions(){
		/******************** CONTENT VERSIONS ***********************/
		print.line().greenLine( "Generating content versions..." );
		truncate( "cb_contentversion" );

		var aContentVersions = deserializeJSON( fileRead( "mockdata/contentVersions.json" ) );

		qb.from( "cb_contentversion" ).insert( aContentVersions );
		print.cyanLine( "   ==> (#aContentVersions.len()#) Content versions inserted" );
	}

	function seedMenu(){
		/******************** MENU ***********************************/
		print.line().greenLine( "Generating menus..." );
		truncate( "cb_menu" );

		var aMenus = [
			{
				"title": "Main Menu",
				"slug": "main-menu",
				"listtype": "ul",
				"createddate": "2016-05-04 17:00:14",
				"menuclass": "m5 p5",
				"listclass": "",
				"modifieddate": "2021-05-05 15:29:13",
				"isdeleted": { "value": 0, "cfsqltype": "bit" },
				"menuid": "77cccd4a-a444-11eb-ab6f-0290cc502ae3",
				"fk_siteid": "1c81d376-a481-11eb-ab6f-0290cc502ae3"
			},
			{
				"title": "test",
				"slug": "test -e123c",
				"listtype": "ul",
				"createddate": "2016-05-04 17:02:54",
				"menuclass": "",
				"listclass": "",
				"modifieddate": "2016-05-04 17:02:54",
				"isdeleted": { "value": 0, "cfsqltype": "bit" },
				"menuid": "77ccceb2-a444-11eb-ab6f-0290cc502ae3",
				"fk_siteid": "1c81d376-a481-11eb-ab6f-0290cc502ae3"
			}
		];

		qb.from( "cb_menu" ).insert( aMenus );
		print.cyanLine( "   ==> (#aMenus.len()#) Menus inserted" );
	}

	function seedMenuItems(){
		/******************** MENU ITEMS *****************************/
		print.line().greenLine( "Generating menu items..." );
		truncate( "cb_menuitem" );

		var aMenuItems = deserializeJSON( fileRead( "mockdata/menuItems.json" ) );

		qb.from( "cb_menuitem" ).insert( aMenuItems );
		print.cyanLine( "   ==> (#aMenuItems.len()#) Menu Items inserted" );
	}

	function seedRelatedContent(){
		/******************** RELATED CONTENT ************************/
		print.line().greenLine( "Generating related content..." );
		truncate( "cb_relatedcontent" );

		var aRelatedContent = [
			{
				"fk_contentid": "779ccef6-a444-11eb-ab6f-0290cc502ae3",
				"fk_relatedcontentid": "779ccbb8-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"fk_contentid": "779ccdac-a444-11eb-ab6f-0290cc502ae3",
				"fk_relatedcontentid": "779cd4dc-a444-11eb-ab6f-0290cc502ae3"
			},
			{
				"fk_contentid": "779ccdac-a444-11eb-ab6f-0290cc502ae3",
				"fk_relatedcontentid": "779cd234-a444-11eb-ab6f-0290cc502ae3"
			}
		];

		qb.from( "cb_relatedcontent" ).insert( aRelatedContent );
		print.cyanLine( "   ==> (#aRelatedContent.len()#) Related Content inserted" );
	}
}
