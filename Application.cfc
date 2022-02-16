/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Application Bootstrap
 */
component {
	/**
	 * --------------------------------------------------------------------------
	 * NON COMMANDBOX INSTALLS
	 * --------------------------------------------------------------------------
	 * If you are NOT using CommandBox as your server, then set the variable to true
	 * and ContentBox will load the `.env` environment file that is needed for operation.
	 * Without this, your NON CommandBox ContentBox install will fail.
	 */
	this._loadDynamicEnvironment = false;

	/**
	 * --------------------------------------------------------------------------
	 * Application Properties: Modify as you see fit!
	 * --------------------------------------------------------------------------
	 */
	this.name              = "ContentBox CMS";
	this.sessionManagement = true;
	this.sessionTimeout    = createTimespan( 0, 1, 0, 0 );
	this.setClientCookies  = true;
	this.setDomainCookies  = true;
	this.scriptProtect     = false;
	this.secureJSON        = false;
	this.timezone 			= "UTC";

	/**
	 * --------------------------------------------------------------------------
	 * Lucee Specific Settings
	 * --------------------------------------------------------------------------
	 */

	 // buffer the output of a tag/function body to output in case of a exception
	this.bufferOutput                   = true;
	// Activate Gzip Compression
	this.compression                    = false;
	// Turn on/off white space management
	this.whiteSpaceManagement           = "smart";
	// Turn on/off remote cfc content whitespace
	this.suppressRemoteComponentContent = false;

	/**
	 * --------------------------------------------------------------------------
	 * ColdBox Bootstrap Settings
	 * --------------------------------------------------------------------------
	 * Modify only if you need to, else default them.
	 */
	COLDBOX_APP_ROOT_PATH 	= getDirectoryFromPath( getCurrentTemplatePath() );
	COLDBOX_APP_MAPPING   	= "";
	COLDBOX_CONFIG_FILE   	= "";
	COLDBOX_APP_KEY       	= "";
	COLDBOX_FAIL_FAST 		= true;

	/**
	 * --------------------------------------------------------------------------
	 * Location Mappings
	 * --------------------------------------------------------------------------
	 * - cbApp : Quick reference to root application
	 * - coldbox : Where ColdBox library is installed
	 * - contentbox : Where the ContentBox module root is installed
	 * - cborm : Where the cborm library is installed: Needed for ORM Event Handling.
	 */
	this.mappings[ "/cbapp" ]      = COLDBOX_APP_ROOT_PATH;
	this.mappings[ "/coldbox" ]    = COLDBOX_APP_ROOT_PATH & "coldbox";
	this.mappings[ "/contentbox" ] = COLDBOX_APP_ROOT_PATH & "modules/contentbox";
	this.mappings[ "/cborm" ]      = this.mappings[ "/contentbox" ] & "/modules/contentbox-deps/modules/cborm";

	/**
	 * --------------------------------------------------------------------------
	 * ORM + Datasource Settings
	 * --------------------------------------------------------------------------
	 * - Please update the cfcLocation as needed to locate more ORM entities for your app
	 * - Dialect is incredibly important! Do not let Hibernate auto configur it, you can get nasty errors.
	 * So Make sure you select one.
	 */
	request.$coldboxUtil = new coldbox.system.core.util.Util();
	if( this._loadDynamicEnvironment ){
		loadEnv();
	}
	// THE CONTENTBOX DATASOURCE NAME
	this.datasource  = "contentbox";
	// ORM SETTINGS
	this.ormEnabled  = true;
	// cfformat-ignore-start
	this.ormSettings = {
		// ENTITY LOCATIONS, ADD MORE LOCATIONS AS YOU SEE FIT
		cfclocation           : [
			// If you create your own app entities
			"models",
			// The ContentBox Core Entities
			"modules/contentbox/models",
			// Custom Module Entities
			"modules_app"
		],
		// THE DIALECT OF YOUR DATABASE OR LET HIBERNATE FIGURE IT OUT, UP TO YOU TO CONFIGURE.
		dialect 				: request.$coldboxUtil.getSystemSetting( "ORM_DIALECT", "" ),
		// DO NOT REMOVE THE FOLLOWING LINE OR AUTO-UPDATES MIGHT FAIL.
		dbcreate              	: "update",
		secondarycacheenabled 	: request.$coldboxUtil.getSystemSetting( "ORM_SECONDARY_CACHE", false ),
		cacheprovider         	: request.$coldboxUtil.getSystemSetting( "ORM_SECONDARY_CACHE", "ehCache" ),
		logSQL                	: request.$coldboxUtil.getSystemSetting( "ORM_LOGSQL", false ),
		sqlScript				: request.$coldboxUtil.getSystemSetting( "ORM_SQL_SCRIPT", "" ),
		// ORM SESSION MANAGEMENT SETTINGS, DO NOT CHANGE
		flushAtRequestEnd     	: false,
		autoManageSession     	: false,
		// ORM EVENTS MUST BE TURNED ON FOR CONTENTBOX TO WORK DO NOT CHANGE
		eventHandling         	: true,
		eventHandler          	: "cborm.models.EventHandler",
		// THIS IS ADDED SO OTHER CFML ENGINES CAN WORK WITH CONTENTBOX
		skipCFCWithError      	: true,
		// TURN ON FOR Debugging if ORM mappings are not working.
		savemapping 			: false
	};
	// cfformat-ignore-end

	/************************************** METHODS *********************************************/

	// application start
	public boolean function onApplicationStart(){
		// Set a high timeout for any orm updates
		setting requestTimeout ="300";
		application.cbBootstrap= new coldbox.system.Bootstrap(
			COLDBOX_CONFIG_FILE,
			COLDBOX_APP_ROOT_PATH,
			COLDBOX_APP_KEY,
			COLDBOX_APP_MAPPING
		);
		application.cbBootstrap.loadColdbox();
		return true;
	}

	// request start
	public boolean function onRequestStart( string targetPage ){
		// In case bootstrap or controller are missing, perform a manual restart
		if (
			isNull( application.cbBootstrap )
			||
			isNull( application.cbController )
		) {
			if( this._loadDynamicEnvironment ){
				loadEnv( force : true );
			}
			reinitApplication();
		}

		// Development Reinit + ORM Reloads
		if (
			!isNull( application.cbController )
			&&
			application.cbController.getSetting( "environment" ) == "development"
			&&
			application.cbBootstrap.isFWReinit()
		) {
			if( this._loadDynamicEnvironment ){
				loadEnv( force : true );
			}
			if ( structKeyExists( server, "lucee" ) ) {
				pagePoolClear();
			}
			ormReload();
		}

		// Process ColdBox Request
		application.cbBootstrap.onRequestStart( arguments.targetPage );

		return true;
	}

	public void function onSessionStart(){
		if( !isNull( application.cbBootstrap ) ){
			application.cbBootStrap.onSessionStart();
		}
	}

	public void function onSessionEnd( struct sessionScope, struct appScope ){
		arguments.appScope.cbBootStrap.onSessionEnd( argumentCollection = arguments );
	}

	public boolean function onMissingTemplate( template ){
		return application.cbBootstrap.onMissingTemplate( argumentCollection = arguments );
	}

	/**
	 * Application Reinitialization
	 **/
	private void function reinitApplication(){
		// Run onAppStart
		onApplicationStart();
	}

	/**
	 * This method is only called if you are in a NON CommandBox install.
	 */
	private void function loadEnv( boolean force = false){
		var javaSystem = createObject( "java", "java.lang.System" );
		var value = javaSystem.getProperty( "contentbox_runtime_env" );
		// If not loaded, lock and load.
		if ( isNull( value ) || arguments.force ) {
			lock
				name="contentbox_runtime_env"
				timeout="15"
				throwOnTimeout="true"
				type="exclusive"
			{
				// Double lock
				if( isNull( javaSystem.getProperty( "contentbox_runtime_env" ) ) || arguments.force ){
					// Load .env file
					var props = createObject( "java", "java.util.Properties" ).init();
					props.load(
						createObject( "java", "java.io.FileInputStream" ).init( expandPath( "/.env" ) )
					);
					// Iterate and add
					var availableProps = props.propertyNames();
					while( availableProps.hasNext() ){
						var propName = availableProps.next();
						javaSystem.setProperty( propName,  props.getProperty( propName ) );
					}
					javaSystem.setProperty( "contentbox_runtime_env", true );
				} // end double lock
			} // end lock
		} // end lock check
	}

}
