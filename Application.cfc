/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Application Bootstrap
*/
component{
	// THIS LOADS THE DSN CREATOR WHEN INSTALLING CONTENTBOX FOR THE FIRST TIME
	// THIS CAN BE REMOVED AFTER INSTALLATION, USUALLY IT IS REMOVED BY THE INSTALLER
	//include "modules/contentbox-installer/includes/dsn_relocation.cfm";

	// Application properties, modify as you see fit
	this.name 				= "ContentBox" & hash( getCurrentTemplatePath() );
	this.sessionManagement 	= true;
	this.sessionTimeout 	= createTimeSpan( 0, 1, 0, 0 );
	this.setClientCookies 	= true;
	this.setDomainCookies 	= true;
	this.scriptProtect		= false;
	this.secureJSON 		= false;

	/**************************************
	LUCEE Specific Settings
	**************************************/
	// buffer the output of a tag/function body to output in case of a exception
	this.bufferOutput 					= true;
	// Activate Gzip Compression
	this.compression 					= false;
	// Turn on/off white space managemetn
	this.whiteSpaceManagement 			= "smart";
	// Turn on/off remote cfc content whitespace
	this.suppressRemoteComponentContent = false;

	// ColdBox Application Specific, Modify if you need to
	COLDBOX_APP_ROOT_PATH 	= getDirectoryFromPath( getCurrentTemplatePath() );
	COLDBOX_APP_MAPPING		= "";
	COLDBOX_CONFIG_FILE 	= "";
	COLDBOX_APP_KEY 		= "";

	// LOCATION MAPPINGS
	this.mappings[ "/cbapp" ] 				= COLDBOX_APP_ROOT_PATH;
	this.mappings[ "/coldbox" ] 			= COLDBOX_APP_ROOT_PATH & "coldbox";
	this.mappings[ "/contentbox" ] 			= COLDBOX_APP_ROOT_PATH & "modules/contentbox";
	this.mappings[ "/cborm" ] 	 			= this.mappings[ "/contentbox" ] & "/modules/contentbox-deps/modules/cborm";

	// LOAD THE DATASOURCE, EITHER FROM DISK OR ENGINE
	loadDatasource();
	// THE CONTENTBOX DATASOURCE NAME
	this.datasource = "contentbox";
	// ORM SETTINGS
	this.ormEnabled = true;
	this.ormSettings = {
		// ENTITY LOCATIONS, ADD MORE LOCATIONS AS YOU SEE FIT
		cfclocation=[ "models", "modules", "modules_app" ],
		// THE DIALECT OF YOUR DATABASE OR LET HIBERNATE FIGURE IT OUT, UP TO YOU TO CONFIGURE
		//dialect 			= "MySQLwithInnoDB",
		// DO NOT REMOVE THE FOLLOWING LINE OR AUTO-UPDATES MIGHT FAIL.
		dbcreate = "update",
		// FILL OUT: IF YOU WANT CHANGE SECONDARY CACHE, PLEASE UPDATE HERE
		secondarycacheenabled = false,
		cacheprovider		= "ehCache",
		// ORM SESSION MANAGEMENT SETTINGS, DO NOT CHANGE
		logSQL 				= false,
		flushAtRequestEnd 	= false,
		autoManageSession	= false,
		// ORM EVENTS MUST BE TURNED ON FOR CONTENTBOX TO WORK
		eventHandling 		= true,
		eventHandler		= "cborm.models.EventHandler",
		// THIS IS ADDED SO OTHER CFML ENGINES CAN WORK WITH CONTENTBOX
		skipCFCWithError	= true
	};

	// Local ORM SQL Logging
	if( reFindNoCase( "^(dev\.|localhost|127\.0\.0)", cgi.http_host )  ){
		this.ormSettings.logSQL = false;
	}

	/************************************** METHODS *********************************************/

	// application start
	public boolean function onApplicationStart(){
		// Set a high timeout for any orm updates
		setting requestTimeout="300";
		application.cbBootstrap = new coldbox.system.Bootstrap( COLDBOX_CONFIG_FILE, COLDBOX_APP_ROOT_PATH, COLDBOX_APP_KEY, COLDBOX_APP_MAPPING );
		application.cbBootstrap.loadColdbox();
		return true;
	}

	// request start
	public boolean function onRequestStart( string targetPage ){
		// In case bootstrap or controller are missing, perform a manual restart
		if( 
			!structKeyExists( application, "cbBootstrap" ) 
			||
			!structKeyExists( application, "cbController" )
		){
			reinitApplication();
		}
		
		// Development Reinit + ORM Reloads
		if( 
			structKeyExists( application, "cbController")
			&& 
			application.cbController.getSetting( "environment" ) == "development" 
			&&
			application.cbBootstrap.isFWReinit()
		){
			if( structKeyExists( server, "lucee" ) ){ pagePoolClear(); }
			ORMREload();
		}

		// Process ColdBox Request
		application.cbBootstrap.onRequestStart( arguments.targetPage );

		return true;
	}

	public void function onSessionStart(){
		if( structKeyExists( application, "cbBootstrap") ){
			application.cbBootStrap.onSessionStart();
		}
	}

	public void function onSessionEnd( struct sessionScope, struct appScope ){
		arguments.appScope.cbBootStrap.onSessionEnd( argumentCollection=arguments );
	}

	public boolean function onMissingTemplate(template){
		return application.cbBootstrap.onMissingTemplate( argumentCollection=arguments );
	}

	/**
	* Application Reinitialization
	**/
	private void function reinitApplication(){
		//Run onAppStart
		onApplicationStart();
	}

	/**
	 * Load the datasource by convention by looking at `config/runtime.properties.cfm` 
	 * or if not, load by default name of `contentbox` which needs to be registered in the CFML engine
	 * This is mostly used for baking docker images with seeded datasources.
	 */
	private void function loadDatasource(){
		// Load our Runtime Properties, which will dynamically create our datasource from config/runtime.properties, 
		// if it does not exist
		var runtimeProperties = COLDBOX_APP_ROOT_PATH & 'config/runtime.properties.cfm';
		if( fileExists( runtimeProperties ) ){
			var props = createObject( "java", "java.util.Properties" ).init();
			props.load( createObject( "java", "java.io.FileInputStream" ).init( runtimeProperties ) );

			// Init the datasource with shared engine properties
			var dsn = {
				username 	= props.getProperty( "DB_USERNAME", "" ),
				password 	= props.getProperty( "DB_PASSWORD", "" ),
				storage 	= props.getProperty( "DB_STORAGE", "false" ),
				clob 		= true,
				blob 		= true
			};

			// Check for full JDBC Connection strings and classes
			var connectionString = props.getProperty( "DB_CONNECTIONSTRING", "" );
			// If no connection string, add required common host/database params
			if( !len( connectionString ) ){
				dsn.host     	= props.getProperty( "DB_HOST" );
				dsn.port     	= props.getProperty( "DB_PORT" );
				dsn.database 	= props.getProperty( "DB_DATABASE" );
				// Lucee Driver Type
				dsn.type 	 	= props.getProperty( "DB_TYPE", "" );
				// ACF Driver Type
				dsn.driver 		= props.getProperty( "DB_DRIVER", "" );
			}
			// Leverages Connection strings
			else {
				if( structKeyExists( server, "lucee" ) ){
					dsn.connectionString = connectionString;
					dsn.class 			 = props.getProperty( "DB_CLASS" );
				} else {
					dsn.url = connectionString;
				}
			}
			// Set it
			this.datasources[ "contentbox" ] = dsn;
		}
	}
}