/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){
		describe( "Settings Services", function(){
			beforeEach( function( currentSpec ){
				model = prepareMock( getInstance( "SettingService@contentbox" ) );
				cache = model.getSettingsCacheProvider();
			} );

			it( "can flush settings", function(){
				model.storeSettings( { global : {}, sites : {} } );
				expect( model.getAllSettings() ).toBeEmpty();
				model.flushSettingsCache();
				expect( model.getAllSettings() ).notToBeEmpty();
			} );

			it( "can get all settings", function(){
				var r = model.getAllSettings();
				expect( r ).toBeStruct().notToBeEmpty();
			} );
		} );
	}

}
