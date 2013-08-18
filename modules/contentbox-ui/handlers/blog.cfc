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
* Handler For ContentBox blog pages
*/
component extends="content" singleton{

	// DI
	property name="entryService" inject="id:entryService@cb";
	
	// Pre Handler Exceptions
	this.preHandler_except = "preview";

	// pre Handler
	function preHandler(event,rc,prc,action,eventArguments){
		// Check if disabled?
		if( prc.cbSettings.cb_site_disable_blog ){
			event.overrideEvent("contentbox-ui:blog.disabled");
		}
		// super call
		super.preHandler(argumentCollection=arguments);
	}

	function disabled(event,rc,prc){
		// missing page, the blog as it does not exist
		prc.missingPage 	 = event.getCurrentRoutedURL();
		prc.missingRoutedURL = event.getCurrentRoutedURL();

		// set 404 headers
		event.setHTTPHeader("404","Page not found");

		// set skin not found
		event.setLayout(name="#prc.cbLayout#/layouts/pages", module="contentbox")
			.setView(view="#prc.cbLayout#/views/notfound",module="contentbox");
	}
	
	/**
	* Preview a blog entry
	*/
	function preview(event,rc,prc){
		// Run parent preview
		super.preview(argumentCollection=arguments);
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
		prc.entry.addNewContentVersion(content=URLDecode( rc.content ), author=prc.author)
			.setActiveContent( prc.entry.getContentVersions() );
		// set skin view
		event.setLayout(name="#prc.cbLayout#/layouts/#rc.layout#", module="contentbox")
			.setView(view="#prc.cbLayout#/views/entry", module="contentbox");
	}

	/**
	* The home page
	*/
	function index(event,rc,prc){
		// incoming params
		event.paramValue("page",1);
		event.paramValue("category","");
		event.paramValue("q","");
		
		// Page numeric check
		if( !isNumeric( rc.page ) ){ rc.page = 1; }

		// prepare paging plugin
		prc.pagingPlugin 		= getMyPlugin(plugin="Paging",module="contentbox");
		prc.pagingBoundaries	= prc.pagingPlugin.getBoundaries(pagingMaxRows=prc.cbSettings.cb_paging_maxentries);
		prc.pagingLink 			= CBHelper.linkBlog() & "?page=@page@";

		// Search Paging Link Override?
		if( len(rc.q) ){
			prc.pagingLink = CBHelper.linkBlog() & "/search/#rc.q#/@page@?";
		}
		// Category Filter Link Override
		if( len(rc.category) ){
			prc.pagingLink = CBHelper.linkBlog() & "/category/#rc.category#/@page@?";
		}

		// get published entries
		var entryResults = entryService.findPublishedEntries(offset=prc.pagingBoundaries.startRow-1,
											   				 max=prc.cbSettings.cb_paging_maxentries,
											   				 category=rc.category,
											   				 searchTerm=rc.q);
		prc.entries 		= entryResults.entries;
		prc.entriesCount  	= entryResults.count;

		// announce event
		announceInterception("cbui_onIndex",{entries=prc.entries,entriesCount=prc.entriesCount});

		// set skin view
		event.setLayout(name="#prc.cbLayout#/layouts/blog", module="contentbox")
			.setView(view="#prc.cbLayout#/views/index",module="contentbox");
		
	}

	/**
	* The archives
	*/
	function archives(event,rc,prc){
		// incoming params
		event.paramValue("page",1);
		// archived params
		event.paramValue("year","0");
		event.paramValue("month","0");
		event.paramValue("day","0");
		
		// Page numeric check
		if( !isNumeric( rc.page ) ){ rc.page = 1; }

		// prepare paging plugin
		prc.pagingPlugin 		= getMyPlugin(plugin="Paging",module="contentbox");
		prc.pagingBoundaries	= prc.pagingPlugin.getBoundaries(pagingMaxRows=prc.cbSettings.cb_paging_maxentries);
		prc.pagingLink 			= event.getCurrentRoutedURL() & "?page=@page@";
		
		// get published entries
		var entryResults = entryService.findPublishedEntriesByDate(year=rc.year,
											   				  	   month=rc.month,
											   				 	   day=rc.day,
											   				 	   offset=prc.pagingBoundaries.startRow-1,
											   					   max=prc.cbSettings.cb_paging_maxentries);
		prc.entries 		= entryResults.entries;
		prc.entriesCount  	= entryResults.count;

		// announce event
		announceInterception("cbui_onArchives",{entries=prc.entries,entriesCount=prc.entriesCount});

		// set skin view
		event.setLayout(name="#prc.cbLayout#/layouts/blog", module="contentbox")
			.setView(view="#prc.cbLayout#/views/archives",module="contentbox");
	}

	/**
	* Around entry page advice that provides caching and multi-output format
	*/
	function aroundEntry(event,rc,prc,eventArguments){
		return wrapContentAdvice( event, rc, prc, eventArguments, variables.entry );
	}

	/**
	* An entry page
	*/
	function entry(event,rc,prc){
		// incoming params
		event.paramValue("entrySlug","");

		// get the author
		var author = getModel("securityService@cb").getAuthorSession();
		var showUnpublished = false;
		if( author.isLoaded() AND author.isLoggedIn() ){
			var showUnpublished = true;
		}
		prc.entry = entryService.findBySlug(rc.entrySlug,showUnpublished);

		// Check if loaded, else not found
		if( prc.entry.isLoaded() ){
			// Record hit
			entryService.updateHits( prc.entry.getContentID() );
			// Retrieve Comments
			// TODO: paging
			var commentResults 	= commentService.findApprovedComments(contentID=prc.entry.getContentID(),sortOrder="asc");
			prc.comments 		= commentResults.comments;
			prc.commentsCount 	= commentResults.count;
			// announce event
			announceInterception("cbui_onEntry",{entry=prc.entry,entrySlug=rc.entrySlug});
			// set skin view
			event.setLayout(name="#prc.cbLayout#/layouts/blog", module="contentbox")
				.setView(view="#prc.cbLayout#/views/entry",module="contentbox");
			// Different display formats if enabled?
			if( prc.cbSettings.cb_content_uiexport ){
				event.paramValue("format", "contentbox");
				switch( rc.format ){
					case "pdf" : {
						event.renderData(data=renderLayout(layout="#prc.cbLayout#/layouts/#layoutService.getThemePrintLayout(format='pdf', layout='blog')#", 
														   view="#prc.cbLayout#/views/entry", module="contentbox", viewModule="contentbox"), 
							type="pdf");
						break;
					}
					case "print" : case "html" : {
						event.renderData(data=renderLayout(layout="#prc.cbLayout#/layouts/#layoutService.getThemePrintLayout(format='print', layout='blog')#", 
														   view="#prc.cbLayout#/views/entry", module="contentbox", viewModule="contentbox"), 
							type="html");
						break;
					}
					case "doc" : {
						event.renderData(data=renderLayout(layout="#prc.cbLayout#/layouts/#layoutService.getThemePrintLayout(format='doc', layout='blog')#", 
														   view="#prc.cbLayout#/views/entry", module="contentbox", viewModule="contentbox"), 
							contentType="application/msword")
							.setHTTPHeader(name="Content-Disposition", value="inline; filename=#prc.entry.getSlug()#.doc");
						break;
					}
				} // end switch
			} // end if formats enabled
		}
		else{
			// announce event
			announceInterception("cbui_onEntryNotFound",{entry=prc.entry,entrySlug=rc.entrySlug});
			// missing page
			prc.missingPage = rc.entrySlug;
			// set 404 headers
			event.setHTTPHeader("404","Entry not found");
			// set skin not found
			event.setLayout(name="#prc.cbLayout#/layouts/blog", module="contentbox")
				.setView(view="#prc.cbLayout#/views/notfound",module="contentbox");
		}
	}

	/**
	* Display the RSS feeds for the blog
	*/
	function rss(event,rc,prc){
		// params
		event.paramValue("category","");
		event.paramValue("entrySlug","");
		event.paramValue("commentRSS",false);

		// Build out the blog RSS feeds
		var feed = RSSService.getRSS(comments=rc.commentRSS,category=rc.category,slug=rc.entrySlug,contentType="Entry");

		// Render out the feed xml
		event.renderData(type="plain",data=feed,contentType="text/xml");
	}

	/**
	* Comment Form Post
	*/
	function commentPost(event,rc,prc){
		// incoming params
		event.paramValue("entrySlug","");

		// Try to retrieve entry by slug
		var thisEntry = entryService.findBySlug( rc.entrySlug );

		// If null, kick them out
		if( isNull( thisEntry ) ){ setNextEvent( prc.cbEntryPoint ); }

		// validate incoming comment post
		prc.commentErrors = validateCommentPost(event,rc,prc,thisEntry);

		// Validate if comment errors exist
		if( arrayLen( prc.commentErrors ) ){
			// MessageBox
			getPlugin("MessageBox").warn(messageArray=prc.commentErrors);
			// put slug in request
			rc.entrySlug = thisEntry.getSlug();
			// Execute entry again, need to correct form
			entry(argumentCollection=arguments);
			return;
		}

		// Valid commenting, so go and save
		saveComment( thisEntry );
	}

}