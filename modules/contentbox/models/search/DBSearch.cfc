/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Our DB Search Adapter
*/
component accessors="true" implements="contentbox.models.search.ISearchAdapter" singleton{

	// DI
	property name="contentService"			inject="id:contentService@cb";
	property name="cb"						inject="id:cbHelper@cb";
	property name="wirebox"					inject="wirebox";

	// constructor
	function init(){
		return this;
	}

	/**
	* Search content and return an standardized ContentBox Results object.
	* @searchTerm The search term to search on
	* @max The max results to return if paging
	* @offset The offset to use in the search results if paging
	*/
	contentbox.models.search.SearchResults function search( required string searchTerm, numeric max=0, numeric offset=0 ){
		// get new search results object
		var searchResults 	= wirebox.getInstance( "SearchResults@cb" );
		var sTime 			= getTickCount();

		try{
			var results = contentService.searchContent(
				offset			= arguments.offset,
				max				= arguments.max,
				searchTerm		= arguments.searchTerm,
				showInSearch	= true,
				contentTypes	= "Page,Entry"
			);
			var args = {
				results 	= results.content,
				total 		= results.count,
				searchTime 	= getTickCount() - sTime,
				searchTerm 	= arguments.searchTerm,
				error 		= false
			};
			searchResults.populate( args );
		} catch( Any e ) {
			searchResults.setError( true );
			searchResults.setErrorMessages( [ "Error executing content search: #e.detail# #e.message#" ] );
		}

		return searchResults;
	}

	/**
	* If chosen to be implemented, it should refresh search indexes and collections
	*/
	contentbox.models.search.ISearchAdapter function refresh(){}

	/**
	* Render the search results according to the adapter and returns HTML
	* @searchResults The search results object
	*/
	any function renderSearch( required string searchTerm, numeric max=0, numeric offset=0 ){
		var searchResults = search(argumentCollection=arguments);
		return renderSearchWithResults( searchResults );
	}

	/**
	* Render the search results according the passed in search results object
	* @searchResults The search results object
	*/
	any function renderSearchWithResults(required contentbox.models.search.SearchResults searchResults){
		var results 	= "";
		var searchItems = arguments.searchResults.getResults();
		var total	 	= arguments.searchResults.getTotal();
		var searchTerm  = arguments.searchResults.getSearchTerm();

		savecontent variable="results"{
			writeOutput('
			<div class="searchResults">
				<div class="well well-sm searchResultsCount">
					Found <strong>#total#</strong> results in <strong>#arguments.searchResults.getSearchTime()#</strong>ms!
				</div>
			');

			for(var item in searchItems ){
				writeOutput( '
				<div class="panel panel-default">
  					<div class="panel-heading">
						<a href="#cb.linkContent(item)#" class="panel-title">#item.getTitle()#</a>
					</div>
					<div class="panel-body">
						<p>#highlightSearchTerm( searchTerm, stripHTML( item.renderContent() ))#</p>
						<cite><span class="label label-primary">#item.getContentType()#</span> : <a href="#cb.linkContent(item)#">#cb.linkContent(item)#</a></cite><br/>
					</div>
				' );


				if( item.hasCategories() ){
					writeOutput( '<div class="panel-footer"><cite>Categories: ' );
					for( var categoryItem in #item.getCategoriesList()# ){
						writeOutput(' <span class="label label-primary">#categoryItem#</span>' );
					}
					writeOutput( '</cite></div>' );
				}

				writeOutput('</div>');

			};

			writeOutput( "</div>" );
		}

		return results;
	}

	/**
	* utility to strip HTML
	*/
	private function stripHTML(stringTarget){
		return REReplaceNoCase( arguments.stringTarget, "<[^>]*>", "", "ALL" );
	}

	/**
	* Utility function to help you highlight search terms in content
	* @term The search term
	* @content The content searched
	*/
	private function highlightSearchTerm(required term, required content){
		var match 	= findNoCase(arguments.term, arguments.content);
		var end		= 0;
		var excerpt = "";

		if( match lte 250 ){ match = 1; }
		end = match + len(arguments.term) + 500;

		if( len(arguments.content) gt 500 ){
			if( match gt 1 ){
				excerpt = "..." & mid(arguments.content, match-250, end-match);
			}
			else{
				excerpt = left(arguments.content, end);
			}
			if( len(arguments.content) gt end ){
				excerpt = excerpt & "...";
			}
		}
		else{
			excerpt = arguments.content;
		}

		try{
			excerpt = reReplaceNoCase(excerpt, "(#arguments.term#)", "<span class='highlight'>\1</span>","all" );
		}
		catch(Any e){}

		// remove images
		//excerpt = reReplaceNoCase(excerpt, '<img\s[^//>].*//?>',"[image]","all" );
		// remove links
		//excerpt = reReplaceNoCase(excerpt, '<a\b[^>]*>(.*?)</a>',"[link]","all" );

		return excerpt;
	}

}