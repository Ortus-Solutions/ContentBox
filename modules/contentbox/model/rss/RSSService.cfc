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

	// DI
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
	RSSService function init(required settingService, required cacheBox){
		// Dependencies
		variables.settingService = arguments.settingService;
		variables.cacheBox 		 = arguments.cacheBox;
		// Get all settings
		var settings = settingService.getAllSettings(asStruct=true);
		// setup the user selected cache provider
		cache = cacheBox.getCache( settings.cb_rss_cacheName );
		
		return this;
	}
	
	/************************************** PUBLIC *********************************************/
	
	/**
	* Clean RSS caches asynchronously
	* @comments.hint Clear comment caches or not, defaults to false
	* @slug.hint The content slug to clear on
	*/
	RSSService function clearCaches(boolean comments=false, string slug=""){
		var cacheKey = "";
		
		// compose cache key
		if( arguments.comments ){
			cacheKey = "cb-feeds-content-comments-";
		}
		else{
			cacheKey = "cb-feeds-content";
		}
		// clear by snippet
		cache.clearByKeySnippet(keySnippet=cacheKey,async=false);
		// log
		if( log.canInfo() ){
			log.info("Sent clear command using the following content key: #cacheKey# from provider: #cache.getName()#");
		}
		return this;
	}
	
	/**
	* Clean All RSS caches NOW BABY, NOW!
	*/
	RSSService function clearAllCaches(boolean async=false){
		cache.clearByKeySnippet(keySnippet="cb-feeds",async=arguments.async);
		return this;
	}
	
	/**
	* Build RSS feeds for contentbox content objects
	* @slug.hint The page or entry slug to filter on.
	* @comments.hint Retrieve the comments RSS feed or content feed, defaults to false
	* @category.hint Filter the content feed with categories
	* @contentType.hint The contentType to build an RSS feed on. Empty is for the site. Available content types are [page,entry]
	*/
	function getRSS(string slug="", boolean comments=false, category="", contentType=""){
		var settings	= settingService.getAllSettings(asStruct=true);
		var rssFeed  	= "";
		var cacheKey  	= "";
		
		// Comments cache Key
		if( arguments.comments ){
			cacheKey 	= "cb-feeds-content-comments-#arguments.slug#";
		}
		// Entries cache Key
		else{
			cacheKey 	= "cb-feeds-content-#hash(arguments.category & arguments.contentType)#";
		}
		
		// Retrieve via caching? and caching active
		if( settings.cb_rss_caching ){
			var rssFeed = cache.get( cacheKey );
			if( !isNull(rssFeed) ){ return rssFeed; }
		}
		
		// Content Type
		switch(arguments.contentType){
			// Pages
			case "page" : {
				// Building comment feed or content feed
				if( arguments.comments ){
					arguments.contentType = "Page"; 
					rssfeed = buildCommentFeed(argumentCollection=arguments);
				}
				else{
					rssfeed = buildPageFeed(argumentCollection=arguments);
				}
				break;
			}
			// Blog
			case "entry" : {
				// Building comment feed or content feed
				if( arguments.comments ){
					arguments.contentType = "Entry";
					rssfeed = buildCommentFeed(argumentCollection=arguments);
				}
				else{
					rssfeed = buildEntryFeed(argumentCollection=arguments);
				}
				break;
			}
			// Default Site
			default : {
				// Building comment feed or content feed
				if( arguments.comments ){
					rssfeed = buildCommentFeed(argumentCollection=arguments);
				}
				else{
					rssfeed = buildContentFeed(argumentCollection=arguments);
				}
				break;
			}
			
		} // end content type switch
		
		// Cache it with settings
		if( settings.cb_rss_caching ){
			cache.set(cacheKey, rssFeed, settings.cb_rss_cachingTimeout, settings.cb_rss_cachingTimeoutIdle);
		}

		return rssFeed;		
	}
	
	/************************************** PRIVATE *********************************************/
	
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
			qEntries.link[i] 			= CBHelper.linkEntry( qEntries.slug );
			qEntries.author[i]			= "#entryResults.entries[i].getAuthorEmail()# (#entryResults.entries[i].getAuthorName()#)";
			qEntries.linkComments[i]	= CBHelper.linkComments( entryResults.entries[i] );
			qEntries.categories[i]		= entryResults.entries[i].getCategoriesList();
			qEntries.content[i]			= xmlFormat( entryResults.entries[i].getActiveContent().renderContent() );
		}
		
		// Generate feed items
		feedStruct.title 		= CBHelper.siteName() & " Blog RSS Feed by ContentBox";
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
		for(var i = 1; i lte pageResults.count; i++){
			// build URL to entry
			qPages.link[i] 			= CBHelper.linkPage( qPages.slug );
			qPages.author[i]		= "#pageResults.pages[i].getAuthorEmail()# (#pageResults.pages[i].getAuthorName()#)";
			qPages.linkComments[i]	= CBHelper.linkComments( pageResults.pages[i] );
			qPages.categories[i]	= pageResults.pages[i].getCategoriesList();
			qPages.content[i]		= xmlFormat( pageResults.pages[i].getActiveContent().renderContent() );
		}
		
		// Generate feed items
		feedStruct.title 		= CBHelper.siteName() & " Page RSS Feed by ContentBox";
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
	* Build content feeds
	* @category The category to filter on if needed
	*/	
	private function buildContentFeed(category=""){
		var settings		= settingService.getAllSettings(asStruct=true);
		var contentResults 	= contentService.findPublishedContent(category=arguments.category,max=settings.cb_rss_maxEntries);
		var myArray 		= [];
		var feedStruct 		= {};
		var columnMap 		= {};
		var qContent		= entityToQuery( contentResults.content );
		
		// max checks
		if( settings.cb_rss_maxEntries lt contentResults.count ){
			contentResults.count = settings.cb_rss_maxEntries;
		}
		
		// Create the column maps
		columnMap.title 		= "title";
		columnMap.description 	= "content";
		columnMap.pubDate 		= "publishedDate";
		columnMap.link 			= "link";
		columnMap.author		= "author";
		columnMap.category_tag	= "categories";
		
		// Add necessary columns to query
		QueryAddColumn(qContent, "link", myArray);
		QueryAddColumn(qContent, "linkComments", myArray);
		QueryAddColumn(qContent, "author", myArray);
		QueryAddColumn(qContent, "categories", myArray);
		QueryAddColumn(qContent, "content", myArray);
		
		// Attach permalinks
		for(var i = 1; i lte contentResults.count; i++){
			// build URL to entry
			qContent.link[i] 			= CBHelper.linkContent( contentResults.content[i] );
			qContent.author[i]			= "#contentResults.content[i].getAuthorEmail()# (#contentResults.content[i].getAuthorName()#)";
			qContent.linkComments[i]	= CBHelper.linkComments( contentResults.content[i] );
			qContent.categories[i]		= contentResults.content[i].getCategoriesList();
			qContent.content[i]			= xmlFormat( contentResults.content[i].getActiveContent().renderContent() );
		}
		
		// Generate feed items
		feedStruct.title 		= CBHelper.siteName() & " Content RSS Feed by ContentBox";
		feedStruct.generator	= "ContentBox by ColdBox Platform";
		feedStruct.copyright	= "Ortus Solutions, Corp (www.ortussolutions.com)";
		feedStruct.description	= CBHelper.siteDescription();
		feedStruct.webmaster	= settings.cb_site_email;
		feedStruct.pubDate 		= now();
		feedStruct.lastbuilddate = now();
		feedStruct.link 		= CBHelper.linkHome();
		feedStruct.items 		= qContent;
		
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
			qComments.content[i]		= xmlFormat( qComments.content[i] );
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