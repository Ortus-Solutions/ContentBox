/**
* I am a blog entry entity
*/
component persistent="true" entityname="bbEntry" table="bb_entry"{
	
	// Properties
	property name="entryID" fieldtype="id" generator="native" setter="false";
	property name="title"			notnull="true"  length="200";
	property name="slug"			notnull="true"  length="200";
	property name="content"    		notnull="true"  ormtype="text" sqltype="longtext";
	property name="excerpt" 		notnull="false" ormtype="text";
	property name="createdDate" 	notnull="true"  ormtype="timestamp" update="false";
	property name="publishedDate"	notnull="false" ormtype="timestamp";
	property name="isPublished" 	notnull="true"  ormtype="boolean" default="true";
	property name="allowComments" 	notnull="true"  ormtype="boolean" default="true";
	property name="passwordProtection" 	notnull="false" length="100";
	
	// M20 -> Author
	property name="author" cfc="blogbox.model.entries.Author" fieldtype="many-to-one" fkcolumn="FK_userID" lazy="true";
	// O2M -> Comments
	property name="comments" singularName="comment" fieldtype="one-to-many" type="array"
			  cfc="blogbox.model.comments.Comment" fkcolumn="entry_id" inverse="true" cascade="all-delete-orphan"; 
	// M2M -> Categories
	property name="categories" fieldtype="many-to-many" type="array" lazy="true"
			  cfc="blogbox.model.entries.Category" fkcolumn="FK_categoryID" linktable="bb_entryCategories" inversejoincolumn="FK_entryID"; 

	/* ----------------------------------------- ORM EVENTS -----------------------------------------  */
	
	/*
	* In built event handler method, which is called if you set ormsettings.eventhandler = true in Application.cfc
	*/
	public void function preInsert(){
		setCreatedDate( now() );
	}
	
	/* ----------------------------------------- PUBLIC -----------------------------------------  */
	
	/**
	* Get display publishedDate
	*/
	string function getPublishedDateForEditor(){
		var pDate = getPublishedDate();
		if( isNull(pDate) ){ pDate = now(); }
		return dateFormat( pDate, "yyyy-mm-dd" );
	}
	
	/**
	* Get display publishedDate
	*/
	string function getDisplayPublishedDate(){
		var publishedDate = getPublishedDate();
		return dateFormat( publishedDate, "mm/dd/yyy" ) & " " & timeFormat(publishedDate, "hh:mm:ss tt");
	}
	
	/**
	* Get formatted createdDate
	*/
	string function getDisplayCreatedDate(){
		var createdDate = getCreatedDate();
		return dateFormat( createdDate, "mm/dd/yyy" ) & " " & timeFormat(createdDate, "hh:mm:ss tt");
	}
	
	/*
	* I return the number of comments for this post
	*/
	numeric function getNumberOfComments(){
		return ArrayLen( getComments() );
	}
	
	/*
	* I remove all category associations
	*/
	public void function removeAllCategories(){
		if ( hasCategories() ){
			variables.categories = [];
		}
	}
	
	/**
	* get flat categories list
	*/
	function getCategoriesList(){
		if( NOT hasCategories() ){ return "Uncategorized"; }
		var cats 	= getCategories();
		var catList = [];
		for(var x=1; x lte arrayLen(cats); x++){
			arrayAppend( catList , cats[x].getCategory() & " " );
		}
		return arrayToList( catList );
	}
	
	/**
	* Shorthand Author name
	*/
	string function getAuthorName(){
		return getAuthor().getName();
	}
	
	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getEntryID() );
	}
	
	/**
	* isPassword Protected
	*/
	boolean function isPasswordProtected(){
		return len( getPasswordProtection() );
	}
	
	/**
	* addPublishedtime
	*/
	any function addPublishedtime(hour,minute){
		var time = timeformat("#arguments.hour#:#arguments.minute#", "hh:MM:SS tt");
		setPublishedDate( getPublishedDate() & " " & time);
		return this;
	}
	
}