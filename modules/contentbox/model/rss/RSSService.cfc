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
* RSS Services for this application
*/
component singleton{

	// Dependencies
	property name="entryService"		inject="id:entryService@cb";
	property name="pageService"			inject="id:pageService@cb";
	property name="contentService"		inject="id:contentService@cb";
	property name="commentService"		inject="id:commentService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";
	property name="feedGenerator" 		inject="coldbox:plugin:FeedGenerator";
	property name="log"					inject="logbox:logger:{this}";
	
	/**
 	* Constructor
 	* @settingService.inject id:settingService@cb
 	* @cacheBox.inject cachebox
	*/
	function init(required settingService, required cacheBox){
		// Dependencies
		variables.settingService = arguments.settingService;
		variables.cacheBox 		 = arguments.cacheBox;
		// Get all settings
		var settings = settingService.getAllSettings(asStruct=true);
		// setup the user selected cache provider
		cache = cacheBox.getCache( settings.cb_rss_cacheName );
		
		return this;
	}
	
	/**
	* Clean RSS caches asynchronously
	*/
	void function clearCaches(boolean comments=false,entrySlug=""){
		var cacheKey = "";
		
		if( arguments.comments ){
			cacheKey = "cb-feeds-comments-#arguments.entrySlug#";
			cache.clearByKeySnippet(keySnippet=cacheKey,async=true);
		}
		else{
			cacheKey = "cb-feeds-entries";
			cache.clearByKeySnippet(keySnippet=cacheKey,async=true);
		}
		
		// log
		if( log.canInfo() ){
			log.info("Sent clear command using the following content key: #cacheKey# from provider: #cache.getName()#");
		}
	}
	
	/**
	* Clean All RSS caches NOW BABY, NOW!
	*/
	void function clearAllCaches(){
		cache.clearByKeySnippet(keySnippet="cb-feeds",async=false);
	}
	
	/**
	* Build RSS feeds for contentbox blog entries
	*/
	function getEntriesRSS(boolean comments=false, string category="", string slug=""){
		var settings	= settingService.getAllSettings(asStruct=true);
		var rssFeed  	= "";
		var cacheKey  	= "";
		
		// Comments cache Key
		if( arguments.comments ){
			cacheKey 	= "cb-feeds-entries-comments-#arguments.slug#";
		}
		// Entries cache Key
		else{
			cacheKey 	= "cb-feeds-entries-#hash(arguments.category)#";
		}
		
		// Retrieve via caching? and caching active
		if( settings.cb_rss_caching ){
			var rssFeed = cache.get( cacheKey );
			if( !isNull(rssFeed) ){ return rssFeed; }
		}
		
		// Building comment feed or entry feed
		switch(arguments.comments){
			case true : { rssfeed = buildCommentFeed(argumentCollection=arguments); break;}
			default   : { rssfeed = buildEntryFeed(argumentCollection=arguments); break; }
		}
		
		// Cache it with settings
		if( settings.cb_rss_caching ){
			cache.set(cacheKey, rssFeed, settings.cb_rss_cachingTimeout, settings.cb_rss_cachingTimeoutIdle);
		}

		return rssFeed;	
	}
	
	/**
	* Build RSS feeds for contentbox pages
	*/
	function getPagesRSS(boolean comments=false, string category="", string slug=""){
		var settings	= settingService.getAllSettings(asStruct=true);
		var rssFeed  	= "";
		var cacheKey  	= "";
		
		// Comments cache Key
		if( arguments.comments ){
			cacheKey 	= "cb-feeds-pages-comments-#arguments.slug#";
		}
		// Entries cache Key
		else{
			cacheKey 	= "cb-feeds-pages-#hash(arguments.category)#";
		}
		
		// Retrieve via caching? and caching active
		if( settings.cb_rss_caching ){
			var rssFeed = cache.get( cacheKey );
			if( !isNull(rssFeed) ){ return rssFeed; }
		}
		
		// Building comment feed or page feed
		switch(arguments.comments){
			case true : { rssfeed = buildCommentFeed(argumentCollection=arguments); break;}
			default   : { rssfeed = buildPageFeed(argumentCollection=arguments); break; }
		}
		
		// Cache it with settings
		if( settings.cb_rss_caching ){
			cache.set(cacheKey, rssFeed, settings.cb_rss_cachingTimeout, settings.cb_rss_cachingTimeoutIdle);
		}

		return rssFeed;	
	}
	
	/**
	* Build RSS feeds for contentbox blog entries, with added caching.
	*/
	function getRSS(boolean comments=false,category="",entrySlug=""){
		var settings	= settingService.getAllSettings(asStruct=true);
		var rssFeed  	= "";
		var cacheKey  	= "";
		
		// Comments cache Key
		if( arguments.comments ){
			cacheKey 	= "cb-feeds-comments-#arguments.entrySlug#";
		}
		// Entries cache Key
		else{
			cacheKey 	= "cb-feeds-entries-#hash(arguments.category)#";
		}
		
		// Retrieve via caching? and caching active
		if( settings.cb_rss_caching ){
			var rssFeed = cache.get( cacheKey );
			if( !isNull(rssFeed) ){ return rssFeed; }
		}
		
		// Building comment feed or entry feed
		switch(arguments.comments){
			case true : { rssfeed = buildCommentFeed(argumentCollection=arguments); break;}
			default   : { rssfeed = buildEntryFeed(argumentCollection=arguments); break; }
		}
		
		// Cache it with settings
		if( settings.cb_rss_caching ){
			cache.set(cacheKey, rssFeed, settings.cb_rss_cachingTimeout, settings.cb_rss_cachingTimeoutIdle);
		}

		return rssFeed;		
	}
	
	/**
	* Build entries feeds
	* @category The category to filter on if needed
	*/	
	private function buildEntryFeed(category=""){
		var settings		= settingService.getAllSettings(asStruct=true);
		var entryResults 	= entryService.findPublishedEntries(category=arguments.category,max=settings.cb_rss_maxEntries);
		var myArray 		= [];
		var feedStruct 		= {};
		var columnMap 		= {};
		var qEntries		= entityToQuery( entryResults.entries );
		
		// max checks
		if( settings.cb_rss_maxEntries lt entryResults.count ){
			entryResults.count = settings.cb_rss_maxEntries;
		}
		
		// Create the column maps
		columnMap.title 		= "title";
		columnMap.description 	= "content";
		columnMap.pubDate 		= "publishedDate";
		columnMap.link 			= "link";
		columnMap.author		= "author";
		columnMap.category_tag	= "categories";
		
		// Add necessary columns to query
		QueryAddColumn(qEntries, "link", myArray);
		QueryAddColumn(qEntries, "linkComments", myArray);
		QueryAddColumn(qEntries, "author", myArray);
		QueryAddColumn(qEntries, "categories", myArray);
		QueryAddColumn(qEntries, "content", myArray);
		
		// Attach permalinks
		for(var i = 1; i lte entryResults.count; i++){
			// build URL to entry
			qEntries.link[i] 			= CBHelper.linkEntryWithSlug( qEntries.slug );
			qEntries.author[i]			= "#entryResults.entries[i].getAuthorEmail()# (#entryResults.entries[i].getAuthorName()#)";
			qEntries.linkComments[i]	= CBHelper.linkComments( entryResults.entries[i] );
			qEntries.categories[i]		= entryResults.entries[i].getCategoriesList();
			qEntries.content[i]			= entryResults.entries[i].getActiveContent().renderContent();
		}
		
		// Generate feed items
		feedStruct.title 		= CBHelper.siteName() & " RSS Feed by ContentBox";
		feedStruct.generator	= "ContentBox by ColdBox Platform";
		feedStruct.copyright	= "Ortus Solutions, Corp (www.ortussolutions.com)";
		feedStruct.description	= CBHelper.siteDescription();
		feedStruct.webmaster	= settings.cb_site_email;
		feedStruct.pubDate 		= now();
		feedStruct.lastbuilddate = now();
		feedStruct.link 		= CBHelper.linkHome();
		feedStruct.items 		= qEntries;
		
		return feedGenerator.createFeed(feedStruct,columnMap);
	}
	
	/**
	* Build pages feeds
	* @category The category to filter on if needed
	*/	
	private function buildPageFeed(category=""){
		var settings		= settingService.getAllSettings(asStruct=true);
		var pageResults 	= pageService.findPublishedPages(category=arguments.category,max=settings.cb_rss_maxEntries);
		var myArray 		= [];
		var feedStruct 		= {};
		var columnMap 		= {};
		var qPages			= entityToQuery( pageResults.pages );
		
		// max checks
		if( settings.cb_rss_maxEntries lt pageResults.count ){
			pageResults.count = settings.cb_rss_maxEntries;
		}
		
		// Create the column maps
		columnMap.title 		= "title";
		columnMap.description 	= "content";
		columnMap.pubDate 		= "publishedDate";
		columnMap.link 			= "link";
		columnMap.author		= "author";
		columnMap.category_tag	= "categories";
		
		// Add necessary columns to query
		QueryAddColumn(qPages, "link", myArray);
		QueryAddColumn(qPages, "linkComments", myArray);
		QueryAddColumn(qPages, "author", myArray);
		QueryAddColumn(qPages, "categories", myArray);
		QueryAddColumn(qPages, "content", myArray);
		
		// Attach permalinks
		for(var i = 1; i lte entryResults.count; i++){
			// build URL to entry
			qPages.link[i] 			= CBHelper.linkPage( qPages.slug );
			qPages.author[i]		= "#pageResults.pages[i].getAuthorEmail()# (#pageResults.pages[i].getAuthorName()#)";
			qPages.linkComments[i]	= CBHelper.linkComments( pageResults.pages[i] );
			qPages.categories[i]	= pageResults.pages[i].getCategoriesList();
			qPages.content[i]		= pageResults.pages[i].getActiveContent().renderContent();
		}
		
		// Generate feed items
		feedStruct.title 		= CBHelper.siteName() & " Pages RSS Feed by ContentBox";
		feedStruct.generator	= "ContentBox by ColdBox Platform";
		feedStruct.copyright	= "Ortus Solutions, Corp (www.ortussolutions.com)";
		feedStruct.description	= CBHelper.siteDescription();
		feedStruct.webmaster	= settings.cb_site_email;
		feedStruct.pubDate 		= now();
		feedStruct.lastbuilddate = now();
		feedStruct.link 		= CBHelper.linkHome();
		feedStruct.items 		= qPages;
		
		return feedGenerator.createFeed(feedStruct,columnMap);
	}

	/**
	* Build comment feeds according to filtering elements
	* @slug.hint The content slug to filter on
	* @contentType.hint The content type discriminator to filter on
	*/	
	private function buildCommentFeed(string slug="", string contentType=""){
		var settings		= settingService.getAllSettings(asStruct=true);
		var commentResults 	= commentService.findApprovedComments(contentID=contentService.getIDBySlug(arguments.slug),contentType=arguments.contentType,max=settings.cb_rss_maxComments);
		var myArray 		= [];
		var feedStruct 		= {};
		var columnMap 		= {};
		var qComments		= entityToQuery( commentResults.comments );
		
		// Create the column maps
		columnMap.title 		= "title";
		columnMap.description 	= "content";
		columnMap.pubDate 		= "createddate";
		columnMap.link 			= "link";
		columnMap.author		= "rssAuthor";
		columnMap.category_tag	= "categories";
		
		// Add necessary columns to query
		QueryAddColumn(qComments, "title", myArray);
		QueryAddColumn(qComments, "linkComments", myArray);
		QueryAddColumn(qComments, "rssAuthor", myArray);
		
		// Attach permalinks
		for(var i = 1; i lte commentResults.count; i++){
			// build URL to entry
			qComments.title[i] 			= "Comment by #qComments.author[i]# on #commentResults.comments[i].getParentTitle()#";
			qComments.rssAuthor[i]		= "#qComments.authorEmail# (#qComments.author#)";
			qComments.linkComments[i]	= CBHelper.linkComment( commentResults.comments[i] );
		}
		
		// Generate feed items
		feedStruct.title 		= CBHelper.siteName() & " Comments RSS Feed by ContentBox";
		feedStruct.generator	= "ContentBox by ColdBox Platform";
		feedStruct.copyright	= "Ortus Solutions, Corp (www.ortussolutions.com)";
		feedStruct.description	= CBHelper.siteDescription();
		feedStruct.webmaster	= settings.cb_site_email;
		feedStruct.pubDate 		= now();
		feedStruct.lastbuilddate = now();
		feedStruct.link 		= CBHelper.linkHome();
		feedStruct.items 		= qComments;
		
		return feedGenerator.createFeed(feedStruct,columnMap);
	}

}