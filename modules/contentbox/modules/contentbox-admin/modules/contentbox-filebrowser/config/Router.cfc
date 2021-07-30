/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * File browser router
 */
component {

	function configure(){
		route( "/filelisting" ).to( "home.filelisting" );
		route( "/createFolder" ).to( "home.createFolder" );
		route( "/remove" ).to( "home.remove" );
		route( "/download" ).to( "home.download" );
		route( "/rename" ).to( "home.rename" );
		route( "/upload" ).to( "home.upload" );
		route( "/d/:path" ).to( "home.index" );
		route( "/" ).to( "home.index" );
		route( "/:handler/:action" ).end();
	}

}
