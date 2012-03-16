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
component extends="BaseContentHandler" singleton{

	// DI
	property name="entryService" inject="id:entryService@cb";

	// pre Handler
	function preHandler(event,action,eventArguments){
		var prc = event.getCollection(private=true);
		// super call
		super.preHandler(argumentCollection=arguments);
		// Check if disabled?
		if( prc.cbSettings.cb_site_disable_blog ){
			event.overrideEvent("contentbox-ui:blog.disabled");
		}
	}

	function disabled(event,rc,prc){
		// missing page, the blog as it does not exist
		prc.missingPage 	 = event.getCurrentRoutedURL();
		prc.missingRoutedURL = event.getCurrentRoutedURL();

		// set 404 headers
		event.setHTTPHeader("404","Page not found");

		// set skin not found
		event.setView(view="#prc.cbLayout#/views/notfound",layout="#prc.cbLayout#/layouts/pages");
	}

	/**
	* The preview page
	*/
	function preview(event,rc,prc){
		event.paramValue("h","");
		event.paramValue("l","");

		var author = getModel("securityService@cb").getAuthorSession();
		// valid Author?
		if( author.isLoaded() AND author.isLoggedIn() AND compareNoCase( hash(author.getAuthorID()), rc.h) EQ 0){
			// Override layouts
			event.setLayout("#rc.l#/layouts/blog").overrideEvent("contentbox-ui:blog.index");
			// Place layout on scope
			prc.cbLayout = rc.l;
			// Place layout root location
			prc.cbLayoutRoot = prc.cbRoot & "/layouts/" & rc.l;
			// preview it
			index(argumentCollection=arguments);
		}
		else{
			setNextEvent(URL=CBHelper.linkBlog());
		}
	}

	/**
	* The home page
	*/
	function index(event,rc,prc){
		// incoming params
		event.paramValue("page",1);
		event.paramValue("category","");
		event.paramValue("q","");

		// prepare paging plugin
		prc.pagingPlugin 		= getMyPlugin(plugin="Paging",module="contentbox");
		prc.pagingBoundaries	= prc.pagingPlugin.getBoundaries();
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
		event.setView("#prc.cbLayout#/views/index");
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

		// prepare paging plugin
		prc.pagingPlugin 		= getMyPlugin(plugin="Paging",module="contentbox");
		prc.pagingBoundaries	= prc.pagingPlugin.getBoundaries();
		prc.pagingLink 			= CBHelper.linkBlog() & event.getCurrentRoutedURL() & "?page=@page@";

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
		event.setView("#prc.cbLayout#/views/archives");
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
			prc.entry.updateHits();
			// Retrieve Comments
			// TODO: paging
			var commentResults 	= commentService.findApprovedComments(contentID=prc.entry.getContentID(),sortOrder="asc");
			prc.comments 		= commentResults.comments;
			prc.commentsCount 	= commentResults.count;
			// announce event
			announceInterception("cbui_onEntry",{entry=prc.entry,entrySlug=rc.entrySlug});
			// set skin view
			event.setView("#prc.cbLayout#/views/entry");
		}
		else{
			// announce event
			announceInterception("cbui_onEntryNotFound",{entry=prc.entry,entrySlug=rc.entrySlug});
			// missing page
			prc.missingPage = rc.entrySlug;
			// set 404 headers
			event.setHTTPHeader("404","Entry not found");
			// set skin not found
			event.setView("#prc.cbLayout#/views/notfound");
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