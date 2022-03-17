/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * The official ContentBox Search Interface
 */
interface {

	/**
	 * Search content and return an standardized ContentBox Results object.
	 *
	 * @searchTerm The search term to search on
	 * @max        The max results to return if paging
	 * @offset     The offset to use in the search results if paging
	 * @siteID     The site id to search on if passed
	 *
	 * @return SearchResults object with the results
	 */
	contentbox.models.search.SearchResults function search(
		required string searchTerm,
		numeric max    = 0,
		numeric offset = 0,
		string siteID  = ""
	);

	/**
	 * If chosen to be implemented, it should refresh search indexes and collections
	 *
	 * @return Itself
	 */
	contentbox.models.search.ISearchAdapter function refresh();

	/**
	 * Render the search results according to the adapter and return HTML
	 *
	 * @searchTerm The search term to search on
	 * @max        The max results to return if paging
	 * @offset     The offset to use in the search results if paging
	 *
	 * @return The search html
	 */
	any function renderSearch(
		required string searchTerm,
		numeric max    = 0,
		numeric offset = 0
	);

	/**
	 * Render the search results according the passed in search results object
	 *
	 * @searchResults The search results object
	 *
	 * @return The search html
	 */
	any function renderSearchWithResults( required contentbox.models.search.SearchResults searchResults );

}
