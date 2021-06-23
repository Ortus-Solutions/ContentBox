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

		widgetService = getInstance( "widgetService@cb" );
	}

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){
		describe( "Content Store Widget", function(){
			beforeEach( function( currentSpec ){
				widget = widgetService.getWidget( "ContentStore" );
			} );

			it( "can get valid content store items", function(){
				var r = widget.renderIt( "foot" );
				expect( r.len() ).toBeGT( 0 );
			} );

			it( "can get invalid content store items with an exception", function(){
				expect( function(){
					widget.renderIt( "invalid" );
				} ).toThrow();
			} );

			it( "can get invalid content with a default value", function(){
				var r = widget.renderIt( "invalid", "" );
				expect( r ).toBe( "" );
			} );

			it( "can get expired content with a default value of empty", function(){
				var r = widget.renderIt( "my-expired-content-store" );
				expect( r ).toBe( "" );
			} );
		} );
	}

}
