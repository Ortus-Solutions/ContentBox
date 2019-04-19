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
	loadDatasource();
	this.ormEnabled = true;
	this.datasource = "contentbox";
	this.ormSettings = {
		cfclocation			= [ rootPath & "/modules" ],
		logSQL 				= true,
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

		// ORM Reload for fresh results
		if( structKeyExists( url, "fwreinit" ) ){
			if( structKeyExists( server, "lucee" ) ){
				pagePoolClear();
			}
			ormReload();
		}

		return true;
	}

	public void function onRequestEnd() { 
        structDelete( application, "cbController" );
        structDelete( application, "wirebox" );
    } 

    /**
	 * Load the datasource by convention by looking at `config/runtime.properties.cfm` 
	 * or if not, load by default name of `contentbox` which needs to be registered in the CFML engine
	 * This is mostly used for baking docker images with seeded datasources.
	 */
	private void function loadDatasource(){
		// Load our Runtime Properties, which will dynamically create our datasource from config/runtime.properties, 
		// if it does not exist
		var runtimeProperties = rootPath & 'config/runtime.properties.cfm';
		if( fileExists( runtimeProperties ) ){
			var props = createObject( "java", "java.util.Properties" ).init();
			props.load( createObject( "java", "java.io.FileInputStream" ).init( runtimeProperties ) );

			// Init the datasource with shared engine properties
			this.datasources[ "contentbox" ] = {
				username 	= props.getProperty( "DB_USERNAME", "" ),
				password 	= props.getProperty( "DB_PASSWORD", "" ),
				storage 	= props.getProperty( "DB_STORAGE", "false" ),
				clob 		= true,
				blob 		= true
			};
			var dsn = this.datasources[ "contentbox" ];

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
		}
	}

}