/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Tests Bootstrap
*/
component{
	this.name				= "ContentBoxTestingSuite" & hash( getCurrentTemplatePath() );
	this.sessionManagement	= true;
	this.sessionTimeout		= createTimeSpan( 0, 0, 0, 30 );
	this.setClientCookies	= true;

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

	// ORM Settings
	this.ormEnabled = true;
	// FILL OUT: THE DATASOURCE OF CONTENTBOX
	this.datasource = "contentbox";

	// FILL OUT: THE LOCATION OF THE CONTENTBOX MODULE
	rootPath = replacenocase( replacenocase( getDirectoryFromPath( getCurrentTemplatePath() ), "tests\", "" ), "tests/", "" );
										
	this.mappings[ "/root" ]   				= rootPath;
	this.mappings[ "/tests" ] 				= getDirectoryFromPath( getCurrentTemplatePath() );
	this.mappings[ "/coldbox" ] 			= rootPath & "/coldbox" ;
	this.mappings[ "/testbox" ] 			= rootPath & "/testbox" ;
	this.mappings[ "/contentbox" ] 			= rootPath & "/modules/contentbox" ;
	this.mappings[ "/contentbox-deps" ]		= rootPath & "/modules/contentbox/modules/contentbox-deps";
	this.mappings[ "/contentbox-ui" ] 		= rootPath & "/modules/contentbox/modules/contentbox-ui";
	this.mappings[ "/contentbox-admin" ] 	= rootPath & "/modules/contentbox/modules/contentbox-admin";
	// Modular ORM Dependencies
	this.mappings[ "/cborm" ]				= this.mappings[ "/contentbox-deps" ] & "modules/cborm";

	this.ormSettings = {
		cfclocation=[ rootPath & "/modules" ],
		logSQL 				= true,
		flushAtRequestEnd 	= false,
		autoManageSession	= false,
		eventHandling 		= true,
		//eventHandler		= "coldbox.system.orm.hibernate.WBEventHandler",
		skipCFCWithError	= true,
		secondarycacheenabled = false
	};

	public boolean function onRequestStart(String targetPage){

		//Set a high timeout for long running tests
		setting requestTimeout="9999";

		// ORM Reload for fresh results
		ormReload();

		return true;
	}