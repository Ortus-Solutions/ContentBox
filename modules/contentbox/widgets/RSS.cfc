/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A widget that reads an RSS feed and displays the items
 */
component extends="contentbox.models.ui.BaseWidget" singleton {

	/**
	 * Constructor
	 */
	RSS function init(){
		// Widget Properties
		setName( "RSS" );
		setVersion( "1.0" );
		setDescription( "A widget that reads an RSS feed and displays the items as you see fit." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "https://www.ortussolutions.com" );
		setCategory( "Content" );
		setIcon( "rss" );
		return this;
	}

	/**
	 * A widget that reads an RSS feed and displays the items
	 *
	 * @feedURL    The rss feed URL
	 * @maxItems   The maximum number of items to display, default is 5
	 * @showBody   Show the body of the feed item or not, default is true
	 * @linkTarget The link target (HTML) for the RSS item link, defaults to _blank
	 * @title      The title to show before the dropdown or list, defaults to H2
	 * @titleLevel The H{level} to use, by default we use H2
	 */
	any function renderIt(
		required feedURL,
		numeric maxItems  = 5,
		boolean showBody  = true,
		string linkTarget = "_blank",
		string title      = "",
		string titleLevel = "2"
	){
		// Detect Feed URL
		if ( !len( arguments.feedURL ) ) {
			return "Please enter a valid RSS Feed URL";
		}

		var rString = "";
		var feed    = getInstance( "FeedReader@cbfeeds" ).readFeed(
			feedURL   = arguments.feedURL,
			maxItems  = arguments.maxItems,
			itemsType = "query"
		);

		// generate recent comments
		saveContent variable="rString" {
			// title
			if ( len( arguments.title ) ) {
				writeOutput(
					"<h#arguments.titlelevel#>#arguments.title#</h#arguments.titlelevel#>
"
				);
			}
			// build RSS feed
			writeOutput(
				buildList(
					feed.items,
					arguments.showBody,
					arguments.linkTarget
				)
			);
		}

		return rString;
	}

	/**
	 * Build List of rss items
	 *
	 * @entries    query
	 * @showBody   show body of content or not
	 * @linkTarget the link target
	 */
	private function buildList(
		required entries,
		required boolean showBody,
		required linkTarget
	){
		var rString = "";

		// cfformat-ignore-start
		// generate Items
		saveContent variable="rString"{
			writeOutput( '<ul class="rssItems">
	' );
			// iterate and create
			for( var x=1; x lte arguments.entries.recordcount; x++ ){
				writeOutput( '<li class="rssItem">
		<a href="#arguments.entries.URL[ x ]#" target="#arguments.linkTarget#">#arguments.entries.title[ x ]#' );
				if( arguments.showBody ){
					writeOutput( '<br/>#arguments.entries.body[ x ]#' );
				}
				writeOutput( '
	</li>
	' );
			}
			// close ul
			writeOutput( '
</ul>
' );
		}

		// cfformat-ignore-end

		return rString;
	}

}
