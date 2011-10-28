/**
* I model a custom HTML content piece
*/
component persistent="true" entityname="cbCustomHTML" table="cb_customHTML"{
	
	// PROPERTIES
	property name="contentID" 	fieldtype="id" generator="native" setter="false";
	property name="title"			notnull="true"  length="200";
	property name="slug"			notnull="true"  length="200" unique="true" index="idx_slug";
	property name="description"		notnull="false" length="500" default="";
	property name="content" 		notnull="true"  ormtype="text" length="8000";
	property name="createdDate" 	notnull="true"  ormtype="timestamp" update="false";
	
	/* ----------------------------------------- ORM EVENTS -----------------------------------------  */
	
	/*
	* In built event handler method, which is called if you set ormsettings.eventhandler = true in Application.cfc
	*/
	public void function preInsert(){
		setCreatedDate( now() );
	}
	
	/* ----------------------------------------- PUBLIC -----------------------------------------  */
	
	/**
	* has excerpt
	*/
	boolean function hasExcerpt(){
		return len( getExcerpt() ) GT 0;
	}
	
	/*
	* Validate entry, returns an array of error or no messages
	*/
	array function validate(){
		var errors = [];
		
		// limits
		title				= left(title,200);
		slug				= left(slug,200);
		description			= left(description,500);
		
		// Required
		if( !len(title) ){ arrayAppend(errors, "Title is required"); }
		if( !len(slug) ){ arrayAppend(errors, "Slug is required"); }
		if( !len(content) ){ arrayAppend(errors, "Content is required"); }
		
		return errors;
	}
	
	/**
	* Get formatted createdDate
	*/
	string function getDisplayCreatedDate(){
		var createdDate = getCreatedDate();
		return dateFormat( createdDate, "mm/dd/yyy" ) & " " & timeFormat(createdDate, "hh:mm:ss tt");
	}
		
	
	
	
}