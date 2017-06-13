/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
*/
component extends="coldbox.system.testing.BaseTestCase"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		super.beforeAll();
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
		super.afterAll();
	}

/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){

		// all your suites go here.
		describe( "Comment Service", function(){

			beforeEach(function( currentSpec ){
				commentService = getModel( "CommentService@cb" );
			});

			it( "can get approved comment count", function(){
				var r = commentService.getApprovedCommentCount();
				expect(	r ).toBeGT( 0 );
			});

			it( "can get unapproved comment count", function(){
				var r = commentService.getUnApprovedCommentCount();
				expect(	r ).toBeGT( 0 );
			});

			describe( "Approved Comment Finders", function(){
				it( "cand find all", function(){
					var r = commentService.findApprovedComments();
					expect(	r.count ).toBeGT( 0 );
				});
				it( "can find by content ID", function(){
					var r = commentService.findApprovedComments( contentID=0 );
					expect(	r.count ).toBe( 0 );
					
					var r = commentService.findApprovedComments( contentID=142 );
					expect(	r.count ).toBeGT( 0 );
				});
				it( "can find by content types", function(){
					var r = commentService.findApprovedComments(contentType="invalid");
					expect(	r.count ).toBe( 0 );
					
					var r = commentService.findApprovedComments(contentType="Entry");
					expect(	r.count ).toBeGT( 0 );
				});
			});

			it( "can do comment searching by parameters", function(){
				// test get all
				var r = commentService.search();
				expect(	r.count ).toBeGT( 0 );
				
				// test any approved
				var r = commentService.search( isApproved="any" );
				expect(	r.count ).toBeGT( 0 );
				
				var r = commentService.search( isApproved=false );
				expect(	r.count ).toBe( 1 );
				
				var r = commentService.search( contentID=142);
				expect(	r.count ).toBeGT( 0 );
				
				// disjunction with content
				var r = commentService.search( contentID=142, search="awesome" );
				expect(	r.count ).toBeGTE( 1 );
				// disjunction with author
				var r = commentService.search( contentID=142, search="Pio" );
				expect(	r.count ).toBeGTE( 1 );
				// disjunction with authorEmail
				var r = commentService.search( contentID=142, search="Test" );
				expect(	r.count ).toBeGTE( 1 );
			});
			


		});
	}
	
}