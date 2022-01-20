/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * RSS Services for this application
 */
component singleton {

	// DI
	property name="entryService" inject="entryService@contentbox";
	property name="pageService" inject="pageService@contentbox";
	property name="contentService" inject="contentService@contentbox";
	property name="commentService" inject="commentService@contentbox";
	property name="CBHelper" inject="CBHelper@contentbox";
	property name="feedGenerator" inject="feedGenerator@cbfeeds";
	property name="log" inject="logbox:logger:{this}";

	/**
	 * Constructor
	 *
	 * @settingService.inject id:settingService@contentbox
	 * @cacheBox.inject       cachebox
	 */
	RSSService function init( required settingService, required cacheBox ){
		// Dependencies
		variables.settingService = arguments.settingService;
		variables.cacheBox       = arguments.cacheBox;
		// Get all settings
		var settings             = settingService.getAllSettings();
		// setup the user selected cache provider
		variables.cache          = cacheBox.getCache( settings.cb_rss_cacheName );

		return this;
	}

	/************************************** PUBLIC *********************************************/

	/**
	 * Clean RSS caches asynchronously
	 *
	 * @comments Clear comment caches or not, defaults to false
	 * @slug     The content slug to clear on
	 */
	RSSService function clearCaches( boolean comments = false, string slug = "" ){
		var cacheKey = "";

		// compose cache key
		if ( arguments.comments ) {
			cacheKey = "cb-feeds-#cgi.HTTP_HOST#-content-comments-";
		} else {
			cacheKey = "cb-feeds-#cgi.HTTP_HOST#-content";
		}

		// clear by snippet
		variables.cache.clearByKeySnippet( keySnippet = cacheKey, async = false );

		// log
		if ( variables.log.canInfo() ) {
			variables.log.info(
				"Sent clear command using the following content key: #cacheKey# from provider: #variables.cache.getName()#"
			);
		}

		return this;
	}

	/**
	 * Clean All RSS caches NOW BABY, NOW!
	 */
	RSSService function clearAllCaches( boolean async = false ){
		variables.cache.clearByKeySnippet( keySnippet = "cb-feeds", async = arguments.async );
		return this;
	}

	/**
	 * Build RSS feeds for contentbox content objects
	 *
	 * @slug        The page or entry slug to filter on.
	 * @comments    Retrieve the comments RSS feed or content feed, defaults to false
	 * @category    Filter the content feed with categories
	 * @contentType The contentType to build an RSS feed on. Empty is for the site. Available content types are [page,entry]
	 * @siteID      The site Id to filter on
	 */
	function getRSS(
		string slug      = "",
		boolean comments = false,
		category         = "",
		contentType      = "",
		string siteID    = ""
	){
		var settings = settingService.getAllSettings();
		var rssFeed  = "";
		var cacheKey = "";

		// Comments cache Key
		if ( arguments.comments ) {
			cacheKey = "cb-feeds-#cgi.HTTP_HOST#-content-comments-#arguments.slug#";
		}
		// Entries cache Key
		else {
			cacheKey = "cb-feeds-#cgi.HTTP_HOST#-content-#hash( arguments.category & arguments.contentType )#";
		}

		// Retrieve via caching? and caching active
		if ( settings.cb_rss_caching ) {
			var rssFeed = variables.cache.get( cacheKey );
			if ( !isNull( rssFeed ) ) {
				return rssFeed;
			}
		}

		// Content Type
		switch ( arguments.contentType ) {
			// Pages
			case "page": {
				// Building comment feed or content feed
				if ( arguments.comments ) {
					arguments.contentType = "Page";
					rssfeed               = buildCommentFeed( argumentCollection = arguments );
				} else {
					rssfeed = buildPageFeed( argumentCollection = arguments );
				}
				break;
			}
			// Blog
			case "entry": {
				// Building comment feed or content feed
				if ( arguments.comments ) {
					arguments.contentType = "Entry";
					rssfeed               = buildCommentFeed( argumentCollection = arguments );
				} else {
					rssfeed = buildEntryFeed( argumentCollection = arguments );
				}
				break;
			}
			// Default Site
			default: {
				// Building comment feed or content feed
				if ( arguments.comments ) {
					rssfeed = buildCommentFeed( argumentCollection = arguments );
				} else {
					rssfeed = buildContentFeed( argumentCollection = arguments );
				}
				break;
			}
		}
		// end content type switch

		// Cache it with settings
		if ( settings.cb_rss_caching ) {
			variables.cache.set(
				cacheKey,
				rssFeed,
				settings.cb_rss_cachingTimeout,
				settings.cb_rss_cachingTimeoutIdle
			);
		}

		return rssFeed;
	}

	/************************************** PRIVATE *********************************************/

	/**
	 * Build entries feeds
	 *
	 * @category The category to filter on
	 * @siteID   The site to filter on
	 */
	private function buildEntryFeed( string category = "", string siteID = "" ){
		var settings     = settingService.getAllSettings();
		var entryResults = entryService.findPublishedContent(
			category: arguments.category,
			max     : settings.cb_rss_maxEntries,
			siteID  : arguments.siteID
		);
		var myArray    = [];
		var feedStruct = {};
		var columnMap  = {};
		var qEntries   = entityToQuery( entryResults.content );

		// max checks
		if ( settings.cb_rss_maxEntries lt entryResults.count ) {
			entryResults.count = settings.cb_rss_maxEntries;
		}

		// Create the column maps
		columnMap.title        = "title";
		columnMap.description  = "content";
		columnMap.pubDate      = "publishedDate";
		columnMap.link         = "link";
		columnMap.author       = "author";
		columnMap.category_tag = "categories";

		// Add necessary columns to query
		queryAddColumn( qEntries, "link", myArray );
		queryAddColumn( qEntries, "linkComments", myArray );
		queryAddColumn( qEntries, "author", myArray );
		queryAddColumn( qEntries, "categories", myArray );
		queryAddColumn( qEntries, "content", myArray );
		queryAddColumn( qEntries, "guid_permalink", myArray );
		queryAddColumn( qEntries, "guid_string", myArray );

		// Attach permalinks
		for ( var i = 1; i lte entryResults.count; i++ ) {
			// build URL to entry
			qEntries.link[ i ]           = variables.CBHelper.linkEntry( qEntries.slug[ i ] );
			qEntries.guid_permalink[ i ] = false;
			qEntries.guid_string[ i ]    = variables.CBHelper.linkEntry( qEntries.slug[ i ] );
			;
			qEntries.author[ i ]       = "#entryResults.content[ i ].getAuthorEmail()# (#entryResults.content[ i ].getAuthorName()#)";
			qEntries.linkComments[ i ] = variables.CBHelper.linkComments( entryResults.content[ i ] );
			qEntries.categories[ i ]   = entryResults.content[ i ].getCategoriesList();
			if ( entryResults.content[ i ].hasExcerpt() ) {
				qEntries.content[ i ] = entryResults.content[ i ].renderExcerpt();
			} else {
				qEntries.content[ i ] = entryResults.content[ i ].renderContent();
			}
			qEntries.content[ i ] = cleanupContent( qEntries.content[ i ] );
		}

		// Generate feed items
		feedStruct.title       = "Blog " & settings.cb_rss_title;
		feedStruct.generator   = settings.cb_rss_generator;
		feedStruct.copyright   = settings.cb_rss_copyright;
		feedStruct.description = settings.cb_rss_description;
		if ( len( settings.cb_rss_webmaster ) ) feedStruct.webmaster = settings.cb_rss_webmaster;
		feedStruct.pubDate       = now();
		feedStruct.lastbuilddate = now();
		feedStruct.link          = variables.CBHelper.linkHome();
		feedStruct.items         = qEntries;

		return variables.feedGenerator.createFeed( feedStruct, columnMap );
	}

	/**
	 * Build pages feeds
	 *
	 * @category The category to filter on
	 * @siteID   The site to filter on
	 */
	private function buildPageFeed( string category = "", string siteID = "" ){
		var settings    = settingService.getAllSettings();
		var pageResults = variables.pageService.findPublishedContent(
			category: arguments.category,
			max     : settings.cb_rss_maxEntries,
			siteID  : arguments.siteID
		);
		var myArray    = [];
		var feedStruct = {};
		var columnMap  = {};
		var qPages     = entityToQuery( pageResults.content );

		// max checks
		if ( settings.cb_rss_maxEntries lt pageResults.count ) {
			pageResults.count = settings.cb_rss_maxEntries;
		}

		// Create the column maps
		columnMap.title        = "title";
		columnMap.description  = "content";
		columnMap.pubDate      = "publishedDate";
		columnMap.link         = "link";
		columnMap.author       = "author";
		columnMap.category_tag = "categories";

		// Add necessary columns to query
		queryAddColumn( qPages, "link", myArray );
		queryAddColumn( qPages, "linkComments", myArray );
		queryAddColumn( qPages, "author", myArray );
		queryAddColumn( qPages, "categories", myArray );
		queryAddColumn( qPages, "content", myArray );
		queryAddColumn( qPages, "guid_permalink", myArray );
		queryAddColumn( qPages, "guid_string", myArray );

		// Attach permalinks
		for ( var i = 1; i lte pageResults.count; i++ ) {
			// build URL to entry
			qPages.link[ i ]           = variables.CBHelper.linkPage( qPages.slug );
			qPages.author[ i ]         = "#pageResults.content[ i ].getAuthorEmail()# (#pageResults.content[ i ].getAuthorName()#)";
			qPages.linkComments[ i ]   = variables.CBHelper.linkComments( pageResults.content[ i ] );
			qPages.categories[ i ]     = pageResults.content[ i ].getCategoriesList();
			qPages.guid_permalink[ i ] = false;
			qPages.guid_string[ i ]    = variables.CBHelper.linkPage( qPages.slug );
			if ( pageResults.content[ i ].hasExcerpt() ) {
				qPages.content[ i ] = pageResults.content[ i ].renderExcerpt();
			} else {
				qPages.content[ i ] = pageResults.content[ i ].renderContent();
			}
			qPages.content[ i ] = cleanupContent( qPages.content[ i ] );
		}

		// Generate feed items
		feedStruct.title       = "Page " & settings.cb_rss_title;
		feedStruct.generator   = settings.cb_rss_generator;
		feedStruct.copyright   = settings.cb_rss_copyright;
		feedStruct.description = settings.cb_rss_description;
		if ( len( settings.cb_rss_webmaster ) ) feedStruct.webmaster = settings.cb_rss_webmaster;
		feedStruct.pubDate       = now();
		feedStruct.lastbuilddate = now();
		feedStruct.link          = CBHelper.linkHome();
		feedStruct.items         = qPages;

		return variables.feedGenerator.createFeed( feedStruct, columnMap );
	}

	/**
	 * Build content feeds
	 *
	 * @category The category to filter on
	 * @siteID   The site to filter on
	 */
	private function buildContentFeed( string category = "", string siteID = "" ){
		var settings       = variables.settingService.getAllSettings();
		var contentResults = variables.contentService.findPublishedContent(
			category: arguments.category,
			max     : settings.cb_rss_maxEntries,
			siteID  : arguments.siteID
		);
		var myArray    = [];
		var feedStruct = {};
		var columnMap  = {};
		var qContent   = entityToQuery( contentResults.content );

		// max checks
		if ( settings.cb_rss_maxEntries lt contentResults.count ) {
			contentResults.count = settings.cb_rss_maxEntries;
		}

		// Create the column maps
		columnMap.title        = "title";
		columnMap.description  = "content";
		columnMap.pubDate      = "publishedDate";
		columnMap.link         = "link";
		columnMap.author       = "author";
		columnMap.category_tag = "categories";

		// Add necessary columns to query
		queryAddColumn( qContent, "link", myArray );
		queryAddColumn( qContent, "linkComments", myArray );
		queryAddColumn( qContent, "author", myArray );
		queryAddColumn( qContent, "categories", myArray );
		queryAddColumn( qContent, "content", myArray );
		queryAddColumn( qContent, "guid_permalink", myArray );
		queryAddColumn( qContent, "guid_string", myArray );

		// Attach permalinks
		for ( var i = 1; i lte contentResults.count; i++ ) {
			// Check for empty authors, just in case.
			var authorEmail = len( contentResults.content[ i ].getAuthorEmail() ) ? contentResults.content[ i ].getAuthorEmail() : "nobody@nobody.com";
			var authorName  = len( contentResults.content[ i ].getAuthorName() ) ? contentResults.content[ i ].getAuthorName() : "nobody";

			// build URL to entry
			qContent.link[ i ]           = CBHelper.linkContent( contentResults.content[ i ] );
			qContent.author[ i ]         = "#authorEmail# (#authorName#)";
			qContent.linkComments[ i ]   = CBHelper.linkComments( contentResults.content[ i ] );
			qContent.categories[ i ]     = contentResults.content[ i ].getCategoriesList();
			qContent.content[ i ]        = cleanupContent( contentResults.content[ i ].renderContent() );
			qContent.guid_permalink[ i ] = false;
			qContent.guid_string[ i ]    = CBHelper.linkContent( contentResults.content[ i ] );
		}

		// Generate feed items
		feedStruct.title       = "Content " & settings.cb_rss_title;
		feedStruct.generator   = settings.cb_rss_generator;
		feedStruct.copyright   = settings.cb_rss_copyright;
		feedStruct.description = settings.cb_rss_description;
		if ( len( settings.cb_rss_webmaster ) ) feedStruct.webmaster = settings.cb_rss_webmaster;
		feedStruct.pubDate       = now();
		feedStruct.lastbuilddate = now();
		feedStruct.link          = CBHelper.linkHome();
		feedStruct.items         = qContent;

		return variables.feedGenerator.createFeed( feedStruct, columnMap );
	}

	/**
	 * Build comment feeds according to filtering elements
	 *
	 * @slug        The content slug to filter on
	 * @contentType The content type discriminator to filter on
	 * @siteID      The site to filter on
	 */
	private function buildCommentFeed(
		string slug        = "",
		string contentType = "",
		string siteID      = ""
	){
		var settings       = variables.settingService.getAllSettings();
		var commentResults = variables.commentService.findAllApproved(
			contentID  : variables.contentService.getIDBySlug( arguments.slug ),
			contentType: arguments.contentType,
			max        : settings.cb_rss_maxComments,
			siteID     : arguments.siteID
		);
		var myArray    = [];
		var feedStruct = {};
		var columnMap  = {};
		var qComments  = entityToQuery( commentResults.comments );

		// Create the column maps
		columnMap.title        = "title";
		columnMap.description  = "content";
		columnMap.pubDate      = "createddate";
		columnMap.link         = "link";
		columnMap.author       = "rssAuthor";
		columnMap.category_tag = "categories";

		// Add necessary columns to query
		queryAddColumn( qComments, "title", myArray );
		queryAddColumn( qComments, "linkComments", myArray );
		queryAddColumn( qComments, "rssAuthor", myArray );
		queryAddColumn( qComments, "guid_permalink", myArray );
		queryAddColumn( qComments, "guid_string", myArray );

		// Attach permalinks
		for ( var i = 1; i lte commentResults.count; i++ ) {
			// build URL to entry
			qComments.title[ i ]          = "Comment by #qComments.author[ i ]# on #commentResults.comments[ i ].getParentTitle()#";
			qComments.rssAuthor[ i ]      = "#qComments.authorEmail# (#qComments.author#)";
			qComments.linkComments[ i ]   = CBHelper.linkComment( commentResults.comments[ i ] );
			qComments.content[ i ]        = cleanupContent( qComments.content[ i ] );
			qComments.guid_permalink[ i ] = false;
			qComments.guid_string[ i ]    = CBHelper.linkComment( commentResults.comments[ i ] );
		}

		// Generate feed items
		feedStruct.title       = "Comments " & settings.cb_rss_title;
		feedStruct.generator   = settings.cb_rss_generator;
		feedStruct.copyright   = settings.cb_rss_copyright;
		feedStruct.description = settings.cb_rss_description;
		if ( len( settings.cb_rss_webmaster ) ) feedStruct.webmaster = settings.cb_rss_webmaster;
		feedStruct.pubDate       = now();
		feedStruct.lastbuilddate = now();
		feedStruct.link          = CBHelper.linkHome();
		feedStruct.items         = qComments;

		return variables.feedGenerator.createFeed( feedStruct, columnMap );
	}

	/**
	 * Cleanup HTML to normal strings to avoid parsing issues
	 */
	private function cleanupContent( required content ){
		return reReplaceNoCase( arguments.content, "<[^>]*>", "", "all" );
	}

}
