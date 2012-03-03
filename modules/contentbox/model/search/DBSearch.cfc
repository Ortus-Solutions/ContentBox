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
Our DB Search Adapter
*/
component accessors="true" implements="contentbox.model.search.ISearchAdapter" singleton{

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
	* @searchTerm.hint The search term to search on
	* @max.hint The max results to return if paging
	* @offset.hint The offset to use in the search results if paging
	*/
	contentbox.model.search.SearchResults function search(required string searchTerm, numeric max=0, numeric offset=0){
		// get new search results object
		var searchResults = wirebox.getInstance("SearchResults@cb");
		var sTime = getTickCount();

		try{
			var results = contentService.searchContent(offset=arguments.offset,max=arguments.max,searchTerm=arguments.searchTerm);
			var args = {
				results = results.content,
				total = results.count,
				searchTime = getTickCount() - sTime,
				searchTerm = arguments.searchTerm,
				error = false
			};
			searchResults.populate(args);
		}
		catch(Any e){
			searchResults.setError(true);
			searchResults.setErrorMessages(["Error executing content search: #e.detail# #e.message#"]);
		}

		return searchResults;
	}

	/**
	* If chosen to be implemented, it should refresh search indexes and collections
	*/
	contentbox.model.search.ISearchAdapter function refresh(){}

	/**
	* Render the search results according to the adapter and returns HTML
	* @searchResults.hint The search results object
	*/
	any function renderSearch(required string searchTerm, numeric max=0, numeric offset=0){
		var searchResults = search(argumentCollection=arguments);
		return renderSearchWithResults( searchResults );
	}

	/**
	* Render the search results according the passed in search results object
	* @searchResults.hint The search results object
	*/
	any function renderSearchWithResults(required contentbox.model.search.SearchResults searchResults){
		var results 	= "";
		var searchItems = arguments.searchResults.getResults();
		var total	 	= arguments.searchResults.getTotal();
		var searchTerm  = arguments.searchResults.getSearchTerm();

		savecontent variable="results"{
			writeOutput('
			<div class="searchResults">
				<div class="searchResultsCount">
					Found <strong>#total#</strong> results in <strong>#arguments.searchResults.getSearchTime()#</strong>ms!
				</div>
				<ol>
			');

			for(var item in searchItems ){
				writeOutput('
				<li>
					<a href="#cb.linkContent(item)#">#item.getTitle()#</a><br/>
					#highlightSearchTerm( searchTerm, item.renderContent() )#
				</li>
				<cite>#item.getContentType()# -> #cb.linkContent(item)#</cite><br/>
				<cite>Categories: #item.getCategoriesList()#</cite>
				<br /><br />
				');
			};

			writeOutput("</ol></div>");
		}

		return results;
	}


	/**
	* Utility function to help you highlight search terms in content
	* @term.hint The search term
	* @content.hint The content searched
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

		excerpt = htmlEditFormat( excerpt );

		try{
			excerpt = reReplaceNoCase(excerpt, "(#arguments.term#)", "<span class='highlight'>\1</span>","all");
		}
		catch(Any e){}

		// remove images
		//excerpt = reReplaceNoCase(excerpt, '<img\s[^//>].*//?>',"[image]","all");
		// remove links
		//excerpt = reReplaceNoCase(excerpt, '<a\b[^>]*>(.*?)</a>',"[link]","all");

		return excerpt;
	}

}