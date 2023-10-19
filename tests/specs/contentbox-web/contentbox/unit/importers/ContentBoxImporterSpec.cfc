/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	function beforeAll(){
		super.beforeAll();

		setup();
		contentboxImporter = getInstance( "ContentBoxImporter@contentbox" );
	}

	function run( testResults, testBox ){
		describe( "ContentBox Importer Service", function(){
			it( "can be created", function(){
				expect( contentboxImporter ).toBeComponent();
			} );

			it( "can import settings", function(){
				withRollback( () => {
					var importData = deserializeJSON( fileRead( expandPath( "/tests/resources/exports/setting.json" ) ) );
					var importLog =	createObject( "java", "java.lang.StringBuilder" ).init(
						""
					);

					var output = getInstance( "settingService@contentbox" ).importFromData(
						importData : importData,
						override : false,
						importLog : importLog
					);

					expect( output ).notToBeEmpty();
					expect( output ).toInclude( "No settings imported as none where found or able to be overriden from the import file." );
				})
			});

		} );
	}

}
