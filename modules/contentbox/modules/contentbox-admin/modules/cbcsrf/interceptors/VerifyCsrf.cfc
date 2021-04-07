/**
* Verifies the CSRF token on all non-GET requests
*/
component extends="coldbox.system.Interceptor" accessors="true" {

	/* *********************************************************************
	 **						DI
	 ********************************************************************* */

	property name="handlerService" inject="coldbox:handlerService";
	property name="cbcsrf" inject="@cbcsrf";

	 /* *********************************************************************
	  **						Properties
	  ********************************************************************* */

	property name="isTestMode" type="boolean" default="false";

	/**
	 * Configure the interceptor
	 */
	function configure(){
		variables.isTestMode = isInstanceOf( controller, "coldbox.system.testing.mock.web.MockController" );
	}

	/**
	 * Fire before event execution
	 *
	 * @event
	 * @interceptData
	 * @buffer
	 * @rc
	 * @prc
	 */
    public void function preProcess( event, interceptData, rc, prc ) {
		// Are we in test mode? then skip
		if( variables.isTestMode ){
			if( log.canDebug() ){
				log.debug( "cbcsrf Verify skipped, we are in integration test mode" );
			}
            return;
		}

		// If it's a GET/HEAD/OPTIONS pass it
        if ( listFindNoCase( "GET,OPTIONS,HEAD", event.getHTTPMethod() )  ) {
			if( log.canDebug() ){
				log.debug( "cbcsrf Verify skipped due to HTTP method: #event.getHTTPMethod()#=>#event.getCurrentEvent()#" );
			}
            return;
		}

		// is the incoming event is in the skipped events?
		if(
			variables.cbcsrf.getSettings()
				.verifyExcludes
				.filter( function( item ){
					// If found, then don't return it
					return !reFindNoCase( item, event.getCurrentEvent() );
				} ).len() != variables.cbcsrf.getSettings().verifyExcludes.len()
		){
			if( log.canDebug() ){
				log.debug( "cbcsrf Verify skipped as event: #event.getCurrentEvent()# is in the verify excludes list." );
			}
			return;
		}

		// Does the event have an annotation
        if ( actionMarkedToSkip( arguments.event ) ) {
			if( log.canDebug() ){
				log.debug( "cbcsrf Verify skipped as action has been annotated to skip: #event.getCurrentEvent()#" );
			}
            return;
		}

		// Do we have an incoming token in the form or header
        if ( ! event.valueExists( "csrf" ) && ! event.getHTTPHeader( "x-csrf-token", "" ).len() ) {
            throw(
                type = "TokenNotFoundException",
                message = "The CSRF token was not included."
            );
        }

		// Get it, put it in prc scope and Verify the token
		prc.csrfToken = event.getValue( "csrf", event.getHTTPHeader( "x-csrf-token", "" ) );
        if ( ! variables.cbcsrf.verify( prc.csrfToken ) ) {
            throw(
                type = "TokenMismatchException",
                message = "The CSRF token is invalid."
            );
		}

		if( log.canDebug() ){
			log.debug( "cbcsrf verified for #event.getCurrentEvent()#" );
		}
    }

	/**
	 * Are we skipping the action or not due to the skipCsrf annotation?
	 *
	 * @event
	 * @interceptData
	 */
    private boolean function actionMarkedToSkip( required event ) {
		var handlerBean = handlerService.getHandlerBean( arguments.event.getCurrentEvent() );
		if ( handlerBean.getHandler() == "" ) {
			return;
		}

		// If metadata is not loaded, load it
		if ( !handlerBean.isMetadataLoaded() ) {
			handlerService.getHandler( handlerBean, arguments.event );
		}

		return handlerBean.getActionMetadata( "skipCsrf", false );
    }

}