/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* I am a versioned piece of content
*/
component	persistent="true" 
			entityname="cbContentVersion" 
			table="cb_contentVersion" 
			batchsize="25" 
			extends="contentbox.models.BaseEntity"
			cachename="cbContentVersion" 
			cacheuse="read-write"{

	/* *********************************************************************
	**							DI
	********************************************************************* */

	property name="interceptorService"		inject="coldbox:interceptorService"		persistent="false";

	/* *********************************************************************
	**							PROPERTIES									
	********************************************************************* */

	property 	name="contentVersionID" 
				fieldtype="id" 
				generator="native" 
				setter="false"  
				params="{ allocationSize = 1, sequence = 'contentVersionID_seq' }";

	property 	name="content"    		
				notnull="true" 
				ormtype="text" 
				length="8000" 
				default="";

	property 	name="changelog"  		
				notnull="false" 
				ormtype="text" 
				length="8000" 
				default="";

	property 	name="version"			
				notnull="true" 
				ormtype="integer"	
				default="1" 
				index="idx_version";

	property 	name="isActive" 		
				notnull="true" 
				ormtype="boolean"   	
				default="false" 
				index="idx_activeContentVersion,idx_contentVersions";

	/* *********************************************************************
	**							RELATIONSHIPS									
	********************************************************************* */

	// M20 -> Author loaded as a proxy and fetched immediately
	property 	name="author" 
				notnull="true" 
				cfc="contentbox.models.security.Author" 
				fieldtype="many-to-one" 
				fkcolumn="FK_authorID" 
				lazy="true" 
				fetch="join";

	// M20 -> relatedContent
	property 	name="relatedContent" 
				notnull="true" 
				cfc="contentbox.models.content.BaseContent" 
				fieldtype="many-to-one" 
				fkcolumn="FK_contentID" 
				lazy="true" 
				fetch="join" 
				index="idx_contentVersions";

	/* *********************************************************************
	**							NON PERSISTED PROPERTIES									
	********************************************************************* */

	property 	name="renderedContent" 
				persistent="false";

	/* *********************************************************************
	**							PK + CONSTRAINTS									
	********************************************************************* */

	this.pk = "contentVersionID";

	this.constraints = {
		"content" = { required=true },
		"version" = { required=true, type="integer" }
	};

	/* *********************************************************************
	**							CONSTRUCTOR									
	********************************************************************* */

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

		super.init();
		
		return this;
	}

	/* *********************************************************************
	**							PUBLIC FUNCTIONS									
	********************************************************************* */
	
	/**
	* Get memento representation
	*/
	function getMemento( excludes="" ){
		var pList 	= listToArray( "content,changelog,version,isActive" );
		var result 	= getBaseMemento( properties=pList, excludes=arguments.excludes );
		
		result[ "author" ] = {
			"authorID" 	= getAuthor().getAuthorID(),
			"firstname" = getAuthor().getFirstname(),
			"lastName" 	= getAuthor().getLastName(),
			"email" 	= getAuthor().getEmail(),
			"username" 	= getAuthor().getUsername(),
			"role" 		= getAuthor().getRole().getRole()
		};
		
		return result;
	}
	/**
	* Shorthand Author name
	*/
	string function getAuthorName(){
		if( hasAuthor() ){
			return getAuthor().getName();
		}
		return '';
	}

	/**
	* Shorthand Author email
	*/
	string function getAuthorEmail(){
		if( hasAuthor() ){
			return getAuthor().getEmail();
		}
		return '';
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