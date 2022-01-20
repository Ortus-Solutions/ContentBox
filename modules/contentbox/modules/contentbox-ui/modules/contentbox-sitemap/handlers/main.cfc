/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manages the creations of dynamic sitemaps in ContentBox
 */
component {

	// DI
	property name="entryService" inject="id:entryService@contentbox";
	property name="pageService" inject="id:pageService@contentbox";
	property name="contentService" inject="id:contentService@contentbox";
	property name="CBHelper" inject="id:CBHelper@contentbox";
	property name="settingService" inject="id:settingService@contentbox";

	/**
	 * Executes before all handler actions
	 */
	any function preHandler( event, rc, prc, action, eventArguments ){
		// params
		param name="rc.format" default="html";
		// Prepare UI Request
		CBHelper.prepareUIRequest( "pages" );
		// Verify if sitemap is enabled, else, proxy into the page event
		if ( !prc.oCurrentSite.getIsSitemapEnabled() ) {
			// proxy
			event.overrideEvent( "contentbox-ui:page.index" );
			return;
		}
	}

	/**
	 * Sitemap Wrapper
	 */
	function index( event, rc, prc ){
		// Caching Enabled? Then test if data is in cache.
		var cacheEnabled = ( !event.valueExists( "cbCache" ) );

		if ( cacheEnabled ) {
			// Get appropriate cache provider from settings
			var cache    = cacheBox.getCache( prc.cbSettings.cb_content_cacheName );
			var cacheKey = "cb-content-sitemap-#cgi.HTTP_HOST#" &
			hash( ".#rc.format#.#event.isSSL()#" & prc.cbox_incomingContextHash );

			// get content data from cache
			var results = cache.get( cacheKey );
			// if NOT null and caching enabled and noCache event argument does not exist and no incoming cbCache URL arg, then cache
			if ( !isNull( results ) ) {
				// Set cache headers if allowed
				if ( prc.cbSettings.cb_content_cachingHeader ) {
					event.setHTTPHeader( name = "x-contentbox-cached-content", value = "true" );
				}
				// return cache content to be displayed
				event.renderData(
					data        = results.data,
					contentType = results.contentType,
					statusCode  = prc.cbSettings.cb_content_cachingHeader ? 203 : 200
				);
				return;
			}
		}

		// Execute sitemap
		var results = _index( argumentCollection = arguments );

		// verify if caching is possible by testing the content parameters
		if ( cacheEnabled ) {
			// Cache data
			cache.set(
				cachekey,
				results,
				( prc.cbSettings.cb_content_cachingTimeout ),
				( prc.cbSettings.cb_content_cachingTimeoutIdle )
			);
		}

		// Render it out
		event.renderData( data = results.data, contentType = results.contentType );
	}

	/**
	 * Single entry point, outputs the sitemap according to the incoming `rc.format`
	 *
	 * @return { data, contentType }
	 */
	private struct function _index( event, rc, prc ){
		// store UI module root
		prc.cbRoot       = getContextRoot() & event.getModuleRoot( "contentbox" );
		// store module entry point
		prc.cbEntryPoint = getModuleConfig( "contentbox-ui" ).entryPoint;

		// Several Link Defs
		prc.linkHome    = CBHelper.linkHome();
		prc.siteBaseURL = CBHelper.siteBaseURL();
		prc.disableBlog = !prc.oCurrentSite.getIsBlogEnabled();

		// Get Content Data
		prc.aPages = pageService.getAllFlatContent(
			sortOrder    = "order asc",
			isPublished  = true,
			showInSearch = true,
			siteID       = prc.oCurrentSite.getsiteID()
		);

		// Blog data if enabled
		if ( prc.disableBlog == false ) {
			prc.blogEntryPoint = settingService.getSetting( "cb_site_blog_entrypoint" );
			if ( len( prc.blogEntryPoint ) && right( prc.blogEntryPoint, 1 ) != "/" ) {
				prc.blogEntryPoint = prc.blogEntryPoint & "/";
			}
			// Entry Content
			prc.aEntries = entryService.getAllFlatContent(
				sortOrder    = "createdDate asc",
				isPublished  = true,
				showInSearch = true,
				siteID       = prc.oCurrentSite.getsiteID()
			);
		}

		// Render it out in specific format
		switch ( rc.format ) {
			case "xml": {
				return {
					data        : renderView( view = "sitemap_xml", module = "contentbox-sitemap" ),
					contentType : "application/xml"
				};
			}
			case "json": {
				return {
					data        : renderView( view = "sitemap_json", module = "contentbox-sitemap" ),
					contentType : "application/json"
				};
			}
			case "txt": {
				return {
					data        : renderView( view = "sitemap_txt", module = "contentbox-sitemap" ),
					contentType : "text/plain"
				};
			}
			default: {
				event.setView( "sitemap_html" );
				return {
					data : renderLayout(
						module     = event.getCurrentLayoutModule(),
						viewModule = event.getCurrentViewModule()
					),
					contentType : "text/html"
				};
			}
		}
	}

}
