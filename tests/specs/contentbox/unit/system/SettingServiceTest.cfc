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
		describe( "Settings Services", function(){
			beforeEach(function( currentSpec ){
				mockCache = createEmptyMock( "coldbox.system.cache.providers.CacheBoxColdBoxProvider" );
				model = prepareMock( getInstance( "SettingService@cb" ) );
				model.$( "getSettingsCacheProvider", mockCache );
			});

			it( "can flush settings", function(){
				mockCache.$( "clear" );
				model.flushSettingsCache();
				expect(	mockCache.$once( "clear" ) ).toBeTrue();
			});

			it( "can get all settings", function(){
				mockCache.$( "get", { mysetting=true } );
				var r = model.getAllSettings( asStruct=true );
				expect(	r ).toBeStruct()
					.notToBeEmpty();
			});
		});
	}

}