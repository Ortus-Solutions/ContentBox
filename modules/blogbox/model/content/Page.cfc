/**
* I am a blog page entity
*/
component persistent="true" entityname="bbPage" table="bb_page" batchsize="10" extends="BaseContent"{
	
	// Properties
	property name="pageID" fieldtype="id" generator="native" setter="false";
	property name="layout"	notnull="false" length="200" default="";
	property name="order"	notnull="false" ormtype="integer" default="0" dbdefault="0";
	
	// O2M -> Comments
	property name="comments" singularName="comment" fieldtype="one-to-many" type="array" lazy="extra" batchsize="10" orderby="createdDate"
			  cfc="blogbox.model.comments.Comment" fkcolumn="FK_pageID" inverse="true" cascade="all-delete-orphan"; 
	
	// M20 -> Parent Page loaded as a proxy
	property name="parent" notnull="false" cfc="blogbox.model.content.Page" fieldtype="many-to-one" fkcolumn="FK_parentID" lazy="true";
	
	// Calculated Fields
	property name="numberOfChildren" 			formula="select count(*) from bb_page page where page.FK_parentID=pageID";
	property name="numberOfComments" 			formula="select count(*) from bb_comment comment where comment.FK_pageID=pageID";
	property name="numberOfApprovedComments" 	formula="select count(*) from bb_comment comment where comment.FK_pageID=pageID and comment.isApproved = 1";

	/* ----------------------------------------- ORM EVENTS -----------------------------------------  */
	
	/* ----------------------------------------- PUBLIC -----------------------------------------  */
	
	/**
	* constructor
	*/
	function init(){
		setType("page");
	}
	
	/**
	* Get the layout or if empty the default convention of "pages"
	*/
	function getLayoutWithDefault(){
		if( len(getLayout()) ){ return getLayout(); }
		return "pages";
	}
	
	
	/*
	* Validate page, returns an array of error or no messages
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
		//if( !len(layout) ){ arrayAppend(errors, "Layout is required"); }
		
		return errors;
	}
	
	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getPageID() );
	}
	
	/**
	* Get parent ID if set or empty
	*/
	function getParentID(){
		if( hasParent() ){ return getParent().getPageID(); }
		return "";
	}
	
	/**
	* Get parent name or empty
	*/
	function getParentName(){
		if( hasParent() ){ return getParent().getTitle(); }
		return "";
	}
	
	/**
	* Get recursive slug paths
	*/
	function getRecursiveSlug(separator="/"){
		var pPath = "";
		if( hasParent() ){ pPath = getParent().getRecursiveSlug(); }
		return pPath & arguments.separator & getSlug();
	}
	
}