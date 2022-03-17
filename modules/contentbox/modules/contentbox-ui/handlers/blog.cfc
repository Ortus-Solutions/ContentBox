/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Handler For ContentBox blog pages
 */
component extends="content" {

	// DI
	property name="entryService" inject="id:entryService@contentbox";
	property name="paginator" inject="Paging@contentbox";

	// Pre Handler Exceptions
	this.preHandler_except = "preview";

	/**
	 * Pre Handler
	 */
	function preHandler( event, rc, prc, action, eventArguments ){
		// Check if disabled?
		if ( !prc.oCurrentSite.getIsBlogEnabled() ) {
			event.overrideEvent( "contentbox-ui:blog.disabled" );
		}
		// super call
		super.preHandler( argumentCollection = arguments );
	}

	/**
	 * Action if blog is disabled
	 */
	function disabled( event, rc, prc ){
		// missing page, the blog as it does not exist
		prc.missingPage      = event.getCurrentRoutedURL();
		prc.missingRoutedURL = event.getCurrentRoutedURL();

		// set 404 headers
		event.setHTTPHeader( "404", "Page not found" );

		// set skin not found
		event
			.setLayout( name = "#prc.cbTheme#/layouts/pages", module = prc.cbThemeRecord.module )
			.setView( view = "#prc.cbTheme#/views/notfound", module = prc.cbThemeRecord.module );
	}

	/**
	 * Preview a blog entry
	 */
	function preview( event, rc, prc ){
		// Run parent preview
		super.preview( argumentCollection = arguments );
		// Concrete Overrides Below

		// Construct the preview entry according to passed arguments
		prc.entry = variables.entryService.new( {
			title         : rc.title,
			slug          : rc.slug,
			publishedDate : now(),
			allowComments : false,
			cache         : false,
			markup        : rc.markup,
			site          : variables.siteService.getOrFail( rc.siteID )
		} );
		// Comments need to be empty
		prc.comments = [];
		// Create preview version
		prc.entry.addNewContentVersion(
			content   = urlDecode( rc.content ),
			author    = prc.oCurrentAuthor,
			isPreview = true
		);

		// set skin view
		event
			.setLayout( name = "#prc.cbTheme#/layouts/#rc.layout#", module = prc.cbThemeRecord.module )
			.setView( view = "#prc.cbTheme#/views/entry", module = prc.cbThemeRecord.module );
	}

	/**
	 * The blog home page
	 */
	function index( event, rc, prc ){
		// incoming params
		event
			.paramValue( "page", 1 )
			.paramValue( "category", "" )
			.paramValue( "q", "" )
			.paramValue( "format", "html" );

		// Page numeric check
		if ( !isNumeric( rc.page ) ) {
			rc.page = 1;
		}

		// prepare paging object
		prc.oPaging          = variables.paginator;
		prc.pagingBoundaries = prc.oPaging.getBoundaries( pagingMaxRows: prc.cbSettings.cb_paging_maxentries );
		prc.blogLink         = variables.CBHelper.linkBlog();
		prc.pagingLink       = prc.blogLink & "?page=@page@";

		// Search Paging Link Override?
		if ( len( rc.q ) ) {
			rc.q           = variables.antiSamy.clean( rc.q );
			prc.pagingLink = prc.blogLink & "/search/#rc.q#/@page@?";
		}

		// Category Filter Link Override
		if ( len( rc.category ) ) {
			rc.category    = variables.antiSamy.clean( rc.category );
			prc.pagingLink = prc.blogLink & "/category/#rc.category#/@page@?";
		}

		// get published entries
		var entryResults = variables.entryService.findPublishedContent(
			offset    : prc.pagingBoundaries.startRow - 1,
			max       : prc.cbSettings.cb_paging_maxentries,
			category  : rc.category,
			searchTerm: rc.q,
			siteID    : prc.oCurrentSite.getsiteID()
		);
		prc.entries      = entryResults.content;
		prc.entriesCount = entryResults.count;

		// announce event
		announce( "cbui_onIndex", { entries : prc.entries, entriesCount : prc.entriesCount } );

		// Export Formats?
		switch ( rc.format ) {
			case "json": {
				event.renderData(
					type = rc.format,
					data = prc.entries.map( function( thisEntry ){
						return arguments.thisEntry.getMemento( profile = "response" )
					} ),
					xmlRootName = "entries"
				);
				break;
			}
			default: {
				// set skin view
				event
					.setLayout( name = "#prc.cbTheme#/layouts/blog", module = prc.cbThemeRecord.module )
					.setView( view = "#prc.cbTheme#/views/index", module = prc.cbThemeRecord.module );
			}
		}
	}

	/**
	 * The archives
	 */
	function archives( event, rc, prc ){
		// incoming params
		event
			.paramValue( "page", 1 )
			.paramValue( "year", 0 )
			.paramValue( "month", 0 )
			.paramValue( "day", 0 )
			.paramValue( "format", "html" );

		// Page numeric check
		if ( !isNumeric( rc.page ) ) {
			rc.page = 1;
		}

		// prepare paging object
		prc.oPaging          = variables.paginator;
		prc.pagingBoundaries = prc.oPaging.getBoundaries( pagingMaxRows = prc.cbSettings.cb_paging_maxentries );
		prc.pagingLink       = event.getCurrentRoutedURL() & "?page=@page@";

		// get published entries
		var entryResults = variables.entryService.findPublishedEntriesByDate(
			year   = rc.year,
			month  = rc.month,
			day    = rc.day,
			offset = prc.pagingBoundaries.startRow - 1,
			max    = prc.cbSettings.cb_paging_maxentries,
			siteID = prc.oCurrentSite.getsiteID()
		);
		prc.entries      = entryResults.entries;
		prc.entriesCount = entryResults.count;

		// announce event
		announce( "cbui_onArchives", { entries : prc.entries, entriesCount : prc.entriesCount } );

		// Export Formats?
		switch ( rc.format ) {
			case "json": {
				event.renderData(
					type = rc.format,
					data = prc.entries.map( function( thisEntry ){
						return arguments.thisEntry.getMemento( profile: "response" )
					} ),
					xmlRootName = "entries"
				);
				break;
			}
			default: {
				// set skin view
				event
					.setLayout( name = "#prc.cbTheme#/layouts/blog", module = prc.cbThemeRecord.module )
					.setView( view = "#prc.cbTheme#/views/archives", module = prc.cbThemeRecord.module );
			}
		}
	}

	/**
	 * Around entry page advice that provides caching and multi-output format
	 */
	function aroundEntry( event, rc, prc, eventArguments ){
		// setup wrap arguments
		arguments.contentCaching = prc.cbSettings.cb_entry_caching;
		arguments.action         = variables.entry;

		return wrapContentAdvice( argumentCollection = arguments );
	}

	/**
	 * An entry page
	 */
	function entry( event, rc, prc ){
		// incoming params
		event.paramValue( "entrySlug", "" );

		// get the author
		var showUnpublished = false;
		if ( prc.oCurrentAuthor.isLoaded() AND prc.oCurrentAuthor.isLoggedIn() ) {
			var showUnpublished = true;
		}
		prc.entry = variables.entryService.findBySlug(
			slug           : rc.entrySlug,
			showUnpublished: showUnpublished,
			siteID         : prc.oCurrentSite.getsiteID()
		);

		// Check if loaded, else not found
		if ( prc.entry.isLoaded() ) {
			// Record hit
			variables.entryService.updateHits( prc.entry );
			// Retrieve Comments
			// TODO: paging
			var commentResults = variables.commentService.findAllApproved(
				contentID: prc.entry.getContentID(),
				sortOrder: "asc"
			);
			prc.comments      = commentResults.comments;
			prc.commentsCount = commentResults.count;
			// announce event
			announce( "cbui_onEntry", { entry : prc.entry, entrySlug : rc.entrySlug } );
			// set skin view
			event
				.setLayout( name = "#prc.cbTheme#/layouts/blog", module = prc.cbThemeRecord.module )
				.setView( view = "#prc.cbTheme#/views/entry", module = prc.cbThemeRecord.module );
		} else {
			// announce event
			announce( "cbui_onEntryNotFound", { entry : prc.entry, entrySlug : rc.entrySlug } );
			// missing page
			prc.missingPage = rc.entrySlug;
			// set 404 headers
			event.setHTTPHeader( "404", "Entry not found" );
			// set skin not found
			event
				.setLayout( name = "#prc.cbTheme#/layouts/blog", module = prc.cbThemeRecord.module )
				.setView( view = "#prc.cbTheme#/views/notfound", module = prc.cbThemeRecord.module );
		}
	}

	/**
	 * Display the RSS feeds for the blog
	 */
	function rss( event, rc, prc ){
		// params
		event
			.paramValue( "category", "" )
			.paramValue( "entrySlug", "" )
			.paramValue( "commentRSS", false );

		// Build out the blog RSS feeds
		var feed = variables.RSSService.getRSS(
			comments   : rc.commentRSS,
			category   : rc.category,
			slug       : rc.entrySlug,
			contentType: "Entry",
			siteID     : prc.oCurrentSite.getsiteID()
		);

		// Render out the feed xml
		rc.format = "rss";
		event.renderData(
			type        = "plain",
			data        = feed,
			contentType = "text/xml"
		);
	}

	/**
	 * Comment Form Post
	 */
	function commentPost( event, rc, prc ){
		// incoming params
		event.paramValue( "entrySlug", "" );
		// Try to retrieve entry by slug
		var thisEntry = variables.entryService.findBySlug( slug: rc.entrySlug, siteID: prc.oCurrentSite.getsiteID() );
		// If null, kick them out
		if ( isNull( thisEntry ) ) {
			relocate( prc.cbEntryPoint );
		}
		// validate incoming comment post
		validateCommentPost( event, rc, prc, thisEntry );
		// Valid commenting, so go and save
		saveComment(
			thisContent = thisEntry,
			subscribe   = rc.subscribe,
			prc         = prc
		);
	}

}
