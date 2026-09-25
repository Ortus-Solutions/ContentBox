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
			"Theme Services",
			() => {
				beforeEach(
					( currentSpec ) => {
						setup();
						cbHelper = getInstance( "CBHelper@contentbox" );
						model = getInstance( "ThemeService@contentbox" );
					}
				);

				it(
					"can build the theme registry",
					() => {
						expect( model.getThemeRegistry() ).notToBeEmpty();
						expect( model.getCoreThemesPath() ).notToBeEmpty();
						expect( model.getCustomThemesPath() ).notToBeEmpty();
						expect( model.getCBHelper() ).toBeComponent();
					}
				);

				xit(
					"can find maintenance view",
					() => {
						var prc = getRequestContext().getPrivateCollection();
						prc.cbThemeRoot = "/";
						expect( model.themeMaintenanceViewExists() ).toBeFalse();

						// No
						prc.cbThemeRoot = "/modules/contentbox/themes/default";
						expect( model.themeMaintenanceViewExists() ).toBeTrue();
					}
				);

				xit(
					"can find the maintenance layout",
					() => {
						var prc = getRequestContext().getPrivateCollection();
						prc.cbThemeRoot = "/";
						expect( model.getThemeMaintenanceLayout() ).toBe( "pages" );

						// No
						prc.cbThemeRoot = "/modules/contentbox/themes/default";
						expect( model.getThemeMaintenanceLayout() ).toBe( "maintenance" );
					}
				);

				xit(
					"can find the search layout",
					() => {
						var prc = getRequestContext().getPrivateCollection();
						prc.cbThemeRoot = "/";
						expect( model.getThemeSearchLayout() ).toBe( "pages" );

						// No
						prc.cbThemeRoot = "/modules/contentbox/themes/default";
						expect( model.getThemeSearchLayout() ).toBe( "search" );
					}
				);
			}
		);
	}

}