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
			// create the admin author
			var author    = createAuthor( arguments.setup );
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
			"domain"             : arguments.setup.getSiteDomain(),
			"domainRegex"        : arguments.setup.getSiteDomainExpression(),
			"domainAliases" 	 : "[]",
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
			"domainAliases" 	 : "[]",
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
	 * Create author
	 *
	 * @setup     The setup object
	 */
	function createAuthor( required setup ){
		var oAuthor = variables.authorService
			.new( properties = arguments.setup.getUserData() )
			.setIsActive( true )
			.setRole( roleService.findByRole( "Administrator" ) );

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
