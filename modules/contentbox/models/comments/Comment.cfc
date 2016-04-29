/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* I am a Comment Entity
*/
component	persistent="true" 
			entityname="cbComment" 
			table="cb_comment" 
			batchsize="25" 
			extends="contentbox.models.BaseEntity"
			cachename="cbComment" 
			cacheuse="read-write"{

	/* *********************************************************************
	**							PROPERTIES									
	********************************************************************* */

	property 	name="commentID" 
				fieldtype="id" 
				generator="native" 
				setter="false" 
				params="{ allocationSize = 1, sequence = 'commentID_seq' }";

	property 	name="content" 		
				ormtype="text" 	
				notnull="true";

	property 	name="author"			
				length="100" 	
				notnull="true";

	property 	name="authorIP"		
				length="100" 	
				notnull="true";

	property 	name="authorEmail"		
				length="255" 	
				notnull="true";

	property 	name="authorURL"		
				length="255" 	
				notnull="false";

	property 	name="isApproved" 		
				notnull="true"  
				ormtype="boolean" 	
				default="false" 
				index="idx_contentComment,idx_approved";

	/* *********************************************************************
	**							RELATIONSHIPS									
	********************************************************************* */

	// M20 -> Content loaded as a proxy
	property 	name="relatedContent" 
				notnull="true" 
				cfc="contentbox.models.content.BaseContent" 
				fieldtype="many-to-one" 
				fkcolumn="FK_contentID" 
				lazy="true" 
				index="idx_contentComment";

	/* *********************************************************************
	**							CONSTRAINTS + PK									
	********************************************************************* */

	this.pk = "commentID";

	this.constraints = {
		"content" 		= { required = true },
		"author" 		= { required = true, size="1..100" },
		"authorIP" 		= { required = true, size="1..100" },
		"authorEmail" 	= { required = true, size="1..255", type="email" },	
		"authorURL" 	= { required = true, size="1..255", type="URL" }
	};

	/************************************** CONSTRUCTOR *********************************************/

	/**
	* constructor
	*/
	function init(){
		variables.isApproved 	= false;
		variables.createdDate	= now();

		super.init();

		return this;
	}

	/************************************** PUBLIC *********************************************/

	/**
	* Get memento representation
	*/
	function getMemento( excludes="" ){
		var pList 	= listToArray( "content,author,authorIP,authorEmail,authorURL,isApproved" );
		var result 	= getBaseMemento( properties=pList, excludes=arguments.excludes );
		
		return result;
	}
	
	/**
	* Get Display Content
	*/
	string function getDisplayContent(){
		return paragraphFormat( getContent() );
	}

	/**
	* Get parent slug from either the page it belongs or the entry it belongs to.
	*/
	function getParentSlug(){
		if( hasRelatedContent() ){ return getRelatedContent().getSlug(); }
		return "";
	}

	/**
	* Get parent title from either the page it belongs or the entry it belongs to.
	*/
	function getParentTitle(){
		if( hasRelatedContent() ){ return getRelatedContent().getTitle(); }
		return "";
	}

}