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
	property name="createdDate" 	notnull="true"  ormtype="date" update="false";
	property name="updatedDate" 	notnull="true"  ormtype="timestamp" sqltype="timestamp" insert="false" update="false";
	property name="publishedDate"	notnull="false" ormtype="date";
	property name="isPublished" 	notnull="true"  ormtype="boolean" default="false";
	property name="allowComments" 	notnull="true"  ormtype="boolean" default="true";
	
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
	* Shorthand Author name
	*/
	string function getAuthorName(){
		return getAuthor().getName();
	}
	
}