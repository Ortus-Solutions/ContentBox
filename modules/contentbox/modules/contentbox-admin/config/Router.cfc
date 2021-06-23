component {

	function configure(){
		route( "/" ).to( "dashboard" );

		route( "/cbsecurity" ).toModuleRouting( "contentbox-security" );

		route( "/authors/page/:page" ).to( "authors" );
		route( "/comments/page/:page" ).to( "comments" );
		route( "/contentStore/page/:page" ).to( "contentStore" );
		route( "/contentStore/parent/:parent?" ).to( "contentStore" );
		route( "/dashboard/reload/:targetModule" ).to( "dashboard.reload" );
		route( "/entries/page/:page" ).to( "entries" );
		route( "/entries/pager/page/:page" ).to( "entries.pager" );
		route( "/menus/page/:page" ).to( "menus" );
		route( "/pages/parent/:parent?" ).to( "pages" );

		route( "/mediamanager/library/:library" ).to( "mediamanager" );

		route( "/module/:moduleEntryPoint/:moduleHandler?/:moduleAction?" ).to( "modules.execute" );

		// Convetion based routing
		route( "/:handler/:action" ).end();
	}

}
