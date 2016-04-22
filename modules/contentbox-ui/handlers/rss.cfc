/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Handles RSS Feeds
*/
component extends="content"{

	/**
	* Display the RSS feeds for the ContentBox
	*/
	function index(event,rc,prc){
		// params
		event.paramValue( "category","" );
		event.paramValue( "contentSlug","" );
		event.paramValue( "commentRSS",false);

		// Build out the site RSS feeds
		var feed = RSSService.getRSS(comments=rc.commentRSS,category=rc.category,slug=rc.contentSlug);

		// Render out the feed xml
		event.renderData(type="plain",data=feed,contentType="text/xml" );
	}

	/**
	* Display the RSS feeds for the pages
	*/
	function pages(event,rc,prc){
		// params
		event.paramValue( "category","" );
		event.paramValue( "commentRSS",false);
		event.paramValue( "slug","" );

		// Build out the site RSS feeds
		var feed = RSSService.getRSS(category=rc.category,slug=rc.slug,comments=rc.commentRSS,contentType="Page" );

		// Render out the feed xml
		event.renderData(type="plain",data=feed,contentType="text/xml" );
	}

}