/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
*/
component extends="tests.resources.BaseTest"{

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
		describe( "Categories", function(){

			beforeEach(function( currentSpec ){
				model = getInstance( "categoryService@cb" ).new( {
					category 	= "unittest",
					slug 		= "unittest"
				} );
			});

			it( "can produce a memento", function(){
				var memento = model.getMemento();
				expect(	memento ).tobeStruct()
					.toHaveKey( "categoryID" )
					.toHaveKey( "category" )
					.toHaveKey( "slug" );
			});

			it( "can get published pages count", function(){
				var populatedCategory = getInstance( "categoryService@cb" ).findBySlug( "coldbox" );
				var count = populatedCategory.getNumberOfPublishedPages();
				expect(	count ).toBeGTE( 1 );
			});

			it( "can get published entries count", function(){
				var populatedCategory = getInstance( "categoryService@cb" ).findBySlug( "coldfusion" );
				var count = populatedCategory.getNumberOfPublishedEntries();
				expect(	count ).toBeGTE( 1 );
			});

			it( "can get published content store count", function(){
				var populatedCategory = getInstance( "categoryService@cb" ).findBySlug( "coldfusion" );
				var count = populatedCategory.getNumberOfPublishedContentStore();
				expect(	count ).toBeGTE( 1 );
			});

		} );
	}
}