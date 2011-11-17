/**
* The main ContentBox engine handler
*/
component extends="BaseContentHandler" singleton{

	// DI
	property name="pageService"			inject="id:pageService@cb";
	
	// pre Handler
	function preHandler(event,action,eventArguments){
		super.preHandler(argumentCollection=arguments);
	}
	
	/**
	* Present pages
	*/
	function index(event,rc,prc){
		// incoming params
		event.paramValue("pageSlug","");
		
		// Try to retrieve by slug
		prc.page = pageService.findBySlug(rc.pageSlug);
		
		// Check if loaded, else not found
		if( prc.page.isLoaded() ){
			// Record hit
			pageService.updateHits( prc.page );
			// Retrieve Comments
			// TODO: paging
			var commentResults 	= commentService.findApprovedComments(pageID=prc.page.getPageID());
			prc.comments 		= commentResults.comments;
			prc.commentsCount 	= commentResults.count;
			// announce event
			announceInterception("cbui_onPage",{page=prc.page,pageSlug=rc.pageSlug});
			// set skin view
			event.setView(view="#prc.cbLayout#/views/page",layout="#prc.cbLayout#/layouts/#prc.page.getLayout()#");
		}
		else{
			// missing page
			prc.missingPage 	 = rc.pageSlug;
			prc.missingRoutedURL = event.getCurrentRoutedURL();
			
			// announce event
			announceInterception("cbui_onPageNotFound",{page=prc.page,pageSlug=rc.pageSlug,routedURL=prc.missingRoutedURL});
			
			// set 404 headers
			event.setHTTPHeader("404","Page not found");
			
			// set skin not found
			event.setView(view="#prc.cbLayout#/views/notfound",layout="#prc.cbLayout#/layouts/pages");
		}	
		
	}

	/**
	* Display the RSS feeds
	*/
	function rss(event,rc,prc){
		// params
		event.paramValue("category","");
		event.paramValue("entrySlug","");
		event.paramValue("commentRSS",false);
		
		// Build out the RSS feeds
		var feed = RSSService.getRSS(comments=rc.commentRSS,category=rc.category,entrySlug=rc.entrySlug);
		
		// Render out the feed xml
		event.renderData(type="plain",data=feed,contentType="text/xml");
	}
	
	/**
	* Comment Form Post
	*/
	function commentPost(event,rc,prc){
		// incoming params
		event.paramValue("contentID","");
		
		// Try to retrieve page by slug
		var page = pageService.get( rc.contentID );
		
		// If null, kick them out
		if( isNull( page ) ){ setNextEvent( prc.cbEntryPoint ); }
		
		// validate incoming comment post
		prc.commentErrors = validateCommentPost(event,rc,prc,page);
		
		// Validate if comment errors exist
		if( arrayLen( prc.commentErrors ) ){
			// MessageBox
			getPlugin("MessageBox").warn(messageArray=prc.commentErrors);
			// put slug in request
			rc.pageSlug = page.getSlug();
			// Execute entry again, need to correct form
			return index(argumentCollection=arguments);	
		}
		
		// Valid commenting, so go and save
		saveComment( page );		
	}

}