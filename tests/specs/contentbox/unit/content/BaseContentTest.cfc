/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
*/
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.models.content.BaseContent"{

	function setup(){
		super.setup();
		mockSettingsService = getMockBox().createEmptyMock( "contentbox.models.system.SettingService" );
		model.$property( "settingService", "variables", mockSettingsService );
	}
	
	function testcanCacheContent(){
		mockSettings = {
			cb_content_caching 	= false,
			cb_entry_caching 	= false
		};
		mockSettingsService.$( "getAllSettings", mockSettings );
		
		model.$( "getContentType", "page" ).$property( "settings", "variables", mockSettings );
		assertFalse( model.canCacheContent() );

		model.$( "getContentType", "entry" ).$property( "settings", "variables", mockSettings );
		assertFalse( model.canCacheContent() );
		
		mockSettings = {
			cb_content_caching 	= true,
			cb_entry_caching 	= true
		};
		mockSettingsService.$( "getAllSettings", mockSettings );
		
		model.$( "getContentType", "page" ).$property( "settings", "variables", mockSettings );
		assertTrue( model.canCacheContent() );
		model.$( "getContentType", "entry" ).$property( "settings", "variables", mockSettings );
		assertTrue( model.canCacheContent() );
		
		// override to false
		model.setCache( false );
		model.$( "getContentType", "page" ).$property( "settings", "variables", mockSettings );
		assertFalse( model.canCacheContent() );
		model.$( "getContentType", "entry" ).$property( "settings", "variables", mockSettings );
		assertFalse( model.canCacheContent() );
	} 
	
	function testAddExpiredTime(){
		// Test 1: empty
		model.setExpireDate( '' );
		model.addExpiredTime( "11", "00" );
		assertEquals( '', model.getExpireDate() );
		
		// Test 2: Valid
		cDate = dateFormat( now(), "mm/dd/yyyy" );
		model.setExpireDate( cDate );
		model.addExpiredTime( "11", "00" );
		assertEquals( cDate & ' ' & timeFormat( "11:00", "hh:MM tt" ), model.getExpireDate() );
	}
	
	function testaddPublishedTime(){
		// Test 1: empty
		model.setPublishedDate( '' );
		model.addPublishedTime( "11", "00" );
		assertEquals( '', model.getPublishedDate() );
		
		// Test 2: Valid
		cDate = dateFormat(now(), "mm/dd/yyyy" );
		model.setPublishedDate( cDate );
		model.addPublishedTime( "11", "00" );
		assertEquals( cDate & ' ' & timeFormat( "11:00", "hh:MM tt" ), model.getPublishedDate() );
	}
	
} 