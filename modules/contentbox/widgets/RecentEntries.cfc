/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A cool basic widget that shows N recent entries
 */
component extends="contentbox.models.ui.BaseWidget" singleton {

	/**
	 * Constructor
	 */
	RecentEntries function init(){
		// Widget Properties
		setName( "RecentEntries" );
		setVersion( "1.0" );
		setDescription( "A cool basic widget that shows N recent blog entries." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "https://www.ortussolutions.com" );
		setIcon( "list" );
		setCategory( "Blog" );
		return this;
	}

	/**
	 * Show n recent entries with some cool orderings
	 *
	 * @max The number of recent entries to show. By default it shows 5
	 * @title An optional title to display using an H2 tag.
	 * @titleLevel The H{level} to use, by default we use H2
	 * @category The list of categories to filter on
	 * @category.multiOptionsUDF getAllCategories
	 * @searchTerm The search term to filter on
	 * @searchTerm.label Search Term
	 * @sortOrder How to order the results, defaults to publishedDate
	 * @sortOrder.label Sort Order
	 * @sortOrder.options Most Recent,Most Popular,Most Commented
	 */
	any function renderIt(
		numeric max       = 5,
		title             = "",
		string titleLevel = "2",
		string category   = "",
		string searchTerm = "",
		string sortOrder  = "Most Recent"
	){
		var event      = getRequestContext();
		var cbSettings = event.getPrivateValue( "cbSettings" );

		// Determine Sort Order
		switch ( arguments.sortOrder ) {
			case "Most Popular": {
				arguments.sortOrder = "hits DESC";
				break;
			}
			case "Most Commented": {
				arguments.sortOrder = "numberOfComments DESC";
				break;
			}
			default: {
				arguments.sortOrder = "publishedDate DESC";
			}
		}

		var entryResults = entryService.findPublishedContent(
			max       : arguments.max,
			category  : arguments.category,
			searchTerm: arguments.searchTerm,
			sortOrder : arguments.sortOrder,
			siteID    : getSite().getsiteID()
		);
		var rString = "";

		// iteration cap
		if ( entryResults.count lt arguments.max ) {
			arguments.max = entryResults.count;
		}

		// generate recent comments
		saveContent variable="rString" {
			// title
			if ( len( arguments.title ) ) {
				writeOutput(
					"<h#arguments.titlelevel# class=""text-center"">#arguments.title#</h#arguments.titlelevel#>
"
				);
			}
			// Row Start
			writeOutput(
				"<div id=""recentEntries"" class=""row row-cols-1 row-cols-md-3 g-4"">
	"
			);
			// iterate and create
			for ( var x = 1; x lte arguments.max; x++ ) {
				writeOutput(
					// Card creation
					"<div class=""col p-4"">
						<div class=""card shadow-sm border-0 h-100"">
							<div class=""card-body px-4"">
								<div class=""py-4"">
									<h3 class=""card=title"">#entryResults.content[ x ].getTitle()#</h3>
								</div>
								<p class=""card-text"">
								#entryResults.content[ x ].getExcerpt()#
								</p>
							</div>
							<div class=""card-footer"">
								<a class=""btn btn-secondary"" href=""#cb.linkEntry( entryResults.content[ x ] )#"">Read
									<svg xmlns=""http://www.w3.org/2000/svg"" width=""20"" fill=""currentColor"" viewBox=""0 0 24 24"" stroke=""currentColor"">
										<path stroke-linecap=""round"" stroke-linejoin=""round"" stroke-width=""2"" d=""M17 8l4 4m0 0l-4 4m4-4H3"" />
									</svg>
								</a>
							</div>
						</div>
					</div>
	"
				);
			}
			// close row
			writeOutput(
				"
</div>
"
			);
		}

		return rString;
	}

	/**
	 * Get all the categories
	 */
	array function getAllCategories() cbIgnore{
		return variables.categoryService.getAllNames();
	}

}
