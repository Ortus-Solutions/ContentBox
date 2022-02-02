/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage Content display
 */
component {

	// DI
	property name="authorService" inject="id:authorService@contentbox";
	property name="categoryService" inject="id:categoryService@contentbox";
	property name="contentService" inject="id:contentService@contentbox";
	property name="commentService" inject="id:commentService@contentbox";
	property name="CBHelper" inject="id:CBHelper@contentbox";
	property name="rssService" inject="id:rssService@contentbox";
	property name="themeService" inject="id:themeService@contentbox";
	property name="antiSamy" inject="antisamy@cbantisamy";
	property name="messagebox" inject="id:messagebox@cbMessageBox";
	property name="dataMarshaller" inject="DataMarshaller@coldbox";
	property name="markdown" inject="Processor@cbmarkdown";
	property name="siteService" inject="siteService@contentbox";

	// Pre Handler Exceptions
	this.preHandler_except = "previewSite";

	/**
	 * Pre Handler
	 */
	function preHandler( event, rc, prc, action, eventArguments ){
		// Maintenance Mode?
		if ( prc.cbSettings.cb_site_maintenance ) {
			if ( prc.oCurrentAuthor.isLoggedIn() && prc.oCurrentAuthor.checkPermission( "MAINTENANCE_MODE_VIEWER" ) ) {
				addAsset( "#prc.cbRoot#/includes/js/maintenance.js" );
			} else {
				event.overrideEvent( "contentbox-ui:page.maintenance" );
				return;
			}
		}

		// Home page determination either blog or a page
		// Blog routes are in the blog namespace
		if (
			event.getCurrentRoute() eq "/" AND
			prc.oCurrentSite.getHomepage() neq "cbBlog" AND
			event.getCurrentRoutedNamespace() neq "blog"
		) {
			event.overrideEvent( "contentbox-ui:page.index" );
			prc.pageOverride = prc.oCurrentSite.getHomepage();
		}

		// If UI export is disabled, default to contentbox
		if ( !prc.cbSettings.cb_content_uiexport ) {
			rc.format = "html";
		}
	}

	/**
	 * Change the fwLocale
	 */
	function changeLang( event, rc, prc ){
		event.paramValue( "lang", "en_US" );
		setFWLocale( rc.lang );
		relocate( url = "/" );
	}

	/**
	 * Preview the site
	 */
	function previewSite( event, rc, prc ){
		// Param incoming data
		event.paramValue( "l", "" ).paramValue( "h", "" );

		// xss headers
		event.setHTTPHeader( name = "X-XSS-Protection", value = 0 );

		// valid Author?
		if (
			prc.oCurrentAuthor.isLoaded() AND
			prc.oCurrentAuthor.isLoggedIn() AND
			compareNoCase( hash( prc.oCurrentAuthor.getAuthorID() ), rc.h ) EQ 0
		) {
			// Place theme on scope
			prc.cbTheme     = rc.l;
			// Place theme root location
			prc.cbThemeRoot = prc.cbRoot & "/themes/" & rc.l;
			// Home page determination either blog or a page
			if ( prc.oCurrentSite.getHomepage() NEQ "cbBlog" ) {
				// Override event and incoming page.
				event.overrideEvent( "contentbox-ui:page.index" );
				prc.pageOverride = prc.oCurrentSite.getHomepage();
				// run it
				var eArgs        = { noCache : true };
				runEvent( event = "contentbox-ui:page.index", eventArguments = eArgs );
				// Override the layout
				event.setLayout( name = "#prc.cbTheme#/layouts/pages", module = prc.cbThemeRecord.module );
			} else {
				// Override layout and event so we can display it
				event.setLayout( "#rc.l#/layouts/blog" ).overrideEvent( "contentbox-ui:blog.index" );
				// run it
				runEvent( "contentbox-ui:blog.index" );
			}
		} else {
			// 	Invalid Credentials
			relocate( URL = CBHelper.linkBlog() );
		}
	}

	/**
	 * Go Into maintenance mode.
	 */
	function maintenance( event, rc, prc ){
		// If no maintenance view exists, just output data
		if ( !themeService.themeMaintenanceViewExists() ) {
			event.renderData( data = variables.markdown.toHTML( prc.cbSettings.cb_site_maintenance_message ) );
		} else {
			// output maintenance view
			event
				.setLayout(
					name   = "#prc.cbTheme#/layouts/#themeService.getThemeMaintenanceLayout()#",
					module = prc.cbThemeRecord.module
				)
				.setView( view = "#prc.cbTheme#/views/maintenance", module = prc.cbThemeRecord.module );
		}
	}

	/*
	 * Error Control
	 */
	function onError(
		event,
		rc,
		prc,
		faultAction,
		exception,
		eventArguments
	){
		// store exceptions
		prc.faultAction = arguments.faultAction;
		prc.exception   = arguments.exception;

		// announce event
		announce(
			"cbui_onError",
			{
				faultAction    : arguments.faultAction,
				exception      : arguments.exception,
				eventArguments : arguments.eventArguments
			}
		);

		// Set view to render
		event
			.setLayout( name = "#prc.cbTheme#/layouts/pages", module = prc.cbThemeRecord.module )
			.setView( view = "#prc.cbTheme#/views/error", module = prc.cbThemeRecord.module );
	}

	/************************************** PRIVATE *********************************************/

	/**
	 * Content display around advice that provides caching for content display and multi-format capabilities
	 *
	 * @event          Request context
	 * @rc             Request collection
	 * @prc            Private request collection
	 * @eventArguments Event arguments
	 * @action         The action to wrap
	 * @contentCaching Wether content caching is enabled or not
	 */
	private function wrapContentAdvice(
		required event,
		required rc,
		required prc,
		required eventArguments,
		required action,
		required boolean contentCaching
	){
		// param incoming multi UI formats
		event.paramValue( "format", "html" );
		// If UI export is disabled, default to contentbox
		if ( !prc.cbSettings.cb_content_uiexport ) {
			rc.format = "html";
		}

		// Caching Enabled? Then test if data is in cache.
		var cacheEnabled = (
			arguments.contentCaching AND
			!structKeyExists( eventArguments, "noCache" ) AND
			!event.valueExists( "cbCache" ) AND
			!flash.exists( "commentErrors" )
		);
		if ( cacheEnabled ) {
			// Get appropriate cache provider from settings
			var cache    = cacheBox.getCache( prc.cbSettings.cb_content_cacheName );
			var cacheKey = "";
			// Do we have an override page setup by the settings?
			if ( structKeyExists( prc, "pageOverride" ) and len( prc.pageOverride ) ) {
				cacheKey = "cb-content-wrapper-#cgi.HTTP_HOST#-#prc.pageOverride#/";
			} else {
				cacheKey = "cb-content-wrapper-#cgi.HTTP_HOST#-#left( event.getCurrentRoutedURL(), 500 )#";
			}

			// Incorporate internal hash + rc distinct hash + formats
			cacheKey &= hash( ".#getFWLocale()#.#rc.format#.#event.isSSL()#" & prc.cbox_incomingContextHash );

			// get content data from cache
			prc.contentCacheData = cache.get( cacheKey );
			// if NOT null and caching enabled and noCache event argument does not exist and no incoming cbCache URL arg, then cache
			if ( !isNull( prc.contentCacheData ) ) {
				// Set cache headers if allowed
				if ( prc.cbSettings.cb_content_cachingHeader ) {
					event
						.setHTTPHeader(
							statusCode = "203",
							statustext = "ContentBoxCache Non-Authoritative Information"
						)
						.setHTTPHeader( name = "x-contentbox-cached-content", value = "true" );
				}
				// Store hits
				variables.contentService.updateHits( prc.contentCacheData.contentID );
				// return cache content to be displayed
				event.renderData(
					data        = prc.contentCacheData.content,
					contentType = prc.contentCacheData.contentType,
					isBinary    = prc.contentCacheData.isBinary
				);
				// Breakout, cached output is done my young padawan learner!
				return;
			}
		}

		// Prepare data packet for rendering and caching and more
		var data = {
			contentID   : "",
			contentType : "text/html",
			isBinary    : false
		};
		// Prepare args for action execution
		var args = {
			event : arguments.event,
			rc    : arguments.rc,
			prc   : arguments.prc
		};
		structAppend( args, arguments.eventArguments );
		// execute the wrapped action
		data.content = arguments.action( argumentCollection = args );

		// Check for missing page? If so, just return, no need to do multiple formats or caching for a missing page
		if ( structKeyExists( prc, "missingPage" ) ) {
			return;
		}

		// Get the content object required: page or entry
		var oContent = ( structKeyExists( prc, "page" ) ? prc.page : prc.entry );

		// generate content only if content is not set, else means handler generated content.
		if ( isNull( data.content ) ) {
			data.content = renderLayout(
				layout = "#prc.cbTheme#/layouts/#themeService.getThemePrintLayout(
					format = rc.format,
					layout = listLast( event.getCurrentLayout(), "/" )
				)#",
				module     = prc.cbThemeRecord.module,
				viewModule = prc.cbThemeRecord.module
			);
		}

		// Multi format generation
		switch ( rc.format ) {
			case "pdf": {
				data.content     = dataMarshaller.marshallData( data = data.content, type = "pdf" );
				data.contentType = "application/pdf";
				data.isBinary    = true;
				break;
			}
			case "doc": {
				data.contentType = "application/msword";
				data.isBinary    = false;
				break;
			}
			case "json": {
				data.content = dataMarshaller.marshallData(
					data = oContent.getMemento( profile: "response" ),
					type = "json"
				);
				data.contentType = "application/json";
				data.isBinary    = false;
				break;
			}
			default: {
				data.contentType = "text/html";
				data.isBinary    = false;
			}
		}

		// Tell renderdata to render it
		event.renderData(
			data        = data.content,
			contentType = data.contentType,
			isBinary    = data.isBinary
		);

		// verify if caching is possible by testing the content parameters
		if ( cacheEnabled AND oContent.isLoaded() AND oContent.getCache() AND oContent.isContentPublished() ) {
			// store content ID as we have it by now
			data.contentID = oContent.getContentID();
			// Cache data
			cache.set(
				cachekey,
				data,
				( oContent.getCacheTimeout() eq 0 ? prc.cbSettings.cb_content_cachingTimeout : oContent.getCacheTimeout() ),
				(
					oContent.getCacheLastAccessTimeout() eq 0 ? prc.cbSettings.cb_content_cachingTimeoutIdle : oContent.getCacheLastAccessTimeout()
				)
			);
		}
	}

	/**
	 * Preview content page super event. Only called internally
	 */
	private function preview( event, rc, prc ){
		// Param incoming data
		event
			.paramValue( "content", "" )
			.paramValue( "contentType", "" )
			.paramValue( "layout", "" )
			.paramValue( "title", "" )
			.paramValue( "slug", "" )
			.paramValue( "h", "" )
			.paramValue( "siteID", "" );

		// valid Author?
		if (
			!prc.oCurrentAuthor.isLoaded() OR
			!prc.oCurrentAuthor.isLoggedIn() OR
			compareNoCase( hash( prc.oCurrentAuthor.getAuthorID() ), rc.h ) NEQ 0
		) {
			// Not an author, kick them out.
			relocate( URL = "/" );
		}

		// xss headers
		event.setHTTPHeader( name = "X-XSS-Protection", value = 0 );
	}

	/**
	 * Validate incoming comment post, if not valid, it redirects back
	 *
	 * @thisContent The content object to validate the comment post for
	 *
	 * @return content handler
	 */
	private function validateCommentPost(
		required event,
		required rc,
		required prc,
		required thisContent
	){
		// param values
		event
			.paramValue( "author", "" )
			.paramValue( "authorURL", "" )
			.paramValue( "authorEmail", "" )
			.paramValue( "content", "" )
			.paramValue( "subscribe", false );

		// Check if comments enabled? else kick them out, who knows how they got here
		if ( NOT CBHelper.isCommentsEnabled( arguments.thisContent ) ) {
			messagebox.warn( "Comments are disabled! So you can't post any!" );
			relocate( URL = CBHelper.linkContent( arguments.thisContent ) );
		}

		// Trim values & XSS Cleanup of fields
		rc.author      = left( antiSamy.htmlSanitizer( trim( rc.author ) ), 100 );
		rc.authorEmail = left( antiSamy.htmlSanitizer( trim( rc.authorEmail ) ), 255 );
		rc.authorURL   = left( antiSamy.htmlSanitizer( trim( rc.authorURL ) ), 255 );
		rc.content     = antiSamy.htmlSanitizer( xmlFormat( trim( rc.content ) ) );

		// Validate incoming data
		var commentErrors = [];
		if ( !len( rc.author ) ) {
			arrayAppend( commentErrors, "Your name is missing!" );
		}
		if ( !len( rc.authorEmail ) OR NOT isValid( "email", rc.authorEmail ) ) {
			arrayAppend( commentErrors, "Your email is missing or is invalid!" );
		}
		if ( len( rc.authorURL ) AND NOT isValid( "URL", rc.authorURL ) ) {
			arrayAppend( commentErrors, "Your website URL is invalid!" );
		}
		if ( !len( rc.content ) ) {
			arrayAppend( commentErrors, "Please provide a comment!" );
		}

		// announce event
		announce(
			"cbui_preCommentPost",
			{
				commentErrors : commentErrors,
				content       : arguments.thisContent,
				contentType   : arguments.thisContent.getContentType()
			}
		);

		// Store errors if found
		if ( arrayLen( commentErrors ) ) {
			// Flash errors
			flash.put(
				name         = "commentErrors",
				value        = commentErrors,
				inflateTOPRC = true
			);
			// Message
			messagebox.warn( arrayToList( commentErrors, "<br>" ) );
			// Redirect
			relocate(
				URL     = CBHelper.linkComments( arguments.thisContent ),
				persist = "author,authorEmail,authorURL,content"
			);
			return;
		}
	}

	/**
	 * Save the comment for a content object
	 *
	 * @thisContent.hint The content object
	 * @subscribe        Subscribing to comments or not
	 * @prc              The prc reference
	 */
	private function saveComment(
		required thisContent,
		required subscribe = false,
		required prc
	){
		// Get new comment to persist
		var comment = populateModel( model: commentService.new(), exclude: "commentID" );
		// relate it to content
		comment.setRelatedContent( arguments.thisContent );
		// save it
		var results = commentService.saveComment( comment = comment, loggedInUser = prc.oCurrentAuthor );

		// announce event
		announce(
			"cbui_onCommentPost",
			{
				comment           : comment,
				content           : arguments.thisContent,
				moderationResults : results,
				contentType       : arguments.thisContent.getContentType(),
				subscribe         : arguments.subscribe
			}
		);

		// Check if all good
		if ( results.moderated ) {
			// Message that comment was moderated
			flash.put(
				name         = "commentErrors",
				value        = results.messages,
				inflateTOPRC = true
			);
			// Message
			messagebox.warn( arrayToList( results.messages, "<br>" ) );
			// relocate back to comments
			relocate( URL = CBHelper.linkComments( arguments.thisContent ) );
		} else {
			// relocate back to comment
			relocate( URL = CBHelper.linkComment( comment ) );
		}
	}

}
