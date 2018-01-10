/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
*/
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.models.updates.UpdateService"{

	function setup(){
		super.setup();
		mockZip = createMock( "contentbox.models.util.ZipUtil" ).init();
		wirebox = createEmptyMock( "coldbox.system.ioc.Injector" );

		mockConfig = {
			path = expandPath( "/contentbox" )
		};

		// init service
		model.$property( "zipUtil","variables",mockZip)
			.$property( "wirebox","variables",wirebox)
			.$property( "appPath","variables", expandPath( "/root" ) )
			.$property( "moduleConfig", "variables", mockConfig);
		model.init();
		model.onDIComplete();
	}

	function teardown(){
		// self cleanup on this test only.
		structdelete( application, "cbController" );
	}

	function testBuildUpdater(){
		 var source = expandPath( "/tests/resources/patches/Update.cfc" );
		 var version = "1-0-0-0-1";
		 var dest = expandPath( "/contentbox/updates/Update.cfc" );

		// copy updater
		fileCopy( source, dest );

		try{
			wirebox.$( "getInstance", createObject( "component","contentbox.updates.Update" ) );
			r = model.buildUpdater();
			assertTrue( isObject(r) );
		}
		finally{
			fileDelete( dest );
		}
	}

	function testdownloadPatch(){
		var patchesPath = expandPath( "/tests/resources/patches/test" );

		if( !directoryExists( patchesPath ) ){
			directoryCreate( patchesPath );
		}
		model.setPatchesLocation( patchesPath );
		var log = createObject( "java","java.lang.StringBuilder" ).init('');
		mockZip.$( "extract", true );

		// good patch
		var r = model.downloadPatch( "http://localhost:8589/tests/resources/patches/test.zip", log );
		//debug( log.toString() );
		assertTrue( fileExists( expandPath( "/tests/resources/patches/test/test.zip" ) ) );
		fileDelete( expandPath( "/tests/resources/patches/test/test.zip" ) );

		// Bad Patch
		r = model.downloadPatch( "http://localhost:8589/tests/resources/patches/invalid.zip", log );
		//debug( log.toString() );
		assertFalse( r );
	}

	function testProcessRemovals(){
		var source = expandPath( "/tests/resources/patches/archive/deletes_empty.txt" );
		var dest = expandPath( "/tests/resources/patches/deletes_empty.txt" );
		var log = createObject( "java","java.lang.StringBuilder" ).init('');

		fileCopy( source, dest );

		// test empty
		model.processRemovals( dest, log );
		debug( log.toString() );
		assertTrue( findNoCase( "No updated files to remove. <br/>", log.toString() ) );
		assertFalse( fileExists( dest ) );

		// test with files
		var source		= expandPath( "/tests/resources/patches/archive/deletes.txt" );
		var dest		= expandPath( "/tests/resources/patches/deletes.txt" );
		var log			= createObject( "java","java.lang.StringBuilder" ).init('');
		var destination	= expandPath( "/tests/resources/patches/tmp/test.txt" );

		fileCopy( source, dest );
		fileWrite( destination, "file" );

		model.processRemovals( dest, log );
		
		assertFalse( fileExists( dest ) );
		assertFalse( fileExists( destination ) );
		debug( log.toString() );

	}

	function testProcessUpdates(){
		var original = expandPath( "/tests/resources/patches/archive/patch.zip" );
		var source = expandPath( "/tests/resources/patches/patch.zip" );
		var log = createObject( "java","java.lang.StringBuilder" ).init('');

		fileCopy( original, source );

		mockZip.$( "extract",true);

		model.processUpdates( source, log );
		assertFalse( fileExists( source ) );
		debug( log.toString() );


	}

}