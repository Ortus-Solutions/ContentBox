/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Our DB Search Adapter that should implement contentbox.models.search.ISearchAdapter
 *
 * @see contentbox.models.search.ISearchAdapter
 */
component accessors="true" singleton {

	// DI
	property name="contentService" inject="contentService@contentbox";
	property name="cb" inject="cbHelper@contentbox";
	property name="wirebox" inject="wirebox";

	/**
	 * Constructor
	 */
	DBSearch function init(){
		return this;
	}

	/**
	 * Search content and return an standardized ContentBox Results object.
	 *
	 * @searchTerm The search term to search on
	 * @max The max results to return if paging
	 * @offset The offset to use in the search results if paging
	 * @siteID The site to filter on if passed
	 *
	 * @return contentbox.models.search.SearchResults Object
	 */
	SearchResults function search(
		required string searchTerm,
		numeric max    = 0,
		numeric offset = 0,
		string siteID  = ""
	){
		// get new search results object
		var searchResults = variables.wirebox.getInstance( "SearchResults@contentbox" );
		var sTime         = getTickCount();

		try {
			var results = variables.contentService.searchContent(
				offset      : arguments.offset,
				max         : arguments.max,
				searchTerm  : arguments.searchTerm,
				showInSearch: true,
				contentTypes: "Page,Entry",
				siteID      : arguments.siteID
			);

			// populate the search results
			searchResults.populate( {
				results    : results.content,
				total      : results.count,
				searchTime : getTickCount() - sTime,
				searchTerm : arguments.searchTerm,
				error      : false
			} );
		} catch ( Any e ) {
			searchResults.setError( true );
			searchResults.setErrorMessages( [ "Error executing content search: #e.detail# #e.message#" ] );
		}

		return searchResults;
	}

	/**
	 * If chosen to be implemented, it should refresh search indexes and collections
	 *
	 * @return contentbox.models.search.ISearchAdapter
	 */
	DBSearch function refresh(){
	}

	/**
	 * Render the search results according to the adapter and returns HTML
	 *
	 * @searchResults The search results object
	 */
	any function renderSearch(
		required string searchTerm,
		numeric max    = 0,
		numeric offset = 0
	){
		var searchResults = search( argumentCollection = arguments );
		return renderSearchWithResults( searchResults );
	}

	/**
	 * Render the search results according the passed in search results object
	 *
	 * @searchResults The search results object
	 */
	any function renderSearchWithResults( required SearchResults searchResults ){
		var results     = "";
		var searchItems = arguments.searchResults.getResults();
		var total       = arguments.searchResults.getTotal();
		var searchTerm  = arguments.searchResults.getSearchTerm();

		// cfformat-ignore-start
		savecontent variable="results" {
			writeOutput(
				"
			<div class=""searchResults row"">
				<div class=""well well-sm searchResultsCount text-center mb-5"">
				 	<small> Found <strong>#total#</strong> results in <strong>#arguments.searchResults.getSearchTime()#</strong>ms!</small>
				</div>
			"
			);

			for ( var item in searchItems ) {
				writeOutput(
					"
				<div class=""col-md-6""> 
				<div class=""card mb-5"">
  					<h4 class=""card-header card-title "">
						<a href=""#cb.linkContent( item )#"" class=""link-unstyled"">#item.getTitle()#</a>
					</h4>
					<div class=""card-body"">
						<p class=""card-text"">#highlightSearchTerm( searchTerm, stripHTML( item.renderContent() ) )#</p>
						<small>
							<a class=""nav-link"" href=""#cb.linkContent( item )#"">#item.getContentType()#: #cb.linkContent( item )#</a></span>
						</small>
					
				"
				);

				if ( item.hasCategories() ) {
					writeOutput( "<small> Categories:" );
					for ( var categoryItem in #item.getCategoriesList()# ) {
						writeOutput( " <span class=""label label-primary"">#categoryItem#</span>" );
					}
					writeOutput( "</small>" );
				}

				writeOutput( "</div> </div> </div>" );
			};

			writeOutput( "</div>" );
		}
		// cfformat-ignore-end

		return results;
	}

	/**
	 * utility to strip HTML
	 */
	private function stripHTML( stringTarget ){
		return reReplaceNoCase( arguments.stringTarget, "<[^>]*>", "", "ALL" );
	}

	/**
	 * Utility function to help you highlight search terms in content
	 * @term The search term
	 * @content The content searched
	 */
	private function highlightSearchTerm( required term, required content ){
		var match   = findNoCase( arguments.term, arguments.content );
		var end     = 0;
		var excerpt = "";

		if ( match lte 250 ) {
			match = 1;
		}
		end = match + len( arguments.term ) + 500;

		if ( len( arguments.content ) gt 500 ) {
			if ( match gt 1 ) {
				excerpt = "..." & mid( arguments.content, match - 250, end - match );
			} else {
				excerpt = left( arguments.content, end );
			}
			if ( len( arguments.content ) gt end ) {
				excerpt = excerpt & "...";
			}
		} else {
			excerpt = arguments.content;
		}

		try {
			excerpt = reReplaceNoCase(
				excerpt,
				"(#arguments.term#)",
				"<span class='highlight'>\1</span>",
				"all"
			);
		} catch ( Any e ) {
		}

		// remove images
		// excerpt = reReplaceNoCase(excerpt, '<img\s[^//>].*//?>',"[image]","all" );
		// remove links
		// excerpt = reReplaceNoCase(excerpt, '<a\b[^>]*>(.*?)</a>',"[link]","all" );

		return excerpt;
	}

}
