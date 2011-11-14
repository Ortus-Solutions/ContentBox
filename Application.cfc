/**
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Luis Majano
Date        :	10/16/2007
Description :
	This is the Application.cfc for usage withing the ColdBox Framework
*/
component{
	// Application properties
	this.name 				= "ContentBox-Shell-" & hash(getCurrentTemplatePath());
	this.sessionManagement 	= true;
	this.sessionTimeout 	= createTimeSpan(0,0,30,0);
	this.setClientCookies 	= true;

	// Mappings Imports
	import coldbox.system.*;

	// ColdBox Specifics
	COLDBOX_APP_ROOT_PATH 	= getDirectoryFromPath( getCurrentTemplatePath() );
	COLDBOX_APP_MAPPING		= "";
	COLDBOX_CONFIG_FILE 	= "";
	COLDBOX_APP_KEY 		= "";

	// FILL OUT: THE DATASOURCE FOR CONTENTBOX
	this.datasource = "contentbox";
	// FILL OUT: THE LOCATION OF THE 'CONTENTBOX' MODULE
	this.mappings["/contentbox"] 	= COLDBOX_APP_ROOT_PATH & "modules/contentbox";

	// ORM SETTINGS
	this.ormEnabled = true;
	this.ormSettings = {
		// FILL OUT: ADD MORE LOCATIONS AS YOU SEE FIT
		cfclocation=["model","modules"],
		// FILL OUT: THE DIALECT OF YOUR DATABASE OR LET HIBERNATE FIGURE IT OUT, UP TO YOU
		//dialect 			= "MySQLwithInnoDB",
		// FILL OUT: Change to dropcreate if you are running this for the first time, then change it back to update for continuos repo updates, or remove for production
		dbcreate			= "update",
		// FILL OUT: Change script for the MS SQL version of the install/setup script
		sqlscript			= "modules/contentbox/install/sql/contentbox_data.sql",
		//sqlscript			= "modules/contentbox/install/sql/contentbox_data_ms.sql",
		logSQL 				= true,
		flushAtRequestEnd 	= false,
		autoManageSession	= false,
		eventHandling 		= true,
		eventHandler		= "modules.contentbox.model.system.EventHandler"
	};

	public boolean function onApplicationStart(){
		application.cbBootstrap = new Coldbox(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY);
		application.cbBootstrap.loadColdbox();
		return true;
	}

	public boolean function onRequestStart(String targetPage){

		// ORM Reload: REMOVE IN PRODUCTION IF NEEDED
		if( structKeyExists(url,"ormReload") ){ ormReload(); }

		// Bootstrap Reinit
		if( not structKeyExists(application,"cbBootstrap") or application.cbBootStrap.isfwReinit() ){
			lock name="coldbox.bootstrap_#this.name#" type="exclusive" timeout="5" throwonTimeout=true{
				structDelete(application,"cbBootStrap");
				application.cbBootstrap = new ColdBox(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY,COLDBOX_APP_MAPPING);
			}
		}

		// ColdBox Reload Checks
		application.cbBootStrap.reloadChecks();

		//Process a ColdBox request only
		if( findNoCase('index.cfm',listLast(arguments.targetPage,"/")) ){
			application.cbBootStrap.processColdBoxRequest();
		}

		return true;
	}

	public void function onSessionStart(){
		application.cbBootStrap.onSessionStart();
	}

	public void function onSessionEnd(struct sessionScope, struct appScope){
		arguments.appScope.cbBootStrap.onSessionEnd(argumentCollection=arguments);
	}

	public boolean function onMissingTemplate(template){
		return application.cbBootstrap.onMissingTemplate(argumentCollection=arguments);
	}
}