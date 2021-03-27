/**
 * This migration is to migrate ContentBox v4 databases to v5 standards.
 */
component {

	variables.today      = now();
	variables.siteTables = [
		"cb_category",
		"cb_content",
		"cb_menu"
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


		variables.uuidLib = createobject("java", "java.util.UUID");

		try{
			migrateIdentifiersToGUIDs( argumentCollection=arguments );
		} catch( any e ){
			systemOutput( e.message, true );
			systemOutput( e.stacktrace, true );
			transactionRollback();
			throw(
				"Migration from identifiers to GUIDs failed due to the following: #e.message#.  Your database is now in an unusable state.  Please restore your database."
			);
			rethrow;
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
			// Add site id relationship
			schema.alter( thisTable, ( table ) => {
				table.addColumn( table.uuid( "FK_siteId" ).nullable() );
				table.addConstraint(
					table
						.foreignKey( "FK_siteId" )
						.references( "id" )
						.onTable( "cb_site" )
						.onDelete( "CASCADE" )
				);
			} );

			systemOutput( "√ - Created site column on '#thisTable#'", true );

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

		} );
	}

	/**
	 * Updates the admin with newer permissions
	 */
	private function updateAdminPermissions( schema, query ){
		var admin = arguments.query
			.newQuery()
			.select( "id" )
			.from( "cb_role" )
			.where( "role", "Administrator" )
			.first();

		var siteAdmin = arguments.query
			.newQuery()
			.select( "id" )
			.from( "cb_permission" )
			.where( "permission", "SITES_ADMIN" )
			.first();

		var sitePermissionFound = !arguments.query
			.newQuery()
			.select( "FK_permissionID" )
			.from( "cb_rolePermissions" )
			.where( "FK_permissionID", siteAdmin.id )
			.first()
			.isEmpty();

		if ( !sitePermissionFound ) {
			arguments.query
				.newQuery()
				.from( "cb_rolePermissions" )
				.insert( {
					"FK_roleID"       : admin.id,
					"FK_permissionID" : siteAdmin.id
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
				.select( "id" )
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
					"id" 		   : uuidLib.randomUUID().toString(),
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

		// Create the site table
		arguments.schema.create( "cb_site", ( table ) => {
			table.uuid( "id" ).primaryKey();
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

		schema.alter(
			"cb_setting",
			function( table ){
				table.addColumn( table.uuid( "FK_siteId" ).nullable() );
				table.addConstraint( table.uuid( "FK_siteId" ).references( "id" ).onTable( "cb_site" ) )
			}
		);

		var allSettings = arguments.query
			.newQuery()
			.from( "cb_setting" )
			.whereNull( "FK_siteId" )
			.get()
			.reduce( ( results, thisSetting ) => {
				results[ thisSetting.name ] = thisSetting.value;
				return results;
			}, {} );


		var initialSiteIdentifier = uuidLib.randomUUID().toString();
		arguments.query
			.newQuery()
			.from( "cb_site" )
			.insert( {
				"id"             	 : initialSiteIdentifier,
				"createdDate"        : today,
				"modifiedDate"       : today,
				"isDeleted"          : 0,
				"name"               : allSettings.cb_site_name,
				"slug"               : "default",
				"homepage"           : allSettings.cb_site_homepage,
				"description"        : allSettings.cb_site_description,
				"keywords"           : allSettings.cb_site_keywords,
				"tagline"            : allSettings.cb_site_tagline,
				"domainRegex"        : "127\.0\.0\.1",
				"isBlogEnabled"      : 1,
				"isSitemapEnabled"   : 1,
				"poweredByHeader"    : 1,
				"adminBar"           : 1,
				"isSSL"              : 0,
				"activeTheme"        : "default",
				"domain"             : "127.0.0.1",
				"notificationEmails" : allSettings.cb_site_email
			} );
		systemOutput( "√ - Default site created", true );

		return initialSiteIdentifier;
	}

	function migrateIdentifiersToGUIDs( schema, query ){

		var grammar = query.getGrammar();
		if( isInstanceOf( grammar, "AutoDiscover" ) ){
			grammar = grammar.autoDiscoverGrammar();
		}

		var idTables = {
			"cb_author" : "authorID",
			"cb_category" : "categoryID",
			"cb_comment" : "commentID",
			"cb_content" : "contentID",
			"cb_contentVersion" : "contentVersionID",
			"cb_customfield" : "customFieldID",
			"cb_loginAttempts" : "loginAttemptsID",
			"cb_menu" : "menuID",
			"cb_menuItem" : "menuItemID",
			"cb_module" : "moduleID",
			"cb_permission" : "permissionID",
			"cb_permissionGroup" : "permissionGroupID",
			"cb_role" : "roleID",
			"cb_securityRule" : "ruleID",
			"cb_setting" : "settingID",
			"cb_stats" : "statsID",
			"cb_subscribers" : "subscriberID",
			"cb_subscriptions" : "subscriptionID"
		};

		var childTables = {
			"cb_entry" : { "parent" : "cb_content", "key" : "contentID" },
			"cb_page" : { "parent" : "cb_content", "key" : "contentID" },
			"cb_contentStore" : {"parent" : "cb_content", "key" : "contentID"},
			"cb_commentSubscriptions" : { "parent": "cb_subscriptions", "key" : "subscriptionID"}
		}

		var FKMap = {
			"cb_authorPermissionGroups" : [
				{
					"column" : "FK_permissionGroupID",
					"reference" : { "table" : "cb_permissionGroup", "column" : "permissionGroupID" }
				},
				{
					"column" : "FK_authorID",
					"reference" : { "table" : "cb_author", "column" : "authorID" }
				}
			],
			"cb_authorPermissions" : [
				{
					"column" : "FK_permissionID",
					"reference" : { "table" : "cb_permission", "column" : "permissionID" }
				},
				{
					"column" : "FK_authorID",
					"reference" : { "table" : "cb_author", "column" : "authorID" }
				}
			],
			"cb_rolePermissions" : [
				{
					"column" : "FK_permissionID",
					"reference" : { "table" : "cb_permission", "column" : "permissionID" }
				},
				{
					"column" : "FK_roleID",
					"reference" : { "table" : "cb_role", "column" : "roleID" }
				}
			],
			"cb_relatedContent" : [
				{
					"column" : "FK_contentID",
					"reference" : { "table" : "cb_content", "column" : "contentID" }
				},
				{
					"column" : "FK_relatedContentID",
					"reference" : { "table" : "cb_content", "column" : "contentID" }
				}
			],
			"cb_groupPermissions" : [
				{
					"column" : "FK_permissionGroupID",
					"reference" : { "table" : "cb_permissionGroup", "column" : "permissionGroupID" }
				},
				{
					"column" : "FK_permissionID",
					"reference" : { "table" : "cb_permission", "column" : "permissionID" }
				}
			],
			"cb_contentCategories" : [
				{
					"column" : "FK_contentID",
					"reference" : { "table" : "cb_content", "column" : "contentID" }
				},
				{
					"column" : "FK_categoryID",
					"reference" : { "table" : "cb_category", "column" : "categoryID" }
				}
			],
			"cb_commentSubscriptions" : [
				{
					"column" : "FK_contentID",
					"reference" : { "table" : "cb_content", "column" : "contentID" }
				}
			],
			"cb_author" : [
				{
					"column" : "FK_roleID",
					"reference" : { "table" : "cb_role", "column" : "roleID" }
				}
			],
			"cb_menuItem" : [
				{
					"column" : "FK_menuID",
					"reference" : { "table" : "cb_menu", "column" : "menuID" }
				},
				{
					"column" : "FK_parentID",
					"reference" : { "table" : "cb_menuItem", "column" : "menuItemID" }
				}
			],
			"cb_customField" : [
				{
					"column" : "FK_contentID",
					"reference" : { "table" : "cb_content", "column" : "contentID" }
				}
			],
			"cb_stats" : [
				{
					"column" : "FK_contentID",
					"reference" : { "table" : "cb_content", "column" : "contentID" }
				}
			],
			"cb_comment" : [
				{
					"column" : "FK_contentID",
					"reference" : { "table" : "cb_content", "column" : "contentID" }
				}
			],
			"cb_content" : [
				{
					"column" : "FK_authorID",
					"reference" : { "table" : "cb_author", "column" : "authorID" }
				},
				{
					"column" : "FK_parentID",
					"reference" : { "table" : "cb_content", "column" : "contentID" }
				}
			],
			"cb_contentVersion" : [
				{
					"column" : "FK_authorID",
					"reference" : { "table" : "cb_author", "column" : "authorID" }
				},
				{
					"column" : "FK_contentID",
					"reference" : { "table" : "cb_content", "column" : "contentID" }
				}
			],
			"cb_subscriptions" : [
				{
					"column" : "FK_subscriberID",
					"reference" : { "table" : "cb_subscribers", "column" : "subscriberID" }
				}
			]
		};

		switch( listLast( getMetadata( grammar ).name, "." ) ){
			case "MySQLGrammar":{
				var guidFn = 'UUID()';
				var populateFKValues = function( tableName, keyConfig ){
					queryExecute("
					UPDATE #tableName#
					SET #tmpColumn# = ( SELECT id from #keyConfig.reference.table# WHERE #keyConfig.reference.table#.#keyConfig.reference.column# = #tableName#.#keyConfig.column# )
					");
				};

				var populateChildFKValues = function( tmpColumn, tableName ){
					queryExecute("
						UPDATE #tableName#
						SET #tmpColumn# = ( SELECT id from #childTables[ tableName ].parent# WHERE #childTables[ tableName ].parent#.#childTables[ tableName ].key# = #tableName#.#childTables[ tableName ].key# )
						");

				};

				var pkDropSQL = function( tableName, pkColumn ){ return "ALTER TABLE #arguments.tableName# DROP PRIMARY KEY, MODIFY #pkColumn# int(11)"; }
				var dropForeignKeys = function( tableName, columnName ){
					query.newQuery().select( [ "CONSTRAINT_NAME" ] )
							.from( "INFORMATION_SCHEMA.KEY_COLUMN_USAGE" )
							.where( "TABLE_NAME", tableName )
							.where( "COLUMN_NAME", columnName )
							.where( "CONSTRAINT_NAME", "!=", "PRIMARY" )
							.whereNotNull( "REFERENCED_TABLE_NAME" )
							.get()
							.map( function( row ){ return row.constraint_name; } )
							.each( function( constraintName ){
								queryExecute( "ALTER TABLE #tableName# DROP FOREIGN KEY #constraintName#");
							} );

					query.newQuery().select( [ "INDEX_NAME" ] )
							.from( "INFORMATION_SCHEMA.STATISTICS" )
							.where( "TABLE_NAME", tableName )
							.where( "COLUMN_NAME", columnName )
							.where( "INDEX_NAME", "!=", "PRIMARY" )
							.get()
							.map( function( row ){ return row.index_name; } )
							.each( function( indexName ){
								schema.alter( tableName, function( table ){
									table.dropConstraint( indexName );
								} );
							} );

					// Drop any foreign keys which reference this table
					if( idTables.keyExists( tableName ) ){
						query.newQuery().select( [ "CONSTRAINT_NAME", "TABLE_NAME" ] )
								.from( "INFORMATION_SCHEMA.KEY_COLUMN_USAGE" )
								.where( "REFERENCED_TABLE_NAME", tableName )
								.where( "REFERENCED_COLUMN_NAME", idTables[ tableName ] )
								.where( "CONSTRAINT_NAME", "!=", "PRIMARY" )
								.whereNotNull( "TABLE_NAME" )
								.get()
								.map( function( row ){ return { "table" : row.table_name, "constraint" : row.constraint_name }; } )
								.each( function( row ){
									queryExecute( "ALTER TABLE #row.table# DROP FOREIGN KEY #row.constraint#");
								} );
					}

				}
				break;
			}
			case "PostgresGrammar":{
				var guidFn = 'gen_random_uuid()';
				var pkDropSQL = function( tableName ){
					var constraintName = queryExecute(
						"SELECT constraint_name FROM information_schema.table_constraints WHERE table_name = '#arguments.tableName#' and constraint_type = 'PRIMARY KEY'"
					).constraint_name;
					return "ALTER table #tableName# DROP CONSTRAINT #constraintName#";
				}
				break;
			}
			case "SqlServerGrammar":{
				var guidFn = 'NEWID()';
				var pkDropSQL = function( tableName ){
					var constraintName = queryExecute(
						"SELECT name
						FROM sys.key_constraints
						WHERE type = 'PK' AND OBJECT_NAME(parent_object_id) = N'#tableName#'"
					).name;

					return "ALTER TABLE #tableName# DROP CONSTRAINT #constraintName#";
				}
				break;
			}
			case "OracleGrammar":{
				var guidFn= 'sys_guid()';
				var pkDropSQL = function( tableName ){
					var constraintName = queryExecute(
						"SELECT constraint_name
						 FROM user_constraints
						 WHERE table_name = '#tableName#'
						 AND constraint_type = 'P'"
					).constraint_name;

					return "ALTER TABLE #tableName# DROP CONSTRAINT #constraintName#";
				}
				break;
			}
			default:{
				throw( "DBMS Grammatical type could not be determined from the grammar #getMetadata( grammar ).name#.  The migration must be aborted." );
			}
		}

		// Populate all of our new identifier columns
		idTables.keyArray().each( function( tableName ){
			var pkColumn = idTables[ tableName ];
			schema.alter( tableName, function( table ){
				table.addColumn( table.uuid( "id" ).unique().default( "#guidFn#" ) );
			} );
		} );

		// Create child table foreign and future PKs
		childTables.keyArray().each( function( tableName ){
			var pkColumn = childTables[ tableName ].key;
			dropForeignKeys( tableName, pkColumn );
			var tmpColumn = "tmp_" & pkColumn;
			schema.alter( tableName, function( table ){
				table.addColumn( table.uuid( tmpColumn ).nullable().unique() );
				table.addConstraint( table.uuid( tmpColumn ).references( "id" ).onTable( childTables[ tableName ].parent ) )
			} );
			populateChildFKValues( tmpColumn, tableName );
		} );

		// Update all foreign keys
		FKMap.keyArray().each( function( tableName ){
			var FKeys = FKMap[ tableName ];
			FKeys.each( function( keyConfig ){

				dropForeignKeys( tableName, keyConfig.column );

				var tmpColumn = "tmp_" & keyConfig.column;
				schema.alter( tableName, function( table ){
					table.addColumn( table.uuid( tmpColumn ).nullable() );
					table.addConstraint( table.uuid( tmpColumn ).references( "id" ).onTable( keyConfig.reference.table ) );
				} );

				populateFKValues( tableName, keyConfig );

				schema.alter( tableName, function( table ){
					table.dropColumn( keyConfig.column );
					table.renameColumn( tmpColumn, table.uuid( keyConfig.column ).nullable() );
				} );

			} );

		} );


		// Change primary keys over on master tables
		idTables.keyArray().each( function( tableName ){
			var pkColumn = idTables[ tableName ];
			schema.alter( tableName, function( table ){
				queryExecute( pkDropSQL( tableName, pkColumn ) );
				table.addConstraint( table.primaryKey( "id" ) );
				table.dropColumn( pkColumn );
			} );
		} );

		// Change primary keys over on child tables
		childTables.keyArray().each( function( tableName ){
			var pkColumn = childTables[ tableName ].key;
			var tmpColumn = "tmp_" & pkColumn;
			schema.alter( tableName, function( table ){
				queryExecute( pkDropSQL( tableName, pkColumn ) );
				table.addConstraint( table.primaryKey( tmpColumn ) );
				table.dropColumn( pkColumn );
				table.renameColumn( tmpColumn, table.uuid( pkColumn ) );
			} );
		} );


		systemOutput( "√ - All tables migrated from incremental identifiers to GUIDs", true );

	}

}
