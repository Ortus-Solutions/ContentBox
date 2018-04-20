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
		describe( "Settings Services", function(){
			beforeEach(function( currentSpec ){
				model = prepareMock( getInstance( "SettingService@cb" ) );
				cache = model.getSettingsCacheProvider();
			});

			it( "can flush settings", function(){
				model.storeSettings( {} );
				expect( model.getAllSettings() ).toBeEmpty();
				model.flushSettingsCache();
				expect( model.getAllSettings() ).notToBeEmpty();
			});

			it( "can get all settings", function(){
				var r = model.getAllSettings( asStruct=true );
				expect(	r ).toBeStruct()
					.notToBeEmpty();
			});
		});
	}

}