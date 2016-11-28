/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Handler For ContentBox blog pages
*/
component extends="content"{

	// DI
	property name="entryService" inject="id:entryService@cb";
	
	// Pre Handler Exceptions
	this.preHandler_except = "preview";

	// pre Handler
	function preHandler( event, rc, prc ,action,eventArguments){
		// Check if disabled?
		if( prc.cbSettings.cb_site_disable_blog ){
			event.overrideEvent( "contentbox-ui:blog.disabled" );
		}
		// super call
		super.preHandler( argumentCollection=arguments );
	}

	/**
	* Action if blog is disabled
	*/
	function disabled( event, rc, prc ){
		// missing page, the blog as it does not exist
		prc.missingPage 	 = event.getCurrentRoutedURL();
		prc.missingRoutedURL = event.getCurrentRoutedURL();

		// set 404 headers
		event.setHTTPHeader( "404","Page not found" );

		// set skin not found
		event.setLayout( name="#prc.cbTheme#/layouts/pages", module="contentbox" )
			.setView( view="#prc.cbTheme#/views/notfound", module="contentbox" );
	}
	
	/**
	* Preview a blog entry
	*/
	function preview( event, rc, prc ){
		// Run parent preview
		super.preview( argumentCollection=arguments );
		// Concrete Overrides Below
		
		// Construct the preview entry according to passed arguments
		prc.entry = entryService.new();
		prc.entry.setTitle( rc.title );
		prc.entry.setSlug( rc.slug );
		prc.entry.setPublishedDate( now() );
		prc.entry.setAllowComments( false );
		prc.entry.setCache( false );
		prc.entry.setMarkup( rc.markup );
		// Comments need to be empty
		prc.comments = [];
		// Create preview version
		prc.entry.addNewContentVersion( content=URLDecode( rc.content ), author=prc.oCurrentAuthor )
			.setActiveContent( prc.entry.getContentVersions() );
		// set skin view
		event.setLayout( name="#prc.cbTheme#/layouts/#rc.layout#", module="contentbox" )
			.setView( view="#prc.cbTheme#/views/entry", module="contentbox" );
	}

	/**
	* The blog home page
	*/
	function index( event, rc, prc ){
		// incoming params
		event.paramValue( "page", 1 )
			.paramValue( "category", "" )
			.paramValue( "q", "" )
			.paramValue( "format", "html" );
		
		// Page numeric check
		if( !isNumeric( rc.page ) ){ rc.page = 1; }

		// XSS Cleanup
		rc.q 		= antiSamy.clean( rc.q );
		rc.category = antiSamy.clean( rc.category );

		// prepare paging object
		prc.oPaging 			= getModel( "Paging@cb" );
		prc.pagingBoundaries	= prc.oPaging.getBoundaries( pagingMaxRows=prc.cbSettings.cb_paging_maxentries );
		prc.pagingLink 			= CBHelper.linkBlog() & "?page=@page@";

		// Search Paging Link Override?
		if( len( rc.q ) ){
			prc.pagingLink = CBHelper.linkBlog() & "/search/#rc.q#/@page@?";
		}
		// Category Filter Link Override
		if( len( rc.category ) ){
			prc.pagingLink = CBHelper.linkBlog() & "/category/#rc.category#/@page@?";
		}

		// get published entries
		var entryResults = entryService.findPublishedEntries(
			offset		= prc.pagingBoundaries.startRow-1,
			max			= prc.cbSettings.cb_paging_maxentries,
			category	= rc.category,
			searchTerm	= rc.q
		);
		prc.entries 		= entryResults.entries;
		prc.entriesCount  	= entryResults.count;

		// announce event
		announceInterception( 
			"cbui_onIndex", {
			entries 	= prc.entries,
			entriesCount= prc.entriesCount
			} 
		);

		// Export Formats?
		switch( rc.format ){
			case "xml" : case "json" : {
				var result = [];
				for( var thisContent in prc.entries ){
					result.append( thisContent.getResponseMemento() );
				}
				event.renderData( type=rc.format, data=result, xmlRootName="entries" );
				break;
			}
			default : {
				// set skin view
				event.setLayout( name="#prc.cbTheme#/layouts/blog", module="contentbox" )
					.setView( view="#prc.cbTheme#/views/index", module="contentbox" );
			}
		}
	}

	/**
	* The archives
	*/
	function archives( event, rc, prc ){
		// incoming params
		event.paramValue( "page", 1 )
			.paramValue( "year", 0 )
			.paramValue( "month", 0 )
			.paramValue( "day", 0 )
			.paramValue( "format", "html" );
		
		// Page numeric check
		if( !isNumeric( rc.page ) ){ rc.page = 1; }

		// prepare paging object
		prc.oPaging 			= getModel( "Paging@cb" );
		prc.pagingBoundaries	= prc.oPaging.getBoundaries( pagingMaxRows=prc.cbSettings.cb_paging_maxentries );
		prc.pagingLink 			= event.getCurrentRoutedURL() & "?page=@page@";
		
		// get published entries
		var entryResults = entryService.findPublishedEntriesByDate(
			year 	= rc.year,
			month 	= rc.month,
			day 	= rc.day,
			offset 	= prc.pagingBoundaries.startRow-1,
			max 	= prc.cbSettings.cb_paging_maxentries
		);
		prc.entries 		= entryResults.entries;
		prc.entriesCount  	= entryResults.count;

		// announce event
		announceInterception( 
			"cbui_onArchives", 
			{
				entries 	= prc.entries,
				entriesCount= prc.entriesCount 
			} 
		);

		// Export Formats?
		switch( rc.format ){
			case "xml" : case "json" : {
				var result = [];
				for( var thisContent in prc.entries ){
					result.append( thisContent.getResponseMemento() );
				}
				event.renderData( type=rc.format, data=result, xmlRootName="entries" );
				break;
			}
			default : {
				// set skin view
				event.setLayout( name="#prc.cbTheme#/layouts/blog", module="contentbox" )
					.setView( view="#prc.cbTheme#/views/archives", module="contentbox" );
			}
		}
	}

	/**
	* Around entry page advice that provides caching and multi-output format
	*/
	function aroundEntry( event, rc, prc , eventArguments ){
		
		// setup wrap arguments
		arguments.contentCaching 	= prc.cbSettings.cb_entry_caching;
		arguments.action 			= variables.entry;

		return wrapContentAdvice( argumentCollection=arguments );
	}

	/**
	* An entry page
	*/
	function entry( event, rc, prc ){
		// incoming params
		event.paramValue( "entrySlug","" );

		// get the author
		var showUnpublished = false;
		if( prc.oCurrentAuthor.isLoaded() AND prc.oCurrentAuthor.isLoggedIn() ){
			var showUnpublished = true;
		}
		prc.entry = entryService.findBySlug(rc.entrySlug,showUnpublished);

		// Check if loaded, else not found
		if( prc.entry.isLoaded() ){
			// Record hit
			entryService.updateHits( prc.entry.getContentID() );
			// Retrieve Comments
			// TODO: paging
			var commentResults 	= commentService.findApprovedComments(contentID=prc.entry.getContentID(),sortOrder="asc" );
			prc.comments 		= commentResults.comments;
			prc.commentsCount 	= commentResults.count;
			// announce event
			announceInterception( "cbui_onEntry",{entry=prc.entry,entrySlug=rc.entrySlug} );
			// set skin view
			event.setLayout(name="#prc.cbTheme#/layouts/blog", module="contentbox" )
				.setView(view="#prc.cbTheme#/views/entry",module="contentbox" );
		}
		else{
			// announce event
			announceInterception( "cbui_onEntryNotFound",{entry=prc.entry,entrySlug=rc.entrySlug} );
			// missing page
			prc.missingPage = rc.entrySlug;
			// set 404 headers
			event.setHTTPHeader( "404","Entry not found" );
			// set skin not found
			event.setLayout(name="#prc.cbTheme#/layouts/blog", module="contentbox" )
				.setView(view="#prc.cbTheme#/views/notfound",module="contentbox" );
		}
	}

	/**
	* Display the RSS feeds for the blog
	*/
	function rss( event, rc, prc ){
		// params
		event.paramValue( "category", "" )
			.paramValue( "entrySlug", "" )
			.paramValue( "commentRSS", false );

		// Build out the blog RSS feeds
		var feed = RSSService.getRSS(
			comments	= rc.commentRSS,
			category	= rc.category,
			slug		= rc.entrySlug,
			contentType	= "Entry" 
		);

		// Render out the feed xml
		event.renderData( type="plain", data=feed, contentType="text/xml" );
	}

	/**
	* Comment Form Post
	*/
	function commentPost( event, rc, prc ){
		// incoming params
		event.paramValue( "entrySlug", "" );
		// Try to retrieve entry by slug
		var thisEntry = entryService.findBySlug( rc.entrySlug );
		// If null, kick them out
		if( isNull( thisEntry ) ){ 
			setNextEvent( prc.cbEntryPoint ); 
		}
		// validate incoming comment post
		validateCommentPost( event, rc, prc, thisEntry );
		// Valid commenting, so go and save
		saveComment( thisContent=thisEntry, subscribe=rc.subscribe, prc=prc );
	}

}