component {

	function configure(){
		// Api Echo
		route( "/", "echo.index" );

		// Security endpoints
		post( "/login", "auth.login" );
		post( "/logout", "auth.logout" );
		post( "/refreshToken", "auth.refreshToken" );
		get( "/whoami", "auth.whoami" );

		// Global Settings
		get( "/settings", "settings.index" );

		// Site Settings
		get( "/sites/:slug/settings", "siteSettings.index" );

		/**
		 * --------------------------------------------------------------------------
		 * Resource groups for /sites/:site
		 * --------------------------------------------------------------------------
		 */
		var except     = "new,edit";
		var sitePrefix = "/sites/:site";

		/**
		 * --------------------------------------------------------------------------
		 * Author Routing
		 * --------------------------------------------------------------------------
		 */
		resources( resource: "authors", except: except );

		/**
		 * --------------------------------------------------------------------------
		 * Category Routing
		 * --------------------------------------------------------------------------
		 */
		resources(
			resource: "categories",
			pattern = "#siteprefix#/categories",
			except  : except
		);

		/**
		 * --------------------------------------------------------------------------
		 * Entry Based Routing
		 * --------------------------------------------------------------------------
		 */
		resources(
			resource: "comments",
			pattern = "#siteprefix#/entries/:contentIdOrSlug/comments",
			except  : except,
			meta    : { contentType : "entry" }
		);
		resources(
			resource: "versions",
			pattern = "#siteprefix#/entries/:contentIdOrSlug/versions",
			except  : "new,edit,create,update",
			meta    : { contentType : "entry" }
		);
		resources(
			resource: "entries",
			pattern = "#siteprefix#/entries",
			except  : except
		);

		/**
		 * --------------------------------------------------------------------------
		 * ContentStore Routing
		 * --------------------------------------------------------------------------
		 */
		resources(
			resource: "versions",
			pattern = "#siteprefix#/contentStore/:contentIdOrSlug/versions",
			except  : "new,edit,create,update",
			meta    : { contentType : "contentStore" }
		);
		resources(
			resource: "contentStore",
			pattern = "#siteprefix#/contentStore",
			except  : except
		);

		/**
		 * --------------------------------------------------------------------------
		 * Page Routing
		 * --------------------------------------------------------------------------
		 */
		resources(
			resource: "versions",
			pattern = "#siteprefix#/pages/:contentIdOrSlug/versions",
			except  : "new,edit,create,update",
			meta    : { contentType : "page" }
		);
		resources(
			resource: "comments",
			pattern = "#siteprefix#/pages/:contentIdOrSlug/comments",
			except  : except,
			meta    : { contentType : "page" }
		);
		resources(
			resource: "pages",
			pattern = "#siteprefix#/pages",
			except  : except
		);

		/**
		 * --------------------------------------------------------------------------
		 * Menu Routing
		 * --------------------------------------------------------------------------
		 */
		resources(
			resource: "menus",
			pattern = "#siteprefix#/menus",
			except  : except
		);

		resources( resource: "sites", except: except );

		// Catch All Resource
		route( "/:anything" ).to( "Echo.onInvalidRoute" );
	}

}
