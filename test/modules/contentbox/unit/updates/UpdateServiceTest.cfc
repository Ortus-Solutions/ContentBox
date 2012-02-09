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
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.updates.UpdateService"{

	function setup(){
		super.setup();
		mockZip = getMockBox().createEmptyMock("coldbox.system.core.util.Zip");
		wirebox = getMockBox().createEmptyMock("coldbox.system.ioc.Injector");
		
		// init service
		model.$property("zipUtil","variables",mockZip);
		model.$property("wirebox","variables",wirebox);
		model.$property("appPath","variables", expandPath("/contentbox-shell") );
		model.init();
	}
	
	function testPath(){
		path = model.getPatchesLocation();
		assertEquals( expandPath("/contentbox/model/updates/patches"), path );
		debug(path);
	}
	
	function testBuildUpdater(){
		 var source = expandPath("/contentbox-test/resources/patches/Update.cfc");
		 var version = "1-0-0-0-1";
		 var dest = expandPath("/contentbox/model/updates/patches/#version#/Update.cfc");
		 
		// copy updater
		directoryCreate( getDirectoryFromPath( dest ) );
		fileCopy( source, dest );
		
		try{
			wirebox.$("getInstance", createObject("component","contentbox.model.updates.patches.#version#.Update") );
			r = model.buildUpdater( version );
			assertTrue( isObject(r) );
		}
		finally{
			directoryDelete( getDirectoryFromPath( dest ), true );
		}
	}
	
	function testdownloadPatch(){
		model.setPatchesLocation( expandPath("/contentbox-test/resources/patches/test") );
		log = createObject("java","java.lang.StringBuilder").init('');
		mockZip.$("extract",true).$("listing",queryNew(""));
		
		// good patch
		model.downloadPatch("http://cf9contentbox.jfetmac/test/resources/patches/test.zip",log);
		assertTrue( fileExists( expandPath("/contentbox-test/resources/patches/test/test.zip") ) );
		fileDelete( expandPath("/contentbox-test/resources/patches/test/test.zip") );
		
		// Bad Patch
		r = model.downloadPatch("http://cf9contentbox.jfetmac/test/resources/patches/invalid.zip",log);
		assertFalse( r );
		
	}
	
	function testProcessRemovals(){
		var source = expandPath("/contentbox-test/resources/patches/deletes_empty.txt");
		var log = createObject("java","java.lang.StringBuilder").init('');
		
		// test empty
		model.processRemovals( source, log );
		assertEquals( "No updated files to remove. <br/>", log.toString() );
		
		// test with files
		var source = expandPath("/contentbox-test/resources/patches/deletes.txt");
		var log = createObject("java","java.lang.StringBuilder").init('');
		var destination = expandPath("/contentbox-test/resources/patches/tmp/test.txt");
		fileWrite( destination, "file");
		model.processRemovals( source, log );
		debug( log.toString() );
		
	}
	
	function testProcessUpdates(){
		var source = expandPath("/contentbox-test/resources/patches/patch.zip");
		var log = createObject("java","java.lang.StringBuilder").init('');
		
		mockZip.$("list",queryNew("")).$("extract",true);
		model.processUpdates( source, log );
		debug( log.toString() );
		
		
	}

} 