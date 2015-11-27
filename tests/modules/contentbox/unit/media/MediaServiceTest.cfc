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
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.media.MediaService"{

	function setup(){
		super.setup();
		mockProvider = getMockBox().createMock("contentbox.model.media.CFContentMediaProvider").init();
		mockWireBox.$("getInstance", mockProvider );
		model.init(mockWireBox);
		mockSettings = getMockBox().createEmptyMock("contentbox.model.system.SettingService").$("getSetting","CFContentMediaProvider");
		model.$property("settingService","variables",mockSettings);
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
		model.registerProvider(mockProvider);
		//not sure what to asset here?
	}

	function testUnRegisterProvider() {
		model.unRegisterProvider(mockProvider);
		//not sure what to asset here?
	}

	function testGetRegisteredProviders() {
		var providers = model.getRegisteredProviders();
		assertTrue( arrayFind(providers,"CFContentMediaProvider") );
	}

	function testGetRegisteredProvidersMap() {
		var providerPath = model.getRegisteredProvidersMap();
		assertIsArray( providerPath );
		assertIsStruct( providerPath[1] );
	}

	function testGetCoreMediaRoot() {
		mockSettings = getMockBox().createEmptyMock("contentbox.model.system.SettingService").$("getSetting","/content");
		model.$property("settingService","variables",mockSettings);
		var path = model.getCoreMediaRoot();
		assertEquals("/content",path);
	}

}