/**
* I am a versioned piece of content
*/
component persistent="true" entityname="cbContentVersion" table="cb_contentVersion" batchsize="25" cachename="cbContentVersion" cacheuse="read-write"{
	
	// PROPERTIES
	property name="contentVersionID" fieldtype="id" generator="native" setter="false";
	property name="content" 		notnull="true" ormtype="text";
	property name="version"			notnull="true" ormtype="integer"	default="1" dbdefalt="1" index="idx_version";
	property name="createdDate" 	notnull="true" ormtype="timestamp"	update="false" default="" index="idx_createdDate";
	property name="isActive" 		notnull="true" ormtype="boolean"   	default="true" dbdefault="0" index="idx_active,idx_entryContent,idx_pageContent";
	
	// M20 -> Author loaded as a proxy and fetched immediately
	property name="author" notnull="true" cfc="contentbox.model.security.Author" fieldtype="many-to-one" fkcolumn="FK_authorID" lazy="true" fetch="join";
	
	// M20 -> relatedContent
	property name="relatedContent" notnull="true" cfc="contentbox.model.content.BaseContent" fieldtype="many-to-one" fkcolumn="FK_contentID" lazy="true" fetch="join" index="idx_contentVersions";
	
	/************************************** CONSTRUCTOR *********************************************/
		
	/**
	* constructor
	*/
	function init(){
		setCreatedDate( now() );
		setIsActive( false );
		setVersion( 1 );
	}
	
	/************************************** PUBLIC *********************************************/
	
	/**
	* Shorthand Author name
	*/
	string function getAuthorName(){
		return getAuthor().getName();
	}
	
	/**
	* Get formatted createdDate
	*/
	string function getDisplayCreatedDate(){
		var createdDate = getCreatedDate();
		return dateFormat( createdDate, "mm/dd/yyy" ) & " " & timeFormat(createdDate, "hh:mm:ss tt");
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
	
	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getContentVersionID() );
	}

}