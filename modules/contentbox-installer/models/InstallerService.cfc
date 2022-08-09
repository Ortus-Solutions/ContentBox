/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Installs ContentBox
 */
component accessors="true" {

	// DI
	property name="siteService" inject="siteService@contentbox";
	property name="authorService" inject="authorService@contentbox";
	property name="settingService" inject="settingService@contentbox";
	property name="categoryService" inject="categoryService@contentbox";
	property name="pageService" inject="pageService@contentbox";
	property name="entryService" inject="entryService@contentbox";
	property name="commentService" inject="commentService@contentbox";
	property name="contentStoreService" inject="contentStoreService@contentbox";
	property name="roleService" inject="roleService@contentbox";
	property name="permissionService" inject="permissionService@contentbox";
	property name="securityRuleService" inject="securityRuleService@contentbox";
	property name="appPath" inject="coldbox:setting:applicationPath";
	property name="coldbox" inject="coldbox";

	/**
	 * Constructor
	 */
	InstallerService function init(){
		variables.permissions = {};
		return this;
	}

	/**
	 * Execute the installer
	 *
	 * @setup The setup object
	 */
	function execute( required setup ){
		transaction {
			// process rewrite rules according to setup install
			if ( arguments.setup.getFullRewrite() ) {
				processRewrite( arguments.setup );
			}
			// create global roles
			var adminRole = createRoles( arguments.setup );
			// create the admin author
			var author    = createAuthor( arguments.setup, adminRole );
			// Create the default site
			var site      = createSite( arguments.setup );
			// Create global settings according to setup
			createSettings( arguments.setup, site );
			// Create global security rules
			createSecurityRules( arguments.setup );
			// Do we create sample data for the default site?
			if ( arguments.setup.getPopulateData() ) {
				createSampleData( arguments.setup, author, site );
			}
			// Do we create a Development Site?
			if ( arguments.setup.getCreateDevSite() ) {
				var devSite = createDevSite( arguments.setup );
				// Populate the dev site?
				if ( arguments.setup.getPopulateData() ) {
					createSampleData( arguments.setup, author, devSite );
				}
			}

			// Remove ORM update from Application.cfc
			// Commented out for better update procedures.
			processORMUpdate( arguments.setup );
			// Process reinit and debug password security
			processColdBoxPasswords( arguments.setup );
			// ContentBox is now online, mark it:
			variables.settingService.activateCB();
			// Reload Security Rules
			variables.coldbox
				.getInterceptorService()
				.getInterceptor( "cbsecurity@global" )
				.configure();
		}
	}

	/**
	 * Create the site record
	 *
	 * @setup The setup object
	 *
	 * @return The site object
	 */
	function createSite( required setup ){
		var oSite = siteService.new( {
			"name"               : arguments.setup.getSiteName(),
			"slug"               : "default",
			"description"        : arguments.setup.getSiteDescription(),
			"keywords"           : arguments.setup.getSiteKeywords(),
			"domain"             : "127.0.0.1",
			"domainRegex"        : "127\.0\.0\.1",
			"tagline"            : arguments.setup.getSiteTagLine(),
			"homepage"           : "cbBlog",
			"isBlogEnabled"      : true,
			"isSitemapEnabled"   : true,
			"poweredByHeader"    : true,
			"adminBar"           : true,
			"isSSL"              : false,
			"activeTheme"        : "default",
			"notificationEmails" : arguments.setup.getSiteEmail()
		} );
		return siteService.save( oSite );
	}

	/**
	 * Create the development site record
	 *
	 * @setup The setup object
	 *
	 * @return The site object
	 */
	function createDevSite( required setup ){
		var oSite = siteService.new( {
			"name"               : "Development Site",
			"slug"               : "development",
			"description"        : "A development site",
			"keywords"           : "",
			"domain"             : "localhost",
			"domainRegex"        : "localhost",
			"tagline"            : "",
			"homepage"           : "cbBlog",
			"isBlogEnabled"      : true,
			"isSitemapEnabled"   : true,
			"poweredByHeader"    : true,
			"adminBar"           : true,
			"isSSL"              : false,
			"activeTheme"        : "default",
			"notificationEmails" : arguments.setup.getSiteEmail()
		} );
		return siteService.save( oSite );
	}

	/**
	 * Create global settings from setup
	 *
	 * @setup The setup object
	 * @site  The site object
	 */
	function createSettings( required setup, required site ){
		var settings = {
			"cb_site_email"         : arguments.setup.getSiteEmail(),
			"cb_site_outgoingEmail" : arguments.setup.getSiteOutgoingEmail(),
			"cb_site_mail_server"   : arguments.setup.getcb_site_mail_server(),
			"cb_site_mail_username" : arguments.setup.getcb_site_mail_username(),
			"cb_site_mail_password" : arguments.setup.getcb_site_mail_password(),
			"cb_site_mail_smtp"     : arguments.setup.getcb_site_mail_smtp(),
			"cb_site_mail_tls"      : arguments.setup.getcb_site_mail_tls(),
			"cb_site_mail_ssl"      : arguments.setup.getcb_site_mail_ssl()
		};

		// Save all settings
		settingService.saveAll(
			// Inflate, set, reduce to array
			settings.reduce( function( results, key, value ){
				arguments.results.append(
					variables.settingService.findByName( arguments.key ).setValue( arguments.value )
				);
				return arguments.results;
			}, [] )
		);
	}

	/**
	 * Create security rules
	 *
	 * @setup The setup object
	 */
	function createSecurityRules( required setup ){
		securityRuleService.resetRules();
	}

	/**
	 * Process ORM Update
	 *
	 * @setup The setup object
	 */
	function processORMUpdate( required setup ){
		var appCFCPath = appPath & "Application.cfc";
		var c          = fileRead( appCFCPath );

		fileWrite( appCFCPath, replaceNoCase( c, """dropcreate""", """update""" ) );

		return this;
	}

	/**
	 * Process ColdBox Passwords
	 *
	 * @setup The setup object
	 */
	function processColdBoxPasswords( required setup ){
		var configPath = appPath & "config/Coldbox.cfc";
		var c          = fileRead( configPath );
		var newPass    = hash( now() & setup.getUserData().toString(), "MD5" );
		c              = replaceNoCase( c, "@fwPassword@", newPass, "all" );
		fileWrite( configPath, c );
		coldbox.setSetting( "debugPassword", newpass );
		coldbox.setSetting( "reinitPassword", newpass );

		return this;
	}

	/**
	 * Process Rewrite Scripts
	 *
	 * @setup The setup object
	 */
	function processRewrite( required setup ){
		// rewrite on Router
		var routesPath = appPath & "config/Router.cfc";
		var c          = fileRead( routesPath );
		c              = replaceNoCase(
			c,
			"setFullRewrites( false )",
			"setFullRewrites( true )"
		);
		fileWrite( routesPath, c );

		// determine engine and setup the appropriate file for the rewrite engine
		switch ( arguments.setup.getRewrite_Engine() ) {
			case "mod_rewrite": {
				// do nothing, .htaccess already on root
				break;
			}
			case "contentbox_express":
			case "commandbox": {
				// do nothing, tuckey already setup at the servlet level on both commandbox and express.
				break;
			}
			case "iis7": {
				var webConfigPath = getDirectoryFromPath( getMetadata( this ).path ) & "web.config";
				// move web.config to root
				fileCopy( webConfigPath, appPath & "web.config" );
				break;
			}
		}

		return this;
	}

	/**
	 * Create permissions
	 *
	 * @setup The setup object
	 */
	function createPermissions( required setup ){
		var perms = {
			"AUTHOR_ADMIN"                  : "Ability to manage authors, default is view only",
			"CATEGORIES_ADMIN"              : "Ability to manage categories, default is view only",
			"COMMENTS_ADMIN"                : "Ability to manage comments, default is view only",
			"CONTENTBOX_ADMIN"              : "Access to the enter the ContentBox administrator console",
			"CONTENTSTORE_ADMIN"            : "Ability to manage the content store, default is view only",
			"CONTENTSTORE_EDITOR"           : "Ability to create, edit and publish content store elements",
			"EDITORS_CACHING"               : "Ability to view the content caching panel",
			"EDITORS_CATEGORIES"            : "Ability to view the content categories panel",
			"EDITORS_CUSTOM_FIELDS"         : "Ability to manage custom fields in any content editors",
			"EDITORS_DISPLAY_OPTIONS"       : "Ability to view the content display options panel",
			"EDITORS_EDITOR_SELECTOR"       : "Ability to change the editor to another registered online editor",
			"EDITORS_FEATURED_IMAGE"        : "Ability to view the featured image panel",
			"EDITORS_HTML_ATTRIBUTES"       : "Ability to view the content HTML attributes panel",
			"EDITORS_LINKED_CONTENT"        : "Ability to view the linked content panel",
			"EDITORS_MODIFIERS"             : "Ability to view the content modifiers panel",
			"EDITORS_RELATED_CONTENT"       : "Ability to view the related content panel",
			"EMAIL_TEMPLATE_ADMIN"          : "Ability to admin and preview email templates",
			"ENTRIES_ADMIN"                 : "Ability to manage blog entries, default is view only",
			"ENTRIES_EDITOR"                : "Ability to create, edit and publish blog entries",
			"FORGEBOX_ADMIN"                : "Ability to manage ForgeBox installations and connectivity.",
			"GLOBAL_SEARCH"                 : "Ability to do global searches in the ContentBox Admin",
			"GLOBALHTML_ADMIN"              : "Ability to manage the system's global HTML content used on layouts",
			"MEDIAMANAGER_ADMIN"            : "Ability to manage the system's media manager",
			"MEDIAMANAGER_LIBRARY_SWITCHER" : "Ability to switch media manager libraries for management",
			"MENUS_ADMIN"                   : "Ability to manage the menu builder",
			"MODULES_ADMIN"                 : "Ability to manage ContentBox Modules",
			"PAGES_ADMIN"                   : "Ability to manage content pages, default is view only",
			"PAGES_EDITOR"                  : "Ability to create, edit and publish pages",
			"PERMISSIONS_ADMIN"             : "Ability to manage permissions, default is view only",
			"RELOAD_MODULES"                : "Ability to reload modules",
			"ROLES_ADMIN"                   : "Ability to manage roles, default is view only",
			"SECURITYRULES_ADMIN"           : "Ability to manage the system's security rules, default is view only",
			"SITES_ADMIN"                   : "Ability to manage sites",
			"SYSTEM_AUTH_LOGS"              : "Access to the system auth logs",
			"SYSTEM_RAW_SETTINGS"           : "Access to the ContentBox raw geek settings panel",
			"SYSTEM_SAVE_CONFIGURATION"     : "Ability to update global configuration data",
			"SYSTEM_TAB"                    : "Access to the ContentBox System tools",
			"SYSTEM_UPDATES"                : "Ability to view and apply ContentBox updates",
			"THEME_ADMIN"                   : "Ability to manage layouts, default is view only",
			"TOOLS_EXPORT"                  : "Ability to export data from ContentBox",
			"TOOLS_IMPORT"                  : "Ability to import data into ContentBox",
			"VERSIONS_DELETE"               : "Ability to delete past content versions",
			"VERSIONS_ROLLBACK"             : "Ability to rollback content versions",
			"WIDGET_ADMIN"                  : "Ability to manage widgets, default is view only"
		};

		var allperms = [];
		for ( var key in perms ) {
			var props          = { permission : key, description : perms[ key ] };
			permissions[ key ] = permissionService.new( properties = props );
			arrayAppend( allPerms, permissions[ key ] );
		}
		permissionService.saveAll( entities = allPerms, transactional = false );

		return this;
	}

	/**
	 * Create roles and return the admin
	 *
	 * @setup The setup object
	 */
	function createRoles( required setup ){
		// Create Permissions
		createPermissions( arguments.setup );

		// Create Editor
		var oRole = roleService.new( properties = { role : "Editor", description : "A ContentBox editor" } );
		// Add Editor Permissions
		oRole.addPermission( permissions[ "COMMENTS_ADMIN" ] );
		oRole.addPermission( permissions[ "CONTENTSTORE_EDITOR" ] );
		oRole.addPermission( permissions[ "PAGES_EDITOR" ] );
		oRole.addPermission( permissions[ "CATEGORIES_ADMIN" ] );
		oRole.addPermission( permissions[ "ENTRIES_EDITOR" ] );
		oRole.addPermission( permissions[ "THEME_ADMIN" ] );
		oRole.addPermission( permissions[ "GLOBALHTML_ADMIN" ] );
		oRole.addPermission( permissions[ "MEDIAMANAGER_ADMIN" ] );
		oRole.addPermission( permissions[ "VERSIONS_ROLLBACK" ] );
		oRole.addPermission( permissions[ "CONTENTBOX_ADMIN" ] );
		oRole.addPermission( permissions[ "EDITORS_LINKED_CONTENT" ] );
		oRole.addPermission( permissions[ "EDITORS_DISPLAY_OPTIONS" ] );
		oRole.addPermission( permissions[ "EDITORS_RELATED_CONTENT" ] );
		oRole.addPermission( permissions[ "EDITORS_MODIFIERS" ] );
		oRole.addPermission( permissions[ "EDITORS_CACHING" ] );
		oRole.addPermission( permissions[ "EDITORS_CATEGORIES" ] );
		oRole.addPermission( permissions[ "EDITORS_HTML_ATTRIBUTES" ] );
		oRole.addPermission( permissions[ "EDITORS_EDITOR_SELECTOR" ] );
		oRole.addPermission( permissions[ "EDITORS_CUSTOM_FIELDS" ] );
		oRole.addPermission( permissions[ "GLOBAL_SEARCH" ] );
		oRole.addPermission( permissions[ "MENUS_ADMIN" ] );
		oRole.addPermission( permissions[ "EDITORS_FEATURED_IMAGE" ] );
		oRole.addPermission( permissions[ "EMAIL_TEMPLATE_ADMIN" ] );
		roleService.save( entity = oRole, transactional = false );

		// Create Admin
		var oRole = roleService.new(
			properties = {
				role        : "Administrator",
				description : "A ContentBox Administrator"
			}
		);
		// Add All Permissions To Admin
		for ( var key in permissions ) {
			oRole.addPermission( permissions[ key ] );
		}
		roleService.save( entity = oRole, transactional = false );

		return oRole;
	}

	/**
	 * Create author
	 *
	 * @setup     The setup object
	 * @adminRole The role of the admin string
	 */
	function createAuthor( required setup, required adminRole ){
		var oAuthor = variables.authorService
			.new( properties = arguments.setup.getUserData() )
			.setIsActive( true )
			.setRole( arguments.adminRole );

		return variables.authorService.save( oAuthor );
	}

	/**
	 * Create Sample Data
	 *
	 * @setup  The setup object
	 * @author The author created
	 * @site   The default site
	 */
	function createSampleData( required setup, required author, required site ){
		// create a few categories
		variables.categoryService.createCategories( "News, ColdFusion, ColdBox, ContentBox", arguments.site );

		// create some blog entries
		var entry = entryService.new(
			properties = {
				title              : "My first entry",
				slug               : "my-first-entry",
				publishedDate      : now(),
				isPublished        : true,
				allowComments      : true,
				passwordProtection : "",
				HTMLKeywords       : "cool,first entry, contentbox",
				HTMLDescription    : "The most amazing ContentBox blog entry in the world"
			}
		);
		entry.setCreator( arguments.author );
		entry.setSite( arguments.site );
		// version content
		entry.addNewContentVersion(
			content   = "Hey everybody, this is my first blog entry made from ContentBox.  Isn't this amazing!'",
			changelog = "Initial creation",
			author    = arguments.author
		);

		// good comment
		var comment = commentService.new(
			properties = {
				content     : "What an amazing blog entry, congratulations!",
				author      : "Awesome Joe",
				authorIP    : cgi.REMOTE_ADDR,
				authorEmail : "awesomejoe@contentbox.org",
				authorURL   : "www.ortussolutions.com",
				isApproved  : true
			}
		);
		comment.setRelatedContent( entry );
		entry.addComment( comment );

		// nasty comment
		var comment = commentService.new(
			properties = {
				content     : "I am some bad words and bad comment not approved",
				author      : "Bad Joe",
				authorIP    : cgi.REMOTE_ADDR,
				authorEmail : "badjoe@contentbox.org",
				authorURL   : "www.ortussolutions.com",
				isApproved  : false
			}
		);
		comment.setRelatedContent( entry );
		entry.addComment( comment );

		// save entry
		entryService.save( entry );

		// create a page
		var page = pageService.new(
			properties = {
				title              : "About",
				slug               : "about",
				publishedDate      : now(),
				isPublished        : true,
				allowComments      : false,
				passwordProtection : "",
				HTMLKeywords       : "about, contentbox,coldfusion,coldbox",
				HTMLDescription    : "The most amazing ContentBox page in the world",
				layout             : "pages"
			}
		);
		page.setCreator( arguments.author );
		page.setSite( arguments.site );
		// Add new version
		page.addNewContentVersion(
			content   = "<p>Hey welcome to my about page for ContentBox, isn't this great!</p><p>{{{ContentStore slug='contentbox'}}}</p>",
			changelog = "First creation",
			author    = arguments.author
		);
		pageService.save( page );

		// create a custom store element
		var contentStore = contentStoreService.new(
			properties = {
				title              : "Contact Info",
				slug               : "contentbox",
				publishedDate      : now(),
				isPublished        : true,
				allowComments      : false,
				passwordProtection : "",
				description        : "Our contact information"
			}
		);
		contentStore.setCreator( arguments.author );
		contentStore.setSite( arguments.site );
		contentStore.addNewContentVersion(
			content = "<p style=""text-align: center;"">
	<a href=""https://www.ortussolutions.com/products/contentbox""><img alt="""" src=""/index.cfm/__media/ContentBox_300.png"" /></a></p>
<p style=""text-align: center;"">
	Created by <a href=""https://www.ortussolutions.com"">Ortus Solutions, Corp</a> and powered by <a href=""http://coldbox.org"">ColdBox Platform</a>.</p>",
			changelog = "First creation",
			author    = arguments.author
		);
		contentStoreService.save( contentStore );
	}

}
