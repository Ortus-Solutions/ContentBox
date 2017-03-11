/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* I represent a content value store
*/
component 	persistent="true" 
			entityname="cbContentStore" 
			table="cb_contentStore" 
			batchsize="25" 
			cachename="cbContentStore" 
			cacheuse="read-write" 
			extends="BaseContent" 
			joinColumn="contentID" 
			discriminatorValue="ContentStore"{

	/* *********************************************************************
	**							PROPERTIES									
	********************************************************************* */

	property name="description"				
			 notnull="false" 
			 length="500" 
			 default="";

	property 	name="order"			
				notnull="false" 	
				ormtype="integer" 
				default="0"
				dbdefault="0";

	/* *********************************************************************
	**							CONSTRAINTS									
	********************************************************************* */

	this.constraints[ "title" ]	= { required = false, size = "1..500" };
	this.constraints[ "order" ]	= { required = false, type="numeric" };
	
	/* *********************************************************************
	**							CONSTRUCTOR									
	********************************************************************* */

	/**
	* constructor
	*/
	function init(){
		super.init();
		
		categories 		= [];
		customFields	= [];
		renderedContent = "";
		allowComments 	= false;
		description		= "";
		createdDate		= now();
		contentType		= "ContentStore";
		order 			= 0;
		
		return this;
	}

	/* *********************************************************************
	**							PUBLIC FUNCTIONS									
	********************************************************************* */
	
	/**
	* Get a flat representation of this entry but for UI response format which
	* restricts the data being generated.
	* @slugCache Cache of slugs to prevent infinite recursions
	* @showComments Show comments in memento or not
	* @showCustomFields Show comments in memento or not
	* @showParent Show parent in memento or not
	* @showChildren Show children in memento or not
	* @showCategories Show categories in memento or not
	* @showRelatedContent Show related Content in memento or not
	*/
	struct function getResponseMemento(
		required array slugCache=[], 
		boolean showAuthor=true,
		boolean showComments=true,
		boolean showCustomFields=true,
		boolean showParent=true,
		boolean showChildren=true,
		boolean showCategories=true,
		boolean showRelatedContent=true
	){
		arguments.properties = listToArray( "description" );
		var result 	= super.getResponseMemento( argumentCollection=arguments );
		
		return result;
	};

	/**
	* Get a flat representation of this entry
	* @slugCache Cache of slugs to prevent infinite recursions
	* @counter
	* @showAuthor Show author in memento or not
	* @showComments Show comments in memento or not
	* @showCustomFields Show comments in memento or not
	* @showContentVersions Show content versions in memento or not
	* @showParent Show parent in memento or not
	* @showChildren Show children in memento or not
	* @showCategories Show categories in memento or not
	* @showRelatedContent Show related Content in memento or not
	* @showStats Show stats in memento or not
	*/
	function getMemento( 
		required array slugCache=[], 
		counter=0,
		boolean showAuthor=true,
		boolean showComments=true,
		boolean showCustomFields=true,
		boolean showContentVersions=true,
		boolean showParent=true,
		boolean showChildren=true,
		boolean showCategories=true,
		boolean showRelatedContent=true,
		boolean showStats=true
	){
		arguments.properties = listToArray( "description,order" );
		var result 	= super.getMemento( argumentCollection=arguments );
		
		return result;
	}

	/**
	* Wipe primary key, and descendant keys, and prepare for cloning of entire hierarchies
	* @author.hint The author doing the cloning
	* @original.hint The original content object that will be cloned into this content object
	* @originalService.hint The ContentBox content service object
	* @publish.hint Publish pages or leave as drafts
	* @originalSlugRoot.hint The original slug that will be replaced in all cloned content
	* @newSlugRoot.hint The new slug root that will be replaced in all cloned content
	*/
	BaseContent function prepareForClone(
		required any author, 
		required any original, 
		required any originalService, 
		required boolean publish,
		required any originalSlugRoot,
		required any newSlugRoot
	){
		// description
		setDescription( arguments.original.getDescription() );
		// do core
		return super.prepareForClone(argumentCollection=arguments);
	}

	/*
	* Validate page, returns an array of error or no messages
	*/
	array function validate(){
		var errors = [];

		// limits
		title			= left(title,200);
		slug			= left(slug,200);
		description		= left(description,500);

		// Required
		if( !len(title) ){ arrayAppend(errors, "Title is required" ); }

		return errors;
	}

}