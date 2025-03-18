/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Tests Bootstrap
 */
component {

	this.name               = "ContentBox Testing Suite";
	this.sessionManagement  = true;
	this.sessionTimeout     = createTimespan( 0, 0, 10, 0 );
	this.applicationTimeout = createTimespan( 0, 0, 10, 0 );
	this.setClientCookies   = true;

	/**************************************
	LUCEE Specific Settings
	**************************************/
	// buffer the output of a tag/function body to output in case of a exception
	this.bufferOutput                   = true;
	// Activate Gzip Compression
	this.compression                    = false;
	// Turn on/off white space managemetn
	this.whiteSpaceManagement           = "smart";
	// Turn on/off remote cfc content whitespace
	this.suppressRemoteComponentContent = false;

	/**************************************
	TESTING ENV Seeding
	**************************************/
	createObject( "java", "java.lang.System" ).setProperty( "ENVIRONMENT", "testing" );

	/**
	 * --------------------------------------------------------------------------
	 * Test Mappings
	 * --------------------------------------------------------------------------
	 */
	// FILL OUT: THE LOCATION OF THE CONTENTBOX MODULE
	rootPath = replaceNoCase(
		replaceNoCase(
			getDirectoryFromPath( getCurrentTemplatePath() ),
			"tests\",
			""
		),
		"tests/",
		""
	);
	this.mappings[ "/root" ]       = rootPath;
	this.mappings[ "/cbapp" ]      = rootPath;
	this.mappings[ "/tests" ]      = getDirectoryFromPath( getCurrentTemplatePath() );
	this.mappings[ "/coldbox" ]    = rootPath & "coldbox";
	this.mappings[ "/testbox" ]    = rootPath & "testbox";
	this.mappings[ "/contentbox" ] = rootPath & "modules/contentbox";
	// Modular ORM Dependencies
	this.mappings[ "/cborm" ]      = this.mappings[ "/contentbox" ] & "/modules/contentbox-deps/modules/cborm";

	/**
	 * --------------------------------------------------------------------------
	 * Test ORM Settings
	 * --------------------------------------------------------------------------
	 */
	this.ormEnabled  = true;
	this.datasource  = "contentbox";
	this.ormSettings = {
		cfclocation : [
			// If you create your own app entities
			rootPath & "models",
			// The ContentBox Core Entities
			rootPath & "modules/contentbox/models",
			// Custom Module Entities
			rootPath & "modules_app"
		],
		dialect               : "org.hibernate.dialect.MySQL5InnoDBDialect", // MySQL Dialect
		dbcreate              : "none",
		secondarycacheenabled : false,
		cacheprovider         : "ehCache",
		logSQL                : false,
		flushAtRequestEknd    : false,
		autoManageSession     : false,
		eventHandling         : true,
		eventHandler          : "cborm.models.EventHandler",
		skipCFCWithError      : true
	};

	public boolean function onRequestStart( String targetPage ){
		// Set a high timeout for long running tests
		setting requestTimeout="9999";

		// New ColdBox Virtual Application Starter
		request.coldBoxVirtualApp = new coldbox.system.testing.VirtualApp( appMapping = "/root" );

		// Force reinit to clear out caches, reload ORM and restart virtual app.
		if ( structKeyExists( url, "fwreinit" ) ) {
			if ( structKeyExists( server, "lucee" ) ) {
				pagePoolClear();
			}
			ormReload();
			request.coldBoxVirtualApp.shutdown();
		}

		// If hitting the runner or specs, prep our virtual app, else ignore startup
		if ( getBaseTemplatePath().replace( expandPath( "/tests" ), "" ).reFindNoCase( "(runner|specs)" ) ) {
			request.coldBoxVirtualApp.startup( true );
		}

		return true;
	}

	public void function onRequestEnd( required targetPage ){
		request.coldBoxVirtualApp.shutdown();
	}

}
