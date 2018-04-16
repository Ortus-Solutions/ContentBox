/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* ContentBox Core module configuration
*/
component {

	// Module Properties
	this.title 				= "ContentBox Core";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "https://www.ortussolutions.com";
	this.description 		= "This is the core module used to power the admin, RESTful and UI modules";
	this.version			= "@version.number@+@build.number@";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	this.entryPoint			= "cbcore";
	this.modelNamespace 	= "cb";
	this.cfmapping 			= "contentbox";
	// Load ContentBox Dependencies First.
	this.dependencies 		= [	"contentbox-deps" ];

	/**
	* Configure Module
	*/
	function configure(){

		// Setup a logger for this class
		variables.log = controller.getLogBox().getLogger( this );

		// Verify custom module, this is needed for registration and loading.
		verifyCustomModule();

		// contentbox settings
		settings = {
			codename 			= "Psalm 144:1",
			codenameLink 		= "https://www.bible.com/bible/114/psa.144.1.nkjv",
			// Auto Updates
			updateSlug_stable 	= "contentbox-stable-updates",
			updateSlug_beta 	= "contentbox-beta-updates",
			updatesURL			= "https://www.coldbox.org/api/forgebox",
			// Officially supported languages for modules
			languages 			= [ "de_DE", "en_US", "es_SV", "it_IT", "pt_BR" ]
		};

		// i18n
		i18n = {
			resourceBundles = {
		    	"cbcore" = "#moduleMapping#/i18n/cbcore"
		  	},
		  	defaultLocale = "en_US",
		  	localeStorage = "cookie"
		};

		// CB Module Conventions
		conventions = {
			layoutsLocation = "themes",
			viewsLocation 	= "themes"
		};

		// Parent Affected Settings
		parentSettings = {
			// File Browser module name override
			filebrowser_module_name		= "contentbox-filebrowser",
			// The default HTMl template for emitting the messages
			messagebox = {
				template = "#moduleMapping#/models/ui/templates/messagebox.cfm"
			}
		};

		// interceptor settings
		interceptorSettings = {
			// ContentBox Custom Events
			customInterceptionPoints = arrayToList( [
				// Code Rendering
				"cb_onContentRendering", "cb_onContentStoreRendering"
			] )
		};

		// interceptors
		interceptors = [
			// Rate Limiter
			{ class="contentbox.models.security.RateLimiter", name="RateLimiter@cb" },
			// CB RSS Cache Cleanup Ghost
			{ class="contentbox.models.rss.RSSCacheCleanup", name="RSSCacheCleanup@cb" },
			// CB Content Cache Cleanup Ghost
			{ class="contentbox.models.content.util.ContentCacheCleanup", name="ContentCacheCleanup@cb" },
			// Content Subscriptions
			{ class="contentbox.models.subscriptions.SubscriptionListener", name="SubscriptionListener@cb" },
			// Content Renderers, remember order is important.
			{ class="contentbox.models.content.renderers.LinkRenderer", name="LinkRenderer@cb" },
			{ class="contentbox.models.content.renderers.WidgetRenderer", name="WidgetRenderer@cb" },
			{ class="contentbox.models.content.renderers.SettingRenderer", name="SettingRenderer@cb" },
			{ class="contentbox.models.content.renderers.MarkdownRenderer", name="MarkdownRenderer@cb" }
		];

		// Manual Mappings
		binder.map( "customFieldService@cb" ).toDSL( "entityService:cbCustomField" );

		// ColdBox Integrations
		binder.map( "ColdBoxRenderer" ).toDSL( "coldbox:Renderer" );
		binder.map( "SystemUtil@cb" ).to( "coldbox.system.core.util.Util" );
	}

	/**
	* Development tier
	*/
	function development(){
	}

	/**
	* Multi-domain hosting, in preparation for multi-site domains
	* This is for both the admin and UI modules
	*/
	function preProcess( event ){
		var haveIndex = findnocase( "index.cfm", arguments.event.getSESBaseURL() ) ? "index.cfm" : "";
		// find appmaping
		var appMapping = ( len( controller.getSetting( 'AppMapping' ) ) ? controller.getSetting( 'AppMapping' ) & "/" : "" );
		// Setup base URL according to incoming host + protocol
		event.setSESBaseURL( "http" & ( event.isSSL() ? "s" : "" ) & "://#cgi.HTTP_HOST#/#appMapping##haveIndex#" );
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// Pre-flight check settings
		wirebox.getInstance( "settingService@cb" ).preFlightCheck();
		// Loadup Config Overrides
		loadConfigOverrides();
		// Load Environment Overrides Now, they take precedence
		loadEnvironmentOverrides();
		// Startup the ContentBox modules, if any
		wirebox.getInstance( "moduleService@cb" ).startup();
		// Startup localization settings
		if( controller.getSetting( 'using_i18n' ) ){
			// Load resource bundles here when ready
		} else{
			// Parent app does not have i18n configured, so add settings manually
			controller.setSetting( 'LocaleStorage', 'cookie' );
			// Add Back when Ready -> controller.setSetting( 'defaultResourceBundle', moduleMapping & '/includes/i18n/main' );
			controller.setSetting( 'defaultLocale', "en_US" );
		}
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
	}

	/************************************** PRIVATE *********************************************/

	/**
	* Load up config overrides
	*/
	private function loadConfigOverrides(){
		var settingService 	= wirebox.getInstance( "SettingService@cb" );
		var oConfig 		= controller.getSetting( "ColdBoxConfig" );
		var configStruct 	= controller.getConfigSettings();
		var contentboxDSL 	= oConfig.getPropertyMixin( "contentbox", "variables", structnew() );

		// Verify if we have settings on the default site for now.
		if(
			structKeyExists( contentboxDSL, "settings" )
			&&
			structKeyExists( contentboxDSL.settings, "default" )
		){
			var overrides 	= contentboxDSL.settings.default;
			var allSettings = settingService.getAllSettings( asStruct = true );
			// Append and override
			structAppend( allSettings, overrides, true );
			// Store them
			settingService.storeSettings( allSettings );
			// Log it
			variables.log.info( "ContentBox config overrides loaded.", overrides );
		}
	}

	/**
	 * Load up java environment overrides for ContentBox settings
	 * The pattern to look is `contentbox.{site}.{setting}`
	 * Example: contentbox.default.cb_media_directoryRoot
	 */
	private function loadEnvironmentOverrides(){
		var settingService      = wirebox.getInstance( "SettingService@cb" );
		var oSystem 			= createObject( "java", "java.lang.System" );
		var environmentSettings = oSystem.getEnv();
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
		var allSettings = settingService.getAllSettings( asStruct = true );
		structAppend( allSettings, overrides, true );
		// Store them
		settingService.storeSettings( allSettings );
		// Log it
		variables.log.info( "ContentBox environment overrides loaded.", overrides );
	}

	/**
	 * Verify the custom module exists. If not, we will auto-generate one to avoid conflicts
	 * and issues with new custom approaches.
	 */
	private function verifyCustomModule(){
		var appPath 			= controller.getSetting( "ApplicationPath" );
		var customModulesPath 	= appPath & "modules_app/contentbox-custom";

		// Verify modules_app: just in case
		if( !directoryExists( appPath & "modules_app" ) ){
			directoryCreate( appPath & "modules_app" );
		}

		// Build out the module
		if( !directoryExists( customModulesPath ) ){
			directoryCreate( customModulesPath );
			directoryCreate( customModulesPath & "/_content" );
			directoryCreate( customModulesPath & "/_modules" );
			directoryCreate( customModulesPath & "/_themes" );
			directoryCreate( customModulesPath & "/_widgets" );
			fileCopy(
				modulePath & "models/modules/custom/ModuleConfigBase.cfc",
				customModulesPath & "ModuleConfig.cfc"
			);
		}
	}
	
	/**
	* This interception point waits until after ContentBox is loaded, to call the widget service to build the Widget maps.
	* Previously Custom widgets were not found, because the Custom Map was not built until another function calls getWidgets()
	* 
	*/
	function postModuleLoad( event, interceptData, buffer, rc, prc ) {
        if( arguments.interceptData.moduleName == "contentbox" ){
            wirebox.getInstance( "widgetservice@cb" ).getWidgets();
        }
    }

}
