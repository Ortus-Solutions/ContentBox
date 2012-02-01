/**
* All tests are performed with the sample data case
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