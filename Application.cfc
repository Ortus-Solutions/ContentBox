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
	this.mappings[ "/contentbox-deps" ] 	= COLDBOX_APP_ROOT_PATH & "modules/contentbox/modules/contentbox-deps";
	this.mappings[ "/cborm" ] 	 			= this.mappings[ "/contentbox-deps" ] & "/modules/cborm";

	// THE DATASOURCE FOR CONTENTBOX MANDATORY
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

	/************************************** METHODS *********************************************/

	// application start
	public boolean function onApplicationStart(){
		//Set a high timeout for any orm updates
		setting requestTimeout="180";
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

	//@cf9-onError@
}