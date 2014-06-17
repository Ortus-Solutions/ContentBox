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
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.content.EntryService"{

	function setup(){
		super.setup();
		model.init(eventHandling=false);
		
		model.$property("HQLHelper","variables", new modules.contentbox.model.util.HQLHelper() );
	}
	
	function testgetArchivesReport(){
		r = model.getArchiveReport();
		assertTrue( arrayLen( r ) );
	}
	
	function testGetIDBySlug(){
		r = model.getIDBySlug('bogus');
		debug( r );
		assertEquals( '', r );
		
		r = model.getIDBySlug('my-first-entry');
		debug( r );
		assertEquals( 1, r );
	}
	
	function testSearch(){
		
		r = model.search();
		assertTrue( r.count gt 0 );
		
		r = model.search(isPublished=false);
		assertTrue( r.count eq 0 );
		r = model.search(isPublished=true);
		assertTrue( r.count gt 0 );
		
		var entries = entityLoad("cbEntry");
		var authorID = entries[1].getAuthor().getAuthorID();
		r = model.search(author=authorID);
		assertTrue( r.count gt 0 );
		
		// search
		r = model.search(search="everybody");
		assertTrue( r.count gt 0 );
		
		// no categories
		r = model.search(category="none");
		assertTrue( r.count gt 0 );
		
		// no categories
		r = model.search(category="1");
		assertTrue( r.count eq 0 );
		
	}
	
	function testFindPublishedEntriesByDate(){
		var entry = entityLoad("cbEntry")[1];
		
		// nothing
		r = model.findPublishedEntriesByDate(year=2000);
		assertFalse( arrayLen(r.entries) );
		assertEquals(0, r.count );
		
		// year
		r = model.findPublishedEntriesByDate(year=dateformat( entry.getCreatedDate(), "yyyy"));
		assertTrue( arrayLen(r.entries) eq 1 );
		
		// year + Month
		r = model.findPublishedEntriesByDate(year=dateformat( entry.getCreatedDate(), "yyyy"),month=dateFormat(entry.getCreatedDate(), "mm") );
		assertTrue( arrayLen(r.entries) eq 1 );
		
		// year + Month + day
		r = model.findPublishedEntriesByDate(year=dateformat( entry.getCreatedDate(), "yyyy"),
											 month=dateFormat(entry.getCreatedDate(), "mm"),
											 day=dateFormat(entry.getCreatedDate(), "dd") );
		assertTrue( arrayLen(r.entries) eq 1 );
	}
	
	function testfindPublishedEntries(){
		r = model.findPublishedEntries();
		assertTrue( r.count gt 0 );
		
		// categories
		r = model.findPublishedEntries(category="software");
		assertTrue( r.count eq 0 );
		
		// search
		r = model.findPublishedEntries(search="first");
		assertTrue( r.count gt 0 );
		
	}
	
	function testFindBySlug(){
		model.$("new", entityNew("cbEntry") );
		r = model.findBySlug("bogus");
		assertFalse( r.isLoaded() );
		
		r = model.findBySlug("my-first-entry");
		assertTrue( r.isLoaded() );		
	}
	

} 