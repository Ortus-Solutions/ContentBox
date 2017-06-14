/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
*/
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.models.media.MediaService"{

	function setup(){
		super.setup();
		mockProvider = getMockBox().createMock( "contentbox.models.media.CFContentMediaProvider" ).init();
		mockWireBox.$( "getInstance", mockProvider );

		model.init( mockWireBox );
		mockSettings = getMockBox().createEmptyMock( "contentbox.models.system.SettingService" )
			.$( "getSetting", "CFContentMediaProvider" );
		model.$property( "settingService", "variables", mockSettings );
	}

	function testGetProvider(){
		var provider = model.getProvider( "CFContentMediaProvider" );
		assertEquals( "CFContentMediaProvider", provider.getName() );
		assertEquals( "CF Content Media Provider", provider.getDisplayName() );
	}

	function testGetDefaultProviderName(){
		assertEquals( "CFContentMediaProvider", model.getDefaultProviderName() );
	}


	function testGetDefaultProvider() {
		var provider = model.getDefaultProvider();
		assertEquals( "CFContentMediaProvider", provider.getName() );
		assertEquals( "CF Content Media Provider", provider.getDisplayName() );
	}

	function testRegisterProvider() {
		model.setProviders( {} );
		model.registerProvider( mockProvider );
		expect(	model.getDefaultProviderName() ).toBe( "CFContentMediaProvider" );
	}

	function testUnRegisterProvider() {
		model.setProviders( {} );
		model.registerProvider( mockProvider );
		model.unRegisterProvider( "CFContentMediaProvider" );
		expect(	model.getProviders() ).toHaveLength( 0 );
	}

	function testGetRegisteredProviders() {
		var providers = model.getRegisteredProviders();
		assertTrue( arrayFind(providers,"CFContentMediaProvider" ) );
	}

	function testGetRegisteredProvidersMap() {
		var providerPath = model.getRegisteredProvidersMap();
		assertIsArray( providerPath );
		assertIsStruct( providerPath[1] );
	}

	function testGetCoreMediaRoot() {
		mockSettings = getMockBox().createEmptyMock( "contentbox.models.system.SettingService" )
			.$( "getSetting", "/content" );
		model.$property( "settingService", "variables", mockSettings );
		var path = model.getCoreMediaRoot();
		assertEquals( "/content",path);
	}
}