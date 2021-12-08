/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * The official ContentBox Search Results Object
 */
component accessors="true" {

	property
		name="results"
		type="any"
		hint="The search results in query or array or whatever format";

	property
		name="total"
		type="numeric"
		hint="The total number of records found";

	property
		name="searchTime"
		type="numeric"
		hint="The amount of time it took for the search in milliseconds";

	property
		name="searchTerm"
		type="string"
		hint="The search term used";

	property
		name="error"
		type="boolean"
		hint="Mark if the search results produce an error or not";

	property
		name="errorMessages"
		type="array"
		hint="An array of error messagse if any";

	property
		name="metadata"
		type="struct"
		hint="Any metadata structure you wish to store";

	/**
	 * Constructor
	 */
	function init(){
		variables.results       = [];
		variables.searchTime    = 0;
		variables.total         = 0;
		variables.metadata      = {};
		variables.error         = false;
		variables.errorMessages = [];
		variables.searchTerm    = "";

		return this;
	}

	/**
	 * Populate a search memento
	 *
	 * @return SearchResults
	 */
	any function populate( required struct memento ){
		for ( var key in arguments.memento ) {
			if ( structKeyExists( variables, key ) ) {
				variables[ key ] = arguments.memento[ key ];
			}
		}
		return this;
	}

	/**
	 * Get the search memento
	 *
	 * @return struct of { "results","searchTime","total","metadata","error","errorMessages","searchTerm" }
	 */
	struct function getMemento(){
		return {
			"results"       : results,
			"searchTime"    : searchTime,
			"total"         : total,
			"metadata"      : metadata,
			"error"         : error,
			"errorMessages" : errorMessages,
			"searchTerm"    : searchTerm
		};
	}

}
