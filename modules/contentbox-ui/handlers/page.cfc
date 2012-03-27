/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
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
component extends="BaseContentHandler" singleton{

	// DI
	property name="pageService"			inject="id:pageService@cb";
	property name="searchService"		inject="id:SearchService@cb";
	property name="securityService"		inject="id:securityService@cb";


	// pre Handler
	function preHandler(event,action,eventArguments){
		super.preHandler(argumentCollection=arguments);
	}

	/**
	* Around index to enable the caching aspects
	*/
	function aroundIndex(event,eventArguments){
		var rc = event.getCollection();
		var prc = event.getCollection(private=true);

		// if not caching, just return
		if( !prc.cbSettings.cb_content_caching ){
			index(event,rc,prc);
			return;
		}

		// Get appropriate cache provider
		var cache = cacheBox.getCache( prc.cbSettings.cb_content_cacheName );
		// Do we have an override page setup by the settings?
		if( !structKeyExists(prc,"pageOverride") ){
			// Try slug parsing for hiearchical URLs
			cacheKey = "cb-content-pagewrapper-#left(event.getCurrentRoutedURL(),255)#";
		}
		else{
			cacheKey = "cb-content-pagewrapper-#prc.pageOverride#";
		}

		// verify page wrapper
		var data = cache.get( cacheKey );
		if( !isNull(data) ){
			// set cache header
			event.setHTTPHeader(statusCode="203",statustext="ContentBoxCache Non-Authoritative Information");
			// return cache content
			return data;
		}

		// execute index
		index(event,rc,prc);

		// verify if caching is possible by testing the page, also, page with comments are not cached.
		if( prc.page.isLoaded() AND !prc.page.getAllowComments() AND prc.page.getCacheLayout() ){
			var data = controller.getPlugin("Renderer").renderLayout();
			cache.set(cachekey,
					  data,
					  (prc.page.getCacheTimeout() eq 0 ? prc.cbSettings.cb_content_cachingTimeout : prc.page.getCacheTimeout()),
					  (prc.page.getCacheLastAccessTimeout() eq 0 ? prc.cbSettings.cb_content_cachingTimeoutIdle : prc.page.getCacheLastAccessTimeout()) );
			return data;
		}
	}

	/**
	* Present pages
	*/
	function index(event,rc,prc){
		// incoming params
		event.paramValue("pageSlug","");
		var incomingURL  = "";
		// Do we have an override page setup by the settings?
		if( !structKeyExists(prc,"pageOverride") ){
			// Try slug parsing for hiearchical URLs
			incomingURL  = rereplaceNoCase(event.getCurrentRoutedURL(), "\/$","");
		}
		else{
			incomingURL	 = prc.pageOverride;
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
			// Record hit
			prc.page.updateHits();
			// Retrieve Comments
			// TODO: paging
			var commentResults 	= commentService.findApprovedComments(contentID=prc.page.getContentID(),sortOrder="asc");
			prc.comments 		= commentResults.comments;
			prc.commentsCount 	= commentResults.count;
			// announce event
			announceInterception("cbui_onPage",{page=prc.page});

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
			announceInterception("cbui_onPageNotFound",{page=prc.page,missingPage=prc.missingPage,routedURL=prc.missingRoutedURL});

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

		// get search results
		if( len(rc.q) ){
			var searchAdapter = searchService.getSearchAdapter();
			prc.searchResults = searchAdapter.search(offset=prc.pagingBoundaries.startRow-1,
												     max=prc.cbSettings.cb_paging_maxentries,
												   	 searchTerm=rc.q);
			prc.searchResultsContent = searchAdapter.renderSearchWithResults( prc.searchResults );
		}
		else{
			prc.searchResults = getModel("SearchResults@cb");
			prc.searchResultsContent = "Please enter a search term to search on.";
		}

		// announce event
		announceInterception("cbui_onContentSearch",{searchResults = prc.searchResults, searchResultsContent = prc.searchResultsContent});

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
			prc.pageOverride = page.getSlug();
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
	private function verifyPageLayout(page){
		if( !fileExists( expandPath( CBHelper.layoutRoot() & "/layouts/#arguments.page.getLayout()#.cfm" ) ) ){
			throw(message="The layout of the page: '#arguments.page.getLayout()#' does not exist in the current theme.",
			      detail="Please verify your page layout settings",
				  type="ContentBox.InvalidPageLayout");
		}
	}


}