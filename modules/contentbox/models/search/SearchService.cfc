/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * The official ContentBox Search Service
 */
component accessors="true" {

	// DI
	property name="wirebox" inject="wirebox";
	property name="settingService" inject="settingService@contentbox";

	/**
	 * Constructor
	 */
	SearchService function init(){
		return this;
	}

	/**
	 * Return the actual ContentBox configured search adapter that should meet
	 * the following interface: contentbox.models.search.ISearchAdapter
	 */
	any function getSearchAdapter(){
		return variables.wirebox.getInstance( variables.settingService.getSetting( "cb_search_adapter" ) );
	}

}
