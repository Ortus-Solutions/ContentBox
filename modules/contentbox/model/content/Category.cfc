/**
* I am a blog entry category
*/
component persistent="true" entityname="cbCategory" table="cb_category"{
	
	// Properties
	property name="categoryID" fieldtype="id" generator="native" setter="false";
	property name="category"		notnull="true"  length="200";
	property name="slug"			notnull="true"  length="200" unique="true" index="idx_slug";
	
	// Calculated properties
	property name="numberOfEntries" formula="select count(*) from cb_entryCategories as entryCats where entryCats.FK_categoryID=categoryID" ;
	
	/* ----------------------------------------- PUBLIC -----------------------------------------  */
	
	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getCommentID() );
	}
}