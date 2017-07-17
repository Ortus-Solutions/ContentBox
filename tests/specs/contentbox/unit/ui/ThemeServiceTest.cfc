/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
*/
component extends="tests.resources.BaseTest"{

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
		describe( "Theme Services", function(){
			beforeEach(function( currentSpec ){
				model = prepareMock( getInstance( "ThemeService@cb" ) );
			});

			it( "can build the theme registry", function(){
				model.onDICOmplete();
				var result = model.buildThemeRegistry();
				expect(	result ).notToBeEmpty();
			});

			it( "can find maintenance view", function(){
				setup();
				var prc = getRequestContext().getPrivateCollection();
				prc.cbThemeRoot = "/";
				expect(	model.themeMaintenanceViewExists() ).toBeFalse();
				
				// No
				prc.cbThemeRoot = "/modules/contentbox/themes/default";
				expect(	model.themeMaintenanceViewExists() ).toBeTrue();
			});

			it( "can find the maintenance layout", function(){
				setup();
				var prc = getRequestContext().getPrivateCollection();
				prc.cbThemeRoot = "/";
				expect(	model.getThemeMaintenanceLayout() ).toBe( "pages" );
				
				// No
				prc.cbThemeRoot = "/modules/contentbox/themes/default";
				expect(	model.getThemeMaintenanceLayout() ).toBe( "maintenance" );
			});

			it( "can find the search layout", function(){
				setup();
				var prc = getRequestContext().getPrivateCollection();
				prc.cbThemeRoot = "/";
				expect(	model.getThemeSearchLayout() ).toBe( "pages" );
				
				// No
				prc.cbThemeRoot = "/modules/contentbox/themes/default";
				expect(	model.getThemeSearchLayout() ).toBe( "search" );
			});

		});

	}

}