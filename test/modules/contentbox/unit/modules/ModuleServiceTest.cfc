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
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.modules.ModuleService"{

	function setup(){
		super.setup();
		model.init();
	}

	function testPopulateModule(){
		module = entityNew("cbModule");
		mock = getMockBox().createStub();
		mock.title = mock.description = mock.author = mock.webURL = mock.forgeboxslug = mock.entryPoint = "unit";
		mock.version = "1.0.0";

		model.populateModule( module, mock );
		assertEquals( "1.0.0", module.getVersion() );
		assertEquals( "unit", module.getAuthor() );
	}

	function testFindModules(){
		r = model.findModules();
		assertTrue( isStruct(r) );
	}

}