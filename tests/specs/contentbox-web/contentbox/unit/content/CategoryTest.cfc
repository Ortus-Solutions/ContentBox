/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends ="tests.resources.BaseTest" autowire="true" {
	property name="categoryService" inject="categoryService@contentbox";

	function run( testResults, testBox ) {
		describe(
			"Categories",
			() => {
				beforeEach(
					( currentSpec ) => {
						model = categoryService.new( { category: "unittest", slug: "unittest" } );
					}
				);

				it(
					"can produce a memento",
					() => {
						var memento = model.getMemento();
						expect( memento )
							.tobeStruct()
							.toHaveKey( "categoryID" )
							.toHaveKey( "category" )
							.toHaveKey( "slug" );
					}
				);

				it(
					"can get published pages count",
					() => {
						var thisCategory = categoryService.findBySlug( "coldbox" );
						var count = thisCategory.getNumberOfPublishedPages();
						expect( count ).toBeGTE( 1 );
					}
				);

				it(
					"can get published entries count",
					() => {
						var thisCategory = categoryService.findBySlug( "coldfusion" );
						var count = thisCategory.getNumberOfPublishedEntries();
						expect( count ).toBeGTE( 1 );
					}
				);

				it(
					"can get published content store count",
					() => {
						var thisCategory = categoryService.findBySlug( "coldfusion" );
						var count = thisCategory.getNumberOfPublishedContentStore();
						expect( count ).toBeGTE( 1 );
					}
				);
			}
		);
	}

}