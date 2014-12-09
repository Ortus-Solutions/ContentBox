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
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.search.DBSearch"{

	function setup(){
		super.setup();
		model.init();
		mockContentService = getMockBox().createEmptyMock("contentbox.model.content.ContentService");
		mockCBHelper = getMockBox().createEmptyMock("contentbox.plugins.CBHelper");
		model.$property("wirebox","variables", mockWireBox);
		model.$property("contentService","variables", mockContentService);
		model.$property("cb","variables", mockCBHelper);
	}
		
	function testSearch(){
		mockResults = getMockBox().createMock("contentbox.model.search.SearchResults").init();
		mockWireBox.$("getInstance", mockResults );
		r = model.search(searchTerm='luis');
		assertTrue( r.getError() );
		
		// with results
		results = {
			content = entityLoad("cbContent"),
			count = 5
		};
		mockResults = getMockBox().createMock("contentbox.model.search.SearchResults").init();
		mockWireBox.$("getInstance", mockResults );
		mockContentService.$("searchContent", results );
		r = model.search(searchTerm='luis');
		debug( r.getMemento() );
		assertFalse( r.getError() );
		assertEquals("luis", r.getSearchTerm() );
	}
	
	function testRenderSearchWithResults(){
		var entity = getMockBox().prepareMock( entityLoad("cbContent")[1] );
		entity.$("renderContent","search content");
		// with results
		results = {
			results = [entity],
			total = 1,
			searchTerm = "content"
		};
		mockResults = getMockBox().createMock("contentbox.model.search.SearchResults").init().populate( results );
		
		mockCBHelper.$("linkContent","http://contentbox.com/content/1");
		r = model.renderSearchWithResults( mockResults );
		debug( r );
		assertTrue( findNoCase("<span class='highlight'>content</span>", r) );
	}
	
	function testRenderSearch(){
		mockResults = getMockBox().createMock("contentbox.model.search.SearchResults").init();
		model.$(method="search",returns=mockResults,preserveReturnType=false)
			.$("renderSearchWithResults", "test");
		
		r = model.renderSearch(searchTerm="luis");
		assertEquals( "test", r);
	}

} 