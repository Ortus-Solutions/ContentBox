/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

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
		describe( "Base Content", function(){
			beforeEach( function( currentSpec ){
				model = getInstance( "BaseContent@contentbox" );
			} );

			it( "can add expired data time combinations", function(){
				// Test 1: empty
				model.setExpireDate( "" );
				model.addExpiredTime( "11", "00" );
				expect( model.getExpireDate() ).toBe( "" );

				// Test 2: Valid
				var cDate = dateFormat( now(), "mm/dd/yyyy" );
				model.setExpireDate( cDate );
				model.addExpiredTime( "11", "00" );
				expect( model.getExpireDate() ).toBe(
					cDate & " " & timeFormat( "11:00", "hh:MM tt" )
				);
			} );

			it( "can add published date time combinations", function(){
				// Test 1: empty
				model.setPublishedDate( "" );
				model.addPublishedTime( "11", "00" );
				expect( model.getPublishedDate() ).toBe( "" );

				// Test 2: Valid
				var cDate = dateFormat( now(), "mm/dd/yyyy" );
				model.setPublishedDate( cDate );
				model.addPublishedTime( "11", "00" );
				expect( model.getPublishedDate() ).toBe(
					cDate & " " & timeFormat( "11:00", "hh:MM tt" )
				);
			} );
		} );
	}

}
