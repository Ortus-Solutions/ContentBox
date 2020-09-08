component {

    function up( schema, query ) {
		variables.today = now();

		transaction{
			// Update Boolean Bits
			updateBooleanBits( argumentCollection=arguments );
			// Create Default Site
			createDefaultSite( argumentCollection=arguments );
			// Create Site Permission
			createSitePermission( argumentCollection=arguments );
			// Update Admin role with Site Permission
			updateAdminPermissions( argumentCollection=arguments );
			// Create Site Relationships
			createSiteRelationships( argumentCollection=arguments );
			// Remove Setting Name Unique Constraint
			schema.alter( "cb_setting", ( table ) => table.dropConstraint( "name" ) );
			systemOutput( "√ - Setting name unique constraint dropped", true );
			// Remove Content Unique Constraint
			schema.alter( "cb_content", ( table ) => table.dropConstraint( "slug" ) );
			systemOutput( "√ - Content slug unique constraint dropped", true );
			// Remove category unique constraint
			schema.alter( "cb_category", ( table ) => table.dropConstraint( "slug" ) );
			systemOutput( "√ - Content Category slug unique constraint dropped", true );
			// Remove menu unique constraint
			schema.alter( "cb_menu", ( table ) => table.dropConstraint( "slug" ) );
			systemOutput( "√ - Menu slug unique constraint dropped", true );
		}
    }

    function down( schema, query ) {
		// Remove default site
		arguments.query
			.newQuery()
			.from( "cb_site" )
			.where( "siteId", 1 )
			.delete();
	}

	/********************* MIGRATION UPDATES *************************/

	private function createSiteRelationships( schema, query ){

		// TODO:

		systemOutput( "********************************************", true );
		systemOutput( "√√√ All Site relationships finalized", true );
		systemOutput( "********************************************", true );
	}

	private function updateBooleanBits( schema, query ){
		arguments.schema.alter( "cb_author", ( table ) => {
			table.modifyColumn( "isDeleted", table.tinyInteger( "isDeleted" ).default( false ) );
			table.modifyColumn( "isActive", table.tinyInteger( "isActive" ).default( true ) );
		} );
		systemOutput( "√ - Author boolean bits updated", true );

		arguments.schema.alter( "cb_category", ( table ) => {
			table.modifyColumn( "isDeleted", table.tinyInteger( "isDeleted" ).default( false ) );
		} );
		systemOutput( "√ - Category boolean bits updated", true );

		arguments.schema.alter( "cb_comment", ( table ) => {
			table.modifyColumn( "isDeleted", table.tinyInteger( "isDeleted" ).default( false ) );
			table.modifyColumn( "isApproved", table.tinyInteger( "isActive" ).default( false ) );
		} );
		systemOutput( "√ - Comment boolean bits updated", true );

		arguments.schema.alter( "cb_content", ( table ) => {
			table.modifyColumn( "isDeleted", table.tinyInteger( "isDeleted" ).default( false ) );
			table.modifyColumn( "isPublished", table.tinyInteger( "isPublished" ).default( true ) );
			table.modifyColumn( "allowComments", table.tinyInteger( "allowComments" ).default( true ) );
			table.modifyColumn( "cache", table.tinyInteger( "cache" ).default( true ) );
			table.modifyColumn( "cacheLayout", table.tinyInteger( "cacheLayout" ).default( true ) );
			table.modifyColumn( "showInSearch", table.tinyInteger( "showInSearch" ).default( true ) );
		} );
		systemOutput( "√ - Content boolean bits updated", true );

		arguments.schema.alter( "cb_contentVersion", ( table ) => {
			table.modifyColumn( "isDeleted", table.tinyInteger( "isDeleted" ).default( false ) );
			table.modifyColumn( "isActive", table.tinyInteger( "isActive" ).default( true ) );
		} );
		systemOutput( "√ - Content Versioning boolean bits updated", true );

		arguments.schema.alter( "cb_customField", ( table ) => {
			table.modifyColumn( "isDeleted", table.tinyInteger( "isDeleted" ).default( false ) );
		} );
		systemOutput( "√ - Custom Fields boolean bits updated", true );

		arguments.schema.alter( "cb_loginAttempts", ( table ) => {
			table.modifyColumn( "isDeleted", table.tinyInteger( "isDeleted" ).default( false ) );
		} );
		systemOutput( "√ - Audit log boolean bits updated", true );

		arguments.schema.alter( "cb_menu", ( table ) => {
			table.modifyColumn( "isDeleted", table.tinyInteger( "isDeleted" ).default( false ) );
		} );
		systemOutput( "√ - Menus boolean bits updated", true );

		arguments.schema.alter( "cb_menuItem", ( table ) => {
			table.modifyColumn( "isDeleted", table.tinyInteger( "isDeleted" ).default( false ) );
		} );
		systemOutput( "√ - Menu Items boolean bits updated", true );

		arguments.schema.alter( "cb_module", ( table ) => {
			table.modifyColumn( "isDeleted", table.tinyInteger( "isDeleted" ).default( false ) );
			table.modifyColumn( "isActive", table.tinyInteger( "isActive" ).default( false ) );
		} );
		systemOutput( "√ - Modules boolean bits updated", true );

		arguments.schema.alter( "cb_page", ( table ) => {
			table.modifyColumn( "isDeleted", table.tinyInteger( "isDeleted" ).default( false ) );
			table.modifyColumn( "showInMenu", table.tinyInteger( "showInMenu" ).default( true ) );
			table.modifyColumn( "SSLOnly", table.tinyInteger( "SSLOnly" ).default( false ) );
		} );
		systemOutput( "√ - Pages boolean bits updated", true );

		arguments.schema.alter( "cb_permission", ( table ) => {
			table.modifyColumn( "isDeleted", table.tinyInteger( "isDeleted" ).default( false ) );
		} );
		systemOutput( "√ - Permissions boolean bits updated", true );

		arguments.schema.alter( "cb_permissionGroup", ( table ) => {
			table.modifyColumn( "isDeleted", table.tinyInteger( "isDeleted" ).default( false ) );
		} );
		systemOutput( "√ - Permission Groups boolean bits updated", true );

		arguments.schema.alter( "cb_role", ( table ) => {
			table.modifyColumn( "isDeleted", table.tinyInteger( "isDeleted" ).default( false ) );
		} );
		systemOutput( "√ - Roles boolean bits updated", true );

		arguments.schema.alter( "cb_securityRule", ( table ) => {
			table.modifyColumn( "isDeleted", table.tinyInteger( "isDeleted" ).default( false ) );
			table.modifyColumn( "useSSL", table.tinyInteger( "useSSL" ).default( false ) );
		} );
		systemOutput( "√ - Security Rules boolean bits updated", true );

		arguments.schema.alter( "cb_setting", ( table ) => {
			table.modifyColumn( "isDeleted", table.tinyInteger( "isDeleted" ).default( false ) );
			table.modifyColumn( "isCore", table.tinyInteger( "isCore" ).default( false ) );
		} );
		systemOutput( "√ - Settings boolean bits updated", true );

		arguments.schema.alter( "cb_stats", ( table ) => {
			table.modifyColumn( "isDeleted", table.tinyInteger( "isDeleted" ).default( false ) );
		} );
		systemOutput( "√ - Stats boolean bits updated", true );

		arguments.schema.alter( "cb_subscribers", ( table ) => {
			table.modifyColumn( "isDeleted", table.tinyInteger( "isDeleted" ).default( false ) );
		} );
		systemOutput( "√ - Subscribers boolean bits updated", true );

		arguments.schema.alter( "cb_subscriptions", ( table ) => {
			table.modifyColumn( "isDeleted", table.tinyInteger( "isDeleted" ).default( false ) );
		} );
		systemOutput( "√ - Subscriptions boolean bits updated", true );

		systemOutput( "********************************************", true );
		systemOutput( "√√√ All boolean bit updates finalized", true );
		systemOutput( "********************************************", true );
	}

	private function updateAdminPermissions( schema, query ){
		var admin = arguments.query
			.newQuery()
			.select( "roleID" )
			.from( "cb_role" )
			.where( "role", "Administrator" )
			.first();

		var siteAdmin = arguments.query
			.newQuery()
			.select( "permissionID" )
			.from( "cb_permission" )
			.where( "permission", "SITES_ADMIN" )
			.first();

		arguments.query
			.newQuery()
			.from( "cb_rolePermissions" )
			.insert( {
				"FK_roleID" : admin.roleID,
				"FK_permissionID" : siteAdmin.permissionID
			} );

		systemOutput( "√ - Admin role updated with new permissions", true );
	}

	private function createSitePermission( schema, query ){
		arguments.query
			.newQuery()
			.from( "cb_permission" )
			.insert( {
				"createdDate" : today,
				"modifiedDate" : today,
				"isDeleted" : 0,
				"permission" : "SITES_ADMIN",
				"decription" : "Ability to manage sites"
			} );
		systemOutput( "√ - Site Admin permission created", true );
	}

	private function createDefaultSite( schema, query ){

		var defaultSite = arguments.query
			.newQuery()
			.select( "siteId" )
			.from( "cb_site" )
			.where( "slug", "default" )
			.first();

		if( !isEmpty( defaultSite ) ){
			systemOutput( "X - Default site already created, skipping migration", true );
			return;
		}

		arguments.query
			.newQuery()
			.from( "cb_site" )
			.insert( {
				"siteId" : 1,
				"createdDate" : today,
				"modifiedDate" : today,
				"isDeleted" : 0,
				"name" : "Default Site",
				"slug" : "default",
				"description" : "The default site",
				"domainRegex" : ".*",
				"isBlogEnabled" : true,
				"isSitemapEnabled" : true,
				"poweredByHeader" : true,
				"adminBar" : true,
				"isSSL" : false,
				"activeTheme" : "default",
				"domain" : "127.0.0.1"
			} );

		systemOutput( "√ - Default site migrated", true );
	}

}
