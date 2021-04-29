/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){
		describe( "Editor Services", function(){
			beforeEach( function( currentSpec ){
				model = getInstance( "EditorService@cb" );
			} );

			it( "can get registered editors", function(){
				model.getEditors()[ "test" ] = this;
				model.getEditors()[ "Awesome" ] = this;
				var a = model.getRegisteredEditors();

				expect( a )
					.toInclude( "Awesome" )
					.toInclude( "ckeditor" )
					.toInclude( "test" );
				debug( a );
			} );

			it( "can register a new editor", function(){
				var editor = prepareMock( new MockEditor() );
				model.registerEditor( editor );
				assertEquals( editor, model.getEditor( "mock-editor" ) );
			} );

			it( "can unregister editors", function(){
				var editor = prepareMock( new MockEditor() );
				model.registerEditor( editor ).unRegisterEditor( "mock-editor" );
				assertFalse( structKeyExists( model.getEditors(), "mock-editor" ) );
			} );
		} );
	}

}
