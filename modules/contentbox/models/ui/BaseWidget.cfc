/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * This is the base class for contentbox widgets which gives them access to ContentBox and ColdBox.
 */
component accessors="true" extends="coldbox.system.FrameworkSupertype" {

	// Shared DI all widgets receive
	property name="siteService" inject="siteService@contentbox";
	property name="categoryService" inject="categoryService@contentbox";
	property name="entryService" inject="entryService@contentbox";
	property name="pageService" inject="pageService@contentbox";
	property name="contentService" inject="contentService@contentbox";
	property name="contentVersionService" inject="contentVersionService@contentbox";
	property name="authorService" inject="authorService@contentbox";
	property name="commentService" inject="commentService@contentbox";
	property name="contentStoreService" inject="contentStoreService@contentbox";
	property name="menuService" inject="menuService@contentbox";
	property name="cb" inject="CBHelper@contentbox";
	property name="securityService" inject="securityService@contentbox";
	property name="html" inject="HTMLHelper@coldbox";
	property name="controller" inject="coldbox";
	property name="log" inject="logbox:logger:{this}";

	// Local Properties
	property
		name   ="name"
		type   ="string"
		default="";

	property
		name   ="version"
		type   ="string"
		default="";

	property
		name   ="description"
		type   ="string"
		default="";

	property
		name   ="author"
		type   ="string"
		default="";

	property
		name   ="authorURL"
		type   ="string"
		default="";

	property
		name   ="forgeBoxSlug"
		type   ="string"
		default="";

	property
		name   ="category"
		type   ="string"
		default="";

	property
		name   ="icon"
		type   ="string"
		default="";

	/**
	 * Base Constructor
	 */
	function init(){
		variables.name        = "";
		variables.version     = "";
		variables.description = "";
		variables.author      = "";
		variables.authorURL   = "";
		variables.category    = "";
		variables.icon        = "";

		return this;
	}

	/**
	 * This is the main renderit method you will need to implement in concrete widgets
	 *
	 * @throws BaseClassException
	 */
	any function renderIt(){
		throw( message = "This is a base method that you must implement", type = "BaseClassException" );
	}

	/**
	 * Get this widget's public methods'
	 *
	 * @return array
	 */
	array function getPublicMethods(){
		var publicMethods = [];
		var meta          = getMetadata( this );
		var method        = "";

		for ( var i = 1; i <= arrayLen( meta.functions ); i++ ) {
			method = meta.functions[ i ];
			// ignores?
			if ( structKeyExists( method, "cbignore" ) ) {
				continue;
			}
			// Add conditions
			if ( !listContains( "init,onMissingMethod", method.name ) ) {
				if (
					!structKeyExists( method, "access" ) || (
						structKeyExists( method, "access" ) && !listContains( "private,package", method.access )
					)
				) {
					arrayAppend( publicMethods, method );
				}
			}
		}
		return publicMethods;
	}

	/**
	 * Detect if we are in admin mode or in the UI, and retrieve the site accordingly
	 */
	function getSite(){
		if ( findNoCase( variables.cb.adminRoot(), getRequestContext().getCurrentRoutedUrl() ) ) {
			return variables.siteService.getCurrentWorkingSite();
		}

		return variables.cb.site();
	}

}
