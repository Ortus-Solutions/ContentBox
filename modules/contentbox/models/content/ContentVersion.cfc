/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* I am a versioned piece of content
*/
component persistent="true" entityname="cbContentVersion" table="cb_contentVersion" batchsize="25" cachename="cbContentVersion" cacheuse="read-write"{

	// DI Injections
	property name="interceptorService"		inject="coldbox:interceptorService" persistent="false";

	// PROPERTIES
	property name="contentVersionID" fieldtype="id" generator="native" setter="false"  params="{ allocationSize = 1, sequence = 'contentVersionID_seq' }";
	property name="content"    		notnull="true"  ormtype="text" length="8000" default="";
	property name="changelog"  		notnull="false" ormtype="text" length="8000" default="";
	property name="version"			notnull="true"  ormtype="integer"	default="1" index="idx_version";
	property name="createdDate" 	notnull="true"  ormtype="timestamp"	update="false" default="" index="idx_versionCreatedDate";
	property name="isActive" 		notnull="true"  ormtype="boolean"   	default="false" index="idx_activeContentVersion,idx_contentVersions";

	// M20 -> Author loaded as a proxy and fetched immediately
	property name="author" notnull="true" cfc="contentbox.models.security.Author" fieldtype="many-to-one" fkcolumn="FK_authorID" lazy="true" fetch="join";

	// M20 -> relatedContent
	property name="relatedContent" notnull="true" cfc="contentbox.models.content.BaseContent" fieldtype="many-to-one" fkcolumn="FK_contentID" lazy="true" fetch="join" index="idx_contentVersions";

	// Non-Persistable Properties
	property name="renderedContent" persistent="false";

	/************************************** CONSTRUCTOR *********************************************/

	/**
	* constructor
	*/
	function init(){
		variables.createdDate 		= now();
		variables.isActive 			= false;
		variables.version 			= 1;
		variables.content 			= "";
		variables.changelog 		= "";
		variables.renderedContent 	= "";
		
		return this;
	}

	/************************************** PUBLIC *********************************************/
	
	/**
	* Get memento representation
	*/
	function getMemento(){
		var pList = listToArray( "contentVersionID,content,changelog,version,createdDate,isActive" );
		var result = {};
		
		for(var thisProp in pList ){
			if( structKeyExists( variables, thisProp ) ){
				result[ thisProp ] = variables[ thisProp ];	
			}
			else{
				result[ thisProp ] = "";
			}	
		}
		
		result[ "author" ] = {
			authorID = getAuthor().getAuthorID(),
			firstname = getAuthor().getFirstname(),
			lastName = getAuthor().getLastName(),
			email = getAuthor().getEmail(),
			username = getAuthor().getUsername(),
			role = getAuthor().getRole().getRole()
		};
		
		return result;
	}
	/**
	* Shorthand Author name
	*/
	string function getAuthorName(){
		return getAuthor().getName();
	}

	/**
	* Shorthand Author email
	*/
	string function getAuthorEmail(){
		return getAuthor().getEmail();
	}

	/**
	* Get formatted createdDate
	*/
	string function getDisplayCreatedDate(){
		var createdDate = getCreatedDate();
		return dateFormat( createdDate, "mm/dd/yyyy" ) & " " & timeFormat(createdDate, "hh:mm:ss tt" );
	}

	/**
	* Get parent slug from the related content it belongs to
	*/
	function getParentSlug(){
		if( hasRelatedContent() ){ return getRelatedContent().getSlug(); }
		return "";
	}

	/**
	* Get parent title from the related content it belongs to
	*/
	function getParentTitle(){
		if( hasRelatedContent() ){ return getRelatedContent().getTitle(); }
		return "";
	}

	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getContentVersionID() );
	}

	/**
	* Render version content out
	*/
	any function renderContent(){

		// Check if we need to translate
		if( NOT len(renderedContent) ){
			lock name="contentbox.versionrendering.#getContentVersionID()#" type="exclusive" throwontimeout="true" timeout="10"{
				if( NOT len(renderedContent) ){
					// else render content out, prepare builder
					var b = createObject( "java","java.lang.StringBuilder" ).init( content );

					// announce renderings with data, so content renderers can process them
					var iData = {
						builder = b,
						content	= this
					};
					interceptorService.processState( "cb_onContentRendering", iData);

					// save content
					renderedContent = b.toString();
				}
			}
		}

		// renturn translated content
		return renderedContent;
	}

}