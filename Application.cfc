/**
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Luis Majano
Date        :	10/16/2007
Description :
	This is the Application.cfc for usage withing the ColdBox Framework.
	Make sure that it extends the coldbox object:
	coldbox.system.Coldbox
	
	So if you have refactored your framework, make sure it extends coldbox.
 
@output false
*/
component{
	// Application properties
	this.name 				= hash(getCurrentTemplatePath());
	this.sessionManagement 	= true;
	this.sessionTimeout 	= createTimeSpan(0,0,30,0);
	this.setClientCookies 	= true;
	
	// Mappings Imports
	import coldbox.system.*;
	
	// ColdBox Specifics
	COLDBOX_APP_ROOT_PATH 	= getDirectoryFromPath(getCurrentTemplatePath());
	COLDBOX_APP_MAPPING		= "";
	COLDBOX_CONFIG_FILE 	= "";
	COLDBOX_APP_KEY 		= "";
	
	// ORM Settings
	this.ormEnabled = true;
	//this.mappings["/"] 			= COLDBOX_APP_ROOT_PATH;
	// FILL OUT: THE DATASOURCE OF BLOGBOX
	this.datasource = "blogbox";
	// FILL OUT: THE LOCATION OF THE BLOG BOX MODULE
	this.mappings["/blogbox"] 	= COLDBOX_APP_ROOT_PATH & "modules/blogbox";
	this.ormSettings = {
		cfclocation=["model","modules"],
		// FILL OUT: THE DIALECT OF YOUR DATABASE
		dialect 			= "MySQLwithInnoDB",
		// FILL OUT: Change to dropcreate if you are running this for the first time, then change it back to update
		dbcreate			= "update",
		//sqlscript			= "modules/blogbox/install/sql/blogbox_data.sql",
		logSQL 				= true,
		flushAtRequestEnd 	= false,
		autoManageSession	= false,
		eventHandling 		= true
	};

	public boolean function onApplicationStart(){
		application.cbBootstrap = new Coldbox(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY);
		application.cbBootstrap.loadColdbox();
		return true;
	}
	
	public boolean function onRequestStart(String targetPage){
		
		// ORM Reload
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