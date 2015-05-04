/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
* The main ContentBox engine handler
*/
component extends="content" singleton{

	// DI
	property name="pageService"			inject="id:pageService@cb";
	property name="searchService"		inject="id:SearchService@cb";
	property name="securityService"		inject="id:securityService@cb";
	property name="mobileDetector"		inject="id:mobileDetector@cb";
	property name="layoutService"		inject="id:LayoutService@cb";
	property name="utility"				inject="coldbox:plugin:Utilities";
	
	// Pre Handler Exceptions
	this.preHandler_except = "preview";
	
	// pre Handler
	function preHandler(event, action, eventArguments, rc, prc ){
		super.preHandler( argumentCollection = arguments );
	}

	/**
	* Preview a page
	*/
	function preview( event, rc, prc ){
		// Run parent preview
		super.preview( argumentCollection = arguments );
		
		// Construct the preview entry according to passed arguments
		prc.page = pageService.new();
		prc.page.setTitle( rc.title );
		prc.page.setSlug( rc.slug );
		prc.page.setPublishedDate( now() );
		prc.page.setAllowComments( false );
		prc.page.setCache( false );
		prc.page.setMarkup( rc.markup );
		prc.page.setLayout( rc.layout );
		// Comments need to be empty
		prc.comments = [];
		// Create preview version
		prc.page.addNewContentVersion( content=URLDecode( rc.content ), author=prc.author )
			.setActiveContent( prc.page.getContentVersions() );
		// Do we have a parent?
		if( len( rc.parentPage ) && isNumeric( rc.parentPage ) ){
			var parent = pageService.get( rc.parentPage );
			if( !isNull( parent ) ){ prc.page.setParent( parent ); }
		}
		// set skin view
		switch( rc.layout ){
			case "-no-layout-" : {
				return prc.page.renderContent();
			}
			default : {
				event.setLayout( name="#prc.cbLayout#/layouts/#prc.page.getLayoutWithInheritance()#", module="contentbox" )
					.setView( view="#prc.cbLayout#/views/page", module="contentbox" );
			}
		} 
	}
	
	/**
	* Around entry page advice that provides caching and multi-output format
	*/
	function aroundIndex( event, rc, prc , eventArguments ){
		// setup wrap arguments
		arguments.contentCaching 	= prc.cbSettings.cb_content_caching;
		arguments.action 			= variables.index;

		return wrapContentAdvice( argumentCollection = arguments );
	}
	
	/**
	* Present pages
	*/
	function index( event, rc, prc ){
		// incoming params
		event.paramValue( "pageSlug", "" );
		var incomingURL  = "";
		// Do we have an override page setup by the settings?
		if( !structKeyExists( prc, "pageOverride" ) ){
			// Try slug parsing for hiearchical URLs
			incomingURL  = rereplaceNoCase( event.getCurrentRoutedURL(), "\/$", "" );
		} else {
			incomingURL	 = prc.pageOverride;
		}
		// Entry point cleanup
		if( len( prc.cbEntryPoint ) ){
			incomingURL = replacenocase( incomingURL, prc.cbEntryPoint & "/", "" );
		}
		// get the author and do publish unpublished tests
		var author = securityService.getAuthorSession();
		var showUnpublished = false;
		if( author.isLoaded() AND author.isLoggedIn() ){
			var showUnpublished = true;
		}
		// Try to get the page using the incoming URI
		prc.page = pageService.findBySlug( incomingURL, showUnpublished );
		// Check if loaded and also the ancestry is ok as per hiearchical URls
		if( prc.page.isLoaded() ){
			// Verify SSL?
			if( prc.page.getSSLOnly() and !event.isSSL() ){
				log.warn( "Page requested: #incomingURL# without SSL and SSL required. Relocating..." );
				setNextEvent( event=incomingURL, ssl=true );
				return;
			}
			// Record hit
			pageService.updateHits( prc.page.getContentID() );
			// Retrieve Comments
			// TODO: paging
			var commentResults 	= commentService.findApprovedComments( contentID=prc.page.getContentID(), sortOrder="asc" );
			prc.comments 		= commentResults.comments;
			prc.commentsCount 	= commentResults.count;
			// Detect Mobile Device
			var isMobileDevice 	= mobileDetector.isMobile();
			// announce event
			announceInterception( "cbui_onPage", { page=prc.page, isMobile=isMobileDevice } );
			// Use the mobile or standard layout
			var thisLayout = ( isMobileDevice ? prc.page.getMobileLayoutWithInheritance() : prc.page.getLayoutWithInheritance() );
			// Verify chosen page layout exists in theme, just in case they moved theme so we can produce a good error message
			verifyPageLayout( thisLayout );
			// Verify No Layout
			if( thisLayout eq '-no-layout-' ){
				return prc.page.renderContent();
			} else {
				// set skin view
				event.setLayout( name="#prc.cbLayout#/layouts/#thisLayout#", module="contentbox" )
					.setView( view="#prc.cbLayout#/views/page", module="contentbox" );
			}
		} else {
			// missing page
			prc.missingPage 	 = incomingURL;
			prc.missingRoutedURL = event.getCurrentRoutedURL();
			// announce event
			announceInterception( "cbui_onPageNotFound", {page=prc.page, missingPage=prc.missingPage, routedURL=prc.missingRoutedURL} );
			// set skin not found
			event.setLayout( name="#prc.cbLayout#/layouts/pages", module="contentbox" )
				.setView( view="#prc.cbLayout#/views/notfound", module="contentbox" )
				.setHTTPHeader( "404", "Page not found" );				
		}
	}

	/**
	* Content Search
	*/
	function search( event, rc, prc ){
		// incoming params
		event.paramValue( "page", 1 );
		event.paramValue( "q", "" );

		// cleanup
		rc.q = HTMLEditFormat( trim( rc.q ) );

		// prepare paging plugin
		prc.pagingPlugin 		= getMyPlugin( plugin="Paging", module="contentbox" );
		prc.pagingBoundaries	= prc.pagingPlugin.getBoundaries( pagingMaxRows=prc.cbSettings.cb_search_maxResults );
		prc.pagingLink 			= CBHelper.linkContentSearch() & "/#URLEncodedFormat( rc.q )#/@page@";
		
		// get search results
		if( len( rc.q ) ){
			var searchAdapter = searchService.getSearchAdapter();
			prc.searchResults = searchAdapter.search( offset=prc.pagingBoundaries.startRow-1,
												      max=prc.cbSettings.cb_search_maxResults,
												   	  searchTerm=rc.q );
			prc.searchResultsContent = searchAdapter.renderSearchWithResults( prc.searchResults );
		}
		else{
			prc.searchResults = getModel( "SearchResults@cb" );
			prc.searchResultsContent = "Please enter a search term to search on.";
		}
		
		// set skin search
		event.setLayout( name="#prc.cbLayout#/layouts/#layoutService.getThemeSearchLayout()#", module="contentbox" )
			.setView( view="#prc.cbLayout#/views/search", module="contentbox" );
			
		// announce event
		announceInterception( "cbui_onContentSearch", { searchResults=prc.searchResults, searchResultsContent=prc.searchResultsContent } );
	}


	/**
	* Display the RSS feeds
	*/
	function rss( event, rc, prc ){
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
	function commentPost( event, rc, prc ){
		// incoming params
		event.paramValue( "contentID", "" );
		// Try to retrieve page by contentID
		var page = pageService.get( rc.contentID );
		// If null, kick them out
		if( isNull( page ) ){ setNextEvent( prc.cbEntryPoint ); }
		// validate incoming comment post
		validateCommentPost( event, rc, prc, page );
		// Valid commenting, so go and save
		saveComment( page, rc.subscribe );
	}

	/************************************** PRIVATE *********************************************/

	/**
	* Verify if a chosen page layout exists or not.
	* @layout The layout to verify
	*/
	private function verifyPageLayout( required layout ){
		var excluded = "-no-layout-";
		// Verify exclusions
		if( listFindNoCase( excluded, arguments.layout ) ){ return; }
		// Verify layout
		if( !fileExists( expandPath( CBHelper.layoutRoot() & "/layouts/#arguments.layout#.cfm" ) ) ){
			throw( 
				message	= "The layout of the page: '#arguments.layout#' does not exist in the current theme.",
			    detail	= "Please verify your page layout settings",
				type 	= "ContentBox.InvalidPageLayout"
			);
		}
	}


}
