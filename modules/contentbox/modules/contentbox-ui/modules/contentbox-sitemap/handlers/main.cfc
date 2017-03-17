/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manages the creations of dynamic sitemaps in ContentBox
*/
component {

	// DI
	property name="entryService"		inject="id:entryService@cb";
	property name="pageService"			inject="id:pageService@cb";
	property name="contentService"		inject="id:contentService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";
	property name="settingService"		inject="id:settingService@cb";
	
	/**
	* Single entry point, outputs the sitemap according to the incoming `rc.format`
	*/
	function index(){
		// params
		param name="rc.format" default="";
		
		// store UI module root
		prc.cbRoot = getContextRoot() & event.getModuleRoot( 'contentbox' );
		// store module entry point
		prc.cbEntryPoint = getModuleConfig( "contentbox-ui" ).entryPoint;
		
		// Several Link Defs
		prc.linkHome 	= CBHelper.linkHome();
		prc.siteBaseURL = CBHelper.siteBaseURL();
		prc.disableBlog = settingService.getSetting( 'cb_site_disable_blog' );
		
		// Get Content Data
		prc.aPages = pageService.getAllFlatPages( 
			sortOrder	= "order asc",
			isPublished = true
		);

		// Blog data if enabled
		if( prc.disableBlog == false ){ 
			prc.blogEntryPoint = settingService.getSetting( 'cb_site_blog_entrypoint' );
			if( len( prc.blogEntryPoint ) && right( prc.blogEntryPoint, 1) != '/' ){
				prc.blogEntryPoint = prc.blogEntryPoint & '/';
			}
			// Entry Content
			prc.aEntries = entryService.getAllFlatEntries( 
				sortOrder	= "createdDate asc",
				isPublished = true
			);
		}
		
		// Output Formats
		if( rc.format == 'xml' ){
			event.renderData(
				data 		= renderView( view="sitemap_xml", module="contentbox-sitemap" ),
				contentType = "application/xml"
			);	
		} else if( rc.format == 'json' ){
			event.renderData(
  				data 		= renderView( view="sitemap_json", module="contentbox-sitemap" ),
  				contentType = "application/json"
			);
		} else if( rc.format == 'txt' ){
			event.renderData(
  				data 		= renderView( view="sitemap_txt", module="contentbox-sitemap" ),
  				contentType = "text/plain"
			);
		} else {
			CBHelper.prepareUIRequest( 'pages' );
			event.setView( "sitemap_html" );
		}
	}
	
}