/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
*/
component{
	// Application properties, modify as you see fit
	this.name 				= "ContentBox-Shell-" & hash(getCurrentTemplatePath());
	this.sessionManagement 	= true;
	this.sessionTimeout 	= createTimeSpan(0,0,45,0);
	this.setClientCookies 	= true;

	// Mapping Imports
	import coldbox.system.*;

	// ColdBox Application Specific, Modify if you need to
	COLDBOX_APP_ROOT_PATH 	= getDirectoryFromPath( getCurrentTemplatePath() );
	COLDBOX_APP_MAPPING		= "";
	COLDBOX_CONFIG_FILE 	= "";
	COLDBOX_APP_KEY 		= "";

	// FILL OUT: THE DATASOURCE FOR CONTENTBOX MANDATORY
	this.datasource = "contentbox";
	// THE LOCATION OF THE 'CONTENTBOX' MODULE MANDATORY
	this.mappings["/contentbox-root"] = COLDBOX_APP_ROOT_PATH;
	this.mappings["/contentbox"] = COLDBOX_APP_ROOT_PATH & "modules/contentbox";
	this.mappings["/contentbox-ui"] = COLDBOX_APP_ROOT_PATH & "modules/contentbox-ui";
	this.mappings["/contentbox-admin"] = COLDBOX_APP_ROOT_PATH & "modules/contentbox-admin";
	this.mappings["/contentbox-modules"] = COLDBOX_APP_ROOT_PATH & "modules/contentbox-modules";
	// THE LOCATION OF COLDBOX
	this.mappings["/coldbox"] 	 = expandPath("/coldbox");

	// ORM SETTINGS
	this.ormEnabled = true;
	this.ormSettings = {
		// FILL OUT: ADD MORE LOCATIONS AS YOU SEE FIT
		cfclocation=["model","modules"],
		// FILL OUT: THE DIALECT OF YOUR DATABASE OR LET HIBERNATE FIGURE IT OUT, UP TO YOU
		//dialect 			= "MySQLwithInnoDB",
		// DO NOT REMOVE THE FOLLOWING LINE OR AUTO-UPDATES MIGHT FAIL.
		dbcreate = "update",
		// FILL OUT: IF YOU WANT ANOTHER SECONDARY CACHE, PLEASE UPDATE HERE
		secondarycacheenabled = true,
		cacheprovider		= "ehCache",
		// ORM SESSION MANAGEMENT SETTINGS, CHANGE AT YOUR OWN RISK
		logSQL 				= true,
		flushAtRequestEnd 	= false,
		autoManageSession	= false,
		//savemapping = true,
		// ORM EVENTS MUST BE TURNED ON FOR CONTENTBOX TO WORK
		eventHandling 		= true,
		eventHandler		= "modules.contentbox.model.system.EventHandler",
		// THIS IS ADDED SO OTHER CFML ENGINES CAN WORK WITH CONTENTBOX
		skipCFCWithError	= true
	};
	
	// application start
	public boolean function onApplicationStart(){
		application.cbBootstrap = new Coldbox(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY);
		application.cbBootstrap.loadColdbox();
		return true;
	}
	
	// request start
	public boolean function onRequestStart(String targetPage){

		// ORM Reload: REMOVE IN PRODUCTION IF NEEDED
		if( structKeyExists(url,"ormReload") ){ ormReload(); }
		
		//applicationstop();abort;

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