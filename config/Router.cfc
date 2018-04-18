/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Application Router
*/
component{

	function configure(){
		// Configuration
		setValidExtensions( 'xml,json,jsont,rss,html,htm,cfm,print,pdf,doc,txt' );
		setFullRewrites( true );

		// Mappings
		route( ":handler/:action" ).end();
	}

}