/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	property name="categoryService" inject="categoryService@contentbox";

	function run( testResults, testBox ){
		describe( "Categories", function(){
			beforeEach( function( currentSpec ){
				model = categoryService.new( { category : "unittest", slug : "unittest" } );
			} );

			it( "can produce a memento", function(){
				var memento = model.getMemento();
				expect( memento )
					.tobeStruct()
					.toHaveKey( "categoryID" )
					.toHaveKey( "category" )
					.toHaveKey( "slug" );
			} );

			it( "can get published pages count", function(){
				var thisCategory = categoryService.findBySlug( "coldbox" );
				var count        = thisCategory.getNumberOfPublishedPages();
				expect( count ).toBeGTE( 1 );
			} );

			it( "can get published entries count", function(){
				var thisCategory = categoryService.findBySlug( "coldfusion" );
				var count        = thisCategory.getNumberOfPublishedEntries();
				expect( count ).toBeGTE( 1 );
			} );

			it( "can get published content store count", function(){
				var thisCategory = categoryService.findBySlug( "coldfusion" );
				var count        = thisCategory.getNumberOfPublishedContentStore();
				expect( count ).toBeGTE( 1 );
			} );
		} );
	}

}
