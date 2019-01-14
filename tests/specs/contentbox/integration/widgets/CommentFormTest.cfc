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
			widgetService 	= getInstance( "widgetService@cb" );
			cbHelper 		= getInstance( "CBHelper@cb" );

			cbHelper.prepareUIRequest();
		}

		// executes after all suites+specs in the run() method
		function afterAll(){
			super.afterAll();
		}

	/*********************************** BDD SUITES ***********************************/

		function run( testResults, testBox ){
			describe( "Comment Form Widget", function(){

				beforeEach(function( currentSpec ){
					widget = widgetService.getWidget( "CommentForm" );
				});

				it( "can render a form with no content object passed", function(){
					var r = widget.renderIt( '' );
					expect( r.len() ).toBeGT( 0 );
				});

				it( "can render a form with an invalid slug", function(){
					var r = widget.renderIt( 'bogus' );
					expect( r ).toInclude( "bogus was not found, cannot generate comment form" );
				});

				it( "can render a form with an valid slug", function(){
					var r = widget.renderIt( 'support' );
					expect( r ).toInclude( "<form action=" );
				});

			} );
		}
	}