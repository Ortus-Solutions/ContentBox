/**
* I am a blog entry entity
*/
component persistent="true" entityname="bbEntry" table="bb_entry" batchsize="10" extends="BaseContent" {
	
	// Properties
	property name="entryID" fieldtype="id" generator="native" setter="false";
	property name="excerpt" 			notnull="false" ormtype="text" default="" length="8000";
	
	// M2M -> Categories
	property name="categories" fieldtype="many-to-many" type="array" lazy="extra" orderby="category"
			  cfc="blogbox.model.content.Category" fkcolumn="FK_entryID" linktable="bb_entryCategories" inversejoincolumn="FK_categoryID"; 
	
	// O2M -> Comments
	property name="comments" singularName="comment" fieldtype="one-to-many" type="array" lazy="extra" batchsize="10" orderby="createdDate"
			  cfc="blogbox.model.comments.Comment" fkcolumn="FK_entryID" inverse="true" cascade="all-delete-orphan"; 
	
	// Calculated Fields
	property name="numberOfComments" 			formula="select count(*) from bb_comment comment where comment.FK_entryID=entryID";
	property name="numberOfApprovedComments" 	formula="select count(*) from bb_comment comment where comment.FK_entryID=entryID and comment.isApproved = 1";

	/* ----------------------------------------- ORM EVENTS -----------------------------------------  */
	
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