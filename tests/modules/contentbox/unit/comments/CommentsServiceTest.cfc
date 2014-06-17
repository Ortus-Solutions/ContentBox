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
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.comments.CommentService"{

	function setup(){
		super.setup();
		model.init(eventHandling=false);
	}
	
	function testgetApprovedCommentCount(){
		r = model.getApprovedCommentCount();
		assertTrue( r gt 0 );	
	}
	
	function testgetUnApprovedCommentCount(){
		r = model.getUnApprovedCommentCount();
		assertTrue( r gt 0 );	
	}
	
	function testfindApprovedComments(){
		// get all approved comments for all content
		c = model.findApprovedComments();
		assertTrue( c.count gt 0 );
		
		c = model.findApprovedComments(contentID=0);
		assertTrue( c.count eq 0 );
		
		c = model.findApprovedComments(contentID=1);
		assertTrue( c.count gt 0 );
		
		c = model.findApprovedComments(contentType="invalid");
		assertTrue( c.count eq 0 );
		
		c = model.findApprovedComments(contentType="Entry");
		assertTrue( c.count gt 0 );
	}
	
	function testsearch(){
		// test get all
		r = model.search();
		assertTrue( r.count gt 0 );
		
		// test any approved
		r = model.search(isApproved="any");
		assertTrue( r.count gt 0 );
		
		r = model.search(isApproved=false);
		assertTrue( r.count eq 1 );
		
		r = model.search(contentID=1);
		assertTrue( r.count gt 0 );
		
		// disjunction with content
		r = model.search(contentID=1,search="amazing");
		assertTrue( r.count eq 1 );
		// disjunction with author
		r = model.search(contentID=1,search="Awesome Joe");
		assertTrue( r.count eq 1 );
		// disjunction with authorEmail
		r = model.search(contentID=1,search="awesomejoe");
		assertTrue( r.count eq 1 );
		
		// disjunction with authorEmail
		r = model.search(contentID=1,search="badjoe");
		assertTrue( r.count eq 1 );
	} 
	
} 