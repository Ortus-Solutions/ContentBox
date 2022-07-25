/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manages page displays
 */
component extends="content" {

	// DI
	property name="pageService" inject="pageService@contentbox";
	property name="searchService" inject="SearchService@contentbox";
	property name="securityService" inject="securityService@contentbox";
	property name="mobileDetector" inject="mobileDetector@contentbox";
	property name="themeService" inject="themeService@contentbox";

	// Pre Handler Exceptions
	this.preHandler_except = "preview";

	/**
	 * Pre handler for pages
	 *
	 * @event         
	 * @action        
	 * @eventArguments
	 * @rc            
	 * @prc           
	 */
	function preHandler( event, action, eventArguments, rc, prc ){
		super.preHandler( argumentCollection = arguments );
	}

	/**
	 * Preview a page
	 *
	 * @event
	 * @rc   
	 * @prc  
	 */
	function preview( event, rc, prc ){
		// Run parent preview
		super.preview( argumentCollection = arguments );

		// Determine content type service to allow for custom content types
		var typeService = getContentTypeService( rc.contentType );

		// Construct the preview entry according to passed arguments
		prc.page = typeService.new( {
			title         : rc.title,
			slug          : rc.slug,
			publishedDate : now(),
			allowComments : false,
			cache         : false,
			markup        : rc.markup,
			layout        : rc.layout,
			site          : variables.siteService.getOrFail( rc.siteID )
		} );

		// Comments need to be empty
		prc.comments = [];

		// Create preview version
		prc.page.addNewContentVersion(
			content   = urlDecode( rc.content ),
			author    = prc.oCurrentAuthor,
			isPreview = true
		);

		// Do we have a parent?
		if ( len( rc.parentContent ) && isNumeric( rc.parentContent ) ) {
			var parent = typeService.get( rc.parentContent );
			if ( !isNull( parent ) ) {
				prc.page.setParent( parent );
			}
		}

		// set skin view
		switch ( rc.layout ) {
			case "-no-layout-": {
				return prc.page.renderContent();
			}
			default: {
				event
					.setLayout(
						name   = "#prc.cbTheme#/layouts/#prc.page.getLayoutWithInheritance()#",
						module = prc.cbThemeRecord.module
					)
					.setView( view = "#prc.cbTheme#/views/page", module = prc.cbThemeRecord.module );
			}
		}
	}

	/**
	 * Around page advice that provides caching and multi-output format
	 *
	 * @event         
	 * @rc            
	 * @prc           
	 * @eventArguments
	 */
	function aroundIndex( event, rc, prc, eventArguments ){
		// setup wrap arguments
		arguments.contentCaching = prc.cbSettings.cb_content_caching;
		arguments.action         = variables.index;

		return wrapContentAdvice( argumentCollection = arguments );
	}

	/**
	 * Present pages in the UI
	 *
	 * @event
	 * @rc   
	 * @prc  
	 */
	function index( event, rc, prc ){
		// Routing placeholder
		event.paramValue( "pageUri", "" );

		// Detect full page uri or override it via a prehandler check
		rc.pageUri = isNull( prc.pageOverride ) ? reReplaceNoCase( event.getCurrentRoutedURL(), "\/$", "" ) : prc.pageOverride;

		// Cleanup the module entry point if any
		if ( len( prc.cbEntryPoint ) ) {
			rc.pageUri = replaceNoCase( rc.pageUri, prc.cbEntryPoint & "/", "" );
		}

		// Try to get the page using the incoming URI
		prc.page = variables.pageService.findBySlug(
			slug           : rc.pageUri,
			showUnpublished: ( prc.oCurrentAuthor.isLoaded() AND prc.oCurrentAuthor.isLoggedIn() ) ? true : false,
			siteID         : prc.oCurrentSite.getsiteID()
		);

		// Check if loaded and also the ancestry is ok as per hiearchical URls
		if ( prc.page.isLoaded() ) {
			// Record hit
			variables.pageService.updateHits( prc.page );
			// Retrieve Comments
			// TODO: paging
			if ( prc.page.getAllowComments() ) {
				var commentResults = variables.commentService.findAllApproved(
					contentID = prc.page.getContentID(),
					sortOrder = "asc"
				);
				prc.comments      = commentResults.comments;
				prc.commentsCount = commentResults.count;
			} else {
				prc.comments      = [];
				prc.commentsCount = 0;
			}
			// Detect Mobile Device
			prc.isMobileDevice = variables.mobileDetector.isMobile();
			// announce event
			announce( "cbui_onPage", { page : prc.page, isMobile : prc.isMobileDevice } );
			// Get the layout
			var thisLayout = prc.page.getLayoutWithInheritance();
			// No layout, just render it out
			if ( thisLayout eq "-no-layout-" ) {
				return prc.page.renderContent();
			}
			// set layout + view combo
			event
				.setLayout( name = "#prc.cbTheme#/layouts/#thisLayout#", module = prc.cbThemeRecord.module )
				.setView( view = "#prc.cbTheme#/views/page", module = prc.cbThemeRecord.module );
			return;
		}
		// end if page was loaded

		// missing page
		prc.missingPage      = rc.pageUri;
		prc.missingRoutedURL = event.getCurrentRoutedURL();

		// announce event
		announce(
			"cbui_onPageNotFound",
			{
				page        : prc.page,
				missingPage : prc.missingPage,
				routedURL   : prc.missingRoutedURL
			}
		);

		// Not Found layout + view
		event
			.setLayout( name = "#prc.cbTheme#/layouts/pages", module = prc.cbThemeRecord.module )
			.setView( view = "#prc.cbTheme#/views/notfound", module = prc.cbThemeRecord.module )
			.setHTTPHeader( "404", "Page not found" );
	}

	/**
	 * Content search
	 *
	 * @event
	 * @rc   
	 * @prc  
	 *
	 * @return HTML
	 */
	function search( event, rc, prc ){
		// incoming params
		event.paramValue( "page", 1 ).paramValue( "q", "" );

		// cleanup
		rc.q = htmlEditFormat( trim( rc.q ) );

		// prepare paging object
		prc.oPaging          = getInstance( "paging@contentbox" );
		prc.pagingBoundaries = prc.oPaging.getBoundaries( pagingMaxRows: prc.cbSettings.cb_search_maxResults );
		prc.pagingLink       = variables.CBHelper.linkContentSearch() & "/#urlEncodedFormat( rc.q )#/@page@";

		// get search results
		if ( len( rc.q ) ) {
			var searchAdapter = variables.searchService.getSearchAdapter();
			prc.searchResults = searchAdapter.search(
				offset    : prc.pagingBoundaries.startRow - 1,
				max       : prc.cbSettings.cb_search_maxResults,
				searchTerm: rc.q,
				siteID    : prc.oCurrentSite.getsiteID()
			);
			prc.searchResultsContent = searchAdapter.renderSearchWithResults( prc.searchResults );
		} else {
			prc.searchResults        = getInstance( "SearchResults@contentbox" );
			prc.searchResultsContent = "<div class='alert alert-info'>Please enter a search term to search on.</div>";
		}

		// set skin search
		event
			.setLayout(
				name   = "#prc.cbTheme#/layouts/#themeService.getThemeSearchLayout()#",
				module = prc.cbThemeRecord.module
			)
			.setView( view = "#prc.cbTheme#/views/search", module = prc.cbThemeRecord.module );

		// announce event
		announce(
			"cbui_onContentSearch",
			{
				searchResults        : prc.searchResults,
				searchResultsContent : prc.searchResultsContent
			}
		);
	}


	/**
	 * RSS Feeds
	 *
	 * @event
	 * @rc   
	 * @prc  
	 */
	function rss( event, rc, prc ){
		// params
		event.paramValue( "category", "" );
		event.paramValue( "entrySlug", "" );
		event.paramValue( "commentRSS", false );

		// Build out the RSS feeds
		var feed = RSSService.getRSS(
			comments  = rc.commentRSS,
			category  = rc.category,
			entrySlug = rc.entrySlug
		);

		// Render out the feed xml
		event.renderData(
			type        = "plain",
			data        = feed,
			contentType = "text/xml"
		);
	}

	/**
	 * Comment Form Post
	 *
	 * @event
	 * @rc   
	 * @prc  
	 */
	function commentPost( event, rc, prc ){
		// incoming params
		event.paramValue( "contentID", "" );
		// Try to retrieve page by contentID
		var page = variables.contentService.get( rc.contentID );
		// If null, kick them out
		if ( isNull( page ) ) {
			relocate( prc.cbEntryPoint );
		}
		// validate incoming comment post
		validateCommentPost( event, rc, prc, page );
		// Valid commenting, so go and save
		saveComment(
			thisContent = page,
			subscribe   = rc.subscribe,
			prc         = prc
		);
	}

	/************************************** PRIVATE *********************************************/

	/**
	 * Get the appropriate type service according to passed content type
	 *
	 * @contentType The type of service needed
	 */
	private function getContentTypeService( contentType = "page" ){
		return ( arguments.contentType == "page" ? variables.pageService : variables.contentService );
	}

}
