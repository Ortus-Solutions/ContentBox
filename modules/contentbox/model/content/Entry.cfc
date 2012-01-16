/**
* I am a blog entry entity that is amazing
*/
component persistent="true" entityname="cbEntry" table="cb_entry" batchsize="25" extends="BaseContent" cachename="cbEntry" cacheuse="read-write"{
	
	// Properties
	property name="entryID" fieldtype="id" generator="native" setter="false";
	property name="excerpt" 			notnull="false" ormtype="text" default="" length="8000";
	
	// M2M -> Categories
	property name="categories" fieldtype="many-to-many" type="array" lazy="extra" orderby="category" cascade="all"  
			  cfc="contentbox.model.content.Category" fkcolumn="FK_entryID" linktable="cb_entryCategories" inversejoincolumn="FK_categoryID"; 
	
	// O2M -> Comments
	property name="comments" singularName="comment" fieldtype="one-to-many" type="array" lazy="extra" batchsize="25" orderby="createdDate"
			  cfc="contentbox.model.comments.Comment" fkcolumn="FK_entryID" inverse="true" cascade="all-delete-orphan"; 
	
	// O2M -> CustomFields
	property name="customFields" singularName="customField" fieldtype="one-to-many" type="array" lazy="extra" batchsize="10"
			  cfc="contentbox.model.content.CustomField" fkcolumn="FK_entryID" inverse="true" cascade="all-delete-orphan"; 
	
	// Calculated Fields
	property name="numberOfComments" 			formula="select count(*) from cb_comment comment where comment.FK_entryID=entryID";
	property name="numberOfApprovedComments" 	formula="select count(*) from cb_comment comment where comment.FK_entryID=entryID and comment.isApproved = 1";

	/* ----------------------------------------- ORM EVENTS -----------------------------------------  */
	
	/* ----------------------------------------- PUBLIC -----------------------------------------  */
	
	/**
	* constructor
	*/
	function init(){
		categories 		= [];
		type 			= "entry";
		renderedContent = "";
	}
	
	/**
	* Get content id based on implementation
	*/
	any function getContentID(){
		return getEntryID();
	}
	
	/**
	* has excerpt
	*/
	boolean function hasExcerpt(){
		return len( getExcerpt() ) GT 0;
	}
	
	/**
	* Render excerpt
	*/
	any function renderExcerpt(){
		return getExcerpt();
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
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getEntryID() );
	}
	
}