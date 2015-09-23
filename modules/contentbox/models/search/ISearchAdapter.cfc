/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* The official ContentBox Search Interface
*/
interface{

	/**
	* Search content and return an standardized ContentBox Results object.
	* @searchTerm.hint The search term to search on
	* @max.hint The max results to return if paging
	* @offset.hint The offset to use in the search results if paging
	*/
	contentbox.models.search.SearchResults function search(required string searchTerm,numeric max=0,numeric offset=0);
	
	/**
	* If chosen to be implemented, it should refresh search indexes and collections
	*/
	contentbox.models.search.ISearchAdapter function refresh();

	/**
	* Render the search results according to the adapter and return HTML
	* @searchTerm.hint The search term to search on
	* @max.hint The max results to return if paging
	* @offset.hint The offset to use in the search results if paging
	*/	
	any function renderSearch(required string searchTerm, numeric max=0, numeric offset=0);
	
	/**
	* Render the search results according the passed in search results object
	* @searchResults.hint The search results object
	*/	
	any function renderSearchWithResults(required contentbox.models.search.SearchResults searchResults);
	
}