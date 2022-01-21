/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A cool basic widget that shows N recent comments
 */
component extends="contentbox.models.ui.BaseWidget" singleton {

	RecentComments function init(){
		// Widget Properties
		setName( "RecentComments" );
		setVersion( "1.0" );
		setDescription( "A cool basic widget that shows N recent comments from any content object" );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "https://www.ortussolutions.com" );
		setIcon( "comments" );
		setCategory( "Content" );
		return this;
	}

	/**
	 * Show n recent comments
	 *
	 * @ma.hint         The number of recent comments to show. By default it shows 5
	 * @maxChars.hint   The maximum character length to show for comment contents
	 * @title.hint      An optional title to display using an H2 tag.
	 * @titleLevel.hint The H{level} to use, by default we use H2
	 */
	any function renderIt(
		numeric max       = 5,
		numeric maxChars  = 80,
		string title      = "",
		string titleLevel = "2"
	){
		var event          = getRequestContext();
		var cbSettings     = event.getValue( name = "cbSettings", private = true );
		var commentResults = commentService.findAllApproved( max = arguments.max );
		var rString        = "";

		// iteration cap
		if ( commentResults.count lt arguments.max ) {
			arguments.max = commentResults.count;
		}

		// generate recent comments
		saveContent variable="rString" {
			// title
			if ( len( arguments.title ) ) {
				writeOutput(
					"<h#arguments.titlelevel#>#arguments.title#</h#arguments.titlelevel#>
"
				);
			}
			// UL start
			writeOutput(
				"<ul id=""recentComments"">
	"
			);
			// iterate and create
			for ( var x = 1; x lte arguments.max; x++ ) {
				writeOutput(
					"<li class=""recentComments"">
		#commentResults.comments[ x ].getAuthor()# said
<a href=""#cb.linkComment( commentResults.comments[ x ] )#"">#left( commentResults.comments[ x ].getContent(), arguments.maxChars )#</a>
	</li>
	"
				);
			}
			// close ul
			writeOutput(
				"
</ul>
"
			);
		}

		return rString;
	}

}
