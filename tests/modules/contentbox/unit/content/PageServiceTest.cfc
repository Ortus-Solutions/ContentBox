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
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.content.PageService"{

	function setup(){
		super.setup();
		model.init(eventHandling=false);
	}
		
	function testGetIDBySlug(){
		r = model.getIDBySlug('bogus');
		assertEquals( '', r );
		
		r = model.getIDBySlug('about');
		assertTrue( len(r) );
	}
	
	function testSearch(){
		
		r = model.search();
		assertTrue( r.count gt 0 );
		
		r = model.search(isPublished=false);
		assertTrue( r.count eq 0 );
		r = model.search(isPublished=true);
		assertTrue( r.count gt 0 );
		
		var pages = entityLoad("cbPage");
		var authorID = pages[1].getAuthor().getAuthorID();
		r = model.search(author=authorID);
		assertTrue( r.count gt 0 );
		
		// search
		r = model.search(search="about");
		assertTrue( r.count gt 0 );
		
		// parent
		r = model.search(parent='');
		assertTrue( r.count gt 0 );
		r = model.search(parent='1');
		assertTrue( r.count eq 0 );
		
	}
	
	function testfindPublishedPages(){
		r = model.findPublishedPages();
		assertTrue( r.count gt 0 );
		
		// search
		r = model.findPublishedPages(searchTerm="about");
		assertTrue( r.count gt 0 );
		
		// parent
		r = model.findPublishedPages(parent='');
		assertTrue( r.count gt 0 );
		r = model.findPublishedPages(parent='1');
		assertTrue( r.count eq 0 );
		
		// search
		r = model.findPublishedPages(showInMenu=true);
		assertTrue( r.count gt 0 );
		
	}
	
	function testFindBySlug(){
		model.$("new", entityNew("cbPage") );
		r = model.findBySlug("bogus");
		assertFalse( r.isLoaded() );
		
		r = model.findBySlug("about");
		assertTrue( r.isLoaded() );		
	}
	

} 