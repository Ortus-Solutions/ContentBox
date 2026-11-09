/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	function run( testResults, testBox ){
		describe( "Subscriber Service", () => {
			beforeEach( ( currentSpec ) => {
				// Capture the request so the debugger can track our data. since we are in unit mode.
				getController().getRequestService().requestCapture();
				subscriberService = getInstance( "SubscriberService@contentbox" );
			} );

			it( "can count the unique subscribers", () => {
				var expected = queryExecute( "select count( distinct subscriberEmail ) as total from cb_subscribers" ).total;
				expect( subscriberService.getUniqueSubscriberCount() ).toBe( expected );
			} );
		} );
	}

}
