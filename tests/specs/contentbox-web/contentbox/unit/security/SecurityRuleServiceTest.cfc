/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	function run( testResults, testBox ) {
		describe(
			"Security Rule Services",
			() => {
				beforeEach(
					( currentSpec ) => {
						model = prepareMock( getInstance( "SecurityRuleService@contentbox" ) );
					}
				);

				it(
					"can get max orders",
					() => {
						var t = model.getMaxOrder();
						expect( t ).toBeNumeric();
						expect( t + 1 ).toBe( model.getNextMaxOrder() );
					}
				);

				it(
					"can save rules",
					() => {
						var t = prepareMock( entityNew( "cbSecurityRule" ) );
						model.$( "save" ).$( "getNextMaxOrder", 99 );
						model.saveRule( t );
						expect( t.getOrder() ).toBe( 99 );

						t.$property(
								"ruleID",
								"variables",
								40
							);
						t.setOrder( 40 );
						model.saveRule( t );
						expect( t.getOrder() ).toBe( 40 );
					}
				);
			}
		);
	}

}