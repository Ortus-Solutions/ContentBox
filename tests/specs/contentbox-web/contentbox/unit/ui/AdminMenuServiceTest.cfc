/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){
		describe( "Admin Menu Services", function(){
			beforeEach( function( currentSpec ){
				model              = prepareMock( getInstance( "AdminMenuService@contentbox" ) );
				prc                = getRequestContext().getPrivateCollection();
				prc.oCurrentAuthor = prepareMock( entityNew( "cbAuthor" ) ).$(
					"checkPermission",
					true
				);
			} );

			it( "can generate the menu", function(){
				var r = model.generateMenu();
				expect( r ).notToBeEmpty();
			} );

			it( "should ignore the removal of non-existent top menu items without throwing exceptions ", function(){
				model.removeTopMenu( "invalid" );
			} );

			it( "should ignore the removal of non-existent header menu items without throwing exceptions ", function(){
				model.removeHeaderMenu( "invalid" );
			} );

			it( "should ignore the removal of non-existent header sub menu items without throwing exceptions ", function(){
				model.removeHeaderSubMenu( "invalid", "bogus" );
			} );

			it( "should ignore the removal of non-existent sub menu items without throwing exceptions ", function(){
				model.removeSubMenu( "invalid", "bogus" );
			} );
		} );
	}

}
