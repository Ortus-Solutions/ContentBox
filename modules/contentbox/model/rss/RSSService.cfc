/**
* RSS Service for this application
*/
component singleton{

	// Dependecnies
	property name="settingService"		inject="id:settingService@cb";
	property name="entryService"		inject="id:entryService@cb";
	property name="commentService"		inject="id:commentService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";
	property name="feedGenerator" 		inject="coldbox:plugin:FeedGenerator";
	property name="log"					inject="logbox:logger:{this}";
	property name="cachebox"			inject="cachebox";
	

	function init(){
		return this;
	}
	
	// Startup the service
	function onDIComplete(){
		var settings	= settingService.getAllSettings(asStruct=true);
		// setup the user selected cache provider
		cache = cacheBox.getCache( settings.cb_rss_cacheName );
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
	* Build RSS feeds for contentbox, with added caching.
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
	function buildEntryFeed(category=""){
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
	* Build comment feeds
	* @entrySlug The category to filter on if needed
	*/	
	function buildCommentFeed(entrySlug=""){
		var settings		= settingService.getAllSettings(asStruct=true);
		var commentResults 	= commentService.findApprovedComments(contentID=entryService.getIDBySlug(arguments.entrySlug),max=settings.cb_rss_maxComments);
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