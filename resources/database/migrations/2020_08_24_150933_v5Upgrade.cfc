/**
 * This migration is to migrate ContentBox v4 databases to v5 standards.
 */
component {

	variables.today      = now();
	variables.siteTables = [
		"cb_category",
		"cb_content",
		"cb_menu",
		"cb_setting"
	];
	variables.newPermissions = [
		{
			name        : "SITES_ADMIN",
			description : "Ability to manage sites"
		}
	];

	private function isContentBox4(){
		// Check for columns created
		cfdbinfo(
			name  = "local.qSettingColumns",
			type  = "columns",
			table = "cb_setting"
		);

		if(
			qSettingColumns.filter( ( thisRow ) => {
				// systemOutput( thisRow, true );
				return thisRow.column_name == "FK_siteId"
			} ).recordCount > 0
		){
			return false;
		}
		return true;
	}

	function up( schema, query ){
		// If you are on version 4 continue, else skip
		// If cb_setting doesn't have a FK_siteId then it's 4
		if( !isContentBox4() ){
			return;
		}

		transaction {
			try {
				// Update Boolean Bits: Removed, No longer needed
				// updateBooleanBits( argumentCollection = arguments );
				// Create Default Site
				arguments.siteId = createDefaultSite( argumentCollection = arguments );
				// Create Site Relationships
				createSiteRelationships( argumentCollection = arguments );
				// Create New Permissions
				createPermissions( argumentCollection = arguments );
				// Update Admin role with Site Permission
				updateAdminPermissions( argumentCollection = arguments );
				// Remove unused unique constraints
				removeUniqueConstraints( argumentCollection = arguments );
			} catch ( any e ) {
				transactionRollback();
				systemOutput( e.stacktrace, true );
				rethrow;
			}
		}
	}

	function down( schema, query ){
		if( !isContentBox4() ){
			return;
		}

		// Remove Site Relationships
		variables.siteTables.each( ( thisTable ) => {
			schema.alter( thisTable, ( table ) => {
				table.dropColumn( "FK_siteId" );
			} );
			systemOutput( "√ - Removed site relationship to '#thisTable#'", true );
		} );

		// Remove Site Table
		arguments.schema.drop( "cb_site" );

		// Remove permissions
		arguments.query
			.newQuery()
			.from( "cb_permissions" )
			.where( "name", "SITES_ADMIN" )
			.delete();
	}

	/********************* MIGRATION UPDATES *************************/

	private function removeUniqueConstraints( schema, query ){
		// Remove Setting Name Unique Constraint
		try {
			schema.alter( "cb_setting", ( table ) => table.dropConstraint( "name" ) );
			systemOutput( "√ - Setting name unique constraint dropped", true );
		} catch ( any e ) {
			if ( findNoCase( "column/key exists", e.message ) ) {
				systemOutput(
					"√ - Setting name unique constraint deletion skipped as it doesn't exist",
					true
				);
			} else {
				rethrow;
			}
		}

		// Remove Content Unique Constraint
		try {
			schema.alter( "cb_content", ( table ) => table.dropConstraint( "slug" ) );
			systemOutput( "√ - Content slug unique constraint dropped", true );
		} catch ( any e ) {
			if ( findNoCase( "column/key exists", e.message ) ) {
				systemOutput(
					"√ - Content slug unique constraint deletion skipped as it doesn't exist",
					true
				);
			} else {
				rethrow;
			}
		}

		// Remove category unique constraint
		try {
			schema.alter( "cb_category", ( table ) => table.dropConstraint( "slug" ) );
			systemOutput( "√ - Content Category slug unique constraint dropped", true );
		} catch ( any e ) {
			if ( findNoCase( "column/key exists", e.message ) ) {
				systemOutput(
					"√ - Content Category slug unique constraint deletion skipped as it doesn't exist",
					true
				);
			} else {
				rethrow;
			}
		}

		// Remove menu unique constraint
		try {
			schema.alter( "cb_menu", ( table ) => table.dropConstraint( "slug" ) );
			systemOutput( "√ - Menu slug unique constraint dropped", true );
		} catch ( any e ) {
			if ( findNoCase( "column/key exists", e.message ) ) {
				systemOutput(
					"√ - Menu slug unique constraint deletion skipped as it doesn't exist",
					true
				);
			} else {
				rethrow;
			}
		}
	}

	private function createSiteRelationships( schema, query, siteId ){
		variables.siteTables.each( ( thisTable ) => {
			// Check for columns created
			cfdbinfo(
				name  = "local.qColumns",
				type  = "columns",
				table = thisTable
			);

			var isSiteColumnCreated = qColumns.filter( ( thisRow ) => {
				// systemOutput( thisRow, true );
				return thisRow.column_name == "FK_siteId"
			} ).recordCount > 0;

			if ( isSiteColumnCreated ) {
				systemOutput(
					"√ - Site relationship for '#thisTable#' already defined, skipping",
					true
				);
			} else {
				// Add site id relationship
				schema.alter( thisTable, ( table ) => {
					table.addColumn( table.unsignedInteger( "FK_siteId" ).nullable() );
				} );
				systemOutput( "√ - Created site column on '#thisTable#'", true );
			}

			// Seed with site id
			if ( thisTable != "cb_setting" ) {
				query
					.newQuery()
					.from( thisTable )
					.whereNull( "FK_siteId" )
					.orWhere( "FK_siteId", 0 )
					.update( { "FK_siteId" : siteId } );

				systemOutput( "√ - Populated '#thisTable#' with default site data", true );
			}

			// Add foreign key
			if ( !isSiteColumnCreated ) {
				schema.alter( thisTable, ( table ) => {
					table.addConstraint(
						table
							.foreignKey( "FK_siteId" )
							.references( "siteId" )
							.onTable( "cb_site" )
							.onDelete( "CASCADE" )
					);
				} );
				systemOutput( "√ - Created site foreign key on '#thisTable#'", true );
			}
		} );
	}

	/**
	 * Updates the admin with newer permissions
	 */
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

		var sitePermissionFound = !arguments.query
			.newQuery()
			.select( "FK_permissionID" )
			.from( "cb_rolePermissions" )
			.where( "FK_permissionID", siteAdmin.permissionId )
			.first()
			.isEmpty();

		if ( !sitePermissionFound ) {
			arguments.query
				.newQuery()
				.from( "cb_rolePermissions" )
				.insert( {
					"FK_roleID"       : admin.roleID,
					"FK_permissionID" : siteAdmin.permissionID
				} );
			systemOutput( "√ - Admin role updated with new permissions", true );
		} else {
			systemOutput( "√ - Admin role already has the new permissions, skipping", true );
		}
	}

	/**
	 * Creates the new permissions
	 */
	private function createPermissions( schema, query ){
		variables.newPermissions.each( ( thisPermission ) => {
			var isNewPermission = query
				.newQuery()
				.select( "permissionID" )
				.from( "cb_permission" )
				.where( "permission", thisPermission.name )
				.first()
				.isEmpty();

			if ( !isNewPermission ) {
				systemOutput(
					"√ - #thisPermission.name# permission already in database skipping",
					true
				);
				return;
			}

			query
				.newQuery()
				.from( "cb_permission" )
				.insert( {
					"createdDate"  : today,
					"modifiedDate" : today,
					"isDeleted"    : 0,
					"permission"   : thisPermission.name,
					"description"  : thisPermission.description
				} );
			systemOutput( "√ - #thisPermission.name# permission created", true );
		} );
	}

	/**
	 * Create multi-site support
	 */
	private function createDefaultSite( schema, query ){
		cfdbinfo( name = "local.qTables", type = "tables" );

		var isSiteTableCreated = qTables.filter( ( thisRow ) => {
			// systemOutput( thisRow, true );
			return thisRow.table_name == "cb_site"
		} ).recordCount > 0;

		if ( !isSiteTableCreated ) {
			// Create the site table
			arguments.schema.create( "cb_site", ( table ) => {
				table.increments( "siteId" );
				table.dateTime( "createdDate" );
				table.dateTime( "modifiedDate" );
				table.boolean( "isDeleted" ).default( false );
				table.string( "name" );
				table.string( "slug" ).unique();
				table.longText( "description" ).nullable();
				table.string( "domainRegex" ).nullable();
				table.string( "keywords" ).nullable();
				table.string( "tagline" ).nullable();
				table.string( "homepage" ).nullable();
				table.boolean( "isBlogEnabled" ).default( true );
				table.boolean( "isSitemapEnabled" ).default( true );
				table.boolean( "poweredByHeader" ).default( true );
				table.boolean( "adminBar" ).default( true );
				table.boolean( "isSSL" ).default( false );
				table.string( "activeTheme" ).nullable();
				table.longText( "notificationEmails" ).nullable();
				table.boolean( "notifyOnEntries" ).default( true );
				table.boolean( "notifyOnPages" ).default( true );
				table.boolean( "notifyOnContentStore" ).default( true );
				table.string( "domain" ).nullable();
			} );
			systemOutput( "√ - Site table created", true );
		} else {
			systemOutput( "√ - Site table already created, skipping", true );
		}

		var defaultSiteRecord = query
			.newQuery()
			.select( "siteId" )
			.from( "cb_site" )
			.where( "slug", "default" )
			.first();

		if ( defaultSiteRecord.isEmpty() ) {
			var allSettings = arguments.query
				.newQuery()
				.from( "cb_setting" )
				.whereNull( "FK_siteId" )
				.get()
				.reduce( ( results, thisSetting ) => {
					results[ thisSetting.name ] = thisSetting.value;
					return results;
				}, {} );

			var qResults = arguments.query
				.newQuery()
				.from( "cb_site" )
				.insert( {
					"siteId"             : 1,
					"createdDate"        : today,
					"modifiedDate"       : today,
					"isDeleted"          : false,
					"name"               : allSettings.cb_site_name,
					"slug"               : "default",
					"homepage"           : allSettings.cb_site_homepage,
					"description"        : allSettings.cb_site_description,
					"keywords"           : allSettings.cb_site_keywords,
					"tagline"            : allSettings.cb_site_tagline,
					"domainRegex"        : "127\.0\.0\.1",
					"isBlogEnabled"      : true,
					"isSitemapEnabled"   : true,
					"poweredByHeader"    : true,
					"adminBar"           : true,
					"isSSL"              : false,
					"activeTheme"        : "default",
					"domain"             : "127.0.0.1",
					"notificationEmails" : allSettings.cb_site_email
				} );
			systemOutput( "√ - Default site created", true );
			return qResults.result.generatedKey;
		} else {
			systemOutput( "√ - Default site already created, skipping", true );
			return defaultSiteRecord.siteId;
		}
	}

}
