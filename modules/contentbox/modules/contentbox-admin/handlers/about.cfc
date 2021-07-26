/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="baseHandler" {

	/**
	 * ContentBox about page
	 */
	function index( event, rc, prc ){
		// Light up
		prc.tabSystem_about = true;
		event.setView( "about/index" );
	}

}
