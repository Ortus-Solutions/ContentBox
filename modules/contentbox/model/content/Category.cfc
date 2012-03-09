/**
* I am a blog entry category
*/
component persistent="true" entityname="cbCategory" table="cb_category" cachename="cbCategory" cacheuse="read-write"{

	// Properties
	property name="categoryID" fieldtype="id" generator="native" setter="false";
	property name="category"		notnull="true"  length="200";
	property name="slug"			notnull="true"  length="200" unique="true" index="idx_slug";

	// Calculated properties
	property name="numberOfEntries" formula="select count(*) from cb_contentCategories as entryCats, cb_entry as entry where entryCats.FK_categoryID=categoryID and entry.contentID = entryCats.FK_contentID" ;
	property name="numberOfPages" formula="select count(*) from cb_contentCategories as entryCats, cb_page as page where entryCats.FK_categoryID=categoryID and page.contentID = entryCats.FK_contentID" ;

	/* ----------------------------------------- PUBLIC -----------------------------------------  */

	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getCategoryID() );
	}
}