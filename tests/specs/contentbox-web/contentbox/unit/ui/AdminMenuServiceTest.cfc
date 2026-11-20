/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ) {
		describe(
			"Admin Menu Services",
			() => {
				beforeEach(
					( currentSpec ) => {
						model = prepareMock( getInstance( "AdminMenuService@contentbox" ) );
						prc = getRequestContext().getPrivateCollection();
						prc.oCurrentAuthor = prepareMock( entityNew( "cbAuthor" ) ).$( "hasPermission", true );
					}
				);

				it(
					"can generate the menu",
					() => {
						var r = model.generateMenu();
						expect( r ).notToBeEmpty();
					}
				);

				it(
					"should ignore the removal of non-existent top menu items without throwing exceptions ",
					() => {
						model.removeTopMenu( "invalid" );
					}
				);

				it(
					"should ignore the removal of non-existent header menu items without throwing exceptions ",
					() => {
						model.removeHeaderMenu( "invalid" );
					}
				);

				it(
					"should ignore the removal of non-existent header sub menu items without throwing exceptions ",
					() => {
						model.removeHeaderSubMenu( "invalid", "bogus" );
					}
				);

				it(
					"should ignore the removal of non-existent sub menu items without throwing exceptions ",
					() => {
						model.removeSubMenu( "invalid", "bogus" );
					}
				);
			}
		);
	}

}