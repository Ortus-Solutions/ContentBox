/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
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
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.content.BaseContent"{

	function setup(){
		super.setup();
		mockSettingsService = getMockBox().createEmptyMock("contentbox.model.system.SettingService");
		model.$property("settingService","variables",mockSettingsService);
	}
	
	function testcanCacheContent(){
		mockSettings = {
			cb_content_caching = false,
			cb_entry_caching = false
		};
		mockSettingsService.$("getAllSettings", mockSettings);
		
		model.$("getContentType","page").$property("settings","variables",mockSettings);
		assertFalse( model.canCacheContent() );
		model.$("getContentType","entry").$property("settings","variables",mockSettings);
		assertFalse( model.canCacheContent() );
		
		mockSettings = {
			cb_content_caching = true,
			cb_entry_caching = true
		};
		mockSettingsService.$("getAllSettings", mockSettings);
		
		model.$("getContentType","page").$property("settings","variables",mockSettings);
		assertTrue( model.canCacheContent() );
		model.$("getContentType","entry").$property("settings","variables",mockSettings);
		assertTrue( model.canCacheContent() );
		
		// override to false
		model.setCache( false );
		model.$("getContentType","page").$property("settings","variables",mockSettings);
		assertFalse( model.canCacheContent() );
		model.$("getContentType","entry").$property("settings","variables",mockSettings);
		assertFalse( model.canCacheContent() );
		
	} 
	
	function testAddExpiredTime(){
		// Test 1: empty
		model.setExpireDate( '' );
		model.addExpiredTime( "11", "00" );
		assertEquals( '', model.getExpireDate() );
		
		// Test 2: Valid
		cDate = dateFormat(now(), "mm/dd/yyyy" );
		model.setExpireDate( cDate );
		model.addExpiredTime( "11", "00" );
		assertEquals( cDate & ' ' & timeFormat( "11:00", "hh:MM:SS tt" ), model.getExpireDate() );
		
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
		assertEquals( cDate & ' ' & timeFormat( "11:00", "hh:MM:SS tt" ), model.getPublishedDate() );
	}
	
	function testbuildContentCacheKey(){
		model.$( 'getContentType', 'unit' );
		model.$( 'getContentID', '1234' );
		key = model.buildContentCacheKey();
		assertEquals( "cb-content-unit-1234", key );
	}
	
} 