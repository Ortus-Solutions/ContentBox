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

		describe( "Module Services", function(){
			beforeEach(function( currentSpec ){
				model = getInstance( "ModuleService@cb" );
			});

			it( "can populate a module", function(){
				var module = entityNew("cbModule");
				var mock = getMockBox().createStub();
				mock.title = mock.description = mock.author = mock.webURL = mock.forgeboxslug = mock.entryPoint = "unit";
				mock.version = "1.0.0";

				model.populateModule( module, mock );
				expect(	module.getVersion() ).toBe( "1.0.0" );
				expect(	module.getAuthor() ).toBe( "unit" );
			});

			it( "can find modules", function(){
				var r = model.findModules();
				expect(	r.count ).toBe( 1 );
			});

		});

	}

}