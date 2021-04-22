/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Setting Service for ContentBox apps.
 * All settings are cached as a struct constructed using the following format:
 * - global : { name : value } // global settings
 * - sites : {
 * 		slug : { name : value }
 * }
 */
component
	extends  ="cborm.models.VirtualEntityService"
	accessors="true"
	threadsafe
	singleton
{

	// DI properties
	property name="siteService" inject="siteService@cb";
	property name="cachebox" inject="cachebox";
	property name="moduleSettings" inject="coldbox:setting:modules";
	property name="appMapping" inject="coldbox:setting:appMapping";
	property name="requestService" inject="coldbox:requestService";
	property name="coldbox" inject="coldbox";
	property name="dateUtil" inject="DateUtil@cb";
	property name="log" inject="logbox:logger:{this}";

	/**
	 * The cache provider name to use for settings caching. Defaults to 'template' cache.
	 * This can also be set in the global ContentBox settings page to any CacheBox cache.
	 */
	property name="cacheProviderName" default="template";

	/**
	 * Bit that detects if CB has been installed or not
	 */
	property
		name   ="CBReadyFlag"
		default="false"
		type   ="boolean";

	// Global Setting Defaults
	this.DEFAULTS = {
		// ContentBox Global Version
		"cb_version" : "@version.number@+@build.number@",
		// Installation security salt
		"cb_salt"                               : hash( createUUID() & getTickCount() & now(), "SHA-512" ),
		// Global Notifications
		"cb_site_email"                         : "",
		"cb_notify_author"                      : "true",
		"cb_notify_entry"                       : "true",
		"cb_notify_page"                        : "true",
		"cb_notify_contentstore"                : "true",
		// Outgoing email
		"cb_site_outgoingEmail"                 : "",
		// Blog Entry Point
		"cb_site_blog_entrypoint"               : "blog",
		// Caching
		"cb_site_settings_cache"                : "template",
		// Security Settings
		"cb_security_min_password_length"       : "8",
		"cb_security_password_reset_expiration" : "60",
		"cb_security_login_blocker"             : "true",
		"cb_security_max_attempts"              : "5",
		"cb_security_blocktime"                 : "5",
		"cb_security_max_auth_logs"             : "500",
		"cb_security_latest_logins"             : "10",
		"cb_security_rate_limiter"              : "true",
		"cb_security_rate_limiter_logging"      : "true",
		"cb_security_rate_limiter_count"        : "4",
		"cb_security_rate_limiter_duration"     : "1",
		"cb_security_rate_limiter_bots_only"    : "true",
		"cb_security_rate_limiter_message"      : "<p>You are making too many requests too fast, please slow down and wait {duration} seconds</p>",
		"cb_security_rate_limiter_redirectURL"  : "",
		"cb_security_2factorAuth_force"         : "false",
		"cb_security_2factorAuth_provider"      : "email",
		"cb_security_2factorAuth_trusted_days"  : "30",
		"cb_security_login_signout_url"         : "",
		"cb_security_login_signin_text"         : "",
		// Admin settings
		"cb_admin_ssl"                          : "false",
		"cb_admin_quicksearch_max"              : "5",
		"cb_admin_theme"                        : "contentbox-default",
		// Paging Defaults
		"cb_paging_maxrows"                     : "20",
		"cb_paging_bandgap"                     : "5",
		"cb_paging_maxentries"                  : "10",
		"cb_paging_maxRSSComments"              : "10",
		// Gravatar
		"cb_gravatar_display"                   : "true",
		"cb_gravatar_rating"                    : "PG",
		// Dashboard Settings
		"cb_dashboard_recentEntries"            : "5",
		"cb_dashboard_recentPages"              : "5",
		"cb_dashboard_recentComments"           : "5",
		"cb_dashboard_recentcontentstore"       : "5",
		"cb_dashboard_newsfeed"                 : "https://www.ortussolutions.com/blog/rss",
		"cb_dashboard_newsfeed_count"           : "5",
		"cb_dashboard_welcome_title"            : "Dashboard",
		"cb_dashboard_welcome_body"             : "",
		// Global Comment Settings
		"cb_comments_whoisURL"                  : "http://whois.arin.net/ui/query.do?q",
		// Mail Settings
		"cb_site_mail_server"                   : "",
		"cb_site_mail_username"                 : "",
		"cb_site_mail_password"                 : "",
		"cb_site_mail_smtp"                     : "25",
		"cb_site_mail_tls"                      : "false",
		"cb_site_mail_ssl"                      : "false",
		// RSS Feeds
		"cb_rss_maxEntries"                     : "10",
		"cb_rss_maxComments"                    : "10",
		"cb_rss_caching"                        : "true",
		"cb_rss_cachingTimeout"                 : "60",
		"cb_rss_cachingTimeoutIdle"             : "15",
		"cb_rss_cacheName"                      : "Template",
		"cb_rss_title"                          : "RSS Feed by ContentBox",
		"cb_rss_generator"                      : "ContentBox by Ortus Solutions",
		"cb_rss_copyright"                      : "Ortus Solutions, Corp (www.ortussolutions.com)",
		"cb_rss_description"                    : "ContentBox RSS Feed",
		"cb_rss_webmaster"                      : "",
		// Content Caching and options
		"cb_content_caching"                    : "true",
		"cb_entry_caching"                      : "true",
		"cb_contentstore_caching"               : "true",
		"cb_content_cachingTimeout"             : "60",
		"cb_content_cachingTimeoutIdle"         : "15",
		"cb_content_cacheName"                  : "Template",
		"cb_page_excerpts"                      : "true",
		"cb_content_uiexport"                   : "true",
		"cb_content_cachingHeader"              : "true",
		// Content Hit Tracking
		"cb_content_hit_count"                  : "true",
		"cb_content_hit_ignore_bots"            : "false",
		"cb_content_bot_regex"                  : "Google|msnbot|Rambler|Yahoo|AbachoBOT|accoona|AcioRobot|ASPSeek|CocoCrawler|Dumbot|FAST-WebCrawler|GeonaBot|Gigabot|Lycos|MSRBOT|Scooter|AltaVista|IDBot|eStyle|Scrubby",
		// Media Manager
		"cb_media_directoryRoot"                : "/contentbox-custom/_content",
		"cb_media_createFolders"                : "true",
		"cb_media_allowDelete"                  : "true",
		"cb_media_allowDownloads"               : "true",
		"cb_media_allowUploads"                 : "true",
		"cb_media_acceptMimeTypes"              : "",
		"cb_media_quickViewWidth"               : "400",
		// HTML5 Media Manager
		"cb_media_html5uploads_maxFileSize"     : "100",
		"cb_media_html5uploads_maxFiles"        : "25",
		// Media Services
		"cb_media_provider"                     : "CFContentMediaProvider",
		"cb_media_provider_caching"             : "true",
		// Editor Manager
		"cb_editors_default"                    : "ckeditor",
		"cb_editors_markup"                     : "HTML",
		"cb_editors_ckeditor_toolbar"           : "[
		{ ""name"": ""document"",    ""items"" : [ ""Source"",""-"",""Maximize"",""ShowBlocks"" ] },
		{ ""name"": ""clipboard"",   ""items"" : [ ""Cut"",""Copy"",""Paste"",""PasteText"",""PasteFromWord"",""-"",""Undo"",""Redo"" ] },
		{ ""name"": ""editing"",     ""items"" : [ ""Find"",""Replace"",""SpellChecker""] },
		{ ""name"": ""forms"",       ""items"" : [ ""Form"", ""Checkbox"", ""Radio"", ""TextField"", ""Textarea"", ""Select"", ""Button"",""HiddenField"" ] },
		""/"",
		{ ""name"": ""basicstyles"", ""items"" : [ ""Bold"",""Italic"",""Underline"",""Strike"",""Subscript"",""Superscript"",""-"",""RemoveFormat"" ] },
		{ ""name"": ""paragraph"",   ""items"" : [ ""NumberedList"",""BulletedList"",""-"",""Outdent"",""Indent"",""-"",""Blockquote"",""CreateDiv"",""-"",""JustifyLeft"",""JustifyCenter"",""JustifyRight"",""JustifyBlock"",""-"",""BidiLtr"",""BidiRtl"" ] },
		{ ""name"": ""links"",       ""items"" : [ ""Link"",""Unlink"",""Anchor"" ] },
		""/"",
		{ ""name"": ""styles"",      ""items"" : [ ""Styles"",""Format"" ] },
		{ ""name"": ""colors"",      ""items"" : [ ""TextColor"",""BGColor"" ] },
		{ ""name"": ""insert"",      ""items"" : [ ""Image"",""Table"",""HorizontalRule"",""Smiley"",""SpecialChar"",""Iframe"",""InsertPre""] },
		{ ""name"": ""contentbox"",  ""items"" : [ ""MediaEmbed"",""cbIpsumLorem"",""cbWidgets"",""cbContentStore"",""cbLinks"",""cbEntryLinks"" ] }
		]",
		"cb_editors_ckeditor_excerpt_toolbar" : "
		[
		{ ""name"": ""document"",    ""items"" : [ ""Source"",""-"",""Maximize"",""ShowBlocks"" ] },
		{ ""name"": ""basicstyles"", ""items"" : [ ""Bold"",""Italic"",""Underline"",""Strike"",""Subscript"",""Superscript""] },
		{ ""name"": ""paragraph"",   ""items"" : [ ""NumberedList"",""BulletedList"",""-"",""Outdent"",""Indent"",""CreateDiv""] },
		{ ""name"": ""links"",       ""items"" : [ ""Link"",""Unlink"",""Anchor"" ] },
		{ ""name"": ""insert"",      ""items"" : [ ""Image"",""Flash"",""Table"",""HorizontalRule"",""Smiley"",""SpecialChar"" ] },
		{ ""name"": ""contentbox"",  ""items"" : [ ""MediaEmbed"",""cbIpsumLorem"",""cbWidgets"",""cbContentStore"",""cbLinks"",""cbEntryLinks"" ] }
		]",
		"cb_editors_ckeditor_extraplugins" : "cbKeyBinding,cbWidgets,cbLinks,cbEntryLinks,cbContentStore,cbIpsumLorem,wsc,mediaembed,insertpre,justify,colorbutton,showblocks,find,div,smiley,specialchar,iframe",
		// Search Settings
		"cb_search_adapter"                : "contentbox.models.search.DBSearch",
		"cb_search_maxResults"             : "20",
		// Site Maintenance
		"cb_site_maintenance_message"      : "<h1>This site is down for maintenance.<br /> Please check back again soon.</h1>",
		"cb_site_maintenance"              : "false",
		// Versioning
		"cb_versions_max_history"          : "",
		"cb_versions_commit_mandatory"     : "false"
	};

	// Site Defaults
	this.SITE_DEFAULTS = {
		// Global HTML: Panel Section
		"cb_html_beforeHeadEnd"              : "",
		"cb_html_afterBodyStart"             : "",
		"cb_html_beforeBodyEnd"              : "",
		"cb_html_beforeContent"              : "",
		"cb_html_afterContent"               : "",
		"cb_html_beforeSideBar"              : "",
		"cb_html_afterSideBar"               : "",
		"cb_html_afterFooter"                : "",
		"cb_html_preEntryDisplay"            : "",
		"cb_html_postEntryDisplay"           : "",
		"cb_html_preIndexDisplay"            : "",
		"cb_html_postIndexDisplay"           : "",
		"cb_html_preArchivesDisplay"         : "",
		"cb_html_postArchivesDisplay"        : "",
		"cb_html_preCommentForm"             : "",
		"cb_html_postCommentForm"            : "",
		"cb_html_prePageDisplay"             : "",
		"cb_html_postPageDisplay"            : "",
		// Site Comment Settings
		"cb_comments_enabled"                : "true",
		"cb_comments_maxDisplayChars"        : "500",
		"cb_comments_notify"                 : "true",
		"cb_comments_moderation_notify"      : "true",
		"cb_comments_notifyemails"           : "",
		"cb_comments_moderation"             : "true",
		"cb_comments_moderation_whitelist"   : "true",
		"cb_comments_moderation_blacklist"   : "",
		"cb_comments_moderation_blockedlist" : "",
		"cb_comments_moderation_expiration"  : "30"
	};

	/**
	 * Constructor
	 */
	SettingService function init(){
		variables.oSystem           = createObject( "java", "java.lang.System" );
		variables.CBReadyFlag       = false;
		variables.cacheProviderName = "template";

		// init it
		super.init( entityName = "cbSetting" );

		return this;
	}

	/**
	 * This method will go over all system settings and make sure that there are no missing default core settings.
	 * If they are, we will create the core settings with the appropriate defaults: this.DEFAULTS
	 */
	SettingService function preFlightCheck(){
		// Log it
		variables.log.info( "> Running ContentBox pre flight checks..." );

		// Iterate over default core settings and check they exist
		lock
			name          ="contentbox-pre-flight",
			timeout       = "10"
			throwOnTimeout="true"
			type          ="exclusive" {
			// Check what's missing for the global settings
			transaction {
				// Get all core, non-deleted settings
				var loadedSettings = newCriteria()
					.isNull( "site" )
					.isFalse( "isDeleted" )
					.isTrue( "isCore" )
					.withProjections( property: "name" )
					.list( sortOrder = "name" );

				// Verify defaults exist
				this.DEFAULTS
					// only process defaults that do not exist in the database
					.filter( function( key, value ){
						return !arrayContainsNoCase( loadedSettings, arguments.key );
					} )
					// Create the missing global setting
					.each( function( key, value ){
						variables.log.info(
							"- Missing core setting (#arguments.key#) found in pre-flight, adding it!"
						);
						this.save(
							this.new( {
								name   : arguments.key,
								value  : trim( arguments.value ),
								isCore : true
							} )
						);
					} );

				// Get all site core settings in the database
				var dbSiteSettings = newCriteria()
					.isFalse( "isDeleted" )
					.isTrue( "isCore" )
					.joinTo( "site", "site" )
					.withProjections( property: "name,site.slug:siteSlug" )
					.asStruct()
					.list( sortOrder = "site.slug,name" );

				// Get all Sites and process them for core settings
				variables.siteService
					.getAll()
					.each( function( site ){
						var targetSite = arguments.site;
						this.SITE_DEFAULTS
							// only process defaults that do not exist in the database
							.filter( function( key, value ){
								return arrayFilter( dbSiteSettings, function( item ){
									return (
										arguments.item[ "name" ] == key && arguments.item[ "siteSlug" ] == targetSite.getSlug()
									);
								} ).isEmpty();
							} )
							// Create the missing site setting
							.each( function( key, value ){
								variables.log.info(
									"- Site (#targetSite.getSlug()#) missing setting (#arguments.key#), adding it!"
								);
								this.save(
									this.new( {
										name   : arguments.key,
										value  : trim( arguments.value ),
										isCore : true,
										site   : targetSite
									} )
								);
							} );
					} );
			}
			// end transaction

			// load cache provider now that everyting is pre-flighted
			loadCacheProviderName();
		}

		variables.log.info( "√ ContentBox Global Settings pre-flight checks finalized!" );

		return this;
	}

	/**
	 * Get a collection (struct) of settings that represent the defaults for a site in ContentBox
	 */
	struct function getSiteSettingDefaults(){
		return this.SITE_DEFAULTS;
	}

	/**
	 * Retrieve a multi-tenant settings cache key
	 */
	string function getSettingsCacheKey(){
		return "cb-settings-#CGI.HTTP_HOST#";
	}

	/**
	 * Check if the installer and dsn creator modules are present
	 */
	struct function isInstallationPresent(){
		var results = { installer : false, dsncreator : false };

		if (
			structKeyExists( moduleSettings, "contentbox-installer" ) AND
			directoryExists( moduleSettings[ "contentbox-installer" ].path )
		) {
			results.installer = true;
		}

		if (
			structKeyExists( moduleSettings, "contentbox-dsncreator" ) AND
			directoryExists( moduleSettings[ "contentbox-dsncreator" ].path )
		) {
			results.dsncreator = true;
		}

		return results;
	}

	/**
	 * Delete the installer module
	 */
	boolean function deleteInstaller(){
		if (
			structKeyExists( moduleSettings, "contentbox-installer" ) AND
			directoryExists( moduleSettings[ "contentbox-installer" ].path )
		) {
			directoryDelete( moduleSettings[ "contentbox-installer" ].path, true );
			return true;
		}
		return false;
	}

	/**
	 * Delete the dsn creator module
	 */
	boolean function deleteDSNCreator(){
		if (
			structKeyExists( moduleSettings, "contentbox-dsncreator" ) AND
			directoryExists( moduleSettings[ "contentbox-dsncreator" ].path )
		) {
			directoryDelete( moduleSettings[ "contentbox-dsncreator" ].path, true );
			return true;
		}
		return false;
	}

	/**
	 * Check if contentbox has been installed by checking if there are no settings and no cb_active ONLY
	 * If the query comes back with active, it will not run it again.
	 */
	boolean function isCBReady(){
		// Short circuit caching
		if ( variables.CBReadyFlag ) {
			return true;
		}

		// Not active yet, discover it
		var thisCount = newCriteria().isEq( "name", "cb_active" ).count();

		// Store it
		if ( thisCount > 0 ) {
			variables.CBReadyFlag = true;
		}

		return ( thisCount > 0 ? true : false );
	}

	/**
	 * Mark cb as ready to serve
	 */
	SettingService function activateCB(){
		save( this.new( { name : "cb_active", value : "true" } ) );
		return this;
	}

	/**
	 * Get a global setting
	 *
	 * @name The name of the seting
	 * @defaultValue The default value if setting not found.
	 *
	 * @throws SettingNotFoundException
	 * @return The setting value or default value if not found
	 */
	function getSetting( required name, defaultValue ){
		var allSettings = getAllSettings();

		// verify it exists
		if ( structKeyExists( allSettings, arguments.name ) ) {
			return allSettings[ arguments.name ];
		}

		// default value
		if ( !isNull( arguments.defaultValue ) ) {
			return arguments.defaultValue;
		}

		// nothing we can do
		throw(
			message: "Setting #arguments.name# not found in settings collection",
			detail : "Registered settings are: #structKeyList( allSettings )#",
			type   : "SettingNotFoundException"
		);
	}

	/**
	 * Get a site setting
	 *
	 * @siteSlug The site to get the setting from
	 * @name The name of the seting
	 * @defaultValue The default value if setting not found.
	 *
	 * @throws SettingNotFoundException
	 * @return The setting value or default value if not found
	 */
	function getSiteSetting( required siteSlug, required name, defaultValue ){
		var allSettings = getAllSiteSettings( arguments.siteSlug );

		// verify it exists
		if ( structKeyExists( allSettings, arguments.name ) ) {
			return allSettings[ arguments.name ];
		}

		// default value
		if ( !isNull( arguments.defaultValue ) ) {
			return arguments.defaultValue;
		}

		// nothing we can do
		throw(
			message: "Site setting #arguments.name# not found in site collection",
			detail : "Registered settings are: #structKeyList( allSettings )#",
			type   : "SettingNotFoundException"
		);
	}

	/**
	 * Get all global settings
	 *
	 * @force To force clear the cache
	 */
	struct function getAllSettings( boolean force = false ){
		return getSettingsContainer( arguments.force ).global;
	}

	/**
	 * Get all site settings
	 *
	 * @slug The site slug to use to retrieve the settings
	 * @force To force clear the cache
	 */
	struct function getAllSiteSettings( required siteSlug, boolean force = false ){
		return getSettingsContainer( arguments.force ).sites[ arguments.siteSlug ];
	}

	/**
	 * Get all the default site settings
	 *
	 * @force To force clear the cache
	 */
	struct function getDefaultSiteSettings( boolean force = false ){
		return getSettingsContainer( arguments.force ).sites[ "default" ];
	}

	/**
	 * Get the entire settings container from cache or build it out.
	 *
	 * @force Force build
	 */
	struct function getSettingsContainer( boolean force = false ){
		// Force Clear
		if ( arguments.force ) {
			flushSettingsCache();
		}

		// Get or set
		return getSettingsCacheProvider().getOrSet(
			getSettingsCacheKey(),
			function(){
				log.info( "Settings container not cached, rebuilding from DB!" );
				return buildSettingsContainer();
			},
			7200
		);
	}

	/**
	 * Try to find a setting object by site and name
	 *
	 * @return The setting object or null
	 */
	function findSiteSetting( required site, required name ){
		return newCriteria()
			.isEq( "site", arguments.site )
			.isEq( "name", arguments.name )
			.get();
	}

	/**
	 * Build out a settings container by global and sites.
	 *
	 * @return struct of { global : {}, sites : { slug : {} } }
	 */
	struct function buildSettingsContainer(){
		var allSites  = variables.siteService.getAllFlat();
		var container = { "global" : {}, "sites" : {} };

		// Initialize site setting containers from defaults
		container.sites = arrayReduce(
			allSites,
			function( result, item ){
				result[ item[ "slug" ] ] = duplicate( this.SITE_DEFAULTS );
				return result;
			},
			{}
		);

		// Populate containers from what's on the database now
		newCriteria()
			.isFalse( "isDeleted" )
			.list( sortOrder = "site,name" )
			.each( function( item ){
				if ( item.hasSite() ) {
					// Store the setting
					container.sites[ item.getSite().getSlug() ][ item.getName() ] = item.getValue();
				} else {
					container.global[ item.getName() ] = item.getValue();
				}
			} );

		return container;
	}

	/**
	 * This will store the incoming structure as the settings in cache.
	 * Usually this method is used for major overrides.
	 */
	SettingService function storeSettings( struct settings ){
		// cache them for 5 days, usually app timeout
		getSettingsCacheProvider().set(
			getSettingsCacheKey(),
			arguments.settings,
			7200
		);
		return this;
	}

	/**
	 * flush settings cache for current multi-tenant host
	 */
	SettingService function flushSettingsCache(){
		// Info
		variables.log.info( "Settings Flush Executed!" );
		// Clear out the settings cache
		getSettingsCacheProvider().clear( getSettingsCacheKey() );
		// Re-load cache provider name, in case user changed it
		loadCacheProviderName();
		// Loadup Config Overrides
		loadConfigOverrides();
		// Load Environment Overrides Now, they take precedence
		loadEnvironmentOverrides();
		return this;
	}

	/**
	 * Bulk saving of options using a memento structure of options
	 * This is usually done from the settings display manager
	 *
	 * @memento The struct of settings
	 * @site Optional site to attach the settings to
	 *
	 * @return SettingService
	 */
	SettingService function bulkSave( struct memento, site ){
		var settings = isNull( arguments.site ) ? getAllSettings() : getAllSiteSettings(
			arguments.site.getSlug()
		);
		var newSettings = [];

		arguments.memento
			// Only save, saveable keys
			.filter( function( key, value ){
				return settings.keyExists( key );
			} )
			// Build out array of settings to save
			.each( function( key, value ){
				var thisSetting = findWhere( { name : key } );

				// Maybe it's a new setting :)
				if ( isNull( thisSetting ) ) {
					thisSetting = new ( { name : key } );
				}

				thisSetting.setValue( toString( value ) );

				// Site mapping
				if ( !isNull( site ) ) {
					thisSetting.setSite( site );
				}

				newSettings.append( thisSetting );
			} );

		// save new settings and flush cache
		saveAll( newSettings );
		flushSettingsCache();

		return this;
	}

	/**
	 * Build file browser settings structure so you can execute multiple containers
	 *
	 * @return struct
	 */
	struct function buildFileBrowserSettings(){
		var cbSettings = getAllSettings();
		var settings   = {
			directoryRoot   : expandPath( cbSettings.cb_media_directoryRoot ),
			createFolders   : cbSettings.cb_media_createFolders,
			deleteStuff     : cbSettings.cb_media_allowDelete,
			allowDownload   : cbSettings.cb_media_allowDownloads,
			allowUploads    : cbSettings.cb_media_allowUploads,
			acceptMimeTypes : cbSettings.cb_media_acceptMimeTypes,
			quickViewWidth  : cbSettings.cb_media_quickViewWidth,
			loadJQuery      : false,
			useMediaPath    : true,
			html5uploads    : {
				maxFileSize : cbSettings.cb_media_html5uploads_maxFileSize,
				maxFiles    : cbSettings.cb_media_html5uploads_maxFiles
			}
		};

		// Base MediaPath
		var mediaPath = "";
		// I don't think this is needed anymore. As we use build link for everything.
		// var mediaPath = ( len( AppMapping ) ? AppMapping : "" ) & "/";
		// if( findNoCase( "index.cfm", requestService.getContext().getSESBaseURL() ) ){
		// mediaPath = "index.cfm" & mediaPath;
		// }

		// add the entry point
		var entryPoint = moduleSettings[ "contentbox-ui" ].entryPoint;
		mediaPath &= ( len( entryPoint ) ? "#entryPoint#/" : "" ) & "__media";
		// Store it
		mediaPath          = ( left( mediaPath, 1 ) == "/" ? mediaPath : "/" & mediaPath );
		settings.mediaPath = mediaPath;

		return settings;
	}

	/**
	 * Setting search with filters
	 *
	 * @search The search term for the name
	 * @max The max records
	 * @offset The offset to tuse
	 * @sortOrder The sort order
	 * @siteID The site id to filter on
	 *
	 * @return struct of { count, settings }
	 */
	struct function search(
		search    = "",
		max       = 0,
		offset    = 0,
		sortOrder = "name asc",
		siteID    = ""
	){
		var results = { "count" : 0, "settings" : [] };
		var c       = newCriteria();

		// Search Criteria
		if ( len( arguments.search ) ) {
			c.like( "name", "%#arguments.search#%" );
		}

		// Site
		if ( len( arguments.siteID ) ) {
			c.isEq( "site.siteID", arguments.siteID );
		}

		// run criteria query and projections count
		results.count    = c.count( "settingID" );
		results.settings = c
			.resultTransformer( c.DISTINCT_ROOT_ENTITY )
			.list(
				offset   : arguments.offset,
				max      : arguments.max,
				sortOrder: arguments.sortOrder,
				asQuery  : false
			);

		return results;
	}

	/**
	 * Get all data prepared for export
	 */
	array function getAllForExport(){
		return newCriteria()
			.withProjections(
				property = "settingID,name,value,createdDate,modifiedDate,isDeleted,isCore,site.siteID:siteID"
			)
			.asStruct()
			.list( sortOrder = "name" );
	}

	/**
	 * Import data from a ContentBox JSON file. Returns the import log
	 *
	 * @importFile The import file location
	 * @override Are we override previous values or not
	 *
	 * @return The import log
	 */
	string function importFromFile( required importFile, boolean override = false ){
		var data      = fileRead( arguments.importFile );
		var importLog = createObject( "java", "java.lang.StringBuilder" ).init(
			"Starting import with override = #arguments.override#...<br>"
		);

		if ( !isJSON( data ) ) {
			throw(
				message = "Cannot import file as the contents is not JSON",
				type    = "InvalidImportFormat"
			);
		}

		// deserialize packet: Should be array of { settingID, name, value }
		return importFromData(
			deserializeJSON( data ),
			arguments.override,
			importLog
		);
	}

	/**
	 * Import data from an array of structures of settings
	 */
	string function importFromData(
		required importData,
		boolean override = false,
		importLog
	){
		var allSettings = [];

		// iterate and import
		for ( var thisSetting in arguments.importData ) {
			var args     = { name : thisSetting.name };
			var oSetting = findWhere( criteria = args );

			// date cleanups, just in case.
			var badDateRegex         = " -\d{4}$";
			thisSetting.createdDate  = reReplace( thisSetting.createdDate, badDateRegex, "" );
			thisSetting.modifiedDate = reReplace( thisSetting.modifiedDate, badDateRegex, "" );
			// Epoch to Local
			thisSetting.createdDate  = dateUtil.epochToLocal( thisSetting.createdDate );
			thisSetting.modifiedDate = dateUtil.epochToLocal( thisSetting.modifiedDate );

			// if null, then create it
			if ( isNull( oSetting ) ) {
				oSetting = this.new( {
					name         : thisSetting.name,
					value        : javacast( "string", thisSetting.value ),
					createdDate  : thisSetting.createdDate,
					modifiedDate : thisSetting.modifiedDate,
					isDeleted    : thisSetting.isDeleted,
					isCore       : ( isNull( thisSetting.isCore ) ? false : thisSetting.isCore )
				} );

				// TODO: Site Inflation
				if ( !isNull( thisSetting.site ) ) {
				}

				arrayAppend( allSettings, oSetting );

				// logs
				importLog.append( "New setting imported: #thisSetting.name#<br>" );
			}
			// else only override if true
			else if ( arguments.override ) {
				oSetting.setValue( javacast( "string", thisSetting.value ) );
				oSetting.setIsDeleted( thisSetting.isDeleted );
				oSetting.setIsCore( thisSetting.isCore );

				// TODO: Site Inflation
				if ( !isNull( thisSetting.site ) ) {
					// oSetting.setSite();
				}

				arrayAppend( allSettings, oSetting );
				importLog.append( "Overriding setting: #thisSetting.name#<br>" );
			} else {
				importLog.append( "Skipping setting: #thisSetting.name#<br>" );
			}
		}

		// Save them?
		if ( arrayLen( allSettings ) ) {
			saveAll( allSettings );
			importLog.append( "Saved all imported and overriden settings!" );
		} else {
			importLog.append(
				"No settings imported as none where found or able to be overriden from the import file."
			);
		}

		return importLog.toString();
	}

	/**
	 * Get the cache provider object to be used for settings
	 * @return coldbox.system.cache.ICacheProvider
	 */
	function getSettingsCacheProvider(){
		// Return the cache to use
		return cacheBox.getCache( variables.cacheProviderName );
	}

	/**
	 * Load up config overrides
	 */
	function loadConfigOverrides(){
		var oConfig       = coldbox.getSetting( "ColdBoxConfig" );
		var configStruct  = coldbox.getConfigSettings();
		var contentboxDSL = oConfig.getPropertyMixin( "contentbox", "variables", structNew() );

		// Global Settings
		if (
			structKeyExists( contentboxDSL, "settings" )
			&&
			structKeyExists( contentboxDSL.settings, "global" )
		) {
			var settingsContainer = getSettingsContainer();

			// Append and override
			structAppend(
				settingsContainer.global,
				contentboxDSL.settings.global,
				true
			);

			// Store them back in
			storeSettings( settingsContainer );

			// Log it
			variables.log.info(
				"ContentBox global config overrides loaded.",
				contentboxDSL.settings.global
			);
		}

		// TODO: Site Settings
	}

	/**
	 * Load up java environment overrides for ContentBox settings
	 * The pattern to look is `contentbox.{site}.{setting}`
	 * Example: contentbox.default.cb_media_directoryRoot
	 */
	function loadEnvironmentOverrides(){
		var environmentSettings = variables.oSystem.getEnv();
		var overrides           = {};

		// iterate and override
		for ( var thisKey in environmentSettings ) {
			if ( reFindNoCase( "^contentbox\_", thisKey ) ) {
				overrides[ reReplaceNoCase( thisKey, "^contentbox\_", "" ) ] = environmentSettings[
					thisKey
				];
			}
		}

		// If empty, exit out.
		if ( structIsEmpty( overrides ) ) {
			return;
		}

		// Append and override
		var settingsContainer = getSettingsContainer();

		// Append and override
		structAppend( settingsContainer.global, overrides, true );

		// Store them back in
		storeSettings( settingsContainer );

		// Log it
		variables.log.info( "ContentBox environment overrides loaded.", overrides );
	}

	/******************************** PRIVATE ************************************************/

	/**
	 * Load the cache provider name from DB or default value
	 */
	private SettingService function loadCacheProviderName(){
		// query db for cache name
		var oProvider = newCriteria().isEq( "name", "cb_site_settings_cache" ).get();
		// Check if setting in DB already, else default it
		if ( !isNull( cacheProvider ) ) {
			variables.cacheProviderName = oProvider.getValue();
		} else {
			// default cache provider name
			variables.cacheProviderName = "template";
		}
		return this;
	}

}
