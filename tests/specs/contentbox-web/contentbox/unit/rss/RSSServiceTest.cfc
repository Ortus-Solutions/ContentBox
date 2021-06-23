/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" skip {

	function setup(){
		super.setup();
		mockSettingsService = prepareMock( getInstance( "SettingService@cb" ) );
		mockCBHelper        = prepareMock( getInstance( "CBHelper@cb" ) );
		service             = prepareMock( getInstance( "RSSService@cb" ) );
		service.$property(
			"settingService",
			"variables",
			mockSettingsService
		);
		service.$property( "CBHelper", "variables", mockCBHelper );
	}

	function testBuildCommentFeed(){
		// mock cb
		mockCBHelper
			.$( "siteName", "Unit Test" )
			.$( "siteDescription", "Unit Test" )
			.$( "linkHome", "http://localhost" )
			.$( "linkComment", "http://localhost##comments" );
		// All Comments
		makePublic( service, "buildCommentFeed" );
		r = service.buildCommentFeed();
		assertTrue( isXML( r ) );

		// Slug
		var b = entityLoad( "cbEntry" )[ 1 ];
		r     = service.buildCommentFeed( slug = b.getSlug() );
		assertTrue( isXML( r ) );

		// ContentType
		r = service.buildCommentFeed( contentType = "Page" );
		assertTrue( isXML( r ) );
	}

	function testBuildContentFeed(){
		getRequestContext().setValue( "CBENTRYPOINT", "http://localhost", true );
		// mock cb
		mockCBHelper
			.$( "siteName", "Unit Test" )
			.$( "siteDescription", "Unit Test" )
			.$( "linkHome", "http://localhost" )
			.$( "linkComments", "http://localhost##comments" )
			.$( "linkContent", "http://localhost" );
		// All Data
		makePublic( service, "buildContentFeed" );
		var r = service.buildContentFeed();
		assertTrue( isXML( r ) );

		// Category
		r = service.buildContentFeed( category = "ContentBox" );
		assertTrue( isXML( r ) );
	}

	function testBuildEntryFeed(){
		getRequestContext().setValue( "CBENTRYPOINT", "http://localhost", true );
		// mock cb
		mockCBHelper
			.$( "siteName", "Unit Test" )
			.$( "siteDescription", "Unit Test" )
			.$( "linkHome", "http://localhost" )
			.$( "linkComments", "http://localhost##comments" )
			.$( "linkEntry", "http://localhost" );
		// All Data
		makePublic( service, "buildEntryFeed" );
		r = service.buildEntryFeed();
		assertTrue( isXML( r ) );

		// Category
		r = service.buildEntryFeed( category = "ContentBox" );
		assertTrue( isXML( r ) );
	}

	function testbuildPageFeed(){
		getRequestContext().setValue( "CBENTRYPOINT", "http://localhost", true );
		// mock cb
		mockCBHelper
			.$( "siteName", "Unit Test" )
			.$( "siteDescription", "Unit Test" )
			.$( "linkHome", "http://localhost" )
			.$( "linkComments", "http://localhost##comments" )
			.$( "linkPage", "http://localhost" );
		// All Data
		makePublic( service, "buildPageFeed" );
		r = service.buildPageFeed();
		assertTrue( isXML( r ) );

		// Category
		r = service.buildPageFeed( category = "ContentBox" );
		assertTrue( isXML( r ) );
	}

}
