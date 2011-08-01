/**
* RSS Service for this application
*/
component singleton{

	// Dependecnies
	property name="settingService"		inject="id:settingService@bb";
	property name="entryService"		inject="id:entryService@bb";
	property name="commentService"		inject="id:commentService@bb";
	property name="feedGenerator" 		inject="coldbox:plugin:feedGenerator";
	property name="bbHelper"			inject="coldbox:myplugin:BBHelper@blogbox-ui";
	property name="log"					inject="logbox:logger:{this}";
	

	function init(){
		return this;
	}
	
	/**
	* Build RSS feeds for BlogBox
	*/
	function getRSS(boolean comments=false,category="",entrySlug=""){
		var rssFeed = "";
		
		// Building comment feed or entry feed
		switch(arguments.comments){
			case true : { rssfeed = buildCommentFeed(argumentCollection=arguments); }
			default   : { rssfeed = buildEntryFeed(argumentCollection=arguments); }
		}
		
		return rssFeed;		
	}
	
	/**
	* Build entries feeds
	* @category The category to filter on if needed
	*/	
	function buildEntryFeed(category=""){
		var settings		= settingService.getAllSettings(asStruct=true);
		var entryResults 	= entryService.findPublishedEntries(category=arguments.category,max=settings.bb_paging_maxRSSEntries,asQuery=true);
		var myArray 		= [];
		var feedStruct 		= {};
		var columnMap 		= {};
		
		// Create the column maps
		columnMap.title 		= "title";
		columnMap.description 	= "content";
		columnMap.pubDate 		= "publishedDate";
		columnMap.link 			= "link";
		
		// Add necessary columns to query
		QueryAddColumn(entryResults.entries, "link", myArray);
		writeDump(entryResults);abort;
		
		// Build it
		for(var i = 1; i <= entryResults.count; i++){
			// build URL to entry
			entryResults.entries.link[i] = "";
			
			// if feedType is simple, shorten entryBody length
			if (arguments.feedType EQ "simple"){
				entries.body[i] = Left(entries.body[i],maxRSSBodyLength) & "...&nbsp;&nbsp;&nbsp;<a href='#entries.link[i]#'>read more</a>";
			}
		}
		
		feedStruct.title = "Simple Blog 5";
		feedStruct.description = "A blog built with ColdBox in order to learn ColdBox.";
		feedStruct.pubDate = "#now()#";
		feedStruct.link = baseUrl;
		feedStruct.items = entries;
		return feedGenerator.createFeed(feedStruct,columnMap);
	}

}