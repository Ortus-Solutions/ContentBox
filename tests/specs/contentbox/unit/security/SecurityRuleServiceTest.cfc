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
		describe( "Security Rule Services", function(){
			beforeEach(function( currentSpec ){
				model = prepareMock( getInstance( "SecurityRuleService@cb" ) );
			});

			it( "can get max orders", function(){
				var t = model.getMaxOrder();
				expect(	t ).toBeNumeric();
				expect(	t+1 ).toBe( model.getNextMaxOrder() );
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

			it( "can get security rules", function(){
				var rule = model.new( 
					properties={
						whitelist	= "",
						securelist	= "firstRule",
						roles		= "",
						permissions	= "ADMIN",
						redirect	= "cbadmin/login",
						useSSL		= false,
						order		= 0,
						match		= "event"
					}
				);

				try{
					model.$( "save" ).$( "delete" );

					model.save( rule );
					var rule = model.new(
						properties={
							whitelist	= "",
							securelist	= "secondRule",
							roles		= "",
							permissions	= "ADMIN",
							redirect	= "cbadmin/login",
							useSSL		= false,
							order		= 1,
							match		= "event"}
						);
					model.save( rule );
					var r = model.getSecurityRules();
					
					lastOrder = r.order[ 1 ];
					for(var x=2; x lte r.recordcount; x++){
						expect(	lastOrder ).toBeLTE( r.order[ x ] );
						lastOrder = r.order[ x ];
					}
				} catch( Any e ){
					rethrow;
				} finally {
					model.delete( rule );
				}
				
			});

		});
	}

}