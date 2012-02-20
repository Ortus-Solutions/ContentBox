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
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.search.SearchService"{

	function setup(){
		super.setup();
		model.init();
	}
		
	function testGetSearchAdapter(){
		mockAdapter = getMockBox().createEmptyMock("contentbox.model.search.DBSearch");
		mockWireBox.$("getInstance", mockAdapter );
		mockSettings = getMockBox().createEmptyMock("contentbox.model.system.SettingService").$("getSetting","contentbox.model.search.DBSearch");
		model.$property("wirebox","variables",mockWireBox);
		model.$property("settingService","variables",mockSettings);
		
		a = model.getSearchAdapter();
		assertEquals( mockAdapter, a );
	}

} 