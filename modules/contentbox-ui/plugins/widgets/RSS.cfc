/**
* A widget that reads an RSS feed and displays the items
*/
component extends="contentbox.model.ui.BaseWidget" singleton{

	RSS function init(controller){
		// super init
		super.init(controller);

		// Widget Properties
		setPluginName("RSS");
		setPluginVersion("1.0");
		setPluginDescription("A widget that reads an RSS feed and displays the items");
		setPluginAuthor("Ortus Solutions");
		setPluginAuthorURL("www.ortussolutions.com");

		return this;
	}

	/**
	* A widget that reads an RSS feed and displays the items
	* @feedURL.hint The rss feed URL
	* @maxItems.hint The maximum number of items to display, default is 5
	* @showBody.hint Show the body of the feed item or not, default is true
	* @linkTarget.hint The link target (HTML) for the RSS item link, defaults to _blank
 	* @title.hint The title to show before the dropdown or list, defaults to H2
	* @titleLevel.hint The H{level} to use, by default we use H2
	*/
	any function renderIt(required feedURL,numeric maxItems=5,boolean showBody=true,string linkTarget="_blank",string title="",string titleLevel="2"){
		var rString		= "";
		var feed 		= getPlugin('FeedReader').readFeed(feedURL=arguments.feedURL,maxItems=arguments.maxItems,itemsType="query");

		// generate recent comments
		saveContent variable="rString"{
			// title
			if( len(arguments.title) ){ writeOutput("<h#arguments.titleLevel#>#arguments.title#</h#arguments.titleLevel#>"); }
			// build RSS feed
			writeOutput( buildList(feed.items,arguments.showBody,arguments.linkTarget) );
		}

		return rString;
	}

	private function buildList(required entries,required showBody,required linkTarget){
		var rString = "";
		// generate Items
		saveContent variable="rString"{
			writeOutput('<ul class="rssItems">');
			// iterate and create
			for(var x=1; x lte arguments.entries.recordcount; x++){
				writeOutput('<li class="rssItem"><a href="#arguments.entries.URL[x]#" target="#arguments.linkTarget#">#arguments.entries.title[x]#');
				if( arguments.showBody ){
					writeOutput('<br/>#arguments.entries.body[x]#');
				}
				writeOutput('</li>');
			}
			// close ul
			writeOutput("</ul>");
		}
		return rString;
	}

}
