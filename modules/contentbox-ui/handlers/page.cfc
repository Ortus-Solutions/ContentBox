/**
* The main ContentBox engine handler
*/
component extends="BaseContentHandler" singleton{

	// DI
	property name="pageService"			inject="id:pageService@cb";
	property name="contentService"		inject="id:contentService@cb";

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

		var incomingSlug = "";
		var incomingURL  = "";

		// Do we have an override page setup by the settings?
		if( !structKeyExists(prc,"pageOverride") ){
			// Try slug parsing for hiearchical URLs
			incomingURL  = "/" & event.getCurrentRoutedURL();
			incomingSlug = listLast(incomingURL,"/");
		}
		else{
			incomingURL	 = "/" & prc.pageOverride & "/";
			incomingslug = prc.pageOverride;
		}
		// get the author
		var author = getModel("securityService@cb").getAuthorSession();
		var showUnpublished = false;
		if( author.isLoaded() AND author.isLoggedIn() ){
			var showUnpublished = true;
		}
		// Try to get the page using the last slug.
		prc.page = pageService.findBySlug( incomingSlug, showUnpublished );

		// Check if loaded and also the ancestry is ok as per hiearchical URls
		if( prc.page.isLoaded() AND (prc.page.getRecursiveSlug() & "/") eq incomingURL){
			// Record hit
			prc.page.updateHits();
			// Retrieve Comments
			// TODO: paging
			var commentResults 	= commentService.findApprovedComments(contentID=prc.page.getContentID());
			prc.comments 		= commentResults.comments;
			prc.commentsCount 	= commentResults.count;
			// announce event
			announceInterception("cbui_onPage",{page=prc.page,pageSlug=rc.pageSlug});

			// Verify chosen page layout exists?
			verifyPageLayout( prc.page );

			// set skin view
			event.setView(view="#prc.cbLayout#/views/page",layout="#prc.cbLayout#/layouts/#prc.page.getLayout()#");
		}
		else{
			// missing page
			prc.missingPage 	 = incomingURL;
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
	* Content Search
	*/
	function search(event,rc,prc){
		// incoming params
		event.paramValue("page",1);
		event.paramValue("q","");

		// Decode search term
		rc.q = URLDecode(rc.q);

		// prepare paging plugin
		prc.pagingPlugin 		= getMyPlugin(plugin="Paging",module="contentbox");
		prc.pagingBoundaries	= prc.pagingPlugin.getBoundaries();
		prc.pagingLink 			= CBHelper.linkContentSearch() & "/#URLEncodedFormat(rc.q)#/@page@";

		// get published content
		if( len(rc.q) ){
			var searchResults = contentService.searchContent(offset=prc.pagingBoundaries.startRow-1,
												   			 max=prc.cbSettings.cb_paging_maxentries,
												   			 searchTerm=rc.q);
			prc.searchItems 		= searchResults.content;
			prc.searchItemsCount  	= searchResults.count;
		}
		else{
			prc.searchItems = [];
			prc.searchItemsCount = 0;
		}
		
		// announce event
		announceInterception("cbui_onContentSearch",{searchItems = prc.searchItems, searchItemsCount = prc.searchItemsCount, searchTerm = rc.q});

		// set skin search
		event.setView(view="#prc.cbLayout#/views/search",layout="#prc.cbLayout#/layouts/pages");
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

		// Try to retrieve page by contentID
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
	
	/************************************** PRIVATE *********************************************/

	/**
	* Verify if a chosen page layout exists or not.
	*/
	private function verifyPageLayout(required page){
		if( !fileExists( expandPath( CBHelper.layoutRoot() & "/layouts/#arguments.page.getLayout()#.cfm" ) ) ){
			throw(message="The layout of the page: '#arguments.page.getLayout()#' does not exist in the current theme.",
			      detail="Please verify your page layout settings",
				  type="ContentBox.InvalidPageLayout");
		}
	}


}