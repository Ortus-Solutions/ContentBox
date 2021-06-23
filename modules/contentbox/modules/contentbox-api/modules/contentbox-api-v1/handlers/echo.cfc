/**
 * Echo endpoint for versioning information
 */
component extends="baseHandler" {

	/**
	 * A nice welcome to the API services
	 */
	any function index( event, rc, prc ){
		prc.response.setData( "Welcome to the ContentBox API v1.x Services" );
	}

}
