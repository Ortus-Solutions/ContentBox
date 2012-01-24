/**
* I model a custom HTML content piece
*/
component persistent="true" entityname="cbCustomHTML" table="cb_customHTML" cachename="cbCustomHTML" cacheuse="read-write"{
	
	// DI Injections
	property name="cachebox" 			inject="cachebox" 					persistent="false";
	property name="settingService"		inject="id:settingService@cb" 		persistent="false";
	property name="interceptorService"	inject="coldbox:interceptorService" persistent="false";
	
	// PROPERTIES
	property name="contentID" 	fieldtype="id" generator="native" setter="false";
	property name="title"			notnull="true"  length="200";
	property name="slug"			notnull="true"  length="200" unique="true" index="idx_customHTML_slug";
	property name="description"		notnull="false" length="500" default="";
	property name="content" 		notnull="true"  ormtype="text" length="8000";
	property name="createdDate" 	notnull="true"  ormtype="timestamp" update="false";
	
	// Non-Persistable
	property name="renderedContent" persistent="false";
	
	/* ----------------------------------------- ORM EVENTS -----------------------------------------  */
	
	/*
	* In built event handler method, which is called if you set ormsettings.eventhandler = true in Application.cfc
	*/
	public void function preInsert(){
		setCreatedDate( now() );
	}
	
	/* ----------------------------------------- PUBLIC -----------------------------------------  */
	
	/**
	* constructor
	*/
	function init(){
		renderedContent = "";
	}
	
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
		
	/**
	* Render content out
	*/
	any function renderContent(){
	
		// Check if we need to translate
		if( NOT len(renderedContent) ){
			lock name="contentbox.customHTMLRendering.#getContentID()#" type="exclusive" throwontimeout="true" timeout="10"{
				if( NOT len(renderedContent) ){
					// else render content out, prepare builder
					var b = createObject("java","java.lang.StringBuilder").init( content );
					
					// announce renderings with data, so content renderers can process them
					var iData = {
						builder = b,
						customHTML	= this
					};
					interceptorService.processState("cb_onCustomHTMLRendering", iData);
					
					// save content
					renderedContent = b.toString();
				}
			}
		}	
		
		// renturn translated content
		return renderedContent;
	}
	
	
}