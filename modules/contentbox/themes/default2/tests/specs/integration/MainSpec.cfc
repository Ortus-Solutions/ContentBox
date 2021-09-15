﻿/*******************************************************************************
 *	Integration Test as BDD
 *
 *	Extends the integration class: coldbox.system.testing.BaseTestCase
 *
 *	so you can test your ColdBox application headlessly. The 'appMapping' points by default to
 *	the '/root' mapping created in the test folder Application.cfc.  Please note that this
 *	Application.cfc must mimic the real one in your root, including ORM settings if needed.
 *
 *	The 'execute()' method is used to execute a ColdBox event, with the following arguments
 *	* event : the name of the event
 *	* private : if the event is private or not
 *	* prePostExempt : if the event needs to be exempt of pre post interceptors
 *	* eventArguments : The struct of args to pass to the event
 *	* renderResults : Render back the results of the event
 *******************************************************************************/
 component
 extends   ="coldbox.system.testing.BaseTestCase"
 appMapping="/root"
{

 /*********************************** LIFE CYCLE Methods ***********************************/

 function beforeAll() {
	 super.beforeAll();
	 // do your own stuff here
 }

 function afterAll() {
	 // do your own stuff here
	 super.afterAll();
 }

 /*********************************** BDD SUITES ***********************************/

 function run() {
	 describe( "Main Handler", function() {
		 beforeEach( function( currentSpec ) {
			 // Setup as a new ColdBox request, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
			 setup();
		 } );

		 it( "can render the homepage", function() {
			 var event = this.get( "main.index" );
			 expect( event.getValue( name = "welcomemessage", private = true ) ).toBe( "Welcome to ColdBox!" );
		 } );

		 it( "can render some restful data", function() {
			 var event = this.post( "main.data" );

			 debug( event.getHandlerResults() );
			 expect( event.getRenderedContent() ).toBeJSON();
		 } );

		 it( "can do a relocation", function() {
			 var event = execute( event = "main.doSomething" );
			 expect( event.getValue( "relocate_event", "" ) ).toBe( "main.index" );
		 } );

		 it( "can startup executable code", function() {
			 var event = execute( "main.onAppInit" );
		 } );

		 it( "can handle exceptions", function() {
			 // You need to create an exception bean first and place it on the request context FIRST as a setup.
			 var exceptionBean = createMock( "coldbox.system.web.context.ExceptionBean" ).init(
				 erroStruct   = structNew(),
				 extramessage = "My unit test exception",
				 extraInfo    = "Any extra info, simple or complex"
			 );
			 prepareMock( getRequestContext() ).setValue(
					 name    = "exception",
					 value   = exceptionBean,
					 private = true
				 )
				 .$( "setHTTPHeader" );

			 // TEST EVENT EXECUTION
			 var event = execute( "main.onException" );
		 } );

		 describe( "Request Events", function() {
			 it( "fires on start", function() {
				 var event = execute( "main.onRequestStart" );
			 } );

			 it( "fires on end", function() {
				 var event = execute( "main.onRequestEnd" );
			 } );
		 } );

		 describe( "Session Events", function() {
			 it( "fires on start", function() {
				 var event = execute( "main.onSessionStart" );
			 } );

			 it( "fires on end", function() {
				 // Place a fake session structure here, it mimics what the handler receives
				 URL.sessionReference     = structNew();
				 URL.applicationReference = structNew();
				 var event                = execute( "main.onSessionEnd" );
			 } );
		 } );
	 } );
 }

}
