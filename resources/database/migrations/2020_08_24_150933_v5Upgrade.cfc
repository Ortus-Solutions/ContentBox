component {

    function up( schema, query ) {
		variables.today = now();

		transaction{
			// Create Default Site
			createDefaultSite( argumentCollection=arguments );
			// Create Site Permission
			createSitePermission( argumentCollection=arguments );
			// Update Admin role with Site Permission
			updateAdminPermissions( argumentCollection=arguments );
			// Remove Setting Name Unique Constraint
			schema.alter( "cb_setting", ( table ) => table.dropConstraint( "name" ) );
			systemOutput( "√ - Setting name unique constraint dropped", true );
			// Remove Content Unique Constraint
			schema.alter( "cb_content", ( table ) => table.dropConstraint( "slug" ) );
			systemOutput( "√ - Content slug unique constraint dropped", true );
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
