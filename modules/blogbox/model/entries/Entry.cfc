/**
* I am a blog entry entity
*/
component persistent="true" entityname="bbEntry" table="bb_entry" batchsize="10"{
	
	// Properties
	property name="entryID" fieldtype="id" generator="native" setter="false";
	property name="title"				notnull="true"  length="200" default="";
	property name="slug"				notnull="true"  length="200" default="";
	property name="content"    			notnull="true"  ormtype="text" sqltype="longtext";
	property name="excerpt" 			notnull="false" ormtype="text" default="";
	property name="createdDate" 		notnull="true"  ormtype="timestamp" update="false";
	property name="publishedDate"		notnull="false" ormtype="timestamp";
	property name="isPublished" 		notnull="true"  ormtype="boolean" default="true" dbdefault="true";
	property name="allowComments" 		notnull="true"  ormtype="boolean" default="true" dbdefault="true";
	property name="passwordProtection" 	notnull="false" length="100" default="";
	property name="HTMLKeywords"		notnull="false" length="160" default="";
	property name="HTMLDescription"		notnull="false" length="160" default="";
	property name="hits"				notnull="false" default="0" dbdefault="0" ormtype="long";
	
	// M20 -> Author loaded as a proxy
	property name="author" cfc="blogbox.model.entries.Author" fieldtype="many-to-one" fkcolumn="FK_authorID" lazy="true";
	// O2M -> Comments
	property name="comments" singularName="comment" fieldtype="one-to-many" type="array" lazy="extra" batchsize="10" orderby="createdDate"
			  cfc="blogbox.model.comments.Comment" fkcolumn="FK_entryID" inverse="true" cascade="all-delete-orphan"; 
	// M2M -> Categories
	property name="categories" fieldtype="many-to-many" type="array" lazy="extra" orderby="category"
			  cfc="blogbox.model.entries.Category" fkcolumn="FK_categoryID" linktable="bb_entryCategories" inversejoincolumn="FK_entryID"; 

	// Calculated Fields
	property name="numberOfComments" formula="select count(*) from bb_comment comment where comment.FK_entryID=entryID";

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
		HTMLKeyWords 		= left(HTMLKeywords,160);
		HTMLDescription 	= left(HTMLDescription,160); 
		passwordProtection 	= left(passwordProtection,100);
		title				= left(title,200);
		slug				= left(slug,200);
		
		// Required
		if( !len(title) ){ arrayAppend(errors, "Title is required"); }
		if( !len(content) ){ arrayAppend(errors, "Content is required"); }
		
		return errors;
	}
	
	/**
	* Get display publishedDate
	*/
	string function getPublishedDateForEditor(boolean showTime=false){
		var pDate = getPublishedDate();
		if( isNull(pDate) ){ pDate = now(); }
		// get formatted date
		var fDate = dateFormat( pDate, "yyyy-mm-dd" );
		if( arguments.showTime ){
			fDate &=" " & timeFormat(pDate, "hh:mm:ss tt");
		}
		return fDate;
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
	* I remove all category associations
	*/
	any function removeAllCategories(){
		if ( hasCategories() ){
			variables.categories = [];
		}
		return this;
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