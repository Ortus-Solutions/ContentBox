/**
* RSS Service for this application
*/
component singleton{

	// Dependecnies
	property name="entryService" 		inject="model";
	property name="feedGenerator" 		inject="coldbox:plugin:feedGenerator";
	property name="baseURL"				inject="coldbox:setting:SESBaseURL";
	property name="maxRSSBodyLength" 	inject="coldbox:setting:maxRSSBodyLength";

	function init(){
		return this;
	}
	
	function getRSS(string feedType="full"){
		
		var entries 	= entryService.getLatestEntries(asQuery=true);
		var myArray 	= [];
		var feedStruct 	= {};
		var columnMap 	= {};
		
		// Verify feedtype
		if( NOT reFindNocase("^(full|simple)", arguments.feedType) ){
			arguments.feedType = "full";
		}
		
		// Create the column maps
		columnMap.title = "title";
		columnMap.description = "body";
		columnMap.pubDate = "time";
		columnMap.link = "link";
		
		QueryAddColumn(entries, "link", myArray);
		
		for(i = 1; i <= entries.recordCount; i = i + 1){
			entries.link[i] = baseUrl & "entry/" & entries.entryID[i];
			
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
