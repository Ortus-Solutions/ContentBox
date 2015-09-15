/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* I content category
*/
component persistent="true" entityname="cbCategory" table="cb_category" cachename="cbCategory" cacheuse="read-write"{

	// DI
	property name="categoryService" inject="categoryService@cb" persistent="false";

	// Properties
	property name="categoryID" fieldtype="id" generator="native" setter="false"  params="{ allocationSize = 1, sequence = 'categoryID_seq' }";
	property name="category"		notnull="true"  length="200";
	property name="slug"			notnull="true"  length="200" unique="true" index="idx_categorySlug";
	
	// Calculated properties
	property name="numberOfEntries" formula="select count(*) from cb_contentCategories as contentCategories, cb_entry as entry, cb_content as content
											 where contentCategories.FK_categoryID=categoryID
											   and contentCategories.FK_contentID = entry.contentID
											   and entry.contentID = content.contentID
											   and content.isPublished = 1" ;
	property name="numberOfPages" 	formula="select count(*) from cb_contentCategories as contentCategories, cb_page as page, cb_content as content
											 where contentCategories.FK_categoryID=categoryID
											   and contentCategories.FK_contentID = page.contentID
											   and page.contentID = content.contentID
											   and content.isPublished = 1" ;

	/* ----------------------------------------- PUBLIC -----------------------------------------  */

	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( variables.categoryID );
	}

	/**
	* Get memento representation
	*/
	function getMemento(){
		var pList = listToArray( "categoryID,category,slug,numberOfEntries,numberOfPages" );
		var result = {};
		
		for(var thisProp in pList ){
			result[ thisProp ] = variables[ thisProp ];	
		}
		
		return result;
	}
}