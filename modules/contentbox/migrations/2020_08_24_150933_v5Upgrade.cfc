/**
 * This migration is to migrate ContentBox v4 databases to v5 standards.
 */
component {

	// DI
	property name="migrationService" inject="MigrationService@cfmigrations";

	// Include Utils
	include template="./_MigrationUtils.cfm";

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
		try {
			return !hasColumn( "cb_setting", "FK_siteID" );
		} catch ( any e ) {
			// check if we don't have a database yet.
			if ( findNoCase( "there is no table", e.message ) ) {
				return false;
			} else {
				rethrow;
			}
		}
	}

	function up( schema, query ){
		// If you are on version 4 continue, else skip
		// If cb_setting doesn't have a FK_siteID then it's 4
		if ( !isContentBox4() ) {
			systemOutput(
				"- Skipping ContentBox v4 -> v5 Migration as we have detected you are already on the v5 schema",
				true
			);
			return;
		}

		// Get the db schema name, we might need it when dropping keys
		variables.dbSchema = migrationService.getSchema();
		variables.uuidLib  = createObject( "java", "java.util.UUID" );

		scopeGrammarUDFs( argumentCollection = arguments );

		try {
			migrateIdentifiersToGUIDs( argumentCollection = arguments );
		} catch ( any e ) {
			systemOutput( e.message, true );
			systemOutput( e.stacktrace, true );
			transactionRollback();
			throw(
				"Migration from identifiers to GUIDs failed due to the following: #e.message#.  Your database is now in an unusable state.  Please restore your database."
			);
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
				// Update Slugs/Titles to 1000 characters
				dropIndexesForTableColumn( "cb_content", "title" );
				dropIndexesForTableColumn( "cb_content", "slug" );
				schema.alter( "cb_content", function( table ){
					table.modifyColumn( "title", table.string( "title", 500 ) );
					table.modifyColumn( "slug", table.string( "slug", 500 ) );
					table.modifyColumn( "featuredImage", table.string( "featuredImage", 500 ).nullable() );
					table.modifyColumn( "featuredImageURL", table.string( "featuredImageURL", 500 ).nullable() );
					// Rebuild Indexes
					table.index( [ "slug" ], "idx_slug" );
					table.index( [ "slug", "isPublished" ], "idx_publishedSlug" );
					table.index( [ "title", "isPublished" ], "idx_search" );
				} );
				// Create Category isPublic with indexes
				if ( !hasColumn( "cb_category", "isPublic" ) ) {
					schema.alter( "cb_category", ( table ) => {
						table.addColumn( table.boolean( "isPublic" ).default( true ) );
						table.index( [ "isPublic" ], "idx_isPublic" );
					} );
				}
			} catch ( any e ) {
				transactionRollback();
				systemOutput( e.stacktrace, true );
				rethrow;
			}
		}
	}

	function down( schema, query ){
		if ( !isContentBox4() ) {
			return;
		}

		// Remove Site Relationships
		variables.siteTables.each( ( thisTable ) => {
			schema.alter( thisTable, ( table ) => {
				table.dropColumn( "FK_siteID" );
			} );
			systemOutput( "√ - Removed site relationship to '#thisTable#'", true );
		} );

		// Remove Site Table
		arguments.schema.drop( "cb_site" );

		// Remove permissions
		arguments.query
			.newQuery()
			.from( "cb_permission" )
			.where( "permission", "SITES_ADMIN" )
			.delete();
	}

	/********************* MIGRATION UPDATES *************************/

	private function removeUniqueConstraints( schema, query ){
		// Remove Setting Name Unique Constraint
		dropIndexesForTableColumn( "cb_setting", "name" );
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
			if ( !hasColumn( thisTable, "FK_siteID" ) ) {
				// Add site id relationship
				schema.alter( thisTable, ( table ) => {
					table.addColumn( table.string( "FK_siteID", 36 ).nullable() );
					table.addConstraint(
						table
							.foreignKey( "FK_siteID" )
							.references( "siteID" )
							.onTable( "cb_site" )
							.onDelete( "CASCADE" )
					);
				} );
				systemOutput( "√ - Created site column on '#thisTable#'", true );
			} else {
				systemOutput( "! - Skipped creating site column on '#thisTable#', it already had one", true );
			}

			// Seed with site id
			if ( thisTable != "cb_setting" ) {
				query
					.newQuery()
					.from( thisTable )
					.whereNull( "FK_siteID" )
					.update( { "FK_siteID" : siteId } );

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
			.where( "FK_permissionID", siteAdmin.permissionID )
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
				systemOutput( "√ - #thisPermission.name# permission already in database skipping", true );
				return;
			}

			query
				.newQuery()
				.from( "cb_permission" )
				.insert( {
					"permissionID" : uuidLib.randomUUID().toString(),
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
			table.string( "siteID", 36 ).primaryKey();
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
			table.boolean( "isActive" ).default( true );
		} );
		systemOutput( "√ - Site table created", true );

		schema.alter( "cb_setting", function( table ){
			table.addColumn( table.string( "FK_siteID", 36 ).nullable() );
			table.addConstraint(
				table
					.string( "FK_siteID", 36 )
					.references( "siteID" )
					.onTable( "cb_site" )
			);
		} );

		var allSettings = arguments.query
			.newQuery()
			.from( "cb_setting" )
			.whereNull( "FK_siteID" )
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
				"siteID"             : initialSiteIdentifier,
				"createdDate"        : today,
				"modifiedDate"       : today,
				"isDeleted"          : 0,
				"isActive"           : 1,
				"name"               : allSettings.cb_site_name,
				"slug"               : "default",
				"homepage"           : allSettings.cb_site_homepage,
				"description"        : allSettings.cb_site_description,
				"keywords"           : allSettings.cb_site_keywords,
				"tagline"            : allSettings.cb_site_tagline,
				"domainRegex"        : "127\.0\.0\.1",
				"isBlogEnabled"      : allSettings.cb_site_disable_blog ? 0 : 1,
				"isSitemapEnabled"   : allSettings.cb_site_sitemap ? 1 : 0,
				"poweredByHeader"    : allSettings.cb_site_poweredby ? 1 : 0,
				"adminBar"           : allSettings.cb_site_adminbar ? 1 : 0,
				"isSSL"              : allSettings.cb_admin_ssl ? 1 : 0,
				"activeTheme"        : allSettings.cb_site_theme,
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
			.whereIn( "name", siteSettings )
			.update( { "FK_siteID" : initialSiteIdentifier } );

		return initialSiteIdentifier;
	}

	/**
	 * Migrate numeric IDs to Guids
	 */
	function migrateIdentifiersToGUIDs( schema, query ){
		systemOutput( "> Starting to process migration of identifiers to uuid's...", true );

		// Create new master table identifiers with a temp name so we can migrate
		variables.idTables
			.keyArray()
			.each( function( tableName ){
				var pkColumn = idTables[ tableName ];
				schema.alter( tableName, function( table ){
					table.addColumn( table.string( "id", 36 ).default( "#guidFn#" ) );
				} );
				query
					.newQuery()
					.from( tableName )
					.update( { "id" : query.raw( "#guidFn#" ) } );
				systemOutput( "	√ - #tablename# new uuid pk created and populated", true );
			} );

		systemOutput( "√√ - Finalized adding new primary keys to all tables", true );
		systemOutput( "", true );
		systemOutput( "> Beginning to process child tables...", true );
		systemOutput( "", true );

		// Create child table foreign and future PKs
		childTables
			.keyArray()
			.each( function( tableName ){
				systemOutput( "> Starting to process child table: #tableName#", true );

				var pkColumn = childTables[ tableName ].key;
				dropForeignKeysAndConstraints( tableName, pkColumn );
				systemOutput( "	√ - (#tableName#) Dropped foreign key and constraints", true );

				var tmpColumn = "tmp_" & pkColumn;
				schema.alter( tableName, function( table ){
					table.addColumn( table.string( tmpColumn, 36 ).nullable() );
				} );
				populateChildFKValues( tmpColumn, tableName );
				systemOutput( "	√ - (#tableName#) rekeyed to new parent uuid", true );
			} );

		systemOutput( "√√ - Finalized rekeying all child tables", true );
		systemOutput( "", true );
		systemOutput( "> Beginning to process foreign keys...", true );
		systemOutput( "", true );

		// Update all foreign keys
		FKMap
			.keyArray()
			.each( function( tableName ){
				systemOutput( "> Starting to process (#arguments.tableName#) foreign keys...", true );

				var FKeys = FKMap[ arguments.tableName ];
				FKeys.each( function( keyConfig ){
					dropForeignKeysAndConstraints( tableName, arguments.keyConfig.column );
					systemOutput(
						"	√ - (#tableName#) Dropped foreign key and constraints (#arguments.keyConfig.column#)",
						true
					);

					var tmpColumn = "tmp_" & arguments.keyConfig.column;
					schema.alter( tableName, function( table ){
						table.addColumn( table.string( tmpColumn, 36 ).nullable() );
					} );
					populateFKValues( tmpColumn, tableName, arguments.keyConfig );
					schema.alter( tableName, function( table ){
						table.dropColumn( keyConfig.column );
						table.renameColumn( tmpColumn, table.string( keyConfig.column, 36 ).nullable() );
					} );
					systemOutput(
						"	√ - (#tableName#) foreign key (#arguments.keyConfig.column#) rekeyed as a uuid into (#tmpColumn#)",
						true
					);
				} );
			} );

		systemOutput( "√√ - Finalized rekeying all foreign keys to new uuid's", true );
		systemOutput( "", true );
		systemOutput( "> Beginning to drop original primary keys and rekeying tables with new uuids...", true );
		systemOutput( "", true );

		// Change primary keys over on master tables
		idTables
			.keyArray()
			.each( function( tableName ){
				systemOutput( "> Starting to process (#arguments.tableName#)...", true );
				var pkColumn = idTables[ tableName ];
				schema.alter( tableName, function( table ){
					queryExecute( pkDropSQL( tableName, pkColumn ) );
					table.dropColumn( pkColumn );
					// Rename it back to what it was called
					table.renameColumn( "id", table.string( pkColumn, 36 ).unique() )
					table.addConstraint( table.primaryKey( pkColumn ) );
				} );
				systemOutput( "	√ (#arguments.tableName#) new uuid key set and finalized!", true );
			} );

		systemOutput( "√√ - Finalized rekeying all tables with new identifiers and old identifiers dropped", true );
		systemOutput( "", true );
		systemOutput( "> Beginning restore all foreign key constraints...", true );
		systemOutput( "", true );

		// Now restore the foreign key constraints
		FKMap
			.keyArray()
			.each( function( tableName ){
				systemOutput( "> Starting to process (#arguments.tableName#)...", true );
				var FKeys = FKMap[ tableName ];
				FKeys.each( function( keyConfig ){
					var tmpColumn = "tmp_" & keyConfig.column;
					schema.alter( tableName, function( table ){
						table.addConstraint(
							table
								.string( keyConfig.column, 36 )
								.references( keyConfig.reference.column )
								.onTable( keyConfig.reference.table )
						);
					} );
				} );
				systemOutput( "	√ (#arguments.tableName#) foreign key constraints finalized!", true );
			} );

		systemOutput( "√√ - All foreign key constraints finalized", true );
		systemOutput( "", true );
		systemOutput( "> Restore child table primary keys to uuids...", true );
		systemOutput( "", true );

		// Change primary keys over on child tables
		childTables
			.keyArray()
			.each( function( tableName ){
				systemOutput( "> Processing child table (#arguments.tableName#)...", true );
				var pkColumn  = childTables[ tableName ].key;
				var tmpColumn = "tmp_" & pkColumn;
				schema.alter( tableName, function( table ){
					queryExecute( pkDropSQL( tableName, pkColumn ) );
					// ensure it is a not null field before we make it PK
					table.modifyColumn( tmpColumn, table.string( tmpColumn, 36 ) );
				} );
				schema.alter( tableName, function( table ){
					table.addConstraint( table.primaryKey( tmpColumn ) );
				} );
				schema.alter( tableName, function( table ){
					table.dropColumn( pkColumn );
					table.renameColumn( tmpColumn, table.string( pkColumn, 36 ) );
				} );
				schema.alter( tableName, function( table ){
					table.addConstraint(
						table
							.string( pkColumn, 36 )
							.references( pkColumn )
							.onTable( childTables[ tableName ].parent )
					);
				} );
				systemOutput( "	√ (#arguments.tableName#) finalized!", true );
			} );

		systemOutput( "√√√ - All tables migrated from incremental identifiers to GUIDs", true );
		systemOutput( "", true );
		systemOutput( "", true );
	}

	/**
	 * Utility functions per database
	 */
	function scopeGrammarUDFs( query, schema ){
		variables.idTables = {
			"cb_author"          : "authorID",
			"cb_category"        : "categoryID",
			"cb_comment"         : "commentID",
			"cb_content"         : "contentID",
			"cb_contentVersion"  : "contentVersionID",
			"cb_customfield"     : "customFieldID",
			"cb_loginAttempts"   : "loginAttemptsID",
			"cb_menu"            : "menuID",
			"cb_menuItem"        : "menuItemID",
			"cb_module"          : "moduleID",
			"cb_permission"      : "permissionID",
			"cb_permissionGroup" : "permissionGroupID",
			"cb_role"            : "roleID",
			"cb_securityRule"    : "ruleID",
			"cb_setting"         : "settingID",
			"cb_stats"           : "statsID",
			"cb_subscribers"     : "subscriberID",
			"cb_subscriptions"   : "subscriptionID"
		};

		variables.childTables = {
			"cb_entry"                : { "parent" : "cb_content", "key" : "contentID" },
			"cb_page"                 : { "parent" : "cb_content", "key" : "contentID" },
			"cb_contentStore"         : { "parent" : "cb_content", "key" : "contentID" },
			"cb_commentSubscriptions" : { "parent" : "cb_subscriptions", "key" : "subscriptionID" }
		};

		variables.FKMap = {
			"cb_authorPermissionGroups" : [
				{
					"column"    : "FK_permissionGroupID",
					"reference" : {
						"table"  : "cb_permissionGroup",
						"column" : "permissionGroupID"
					}
				},
				{
					"column"    : "FK_authorID",
					"reference" : { "table" : "cb_author", "column" : "authorID" }
				}
			],
			"cb_authorPermissions" : [
				{
					"column"    : "FK_permissionID",
					"reference" : { "table" : "cb_permission", "column" : "permissionID" }
				},
				{
					"column"    : "FK_authorID",
					"reference" : { "table" : "cb_author", "column" : "authorID" }
				}
			],
			"cb_rolePermissions" : [
				{
					"column"    : "FK_permissionID",
					"reference" : { "table" : "cb_permission", "column" : "permissionID" }
				},
				{
					"column"    : "FK_roleID",
					"reference" : { "table" : "cb_role", "column" : "roleID" }
				}
			],
			"cb_relatedContent" : [
				{
					"column"    : "FK_contentID",
					"reference" : { "table" : "cb_content", "column" : "contentID" }
				},
				{
					"column"    : "FK_relatedContentID",
					"reference" : { "table" : "cb_content", "column" : "contentID" }
				}
			],
			"cb_groupPermissions" : [
				{
					"column"    : "FK_permissionGroupID",
					"reference" : {
						"table"  : "cb_permissionGroup",
						"column" : "permissionGroupID"
					}
				},
				{
					"column"    : "FK_permissionID",
					"reference" : { "table" : "cb_permission", "column" : "permissionID" }
				}
			],
			"cb_contentCategories" : [
				{
					"column"    : "FK_contentID",
					"reference" : { "table" : "cb_content", "column" : "contentID" }
				},
				{
					"column"    : "FK_categoryID",
					"reference" : { "table" : "cb_category", "column" : "categoryID" }
				}
			],
			"cb_commentSubscriptions" : [
				{
					"column"    : "FK_contentID",
					"reference" : { "table" : "cb_content", "column" : "contentID" }
				}
			],
			"cb_author" : [
				{
					"column"    : "FK_roleID",
					"reference" : { "table" : "cb_role", "column" : "roleID" }
				}
			],
			"cb_menuItem" : [
				{
					"column"    : "FK_menuID",
					"reference" : { "table" : "cb_menu", "column" : "menuID" }
				},
				{
					"column"    : "FK_parentID",
					"reference" : { "table" : "cb_menuItem", "column" : "menuItemID" }
				}
			],
			"cb_customField" : [
				{
					"column"    : "FK_contentID",
					"reference" : { "table" : "cb_content", "column" : "contentID" }
				}
			],
			"cb_stats" : [
				{
					"column"    : "FK_contentID",
					"reference" : { "table" : "cb_content", "column" : "contentID" }
				}
			],
			"cb_comment" : [
				{
					"column"    : "FK_contentID",
					"reference" : { "table" : "cb_content", "column" : "contentID" }
				}
			],
			"cb_content" : [
				{
					"column"    : "FK_authorID",
					"reference" : { "table" : "cb_author", "column" : "authorID" }
				},
				{
					"column"    : "FK_parentID",
					"reference" : { "table" : "cb_content", "column" : "contentID" }
				}
			],
			"cb_contentVersion" : [
				{
					"column"    : "FK_authorID",
					"reference" : { "table" : "cb_author", "column" : "authorID" }
				},
				{
					"column"    : "FK_contentID",
					"reference" : { "table" : "cb_content", "column" : "contentID" }
				}
			],
			"cb_subscriptions" : [
				{
					"column"    : "FK_subscriberID",
					"reference" : { "table" : "cb_subscribers", "column" : "subscriberID" }
				}
			]
		};

		var grammar = query.getGrammar();
		if ( isInstanceOf( grammar, "AutoDiscover" ) ) {
			grammar = grammar.autoDiscoverGrammar();
		}

		switch ( listLast( getMetadata( grammar ).name, "." ) ) {
			case "MySQLGrammar": {
				variables.guidFn           = "UUID()";
				variables.populateFKValues = function( tmpColumn, tableName, keyConfig ){
					queryExecute(
						"
						UPDATE #arguments.tableName# as target
						JOIN #arguments.keyConfig.reference.table# as ref
							ON target.#arguments.keyConfig.column# = ref.#arguments.keyConfig.reference.column#
						SET target.#arguments.tmpColumn# = ref.id
					"
					);
				};

				variables.populateChildFKValues = function( tmpColumn, tableName ){
					queryExecute(
						"
						UPDATE #arguments.tableName#
						SET #arguments.tmpColumn# = (
							SELECT id from #childTables[ arguments.tableName ].parent#
							WHERE #childTables[ arguments.tableName ].parent#.#childTables[ arguments.tableName ].key# = #arguments.tableName#.#childTables[ arguments.tableName ].key#
						)
					"
					);
				};

				variables.pkDropSQL = function( tableName, pkColumn ){
					return "ALTER TABLE #arguments.tableName# DROP PRIMARY KEY, MODIFY #arguments.pkColumn# int(11)";
				}

				variables.dropForeignKeysAndConstraints = function( tableName, columnName, dropReferenced = true ){
					// Drop FKs
					query
						.newQuery()
						.select( [ "CONSTRAINT_NAME" ] )
						.from( "INFORMATION_SCHEMA.KEY_COLUMN_USAGE" )
						.where( "TABLE_NAME", tableName )
						.where( "COLUMN_NAME", columnName )
						.where( "CONSTRAINT_NAME", "!=", "PRIMARY" )
						.where( "TABLE_SCHEMA", variables.dbSchema )
						.whereNotNull( "REFERENCED_TABLE_NAME" )
						.get()
						.map( function( row ){
							return row.constraint_name;
						} )
						.each( function( constraintName ){
							queryExecute( "ALTER TABLE #tableName# DROP FOREIGN KEY #constraintName#" );
						} );

					// Drop Indexes
					query
						.newQuery()
						.select( [ "INDEX_NAME" ] )
						.from( "INFORMATION_SCHEMA.STATISTICS" )
						.where( "TABLE_NAME", tableName )
						.where( "COLUMN_NAME", columnName )
						.where( "INDEX_NAME", "!=", "PRIMARY" )
						.where( "TABLE_SCHEMA", variables.dbSchema )
						.get()
						.map( function( row ){
							return row.index_name;
						} )
						.each( function( indexName ){
							schema.alter( tableName, function( table ){
								table.dropConstraint( indexName );
							} );
						} );

					// Drop any foreign keys which reference this table
					if ( arguments.dropReferenced && idTables.keyExists( tableName ) ) {
						query
							.newQuery()
							.select( [ "CONSTRAINT_NAME", "TABLE_NAME" ] )
							.from( "INFORMATION_SCHEMA.KEY_COLUMN_USAGE" )
							.where( "REFERENCED_TABLE_NAME", tableName )
							.where( "REFERENCED_COLUMN_NAME", idTables[ tableName ] )
							.where( "CONSTRAINT_NAME", "!=", "PRIMARY" )
							.where( "TABLE_SCHEMA", variables.dbSchema )
							.whereNotNull( "TABLE_NAME" )
							.get()
							.map( function( row ){
								return {
									"table"      : row.table_name,
									"constraint" : row.constraint_name
								};
							} )
							.each( function( row ){
								queryExecute( "ALTER TABLE #row.table# DROP FOREIGN KEY #row.constraint#" );
							} );
					}
				};
				variables.dropIndexesForTableColumn = function( tableName, columnName ){
					query
						.newQuery()
						.select( [ "INDEX_NAME" ] )
						.from( "INFORMATION_SCHEMA.STATISTICS" )
						.where( "TABLE_NAME", tableName )
						.where( "COLUMN_NAME", columnName )
						.where( "INDEX_NAME", "!=", "PRIMARY" )
						.where( "TABLE_SCHEMA", variables.dbSchema )
						.get()
						.map( function( row ){
							return row.index_name;
						} )
						.each( function( indexName ){
							schema.alter( tableName, function( table ){
								table.dropConstraint( indexName );
							} );
						} );
				}
				break;
			}
			case "SqlServerGrammar": {
				variables.guidFn    = "NEWID()";
				variables.pkDropSQL = function( tableName ){
					var constraintName = queryExecute(
						"SELECT name
						FROM sys.key_constraints
						WHERE type = 'PK' AND OBJECT_NAME(parent_object_id) = N'#tableName#'"
					).name;

					return "ALTER TABLE #tableName# DROP CONSTRAINT #constraintName#";
				}
				variables.populateFKValues = function( tmpColumn, tableName, keyConfig ){
					queryExecute(
						"
						UPDATE target
							SET target.#arguments.tmpColumn# = ref.id
						FROM #arguments.tableName# as target
						JOIN #arguments.keyConfig.reference.table# as ref
							ON target.#arguments.keyConfig.column# = ref.#arguments.keyConfig.reference.column#
					"
					);
				};

				variables.populateChildFKValues = function( tmpColumn, tableName ){
					queryExecute(
						"
						UPDATE #arguments.tableName#
						SET #arguments.tmpColumn# = (
							SELECT id
							FROM #childTables[ arguments.tableName ].parent#
							WHERE #childTables[ arguments.tableName ].parent#.#childTables[ arguments.tableName ].key# = #arguments.tableName#.#childTables[ arguments.tableName ].key#
						)
					"
					);
				};

				variables.dropForeignKeysAndConstraints = function( tableName, columnName, dropReferenced = true ){
					query
						.newQuery()
						.select( [ "sys.foreign_keys.name" ] )
						.from( "sys.foreign_keys" )
						.join(
							"sys.foreign_key_columns",
							"sys.foreign_key_columns.constraint_object_id",
							"sys.foreign_keys.OBJECT_ID"
						)
						.join(
							"sys.tables",
							"sys.tables.OBJECT_ID",
							"sys.foreign_keys.referenced_object_id"
						)
						.whereRaw( "OBJECT_NAME( sys.foreign_keys.parent_object_id ) = '#tableName#'" )
						.whereRaw(
							"COL_NAME(sys.foreign_key_columns.parent_object_id,sys.foreign_key_columns.parent_column_id) = '#columnName#'"
						)
						.get()
						.map( function( row ){
							return row.name;
						} )
						.each( function( constraintName ){
							queryExecute( "ALTER TABLE #tableName# DROP CONSTRAINT #constraintName#" );
						} );

					query
						.newQuery()
						.select( [ "name" ] )
						.from( "sys.indexes" )
						.join(
							"sys.index_columns",
							"sys.indexes.index_id",
							"sys.index_columns.index_id"
						)
						.where( "sys.indexes.is_hypothetical", 0 )
						.whereRaw(
							"sys.indexes.object_id = OBJECT_ID( '#tableName#' ) and COL_NAME(sys.index_columns.object_id,sys.index_columns.column_id) = '#columnName#' AND name NOT LIKE 'PK_%'"
						)
						.get()
						.map( function( row ){
							return row.name;
						} )
						.each( function( indexName ){
							queryExecute(
								listFirst( indexName, "_" ) == "UQ" ? "ALTER TABLE #tableName# DROP CONSTRAINT #indexName#" : "DROP INDEX IF EXISTS #indexName# on #tableName#"
							);
						} );

					// Drop any foreign keys which reference this table
					if ( arguments.dropReferenced && idTables.keyExists( tableName ) ) {
						query
							.newQuery()
							.selectRaw(
								"sys.foreign_keys.name as constraint_name, OBJECT_NAME( sys.foreign_keys.parent_object_id ) as table_name"
							)
							.from( "sys.foreign_keys" )
							.join(
								"sys.foreign_key_columns",
								"sys.foreign_key_columns.constraint_object_id",
								"sys.foreign_keys.OBJECT_ID"
							)
							.join(
								"sys.tables",
								"sys.tables.OBJECT_ID",
								"sys.foreign_keys.referenced_object_id"
							)
							.whereRaw( "OBJECT_NAME (sys.foreign_keys.referenced_object_id) = '#tableName#'" )
							.get()
							.map( function( row ){
								return {
									"table"      : row.table_name,
									"constraint" : row.constraint_name
								};
							} )
							.each( function( row ){
								queryExecute( "ALTER TABLE #row.table# DROP CONSTRAINT #row.constraint#" );
							} );
					}
				}

				variables.dropIndexesForTableColumn = function( tableName, columnName ){
					query
						.newQuery()
						.select( [ "name" ] )
						.from( "sys.indexes" )
						.join(
							"sys.index_columns",
							"sys.indexes.index_id",
							"sys.index_columns.index_id"
						)
						.where( "sys.indexes.is_hypothetical", 0 )
						.whereRaw(
							"sys.indexes.object_id = OBJECT_ID( '#tableName#' ) and COL_NAME(sys.index_columns.object_id,sys.index_columns.column_id) = '#columnName#' AND sys.indexes.type > 2"
						)
						.get()
						.map( function( row ){
							return row.name;
						} )
						.each( function( indexName ){
							// These may be either constraints or indexes, depending.  Try both
							try {
								queryExecute( "ALTER TABLE #tableName# DROP CONSTRAINT #indexName#" );
							} catch ( any e ) {
								queryExecute( "DROP INDEX #indexName# on #tableName#" );
							}
						} );
				}
				break;
			}
			case "PostgresGrammar":
			case "OracleGrammar": {
				throw( "Database Migrations from ContentBox v4 to v5 are not supported for this DBMS platform" );
			}
			default: {
				throw(
					"DBMS Grammatical type could not be determined from the grammar #getMetadata( grammar ).name#.  The migration must be aborted."
				);
			}
		}
	}

}
