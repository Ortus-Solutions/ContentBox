/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Setting Service for contentbox
*/
component extends="cborm.models.VirtualEntityService" accessors="true" threadsafe singleton{

	// DI properties
	property name="cachebox" 		inject="cachebox";
	property name="moduleSettings"	inject="coldbox:setting:modules";
	property name="appMapping"		inject="coldbox:setting:appMapping";
	property name="requestService"	inject="coldbox:requestService";
	property name="coldbox"			inject="coldbox";
	property name="dateUtil"        inject="DateUtil@cb";
	property name="log"				inject="logbox:logger:{this}";

	/**
	* The cache provider name to use for settings caching. Defaults to 'template' cache.
	* This can also be set in the global ContentBox settings page to any CacheBox cache.
	*/
	property name="cacheProviderName" default="template";

	/**
	 * Bit that detects if CB has been installed or not
	 */
	property name="CBReadyFlag" default="false" type="boolean";

	// Setting Static Defaults
	this.DEFAULTS = {
		// Installation security salt
		"cb_salt" 								= hash( createUUID() & getTickCount() & now(), "SHA-512" ),

		// Site Settings
		"cb_site_name" 							= "",
		"cb_site_email" 						= "",
		"cb_site_tagline" 						= "",
		"cb_site_description" 					= "",
		"cb_site_keywords" 						= "",
		"cb_site_outgoingEmail" 				= "",
		"cb_site_homepage" 						= "cbBlog",
		"cb_site_disable_blog" 					= "false",
		"cb_site_blog_entrypoint" 				= "blog",
		"cb_site_ssl" 							= "false",
		"cb_site_poweredby" 					= "true",
		"cb_site_settings_cache"				= "Template",
		"cb_site_sitemap"						= "true",
		"cb_site_adminbar"						= "true",

		// Security Settings
		"cb_security_min_password_length"		= "8",
		"cb_security_login_blocker" 			= "true",
		"cb_security_max_attempts"				= "5",
		"cb_security_blocktime"					= "5",
		"cb_security_max_auth_logs"				= "500",
		"cb_security_latest_logins"				= "10",
		"cb_security_rate_limiter"				= "true",
		"cb_security_rate_limiter_logging"		= "true",
		"cb_security_rate_limiter_count"		= "4",
		"cb_security_rate_limiter_duration"		= "1",
		"cb_security_rate_limiter_bots_only"	= "true",
		"cb_security_rate_limiter_message"		= "<p>You are making too many requests too fast, please slow down and wait {duration} seconds</p>",
		"cb_security_rate_limiter_redirectURL"	= "",
		"cb_security_2factorAuth_force" 		= "false",
		"cb_security_2factorAuth_provider" 		= "email",
		"cb_security_2factorAuth_trusted_days"	= "30",
		"cb_security_login_signout_url"	        = "",
		"cb_security_login_signin_text"	        = "",

		// Admin settings
		"cb_admin_ssl" 							= "false",
		"cb_admin_quicksearch_max" 				= "5",
		"cb_admin_theme" 						= "contentbox-default",

		// Paging Defaults
		"cb_paging_maxrows" 					= "20",
		"cb_paging_bandgap" 					= "5",
		"cb_paging_maxentries" 					= "10",
		"cb_paging_maxRSSComments" 				= "10",

		// Gravatar
		"cb_gravatar_display" 					= "true",
		"cb_gravatar_rating" 					= "PG",

		// Dashboard Settings
		"cb_dashboard_recentEntries" 			= "5",
		"cb_dashboard_recentPages" 				= "5",
		"cb_dashboard_recentComments" 			= "5",
		"cb_dashboard_recentcontentstore" 		= "5",
		"cb_dashboard_newsfeed" 				= "https://www.ortussolutions.com/blog/rss",
		"cb_dashboard_newsfeed_count" 			= "5",
		"cb_dashboard_welcome_title" 			= "Dashboard",
		"cb_dashboard_welcome_body" 			= "",

		// Comment Settings
		"cb_comments_whoisURL" 					= "http://whois.arin.net/ui/query.do?q",
		"cb_comments_maxDisplayChars" 			= "500",
		"cb_comments_enabled" 					= "true",
		"cb_comments_urltranslations" 			= "true",
		"cb_comments_moderation" 				= "true",
		"cb_comments_moderation_whitelist" 		= "true",
		"cb_comments_notify" 					= "true",
		"cb_comments_moderation_notify" 		= "true",
		"cb_comments_notifyemails" 				= "",
		"cb_comments_moderation_blacklist" 		= "",
		"cb_comments_moderation_blockedlist" 	= "",
		"cb_comments_moderation_expiration" 	= "30",

		// Mail Settings
		"cb_site_mail_server" 					= "",
		"cb_site_mail_username" 				= "",
		"cb_site_mail_password" 				= "",
		"cb_site_mail_smtp" 					= "25",
		"cb_site_mail_tls" 						= "false",
		"cb_site_mail_ssl" 						= "false",

		// Notifications
		"cb_notify_author" 						= "true",
		"cb_notify_entry"  						= "true",
		"cb_notify_page"   						= "true",
		"cb_notify_contentstore" 				= "true",

		// Site Layout
		"cb_site_theme" 						= "default",

		// RSS Feeds
		"cb_rss_maxEntries" 					= "10",
		"cb_rss_maxComments" 					= "10",
		"cb_rss_caching" 						= "true",
		"cb_rss_cachingTimeout" 				= "60",
		"cb_rss_cachingTimeoutIdle" 			= "15",
		"cb_rss_cacheName" 						= "Template",
		"cb_rss_title" 							= "RSS Feed by ContentBox",
		"cb_rss_generator" 						= "ContentBox by Ortus Solutions",
		"cb_rss_copyright" 						= "Ortus Solutions, Corp (www.ortussolutions.com)",
		"cb_rss_description" 					= "ContentBox RSS Feed",
		"cb_rss_webmaster" 						= "",

		// Content Caching and options
		"cb_content_caching" 					= "true",
		"cb_entry_caching" 						= "true",
		"cb_contentstore_caching" 				= "true",
		"cb_content_cachingTimeout" 			= "60",
		"cb_content_cachingTimeoutIdle" 		= "15",
		"cb_content_cacheName" 					= "Template",
		"cb_page_excerpts" 						= "true",
		"cb_content_uiexport" 					= "true",
		"cb_content_cachingHeader" 				= "true",

		// Content Hit Tracking
		"cb_content_hit_count" 					= "true",
		"cb_content_hit_ignore_bots" 			= "false",
		"cb_content_bot_regex" 					= "Google|msnbot|Rambler|Yahoo|AbachoBOT|accoona|AcioRobot|ASPSeek|CocoCrawler|Dumbot|FAST-WebCrawler|GeonaBot|Gigabot|Lycos|MSRBOT|Scooter|AltaVista|IDBot|eStyle|Scrubby",

		// Global HTML
		"cb_html_beforeHeadEnd" 				= "",
		"cb_html_afterBodyStart" 				= "",
		"cb_html_beforeBodyEnd" 				= "",
		"cb_html_beforeContent" 				= "",
		"cb_html_afterContent" 					= "",
		"cb_html_beforeSideBar" 				= "",
		"cb_html_afterSideBar" 					= "",
		"cb_html_afterFooter" 					= "",
		"cb_html_preEntryDisplay" 				= "",
		"cb_html_postEntryDisplay" 				= "",
		"cb_html_preIndexDisplay" 				= "",
		"cb_html_postIndexDisplay" 				= "",
		"cb_html_preArchivesDisplay" 			= "",
		"cb_html_postArchivesDisplay" 			= "",
		"cb_html_preCommentForm" 				= "",
		"cb_html_postCommentForm" 				= "",
		"cb_html_prePageDisplay" 				= "",
		"cb_html_postPageDisplay" 				= "",

		// Media Manager
		"cb_media_directoryRoot" 				= "/contentbox-custom/_content",
		"cb_media_createFolders" 				= "true",
		"cb_media_allowDelete" 					= "true",
		"cb_media_allowDownloads" 				= "true",
		"cb_media_allowUploads" 				= "true",
		"cb_media_acceptMimeTypes" 				= "",
		"cb_media_quickViewWidth" 				= "400",

		// HTML5 Media Manager
		"cb_media_html5uploads_maxFileSize" 	= "100",
		"cb_media_html5uploads_maxFiles" 		= "25",

		// Media Services
		"cb_media_provider" 					= "CFContentMediaProvider",
		"cb_media_provider_caching" 			= "true",

		// Editor Manager
		"cb_editors_default" 					= "ckeditor",
		"cb_editors_markup" 					= "HTML",
		"cb_editors_ckeditor_toolbar" 			= '[
		{ "name": "document",    "items" : [ "Source","-","Maximize","ShowBlocks" ] },
		{ "name": "clipboard",   "items" : [ "Cut","Copy","Paste","PasteText","PasteFromWord","-","Undo","Redo" ] },
		{ "name": "editing",     "items" : [ "Find","Replace","SpellChecker"] },
		{ "name": "forms",       "items" : [ "Form", "Checkbox", "Radio", "TextField", "Textarea", "Select", "Button","HiddenField" ] },
		"/",
		{ "name": "basicstyles", "items" : [ "Bold","Italic","Underline","Strike","Subscript","Superscript","-","RemoveFormat" ] },
		{ "name": "paragraph",   "items" : [ "NumberedList","BulletedList","-","Outdent","Indent","-","Blockquote","CreateDiv","-","JustifyLeft","JustifyCenter","JustifyRight","JustifyBlock","-","BidiLtr","BidiRtl" ] },
		{ "name": "links",       "items" : [ "Link","Unlink","Anchor" ] },
		"/",
		{ "name": "styles",      "items" : [ "Styles","Format" ] },
		{ "name": "colors",      "items" : [ "TextColor","BGColor" ] },
		{ "name": "insert",      "items" : [ "Image","Table","HorizontalRule","Smiley","SpecialChar","Iframe","InsertPre"] },
		{ "name": "contentbox",  "items" : [ "MediaEmbed","cbIpsumLorem","cbWidgets","cbContentStore","cbLinks","cbEntryLinks" ] }
		]',
				"cb_editors_ckeditor_excerpt_toolbar" 	= '
		[
		{ "name": "document",    "items" : [ "Source","-","Maximize","ShowBlocks" ] },
		{ "name": "basicstyles", "items" : [ "Bold","Italic","Underline","Strike","Subscript","Superscript"] },
		{ "name": "paragraph",   "items" : [ "NumberedList","BulletedList","-","Outdent","Indent","CreateDiv"] },
		{ "name": "links",       "items" : [ "Link","Unlink","Anchor" ] },
		{ "name": "insert",      "items" : [ "Image","Flash","Table","HorizontalRule","Smiley","SpecialChar" ] },
		{ "name": "contentbox",  "items" : [ "MediaEmbed","cbIpsumLorem","cbWidgets","cbContentStore","cbLinks","cbEntryLinks" ] }
		]' ,
		"cb_editors_ckeditor_extraplugins" 		= "cbKeyBinding,cbWidgets,cbLinks,cbEntryLinks,cbContentStore,cbIpsumLorem,wsc,mediaembed,insertpre,justify,colorbutton,showblocks,find,div,smiley,specialchar,iframe",

		// Search Settings
		"cb_search_adapter" 					= "contentbox.models.search.DBSearch",
		"cb_search_maxResults" 					= "20",

		// Site Maintenance
		"cb_site_maintenance_message" 			= "<h1>This site is down for maintenance.<br /> Please check back again soon.</h1>",
		"cb_site_maintenance" 					= "false",

		// Versioning
		"cb_versions_max_history" 				= "",
		"cb_versions_commit_mandatory" 			= "false"
	};

	/**
	* Constructor
	*/
	SettingService function init(){

		variables.oSystem 		= createObject( "java", "java.lang.System" );
		variables.CBReadyFlag 	= false;

		// init it
		super.init( entityName="cbSetting" );

		// load cache provider
		loadCacheProviderName();

		return this;
	}

	/**
	 * This method will go over all system settings and make sure that there are no missing default core settings.
	 * If they are, we will create the core settings with the appropriate defaults: this.DEFAULTS
	 */
	SettingService function preFlightCheck(){
		var missingSettings = false;
		var loadedSettings 	= getAllSettings( asStruct = true );

		// Iterate over default core settings and check they exist
		for( var thisSetting in this.DEFAULTS ){
			if( !structKeyExists( loadedSettings, thisSetting ) ){
				missingSettings = true;
				save( new( {
					name 	= thisSetting,
					value 	= trim( this.DEFAULTS[ thisSetting ] ),
					isCore 	= true
				} ) );
			}
		}
		// if we added new ones, flush caches
		if( missingSettings ){
			flushSettingsCache();
		}

		return this;
	}

	/**
	* Get Real IP, by looking at clustered, proxy headers and locally.
	*/
	function getRealIP(){
		var headers = GetHttpRequestData().headers;

		// Very balanced headers
		if( structKeyExists( headers, 'x-cluster-client-ip' ) ){
			return headers[ 'x-cluster-client-ip' ];
		}
		if( structKeyExists( headers, 'X-Forwarded-For' ) ){
			return headers[ 'X-Forwarded-For' ];
		}

		return len( cgi.remote_addr ) ? cgi.remote_addr : '127.0.0.1';
	}

	/**
	* Retrieve a multi-tenant settings cache key
	*/
	string function getSettingsCacheKey(){
		return "cb-settings-#cgi.http_host#";
	}

	/**
	* Check if the installer and dsn creator modules are present
	*/
	struct function isInstallationPresent(){
		var results = { installer = false, dsncreator = false };

		if( structKeyExists( moduleSettings, "contentbox-installer" ) AND
		    directoryExists( moduleSettings[ "contentbox-installer" ].path ) ){
			results.installer = true;
		}

		if( structKeyExists( moduleSettings, "contentbox-dsncreator" ) AND
		    directoryExists( moduleSettings[ "contentbox-dsncreator" ].path ) ){
			results.dsncreator = true;
		}

		return results;
	}

	/**
	* Delete the installer module
	*/
	boolean function deleteInstaller(){
		if( structKeyExists( moduleSettings, "contentbox-installer" ) AND
		    directoryExists( moduleSettings[ "contentbox-installer" ].path ) ){
			directoryDelete( moduleSettings[ "contentbox-installer" ].path, true );
			return true;
		}
		return false;
	}

	/**
	* Delete the dsn creator module
	*/
	boolean function deleteDSNCreator(){
		if( structKeyExists( moduleSettings, "contentbox-dsncreator" ) AND
		    directoryExists( moduleSettings[ "contentbox-dsncreator" ].path ) ){
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
		if( CBReadyFlag ){
			return true;
		}

		// Not active yet, discover it
		var thisCount = newCriteria()
			.isEq( "name", "cb_active" )
			.count();

		// Store it
		if( thisCount > 0 ){
			CBReadyFlag = true;
		}

		return( thisCount > 0 ? true : false );
	}

	/**
	* Mark cb as ready to serve
	*/
	function activateCB(){
		var s = new( properties={ name="cb_active", value="true" } );
		save( s );
		return this;
	}

	/**
	* Get a setting
	* @name The name of the seting
	* @defaultValue The default value if setting not found.
	*/
	function getSetting( required name, defaultValue ){
		var s = getAllSettings( asStruct=true );
		if( structKeyExists( s, arguments.name ) ){
			return s[ arguments.name ];
		}
		if( structKeyExists( arguments, "defaultValue" ) ){
			return arguments.defaultValue;
		}
		throw(
			message = "Setting #arguments.name# not found in settings collection",
			detail 	= "Registered settings are: #structKeyList(s)#",
			type 	= "contentbox.SettingService.SettingNotFound"
		);
	}

	/**
	* Get all settings
	* @asStruct Indicator if we should return structs or array of objects
	*
	* @return struct or array of objects
	*/
	function getAllSettings( boolean asStruct=false ){
		var cache 		= getSettingsCacheProvider();
		var cacheKey 	= getSettingsCacheKey();
		// retrieve all settings from cache
		var settings = cache.get( getSettingsCacheKey() );

		// found in cache?
		if( isNull( settings ) ){
			// not found, so query db
			var settings = list( sortOrder="name" );
			// cache them for 5 days, usually app timeout
			cache.set( cacheKey, settings, 7200 );
		}

		// convert to struct if a query, else return it.
		if( arguments.asStruct and isQuery( settings ) ){
			var s = {};
			for( var x=1; x lte settings.recordcount; x++ ){
				s[ settings.name[ x ] ] = settings.value[ x ];
			}
			return s;
		}

		return settings;
	}

	/**
	* This will store the incoming structure as the settings in cache.
	* Usually this method is used for major overrides.
	*/
	SettingService function storeSettings( struct settings ){
		// cache them for 5 days, usually app timeout
		getSettingsCacheProvider()
			.set( getSettingsCacheKey(), arguments.settings, 7200 );
		return this;
	}

	/**
	* flush settings cache for current multi-tenant host
	*/
	SettingService function flushSettingsCache(){
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
	* @memento The struct of settings
	*/
	SettingService function bulkSave( struct memento ){
		var settings 	= getAllSettings( asStruct=true );
		var oOption  	= "";
		var newOptions 	= [];

		// iterate over settings
		for( var key in settings ){
			// save only sent in setting keys
			if( structKeyExists( memento, key ) ){
				oOption = findWhere( { name=key } );
				oOption.setValue( memento[ key ] );
				arrayAppend( newOptions, oOption );
			}
		}

		// save new settings and flush cache
		saveAll( newOptions );
		flushSettingsCache();

		return this;
	}

	/**
	* Build file browser settings structure
	*/
	struct function buildFileBrowserSettings(){
		var cbSettings = getAllSettings(asStruct=true);
		var settings = {
			directoryRoot	= expandPath( cbSettings.cb_media_directoryRoot ),
			createFolders	= cbSettings.cb_media_createFolders,
			deleteStuff		= cbSettings.cb_media_allowDelete,
			allowDownload	= cbSettings.cb_media_allowDownloads,
			allowUploads	= cbSettings.cb_media_allowUploads,
			acceptMimeTypes	= cbSettings.cb_media_acceptMimeTypes,
			quickViewWidth	= cbSettings.cb_media_quickViewWidth,
			loadJQuery 		= false,
			useMediaPath	= true,
			html5uploads = {
				maxFileSize = cbSettings.cb_media_html5uploads_maxFileSize,
				maxFiles	= cbSettings.cb_media_html5uploads_maxFiles
			}
		};

		// Base MediaPath
		var mediaPath = "";
		// I don't think this is needed anymore. As we use build link for everything.
		//var mediaPath = ( len( AppMapping ) ? AppMapping : "" ) & "/";
		//if( findNoCase( "index.cfm", requestService.getContext().getSESBaseURL() ) ){
			//mediaPath = "index.cfm" & mediaPath;
		//}

		// add the entry point
		var entryPoint = moduleSettings[ "contentbox-ui" ].entryPoint;
		mediaPath &= ( len( entryPoint ) ? "#entryPoint#/" : "" ) & "__media";
		// Store it
		mediaPath = ( left( mediaPath,1 ) == '/' ? mediaPath : "/" & mediaPath );
		settings.mediaPath =mediaPath;

		return settings;
	}

	/**
	* setting search returns struct with keys [settings,count]
	*/
	struct function search( search="", max=0, offset=0, sortOrder="name asc" ){
		var results = {};
		// criteria queries
		var c = newCriteria();
		// Search Criteria
		if( len(arguments.search) ){
			c.like( "name","%#arguments.search#%" );
		}
		// run criteria query and projections count
		results.count 		= c.count( "settingID" );
		results.settings 	= c.resultTransformer( c.DISTINCT_ROOT_ENTITY )
								.list(offset=arguments.offset, max=arguments.max, sortOrder=sortOrder, asQuery=false);
		return results;
	}

	/**
	* Get all data prepared for export
	*/
	array function getAllForExport(){
		var c = newCriteria();

		return c.withProjections( property="settingID,name,value,createdDate,modifiedDate,isDeleted" )
			.resultTransformer( c.ALIAS_TO_ENTITY_MAP )
			.list( sortOrder="name" );

	}

	/**
	* Import data from a ContentBox JSON file. Returns the import log
	*/
	string function importFromFile(required importFile, boolean override=false){
		var data 		= fileRead( arguments.importFile );
		var importLog 	= createObject( "java", "java.lang.StringBuilder" ).init( "Starting import with override = #arguments.override#...<br>" );

		if( !isJSON( data ) ){
			throw(message="Cannot import file as the contents is not JSON", type="InvalidImportFormat" );
		}

		// deserialize packet: Should be array of { settingID, name, value }
		return	importFromData( deserializeJSON( data ), arguments.override, importLog );

	}

	/**
	* Import data from an array of structures of settings
	*/
	string function importFromData(required importData, boolean override=false, importLog){
		var allSettings = [];

		// iterate and import
		for( var thisSetting in arguments.importData ){
			var args = { name = thisSetting.name };
			var oSetting = findWhere( criteria=args );

			// date cleanups, just in case.
			var badDateRegex  	= " -\d{4}$";
			thisSetting.createdDate 	= reReplace( thisSetting.createdDate, badDateRegex, "" );
			thisSetting.modifiedDate 	= reReplace( thisSetting.modifiedDate, badDateRegex, "" );
			// Epoch to Local
			thisSetting.createdDate 	= dateUtil.epochToLocal( thisSetting.createdDate );
			thisSetting.modifiedDate 	= dateUtil.epochToLocal( thisSetting.modifiedDate );

			// if null, then create it
			if( isNull( oSetting ) ){
				var args = {
					name 			= thisSetting.name,
					value 			= javaCast( "string", thisSetting.value ),
					createdDate 	= thisSetting.createdDate,
					modifiedDate 	= thisSetting.modifiedDate,
					isDeleted 		= thisSetting.isDeleted
				};
				arrayAppend( allSettings, new( properties=args ) );
				// logs
				importLog.append( "New setting imported: #thisSetting.name#<br>" );
			}
			// else only override if true
			else if( arguments.override ){
				oSetting.setValue( javaCast( "string", thisSetting.value ) );
				oSetting.setIsDeleted( thisSetting.isDeleted );
				arrayAppend( allSettings, oSetting );
				importLog.append( "Overriding setting: #thisSetting.name#<br>" );
			} else {
				importLog.append( "Skipping setting: #thisSetting.name#<br>" );
			}
		}

		// Save them?
		if( arrayLen( allSettings ) ){
			saveAll( allSettings );
			importLog.append( "Saved all imported and overriden settings!" );
		} else {
			importLog.append( "No settings imported as none where found or able to be overriden from the import file." );
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
		var oConfig 		= coldbox.getSetting( "ColdBoxConfig" );
		var configStruct 	= coldbox.getConfigSettings();
		var contentboxDSL 	= oConfig.getPropertyMixin( "contentbox", "variables", structnew() );

		// Verify if we have settings on the default site for now.
		if(
			structKeyExists( contentboxDSL, "settings" )
			&&
			structKeyExists( contentboxDSL.settings, "default" )
		){
			var overrides 	= contentboxDSL.settings.default;
			var allSettings = getAllSettings( asStruct = true );
			// Append and override
			structAppend( allSettings, overrides, true );
			// Store them
			storeSettings( allSettings );
			// Log it
			variables.log.info( "ContentBox config overrides loaded.", overrides );
		}
	}

	/**
	 * Load up java environment overrides for ContentBox settings
	 * The pattern to look is `contentbox.{site}.{setting}`
	 * Example: contentbox.default.cb_media_directoryRoot
	 */
	function loadEnvironmentOverrides(){
		var environmentSettings = variables.oSystem.getEnv();
		var overrides 			= {};

		// iterate and override
		for( var thisKey in environmentSettings ){
			if( REFindNoCase( "^contentbox\_default\_", thisKey ) ){
				// No multi-site yet, so get the last part as the setting.
				overrides[ reReplaceNoCase( thisKey, "^contentbox\_default\_", "" ) ] = environmentSettings[  thisKey ];
			}
		}

		// If empty, exit out.
		if( structIsEmpty( overrides ) ){ return; }

		// Append and override
		var allSettings = getAllSettings( asStruct = true );
		structAppend( allSettings, overrides, true );
		// Store them
		storeSettings( allSettings );
		// Log it
		variables.log.info( "ContentBox environment overrides loaded.", overrides );
	}

	/******************************** PRIVATE ************************************************/

	/**
	* Load the cache provider name from DB or default value
	*/
	private SettingService function loadCacheProviderName(){
		// query db for cache name
		var oProvider = newCriteria()
			.isEq( "name", "cb_site_settings_cache" )
			.get();
		// Check if setting in DB already, else default it
		if( !isNull( cacheProvider ) ){
			variables.cacheProviderName = oProvider.getValue();
		} else {
			// default cache provider name
			variables.cacheProviderName = "template";
		}
		return this;
	}

}
