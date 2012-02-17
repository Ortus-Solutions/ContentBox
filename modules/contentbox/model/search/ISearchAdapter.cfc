/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
The official ContentBox Search Interface
*/
interface{

	/**
	* Search content and return an standardized ContentBox Results object.
	* @searchTerm.hint The search term to search on
	* @max.hint The max results to return if paging
	* @offset.hint The offset to use in the search results if paging
	*/
	contentbox.model.search.SearchResults function search(required string searchTerm,numeric max=0,numeric offset=0);
	
	/**
	* If chosen to be implemented, it should refresh search indexes and collections
	*/
	contentbox.model.search.ISearchAdapter function refresh();

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
	any function renderSearchWithResults(required contentbox.model.search.SearchResults searchResults);
	
}