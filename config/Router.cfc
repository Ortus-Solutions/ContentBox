/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Application Router
 */
component {

	function configure(){
		// Configuration
		setValidExtensions( "xml,json,jsont,rss,html,htm,cfm,print,pdf,doc,txt" );
		// Process Full Rewrites then true, else false and an `index.cfm` will always be included in URLs
		setFullRewrites( false );

		/**
		 * --------------------------------------------------------------------------
		 * App Routes
		 * --------------------------------------------------------------------------
		 *
		 * Here is where you can register the routes for your web application!
		 * Go get Funky!
		 *
		 */

		// Mappings
		route( ":handler/:action" ).end();
	}

}
