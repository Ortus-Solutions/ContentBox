/**
 * This migration is to migrate ContentBox v4 databases to v5 standards.
 */
component {

	// DI
	property name = "migrationService" inject = "MigrationService@cfmigrations";

	// Include Utils
	include template = "./util/MigrationUtils.cfm";

	function up( schema, query ){
		// In order of dependency
		var migrations = [
			"sites"                   : { table : "cb_site" },
			"settings"                : { table : "cb_setting" },
			"roles"                   : { table : "cb_role" },
			"permissions"             : { table : "cb_permission" },
			"permission_groups"       : { table : "cb_permissionGroup" },
			"role_permissions"        : { table : "cb_rolePermissions" },
			"group_permissions"       : { table : "cb_groupPermissions" },
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

			if( !schema.hasTable( record.table ) ){
				systemOutput( "- Table doesn't exist (#record.table#) creating it...", true );
				new "init.create_#migration#"().up( schema, query );
			} else {
				systemOutput( "√ Table (#record.table#) already exists, skipping...", true );
			}
		} );

		// Create default Site
		//createDefaultSite();
	}

	function down( schema, query ){
	}

	/**
	 * Create multi-site support
	 */
	private function createDefaultSite( schema, query ){
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
				"siteID"            : initialSiteIdentifier,
				"createdDate"       : today,
				"modifiedDate"      : today,
				"isDeleted"         : 0,
				"isActive"          : 1,
				"name"              : allSettings.cb_site_name,
				"slug"              : "default",
				"homepage"          : allSettings.cb_site_homepage,
				"description"       : allSettings.cb_site_description,
				"keywords"          : allSettings.cb_site_keywords,
				"tagline"           : allSettings.cb_site_tagline,
				"domainRegex"       : "127\.0\.0\.1",
				"isBlogEnabled"     : allSettings.cb_site_disable_blog ? 0: 1,
				"isSitemapEnabled"  : allSettings.cb_site_sitemap ? 1     : 0,
				"poweredByHeader"   : allSettings.cb_site_poweredby ? 1   : 0,
				"adminBar"          : allSettings.cb_site_adminbar ? 1    : 0,
				"isSSL"             : allSettings.cb_admin_ssl ? 1        : 0,
				"activeTheme"       : allSettings.cb_site_theme,
				"domain"            : "127.0.0.1",
				"notificationEmails": allSettings.cb_site_email
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

}
