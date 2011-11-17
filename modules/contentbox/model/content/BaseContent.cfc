/**
* A mapped super class used for contentbox content: entries and pages
*/
component mappedsuperclass="true" accessors="true"{
	
	// DI Injections
	property name="cachebox" 		inject="cachebox" persistent="false";
	property name="settingService"	inject="id:settingService@cb" persistent="false";
	
	// Properties
	property name="title"				notnull="true"  length="200" default="" index="idx_search";
	property name="slug"				notnull="true"  length="200" default="" unique="true" index="idx_slug,idx_publishedSlug";
	property name="content"    			notnull="true"  ormtype="text" length="8000";
	property name="createdDate" 		notnull="true"  ormtype="timestamp" update="false" index="idx_createdDate";
	property name="publishedDate"		notnull="false" ormtype="timestamp" idx="idx_publishedDate";
	property name="isPublished" 		notnull="true"  ormtype="boolean" default="true" dbdefault="1" index="idx_published,idx_search,idx_publishedSlug";
	property name="allowComments" 		notnull="true"  ormtype="boolean" default="true" dbdefault="1";
	property name="passwordProtection" 	notnull="false" length="100" default="" index="idx_published";
	property name="HTMLKeywords"		notnull="false" length="160" default="";
	property name="HTMLDescription"		notnull="false" length="160" default="";
	property name="hits"				notnull="false" ormtype="long" default="0" dbdefault="0";

	// M20 -> Author loaded as a proxy
	property name="author" cfc="contentbox.model.security.Author" fieldtype="many-to-one" fkcolumn="FK_authorID" lazy="true";
	
	// NON-persistent content type discriminator
	property name="type" persistent="false" type="string" hint="Valid content types are page,entry";
	
	/* ----------------------------------------- ORM EVENTS -----------------------------------------  */
	
	/*
	* In built event handler method, which is called if you set ormsettings.eventhandler = true in Application.cfc
	*/
	public void function preInsert(){
		setCreatedDate( now() );
	}
	
	/* ----------------------------------------- PUBLIC -----------------------------------------  */
	
	/**
	* Get display publishedDate
	*/
	string function getPublishedDateForEditor(boolean showTime=false){
		var pDate = getPublishedDate();
		if( isNull(pDate) ){ pDate = now(); }
		// get formatted date
		var fDate = dateFormat( pDate, "yyyy-mm-dd" );
		if( arguments.showTime ){
			fDate &=" " & timeFormat(pDate, "hh:mm:ss tt");
		}
		return fDate;
	}
	
	/**
	* Get display publishedDate
	*/
	string function getDisplayPublishedDate(){
		var publishedDate = getPublishedDate();
		return dateFormat( publishedDate, "mm/dd/yyy" ) & " " & timeFormat(publishedDate, "hh:mm:ss tt");
	}
	
	/**
	* Get formatted createdDate
	*/
	string function getDisplayCreatedDate(){
		var createdDate = getCreatedDate();
		return dateFormat( createdDate, "mm/dd/yyy" ) & " " & timeFormat(createdDate, "hh:mm:ss tt");
	}
		
	/**
	* Shorthand Author name
	*/
	string function getAuthorName(){
		return getAuthor().getName();
	}
		
	/**
	* isPassword Protected
	*/
	boolean function isPasswordProtected(){
		return len( getPasswordProtection() );
	}
	
	/**
	* addPublishedtime
	*/
	any function addPublishedtime(hour,minute){
		var time = timeformat("#arguments.hour#:#arguments.minute#", "hh:MM:SS tt");
		setPublishedDate( getPublishedDate() & " " & time);
		return this;
	}
	
	/**
	* Render content out
	*/
	function getRenderedContent(){
		
	}

}