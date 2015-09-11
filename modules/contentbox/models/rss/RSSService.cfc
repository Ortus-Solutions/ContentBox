/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* RSS Services for this application
*/
component singleton{

	// DI
	property name="entryService"		inject="id:entryService@cb";
	property name="pageService"			inject="id:pageService@cb";
	property name="contentService"		inject="id:contentService@cb";
	property name="commentService"		inject="id:commentService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";
	property name="feedGenerator" 		inject="feedGenerator@cbfeeds";
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
	RSSService function clearCaches(boolean comments=false, string slug="" ){
		var cacheKey = "";

		// compose cache key
		if( arguments.comments ){
			cacheKey = "cb-feeds-#cgi.http_host#-content-comments-";
		} else {
			cacheKey = "cb-feeds-#cgi.http_host#-content";
		}
		// clear by snippet
		cache.clearByKeySnippet(keySnippet=cacheKey,async=false);
		// log
		if( log.canInfo() ){
			log.info( "Sent clear command using the following content key: #cacheKey# from provider: #cache.getName()#" );
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
	function getRSS(string slug="", boolean comments=false, category="", contentType="" ){
		var settings	= settingService.getAllSettings(asStruct=true);
		var rssFeed  	= "";
		var cacheKey  	= "";

		// Comments cache Key
		if( arguments.comments ){
			cacheKey 	= "cb-feeds-#cgi.http_host#-content-comments-#arguments.slug#";
		}
		// Entries cache Key
		else{
			cacheKey 	= "cb-feeds-#cgi.http_host#-content-#hash(arguments.category & arguments.contentType)#";
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
	private function buildEntryFeed(category="" ){
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
		QueryAddColumn(qEntries, "guid_permalink", myArray);
		QueryAddColumn(qEntries, "guid_string", myArray);

		// Attach permalinks
		for(var i = 1; i lte entryResults.count; i++){
			// build URL to entry
			qEntries.link[i] 			= CBHelper.linkEntry( qEntries.slug[i] );
			qEntries.guid_permalink[i]	= false;
			qEntries.guid_string[i]		= CBHelper.linkEntry( qEntries.slug[i] );;
			qEntries.author[i]			= "#entryResults.entries[i].getAuthorEmail()# (#entryResults.entries[i].getAuthorName()#)";
			qEntries.linkComments[i]	= CBHelper.linkComments( entryResults.entries[i] );
			qEntries.categories[i]		= entryResults.entries[i].getCategoriesList();
			if( entryResults.entries[i].hasExcerpt() ){
				qEntries.content[i]	= entryResults.entries[i].renderExcerpt();
			}
			else{
				qEntries.content[i]	= entryResults.entries[i].renderContent();
			}
			qEntries.content[ i ] = cleanupContent( qEntries.content[ i ] );
		}

		// Generate feed items
		feedStruct.title 		= "Blog " & settings.cb_rss_title;
		feedStruct.generator	= settings.cb_rss_generator;
		feedStruct.copyright	= settings.cb_rss_copyright;
		feedStruct.description	= settings.cb_rss_description;
		if( len( settings.cb_rss_webmaster ) )
			feedStruct.webmaster	= settings.cb_rss_webmaster;
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
	private function buildPageFeed(category="" ){
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
		QueryAddColumn(qPages, "guid_permalink", myArray);
		QueryAddColumn(qPages, "guid_string", myArray);

		// Attach permalinks
		for(var i = 1; i lte pageResults.count; i++){
			// build URL to entry
			qPages.link[i] 				= CBHelper.linkPage( qPages.slug );
			qPages.author[i]			= "#pageResults.pages[i].getAuthorEmail()# (#pageResults.pages[i].getAuthorName()#)";
			qPages.linkComments[i]		= CBHelper.linkComments( pageResults.pages[i] );
			qPages.categories[i]		= pageResults.pages[i].getCategoriesList();
			qPages.guid_permalink[i] 	= false;
			qPages.guid_string[i] 		= CBHelper.linkPage( qPages.slug );
			if( pageResults.pages[i].hasExcerpt() ){
				qPages.content[i]	= pageResults.pages[i].renderExcerpt();
			} else {
				qPages.content[i]	= pageResults.pages[i].renderContent();
			}
			qPages.content[ i ] = cleanupContent( qPages.content[ i ] );
		}

		// Generate feed items
		feedStruct.title 		= "Page " & settings.cb_rss_title;
		feedStruct.generator	= settings.cb_rss_generator;
		feedStruct.copyright	= settings.cb_rss_copyright;
		feedStruct.description	= settings.cb_rss_description;
		if( len( settings.cb_rss_webmaster ) )
			feedStruct.webmaster	= settings.cb_rss_webmaster;
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
	private function buildContentFeed(category="" ){
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
		QueryAddColumn(qContent, "guid_permalink", myArray);
		QueryAddColumn(qContent, "guid_string", myArray);

		// Attach permalinks
		for(var i = 1; i lte contentResults.count; i++){
			// build URL to entry
			qContent.link[i] 			= CBHelper.linkContent( contentResults.content[i] );
			qContent.author[i]			= "#contentResults.content[i].getAuthorEmail()# (#contentResults.content[i].getAuthorName()#)";
			qContent.linkComments[i]	= CBHelper.linkComments( contentResults.content[i] );
			qContent.categories[i]		= contentResults.content[i].getCategoriesList();
			qContent.content[i]			= cleanupContent( contentResults.content[i].renderContent() );
			qContent.guid_permalink[i] 	= false;
			qContent.guid_string[i] 	= CBHelper.linkContent( contentResults.content[i] );

		}

		// Generate feed items
		feedStruct.title 		= "Content " & settings.cb_rss_title;
		feedStruct.generator	= settings.cb_rss_generator;
		feedStruct.copyright	= settings.cb_rss_copyright;
		feedStruct.description	= settings.cb_rss_description;
		if( len( settings.cb_rss_webmaster ) )
			feedStruct.webmaster	= settings.cb_rss_webmaster;
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
	private function buildCommentFeed(string slug="", string contentType="" ){
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
		QueryAddColumn(qComments, "guid_permalink", myArray);
		QueryAddColumn(qComments, "guid_string", myArray);

		// Attach permalinks
		for(var i = 1; i lte commentResults.count; i++){
			// build URL to entry
			qComments.title[i] 			= "Comment by #qComments.author[i]# on #commentResults.comments[i].getParentTitle()#";
			qComments.rssAuthor[i]		= "#qComments.authorEmail# (#qComments.author#)";
			qComments.linkComments[i]	= CBHelper.linkComment( commentResults.comments[i] );
			qComments.content[i]		= cleanupContent( qComments.content[i] );
			qComments.guid_permalink[i]	= false;
			qComments.guid_string[i]	= CBHelper.linkComment( commentResults.comments[i] );
		}

		// Generate feed items
		feedStruct.title 		= "Comments " & settings.cb_rss_title;
		feedStruct.generator	= settings.cb_rss_generator;
		feedStruct.copyright	= settings.cb_rss_copyright;
		feedStruct.description	= settings.cb_rss_description;
		if( len( settings.cb_rss_webmaster ) )
			feedStruct.webmaster	= settings.cb_rss_webmaster;
		feedStruct.pubDate 		= now();
		feedStruct.lastbuilddate = now();
		feedStruct.link 		= CBHelper.linkHome();
		feedStruct.items 		= qComments;

		return feedGenerator.createFeed(feedStruct,columnMap);
	}

	/**
	* Cleanup HTML to normal strings to avoid parsing issues
	*/
	private function cleanupContent( required content ){
		return reReplacenocase( arguments.content, "<[^>]*>", "", "all" );
	}

}