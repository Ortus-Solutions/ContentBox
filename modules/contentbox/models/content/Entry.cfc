/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* I am a blog entry entity that is amazing
*/
component 	persistent="true" 
			entityname="cbEntry" 
			table="cb_entry" 
			batchsize="25" 
			cachename="cbEntry" 
			cacheuse="read-write" 
			extends="BaseContent" 
			joinColumn="contentID" 
			discriminatorValue="Entry"{

	/* *********************************************************************
	**							PROPERTIES									
	********************************************************************* */

	property 	name="excerpt" 
				notnull="false" 
				ormtype="text" 
				default="" 
				length="8000";
	
	/* *********************************************************************
	**							NON PERSISTED PROPERTIES									
	********************************************************************* */
	
	property 	name="renderedExcerpt" 
				persistent="false";

	/* *********************************************************************
	**							CONSTRAINTS									
	********************************************************************* */

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
		renderedExcerpt	= "";
		createdDate		= now();
		contentType		= "Entry";
		
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
		var result 	= super.getResponseMemento( argumentCollection=arguments );
		
		result[ "excerpt" ] = renderExcerpt();

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
		// Local Memento Properties
		var result 	= super.getMemento( argumentCollection=arguments );
		
		result[ "excerpt" ] = variables.excerpt;

		return result;
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
		
		// Check if we need to translate
		if( NOT len( renderedExcerpt ) ){
			lock name="contentbox.excerptrendering.#getContentID()#" type="exclusive" throwontimeout="true" timeout="10"{
				if( NOT len( renderedExcerpt ) ){
					// render excerpt out, prepare builder
					var b = createObject( "java","java.lang.StringBuilder" ).init( getExcerpt() );
					// announce renderings with data, so content renderers can process them
					var iData = {
						builder = b,
						content	= this
					};
					interceptorService.processState( "cb_onContentRendering", iData);
					// store processed content
					renderedExcerpt = b.toString();
				}
			}
		}
		
		return renderedExcerpt;
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
		if( !len(title) ){ arrayAppend(errors, "Title is required" ); }
		if( !len(slug) ){ arrayAppend(errors, "Slug is required" ); }

		return errors;
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
	BaseContent function prepareForClone(required any author, 
										 required any original, 
										 required any originalService, 
										 required boolean publish,
										 required any originalSlugRoot,
										 required any newSlugRoot){
		if( arguments.original.hasExcerpt() ){
			setExcerpt( arguments.original.getExcerpt() );
		}
		return super.prepareForClone(argumentCollection=arguments);
	}

}