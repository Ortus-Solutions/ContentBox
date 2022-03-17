/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage Generic content actions
 */
component extends="baseHandler" {

	// Dependencies
	property name="contentService" inject="contentService@contentbox";
	property name="statsService" inject="statsService@contentbox";
	property name="contentStoreService" inject="contentStoreService@contentbox";
	property name="authorService" inject="authorService@contentbox";

	/**
	 * Quick Content Preview from editors
	 *
	 * @return html
	 */
	function preview( event, rc, prc ){
		// param incoming data
		event
			.paramValue( "layout", "pages" )
			.paramValue( "content", "" )
			.paramValue( "contentType", "" )
			.paramValue( "title", "" )
			.paramValue( "slug", "" )
			.paramValue( "markup", "HTML" )
			.paramValue( "parentContent", "" );

		// Determine Type
		switch ( rc.contentType ) {
			case "Page": {
				prc.xehPreview = variables.CBHelper.linkPage( "__page_preview" );
				break;
			}
			case "Entry": {
				prc.xehPreview = variables.CBHelper.linkPage( "__entry_preview" );
				rc.layout      = "blog";
				break;
			}
			case "ContentStore": {
				var oContent = contentStoreService.new();
				prc.preview  = oContent.renderContentSilent( rc.content );
				event.setView( view = "content/simplePreview", layout = "ajax" );
				return;
			}
		}
		// author security hash
		prc.h = hash( prc.oCurrentAuthor.getAuthorID() );
		// full preview view
		event.setView( view = "content/preview", layout = "ajax" );
	}

	/**
	 * Global Content Search
	 *
	 * @return html
	 */
	function search( event, rc, prc ){
		// Params
		event.paramValue( "search", "" );

		// Determine Context via `:` Search string
		prc.context      = "";
		prc.contentTypes = "page,entry,contentstore";
		if ( find( ":", rc.search ) ) {
			prc.context = listFirst( rc.search, ":" );
			rc.search   = listLast( rc.search, ":" );
		}

		// Determine search via context or none at all
		if ( !len( prc.context ) || listFindNoCase( prc.contentTypes, prc.context ) ) {
			// Search for content
			prc.results = variables.contentService.searchContent(
				searchTerm         : rc.search,
				max                : prc.cbSettings.cb_admin_quicksearch_max,
				sortOrder          : "title",
				isPublished        : "all",
				searchActiveContent: false,
				contentTypes       : prc.context,
				siteID             : prc.oCurrentSite.getsiteID()
			);
			prc.minContentCount = (
				prc.results.count lt prc.cbSettings.cb_admin_quicksearch_max ? prc.results.count : prc.cbSettings.cb_admin_quicksearch_max
			);
		} else {
			prc.results         = { "count" : 0, "content" : [] };
			prc.minContentCount = 0;
		}

		// Search for Authors
		if ( !len( prc.context ) || listFindNoCase( "author", prc.context ) ) {
			prc.authors        = authorService.search( searchTerm: rc.search, max: prc.cbSettings.cb_admin_quicksearch_max );
			prc.minAuthorCount = (
				prc.authors.count lt prc.cbSettings.cb_admin_quicksearch_max ? prc.authors.count : prc.cbSettings.cb_admin_quicksearch_max
			);
		} else {
			prc.authors        = { "count" : 0, "authors" : [] };
			prc.minAuthorCount = 0;
		}

		// cb helper on scope
		prc.cb = variables.CBHelper;
		// announce event
		announce( "onGlobalSearchRequest" );
		// renderdata
		event.renderdata( data = renderView( "content/search" ) );
	}

	/**
	 * Check if a slug is unique
	 *
	 * @return json
	 */
	function slugUnique( event, rc, prc ){
		// Params
		param rc.slug        = "";
		param rc.contentID   = "";
		param rc.contentType = "";

		var data = { "UNIQUE" : false };

		if ( len( rc.slug ) ) {
			data[ "UNIQUE" ] = variables.contentService.isSlugUnique(
				slug       : rc.slug,
				contentID  : rc.contentID,
				siteID     : prc.oCurrentSite.getsiteID(),
				contentType: rc.contentType
			);
		}

		event.renderData( data = data, type = "json" );
	}

	/**
	 * Render the content selector from editors
	 *
	 * @return html
	 */
	function relatedContentSelector( event, rc, prc ){
		// paging default
		event
			.paramValue( "page", 1 )
			.paramValue( "search", "" )
			.paramValue( "clear", false )
			.paramValue( "excludeIDs", "" )
			.paramValue( "contentType", "" );

		// exit handlers
		prc.xehRelatedContentSelector = "#prc.cbAdminEntryPoint#.content.relatedContentSelector";

		// prepare paging object
		prc.oPaging    = getInstance( "Paging@contentbox" );
		prc.paging     = prc.oPaging.getBoundaries();
		prc.pagingLink = "javascript:pagerLink( @page@, '#rc.contentType#' )";

		// search entries with filters and all
		var contentResults = variables.contentService.searchContent(
			searchTerm         : rc.search,
			offset             : prc.paging.startRow - 1,
			max                : prc.cbSettings.cb_paging_maxrows,
			sortOrder          : ( rc.contentType == "Entry" ? "publishedDate desc" : "slug asc" ),
			searchActiveContent: false,
			contentTypes       : rc.contentType,
			excludeIDs         : rc.excludeIDs,
			siteID             : prc.oCurrentSite.getsiteID()
		);

		// setup data for display
		prc.content      = contentResults.content;
		prc.contentCount = contentResults.count;
		prc.CBHelper     = variables.CBHelper;

		// if ajax and searching, just return tables
		return renderView( view = "content/relatedContentResults", module = "contentbox-admin" );
	}

	/**
	 * Show the related content panel
	 *
	 * @return html
	 */
	function showRelatedContentSelector( event, rc, prc ){
		event
			.paramValue( "search", "" )
			.paramValue( "clear", false )
			.paramValue( "excludeIDs", "" )
			.paramValue( "contentType", "Page,Entry,ContentStore" );

		// exit handlers
		prc.xehRelatedContentSelector = "#prc.cbAdminEntryPoint#.content.relatedContentSelector";
		prc.CBHelper                  = variables.CBHelper;

		event.setView( view = "content/relatedContentSelector", layout = "ajax" );
	}

	/**
	 * Break related content links
	 *
	 * @return json
	 */
	function breakContentLink( event, rc, prc ){
		event.paramValue( "contentID", "" ).paramValue( "linkedID", "" );

		var data = {};
		if ( len( rc.contentID ) && len( rc.linkedID ) ) {
			var currentContent = variables.contentService.get( rc.contentID );
			var linkedContent  = variables.contentService.get( rc.linkedID );

			linkedContent.removeRelatedContent( currentContent );
			variables.contentService.save( linkedContent );

			data[ "SUCCESS" ] = true;
		}
		event.renderData( data = data, type = "json" );
	}

	/**
	 * Reset Content Hits on one or more content items
	 *
	 * @return json
	 */
	any function resetHits( event, rc, prc ){
		event.paramValue( "contentID", "" );
		// build to array and iterate
		listToArray( rc.contentID )
			// Build out each content object
			.map( function( thisId ){
				return variables.contentService.get( arguments.thisId );
			} )
			// Filter only loaded and content objects that have stats already
			.filter( function( thisContent ){
				return ( !isNull( arguments.thisContent ) && arguments.thisContent.hasStats() );
			} )
			// Reset Hits
			.each( function( thisContent ){
				variables.contentService.save( arguments.thisContent.getStats().setHits( 0 ) );
				event.getResponse().addMessage( "Hits reset for (#arguments.thisContent.getTitle()#)" );
			} );
	}

	/**
	 * This viewlet shows latest content edits via arguments
	 *
	 * @author              The optional author to look for latest edits only
	 * @author.generic      contentbox.models.security.Author
	 * @isPublished         Boolean indicator if you need to search on all published states, only published, or only draft
	 * @max                 The maximum number of records, capped at 25 by default
	 * @showHits            Show hit count on content item, defaults to true
	 * @colorCodings        Show content row color codings
	 * @showPublishedStatus Show published status columns
	 * @showAuthor          Show the author in the table
	 *
	 * @return html
	 */
	function latestContentEdits(
		event,
		rc,
		prc,
		any author,
		boolean isPublished,
		numeric max                 = 25,
		boolean showHits            = true,
		boolean colorCodings        = true,
		boolean showPublishedStatus = true,
		boolean showAuthor          = true
	){
		// Setup args so we can use them in the viewlet
		var args = {
			max    : arguments.max,
			siteID : prc.oCurrentSite.getsiteID()
		};
		if ( structKeyExists( arguments, "author" ) ) {
			args.author = arguments.author;
		}
		if ( structKeyExists( arguments, "isPublished" ) ) {
			args.isPublished = arguments.isPublished;
		}

		// Add Site context if `author` is not passed
		if ( isNull( args.author ) ) {
			args.siteID = prc.oCurrentSite.getsiteID();
		}

		// Get latest content edits with criteria
		var aLatestEdits = variables.contentService.getLatestEdits( argumentCollection = args );

		// view pager
		return renderView(
			view   = "content/contentViewlet",
			module = "contentbox-admin",
			args   = {
				viewletID           : createUUID(),
				aContent            : aLatestEdits,
				showHits            : arguments.showHits,
				colorCodings        : arguments.colorCodings,
				showPublishedStatus : arguments.showPublishedStatus,
				showAuthor          : arguments.showAuthor
			}
		);
	}

	/**
	 * This viewlet shows future or expired content using filters. By default it shows future published content
	 *
	 * @author              The optional author to look for latest edits only
	 * @author.generic      contentbox.models.security.Author
	 * @showExpired         Show expired content, defaults to false (future published content)
	 * @offset              The offset when doing pagination
	 * @max                 The maximum number of records, capped at 25 by default
	 * @showHits            Show hit count on content item, defaults to true
	 * @colorCodings        Show content row color codings
	 * @showPublishedStatus Show published status columns
	 * @showAuthor          Show the author in the table
	 *
	 * @return html
	 */
	function contentByPublishedStatus(
		event,
		rc,
		prc,
		boolean showExpired = false,
		any author,
		boolean offset              = 0,
		numeric max                 = 25,
		boolean showHits            = true,
		boolean colorCodings        = true,
		boolean showPublishedStatus = true,
		boolean showAuthor          = true
	){
		// Setup args so we can use them in the viewlet
		var args = {
			max    : arguments.max,
			offset : arguments.offset,
			siteID : prc.oCurrentSite.getsiteID()
		};
		if ( structKeyExists( arguments, "author" ) ) {
			args.author = arguments.author;
		}

		// Expired Content
		var aContent = "";
		if ( arguments.showExpired ) {
			aContent = variables.contentService.findExpiredContent( argumentCollection = args );
		}
		// Future Published Content
		else {
			aContent = variables.contentService.findFuturePublishedContent( argumentCollection = args );
		}

		// view pager
		return renderView(
			view   = "content/contentViewlet",
			module = "contentbox-admin",
			args   = {
				viewletID           : createUUID(),
				aContent            : aContent,
				showHits            : arguments.showHits,
				colorCodings        : arguments.colorCodings,
				showPublishedStatus : arguments.showPublishedStatus,
				showAuthor          : arguments.showAuthor
			}
		);
	}

}
