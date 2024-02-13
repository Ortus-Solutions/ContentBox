/**
 * This migration is to migrate ContentBox v4 databases to v5 standards.
 */
component {

	// DI
	property name="migrationService" inject="MigrationService@cfmigrations";

	// Include Utils
	include template = "./util/MigrationUtils.cfm";

	function up( schema, query ){
		// In order of dependency
		var migrations = [
			"sites"                   : { table : "cb_site" },
			"settings"                : { table : "cb_setting" },
			"permissions"             : { table : "cb_permission" },
			"permission_groups"       : { table : "cb_permissionGroup" },
			"group_permissions"       : { table : "cb_groupPermissions" },
			"roles"                   : { table : "cb_role" },
			"role_permissions"        : { table : "cb_rolePermissions" },
			"author"                  : { table : "cb_author" },
			"author_permissions"      : { table : "cb_authorPermissions" },
			"author_permission_groups": { table : "cb_authorPermissionGroups" },
			"category"                : { table : "cb_category" },
			"content"                 : { table : "cb_content" },
			"content_versions"        : { table : "cb_contentVersion" },
			"content_categories"      : { table : "cb_contentCategories" },
			"contentStore"            : { table : "cb_contentStore" },
			"entry"                   : { table : "cb_entry" },
			"page"                    : { table : "cb_page" },
			"stats"                   : { table : "cb_stats" },
			"related_content"         : { table : "cb_relatedContent" },
			"content_templates"       : { table : "cb_contentTemplate" },
			"comments"                : { table : "cb_comment" },
			"custom_fields"           : { table : "cb_customfield" },
			"login_attempts"          : { table : "cb_loginAttempts" },
			"menus"                   : { table : "cb_menu" },
			"menu_items"              : { table : "cb_menuItem" },
			"modules"                 : { table : "cb_module" },
			"relocations"             : { table : "cb_relocations" },
			"security_rules"          : { table : "cb_securityRule" },
			"subscribers"             : { table : "cb_subscribers" },
			"subscriptions"           : { table : "cb_subscriptions" },
			"comment_subscriptions"   : { table : "cb_commentSubscriptions" },
			"security_logs"           : { table : "cbsecurity_logs" },
			"jwt"                     : { table : "cb_jwt" }
		];

		systemOutput( "Starting to initialize the ContentBox Database, this will take a while...", true );

		migrations.each( ( migration, record ) => {
			systemOutput( "Migrating [#migration#]...", true );

			if ( !schema.hasTable( record.table ) ) {
				systemOutput( "- Table doesn't exist (#record.table#) creating it...", true );
				new "init.create_#migration#"( ).up( schema, query );

				// Seeding Permissions
				if ( migration == "permissions" ) {
					systemOutput( "- Seeding permissions...", true );
					new init.seed_permissions().seed( schema, query );
				}

				// Seeding Roles
				if ( migration == "role_permissions" ) {
					systemOutput( "- Seeding roles...", true );
					new init.seed_roles().seed( schema, query );
				}
			} else {
				systemOutput( "√ Table (#record.table#) already exists, skipping...", true );
			}
		} );

		systemOutput( "√ Database structure complete", true );
	}

	function down( schema, query ){
	}

}
