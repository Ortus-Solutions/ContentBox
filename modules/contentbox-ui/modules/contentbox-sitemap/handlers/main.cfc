component {

	property name="entryService"		inject="id:entryService@cb";
	property name="pageService"			inject="id:pageService@cb";
	property name="contentService"		inject="id:contentService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";
	property name="settingService"		inject="id:settingService@cb";
	
	public function index(){
		param name="rc.format" default="";
		
		// store UI module root
		prc.cbRoot = getContextRoot() & event.getModuleRoot( 'contentbox' );
		// store module entry point
		prc.cbEntryPoint = getModuleConfig( "contentbox-ui" ).entryPoint;
		
		
		prc.linkHome = cbhelper.linkHome();
		prc.siteBaseURL = cbhelper.siteBaseURL();
		prc.disableBlog = settingService.getSetting( 'cb_site_disable_blog' );
		
		prc.pageResults = pageService.search( 
			search		= "",
			isPublished	= true,
			category	= "all",
			author		= "all",
			creator		= "all",
			sortOrder	= "order asc" 
		);
		if( prc.disableBlog == false ){ 
			prc.blogEntryPoint = settingService.getSetting( 'cb_site_blog_entrypoint' );
			if( len( prc.blogEntryPoint ) && right( prc.blogEntryPoint, 1) != '/' ){
				prc.blogEntryPoint = prc.blogEntryPoint & '/';
			}
			prc.entryResults = entryService.search( 
				search		= "",
				isPublished	= true,
				category	= "all",
				author		= "all",
				creator		= "all",
				sortOrder	= "" 
			); 		
		}
		 
		if( rc.format == 'xml' ){
			event.renderData(
				data = renderView( view="sitemap_xml", module="contentbox-sitemap" ),
				contentType = "application/xml"
			);	
		} else if( rc.format == 'json' ){
			event.renderData(
  				data = renderView( view="sitemap_json", module="contentbox-sitemap" ),
  				contentType = "application/json"
			);
		} else if( rc.format == 'txt' ){
			event.renderData(
  				data = renderView( view="sitemap_txt", module="contentbox-sitemap" ),
  				contentType = "text/plain"
			);
		} else {
			CBHelper.prepareUIRequest( 'pages' );
			event.setView( "sitemap_html" );
		}
	}
	
}