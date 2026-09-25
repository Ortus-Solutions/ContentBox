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
			"CKEditor",
			() => {
				beforeEach(
					( currentSpec ) => {
						model = prepareMock( getInstance( "CKEditor@contentbox-ckeditor" ) );
						prc = getRequestContext().getPrivateCollection();
						prc.cbAdminEntryPoint = "/cbadmin";
					}
				);

				it(
					"can compileJS",
					() => {
						makePublic( model, "compileJS" );
						var t = model.compileJS(
								{
									toolbar       : { "unit": "true" },
									excerptToolbar: { "excerptTest": "true" }
								},
								{ extraPlugins: listToArray( model.getExtraPlugins() ) },
								{ extraConfig: "extraconfig = 'true'" },
								{ contentsCss: [ "/unit/css"] }
							);

						expect( t ).notToBeEmpty();
						expect( t )
							.toInclude( "extraconfig" )
							.toInclude( "unit/css" )
							.toInclude( """unit"":" )
							.toInclude( """excerptTest"":" );
					}
				);
			}
		);
	}

}