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

		// Zip up the test package

		// Path to the test package
		testPackage = "";
	}

	function run( testResults, testBox ){

		describe( "ContentBox Importer Service", function(){

			it( "can be created", function(){
				expect( contentboxImporter ).toBeComponent();
			});

			story( "I want to prepare a .cbox packages for import via the setup() method", function(){

				given( "a valid .cbox package", function(){
					then( "it will prepare the import correctly", function(){
						//fail( "not there yet" );
					});
				});

				given( "an invalid .cbox package", function(){
					then( "it will throw a '' exception", function(){

					});
				});


			});

		} );
	}

}
