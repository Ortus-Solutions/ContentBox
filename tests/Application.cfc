/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Tests Bootstrap
*/
component{
	this.name				= "ContentBoxTestingSuite";
	this.sessionManagement	= true;
	this.sessionTimeout 	= createTimeSpan( 0, 0, 10, 0 );
	this.applicationTimeout = createTimeSpan( 0, 0, 10, 0 );
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

	// FILL OUT: THE LOCATION OF THE CONTENTBOX MODULE
	rootPath = replacenocase( replacenocase( getDirectoryFromPath( getCurrentTemplatePath() ), "tests\", "" ), "tests/", "" );

	this.mappings[ "/root" ]   				= rootPath;
	this.mappings[ "/cbapp" ]   			= rootPath;
	this.mappings[ "/tests" ] 				= getDirectoryFromPath( getCurrentTemplatePath() );
	this.mappings[ "/coldbox" ] 			= rootPath & "coldbox" ;
	this.mappings[ "/testbox" ] 			= rootPath & "testbox" ;
	this.mappings[ "/contentbox" ] 			= rootPath & "modules/contentbox" ;

	// Modular ORM Dependencies
	this.mappings[ "/cborm" ]				= this.mappings[ "/contentbox" ] & "/modules/contentbox-deps/modules/cborm";

	// Datasource definitions For Standalone mode/travis mode.
	if( directoryExists( "/home/travis" ) ){
		this.datasources[ "contentbox" ] = {
			driver 				: "MySQL5",
			type 				: "mysql",
			connectionString	: 'jdbc:mysql://localhost:3306/contentbox?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true',
			url					: 'jdbc:mysql://localhost:3306/contentbox?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true',
			username 			: 'root'
		};
		if( structKeyExists( server, "lucee" ) ){
			this.datasources[ "contentbox" ].class = 'com.mysql.jdbc.Driver';
		}
	}

	// ORM Settings
	this.ormEnabled = true;
	this.datasource = "contentbox";
	this.ormSettings = {
		cfclocation			= [ rootPath & "/modules/contentbox/models" ],
		//logSQL 				= true, //Uncomment when needed
		logSQL 				= false,
		flushAtRequestEnd 	= false,
		autoManageSession	= false,
		eventHandling 		= true,
		eventHandler		= "cborm.models.EventHandler",
		skipCFCWithError	= true,
		secondarycacheenabled = false
	};

	public boolean function onRequestStart(String targetPage){
		// Set a high timeout for long running tests
		setting requestTimeout="9999";

		// Cleanup
		if( !isNull( application.cbController ) ){
			application.cbController.getLoaderService().processShutdown();
		}
		structDelete( application, "cbController" );
		structDelete( application, "wirebox" );

		// ORM Reload for fresh results
		if( structKeyExists( url, "fwreinit" ) ){
			if( structKeyExists( server, "lucee" ) ){
				pagePoolClear();
			}
			ormReload();
		}

		return true;
	}

}