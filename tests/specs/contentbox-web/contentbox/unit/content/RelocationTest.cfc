/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends ="tests.resources.BaseTest" autowire="true" {
	property name="relocationService" inject="RelocationService@contentbox";

	property name="siteService" inject="SiteService@contentbox";

	function run( testResults, testBox ) {
		describe(
			"Relocations",
			() => {
				beforeEach(
					( currentSpec ) => {
						model = relocationService.new( { target: "unittest", slug: "unittest" } );
					}
				);

				it(
					"can produce a memento",
					() => {
						var memento = model.getMemento();
						expect( memento )
							.tobeStruct()
							.toHaveKey( "relocationID" )
							.toHaveKey( "target" )
							.toHaveKey( "createdDate" )
							.toHaveKey( "slug" )
							.toHaveKey( "relatedContent" );
					}
				);

				it(
					"will remove leading and trailing slashes from new relocation slugs",
					() => {
						model.setSlug( "/unittest/" );
						expect( model.getSlug() ).toBe( "unittest" );
					}
				);

				it(
					"Can search for a relocation by siteId",
					() => {
						var defaultSite = siteService.findBySlug( "default" );
						var response = relocationService.search( siteID = defaultSite.getSiteId() );
						expect( response ).toHaveKey( "relocations" );
						expect( response.relocations ).toBeArray();
						response.relocations.each(
								( r ) => {
									expect( r.getSite().getSiteID() ).toBe( defaultSite.getSiteId() );
								}
							);
					}
				);

				it(
					"Can search for a relocation by a partial value of the slug",
					() => {
						var defaultSite = siteService.findBySlug( "default" );
						var response = relocationService.search( search = "unittest" );
						expect( response ).toHaveKey( "relocations" );
						expect( response.relocations ).toBeArray();
					}
				);
			}
		);
	}

}