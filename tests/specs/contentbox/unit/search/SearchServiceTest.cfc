/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
*/
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.models.search.SearchService"{

	function setup(){
		super.setup();
		model.init();
	}

	function testGetSearchAdapter(){
		mockAdapter = getMockBox().createEmptyMock( "contentbox.models.search.DBSearch" );
		mockWireBox.$( "getInstance", mockAdapter );
		mockSettings = getMockBox().createEmptyMock( "contentbox.models.system.SettingService" ).$( "getSetting","contentbox.models.search.DBSearch" );
		model.$property( "wirebox","variables",mockWireBox);
		model.$property( "settingService","variables",mockSettings);

		a = model.getSearchAdapter();
		assertEquals( mockAdapter, a );
	}

}