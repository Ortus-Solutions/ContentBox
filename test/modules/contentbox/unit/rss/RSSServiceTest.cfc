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
component extends="coldbox.system.testing.BaseTestCase"{

	function setup(){
		reset();
		super.setup();
		mockSettingsService = getMockBox().prepareMock( getModel("SettingService@cb") );
		mockCBHelper = getMockBox().prepareMock( getModel("CBHelper@cb") );
		service = getMockBox().prepareMock( getModel("RSSService@cb") );
		service.$property("settingService","variables",mockSettingsService );
		service.$property("CBHelper","variables",mockCBHelper );
	}
	
	function testGetRSS(){
		// mocks
		mockSettings = {
			cb_rss_caching = false
		};
		mockSettingsService.$("getAllSettings", mockSettings);
		mockFeed = {};
		service.$("buildEntryFeed", mockFeed)
			.$("buildCommentFeed", mockFeed)
			.$("buildContentFeed", mockFeed)
			.$("buildPageFeed", mockFeed);
	
		// Get all entries RSS
		service.getRSS();
		assertTrue( service.$once("buildContentFeed") );
		
		// Comments
		service.getRSS(comments=true);
		assertTrue( service.$once("buildCommentFeed") );
		
	} 
	
	function testBuildCommentFeed(){
		// mock cb
		mockCBHelper.$("siteName","Unit Test")
			.$("siteDescription","Unit Test")
			.$("linkHome","http://localhost")
			.$("linkComment","http://localhost##comments");
		// All Comments
		makePublic( service, "buildCommentFeed" );
		r = service.buildCommentFeed();
		assertTrue( isXML(r) );
		
		// Slug
		var b = entityLoad("cbEntry")[1];
		r = service.buildCommentFeed(slug=b.getSlug());
		assertTrue( isXML( r ) );
		
		// ContentType
		r = service.buildCommentFeed(contentType='Page');
		assertTrue( isXML( r ) );
	}
	
	function testBuildContentFeed(){
		getRequestContext().setValue("CBENTRYPOINT","http://localhost",true);
		// mock cb
		mockCBHelper.$("siteName","Unit Test")
			.$("siteDescription","Unit Test")
			.$("linkHome","http://localhost")
			.$("linkComments","http://localhost##comments")
			.$("linkContent","http://localhost");
		// All Data
		makePublic( service, "buildContentFeed" );
		r = service.buildContentFeed();
		assertTrue( isXML(r) );
		
		
		// Category
		r = service.buildContentFeed(category='ContentBox');
		assertTrue( isXML( r ) );
	}
	
	function testBuildEntryFeed(){
		getRequestContext().setValue("CBENTRYPOINT","http://localhost",true);
		// mock cb
		mockCBHelper.$("siteName","Unit Test")
			.$("siteDescription","Unit Test")
			.$("linkHome","http://localhost")
			.$("linkComments","http://localhost##comments")
			.$("linkEntry","http://localhost");
		// All Data
		makePublic( service, "buildEntryFeed" );
		r = service.buildEntryFeed();
		assertTrue( isXML(r) );
		
		// Category
		r = service.buildEntryFeed(category='ContentBox');
		assertTrue( isXML( r ) );
	}
	
	function testbuildPageFeed(){
		getRequestContext().setValue("CBENTRYPOINT","http://localhost",true);
		// mock cb
		mockCBHelper.$("siteName","Unit Test")
			.$("siteDescription","Unit Test")
			.$("linkHome","http://localhost")
			.$("linkComments","http://localhost##comments")
			.$("linkPage","http://localhost");
		// All Data
		makePublic( service, "buildPageFeed" );
		r = service.buildPageFeed();
		assertTrue( isXML(r) );
		
		// Category
		r = service.buildPageFeed(category='ContentBox');
		assertTrue( isXML( r ) );
	}
	
} 