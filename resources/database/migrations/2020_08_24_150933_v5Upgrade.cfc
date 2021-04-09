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

		scopeGrammarUDFs( argumentCollection=arguments );

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
		dropIndexesForTableColumn( "cb_settings", "name" );
		systemOutput( "√ - Setting name unique constraint dropped", true );

		// Remove Content Unique Constraint
		dropIndexesForTableColumn( "cb_content", "slug" );
		systemOutput( "√ - Content slug unique constraint dropped", true );

		// Remove category unique constraint
		dropIndexesForTableColumn( "cb_category", "slug" );
		systemOutput( "√ - Content Category slug unique constraint dropped", true );

		// Remove menu unique constraint
		dropIndexesForTableColumn( "cb_menu", "slug" );
		systemOutput( "√ - Menu slug unique constraint dropped", true );

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
			query
				.newQuery()
				.from( thisTable )
				.whereNull( "FK_siteId" )
				.update( { "FK_siteId" : siteId } );

			systemOutput( "√ - Populated '#thisTable#' with default site data", true );

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
					"id" : uuidLib.randomUUID().toString(),
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
				"id"                 : initialSiteIdentifier,
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

		var siteSettings = [
				// Global HTML: Panel Section
				"cb_html_beforeHeadEnd",
				"cb_html_afterBodyStart",
				"cb_html_beforeBodyEnd",
				"cb_html_beforeContent",
				"cb_html_afterContent",
				"cb_html_beforeSideBar",
				"cb_html_afterSideBar",
				"cb_html_afterFooter",
				"cb_html_preEntryDisplay",
				"cb_html_postEntryDisplay",
				"cb_html_preIndexDisplay",
				"cb_html_postIndexDisplay",
				"cb_html_preArchivesDisplay",
				"cb_html_postArchivesDisplay",
				"cb_html_preCommentForm",
				"cb_html_postCommentForm",
				"cb_html_prePageDisplay",
				"cb_html_postPageDisplay",
				// Site Comment Settings
				"cb_comments_enabled",
				"cb_comments_maxDisplayChars",
				"cb_comments_notify",
				"cb_comments_moderation_notify",
				"cb_comments_notifyemails",
				"cb_comments_moderation",
				"cb_comments_moderation_whitelist",
				"cb_comments_moderation_blacklist",
				"cb_comments_moderation_blockedlist",
				"cb_comments_moderation_expiration"
		];

		// Assign all null site settings to the default
		query
			.newQuery()
			.from( "cb_setting" )
			.whereNull( "FK_siteId" )
			.whereIn( "name", siteSettings )
			.update( { "FK_siteId" : initialSiteIdentifier } );

		return initialSiteIdentifier;
	}

	function migrateIdentifiersToGUIDs( schema, query ){

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
			dropForeignKeysAndConstraints( tableName, pkColumn );
			var tmpColumn = "tmp_" & pkColumn;
			schema.alter( tableName, function( table ){
				table.addColumn( table.uuid( tmpColumn ).nullable() );
			} );
			populateChildFKValues( tmpColumn, tableName );
		} );

		// Update all foreign keys
		FKMap.keyArray().each( function( tableName ){
			var FKeys = FKMap[ tableName ];
			FKeys.each( function( keyConfig ){

				dropForeignKeysAndConstraints( tableName, keyConfig.column );

				var tmpColumn = "tmp_" & keyConfig.column;
				schema.alter( tableName, function( table ){
					table.addColumn( table.uuid( tmpColumn ).nullable() );
				} );

				populateFKValues( tmpColumn, tableName, keyConfig );

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
				table.dropColumn( pkColumn );
				table.addConstraint( table.primaryKey( "id" ) );
			} );
		} );

		// Now restore the foreign key constraints
		FKMap.keyArray().each( function( tableName ){
			var FKeys = FKMap[ tableName ];
			FKeys.each( function( keyConfig ){
				var tmpColumn = "tmp_" & keyConfig.column;
				schema.alter( tableName, function( table ){
					table.addConstraint( table.uuid( keyConfig.column ).references( "id" ).onTable( keyConfig.reference.table ) );
				} );

			} );

		} );


		// Change primary keys over on child tables
		childTables.keyArray().each( function( tableName ){
			var pkColumn = childTables[ tableName ].key;
			var tmpColumn = "tmp_" & pkColumn;
			schema.alter( tableName, function( table ){
				queryExecute( pkDropSQL( tableName, pkColumn ) );
				//ensure it is a not null field before we make it PK
				table.modifyColumn( tmpColumn, table.uuid( tmpColumn ) );

				table.addConstraint( table.primaryKey( tmpColumn ) );
				table.dropColumn( pkColumn );
				table.renameColumn( tmpColumn, table.uuid( pkColumn ) );
				table.addConstraint( table.uuid( pkColumn ).references( "id" ).onTable( childTables[ tableName ].parent ) );
			} );
		} );


		systemOutput( "√ - All tables migrated from incremental identifiers to GUIDs", true );

	}


	function scopeGrammarUDFs( query, schema ){

		variables.idTables = {
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

		variables.childTables = {
			"cb_entry" : { "parent" : "cb_content", "key" : "contentID" },
			"cb_page" : { "parent" : "cb_content", "key" : "contentID" },
			"cb_contentStore" : {"parent" : "cb_content", "key" : "contentID"},
			"cb_commentSubscriptions" : { "parent": "cb_subscriptions", "key" : "subscriptionID"}
		};

		variables.FKMap = {
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

		var grammar = query.getGrammar();
		if( isInstanceOf( grammar, "AutoDiscover" ) ){
			grammar = grammar.autoDiscoverGrammar();
		}

		switch( listLast( getMetadata( grammar ).name, "." ) ){
			case "MySQLGrammar":{
				variables.guidFn = 'UUID()';
				variables.populateFKValues = function( tmpColumn, tableName, keyConfig ){
					queryExecute("
					UPDATE #tableName#
					SET #tmpColumn# = ( SELECT id from #keyConfig.reference.table# WHERE #keyConfig.reference.table#.#keyConfig.reference.column# = #tableName#.#keyConfig.column# )
					");
				};

				variables.populateChildFKValues = function( tmpColumn, tableName ){
					queryExecute("
						UPDATE #tableName#
						SET #tmpColumn# = ( SELECT id from #childTables[ tableName ].parent# WHERE #childTables[ tableName ].parent#.#childTables[ tableName ].key# = #tableName#.#childTables[ tableName ].key# )
						");

				};

				variables.pkDropSQL = function( tableName, pkColumn ){ return "ALTER TABLE #arguments.tableName# DROP PRIMARY KEY, MODIFY #pkColumn# int(11)"; }
				variables.dropForeignKeysAndConstraints = function( tableName, columnName, dropReferenced=true ){
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
					if( arguments.dropReferenced && idTables.keyExists( tableName ) ){
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

				};
				variables.dropIndexesForTableColumn = function( tableName, columnName ){
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
				}
				break;
			}
			case "SqlServerGrammar":{
				variables.guidFn = 'NEWID()';
				variables.pkDropSQL = function( tableName ){
					var constraintName = queryExecute(
						"SELECT name
						FROM sys.key_constraints
						WHERE type = 'PK' AND OBJECT_NAME(parent_object_id) = N'#tableName#'"
					).name;

					return "ALTER TABLE #tableName# DROP CONSTRAINT #constraintName#";
				}
				variables.populateFKValues = function( tmpColumn, tableName, keyConfig ){
					queryExecute("
					UPDATE #tableName#
					SET #tmpColumn# = ( SELECT id from #keyConfig.reference.table# WHERE #keyConfig.reference.table#.#keyConfig.reference.column# = #tableName#.#keyConfig.column# )
					");
				};

				variables.populateChildFKValues = function( tmpColumn, tableName ){
					queryExecute("
						UPDATE #tableName#
						SET #tmpColumn# = ( SELECT id from #childTables[ tableName ].parent# WHERE #childTables[ tableName ].parent#.#childTables[ tableName ].key# = #tableName#.#childTables[ tableName ].key# )
						");

				};
				variables.dropForeignKeysAndConstraints = function( tableName, columnName, dropReferenced=true  ){

					query.newQuery().select( [ "sys.foreign_keys.name" ] )
								.from( "sys.foreign_keys" )
								.join( "sys.foreign_key_columns", "sys.foreign_key_columns.constraint_object_id", "sys.foreign_keys.OBJECT_ID" )
								.join( "sys.tables", "sys.tables.OBJECT_ID", "sys.foreign_keys.referenced_object_id" )
								.whereRaw( "OBJECT_NAME( sys.foreign_keys.parent_object_id ) = '#tableName#'" )
								.whereRaw( "COL_NAME(sys.foreign_key_columns.parent_object_id,sys.foreign_key_columns.parent_column_id) = '#columnName#'" )
								.get()
								.map( function( row ){ return row.name; } )
								.each( function( constraintName ){
									queryExecute( "ALTER TABLE #tableName# DROP CONSTRAINT #constraintName#");
								} );

					query.newQuery().select( [ "name" ] )
							.from( "sys.indexes" )
							.join( "sys.index_columns", "sys.indexes.index_id", "sys.index_columns.index_id" )
							.where( "sys.indexes.is_hypothetical", 0 )
							.whereRaw( "sys.indexes.object_id = OBJECT_ID( '#tableName#' ) and COL_NAME(sys.index_columns.object_id,sys.index_columns.column_id) = '#columnName#' AND name NOT LIKE 'PK_%'" )
							.get()
							.map( function( row ){ return row.name; } )
							.each( function( indexName ){
								queryExecute( listFirst( indexName, "_" ) == 'UQ' ? "ALTER TABLE #tableName# DROP CONSTRAINT #indexName#" : "DROP INDEX IF EXISTS #indexName# on #tableName#");
							} );

					// Drop any foreign keys which reference this table
					if( arguments.dropReferenced && idTables.keyExists( tableName ) ){
						query.newQuery().selectRaw( "sys.foreign_keys.name as constraint_name, OBJECT_NAME( sys.foreign_keys.parent_object_id ) as table_name")
								.from( "sys.foreign_keys" )
								.join( "sys.foreign_key_columns", "sys.foreign_key_columns.constraint_object_id", "sys.foreign_keys.OBJECT_ID" )
								.join( "sys.tables", "sys.tables.OBJECT_ID", "sys.foreign_keys.referenced_object_id" )
								.whereRaw( "OBJECT_NAME (sys.foreign_keys.referenced_object_id) = '#tableName#'" )
								.get()
								.map( function( row ){ return { "table" : row.table_name, "constraint" : row.constraint_name }; } )
								.each( function( row ){
									queryExecute( "ALTER TABLE #row.table# DROP CONSTRAINT #row.constraint#");
								} );
					}

				}

				variables.dropIndexesForTableColumn = function( tableName, columnName ){
					query.newQuery().select( [ "name" ] )
							.from( "sys.indexes" )
							.join( "sys.index_columns", "sys.indexes.index_id", "sys.index_columns.index_id" )
							.where( "sys.indexes.is_hypothetical", 0 )
							.whereRaw( "sys.indexes.object_id = OBJECT_ID( '#tableName#' ) and COL_NAME(sys.index_columns.object_id,sys.index_columns.column_id) = '#columnName#' AND sys.indexes.type > 2" )
							.get()
							.map( function( row ){ return row.name; } )
							.each( function( indexName ){
								// These may be either constraints or indexes, depending.  Try both
								try{
									queryExecute( "ALTER TABLE #tableName# DROP CONSTRAINT #indexName#" );
								} catch( any e ){
									queryExecute( "DROP INDEX #indexName# on #tableName#" );
								}
							} );
				}
				break;
			}
			case "PostgresGrammar":
			case "OracleGrammar":{
				throw(
					"Database Migrations from ContentBox v4 to v5 are not supported for this DBMS platform"
				);
			}
			default:{
				throw( "DBMS Grammatical type could not be determined from the grammar #getMetadata( grammar ).name#.  The migration must be aborted." );
			}
		}
	}

}
