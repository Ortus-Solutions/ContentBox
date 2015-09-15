/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* I am a cms page entity that totally rocks
*/
component 	persistent="true" 
			entityname="cbPage" 
			table="cb_page" 
			batchsize="25" 
			cachename="cbPage" 
			cacheuse="read-write" 
			extends="BaseContent" 
			joinColumn="contentID" 
			discriminatorValue="Page"{

	// Properties
	property 	name="layout"			
				notnull="false" 	
				length="200" 
				default="";
	
	property 	name="mobileLayout"	
				notnull="false" 	
				length="200" 
				default="";
	
	property 	name="order"			
				notnull="false" 	
				ormtype="integer" 
				default="0";
	
	property 	name="showInMenu" 		
				notnull="true"  	
				ormtype="boolean" 
				default="true" 
				index="idx_showInMenu";
	
	property 	name="excerpt" 		
				notnull="false" 	
				ormtype="text" 
				default="" 
				length="8000";
	
	property 	name="SSLOnly" 		
				notnull="true"  	
				ormtype="boolean" 
				default="false" 
				index="idx_ssl";
	
	// Non-Persistable Properties
	property 	name="renderedExcerpt" 
			 	persistent="false";

	/************************************** CONSTRUCTOR *********************************************/

	/**
	* constructor
	*/
	function init(){
		super.init();

		categories 		= [];
		customFields	= [];
		renderedContent = "";
		renderedExcerpt	= "";
		allowComments 	= false;
		createdDate		= now();
		layout 			= "pages";
		mobileLayout	= "";
		contentType		= "Page";
		order 			= 0;
		showInMenu 		= true;
		SSLOnly			= false;
		
		// INHERITANCE LAYOUT STATIC
		LAYOUT_INHERITANCE_KEY = "-inherit-";
		
		return this;
	}

	/************************************** PUBLIC *********************************************/

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
	
	/**
	* Get a flat representation of this page
	* slugCache.hint Cache of slugs to prevent infinite recursions
	*/
	function getMemento( array slugCache=[] ){
		var pList = listToArray( "layout,mobileLayout,order,showInMenu,excerpt" );
		var result = super.getMemento( argumentCollection=arguments );
		
		// Local Memento Properties
		for(var thisProp in pList ){
			if( structKeyExists( variables, thisProp ) ){
				result[ thisProp ] = variables[ thisProp ];	
			}
			else{
				result[ thisProp ] = "";
			}
		}
		
		return result;
	}
	
	/**
	* Get the layout or if empty the default convention of "pages"
	*/
	function getLayoutWithDefault(){
		if( len( getLayout() ) ){ return getLayout(); }
		return "pages";
	}
	
	/**
	* Get layout with layout inheritance, if none found return normal saved layout
	*/
	function getLayoutWithInheritance(){
		var thisLayout = getLayout();
		// check for inheritance and parent?
		if( thisLayout eq LAYOUT_INHERITANCE_KEY AND hasParent() ){
			return getParent().getLayoutWithInheritance();
		}
		// Else return the layout
		return thisLayout;
	}
	
	/**
	* Get mobile layout with layout inheritance, if none found return normal saved layout
	*/
	function getMobileLayoutWithInheritance(){
		var thisLayout = ( isNull( mobileLayout ) ? '' : mobileLayout );
		// check for inheritance and parent?
		if( thisLayout eq LAYOUT_INHERITANCE_KEY AND hasParent() ){
			return getParent().getMobileLayoutWithInheritance();
		}
		// Is the mobile layout none, then return the normal layout
		return ( !len( thisLayout ) ? getLayoutWithInheritance() : thisLayout );
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
		// do layout
		setLayout( arguments.original.getLayout() );
		// do excerpts
		if( arguments.original.hasExcerpt() ){
			setExcerpt( arguments.original.getExcerpt() );
		}
		// do core
		return super.prepareForClone( argumentCollection=arguments );
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
		if( !len(title) ){ arrayAppend(errors, "Title is required" ); }
		if( !len(layout) ){ arrayAppend(errors, "Layout is required" ); }

		return errors;
	}

}