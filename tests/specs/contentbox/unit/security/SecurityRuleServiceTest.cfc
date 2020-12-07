/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
*/
component extends="tests.resources.BaseTest"{


	function run( testResults, testBox ){
		describe( "Security Rule Services", function(){
			beforeEach( function( currentSpec ){
				model = prepareMock( getInstance( "SecurityRuleService@cb" ) );
			});

			it( "can get max orders", function(){
				var t = model.getMaxOrder();
				expect(	t ).toBeNumeric();
				expect(	t + 1 ).toBe( model.getNextMaxOrder() );
			});

			it( "can save rules", function(){
				var t = prepareMock( entityNew( "cbSecurityRule" ) );
				model.$( "save" ).$( "getNextMaxOrder", 99 );
				model.saveRule( t );
				expect(	t.getOrder() ).toBe( 99 );

				t.$property( "ruleID", "variables", 40 );
				t.setOrder( 40 );
				model.saveRule( t );
				expect(	t.getOrder() ).toBe( 40 );
			});

		});
	}

}